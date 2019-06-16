unit IL_Data;

{$INCLUDE '.\IL_defs.inc'}

interface

uses
  Graphics,
  IL_Types;

type
  TILItemManufacturerInfo = record
    Str:          String;
    LogoResName:  String;
    Logo:         TBitmap;  // 256 x 96 px, white background, loaded from resources
  end;

type
  TILDataProvider = class(TObject)
  private
    fItemManufacturers: array[TILItemManufacturer] of TILItemManufacturerInfo;
    fItemReviewIcon:    TBitmap;
    fItemFlagIcons:     array[TILItemFlag] of TBitmap;
    fItemDefaultPics:   array[TILITemType] of TBitmap;
    fGradientImage:     TBitmap;
    Function GetItemManufacturerCount: Integer;
    Function GetItemManufacturer(ItemManufacturer: TILItemManufacturer): TILItemManufacturerInfo;
    Function GetItemFlagIconCount: Integer;
    Function GetItemFlagIcon(ItemFlag: TILItemFlag): TBitmap;
    Function GetItemDefaultPictureCount: Integer;
    Function GetItemDefaultPicture(ItemType: TILITemType): TBitmap;
  protected
    procedure InitializeItemManufacurers; virtual;
    procedure FinalizeItemManufacturers; virtual;
    procedure InitializeItemReviewIcon; virtual;
    procedure FinalizeItemReviewIcon; virtual;
    procedure InitializeItemFlagIcons; virtual;
    procedure FinalizeItemFlagIcons; virtual;
    procedure InitializeDefaultPictures; virtual;
    procedure FinalizeDefaultPictures; virtual;
    procedure InitializeGradientImage; virtual;
    procedure FinalieGradientImage; virtual;
    procedure Initialize; virtual;
    procedure Finalize; virtual;
  public
    class Function GetItemTypeString(ItemType: TILItemType): String; virtual;
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
    property GradientImage: TBitmap read fGradientImage;    
  end;

implementation

uses
  SysUtils, Classes;

// resources containing the data
{$R '..\resources\man_logos.res'}
{$R '..\resources\icon_review.res'}
{$R '..\resources\flag_icons.res'}
{$R '..\resources\default_pics.res'}
{$R '..\resources\gradient.res'}

