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
    Function Compare(Item: TILItem_Comp; ItemValueTag: TILItemValueTag; Reversed: Boolean): Integer; virtual;
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
begin
Result :=
  AnsiContainsText(TypeStr,Text) or
  AnsiContainsText(fItemTypeSpec,Text) or
  AnsiContainsText(IntToStr(fPieces),Text) or
  AnsiContainsText(fDataProvider.ItemManufacturers[fManufacturer].Str,Text) or
  AnsiContainsText(fManufacturerStr,Text) or
  AnsiContainsText(IntToStr(fID),Text) or
  AnsiContainsText(fTextTag,Text) or
  AnsiContainsText(IntToStr(fWantedLevel),Text) or
  AnsiContainsText(fVariant,Text) or
  AnsiContainsText(IntToStr(fSizeX),Text) or
  AnsiContainsText(IntToStr(fSizeY),Text) or
  AnsiContainsText(IntToStr(fSizeZ),Text) or
  AnsiContainsText(IntToStr(fUnitWeight),Text) or
  AnsiContainsText(fNotes,Text);
If not Result and ShopsSelected(SelShop) then
  Result := AnsiContainsText(SelShop.Name,Text);
end;

//------------------------------------------------------------------------------

Function TILItem_Comp.Compare(Item: TILItem_Comp; ItemValueTag: TILItemValueTag; Reversed: Boolean): Integer;
var
  SelShop1: TILItemShop;
  SelShop2: TILItemShop;
