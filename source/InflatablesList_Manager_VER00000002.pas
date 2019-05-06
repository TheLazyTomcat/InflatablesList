unit InflatablesList_Manager_VER00000002;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  Classes,
  AuxTypes,
  InflatablesList_Types, InflatablesList_Manager_VER00000001;

type
  TILManager_VER00000002 = class(TILManager_VER00000001)
  protected
    procedure SaveData(Stream: TStream; Struct: UInt32); override;
    procedure SaveToStream_VER00000002(Stream: TStream); virtual;
    procedure SaveShopTemplates_VER00000002(Stream: TStream); virtual;
    procedure SaveItem_VER00000002(Stream: TStream; Item: TILItem); virtual;
    procedure SaveItemShop_VER00000002(Stream: TStream; Shop: TILItemShop); virtual;
    procedure LoadData(Stream: TStream; Struct: UInt32); override;
    procedure LoadFromStream_VER00000002(Stream: TStream); virtual;
    procedure LoadShopTemplates_VER00000002(Stream: TStream); virtual;
    procedure LoadItem_VER00000002(Stream: TStream; out Item: TILItem); virtual;
    procedure LoadItemShop_VER00000002(Stream: TStream; out Shop: TILItemShop); virtual;
  end;

implementation

uses
  SysUtils, Graphics,
  BinaryStreaming,
  InflatablesList_Manager_Base,
  InflatablesList_HTML_ElementFinder;

procedure TILManager_VER00000002.SaveData(Stream: TStream; Struct: UInt32);
begin
case Struct of
  IL_LISTFILE_FILESTRUCTURE_00000002: SaveToStream_VER00000002(Stream);
else
  inherited SaveData(Stream,Struct);
end;
end;

//------------------------------------------------------------------------------

procedure TILManager_VER00000002.SaveToStream_VER00000002(Stream: TStream);
var
  i:  Integer;
begin
// save some technical info
Stream_WriteString(Stream,FormatDateTime('yyyy-mm-dd-hh-nn-ss-zzz',Now));
SaveSortingSettings_VER00000001(Stream);
SaveShopTemplates_VER00000002(Stream);
SaveFilterSettings_VER00000000(Stream);
// items
Stream_WriteUInt32(Stream,Length(fList));
For i := Low(fList) to High(fList) do
  SaveItem_VER00000002(Stream,fList[i]);
end;

//------------------------------------------------------------------------------

procedure TILManager_VER00000002.SaveShopTemplates_VER00000002(Stream: TStream);
var
  i:  Integer;
begin
Stream_WriteUInt32(Stream,Length(fShopTemplates));
For i := Low(fShopTemplates) to High(fShopTemplates) do
  begin
    Stream_WriteString(Stream,fShopTemplates[i].Name);
    SaveItemShop_VER00000002(Stream,fShopTemplates[i].ShopData);
  end;
end;

//------------------------------------------------------------------------------

procedure TILManager_VER00000002.SaveItem_VER00000002(Stream: TStream; Item: TILItem);
var
  i:  Integer;

  procedure WritePicture(Pic: TBitmap);
  var
    TempStream: TMemoryStream;
  begin
    If Assigned(Pic) then
      begin
        TempStream := TMemoryStream.Create;
        try
          Pic.SaveToStream(TempStream);
          Stream_WriteUInt32(Stream,TempStream.Size);
          Stream.CopyFrom(TempStream,0);
        finally
          TempStream.Free;
        end;
      end
    else Stream_WriteUInt32(Stream,0);
  end;

