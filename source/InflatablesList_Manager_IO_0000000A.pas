unit InflatablesList_Manager_IO_0000000A;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  Classes,
  AuxTypes,
  InflatablesList_Manager_IO,  
  InflatablesList_Manager_IO_00000009;

const
  IL_MANAGER_FLAG_BITMASK_ENCRYPTED  = UInt32($00000001);
  IL_MANAGER_FLAG_BITMASK_COMPRESSED = UInt32($00000002);

type
  TILManager_IO_0000000A = class(TILManager_IO_00000009)
  protected
    fFNCompressStream:    procedure(Stream: TMemoryStream) of object;
    fFNDecompressStream:  procedure(Stream: TMemoryStream) of object;
    fFNEncryptStream:     procedure(Stream: TMemoryStream) of object;
    fFNDecryptStream:     procedure(Stream: TMemoryStream) of object;
    // special functions
    Function GetFlagsWord: UInt32; virtual;
    procedure SetFlagsWord(FlagsWord: UInt32); virtual;
    procedure DecodeFlagsWord(FlagsWord: UInt32; var PreloadResult: TILPreloadResultFlags); virtual;
    // stream processing functions
    procedure CompressStream_ZLIB(WorkStream: TMemoryStream); virtual;
    procedure DecompressStream_ZLIB(WorkStream: TMemoryStream); virtual;
    procedure EncryptStream_AES256(WorkStream: TMemoryStream); virtual;
    procedure DecryptStream_AES256(WorkStream: TMemoryStream); virtual;
    // normal methods
    procedure InitSaveFunctions(Struct: UInt32); override;
    procedure InitLoadFunctions(Struct: UInt32); override;
    procedure InitPreloadFunctions(Struct: UInt32); override;
    procedure SaveList_0000000A(Stream: TStream); virtual;
    procedure LoadList_0000000A(Stream: TStream); virtual;
    procedure SaveSortingSettings_0000000A(Stream: TStream); virtual;
    procedure LoadSortingSettings_0000000A(Stream: TStream); virtual;
    procedure SaveList_Plain_0000000A(Stream: TStream); virtual;
    procedure LoadList_Plain_0000000A(Stream: TStream); virtual;
    procedure SaveList_Processed_0000000A(Stream: TStream); virtual;
    procedure LoadList_Processed_0000000A(Stream: TStream); virtual;
    procedure PreloadStream_0000000A(Stream: TStream; var PreloadResult: TILPreloadResultFlags); virtual;
  end;

implementation

uses
  SysUtils, DateUtils,
  BinaryStreaming, StrRect, WinFileInfo, BitOps, MD5, SHA2, AES, SimpleCompress,
  InflatablesList_Types,
  InflatablesList_Utils;

Function TILManager_IO_0000000A.GetFlagsWord: UInt32;
begin
Result := 0;
SetFlagStateValue(Result,IL_MANAGER_FLAG_BITMASK_ENCRYPTED,fEncrypted);
SetFlagStateValue(Result,IL_MANAGER_FLAG_BITMASK_COMPRESSED,fCompressed);
end;

//------------------------------------------------------------------------------

procedure TILManager_IO_0000000A.SetFlagsWord(FlagsWord: UInt32);
begin
fEncrypted := GetFlagState(FlagsWord,IL_MANAGER_FLAG_BITMASK_ENCRYPTED);
fCompressed := GetFlagState(FlagsWord,IL_MANAGER_FLAG_BITMASK_COMPRESSED);
end;

//------------------------------------------------------------------------------

procedure TILManager_IO_0000000A.DecodeFlagsWord(FlagsWord: UInt32; var PreloadResult: TILPreloadResultFlags);
begin
If GetFlagState(FlagsWord,IL_MANAGER_FLAG_BITMASK_ENCRYPTED) then
  Include(PreloadResult,ilprfEncrypted);
If GetFlagState(FlagsWord,IL_MANAGER_FLAG_BITMASK_COMPRESSED) then
  Include(PreloadResult,ilprfCompressed);
end;

//------------------------------------------------------------------------------

procedure TILManager_IO_0000000A.CompressStream_ZLIB(WorkStream: TMemoryStream);
begin
WorkStream.Seek(0,soBeginning);
ZCompressStream(WorkStream);
end;

