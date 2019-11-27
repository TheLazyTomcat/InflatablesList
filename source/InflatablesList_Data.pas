unit InflatablesList_Data;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  Graphics,
  InflatablesList_Types;

type
  TILItemManufacturerInfo = record
    Str:          String;
    Tag:          String;
    LogoResName:  String;
    Logo:         TBitmap;  // 256 x 96 px, white background, loaded from resources
  end;

type
  TILDataProvider = class(TObject)
  private
    fItemManufacturers:     array[TILItemManufacturer] of TILItemManufacturerInfo;
    fItemReviewIcon:        TBitmap;
    fItemFlagIcons:         array[TILItemFlag] of TBitmap;
    fEmptyPicture:          TBitmap;
    fEmptyPictureSmall:     TBitmap;
    fEmptyPictureMini:      TBitmap;
    fItemDefaultPics:       array[TILItemType] of TBitmap;
    fItemDefaultPicsSmall:  array[TILItemType] of TBitmap;
    fItemDefaultPicsMini:   array[TILItemType] of TBitmap;
    fWantedGradientImage:   TBitmap;
    fRatingGradientImage:   TBitmap;
    fItemLockImage:         TBitmap;
    fItemLockIconWhite:     TBitmap;
    fItemLockIconBlack:     TBitmap;
    Function GetItemManufacturerCount: Integer;
    Function GetItemManufacturer(ItemManufacturer: TILItemManufacturer): TILItemManufacturerInfo;
    Function GetItemFlagIconCount: Integer;
    Function GetItemFlagIcon(ItemFlag: TILItemFlag): TBitmap;
    Function GetItemDefaultPictureCount: Integer;
    Function GetItemDefaultPicture(ItemType: TILITemType): TBitmap;
    Function GetItemDefaultPictureSmallCount: Integer;
    Function GetItemDefaultPictureSmall(ItemType: TILITemType): TBitmap;
    Function GetItemDefaultPictureMiniCount: Integer;
    Function GetItemDefaultPictureMini(ItemType: TILITemType): TBitmap;
  protected
    procedure InitializeItemManufacurers; virtual;
    procedure FinalizeItemManufacturers; virtual;
    procedure InitializeItemReviewIcon; virtual;
    procedure FinalizeItemReviewIcon; virtual;
    procedure InitializeItemFlagIcons; virtual;
    procedure FinalizeItemFlagIcons; virtual;
    procedure InitializeEmptyPictures; virtual;
    procedure FinalizeEmptyPictures; virtual;
    procedure InitializeDefaultPictures; virtual;
    procedure FinalizeDefaultPictures; virtual;
    procedure InitializeDefaultPicturesSmall; virtual;
    procedure FinalizeDefaultPicturesSmall; virtual;
    procedure InitializeDefaultPicturesMini; virtual;
    procedure FinalizeDefaultPicturesMini; virtual;
    procedure InitializeGradientImages; virtual;
    procedure FinalizeGradientImages; virtual;
    procedure InitializeItemLockImage; virtual;
    procedure FinalizeItemLockImage; virtual;
    procedure Initialize; virtual;
    procedure Finalize; virtual;
  public
    class Function LoadBitmapFromResource(const ResName: String; Bitmap: TBitmap): Boolean; virtual;
    class Function GetItemTypeString(ItemType: TILItemType): String; virtual;
    class Function GetItemMaterialString(ItemMaterial: TILItemMaterial): String; virtual;
    class Function GetItemFlagString(ItemFlag: TILItemFlag): String; virtual;
    class Function GetItemValueTagString(ItemValueTag: TILItemValueTag): String; virtual;
    class Function GetShopUpdateResultString(UpdateResult: TILItemShopUpdateResult): String; virtual;
    class Function GetShopParsingExtractFromString(ExtractFrom: TILItemShopParsingExtrFrom): String; virtual;
    class Function GetShopParsingExtractMethodString(ExtractMethod: TILItemShopParsingExtrMethod): String; virtual;
    class Function GetAdvancedItemSearchResultString(SearchResult: TILAdvItemSearchResult): String; virtual;
    class Function GetAdvancedShopSearchResultString(SearchResult: TILAdvShopSearchResult): String; virtual;
    constructor Create;
    destructor Destroy; override;
    property ItemManufacturerCount: Integer read GetItemManufacturerCount;
    property ItemManufacturers[ItemManufacturer: TILItemManufacturer]: TILItemManufacturerInfo read GetItemManufacturer;
    property ItemReviewIcon: TBitmap read fItemReviewIcon;
    property ItemFlagIconCount: Integer read GetItemFlagIconCount;
    property ItemFlagIcons[ItemFlag: TILItemFlag]: TBitmap read GetItemFlagIcon;
    property EmptyPicture: TBitmap read fEmptyPicture;
    property EmptyPictureSmall: TBitmap read fEmptyPictureSmall;
    property EmptyPictureMini: TBitmap read fEmptyPictureMini;
    property ItemDefaultPictureCount: Integer read GetItemDefaultPictureCount;
    property ItemDefaultPictures[ItemType: TILITemType]: TBitmap read GetItemDefaultPicture;
    property ItemDefaultPictureSmallCount: Integer read GetItemDefaultPictureSmallCount;
    property ItemDefaultPicturesSmall[ItemType: TILITemType]: TBitmap read GetItemDefaultPictureSmall;
    property ItemDefaultPictureMiniCount: Integer read GetItemDefaultPictureMiniCount;
    property ItemDefaultPicturesMini[ItemType: TILITemType]: TBitmap read GetItemDefaultPictureMini;
    property WantedGradientImage: TBitmap read fWantedGradientImage;
    property RatingGradientImage: TBitmap read fRatingGradientImage;
    property ItemLockImage: TBitmap read fItemLockImage;
    property ItemLockIconWhite: TBitmap read fItemLockIconWhite;
    property ItemLockIconBlack: TBitmap read fItemLockIconBlack;
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
{$R '..\resources\item_lock.res'}
{$R '..\resources\empty_pic.res'}

