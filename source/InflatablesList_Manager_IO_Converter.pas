unit InflatablesList_Manager_IO_Converter;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  Classes,
  AuxTypes,
  InflatablesList_Manager_IO;

type
  TILManager_IO_Converter = class(TILManager_IO)
  protected
    fConvertStream: TMemoryStream;
    procedure Convert_7_to_8_SortSett(Stream: TStream); virtual;
    procedure Convert_7_to_8_ShopTempl(Stream: TStream); virtual;
    procedure Convert_7_to_8_FilterSett(Stream: TStream); virtual;
    procedure Convert_7_to_8_Items(Stream: TStream); virtual;
    procedure Convert_7_to_8_Item(Stream: TStream); virtual;
    procedure Convert_7_to_8_Shop(Stream: TStream); virtual;
    procedure Convert_7_to_8_ParsSett(Stream: TStream); virtual;
    procedure Convert_7_to_8(Stream: TStream); override;
  end;

implementation

uses
  SysUtils,
  BinaryStreaming, MemoryBuffer,
  InflatablesList_Types,
  InflatablesList_HTML_ElementFinder,
  InflatablesList_Item_IO,
  InflatablesList_ItemShop_IO,
  InflatablesList_ItemShopParsingSettings_IO,
  InflatablesList_ItemShopTemplate_IO;

procedure TILManager_IO_Converter.Convert_7_to_8_SortSett(Stream: TStream);
var
  Cntr: UInt32;
  i:    Integer;

  procedure ConvertSortingSettings;
  var
    ii: Integer;
  begin
    Stream_WriteUInt32(fConvertStream,Stream_ReadUInt32(Stream));
    For ii := 0 to 29 do 
      begin
        Stream_WriteInt32(fConvertStream,Stream_ReadInt32(Stream));
        Stream_WriteBool(fConvertStream,Stream_ReadBool(Stream));
      end;
  end;

begin
Stream_WriteString(fConvertStream,'SORT');
// data itself are the same, do plain copy...
// reversed flag
Stream_WriteBool(fConvertStream,Stream_ReadBool(Stream));
// actual sort settings
ConvertSortingSettings;
// sorting profiles
Cntr := Stream_ReadUInt32(Stream);
Stream_WriteUInt32(fConvertStream,Cntr);
For i := 0 to Pred(Cntr) do
  begin
    Stream_WriteString(fConvertStream,Stream_ReadString(Stream));
    ConvertSortingSettings;
  end;
end;

//------------------------------------------------------------------------------

procedure TILManager_IO_Converter.Convert_7_to_8_ShopTempl(Stream: TStream);
var
  Cntr:           UInt32;
  i:              Integer;
  // temps
  Untracked:      Boolean;
  AltDownMethod:  Boolean;
  HistCntr:       UInt32;
  HistIter:       Integer;
begin
Stream_WriteString(fConvertStream,'TEMPLATES');
Cntr := Stream_ReadUInt32(Stream);
Stream_WriteUInt32(fConvertStream,Cntr);
For i := 0 to Pred(Cntr) do
  begin
    Stream_WriteUInt32(fConvertStream,IL_SHOPTEMPLATE_SIGNATURE);
    Stream_WriteUInt32(fConvertStream,IL_SHOPTEMPLATE_STREAMSTRUCTURE_00000000);
    // data
    Stream_WriteString(fConvertStream,Stream_ReadString(Stream)); // template name
    Stream_ReadBool(Stream);                                      // * selected
    Untracked := Stream_ReadBool(Stream);                         // > untracked
    AltDownMethod := Stream_ReadBool(Stream);                     // > alternative download method
    Stream_WriteString(fConvertStream,Stream_ReadString(Stream)); // shop name
    Stream_WriteBool(fConvertStream,Untracked);                   // < untracked
    Stream_WriteBool(fConvertStream,AltDownMethod);               // < alternative download method
    Stream_WriteString(fConvertStream,Stream_ReadString(Stream)); // shop URL
    Stream_ReadString(Stream);                                    // * item URL
    Stream_ReadInt32(Stream);                                     // * available
    Stream_ReadUInt32(Stream);                                    // * price
    // * avail history
    HistCntr := Stream_ReadUInt32(Stream);
    For HistIter := 0 to Pred(HistCntr) do
      begin
        Stream_ReadInt32(Stream);
        Stream_ReadFloat64(Stream);
      end;
    // * price history
    HistCntr := Stream_ReadUInt32(Stream);
    For HistIter := 0 to Pred(HistCntr) do
      begin
        Stream_ReadInt32(Stream);
        Stream_ReadFloat64(Stream);
      end;
    Stream_ReadString(Stream);        // * notes
    // parsing settings
    Convert_7_to_8_ParsSett(Stream);
    Stream_ReadInt32(Stream);         // * last update result
    Stream_ReadString(Stream);        // * last update message
  end;
