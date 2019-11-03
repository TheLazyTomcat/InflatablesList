unit InflatablesList_ItemShop_Search;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  InflatablesList_Types,
  InflatablesList_ItemShop_Update;

type
  TILItemShop_Search = class(TILItemShop_Update)
  protected
    Function DeepScan_AvailHistory(CompFunc: TILAdvSearchCompareFunc): Boolean; virtual;
    Function DeepScan_PriceHistory(CompFunc: TILAdvSearchCompareFunc): Boolean; virtual;
    Function SearchResolveParsSett(const SearchSettings: TILAdvSearchSettings; Field: TILAdvShopSearchResult): Boolean; virtual;
  public
    Function SearchField(const SearchSettings: TILAdvSearchSettings; Index: Integer; Field: TILAdvShopSearchResult): Boolean; virtual;
  end;

implementation

uses
  SysUtils,
  InflatablesList_Utils,
  InflatablesList_Data,
  InflatablesList_ItemShopParsingSettings;


Function TILItemShop_Search.DeepScan_AvailHistory(CompFunc: TILAdvSearchCompareFunc): Boolean;
var
  i:  Integer;
begin
Result := False;
For i := 0 to Pred(AvailHistoryEntryCount) do
  If CompFunc(IL_FormatDateTime('yyyy-mm-dd hh:nn:ss',AvailHistoryEntries[i].Time),False,False,False) or
     CompFunc(IntToStr(AvailHistoryEntries[i].Value),False,False,False,'pcs') then
    begin
      Result := True;
      Break{For i};
    end;
end;

//------------------------------------------------------------------------------

Function TILItemShop_Search.DeepScan_PriceHistory(CompFunc: TILAdvSearchCompareFunc): Boolean;
var
  i:  Integer;
begin
Result := False;
For i := 0 to Pred(PriceHistoryEntryCount) do
  If CompFunc(IL_FormatDateTime('yyyy-mm-dd hh:nn:ss',PriceHistoryEntries[i].Time),False,False,False) or
     CompFunc(IntToStr(PriceHistoryEntries[i].Value),False,False,False,'Kè') then
    begin
      Result := True;
      Break{For i};
    end;
end;

//------------------------------------------------------------------------------

Function TILItemShop_Search.SearchResolveParsSett(const SearchSettings: TILAdvSearchSettings; Field: TILAdvShopSearchResult): Boolean;
var
  ResolvedParsSett: TILItemShopParsingSettings;
begin
ResolvedParsSett := TILItemShopParsingSettings(SearchSettings.ParsTemplResolve(fParsingSettings.TemplateReference));
If not Assigned(ResolvedParsSett) then
  ResolvedParsSett := fParsingSettings;
Result := ResolvedParsSett.SearchField(SearchSettings,Field);
end;

//==============================================================================

Function TILItemShop_Search.SearchField(const SearchSettings: TILAdvSearchSettings; Index: Integer; Field: TILAdvShopSearchResult): Boolean;
begin
// normal search
case Field of
  ilassrListIndex:          Result := SearchSettings.CompareFunc(IntToStr(Index),False,False,False);
  ilassrSelected:           Result := fSelected and SearchSettings.CompareFunc('Selected',False,True,False);
  ilassrUntracked:          Result := fUntracked and SearchSettings.CompareFunc('Untracked',False,True,False);
  ilassrAltDownMethod:      Result := fAltDownMethod and SearchSettings.CompareFunc('Alternative download method',False,True,False);
  ilassrName:               Result := SearchSettings.CompareFunc(fName,True,True,False);
  ilassrShopURL:            Result := SearchSettings.CompareFunc(fShopURL,True,True,False);
  ilassrItemURL:            Result := SearchSettings.CompareFunc(fItemURL,True,True,False);
  ilassrAvailable:          Result := SearchSettings.CompareFunc(IntToStr(fAvailable),False,True,False,'pcs');
  ilassrPrice:              Result := SearchSettings.CompareFunc(IntToStr(fPrice),False,True,False,'Kè');
  ilassrNotes:              Result := SearchSettings.CompareFunc(fNotes,True,True,False);
  ilassrLastUpdResult:      Result := SearchSettings.CompareFunc(TILDataProvider.GetShopUpdateResultString(fLastUpdateRes),False,False,False);
  ilassrLastUpdMessage:     Result := SearchSettings.CompareFunc(fLastUpdateMsg,True,False,False);
  ilassrLastUpdTime:        Result := SearchSettings.CompareFunc(IL_FormatDateTime('yyyy-mm-dd hh:nn:ss',fLastUpdateTime),False,False,False);
  // parsing settings
  ilassrParsingVariables,
  ilassrParsingTemplateRef: Result := fParsingSettings.SearchField(SearchSettings,Field);
  // following can be taken from a template, so resolve first...
  ilassrIgnoreParsErrors,
  ilassrAvailExtrSettings,
  ilassrPriceExtrSettings,
  ilassrAvailFinder,
  ilassrPriceFinder:        Result := SearchResolveParsSett(SearchSettings,Field);
else
  // deep scan...
  If SearchSettings.DeepScan then
    case Field of
      ilassrAvailHistory:       Result := DeepScan_AvailHistory(SearchSettings.CompareFunc);
      ilassrPriceHistory:       Result := DeepScan_PriceHistory(SearchSettings.CompareFunc);
    else
      //fParsingSettings
      Result := False;
    end
  else Result := False;
end;
end;

end.
