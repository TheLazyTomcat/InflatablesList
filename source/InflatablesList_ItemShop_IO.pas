unit InflatablesList_ItemShop_IO;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  Classes,
  AuxTypes,
  InflatablesList_ItemShop_Search;

const
  IL_ITEMSHOP_SIGNATURE = UInt32($504F4853);  // SHOP

  IL_ITEMSHOP_STREAMSTRUCTURE_00000000 = UInt32($00000000);
  IL_ITEMSHOP_STREAMSTRUCTURE_00000001 = UInt32($00000001);

  IL_ITEMSHOP_STREAMSTRUCTURE_SAVE = IL_ITEMSHOP_STREAMSTRUCTURE_00000001;

type
  TILItemShop_IO = class(TILItemShop_Search)
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

procedure TILItemShop_IO.Save(Stream: TStream; Struct: UInt32);
begin
InitSaveFunctions(Struct);
fFNSaveToStream(Stream);
end;

//------------------------------------------------------------------------------

procedure TILItemShop_IO.Load(Stream: TStream; Struct: UInt32);
begin
InitLoadFunctions(Struct);
fFNLoadFromStream(Stream);
end;

//==============================================================================

procedure TILItemShop_IO.SaveToStream(Stream: TStream);
begin
Stream_WriteUInt32(Stream,IL_ITEMSHOP_SIGNATURE);
Stream_WriteUInt32(Stream,IL_ITEMSHOP_STREAMSTRUCTURE_SAVE);
Save(Stream,IL_ITEMSHOP_STREAMSTRUCTURE_SAVE);
end;

//------------------------------------------------------------------------------

procedure TILItemShop_IO.LoadFromStream(Stream: TStream);
begin
If Stream_ReadUInt32(Stream) = IL_ITEMSHOP_SIGNATURE then
  Load(Stream,Stream_ReadUInt32(Stream))
else
  raise Exception.Create('TILItemShop_IO.LoadFromStream: Invalid stream.');
end;

//------------------------------------------------------------------------------

procedure TILItemShop_IO.SaveToFile(const FileName: String);
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

procedure TILItemShop_IO.LoadFromFile(const FileName: String);
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
