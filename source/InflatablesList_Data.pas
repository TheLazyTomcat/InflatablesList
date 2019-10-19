unit InflatablesList_Data;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  Graphics,
  InflatablesList_Types;

type
  TILItemManufacturerInfo = record
    Str:          String;
    LogoResName:  String;
    Logo:         TBitmap;  // 256 x 96 px, white background, loaded from resources
  end;

type
  TILDataProvider = class(TObject)
  private
    fItemManufacturers:     array[TILItemManufacturer] of TILItemManufacturerInfo;
    fItemReviewIcon:        TBitmap;
    fItemFlagIcons:         array[TILItemFlag] of TBitmap;
    fItemDefaultPics:       array[TILITemType] of TBitmap;
    fItemDefaultPicsSmall:  array[TILITemType] of TBitmap;
    fWantedGradientImage:   TBitmap;
    fRatingGradientImage:   TBitmap;
    Function GetItemManufacturerCount: Integer;
    Function GetItemManufacturer(ItemManufacturer: TILItemManufacturer): TILItemManufacturerInfo;
    Function GetItemFlagIconCount: Integer;
    Function GetItemFlagIcon(ItemFlag: TILItemFlag): TBitmap;
    Function GetItemDefaultPictureCount: Integer;
    Function GetItemDefaultPicture(ItemType: TILITemType): TBitmap;
    Function GetItemDefaultPictureSmallCount: Integer;
    Function GetItemDefaultPictureSmall(ItemType: TILITemType): TBitmap;
  protected
    class Function LoadBitmapFromResource(const ResName: String; Bitmap: TBitmap): Boolean; virtual;
    procedure InitializeItemManufacurers; virtual;
    procedure FinalizeItemManufacturers; virtual;
    procedure InitializeItemReviewIcon; virtual;
    procedure FinalizeItemReviewIcon; virtual;
    procedure InitializeItemFlagIcons; virtual;
    procedure FinalizeItemFlagIcons; virtual;
    procedure InitializeDefaultPictures; virtual;
    procedure FinalizeDefaultPictures; virtual;
    procedure InitializeDefaultPicturesSmall; virtual;
    procedure FinalizeDefaultPicturesSmall; virtual;
    procedure InitializeGradientImages; virtual;
    procedure FinalieGradientImages; virtual;
    procedure Initialize; virtual;
    procedure Finalize; virtual;
  public
    class Function GetItemTypeString(ItemType: TILItemType): String; virtual;
    class Function GetItemMaterialString(ItemMaterial: TILItemMaterial): String; virtual;
    class Function GetItemFlagString(ItemFlag: TILItemFlag): String; virtual;
    class Function GetItemValueTagString(ItemValueTag: TILItemValueTag): String; virtual;
    class Function GetShopParsingExtractFromString(ExtractFrom: TILItemShopParsingExtrFrom): String; virtual;
    class Function GetShopParsingExtractMethodString(ExtractMethod: TILItemShopParsingExtrMethod): String; virtual;
    constructor Create;
    destructor Destroy; override;
    property ItemManufacturerCount: Integer read GetItemManufacturerCount;
    property ItemManufacturers[ItemManufacturer: TILItemManufacturer]: TILItemManufacturerInfo read GetItemManufacturer;
    property ItemReviewIcon: TBitmap read fItemReviewIcon;
    property ItemFlagIconCount: Integer read GetItemFlagIconCount;
    property ItemFlagIcons[ItemFlag: TILItemFlag]: TBitmap read GetItemFlagIcon;
    property ItemDefaultPictureCount: Integer read GetItemDefaultPictureCount;
    property ItemDefaultPictures[ItemType: TILITemType]: TBitmap read GetItemDefaultPicture;
    property ItemDefaultPictureSmallCount: Integer read GetItemDefaultPictureSmallCount;
    property ItemDefaultPicturesSmall[ItemType: TILITemType]: TBitmap read GetItemDefaultPictureSmall;
    property WantedGradientImage: TBitmap read fWantedGradientImage;
    property RatingGradientImage: TBitmap read fRatingGradientImage;
  end;

implementation

uses
  SysUtils, Classes,
  StrRect,
  InflatablesList_Utils;

// resources containing the data
{$R '..\resources\man_logos.res'}
{$R '..\resources\icon_review.res'}
{$R '..\resources\flag_icons.res'}
{$R '..\resources\default_pics.res'}
{$R '..\resources\gradient.res'}

