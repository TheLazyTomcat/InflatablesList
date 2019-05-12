unit InflatablesList_Manager_VER00000002;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  Classes,
  AuxTypes,
  InflatablesList_Types, InflatablesList_Manager_VER00000001;

type
  TILManager_VER00000002 = class(TILManager_VER00000001)
  protected
    procedure InitSaveFunctions(Struct: UInt32); override;
    procedure InitLoadFunctions(Struct: UInt32); override;
    procedure SaveToStream_VER00000002(Stream: TStream); virtual;
    procedure LoadFromStream_VER00000002(Stream: TStream); virtual;
    procedure SaveItemShop_VER00000002(Stream: TStream; const Shop: TILItemShop); virtual;
    procedure LoadItemShop_VER00000002(Stream: TStream; out Shop: TILItemShop); virtual;
    procedure SaveParsingSettings_VER00000002(Stream: TStream; const ParsSett: TILItemShopParsingSetting); virtual;
    procedure LoadParsingSettings_VER00000002(Stream: TStream; out ParsSett: TILItemShopParsingSetting); virtual;
    procedure SaveShopTemplate_VER00000002(Stream: TStream; const ShopTemplate: TILShopTemplate); virtual;
    procedure LoadShopTemplate_VER00000002(Stream: TStream; out ShopTemplate: TILShopTemplate); virtual;
  end;

implementation

uses
  SysUtils,
  BinaryStreaming,
  InflatablesList_Manager_Base,
  InflatablesList_HTML_ElementFinder;

procedure TILManager_VER00000002.InitSaveFunctions(Struct: UInt32);
begin
case Struct of
  IL_LISTFILE_FILESTRUCTURE_00000002:
    begin
      fFNSaveToStream := SaveToStream_VER00000002;
      fFNSaveSortingSettings := SaveSortingSettings_VER00000001;
      fFNSaveShopTemplates := SaveShopTemplates_VER00000000;
      fFNSaveFilterSettings := SaveFilterSettings_VER00000000;
      fFNSaveItem := SaveItem_VER00000000;
      fFNSaveItemShop := SaveItemShop_VER00000002;
      fFNSaveParsingSettings := SaveParsingSettings_VER00000002;
      fFNExportShopTemplate := SaveShopTemplate_VER00000002;
    end;
else
  inherited InitSaveFunctions(Struct);
end;
end;

//------------------------------------------------------------------------------

procedure TILManager_VER00000002.InitLoadFunctions(Struct: UInt32);
begin
case Struct of
  IL_LISTFILE_FILESTRUCTURE_00000002:
    begin
      fFNLoadFromStream := LoadFromStream_VER00000002;
      fFNLoadSortingSettings := LoadSortingSettings_VER00000001;
      fFNLoadShopTemplates := LoadShopTemplates_VER00000000;
      fFNLoadFilterSettings := LoadFilterSettings_VER00000000;
      fFNLoadItem := LoadItem_VER00000000;
      fFNLoadItemShop := LoadItemShop_VER00000002;
      fFNLoadParsingSettings := LoadParsingSettings_VER00000002;
      fFNImportShopTemplate := LoadShopTemplate_VER00000002;
    end;
else
  inherited InitLoadFunctions(Struct);
end;
end;

//------------------------------------------------------------------------------

procedure TILManager_VER00000002.SaveToStream_VER00000002(Stream: TStream);
var
  i:  Integer;
begin
// only add some technical info
Stream_WriteString(Stream,FormatDateTime('yyyy-mm-dd-hh-nn-ss-zzz',Now));
fFNSaveSortingSettings(Stream);
fFNSaveShopTemplates(Stream);
fFNSaveFilterSettings(Stream);
// items
Stream_WriteUInt32(Stream,Length(fList));
For i := Low(fList) to High(fList) do
  fFNSaveItem(Stream,fList[i]);
end;

//------------------------------------------------------------------------------

procedure TILManager_VER00000002.LoadFromStream_VER00000002(Stream: TStream);
var
  i:  Integer;
begin
Stream_ReadString(Stream);
fFNLoadSortingSettings(Stream);
fFNLoadShopTemplates(Stream);
fFNLoadFilterSettings(Stream);
// items
ItemClear;
SetLength(fList,Stream_ReadUInt32(Stream));
For i := Low(fList) to High(fList) do
  fFNLoadItem(Stream,fList[i]);
ReIndex;
ItemRedraw;
end;

//------------------------------------------------------------------------------

procedure TILManager_VER00000002.SaveItemShop_VER00000002(Stream: TStream; const Shop: TILItemShop);
var
  i:  Integer;