end;

//------------------------------------------------------------------------------

procedure TILManager_IO_Converter.Convert_7_to_8_FilterSett(Stream: TStream);
begin
Stream_WriteString(fConvertStream,'FILTER');
Stream_WriteInt32(fConvertStream,Stream_ReadInt32(Stream));   // Operator
Stream_WriteUInt32(fConvertStream,Stream_ReadUInt32(Stream)); // Flags
end;

//------------------------------------------------------------------------------

procedure TILManager_IO_Converter.Convert_7_to_8_Items(Stream: TStream);
var
  Cntr: UInt32;
  i:    Integer;
begin
Stream_WriteString(fConvertStream,'ITEMS');
Cntr := Stream_ReadUInt32(Stream);
Stream_WriteUInt32(fConvertStream,Cntr);
For i := 0 to Pred(Cntr) do
  Convert_7_to_8_Item(Stream);
end;

//------------------------------------------------------------------------------

procedure TILManager_IO_Converter.Convert_7_to_8_Item(Stream: TStream);
var
  Cntr: UInt32;
  Buff: TMemoryBuffer;
  i:    Integer;
begin
Stream_WriteUInt32(fConvertStream,IL_ITEM_SIGNATURE);
Stream_WriteUInt32(fConvertStream,IL_ITEM_STREAMSTRUCTURE_00000000);
// data
Stream_WriteFloat64(fConvertStream,Stream_ReadFloat64(Stream));   // TimeOfAddition
// pictures...
// item
Cntr := Stream_ReadUInt32(Stream);
Stream_WriteUInt32(fConvertStream,Cntr);
If Cntr > 0 then
  begin
    GetBuffer(Buff,Cntr);
    try
      Stream_ReadBuffer(Stream,Buff.Memory^,Buff.Size);
      Stream_WriteBuffer(fConvertStream,Buff.Memory^,Buff.Size);
    finally
      FreeBuffer(Buff);
    end;
  end;
// package
Cntr := Stream_ReadUInt32(Stream);
Stream_WriteUInt32(fConvertStream,Cntr);
If Cntr > 0 then
  begin
    GetBuffer(Buff,Cntr);
    try
      Stream_ReadBuffer(Stream,Buff.Memory^,Buff.Size);
      Stream_WriteBuffer(fConvertStream,Buff.Memory^,Buff.Size);
    finally
      FreeBuffer(Buff);
    end;
  end;
