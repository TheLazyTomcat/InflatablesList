unit InflatablesList_ItemShopTemplate_IO_00000001;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  Classes,
  AuxTypes,
  InflatablesList_ItemShopTemplate_IO_00000000;

type
  TILItemShopTemplate_IO_00000001 = class(TILItemShopTemplate_IO_00000000)
  protected
    Function GetFlagsWord: UInt32; virtual;
    procedure SetFlagsWord(FlagsWord: UInt32); virtual;
    procedure InitSaveFunctions(Struct: UInt32); override;
    procedure InitLoadFunctions(Struct: UInt32); override;
    procedure SaveTemplate_00000001(Stream: TStream); virtual;
    procedure LoadTemplate_00000001(Stream: TStream); virtual;
  end;

implementation

uses
  BinaryStreaming,
  InflatablesList_ItemShopTemplate_IO;

Function TILItemShopTemplate_IO_00000001.GetFlagsWord: UInt32;
begin
Result := 0;
end;

//------------------------------------------------------------------------------

procedure TILItemShopTemplate_IO_00000001.SetFlagsWord(FlagsWord: UInt32);
begin
// nothing to do atm.
end;

//------------------------------------------------------------------------------

procedure TILItemShopTemplate_IO_00000001.InitSaveFunctions(Struct: UInt32);
begin
If Struct = IL_SHOPTEMPLATE_STREAMSTRUCTURE_00000001 then
  fFNSaveToStream := SaveTemplate_00000001
else
  inherited InitSaveFunctions(Struct);
end;

//------------------------------------------------------------------------------

procedure TILItemShopTemplate_IO_00000001.InitLoadFunctions(Struct: UInt32);
begin
If Struct = IL_SHOPTEMPLATE_STREAMSTRUCTURE_00000001 then
  fFNLoadFromStream := LoadTemplate_00000001
else
  inherited InitLoadFunctions(Struct);
end;

//------------------------------------------------------------------------------

procedure TILItemShopTemplate_IO_00000001.SaveTemplate_00000001(Stream: TStream);
begin
Stream_WriteUInt32(Stream,GetFlagsWord);
// rest of the structure is unchanged from ver 0
SaveTemplate_00000000(Stream);
end;

//------------------------------------------------------------------------------

procedure TILItemShopTemplate_IO_00000001.LoadTemplate_00000001(Stream: TStream);
begin
SetFlagsWord(Stream_ReadUInt32(Stream));
LoadTemplate_00000000(Stream);
end;

end.
