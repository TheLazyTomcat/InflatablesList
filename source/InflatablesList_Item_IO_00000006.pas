unit InflatablesList_Item_IO_00000006;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  Classes,
  AuxTypes,
  InflatablesList_Item_IO_00000005;

type
  TILItem_IO_00000006 = class(TILItem_IO_00000005)
  protected
    // special functions
    Function GetFlagsWord: UInt32; virtual;
    procedure SetFlagsWord(FlagsWord: UInt32); virtual;
    // normal IO funtions
    procedure InitSaveFunctions(Struct: UInt32); override;
    procedure InitLoadFunctions(Struct: UInt32); override;
    procedure SaveItem_00000006(Stream: TStream); virtual;
    procedure LoadItem_00000006(Stream: TStream); virtual;
    procedure SaveItem_Plain_00000006(Stream: TStream); virtual;
    procedure LoadItem_Plain_00000006(Stream: TStream); virtual;
    procedure SaveItem_Processed_00000006(Stream: TStream); virtual;
    procedure LoadItem_Processed_00000006(Stream: TStream); virtual;
  end;

implementation

uses
  BinaryStreaming, BitOps, MemoryBuffer,
  InflatablesList_Types,
  InflatablesList_Encryption,
  InflatablesList_Item_IO,
  InflatablesList_Manager_IO;

Function TILItem_IO_00000006.GetFlagsWord: UInt32;
begin
Result := 0;
SetFlagStateValue(Result,IL_ITEM_FLAG_BITMASK_ENCRYPTED,fEncrypted);
end;

//------------------------------------------------------------------------------

procedure TILItem_IO_00000006.SetFlagsWord(FlagsWord: UInt32);
begin
fEncrypted := GetFlagState(FlagsWord,IL_ITEM_FLAG_BITMASK_ENCRYPTED);
end;

//------------------------------------------------------------------------------

procedure TILItem_IO_00000006.InitSaveFunctions(Struct: UInt32);
begin
If Struct = IL_ITEM_STREAMSTRUCTURE_00000006 then
  begin
    fFNSaveToStream := SaveItem_00000006;
    fFNSavePicture := SavePicture_00000000;
  end
else inherited InitSaveFunctions(Struct);
end;

//------------------------------------------------------------------------------

procedure TILItem_IO_00000006.InitLoadFunctions(Struct: UInt32);
begin
If Struct = IL_ITEM_STREAMSTRUCTURE_00000006 then
  begin
    fFNLoadFromStream := LoadItem_00000006;
    fFNLoadPicture := LoadPicture_00000000;
  end
else inherited InitLoadFunctions(Struct);
end;

//------------------------------------------------------------------------------

procedure TILItem_IO_00000006.SaveItem_00000006(Stream: TStream);
begin
Stream_WriteUInt32(Stream,GetFlagsWord);
If fEncrypted then
  SaveItem_Processed_00000006(Stream)
else
  SaveItem_Plain_00000006(Stream);
end;

//------------------------------------------------------------------------------

procedure TILItem_IO_00000006.LoadItem_00000006(Stream: TStream);
begin
SetFlagsWord(Stream_ReadUInt32(Stream));
If fEncrypted then
  LoadItem_Processed_00000006(Stream)
else
  LoadItem_00000005(Stream);
end;

//------------------------------------------------------------------------------

procedure TILItem_IO_00000006.SaveItem_Plain_00000006(Stream: TStream);
begin
// the structure is unchanged from ver 5
SaveItem_00000005(Stream);
end;

//------------------------------------------------------------------------------

procedure TILItem_IO_00000006.LoadItem_Plain_00000006(Stream: TStream);
begin
LoadItem_00000005(Stream);
end;

//------------------------------------------------------------------------------

procedure TILItem_IO_00000006.SaveItem_Processed_00000006(Stream: TStream);
var
  TempStream: TMemoryStream;
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
      SaveItem_Plain_00000006(TempStream);
      TempStream.Size := TempStream.Position;
      // encrypt the stream
      InflatablesList_Encryption.EncryptStream_AES256(TempStream,fItemPassword,IL_ITEM_DECRYPT_CHECK);
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

procedure TILItem_IO_00000006.LoadItem_Processed_00000006(Stream: TStream);
begin
{
  the item is marked as encrypted - do not decrypt it here , just load it into
  fEncryptedData buffer and set fDataAccessible to false
}
fDataAccessible := False;
GetBuffer(fEncryptedData,TMemSize(Stream_ReadUInt64(Stream)));
Stream_ReadBuffer(Stream,fEncryptedData.Memory^,fEncryptedData.Size);
end;

end.
