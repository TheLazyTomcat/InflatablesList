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
    Function SearchField(const SearchSettings: TILAdvSearchSettings; Field: TILAdvItemSearchResult): Boolean; virtual;
  public
    Function FindPrev(const Text: String; From: TILItemSearchResult = ilisrNone): TILItemSearchResult; virtual;
    Function FindNext(const Text: String; From: TILItemSearchResult = ilisrNone): TILItemSearchResult; virtual;
    Function FindAll(const SearchSettings: TILAdvSearchSettings; out SearchResult: TILAdvSearchResult): Boolean; virtual;
  end;

implementation

uses
  SysUtils,
  InflatablesList_Utils;

Function TILItem_Search.SearchField(const SearchSettings: TILAdvSearchSettings; Field: TILAdvItemSearchResult): Boolean;
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
  ilaisrListIndex:            Result := SearchSettings.CompareFunc(IntToStr(fIndex),False,False,False);
  ilaisrUniqueID:             Result := SearchSettings.CompareFunc(GUIDToString(fUniqueID),False,False,False);
  ilaisrTimeOfAdd:            Result := SearchSettings.CompareFunc(IL_FormatDateTime('yyyy-mm-dd hh:nn:ss',fTimeOfAddition),False,False,False);
  ilaisrDescriptor:           Result := SearchSettings.CompareFunc(Descriptor,True,False,True);
  ilaisrTitleStr:             Result := SearchSettings.CompareFunc(TitleStr,True,False,True);
  ilaisrType:                 Result := SearchSettings.CompareFunc(fDataProvider.GetItemTypeString(fItemType),False,True,False);
  ilaisrTypeSpec:             Result := SearchSettings.CompareFunc(fItemTypeSpec,True,True,False);
  ilaisrTypeStr:              Result := SearchSettings.CompareFunc(TypeStr,True,False,True);
  ilaisrPieces:               Result := SearchSettings.CompareFunc(IntToStr(fPieces),False,True,False,'pcs');
  ilaisrUserID:               Result := SearchSettings.CompareFunc(fUserID,True,True,False);
  ilaisrManufacturer:         Result := SearchSettings.CompareFunc(fDataProvider.ItemManufacturers[fManufacturer].Str,False,True,False);
  ilaisrManufacturerStr:      Result := SearchSettings.CompareFunc(fManufacturerStr,True,True,False);
  ilaisrManufacturerTag:      Result := SearchSettings.CompareFunc(fDataProvider.ItemManufacturers[fManufacturer].Tag ,True,False,False);
  ilaisrTextID:               Result := SearchSettings.CompareFunc(fTextID,True,True,False);
  ilaisrNumID:                Result := SearchSettings.CompareFunc(IntToStr(fID),False,True,False);
  ilaisrIDStr:                Result := SearchSettings.CompareFunc(IDStr,True,False,False);
  ilaisrFlags:                Result := SearchSettings.CompareFunc(GetFlagsString,False,True,True);
  ilaisrFlagOwned:            Result := (ilifOwned in fFlags) and SearchSettings.CompareFunc(fDataProvider.GetItemFlagString(ilifOwned),False,True,False);
  ilaisrFlagWanted:           Result := (ilifWanted in fFlags) and SearchSettings.CompareFunc(fDataProvider.GetItemFlagString(ilifWanted),False,True,False);
  ilaisrFlagOrdered:          Result := (ilifOrdered in fFlags) and SearchSettings.CompareFunc(fDataProvider.GetItemFlagString(ilifOrdered),False,True,False);
  ilaisrFlagBoxed:            Result := (ilifBoxed in fFlags) and SearchSettings.CompareFunc(fDataProvider.GetItemFlagString(ilifBoxed),False,True,False);
  ilaisrFlagElsewhere:        Result := (ilifElsewhere in fFlags) and SearchSettings.CompareFunc(fDataProvider.GetItemFlagString(ilifElsewhere),False,True,False);
  ilaisrFlagUntested:         Result := (ilifUntested in fFlags) and SearchSettings.CompareFunc(fDataProvider.GetItemFlagString(ilifUntested),False,True,False);
  ilaisrFlagTesting:          Result := (ilifTesting in fFlags) and SearchSettings.CompareFunc(fDataProvider.GetItemFlagString(ilifTesting),False,True,False);
  ilaisrFlagTested:           Result := (ilifTested in fFlags) and SearchSettings.CompareFunc(fDataProvider.GetItemFlagString(ilifTested),False,True,False);
  ilaisrFlagDamaged:          Result := (ilifDamaged in fFlags) and SearchSettings.CompareFunc(fDataProvider.GetItemFlagString(ilifDamaged),False,True,False);
  ilaisrFlagRepaired:         Result := (ilifRepaired in fFlags) and SearchSettings.CompareFunc(fDataProvider.GetItemFlagString(ilifRepaired),False,True,False);
  ilaisrFlagPriceChange:      Result := (ilifPriceChange in fFlags) and SearchSettings.CompareFunc(fDataProvider.GetItemFlagString(ilifPriceChange),False,True,False);
  ilaisrFlagAvailChange:      Result := (ilifAvailChange in fFlags) and SearchSettings.CompareFunc(fDataProvider.GetItemFlagString(ilifAvailChange),False,True,False);
  ilaisrFlagNotAvailable:     Result := (ilifNotAvailable in fFlags) and SearchSettings.CompareFunc(fDataProvider.GetItemFlagString(ilifNotAvailable),False,True,False);
  ilaisrFlagLost:             Result := (ilifLost in fFlags) and SearchSettings.CompareFunc(fDataProvider.GetItemFlagString(ilifLost),False,True,False);
  ilaisrFlagDiscarded:        Result := (ilifDiscarded in fFlags) and SearchSettings.CompareFunc(fDataProvider.GetItemFlagString(ilifDiscarded),False,True,False);
  ilaisrTextTag:              Result := SearchSettings.CompareFunc(fTextTag,True,True,False);
  ilaisrNumTag:               Result := SearchSettings.CompareFunc(IntToStr(fNumTag),True,True,False);
  ilaisrWantedLevel:          Result := SearchSettings.CompareFunc(IntToStr(fWantedLevel),False,True,False);
  ilaisrVariant:              Result := SearchSettings.CompareFunc(fVariant,True,True,False);
  ilaisrVariantTag:           Result := SearchSettings.CompareFunc(fVariantTag,True,True,False);
  ilaisrMaterial:             Result := SearchSettings.CompareFunc(fDataProvider.GetItemMaterialString(fMaterial),False,True,False);
  ilaisrSizeX:                Result := SearchSettings.CompareFunc(IntToStr(fSizeX),False,True,False,'mm');
  ilaisrSizeY:                Result := SearchSettings.CompareFunc(IntToStr(fSizeY),False,True,False,'mm');
  ilaisrSizeZ:                Result := SearchSettings.CompareFunc(IntToStr(fSizeZ),False,True,False,'mm');
  ilaisrTotalSize:            Result := SearchSettings.CompareFunc(IntToStr(TotalSize),False,False,True,'mm^3');
  ilaisrSizeStr:              Result := SearchSettings.CompareFunc(SizeStr,False,False,True);
  ilaisrUnitWeight:           Result := SearchSettings.CompareFunc(IntToStr(fUnitWeight),False,True,False,'g');
  ilaisrTotalWeight:          Result := SearchSettings.CompareFunc(IntToStr(TotalWeight),False,False,True,'g');
  ilaisrTotalWeightStr:       Result := SearchSettings.CompareFunc(TotalWeightStr,True,False,True);
  ilaisrThickness:            Result := SearchSettings.CompareFunc(IntToStr(fThickness),False,True,False,'um');
  ilaisrNotes:                Result := SearchSettings.CompareFunc(fNotes,True,True,False);
  ilaisrReviewURL:            Result := SearchSettings.CompareFunc(fReviewURL,True,True,False);
  {$message 'reimplement'}
  //ilaisrMainPictureFile:      Result := SearchSettings.CompareFunc(fItemPictureFile,True,True,False);
  //ilaisrSecondaryPictureFile: Result := SearchSettings.CompareFunc(fSecondaryPictureFile,True,True,False);
  //ilaisrPackagePictureFile:   Result := SearchSettings.CompareFunc(fPackagePictureFile,True,True,False);
  ilaisrUnitPriceDefault:     Result := SearchSettings.CompareFunc(IntToStr(fUnitPriceDefault),False,True,False,'Kè');
  ilaisrRating:               Result := SearchSettings.CompareFunc(IntToStr(fRating),False,True,False,'%');
  ilaisrUnitPrice:            Result := SearchSettings.CompareFunc(IntToStr(UnitPrice),False,False,True,'Kè');
  ilaisrUnitPriceLowest:      Result := SearchSettings.CompareFunc(IntToStr(fUnitPriceLowest),False,False,True,'Kè');
  ilaisrTotalPriceLowest:     Result := SearchSettings.CompareFunc(IntToStr(TotalPriceLowest),False,False,True,'Kè');
  ilaisrUnitPriceHighest:     Result := SearchSettings.CompareFunc(IntToStr(fUnitPriceHighest),False,False,True,'Kè');
  ilaisrTotalPriceHighest:    Result := SearchSettings.CompareFunc(IntToStr(TotalPriceHighest),False,False,True,'Kè');
  ilaisrUnitPriceSel:         Result := SearchSettings.CompareFunc(IntToStr(fUnitPriceSelected),False,False,False,'Kè');
  ilaisrTotalPriceSel:        Result := SearchSettings.CompareFunc(IntToStr(TotalPriceSelected),False,False,True,'Kè');
  ilaisrTotalPrice:           Result := SearchSettings.CompareFunc(IntToStr(TotalPrice),False,False,True,'Kè');
  ilaisrAvailableLowest:      Result := SearchSettings.CompareFunc(IntToStr(fAvailableLowest),False,False,True,'pcs');
  ilaisrAvailableHighest:     Result := SearchSettings.CompareFunc(IntToStr(fAvailableHighest),False,False,True,'pcs');
  ilaisrAvailableSel:         Result := SearchSettings.CompareFunc(IntToStr(fAvailableSelected),False,False,False,'pcs');
  ilaisrShopCount:            Result := SearchSettings.CompareFunc(IntToStr(fShopCount),False,False,False);
  ilaisrShopCountStr:         Result := SearchSettings.CompareFunc(ShopsCountStr,True,False,True);
  ilaisrUsefulShopCount:      Result := SearchSettings.CompareFunc(IntToStr(ShopsUsefulCount),False,False,True);
  ilaisrUsefulShopRatio:      Result := SearchSettings.CompareFunc(IL_Format('%f',[ShopsUsefulRatio]),False,False,True);
  ilaisrSelectedShop:         If ShopsSelected(SelShop) then
                                Result := SearchSettings.CompareFunc(SelShop.Name,True,True,False)
                              else
                                Result := False;
  ilaisrWorstUpdateResult:    Result := SearchSettings.CompareFunc(fDataProvider.GetShopUpdateResultString(ShopsWorstUpdateResult),False,False,True);
