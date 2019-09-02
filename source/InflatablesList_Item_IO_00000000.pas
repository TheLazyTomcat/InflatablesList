unit InflatablesList_Item_IO_00000000;
{$message 'll_rework'}

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  Classes, Graphics,
  AuxTypes,
  InflatablesList_Item_IO;

type
  TILItem_IO_00000000 = class(TILItem_IO)
  protected
    procedure InitSaveFunctions(Struct: UInt32); override;
    procedure InitLoadFunctions(Struct: UInt32); override;
    procedure SaveItem_00000000(Stream: TStream); virtual;
    procedure LoadItem_00000000(Stream: TStream); virtual;
    procedure SavePicture_00000000(Stream: TStream; Pic: TBitmap); virtual;
    procedure LoadPicture_00000000(Stream: TStream; out Pic: TBitmap); virtual;
  end;

implementation

uses
  SysUtils,
  BinaryStreaming,
  InflatablesList_Types,
  InflatablesList_ItemShop;

procedure TILItem_IO_00000000.InitSaveFunctions(Struct: UInt32);
begin
If Struct = IL_ITEM_STREAMSTRUCTURE_00000000 then
  begin
    fFNSaveToStream := SaveItem_00000000;
    fFNSavePicture := SavePicture_00000000;
  end
else raise Exception.CreateFmt('TILItem_IO_00000000.InitSaveFunctions: Invalid stream structure (%.8x).',[Struct]);
end;

//------------------------------------------------------------------------------

procedure TILItem_IO_00000000.InitLoadFunctions(Struct: UInt32);
begin
If Struct = IL_ITEM_STREAMSTRUCTURE_00000000 then
  begin
    fFNLoadFromStream := LoadItem_00000000;
    fFNLoadPicture := LoadPicture_00000000;
  end
else raise Exception.CreateFmt('TILItem_IO_00000000.InitLoadFunctions: Invalid stream structure (%.8x).',[Struct]);
end;

//------------------------------------------------------------------------------

procedure TILItem_IO_00000000.SaveItem_00000000(Stream: TStream);
var
  i:  Integer;
begin
Stream_WriteFloat64(Stream,fTimeOfAddition);
// pictures
SavePicture_00000000(Stream,fItemPicture);
SavePicture_00000000(Stream,fPackagePicture);
// basic specs
Stream_WriteInt32(Stream,IL_ItemTypeToNum(fItemType));
Stream_WriteString(Stream,fItemTypeSpec);
Stream_WriteUInt32(Stream,fPieces);
Stream_WriteInt32(Stream,IL_ItemManufacturerToNum(fManufacturer));
Stream_WriteString(Stream,fManufacturerStr);
Stream_WriteInt32(Stream,fID);
// flags
Stream_WriteUInt32(Stream,IL_EncodeItemFlags(fFlags));
Stream_WriteString(Stream,fTextTag);
// extended specs
Stream_WriteUInt32(Stream,fWantedLevel);
Stream_WriteString(Stream,fVariant);
Stream_WriteUInt32(Stream,fSizeX);
Stream_WriteUInt32(Stream,fSizeY);
Stream_WriteUInt32(Stream,fSizeZ);
Stream_WriteUInt32(Stream,fUnitWeight);
// others
Stream_WriteString(Stream,fNotes);
Stream_WriteString(Stream,fReviewURL);
Stream_WriteString(Stream,fItemPictureFile);
Stream_WriteString(Stream,fPackagePictureFile);
Stream_WriteUInt32(Stream,fUnitPriceDefault);
// shop avail and prices
Stream_WriteUInt32(Stream,fUnitPriceLowest);
Stream_WriteUInt32(Stream,fUnitPriceHighest);
Stream_WriteUInt32(Stream,fUnitPriceSelected);
Stream_WriteInt32(Stream,fAvailableLowest);
Stream_WriteInt32(Stream,fAvailableHighest);
Stream_WriteInt32(Stream,fAvailableSelected);
// shops
Stream_WriteUInt32(Stream,ShopCount);
For i := ShopLowIndex to ShopHighIndex do
  fShops[i].SaveToStream(Stream);
end;

//------------------------------------------------------------------------------

procedure TILItem_IO_00000000.LoadItem_00000000(Stream: TStream);
var
  i:  Integer;
begin
fTimeOfAddition := TDateTime(Stream_ReadFloat64(Stream));
// pictures
LoadPicture_00000000(Stream,fItemPicture);
LoadPicture_00000000(Stream,fPackagePicture);
// basic specs
fItemType := IL_NumToItemType(Stream_ReadInt32(Stream));
fItemTypeSpec := Stream_ReadString(Stream);
fPieces := Stream_ReadUInt32(Stream);
fManufacturer := IL_NumToItemManufacturer(Stream_ReadInt32(Stream));
fManufacturerStr := Stream_ReadString(Stream);
fID := Stream_ReadInt32(Stream);
// flags
fFlags := IL_DecodeItemFlags(Stream_ReadUInt32(Stream));
fTextTag := Stream_ReadString(Stream);
// extended specs
fWantedLevel := Stream_ReadUInt32(Stream);
fVariant := Stream_ReadString(Stream);
fSizeX := Stream_ReadUInt32(Stream);
fSizeY := Stream_ReadUInt32(Stream);
fSizeZ := Stream_ReadUInt32(Stream);
fUnitWeight := Stream_ReadUInt32(Stream);
// other info
fNotes := Stream_ReadString(Stream);
fReviewURL := Stream_ReadString(Stream);
fItemPictureFile := Stream_ReadString(Stream);
fPackagePictureFile := Stream_ReadString(Stream);
fUnitPriceDefault := Stream_ReadUInt32(Stream);
// shop avail and prices
fUnitPriceLowest := Stream_ReadUInt32(Stream);
fUnitPriceHighest := Stream_ReadUInt32(Stream);
fUnitPriceSelected := Stream_ReadUInt32(Stream);
fAvailableLowest := Stream_ReadInt32(Stream);
fAvailableHighest := Stream_ReadInt32(Stream);
fAvailableSelected := Stream_ReadInt32(Stream);
// shops
ShopClear;
SetLength(fShops,Stream_ReadUInt32(Stream));
fShopCount := Length(fShops);
For i := ShopLowIndex to ShopHighIndex do
  begin
    fShops[i] := TILItemShop.Create;
    fShops[i].StaticOptions := fStaticOptions;    
    fShops[i].LoadFromStream(Stream);
    fShops[i].AssignInternalEvents(
      ShopClearSelectedHandler,
      ShopUpdateOverviewHandler,
      ShopUpdateShopListItemHandler,
      ShopUpdateValuesHandler,
      ShopUpdateAvailHistoryHandler,
      ShopUpdatePriceHistoryHandler);
  end;
end;

//------------------------------------------------------------------------------

procedure TILItem_IO_00000000.SavePicture_00000000(Stream: TStream; Pic: TBitmap);
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

//------------------------------------------------------------------------------

procedure TILItem_IO_00000000.LoadPicture_00000000(Stream: TStream; out Pic: TBitmap);
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

end.
