unit InflatablesList_ItemShop_IO_00000000;
{$message 'll_rework'}

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  Classes,
  AuxTypes,
  InflatablesList_ItemShop_IO;

type
  TILItemShop_IO_00000000 = class(TILItemShop_IO)
  protected
    procedure InitSaveFunctions(Struct: UInt32); override;
    procedure InitLoadFunctions(Struct: UInt32); override;
    procedure SaveItemShop_00000000(Stream: TStream); virtual;
    procedure LoadItemShop_00000000(Stream: TStream); virtual;
  end;

implementation

uses
  SysUtils,
  BinaryStreaming,
  InflatablesList_Types;

procedure TILItemShop_IO_00000000.InitSaveFunctions(Struct: UInt32);
begin
If Struct = IL_ITEMSHOP_STREAMSTRUCTURE_00000000 then
  fFNSaveToStream := SaveItemShop_00000000
else
  raise Exception.CreateFmt('TILItemShop_IO_00000000.InitSaveFunctions: Invalid stream structure (%.8x).',[Struct]);
end;

//------------------------------------------------------------------------------

procedure TILItemShop_IO_00000000.InitLoadFunctions(Struct: UInt32);
begin
If Struct = IL_ITEMSHOP_STREAMSTRUCTURE_00000000 then
  fFNLoadFromStream := LoadItemShop_00000000
else
  raise Exception.CreateFmt('TILItemShop_IO_00000000.InitLoadFunctions: Invalid stream structure (%.8x).',[Struct]);
end;

//------------------------------------------------------------------------------

procedure TILItemShop_IO_00000000.SaveItemShop_00000000(Stream: TStream);
var
  i:  Integer;
begin
Stream_WriteBool(Stream,fSelected);
Stream_WriteBool(Stream,fUntracked);
Stream_WriteBool(Stream,fAltDownMethod);
Stream_WriteString(Stream,fName);
Stream_WriteString(Stream,fShopURL);
Stream_WriteString(Stream,fItemURL);
Stream_WriteInt32(Stream,fAvailable);
Stream_WriteUInt32(Stream,fPrice);
// avail history
Stream_WriteUInt32(Stream,Length(fAvailHistory));
For i := Low(fAvailHistory) to High(fAvailHistory) do
  begin
    Stream_WriteInt32(Stream,fAvailHistory[i].Value);
    Stream_WriteFloat64(Stream,fAvailHistory[i].Time);
  end;
// price history
Stream_WriteUInt32(Stream,Length(fPriceHistory));
For i := Low(fPriceHistory) to High(fPriceHistory) do
  begin
    Stream_WriteInt32(Stream,fPriceHistory[i].Value);
    Stream_WriteFloat64(Stream,fPriceHistory[i].Time);
  end;
Stream_WriteString(Stream,fNotes);
fParsingSettings.SaveToStream(Stream);
Stream_WriteInt32(Stream,IL_ItemShopUpdateResultToNum(fLastUpdateRes));
Stream_WriteString(Stream,fLastUpdateMsg);
end;

//------------------------------------------------------------------------------

procedure TILItemShop_IO_00000000.LoadItemShop_00000000(Stream: TStream);
var
  i: Integer;
begin
fSelected := Stream_ReadBool(Stream);
fUntracked := Stream_ReadBool(Stream);
fAltDownMethod := Stream_ReadBool(Stream);
fName := Stream_ReadString(Stream);
fShopURL := Stream_ReadString(Stream);
fItemURL := Stream_ReadString(Stream);
fAvailable := Stream_ReadInt32(Stream);
fPrice := Stream_ReadUInt32(Stream);
// avail history
SetLength(fAvailHistory,Stream_ReadUInt32(Stream));
For i := Low(fAvailHistory) to High(fAvailHistory) do
  begin
    fAvailHistory[i].Value := Stream_ReadInt32(Stream);
    fAvailHistory[i].Time := Stream_ReadFloat64(Stream);
  end;
// price history
SetLength(fPriceHistory,Stream_ReadUInt32(Stream));
For i := Low(fPriceHistory) to High(fPriceHistory) do
  begin
    fPriceHistory[i].Value := Stream_ReadInt32(Stream);
    fPriceHistory[i].Time := Stream_ReadFloat64(Stream);
  end;
fNotes := Stream_ReadString(Stream);
// parsing settings
fParsingSettings.LoadFromStream(Stream);
fLastUpdateRes := IL_NumToItemShopUpdateResult(Stream_ReadInt32(Stream));
fLastUpdateMsg := Stream_ReadString(Stream);
end;

end.