// basic specs
Stream_WriteInt32(fConvertStream,Stream_ReadInt32(Stream));   // ItemType
Stream_WriteString(fConvertStream,Stream_ReadString(Stream)); // ItemTypeSpec
Stream_WriteUInt32(fConvertStream,Stream_ReadUInt32(Stream)); // Pieces
Stream_WriteInt32(fConvertStream,Stream_ReadInt32(Stream));   // Manufacturer
Stream_WriteString(fConvertStream,Stream_ReadString(Stream)); // ManufacturerStr
Stream_WriteInt32(fConvertStream,Stream_ReadInt32(Stream));   // ID
// flags
Stream_WriteUInt32(fConvertStream,Stream_ReadUInt32(Stream)); // Flags
Stream_WriteString(fConvertStream,Stream_ReadString(Stream)); // TextTag
// extended specs
Stream_WriteUInt32(fConvertStream,Stream_ReadUInt32(Stream)); // WantedLevel
Stream_WriteString(fConvertStream,Stream_ReadString(Stream)); // Variant
Stream_WriteUInt32(fConvertStream,Stream_ReadUInt32(Stream)); // SizeX
Stream_WriteUInt32(fConvertStream,Stream_ReadUInt32(Stream)); // SizeY
Stream_WriteUInt32(fConvertStream,Stream_ReadUInt32(Stream)); // SizeZ
Stream_WriteUInt32(fConvertStream,Stream_ReadUInt32(Stream)); // UnitWeight
// others
Stream_WriteString(fConvertStream,Stream_ReadString(Stream)); // Notes
Stream_WriteString(fConvertStream,Stream_ReadString(Stream)); // ReviewURL
Stream_WriteString(fConvertStream,Stream_ReadString(Stream)); // ItemPictureFile
Stream_WriteString(fConvertStream,Stream_ReadString(Stream)); // PackagePictureFile
Stream_WriteUInt32(fConvertStream,Stream_ReadUInt32(Stream)); // UnitPriceDefault
// avail and prices
Stream_WriteUInt32(fConvertStream,Stream_ReadUInt32(Stream)); // UnitPriceLowest
Stream_WriteUInt32(fConvertStream,Stream_ReadUInt32(Stream)); // UnitPriceHighest
Stream_WriteUInt32(fConvertStream,Stream_ReadUInt32(Stream)); // UnitPriceSelected
Stream_WriteInt32(fConvertStream,Stream_ReadInt32(Stream));   // AvailableLowest
Stream_WriteInt32(fConvertStream,Stream_ReadInt32(Stream));   // AvailableHighest
Stream_WriteInt32(fConvertStream,Stream_ReadInt32(Stream));   // AvailableSelected
// shops
Cntr := Stream_ReadUInt32(Stream);
Stream_WriteUInt32(fConvertStream,Cntr);
For i := 0 to Pred(Cntr) do
  Convert_7_to_8_Shop(Stream);
end;

//------------------------------------------------------------------------------

procedure TILManager_IO_Converter.Convert_7_to_8_Shop(Stream: TStream);
var
  Cntr: UInt32;
  i:    Integer;
begin
Stream_WriteUInt32(fConvertStream,IL_ITEMSHOP_SIGNATURE);
Stream_WriteUInt32(fConvertStream,IL_ITEMSHOP_STREAMSTRUCTURE_00000000);
// data
Stream_WriteBool(fConvertStream,Stream_ReadBool(Stream));     // Selected
Stream_WriteBool(fConvertStream,Stream_ReadBool(Stream));     // Untracked
Stream_WriteBool(fConvertStream,Stream_ReadBool(Stream));     // AltDownMethod
Stream_WriteString(fConvertStream,Stream_ReadString(Stream)); // Name
Stream_WriteString(fConvertStream,Stream_ReadString(Stream)); // ShopURL
Stream_WriteString(fConvertStream,Stream_ReadString(Stream)); // ItemURL
Stream_WriteInt32(fConvertStream,Stream_ReadInt32(Stream));   // Available
Stream_WriteUInt32(fConvertStream,Stream_ReadUInt32(Stream)); // Price
// avail history
Cntr := Stream_ReadUInt32(Stream);
Stream_WriteUInt32(fConvertStream,Cntr);
For i := 0 to Pred(Cntr) do
  begin
    Stream_WriteInt32(fConvertStream,Stream_ReadInt32(Stream));     // Value
    Stream_WriteFloat64(fConvertStream,Stream_ReadFloat64(Stream)); // Time
  end;
// price history
Cntr := Stream_ReadUInt32(Stream);
Stream_WriteUInt32(fConvertStream,Cntr);
For i := 0 to Pred(Cntr) do
  begin
    Stream_WriteInt32(fConvertStream,Stream_ReadInt32(Stream));     // Value
    Stream_WriteFloat64(fConvertStream,Stream_ReadFloat64(Stream)); // Time
  end;
