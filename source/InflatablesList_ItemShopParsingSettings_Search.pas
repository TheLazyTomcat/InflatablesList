unit InflatablesList_ItemShopParsingSettings_Search;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  InflatablesList_Types,
  InflatablesList_ItemShopParsingSettings_Base;

type
  TILItemShopParsingSettings_Search = class(TILItemShopParsingSettings_Base)
  protected
    Function DeepScan_AvailExtrSett(CompFunc: TILAdvSearchCompareFunc): Boolean; virtual;
    Function DeepScan_PriceExtrSett(CompFunc: TILAdvSearchCompareFunc): Boolean; virtual;
    Function DeepScan_AvailFinder(const SearchSettings: TILAdvSearchSettings): Boolean; virtual;
    Function DeepScan_PriceFinder(const SearchSettings: TILAdvSearchSettings): Boolean; virtual;
  public
    Function SearchField(const SearchSettings: TILAdvSearchSettings; Field: TILAdvShopSearchResult): Boolean; virtual;
  end;

implementation

uses
  InflatablesList_Data;

Function TILItemShopParsingSettings_Search.DeepScan_AvailExtrSett(CompFunc: TILAdvSearchCompareFunc): Boolean;
var
  i:  Integer;
begin
Result := False;
For i := Low(fAvailExtrSetts) to High(fAvailExtrSetts) do
  If CompFunc(TILDataProvider.GetShopParsingExtractFromString(fAvailExtrSetts[i].ExtractFrom),False,True,False) or
    CompFunc(TILDataProvider.GetShopParsingExtractMethodString(fAvailExtrSetts[i].ExtractionMethod),False,True,False) or
    CompFunc(fAvailExtrSetts[i].ExtractionData,True,True,False) or CompFunc(fAvailExtrSetts[i].NegativeTag,True,True,False) then
      begin
        Result := True;
        Break{For i};
      end;
end;

//------------------------------------------------------------------------------

Function TILItemShopParsingSettings_Search.DeepScan_PriceExtrSett(CompFunc: TILAdvSearchCompareFunc): Boolean;
var
  i:  Integer;
begin
Result := False;
For i := Low(fPriceExtrSetts) to High(fPriceExtrSetts) do
  If CompFunc(TILDataProvider.GetShopParsingExtractFromString(fPriceExtrSetts[i].ExtractFrom),False,True,False) or
    CompFunc(TILDataProvider.GetShopParsingExtractMethodString(fPriceExtrSetts[i].ExtractionMethod),False,True,False) or
    CompFunc(fPriceExtrSetts[i].ExtractionData,True,True,False) or CompFunc(fPriceExtrSetts[i].NegativeTag,True,True,False) then
      begin
        Result := True;
        Break{For i};
      end;
end;

//------------------------------------------------------------------------------

Function TILItemShopParsingSettings_Search.DeepScan_AvailFinder(const SearchSettings: TILAdvSearchSettings): Boolean;
begin
Result := fAvailFinder.Search(SearchSettings);
end;

//------------------------------------------------------------------------------

Function TILItemShopParsingSettings_Search.DeepScan_PriceFinder(const SearchSettings: TILAdvSearchSettings): Boolean;
begin
Result := fPriceFinder.Search(SearchSettings);
end;

//==============================================================================

Function TILItemShopParsingSettings_Search.SearchField(const SearchSettings: TILAdvSearchSettings; Field: TILAdvShopSearchResult): Boolean;
var
  i:  Integer;
begin
// normal search...
case Field of
  ilassrParsingVariables:   begin
                              Result := False;
                              For i := 0 to Pred(VariableCount) do
                                If SearchSettings.CompareFunc(Variables[i],True,True,False) then
                                  begin
                                    Result := True;
                                    Break{For i};
                                  end;
                            end;
  ilassrParsingTemplateRef: Result := (Length(fTemplateRef) > 0) and SearchSettings.CompareFunc(fTemplateRef,True,True,False);
  ilassrIgnoreParsErrors:   Result := fDisableParsErrs and (SearchSettings.CompareFunc('Ignore parsing errors',False,True,False) or
                                        SearchSettings.CompareFunc('Disable parsing errors',False,True,False) or
                                        SearchSettings.CompareFunc('Disable raising of parsing errors',False,True,False));  
else
  // deep scan...
  If SearchSettings.DeepScan then
    case Field of
      ilassrAvailExtrSettings:  Result := DeepScan_AvailExtrSett(SearchSettings.CompareFunc);
      ilassrPriceExtrSettings:  Result := DeepScan_PriceExtrSett(SearchSettings.CompareFunc);
      ilassrAvailFinder:        Result := DeepScan_AvailFinder(SearchSettings);
      ilassrPriceFinder:        Result := DeepScan_PriceFinder(SearchSettings);
    else
      //fParsingSettings
      Result := False;
    end
  else Result := False;
end;
end;

end.
