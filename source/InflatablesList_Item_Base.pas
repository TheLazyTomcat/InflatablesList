unit InflatablesList_Item_Base;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  Graphics,
  AuxTypes, AuxClasses,
  InflatablesList_Types,
  InflatablesList_Data,
  InflatablesList_ItemShop;

type
  TILItemUpdatedFlag = (iliufMainList,iliufSmallList,iliufOverview,iliufTitle,
                        iliufPictures,iliufShopList);

  TILItemUpdatedFlags = set of TILItemUpdatedFlag;

  TILItem_Base = class(TCustomListObject)
  protected
    fDataProvider:          TILDataProvider;
    fOwnsDataProvider:      Boolean;
    fIndex:                 Integer;  // used in sorting
    fRender:                TBitmap;
    fRenderSmall:           TBitmap;
    fFilteredOut:           Boolean;
    fUpdateCounter:         Integer;
    fUpdated:               TILItemUpdatedFlags;
    fStaticOptions:         TILStaticManagerOptions;
    // events
    fOnMainListUpdate:      TNotifyEvent;   // internal
    fOnSmallListUpdate:     TNotifyEvent;   // internal
    fOnOverviewUpdate:      TNotifyEvent;   // internal
    fOnTitleUpdate:         TNotifyEvent;
    fOnPicturesUpdate:      TNotifyEvent;
    fOnShopListUpdate:      TNotifyEvent;
    fOnShopListItemUpdate:  TIntegerEvent;  // forwarded from item shop
    fOnShopValuesUpdate:    TIntegerEvent;  // forwarded from item shop
    fOnShopAvailHistoryUpd: TIntegerEvent;  // forwarded from item shop
    fOnShopPriceHistoryUpd: TIntegerEvent;  // forwarded from item shop
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
    fAvailableLowest:       Int32;    // negative value means "more than"
    fAvailableHighest:      Int32;
    fAvailableSelected:     Int32;
    // shops
    fShopCount:             Integer;
    fShops:                 array of TILItemShop;
    procedure SetStaticOptions(Value: TILStaticManagerOptions); virtual;
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
    // other protected methods
    Function GetCapacity: Integer; override;
    procedure SetCapacity(Value: Integer); override;
    Function GetCount: Integer; override;
    procedure SetCount(Value: Integer); override;
    procedure InitializeData; virtual;
    procedure FinalizeData; virtual;
    procedure Initialize; virtual;
    procedure Finalize; virtual;
    // small pictures rendering
    procedure RenderSmallItemPicture; virtual; abstract;
    procedure RenderSmallSecondaryPicture; virtual; abstract;
    procedure RenderSmallPackagePicture; virtual; abstract;
    procedure RenderSmallPictures; virtual;
    // handlers for item shop events
    procedure ClearSelectedHandler(Sender: TObject); virtual;
    procedure UpdateOverviewHandler(Sender: TObject); virtual;
    procedure UpdateShopListItemHandler(Sender: TObject); virtual;
    procedure UpdateShopValuesHandler(Sender: TObject); virtual;
    procedure UpdateShopAvailHistoryHandler(Sender: TObject); virtual;
    procedure UpdateShopPriceHistoryHandler(Sender: TObject); virtual;
    // event callers
    procedure UpdateMainList; virtual;
    procedure UpdateSmallList; virtual;
    procedure UpdateOverview; virtual;
    procedure UpdateTitle; virtual;
    procedure UpdatePictures; virtual;
    procedure UpdateShopList; virtual;
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
    procedure SwitchPictures(Src,Dst: TLIItemPictureKind); virtual;
    Function SetFlagValue(ItemFlag: TILItemFlag; NewValue: Boolean): Boolean; virtual;
    procedure BroadcastReqCount; virtual;
    procedure Release(FullRelease: Boolean); virtual;
    // properties
    property Index: Integer read fIndex write fIndex;
    property Render: TBitmap read fRender;
    property RenderSmall: TBitmap read fRenderSmall;
    property FilteredOut: Boolean read fFilteredOut;
    property StaticOptions: TILStaticManagerOptions read fStaticOptions write SetStaticOptions;
    // events
    property OnMainListUpdate: TNotifyEvent read fOnMainListUpdate write fOnMainListUpdate;
    property OnSmallListUpdate: TNotifyEvent read fOnSmallListUpdate write fOnSmallListUpdate;
    property OnOverviewListUpdate: TNotifyEvent read fOnOverviewUpdate write fOnOverviewUpdate;
    property OnTitleUpdate: TNotifyEvent read fOnTitleUpdate write fOnTitleUpdate;
    property OnPicturesUpdate: TNotifyEvent read fOnPicturesUpdate write fOnPicturesUpdate;
    property OnShopListUpdate: TNotifyEvent read fOnShopListUpdate write fOnShopListUpdate;
    property OnShopListItemUpdate: TIntegerEvent read fOnShopListItemUpdate write fOnShopListItemUpdate;
    property OnShopValuesUpdate: TIntegerEvent read fOnShopValuesUpdate write fOnShopValuesUpdate;
    property OnShopAvailHistoryUpdate: TIntegerEvent read fOnShopAvailHistoryUpd write fOnShopAvailHistoryUpd;
    property OnShopPriceHistoryUpdate: TIntegerEvent read fOnShopPriceHistoryUpd write fOnShopPriceHistoryUpd;
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
  SysUtils;

