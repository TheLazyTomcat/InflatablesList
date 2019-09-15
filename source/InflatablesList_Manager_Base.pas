unit InflatablesList_Manager_Base;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  StdCtrls,
  AuxClasses,
  InflatablesList_Types,
  InflatablesList_Data,
  InflatablesList_Backup,
  InflatablesList_Item;

type
  TILManagerUpdatedFlag = (ilmufMainList,ilmufSmallList,ilmufOverview,ilmufSettings);

  TILManagerUpdatedFlags = set of TILManagerUpdatedFlag;

  TILManager_Base = class(TCustomListObject)
  protected
    fTransient:                   Boolean;
    fStaticSettings:              TILStaticManagerSettings; // not changed at runtime
    fBackupManager:               TILBackupManager;
    fDataProvider:                TILDataProvider;
    fSorting:                     Boolean;                  // transient, used only during sorting to disable reindexing
    fUpdateCounter:               Integer;                  // transient (not copied in copy constructor)
    fUpdated:                     TILManagerUpdatedFlags;   // transient
    // list properties
    fEncrypted:                   Boolean;
    fListPassword:                String;
    fCompressed:                  Boolean;
    // internal events forwarded from item shops
    fOnShopListItemUpdate:        TILIndexedObjectL2Event;  // all events are transient
    fOnShopValuesUpdate:          TILObjectL2Event;
    fOnShopAvailHistoryUpd:       TILObjectL2Event;
    fOnShopPriceHistoryUpd:       TILObjectL2Event;
    // internal events forwarded from items
    fOnItemTitleUpdate:           TILObjectL1Event;
    fOnItemPicturesUpdate:        TILObjectL1Event;
    fOnItemFlagsUpdate:           TILObjectL1Event;
    fOnItemValuesUpdate:          TILObjectL1Event;         // reserved for item frame
    fOnItemShopListUpdate:        TILObjectL1Event;
    fOnItemShopListValuesUpdate:  TILObjectL1Event;         // reserved for shop form
    // events
    fOnMainListUpdate:            TNotifyEvent;
    fOnSmallListUpdate:           TNotifyEvent;
    fOnOverviewUpdate:            TNotifyEvent;
    fOnSettingsChange:            TNotifyEvent;
    // main list
    fList:                        array of TILItem;
    fCount:                       Integer;
    // other data
    fNotes:                       String;
    // getters and setters
    procedure SetEncrypted(Value: Boolean); virtual;
    procedure SetListPassword(const Value: String); virtual;
    procedure SetCompressed(Value: Boolean); virtual;
    // data getters and setters
    procedure SetNotes(const Value: String); virtual;
    // list methods
    Function GetCapacity: Integer; override;
    procedure SetCapacity(Value: Integer); override;
    Function GetCount: Integer; override;
    procedure SetCount(Value: Integer); override;
    Function GetItem(Index: Integer): TILITem; virtual;
    // handlers for item shop events
    procedure ShopUpdateShopListItemHandler(Sender: TObject; Shop: TObject; Index: Integer); virtual;
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
    procedure UpdateSettings; virtual;
    // macro callers
    procedure UpdateList; virtual;
    // inits/finals
    procedure InitializeStaticSettings; virtual;
    procedure FinalizeStaticSettings; virtual;
    procedure Initialize; virtual;
    procedure Finalize; virtual;
    // other
    procedure ReIndex; virtual;
    procedure ThisCopyFrom_Base(Source: TILManager_Base); virtual;
  public
    constructor Create;
    constructor CreateAsCopy(Source: TILManager_Base); virtual; // will be overriden
    constructor CreateTransient;  // nothing is initialized, use with great caution
    destructor Destroy; override;
    procedure CopyFrom(Source: TILManager_Base); virtual;
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
    procedure ReinitDrawSize(MainList: TListBox; SmallList: TListBox); overload; virtual;
    procedure ReinitDrawSize(MainList: TListBox; OnlyVisible: Boolean); overload; virtual;
    // utility methods
    Function SortingItemStr(const SortingItem: TILSortingItem): String; virtual;
    Function TotalPictureCount: Integer; virtual;
    // properties
    property Transient: Boolean read fTransient;
    property StaticSettings: TILStaticManagerSettings read fStaticSettings;    
    property DataProvider: TILDataProvider read fDataProvider;
    property BackupManager: TILBackupManager read fBackupManager;
    // encryption
    property Encrypted: Boolean read fEncrypted write SetEncrypted;
    property ListPassword: String read fListPassword write SetListPassword;
    // other list properties
    property Compressed: Boolean read fCompressed write SetCompressed;
    // list and data
    property ItemCount: Integer read GetCount;
    property Items[Index: Integer]: TILItem read GetItem; default;
    property Notes: String read fNotes write SetNotes;
    // item shop events
    property OnShopListItemUpdate: TILIndexedObjectL2Event read fOnShopListItemUpdate write fOnShopListItemUpdate;
    property OnShopValuesUpdate: TILObjectL2Event read fOnShopValuesUpdate write fOnShopValuesUpdate;
    property OnShopAvailHistoryUpdate: TILObjectL2Event read fOnShopAvailHistoryUpd write fOnShopAvailHistoryUpd;
    property OnShopPriceHistoryUpdate: TILObjectL2Event read fOnShopPriceHistoryUpd write fOnShopPriceHistoryUpd;
    // item events
    property OnItemTitleUpdate: TILObjectL1Event read fOnItemTitleUpdate write fOnItemTitleUpdate;
    property OnItemPicturesUpdate: TILObjectL1Event read fOnItemPicturesUpdate write fOnItemPicturesUpdate;
    property OnItemFlagsUpdate: TILObjectL1Event read fOnItemFlagsUpdate write fOnItemFlagsUpdate;
    property OnItemValuesUpdate: TILObjectL1Event read fOnItemValuesUpdate write fOnItemValuesUpdate;
    property OnItemShopListUpdate: TILObjectL1Event read fOnItemShopListUpdate write fOnItemShopListUpdate;
    property OnItemShopListValuesUpdate: TILObjectL1Event read fOnItemShopListValuesUpdate write fOnItemShopListValuesUpdate;
    // global events
    property OnMainListUpdate: TNotifyEvent read fOnMainListUpdate write fOnMainListUpdate;
    property OnSmallListUpdate: TNotifyEvent read fOnSmallListUpdate write fOnSmallListUpdate;
    property OnOverviewUpdate: TNotifyEvent read fOnOverviewUpdate write fOnOverviewUpdate;
    property OnSettingsChange: TNotifyEvent read fOnSettingsChange write fOnSettingsChange;
  end;

