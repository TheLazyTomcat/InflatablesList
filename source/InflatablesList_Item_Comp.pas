unit InflatablesList_Item_Comp;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  InflatablesList_Types,
  InflatablesList_Item_Draw;

type
  TILItem_Comp = class(TILItem_Draw)
  public
    Function Contains(const Text: String): Boolean; virtual;
    Function Compare(WithItem: TILItem_Comp; WithValue: TILItemValueTag; Reversed: Boolean): Integer; virtual;
    procedure Filter(FilterSettings: TILFilterSettings); virtual;
  end;

implementation

uses
  SysUtils,
  AuxTypes, BitOps,
  InflatablesList_Utils,
  InflatablesList_ItemShop;

Function TILItem_Comp.Contains(const Text: String): Boolean;
var
  SelShop:  TILItemShop;

  Function GetFlagsString: String;
  const
    FLAG_STRS: array[TILItemFlag] of String = (
      'Owned','Wanted','Ordered','Boxed','Elsewhere','Untested','Testing',
      'Tested','Damaged','Repaired','Price change','Available change',
      'Not Available','Lost','Discarded');
  var
    Flag: TILItemFlag;
  begin
    Result := '';
    For Flag := Low(TILItemFlag) to High(TILItemFlag) do
      If Flag in fFlags then
        Result := Result + FLAG_STRS[Flag];
  end;

begin
// search only in editable values
Result :=
  IL_ContainsText(TypeStr,Text) or
  IL_ContainsText(fItemTypeSpec,Text) or
  IL_ContainsText(IL_Format('%dpcs',[fPieces]),Text) or
  IL_ContainsText(fDataProvider.ItemManufacturers[fManufacturer].Str,Text) or
  IL_ContainsText(fManufacturerStr,Text) or
  IL_ContainsText(fTextID,Text) or
  IL_ContainsText(IntToStr(fID),Text) or
  IL_ContainsText(GetFlagsString,Text) or
  IL_ContainsText(fTextTag,Text) or
  IL_ContainsText(IntToStr(fNumTag),Text) or
  IL_ContainsText(IntToStr(fWantedLevel),Text) or
  IL_ContainsText(fVariant,Text) or
  IL_ContainsText(fDataProvider.GetItemMaterialString(fMaterial),Text) or
  IL_ContainsText(IL_Format('%dmm',[fSizeX]),Text) or
  IL_ContainsText(IL_Format('%dmm',[fSizeY]),Text) or
  IL_ContainsText(IL_Format('%dmm',[fSizeZ]),Text) or
  IL_ContainsText(IL_Format('%dg',[fUnitWeight]),Text) or
  IL_ContainsText(IL_Format('%dum',[fThickness]),Text) or
  IL_ContainsText(fNotes,Text) or
  IL_ContainsText(fReviewURL,Text) or
  IL_ContainsText(fItemPictureFile,Text) or
  IL_ContainsText(fSecondaryPictureFile,Text) or
  IL_ContainsText(fPackagePictureFile,Text) or
  IL_ContainsText(IL_Format('%dKè',[fUnitPriceDefault]),Text) or
  IL_ContainsText(IL_Format('%d%%',[fRating]),Text);
If not Result and ShopsSelected(SelShop) then
  Result := IL_ContainsText(SelShop.Name,Text);
end;

//------------------------------------------------------------------------------

Function TILItem_Comp.Compare(WithItem: TILItem_Comp; WithValue: TILItemValueTag; Reversed: Boolean): Integer;
var
  SelShop1: TILItemShop;
  SelShop2: TILItemShop;
