unit InflatablesList_Manager_Base;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  Graphics, StdCtrls,
  AuxClasses,
  InflatablesList_Types,
  InflatablesList_Data,
  InflatablesList_Backup,
  InflatablesList_Item;

type
  TILManagerUpdatedFlag = (ilmufMainList,ilmufSmallList,ilmufMiniList,
                           ilmufOverview,ilmufSettings);

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
    fHasItemsPassword:            Boolean;
    fItemsPassword:               String;
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
    fOnMiniListUpdate:            TNotifyEvent;
    fOnOverviewUpdate:            TNotifyEvent;
    fOnSettingsChange:            TNotifyEvent;
    fOnItemsPasswordRequest:      TNotifyEvent;
    // main list
    fList:                        array of TILItem;
    fCount:                       Integer;
    // other data
    fNotes:                       String;
    fListName:                    String;
    // getters and setters
    procedure SetEncrypted(Value: Boolean); virtual;
    procedure SetListPassword(const Value: String); virtual;
    procedure SetCompressed(Value: Boolean); virtual;
    procedure SetItemsPassword(const Value: String); virtual;    
    // data getters and setters
    procedure SetNotes(const Value: String); virtual;
    procedure SetListName(const Value: String); virtual;
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
    procedure ItemUpdateMiniListHandler(Sender: TObject); virtual;
    procedure ItemUpdateOverviewHandler(Sender: TObject); virtual;
    procedure ItemUpdateTitleHandler(Sender: TObject); virtual;
    procedure ItemUpdatePicturesHandler(Sender: TObject); virtual; 
    procedure ItemUpdateFlagsHandler(Sender: TObject); virtual; 
    procedure ItemUpdateValuesHandler(Sender: TObject); virtual; 
    procedure ItemUpdateShopListHandler(Sender: TObject); virtual;
    Function ItemPasswordRequestHandler(Sender: TObject; out Password: String): Boolean; virtual;
    // event callers
    procedure UpdateMainList; virtual;
    procedure UpdateSmallList; virtual;
    procedure UpdateMiniList; virtual;
    procedure UpdateOverview; virtual;
    procedure UpdateSettings; virtual;
    procedure RequestItemsPassword; virtual;
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
    Function ItemIndexOf(ItemUniqueID: TGUID): Integer; virtual;
    Function ItemAddEmpty: Integer; virtual;
    Function ItemAddCopy(SrcIndex: Integer): Integer; virtual;
    procedure ItemExchange(Idx1,Idx2: Integer); virtual;
    procedure ItemMove(Src,Dst: Integer); virtual;
    procedure ItemDelete(Index: Integer); virtual;
    procedure ItemClear; virtual;
    // macro methods (broadcast to item objects)
    procedure ReinitMainDrawSize(MainWidth,MainHeight: Integer; MainFont: TFont); overload; virtual;
    procedure ReinitMainDrawSize(MainList: TListBox); overload; virtual;
    procedure ReinitMainDrawSize(MainList: TListBox; OnlyVisible: Boolean); overload; virtual;
    procedure ReinitSmallDrawSize(SmallWidth,SmallHeight: Integer; SmallFont: TFont); overload; virtual;
    procedure ReinitSmallDrawSize(SmallList: TListBox); overload; virtual;
    procedure ReinitMiniDrawSize(MiniWidth,MiniHeight: Integer; MiniFont: TFont); virtual;
    // utility methods
    Function SortingItemStr(const SortingItem: TILSortingItem): String; virtual;
    Function TotalPictureCount: Integer; virtual;
    procedure AssignInternalEventHandlers; virtual;
    Function EncryptedItemCount(CountDecrypted: Boolean): Integer; virtual;
    Function CheckItemPassword(const Password: String): Boolean; virtual;
    Function DecryptAllItems: Integer; virtual;
    Function GenerateUserID(out NewID: String): Boolean; virtual;
    // properties
    property Transient: Boolean read fTransient;
    property StaticSettings: TILStaticManagerSettings read fStaticSettings;
    property DataProvider: TILDataProvider read fDataProvider;
    property BackupManager: TILBackupManager read fBackupManager;
    // list properties
    property Encrypted: Boolean read fEncrypted write SetEncrypted;
    property ListPassword: String read fListPassword write SetListPassword;
    property Compressed: Boolean read fCompressed write SetCompressed;
    property HasItemsPassword: Boolean read fHasItemsPassword;
    property ItemsPassword: String read fItemsPassword write SetItemsPassword;    
    // list and data
    property ItemCount: Integer read GetCount;
    property Items[Index: Integer]: TILItem read GetItem; default;
    property Notes: String read fNotes write SetNotes;
    property ListName: String read fListName write SetListName;
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
    property OnMiniListUpdate: TNotifyEvent read fOnMiniListUpdate write fOnMiniListUpdate;
    property OnOverviewUpdate: TNotifyEvent read fOnOverviewUpdate write fOnOverviewUpdate;
    property OnSettingsChange: TNotifyEvent read fOnSettingsChange write fOnSettingsChange;
    property OnItemsPasswordRequest: TNotifyEvent read fOnItemsPasswordRequest write fOnItemsPasswordRequest;
  end;