const
  IL_DATA_ITEMMANUFACTURER_STRS: array[TILItemManufacturer] of String = (
    'Bestway','Crivit','Intex','HappyPeople','Mondo','Polygroup','Summer Waves',
    'Swimline','Vetro-Plus','Wehncke','WIKY','ostatní');

  IL_DATA_ITEMMANUFACTURER_TAGS: array[TILItemManufacturer] of String = (
    'bw','cr','it','hp','mn','pg','sw','sl','vp','wh','wk','os');

  IL_DATA_ITEMMANUFACTURER_LOGORESNAMES: array[TILItemManufacturer] of String = (
    'man_logo_bestway','man_logo_crivit','man_logo_intex','man_logo_happypeople',
    'man_logo_mondo','man_logo_polygroup','man_logo_summerwaves','man_logo_swimline',
    'man_logo_vetroplus','man_logo_wehncke','man_logo_wiky','man_logo_others');

  IL_DATA_ITEMTYPE_STRS: array[TILItemType] of String =
    ('neznámý','kruh','kruh s madly','kruh speciální','míè','rider','lehátko',
     'lehátko s opìrkou','sedátko','rukávky','hraèka','ostrov','ostrov extra',
     'èlun','matrace','postel','køeslo','pohovka','balónek','ostatní');

  IL_DATA_ITEMMATERIAL_STRS: array[TILItemMaterial] of String =
    ('neznámý','polyvinylchlorid (PVC)','polyester (PES)','polyetylen (PE)',
     'polypropylen (PP)','akrylonitrilbutadienstyren (ABS)','polystyren (PS)',
     'polyuretan (PUR)','povloèkované PVC','latex','silokon','gumotextílie',
     'ostatní');

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
    '<none>','Item is encrypted','Unique identifier (UID)','Time of addition','Item descriptor',
    'Main picture (is present)','Main picture file','Main picture thumbnail (is present)',
    'Package picture (is present)','Package picture file','Package picture thumbnail (is present)',
    'Current secondary picture (is present)','Current secondary picture file',
    'Current secondary picture thumbnail (is present)','Picture count','Secondary picture count',
    'Secondary picture count (with thumbnails)','Item type','Item type specifier',
    'Pieces','User ID','Manufacturer','Manufacturer string','Textual ID','Numerical ID',
    'ID string','Owned (flag)','Wanted (flag)','Ordered (flag)','Boxed (flag)',
    'Elsewhere (flag)','Untested (flag)','Testing (flag)','Tested (flag)','Damaged (flag)',
    'Repaired (flag)','Price change (flag)','Availability change (flag)','Not available (flag)',
    'Lost (flag)','Discarded (flag)','Textual tag','Numerical tag','Wanted level (flagged)',
    'Variant (color, pattern, type, ...)','Variant tag','Wall thickness','Material type',
    'Size X (length, diameter, ...)','Size Y (width, inner diameter, ...)',
    'Size Z (height, thickness, ...)','Total size (X * Y * Z)','Weight','Total weight',
    'Notes','ReviewURL','Review (is present)','Default unit price',
    'Rating','Unit price lowest','Total price lowest','Unit price selected',
    'Total price selected','Total price','Available pieces','Shop count','Useful shop count',
    'Useful shop ratio (useful/total)','Selected shop','Worst update result');

  IL_DATA_SHOPUPDATERESULT_STRS: array[TILItemShopUpdateResult] of String = (
    'Success','Mild success','Data fail','Soft fail','Hard fail',
    'Download fail','Parsing fail','Fatal error');

  IL_DATA_DEFAULTPIC_RESNAME: array[TILITemType] of String = (
    'def_pic_unknown','def_pic_ring','def_pic_ring_w_handles',
    'def_pic_ring_special','def_pic_ball','def_pic_rider','def_pic_lounger',
    'def_pic_lounger_chair','def_pic_seat','def_pic_wings','def_pic_toy',
    'def_pic_island','def_pic_island_rider','def_pic_boat','def_pic_mattress',
    'def_pic_bed','def_pic_chair','def_pic_sofa','def_pic_balloon',
    'def_pic_others');

  IL_DATA_SHOPPARSING_EXTRACTFROM: array[TILItemShopParsingExtrFrom] of String = (
    'Text','Nested text','Attribute value');

  IL_DATA_SHOPPARSING_EXTRACTMETHOD: array[TILItemShopParsingExtrMethod] of String = (
    'First integer','First integer, tagged','Negative tag is count',
    'First number','First number tagged');

  IL_DATA_ADVSEARCHRESULT_ITEM_STRS: array[TILAdvItemSearchResult] of String = (
    'List index','Unique ID','Time of addition','Item descriptor','Title',
    'Type','Type specification','Type string','Pieces','User ID','Manufacturer',
    'Manufacturer string','Manufaturer tag','Text ID','Numerical ID','ID string',
    'Flags','Flag - Owned','Flag - Wanted','Flag - Ordered','Flag - Boxed',
    'Flag - Elsewhere','Flag - Untested','Flag - Iesting','Flag - Tested',
    'Flag - Damaged','Flag - Rrepaired','Flag  - Price change',
    'Flag - Availability change','Flag - Not available','Flag - Lost',
    'Flag - Discarded','Textual tag','Numerical tag','Wanted level','Variant',
    'Variant tag','Material','Size X','Size Y','Size Z','Total size',
    'Size string','Unit weight','Total weight','Total weight string',
    'Thickness','Notes','Review URL','Pictures','Main picture file',
    'Package picture file','Current secondary picture file','Unit price default',
    'Rating','Unit price','Unit price lowest','Total price lowest',
    'Unit price highest','Total price highest','Unit price selected',
    'Total price selected','Total price','Available lowest','Available highest',
    'Available selected','Shop count','Shop count string','Useful shop count',
    'Useful shop ratio','Selected shop','Worst update result');

  IL_DATA_ADVSEARCHRESULT_SHOP_STRS: array[TILAdvShopSearchResult] of String = (
    'List index','Selected','Untracked','Alternative download method','Name',
    'Shop URL','Item URL','Available','Price','Notes','Last update result',
    'Last update message','Last update time','Parsing variables',
    'Parsing template reference','Ignore parsing errors','Available history',
    'Price history','Available extraction settings','Price extraction settings',
    'Available parsing finder','Price parsing finder');

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

