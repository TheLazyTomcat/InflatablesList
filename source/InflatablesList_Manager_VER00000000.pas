unit InflatablesList_Manager_VER00000000;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  Classes,
  AuxTypes,
  InflatablesList_Types, InflatablesList_Manager_Base;

type
  TILManager_VER00000000 = class(TILManager_Base)
  protected
    // saving/loading of data for version 0
    procedure SaveData(Stream: TStream; Struct: UInt32); override;
    procedure SaveToStream_VER00000000(Stream: TStream); virtual;
    procedure SaveSortingSettings_VER00000000(Stream: TStream); virtual;
    procedure SaveShopTemplates_VER00000000(Stream: TStream); virtual;
    procedure SaveFilterSettings_VER00000000(Stream: TStream); virtual;
    procedure SaveItem_VER00000000(Stream: TStream; Item: TILItem); virtual;
    procedure SaveItemShop_VER00000000(Stream: TStream; Shop: TILItemShop); virtual;
    procedure LoadData(Stream: TStream; Struct: UInt32); override;
    procedure LoadFromStream_VER00000000(Stream: TStream); virtual;
    procedure LoadSortingSettings_VER00000000(Stream: TStream); virtual;
    procedure LoadShopTemplates_VER00000000(Stream: TStream); virtual;
    procedure LoadFilterSettings_VER00000000(Stream: TStream); virtual;
    procedure LoadItem_VER00000000(Stream: TStream; out Item: TILItem); virtual;
    procedure LoadItemShop_VER00000000(Stream: TStream; out Shop: TILItemShop); virtual;
  end;

implementation

uses
  SysUtils, Graphics,
  BinaryStreaming;

procedure TILManager_VER00000000.SaveData(Stream: TStream; Struct: UInt32);
begin
case Struct of
  IL_LISTFILE_FILESTRUCTURE_00000000: SaveToStream_VER00000000(Stream);
else
  raise Exception.CreateFmt('TILManager_VER00000000.SaveDataToStream: Unknown stream structure (%.8x).',[Struct]);
end;
end;

//------------------------------------------------------------------------------

procedure TILManager_VER00000000.SaveToStream_VER00000000(Stream: TStream);
var
  i:  Integer;
begin
SaveSortingSettings_VER00000000(Stream);
SaveShopTemplates_VER00000000(Stream);
SaveFilterSettings_VER00000000(Stream);
// items
Stream_WriteUInt32(Stream,Length(fList));
For i := Low(fList) to High(fList) do
  SaveItem_VER00000000(Stream,fList[i]);
end;
 
//------------------------------------------------------------------------------

procedure TILManager_VER00000000.SaveSortingSettings_VER00000000(Stream: TStream);
var
  i:  Integer;
begin
Stream_WriteUInt32(Stream,fActualSortSett.Count);
For i := Low(fActualSortSett.Items) to High(fActualSortSett.Items) do
  begin
    Stream_WriteInt32(Stream,IL_ItemValueTagToNum(fActualSortSett.Items[i].ItemValueTag));
    Stream_WriteBool(Stream,fActualSortSett.Items[i].Reversed);
  end;
end;
 
//------------------------------------------------------------------------------

procedure TILManager_VER00000000.SaveShopTemplates_VER00000000(Stream: TStream);
var
  i:  Integer;
begin
Stream_WriteUInt32(Stream,Length(fShopTemplates));
For i := Low(fShopTemplates) to High(fShopTemplates) do
  begin
    Stream_WriteString(Stream,fShopTemplates[i].Name);
    SaveItemShop_VER00000000(Stream,fShopTemplates[i].ShopData);
  end;
end;
 
//------------------------------------------------------------------------------

procedure TILManager_VER00000000.SaveFilterSettings_VER00000000(Stream: TStream);
begin
Stream_WriteInt32(Stream,IL_FilterOperatorToNum(fFilterSettings.Operator));
Stream_WriteUInt32(Stream,IL_EncodeFilterFlags(fFilterSettings.Flags));
end;
 
//------------------------------------------------------------------------------

