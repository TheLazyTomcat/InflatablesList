unit InflatablesList_Manager_Base;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  StdCtrls,
  AuxClasses, SimpleCmdLineParser,
  InflatablesList_Types,
  InflatablesList_Data,
  InflatablesList_Item;

type
  TILManager_Base = class(TCustomListObject)
  protected
    fDataProvider:  TILDataProvider;
    fFileName:      String;
    fSorting:       Boolean;
    fUpdateCounter: Integer;
    fUpdated:       Boolean;
    // cmd options
    fCMDLineParser: TCLPParser;
    fStaticOptions: TILStaticManagerOptions;  // not changed at runtime
    // main list
    fList:          array of TILItem;
    fCount:         Integer;
    // other data
    fNotes:         String;
    // events
    fOnListUpdate:  TNotifyEvent;
    Function GetCapacity: Integer; override;
    procedure SetCapacity(Value: Integer); override;
    Function GetCount: Integer; override;
    procedure SetCount(Value: Integer); override;
    Function GetItem(Index: Integer): TILITem; virtual;
    // items event handling
    procedure OnItemListUpdate(Sender: TObject); virtual;
    // inits/finals
    procedure Initialize; virtual;
    procedure Finalize; virtual;
    // other
    procedure ReIndex; virtual;
  public
    constructor Create;
    destructor Destroy; override;
    procedure BeginUpdate; virtual;
    procedure EndUpdate; virtual;
    Function LowIndex: Integer; override;
    Function HighIndex: Integer; override;
    Function ItemLowIndex: Integer; virtual;
    Function ItemHighIndex: Integer; virtual;
    // list manipulation
    Function ItemAddEmpty: Integer; virtual;
    Function ItemAddCopy(SrcIndex: Integer): Integer; virtual;
    procedure ItemExchange(Idx1,Idx2: Integer); virtual;
    procedure ItemMove(Src,Dst: Integer); virtual;
    procedure ItemDelete(Index: Integer); virtual;
    procedure ItemClear; virtual;
    // searching
    Function FindPrev(const Text: String; FromIndex: Integer = -1): Integer; virtual;
    Function FindNext(const Text: String; FromIndex: Integer = -1): Integer; virtual;
    // macro methods (broadcast to item objects)
    procedure ReinitDrawSize(MainList: TListBox); virtual;
    // utility methods
    Function SortingItemStr(const SortingItem: TILSortingItem): String; virtual;
    // properties
    property DataProvider: TILDataProvider read fDataProvider;
    property FileName: String read fFileName;
    property StaticOptions: TILStaticManagerOptions read fStaticOptions;
    property ItemCount: Integer read GetCount;
    property Items[Index: Integer]: TILItem read GetItem; default;
    property Notes: String read fNotes write fNotes;
    // events
    property OnListUpdate: TNotifyEvent read fOnListUpdate write fOnListUpdate;
  end;

implementation

uses
  SysUtils,
  InflatablesList_Utils;

Function TILManager_Base.GetCapacity: Integer;
begin
Result := Length(fList);
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.SetCapacity(Value: Integer);
var
  i:  Integer;
begin
If Value < fCount then
  For i := Value to Pred(fCount) do
    fList[i].Free;
SetLength(fList,Value);
end;

//------------------------------------------------------------------------------

Function TILManager_Base.GetCount: Integer;
begin
Result := fCount;
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.SetCount(Value: Integer);
begin
// do nothing
end;

//------------------------------------------------------------------------------

Function TILManager_Base.GetItem(Index: Integer): TILITem;
begin
If CheckIndex(Index) then
  Result := fList[Index]