implementation

uses
  SysUtils,
  SimpleCmdLineParser, StrRect,
  InflatablesList_Utils,
  InflatablesList_ItemShop;

const
  IL_DEFAULT_LIST_FILENAME = 'list.inl';

procedure TILManager_Base.SetEncrypted(Value: Boolean);
begin
If fEncrypted <> Value then
  begin
    fEncrypted := Value;
    UpdateSettings;
  end;
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.SetListPassword(const Value: String);
begin
If not IL_SameStr(fListPassword,Value) then
  begin
    fListPassword := Value;
    UniqueString(fListPassword);
    UpdateSettings;
  end;
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.SetCompressed(Value: Boolean);
begin
If fCompressed <> Value then
  begin
    fCompressed := Value;
    UpdateSettings;
  end;
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.SetNotes(const Value: String);
begin
If not IL_SameStr(fNotes,Value) then
  begin
    fNotes := Value;
    UniqueString(fNotes);
  end;
end;

//------------------------------------------------------------------------------

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
  begin
    For i := Value to Pred(fCount) do
      fList[i].Free;
    fCount := Value;
  end;
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

procedure TILManager_Base.ShopUpdateShopListItemHandler(Sender: TObject; Shop: TObject; Index: Integer);
begin
If Assigned(fOnShopListItemUpdate) and (Sender is TILItem) and (Shop is TILItemShop) then
  fOnShopListItemUpdate(Self,Sender,Shop,Index);
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
UpdateOverview;
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
If Sender is TILItem then
  begin
    If Assigned(fOnItemValuesUpdate) then
      fOnItemValuesUpdate(Self,Sender);
    If Assigned(fOnItemShopListValuesUpdate) then
      fOnItemShopListValuesUpdate(Self,Sender);
  end;
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
Include(fUpdated,ilmufMainList);
end;
 
//------------------------------------------------------------------------------

procedure TILManager_Base.UpdateSmallList;
begin
If Assigned(fOnSmallListUpdate) and (fUpdateCounter <= 0) then
  fOnSmallListUpdate(Self);
Include(fUpdated,ilmufSmallList);
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.UpdateOverview;
begin
If Assigned(fOnOverviewUpdate) and (fUpdateCounter <= 0) then
  fOnOverviewUpdate(Self);
Include(fUpdated,ilmufOverview);
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.UpdateSettings;
begin
If Assigned(fOnSettingsChange) and (fUpdateCounter <= 0) then
  fOnSettingsChange(Self);
