unit IL_Item_Base;

{$INCLUDE '.\IL_defs.inc'}

interface

uses
  Graphics,
  AuxTypes, AuxClasses,
  IL_Types, IL_Data, IL_ItemShop;

type
  TILItem_Base = class(TCustomListObject)
  protected
    fDataProvider:          TILDataProvider;
    fOwnsDataProvider:      Boolean;
    fIndex:                 Integer;  // used in sorting
    fRender:                TBitmap;
    fFilteredOut:           Boolean;
    fUpdateCounter:         Integer;
    fUpdated:               TILItemUpdatedFlags;
    // events
    fOnMainListUpdate:      TNotifyEvent;
    fOnSmallListUpdate:     TNotifyEvent;
    fOnTitleUpdate:         TNotifyEvent;
    fOnPicturesUpdate:      TNotifyEvent;
    fOnShopListUpdate:      TNotifyEvent;
    fOnShopListItemUpdate:  TIntegerEvent;
    fOnShopValuesUpdate:    TIntegerEvent;
    fOnShopAvailHistoryUpd: TIntegerEvent;
    fOnShopPriceHistoryUpd: TIntegerEvent;
    // item data...
    // general read-only info
    fTimeOfAddition:        TDateTime;
    // stored pictures
    fItemPicture:           TBitmap;  // 96 x 96 px, white background
    fPackagePicture:        TBitmap;  // 96 x 96 px, white background
    // basic specs
    fItemType:              TILItemType;
    fItemTypeSpec:          String;   // closer specification of type
    fPieces:                UInt32;
    fManufacturer:          TILItemManufacturer;
    fManufacturerStr:       String;
    fID:                    Int32;
    // flags, tags
    fFlags:                 TILItemFlags;
    fTextTag:               String;
    // extended specs
    fWantedLevel:           UInt32;   // 0..7
    fVariant:               String;   // color, pattern, ...
    fSizeX:                 UInt32;   // length (diameter if applicable)
    fSizeY:                 UInt32;   // width (inner diameter if applicable)
    fSizeZ:                 UInt32;   // height
    fUnitWeight:            UInt32;   // [g]
    // some other stuff
    fNotes:                 String;
    fReviewURL:             String;
    fItemPictureFile:       String;
    fPackagePictureFile:    String;
    fUnitPriceDefault:      UInt32;
    // availability and prices (calculated from shops)
    fUnitPriceLowest:       UInt32;
    fUnitPriceHighest:      UInt32;
    fUnitPriceSelected:     UInt32;
    fAvailableLowest:       Int32;    // negative value means "more than"
    fAvailableHighest:      Int32;
    fAvailableSelected:     Int32;
    // shops
    fShopCount:             Integer;
    fShops_:                 array of TILItemShop; {$message 'later remove the underscore'}
    // data getters and setters
    procedure SetItemPicture(Value: TBitmap); virtual;
    procedure SetPackagePicture(Value: TBitmap); virtual;
    procedure SetItemType(Value: TILItemType); virtual;
    procedure SetItemTypeSpec(const Value: String); virtual;
    procedure SetPieces(Value: UInt32); virtual;
    procedure SetManufacturer(Value: TILItemManufacturer); virtual;
    procedure SetManufacturerStr(const Value: String); virtual;
    procedure SetID(Value: Int32); virtual;
    procedure SetFlags(Value: TILItemFlags); virtual;
    procedure SetTextTag(const Value: String); virtual;
    procedure SetWantedLevel(Value: UInt32); virtual;
    procedure SetVariant(const Value: String); virtual;
    procedure SetSizeX(Value: UInt32); virtual;
    procedure SetSizeY(Value: UInt32); virtual;
    procedure SetSizeZ(Value: UInt32); virtual;
    procedure SetUnitWeight(Value: UInt32); virtual;
    procedure SetNotes(const Value: String); virtual;
    procedure SetReviewURL(const Value: String); virtual;
    procedure SetItemPictureFile(const Value: String); virtual;
    procedure SetPackagePictureFile(const Value: String); virtual;
    procedure SetUnitPriceDefault(Value: UInt32); virtual;
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
    procedure ClearSelectedHandler(Sender: TObject); virtual;
    procedure UpdateMainList; virtual;
    procedure UpdateSmallList; virtual;
    procedure UpdateTitle; virtual;
    procedure UpdatePictures; virtual;
    procedure UpdateShopList; virtual;
    procedure UpdateShopListItem(Sender: TObject); virtual;
    procedure UpdateShopValues(Sender: TObject); virtual;
    procedure UpdateShopAvailHistory(Sender: TObject); virtual;
    procedure UpdateShopPriceHistory(Sender: TObject); virtual;
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
    procedure SwitchPictures; virtual;
    Function SetFlagValue(ItemFlag: TILItemFlag; NewValue: Boolean): Boolean; virtual;
    procedure BroadcastReqCount; virtual;
    procedure Release(FullRelease: Boolean); virtual;
    // properties
    property Index: Integer read fIndex write fIndex;
    property Render: TBitmap read fRender;
    property FilteredOut: Boolean read fFilteredOut;
    // events
    property OnMainListUpdate: TNotifyEvent read fOnMainListUpdate write fOnMainListUpdate;
    property OnSmallListUpdate: TNotifyEvent read fOnSmallListUpdate write fOnSmallListUpdate;
    property OnTitleUpdate: TNotifyEvent read fOnTitleUpdate write fOnTitleUpdate;
    property OnPicturesUpdate: TNotifyEvent read fOnPicturesUpdate write fOnPicturesUpdate;
    property OnShopListUpdate: TNotifyEvent read fOnShopListUpdate write fOnShopListUpdate;
    property OnShopListItemUpdate: TIntegerEvent read fOnShopListItemUpdate write fOnShopListItemUpdate;
    property OnShopValuesUpdate: TIntegerEvent read fOnShopValuesUpdate write fOnShopValuesUpdate;
    property OnShopAvailHistoryUpdate: TIntegerEvent read fOnShopAvailHistoryUpd write fOnShopAvailHistoryUpd;
    property OnShopPriceHistoryUpdate: TIntegerEvent read fOnShopPriceHistoryUpd write fOnShopPriceHistoryUpd;
    // item data
    property TimeOfAddition: TDateTime read fTimeOfAddition;
    property ItemPicture: TBitmap read fItemPicture write SetItemPicture;
    property PackagePicture: TBitmap read fPackagePicture write SetPackagePicture;
    property ItemType: TILItemType read fItemType write SetItemType;
    property ItemTypeSpec: String read fItemTypeSpec write SetItemTypeSpec;
    property Pieces: UInt32 read fPieces write SetPieces;
    property Manufacturer: TILItemManufacturer read fManufacturer write SetManufacturer;
    property ManufacturerStr: String read fManufacturerStr write SetManufacturerStr;
    property ID: Int32 read fID write SetID;
    property Flags: TILItemFlags read fFlags write SetFlags;
    property TextTag: String read fTextTag write SetTextTag;
    property WantedLevel: UInt32 read fWantedLevel write SetWantedLevel;
    property Variant: String read fVariant write SetVariant;
    property SizeX: UInt32 read fSizeX write SetSizeX;
    property SizeY: UInt32 read fSizeY write SetSizeY;
    property SizeZ: UInt32 read fSizeZ write SetSizeZ;
    property UnitWeight: UInt32 read fUnitWeight write SetUnitWeight;
    property Notes: String read fNotes write SetNotes;
    property ReviewURL: String read fReviewURL write SetReviewURL;
    property ItemPictureFile: String read fItemPictureFile write SetItemPictureFile;
    property PackagePictureFile: String read fPackagePictureFile write SetPackagePictureFile;
    property UnitPriceDefault: UInt32 read fUnitPriceDefault write SetUnitPriceDefault;
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