procedure TILManager_VER00000000.SaveItem_VER00000000(Stream: TStream; Item: TILItem);
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
  SaveItemShop_VER00000000(Stream,Item.Shops[i]);
end;

//------------------------------------------------------------------------------

procedure TILManager_VER00000000.SaveItemShop_VER00000000(Stream: TStream; Shop: TILItemShop);
var
  i:  Integer;

  procedure SaveParsingSettings(ParsingSettings: TILItemShopParsingSetting);
  var
    ii:  Integer;
  begin
    Stream_WriteString(Stream,ParsingSettings.MoreThanTag);
    Stream_WriteInt32(Stream,IL_AvailExtrMethodToNum(ParsingSettings.AvailExtrMethod));
    Stream_WriteInt32(Stream,IL_PriceExtrMethodToNum(ParsingSettings.PriceExtrMethod));
    // parsing stages for available pieces
    Stream_WriteUInt32(Stream,Length(ParsingSettings.AvailStages));
    For ii := Low(ParsingSettings.AvailStages) to High(ParsingSettings.AvailStages) do
      begin
        Stream_WriteString(Stream,ParsingSettings.AvailStages[ii].ElementName);
        Stream_WriteString(Stream,ParsingSettings.AvailStages[ii].AttributeName);
        Stream_WriteString(Stream,ParsingSettings.AvailStages[ii].AttributeValue);
        Stream_WriteBool(Stream,ParsingSettings.AvailStages[ii].FullTextMatch);
        Stream_WriteBool(Stream,ParsingSettings.AvailStages[ii].RecursiveSearch);
        Stream_WriteString(Stream,ParsingSettings.AvailStages[ii].Text);
      end;
    // parsing stages for price
    Stream_WriteUInt32(Stream,Length(ParsingSettings.PriceStages));
    For ii := Low(ParsingSettings.PriceStages) to High(ParsingSettings.PriceStages) do
      begin
        Stream_WriteString(Stream,ParsingSettings.PriceStages[ii].ElementName);
        Stream_WriteString(Stream,ParsingSettings.PriceStages[ii].AttributeName);
        Stream_WriteString(Stream,ParsingSettings.PriceStages[ii].AttributeValue);
        Stream_WriteBool(Stream,ParsingSettings.PriceStages[ii].FullTextMatch);
        Stream_WriteBool(Stream,ParsingSettings.PriceStages[ii].RecursiveSearch);
        Stream_WriteString(Stream,ParsingSettings.PriceStages[ii].Text);
      end;
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
SaveParsingSettings(Shop.ParsingSettings);
Stream_WriteString(Stream,Shop.LastUpdateMsg);
end;

//------------------------------------------------------------------------------

procedure TILManager_VER00000000.LoadData(Stream: TStream; Struct: UInt32);
begin
case Struct of
  IL_LISTFILE_FILESTRUCTURE_00000000: LoadFromStream_VER00000000(Stream);
else
  raise Exception.CreateFmt('TILManager_VER00000000.LoadDataFromStream: Unknown stream structure (%.8x).',[Struct]);
end;
end;

//------------------------------------------------------------------------------

procedure TILManager_VER00000000.LoadFromStream_VER00000000(Stream: TStream);
var
  i:  Integer;
begin
LoadSortingSettings_VER00000000(Stream);
LoadShopTemplates_VER00000000(Stream);
LoadFilterSettings_VER00000000(Stream);
// items
ItemClear;
SetLength(fList,Stream_ReadUInt32(Stream));
For i := Low(fList) to High(fList) do
  LoadItem_VER00000000(Stream,fList[i]);
ReIndex;
ItemRedraw;
end;

//------------------------------------------------------------------------------

procedure TILManager_VER00000000.LoadSortingSettings_VER00000000(Stream: TStream);
var
  i:  Integer;
begin
fActualSortSett.Count := Stream_ReadUInt32(Stream);
For i := Low(fActualSortSett.Items) to High(fActualSortSett.Items) do
  begin
    fActualSortSett.Items[i].ItemValueTag := IL_NumToItemValueTag(Stream_ReadInt32(Stream));
    fActualSortSett.Items[i].Reversed := Stream_ReadBool(Stream);
  end;
