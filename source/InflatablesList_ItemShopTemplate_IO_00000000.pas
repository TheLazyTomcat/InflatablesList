unit InflatablesList_ItemShopTemplate_IO_00000000;

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
  public
    class procedure Convert(Stream, ConvStream: TStream); virtual;
  end;

implementation

uses
  SysUtils,
  BinaryStreaming,
  InflatablesList_ItemShopParsingSettings;

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

//==============================================================================

class procedure TILItemShopTemplate_IO_00000000.Convert(Stream, ConvStream: TStream);
var
  Untracked:      Boolean;
  AltDownMethod:  Boolean;
  HistCntr:       UInt32;
  HistIter:       Integer;
begin
Stream_WriteUInt32(ConvStream,IL_SHOPTEMPLATE_SIGNATURE);
Stream_WriteUInt32(ConvStream,IL_SHOPTEMPLATE_STREAMSTRUCTURE_00000000);
// data
{
  > loaded
  < saved
  * discarded
}
Stream_WriteString(ConvStream,Stream_ReadString(Stream)); // template name
Stream_ReadBool(Stream);                                  // * selected (discard, relic from saving as full item shop)
Untracked := Stream_ReadBool(Stream);                     // > untracked
AltDownMethod := Stream_ReadBool(Stream);                 // > alternative download method
Stream_WriteString(ConvStream,Stream_ReadString(Stream)); // shop name
Stream_WriteBool(ConvStream,Untracked);                   // < untracked
Stream_WriteBool(ConvStream,AltDownMethod);               // < alternative download method
Stream_WriteString(ConvStream,Stream_ReadString(Stream)); // shop URL
Stream_ReadString(Stream);                                // * item URL
Stream_ReadInt32(Stream);                                 // * available
Stream_ReadUInt32(Stream);                                // * price
// * avail history
HistCntr := Stream_ReadUInt32(Stream);
For HistIter := 0 to Pred(HistCntr) do
  begin
    Stream_ReadInt32(Stream);
    Stream_ReadFloat64(Stream);
  end;
// * price history
HistCntr := Stream_ReadUInt32(Stream);
For HistIter := 0 to Pred(HistCntr) do
  begin
    Stream_ReadInt32(Stream);
    Stream_ReadFloat64(Stream);
  end;
Stream_ReadString(Stream);        // * notes
// parsing settings
TILItemShopParsingSettings.Convert(Stream,ConvStream);
Stream_ReadInt32(Stream);         // * last update result
Stream_ReadString(Stream);        // * last update message
end;

end.