begin
Stream_WriteFloat64(Stream,Item.TimeOfAddition);
// pictures
WritePicture(Item.MainPicture);
WritePicture(Item.PackagePicture);
// basic specs
Stream_WriteInt32(Stream,IL_ItemTypeToNum(Item.ItemType));
Stream_WriteString(Stream,Item.ItemTypeSpec);
Stream_WriteUInt32(Stream,Item.Count);
Stream_WriteInt32(Stream,IL_ItemManufacturerToNum(Item.Manufacturer));
Stream_WriteString(Stream,Item.ManufacturerStr);
Stream_WriteInt32(Stream,Item.ID);
// flags
Stream_WriteUInt32(Stream,IL_EncodeItemFlags(Item.Flags));
Stream_WriteString(Stream,Item.TextTag);
// extended specs
Stream_WriteUInt32(Stream,Item.WantedLevel);
Stream_WriteString(Stream,Item.Variant);
Stream_WriteUInt32(Stream,Item.SizeX);
Stream_WriteUInt32(Stream,Item.SizeY);
Stream_WriteUInt32(Stream,Item.SizeZ);
Stream_WriteUInt32(Stream,Item.UnitWeight);
// others
Stream_WriteString(Stream,Item.Notes);
Stream_WriteString(Stream,Item.ReviewURL);
Stream_WriteString(Stream,Item.MainPictureFile);
Stream_WriteString(Stream,Item.PackagePictureFile);
Stream_WriteUInt32(Stream,Item.UnitPriceDefault);
Stream_WriteUInt32(Stream,Item.UnitPriceLowest);
Stream_WriteUInt32(Stream,Item.UnitPriceSelected);
Stream_WriteInt32(Stream,Item.AvailablePieces);
// shops
Stream_WriteUInt32(Stream,Length(Item.Shops));
For i := Low(Item.Shops) to High(Item.Shops) do
  SaveItemShop_VER00000002(Stream,Item.Shops[i]);
end;

//------------------------------------------------------------------------------

procedure TILManager_VER00000002.SaveItemShop_VER00000002(Stream: TStream; Shop: TILItemShop);
var
  i:  Integer;

  procedure SaveParsingSettings(ParsingSettings: TILItemShopParsingSetting);
  var
    ii: Integer;
  begin
    // variables
    For ii := Low(ParsingSettings.Variables.Vars) to High(ParsingSettings.Variables.Vars) do
      Stream_WriteString(Stream,ParsingSettings.Variables.Vars[ii]);
    // available
    Stream_WriteUInt32(Stream,Length(ParsingSettings.Available.Extraction));
    For ii := Low(ParsingSettings.Available.Extraction) to High(ParsingSettings.Available.Extraction) do
      begin
        Stream_WriteInt32(Stream,IL_ExtractFromToNum(ParsingSettings.Available.Extraction[ii].ExtractFrom));
        Stream_WriteInt32(Stream,IL_ExtrMethodToNum(ParsingSettings.Available.Extraction[ii].ExtractionMethod));
        Stream_WriteString(Stream,ParsingSettings.Available.Extraction[ii].ExtractionData);
        Stream_WriteString(Stream,ParsingSettings.Available.Extraction[ii].NegativeTag);
      end;
    TILElementFinder(ParsingSettings.Available.Finder).SaveToStream(Stream);
    // price
    Stream_WriteUInt32(Stream,Length(ParsingSettings.Price.Extraction));
    For ii := Low(ParsingSettings.Price.Extraction) to High(ParsingSettings.Price.Extraction) do
      begin
        Stream_WriteInt32(Stream,IL_ExtractFromToNum(ParsingSettings.Price.Extraction[ii].ExtractFrom));
        Stream_WriteInt32(Stream,IL_ExtrMethodToNum(ParsingSettings.Price.Extraction[ii].ExtractionMethod));
        Stream_WriteString(Stream,ParsingSettings.Price.Extraction[ii].ExtractionData);
        Stream_WriteString(Stream,ParsingSettings.Price.Extraction[ii].NegativeTag);
      end;
    TILElementFinder(ParsingSettings.Price.Finder).SaveToStream(Stream);
  end;

begin
Stream_WriteBool(Stream,Shop.Selected);
Stream_WriteString(Stream,Shop.Name);
Stream_WriteString(Stream,Shop.ShopURL);
Stream_WriteString(Stream,Shop.ItemURL);
Stream_WriteInt32(Stream,Shop.Available);
Stream_WriteUInt32(Stream,Shop.Price);
// avail history
Stream_WriteUInt32(Stream,Length(Shop.AvailHistory));
For i := Low(Shop.AvailHistory) to High(Shop.AvailHistory) do
  begin
    Stream_WriteInt32(Stream,Shop.AvailHistory[i].Value);
    Stream_WriteFloat64(Stream,Shop.AvailHistory[i].Time);
  end;