begin
case WithValue of
  // internals = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
  ilivtUniqueID:          Result := IL_SortCompareGUID(fUniqueID,WithItem.UniqueID);
  ilivtTimeOfAdd:         Result := IL_SortCompareDateTime(fTimeOfAddition,WithItem.TimeOfAddition);

  // basic specs = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
  ilivtMainPicture:       Result := IL_SortCompareBool(Assigned(fItemPicture),Assigned(WithItem.ItemPicture));
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtSecondaryPicture:  Result := IL_SortCompareBool(Assigned(fSecondaryPicture),Assigned(WithItem.SecondaryPicture));
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtPackagePicture:    Result := IL_SortCompareBool(Assigned(fPackagePicture),Assigned(WithItem.PackagePicture));
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtItemType:          If not(fItemType in [ilitUnknown,ilitOther]) and not(WithItem.ItemType in [ilitUnknown,ilitOther]) then
                            Result := IL_SortCompareText(
                              fDataProvider.GetItemTypeString(fItemType),
                              fDataProvider.GetItemTypeString(WithItem.ItemType))
                          // push others and unknowns to the end
                          else If not(fItemType in [ilitUnknown,ilitOther]) then
                            Result := IL_NegateValue(+1,Reversed)
                          else If not(WithItem.ItemType in [ilitUnknown,ilitOther]) then
                            Result := IL_NegateValue(-1,Reversed)
                          // both are either unknown or other, push unknown to the end...
                          else If fItemType <> WithItem.ItemType then
                            begin
                              If fItemType = ilitOther then
                                Result := IL_NegateValue(+1,Reversed)
                              else If WithItem.ItemType = ilitOther then
                                Result := IL_NegateValue(-1,Reversed)
                              else
                                Result := 0;
                            end
                          else Result := 0;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtItemTypeSpec:      Result := IL_SortCompareText(fItemTypeSpec,WithItem.ItemTypeSpec);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtCount:             Result := IL_SortCompareUInt32(fPieces,WithItem.Pieces);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtManufacturer:      If (fManufacturer <> ilimOthers) and (WithItem.Manufacturer <> ilimOthers) then
                            Result := IL_SortCompareText(
                              fDataProvider.ItemManufacturers[fManufacturer].Str,
                              fDataProvider.ItemManufacturers[WithItem.Manufacturer].Str)
                          else If fManufacturer = ilimOthers then
                            Result := IL_NegateValue(-1,Reversed) // push other to the end
                          else If WithItem.Manufacturer = ilimOthers then
                            Result := IL_NegateValue(+1,Reversed)
                          else
                            Result := 0;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtManufacturerStr:   Result := IL_SortCompareText(fManufacturerStr,WithItem.ManufacturerStr);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtTextID:            Result := IL_SortCompareText(fTextID,WithItem.TextID);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtID:                Result := IL_SortCompareInt32(fID,WithItem.ID);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtIDStr:             Result := IL_SortCompareText(IDStr,WithItem.IDStr);

  // flags = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
  ilivtFlagOwned:         Result := IL_SortCompareBool(ilifOwned in fFlags,ilifOwned in WithItem.Flags);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtFlagWanted:        Result := IL_SortCompareBool(ilifWanted in fFlags,ilifWanted in WithItem.Flags);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtFlagOrdered:       Result := IL_SortCompareBool(ilifOrdered in fFlags,ilifOrdered in WithItem.Flags);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtFlagBoxed:         Result := IL_SortCompareBool(ilifBoxed in fFlags,ilifBoxed in WithItem.Flags);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtFlagElsewhere:     Result := IL_SortCompareBool(ilifElsewhere in fFlags,ilifElsewhere in WithItem.Flags);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtFlagUntested:      Result := IL_SortCompareBool(ilifUntested in fFlags,ilifUntested in WithItem.Flags);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtFlagTesting:       Result := IL_SortCompareBool(ilifTesting in fFlags,ilifTesting in WithItem.Flags);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtFlagTested:        Result := IL_SortCompareBool(ilifTested in fFlags,ilifTested in WithItem.Flags);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtFlagDamaged:       Result := IL_SortCompareBool(ilifDamaged in fFlags,ilifDamaged in WithItem.Flags);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtFlagRepaired:      Result := IL_SortCompareBool(ilifRepaired in fFlags,ilifRepaired in WithItem.Flags);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtFlagPriceChange:   Result := IL_SortCompareBool(ilifPriceChange in fFlags,ilifPriceChange in WithItem.Flags);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtFlagAvailChange:   Result := IL_SortCompareBool(ilifAvailChange in fFlags,ilifAvailChange in WithItem.Flags);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtFlagNotAvailable:  Result := IL_SortCompareBool(ilifNotAvailable in fFlags,ilifNotAvailable in WithItem.Flags);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtFlagLost:          Result := IL_SortCompareBool(ilifLost in fFlags,ilifLost in WithItem.Flags);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtFlagDiscarded:     Result := IL_SortCompareBool(ilifDiscarded in fFlags,ilifDiscarded in WithItem.Flags);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtTextTag:           If (Length(fTextTag) > 0) and (Length(WithItem.TextTag) > 0) then
                            Result := IL_SortCompareText(fTextTag,WithItem.TextTag)
                          else If Length(fTextTag) > 0 then
                            Result := IL_NegateValue(+1,Reversed)
                          else If Length(WithItem.TextTag) > 0 then
                            Result := IL_NegateValue(-1,Reversed)
                          else
                            Result := 0;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtNumTag:            If (fNumTag <> 0) and (WithItem.NumTag <> 0) then
                            Result := IL_SortCompareInt32(fNumTag,WithItem.NumTag)
                          else If fNumTag <> 0 then
                            Result := IL_NegateValue(+1,Reversed)
                          else If WithItem.NumTag <> 0 then
                            Result := IL_NegateValue(-1,Reversed)
                          else
                            Result := 0;

  // extended specs  = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
  ilivtWantedLevel:       If (ilifWanted in fFlags) and (ilifWanted in WithItem.Flags) then
                            Result := IL_SortCompareUInt32(fWantedLevel,WithItem.WantedLevel)
                          else If ilifWanted in fFlags then
                            Result := IL_NegateValue(+1,Reversed)
                          else If ilifWanted in WithItem.Flags then
                            Result := IL_NegateValue(-1,Reversed) // those without the flag set goes at the end
                          else
                            Result := 0;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtVariant:           Result := IL_SortCompareText(fVariant,WithItem.Variant);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtMaterial:          If not(fMaterial in [ilimtUnknown,ilimtOther]) and not(WithItem.Material in [ilimtUnknown,ilimtOther]) then
                            Result := IL_SortCompareText(
                              fDataProvider.GetItemMaterialString(fMaterial),
                              fDataProvider.GetItemMaterialString(WithItem.Material))
                          // push others and unknowns to the end
                          else If not(fMaterial in [ilimtUnknown,ilimtOther]) then
                            Result := IL_NegateValue(+1,Reversed)
                          else If not(WithItem.Material in [ilimtUnknown,ilimtOther]) then
                            Result := IL_NegateValue(-1,Reversed)
                          // both are either unknown or other, push unknown to the end...
                          else If fMaterial <> WithItem.Material then
                            begin
                              If fMaterial = ilimtOther then
                                Result := IL_NegateValue(+1,Reversed)
                              else If WithItem.Material = ilimtOther then
                                Result := IL_NegateValue(-1,Reversed)
                              else
                                Result := 0;
                            end
                          else Result := 0;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtSizeX:             Result := IL_SortCompareUInt32(fSizeX,WithItem.SizeX);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtSizeY:             Result := IL_SortCompareUInt32(fSizeY,WithItem.SizeY);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtSizeZ:             Result := IL_SortCompareUInt32(fSizeZ,WithItem.SizeZ);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtTotalSize:         If (TotalSize > 0) and (WithItem.TotalSize > 0) then
                            Result := IL_SortCompareInt64(TotalSize,WithItem.TotalSize)
                          else If TotalSize > 0 then
                            Result := IL_NegateValue(+1,Reversed) // push items with 0 total size to the end
                          else If WithItem.TotalSize > 0 then
                            Result := IL_NegateValue(-1,Reversed)
                          else
                            Result := 0;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtUnitWeight:        If (fUnitWeight > 0) and (WithItem.UnitWeight > 0) then
                            Result := IL_SortCompareUInt32(fUnitWeight,WithItem.UnitWeight)
                          else If fUnitWeight > 0 then
                            Result := IL_NegateValue(+1,Reversed) // push items with 0 weight to the end
                          else If WithItem.UnitWeight > 0 then
                            Result := IL_NegateValue(-1,Reversed)
                          else
                            Result := 0;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtTotalWeight:       If (TotalWeight > 0) and (WithItem.TotalWeight > 0) then
                            Result := IL_SortCompareUInt32(TotalWeight,WithItem.TotalWeight)
                          else If TotalWeight > 0 then
                            Result := IL_NegateValue(+1,Reversed) // push items with 0 total weight to the end
                          else If WithItem.TotalWeight > 0 then
                            Result := IL_NegateValue(-1,Reversed)
                          else
                            Result := 0;
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtThickness:         If (fThickness > 0) and (WithItem.Thickness > 0) then
                            Result := IL_SortCompareUInt32(fThickness,WithItem.Thickness)
                          else If fThickness > 0 then
                            Result := IL_NegateValue(+1,Reversed) // push items with 0 thickness to the end
                          else If WithItem.Thickness > 0 then
                            Result := IL_NegateValue(-1,Reversed)
                          else
                            Result := 0;

  // others  = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
  ilivtNotes:             Result := IL_SortCompareText(fNotes,WithItem.Notes);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtReviewURL:         Result := IL_SortCompareText(fReviewURL,WithItem.ReviewURL);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtReview:            Result := IL_SortCompareBool(Length(fReviewURL) > 0,Length(WithItem.ReviewURL) > 0);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtMainPictureFile:   Result := IL_SortCompareText(fItemPictureFile,WithItem.ItemPictureFile);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtMainPicFilePres:   Result := IL_SortCompareBool(Length(fItemPictureFile) > 0,Length(WithItem.ItemPictureFile) > 0);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtSecondaryPictureFile:  Result := IL_SortCompareText(fSecondaryPictureFile,WithItem.SecondaryPictureFile);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtSecondaryPicFilePres:  Result := IL_SortCompareBool(Length(fSecondaryPictureFile) > 0,Length(WithItem.SecondaryPictureFile) > 0);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtPackPictureFile:   Result := IL_SortCompareText(fPackagePictureFile,WithItem.PackagePictureFile);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtPackPicFilePres:   Result := IL_SortCompareBool(Length(fPackagePictureFile) > 0,Length(WithItem.PackagePictureFile) > 0);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtUnitPriceDefault:  Result := IL_SortCompareUInt32(fUnitPriceDefault,WithItem.UnitPriceDefault);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtRating:            If ((ilifOwned in fFlags) and not(ilifWanted in fFlags)) and
                             ((ilifOwned in WithItem.Flags) and not(ilifWanted in WithItem.Flags)) then
                            Result := IL_SortCompareUInt32(fRating,WithItem.Rating)
                          // those without proper flag combination goes at the end
                          else If ((ilifOwned in fFlags) and not(ilifWanted in fFlags)) then
                            Result := IL_NegateValue(+1,Reversed)
                          else If ((ilifOwned in WithItem.Flags) and not(ilifWanted in WithItem.Flags)) then
                            Result := IL_NegateValue(-1,Reversed)
                          else
                            Result := 0; 
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtUnitPriceLowest:   Result := IL_SortCompareUInt32(fUnitPriceLowest,WithItem.UnitPriceLowest);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtTotalPriceLowest:  Result := IL_SortCompareUInt32(TotalPriceLowest,WithItem.TotalPriceLowest);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtUnitPriceSel:      Result := IL_SortCompareUInt32(fUnitPriceSelected,WithItem.UnitPriceSelected);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtTotalPriceSel:     Result := IL_SortCompareUInt32(TotalPriceSelected,WithItem.TotalPriceSelected);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtTotalPrice:        Result := IL_SortCompareUInt32(TotalPrice,WithItem.TotalPrice);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtAvailable:         If (fAvailableSelected < 0) and (WithItem.AvailableSelected < 0) then
                            Result := IL_SortCompareInt32(Abs(fAvailableSelected),Abs(WithItem.AvailableSelected))
                          else If (fAvailableSelected < 0) then
                            Result := IL_SortCompareInt32(Abs(fAvailableSelected) + 1,WithItem.AvailableSelected)
                          else If (WithItem.AvailableSelected < 0) then
                            Result := IL_SortCompareInt32(fAvailableSelected,Abs(WithItem.AvailableSelected) + 1)
                          else
                            Result := IL_SortCompareInt32(fAvailableSelected,WithItem.AvailableSelected);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtShopCount:         Result := IL_SortCompareUInt32(fShopCount,WithItem.ShopCount);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtUsefulShopCount:   Result := IL_SortCompareUInt32(ShopsUsefulCount,WithItem.ShopsUsefulCount);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtUsefulShopRatio:   If (fShopCount > 0) and (WithItem.ShopCount > 0) then
                            Result := IL_SortCompareFloat(ShopsUsefulRatio,WithItem.ShopsUsefulRatio)
                          else If fShopCount > 0 then
                            Result := IL_NegateValue(+1,Reversed) // push items with no shop to the end
                          else If WithItem.ShopCount > 0 then
                            Result := IL_NegateValue(-1,Reversed)
                          else
                            Result := 0;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtSelectedShop:      If ShopsSelected(SelShop1) and WithItem.ShopsSelected(SelShop2) then
                            Result := IL_SortCompareText(SelShop1.Name,SelShop2.Name)
                          else If ShopsSelected(SelShop1) then
                            Result := IL_NegateValue(+1,Reversed)
                          else If WithItem.ShopsSelected(SelShop2) then
                            Result := IL_NegateValue(-1,Reversed) // push items with no shop selected at the end
                          else
                            Result := 0;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtWorstUpdateResult: If (fShopCount > 0) and (WithItem.ShopCount > 0) then
                            Result := IL_SortCompareInt32(Ord(ShopsWorstUpdateResult),Ord(WithItem.ShopsWorstUpdateResult))
                          else If fShopCount > 0 then
                            Result := IL_NegateValue(+1,Reversed) // push items with no shop to the end
                          else If WithItem.ShopCount > 0 then
                            Result := IL_NegateValue(-1,Reversed)
                          else
                            Result := 0;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