procedure TILItem_Base.SetItemPicture(Value: TBitmap);
begin
If fItemPicture <> Value {a different object reference} then
  begin
    If Assigned(fItemPicture) then
      FreeAndNil(fItemPicture);
    fItemPicture := Value;
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
  end;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.SetSizeX(Value: UInt32);
begin
If fSizeX <> Value then
  begin
    fSizeX := Value;
    UpdateMainList;
  end;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.SetSizeY(Value: UInt32);
begin
If fSizeY <> Value then
  begin
    fSizeY := Value;
    UpdateMainList;
  end;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.SetSizeZ(Value: UInt32);
begin
If fSizeZ <> Value then
  begin
    fSizeZ := Value;
    UpdateMainList;
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
  end;
end;

//------------------------------------------------------------------------------

Function TILItem_Base.GetShop(Index: Integer): TILItemShop;
begin
If CheckIndex(Index) then
  Result := fShops_[Index]
else
  raise Exception.CreateFmt('TILItem_Base.GetShop: Index (%d) out of bounds.',[Index]);
end;

//==============================================================================

Function TILItem_Base.GetCapacity: Integer;
begin
Result := Length(fShops_);
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.SetCapacity(Value: Integer);
var
  i:  Integer;
begin
If Value < fShopCount then
  For i := Value to Pred(fShopCount) do
    fShops_[i].Free;
SetLength(fShops_,Value);
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
fTimeOfAddition := Now;
// basic specs
fItemPicture := nil;
fPackagePicture := nil;
fItemType := ilitUnknown;
fItemTypeSpec := '';
fPieces := 1;
fManufacturer := ilimOthers;
fManufacturerStr := '';
fID := 0;
// flags
fFlags := [];
fTextTag := '';
// ext. specs
fWantedLevel := 0;
fVariant := '';
fSizeX := 0;
fSizeY := 0;
fSizeZ := 0;
fUnitWeight := 0;
// other info
fNotes := '';
fReviewURL := '';
fItemPictureFile := '';
fPackagePictureFile := '';
fUnitPriceDefault := 0;
fUnitPriceLowest := 0;
fUnitPriceHighest := 0;
fUnitPriceSelected := 0;
fAvailableLowest := 0;
fAvailableHighest := 0;
fAvailableSelected := 0;
// shops
fShopCount := 0;
SetLength(fShops_,0);
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.FinalizeData;
var
  i:  Integer;
