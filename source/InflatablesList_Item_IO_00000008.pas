unit InflatablesList_Item_IO_00000008;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  Classes, Graphics,
  AuxTypes,
  InflatablesList_Item_IO;

type
  TILItem_IO_00000008 = class(TILItem_IO)
  protected
    fFNSaveToStreamPlain:   procedure(Stream: TStream) of object;
    fFNLoadFromStreamPlain: procedure(Stream: TStream) of object;
    fFNSaveToStreamProc:    procedure(Stream: TStream) of object;
    fFNLoadFromStreamProc:  procedure(Stream: TStream) of object;
    fFNDeferredLoadProc:    procedure(Stream: TStream) of object;
    // special functions
    Function GetFlagsWord: UInt32; virtual;
    procedure SetFlagsWord(FlagsWord: UInt32); virtual;
    // normal IO funtions
    procedure InitSaveFunctions(Struct: UInt32); override;
    procedure InitLoadFunctions(Struct: UInt32); override;
    procedure SaveItem_00000008(Stream: TStream); virtual;
    procedure LoadItem_00000008(Stream: TStream); virtual;
    procedure SavePicture_00000008(Stream: TStream; Pic: TBitmap); virtual;
    procedure LoadPicture_00000008(Stream: TStream; out Pic: TBitmap); virtual;
    procedure SaveItem_Plain_00000008(Stream: TStream); virtual;
    procedure LoadItem_Plain_00000008(Stream: TStream); virtual;
    procedure SaveItem_Processed_00000008(Stream: TStream); virtual;
    procedure LoadItem_Processed_00000008(Stream: TStream); virtual;
  end;

implementation

uses
  SysUtils,
  BinaryStreaming, BitOps, MemoryBuffer,
  InflatablesList_Types,
  InflatablesList_Utils,
  InflatablesList_Encryption,
  InflatablesList_ItemPictures_Base,
  InflatablesList_ItemShop,
  InflatablesList_Manager_IO;

Function TILItem_IO_00000008.GetFlagsWord: UInt32;
begin
Result := 0;
SetFlagStateValue(Result,IL_ITEM_FLAG_BITMASK_ENCRYPTED,fEncrypted);
end;

//------------------------------------------------------------------------------

procedure TILItem_IO_00000008.SetFlagsWord(FlagsWord: UInt32);
begin
fEncrypted := GetFlagState(FlagsWord,IL_ITEM_FLAG_BITMASK_ENCRYPTED);
end;

//------------------------------------------------------------------------------

procedure TILItem_IO_00000008.InitSaveFunctions(Struct: UInt32);
begin
If Struct = IL_ITEM_STREAMSTRUCTURE_00000008 then
  begin
    fFNSaveToStream := SaveItem_00000008;
    fFNSavePicture := SavePicture_00000008;
    fFNSaveToStreamPlain := SaveItem_Plain_00000008;
    fFNSaveToStreamProc := SaveItem_Processed_00000008;
  end
else raise Exception.CreateFmt('TILItem_IO_00000008.InitSaveFunctions: Invalid stream structure (%.8x).',[Struct]);
end;

//------------------------------------------------------------------------------

procedure TILItem_IO_00000008.InitLoadFunctions(Struct: UInt32);
begin
If Struct = IL_ITEM_STREAMSTRUCTURE_00000008 then
  begin
    fFNLoadFromStream := LoadItem_00000008;
    fFNLoadPicture := LoadPicture_00000008;
    fFNLoadFromStreamPlain := LoadItem_Plain_00000008;
    fFNLoadFromStreamProc := LoadItem_Processed_00000008;
    fFNDeferredLoadProc := LoadItem_Plain_00000008;
  end
else raise Exception.CreateFmt('TILItem_IO_00000008.InitLoadFunctions: Invalid stream structure (%.8x).',[Struct]);
end;

//------------------------------------------------------------------------------

procedure TILItem_IO_00000008.SaveItem_00000008(Stream: TStream);
begin
Stream_WriteUInt32(Stream,GetFlagsWord);
If fEncrypted then
  fFNSaveToStreamProc(Stream)
