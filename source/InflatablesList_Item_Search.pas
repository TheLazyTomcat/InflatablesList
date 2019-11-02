unit InflatablesList_Item_Search;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  InflatablesList_Types,
  InflatablesList_ItemShop,
  InflatablesList_Item_Comp;

type
  TILItem_Search = class(TILItem_Comp)
  protected
    fCurrentSearchSettings: TILAdvSearchSettings;
    Function SearchCompare(const Value: String; IsText,IsEditable,IsCalculated: Boolean; const UnitStr: String = ''): Boolean; virtual;
    Function SearchField(Field: TILAdvItemSearchResult): Boolean; virtual;
    Function SearchShopField(Index: Integer; Shop: TILItemShop; Field: TILAdvShopSearchResult): Boolean; virtual;
  public
    Function FindPrev(const Text: String; From: TILItemSearchResult = ilisrNone): TILItemSearchResult; virtual;
    Function FindNext(const Text: String; From: TILItemSearchResult = ilisrNone): TILItemSearchResult; virtual;
    Function FindAll(const SearchSettings: TILAdvSearchSettings; var SearchResult: TILAdvSearchResult): Boolean; virtual;
  end;

implementation

uses
  SysUtils,
  InflatablesList_Utils;

Function TILItem_Search.SearchCompare(const Value: String; IsText,IsEditable,IsCalculated: Boolean; const UnitStr: String = ''): Boolean;

  Function UnitsRectify: String;
  begin
    If (fCurrentSearchSettings.IncludeUnits) and (Length(UnitStr) > 0) then
      Result := IL_Format('%s%s',[fCurrentSearchSettings.Text,UnitStr])
    else
      Result := fCurrentSearchSettings.Text;
  end;
  
begin
If (not fCurrentSearchSettings.TextsOnly or IsText) and
   (not fCurrentSearchSettings.EditablesOnly or IsEditable) and
   (fCurrentSearchSettings.SearchCalculated or not IsCalculated) then
  begin
    If fCurrentSearchSettings.PartialMatch then
      begin
        If fCurrentSearchSettings.CaseSensitive then
          Result := IL_ContainsStr(Value,UnitsRectify)
        else
          Result := IL_ContainsText(Value,UnitsRectify)
      end
    else
      begin
        If fCurrentSearchSettings.CaseSensitive then
          Result := IL_SameStr(Value,UnitsRectify)
        else
          Result := IL_SameText(Value,UnitsRectify)
      end;
  end
else Result := False;
end;

//------------------------------------------------------------------------------

Function TILItem_Search.SearchField(Field: TILAdvItemSearchResult): Boolean;
var
  SelShop:  TILItemShop;

  Function GetFlagsString: String;
  var
    Flag: TILItemFlag;
  begin
    Result := '';
    For Flag := Low(TILItemFlag) to High(TILItemFlag) do
      If Flag in fFlags then
        begin
          If Length(Result) > 0 then
            Result := Result + ' ' + fDataProvider.GetItemFlagString(Flag)
          else
            Result := fDataProvider.GetItemFlagString(Flag);
        end;
  end;

