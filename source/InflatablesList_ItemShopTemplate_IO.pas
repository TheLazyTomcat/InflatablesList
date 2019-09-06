unit InflatablesList_ItemShopTemplate_IO;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  Classes,
  AuxTypes,
  InflatablesList_ItemShopTemplate_Base;

const
  IL_SHOPTEMPLATE_SIGNATURE = UInt32($4C504D54);  // TMPL

  IL_SHOPTEMPLATE_STREAMSTRUCTURE_00000000 = UInt32($00000000);

  IL_SHOPTEMPLATE_STREAMSTRUCTURE_SAVE = IL_SHOPTEMPLATE_STREAMSTRUCTURE_00000000;

type
  TILItemShopTemplate_IO = class(TILItemShopTemplate_Base)
  protected
    fFNSaveToStream:    procedure(Stream: TStream) of object;
    fFNLoadFromStream:  procedure(Stream: TStream) of object;
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
  BinaryStreaming, StrRect;

procedure TILItemShopTemplate_IO.Save(Stream: TStream; Struct: UInt32);
begin
InitSaveFunctions(Struct);
fFNSaveToStream(Stream);
end;

//------------------------------------------------------------------------------

procedure TILItemShopTemplate_IO.Load(Stream: TStream; Struct: UInt32);
begin
InitLoadFunctions(Struct);
fFNLoadFromStream(Stream);
end;

//==============================================================================

procedure TILItemShopTemplate_IO.SaveToStream(Stream: TStream);
begin
Stream_WriteUInt32(Stream,IL_SHOPTEMPLATE_SIGNATURE);
Stream_WriteUInt32(Stream,IL_SHOPTEMPLATE_STREAMSTRUCTURE_SAVE);
Save(Stream,IL_SHOPTEMPLATE_STREAMSTRUCTURE_SAVE);
end;

//------------------------------------------------------------------------------

procedure TILItemShopTemplate_IO.LoadFromStream(Stream: TStream);
begin
If Stream_ReadUInt32(Stream) = IL_SHOPTEMPLATE_SIGNATURE then
  Load(Stream,Stream_ReadUInt32(Stream))
else
  raise Exception.Create('TILItemShopTemplate_IO.LoadFromStream: Invalid stream.');
end;

//------------------------------------------------------------------------------

procedure TILItemShopTemplate_IO.SaveToFile(const FileName: String);
var
  FileStream: TMemoryStream;
begin
FileStream := TMemoryStream.Create;
try
  SaveToStream(FileStream);
  FileStream.SaveToFile(StrToRTL(FileName));
finally
  FileStream.Free;
end;
end;

//------------------------------------------------------------------------------

procedure TILItemShopTemplate_IO.LoadFromFile(const FileName: String);
var
  FileStream: TMemoryStream;
begin
FileStream := TMemoryStream.Create;
try
  FileStream.LoadFromFile(StrToRTL(FileName));
  FileStream.Seek(0,soBeginning);
  LoadFromStream(FileStream);
finally
  FileStream.Free;
end;
end;

end.
