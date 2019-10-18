unit InflatablesList_Manager_IO_0000000B;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  Classes,
  AuxTypes,
  InflatablesList_Manager_IO_0000000A;

type
  TILManager_IO_0000000B = class(TILManager_IO_0000000A)
  protected
    procedure InitSaveFunctions(Struct: UInt32); override;
    procedure InitLoadFunctions(Struct: UInt32); override;
    procedure SaveList_Plain_0000000B(Stream: TStream); virtual;
    procedure LoadList_Plain_0000000B(Stream: TStream); virtual;
  end;

implementation

uses
  SysUtils,
  BinaryStreaming,
  InflatablesList_Utils,
  InflatablesList_Manager_IO;

procedure TILManager_IO_0000000B.InitSaveFunctions(Struct: UInt32);
begin
If Struct = IL_LISTFILE_STREAMSTRUCTURE_0000000B then
  begin
    fFNSaveToStream := SaveList_0000000A;
    fFNSaveSortingSettings := SaveSortingSettings_0000000A;
    fFNSaveShopTemplates := SaveShopTemplates_00000008;
    fFNSaveFilterSettings := SaveFilterSettings_00000008;
    fFNSaveItems := SaveItems_00000008;
    fFNCompressStream := CompressStream_ZLIB;
    fFNEncryptStream := EncryptStream_AES256;
    fFNSaveToStreamPlain := SaveList_Plain_0000000B;
    fFNSaveToStreamProc := SaveList_Processed_0000000A;
  end
else inherited InitSaveFunctions(Struct);
end;

//------------------------------------------------------------------------------

procedure TILManager_IO_0000000B.InitLoadFunctions(Struct: UInt32);
begin
If Struct = IL_LISTFILE_STREAMSTRUCTURE_0000000B then
  begin
    fFNLoadFromStream := LoadList_0000000A;
    fFNLoadSortingSettings := LoadSortingSettings_0000000A;
    fFNLoadShopTemplates := LoadShopTemplates_00000008;
    fFNLoadFilterSettings := LoadFilterSettings_00000008;
    fFNLoadItems := LoadItems_00000008;
    fFNDecompressStream := DecompressStream_ZLIB;
    fFNDecryptStream := DecryptStream_AES256; 
    fFNLoadFromStreamPlain := LoadList_Plain_0000000B;
    fFNLoadFromStreamProc := LoadList_Processed_0000000A;
  end
else
inherited InitLoadFunctions(Struct);
end;

//------------------------------------------------------------------------------

procedure TILManager_IO_0000000B.SaveList_Plain_0000000B(Stream: TStream);
begin
SaveList_Plain_0000000A(Stream);
Stream_WriteString(Stream,fListName);
end;

//------------------------------------------------------------------------------

procedure TILManager_IO_0000000B.LoadList_Plain_0000000B(Stream: TStream);
begin
LoadList_Plain_0000000A(Stream);
fListName := Stream_ReadString(Stream);
end;

end.