begin
case Field of
  ilaisrListIndex:            Result := SearchCompare(IntToStr(fIndex),False,False,False);
  ilaisrUniqueID:             Result := SearchCompare(GUIDToString(fUniqueID),False,False,False);
  ilaisrTimeOfAdd:            Result := SearchCompare(IL_FormatDateTime('yyyy-mm-dd hh:nn:ss',fTimeOfAddition),False,False,False);
  ilaisrTitleStr:             Result := SearchCompare(TitleStr,True,False,True);
  ilaisrType:                 Result := SearchCompare(fDataProvider.GetItemTypeString(fItemType),False,True,False);
  ilaisrTypeSpec:             Result := SearchCompare(fItemTypeSpec,True,True,False);
  ilaisrTypeStr:              Result := SearchCompare(TypeStr,True,False,True);
  ilaisrPieces:               Result := SearchCompare(IntToStr(fPieces),False,True,False,'pcs');
  ilaisrManufacturer:         Result := SearchCompare(fDataProvider.ItemManufacturers[fManufacturer].Str,False,True,False);
  ilaisrManufacturerStr:      Result := SearchCompare(fManufacturerStr,True,True,False);
  ilaisrTextID:               Result := SearchCompare(fTextID,True,True,False);
  ilaisrNumID:                Result := SearchCompare(IntToStr(fID),False,True,False);
  ilaisrIDStr:                Result := SearchCompare(IDStr,True,False,False);
  ilaisrFlags:                Result := SearchCompare(GetFlagsString,False,True,True);
  ilaisrFlagOwned:            Result := (ilifOwned in fFlags) and SearchCompare(fDataProvider.GetItemFlagString(ilifOwned),False,True,False);
  ilaisrFlagWanted:           Result := (ilifWanted in fFlags) and SearchCompare(fDataProvider.GetItemFlagString(ilifWanted),False,True,False);
  ilaisrFlagOrdered:          Result := (ilifOrdered in fFlags) and SearchCompare(fDataProvider.GetItemFlagString(ilifOrdered),False,True,False);
  ilaisrFlagBoxed:            Result := (ilifBoxed in fFlags) and SearchCompare(fDataProvider.GetItemFlagString(ilifBoxed),False,True,False);
  ilaisrFlagElsewhere:        Result := (ilifElsewhere in fFlags) and SearchCompare(fDataProvider.GetItemFlagString(ilifElsewhere),False,True,False);
  ilaisrFlagUntested:         Result := (ilifUntested in fFlags) and SearchCompare(fDataProvider.GetItemFlagString(ilifUntested),False,True,False);
  ilaisrFlagTesting:          Result := (ilifTesting in fFlags) and SearchCompare(fDataProvider.GetItemFlagString(ilifTesting),False,True,False);
  ilaisrFlagTested:           Result := (ilifTested in fFlags) and SearchCompare(fDataProvider.GetItemFlagString(ilifTested),False,True,False);
  ilaisrFlagDamaged:          Result := (ilifDamaged in fFlags) and SearchCompare(fDataProvider.GetItemFlagString(ilifDamaged),False,True,False);
  ilaisrFlagRepaired:         Result := (ilifRepaired in fFlags) and SearchCompare(fDataProvider.GetItemFlagString(ilifRepaired),False,True,False);
  ilaisrFlagPriceChange:      Result := (ilifPriceChange in fFlags) and SearchCompare(fDataProvider.GetItemFlagString(ilifPriceChange),False,True,False);
  ilaisrFlagAvailChange:      Result := (ilifAvailChange in fFlags) and SearchCompare(fDataProvider.GetItemFlagString(ilifAvailChange),False,True,False);
  ilaisrFlagNotAvailable:     Result := (ilifNotAvailable in fFlags) and SearchCompare(fDataProvider.GetItemFlagString(ilifNotAvailable),False,True,False);
  ilaisrFlagLost:             Result := (ilifLost in fFlags) and SearchCompare(fDataProvider.GetItemFlagString(ilifLost),False,True,False);
  ilaisrFlagDiscarded:        Result := (ilifDiscarded in fFlags) and SearchCompare(fDataProvider.GetItemFlagString(ilifDiscarded),False,True,False);
  ilaisrTextTag:              Result := SearchCompare(fTextTag,True,True,False);
  ilaisrNumTag:               Result := SearchCompare(IntToStr(fNumTag),True,True,False);
  ilaisrWantedLevel:          Result := SearchCompare(IntToStr(fWantedLevel),False,True,False);
  ilaisrVariant:              Result := SearchCompare(fVariant,True,True,False);
  ilaisrMaterial:             Result := SearchCompare(fDataProvider.GetItemMaterialString(fMaterial),False,True,False);
  ilaisrSizeX:                Result := SearchCompare(IntToStr(fSizeX),False,True,False,'mm');
  ilaisrSizeY:                Result := SearchCompare(IntToStr(fSizeY),False,True,False,'mm');
  ilaisrSizeZ:                Result := SearchCompare(IntToStr(fSizeZ),False,True,False,'mm');
  ilaisrTotalSize:            Result := SearchCompare(IntToStr(TotalSize),False,False,True,'mm^3');
  ilaisrSizeStr:              Result := SearchCompare(SizeStr,False,False,True);
  ilaisrUnitWeight:           Result := SearchCompare(IntToStr(fUnitWeight),False,True,False,'g');
  ilaisrTotalWeight:          Result := SearchCompare(IntToStr(TotalWeight),False,False,True,'g');
  ilaisrTotalWeightStr:       Result := SearchCompare(TotalWeightStr,True,False,True);
  ilaisrThickness:            Result := SearchCompare(IntToStr(fThickness),False,True,False,'um');
  ilaisrNotes:                Result := SearchCompare(fNotes,True,True,False);
  ilaisrReviewURL:            Result := SearchCompare(fReviewURL,True,True,False);
  ilaisrMainPictureFile:      Result := SearchCompare(fItemPictureFile,True,True,False);
  ilaisrSecondaryPictureFile: Result := SearchCompare(fSecondaryPictureFile,True,True,False);
  ilaisrPackagePictureFile:   Result := SearchCompare(fPackagePictureFile,True,True,False);
  ilaisrUnitPriceDefault:     Result := SearchCompare(IntToStr(fUnitPriceDefault),False,True,False,'Kè');
  ilaisrRating:               Result := SearchCompare(IntToStr(fRating),False,True,False,'%');
  ilaisrUnitPrice:            Result := SearchCompare(IntToStr(UnitPrice),False,False,True,'Kè');
  ilaisrUnitPriceLowest:      Result := SearchCompare(IntToStr(fUnitPriceLowest),False,False,True,'Kè');
  ilaisrTotalPriceLowest:     Result := SearchCompare(IntToStr(TotalPriceLowest),False,False,True,'Kè');
  ilaisrUnitPriceHighest:     Result := SearchCompare(IntToStr(fUnitPriceHighest),False,False,True,'Kè');
  ilaisrTotalPriceHighest:    Result := SearchCompare(IntToStr(TotalPriceHighest),False,False,True,'Kè');
  ilaisrUnitPriceSel:         Result := SearchCompare(IntToStr(fUnitPriceSelected),False,False,False,'Kè');
  ilaisrTotalPriceSel:        Result := SearchCompare(IntToStr(TotalPriceSelected),False,False,True,'Kè');
  ilaisrTotalPrice:           Result := SearchCompare(IntToStr(TotalPrice),False,False,True,'Kè');
  ilaisrAvailableLowest:      Result := SearchCompare(IntToStr(fAvailableLowest),False,False,True,'pcs');
  ilaisrAvailableHighest:     Result := SearchCompare(IntToStr(fAvailableHighest),False,False,True,'pcs');
  ilaisrAvailableSel:         Result := SearchCompare(IntToStr(fAvailableSelected),False,False,False,'pcs');
  ilaisrShopCount:            Result := SearchCompare(IntToStr(fShopCount),False,False,False);
  ilaisrShopCountStr:         Result := SearchCompare(ShopsCountStr,True,False,True);
  ilaisrUsefulShopCount:      Result := SearchCompare(IntToStr(ShopsUsefulCount),False,False,True);
  ilaisrUsefulShopRatio:      Result := SearchCompare(IL_Format('%f',[ShopsUsefulRatio]),False,False,True);
  ilaisrSelectedShop:         If ShopsSelected(SelShop) then
                                Result := SearchCompare(SelShop.Name,True,True,False)
                              else
                                Result := False;
  ilaisrWorstUpdateResult:    Result := SearchCompare(fDataProvider.GetShopUpdateResultString(ShopsWorstUpdateResult),False,False,True);
