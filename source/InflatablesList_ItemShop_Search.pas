unit InflatablesList_ItemShop_Search;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  InflatablesList_Types,
  InflatablesList_ItemShop_Update;

type
  TILItemShop_Search = class(TILItemShop_Update)
  public
    Function SearchField(Index: Integer; Field: TILAdvShopSearchResult; DeepScan: Boolean; CompFunc: TILAdvSearchCompareFunc): Boolean; virtual;
    Function DeepScan_AvailHistory(CompFunc: TILAdvSearchCompareFunc): Boolean; virtual;
    Function DeepScan_PriceHistory(CompFunc: TILAdvSearchCompareFunc): Boolean; virtual;
    Function DeepScan_ParsSettVariables(CompFunc: TILAdvSearchCompareFunc): Boolean; virtual;
  end;

implementation

uses
  SysUtils,
  InflatablesList_Utils,
  InflatablesList_Data;

Function TILItemShop_Search.SearchField(Index: Integer; Field: TILAdvShopSearchResult; DeepScan: Boolean; CompFunc: TILAdvSearchCompareFunc): Boolean;
begin
// normal search
case Field of
  ilassrListIndex:      Result := CompFunc(IntToStr(Index),False,False,False);
  ilassrSelected:       Result := fSelected and CompFunc('Selected',False,True,False);
  ilassrUntracked:      Result := fUntracked and CompFunc('Untracked',False,True,False);
  ilassrAltDownMethod:  Result := fAltDownMethod and CompFunc('Alternative download method',False,True,False);
  ilassrName:           Result := CompFunc(fName,True,True,False);
  ilassrShopURL:        Result := CompFunc(fShopURL,True,True,False);
  ilassrItemURL:        Result := CompFunc(fItemURL,True,True,False);
  ilassrAvailable:      Result := CompFunc(IntToStr(fAvailable),False,True,False,'pcs');
  ilassrPrice:          Result := CompFunc(IntToStr(fPrice),False,True,False,'Kè');
  ilassrNotes:          Result := CompFunc(fNotes,True,True,False);
  ilassrLastUpdResult:  Result := CompFunc(TILDataProvider.GetShopUpdateResultString(fLastUpdateRes),False,False,False);
  ilassrLastUpdMessage: Result := CompFunc(fLastUpdateMsg,True,False,False);
  ilassrLastUpdTime:    Result := CompFunc(IL_FormatDateTime('yyyy-mm-dd hh:nn:ss',fLastUpdateTime),False,False,False);
else
  // deep search...
  If DeepScan then
    case Field of
      ilassrAvailHistory:       Result := DeepScan_AvailHistory(CompFunc);
      ilassrPriceHistory:       Result := DeepScan_PriceHistory(CompFunc);
      ilassrParsingVariables:   Result := DeepScan_ParsSettVariables(CompFunc);
      ilassrIgnoreParsErrors:   Result := fParsingSettings.DisableParsingErrors and
                                          CompFunc('Ignore parsing errors',False,True,False);
      ilassrParsingTemplateRef: Result := CompFunc(fParsingSettings.TemplateReference,True,True,False);
    else
      //fParsingSettings
      Result := False;
    end
  else Result := False;
end;
end;

//------------------------------------------------------------------------------

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

Function TILItemShop_Search.DeepScan_ParsSettVariables(CompFunc: TILAdvSearchCompareFunc): Boolean;
var
  i:  Integer;
begin
Result := False;
For i := 0 to Pred(fParsingSettings.VariableCount) do
  If CompFunc(fParsingSettings.Variables[i],True,True,False) then
    begin
      Result := True;
      Break{For i};
    end;
end;

end.