implementation

uses
  SysUtils,
  SimpleCmdLineParser, StrRect, BitVector,
  InflatablesList_Utils,
  InflatablesList_Encryption,
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

procedure TILManager_Base.SetItemsPassword(const Value: String);
begin
If CheckItemPassword(Value) then
  begin
    fItemsPassword := Value;
    UniqueString(fItemsPassword);
    fHasItemsPassword := True;
  end
else raise EILWrongPassword.Create('TILManager_Base.SetItemsPassword: Wrong password.');
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

procedure TILManager_Base.SetListName(const Value: String);
begin
If not IL_SameStr(fListName,Value) then
  begin
    fListName := Value;
    UniqueString(fListName);
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

procedure TILManager_Base.ItemUpdateMiniListHandler(Sender: TObject);
begin
UpdateMiniList;
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

Function TILManager_Base.ItemPasswordRequestHandler(Sender: TObject; out Password: String): Boolean;
begin
Password := '';
If not fHasItemsPassword then
  RequestItemsPassword; // prompt for password, changes fItemsPassword
If fHasItemsPassword then
  begin
    Password := fItemsPassword;
    Result := True;
  end
else Result := False;
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

procedure TILManager_Base.UpdateMiniList;
begin
If Assigned(fOnMiniListUpdate) and (fUpdateCounter <= 0) then
  fOnMiniListUpdate(Self);
Include(fUpdated,ilmufMiniList);
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

procedure TILManager_Base.RequestItemsPassword;
begin
// just a caller...
If Assigned(fOnItemsPasswordRequest) then
  fOnItemsPasswordRequest(Self);
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.UpdateList;
begin
UpdateMainList;
UpdateSmallList;
UpdateMiniList;
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
  fStaticSettings.NoParse := CMDLineParser.CommandPresent('no_parse');  
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
  fStaticSettings.ListName := IL_ExtractFileNameNoExt(fStaticSettings.ListFile);
  fStaticSettings.PicturesPath := IL_IncludeTrailingPathDelimiter(
    fStaticSettings.ListPath + fStaticSettings.ListName + '_pics');
  fStaticSettings.BackupPath := IL_IncludeTrailingPathDelimiter(
    fStaticSettings.ListPath + fStaticSettings.ListName + '_backup');
  fStaticSettings.SavedPagesPath := IL_IncludeTrailingPathDelimiter(
    fStaticSettings.ListPath + fStaticSettings.ListName + '_saved_pages');
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
fBackupManager := TILBackupManager.Create;
fBackupManager.StaticSettings := fStaticSettings;
fBackupManager.LoadBackups;
fSorting := False;
fUpdateCounter := 0;
fUpdated := [];
// encryption
fEncrypted := False;
fListPassword := '';
fHasItemsPassword := False;
fItemsPassword := '';
fCompressed := False;
// list
SetLength(fList,0);
fCount := 0;
fNotes := '';
fListName := '';
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
fHasItemsPassword := Source.HasItemsPassword;
fItemsPassword := Source.ItemsPassword;
UniqueString(fItemsPassword);
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
fListName := Source.ListName;
UniqueString(fListName);
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
fHasItemsPassword := Source.HasItemsPassword;
fItemsPassword := Source.ItemsPassword;
UniqueString(fItemsPassword);
// copy the list
Capacity := Source.Count;
For i := Source.LowIndex to Source.HighIndex do
  fList[i] := TILItem.CreateAsCopy(fDataProvider,Source[i],True);