const
  IL_DATA_ITEMMANUFACTURER_STRS: array[TILItemManufacturer] of String = (
    'Bestway','Intex','HappyPeople','Mondo','Polygroup','Summer Waves',
    'Swimline','Vetro-Plus','Wehncke','WIKY','ostatn�');

  IL_DATA_ITEMMANUFACTURER_LOGORESNAMES: array[TILItemManufacturer] of String = (
    'man_logo_bestway','man_logo_intex','man_logo_happypeople','man_logo_mondo',
    'man_logo_polygroup','man_logo_summerwaves','man_logo_swimline',
    'man_logo_vetroplus','man_logo_wehncke','man_logo_wiky','man_logo_others');

  IL_DATA_ITEMTYPE_STRS: array[TILItemType] of String =
    ('nezn�m�','kruh','kruh s madly','m��','rider','leh�tko','leh�tko/k�eslo',
     'k�eslo','sed�tko','matrace','ostrov','postel','�lun','hra�ka','ruk�vky',
     'balonek','ostatn�');

  IL_DATA_ITEMFLAGICON_RESNAMES: array[TILItemFlag] of String = (
    'flag_icon_owned','flag_icon_wanted','flag_icon_ordered','flag_icon_boxed',
    'flag_icon_elsewhere','flag_icon_untested','flag_icon_testing',
    'flag_icon_tested','flag_icon_damaged','flag_icon_repaired',
    'flag_icon_pricechange','flag_icon_availchange','flag_icon_notavailable',
    'flag_icon_lost');

  IL_DATA_ITEMVALUETAG_STRS: array[TILItemValueTag] of String = (
    '<none>','Main picture (is present)','Package picture (is present)',
    'Time of addition','Item type','Item type specifier','Count','Manufacturer',
    'Manufacturer string','Numerical ID',
    'Owned (flag)','Wanted (flag)','Ordered (flag)','Boxed (flag)',
    'Elsewhere (flag)','Untested (flag)','Testing (flag)','Tested (flag)',
    'Damaged (flag)','Repaired (flag)','Price change (flag)',
    'Availability change (flag)','Not available (flag)','Lost (flag)',
    'Textual tag','Wanted level (flagged)','Variant (color, pattern, type, ...)',
    'Size X (length, diameter, ...)','Size Y (width, inner diameter, ...)',
    'Size Z (height, thickness, ...)','Total size (X * Y * Z)',
    'Weight','Total weight','Notes','ReviewURL','Review (is present)',
    'Main picture file','Main picture file (is present)','Package picture file',
    'Package picture file (is present)','Default unit price','Lowest unit price',
    'Lowest total price','Selected unit price','Selected total price',
    'Total price','Available pieces','Shop count','Useful shop count',
    'Useful shop ratio (useful/total)','Selected shop','Worst update result');

  IL_DATA_DEFAULTPIC_RESNAME: array[TILITemType] of String = (
    'def_pic_unknown','def_pic_ring','def_pic_ring_w_handles','def_pic_ball',
    'def_pic_rider','def_pic_lounger','def_pic_lounger_chair','def_pic_chair',
    'def_pic_seat','def_pic_mattress','def_pic_island','def_pic_bed',
    'def_pic_boat','def_pic_toy','def_pic_wings','def_pic_balloon',
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

//==============================================================================

procedure TILDataProvider.InitializeItemManufacurers;
var
  i:          TILItemManufacturer;
  ResStream:  TResourceStream;
  Bitmap:     TBitmap;
begin
For i := Low(fItemManufacturers) to High(fItemManufacturers) do
  begin
    fItemManufacturers[i].Str := IL_DATA_ITEMMANUFACTURER_STRS[i];
    fItemManufacturers[i].LogoResName := IL_DATA_ITEMMANUFACTURER_LOGORESNAMES[i];
    try
      ResStream := TResourceStream.Create(hInstance,fItemManufacturers[i].LogoResName,PChar(10){RT_RCDATA});
      try
        Bitmap := TBitmap.Create;
        ResStream.Seek(0,soBeginning);
        Bitmap.LoadFromStream(ResStream);
        fItemManufacturers[i].Logo := Bitmap;
      finally
        ResStream.Free;
      end;
    except
      // supress error
      fItemManufacturers[i].Logo := nil;
    end;
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
var
  ResStream:  TResourceStream;
begin
try
  ResStream := TResourceStream.Create(hinstance,'icon_review',PChar(10));
  try
    fItemReviewIcon := TBitmap.Create;
    ResStream.Seek(0,soBeginning);
    fItemReviewIcon.LoadFromStream(ResStream);
  finally
    ResStream.Free;
  end;
except
  fItemReviewIcon := nil;
end;
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
  i:          TILItemFlag;
  ResStream:  TResourceStream;
begin
For i := Low(fItemFlagIcons) to High(fItemFlagIcons) do
  try
    ResStream := TResourceStream.Create(hInstance,IL_DATA_ITEMFLAGICON_RESNAMES[i],PChar(10));
    try
      fItemFlagIcons[i] := TBitmap.Create;
      ResStream.Seek(0,soBeginning);
      fItemFlagIcons[i].LoadFromStream(ResStream);
    finally
      ResStream.Free;
    end;
  except
    fItemFlagIcons[i] := nil;
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
  i:          TILItemType;
  ResStream:  TResourceStream;
begin
For i := Low(fItemDefaultPics) to High(fItemDefaultPics) do
  try
    ResStream := TResourceStream.Create(hInstance,IL_DATA_DEFAULTPIC_RESNAME[i],PChar(10));
    try
      fItemDefaultPics[i] := TBitmap.Create;
      ResStream.Seek(0,soBeginning);
      fItemDefaultPics[i].LoadFromStream(ResStream);
    finally
      ResStream.Free;
    end;
  except
    fItemDefaultPics[i] := nil;
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

procedure TILDataProvider.InitializeGradientImage;
var
  ResStream:  TResourceStream;
begin
try
  ResStream := TResourceStream.Create(hinstance,'gradient',PChar(10));
  try
    fGradientImage := TBitmap.Create;
    ResStream.Seek(0,soBeginning);
    fGradientImage.LoadFromStream(ResStream);
  finally
    ResStream.Free;
  end;
except
  fItemReviewIcon := nil;
end;
end;

//------------------------------------------------------------------------------

procedure TILDataProvider.FinalieGradientImage;
begin
If Assigned(fGradientImage) then
  FreeAndNil(fGradientImage);
end;

//------------------------------------------------------------------------------

procedure TILDataProvider.Initialize;
begin
InitializeItemManufacurers;
InitializeItemReviewIcon;
InitializeItemFlagIcons;
InitializeDefaultPictures;
InitializeGradientImage;
end;

//------------------------------------------------------------------------------

procedure TILDataProvider.Finalize;
begin
FinalieGradientImage;
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