Include(fUpdated,ilmufSettings);
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.UpdateList;
begin
UpdateMainList;
UpdateSmallList;
UpdateOverview;
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.InitializeStaticSettings;
var
  CommandData:    TCLPParameter;
  CMDLineParser:  TCLPParser;
begin
CMDLineParser := TCLPParser.Create;
try
  fStaticSettings.NoPictures := CMDLineParser.CommandPresent('no_pics');
  fStaticSettings.TestCode := CMDLineParser.CommandPresent('test_code');
  fStaticSettings.SavePages := CMDLineParser.CommandPresent('save_pages');
  fStaticSettings.LoadPages := CMDLineParser.CommandPresent('load_pages');
  fStaticSettings.NoSave := CMDLineParser.CommandPresent('no_save');
  fStaticSettings.NoBackup := CMDLineParser.CommandPresent('no_backup');
  fStaticSettings.NoUpdateAutoLog := CMDLineParser.CommandPresent('no_updlog');
  // note that list_override also disables backups (equivalent to no_backup)
  fStaticSettings.ListOverride := False;
  fStaticSettings.DefaultPath := IL_ExtractFilePath(IL_ExpandFileName(RTLToStr(ParamStr(0))));
  fStaticSettings.ListPath := fStaticSettings.DefaultPath;
  fStaticSettings.ListFile := fStaticSettings.ListPath + IL_DEFAULT_LIST_FILENAME;
  If CMDLineParser.CommandPresent('list_override') then
    begin
      CMDLineParser.GetCommandData('list_override',CommandData);
      If Length(CommandData.Arguments) > 0 then
        begin
          fStaticSettings.ListOverride := True;
          fStaticSettings.ListFile := IL_ExpandFileName(CommandData.Arguments[Low(CommandData.Arguments)]);
          fStaticSettings.ListPath := IL_ExtractFilePath(fStaticSettings.ListFile);
        end;
    end;
finally
  CMDLineParser.Free;
end;
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.FinalizeStaticSettings;
begin
// do nothing
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.Initialize;
begin
fTransient := False;
InitializeStaticSettings;
fDataProvider := TILDataProvider.Create;
fBackupManager := TILBackupManager.Create(fStaticSettings.ListFile);
fBackupManager.LoadBackups;
fSorting := False;
fUpdateCounter := 0;
fUpdated := [];
// encryption
fEncrypted := False;
fListPassword := '';
fCompressed := False;
// list
SetLength(fList,0);
fCount := 0;
fNotes := '';
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.Finalize;
begin
ItemClear;
SetLength(fList,0);
FreeAndNil(fBackupManager);
FreeAndNil(fDataProvider);  // no need to save backups, they are saved in backup itself
FinalizeStaticSettings;
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.ReIndex;
var
  i:  Integer;
begin
For i := ItemLowIndex to ItemHighIndex do
  fList[i].Index := i;
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.ThisCopyFrom_Base(Source: TILManager_Base);
var
  i:  Integer;
begin
// implements CopyFrom for this one class, no inheritance
// properties
fTransient := Source.Transient;
fStaticSettings := IL_THreadSafeCopy(Source.StaticSettings);
fEncrypted := Source.Encrypted;
fListPassword := Source.ListPassword;
UniqueString(fListPassword);
fCompressed := Source.Compressed;
// free existing items
For i := ItemLowIndex to ItemHighIndex do
  FreeAndNil(fList[i]);
// copy items
SetLength(fList,Source.ItemCount);
fCount := Source.ItemCount;
For i := ItemLowIndex to ItemHighIndex do
  fList[i] := TILItem.CreateAsCopy(fDataProvider,Source[i],True);
// other data
fNotes := Source.Notes;
UniqueString(fNotes);
end;

//==============================================================================

constructor TILManager_Base.Create;
begin
inherited Create;
Initialize;
end;

//------------------------------------------------------------------------------

constructor TILManager_Base.CreateAsCopy(Source: TILManager_Base);
var
  i:  Integer;
begin
Create;
fStaticSettings := IL_ThreadSafeCopy(Source.StaticSettings);
{
  data provider was already created in a call to Create, no need to recreate it
  but recreate backup manager
}
FreeAndNil(fBackupManager);
fBackupManager := TILBackupManager.CreateAsCopy(Source.BackupManager);
fEncrypted := Source.Encrypted;
fListPassword := Source.ListPassword;
UniqueString(fListPassword);
fCompressed := Source.Compressed;
// copy the list
Capacity := Source.Count;
For i := Source.LowIndex to Source.HighIndex do
  fList[i] := TILItem.CreateAsCopy(fDataProvider,Source[i],True);
