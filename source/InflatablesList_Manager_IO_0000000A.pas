unit InflatablesList_Manager_IO_0000000A;{$message 'revisit'}

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  Classes,
  AuxTypes,
  InflatablesList_Manager_IO_00000009;

{
  Enryption is done using AES cipher (Rijndael), 256bit key, 128bit blocks,
  CBC mode of operaton, zero-padded last block.

  Unencrypted size of data (UInt64) is stored just before the cipher stream,
  immediately followed by size of the encrypted data (UInt64).

  Key is obtained as SHA-256 of UTF16-encoded list password.

  Init vector is obtained as MD5 of UTF16-encoded list password.
  
  Correct decryption is checked on last 8 bytes of unencrypted data - it must
  match IL_LISTFILE_DECRYPT_CHECK constant.
}

type
  TILManager_IO_0000000A = class(TILManager_IO_00000009)
  protected
    procedure InitSaveFunctions(Struct: UInt32); override;
    procedure InitLoadFunctions(Struct: UInt32); override;
    procedure SaveList_0000000A(Stream: TStream); virtual;
    procedure LoadList_0000000A(Stream: TStream); virtual;
  end;

implementation

uses
  SysUtils,
  BinaryStreaming, AES, MD5, SHA2, StrRect,
  InflatablesList_Types,
  InflatablesList_Manager_IO;

procedure TILManager_IO_0000000A.InitSaveFunctions(Struct: UInt32);
begin
If Struct = IL_LISTFILE_STREAMSTRUCTURE_0000000A then
  begin
    fFNSaveToStream := SaveList_0000000A;
    fFNSaveSortingSettings := SaveSortingSettings_00000008;
    fFNSaveShopTemplates := SaveShopTemplates_00000008;
    fFNSaveFilterSettings := SaveFilterSettings_00000008;
    fFNSaveItems := SaveItems_00000008;
  end
else inherited InitSaveFunctions(Struct);
end;

//------------------------------------------------------------------------------

procedure TILManager_IO_0000000A.InitLoadFunctions(Struct: UInt32);
begin
If Struct = IL_LISTFILE_STREAMSTRUCTURE_0000000A then
  begin
    fFNLoadFromStream := LoadList_0000000A;
    fFNLoadSortingSettings := LoadSortingSettings_00000008;
    fFNLoadShopTemplates := LoadShopTemplates_00000008;
    fFNLoadFilterSettings := LoadFilterSettings_00000008;
    fFNLoadItems := LoadItems_00000008;
  end
else
inherited InitLoadFunctions(Struct);
end;

//------------------------------------------------------------------------------

procedure TILManager_IO_0000000A.SaveList_0000000A(Stream: TStream);
var
  TempStream: TMemoryStream;
  DataSize:   UInt64;
  Key:        TSHA2Hash_256;
  InitVector: TMD5Hash;
  Cipher:     TAESCipherAccelerated;
begin
TempStream := TMemoryStream.Create;
try
  // get key and init vector
  Key := BinaryCorrectSHA2(WideStringSHA2(sha256,StrToUnicode(fListPassword)).Hash256);
  InitVector := BinaryCorrectMD5(WideStringMD5(StrToUnicode(fListPassword)));
  // preallocate stream
  TempStream.Size := Stream.Size;
  TempStream.Seek(0,soBeginning);
  // save unencrypted data
  // the main structure is the same as in version 9, only difference is the
  // validity check value at the end
  SaveList_00000009(TempStream);
  Stream_WriteUInt64(TempStream,IL_LISTFILE_DECRYPT_CHECK);
  TempStream.Size := TempStream.Position;
  DataSize := UInt64(TempStream.Size);
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
  Stream_WriteUInt64(Stream,DataSize);
  Stream_WriteUInt64(Stream,TempStream.Size);
  Stream_WriteBuffer(Stream,TempStream.Memory^,TempStream.Size);
finally
  TempStream.Free;
end;
end;

//------------------------------------------------------------------------------

procedure TILManager_IO_0000000A.LoadList_0000000A(Stream: TStream);
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
  // get key and init vector
  Key := BinaryCorrectSHA2(WideStringSHA2(sha256,StrToUnicode(fListPassword)).Hash256);
  InitVector := BinaryCorrectMD5(WideStringMD5(StrToUnicode(fListPassword)));
  // load encrypted and unencrypted data sizes
  DataSize := Stream_ReadUInt64(Stream);
  CryptSize := Stream_ReadUInt64(Stream);
  // preallocate stream
  TempStream.Size := CryptSize;
  // load encrypted data in one go
  Stream_ReadBuffer(Stream,TempStream.Memory^,TempStream.Size);
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
  If Stream_ReadUInt64(TempStream) = IL_LISTFILE_DECRYPT_CHECK then
    begin
      TempStream.Seek(0,soBeginning);
      LoadList_00000009(TempStream);
    end
  else raise EWrongPassword.Create('TILManager_IO_0000000A.LoadList_0000000A: Decryption failed. (wrong password?)');
finally
  TempStream.Free;
end;
end;

end.