//------------------------------------------------------------------------------

Function TILDataProvider.GetItemDefaultPictureMiniCount: Integer;
begin
Result := Length(fItemDefaultPicsMini);
end;

//------------------------------------------------------------------------------

Function TILDataProvider.GetItemDefaultPictureMini(ItemType: TILITemType): TBitmap;
begin
If (ItemType >= Low(fItemDefaultPicsMini)) and (ItemType <= High(fItemDefaultPicsMini)) then
  Result := fItemDefaultPicsMini[ItemType]
else
  raise Exception.CreateFmt('TILDataProvider.GetItemDefaultPictureMini: Invalid item type (%d).',[Ord(ItemType)]);
end;

//==============================================================================

procedure TILDataProvider.InitializeItemManufacurers;
var
  i:      TILItemManufacturer;
  Bitmap: TBitmap;
begin
For i := Low(fItemManufacturers) to High(fItemManufacturers) do
  begin
    fItemManufacturers[i].Str := IL_DATA_ITEMMANUFACTURER_STRS[i];
    fItemManufacturers[i].Tag := IL_DATA_ITEMMANUFACTURER_TAGS[i];
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

procedure TILDataProvider.InitializeEmptyPictures;
begin
fEmptyPicture := TBitmap.Create;
If LoadBitmapFromResource('empty_pic',fEmptyPicture) then
  begin
    fEmptyPictureSmall := TBitmap.Create;
    fEmptyPictureSmall.PixelFormat := pf24bit;
    fEmptyPictureSmall.Width := 48;
    fEmptyPictureSmall.Height := 48;
    IL_PicShrink(fEmptyPicture,fEmptyPictureSmall,2);
    fEmptyPictureMini := TBitmap.Create;
    fEmptyPictureMini.PixelFormat := pf24bit;
    fEmptyPictureMini.Width := 32;
    fEmptyPictureMini.Height := 32;
    IL_PicShrink(fEmptyPicture,fEmptyPictureMini,3);
  end