begin
Stream_WriteBool(Stream,Shop.Selected);
Stream_WriteString(Stream,Shop.Name);
Stream_WriteString(Stream,Shop.ShopURL);
Stream_WriteString(Stream,Shop.ItemURL);
Stream_WriteInt32(Stream,Shop.Available);
Stream_WriteUInt32(Stream,Shop.Price);
// avail history
Stream_WriteUInt32(Stream,Length(Shop.AvailHistory));
For i := Low(Shop.AvailHistory) to High(Shop.AvailHistory) do
  begin
    Stream_WriteInt32(Stream,Shop.AvailHistory[i].Value);
    Stream_WriteFloat64(Stream,Shop.AvailHistory[i].Time);
  end;
// price history
Stream_WriteUInt32(Stream,Length(Shop.PriceHistory));
For i := Low(Shop.PriceHistory) to High(Shop.PriceHistory) do
  begin
    Stream_WriteInt32(Stream,Shop.PriceHistory[i].Value);
    Stream_WriteFloat64(Stream,Shop.PriceHistory[i].Time);
  end;
// parsing settings
Stream_WriteString(Stream,Shop.Notes);
fFNSaveParsingSettings(Stream,Shop.ParsingSettings);
Stream_WriteString(Stream,Shop.LastUpdateMsg);
end;

//------------------------------------------------------------------------------

procedure TILManager_VER00000002.LoadItemShop_VER00000002(Stream: TStream; out Shop: TILItemShop);
var
  i: Integer;
begin
Shop.Selected := Stream_ReadBool(Stream);
Shop.Untracked := False;
Shop.Name := Stream_ReadString(Stream);
Shop.ShopURL := Stream_ReadString(Stream);
Shop.ItemURL := Stream_ReadString(Stream);
Shop.Available := Stream_ReadInt32(Stream);
Shop.Price := Stream_ReadUInt32(Stream);
// avail history
SetLength(Shop.AvailHistory,Stream_ReadUInt32(Stream));
For i := Low(Shop.AvailHistory) to High(Shop.AvailHistory) do
  begin
    Shop.AvailHistory[i].Value := Stream_ReadInt32(Stream);
    Shop.AvailHistory[i].Time := Stream_ReadFloat64(Stream);
  end;
// price history
SetLength(Shop.PriceHistory,Stream_ReadUInt32(Stream));
For i := Low(Shop.PriceHistory) to High(Shop.PriceHistory) do
  begin
    Shop.PriceHistory[i].Value := Stream_ReadInt32(Stream);
    Shop.PriceHistory[i].Time := Stream_ReadFloat64(Stream);
  end;
Shop.Notes := Stream_ReadString(Stream);
// parsing settings
fFNLoadParsingSettings(Stream,Shop.ParsingSettings);
Shop.LastUpdateMsg := Stream_ReadString(Stream);
end;

//------------------------------------------------------------------------------

procedure TILManager_VER00000002.SaveParsingSettings_VER00000002(Stream: TStream; const ParsSett: TILItemShopParsingSetting);
var
  i: Integer;
begin
// no need to write empty settings, just omit TemplateRef and DisableParsErrs;
// variables
For i := Low(ParsSett.Variables.Vars) to High(ParsSett.Variables.Vars) do
  Stream_WriteString(Stream,ParsSett.Variables.Vars[i]);
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

procedure TILManager_VER00000002.LoadParsingSettings_VER00000002(Stream: TStream; out ParsSett: TILItemShopParsingSetting);
var
  i: Integer;
begin
// variables
For i := Low(ParsSett.Variables.Vars) to High(ParsSett.Variables.Vars) do
  ParsSett.Variables.Vars[i] := Stream_ReadString(Stream);
// others
ParsSett.TemplateRef := '';
ParsSett.DisableParsErrs := False;
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

//------------------------------------------------------------------------------

procedure TILManager_VER00000002.SaveShopTemplate_VER00000002(Stream: TStream; const ShopTemplate: TILShopTemplate);
begin
Stream_WriteString(Stream,ShopTemplate.Name);
fFNSaveItemShop(Stream,ShopTemplate.ShopData);
end;

//------------------------------------------------------------------------------

procedure TILManager_VER00000002.LoadShopTemplate_VER00000002(Stream: TStream; out ShopTemplate: TILShopTemplate);
begin
ShopTemplate.Name := Stream_ReadString(Stream);
fFNLoadItemShop(Stream,ShopTemplate.ShopData);
end;

end.
