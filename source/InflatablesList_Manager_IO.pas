unit InflatablesList_Manager_IO;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  Classes,
  AuxTypes,
  InflatablesList_Types, InflatablesList_Manager_Shops;

const
  IL_LISTFILE_SIGNATURE = UInt32($4C464E49);  // signature of the list file

  IL_LISTFILE_FILESTRUCTURE_00000000 = UInt32($00000000);
  IL_LISTFILE_FILESTRUCTURE_00000001 = UInt32($00000001);
  IL_LISTFILE_FILESTRUCTURE_00000002 = UInt32($00000002);
  IL_LISTFILE_FILESTRUCTURE_00000003 = UInt32($00000003);
  IL_LISTFILE_FILESTRUCTURE_00000004 = UInt32($00000004);
  IL_LISTFILE_FILESTRUCTURE_00000005 = UInt32($00000005);
  IL_LISTFILE_FILESTRUCTURE_00000006 = UInt32($00000006);
  IL_LISTFILE_FILESTRUCTURE_00000007 = UInt32($00000007);

  IL_LISTFILE_FILESTRUCTURE_SAVE = IL_LISTFILE_FILESTRUCTURE_00000007;

type
  TILManager_IO = class(TILManager_Shops)
  protected
    fFNSaveToStream:        procedure(Stream: TStream) of object;
    fFNLoadFromStream:      procedure(Stream: TStream) of object;
    fFNSaveSortingSettings: procedure(Stream: TStream) of object;
    fFNLoadSortingSettings: procedure(Stream: TStream) of object;
    fFNSaveShopTemplates:   procedure(Stream: TStream) of object;
    fFNLoadShopTemplates:   procedure(Stream: TStream) of object;
    fFNSaveFilterSettings:  procedure(Stream: TStream) of object;
    fFNLoadFilterSettings:  procedure(Stream: TStream) of object;
    fFNSaveItem:            procedure(Stream: TStream; const Item: TILItem) of object;
    fFNLoadItem:            procedure(Stream: TStream; out Item: TILItem) of object;
    fFNSaveItemShop:        procedure(Stream: TStream; const Shop: TILItemShop) of object;
    fFNLoadItemShop:        procedure(Stream: TStream; out Shop: TILItemShop) of object;
    fFNSaveParsingSettings: procedure(Stream: TStream; const ParsSett: TILItemShopParsingSetting) of object;
    fFNLoadParsingSettings: procedure(Stream: TStream; out ParsSett: TILItemShopParsingSetting) of object;
    fFNExportShopTemplate:  procedure(Stream: TStream; const ShopTemplate: TILShopTemplate) of object;
    fFNImportShopTemplate:  procedure(Stream: TStream; out ShopTemplate: TILShopTemplate) of object;
    procedure InitSaveFunctions(Struct: UInt32); virtual; abstract;
    procedure InitLoadFunctions(Struct: UInt32); virtual; abstract;
    procedure SaveData(Stream: TStream; Struct: UInt32); virtual;
    procedure LoadData(Stream: TStream; Struct: UInt32); virtual;
    procedure ExportShopTemplate(Stream: TStream; const ShopTemplate: TILShopTemplate; Struct: UInt32); virtual;
    procedure ImportShopTemplate(Stream: TStream; out ShopTemplate: TILShopTemplate; Struct: UInt32); virtual;
  public
    procedure SaveToStream(Stream: TStream); virtual;
    procedure SaveToFile(const FileName: String); virtual;
    procedure SaveToFileBuffered(const FileName: String); virtual;
    procedure LoadFromStream(Stream: TStream); virtual;
    procedure LoadFromFile(const FileName: String); virtual;
    procedure LoadFromFileBuffered(const FileName: String); virtual;
  end;

implementation

uses
  SysUtils,
  BinaryStreaming,
  InflatablesList_Manager_Base;

procedure TILManager_IO.SaveData(Stream: TStream; Struct: UInt32);
begin
InitSaveFunctions(Struct);
fFNSaveToStream(Stream);
end;

//------------------------------------------------------------------------------

procedure TILManager_IO.LoadData(Stream: TStream; Struct: UInt32);
begin
InitLoadFunctions(Struct);
fFNLoadFromStream(Stream);
end;

//------------------------------------------------------------------------------

procedure TILManager_IO.ExportShopTemplate(Stream: TStream; const ShopTemplate: TILShopTemplate; Struct: UInt32);
begin
InitSaveFunctions(Struct);
fFNExportShopTemplate(Stream,ShopTemplate);
end;

//------------------------------------------------------------------------------

procedure TILManager_IO.ImportShopTemplate(Stream: TStream; out ShopTemplate: TILShopTemplate; Struct: UInt32);
begin
InitLoadFunctions(Struct);
fFNImportShopTemplate(Stream,ShopTemplate);
end;

//==============================================================================

procedure TILManager_IO.SaveToStream(Stream: TStream);
begin
Stream_WriteUInt32(Stream,IL_LISTFILE_SIGNATURE);
Stream_WriteUInt32(Stream,IL_LISTFILE_FILESTRUCTURE_SAVE);
SaveData(Stream,IL_LISTFILE_FILESTRUCTURE_SAVE);
end;

//------------------------------------------------------------------------------

procedure TILManager_IO.SaveToFile(const FileName: String);
var
  FileStream: TFileStream;
begin
FileStream := TFileStream.Create(FileName,fmCreate or fmShareDenyWrite);
try
  SaveToStream(FileStream);
  FileStream.Size := FileStream.Position;
  fFileName := FileName;
finally
  FileStream.Free;
end;
end;

//------------------------------------------------------------------------------

procedure TILManager_IO.SaveToFileBuffered(const FileName: String);
var
  FileStream: TMemoryStream;
begin
FileStream := TMemoryStream.Create;
try
  //prealloc
  FileStream.Size := Length(fList) * (45 * 1024); {~45Kib per item}
  SaveToStream(FileStream);
  FileStream.Size := FileStream.Position;
  FileStream.SaveToFile(FileName);
  fFileName := FileName;
finally
  FileStream.Free;
end;
end;

//------------------------------------------------------------------------------

procedure TILManager_IO.LoadFromStream(Stream: TStream);
begin
If Stream_ReadUInt32(Stream) <> UInt32(IL_LISTFILE_SIGNATURE) then
  raise Exception.Create('TILManager_Base.LoadFromStream: Unknown file format.');
LoadData(Stream,Stream_ReadUInt32(Stream));
end;

//------------------------------------------------------------------------------

procedure TILManager_IO.LoadFromFile(const FileName: String);
var
  FileStream: TFileStream;
begin
FileStream := TFileStream.Create(FileName,fmOpenRead or fmShareDenyWrite);
try
  LoadFromStream(FileStream);
  fFileName := FileName;
finally
  FileStream.Free;
end;
end;

//------------------------------------------------------------------------------

procedure TILManager_IO.LoadFromFileBuffered(const FileName: String);
var
  FileStream: TMemoryStream;
begin
FileStream := TMemoryStream.Create;
try
  FileStream.LoadFromFile(FileName);
  FileStream.Seek(0,soBeginning);
  LoadFromStream(FileStream);
  fFileName := FileName;
finally
  FileStream.Free;
end;
end;

end.
