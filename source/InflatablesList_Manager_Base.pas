unit InflatablesList_Manager_Base;{$message 'revisit'}
{$message 'll_rework'}

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
    fStaticOptions: TILStaticManagerOptions;  // not changed at runtime
    fDataProvider:  TILDataProvider;
    fSorting:       Boolean;                  // used only during sorting to disable reindexing
    fUpdateCounter: Integer;
    fUpdated:       Boolean;
    // main list
    fList:          array of TILItem;
    fCount:         Integer;
    // other data
    fNotes:         String;
    // encryption
    fEncrypted:     Boolean;
    fListPassword:  String;
    // internal events forwarded from item shops
    fOnShopListItemUpdate:  TILObjectL2Event;
    fOnShopValuesUpdate:    TILObjectL2Event;
    fOnShopAvailHistoryUpd: TILObjectL2Event;
    fOnShopPriceHistoryUpd: TILObjectL2Event;
    // internal events forwarded from items
    fOnItemTitleUpdate:     TILObjectL1Event;
    fOnItemPicturesUpdate:  TILObjectL1Event;
    fOnItemFlagsUpdate:     TILObjectL1Event;
    fOnItemValuesUpdate:    TILObjectL1Event;
    fOnItemShopListUpdate:  TILObjectL1Event;
    // events
    fOnMainListUpdate:      TNotifyEvent;
    fOnSmallListUpdate:     TNotifyEvent;
    fOnOverviewUpdate:      TNotifyEvent;
    Function GetCapacity: Integer; override;
    procedure SetCapacity(Value: Integer); override;
    Function GetCount: Integer; override;
    procedure SetCount(Value: Integer); override;
    Function GetItem(Index: Integer): TILITem; virtual;
    // handlers for item shop events
    procedure ShopUpdateShopListItemHandler(Sender: TObject; Shop: TObject); virtual; 
    procedure ShopUpdateValuesHandler(Sender: TObject; Shop: TObject); virtual; 
    procedure ShopUpdateAvailHistoryHandler(Sender: TObject; Shop: TObject); virtual; 
    procedure ShopUpdatePriceHistoryHandler(Sender: TObject; Shop: TObject); virtual; 
    // handlers for item events
    procedure ItemUpdateMainListHandler(Sender: TObject); virtual; 
    procedure ItemUpdateSmallListHandler(Sender: TObject); virtual; 
    procedure ItemUpdateOverviewHandler(Sender: TObject); virtual; 
    procedure ItemUpdateTitleHandler(Sender: TObject); virtual;
    procedure ItemUpdatePicturesHandler(Sender: TObject); virtual; 
    procedure ItemUpdateFlagsHandler(Sender: TObject); virtual; 
    procedure ItemUpdateValuesHandler(Sender: TObject); virtual; 
    procedure ItemUpdateShopListHandler(Sender: TObject); virtual;
    // event callers
    procedure UpdateMainList; virtual;
    procedure UpdateSmallList; virtual;
    procedure UpdateOverview; virtual;    
    // inits/finals
    procedure InitializeStaticOptions; virtual;
    procedure FinalizeStaticOptions; virtual;
    procedure Initialize; virtual;
    procedure Finalize; virtual;
    // other
    procedure DoUpdate; virtual;    
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
    procedure ReinitDrawSize(MainList: TListBox; SmallList: TListBox); virtual;
    // utility methods
    Function SortingItemStr(const SortingItem: TILSortingItem): String; virtual;
    // properties
    property StaticOptions: TILStaticManagerOptions read fStaticOptions;    
    property DataProvider: TILDataProvider read fDataProvider;
    property ItemCount: Integer read GetCount;
    property Items[Index: Integer]: TILItem read GetItem; default;
    property Notes: String read fNotes write fNotes;
    // encryption
    property Encrypted: Boolean read fEncrypted write fEncrypted;
    property ListPassword: String read fListPassword write fListPassword;
    // events
    // item shop events
    property OnShopListItemUpdate: TILObjectL2Event read fOnShopListItemUpdate write fOnShopListItemUpdate;
    property OnShopValuesUpdate: TILObjectL2Event read fOnShopValuesUpdate write fOnShopValuesUpdate;
    property OnShopAvailHistoryUpdate: TILObjectL2Event read fOnShopAvailHistoryUpd write fOnShopAvailHistoryUpd;
    property OnShopPriceHistoryUpdate: TILObjectL2Event read fOnShopPriceHistoryUpd write fOnShopPriceHistoryUpd;
    // item events
    property OnItemTitleUpdate: TILObjectL1Event read fOnItemTitleUpdate write fOnItemTitleUpdate;
    property OnItemPicturesUpdate: TILObjectL1Event read fOnItemPicturesUpdate write fOnItemPicturesUpdate;
    property OnItemFlagsUpdate: TILObjectL1Event read fOnItemFlagsUpdate write fOnItemFlagsUpdate;
    property OnItemValuesUpdate: TILObjectL1Event read fOnItemValuesUpdate write fOnItemValuesUpdate;
    property OnItemShopListUpdate: TILObjectL1Event read fOnItemShopListUpdate write fOnItemShopListUpdate;
    // global events
    property OnMainListUpdate: TNotifyEvent read fOnMainListUpdate write fOnMainListUpdate;
    property OnSmallListUpdate: TNotifyEvent read fOnSmallListUpdate write fOnSmallListUpdate;
    property OnOverviewUpdate: TNotifyEvent read fOnOverviewUpdate write fOnOverviewUpdate;
  end;