const
  IL_DATA_ITEMMANUFACTURER_STRS: array[TILItemManufacturer] of String = (
    'Bestway','Crivit','Intex','HappyPeople','Mondo','Polygroup','Summer Waves',
    'Swimline','Vetro-Plus','Wehncke','WIKY','ostatní');

  IL_DATA_ITEMMANUFACTURER_LOGORESNAMES: array[TILItemManufacturer] of String = (
    'man_logo_bestway','man_logo_crivit','man_logo_intex','man_logo_happypeople',
    'man_logo_mondo','man_logo_polygroup','man_logo_summerwaves','man_logo_swimline',
    'man_logo_vetroplus','man_logo_wehncke','man_logo_wiky','man_logo_others');

  IL_DATA_ITEMTYPE_STRS: array[TILItemType] of String =
    ('neznámý','kruh','kruh s madly','míè','rider','lehátko','lehátko/køeslo',
     'køeslo','sedátko','matrace','ostrov','ostrov/rider','postel','èlun',
     'hraèka','rukávky','balónek','ostatní');

  IL_DATA_ITEMMATERIAL_STRS: array[TILItemMaterial] of String =
    ('neznámý','polyvinylchlorid (PVC)','polyester (PES)','polyetylen (PE)',
     'polypropylen (PP)','akrylonitrilbutadienstyren (ABS)','polystyren (PS)',
     'povloèkované PVC','latex','silokon','gumotextílie','ostatní');

  IL_DATA_ITEMFLAG_STRS: array[TILItemFlag] of String = (
    'Owned','Wanted','Ordered','Boxed','Elsewhere','Untested','Testing',
    'Tested','Damaged','Repaired','Price change','Available change',
    'Not Available','Lost','Discarded');     

  IL_DATA_ITEMFLAGICON_RESNAMES: array[TILItemFlag] of String = (
    'flag_icon_owned','flag_icon_wanted','flag_icon_ordered','flag_icon_boxed',
    'flag_icon_elsewhere','flag_icon_untested','flag_icon_testing',
    'flag_icon_tested','flag_icon_damaged','flag_icon_repaired',
    'flag_icon_pricechange','flag_icon_availchange','flag_icon_notavailable',
    'flag_icon_lost','flag_icon_discarded');

  IL_DATA_ITEMVALUETAG_STRS: array[TILItemValueTag] of String = (
    '<none>','Unique identifier (UID)','Time of addition','Main picture (is present)',
    'Secondary picture (is present)','Package picture (is present)','Item type',
    'Item type specifier','Count','Manufacturer','Manufacturer string','Textual ID',
    'Numerical ID','ID string','Owned (flag)','Wanted (flag)','Ordered (flag)',
    'Boxed (flag)','Elsewhere (flag)','Untested (flag)','Testing (flag)','Tested (flag)',
    'Damaged (flag)','Repaired (flag)','Price change (flag)','Availability change (flag)',
    'Not available (flag)','Lost (flag)','Discarded (flag)','Textual tag','Numerical tag',
    'Wanted level (flagged)','Variant (color, pattern, type, ...)','Material type',
    'Size X (length, diameter, ...)','Size Y (width, inner diameter, ...)',
    'Size Z (height, thickness, ...)','Total size (X * Y * Z)','Weight','Total weight',
    'Wall thickness','Notes','ReviewURL','Review (is present)','Main picture file',
    'Main picture file (is present)','Secondary picture file','Secondary picture file (is present)',
    'Package picture file','Package picture file (is present)','Default unit price',
    'Rating','Unit price lowest','Total price lowest','Unit price selected','Total price selected',
    'Total price','Available pieces','Shop count','Useful shop count',
    'Useful shop ratio (useful/total)','Selected shop','Worst update result');

  IL_DATA_DEFAULTPIC_RESNAME: array[TILITemType] of String = (
    'def_pic_unknown','def_pic_ring','def_pic_ring_w_handles','def_pic_ball',
    'def_pic_rider','def_pic_lounger','def_pic_lounger_chair','def_pic_chair',
    'def_pic_seat','def_pic_mattress','def_pic_island','def_pic_island_rider',
    'def_pic_bed','def_pic_boat','def_pic_toy','def_pic_wings','def_pic_balloon',
    'def_pic_others');

  IL_DATA_SHOPPARSING_EXTRACTFROM: array[TILItemShopParsingExtrFrom] of String = (
    'Text','Nested text','Attribute value');

  IL_DATA_SHOPPARSING_EXTRACTMETHOD: array[TILItemShopParsingExtrMethod] of String = (
    'First integer','First integer, tagged','Negative tag is count',
    'First number','First number tagged');

