unit IL_Manager_IO;

{$INCLUDE '.\IL_defs.inc'}

interface

uses
  Classes,
  AuxTypes,
  IL_Manager_Templates;

const
  IL_LISTFILE_SIGNATURE = UInt32($4C464E49);  // signature of the list file

  // 0 - 6 are deprecated (unsupported), 7 can be only read (converted)
  IL_LISTFILE_STREAMSTRUCTURE_00000000 = UInt32($00000000);
  IL_LISTFILE_STREAMSTRUCTURE_00000001 = UInt32($00000001);
  IL_LISTFILE_STREAMSTRUCTURE_00000002 = UInt32($00000002);
  IL_LISTFILE_STREAMSTRUCTURE_00000003 = UInt32($00000003);
  IL_LISTFILE_STREAMSTRUCTURE_00000004 = UInt32($00000004);
  IL_LISTFILE_STREAMSTRUCTURE_00000005 = UInt32($00000005);
  IL_LISTFILE_STREAMSTRUCTURE_00000006 = UInt32($00000006);
  IL_LISTFILE_STREAMSTRUCTURE_00000007 = UInt32($00000007);
  IL_LISTFILE_STREAMSTRUCTURE_00000008 = UInt32($00000008);

  IL_LISTFILE_STREAMSTRUCTURE_SAVE = IL_LISTFILE_STREAMSTRUCTURE_00000008;

type
  TILManager_IO = class(TILManager_Templates)
  protected
    fFNSaveToStream:        procedure(Stream: TStream) of object;
    fFNLoadFromStream:      procedure(Stream: TStream) of object;
    fFNSaveSortingSettings: procedure(Stream: TStream) of object;
    fFNLoadSortingSettings: procedure(Stream: TStream) of object;
    fFNSaveShopTemplates:   procedure(Stream: TStream) of object;
    fFNLoadShopTemplates:   procedure(Stream: TStream) of object;
    fFNSaveFilterSettings:  procedure(Stream: TStream) of object;
    fFNLoadFilterSettings:  procedure(Stream: TStream) of object;
    fFNSaveItems:           procedure(Stream: TStream) of object;
    fFNLoadItems:           procedure(Stream: TStream) of object;
    procedure Convert_7_to_8(Stream: TStream); virtual; abstract;
    procedure InitSaveFunctions(Struct: UInt32); virtual; abstract;
    procedure InitLoadFunctions(Struct: UInt32); virtual; abstract;
    procedure Save(Stream: TStream; Struct: UInt32); virtual;
    procedure Load(Stream: TStream; Struct: UInt32); virtual;
  public
    procedure SaveToStream(Stream: TStream); virtual;
    procedure LoadFromStream(Stream: TStream); virtual;    
    procedure SaveToFile(const FileName: String); virtual;
    procedure LoadFromFile(const FileName: String); virtual;    
  end;

implementation

uses
  SysUtils,
  BinaryStreaming;

procedure TILManager_IO.Save(Stream: TStream; Struct: UInt32);
begin
InitSaveFunctions(Struct);
fFNSaveToStream(Stream);
end;

//------------------------------------------------------------------------------

procedure TILManager_IO.Load(Stream: TStream; Struct: UInt32);
begin
If Struct = IL_LISTFILE_STREAMSTRUCTURE_00000007 then
  Convert_7_to_8(Stream)
else
  begin
    InitLoadFunctions(Struct);
    fFNLoadFromStream(Stream);
  end;
end;

//==============================================================================

procedure TILManager_IO.SaveToStream(Stream: TStream);
begin
Stream_WriteUInt32(Stream,IL_LISTFILE_SIGNATURE);
Stream_WriteUInt32(Stream,IL_LISTFILE_STREAMSTRUCTURE_SAVE);
Save(Stream,IL_LISTFILE_STREAMSTRUCTURE_SAVE);
end;

//------------------------------------------------------------------------------

procedure TILManager_IO.LoadFromStream(Stream: TStream);
begin
If Stream_ReadUInt32(Stream) = IL_LISTFILE_SIGNATURE then
  Load(Stream,Stream_ReadUInt32(Stream))
else
  raise Exception.Create('TILItem_IO.LoadFromStream: Invalid stream.');
end;

//------------------------------------------------------------------------------

procedure TILManager_IO.SaveToFile(const FileName: String);
var
  FileStream: TMemoryStream;
begin
FileStream := TMemoryStream.Create;
try
  SaveToStream(FileStream);
  FileStream.SaveToFile(FileName);
finally
  FileStream.Free;
end;
end;

//------------------------------------------------------------------------------

procedure TILManager_IO.LoadFromFile(const FileName: String);
var
  FileStream: TMemoryStream;
begin
FileStream := TMemoryStream.Create;
try
  FileStream.LoadFromFile(FileName);
  FileStream.Seek(0,soBeginning);
  LoadFromStream(FileStream);
finally
  FileStream.Free;
end;
end;

end.