fCount := Source.Count;
// other data
fNotes := Source.Notes;
UniqueString(fNotes);
end;

//------------------------------------------------------------------------------

constructor TILManager_Base.CreateTransient;
begin
inherited Create;
fTransient := True;
{
  No field is initialized, no internal object created.

  This means instance created by calling this constructor can be used only for
  specific purposes.

  At this moment, only following methods and properties/fields can be safely
  accessed:

     - property Transient
     - method PreloadStream
     - method PreloadFile(String) - only this one overload!

  No other method should be called, and no property/field accesses.
}
end;

//------------------------------------------------------------------------------

destructor TILManager_Base.Destroy;
begin
If not fTransient then
  Finalize;
inherited;
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.CopyFrom(Source: TILManager_Base);
begin
{
  copies all data and non-transient, non-object properties from the source,
  replacing existing data and values
}
ThisCopyFrom_Base(Source);
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.BeginUpdate;
begin
If fUpdateCounter <= 0 then
  fUpdated := [];
Inc(fUpdateCounter);
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.EndUpdate;
begin
Dec(fUpdateCounter);
If fUpdateCounter <= 0 then
  begin
    fUpdateCounter := 0;
    If ilmufMainList in fUpdated then
      UpdateMainList;
    If ilmufSmallList in fUpdated then
      UpdateSmallList;
    If ilmufOverview in fUpdated then
      UpdateOverview;
    If ilmufSettings in fUpdated then
      UpdateSettings;
    fUpdated := [];
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
fList[Result].StaticSettings := fStaticSettings;
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
UpdateList;
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
    fList[Result].StaticSettings := fStaticSettings;
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
    UpdateList;
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
    If not CheckIndex(Idx1) then
      raise Exception.CreateFmt('TILManager_Base.ItemExchange: Index 1 (%d) out of bounds.',[Idx1]);
    If not CheckIndex(Idx2) then 
      raise Exception.CreateFmt('TILManager_Base.ItemExchange: Index 2 (%d) out of bounds.',[Idx1]);
    Temp := fList[Idx1];
    fList[Idx1] := fList[Idx2];
    fList[Idx2] := Temp;
    If not fSorting then
      begin
        // full reindex not needed
        fList[Idx1].Index := Idx1;
        fList[Idx2].Index := Idx2;
        UpdateMainList;
        UpdateSmallList;
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
    If not CheckIndex(Src) then
      raise Exception.CreateFmt('TILManager_Base.ItemMove: Source index (%d) out of bounds.',[Src]);
    If not CheckIndex(Dst) then 
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
    UpdateMainList;
    UpdateSmallList;
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
    Shrink;
    ReIndex;    
    UpdateList;
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
UpdateList;
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

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

procedure TILManager_Base.ReinitDrawSize(MainList: TListBox; OnlyVisible: Boolean);
var
  i:  Integer;
begin
If OnlyVisible and CheckIndex(MainList.TopIndex) and
  CheckIndex(Pred(MainList.TopIndex + MainList.ClientHeight div MainList.ItemHeight)) then
  begin
    BeginUpdate;
    try
      For i := MainList.TopIndex to Pred(MainList.TopIndex + MainList.ClientHeight div MainList.ItemHeight) do
        fList[i].ReinitDrawSize(MainList);
    finally
      EndUpdate;
    end;
  end
else
  begin
    BeginUpdate;
    try
      For i := ItemLowIndex to ItemHighIndex do
        fList[i].ReinitDrawSize(MainList);
    finally
      EndUpdate;
    end;
  end;
end;

//------------------------------------------------------------------------------

Function TILManager_Base.SortingItemStr(const SortingItem: TILSortingItem): String;
begin
Result := IL_Format('%s %s',[IL_BoolToStr(SortingItem.Reversed,'+','-'),
  fDataProvider.GetItemValueTagString(SortingItem.ItemValueTag)])
end;

//------------------------------------------------------------------------------

Function TILManager_Base.TotalPictureCount: Integer;
var
  i:  Integer;
begin
Result := 0;
For i := ItemLowIndex to ItemhighIndex do
  begin
    If Assigned(fList[i].ItemPicture) then Inc(Result);
    If Assigned(fList[i].SecondaryPicture) then Inc(Result);
    If Assigned(fList[i].PackagePicture) then Inc(Result);
  end;
end;

end.