begin
If Assigned(fItemPicture) then
  FreeAndNil(fItemPicture);
If Assigned(fPackagePicture) then
  FreeAndNil(fPackagePicture);
// remove shops  
For i := LowIndex to HighIndex do
  fShops_[i].Free;
fShopCount := 0;
SetLength(fShops_,0);
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.Initialize;
begin
fIndex := -1;
fRender := TBitmap.Create;
fRender.PixelFormat := pf24bit;
fFilteredOut := False;
fUpdateCounter := 0;
fUpdated := [];
InitializeData;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.Finalize;
begin
FinalizeData;
If Assigned(fRender) then
  FreeAndNil(fRender);
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
          fShops_[i].Selected := False
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

//------------------------------------------------------------------------------

procedure TILItem_Base.UpdateShopListItem(Sender: TObject);
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

procedure TILItem_Base.UpdateShopValues(Sender: TObject);
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

procedure TILItem_Base.UpdateShopAvailHistory(Sender: TObject);
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

procedure TILItem_Base.UpdateShopPriceHistory(Sender: TObject);
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
// do not copy time of addition, leave it as is (actual time)
If CopyPics then
  begin
    If Assigned(Source.ItemPicture) then
      begin
        fItemPicture := TBitmap.Create;
        fItemPicture.Assign(Source.ItemPicture);
      end;
    If Assigned(Source.PackagePicture) then
      begin
        fPackagePicture := TBitmap.Create;
        fPackagePicture.Assign(Source.PackagePicture);
      end;
    If Assigned(Source.Render) then
      fRender.Assign(Source.Render);
  end;
fItemType := Source.ItemType;
fItemTypeSpec := Source.ItemTypeSpec;
UniqueString(fItemTypeSpec);
fPieces := Source.Pieces;
fManufacturer := Source.Manufacturer;
fManufacturerStr := Source.ManufacturerStr;
UniqueString(fManufacturerStr);
fID := Source.ID;
fFlags := Source.Flags;
fTextTag := Source.TextTag;
UniqueString(fTextTag);
fWantedLevel := Source.WantedLevel;
fVariant := Source.Variant;
UniqueString(fVariant);
fSizeX := Source.SizeX;
fSizeY := Source.SizeY;
fSizeZ := Source.SizeZ;
fUnitWeight := Source.UnitWeight;
fNotes := Source.Notes;
UniqueString(fNotes);
fReviewURL := Source.ReviewURL;
UniqueString(fReviewURL);
fItemPictureFile := Source.ItemPictureFile;
UniqueString(fItemPictureFile);
fPackagePictureFile := Source.PackagePictureFile;
UniqueString(fPackagePictureFile);
fUnitPriceDefault := Source.UnitPriceDefault;
fUnitPriceLowest := Source.UnitPriceLowest;
fUnitPriceHighest := Source.UnitPriceHighest;
fUnitPriceSelected := Source.UnitPriceSelected;
fAvailableLowest := Source.AvailableLowest;
fAvailableHighest := Source.AvailableHighest;
fAvailableSelected := Source.AvailableSelected;
// copy shops
SetLength(fShops_,Source.ShopCount);
For i := Low(fShops_) to High(fShops_) do
  fShops_[i] := TILItemShop.CreateAsCopy(Source[i]);
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
Result := Low(fShops_);
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
  If AnsiSameText(fShops_[i].Name,Name) then
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
  If fShops_[i] = Shop then
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
fShops_[Result] := TILItemShop.Create;
fShops_[Result].OnClearSelected := ClearSelectedHandler;
fShops_[Result].OnListUpdate := UpdateShopListItem;
fShops_[Result].OnValuesUpdate := UpdateShopValues;
fShops_[Result].OnAvailHistoryUpdate := UpdateShopAvailHistory;
fShops_[Result].OnPriceHistoryUpdate := UpdateShopPriceHistory;
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
    Temp := fShops_[Idx1];
    fShops_[Idx1] := fShops_[Idx2];
    fShops_[Idx2] := Temp;
    UpdateShopList;
  end;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.ShopDelete(Index: Integer);
var
  i:  Integer;
begin
If (Index >= ShopLowIndex) and (Index <= ShopHighIndex) then
  begin
    FreeAndNil(fShops_[Index]);
    For i := Index to Pred(ShopHighIndex) do
      fShops_[i] := fShops_[i + 1];
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
  FreeAndNil(fShops_[i]);
SetLength(fShops_,0);
fShopCount := 0;
UpdateShopList;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.SwitchPictures;
var
  Temp: TBitmap;
begin
Temp := fItemPicture;
fItemPicture := fPackagePicture;
fPackagePicture := Temp;
UpdateMainList;
UpdateSmallList;
UpdatePictures;
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
  fShops_[i].RequiredCount := fPieces;
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
