unit InflatablesList_Encryption;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  SysUtils, Classes,
  AuxTypes;

type
  EILWrongPassword = class(Exception);

procedure EncryptStream_AES256(WorkStream: TMemoryStream; const Password: String; DecryptCheck: UInt64);
procedure DecryptStream_AES256(WorkStream: TMemoryStream; const Password: String; DecryptCheck: UInt64);

implementation

uses
  MD5, SHA2, AES, StrRect, BinaryStreaming,
  InflatablesList_Types;

procedure EncryptStream_AES256(WorkStream: TMemoryStream; const Password: String; DecryptCheck: UInt64);
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

  Unencrypted size of data (UInt64) is stored just before the cipher stream.

  Key is obtained as SHA-256 of UTF16-encoded list password.

  Init vector is obtained as MD5 of UTF16-encoded list password.

  Correct decryption is checked on last 8 bytes of unencrypted data - it must
  match IL_LISTFILE_DECRYPT_CHECK constant.

  Output pseudo-structure:

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
  Stream_WriteUInt64(TempStream,DecryptCheck);
  DataSize := UInt64(TempStream.Size);
  // get key and init vector
  Key := BinaryCorrectSHA2(WideStringSHA2(sha256,StrToUnicode(Password)).Hash256);
  InitVector := BinaryCorrectMD5(WideStringMD5(StrToUnicode(Password)));
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
  Stream_WriteBuffer(WorkStream,TempStream.Memory^,TMemSize(TempStream.Size));
  WorkStream.Size := WorkStream.Position;
finally
  TempStream.Free;
end;
end;

//------------------------------------------------------------------------------  

procedure DecryptStream_AES256(WorkStream: TMemoryStream; const Password: String; DecryptCheck: UInt64);
var
  TempStream: TMemoryStream;
  DataSize:   UInt64;
  Key:        TSHA2Hash_256;
  InitVector: TMD5Hash;
  Cipher:     TAESCipherAccelerated;
begin
TempStream := TMemoryStream.Create;
try
  // load encrypted and unencrypted data sizes
  WorkStream.Seek(0,soBeginning);
  DataSize := Stream_ReadUInt64(WorkStream);
  // preallocate stream
  TempStream.Size := WorkStream.Size;
  // load encrypted data into temp
  Stream_ReadBuffer(WorkStream,TempStream.Memory^,TMemSize(TempStream.Size));
  // get key and init vector
  Key := BinaryCorrectSHA2(WideStringSHA2(sha256,StrToUnicode(Password)).Hash256);
  InitVector := BinaryCorrectMD5(WideStringMD5(StrToUnicode(Password)));
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
  If Stream_ReadUInt64(TempStream) <> DecryptCheck then
    raise EILWrongPassword.Create('DecryptStream_AES256: Decryption failed, wrong password?');
  //write decrypted data without validity check
  WorkStream.Seek(0,soBeginning);
  Stream_WriteBuffer(WorkStream,TempStream.Memory^,TMemSize(TempStream.Size - SizeOf(UInt64)));
  WorkStream.Size := WorkStream.Position;
finally
  TempStream.Free;
end;
end;

end.