begin
case ItemValueTag of
  // internals = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
  ilivtUniqueID:          Result := IL_CompareGUID(fUniqueID,Item.UniqueID);
  ilivtTimeOfAdd:         Result := IL_CompareDateTime(fTimeOfAddition,Item.TimeOfAddition);

  // basic specs = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
  ilivtMainPicture:       Result := IL_CompareBool(Assigned(fItemPicture),Assigned(Item.ItemPicture));
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtPackagePicture:    Result := IL_CompareBool(Assigned(fPackagePicture),Assigned(Item.PackagePicture));
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtItemType:          If not(fItemType in [ilitUnknown,ilitOther]) and not(Item.ItemType in [ilitUnknown,ilitOther]) then
                            Result := IL_CompareText(
                              fDataProvider.GetItemTypeString(fItemType),
                              fDataProvider.GetItemTypeString(Item.ItemType))
                          // push others and unknowns to the end
                          else If not(fItemType in [ilitUnknown,ilitOther]) then
                            Result := IL_NegateValue(+1,Reversed)
                          else If not(Item.ItemType in [ilitUnknown,ilitOther]) then
                            Result := IL_NegateValue(-1,Reversed)
                          // both are either unknown or other, push unknown to the end...
                          else If fItemType <> Item.ItemType then
                            begin
                              If fItemType = ilitOther then
                                Result := IL_NegateValue(+1,Reversed)
                              else If Item.ItemType = ilitOther then
                                Result := IL_NegateValue(-1,Reversed)
                              else
                                Result := 0;
                            end
                          else Result := 0;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtItemTypeSpec:      Result := IL_CompareText(fItemTypeSpec,Item.ItemTypeSpec);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtCount:             Result := IL_CompareUInt32(fPieces,Item.Pieces);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtManufacturer:      If (fManufacturer <> ilimOthers) and (Item.Manufacturer <> ilimOthers) then
                            Result := IL_CompareText(
                              fDataProvider.ItemManufacturers[fManufacturer].Str,
                              fDataProvider.ItemManufacturers[Item.Manufacturer].Str)
                          else If fManufacturer = ilimOthers then
                            Result := IL_NegateValue(-1,Reversed) // push other to the end
                          else If Item.Manufacturer = ilimOthers then
                            Result := IL_NegateValue(+1,Reversed)
                          else
                            Result := 0;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtManufacturerStr:   Result := IL_CompareText(fManufacturerStr,Item.ManufacturerStr);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtTextID:            Result := IL_CompareText(fTextID,Item.TextID);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtID:                Result := IL_CompareInt32(fID,Item.ID);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtIDStr:             Result := IL_CompareText(IDStr,Item.IDStr);

  // flags = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
  ilivtFlagOwned:         Result := IL_CompareBool(ilifOwned in fFlags,ilifOwned in Item.Flags);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtFlagWanted:        Result := IL_CompareBool(ilifWanted in fFlags,ilifWanted in Item.Flags);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtFlagOrdered:       Result := IL_CompareBool(ilifOrdered in fFlags,ilifOrdered in Item.Flags);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtFlagBoxed:         Result := IL_CompareBool(ilifBoxed in fFlags,ilifBoxed in Item.Flags);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtFlagElsewhere:     Result := IL_CompareBool(ilifElsewhere in fFlags,ilifElsewhere in Item.Flags);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtFlagUntested:      Result := IL_CompareBool(ilifUntested in fFlags,ilifUntested in Item.Flags);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtFlagTesting:       Result := IL_CompareBool(ilifTesting in fFlags,ilifTesting in Item.Flags);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtFlagTested:        Result := IL_CompareBool(ilifTested in fFlags,ilifTested in Item.Flags);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtFlagDamaged:       Result := IL_CompareBool(ilifDamaged in fFlags,ilifDamaged in Item.Flags);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtFlagRepaired:      Result := IL_CompareBool(ilifRepaired in fFlags,ilifRepaired in Item.Flags);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtFlagPriceChange:   Result := IL_CompareBool(ilifPriceChange in fFlags,ilifPriceChange in Item.Flags);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtFlagAvailChange:   Result := IL_CompareBool(ilifAvailChange in fFlags,ilifAvailChange in Item.Flags);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtFlagNotAvailable:  Result := IL_CompareBool(ilifNotAvailable in fFlags,ilifNotAvailable in Item.Flags);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtFlagLost:          Result := IL_CompareBool(ilifLost in fFlags,ilifLost in Item.Flags);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtFlagDiscarded:     Result := IL_CompareBool(ilifDiscarded in fFlags,ilifDiscarded in Item.Flags);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtTextTag:           If (Length(fTextTag) > 0) and (Length(Item.TextTag) > 0) then
                            Result := IL_CompareText(fTextTag,Item.TextTag)
                          else If Length(fTextTag) > 0 then
                            Result := IL_NegateValue(+1,Reversed)
                          else If Length(Item.TextTag) > 0 then
                            Result := IL_NegateValue(-1,Reversed)
                          else
                            Result := 0;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtNumTag:            If (fNumTag <> 0) and (Item.NumTag <> 0) then
                            Result := Item.NumTag - fNumTag
                          else If fNumTag <> 0 then
                            Result := IL_NegateValue(+1,Reversed)
                          else If Item.NumTag <> 0 then
                            Result := IL_NegateValue(-1,Reversed)
                          else
                            Result := 0;

  // extended specs  = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
  ilivtWantedLevel:       If (ilifWanted in fFlags) and (ilifWanted in Item.Flags) then
                            Result := IL_CompareUInt32(fWantedLevel,Item.WantedLevel)
                          else If ilifWanted in fFlags then
                            Result := IL_NegateValue(+1,Reversed)
                          else If ilifWanted in Item.Flags then
                            Result := IL_NegateValue(-1,Reversed) // those without the flag set goes at the end
                          else
                            Result := 0;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtVariant:           Result := IL_CompareText(fVariant,Item.Variant);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtMaterial:          If not(fMaterial in [ilimtUnknown,ilimtOther]) and not(Item.Material in [ilimtUnknown,ilimtOther]) then
                            Result := IL_CompareText(
                              fDataProvider.GetItemMaterialString(fMaterial),
                              fDataProvider.GetItemMaterialString(Item.Material))
                          // push others and unknowns to the end
                          else If not(fMaterial in [ilimtUnknown,ilimtOther]) then
                            Result := IL_NegateValue(+1,Reversed)
                          else If not(Item.Material in [ilimtUnknown,ilimtOther]) then
                            Result := IL_NegateValue(-1,Reversed)
                          // both are either unknown or other, push unknown to the end...
                          else If fMaterial <> Item.Material then
                            begin
                              If fMaterial = ilimtOther then
                                Result := IL_NegateValue(+1,Reversed)
                              else If Item.Material = ilimtOther then
                                Result := IL_NegateValue(-1,Reversed)
                              else
                                Result := 0;
                            end
                          else Result := 0;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtSizeX:             Result := IL_CompareUInt32(fSizeX,Item.SizeX);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtSizeY:             Result := IL_CompareUInt32(fSizeY,Item.SizeY);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtSizeZ:             Result := IL_CompareUInt32(fSizeZ,Item.SizeZ);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtTotalSize:         If (TotalSize > 0) and (Item.TotalSize > 0) then
                            Result := IL_CompareInt64(TotalSize,Item.TotalSize)
                          else If TotalSize > 0 then
                            Result := IL_NegateValue(+1,Reversed) // push items with 0 total size to the end
                          else If Item.TotalSize > 0 then
                            Result := IL_NegateValue(-1,Reversed)
                          else
                            Result := 0;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtUnitWeight:        If (fUnitWeight > 0) and (Item.UnitWeight > 0) then
                            Result := IL_CompareUInt32(fUnitWeight,Item.UnitWeight)
                          else If fUnitWeight > 0 then
                            Result := IL_NegateValue(+1,Reversed) // push items with 0 weight to the end
                          else If Item.UnitWeight > 0 then
                            Result := IL_NegateValue(-1,Reversed)
                          else
                            Result := 0;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtTotalWeight:       If (TotalWeight > 0) and (Item.TotalWeight > 0) then
                            Result := IL_CompareUInt32(TotalWeight,Item.TotalWeight)
                          else If TotalWeight > 0 then
                            Result := IL_NegateValue(+1,Reversed) // push items with 0 total weight to the end
                          else If Item.TotalWeight > 0 then
                            Result := IL_NegateValue(-1,Reversed)
                          else
                            Result := 0;
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtThickness:         If (fThickness > 0) and (Item.Thickness > 0) then
                            Result := IL_CompareUInt32(fThickness,Item.Thickness)
                          else If fThickness > 0 then
                            Result := IL_NegateValue(+1,Reversed) // push items with 0 thickness to the end
                          else If Item.Thickness > 0 then
                            Result := IL_NegateValue(-1,Reversed)
                          else
                            Result := 0;

  // others  = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
  ilivtNotes:             Result := IL_CompareText(fNotes,Item.Notes);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtReviewURL:         Result := IL_CompareText(fReviewURL,Item.ReviewURL);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtReview:            Result := IL_CompareBool(Length(fReviewURL) > 0,Length(Item.ReviewURL) > 0);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtMainPictureFile:   Result := IL_CompareText(fItemPictureFile,Item.ItemPictureFile);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtMainPicFilePres:   Result := IL_CompareBool(Length(fItemPictureFile) > 0,Length(Item.ItemPictureFile) > 0);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtPackPictureFile:   Result := IL_CompareText(fPackagePictureFile,Item.PackagePictureFile);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtPackPicFilePres:   Result := IL_CompareBool(Length(fPackagePictureFile) > 0,Length(Item.PackagePictureFile) > 0);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtUnitPriceDefault:  Result := IL_CompareUInt32(fUnitPriceDefault,Item.UnitPriceDefault);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtUnitPriceLowest:   Result := IL_CompareUInt32(fUnitPriceLowest,Item.UnitPriceLowest);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtTotalPriceLowest:  Result := IL_CompareUInt32(TotalPriceLowest,Item.TotalPriceLowest);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtUnitPriceSel:      Result := IL_CompareUInt32(fUnitPriceSelected,Item.UnitPriceSelected);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtTotalPriceSel:     Result := IL_CompareUInt32(TotalPriceSelected,Item.TotalPriceSelected);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtTotalPrice:        Result := IL_CompareUInt32(TotalPrice,Item.TotalPrice);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtAvailable:         If (fAvailableSelected < 0) and (Item.AvailableSelected < 0) then
                            Result := IL_CompareInt32(Abs(fAvailableSelected),Abs(Item.AvailableSelected))
                          else If (fAvailableSelected < 0) then
                            Result := IL_CompareInt32(Abs(fAvailableSelected) + 1,Item.AvailableSelected)
                          else If (Item.AvailableSelected < 0) then
                            Result := IL_CompareInt32(fAvailableSelected,Abs(Item.AvailableSelected) + 1)
                          else
                            Result := IL_CompareInt32(fAvailableSelected,Item.AvailableSelected);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtShopCount:         Result := IL_CompareUInt32(fShopCount,Item.ShopCount);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtUsefulShopCount:   Result := IL_CompareUInt32(ShopsUsefulCount,Item.ShopsUsefulCount);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtUsefulShopRatio:   If (fShopCount > 0) and (Item.ShopCount > 0) then
                            Result := IL_CompareFloat(ShopsUsefulRatio,Item.ShopsUsefulRatio)
                          else If fShopCount > 0 then
                            Result := IL_NegateValue(+1,Reversed) // push items with no shop to the end
                          else If Item.ShopCount > 0 then
                            Result := IL_NegateValue(-1,Reversed)
                          else
                            Result := 0;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtSelectedShop:      If ShopsSelected(SelShop1) and Item.ShopsSelected(SelShop2) then
                            Result := IL_CompareText(SelShop1.Name,SelShop2.Name)
                          else If ShopsSelected(SelShop1) then
                            Result := IL_NegateValue(+1,Reversed)
                          else If Item.ShopsSelected(SelShop2) then
                            Result := IL_NegateValue(-1,Reversed) // push items with no shop selected at the end
                          else
                            Result := 0;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ilivtWorstUpdateResult: If (fShopCount > 0) and (Item.ShopCount > 0) then
                            Result := IL_CompareInt32(Ord(ShopsWorstUpdateResult),Ord(Item.ShopsWorstUpdateResult))
                          else If fShopCount > 0 then
                            Result := IL_NegateValue(+1,Reversed) // push items with no shop to the end
                          else If Item.ShopCount > 0 then
                            Result := IL_NegateValue(-1,Reversed)
                          else
                            Result := 0;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
else
  {vtNone}
  Result := 0;
end;
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
        SetFlagStateValue(FlagsMap,BitMask,ItemFlag in fFlags);
        BitOps.SetFlagValue(FlagsMask,BitMask);
      end
    else If FlagClr in FilterSettings.Flags then
      begin
        SetFlagStateValue(FlagsMap,BitMask,not(ItemFlag in fFlags));
        BitOps.SetFlagValue(FlagsMask,BitMask);
      end
    else
      begin
        ResetFlagValue(FlagsMap,BitMask);
        ResetFlagValue(FlagsMask,BitMask);
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