//==============================================================================

Function TILDataProvider.GetItemManufacturerCount: Integer;
begin
Result := Length(fItemManufacturers);
end;

//------------------------------------------------------------------------------

Function TILDataProvider.GetItemManufacturer(ItemManufacturer: TILItemManufacturer): TILItemManufacturerInfo;
begin
If (ItemManufacturer >= Low(fItemManufacturers)) and (ItemManufacturer <= High(fItemManufacturers)) then
  Result := fItemManufacturers[ItemManufacturer]
else
  raise Exception.CreateFmt('TILDataProvider.GetItemManufacturer: Invalid item manufacturer (%d).',[Ord(ItemManufacturer)]);
end;

//------------------------------------------------------------------------------

Function TILDataProvider.GetItemFlagIconCount: Integer;
begin
Result := Length(fItemFlagIcons);
end;

//------------------------------------------------------------------------------

Function TILDataProvider.GetItemFlagIcon(ItemFlag: TILItemFlag): TBitmap;
begin
If (ItemFlag >= Low(fItemFlagIcons)) and (ItemFlag <= High(fItemFlagIcons)) then
  Result := fItemFlagIcons[ItemFlag]
else
  raise Exception.CreateFmt('TILDataProvider.GetItemFlagIcon: Invalid item flag (%d).',[Ord(ItemFlag)]);
end;

//------------------------------------------------------------------------------

Function TILDataProvider.GetItemDefaultPictureCount: Integer;
begin
Result := Length(fItemDefaultPics);
end;

//------------------------------------------------------------------------------

Function TILDataProvider.GetItemDefaultPicture(ItemType: TILITemType): TBitmap;
begin
If (ItemType >= Low(fItemDefaultPics)) and (ItemType <= High(fItemDefaultPics)) then
  Result := fItemDefaultPics[ItemType]
else
  raise Exception.CreateFmt('TILDataProvider.GetItemDefaultPicture: Invalid item type (%d).',[Ord(ItemType)]);
end;

//------------------------------------------------------------------------------

Function TILDataProvider.GetItemDefaultPictureSmallCount: Integer;
begin
Result := Length(fItemDefaultPicsSmall);
end;

//------------------------------------------------------------------------------

Function TILDataProvider.GetItemDefaultPictureSmall(ItemType: TILITemType): TBitmap;
begin
If (ItemType >= Low(fItemDefaultPicsSmall)) and (ItemType <= High(fItemDefaultPicsSmall)) then
  Result := fItemDefaultPicsSmall[ItemType]
else
  raise Exception.CreateFmt('TILDataProvider.GetItemDefaultPictureSmall: Invalid item type (%d).',[Ord(ItemType)]);
end;

//==============================================================================

class Function TILDataProvider.LoadBitmapFromResource(const ResName: String; Bitmap: TBitmap): Boolean;
var
  ResStream:  TResourceStream;
begin
try
  ResStream := TResourceStream.Create(hInstance,StrToRTL(ResName),PChar(10){RT_RCDATA});
  try
    ResStream.Seek(0,soBeginning);
    Bitmap.LoadFromStream(ResStream);
  finally
    ResStream.Free;
  end;
  Result := True;
except
  Result := False;
end;
end;

//------------------------------------------------------------------------------

procedure TILDataProvider.InitializeItemManufacurers;
var
  i:      TILItemManufacturer;
  Bitmap: TBitmap;
begin
For i := Low(fItemManufacturers) to High(fItemManufacturers) do
  begin
    fItemManufacturers[i].Str := IL_DATA_ITEMMANUFACTURER_STRS[i];
    fItemManufacturers[i].LogoResName := IL_DATA_ITEMMANUFACTURER_LOGORESNAMES[i];
    Bitmap := TBitmap.Create;
    If not LoadBitmapFromResource(fItemManufacturers[i].LogoResName,Bitmap) then
      FreeAndNil(Bitmap);
    fItemManufacturers[i].Logo := Bitmap;
  end;