//------------------------------------------------------------------------------

procedure TILManager_IO_0000000A.DecompressStream_ZLIB(WorkStream: TMemoryStream);
begin
WorkStream.Seek(0,soBeginning);
ZDecompressStream(WorkStream);
end;

//------------------------------------------------------------------------------

procedure TILManager_IO_0000000A.EncryptStream_AES256(WorkStream: TMemoryStream);
var
  TempStream: TMemoryStream;
  DataSize:   UInt64;
  Key:        TSHA2Hash_256;
  InitVector: TMD5Hash;
  Cipher:     TAESCipherAccelerated;
begin
{
  Enryption is done using AES cipher (Rijndael), 256bit key, 128bit blocks,
  CBC mode of operaton, zero-padded last block.

  Unencrypted size of data (UInt64) is stored just before the cipher stream,
  immediately followed by size of the encrypted data (UInt64).

  Key is obtained as SHA-256 of UTF16-encoded list password.

  Init vector is obtained as MD5 of UTF16-encoded list password.

  Correct decryption is checked on last 8 bytes of unencrypted data - it must
  match IL_LISTFILE_DECRYPT_CHECK constant.

  Output pseudo-structure:

    UInt64    size of unencrypted data
    UInt64    size of encrypted data - AES is block cipher, so this can
              differ from unencrypted size
    []        encrypted data

    Encrypted data has following pseudo-structure after decryption:

      []        unencrypted (plain) data
      UInt64    decryption check - must be equal to IL_LISTFILE_DECRYPT_CHECK
                constant
}
TempStream := TMemoryStream.Create;
try
  // preallocate and copy data to temp stream
  TempStream.Size := WorkStream.Size;
  WorkStream.Seek(0,soBeginning);
  Stream_ReadBuffer(WorkStream,TempStream.Memory^,TMemSize(TempStream.Size));
  // write validity check at the end
  TempStream.Seek(0,soEnd);
  Stream_WriteUInt64(TempStream,IL_LISTFILE_DECRYPT_CHECK);
  DataSize := UInt64(TempStream.Size);
  // get key and init vector
  Key := BinaryCorrectSHA2(WideStringSHA2(sha256,StrToUnicode(fListPassword)).Hash256);
  InitVector := BinaryCorrectMD5(WideStringMD5(StrToUnicode(fListPassword)));
  // encrypt stream
  Cipher := TAESCipherAccelerated.Create(Key,InitVector,r256bit,cmEncrypt);
  try
    Cipher.ModeOfOperation := moCBC;
    Cipher.Padding := padZeroes;
    TempStream.Seek(0,soBeginning);
    Cipher.ProcessStream(TempStream);
  finally
    Cipher.Free;
  end;
  // save data size and encrypted stream
  WorkStream.Seek(0,soBeginning);
  Stream_WriteUInt64(WorkStream,DataSize);
  Stream_WriteUInt64(WorkStream,UInt64(TempStream.Size));
  Stream_WriteBuffer(WorkStream,TempStream.Memory^,TMemSize(TempStream.Size));
  WorkStream.Size := WorkStream.Position;
finally
  TempStream.Free;
end;
end;

//------------------------------------------------------------------------------

procedure TILManager_IO_0000000A.DecryptStream_AES256(WorkStream: TMemoryStream);
var
  TempStream: TMemoryStream;
  DataSize:   UInt64;
  CryptSize:  UInt64;
  Key:        TSHA2Hash_256;
  InitVector: TMD5Hash;
  Cipher:     TAESCipherAccelerated;