fCount := Source.Count;
// other data
fNotes := Source.Notes;
UniqueString(fNotes);
fListName := Source.ListName;
UniqueString(fListName);
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
    If ilmufMiniList in fUpdated then
      UpdateMiniList;
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

Function TILManager_Base.ItemIndexOf(ItemUniqueID: TGUID): Integer;
var
  i:  Integer;
begin
Result := -1;
For i := ItemLowIndex to ItemHighIndex do
  If fList[i].DataAccessible then
    If IsEqualGUID(ItemUniqueID,fList[i].UniqueID) then
      begin
        Result := i;
        Break{For i};
      end;
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
  ItemUpdateMiniListHandler,
  ItemUpdateOverviewHandler,
  ItemUpdateTitleHandler,
  ItemUpdatePicturesHandler,
  ItemUpdateFlagsHandler,
  ItemUpdateValuesHandler,
  ItemUpdateShopListHandler,
  ItemPasswordRequestHandler);
Inc(fCount);
UpdateList;
UpdateOverview;
end;

//------------------------------------------------------------------------------

Function TILManager_Base.ItemAddCopy(SrcIndex: Integer): Integer;
begin
If (SrcIndex >= ItemLowIndex) and (SrcIndex <= ItemHighIndex) then
  begin
    If fList[SrcIndex].DataAccessible then
      begin
        Grow;
        Result := fCount;
        fList[Result] := TILItem.CreateAsCopy(fDataProvider,fList[SrcIndex],True);
        fList[Result].Index := Result;
        fList[Result].AssignInternalEvents(
          ShopUpdateShopListItemHandler,
          ShopUpdateValuesHandler,
          ShopUpdateAvailHistoryHandler,
          ShopUpdatePriceHistoryHandler,
          ItemUpdateMainListHandler,
          ItemUpdateSmallListHandler,
          ItemUpdateMiniListHandler,
          ItemUpdateOverviewHandler,
          ItemUpdateTitleHandler,
          ItemUpdatePicturesHandler,
          ItemUpdateFlagsHandler,
          ItemUpdateValuesHandler,
          ItemUpdateShopListHandler,
          ItemPasswordRequestHandler);
        Inc(fCount);
        UpdateList;
        UpdateOverview;
      end
    else raise Exception.Create('TILManager_Base.ItemAddCopy: Cannot create copy of encrypted item.');
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
        UpdateList;
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
    UpdateList;
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
    UpdateOverview;
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
UpdateOverview;
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.ReinitMainDrawSize(MainWidth,MainHeight: Integer; MainFont: TFont);
var
  i:  Integer;
begin
BeginUpdate;
try
  For i := ItemLowIndex to ItemHighIndex do
    fList[i].ReinitMainDrawSize(MainWidth,MainHeight,MainFont);
finally
  EndUpdate;
end;
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

procedure TILManager_Base.ReinitMainDrawSize(MainList: TListBox);
var
  i:  Integer;
begin
BeginUpdate;
try
  For i := ItemLowIndex to ItemHighIndex do
    fList[i].ReinitMainDrawSize(MainList);
finally
  EndUpdate;
end;
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

procedure TILManager_Base.ReinitMainDrawSize(MainList: TListBox; OnlyVisible: Boolean);
var
  i:  Integer;
begin
If OnlyVisible and CheckIndex(MainList.TopIndex) and
  CheckIndex(Pred(MainList.TopIndex + MainList.ClientHeight div MainList.ItemHeight)) then
  begin
    BeginUpdate;
    try
      For i := MainList.TopIndex to Pred(MainList.TopIndex + MainList.ClientHeight div MainList.ItemHeight) do
        fList[i].ReinitMainDrawSize(MainList);
    finally
      EndUpdate;
    end;
  end
