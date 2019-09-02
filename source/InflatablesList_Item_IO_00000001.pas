unit InflatablesList_Item_IO_00000001;
{$message 'll_rework'}

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  Classes,
  AuxTypes,
  InflatablesList_Item_IO_00000000;

type
  TILItem_IO_00000001 = class(TILItem_IO_00000000)
  protected
    procedure InitSaveFunctions(Struct: UInt32); override;
    procedure InitLoadFunctions(Struct: UInt32); override;
    procedure SaveItem_00000001(Stream: TStream); virtual;
    procedure LoadItem_00000001(Stream: TStream); virtual;
  end;

implementation

uses
  BinaryStreaming,
  InflatablesList_Types,
  InflatablesList_Item_IO,  
  InflatablesList_ItemShop;

procedure TILItem_IO_00000001.InitSaveFunctions(Struct: UInt32);
begin
If Struct = IL_ITEM_STREAMSTRUCTURE_00000001 then
  begin
    fFNSaveToStream := SaveItem_00000001;
    fFNSavePicture := SavePicture_00000000;
  end
else inherited InitSaveFunctions(Struct);
end;

//------------------------------------------------------------------------------

procedure TILItem_IO_00000001.InitLoadFunctions(Struct: UInt32);
begin
If Struct = IL_ITEM_STREAMSTRUCTURE_00000001 then
  begin
    fFNLoadFromStream := LoadItem_00000001;
    fFNLoadPicture := LoadPicture_00000000;
  end
else inherited InitLoadFunctions(Struct);
end;

//------------------------------------------------------------------------------

procedure TILItem_IO_00000001.SaveItem_00000001(Stream: TStream);
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
Stream_WriteInt32(Stream,IL_ItemMaterialToNum(fMaterial));
Stream_WriteUInt32(Stream,fSizeX);
Stream_WriteUInt32(Stream,fSizeY);
Stream_WriteUInt32(Stream,fSizeZ);
Stream_WriteUInt32(Stream,fUnitWeight);
Stream_WriteUInt32(Stream,fThickness);
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

procedure TILItem_IO_00000001.LoadItem_00000001(Stream: TStream);
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
fMaterial := IL_NumToItemMaterial(Stream_ReadInt32(Stream));
fSizeX := Stream_ReadUInt32(Stream);
fSizeY := Stream_ReadUInt32(Stream);
fSizeZ := Stream_ReadUInt32(Stream);
fUnitWeight := Stream_ReadUInt32(Stream);
fThickness := Stream_ReadUInt32(Stream);
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

end.