end;

//------------------------------------------------------------------------------

procedure TILDataProvider.FinalizeItemManufacturers;
var
  i:  TILItemManufacturer;
begin
For i := Low(fItemManufacturers) to High(fItemManufacturers) do
  If Assigned(fItemManufacturers[i].Logo) then
    FreeAndNil(fItemManufacturers[i].Logo);
end;

//------------------------------------------------------------------------------

procedure TILDataProvider.InitializeItemReviewIcon;
begin
fItemReviewIcon := TBitmap.Create;
If not LoadBitmapFromResource('icon_review',fItemReviewIcon) then
  FreeAndNil(fItemReviewIcon);
end;

//------------------------------------------------------------------------------

procedure TILDataProvider.FinalizeItemReviewIcon;
begin
If Assigned(fItemReviewIcon) then
  FreeAndNil(fItemReviewIcon);
end;

//------------------------------------------------------------------------------

procedure TILDataProvider.InitializeItemFlagIcons;
var
  i:  TILItemFlag; 
begin
For i := Low(fItemFlagIcons) to High(fItemFlagIcons) do
  begin
    fItemFlagIcons[i] := TBitmap.Create;
    If not LoadBitmapFromResource(IL_DATA_ITEMFLAGICON_RESNAMES[i],fItemFlagIcons[i]) then
      FreeAndNil(fItemFlagIcons[i]);
  end;
end;

//------------------------------------------------------------------------------

procedure TILDataProvider.FinalizeItemFlagIcons;
var
  i:  TILItemFlag;
begin
For i := Low(fItemFlagIcons) to High(fItemFlagIcons) do
  If Assigned(fItemFlagIcons[i])  then
    FreeAndNil(fItemFlagIcons[i]);
end;

//------------------------------------------------------------------------------

procedure TILDataProvider.InitializeDefaultPictures;
var
  i:  TILItemType;
begin
For i := Low(fItemDefaultPics) to High(fItemDefaultPics) do
  begin
    fItemDefaultPics[i] := TBitmap.Create;
    If not LoadBitmapFromResource(IL_DATA_DEFAULTPIC_RESNAME[i],fItemDefaultPics[i]) then
      FreeAndNil(fItemDefaultPics[i]);
  end;
end;

//------------------------------------------------------------------------------

procedure TILDataProvider.FinalizeDefaultPictures;
var
  i:  TILItemType;
begin
For i := Low(fItemDefaultPics) to High(fItemDefaultPics) do
  If Assigned(fItemDefaultPics[i]) then
    FreeAndNil(fItemDefaultPics[i]);
end;

//------------------------------------------------------------------------------

procedure TILDataProvider.InitializeDefaultPicturesSmall;
var
  i:  TILItemType;
begin
For i := Low(fItemDefaultPicsSmall) to High(fItemDefaultPicsSmall) do
  try
    fItemDefaultPicsSmall[i] := TBitmap.Create;
    fItemDefaultPicsSmall[i].PixelFormat := pf24bit;
    fItemDefaultPicsSmall[i].Width := 48;
    fItemDefaultPicsSmall[i].Height := 48;
    IL_PicShrink(fItemDefaultPics[i],fItemDefaultPicsSmall[i],2);
  except
    fItemDefaultPics[i] := nil;
  end;
end;

//------------------------------------------------------------------------------

procedure TILDataProvider.FinalizeDefaultPicturesSmall;
var
  i:  TILItemType;
begin
For i := Low(fItemDefaultPicsSmall) to High(fItemDefaultPicsSmall) do
  If Assigned(fItemDefaultPicsSmall[i]) then
    FreeAndNil(fItemDefaultPicsSmall[i]);
end;

//------------------------------------------------------------------------------

procedure TILDataProvider.InitializeGradientImages;
begin
fWantedGradientImage := TBitmap.Create;
If not LoadBitmapFromResource('wanted_grad',fWantedGradientImage) then
  FreeAndNil(fWantedGradientImage);
fRatingGradientImage := TBitmap.Create;
If not LoadBitmapFromResource('rating_grad',fRatingGradientImage) then
  FreeAndNil(fRatingGradientImage);
end;

//------------------------------------------------------------------------------