end;

//------------------------------------------------------------------------------

procedure TILManager_VER00000000.LoadShopTemplates_VER00000000(Stream: TStream);
var
  i:  Integer;
begin
SetLength(fShopTemplates,Stream_ReadUInt32(Stream));
For i := Low(fShopTemplates) to High(fShopTemplates) do
  begin
    fShopTemplates[i].Name := Stream_ReadString(Stream);
    LoadItemShop_VER00000000(Stream,fShopTemplates[i].ShopData);
  end;
end;

//------------------------------------------------------------------------------

procedure TILManager_VER00000000.LoadFilterSettings_VER00000000(Stream: TStream);
begin
fFilterSettings.Operator := IL_NumToFilterOperator(Stream_ReadInt32(Stream));
fFilterSettings.Flags := IL_DecodeFilterFlags(Stream_ReadUInt32(Stream));
end;

//------------------------------------------------------------------------------

procedure TILManager_VER00000000.LoadItem_VER00000000(Stream: TStream; out Item: TILItem);
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

    {$message 'remove'}
    //FreeAndNil(Pic);
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
  LoadItemShop_VER00000000(Stream,Item.Shops[i]);
// prepare render
Item.ItemListRender := TBitmap.Create;
Item.ItemListRender.PixelFormat := pf24bit;
Item.ItemListRender.Width := fRenderWidth;
Item.ItemListRender.Height := fRenderHeight;
end;

//------------------------------------------------------------------------------

procedure TILManager_VER00000000.LoadItemShop_VER00000000(Stream: TStream; out Shop: TILItemShop);
var
  i: Integer;

  procedure LoadParsingSettings(out ParsingSettings: TILItemShopParsingSetting);
  var
    ii:  Integer;
  begin
    ParsingSettings.MoreThanTag := Stream_ReadString(Stream);
    ParsingSettings.AvailExtrMethod := IL_NumToAvailExtrMethod(Stream_ReadInt32(Stream));
    ParsingSettings.PriceExtrMethod := IL_NumToPriceExtrMethod(Stream_ReadInt32(Stream));
    // parsing stages for available pieces
    SetLength(ParsingSettings.AvailStages,Stream_ReadUInt32(Stream));
    For ii := Low(ParsingSettings.AvailStages) to High(ParsingSettings.AvailStages) do
      begin
        ParsingSettings.AvailStages[ii].ElementName := Stream_ReadString(Stream);
        ParsingSettings.AvailStages[ii].AttributeName := Stream_ReadString(Stream);
        ParsingSettings.AvailStages[ii].AttributeValue := Stream_ReadString(Stream);
        ParsingSettings.AvailStages[ii].FullTextMatch := Stream_ReadBool(Stream);
        ParsingSettings.AvailStages[ii].RecursiveSearch := Stream_ReadBool(Stream);
        ParsingSettings.AvailStages[ii].Text := Stream_ReadString(Stream);
      end;
    // parsing stages for price
    SetLength(ParsingSettings.PriceStages,Stream_ReadUInt32(Stream));
    For ii := Low(ParsingSettings.PriceStages) to High(ParsingSettings.PriceStages) do
      begin
        ParsingSettings.PriceStages[ii].ElementName := Stream_ReadString(Stream);
        ParsingSettings.PriceStages[ii].AttributeName := Stream_ReadString(Stream);
        ParsingSettings.PriceStages[ii].AttributeValue := Stream_ReadString(Stream);
        ParsingSettings.PriceStages[ii].FullTextMatch := Stream_ReadBool(Stream);
        ParsingSettings.PriceStages[ii].RecursiveSearch := Stream_ReadBool(Stream);
        ParsingSettings.PriceStages[ii].Text := Stream_ReadString(Stream);
      end;
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
// parsing settings
LoadParsingSettings(Shop.ParsingSettings);
Shop.LastUpdateMsg := Stream_ReadString(Stream);
end;

end.