else
  fFNSaveToStreamPlain(Stream);
end;

//------------------------------------------------------------------------------

procedure TILItem_IO_00000008.LoadItem_00000008(Stream: TStream);
begin
SetFlagsWord(Stream_ReadUInt32(Stream));
If fEncrypted then
  fFNLoadFromStreamProc(Stream)
else
  fFNLoadFromStreamPlain(Stream);
end;

//------------------------------------------------------------------------------

procedure TILItem_IO_00000008.SavePicture_00000008(Stream: TStream; Pic: TBitmap);
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

procedure TILItem_IO_00000008.LoadPicture_00000008(Stream: TStream; out Pic: TBitmap);
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

//------------------------------------------------------------------------------

procedure TILItem_IO_00000008.SaveItem_Plain_00000008(Stream: TStream);
var
  i:  Integer;
begin
Stream_WriteBuffer(Stream,fUniqueID,SizeOf(fUniqueID));
Stream_WriteFloat64(Stream,fTimeOfAddition);
// pictures
If fPictures.CheckIndex(fPictures.IndexOfItemPicture) then
  fFNSavePicture(Stream,fPictures[fPictures.IndexOfItemPicture].Thumbnail)
else
  fFNSavePicture(Stream,nil);
If fPictures.CheckIndex(fPictures.CurrentSecondary) then
  fFNSavePicture(Stream,fPictures[fPictures.CurrentSecondary].Thumbnail)
else
  fFNSavePicture(Stream,nil);
If fPictures.CheckIndex(fPictures.IndexOfPackagePicture) then
  fFNSavePicture(Stream,fPictures[fPictures.IndexOfPackagePicture].Thumbnail)
else
  fFNSavePicture(Stream,nil);
// basic specs
Stream_WriteInt32(Stream,IL_ItemTypeToNum(fItemType));
Stream_WriteString(Stream,fItemTypeSpec);
Stream_WriteUInt32(Stream,fPieces);
Stream_WriteString(Stream,fUserID);
Stream_WriteInt32(Stream,IL_ItemManufacturerToNum(fManufacturer));
Stream_WriteString(Stream,fManufacturerStr);
Stream_WriteString(Stream,fTextID);
Stream_WriteInt32(Stream,fID);
// flags
Stream_WriteUInt32(Stream,IL_EncodeItemFlags(fFlags));
Stream_WriteString(Stream,fTextTag);
Stream_WriteInt32(Stream,fNumTag);
// extended specs
Stream_WriteUInt32(Stream,fWantedLevel);
Stream_WriteString(Stream,fVariant);
Stream_WriteString(Stream,fVariantTag);
Stream_WriteInt32(Stream,IL_ItemMaterialToNum(fMaterial));
Stream_WriteUInt32(Stream,fSizeX);
Stream_WriteUInt32(Stream,fSizeY);
Stream_WriteUInt32(Stream,fSizeZ);
Stream_WriteUInt32(Stream,fUnitWeight);
Stream_WriteUInt32(Stream,fThickness);
// others
Stream_WriteString(Stream,fNotes);
Stream_WriteString(Stream,fReviewURL);
// pictures
If fPictures.CheckIndex(fPictures.IndexOfItemPicture) then
  Stream_WriteString(Stream,
    IL_PathRelative(fStaticSettings.ListPath,
      fPictures.AutomationFolder + fPictures[fPictures.IndexOfItemPicture].PictureFile))
else
  Stream_WriteString(Stream,'');
If fPictures.CheckIndex(fPictures.CurrentSecondary) then
  Stream_WriteString(Stream,
    IL_PathRelative(fStaticSettings.ListPath,
      fPictures.AutomationFolder + fPictures[fPictures.CurrentSecondary].PictureFile))
else
  Stream_WriteString(Stream,'');
