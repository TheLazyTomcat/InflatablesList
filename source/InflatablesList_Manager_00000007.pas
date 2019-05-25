unit InflatablesList_Manager_00000007;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  Classes,
  AuxTypes,
  InflatablesList_Types, InflatablesList_Manager_00000006;

type
  TILManager_00000007 = class(TILManager_00000006)
  protected
    procedure InitSaveFunctions(Struct: UInt32); override;
    procedure InitLoadFunctions(Struct: UInt32); override;
    procedure SaveItem_00000007(Stream: TStream; const Item: TILItem); virtual;
    procedure LoadItem_00000007(Stream: TStream; out Item: TILItem); virtual;
  end;

implementation

uses
  SysUtils, Graphics,
  BinaryStreaming,
  InflatablesList_Manager_IO;

procedure TILManager_00000007.InitSaveFunctions(Struct: UInt32);
begin
case Struct of
  IL_LISTFILE_FILESTRUCTURE_00000007:
    begin
      fFNSaveToStream := SaveToStream_00000002;
      fFNSaveSortingSettings := SaveSortingSettings_00000001;
      fFNSaveShopTemplates := SaveShopTemplates_00000000;
      fFNSaveFilterSettings := SaveFilterSettings_00000000;
      fFNSaveItem := SaveItem_00000007;
      fFNSaveItemShop := SaveItemShop_00000006;
      fFNSaveParsingSettings := SaveParsingSettings_00000003;
      fFNExportShopTemplate := SaveShopTemplate_00000002;
    end;
else
  inherited InitSaveFunctions(Struct);
end;
end;

//------------------------------------------------------------------------------

procedure TILManager_00000007.InitLoadFunctions(Struct: UInt32);
begin
case Struct of
  IL_LISTFILE_FILESTRUCTURE_00000007:
    begin
      fFNLoadFromStream := LoadFromStream_00000002;
      fFNLoadSortingSettings := LoadSortingSettings_00000001;
      fFNLoadShopTemplates := LoadShopTemplates_00000000;
      fFNLoadFilterSettings := LoadFilterSettings_00000000;
      fFNLoadItem := LoadItem_00000007;
      fFNLoadItemShop := LoadItemShop_00000006;
      fFNLoadParsingSettings := LoadParsingSettings_00000003;
      fFNImportShopTemplate := LoadShopTemplate_00000002;
    end;
else
  inherited InitLoadFunctions(Struct);
end;
end;

//------------------------------------------------------------------------------

procedure TILManager_00000007.SaveItem_00000007(Stream: TStream; const Item: TILItem);
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
// shop avail and prices
Stream_WriteUInt32(Stream,Item.UnitPriceLowest);
Stream_WriteUInt32(Stream,Item.UnitPriceHighest);
Stream_WriteUInt32(Stream,Item.UnitPriceSelected);
Stream_WriteInt32(Stream,Item.AvailableLowest);
Stream_WriteInt32(Stream,Item.AvailableHighest);
Stream_WriteInt32(Stream,Item.AvailableSelected);
// shops
Stream_WriteUInt32(Stream,Length(Item.Shops));
For i := Low(Item.Shops) to High(Item.Shops) do
  fFNSaveItemShop(Stream,Item.Shops[i]);
end;

//------------------------------------------------------------------------------

procedure TILManager_00000007.LoadItem_00000007(Stream: TStream; out Item: TILItem);
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
ItemInitialize(Item);
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
// shop avail and prices
Item.UnitPriceLowest := Stream_ReadUInt32(Stream);
Item.UnitPriceHighest := Stream_ReadUInt32(Stream);
Item.UnitPriceSelected := Stream_ReadUInt32(Stream);
Item.AvailableLowest := Stream_ReadInt32(Stream);
Item.AvailableHighest := Stream_ReadInt32(Stream);
Item.AvailableSelected := Stream_ReadInt32(Stream);
// shops
SetLength(Item.Shops,Stream_ReadUInt32(Stream));
For i := Low(Item.Shops) to High(Item.Shops) do
  fFNLoadItemShop(Stream,Item.Shops[i]);
// internals
ItemInitInternals(Item);
end;

end.