else
  begin
    FreeAndNil(fEmptyPicture);
    raise Exception.Create('TILDataProvider.InitializeEmptyPictures: Failed to load empty item picture.');
  end;
end;

//------------------------------------------------------------------------------

procedure TILDataProvider.FinalizeEmptyPictures;
begin
If Assigned(fEmptyPictureMini) then
  FreeAndNil(fEmptyPictureMini);
If Assigned(fEmptyPictureSmall) then
  FreeAndNil(fEmptyPictureSmall);
If Assigned(fEmptyPicture) then
  FreeAndNil(fEmptyPicture);
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

procedure TILDataProvider.InitializeDefaultPicturesMini;
var
  i:  TILItemType;
begin
For i := Low(fItemDefaultPicsMini) to High(fItemDefaultPicsMini) do
  try
    fItemDefaultPicsMini[i] := TBitmap.Create;
    fItemDefaultPicsMini[i].PixelFormat := pf24bit;
    fItemDefaultPicsMini[i].Width := 32;
    fItemDefaultPicsMini[i].Height := 32;
    IL_PicShrink(fItemDefaultPics[i],fItemDefaultPicsMini[i],3);
  except
    fItemDefaultPics[i] := nil;
  end;
end;

//------------------------------------------------------------------------------

procedure TILDataProvider.FinalizeDefaultPicturesMini;
var
  i:  TILItemType;
