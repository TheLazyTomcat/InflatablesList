unit InflatablesList_Manager_00000003;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  Classes,
  AuxTypes,
  InflatablesList_Types, InflatablesList_Manager_00000002;

type
  TILManager_00000003 = class(TILManager_00000002)
  protected
    procedure InitSaveFunctions(Struct: UInt32); override;
    procedure InitLoadFunctions(Struct: UInt32); override;
    procedure SaveParsingSettings_00000003(Stream: TStream; const ParsSett: TILItemShopParsingSetting); virtual;
    procedure LoadParsingSettings_00000003(Stream: TStream; out ParsSett: TILItemShopParsingSetting); virtual;
  end;

implementation

uses
  BinaryStreaming,
  InflatablesList_Manager_IO,
  InflatablesList_HTML_ElementFinder;

procedure TILManager_00000003.InitSaveFunctions(Struct: UInt32);
begin
case Struct of
  IL_LISTFILE_FILESTRUCTURE_00000003:
    begin
      fFNSaveToStream := SaveToStream_00000002;
      fFNSaveSortingSettings := SaveSortingSettings_00000001;
      fFNSaveShopTemplates := SaveShopTemplates_00000000;
      fFNSaveFilterSettings := SaveFilterSettings_00000000;
      fFNSaveItem := SaveItem_00000000;
      fFNSaveItemShop := SaveItemShop_00000002;
      fFNSaveParsingSettings := SaveParsingSettings_00000003;
      fFNExportShopTemplate := SaveShopTemplate_00000002;
    end;
else
  inherited InitSaveFunctions(Struct);
end;
end;

//------------------------------------------------------------------------------

procedure TILManager_00000003.InitLoadFunctions(Struct: UInt32);
begin
case Struct of
  IL_LISTFILE_FILESTRUCTURE_00000003:
    begin
      fFNLoadFromStream := LoadFromStream_00000002;
      fFNLoadSortingSettings := LoadSortingSettings_00000001;
      fFNLoadShopTemplates := LoadShopTemplates_00000000;
      fFNLoadFilterSettings := LoadFilterSettings_00000000;
      fFNLoadItem := LoadItem_00000000;
      fFNLoadItemShop := LoadItemShop_00000002;
      fFNLoadParsingSettings := LoadParsingSettings_00000003;
      fFNImportShopTemplate := LoadShopTemplate_00000002;
    end;
else
  inherited InitLoadFunctions(Struct);
end;
end;

//------------------------------------------------------------------------------

procedure TILManager_00000003.SaveParsingSettings_00000003(Stream: TStream; const ParsSett: TILItemShopParsingSetting);
var
  i: Integer;
begin
// no need to write empty settings, just omit TemplateRef and DisableParsErrs;
// variables
For i := Low(ParsSett.Variables.Vars) to High(ParsSett.Variables.Vars) do
  Stream_WriteString(Stream,ParsSett.Variables.Vars[i]);
// others
Stream_WriteString(Stream,ParsSett.TemplateRef);
Stream_WriteBool(Stream,ParsSett.DisableParsErrs);
// available
Stream_WriteUInt32(Stream,Length(ParsSett.Available.Extraction));
For i := Low(ParsSett.Available.Extraction) to High(ParsSett.Available.Extraction) do
  begin
    Stream_WriteInt32(Stream,IL_ExtractFromToNum(ParsSett.Available.Extraction[i].ExtractFrom));
    Stream_WriteInt32(Stream,IL_ExtrMethodToNum(ParsSett.Available.Extraction[i].ExtractionMethod));
    Stream_WriteString(Stream,ParsSett.Available.Extraction[i].ExtractionData);
    Stream_WriteString(Stream,ParsSett.Available.Extraction[i].NegativeTag);
  end;
TILElementFinder(ParsSett.Available.Finder).SaveToStream(Stream);
// price
Stream_WriteUInt32(Stream,Length(ParsSett.Price.Extraction));
For i := Low(ParsSett.Price.Extraction) to High(ParsSett.Price.Extraction) do
  begin
    Stream_WriteInt32(Stream,IL_ExtractFromToNum(ParsSett.Price.Extraction[i].ExtractFrom));
    Stream_WriteInt32(Stream,IL_ExtrMethodToNum(ParsSett.Price.Extraction[i].ExtractionMethod));
    Stream_WriteString(Stream,ParsSett.Price.Extraction[i].ExtractionData);
    Stream_WriteString(Stream,ParsSett.Price.Extraction[i].NegativeTag);
  end;
TILElementFinder(ParsSett.Price.Finder).SaveToStream(Stream);
end;

//------------------------------------------------------------------------------

procedure TILManager_00000003.LoadParsingSettings_00000003(Stream: TStream; out ParsSett: TILItemShopParsingSetting);
var
  i:        Integer;
  TempStr:  String;
  Index:    Integer;
begin
// variables
For i := Low(ParsSett.Variables.Vars) to High(ParsSett.Variables.Vars) do
  ParsSett.Variables.Vars[i] := Stream_ReadString(Stream);
// others
TempStr := Stream_ReadString(Stream);
Index := ShopTemplateIndexOf(TempStr);
If Index >= 0 then
  ParsSett.TemplateRef := ShopTemplates[Index].Name
else
  ParsSett.TemplateRef := '';
ParsSett.DisableParsErrs := Stream_ReadBool(Stream);
// available
SetLength(ParsSett.Available.Extraction,Stream_ReadUInt32(Stream));
For i := Low(ParsSett.Available.Extraction) to High(ParsSett.Available.Extraction) do
  begin
    ParsSett.Available.Extraction[i].ExtractFrom := IL_NumToExtractFrom(Stream_ReadInt32(Stream));
    ParsSett.Available.Extraction[i].ExtractionMethod := IL_NumToExtrMethod(Stream_ReadInt32(Stream));
    ParsSett.Available.Extraction[i].ExtractionData := Stream_ReadString(Stream);
    ParsSett.Available.Extraction[i].NegativeTag := Stream_ReadString(Stream);
  end;
ParsSett.Available.Finder := TILElementFinder.Create;
TILElementFinder(ParsSett.Available.Finder).LoadFromStream(Stream);
// price
SetLength(ParsSett.Price.Extraction,Stream_ReadUInt32(Stream));
For i := Low(ParsSett.Price.Extraction) to High(ParsSett.Price.Extraction) do
  begin
    ParsSett.Price.Extraction[i].ExtractFrom := IL_NumToExtractFrom(Stream_ReadInt32(Stream));
    ParsSett.Price.Extraction[i].ExtractionMethod := IL_NumToExtrMethod(Stream_ReadInt32(Stream));
    ParsSett.Price.Extraction[i].ExtractionData := Stream_ReadString(Stream);
    ParsSett.Price.Extraction[i].NegativeTag := Stream_ReadString(Stream);
  end;
ParsSett.Price.Finder := TILElementFinder.Create;
TILElementFinder(ParsSett.Price.Finder).LoadFromStream(Stream);
end;


end.
