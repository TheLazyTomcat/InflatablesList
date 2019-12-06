unit InflatablesList_Manager_IO_0000000A;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  Classes,
  AuxTypes,
  InflatablesList_Types,
  InflatablesList_Manager_IO_00000009;

{
  fFNSaveTo(LoadFrom)Stream functions is a redirector, it saves(loads) data that
  are considered to not to be part of the list and then calls plain save(load)
  or processed save(load) according to certain criteria.

  Processed save(load) work with plain save(load) and only process the full
  stream, it must never create its own data stream.
}
type
  TILManager_IO_0000000A = class(TILManager_IO_00000009)
  protected
    fFNCompressStream:      procedure(Stream: TMemoryStream) of object;
    fFNDecompressStream:    procedure(Stream: TMemoryStream) of object;
    fFNEncryptStream:       procedure(Stream: TMemoryStream) of object;
    fFNDecryptStream:       procedure(Stream: TMemoryStream) of object;
    fFNSaveToStreamPlain:   procedure(Stream: TStream) of object;
    fFNLoadFromStreamPlain: procedure(Stream: TStream) of object;
    fFNSaveToStreamProc:    procedure(Stream: TStream) of object;
    fFNLoadFromStreamProc:  procedure(Stream: TStream) of object;
    // special functions
    Function GetFlagsWord: UInt32; virtual;
    procedure SetFlagsWord(FlagsWord: UInt32); virtual;
    class procedure DecodeFlagsWord(FlagsWord: UInt32; var PreloadResult: TILPreloadResultFlags); virtual;
    // stream processing functions
    procedure CompressStream_ZLIB(WorkStream: TMemoryStream); virtual;
    procedure DecompressStream_ZLIB(WorkStream: TMemoryStream); virtual;
    procedure EncryptStream_AES256(WorkStream: TMemoryStream); virtual;
    procedure DecryptStream_AES256(WorkStream: TMemoryStream); virtual;
    // normal IO methods
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
    procedure Preload_0000000A(Stream: TStream; out Info: TILPreloadInfo); virtual;
  end;

implementation

uses
  SysUtils, DateUtils,
  BinaryStreaming, WinFileInfo, BitOps, SimpleCompress,
  InflatablesList_Utils,
  InflatablesList_Encryption,
  InflatablesList_Manager_IO;

Function TILManager_IO_0000000A.GetFlagsWord: UInt32;
begin
Result := 0;
SetFlagStateValue(Result,IL_LIST_FLAG_BITMASK_ENCRYPTED,fEncrypted);
SetFlagStateValue(Result,IL_LIST_FLAG_BITMASK_COMPRESSED,fCompressed);
end;

//------------------------------------------------------------------------------

procedure TILManager_IO_0000000A.SetFlagsWord(FlagsWord: UInt32);
begin
fEncrypted := GetFlagState(FlagsWord,IL_LIST_FLAG_BITMASK_ENCRYPTED);
fCompressed := GetFlagState(FlagsWord,IL_LIST_FLAG_BITMASK_COMPRESSED);
end;

//------------------------------------------------------------------------------

class procedure TILManager_IO_0000000A.DecodeFlagsWord(FlagsWord: UInt32; var PreloadResult: TILPreloadResultFlags);
begin
If GetFlagState(FlagsWord,IL_LIST_FLAG_BITMASK_ENCRYPTED) then
  Include(PreloadResult,ilprfEncrypted);
If GetFlagState(FlagsWord,IL_LIST_FLAG_BITMASK_COMPRESSED) then
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
begin
WorkStream.Seek(0,soBeginning);
InflatablesList_Encryption.EncryptStream_AES256(WorkStream,fListPassword,IL_LISTFILE_DECRYPT_CHECK);
end;

//------------------------------------------------------------------------------

procedure TILManager_IO_0000000A.DecryptStream_AES256(WorkStream: TMemoryStream);
begin
WorkStream.Seek(0,soBeginning);
InflatablesList_Encryption.DecryptStream_AES256(WorkStream,fListPassword,IL_LISTFILE_DECRYPT_CHECK);
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
    fFNSaveToStreamPlain := SaveList_Plain_0000000A;
    fFNSaveToStreamProc := SaveList_Processed_0000000A;
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
    fFNLoadFromStreamPlain := LoadList_Plain_0000000A;
    fFNLoadFromStreamProc := LoadList_Processed_0000000A;
  end
else inherited InitLoadFunctions(Struct);
end;

//------------------------------------------------------------------------------

procedure TILManager_IO_0000000A.InitPreloadFunctions(Struct: UInt32);
begin
If Struct = IL_LISTFILE_STREAMSTRUCTURE_0000000A then
  fFNPreload := Preload_0000000A
else
  fFNPreload := nil;
end;

//------------------------------------------------------------------------------

procedure TILManager_IO_0000000A.SaveList_0000000A(Stream: TStream);
var
  Time: TDateTIme;
begin
Stream_WriteUInt32(Stream,GetFlagsWord);
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
If fEncrypted or fCompressed then
  fFNSaveToStreamProc(Stream)
else
  fFNSaveToStreamPlain(Stream);
end;

//------------------------------------------------------------------------------

procedure TILManager_IO_0000000A.LoadList_0000000A(Stream: TStream);
begin
SetFlagsWord(Stream_ReadUInt32(Stream));
Stream_ReadInt64(Stream);   // discard version of the program in which the file was saved
Stream_ReadInt64(Stream);   // discard time
Stream_ReadString(Stream);  // discard time string
If fEncrypted or fCompressed then
  fFNLoadFromStreamProc(Stream)
else
  fFNLoadFromStreamPlain(Stream);
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
begin
fFNSaveSortingSettings(Stream);
fFNSaveShopTemplates(Stream);
fFNSaveFilterSettings(Stream);
fFNSaveItems(Stream);
Stream_WriteString(Stream,fNotes);
end;

//------------------------------------------------------------------------------

procedure TILManager_IO_0000000A.LoadList_Plain_0000000A(Stream: TStream);
begin
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
  fFNSaveToStreamPlain(TempStream);
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
  fFNLoadFromStreamPlain(TempStream);
finally
  TempStream.Free;
end;
end;

//------------------------------------------------------------------------------

procedure TILManager_IO_0000000A.Preload_0000000A(Stream: TStream; out Info: TILPreloadInfo);
begin
Info.Flags := Stream_ReadUInt32(Stream);
DecodeFlagsWord(Info.Flags,Info.ResultFlags);
Info.Version.Full := Stream_ReadInt64(Stream);
Info.TimeRaw := Stream_ReadInt64(Stream);
Info.Time := UnixToDateTime(Info.TimeRaw);
Info.TimeStr := Stream_ReadString(Stream);
Include(Info.ResultFlags,ilprfExtInfo);
end;

end.