// price history
Stream_WriteUInt32(Stream,Length(Shop.PriceHistory));
For i := Low(Shop.PriceHistory) to High(Shop.PriceHistory) do
  begin
    Stream_WriteInt32(Stream,Shop.PriceHistory[i].Value);
    Stream_WriteFloat64(Stream,Shop.PriceHistory[i].Time);
  end;
// parsing settings
Stream_WriteString(Stream,Shop.Notes);
SaveParsingSettings(Shop.ParsingSettings);
Stream_WriteString(Stream,Shop.LastUpdateMsg);
end;

//------------------------------------------------------------------------------

procedure TILManager_VER00000002.LoadData(Stream: TStream; Struct: UInt32);
begin
case Struct of
  IL_LISTFILE_FILESTRUCTURE_00000002: LoadFromStream_VER00000002(Stream);
else
  inherited LoadData(Stream,Struct);
end;
end;

//------------------------------------------------------------------------------

procedure TILManager_VER00000002.LoadFromStream_VER00000002(Stream: TStream);
var
  i:  Integer;
begin
Stream_ReadString(Stream);
LoadSortingSettings_VER00000001(Stream);
LoadShopTemplates_VER00000002(Stream);
LoadFilterSettings_VER00000000(Stream);
// items
ItemClear;
SetLength(fList,Stream_ReadUInt32(Stream));
For i := Low(fList) to High(fList) do
  LoadItem_VER00000002(Stream,fList[i]);
ReIndex;
ItemRedraw;
end;

//------------------------------------------------------------------------------

procedure TILManager_VER00000002.LoadShopTemplates_VER00000002(Stream: TStream);
var
  i:  Integer;
begin
SetLength(fShopTemplates,Stream_ReadUInt32(Stream));
For i := Low(fShopTemplates) to High(fShopTemplates) do
  begin
    fShopTemplates[i].Name := Stream_ReadString(Stream);
    LoadItemShop_VER00000002(Stream,fShopTemplates[i].ShopData);
  end;
end;

//------------------------------------------------------------------------------

procedure TILManager_VER00000002.LoadItem_VER00000002(Stream: TStream; out Item: TILItem);
var
  i:  Integer;

  procedure ReadPicture(var Pic: TBitmap);
  var
    Size:       UInt32;
    TempStream: TMemoryStream;
  begin
    Size := Stream_ReadUInt32(Stream);
    If Size > 0 then
      begin
        TempStream := TMemoryStream.Create;
        try
          TempStream.CopyFrom(Stream,Size);
          TempStream.Seek(0,soBeginning);
          Pic := TBitmap.Create;
          try
            Pic.LoadFromStream(TempStream);
          except
            FreeAndNil(Pic);
          end;
        finally
          TempStream.Free;
        end;
      end
    else Pic := nil;
  end;

begin
Item.TimeOfAddition := TDateTime(Stream_ReadFloat64(Stream));
// pictures
ReadPicture(Item.MainPicture);
ReadPicture(Item.PackagePicture);
// basic specs
Item.ItemType := IL_NumToItemType(Stream_ReadInt32(Stream));
Item.ItemTypeSpec := Stream_ReadString(Stream);
Item.Count := Stream_ReadUInt32(Stream);
Item.Manufacturer := IL_NumToItemManufacturer(Stream_ReadInt32(Stream));
Item.ManufacturerStr := Stream_ReadString(Stream);
Item.ID := Stream_ReadInt32(Stream);
// flags
Item.Flags := IL_DecodeItemFlags(Stream_ReadUInt32(Stream));
Item.TextTag := Stream_ReadString(Stream);
// extended specs
Item.WantedLevel := Stream_ReadUInt32(Stream);
Item.Variant := Stream_ReadString(Stream);
Item.SizeX := Stream_ReadUInt32(Stream);
Item.SizeY := Stream_ReadUInt32(Stream);
Item.SizeZ := Stream_ReadUInt32(Stream);
Item.UnitWeight := Stream_ReadUInt32(Stream);
// other info
Item.Notes := Stream_ReadString(Stream);
Item.ReviewURL := Stream_ReadString(Stream);
Item.MainPictureFile := Stream_ReadString(Stream);
Item.PackagePictureFile := Stream_ReadString(Stream);
Item.UnitPriceDefault := Stream_ReadUInt32(Stream);
Item.UnitPriceLowest := Stream_ReadUInt32(Stream);
Item.UnitPriceSelected := Stream_ReadUInt32(Stream);
Item.AvailablePieces := Stream_ReadInt32(Stream);
// shops
SetLength(Item.Shops,Stream_ReadUInt32(Stream));
For i := Low(Item.Shops) to High(Item.Shops) do
  LoadItemShop_VER00000002(Stream,Item.Shops[i]);