If fPictures.CheckIndex(fPictures.IndexOfPackagePicture) then
  Stream_WriteString(Stream,
    IL_PathRelative(fStaticSettings.ListPath,
      fPictures.AutomationFolder + fPictures[fPictures.IndexOfPackagePicture].PictureFile))
else
  Stream_WriteString(Stream,'');
Stream_WriteUInt32(Stream,fUnitPriceDefault);
Stream_WriteUInt32(Stream,fRating);
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

procedure TILItem_IO_00000008.LoadItem_Plain_00000008(Stream: TStream);
var
  i:                      Integer;
  ItemPictureThumb:       TBitmap;
  SecondaryPictureThumb:  TBitmap;
  PackagePictureThumb:    TBitmap;
  ItemPictureFile:        String;
  SecondaryPictureFile:   String;
  PackagePictureFile:     String;
  AutomationInfo:         TILPictureAutomationInfo;
begin
ItemPictureThumb := nil;
SecondaryPictureThumb := nil;
PackagePictureThumb := nil;
try
  Stream_ReadBuffer(Stream,fUniqueID,SizeOf(fUniqueID));
  fTimeOfAddition := TDateTime(Stream_ReadFloat64(Stream));
  // pictures - load into temporaries
  fFNLoadPicture(Stream,ItemPictureThumb);
  fFNLoadPicture(Stream,SecondaryPictureThumb);
  fFNLoadPicture(Stream,PackagePictureThumb);
  // basic specs
  fItemType := IL_NumToItemType(Stream_ReadInt32(Stream));
  fItemTypeSpec := Stream_ReadString(Stream);
  fPieces := Stream_ReadUInt32(Stream);
  fUserID := Stream_ReadString(Stream);
  fManufacturer := IL_NumToItemManufacturer(Stream_ReadInt32(Stream));
  fManufacturerStr := Stream_ReadString(Stream);
  fTextID := Stream_ReadString(Stream);
  fID := Stream_ReadInt32(Stream);
  // flags
  fFlags := IL_DecodeItemFlags(Stream_ReadUInt32(Stream));
  fTextTag := Stream_ReadString(Stream);
  fNumTag := Stream_ReadInt32(Stream);
  // extended specs
  fWantedLevel := Stream_ReadUInt32(Stream);
  fVariant := Stream_ReadString(Stream);
  fVariantTag := Stream_ReadString(Stream);
  fMaterial := IL_NumToItemMaterial(Stream_ReadInt32(Stream));
  fSizeX := Stream_ReadUInt32(Stream);
  fSizeY := Stream_ReadUInt32(Stream);
  fSizeZ := Stream_ReadUInt32(Stream);
  fUnitWeight := Stream_ReadUInt32(Stream);
  fThickness := Stream_ReadUInt32(Stream);
  // other info
  fNotes := Stream_ReadString(Stream);
  fReviewURL := Stream_ReadString(Stream);
  // picture files - load into temporaries and expand them  
  ItemPictureFile := Stream_ReadString(Stream);
  SecondaryPictureFile := Stream_ReadString(Stream);
  PackagePictureFile := Stream_ReadString(Stream);
  ItemPictureFile := IL_ExpandFileName(fStaticSettings.ListPath + ItemPictureFile);
  SecondaryPictureFile := IL_ExpandFileName(fStaticSettings.ListPath + SecondaryPictureFile);
  PackagePictureFile := IL_ExpandFileName(fStaticSettings.ListPath + PackagePictureFile);
  fUnitPriceDefault := Stream_ReadUInt32(Stream);
  fRating := Stream_ReadUInt32(Stream);
  // shop avail and prices
  fUnitPriceLowest := Stream_ReadUInt32(Stream);
  fUnitPriceHighest := Stream_ReadUInt32(Stream);
  fUnitPriceSelected := Stream_ReadUInt32(Stream);
  fAvailableLowest := Stream_ReadInt32(Stream);
  fAvailableHighest := Stream_ReadInt32(Stream);
  fAvailableSelected := Stream_ReadInt32(Stream);
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
  // convert pictures
  fPictures.BeginInitialization;
  try
    If Length(ItemPictureFile) > 0 then
      If fPictures.AutomatePictureFile(ItemPictureFile,AutomationInfo) then
        begin
          i := fPictures.Add(AutomationInfo);
          fPictures.SetThumbnail(i,ItemPictureThumb,True);
          fPictures.SetItemPicture(i,True);
        end;
    If Length(PackagePictureFile) > 0 then
      If fPictures.AutomatePictureFile(PackagePictureFile,AutomationInfo) then
        begin
          i := fPictures.Add(AutomationInfo);
          fPictures.SetThumbnail(i,PackagePictureThumb,True);
          fPictures.SetPackagePicture(i,True);
        end;
    If Length(SecondaryPictureFile) > 0 then
      If fPictures.AutomatePictureFile(SecondaryPictureFile,AutomationInfo) then
        begin
          i := fPictures.Add(AutomationInfo);
          fPictures.SetThumbnail(i,SecondaryPictureThumb,True);
        end;
  finally
    fPictures.EndInitialization;
  end;