procedure TILDataProvider.FinalieGradientImages;
begin
If Assigned(fWantedGradientImage) then
  FreeAndNil(fWantedGradientImage);
If Assigned(fRatingGradientImage) then
  FreeAndNil(fRatingGradientImage);
end;

//------------------------------------------------------------------------------

procedure TILDataProvider.Initialize;
begin
InitializeItemManufacurers;
InitializeItemReviewIcon;
InitializeItemFlagIcons;
InitializeDefaultPictures;
InitializeDefaultPicturesSmall;
InitializeGradientImages;
end;

//------------------------------------------------------------------------------

procedure TILDataProvider.Finalize;
begin
FinalieGradientImages;
FinalizeDefaultPicturesSmall;
FinalizeDefaultPictures;
FinalizeItemFlagIcons;
FinalizeItemReviewIcon;
FinalizeItemManufacturers;
end;

//==============================================================================

class Function TILDataProvider.GetItemTypeString(ItemType: TILItemType): String;
begin
If (ItemType >= Low(TILItemType)) and (ItemType <= High(TILItemType)) then
  Result := IL_DATA_ITEMTYPE_STRS[ItemType]
else
  raise Exception.CreateFmt('TILDataProvider.GetItemTypeString: Invalid item type (%d).',[Ord(ItemType)]);
end;

//------------------------------------------------------------------------------

class Function TILDataProvider.GetItemMaterialString(ItemMaterial: TILItemMaterial): String;
begin
If (ItemMaterial >= Low(TILItemMaterial)) and (ItemMaterial <= High(TILItemMaterial)) then
  Result := IL_DATA_ITEMMATERIAL_STRS[ItemMaterial]
else
  raise Exception.CreateFmt('TILDataProvider.GetItemMaterialString: Invalid item material (%d).',[Ord(ItemMaterial)]);
end;

//------------------------------------------------------------------------------

class Function TILDataProvider.GetItemFlagString(ItemFlag: TILItemFlag): String;
begin
If (ItemFlag >= Low(TILItemFlag)) and (ItemFlag <= High(TILItemFlag)) then
  Result := IL_DATA_ITEMFLAG_STRS[ItemFlag]
else
  raise Exception.CreateFmt('TILDataProvider.GetItemFlagString: Invalid item flag (%d).',[Ord(ItemFlag)]);
end;

//------------------------------------------------------------------------------

class Function TILDataProvider.GetItemValueTagString(ItemValueTag: TILItemValueTag): String;
begin
If (ItemValueTag >= Low(TILItemValueTag)) and (ItemValueTag <= High(TILItemValueTag)) then
  Result := IL_DATA_ITEMVALUETAG_STRS[ItemValueTag]
else
  raise Exception.CreateFmt('TILDataProvider.GetItemValueTagString: Invalid item value tag (%d).',[Ord(ItemValueTag)]);
end;

//------------------------------------------------------------------------------

class Function TILDataProvider.GetShopParsingExtractFromString(ExtractFrom: TILItemShopParsingExtrFrom): String;
begin
If (ExtractFrom >= Low(TILItemShopParsingExtrFrom)) and (ExtractFrom <= High(TILItemShopParsingExtrFrom)) then
  Result := IL_DATA_SHOPPARSING_EXTRACTFROM[ExtractFrom]
else
  raise Exception.CreateFmt('TILDataProvider.GetShopParsingEtractFromString: Invalid extract from value (%d).',[Ord(ExtractFrom)]);
end;

//------------------------------------------------------------------------------

class Function TILDataProvider.GetShopParsingExtractMethodString(ExtractMethod: TILItemShopParsingExtrMethod): String;
begin
If (ExtractMethod >= Low(TILItemShopParsingExtrMethod)) and (ExtractMethod <= High(TILItemShopParsingExtrMethod)) then
  Result := IL_DATA_SHOPPARSING_EXTRACTMETHOD[ExtractMethod]
else
  raise Exception.CreateFmt('TILDataProvider.GetShopParsingExtractMethodString: Invalid extraction method (%d).',[Ord(ExtractMethod)]);
end;

//------------------------------------------------------------------------------

constructor TILDataProvider.Create;
begin
inherited Create;
Initialize;
end;

//------------------------------------------------------------------------------

destructor TILDataProvider.Destroy;
begin
Finalize;
inherited;
end;

end.
