unit InflatablesList_ItemShopTemplate_IO_00000000;{$message 'revisit'}

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  Classes,
  AuxTypes,
  InflatablesList_ItemShopTemplate_IO;

type
  TILItemShopTemplate_IO_00000000 = class(TILItemShopTemplate_IO)
  protected
    procedure InitSaveFunctions(Struct: UInt32); override;
    procedure InitLoadFunctions(Struct: UInt32); override;
    procedure SaveTemplate_00000000(Stream: TStream); virtual;
    procedure LoadTemplate_00000000(Stream: TStream); virtual;
  end;

implementation

uses
  SysUtils,
  BinaryStreaming;

procedure TILItemShopTemplate_IO_00000000.InitSaveFunctions(Struct: UInt32);
begin
If Struct = IL_SHOPTEMPLATE_STREAMSTRUCTURE_00000000 then
  fFNSaveToStream := SaveTemplate_00000000
else
  raise Exception.CreateFmt('TILItemShopTemplate_IO_00000000.InitSaveFunctions: Invalid stream structure (%.8x).',[Struct]);
end;

//------------------------------------------------------------------------------

procedure TILItemShopTemplate_IO_00000000.InitLoadFunctions(Struct: UInt32);
begin
If Struct = IL_SHOPTEMPLATE_STREAMSTRUCTURE_00000000 then
  fFNLoadFromStream := LoadTemplate_00000000
else
  raise Exception.CreateFmt('TILItemShopTemplate_IO_00000000.InitLoadFunctions: Invalid stream structure (%.8x).',[Struct]);
end;

//------------------------------------------------------------------------------

procedure TILItemShopTemplate_IO_00000000.SaveTemplate_00000000(Stream: TStream);
begin
Stream_WriteString(Stream,fName);
Stream_WriteString(Stream,fShopName);
Stream_WriteBool(Stream,fUntracked);
Stream_WriteBool(Stream,fAltDownMethod);
Stream_WriteString(Stream,fShopURL);
fParsingSettings.SaveToStream(Stream);
end;

//------------------------------------------------------------------------------

procedure TILItemShopTemplate_IO_00000000.LoadTemplate_00000000(Stream: TStream);
begin
fName := Stream_ReadString(Stream);
fShopName := Stream_ReadString(Stream);
fUntracked := Stream_ReadBool(Stream);
fAltDownMethod := Stream_ReadBool(Stream);
fShopURL := Stream_ReadString(Stream);
fParsingSettings.LoadFromStream(Stream);
end;

end.
