unit InflatablesList_Item_IO_0000000A;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  Classes,
  AuxTypes,
  InflatablesList_Item_IO_00000009;

type
  TILItem_IO_0000000A = class(TILItem_IO_00000009)
  protected
    procedure InitSaveFunctions(Struct: UInt32); override;
    procedure InitLoadFunctions(Struct: UInt32); override;
    procedure SaveItem_Plain_0000000A(Stream: TStream); virtual;
    procedure LoadItem_Plain_0000000A(Stream: TStream); virtual;
  end;

implementation

uses
  BinaryStreaming,
  InflatablesList_Types,
  InflatablesList_ItemShop,
  InflatablesList_Item_IO;

procedure TILItem_IO_0000000A.InitSaveFunctions(Struct: UInt32);
begin
If Struct = IL_ITEM_STREAMSTRUCTURE_0000000A then
  begin
    fFNSaveToStream := SaveItem_00000008;
    fFNSavePicture := SavePicture_00000008;
    fFNSaveToStreamPlain := SaveItem_Plain_0000000A;
    fFNSaveToStreamProc := SaveItem_Processed_00000008;
  end
else inherited InitSaveFunctions(Struct);
end;

//------------------------------------------------------------------------------

procedure TILItem_IO_0000000A.InitLoadFunctions(Struct: UInt32);
begin
If Struct = IL_ITEM_STREAMSTRUCTURE_0000000A then
  begin
    fFNLoadFromStream := LoadItem_00000008;
    fFNLoadPicture := LoadPicture_00000008;
    fFNLoadFromStreamPlain := LoadItem_Plain_0000000A;
    fFNLoadFromStreamProc := LoadItem_Processed_00000008;
    fFNDeferredLoadProc := LoadItem_Plain_0000000A;
    fDeferredLoadProcNum := Struct;
  end
else inherited InitLoadFunctions(Struct);
end;

//------------------------------------------------------------------------------

procedure TILItem_IO_0000000A.SaveItem_Plain_0000000A(Stream: TStream);
var
  i:  Integer;
begin
Stream_WriteBuffer(Stream,fUniqueID,SizeOf(fUniqueID));
Stream_WriteFloat64(Stream,fTimeOfAddition);
// pictures
fPictures.SaveToStream(Stream);
// basic specs
Stream_WriteInt32(Stream,IL_ItemTypeToNum(fItemType));
Stream_WriteString(Stream,fItemTypeSpec);
Stream_WriteUInt32(Stream,fPieces);
Stream_WriteString(Stream,fUserID);
Stream_WriteInt32(Stream,IL_ItemManufacturerToNum(fManufacturer));
Stream_WriteString(Stream,fManufacturerStr);
Stream_WriteString(Stream,fTextID);
Stream_WriteInt32(Stream,fNumID);
// flags
Stream_WriteUInt32(Stream,IL_EncodeItemFlags(fFlags));
Stream_WriteString(Stream,fTextTag);
Stream_WriteInt32(Stream,fNumTag);
// extended specs
Stream_WriteUInt32(Stream,fWantedLevel);
Stream_WriteString(Stream,fVariant);
Stream_WriteString(Stream,fVariantTag);
Stream_WriteUInt32(Stream,fUnitWeight);
Stream_WriteInt32(Stream,IL_ItemMaterialToNum(fMaterial));
Stream_WriteInt32(Stream,IL_ItemSurfaceFinishToNum(fSurfaceFinish));
Stream_WriteUInt32(Stream,fThickness);
Stream_WriteUInt32(Stream,fSizeX);
Stream_WriteUInt32(Stream,fSizeY);
Stream_WriteUInt32(Stream,fSizeZ);
// others
Stream_WriteString(Stream,fNotes);
Stream_WriteString(Stream,fReviewURL);
Stream_WriteUInt32(Stream,fUnitPriceDefault);
Stream_WriteUInt32(Stream,fRating);
Stream_WriteString(Stream,fRatingDetails);
// shop avail and prices
Stream_WriteUInt32(Stream,fUnitPriceLowest);
Stream_WriteUInt32(Stream,fUnitPriceHighest);
Stream_WriteUInt32(Stream,fUnitPriceSelected);
Stream_WriteInt32(Stream,fAvailableLowest);
Stream_WriteInt32(Stream,fAvailableHighest);
Stream_WriteInt32(Stream,_fAvailableSelected);
// shops
Stream_WriteUInt32(Stream,ShopCount);
For i := ShopLowIndex to ShopHighIndex do
  fShops[i].SaveToStream(Stream);
end;

//------------------------------------------------------------------------------

procedure TILItem_IO_0000000A.LoadItem_Plain_0000000A(Stream: TStream);
var
  i:  Integer;
begin
Stream_ReadBuffer(Stream,fUniqueID,SizeOf(fUniqueID));
fTimeOfAddition := TDateTime(Stream_ReadFloat64(Stream));
// pictures
fPictures.LoadFromStream(Stream);
// basic specs
fItemType := IL_NumToItemType(Stream_ReadInt32(Stream));
fItemTypeSpec := Stream_ReadString(Stream);
fPieces := Stream_ReadUInt32(Stream);
fUserID := Stream_ReadString(Stream);
fManufacturer := IL_NumToItemManufacturer(Stream_ReadInt32(Stream));
fManufacturerStr := Stream_ReadString(Stream);
fTextID := Stream_ReadString(Stream);
fNumID := Stream_ReadInt32(Stream);
// flags
fFlags := IL_DecodeItemFlags(Stream_ReadUInt32(Stream));
fTextTag := Stream_ReadString(Stream);
fNumTag := Stream_ReadInt32(Stream);
// extended specs
fWantedLevel := Stream_ReadUInt32(Stream);
fVariant := Stream_ReadString(Stream);
fVariantTag := Stream_ReadString(Stream);
fUnitWeight := Stream_ReadUInt32(Stream);
fMaterial := IL_NumToItemMaterial(Stream_ReadInt32(Stream));
fSurfaceFinish := IL_NumToItemSurfaceFinish(Stream_ReadInt32(Stream));
fThickness := Stream_ReadUInt32(Stream);
fSizeX := Stream_ReadUInt32(Stream);
fSizeY := Stream_ReadUInt32(Stream);
fSizeZ := Stream_ReadUInt32(Stream);
// other info
fNotes := Stream_ReadString(Stream);
fReviewURL := Stream_ReadString(Stream);
fUnitPriceDefault := Stream_ReadUInt32(Stream);
fRating := Stream_ReadUInt32(Stream);
fRatingDetails := Stream_ReadString(Stream);
// shop avail and prices
fUnitPriceLowest := Stream_ReadUInt32(Stream);
fUnitPriceHighest := Stream_ReadUInt32(Stream);
fUnitPriceSelected := Stream_ReadUInt32(Stream);
fAvailableLowest := Stream_ReadInt32(Stream);
fAvailableHighest := Stream_ReadInt32(Stream);
_fAvailableSelected := Stream_ReadInt32(Stream);
// shops
SetLength(fShops,Stream_ReadUInt32(Stream));
fShopCount := Length(fShops);
For i := ShopLowIndex to ShopHighIndex do
  begin
    fShops[i] := TILItemShop.Create;
    fShops[i].StaticSettings := fStaticSettings;
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
