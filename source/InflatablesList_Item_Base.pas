unit InflatablesList_Item_Base;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  Graphics,
  AuxTypes, AuxClasses, MemoryBuffer,
  InflatablesList_Types,
  InflatablesList_Data,
  InflatablesList_ItemShop;

type
  TILItemUpdatedFlag = (iliufMainList,iliufSmallList,iliufOverview,iliufTitle,
                        iliufPictures,iliufFlags,iliufValues,iliufShopList);

  TILItemUpdatedFlags = set of TILItemUpdatedFlag;

  TILItem_Base = class(TCustomListObject)
  protected
    fDataProvider:          TILDataProvider;
    fOwnsDataProvider:      Boolean;
    fStaticSettings:        TILStaticManagerSettings;
    fIndex:                 Integer;  // used in sorting
    fRender:                TBitmap;
    fRenderSmall:           TBitmap;
    fFilteredOut:           Boolean;
    fUpdateCounter:         Integer;
    fUpdated:               TILItemUpdatedFlags;
    // internal events forwarded from item shops
    fOnShopListItemUpdate:  TILIndexedObjectL1Event;
    fOnShopValuesUpdate:    TILObjectL1Event;
    fOnShopAvailHistoryUpd: TILObjectL1Event;
    fOnShopPriceHistoryUpd: TILObjectL1Event;
    // internal events
    fOnMainListUpdate:      TNotifyEvent;
    fOnSmallListUpdate:     TNotifyEvent;
    fOnOverviewUpdate:      TNotifyEvent;
    fOnTitleUpdate:         TNotifyEvent;
    fOnPicturesUpdate:      TNotifyEvent;
    fOnFlagsUpdate:         TNotifyEvent;
    fOnValuesUpdate:        TNotifyEvent;
    fOnShopListUpdate:      TNotifyEvent;
    // item flags and internal data
  {$IFDEF DevelMsgs}
    {$message 'implement encryption'}
  {$ENDIF}
  {
    - decryption if individual items or all of them
    - list-wide password
    - fCurrentPassword, fNewPassword
    - do not ask for password when it was already entered
    - ask for pswd only when needed, not at the list load

    encryption process:

      - when no item is as of yet encrypted and user marks an item as ecrypted,
        prompt for a password (list-wide), this pswd will be stored in the list
        manager and used in each saving
      - when there are encrypted items in the list none of which were decrypted
        and another is marked as encrypted, prompt for password - use this
        password to ad-hoc decrypt first encrypted item and when the pswd
        matches, store it in list manager and use it to encrypt the item during
        saving (do not decrypt or re-encrypt other items during this process)
      - when there are decrypted items and new item is marked as encrypted,
        a valid password must be in the list manager - do not prompt for a new
        one and use this one instead

      - when changing the password, firt ask for an old one if there are any
        encrypted items (test it) and store the new one in different field (the
        old one must be used to decrypt already encrypted items to re-encrypt
        them
  }
    fEncrypted:             Boolean;        // item will be encrypted during saving
    fDataAccessible:        Boolean;        // unencrypted or decrypted item
    fEncryptedData:         TMemoryBuffer;
    // item data...
    // general read-only info
    fUniqueID:              TGUID;
    fTimeOfAddition:        TDateTime;
    // stored pictures
    fItemPicture:           TBitmap;  // 96 x 96 px, white background
    fSecondaryPicture:      TBitmap;  // 96 x 96 px, white background
    fPackagePicture:        TBitmap;  // 96 x 96 px, white background
    // not stored pictures
    fItemPictureSmall:      TBitmap;  // 48 x 48 px, white background
    fSecondaryPictureSmall: TBitmap;  // 48 x 48 px, white background
    fPackagePictureSmall:   TBitmap;  // 48 x 48 px, white background
    // basic specs
    fItemType:              TILItemType;
    fItemTypeSpec:          String;   // closer specification of type
    fPieces:                UInt32;
    fManufacturer:          TILItemManufacturer;
    fManufacturerStr:       String;
    fTextID:                String;
    fID:                    Int32;
    // flags, tags
    fFlags:                 TILItemFlags;
    fTextTag:               String;
    fNumTag:                Int32;
    // extended specs
    fWantedLevel:           UInt32;           // 0..7
    fVariant:               String;           // color, pattern, ...
    fMaterial:              TILItemMaterial;  // eg. pvc, silicone, ...
    fSizeX:                 UInt32;           // length (diameter if applicable)
    fSizeY:                 UInt32;           // width (inner diameter if applicable)
    fSizeZ:                 UInt32;           // height
    fUnitWeight:            UInt32;           // [g]
    fThickness:             UInt32;           // [um] - micrometers
    // some other stuff
    fNotes:                 String;
    fReviewURL:             String;
    fItemPictureFile:       String;
    fSecondaryPictureFile:  String;
    fPackagePictureFile:    String;
    fUnitPriceDefault:      UInt32;
    fRating:                UInt32;           // 0..100 [%]
    // availability and prices (calculated from shops)
    fUnitPriceLowest:       UInt32;
    fUnitPriceHighest:      UInt32;
    fUnitPriceSelected:     UInt32;
    fAvailableLowest:       Int32;            // negative value means "more than"
    fAvailableHighest:      Int32;
    fAvailableSelected:     Int32;
    // shops
    fShopCount:             Integer;
    fShops:                 array of TILItemShop;
    procedure SetStaticSettings(Value: TILStaticManagerSettings); virtual;
    procedure SetIndex(Value: Integer); virtual;
    // data getters and setters
    procedure SetItemPicture(Value: TBitmap); virtual;
    procedure SetSecondaryPicture(Value: TBitmap); virtual;
    procedure SetPackagePicture(Value: TBitmap); virtual;
    procedure SetItemType(Value: TILItemType); virtual;
    procedure SetItemTypeSpec(const Value: String); virtual;
    procedure SetPieces(Value: UInt32); virtual;
    procedure SetManufacturer(Value: TILItemManufacturer); virtual;
    procedure SetManufacturerStr(const Value: String); virtual;
    procedure SetTextID(const Value: String); virtual;
    procedure SetID(Value: Int32); virtual;
    procedure SetFlags(Value: TILItemFlags); virtual;
    procedure SetTextTag(const Value: String); virtual;
    procedure SetNumTag(Value: Int32); virtual;
    procedure SetWantedLevel(Value: UInt32); virtual;
    procedure SetVariant(const Value: String); virtual;
    procedure SetMaterial(Value: TILItemMaterial); virtual;
    procedure SetSizeX(Value: UInt32); virtual;
    procedure SetSizeY(Value: UInt32); virtual;
    procedure SetSizeZ(Value: UInt32); virtual;
    procedure SetUnitWeight(Value: UInt32); virtual;
    procedure SetThickness(Value: UInt32); virtual;
    procedure SetNotes(const Value: String); virtual;
    procedure SetReviewURL(const Value: String); virtual;
    procedure SetItemPictureFile(const Value: String); virtual;
    procedure SetSecondaryPictureFile(const Value: String); virtual;
    procedure SetPackagePictureFile(const Value: String); virtual;
    procedure SetUnitPriceDefault(Value: UInt32); virtual;
    procedure SetRating(Value: UInt32); virtual;
    Function GetShop(Index: Integer): TILItemShop; virtual;
    // list methods
    Function GetCapacity: Integer; override;
    procedure SetCapacity(Value: Integer); override;
    Function GetCount: Integer; override;
    procedure SetCount(Value: Integer); override;
    // handlers for item shop events
    procedure ShopClearSelectedHandler(Sender: TObject); virtual;
    procedure ShopUpdateOverviewHandler(Sender: TObject); virtual;
    procedure ShopUpdateShopListItemHandler(Sender: TObject); virtual;
    procedure ShopUpdateValuesHandler(Sender: TObject); virtual;
    procedure ShopUpdateAvailHistoryHandler(Sender: TObject); virtual;
    procedure ShopUpdatePriceHistoryHandler(Sender: TObject); virtual;
    // event callers
    procedure UpdateShopListItem(Index: Integer); virtual;
    procedure UpdateMainList; virtual;
    procedure UpdateSmallList; virtual;
    procedure UpdateOverview; virtual;
    procedure UpdateTitle; virtual;
    procedure UpdatePictures; virtual;
    procedure UpdateFlags; virtual;
    procedure UpdateValues; virtual;
    procedure UpdateShopList; virtual;
    // macro callers
    procedure UpdateShops; virtual; // when list shop is added or deleted
    // small pictures rendering
    procedure RenderSmallItemPicture; virtual; abstract;
    procedure RenderSmallSecondaryPicture; virtual; abstract;
    procedure RenderSmallPackagePicture; virtual; abstract;
    procedure RenderSmallPictures; virtual;
    // other protected methods
    procedure InitializeData; virtual;
    procedure FinalizeData; virtual;
    procedure Initialize; virtual;
    procedure Finalize; virtual;
  public
    constructor Create(DataProvider: TILDataProvider); overload;
    constructor Create; overload;
    constructor CreateAsCopy(DataProvider: TILDataProvider; Source: TILItem_Base; CopyPics: Boolean); overload;
    constructor CreateAsCopy(Source: TILItem_Base; CopyPics: Boolean); overload;
    destructor Destroy; override;
    procedure BeginUpdate; virtual;
    procedure EndUpdate; virtual;
    // shops
    Function LowIndex: Integer; override;
    Function HighIndex: Integer; override;
    Function ShopLowIndex: Integer; virtual;
    Function ShopHighIndex: Integer; virtual;
    Function ShopIndexOf(const Name: String): Integer; overload; virtual;
    Function ShopIndexOf(Shop: TILITemShop): Integer; overload; virtual;    
    Function ShopAdd: Integer; virtual;
    procedure ShopExchange(Idx1,Idx2: Integer); virtual;
    procedure ShopDelete(Index: Integer); virtual;
    procedure ShopClear; virtual;
    // data helpers
    procedure ResetTimeOfAddition; virtual;
    procedure SwapPictures(Src,Dst: TLIItemPictureKind); virtual;
    procedure BroadcastReqCount; virtual;    
    Function SetFlagValue(ItemFlag: TILItemFlag; NewValue: Boolean): Boolean; virtual;
    procedure GetPriceAndAvailFromShops; virtual;
    procedure FlagPriceAndAvail(OldPrice: UInt32; OldAvail: Int32); virtual;
    procedure GetAndFlagPriceAndAvail(OldPrice: UInt32; OldAvail: Int32); virtual;
    // other methods
    procedure AssignInternalEvents(
      ShopListItemUpdate:   TILIndexedObjectL1Event;
      ShopValuesUpdate,
      ShopAvailHistUpdate,
      ShopPriceHistUpdate:  TILObjectL1Event;
      MainListUpdate,
      SmallListUpdate,
      OverviewUpdate,
      TitleUpdate,
      PicturesUpdate,
      FlagsUpdate,
      ValuesUpdate,
      ShopListUpdate:       TNotifyEvent); virtual;
    procedure ClearInternalEvents; virtual;
    // properties
    property StaticSettings: TILStaticManagerSettings read fStaticSettings write SetStaticSettings;    
    property Index: Integer read fIndex write SetIndex;
    property Render: TBitmap read fRender;
    property RenderSmall: TBitmap read fRenderSmall;
    property FilteredOut: Boolean read fFilteredOut;
    // item data
    property UniqueID: TGUID read fUniqueID;
    property TimeOfAddition: TDateTime read fTimeOfAddition;
    property ItemPicture: TBitmap read fItemPicture write SetItemPicture;
    property SecondaryPicture: TBitmap read fSecondaryPicture write SetSecondaryPicture;
    property PackagePicture: TBitmap read fPackagePicture write SetPackagePicture;
    property ItemType: TILItemType read fItemType write SetItemType;
    property ItemTypeSpec: String read fItemTypeSpec write SetItemTypeSpec;
    property Pieces: UInt32 read fPieces write SetPieces;
    property Manufacturer: TILItemManufacturer read fManufacturer write SetManufacturer;
    property ManufacturerStr: String read fManufacturerStr write SetManufacturerStr;
    property ID: Int32 read fID write SetID;
    property TextID: String read fTextID write SetTextID;
    property Flags: TILItemFlags read fFlags write SetFlags;
    property TextTag: String read fTextTag write SetTextTag;
    property NumTag: Int32 read fNumTag write SetNumTag;
    property WantedLevel: UInt32 read fWantedLevel write SetWantedLevel;
    property Variant: String read fVariant write SetVariant;
    property Material: TILItemMaterial read fMaterial write SetMaterial;
    property SizeX: UInt32 read fSizeX write SetSizeX;
    property SizeY: UInt32 read fSizeY write SetSizeY;
    property SizeZ: UInt32 read fSizeZ write SetSizeZ;
    property UnitWeight: UInt32 read fUnitWeight write SetUnitWeight;
    property Thickness: UInt32 read fThickness write SetThickness;
    property Notes: String read fNotes write SetNotes;
    property ReviewURL: String read fReviewURL write SetReviewURL;
    property ItemPictureFile: String read fItemPictureFile write SetItemPictureFile;
    property SecondaryPictureFile: String read fSecondaryPictureFile write SetSecondaryPictureFile;
    property PackagePictureFile: String read fPackagePictureFile write SetPackagePictureFile;
    property UnitPriceDefault: UInt32 read fUnitPriceDefault write SetUnitPriceDefault;
    property Rating: UInt32 read fRating write SetRating;
    property UnitPriceLowest: UInt32 read fUnitPriceLowest;
    property UnitPriceHighest: UInt32 read fUnitPriceHighest;
    property UnitPriceSelected: UInt32 read fUnitPriceSelected;
    property AvailableLowest: Int32 read fAvailableLowest;
    property AvailableHighest: Int32 read fAvailableHighest;
    property AvailableSelected: Int32 read fAvailableSelected;
    property ShopCount: Integer read GetCount;
    property Shops[Index: Integer]: TILItemShop read GetShop; default;
  end;

implementation

uses
  SysUtils,
  InflatablesList_Utils;

procedure TILItem_Base.SetStaticSettings(Value: TILStaticManagerSettings);
var
  i:  Integer;
begin
fStaticSettings := IL_ThreadSafeCopy(Value);
For i := ShopLowIndex to ShopHighIndex do
  fShops[i].StaticSettings := fStaticSettings;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.SetIndex(Value: Integer);
begin
If fIndex <> Value then
  begin
    fIndex := Value;
  end;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.SetItemPicture(Value: TBitmap);
begin
If fItemPicture <> Value {a different object reference} then
  begin
    If Assigned(fItemPicture) then
      FreeAndNil(fItemPicture);
    fItemPicture := Value;
    RenderSmallItemPicture;
    UpdateMainList;
    UpdateSmallList;
    UpdatePictures;
  end;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.SetSecondaryPicture(Value: TBitmap);
begin
If fSecondaryPicture <> Value then
  begin
    If Assigned(fSecondaryPicture) then
      FreeAndNil(fSecondaryPicture);
    fSecondaryPicture := Value;
    RenderSmallSecondaryPicture;
    UpdateMainList;
    UpdatePictures;
  end;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.SetPackagePicture(Value: TBitmap);
begin
If fPackagePicture <> Value then
  begin
    If Assigned(fPackagePicture) then
      FreeAndNil(fPackagePicture);
    fPackagePicture := Value;
    RenderSmallPackagePicture;
    UpdateMainList;
    UpdatePictures;
  end;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.SetItemType(Value: TILItemType);
begin
If fItemType <> Value then
  begin
    fItemType := Value;
    UpdateMainList;
    UpdateSmallList;
    UpdateTitle;
  end;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.SetItemTypeSpec(const Value: String);
begin
If not IL_SameStr(fItemTypeSpec,Value) then
  begin
    fItemTypeSpec := Value;
    UniqueString(fItemTypeSpec);
    UpdateMainList;
    UpdateSmallList;
    UpdateTitle;
  end;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.SetPieces(Value: UInt32);
begin
If fPieces <> Value then
  begin
    fPieces := Value;
    BeginUpdate;
    try
      FlagPriceAndAvail(fUnitPriceSelected,fAvailableSelected);
      UpdateMainList;
      UpdateSmallList;
      UpdateOverview;      
      UpdateTitle;
      UpdateValues;
      // UpdteFlags is called in FlagPriceAndAvail only when needed
    finally
      EndUpdate;
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.SetManufacturer(Value: TILItemManufacturer);
begin
If fManufacturer <> Value then
  begin
    fManufacturer := Value;
    UpdateMainList;
    UpdateSmallList;
    UpdateTitle;
  end;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.SetManufacturerStr(const Value: String);
begin
If not IL_SameStr(fManufacturerStr,Value) then
  begin
    fManufacturerStr := Value;
    UniqueString(fManufacturerStr);
    UpdateMainList;
    UpdateSmallList;
    UpdateTitle;
  end;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.SetTextID(const Value: String);
begin
If not IL_SameStr(fTextID,Value) then
  begin
    fTextID := Value;
    UniqueString(fTextID);
    UpdateMainList;
    UpdateSmallList;
    UpdateTitle;
  end;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.SetID(Value: Int32);
begin
If fID <> Value then
  begin
    fID := Value;
    UpdateMainList;
    UpdateSmallList;
    UpdateTitle;
  end;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.SetFlags(Value: TILItemFlags);
begin
If fFlags <> Value then
  begin
    fFlags := Value;
    BeginUpdate;
    try
      FlagPriceAndAvail(fUnitPriceSelected,fAvailableSelected);
      UpdateMainList;
      // UpdteFlags is called in FlagPriceAndAvail only when needed
    finally
      EndUpdate;
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.SetTextTag(const Value: String);
begin
If not IL_SameStr(fTextTag,Value) then
  begin
    fTextTag := Value;
    UniqueString(fTextTag);
    UpdateMainList;
    UpdateSmallList;
  end;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.SetNumTag(Value: Int32);
begin
If fNumTag <> Value then
  begin
    fNumTag := Value;
    UpdateMainList;
    UpdateSmallList;
  end;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.SetWantedLevel(Value: UInt32);
begin
If fWantedLevel <> Value then
  begin
    fWantedLevel := Value;
    UpdateMainList;
  end;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.SetVariant(const Value: String);
begin
If not IL_SameStr(fVariant,Value) then
  begin
    fVariant := Value;
    UniqueString(fVariant);
    UpdateMainList;
    UpdateSmallList;
  end;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.SetMaterial(Value: TILItemMaterial);
begin
If fMaterial <> Value then
  begin
    fMaterial := Value;
  end;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.SetSizeX(Value: UInt32);
begin
If fSizeX <> Value then
  begin
    fSizeX := Value;
    UpdateMainList;
    UpdateSmallList;
  end;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.SetSizeY(Value: UInt32);
begin
If fSizeY <> Value then
  begin
    fSizeY := Value;
    UpdateMainList;
    UpdateSmallList;
  end;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.SetSizeZ(Value: UInt32);
begin
If fSizeZ <> Value then
  begin
    fSizeZ := Value;
    UpdateMainList;
    UpdateSmallList;
  end;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.SetUnitWeight(Value: UInt32);
begin
If fUnitWeight <> Value then
  begin
    fUnitWeight := Value;
    UpdateValues;
  end;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.SetThickness(Value: UInt32);
begin
If fThickness <> Value then
  begin
    fThickness := Value;
  end;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.SetNotes(const Value: String);
begin
If not IL_SameStr(fNotes,Value) then
  begin
    fNotes := Value;
    UniqueString(fNotes);
  end;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.SetReviewURL(const Value: String);
begin
If not IL_SameStr(fReviewURL,Value) then
  begin
    fReviewURL := Value;
    UniqueString(fReviewURL);
    UpdateMainList;
  end;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.SetItemPictureFile(const Value: String);
begin
If not IL_SameStr(fItemPictureFile,Value) then
  begin
    fItemPictureFile := Value;
    UniqueString(fItemPictureFile);
    UpdateMainList;
  end;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.SetSecondaryPictureFile(const Value: String);
begin
If not IL_SameStr(fSecondaryPictureFile,Value) then
  begin
    fSecondaryPictureFile := Value;
    UniqueString(fSecondaryPictureFile);
    UpdateMainList;
  end;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.SetPackagePictureFile(const Value: String);
begin
If not IL_SameStr(fPackagePictureFile,Value) then
  begin
    fPackagePictureFile := Value;
    UniqueString(fPackagePictureFile);
    UpdateMainList;
  end;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.SetUnitPriceDefault(Value: UInt32);
begin
If fUnitPriceDefault <> Value then
  begin
    fUnitPriceDefault := Value;
    UpdateMainList;
    UpdateSmallList;
    UpdateOverview;
    UpdateValues;
  end;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.SetRating(Value: UInt32);
begin
If fRating <> Value then
  begin
    fRating := Value;
    UpdateMainList;
  end;
end;

//------------------------------------------------------------------------------

Function TILItem_Base.GetShop(Index: Integer): TILItemShop;
begin
If CheckIndex(Index) then
  Result := fShops[Index]
else
  raise Exception.CreateFmt('TILItem_Base.GetShop: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

Function TILItem_Base.GetCapacity: Integer;
begin
Result := Length(fShops);
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.SetCapacity(Value: Integer);
var
  i:  Integer;
begin
If Value < fShopCount then
  begin
    For i := Value to Pred(fShopCount) do
      fShops[i].Free;
    fShopCount := Value;  
  end;
SetLength(fShops,Value);
end;

//------------------------------------------------------------------------------

Function TILItem_Base.GetCount: Integer;
begin
Result := fShopCount;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.SetCount(Value: Integer);
begin
// do nothing
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.ShopClearSelectedHandler(Sender: TObject);
var
  Index,i:  Integer;
begin
If Sender is TILItemShop then
  begin
    Index := ShopIndexOf(TILItemShop(Sender));
    If CheckIndex(Index) then
      For i := ShopLowIndex to ShopHighIndex do
        If i <> Index then
          fShops[i].Selected := False
  end;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.ShopUpdateOverviewHandler(Sender: TObject);
begin
UpdateOverview;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.ShopUpdateShopListItemHandler(Sender: TObject);
var
  Index:  Integer;
begin
If Sender is TILItemShop then
  begin
    Index := ShopIndexOf(TILItemShop(Sender));
    If CheckIndex(Index) then
      UpdateShopListItem(Index);
  end;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.ShopUpdateValuesHandler(Sender: TObject);
begin
If Assigned(fOnShopValuesUpdate) and (Sender is TILItemShop) then
  begin
    GetAndFlagPriceAndAvail(fUnitPriceSelected,fAvailableSelected);  
    fOnShopValuesUpdate(Self,Sender);
  end;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.ShopUpdateAvailHistoryHandler(Sender: TObject);
begin
If Assigned(fOnShopAvailHistoryUpd) and (Sender is TILItemShop) then
  fOnShopAvailHistoryUpd(Self,Sender);
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.ShopUpdatePriceHistoryHandler(Sender: TObject);
begin
If Assigned(fOnShopPriceHistoryUpd) and (Sender is TILItemShop) then
  fOnShopPriceHistoryUpd(Self,Sender);
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.UpdateShopListItem(Index: Integer);
begin
If Assigned(fOnShopListItemUpdate) and CheckIndex(Index) then
  fOnShopListItemUpdate(Self,fShops[Index],Index);
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.UpdateMainList;
begin
If Assigned(fOnMainListUpdate) and (fUpdateCounter <= 0) then
  fOnMainListUpdate(Self);
Include(fUpdated,iliufMainList);
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.UpdateSmallList;
begin
If Assigned(fOnSmallListUpdate) and (fUpdateCounter <= 0) then
  fOnSmallListUpdate(Self);
Include(fUpdated,iliufSmallList);
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.UpdateOverview;
begin
If Assigned(fOnOverviewUpdate) and (fUpdateCounter <= 0) then
  fOnOverviewUpdate(Self);
Include(fUpdated,iliufOverview);
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.UpdateTitle;
begin
If Assigned(fOnTitleUpdate) and (fUpdateCounter <= 0) then
  fOnTitleUpdate(Self);
Include(fUpdated,iliufTitle);
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.UpdatePictures;
begin
If Assigned(fOnPicturesUpdate) and (fUpdateCounter <= 0) then
  fOnPicturesUpdate(Self);
Include(fUpdated,iliufPictures);
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.UpdateFlags;
begin
If Assigned(fOnFlagsUpdate) and (fUpdateCounter <= 0) then
  fOnFlagsUpdate(Self);
Include(fUpdated,iliufFlags);
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.UpdateValues;
begin
If Assigned(fOnValuesUpdate) and (fUpdateCounter <= 0) then
  fOnValuesUpdate(Self);
Include(fUpdated,iliufValues);
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.UpdateShopList;
begin
If Assigned(fOnShopListUpdate) and (fUpdateCounter <= 0) then
  fOnShopListUpdate(Self);
Include(fUpdated,iliufShopList);
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.UpdateShops;
begin
GetAndFlagPriceAndAvail(fUnitPriceSelected,fAvailableSelected);
UpdateMainList;   // there can be shop count shown
UpdateSmallList;  // well...
UpdateOverview;   // -//-
UpdateValues;     // shop count is shown there
UpdateShopList;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.RenderSmallPictures;
begin
RenderSmallItemPicture;
RenderSmallSecondaryPicture;
RenderSmallPackagePicture;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.InitializeData;
begin
CreateGUID(fUniqueID);
fTimeOfAddition := Now;
// basic specs
fItemPicture := nil;
fSecondaryPicture := nil;
fPackagePicture := nil;
fItemPictureSmall := nil;
fSecondaryPictureSmall := nil;
fPackagePictureSmall := nil;
fItemType := ilitUnknown;
fItemTypeSpec := '';
fPieces := 1;
fManufacturer := ilimOthers;
fManufacturerStr := '';
fTextID := '';
fID := 0;
// flags
fFlags := [];
fTextTag := '';
fNumTag := 0;
// ext. specs
fWantedLevel := 0;
fVariant := '';
fMaterial := ilimtUnknown;
fSizeX := 0;
fSizeY := 0;
fSizeZ := 0;
fUnitWeight := 0;
fThickness := 0;
// other info
fNotes := '';
fReviewURL := '';
fItemPictureFile := '';
fPackagePictureFile := '';
fUnitPriceDefault := 0;
fRating := 0;
fUnitPriceLowest := 0;
fUnitPriceHighest := 0;
fUnitPriceSelected := 0;
fAvailableLowest := 0;
fAvailableHighest := 0;
fAvailableSelected := 0;
// shops
fShopCount := 0;
SetLength(fShops,0);
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.FinalizeData;
var
  i:  Integer;
begin
If Assigned(fItemPicture) then
  FreeAndNil(fItemPicture);
If Assigned(fSecondaryPicture) then
  FreeAndNil(fSecondaryPicture);
If Assigned(fPackagePicture) then
  FreeAndNil(fPackagePicture);
If Assigned(fItemPictureSmall) then
  FreeAndNil(fItemPictureSmall);
If Assigned(fSecondaryPictureSmall) then
  FreeAndNil(fSecondaryPictureSmall);
If Assigned(fPackagePictureSmall) then
  FreeAndNil(fPackagePictureSmall);
// remove shops  
For i := LowIndex to HighIndex do
  fShops[i].Free;
fShopCount := 0;
SetLength(fShops,0);
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.Initialize;
begin
FillChar(fStaticSettings,SizeOf(TILStaticManagerSettings),0);
fIndex := -1;
fRender := TBitmap.Create;
fRender.PixelFormat := pf24bit;
fRenderSmall := TBitmap.Create;
fRenderSmall.PixelFormat := pf24bit;
fFilteredOut := False;
fUpdateCounter := 0;
fUpdated := [];
InitializeData;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.Finalize;
begin
FinalizeData;
If Assigned(fRenderSmall) then
  FreeAndNil(fRenderSmall);
If Assigned(fRender) then
  FreeAndNil(fRender);
end;

//==============================================================================

constructor TILItem_Base.Create(DataProvider: TILDataProvider);
begin
inherited Create;
fDataProvider := DataProvider;
fOwnsDataProvider := False;
Initialize;
end;

//------------------------------------------------------------------------------

constructor TILItem_Base.Create;
begin
Create(TILDataProvider.Create);
fOwnsDataProvider := True;
end;

//------------------------------------------------------------------------------

constructor TILItem_Base.CreateAsCopy(DataProvider: TILDataProvider; Source: TILItem_Base; CopyPics: Boolean);
var
  i:  Integer;
begin
Create(DataProvider);
fStaticSettings := IL_ThreadSafeCopy(Source.StaticSettings);
// do not copy time of addition and UID
If CopyPics then
  begin
    If Assigned(Source.ItemPicture) then
      begin
        fItemPicture := TBitmap.Create;
        fItemPicture.Assign(Source.ItemPicture);
      end;
    If Assigned(Source.SecondaryPicture) then
      begin
        fSecondaryPicture := TBitmap.Create;
        fSecondaryPicture.Assign(Source.SecondaryPicture);
      end;
    If Assigned(Source.PackagePicture) then
      begin
        fPackagePicture := TBitmap.Create;
        fPackagePicture.Assign(Source.PackagePicture);
      end;
    RenderSmallPictures;
    If Assigned(Source.Render) then
      fRender.Assign(Source.Render);
    If Assigned(Source.RenderSmall) then
      fRenderSmall.Assign(Source.RenderSmall);
  end;
fItemType := Source.ItemType;
fItemTypeSpec := Source.ItemTypeSpec;
UniqueString(fItemTypeSpec);
fPieces := Source.Pieces;
fManufacturer := Source.Manufacturer;
fManufacturerStr := Source.ManufacturerStr;
UniqueString(fManufacturerStr);
fTextID := Source.TextID;
UniqueString(fTextID);
fID := Source.ID;
fFlags := Source.Flags;
fTextTag := Source.TextTag;
UniqueString(fTextTag);
fNumTag := Source.NumTag;
fWantedLevel := Source.WantedLevel;
fVariant := Source.Variant;
UniqueString(fVariant);
fMaterial := Source.Material;
fSizeX := Source.SizeX;
fSizeY := Source.SizeY;
fSizeZ := Source.SizeZ;
fUnitWeight := Source.UnitWeight;
fThickness := Source.Thickness;
fNotes := Source.Notes;
UniqueString(fNotes);
fReviewURL := Source.ReviewURL;
UniqueString(fReviewURL);
fItemPictureFile := Source.ItemPictureFile;
UniqueString(fItemPictureFile);
fSecondaryPictureFile := Source.SecondaryPictureFile;
UniqueString(fSecondaryPictureFile);
fPackagePictureFile := Source.PackagePictureFile;
UniqueString(fPackagePictureFile);
fUnitPriceDefault := Source.UnitPriceDefault;
fRating := Source.Rating;
fUnitPriceLowest := Source.UnitPriceLowest;
fUnitPriceHighest := Source.UnitPriceHighest;
fUnitPriceSelected := Source.UnitPriceSelected;
fAvailableLowest := Source.AvailableLowest;
fAvailableHighest := Source.AvailableHighest;
fAvailableSelected := Source.AvailableSelected;
// copy shops
SetLength(fShops,Source.ShopCount);
fShopCount := Source.ShopCount;
For i := Low(fShops) to High(fShops) do
  begin
    fShops[i] := TILItemShop.CreateAsCopy(Source[i]);
    fShops[i].StaticSettings := fStaticSettings;
    fShops[i].RequiredCount := fPieces;
    fShops[i].AssignInternalEvents(
      ShopClearSelectedHandler,
      ShopUpdateOverviewHandler,
      ShopUpdateShopListItemHandler,
      ShopUpdateValuesHandler,
      ShopUpdateAvailHistoryHandler,
      ShopUpdatePriceHistoryHandler);
  end;
end;

//------------------------------------------------------------------------------

constructor TILItem_Base.CreateAsCopy(Source: TILItem_Base; CopyPics: Boolean);
begin
CreateAsCopy(TILDataProvider.Create,Source,CopyPics);
fOwnsDataProvider := True;
end;

//------------------------------------------------------------------------------

destructor TILItem_Base.Destroy;
begin
Finalize;
If fOwnsDataProvider then
  FreeAndNil(fDataProvider);
inherited;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.BeginUpdate;
begin
If fUpdateCounter <= 0 then
  fUpdated := [];
Inc(fUpdateCounter);
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.EndUpdate;
begin
Dec(fUpdateCounter);
If fUpdateCounter <= 0 then
  begin
    fUpdateCounter := 0;
    If iliufMainList in fUpdated then
      UpdateMainList;
    If iliufSmallList in fUpdated then
      UpdateSmallList;
    If iliufOverview in fUpdated then
      UpdateOverview;
    If iliufTitle in fUpdated then
      UpdateTitle;
    If iliufPictures in fUpdated then
      UpdatePictures;
    If iliufFlags in fUpdated then
      UpdateFlags;
    If iliufValues in fUpdated then
      UpdateValues;
    If iliufShopList in fUpdated then
      UpdateShopList;
    fUpdated := [];
  end;
end;

//------------------------------------------------------------------------------

Function TILItem_Base.LowIndex: Integer;
begin
Result := Low(fShops);
end;

//------------------------------------------------------------------------------

Function TILItem_Base.HighIndex: Integer;
begin
Result := Pred(fShopCount);
end;

//------------------------------------------------------------------------------

Function TILItem_Base.ShopLowIndex: Integer;
begin
Result := LowIndex;
end;
 
//------------------------------------------------------------------------------

Function TILItem_Base.ShopHighIndex: Integer;
begin
Result := HighIndex;
end;
 
//------------------------------------------------------------------------------

Function TILItem_Base.ShopIndexOf(const Name: String): Integer;
var
  i:  Integer;
begin
Result := -1;
For i := ShopLowIndex to ShopHighIndex do
  If IL_SameText(fShops[i].Name,Name) then
    begin
      Result := i;
      Break{For i};
    end;
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

Function TILItem_Base.ShopIndexOf(Shop: TILItemShop): Integer;
var
  i:  Integer;
begin
Result := -1;
For i := ShopLowIndex to ShopHighIndex do
  If fShops[i] = Shop then
    begin
      Result := i;
      Break{For i};
    end;
end;

//------------------------------------------------------------------------------

Function TILItem_Base.ShopAdd: Integer;
begin
Grow;
Result := fShopCount;
fShops[Result] := TILItemShop.Create;
fShops[Result].StaticSettings := fStaticSettings;
fShops[Result].RequiredCount := fPieces;
fShops[Result].AssignInternalEvents(
  ShopClearSelectedHandler,
  ShopUpdateOverviewHandler,
  ShopUpdateShopListItemHandler,
  ShopUpdateValuesHandler,
  ShopUpdateAvailHistoryHandler,
  ShopUpdatePriceHistoryHandler);
Inc(fShopCount);
UpdateShops;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.ShopExchange(Idx1,Idx2: Integer);
var
  Temp: TILItemShop;
begin
If Idx1 <> Idx2 then
  begin
    // sanity checks
    If not CheckIndex(Idx1) then
      raise Exception.CreateFmt('TILItem_Base.ShopExchange: Index 1 (%d) out of bounds.',[Idx1]);
    If not CheckIndex(Idx2) then
      raise Exception.CreateFmt('TILItem_Base.ShopExchange: Index 2 (%d) out of bounds.',[Idx1]);
    Temp := fShops[Idx1];
    fShops[Idx1] := fShops[Idx2];
    fShops[Idx2] := Temp;
    UpdateShopListItem(Idx1);
    UpdateShopListItem(Idx2);
  end;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.ShopDelete(Index: Integer);
var
  i:  Integer;
begin
If CheckIndex(Index) then
  begin
    FreeAndNil(fShops[Index]);
    For i := Index to Pred(ShopHighIndex) do
      fShops[i] := fShops[i + 1];
    Dec(fShopCount);
    Shrink;
    UpdateShops;
  end
else raise Exception.CreateFmt('TILItem_Base.ShopDelete: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.ShopClear;
var
  i:  Integer;
begin
For i := ShopLowIndex to ShopHighIndex do
  FreeAndNil(fShops[i]);
SetLength(fShops,0);
fShopCount := 0;
UpdateShops;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.ResetTimeOfAddition;
begin
fTimeOfAddition := Now;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.SwapPictures(Src,Dst: TLIItemPictureKind);
type
  PBitmap = ^TBitmap;
var
  SrcBmpPtr:  PBitmap;
  DstBmpPtr:  PBitmap;
  BmpTemp:    TBitmap;
  SrcStrPtr:  PString;
  DstStrPtr:  PString;
  StrTemp:    String;
begin
If (Src <> Dst) and (Src <> ilipkUnknown) and (Dst <> ilipkUnknown) then
  begin
    case Src of
      ilipkMain:      begin
                        SrcBmpPtr := @fItemPicture;
                        SrcStrPtr := @fItemPictureFile;
                      end;
      ilipkSecondary: begin
                        SrcBmpPtr := @fSecondaryPicture;
                        SrcStrPtr := @fSecondaryPictureFile;
                      end;
      ilipkPackage:   begin
                        SrcBmpPtr := @fPackagePicture;
                        SrcStrPtr := @fPackagePictureFile;
                      end;  
    else
      raise Exception.CreateFmt('Invalid source picture kind (%d).',[Ord(Src)]);
    end;
    case Dst of
      ilipkMain:      begin
                        DstBmpPtr := @fItemPicture;
                        DstStrPtr := @fItemPictureFile;
                      end;
      ilipkSecondary: begin
                        DstBmpPtr := @fSecondaryPicture;
                        DstStrPtr := @fSecondaryPictureFile;
                      end;
      ilipkPackage:   begin
                        DstBmpPtr := @fPackagePicture;
                        DstStrPtr := @fPackagePictureFile;
                      end;
    else
      raise Exception.CreateFmt('Invalid destination picture kind (%d).',[Ord(Dst)]);
    end;
    // switch picture bitmaps
    BmpTemp := DstBmpPtr^;
    DstBmpPtr^ := SrcBmpPtr^;
    SrcBmpPtr^ := BmpTemp;
    RenderSmallPictures;
    // switch picture files
    StrTemp := DstStrPtr^;
    DstStrPtr^ := SrcStrPtr^;
    SrcStrPtr^ := StrTemp;
    UpdateMainList;
    UpdateSmallList;
    UpdatePictures;
  end;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.BroadcastReqCount;
var
  i:  Integer;
begin
For i := ShopLowIndex to ShopHighIndex do
  fShops[i].RequiredCount := fPieces;
end;

//------------------------------------------------------------------------------

Function TILItem_Base.SetFlagValue(ItemFlag: TILItemFlag; NewValue: Boolean): Boolean;
begin
BeginUpdate;
try
  Result := IL_SetItemFlagValue(fFlags,ItemFlag,NewValue);
  If (ItemFlag = ilifWanted) and (Result <> NewValue) then
    FlagPriceAndAvail(fUnitPriceSelected,fAvailableSelected);
  If Result <> NewValue then
    UpdateMainList;
finally
  EndUpdate;
end;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.GetPriceAndAvailFromShops;
var
  i:          Integer;
  Selected:   Boolean;
  LowPrice:   Int64;
  HighPrice:  Int64;
  LowAvail:   Int64;
  HighAvail:  Int64;

  Function AvailIsLess(A,B: Int32): Boolean;
  begin
    If Abs(A) = Abs(B) then
      Result := B > 0
    else
      Result := Abs(A) < Abs(B);
  end;

  Function AvailIsMore(A,B: Int32): Boolean;
  begin
    If Abs(A) = Abs(B) then
      Result := A < 0
    else
      Result := Abs(A) > Abs(B);
  end;

begin
// first make sure only one shop is selected
Selected := False;
For i := ShopLowIndex to ShopHighIndex do
  If fShops[i].Selected and not Selected then
    Selected := True
  else
    fShops[i].Selected := False;
// get price and avail extremes (availability must be non-zero) and selected
LowPrice := 0;
HighPrice := 0;
LowAvail := 0;
HighAvail := 0;
fUnitPriceSelected := 0;
fAvailableSelected := 0;
For i := ShopLowIndex to ShopHighIndex do
  begin
    If (fShops[i].Available <> 0) and (fShops[i].Price > 0) then
      begin
        If (fShops[i].Price < LowPrice) or (LowPrice <= 0) then
          LowPrice := fShops[i].Price;
        If (fShops[i].Price > HighPrice) or (HighPrice <= 0) then
          HighPrice := fShops[i].Price;
        If AvailIsLess(fShops[i].Available,LowAvail) or (LowAvail <= 0) then
          LowAvail := fShops[i].Available;
        If AvailIsMore(fShops[i].Available,HighAvail) or (HighAvail <= 0) then
          HighAvail := fShops[i].Available;
      end;
    If fShops[i].Selected then
      begin
        fUnitPriceSelected := fShops[i].Price;
        fAvailableSelected := fShops[i].Available;
      end;
  end;
fUnitPriceLowest := LowPrice;
fUnitPriceHighest := HighPrice;
fAvailableLowest := LowAvail;
fAvailableHighest := HighAvail;
UpdateMainList;
UpdateSmallList;
UpdateOverview;
UpdateValues;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.FlagPriceAndAvail(OldPrice: UInt32; OldAvail: Int32);
begin
If (ilifWanted in fFlags) and (fShopCount > 0) then
  begin
    Exclude(fFlags,ilifNotAvailable);
    If (fAvailableSelected <> 0) and (fUnitPriceSelected > 0) then
      begin
        If fAvailableSelected > 0 then
          begin
            If UInt32(fAvailableSelected) < fPieces then
              Include(fFlags,ilifNotAvailable);
          end
        else
          begin
            If UInt32(Abs(fAvailableSelected) * 2) < fPieces then
              Include(fFlags,ilifNotAvailable);
          end;
        If fAvailableSelected <> OldAvail then
          Include(fFlags,ilifAvailChange);
        If fUnitPriceSelected <> OldPrice then
          Include(fFlags,ilifPriceChange);
      end
    else
      begin
        Include(fFlags,ilifNotAvailable);
        If (fAvailableSelected <> OldAvail) then
          Include(fFlags,ilifAvailChange);
      end;
    UpdateMainList;
    UpdateFlags;
  end;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.GetAndFlagPriceAndAvail(OldPrice: UInt32; OldAvail: Int32);
begin
BeginUpdate;
try
  GetPriceAndAvailFromShops;
  FlagPriceAndAvail(OldPrice,OldAvail);
finally
  EndUpdate;
end;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.AssignInternalEvents(ShopListItemUpdate: TILIndexedObjectL1Event;
  ShopValuesUpdate,ShopAvailHistUpdate,ShopPriceHistUpdate: TILObjectL1Event;
  MainListUpdate,SmallListUpdate,OverviewUpdate,TitleUpdate,PicturesUpdate,
  FlagsUpdate,ValuesUpdate,ShopListUpdate: TNotifyEvent);
begin
fOnShopListItemUpdate := IL_CheckHandler(ShopListItemUpdate);
fOnShopValuesUpdate := IL_CheckHandler(ShopValuesUpdate);
fOnShopAvailHistoryUpd := IL_CheckHandler(ShopAvailHistUpdate);
fOnShopPriceHistoryUpd := IL_CheckHandler(ShopPriceHistUpdate);
fOnMainListUpdate := IL_CheckHandler(MainListUpdate);
fOnSmallListUpdate := IL_CheckHandler(SmallListUpdate);
fOnOverviewUpdate := IL_CheckHandler(OverviewUpdate);
fOnTitleUpdate := IL_CheckHandler(TitleUpdate);
fOnPicturesUpdate := IL_CheckHandler(PicturesUpdate);
fOnFlagsUpdate := IL_CheckHandler(FlagsUpdate);
fOnValuesUpdate := IL_CheckHandler(ValuesUpdate);
fOnShopListUpdate := IL_CheckHandler(ShopListUpdate);
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.ClearInternalEvents;
begin
fOnShopListItemUpdate := nil;
fOnShopValuesUpdate := nil;
fOnShopAvailHistoryUpd := nil;
fOnShopPriceHistoryUpd := nil;
fOnMainListUpdate := nil;
fOnSmallListUpdate := nil;
fOnOverviewUpdate := nil;
fOnTitleUpdate := nil;
fOnPicturesUpdate := nil;
fOnFlagsUpdate := nil;
fOnValuesUpdate := nil;
fOnShopListUpdate := nil;
end;

end.