procedure TILItem_Base.SetStaticOptions(Value: TILStaticManagerOptions);
begin
fStaticOptions := IL_ThreadSafeCopy(Value);
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
If not AnsiSameStr(fItemTypeSpec,Value) then
  begin
    fItemTypeSpec := Value;
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
    UpdateMainList;
    UpdateSmallList;
    UpdateOverview;
    UpdateTitle;
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
If not AnsiSameStr(fManufacturerStr,Value) then
  begin
    fManufacturerStr := Value;
    UpdateMainList;
    UpdateSmallList;
    UpdateTitle;
  end;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.SetTextID(const Value: String);
begin
If not AnsiSameStr(fTextID,Value) then
  begin
    fTextID := Value;
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
    UpdateMainList;
  end;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.SetTextTag(const Value: String);
begin
If not AnsiSameStr(fTextTag,Value) then
  begin
    fTextTag := Value;
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
If not AnsiSameStr(fVariant,Value) then
  begin
    fVariant := Value;
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
If not AnsiSameStr(fNotes,Value) then
  begin
    fNotes := Value;
  end;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.SetReviewURL(const Value: String);
begin
If not AnsiSameStr(fReviewURL,Value) then
  begin
    fReviewURL := Value;
    UpdateMainList;
  end;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.SetItemPictureFile(const Value: String);
begin
If not AnsiSameStr(fItemPictureFile,Value) then
  begin
    fItemPictureFile := Value;
  end;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.SetSecondaryPictureFile(const Value: String);
begin
If not AnsiSameStr(fSecondaryPictureFile,Value) then
  begin
    fSecondaryPictureFile := Value;
  end;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.SetPackagePictureFile(const Value: String);
begin
If not AnsiSameStr(fPackagePictureFile,Value) then
  begin
    fPackagePictureFile := Value;
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

//==============================================================================

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
  For i := Value to Pred(fShopCount) do
    fShops[i].Free;
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

//------------------------------------------------------------------------------

procedure TILItem_Base.RenderSmallPictures;
begin
RenderSmallItemPicture;
RenderSmallSecondaryPicture;
RenderSmallPackagePicture;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.ClearSelectedHandler(Sender: TObject);
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

procedure TILItem_Base.UpdateOverviewHandler(Sender: TObject);
begin
UpdateOverview;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.UpdateShopListItemHandler(Sender: TObject);
var
  Index:  Integer;
begin
If Assigned(fOnShopListItemUpdate) and (Sender is TILItemShop) then
  begin
    Index := ShopIndexOf(TILItemShop(Sender));
    If CheckIndex(Index) then
      fOnShopListItemUpdate(Self,Index);
  end;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.UpdateShopValuesHandler(Sender: TObject);
var
  Index:  Integer;
begin
If Assigned(fOnShopValuesUpdate) and (Sender is TILItemShop) then
  begin
    Index := ShopIndexOf(TILItemShop(Sender));
    If CheckIndex(Index) then
      fOnShopValuesUpdate(Self,Index);
  end;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.UpdateShopAvailHistoryHandler(Sender: TObject);
var
  Index:  Integer;
begin
If Assigned(fOnShopAvailHistoryUpd) and (Sender is TILItemShop) then
  begin
    Index := ShopIndexOf(TILItemShop(Sender));
    If CheckIndex(Index) then
      fOnShopAvailHistoryUpd(Self,Index);
  end;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.UpdateShopPriceHistoryHandler(Sender: TObject);
var
  Index:  Integer;
begin
If Assigned(fOnShopPriceHistoryUpd) and (Sender is TILItemShop) then
  begin
    Index := ShopIndexOf(TILItemShop(Sender));
    If CheckIndex(Index) then
      fOnShopPriceHistoryUpd(Self,Index);
  end;
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

procedure TILItem_Base.UpdateShopList;
begin
If Assigned(fOnShopListUpdate) and (fUpdateCounter <= 0) then
  fOnShopListUpdate(Self);
