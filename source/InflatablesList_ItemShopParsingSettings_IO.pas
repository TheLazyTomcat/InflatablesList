unit InflatablesList_ItemShopParsingSettings_IO;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  Classes,
  AuxTypes,
  InflatablesList_ItemShopParsingSettings_Base;

const
  IL_SHOPPARSSETT_SIGNATURE = UInt32($53524150);  // PARS

  IL_SHOPPARSSETT_STREAMSTRUCTURE_00000000 = UInt32($00000000);
  IL_SHOPPARSSETT_STREAMSTRUCTURE_00000001 = UInt32($00000001);

  IL_SHOPPARSSETT_STREAMSTRUCTURE_SAVE = IL_SHOPPARSSETT_STREAMSTRUCTURE_00000001;

type
  TILItemShopParsingSettings_IO = class(TILItemShopParsingSettings_Base)
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
  StrRect, BinaryStreaming;

procedure TILItemShopParsingSettings_IO.Save(Stream: TStream; Struct: UInt32);
begin
InitSaveFunctions(Struct);
fFNSaveToStream(Stream);
end;

//------------------------------------------------------------------------------

procedure TILItemShopParsingSettings_IO.Load(Stream: TStream; Struct: UInt32);
begin
InitLoadFunctions(Struct);
fFNLoadFromStream(Stream);
end;

//==============================================================================

procedure TILItemShopParsingSettings_IO.SaveToStream(Stream: TStream);
begin
Stream_WriteUInt32(Stream,IL_SHOPPARSSETT_SIGNATURE);
Stream_WriteUInt32(Stream,IL_SHOPPARSSETT_STREAMSTRUCTURE_SAVE);
Save(Stream,IL_SHOPPARSSETT_STREAMSTRUCTURE_SAVE);
end;

//------------------------------------------------------------------------------

procedure TILItemShopParsingSettings_IO.LoadFromStream(Stream: TStream);
begin
If Stream_ReadUInt32(Stream) = IL_SHOPPARSSETT_SIGNATURE then
  Load(Stream,Stream_ReadUInt32(Stream))
else
  raise Exception.Create('TILItemShopParsingSettings_IO.LoadFromStream: Invalid stream.');
end;

//------------------------------------------------------------------------------

procedure TILItemShopParsingSettings_IO.SaveToFile(const FileName: String);
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

procedure TILItemShopParsingSettings_IO.LoadFromFile(const FileName: String);
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