implementation

uses
  SysUtils,
  InflatablesList_Utils,
  InflatablesList_ItemShop;

const
  DEFAULT_LIST_FILENAME = 'list.inl';

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

procedure TILManager_Base.ShopUpdateShopListItemHandler(Sender: TObject; Shop: TObject);
begin
If Assigned(fOnShopListItemUpdate) and (Sender is TILItem) and (Shop is TILItemShop) then
  fOnShopListItemUpdate(Self,Sender,Shop);
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.ShopUpdateValuesHandler(Sender: TObject; Shop: TObject);
begin
If Assigned(fOnShopValuesUpdate) and (Sender is TILItem) and (Shop is TILItemShop) then
  fOnShopValuesUpdate(Self,Sender,Shop);
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.ShopUpdateAvailHistoryHandler(Sender: TObject; Shop: TObject);
begin
If Assigned(fOnShopAvailHistoryUpd) and (Sender is TILItem) and (Shop is TILItemShop) then
  fOnShopAvailHistoryUpd(Self,Sender,Shop);
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.ShopUpdatePriceHistoryHandler(Sender: TObject; Shop: TObject);
begin
If Assigned(fOnShopPriceHistoryUpd) and (Sender is TILItem) and (Shop is TILItemShop) then
  fOnShopPriceHistoryUpd(Self,Sender,Shop);
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.ItemUpdateMainListHandler(Sender: TObject);
begin
UpdateMainList;
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.ItemUpdateSmallListHandler(Sender: TObject);
begin
UpdateSmallList;
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.ItemUpdateOverviewHandler(Sender: TObject);
begin
UpdateOverview
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.ItemUpdateTitleHandler(Sender: TObject);
begin
If Assigned(fOnItemTitleUpdate) and (Sender is TILItem) then
  fOnItemTitleUpdate(Self,Sender);
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.ItemUpdatePicturesHandler(Sender: TObject);
begin
If Assigned(fOnItemPicturesUpdate) and (Sender is TILItem) then
  fOnItemPicturesUpdate(Self,Sender);
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.ItemUpdateFlagsHandler(Sender: TObject);
begin
If Assigned(fOnItemFlagsUpdate) and (Sender is TILItem) then
  fOnItemFlagsUpdate(Self,Sender);
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.ItemUpdateValuesHandler(Sender: TObject);
begin
If Assigned(fOnItemValuesUpdate) and (Sender is TILItem) then
  fOnItemValuesUpdate(Self,Sender);
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.ItemUpdateShopListHandler(Sender: TObject);
begin
If Assigned(fOnItemShopListUpdate) and (Sender is TILItem) then
  fOnItemShopListUpdate(Self,Sender);
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.UpdateMainList;
begin
If Assigned(fOnMainListUpdate) and (fUpdateCounter <= 0) then
  fOnMainListUpdate(Self);
fUpdated := True;
end;
 
//------------------------------------------------------------------------------

procedure TILManager_Base.UpdateSmallList;
begin
If Assigned(fOnSmallListUpdate) and (fUpdateCounter <= 0) then
  fOnSmallListUpdate(Self);
