unit InflatablesList_Item_Comp;
{$message 'll_rework'}

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
  SysUtils, StrUtils,
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
  AnsiContainsText(TypeStr,Text) or
  AnsiContainsText(fItemTypeSpec,Text) or
  AnsiContainsText(Format('%dpcs',[fPieces]),Text) or
  AnsiContainsText(fDataProvider.ItemManufacturers[fManufacturer].Str,Text) or
  AnsiContainsText(fManufacturerStr,Text) or
  AnsiContainsText(fTextID,Text) or
  AnsiContainsText(IntToStr(fID),Text) or
  AnsiContainsText(GetFlagsString,Text) or
  AnsiContainsText(fTextTag,Text) or
  AnsiContainsText(IntToStr(fNumTag),Text) or
  AnsiContainsText(IntToStr(fWantedLevel),Text) or
  AnsiContainsText(fVariant,Text) or
  AnsiContainsText(fDataProvider.GetItemMaterialString(fMaterial),Text) or
  AnsiContainsText(Format('%dmm',[fSizeX]),Text) or
  AnsiContainsText(Format('%dmm',[fSizeY]),Text) or
  AnsiContainsText(Format('%dmm',[fSizeZ]),Text) or
  AnsiContainsText(Format('%dg',[fUnitWeight]),Text) or
  AnsiContainsText(Format('%dum',[fThickness]),Text) or
  AnsiContainsText(fNotes,Text) or
  AnsiContainsText(fReviewURL,Text) or
  AnsiContainsText(fItemPictureFile,Text) or
  AnsiContainsText(fSecondaryPictureFile,Text) or
  AnsiContainsText(fPackagePictureFile,Text) or
  AnsiContainsText(Format('%dKè',[fUnitPriceDefault]),Text) or
  AnsiContainsText(Format('%d%%',[fRating]),Text);
If not Result and ShopsSelected(SelShop) then
  Result := AnsiContainsText(SelShop.Name,Text);
end;

//------------------------------------------------------------------------------

Function TILItem_Comp.Compare(WithItem: TILItem_Comp; WithValue: TILItemValueTag; Reversed: Boolean): Integer;
var
  SelShop1: TILItemShop;
  SelShop2: TILItemShop;