else
  Result := False;
end;
end;

//==============================================================================

Function TILItem_Search.FindPrev(const Text: String; From: TILItemSearchResult = ilisrNone): TILItemSearchResult;
var
  i:  TILItemSearchResult;
begin
Result := ilisrNone;
If fDataAccessible then
  begin
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
end;

//------------------------------------------------------------------------------

Function TILItem_Search.FindNext(const Text: String; From: TILItemSearchResult = ilisrNone): TILItemSearchResult;
var
  i:  TILItemSearchResult;
begin
Result := ilisrNone;
If fDataAccessible then
  begin
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
end;

//------------------------------------------------------------------------------

Function TILItem_Search.FindAll(const SearchSettings: TILAdvSearchSettings; out SearchResult: TILAdvSearchResult): Boolean;
var
  Field:      TILAdvItemSearchResult;
  i:          Integer;
  ShopCntr:   Integer;
  ShopField:  TILAdvShopSearchResult;
begin
// init
SearchResult.ItemIndex := -1;
SearchResult.ItemValue := [];
SetLength(SearchResult.Shops,0);
// fields
For Field := Low(TILAdvItemSearchResult) to High(TILAdvItemSearchResult) do
  If SearchField(SearchSettings,Field) then
    Include(SearchResult.ItemValue,Field);
// shops
If SearchSettings.SearchShops then
  begin
    ShopCntr := 0;
    SetLength(SearchResult.Shops,fShopCount);
    For i := ShopLowIndex to ShopHighIndex do
      begin
        For ShopField := Low(TILAdvShopSearchResult) to High(TILAdvShopSearchResult) do
          If fShops[i].SearchField(SearchSettings,i,ShopField) then
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
