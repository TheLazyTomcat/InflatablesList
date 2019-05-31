unit IL_Item_Base;

{$INCLUDE '.\IL_defs.inc'}

interface

uses
  Graphics,
  AuxTypes, AuxClasses,
  IL_Types, IL_Data, IL_ItemShop;

type
  TILItemUpdatedFlag = (iliufList,iliufTitle,iliufPictures);

  TILItemUpdatedFlags = set of TILItemUpdatedFlag;

  TILItem_Base = class(TCustomListObject)
  protected
    fDataProvider:        TILDataProvider;
    fOwnsDataProvider:    Boolean;
    fIndex:               Integer;  // used when sorting
    fRender:              TBitmap;
    fFilteredOut:         Boolean;
    fUpdateCounter:       Integer;
    fUpdated:             TILItemUpdatedFlags;
    // item data...
    // general read-only info
    fTimeOfAddition:      TDateTime;
    // stored pictures
    fMainPicture:         TBitmap;  // 96 x 96 px, white background
    fPackagePicture:      TBitmap;  // 96 x 96 px, white background
    // basic specs
    fItemType:            TILItemType;
    fItemTypeSpec:        String;   // closer specification of type
    fPieces:              UInt32;
    fManufacturer:        TILItemManufacturer;
    fManufacturerStr:     String;
    fID:                  Int32;
    // flags, tags
    fFlags:               TILItemFlags;
    fTextTag:             String;
    // extended specs
    fWantedLevel:         UInt32;   // 0..7
    fVariant:             String;   // color, pattern, ...
    fSizeX:               UInt32;   // length (diameter if applicable)
    fSizeY:               UInt32;   // width (inner diameter if applicable)
    fSizeZ:               UInt32;   // height
    fUnitWeight:          UInt32;   // [g]
    // some other stuff
    fNotes:               String;
    fReviewURL:           String;
    fMainPictureFile:     String;
    fPackagePictureFile:  String;
    fUnitPriceDefault:    UInt32;
    // availability and prices (calculated from shops)
    fUnitPriceLowest:     UInt32;
    fUnitPriceHighest:    UInt32;
    fUnitPriceSelected:   UInt32;
    fAvailableLowest:     Int32;    // negative value means "more than"
    fAvailableHighest:    Int32;
    fAvailableSelected:   Int32;
    // shops
    fShopCount:           Integer;
    fShops:               array of TILItemShop;
    // events
    fOnListUpdate:        TNotifyEvent;
    fOnTitleUpdate:       TNotifyEvent;
    fOnPicturesUpdate:    TNotifyEvent;
    // data getters and setters
    procedure SetMainPicture(Value: TBitmap); virtual;
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
    procedure SetMainPictureFile(const Value: String); virtual;
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
    procedure UpdateList; virtual;
    procedure UpdateTitle; virtual;
    procedure UpdatePictures; virtual;
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
    Function ShopIndexOf(const Name: String): Integer; virtual;
    Function ShopAdd: Integer; virtual;
    procedure ShopExchange(Idx1,Idx2: Integer); virtual;
    procedure ShopDelete(Index: Integer); virtual;
    procedure ShopClear; virtual;
    property Index: Integer read fIndex write fIndex;
    property Render: TBitmap read fRender;
    property FilteredOut: Boolean read fFilteredOut;
    // item data
    property TimeOfAddition: TDateTime read fTimeOfAddition;
    property MainPicture: TBitmap read fMainPicture write SetMainPicture;
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
    property MainPictureFile: String read fMainPictureFile write SetMainPictureFile;
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
    // events
    property OnListUpdate: TNotifyEvent read fOnListUpdate write fOnListUpdate;
    property OnTitleUpdate: TNotifyEvent read fOnTitleUpdate write fOnTitleUpdate;
    property OnPicturesUpdate: TNotifyEvent read fOnPicturesUpdate write fOnPicturesUpdate;
  end;

implementation

uses
  SysUtils;

procedure TILItem_Base.SetMainPicture(Value: TBitmap);
begin
If fMainPicture <> Value {a different object reference} then
  begin
    If Assigned(fMainPicture) then
      FreeAndNil(fMainPicture);
    fMainPicture := Value;
    UpdateList;
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
    UpdateList;
    UpdateTitle;
  end;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.SetItemTypeSpec(const Value: String);
begin
If not AnsiSameStr(fItemTypeSpec,Value) then
  begin
    fItemTypeSpec := Value;
    UpdateList;
    UpdateTitle;
  end;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.SetPieces(Value: UInt32);
