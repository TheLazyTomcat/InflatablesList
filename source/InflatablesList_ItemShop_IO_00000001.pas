unit InflatablesList_ItemShop_IO_00000001;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  Classes,
  AuxTypes,
  InflatablesList_ItemShop_IO_00000000;

type
  TILItemShop_IO_00000001 = class(TILItemShop_IO_00000000)
  protected
    Function GetFlagsWord: UInt32; virtual;
    procedure SetFlagsWord(FlagsWord: UInt32); virtual;
    procedure InitSaveFunctions(Struct: UInt32); override;
    procedure InitLoadFunctions(Struct: UInt32); override;
    procedure SaveItemShop_00000001(Stream: TStream); virtual;
    procedure LoadItemShop_00000001(Stream: TStream); virtual;
  end;

implementation

uses
  DateUtils,
  BinaryStreaming,
  InflatablesList_ItemShop_IO;

Function TILItemShop_IO_00000001.GetFlagsWord: UInt32;
begin
Result := 0;
end;

//------------------------------------------------------------------------------

procedure TILItemShop_IO_00000001.SetFlagsWord(FlagsWord: UInt32);
begin
// nothing to do
end;

//------------------------------------------------------------------------------

procedure TILItemShop_IO_00000001.InitSaveFunctions(Struct: UInt32);
begin
If Struct = IL_ITEMSHOP_STREAMSTRUCTURE_00000001 then
  fFNSaveToStream := SaveItemShop_00000001
else
  inherited InitSaveFunctions(Struct);
end;

//------------------------------------------------------------------------------

procedure TILItemShop_IO_00000001.InitLoadFunctions(Struct: UInt32);
begin
If Struct = IL_ITEMSHOP_STREAMSTRUCTURE_00000001 then
  fFNLoadFromStream := LoadItemShop_00000001
else
  inherited InitLoadFunctions(Struct);
end;

//------------------------------------------------------------------------------

procedure TILItemShop_IO_00000001.SaveItemShop_00000001(Stream: TStream);
begin
Stream_WriteUInt32(Stream,GetFlagsWord);
// rest of the structure is unchanged from ver 0
SaveItemShop_00000000(Stream);
Stream_WriteInt64(Stream,DateTimeToUnix(fLastUpdateTime));
end;

//------------------------------------------------------------------------------

procedure TILItemShop_IO_00000001.LoadItemShop_00000001(Stream: TStream);
begin
SetFlagsWord(Stream_ReadUInt32(Stream));
LoadItemShop_00000000(Stream);
fLastUpdateTime := UnixToDateTime(Stream_ReadInt64(Stream));
end;

end.