else
  begin
    BeginUpdate;
    try
      For i := ItemLowIndex to ItemHighIndex do
        fList[i].ReinitMainDrawSize(MainList);
    finally
      EndUpdate;
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.ReinitSmallDrawSize(SmallWidth,SmallHeight: Integer; SmallFont: TFont);
var
  i:  Integer;
begin
BeginUpdate;
try
  For i := ItemLowIndex to ItemHighIndex do
    fList[i].ReinitSmallDrawSize(SmallWidth,SmallHeight,SmallFont);
finally
  EndUpdate;
end;
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

procedure TILManager_Base.ReinitSmallDrawSize(SmallList: TListBox);
var
  i:  Integer;
begin
BeginUpdate;
try
  For i := ItemLowIndex to ItemHighIndex do
    fList[i].ReinitSmallDrawSize(SmallList);
finally
  EndUpdate;
end;
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.ReinitMiniDrawSize(MiniWidth,MiniHeight: Integer; MiniFont: TFont);
var
  i:  Integer;
begin
BeginUpdate;
try
  For i := ItemLowIndex to ItemHighIndex do
    fList[i].ReinitMiniDrawSize(MiniWidth,MiniHeight,MiniFont);
finally
  EndUpdate;
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
  If fList[i].DataAccessible then
    Inc(Result,fList[i].Pictures.Count);
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.AssignInternalEventHandlers;
var
  i:  Integer;
begin
For i := ItemLowIndex to ItemhighIndex do
  begin
    fList[i].AssignInternalEventHandlers;
    fList[i].AssignInternalEvents(
      ShopUpdateShopListItemHandler,
      ShopUpdateValuesHandler,
      ShopUpdateAvailHistoryHandler,
      ShopUpdatePriceHistoryHandler,
      ItemUpdateMainListHandler,
      ItemUpdateSmallListHandler,
      ItemUpdateMiniListHandler,
      ItemUpdateOverviewHandler,
      ItemUpdateTitleHandler,
      ItemUpdatePicturesHandler,
      ItemUpdateFlagsHandler,
      ItemUpdateValuesHandler,
      ItemUpdateShopListHandler,
      ItemPasswordRequestHandler);
  end;
end;

//------------------------------------------------------------------------------

Function TILManager_Base.EncryptedItemCount(CountDecrypted: Boolean): Integer;
var
  i:  Integer;
begin
Result := 0;
For i := ItemLowIndex to ItemHighIndex do
  If fList[i].Encrypted and (not fList[i].DataAccessible or CountDecrypted) then
    Inc(Result);
end;

//------------------------------------------------------------------------------

Function TILManager_Base.CheckItemPassword(const Password: String): Boolean;
var
  i:  Integer;
begin
Result := True;
For i := ItemLowIndex to ItemHighIndex do
  If fList[i].Encrypted and not fList[i].DataAccessible then
    begin
      // try it only on the first encountered item
      Result := fList[i].TryDecrypt(Password);
      Break{For i};
    end;
end;

//------------------------------------------------------------------------------

Function TILManager_Base.DecryptAllItems: Integer;
var
  i:      Integer;
  Dummy:  String;
begin
Result := 0;
If (EncryptedItemCount(False) > 0) and ItemPasswordRequestHandler(Self,Dummy) then
  For i := ItemLowIndex to ItemHighIndex do
    If fList[i].Encrypted and not fList[i].DataAccessible then
      begin
        fList[i].Decrypt;
        Inc(Result);
      end;
end;

//------------------------------------------------------------------------------

Function TILManager_Base.GenerateUserID(out NewID: String): Boolean;
var
  i:      Integer;
  Temp:   Integer;
  Taken:  TBitVector;
begin
NewID := '';
Result := False;
Taken := TBitVector.Create(10000);
try
  Taken[0] := True; // ID 0 is not allowed
  For i := ItemLowIndex to ItemHighIndex do
    If fList[i].DataAccessible then
      If TryStrToInt(fList[i].UserID,Temp) then
        If (Temp > 0) and (Temp < Taken.Count) then
          Taken[Temp] := True;
  // find first unassigned id
  i := Taken.FirstClean;
  If i > 0 then
    begin
      NewId := IL_Format('%.4d',[i]);
      Result := True;
    end;
finally
  Taken.Free;
end;
end;

end.
