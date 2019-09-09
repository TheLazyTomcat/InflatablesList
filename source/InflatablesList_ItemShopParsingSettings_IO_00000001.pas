unit InflatablesList_ItemShopParsingSettings_IO_00000001;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  AuxTypes,
  Classes,
  InflatablesList_ItemShopParsingSettings_IO_00000000;

type
  TILItemShopParsingSettings_IO_00000001 = class(TILItemShopParsingSettings_IO_00000000)
  protected
    Function GetFlagsWord: UInt32; virtual;
    procedure SetFlagsWord(FlagsWord: UInt32); virtual;
    procedure InitSaveFunctions(Struct: UInt32); override;
    procedure InitLoadFunctions(Struct: UInt32); override;
    procedure SaveSettings_00000001(Stream: TStream); virtual;
    procedure LoadSettings_00000001(Stream: TStream); virtual;
  end;

implementation

uses
  BinaryStreaming,
  InflatablesList_ItemShopParsingSettings_IO;

Function TILItemShopParsingSettings_IO_00000001.GetFlagsWord: UInt32;
begin
Result := 0;
end;

//------------------------------------------------------------------------------

procedure TILItemShopParsingSettings_IO_00000001.SetFlagsWord(FlagsWord: UInt32);
begin
// nothing to do
end;

//------------------------------------------------------------------------------

procedure TILItemShopParsingSettings_IO_00000001.InitSaveFunctions(Struct: UInt32);
begin
If Struct = IL_SHOPPARSSETT_STREAMSTRUCTURE_00000001 then
  fFNSaveToStream := SaveSettings_00000001
else
  inherited InitSaveFunctions(Struct);
end;

//------------------------------------------------------------------------------

procedure TILItemShopParsingSettings_IO_00000001.InitLoadFunctions(Struct: UInt32);
begin
If Struct = IL_SHOPPARSSETT_STREAMSTRUCTURE_00000001 then
  fFNLoadFromStream := LoadSettings_00000001
else
  inherited InitLoadFunctions(Struct);
end;

//------------------------------------------------------------------------------

procedure TILItemShopParsingSettings_IO_00000001.SaveSettings_00000001(Stream: TStream);
begin
Stream_WriteUInt32(Stream,GetFlagsWord);
// rest of the structure is the same as in ver 0
SaveSettings_00000000(Stream);
end;

//------------------------------------------------------------------------------

procedure TILItemShopParsingSettings_IO_00000001.LoadSettings_00000001(Stream: TStream);
begin
SetFlagsWord(Stream_ReadUInt32(Stream));
LoadSettings_00000000(Stream);
end;

end.