// prepare render
Item.ItemListRender := TBitmap.Create;
Item.ItemListRender.PixelFormat := pf24bit;
Item.ItemListRender.Width := fRenderWidth;
Item.ItemListRender.Height := fRenderHeight;
end;

//------------------------------------------------------------------------------

procedure TILManager_VER00000002.LoadItemShop_VER00000002(Stream: TStream; out Shop: TILItemShop);
var
  i: Integer;

  procedure LoadParsingSettings(out ParsingSettings: TILItemShopParsingSetting);
  var
    ii: Integer;
  begin
    // variables
    For ii := Low(ParsingSettings.Variables.Vars) to High(ParsingSettings.Variables.Vars) do
      ParsingSettings.Variables.Vars[ii] := Stream_ReadString(Stream);
    // available
    SetLength(ParsingSettings.Available.Extraction,Stream_ReadUInt32(Stream));
    For ii := Low(ParsingSettings.Available.Extraction) to High(ParsingSettings.Available.Extraction) do
      begin
        ParsingSettings.Available.Extraction[ii].ExtractFrom := IL_NumToExtractFrom(Stream_ReadInt32(Stream));
        ParsingSettings.Available.Extraction[ii].ExtractionMethod := IL_NumToExtrMethod(Stream_ReadInt32(Stream));
        ParsingSettings.Available.Extraction[ii].ExtractionData := Stream_ReadString(Stream);
        ParsingSettings.Available.Extraction[ii].NegativeTag := Stream_ReadString(Stream);
      end;
    ParsingSettings.Available.Finder := TILElementFinder.Create;
    TILElementFinder(ParsingSettings.Available.Finder).LoadFromStream(Stream);
    // price
    SetLength(ParsingSettings.Price.Extraction,Stream_ReadUInt32(Stream));
    For ii := Low(ParsingSettings.Price.Extraction) to High(ParsingSettings.Price.Extraction) do
      begin
        ParsingSettings.Price.Extraction[ii].ExtractFrom := IL_NumToExtractFrom(Stream_ReadInt32(Stream));
        ParsingSettings.Price.Extraction[ii].ExtractionMethod := IL_NumToExtrMethod(Stream_ReadInt32(Stream));
        ParsingSettings.Price.Extraction[ii].ExtractionData := Stream_ReadString(Stream);
        ParsingSettings.Price.Extraction[ii].NegativeTag := Stream_ReadString(Stream);
      end;
    ParsingSettings.Price.Finder := TILElementFinder.Create;
    TILElementFinder(ParsingSettings.Price.Finder).LoadFromStream(Stream);
  end;

begin
Shop.Selected := Stream_ReadBool(Stream);
Shop.Name := Stream_ReadString(Stream);
Shop.ShopURL := Stream_ReadString(Stream);
Shop.ItemURL := Stream_ReadString(Stream);
Shop.Available := Stream_ReadInt32(Stream);
Shop.Price := Stream_ReadUInt32(Stream);
// avail history
SetLength(Shop.AvailHistory,Stream_ReadUInt32(Stream));
For i := Low(Shop.AvailHistory) to High(Shop.AvailHistory) do
  begin
    Shop.AvailHistory[i].Value := Stream_ReadInt32(Stream);
    Shop.AvailHistory[i].Time := Stream_ReadFloat64(Stream);
  end;
// price history
SetLength(Shop.PriceHistory,Stream_ReadUInt32(Stream));
For i := Low(Shop.PriceHistory) to High(Shop.PriceHistory) do
  begin
    Shop.PriceHistory[i].Value := Stream_ReadInt32(Stream);
    Shop.PriceHistory[i].Time := Stream_ReadFloat64(Stream);
  end;
Shop.Notes := Stream_ReadString(Stream);
// parsing settings
LoadParsingSettings(Shop.ParsingSettings);
Shop.LastUpdateMsg := Stream_ReadString(Stream);
end;

end.