begin
TempStream := TMemoryStream.Create;
try
  // load encrypted and unencrypted data sizes
  WorkStream.Seek(0,soBeginning);
  DataSize := Stream_ReadUInt64(WorkStream);
  CryptSize := Stream_ReadUInt64(WorkStream);
  // preallocate stream
  TempStream.Size := CryptSize;
  // load encrypted data into temp
  Stream_ReadBuffer(WorkStream,TempStream.Memory^,TMemSize(TempStream.Size));
  // get key and init vector
  Key := BinaryCorrectSHA2(WideStringSHA2(sha256,StrToUnicode(fListPassword)).Hash256);
  InitVector := BinaryCorrectMD5(WideStringMD5(StrToUnicode(fListPassword)));
  // decrypt stream
  Cipher := TAESCipherAccelerated.Create(Key,InitVector,r256bit,cmDecrypt);
  try
    Cipher.ModeOfOperation := moCBC;
    Cipher.Padding := padZeroes;
    TempStream.Seek(0,soBeginning);
    Cipher.ProcessStream(TempStream);
  finally
    Cipher.Free;
  end;
  TempStream.Size := DataSize;
  // check if decryption went ok (key was correct)
  TempStream.Seek(-SizeOf(UInt64),soEnd);
  If Stream_ReadUInt64(TempStream) <> IL_LISTFILE_DECRYPT_CHECK then
    raise EILWrongPassword.Create('TILManager_IO_0000000A.DecryptStream_AES256: Decryption failed, wrong password?');
  //write decrypted data vithout validity check
  WorkStream.Seek(0,soBeginning);
  Stream_WriteBuffer(WorkStream,TempStream.Memory^,TMemSize(TempStream.Size - SizeOf(UInt64)));
  WorkStream.Size := WorkStream.Position;
finally
  TempStream.Free;
end;
end;

//------------------------------------------------------------------------------

procedure TILManager_IO_0000000A.InitSaveFunctions(Struct: UInt32);
begin
If Struct = IL_LISTFILE_STREAMSTRUCTURE_0000000A then
  begin
    fFNSaveToStream := SaveList_0000000A;
    fFNSaveSortingSettings := SaveSortingSettings_0000000A;
    fFNSaveShopTemplates := SaveShopTemplates_00000008;
    fFNSaveFilterSettings := SaveFilterSettings_00000008;
    fFNSaveItems := SaveItems_00000008;
    fFNCompressStream := CompressStream_ZLIB;
    fFNEncryptStream := EncryptStream_AES256;
  end
else inherited InitSaveFunctions(Struct);
end;

//------------------------------------------------------------------------------

procedure TILManager_IO_0000000A.InitLoadFunctions(Struct: UInt32);
begin
If Struct = IL_LISTFILE_STREAMSTRUCTURE_0000000A then
  begin
    fFNLoadFromStream := LoadList_0000000A;
    fFNLoadSortingSettings := LoadSortingSettings_0000000A;
    fFNLoadShopTemplates := LoadShopTemplates_00000008;
    fFNLoadFilterSettings := LoadFilterSettings_00000008;
    fFNLoadItems := LoadItems_00000008;
    fFNDecompressStream := DecompressStream_ZLIB;
    fFNDecryptStream := DecryptStream_AES256;
  end
else inherited InitLoadFunctions(Struct);
end;

//------------------------------------------------------------------------------

procedure TILManager_IO_0000000A.InitPreloadFunctions(Struct: UInt32);
begin
If Struct = IL_LISTFILE_STREAMSTRUCTURE_0000000A then
  fFNPreloadStream := PreloadStream_0000000A
else
  fFNPreloadStream := nil;
end;

//------------------------------------------------------------------------------

procedure TILManager_IO_0000000A.SaveList_0000000A(Stream: TStream);
begin
Stream_WriteUInt32(Stream,GetFlagsWord);
If fEncrypted or fCompressed then
  SaveList_Processed_0000000A(Stream)
else
  SaveList_Plain_0000000A(Stream);
end;

//------------------------------------------------------------------------------

procedure TILManager_IO_0000000A.LoadList_0000000A(Stream: TStream);
begin
SetFlagsWord(Stream_ReadUInt32(Stream));
If fEncrypted or fCompressed then
  LoadList_Processed_0000000A(Stream)
else
  LoadList_Plain_0000000A(Stream);
end;

//------------------------------------------------------------------------------

procedure TILManager_IO_0000000A.SaveSortingSettings_0000000A(Stream: TStream);
begin
// use old structure and just append case sensitivity flag
SaveSortingSettings_00000008(Stream);
Stream_WriteBool(Stream,fCaseSensSort);
end;

//------------------------------------------------------------------------------