Include(fUpdated,iliufShopList);
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
fStaticOptions := IL_ThreadSafeCopy(Source.StaticOptions);
// do not copy time of addition, leave it as is (actual time)
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
    fShops[i].OnClearSelected := ClearSelectedHandler;
    fShops[i].OnOverviewUpdate := UpdateOverviewHandler;
    fShops[i].OnListUpdate := UpdateShopListItemHandler;
    fShops[i].OnValuesUpdate := UpdateShopValuesHandler;
    fShops[i].OnAvailHistoryUpdate := UpdateShopAvailHistoryHandler;
    fShops[i].OnPriceHistoryUpdate := UpdateShopPriceHistoryHandler;
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
  If AnsiSameText(fShops[i].Name,Name) then
    begin
      Result := i;
      Break{For i};
    end;
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

Function TILItem_Base.ShopIndexOf(Shop: TILITemShop): Integer;
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
fShops[Result].StaticOptions := fStaticOptions;
fShops[Result].OnClearSelected := ClearSelectedHandler;
fShops[Result].OnOverviewUpdate := UpdateOverviewHandler;
fShops[Result].OnListUpdate := UpdateShopListItemHandler;
fShops[Result].OnValuesUpdate := UpdateShopValuesHandler;
fShops[Result].OnAvailHistoryUpdate := UpdateShopAvailHistoryHandler;
fShops[Result].OnPriceHistoryUpdate := UpdateShopPriceHistoryHandler;
Inc(fShopCount);
UpdateShopList;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.ShopExchange(Idx1,Idx2: Integer);
var
  Temp: TILItemShop;
begin
If Idx1 <> Idx2 then
  begin
    // sanity checks
    If (Idx1 < ShopLowIndex) or (Idx1 > ShopHighIndex) then
      raise Exception.CreateFmt('TILItem_Base.ShopExchange: Index 1 (%d) out of bounds.',[Idx1]);
    If (Idx2 < ShopLowIndex) or (Idx2 > ShopHighIndex) then
      raise Exception.CreateFmt('TILItem_Base.ShopExchange: Index 2 (%d) out of bounds.',[Idx1]);
    Temp := fShops[Idx1];
    fShops[Idx1] := fShops[Idx2];
    fShops[Idx2] := Temp;
    UpdateShopListItemHandler(fShops[Idx1]);
    UpdateShopListItemHandler(fShops[Idx2]);
  end;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.ShopDelete(Index: Integer);
var
  i:  Integer;
begin
If (Index >= ShopLowIndex) and (Index <= ShopHighIndex) then
  begin
    FreeAndNil(fShops[Index]);
    For i := Index to Pred(ShopHighIndex) do
      fShops[i] := fShops[i + 1];
    Dec(fShopCount);
    Shrink;
    UpdateShopList;
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
UpdateShopList;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.ResetTimeOfAddition;
begin
fTimeOfAddition := Now;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.SwitchPictures(Src,Dst: TLIItemPictureKind);
type
  PBitmap = ^TBitmap;
var
  SrcPtr: PBitmap;
  DstPtr: PBitmap;
  Temp:   TBitmap;
begin
If (Src <> Dst) and (Src <> ilipkUnknown) and (Dst <> ilipkUnknown) then
  begin
    case Src of
      ilipkMain:      SrcPtr := @fItemPicture;
      ilipkSecondary: SrcPtr := @fSecondaryPicture;
      ilipkPackage:   SrcPtr := @fPackagePicture;
    else
      raise Exception.CreateFmt('Invalid source picture kind (%d).',[Ord(Src)]);
    end;
    case Dst of
      ilipkMain:      DstPtr := @fItemPicture;
      ilipkSecondary: DstPtr := @fSecondaryPicture;
      ilipkPackage:   DstPtr := @fPackagePicture;
    else
      raise Exception.CreateFmt('Invalid destination picture kind (%d).',[Ord(Dst)]);
    end;
    Temp := SrcPtr^;
    SrcPtr^ := DstPtr^;
    DstPtr^ := Temp;
    UpdateMainList;
    UpdateSmallList;
    UpdatePictures;
  end;
end;

//------------------------------------------------------------------------------

Function TILItem_Base.SetFlagValue(ItemFlag: TILItemFlag; NewValue: Boolean): Boolean;
begin
Result := IL_SetItemFlagValue(fFlags,ItemFlag,NewValue);
If Result <> NewValue then
  UpdateMainList;
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

procedure TILItem_Base.Release(FullRelease: Boolean);
begin
If FullRelease then
  begin
    fOnTitleUpdate := nil;
    fOnPicturesUpdate := nil;
  end;
fOnShopListUpdate := nil;
fOnShopListItemUpdate := nil;
fOnShopValuesUpdate := nil;
fOnShopAvailHistoryUpd := nil;
fOnShopPriceHistoryUpd := nil;
end;

end.
