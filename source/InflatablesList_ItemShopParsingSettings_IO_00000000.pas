unit InflatablesList_ItemShopParsingSettings_IO_00000000;
{$message 'll_rework'}

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  AuxTypes,
  Classes,
  InflatablesList_ItemShopParsingSettings_IO;

type
  TILItemShopParsingSettings_IO_00000000 = class(TILItemShopParsingSettings_IO)
  protected
    procedure InitSaveFunctions(Struct: UInt32); override;
    procedure InitLoadFunctions(Struct: UInt32); override;
    procedure SaveSettings_00000000(Stream: TStream); virtual;
    procedure LoadSettings_00000000(Stream: TStream); virtual;
  end;  

implementation

uses
  SysUtils,
  BinaryStreaming,
  InflatablesList_Types;

procedure TILItemShopParsingSettings_IO_00000000.InitSaveFunctions(Struct: UInt32);
begin
If Struct = IL_SHOPPARSSETT_STREAMSTRUCTURE_00000000 then
  fFNSaveToStream := SaveSettings_00000000
else
  raise Exception.CreateFmt('TILItemShopParsingSettings_IO_00000000.InitSaveFunctions: Invalid stream structure (%.8x).',[Struct]);
end;

//------------------------------------------------------------------------------

procedure TILItemShopParsingSettings_IO_00000000.InitLoadFunctions(Struct: UInt32);
begin
If Struct = IL_SHOPPARSSETT_STREAMSTRUCTURE_00000000 then
  fFNLoadFromStream := LoadSettings_00000000
else
  raise Exception.CreateFmt('TILItemShopParsingSettings_IO_00000000.InitLoadFunctions: Invalid stream structure (%.8x).',[Struct]);
end;

//------------------------------------------------------------------------------

procedure TILItemShopParsingSettings_IO_00000000.SaveSettings_00000000(Stream: TStream);
var
  i:  Integer;
begin
For i := Low(fVariables.Vars) to High(fVariables.Vars) do
  Stream_WriteString(Stream,fVariables.Vars[i]);
Stream_WriteString(Stream,fTemplateRef);
Stream_WriteBool(Stream,fDisableParsErrs);
Stream_WriteUInt32(Stream,Length(fAvailExtrSetts));
For i := Low(fAvailExtrSetts) to High(fAvailExtrSetts) do
  begin
    Stream_WriteInt32(Stream,IL_ExtractFromToNum(fAvailExtrSetts[i].ExtractFrom));
    Stream_WriteInt32(Stream,IL_ExtrMethodToNum(fAvailExtrSetts[i].ExtractionMethod));
    Stream_WriteString(Stream,fAvailExtrSetts[i].ExtractionData);
    Stream_WriteString(Stream,fAvailExtrSetts[i].NegativeTag);
  end;
fAvailFinder.SaveToStream(Stream);
Stream_WriteUInt32(Stream,Length(fPriceExtrSetts));
For i := Low(fPriceExtrSetts) to High(fPriceExtrSetts) do
  begin
    Stream_WriteInt32(Stream,IL_ExtractFromToNum(fPriceExtrSetts[i].ExtractFrom));
    Stream_WriteInt32(Stream,IL_ExtrMethodToNum(fPriceExtrSetts[i].ExtractionMethod));
    Stream_WriteString(Stream,fPriceExtrSetts[i].ExtractionData);
    Stream_WriteString(Stream,fPriceExtrSetts[i].NegativeTag);
  end;
fPriceFinder.SaveToStream(Stream);
end;

//------------------------------------------------------------------------------

procedure TILItemShopParsingSettings_IO_00000000.LoadSettings_00000000(Stream: TStream);
var
  i:  Integer;
begin
For i := Low(fVariables.Vars) to High(fVariables.Vars) do
  fVariables.Vars[i] := Stream_ReadString(Stream);
fTemplateRef := Stream_ReadString(Stream);
fDisableParsErrs := Stream_ReadBool(Stream);
SetLength(fAvailExtrSetts,Stream_ReadUInt32(Stream));
For i := Low(fAvailExtrSetts) to High(fAvailExtrSetts) do
  begin
    fAvailExtrSetts[i].ExtractFrom := IL_NumToextractFrom(Stream_ReadInt32(Stream));
    fAvailExtrSetts[i].ExtractionMethod := IL_NumToExtrMethod(Stream_ReadInt32(Stream));
    fAvailExtrSetts[i].ExtractionData := Stream_ReadString(Stream);
    fAvailExtrSetts[i].NegativeTag := Stream_ReadString(Stream);
  end;
fAvailFinder.LoadFromStream(Stream);
SetLength(fPriceExtrSetts,Stream_ReadUInt32(Stream));
For i := Low(fPriceExtrSetts) to High(fPriceExtrSetts) do
  begin
    fPriceExtrSetts[i].ExtractFrom := IL_NumToextractFrom(Stream_ReadInt32(Stream));
    fPriceExtrSetts[i].ExtractionMethod := IL_NumToExtrMethod(Stream_ReadInt32(Stream));
    fPriceExtrSetts[i].ExtractionData := Stream_ReadString(Stream);
    fPriceExtrSetts[i].NegativeTag := Stream_ReadString(Stream);
  end;
fPriceFinder.LoadFromStream(Stream);
end;

end.