else
  raise Exception.CreateFmt('TILManager_Base.GetItem: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.OnItemListUpdate(Sender: TObject);
begin
If Assigned(fOnListUpdate) and (fUpdateCounter <= 0) then
  fOnListUpdate(Self);
fUpdated := True;
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.Initialize;
begin
fDataProvider := TILDataProvider.Create;
fFileName := '';
fSorting := False;
fUpdateCounter := 0;
fUpdated := False;
// cmd-line options
fCMDLineParser := TCLPParser.Create;
fStaticOptions.NoPictures := fCMDLineParser.CommandPresent('no_pics');
fStaticOptions.TestCode := fCMDLineParser.CommandPresent('test_code');
fStaticOptions.SavePages := fCMDLineParser.CommandPresent('save_pages');
fStaticOptions.LoadPages := fCMDLineParser.CommandPresent('load_pages');
// list
fCount := 0;
SetLength(fList,0);
fNotes := '';
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.Finalize;
begin
ItemClear;
SetLength(fList,0);
FreeAndNil(fCMDLineParser);
FreeAndNil(fDataProvider);
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.ReIndex;
var
  i:  Integer;
begin
For i := ItemLowIndex to ItemHighIndex do
  fList[i].Index := i;
end;

//==============================================================================

constructor TILManager_Base.Create;
begin
inherited Create;
Initialize;
end;

//------------------------------------------------------------------------------

destructor TILManager_Base.Destroy;
begin
Finalize;
inherited;
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.BeginUpdate;
begin
If fUpdateCounter <= 0 then
  fUpdated := False;
Inc(fUpdateCounter);
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.EndUpdate;
begin
Dec(fUpdateCounter);
If fUpdateCounter <= 0 then
  begin
    fUpdateCounter := 0;
    If fUpdated and Assigned(fOnListUpdate) then
      fOnListUpdate(Self);
    fUpdated := False;
  end;
end;

//------------------------------------------------------------------------------

Function TILManager_Base.LowIndex: Integer;
begin
Result := Low(fList);
end;

//------------------------------------------------------------------------------

Function TILManager_Base.HighIndex: Integer;
begin
Result := Pred(fCount);
end;

//------------------------------------------------------------------------------

Function TILManager_Base.ItemLowIndex: Integer;
begin
Result := LowIndex;
end;

//------------------------------------------------------------------------------

Function TILManager_Base.ItemHighIndex: Integer;
begin
Result := HighIndex;
end;

//------------------------------------------------------------------------------

Function TILManager_Base.ItemAddEmpty: Integer;
begin
Grow;
Result := fCount;
fList[Result] := TILItem.Create(fDataProvider);
fList[Result].Index := Result;
fList[Result].StaticOptions := fStaticOptions;
fList[Result].OnMainListUpdate := OnItemListUpdate;
fList[Result].OnSmallListUpdate := OnItemListUpdate;
Inc(fCount);
end;

//------------------------------------------------------------------------------

Function TILManager_Base.ItemAddCopy(SrcIndex: Integer): Integer;
begin
If (SrcIndex >= ItemLowIndex) and (SrcIndex <= ItemHighIndex) then
  begin
    Grow;
    Result := fCount;
    fList[Result] := TILItem.CreateAsCopy(fDataProvider,fList[SrcIndex],True);
    fList[Result].Index := Result;
    // static options are copied in item constructor
    fList[Result].OnMainListUpdate := OnItemListUpdate;
    fList[Result].OnSmallListUpdate := OnItemListUpdate;
    Inc(fCount);
  end
else raise Exception.CreateFmt('TILManager_Base.ItemAddCopy: Source index (%d) out of bounds.',[SrcIndex]);
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.ItemExchange(Idx1,Idx2: Integer);
var
  Temp: TILItem;
begin
If Idx1 <> Idx2 then
  begin
    // sanity checks
    If (Idx1 < ItemLowIndex) or (Idx1 > ItemHighIndex) then
      raise Exception.CreateFmt('TILManager_Base.ItemExchange: Index 1 (%d) out of bounds.',[Idx1]);
    If (Idx2 < ItemLowIndex) or (Idx2 > ItemHighIndex) then
      raise Exception.CreateFmt('TILManager_Base.ItemExchange: Index 2 (%d) out of bounds.',[Idx1]);
    Temp := fList[Idx1];
    fList[Idx1] := fList[Idx2];
    fList[Idx2] := Temp;
    If not fSorting then
      begin
        // full reindex not needed
        fList[Idx1].Index := Idx1;
        fList[Idx2].Index := Idx2;
      end;
  end;
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.ItemMove(Src,Dst: Integer);
var
  Temp: TILItem;
  i:    Integer;
begin
If Src <> Dst then
  begin
    // sanity checks
    If (Src < ItemLowIndex) or (Src > ItemHighIndex) then
      raise Exception.CreateFmt('TILManager_Base.ItemMove: Source index (%d) out of bounds.',[Src]);
    If (Dst < ItemLowIndex) or (Dst > ItemHighIndex) then
      raise Exception.CreateFmt('TILManager_Base.ItemMove: Destination index (%d) out of bounds.',[Dst]);
    Temp := fList[Src];
    If Src < Dst then
      begin
        // move items down one place
        For i := Src to Pred(Dst) do
          fList[i] := fList[i + 1];
      end
    else
      begin
        // move items up one place
        For i := Src downto Succ(Dst) do
          fList[i] := fList[i - 1];
      end;
    fList[Dst] := Temp;
    ReIndex;      
  end;
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.ItemDelete(Index: Integer);
var
  i:  Integer;
begin
If (Index >= ItemLowIndex) and (Index <= ItemHighIndex) then
  begin
    FreeAndNil(fList[Index]);
    For i := Index to Pred(ItemHighIndex) do
      fList[i] := fList[i + 1];
    Dec(fCount);
    ReIndex;
    Shrink;
  end
else raise Exception.CreateFmt('TILManager_Base.ItemDelete: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.ItemClear;
var
  i:  Integer;
begin
For i := ItemLowIndex to ItemHighIndex do
  FreeAndNil(fList[i]);
fCount := 0;
Shrink;
end;

//------------------------------------------------------------------------------

Function TILManager_Base.FindPrev(const Text: String; FromIndex: Integer = -1): Integer;
var
  i:  Integer;
begin
Result := -1;
If fCount > 0 then
  begin
    i := IL_IndexWrap(Pred(FromIndex),ItemLowIndex,ItemHighIndex);
    while i <> FromIndex do
      begin
        If fList[i].Contains(Text) then
          begin
            Result := i;
            Break{while...};
          end;
        i := IL_IndexWrap(Pred(i),ItemLowIndex,ItemHighIndex);
      end;
  end;
end;

//------------------------------------------------------------------------------

Function TILManager_Base.FindNext(const Text: String; FromIndex: Integer = -1): Integer;
var
  i:  Integer;
begin
Result := -1;
If fCount > 0 then
  begin
    i := IL_IndexWrap(Succ(FromIndex),ItemLowIndex,ItemHighIndex);
    while i <> FromIndex do
      begin
        If fList[i].Contains(Text) then
          begin
            Result := i;
            Break{while...};
          end;
        i := IL_IndexWrap(Succ(i),ItemLowIndex,ItemHighIndex);
      end;
  end;
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.ReinitDrawSize(MainList: TListBox);
var
  i:  Integer;
begin
BeginUpdate;
try
  For i := ItemLowIndex to ItemHighIndex do
    fList[i].ReinitDrawSize(MainList);
finally
  EndUpdate;
end;
end;

//------------------------------------------------------------------------------

Function TILManager_Base.SortingItemStr(const SortingItem: TILSortingItem): String;
begin
Result := Format('%s %s',[IL_BoolToStr(SortingItem.Reversed,'+','-'),
  fDataProvider.GetItemValueTagString(SortingItem.ItemValueTag)])
end;

end.