else
  {vtNone}
  Result := 0;
end;
If Result < -1 then
  Result := -1
else If Result > 1 then
  Result := 1;
If Reversed then
  Result := -Result;  
end;

//------------------------------------------------------------------------------

procedure TILItem_Comp.Filter(FilterSettings: TILFilterSettings);
var
  FlagsMap:   UInt32;
  FlagsMask:  UInt32;
  i:          Integer;
  StateSet:   Boolean;
  State:      Boolean;  // true = filtered-in, false = filtered-out

  procedure CheckItemFlag(BitMask: UInt32; ItemFlag: TILItemFlag; FlagSet, FlagClr: TILFilterFlag);
  begin
    If FlagSet in FilterSettings.Flags then
      begin
        BitOps.SetFlagStateValue(FlagsMap,BitMask,ItemFlag in fFlags);
        BitOps.SetFlagValue(FlagsMask,BitMask);
      end
    else If FlagClr in FilterSettings.Flags then
      begin
        BitOps.SetFlagStateValue(FlagsMap,BitMask,not(ItemFlag in fFlags));
        BitOps.SetFlagValue(FlagsMask,BitMask);
      end
    else
      begin
        BitOps.ResetFlagValue(FlagsMap,BitMask);
        BitOps.ResetFlagValue(FlagsMask,BitMask);
      end;
  end;