finally
  If Assigned(ItemPictureThumb) then
    FreeAndNil(ItemPictureThumb);
  If Assigned(SecondaryPictureThumb) then
    FreeAndNil(SecondaryPictureThumb);
  If Assigned(PackagePictureThumb) then
    FreeAndNil(PackagePictureThumb);
end;
end;

//------------------------------------------------------------------------------

procedure TILItem_IO_00000008.SaveItem_Processed_00000008(Stream: TStream);
var
  TempStream: TMemoryStream;
  Password:   String;
begin
// in current implementation, if we are here, we are writing encrypted item...
If fDataAccessible then
  begin
    {
      data are not encrypted, encrypt them and then save the resulting stream

      if the item is marked for encryption and the data are decrypted, this
      means the password is valid since it was already put in (item was either
      marked for encryption - in that case thee manager prompted for the
      password, or the item was decrypted and in that case the password was
      entered for that to happen)
    }
    TempStream := TMemoryStream.Create;
    try
      // preallocate
      TempStream.Size := Int64(IL_LISTFILE_PREALLOC_BYTES_ITEM + (3 * IL_LISTFILE_PREALLOC_BYTES_PIC));
      TempStream.Seek(0,soBeginning);
      // write plain data
      fFNSaveToStreamPlain(TempStream);
      TempStream.Size := TempStream.Position;
      // encrypt the stream
      If RequestItemsPassword(Password) then
        InflatablesList_Encryption.EncryptStream_AES256(TempStream,Password,IL_ITEM_DECRYPT_CHECK)
      else
        raise Exception.Create('TILItem_IO_00000006.SaveItem_Processed_00000006: Unable to obtain password for saving, cannot continue.');
      // save the encrypted stream
      Stream_WriteUInt64(Stream,UInt64(TempStream.Size));                       // write size of encrypted data      
      Stream_WriteBuffer(Stream,TempStream.Memory^,TMemSize(TempStream.Size));  // TempStream contains unencrypted size
    finally
      TempStream.Free;
    end;    
  end
else
  begin
    {
      data are still stored in encrypted state, do nothing, just take the
      encrypted data buffer and save it as is (expects fEncryptedData to contain
      the data :O)
    }
    Stream_WriteUInt64(Stream,UInt64(fEncryptedData.Size));                 // encrypted size
    Stream_WriteBuffer(Stream,fEncryptedData.Memory^,fEncryptedData.Size);  // encrypted data
  end;
end;

//------------------------------------------------------------------------------

procedure TILItem_IO_00000008.LoadItem_Processed_00000008(Stream: TStream);
begin
{
  the item is marked as encrypted - do not decrypt it here, just load it into
  fEncryptedData buffer and set fDataAccessible to false
}
fDataAccessible := False;
ReallocBuffer(fEncryptedData,TMemSize(Stream_ReadUInt64(Stream)));
Stream_ReadBuffer(Stream,fEncryptedData.Memory^,fEncryptedData.Size);
end;

end.