begin
For i := Low(fItemDefaultPicsMini) to High(fItemDefaultPicsMini) do
  If Assigned(fItemDefaultPicsMini[i]) then
    FreeAndNil(fItemDefaultPicsMini[i]);
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

procedure TILDataProvider.FinalizeGradientImages;
begin
If Assigned(fWantedGradientImage) then
  FreeAndNil(fWantedGradientImage);
If Assigned(fRatingGradientImage) then
  FreeAndNil(fRatingGradientImage);
end;

//------------------------------------------------------------------------------

procedure TILDataProvider.InitializeItemLockImage;
begin
fItemLockImage := TBitmap.Create;
If not LoadBitmapFromResource('item_lock',fItemLockImage) then
  FreeAndNil(fItemLockImage);
fItemLockIconWhite := TBitmap.Create;
If not LoadBitmapFromResource('icon_lock_w',fItemLockIconWhite) then
  FreeAndNil(fItemLockIconWhite);  
fItemLockIconBlack := TBitmap.Create;
If not LoadBitmapFromResource('icon_lock_b',fItemLockIconBlack) then
  FreeAndNil(fItemLockIconBlack);
end;

//------------------------------------------------------------------------------

procedure TILDataProvider.FinalizeItemLockImage;
begin
If Assigned(fItemLockImage) then
  FreeAndNil(fItemLockImage);
If Assigned(fItemLockIconWhite) then
  FreeAndNil(fItemLockIconWhite);
If Assigned(fItemLockIconBlack) then
  FreeAndNil(fItemLockIconBlack);
end;

//------------------------------------------------------------------------------

procedure TILDataProvider.Initialize;
begin
InitializeItemManufacurers;
InitializeItemReviewIcon;
InitializeItemFlagIcons;
InitializeEmptyPictures;
InitializeDefaultPictures;
InitializeDefaultPicturesSmall;
InitializeDefaultPicturesMini;
InitializeGradientImages;
InitializeItemLockImage;
end;

//------------------------------------------------------------------------------

procedure TILDataProvider.Finalize;
begin
FinalizeItemLockImage;
FinalizeGradientImages;
FinalizeDefaultPicturesMini;
FinalizeDefaultPicturesSmall;
FinalizeDefaultPictures;
FinalizeEmptyPictures;
FinalizeItemFlagIcons;
FinalizeItemReviewIcon;
FinalizeItemManufacturers;
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

class Function TILDataProvider.GetShopUpdateResultString(UpdateResult: TILItemShopUpdateResult): String;
begin
If (UpdateResult >= Low(TILItemShopUpdateResult)) and (UpdateResult <= High(TILItemShopUpdateResult)) then
  Result := IL_DATA_SHOPUPDATERESULT_STRS[UpdateResult]
else
  raise Exception.CreateFmt('TILDataProvider.GetShopUpdateResultString: Invalid shop update result (%d).',[Ord(UpdateResult)]);
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

class Function TILDataProvider.GetAdvancedItemSearchResultString(SearchResult: TILAdvItemSearchResult): String;
begin
If (SearchResult >= Low(TILAdvItemSearchResult)) and (SearchResult <= High(TILAdvItemSearchResult)) then
  Result := IL_DATA_ADVSEARCHRESULT_ITEM_STRS[SearchResult]
else
  raise Exception.CreateFmt('TILDataProvider.GetAdvancedItemSearchResultString: Invalid search result (%d).',[Ord(SearchResult)]);
end;

//------------------------------------------------------------------------------

class Function TILDataProvider.GetAdvancedShopSearchResultString(SearchResult: TILAdvShopSearchResult): String;
begin
If (SearchResult >= Low(TILAdvShopSearchResult)) and (SearchResult <= High(TILAdvShopSearchResult)) then
  Result := IL_DATA_ADVSEARCHRESULT_Shop_STRS[SearchResult]
else
  raise Exception.CreateFmt('TILDataProvider.GetAdvancedShopSearchResultString: Invalid search result (%d).',[Ord(SearchResult)]);
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