procedure TILManager_IO_0000000A.LoadSortingSettings_0000000A(Stream: TStream);
begin
LoadSortingSettings_00000008(Stream);
fCaseSensSort := Stream_ReadBool(Stream);
end;

//------------------------------------------------------------------------------

procedure TILManager_IO_0000000A.SaveList_Plain_0000000A(Stream: TStream);
var
  Time: TDateTIme;
begin
// save version of the program (for reference and debugging)
with TWinFileInfo.Create(WFI_LS_LoadVersionInfo or WFI_LS_LoadFixedFileInfo or WFI_LS_DecodeFixedFileInfo) do
try
  Stream_WriteInt16(Stream,VersionInfoFixedFileInfoDecoded.FileVersionMembers.Major);
  Stream_WriteInt16(Stream,VersionInfoFixedFileInfoDecoded.FileVersionMembers.Minor);
  Stream_WriteInt16(Stream,VersionInfoFixedFileInfoDecoded.FileVersionMembers.Release);
  Stream_WriteInt16(Stream,VersionInfoFixedFileInfoDecoded.FileVersionMembers.Build);
finally
  Free;
end;
// save time
Time := Now;
Stream_WriteInt64(Stream,DateTimeToUnix(Time));
Stream_WriteString(Stream,IL_FormatDateTime('yyyy-mm-dd-hh-nn-ss-zzz',Time));
fFNSaveSortingSettings(Stream);
fFNSaveShopTemplates(Stream);
fFNSaveFilterSettings(Stream);
fFNSaveItems(Stream);
Stream_WriteString(Stream,fNotes);
end;

//------------------------------------------------------------------------------

procedure TILManager_IO_0000000A.LoadList_Plain_0000000A(Stream: TStream);
begin
Stream_ReadInt64(Stream);   // discard version of the program in which the file was saved
Stream_ReadInt64(Stream);   // discard time
Stream_ReadString(Stream);  // discard time string
fFNLoadSortingSettings(Stream);
fFNLoadShopTemplates(Stream);
fFNLoadFilterSettings(Stream);
fFNLoadItems(Stream);
fNotes := Stream_ReadString(Stream);
end;

//------------------------------------------------------------------------------

procedure TILManager_IO_0000000A.SaveList_Processed_0000000A(Stream: TStream);
var
  TempStream: TMemoryStream;
begin
TempStream := TMemoryStream.Create;
try
  // preallocate temporary stream
  TempStream.Size := Stream.Size;
  TempStream.Seek(0,soBeginning);
  // write plain data to temp
  SaveList_Plain_0000000A(TempStream);
  TempStream.Size := TempStream.Position;
  // compress temp
  If fCompressed then
    fFNCompressStream(TempStream);
  // encrypt temp
  If fEncrypted then
    fFNEncryptStream(TempStream);
  // write processed temp to stream
  Stream_WriteUInt64(Stream,UInt64(TempStream.Size));
  Stream_WriteBuffer(Stream,TempStream.Memory^,TMemSize(TempStream.Size));
finally
  TempStream.Free;
end;
end;

//------------------------------------------------------------------------------

procedure TILManager_IO_0000000A.LoadList_Processed_0000000A(Stream: TStream);
var
  TempStream: TMemoryStream;
begin
TempStream := TMemoryStream.Create;
try
  // read processed stream into temp
  TempStream.Size := Int64(Stream_ReadUInt64(Stream));
  Stream_ReadBuffer(Stream,TempStream.Memory^,TMemSize(TempStream.Size));
  // decrypt temp
  If fEncrypted then
    fFNDecryptStream(TempStream);
  // decompress temp
  If fCompressed then
    fFNDecompressStream(TempStream);
  // read plain data from temp
  TempStream.Seek(0,soBeginning);  
  LoadList_Plain_0000000A(TempStream);
finally
  TempStream.Free;
end;
end;

//------------------------------------------------------------------------------

procedure TILManager_IO_0000000A.PreloadStream_0000000A(Stream: TStream; var PreloadResult: TILPreloadResultFlags);
begin
DecodeFlagsWord(Stream_ReadUInt32(Stream),PreloadResult);
end;

end.