begin
If fPieces <> Value then
  begin
    fPieces := Value;
    UpdateList;
    UpdateTitle;
  end;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.SetManufacturer(Value: TILItemManufacturer);
begin
If fManufacturer <> Value then
  begin
    fManufacturer := Value;
    UpdateList;
    UpdateTitle;
  end;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.SetManufacturerStr(const Value: String);
begin
If not AnsiSameStr(fManufacturerStr,Value) then
  begin
    fManufacturerStr := Value;
    UpdateList;
    UpdateTitle;
  end;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.SetID(Value: Int32);
begin
If fID <> Value then
  begin
    fID := Value;
    UpdateList;
    UpdateTitle;
  end;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.SetFlags(Value: TILItemFlags);
begin
If fFlags <> Value then
  begin
    fFlags := Value;
    UpdateList;
  end;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.SetTextTag(const Value: String);
begin
If not AnsiSameStr(fTextTag,Value) then
  begin
    fTextTag := Value;
    UpdateList;
  end;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.SetWantedLevel(Value: UInt32);
begin
If fWantedLevel <> Value then
  begin
    fWantedLevel := Value;
    UpdateList;
  end;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.SetVariant(const Value: String);
begin
If not AnsiSameStr(fVariant,Value) then
  begin
    fVariant := Value;
    UpdateList;
  end;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.SetSizeX(Value: UInt32);
begin
If fSizeX <> Value then
  begin
    fSizeX := Value;
    UpdateList;
  end;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.SetSizeY(Value: UInt32);
begin
If fSizeY <> Value then
  begin
    fSizeY := Value;
    UpdateList;
  end;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.SetSizeZ(Value: UInt32);
begin
If fSizeZ <> Value then
  begin
    fSizeZ := Value;
    UpdateList;
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
    UpdateList;
  end;
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.SetMainPictureFile(const Value: String);
begin
If not AnsiSameStr(fMainPictureFile,Value) then
  begin
    fMainPictureFile := Value;
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
    UpdateList;
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
fTimeOfAddition := Now;
// basic specs
fMainPicture := nil;
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
fMainPictureFile := '';
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
SetLength(fShops,0);
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.FinalizeData;
var
  i:  Integer;
begin
If Assigned(fMainPicture) then
  FreeAndNil(fMainPicture);
If Assigned(fPackagePicture) then
  FreeAndNil(fPackagePicture);
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

procedure TILItem_Base.UpdateList;
begin
{$message 'implement'}
If Assigned(fOnListUpdate) and (fUpdateCounter <= 0) then
  fOnListUpdate(Self);
Include(fUpdated,iliufList);
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.UpdateTitle;
begin
{$message 'implement'}
If Assigned(fOnTitleUpdate) and (fUpdateCounter <= 0) then
  fOnTitleUpdate(Self);
Include(fUpdated,iliufTitle);
end;

//------------------------------------------------------------------------------

procedure TILItem_Base.UpdatePictures;
begin
{$message 'implement'}
If Assigned(fOnPicturesUpdate) and (fUpdateCounter <= 0) then
  fOnPicturesUpdate(Self);
Include(fUpdated,iliufPictures);
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
// do not copz time of addition, leave it as is (actual time)
If CopyPics then
  begin
    If Assigned(Source.MainPicture) then
      begin
        fMainPicture := TBitmap.Create;
        fMainPicture.Assign(Source.MainPicture);
      end;
    If Assigned(fPackagePicture) then
      begin
        fPackagePicture := TBitmap.Create;
        fPackagePicture.Assign(Source.PackagePicture);
      end;
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
fMainPictureFile := Source.MainPictureFile;
UniqueString(fMainPictureFile);
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
SetLength(fShops,Source.ShopCount);
For i := Low(fShops) to High(fShops) do
  fShops[i] := TILItemShop.CreateAsCopy(Source[i]);
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
    If iliufList in fUpdated then
      UpdateList;
    If iliufTitle in fUpdated then
      UpdateTitle;
    If iliufPictures in fUpdated then
      UpdatePictures;
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
  If AnsiSameText(Shops[i].Name,Name) then
    begin
      Result := i;
      Break{For i};
    end;
end;

//------------------------------------------------------------------------------

Function TILItem_Base.ShopAdd: Integer;
begin
Grow;
Result := HighIndex;
fShops[Result] := TILItemShop.Create;
Inc(fShopCount);
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
end;

end.