Stream_WriteString(fConvertStream,Stream_ReadString(Stream)); // Notes
Convert_7_to_8_ParsSett(Stream);
Stream_WriteInt32(fConvertStream,Stream_ReadInt32(Stream));   // LastUpdateRes
Stream_WriteString(fConvertStream,Stream_ReadString(Stream)); // LastUpdateMsg
end;

//------------------------------------------------------------------------------

procedure TILManager_IO_Converter.Convert_7_to_8_ParsSett(Stream: TStream);
var
  i:      Integer;
  Cntr:   UInt32;
  Finder: TILElementFinder;
begin
Stream_WriteUInt32(fConvertStream,IL_SHOPPARSSETT_SIGNATURE);
Stream_WriteUInt32(fConvertStream,IL_SHOPPARSSETT_STREAMSTRUCTURE_00000000);
// data (structure is the same as in 7)
// variables
For i := Low(PILItemShopParsingVariables(nil).Vars) to High(PILItemShopParsingVariables(nil).Vars) do
  Stream_WriteString(fConvertStream,Stream_ReadString(Stream));
Stream_WriteString(fConvertStream,Stream_ReadString(Stream));     // template reference
Stream_WriteBool(fConvertStream,Stream_ReadBool(Stream));         // disable parsing errors
// available
Cntr := Stream_ReadUInt32(Stream);
Stream_WriteUInt32(fConvertStream,Cntr);
For i := 0 to Pred(Cntr) do
  begin
    Stream_WriteInt32(fConvertStream,Stream_ReadInt32(Stream));   // ExtractFrom
    Stream_WriteInt32(fConvertStream,Stream_ReadInt32(Stream));   // ExtractionMethod
    Stream_WriteString(fConvertStream,Stream_ReadString(Stream)); // ExtractionData
    Stream_WriteString(fConvertStream,Stream_ReadString(Stream)); // NegativeTag
  end;
Finder := TILElementFinder.Create;
try
  Finder.LoadFromStream(Stream);
  Finder.SaveToStream(fConvertStream);
finally
  FreeAndNil(Finder);
end;
// price
Cntr := Stream_ReadUInt32(Stream);
Stream_WriteUInt32(fConvertStream,Cntr);
For i := 0 to Pred(Cntr) do
  begin
    Stream_WriteInt32(fConvertStream,Stream_ReadInt32(Stream));   // ExtractFrom
    Stream_WriteInt32(fConvertStream,Stream_ReadInt32(Stream));   // ExtractionMethod
    Stream_WriteString(fConvertStream,Stream_ReadString(Stream)); // ExtractionData
    Stream_WriteString(fConvertStream,Stream_ReadString(Stream)); // NegativeTag
  end;
Finder := TILElementFinder.Create;
try
  Finder.LoadFromStream(Stream);
  Finder.SaveToStream(fConvertStream);
finally
  FreeAndNil(Finder);
end;  
end;

//------------------------------------------------------------------------------

procedure TILManager_IO_Converter.Convert_7_to_8(Stream: TStream);
var
  StartPos: Int64;
begin
// at this point, stream position is just after structure selection
fConvertStream := TMemoryStream.Create;
try
  fConvertStream.Size := Stream.Size;
  fConvertStream.Seek(0,soBeginning);
  StartPos := Stream.Position;
  try
    Stream_WriteString(fConvertStream,Stream_ReadString(Stream)); // time
    Convert_7_to_8_SortSett(Stream);
    Convert_7_to_8_ShopTempl(Stream);
    Convert_7_to_8_FilterSett(Stream);
    Convert_7_to_8_Items(Stream);
    Stream.Seek(StartPos,soBeginning);
    Stream.CopyFrom(fConvertStream,0);
    Stream.Size := StartPos + fConvertStream.Size;
  finally
    Stream.Seek(StartPos,soBeginning);
  end;
finally
  fConvertStream.Free;
end;
end;

end.