else
  Result := False;
end;
end;

//------------------------------------------------------------------------------

Function TILItem_Search.SearchShopField(Index: Integer; Shop: TILItemShop; Field: TILAdvShopSearchResult): Boolean;
var
  i:  Integer;
begin
// normal search
case Field of
  ilassrListIndex:          Result := SearchCompare(IntToStr(Index),False,False,False);
  ilassrSelected:           Result := Shop.Selected and SearchCompare('Selected',False,True,False);
  ilassrUntracked:          Result := Shop.Untracked and SearchCompare('Untracked',False,True,False);
  ilassrAltDownMethod:      Result := Shop.AltDownMethod and SearchCompare('Alternative download method',False,True,False);
  ilassrName:               Result := SearchCompare(Shop.Name,True,True,False);
  ilassrShopURL:            Result := SearchCompare(Shop.ShopURL,True,True,False);
  ilassrItemURL:            Result := SearchCompare(Shop.ItemURL,True,True,False);
  ilassrAvailable:          Result := SearchCompare(IntToStr(Shop.Available),False,True,False,'pcs');
  ilassrPrice:              Result := SearchCompare(IntToStr(Shop.Price),False,True,False,'Kè');
  ilassrNotes:              Result := SearchCompare(Shop.Notes,True,True,False);
  ilassrLastUpdResult:      Result := SearchCompare(fDataProvider.GetShopUpdateResultString(Shop.LastUpdateRes),False,False,False);
  ilassrLastUpdMessage:     Result := SearchCompare(Shop.LastUpdateMsg,True,False,False);
  ilassrLastUpdTime:        Result := SearchCompare(IL_FormatDateTime('yyyy-mm-dd hh:nn:ss',Shop.LastUpdateTime),False,False,False);