begin
FlagsMap := 0;
FlagsMask := 0;
If FilterSettings.Flags <> [] then
  begin
    CheckItemFlag($00000001,ilifOwned,ilffOwnedSet,ilffOwnedClr);
    CheckItemFlag($00000002,ilifWanted,ilffWantedSet,ilffWantedClr);
    CheckItemFlag($00000004,ilifOrdered,ilffOrderedSet,ilffOrderedClr);
    CheckItemFlag($00000008,ilifBoxed,ilffBoxedSet,ilffBoxedClr);
    CheckItemFlag($00000010,ilifElsewhere,ilffElsewhereSet,ilffElsewhereClr);
    CheckItemFlag($00000020,ilifUntested,ilffUntestedSet,ilffUntestedClr);
    CheckItemFlag($00000040,ilifTesting,ilffTestingSet,ilffTestingClr);
    CheckItemFlag($00000080,ilifTested,ilffTestedSet,ilffTestedClr);
    CheckItemFlag($00000100,ilifDamaged,ilffDamagedSet,ilffDamagedClr);
    CheckItemFlag($00000200,ilifRepaired,ilffRepairedSet,ilffRepairedClr);
    CheckItemFlag($00000400,ilifPriceChange,ilffPriceChangeSet,ilffPriceChangeClr);
    CheckItemFlag($00000800,ilifAvailChange,ilffAvailChangeSet,ilffAvailChangeClr);
    CheckItemFlag($00001000,ilifNotAvailable,ilffNotAvailableSet,ilffNotAvailableClr);
    CheckItemFlag($00002000,ilifLost,ilffLostSet,ilffLostClr);
    CheckItemFlag($00004000,ilifDiscarded,ilffDiscardedSet,ilffDiscardedClr);
  end;
StateSet := False;
State := False; // will be later set to true value
If FlagsMask <> 0 then
  begin
    For i := 0 to Ord(High(TILItemFlag)) do
      begin
        If FlagsMask and 1 <> 0 then
          begin
            If StateSet then
              begin
                case FilterSettings.Operator of
                  ilfoOR:   State := State or (FlagsMap and 1 <> 0);
                  ilfoXOR:  State := State xor (FlagsMap and 1 <> 0);
                else
                 {ilfoAND}
                  State := State and (FlagsMap and 1 <> 0);
                end;
              end
            else
              begin
                State := FlagsMap and 1 <> 0;
                StateSet := True;
              end;
          end;
        FlagsMap := FlagsMap shr 1;
        FlagsMask := FlagsMask shr 1;
      end;
  end
else State := True;
fFilteredOut := not State;
end;

end.