fUpdated := True;
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.UpdateOverview;
begin
If Assigned(fOnOverviewUpdate) and (fUpdateCounter <= 0) then
  fOnOverviewUpdate(Self);
fUpdated := True;
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.InitializeStaticOptions;
var
  CommandData:    TCLPParameter;
  CMDLineParser:  TCLPParser;
begin
CMDLineParser := TCLPParser.Create;
try
  fStaticOptions.NoPictures := CMDLineParser.CommandPresent('no_pics');
  fStaticOptions.TestCode := CMDLineParser.CommandPresent('test_code');
  fStaticOptions.SavePages := CMDLineParser.CommandPresent('save_pages');
  fStaticOptions.LoadPages := CMDLineParser.CommandPresent('load_pages');
  fStaticOptions.NoSave := CMDLineParser.CommandPresent('no_save');
  fStaticOptions.NoBackup := CMDLineParser.CommandPresent('no_backup');
  fStaticOptions.NoUpdateAutoLog := CMDLineParser.CommandPresent('no_updlog');
  // note that list_override also disables backups (equivalent to no_backup)
  fStaticOptions.ListOverride := False;
  fStaticOptions.ListPath := ExtractFilePath(ExpandFileName(ParamStr(0)));
  fStaticOptions.ListFile := fStaticOptions.ListPath + DEFAULT_LIST_FILENAME;
  If CMDLineParser.CommandPresent('list_override') then
    begin
      CMDLineParser.GetCommandData('list_override',CommandData);
      If Length(CommandData.Arguments) > 0 then
        begin
          fStaticOptions.NoBackup := True;        
          fStaticOptions.ListOverride := True;
          fStaticOptions.ListFile := ExpandFileName(CommandData.Arguments[Low(CommandData.Arguments)]);
          fStaticOptions.ListPath := ExtractFilePath(fStaticOptions.ListFile);
        end;
    end;
  // other static option
  fStaticOptions.DefaultPath := ExtractFilePath(ExpandFileName(ParamStr(0)));
finally
  CMDLineParser.Free;
end;
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.FinalizeStaticOptions;
begin
// do nothing
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.Initialize;
begin
InitializeStaticOptions;
fDataProvider := TILDataProvider.Create;
fSorting := False;
fUpdateCounter := 0;
fUpdated := False;
// list
fCount := 0;
SetLength(fList,0);
fNotes := '';
// encryption
fEncrypted := False;
fListPassword := '';
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.Finalize;
begin
ItemClear;
SetLength(fList,0);
FreeAndNil(fDataProvider);
FinalizeStaticOptions;
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.DoUpdate;
begin
UpdateMainList;
UpdateSmallList;
UpdateOverview;
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
    If fUpdated then
      DoUpdate;
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
fList[Result].AssignInternalEvents(
  ShopUpdateShopListItemHandler,
  ShopUpdateValuesHandler,
  ShopUpdateAvailHistoryHandler,
  ShopUpdatePriceHistoryHandler,
  ItemUpdateMainListHandler,
  ItemUpdateSmallListHandler,
  ItemUpdateOverviewHandler,
  ItemUpdateTitleHandler,
  ItemUpdatePicturesHandler,
  ItemUpdateFlagsHandler,
  ItemUpdateValuesHandler,
  ItemUpdateShopListHandler);
Inc(fCount);
DoUpdate;
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
    fList[Result].AssignInternalEvents(
      ShopUpdateShopListItemHandler,
      ShopUpdateValuesHandler,
      ShopUpdateAvailHistoryHandler,
      ShopUpdatePriceHistoryHandler,
      ItemUpdateMainListHandler,
      ItemUpdateSmallListHandler,
      ItemUpdateOverviewHandler,
      ItemUpdateTitleHandler,
      ItemUpdatePicturesHandler,
      ItemUpdateFlagsHandler,
      ItemUpdateValuesHandler,
      ItemUpdateShopListHandler);
    Inc(fCount);
    DoUpdate;
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
        DoUpdate;
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
    DoUpdate;
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
    DoUpdate;
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
DoUpdate;
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

procedure TILManager_Base.ReinitDrawSize(MainList: TListBox; SmallList: TListBox);
var
  i:  Integer;
begin
BeginUpdate;
try
  For i := ItemLowIndex to ItemHighIndex do
    fList[i].ReinitDrawSize(MainList,SmallList);
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