else
  // deep search...
  If fCurrentSearchSettings.DeepScan then
    case Field of
      ilassrAvailHistory:
        begin
          Result := False;
          For i := 0 to Pred(Shop.AvailHistoryEntryCount) do
            If SearchCompare(IL_FormatDateTime('yyyy-mm-dd hh:nn:ss',Shop.AvailHistoryEntries[i].Time),False,False,False) or
               SearchCompare(IntToStr(Shop.AvailHistoryEntries[i].Value),False,False,False,'pcs') then
              begin
                Result := True;
                Break{For i};
              end;
        end;
      ilassrPriceHistory:
        begin
          Result := False;
          For i := 0 to Pred(Shop.PriceHistoryEntryCount) do
            If SearchCompare(IL_FormatDateTime('yyyy-mm-dd hh:nn:ss',Shop.PriceHistoryEntries[i].Time),False,False,False) or
               SearchCompare(IntToStr(Shop.PriceHistoryEntries[i].Value),False,False,False,'Kè') then
              begin
                Result := True;
                Break{For i};
              end;
        end;
      ilassrParsingVariables:
        begin
          Result := False;
          For i := 0 to Pred(Shop.ParsingSettings.VariableCount) do
            If SearchCompare(Shop.ParsingSettings.Variables[i],True,True,False) then
              begin
                Result := True;
                Break{For i};
              end;
        end;
      ilassrParsingSettings:
        begin
          Result := False;
          // resolve parsing settings reference
          //Shop.ParsingSettings.
        end;
    else
      Result := False;
    end
  else Result := False;
end;
end;

//==============================================================================

Function TILItem_Search.FindPrev(const Text: String; From: TILItemSearchResult = ilisrNone): TILItemSearchResult;
var
  i:  TILItemSearchResult;
begin
Result := ilisrNone;
i := IL_WrapSearchResult(Pred(From));
while i <> From do
  begin
    If Contains(Text,IL_ItemSearchResultToValueTag(i)) then
      begin
        Result := i;
        Break{while...};
      end;
    i := IL_WrapSearchResult(Pred(i));
  end;
end;

//------------------------------------------------------------------------------

Function TILItem_Search.FindNext(const Text: String; From: TILItemSearchResult = ilisrNone): TILItemSearchResult;
var
  i:  TILItemSearchResult;
begin
Result := ilisrNone;
i := IL_WrapSearchResult(Succ(From));
while i <> From do
  begin
    If Contains(Text,IL_ItemSearchResultToValueTag(i)) then
      begin
        Result := i;
        Break{while...};
      end;
    i := IL_WrapSearchResult(Succ(i));
  end;
end;

//------------------------------------------------------------------------------

Function TILItem_Search.FindAll(const SearchSettings: TILAdvSearchSettings; var SearchResult: TILAdvSearchResult): Boolean;
var
  Field:      TILAdvItemSearchResult;
  i:          Integer;
  ShopCntr:   Integer;
  ShopField:  TILAdvShopSearchResult;
begin
// init
fCurrentSearchSettings := IL_ThreadSafeCopy(SearchSettings);
SearchResult.ItemIndex := -1;
SearchResult.ItemValue := [];
SetLength(SearchResult.Shops,0);
// fields
For Field := Low(TILAdvItemSearchResult) to High(TILAdvItemSearchResult) do
  If SearchField(Field) then
    Include(SearchResult.ItemValue,Field);
// shops
If fCurrentSearchSettings.SearchShops then
  begin
    ShopCntr := 0;
    SetLength(SearchResult.Shops,fShopCount);
    For i := ShopLowIndex to ShopHighIndex do
      begin
        For ShopField := Low(TILAdvShopSearchResult) to High(TILAdvShopSearchResult) do
          If SearchShopField(i,fShops[i],ShopField) then
            Include(SearchResult.Shops[ShopCntr].ShopValue,ShopField);
        If SearchResult.Shops[ShopCntr].ShopValue <> [] then
          begin
            SearchResult.Shops[ShopCntr].ShopIndex := i;
            Inc(ShopCntr);
          end;
      end;
    SetLength(SearchResult.Shops,ShopCntr);
  end;
// final touches
If (SearchResult.ItemValue <> []) or (Length(SearchResult.Shops) > 0) then
  SearchResult.ItemIndex := fIndex;
Result := SearchResult.ItemIndex >= 0;
end;

end.