begin
case WithValue of
  // internals = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
  ilivtUniqueID:          Result := IL_CompareGUID(fUniqueID,WithItem.UniqueID);
  ilivtTimeOfAdd:         Result := IL_CompareDateTime(fTimeOfAddition,WithItem.TimeOfAddition);

  // basic specs = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
  ilivtMainPicture:       Result := IL_CompareBool(Assigned(fItemPicture),Assigned(WithItem.ItemPicture));
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtSecondaryPicture:  Result := IL_CompareBool(Assigned(fSecondaryPicture),Assigned(WithItem.SecondaryPicture));
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtPackagePicture:    Result := IL_CompareBool(Assigned(fPackagePicture),Assigned(WithItem.PackagePicture));
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtItemType:          If not(fItemType in [ilitUnknown,ilitOther]) and not(WithItem.ItemType in [ilitUnknown,ilitOther]) then
                            Result := IL_CompareText(
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
  ilivtItemTypeSpec:      Result := IL_CompareText(fItemTypeSpec,WithItem.ItemTypeSpec);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtCount:             Result := IL_CompareUInt32(fPieces,WithItem.Pieces);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtManufacturer:      If (fManufacturer <> ilimOthers) and (WithItem.Manufacturer <> ilimOthers) then
                            Result := IL_CompareText(
                              fDataProvider.ItemManufacturers[fManufacturer].Str,
                              fDataProvider.ItemManufacturers[WithItem.Manufacturer].Str)
                          else If fManufacturer = ilimOthers then
                            Result := IL_NegateValue(-1,Reversed) // push other to the end
                          else If WithItem.Manufacturer = ilimOthers then
                            Result := IL_NegateValue(+1,Reversed)
                          else
                            Result := 0;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtManufacturerStr:   Result := IL_CompareText(fManufacturerStr,WithItem.ManufacturerStr);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtTextID:            Result := IL_CompareText(fTextID,WithItem.TextID);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtID:                Result := IL_CompareInt32(fID,WithItem.ID);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtIDStr:             Result := IL_CompareText(IDStr,WithItem.IDStr);

  // flags = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
  ilivtFlagOwned:         Result := IL_CompareBool(ilifOwned in fFlags,ilifOwned in WithItem.Flags);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtFlagWanted:        Result := IL_CompareBool(ilifWanted in fFlags,ilifWanted in WithItem.Flags);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtFlagOrdered:       Result := IL_CompareBool(ilifOrdered in fFlags,ilifOrdered in WithItem.Flags);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtFlagBoxed:         Result := IL_CompareBool(ilifBoxed in fFlags,ilifBoxed in WithItem.Flags);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtFlagElsewhere:     Result := IL_CompareBool(ilifElsewhere in fFlags,ilifElsewhere in WithItem.Flags);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtFlagUntested:      Result := IL_CompareBool(ilifUntested in fFlags,ilifUntested in WithItem.Flags);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtFlagTesting:       Result := IL_CompareBool(ilifTesting in fFlags,ilifTesting in WithItem.Flags);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtFlagTested:        Result := IL_CompareBool(ilifTested in fFlags,ilifTested in WithItem.Flags);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtFlagDamaged:       Result := IL_CompareBool(ilifDamaged in fFlags,ilifDamaged in WithItem.Flags);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtFlagRepaired:      Result := IL_CompareBool(ilifRepaired in fFlags,ilifRepaired in WithItem.Flags);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtFlagPriceChange:   Result := IL_CompareBool(ilifPriceChange in fFlags,ilifPriceChange in WithItem.Flags);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtFlagAvailChange:   Result := IL_CompareBool(ilifAvailChange in fFlags,ilifAvailChange in WithItem.Flags);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtFlagNotAvailable:  Result := IL_CompareBool(ilifNotAvailable in fFlags,ilifNotAvailable in WithItem.Flags);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtFlagLost:          Result := IL_CompareBool(ilifLost in fFlags,ilifLost in WithItem.Flags);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtFlagDiscarded:     Result := IL_CompareBool(ilifDiscarded in fFlags,ilifDiscarded in WithItem.Flags);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtTextTag:           If (Length(fTextTag) > 0) and (Length(WithItem.TextTag) > 0) then
                            Result := IL_CompareText(fTextTag,WithItem.TextTag)
                          else If Length(fTextTag) > 0 then
                            Result := IL_NegateValue(+1,Reversed)
                          else If Length(WithItem.TextTag) > 0 then
                            Result := IL_NegateValue(-1,Reversed)
                          else
                            Result := 0;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtNumTag:            If (fNumTag <> 0) and (WithItem.NumTag <> 0) then
                            Result := IL_CompareInt32(fNumTag,WithItem.NumTag)
                          else If fNumTag <> 0 then
                            Result := IL_NegateValue(+1,Reversed)
                          else If WithItem.NumTag <> 0 then
                            Result := IL_NegateValue(-1,Reversed)
                          else
                            Result := 0;

  // extended specs  = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
  ilivtWantedLevel:       If (ilifWanted in fFlags) and (ilifWanted in WithItem.Flags) then
                            Result := IL_CompareUInt32(fWantedLevel,WithItem.WantedLevel)
                          else If ilifWanted in fFlags then
                            Result := IL_NegateValue(+1,Reversed)
                          else If ilifWanted in WithItem.Flags then
                            Result := IL_NegateValue(-1,Reversed) // those without the flag set goes at the end
                          else
                            Result := 0;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtVariant:           Result := IL_CompareText(fVariant,WithItem.Variant);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtMaterial:          If not(fMaterial in [ilimtUnknown,ilimtOther]) and not(WithItem.Material in [ilimtUnknown,ilimtOther]) then
                            Result := IL_CompareText(
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
  ilivtSizeX:             Result := IL_CompareUInt32(fSizeX,WithItem.SizeX);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtSizeY:             Result := IL_CompareUInt32(fSizeY,WithItem.SizeY);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtSizeZ:             Result := IL_CompareUInt32(fSizeZ,WithItem.SizeZ);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtTotalSize:         If (TotalSize > 0) and (WithItem.TotalSize > 0) then
                            Result := IL_CompareInt64(TotalSize,WithItem.TotalSize)
                          else If TotalSize > 0 then
                            Result := IL_NegateValue(+1,Reversed) // push items with 0 total size to the end
                          else If WithItem.TotalSize > 0 then
                            Result := IL_NegateValue(-1,Reversed)
                          else
                            Result := 0;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtUnitWeight:        If (fUnitWeight > 0) and (WithItem.UnitWeight > 0) then
                            Result := IL_CompareUInt32(fUnitWeight,WithItem.UnitWeight)
                          else If fUnitWeight > 0 then
                            Result := IL_NegateValue(+1,Reversed) // push items with 0 weight to the end
                          else If WithItem.UnitWeight > 0 then
                            Result := IL_NegateValue(-1,Reversed)
                          else
                            Result := 0;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtTotalWeight:       If (TotalWeight > 0) and (WithItem.TotalWeight > 0) then
                            Result := IL_CompareUInt32(TotalWeight,WithItem.TotalWeight)
                          else If TotalWeight > 0 then
                            Result := IL_NegateValue(+1,Reversed) // push items with 0 total weight to the end
                          else If WithItem.TotalWeight > 0 then
                            Result := IL_NegateValue(-1,Reversed)
                          else
                            Result := 0;
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtThickness:         If (fThickness > 0) and (WithItem.Thickness > 0) then
                            Result := IL_CompareUInt32(fThickness,WithItem.Thickness)
                          else If fThickness > 0 then
                            Result := IL_NegateValue(+1,Reversed) // push items with 0 thickness to the end
                          else If WithItem.Thickness > 0 then
                            Result := IL_NegateValue(-1,Reversed)
                          else
                            Result := 0;

  // others  = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
  ilivtNotes:             Result := IL_CompareText(fNotes,WithItem.Notes);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtReviewURL:         Result := IL_CompareText(fReviewURL,WithItem.ReviewURL);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtReview:            Result := IL_CompareBool(Length(fReviewURL) > 0,Length(WithItem.ReviewURL) > 0);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtMainPictureFile:   Result := IL_CompareText(fItemPictureFile,WithItem.ItemPictureFile);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtMainPicFilePres:   Result := IL_CompareBool(Length(fItemPictureFile) > 0,Length(WithItem.ItemPictureFile) > 0);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtSecondaryPictureFile:  Result := IL_CompareText(fSecondaryPictureFile,WithItem.SecondaryPictureFile);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtSecondaryPicFilePres:  Result := IL_CompareBool(Length(fSecondaryPictureFile) > 0,Length(WithItem.SecondaryPictureFile) > 0);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtPackPictureFile:   Result := IL_CompareText(fPackagePictureFile,WithItem.PackagePictureFile);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtPackPicFilePres:   Result := IL_CompareBool(Length(fPackagePictureFile) > 0,Length(WithItem.PackagePictureFile) > 0);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtUnitPriceDefault:  Result := IL_CompareUInt32(fUnitPriceDefault,WithItem.UnitPriceDefault);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtRating:            If ((ilifOwned in fFlags) and not(ilifWanted in fFlags)) and
                             ((ilifOwned in WithItem.Flags) and not(ilifWanted in WithItem.Flags)) then
                            Result := IL_CompareUInt32(fRating,WithItem.Rating)
                          // those without proper flag combination goes at the end
                          else If ((ilifOwned in fFlags) and not(ilifWanted in fFlags)) then
                            Result := IL_NegateValue(+1,Reversed)
                          else If ((ilifOwned in WithItem.Flags) and not(ilifWanted in WithItem.Flags)) then
                            Result := IL_NegateValue(-1,Reversed)
                          else
                            Result := 0; 
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtUnitPriceLowest:   Result := IL_CompareUInt32(fUnitPriceLowest,WithItem.UnitPriceLowest);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtTotalPriceLowest:  Result := IL_CompareUInt32(TotalPriceLowest,WithItem.TotalPriceLowest);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtUnitPriceSel:      Result := IL_CompareUInt32(fUnitPriceSelected,WithItem.UnitPriceSelected);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtTotalPriceSel:     Result := IL_CompareUInt32(TotalPriceSelected,WithItem.TotalPriceSelected);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtTotalPrice:        Result := IL_CompareUInt32(TotalPrice,WithItem.TotalPrice);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtAvailable:         If (fAvailableSelected < 0) and (WithItem.AvailableSelected < 0) then
                            Result := IL_CompareInt32(Abs(fAvailableSelected),Abs(WithItem.AvailableSelected))
                          else If (fAvailableSelected < 0) then
                            Result := IL_CompareInt32(Abs(fAvailableSelected) + 1,WithItem.AvailableSelected)
                          else If (WithItem.AvailableSelected < 0) then
                            Result := IL_CompareInt32(fAvailableSelected,Abs(WithItem.AvailableSelected) + 1)
                          else
                            Result := IL_CompareInt32(fAvailableSelected,WithItem.AvailableSelected);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtShopCount:         Result := IL_CompareUInt32(fShopCount,WithItem.ShopCount);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtUsefulShopCount:   Result := IL_CompareUInt32(ShopsUsefulCount,WithItem.ShopsUsefulCount);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtUsefulShopRatio:   If (fShopCount > 0) and (WithItem.ShopCount > 0) then
                            Result := IL_CompareFloat(ShopsUsefulRatio,WithItem.ShopsUsefulRatio)
                          else If fShopCount > 0 then
                            Result := IL_NegateValue(+1,Reversed) // push items with no shop to the end
                          else If WithItem.ShopCount > 0 then
                            Result := IL_NegateValue(-1,Reversed)
                          else
                            Result := 0;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtSelectedShop:      If ShopsSelected(SelShop1) and WithItem.ShopsSelected(SelShop2) then
                            Result := IL_CompareText(SelShop1.Name,SelShop2.Name)
                          else If ShopsSelected(SelShop1) then
                            Result := IL_NegateValue(+1,Reversed)
                          else If WithItem.ShopsSelected(SelShop2) then
                            Result := IL_NegateValue(-1,Reversed) // push items with no shop selected at the end
                          else
                            Result := 0;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtWorstUpdateResult: If (fShopCount > 0) and (WithItem.ShopCount > 0) then
                            Result := IL_CompareInt32(Ord(ShopsWorstUpdateResult),Ord(WithItem.ShopsWorstUpdateResult))
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
