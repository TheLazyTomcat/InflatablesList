unit InflatablesList_Item_Comp;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  InflatablesList_Types,
  InflatablesList_Item_Draw;

type
  TILItem_Comp = class(TILItem_Draw)
  public
    Function Contains(const Text: String; Value: TILItemSearchResult): Boolean; overload; virtual;
    Function Contains(const Text: String): Boolean; overload; virtual;
    Function Compare(WithItem: TILItem_Comp; WithValue: TILItemValueTag; Reversed: Boolean; CaseSensitive: Boolean): Integer; virtual;
    procedure Filter(FilterSettings: TILFilterSettings); virtual;
  end;

implementation

uses
  SysUtils,
  AuxTypes, BitOps,
  InflatablesList_Utils,
  InflatablesList_ItemShop;

Function TILItem_Comp.Contains(const Text: String; Value: TILItemSearchResult): Boolean;
var
  SelShop:  TILItemShop;
  i:        Integer;

  Function CheckInPicture(Index: Integer; const Text: String): Boolean;
  begin
    If fPictures.CheckIndex(Index) then
      Result := IL_ContainsText(fPictures[Index].PictureFile,Text)
    else
      Result := False;
  end;

begin
// search only in editable values
If fDataAccessible then
  case Value of
    ilisrItemPicFile:           Result := CheckInPicture(fPictures.IndexOfItemPicture,Text);
    ilisrSecondaryPicFile:      begin
                                  Result := False;
                                  For i := fPictures.LowIndex to fPictures.HighIndex do
                                    If not fPictures[i].ItemPicture and not fPictures[i].PackagePicture then
                                      If CheckInPicture(i,Text) then
                                        begin
                                          Result := True;
                                          Break{For i};
                                        end;
                                end;
    ilisrPackagePicFile:        Result := CheckInPicture(fPictures.IndexOfPackagePicture,Text);
    ilisrType:                  Result := IL_ContainsText(fDataProvider.GetItemTypeString(fItemType),Text);
    ilisrTypeSpec:              Result := IL_ContainsText(fItemTypeSpec,Text);
    ilisrPieces:                Result := IL_ContainsText(IL_Format('%dpcs',[fPieces]),Text);
    ilisrUserID:                Result := IL_ContainsText(fUserID,Text);
    ilisrManufacturer:          Result := IL_ContainsText(fDataProvider.ItemManufacturers[fManufacturer].Str,Text);
    ilisrManufacturerStr:       Result := IL_ContainsText(fManufacturerStr,Text);
    ilisrTextID:                Result := IL_ContainsText(fTextID,Text);
    ilisrNumID:                 Result := IL_ContainsText(IntToStr(fNumID),Text);
    ilisrFlagOwned:             Result := (ilifOwned in fFlags) and IL_ContainsText(fDataProvider.GetItemFlagString(ilifOwned),Text);
    ilisrFlagWanted:            Result := (ilifWanted in fFlags) and IL_ContainsText(fDataProvider.GetItemFlagString(ilifWanted),Text);
    ilisrFlagOrdered:           Result := (ilifOrdered in fFlags) and IL_ContainsText(fDataProvider.GetItemFlagString(ilifOrdered),Text);
    ilisrFlagBoxed:             Result := (ilifBoxed in fFlags) and IL_ContainsText(fDataProvider.GetItemFlagString(ilifBoxed),Text);
    ilisrFlagElsewhere:         Result := (ilifElsewhere in fFlags) and IL_ContainsText(fDataProvider.GetItemFlagString(ilifElsewhere),Text);
    ilisrFlagUntested:          Result := (ilifUntested in fFlags) and IL_ContainsText(fDataProvider.GetItemFlagString(ilifUntested),Text);
    ilisrFlagTesting:           Result := (ilifTesting in fFlags) and IL_ContainsText(fDataProvider.GetItemFlagString(ilifTesting),Text);
    ilisrFlagTested:            Result := (ilifTested in fFlags) and IL_ContainsText(fDataProvider.GetItemFlagString(ilifTested),Text);
    ilisrFlagDamaged:           Result := (ilifDamaged in fFlags) and IL_ContainsText(fDataProvider.GetItemFlagString(ilifDamaged),Text);
    ilisrFlagRepaired:          Result := (ilifRepaired in fFlags) and IL_ContainsText(fDataProvider.GetItemFlagString(ilifRepaired),Text);
    ilisrFlagPriceChange:       Result := (ilifPriceChange in fFlags) and IL_ContainsText(fDataProvider.GetItemFlagString(ilifPriceChange),Text);
    ilisrFlagAvailChange:       Result := (ilifAvailChange in fFlags) and IL_ContainsText(fDataProvider.GetItemFlagString(ilifAvailChange),Text);
    ilisrFlagNotAvailable:      Result := (ilifNotAvailable in fFlags) and IL_ContainsText(fDataProvider.GetItemFlagString(ilifNotAvailable),Text);
    ilisrFlagLost:              Result := (ilifLost in fFlags) and IL_ContainsText(fDataProvider.GetItemFlagString(ilifLost),Text);
    ilisrFlagDiscarded:         Result := (ilifDiscarded in fFlags) and IL_ContainsText(fDataProvider.GetItemFlagString(ilifDiscarded),Text);
    ilisrTextTag:               Result := IL_ContainsText(fTextTag,Text);
    ilisrNumTag:                Result := IL_ContainsText(IntToStr(fNumTag),Text);
    ilisrWantedLevel:           Result := IL_ContainsText(IntToStr(fWantedLevel),Text);
    ilisrVariant:               Result := IL_ContainsText(fVariant,Text);
    ilisrVariantTag:            Result := IL_ContainsText(fVariantTag,Text);
    ilisrUnitWeight:            Result := IL_ContainsText(IL_Format('%dg',[fUnitWeight]),Text);
    ilisrMaterial:              Result := IL_ContainsText(fDataProvider.GetItemMaterialString(fMaterial),Text);
    ilisrSurface:               Result := IL_ContainsText(fDataProvider.GetItemSurfaceString(fSurface),Text);
    ilisrThickness:             Result := IL_ContainsText(IL_Format('%dum',[fThickness]),Text);
    ilisrSizeX:                 Result := IL_ContainsText(IL_Format('%dmm',[fSizeX]),Text);
    ilisrSizeY:                 Result := IL_ContainsText(IL_Format('%dmm',[fSizeY]),Text);
    ilisrSizeZ:                 Result := IL_ContainsText(IL_Format('%dmm',[fSizeZ]),Text);
    ilisrNotes:                 Result := IL_ContainsText(fNotes,Text);
    ilisrReviewURL:             Result := IL_ContainsText(fReviewURL,Text);
    ilisrUnitPriceDefault:      Result := IL_ContainsText(IL_Format('%dK',[fUnitPriceDefault]),Text);
    ilisrRating:                Result := IL_ContainsText(IL_Format('%d%%',[fRating]),Text);
    ilisrRatingDetails:         Result := IL_ContainsText(fRatingDetails,Text);
    ilisrSelectedShop:          If ShopsSelected(SelShop) then
                                  Result := IL_ContainsText(SelShop.Name,Text)
                                else
                                  Result := False;
  else
    Result := False;
  end
else Result := False;
end;

//------------------------------------------------------------------------------

Function TILItem_Comp.Contains(const Text: String): Boolean;
begin
If fDataAccessible then
  // search only in editable values
  Result :=
    Contains(Text,ilisrItemPicFile) or
    Contains(Text,ilisrSecondaryPicFile) or
    Contains(Text,ilisrPackagePicFile) or
    Contains(Text,ilisrType) or
    Contains(Text,ilisrTypeSpec) or
    Contains(Text,ilisrPieces) or
    Contains(Text,ilisrUserID) or
    Contains(Text,ilisrManufacturer) or
    Contains(Text,ilisrManufacturerStr) or
    Contains(Text,ilisrTextID) or
    Contains(Text,ilisrNumID) or
    Contains(Text,ilisrFlagOwned) or
    Contains(Text,ilisrFlagWanted) or
    Contains(Text,ilisrFlagOrdered) or
    Contains(Text,ilisrFlagBoxed) or
    Contains(Text,ilisrFlagElsewhere) or
    Contains(Text,ilisrFlagUntested) or
    Contains(Text,ilisrFlagTesting) or
    Contains(Text,ilisrFlagTested) or
    Contains(Text,ilisrFlagDamaged) or
    Contains(Text,ilisrFlagRepaired) or
    Contains(Text,ilisrFlagPriceChange) or
    Contains(Text,ilisrFlagAvailChange) or
    Contains(Text,ilisrFlagNotAvailable) or
    Contains(Text,ilisrFlagLost) or
    Contains(Text,ilisrFlagDiscarded) or
    Contains(Text,ilisrTextTag) or
    Contains(Text,ilisrNumTag) or
    Contains(Text,ilisrWantedLevel) or
    Contains(Text,ilisrVariant) or
    Contains(Text,ilisrVariantTag) or
    Contains(Text,ilisrUnitWeight) or
    Contains(Text,ilisrMaterial) or
    Contains(Text,ilisrSurface) or
    Contains(Text,ilisrThickness) or    
    Contains(Text,ilisrSizeX) or
    Contains(Text,ilisrSizeY) or
    Contains(Text,ilisrSizeZ) or
    Contains(Text,ilisrNotes) or
    Contains(Text,ilisrReviewURL) or
    Contains(Text,ilisrUnitPriceDefault) or
    Contains(Text,ilisrRating) or
    Contains(Text,ilisrRatingDetails) or
    Contains(Text,ilisrSelectedShop)
else
  Result := False;
end;

//------------------------------------------------------------------------------

Function TILItem_Comp.Compare(WithItem: TILItem_Comp; WithValue: TILItemValueTag; Reversed: Boolean; CaseSensitive: Boolean): Integer;
var
  SelShop1: TILItemShop;
  SelShop2: TILItemShop;
  I1,I2:    Integer;

  Function CompareText_Internal(const A,B: String): Integer;
  begin
    If CaseSensitive then
      Result := IL_SortCompareStr(A,B)
    else
      Result := IL_SortCompareText(A,B)
  end;

begin
If (fDataAccessible and WithItem.DataAccessible) or (WithValue = ilivtItemEncrypted) then
  case WithValue of
    // internals = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
    ilivtItemEncrypted:     Result := IL_SortCompareBool(fEncrypted,WithItem.Encrypted);
    ilivtUniqueID:          Result := IL_SortCompareGUID(fUniqueID,WithItem.UniqueID);
    ilivtTimeOfAdd:         Result := IL_SortCompareDateTime(fTimeOfAddition,WithItem.TimeOfAddition);
    ilivtDescriptor:        Result := CompareText_Internal(Descriptor,WithItem.Descriptor);

    // pictures  = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
    ilivtMainPicFilePres:   Result := IL_SortCompareBool(fPictures.CheckIndex(fPictures.IndexOfItemPicture),
                              WithItem.Pictures.CheckIndex(WithItem.Pictures.IndexOfItemPicture));
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -                              
    ilivtPackPicFilePres:   Result := IL_SortCompareBool(fPictures.CheckIndex(fPictures.IndexOfPackagePicture),
                              WithItem.Pictures.CheckIndex(WithItem.Pictures.IndexOfPackagePicture));
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ilivtCurrSecPicPres:    Result := IL_SortCompareBool(fPictures.CheckIndex(fPictures.CurrentSecondary),
                              WithItem.Pictures.CheckIndex(WithItem.Pictures.CurrentSecondary));
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ilivtMainPictureFile,
    ilivtPackPictureFile,
    ilivtCurrSecPicFile:    begin
                              case WithValue of
                                ilivtMainPictureFile: begin
                                                        I1 := fPictures.IndexOfItemPicture;
                                                        I2 := WithItem.Pictures.IndexOfItemPicture;
                                                      end;
                                ilivtPackPictureFile: begin
                                                        I1 := fPictures.IndexOfPackagePicture;
                                                        I2 := WithItem.Pictures.IndexOfPackagePicture;
                                                      end;
                              else
                               {ilivtCurrSecPicFile}
                                I1 := fPictures.CurrentSecondary;
                                I2 := WithItem.Pictures.CurrentSecondary;
                              end;
                              If fPictures.CheckIndex(I1) and WithItem.Pictures.CheckIndex(I2) then
                                Result := CompareText_Internal(fPictures[I1].PictureFile,WithItem.Pictures[I2].PictureFile)
                              else If fPictures.CheckIndex(I1) and not WithItem.Pictures.CheckIndex(I2) then
                                Result := IL_NegateValue(+1,Reversed)
                              else If not fPictures.CheckIndex(I1) and WithItem.Pictures.CheckIndex(I2) then
                                Result := IL_NegateValue(-1,Reversed)
                              else
                                Result := 0;
                            end;
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ilivtMainPictureThumb,
    ilivtPackPictureThumb,
    ilivtCurrSecPicThumb:   begin
                              case WithValue of
                                ilivtMainPictureThumb:  begin
                                                          I1 := fPictures.IndexOfItemPicture;
                                                          I2 := WithItem.Pictures.IndexOfItemPicture;
                                                        end;
                                ilivtPackPictureThumb:  begin
                                                          I1 := fPictures.IndexOfPackagePicture;
                                                          I2 := WithItem.Pictures.IndexOfPackagePicture;
                                                        end;
                              else
                               {ilivtCurrSecPicThumb}
                                I1 := fPictures.CurrentSecondary;
                                I2 := WithItem.Pictures.CurrentSecondary;
                              end;
                              If fPictures.CheckIndex(I1) and WithItem.Pictures.CheckIndex(I2) then
                                Result := IL_SortCompareBool(Assigned(fPictures[I1].Thumbnail),Assigned(WithItem.Pictures[I2].Thumbnail))
                              else If fPictures.CheckIndex(I1) and not WithItem.Pictures.CheckIndex(I2) then
                                Result := IL_NegateValue(+1,Reversed)
                              else If not fPictures.CheckIndex(I1) and WithItem.Pictures.CheckIndex(I2) then
                                Result := IL_NegateValue(-1,Reversed)
                              else
                                Result := 0;    
                            end;
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ilivtPictureCount:      Result := IL_SortCompareInt32(fPictures.Count,WithItem.Pictures.Count);
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ilivtSecPicCount:       Result := IL_SortCompareInt32(fPictures.SecondaryCount(False),WithItem.Pictures.SecondaryCount(False));
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ilivtSecPicThumbCount:  Result := IL_SortCompareInt32(fPictures.SecondaryCount(True),WithItem.Pictures.SecondaryCount(True));

    // basic specs = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
    ilivtItemType:          If fItemType <> WithItem.ItemType then
                              begin
                                If not(fItemType in [ilitUnknown,ilitOther]) and not(WithItem.ItemType in [ilitUnknown,ilitOther]) then
                                  Result := CompareText_Internal(
                                    fDataProvider.GetItemTypeString(fItemType),
                                    fDataProvider.GetItemTypeString(WithItem.ItemType))
                                // push others and unknowns to the end
                                else If not(fItemType in [ilitUnknown,ilitOther]) and (WithItem.ItemType in [ilitUnknown,ilitOther]) then
                                  Result := IL_NegateValue(+1,Reversed)
                                else If (fItemType in [ilitUnknown,ilitOther]) and not(WithItem.ItemType in [ilitUnknown,ilitOther]) then
                                  Result := IL_NegateValue(-1,Reversed)
                                // both are either unknown or other, but differs, push unknown to the end...
                                else
                                  begin
                                    If fItemType = ilitOther then
                                      Result := IL_NegateValue(+1,Reversed)
                                    else If WithItem.ItemType = ilitOther then
                                      Result := IL_NegateValue(-1,Reversed)
                                    else
                                      Result := 0;
                                  end;
                              end
                            else Result := 0;
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ilivtItemTypeSpec:      Result := CompareText_Internal(fItemTypeSpec,WithItem.ItemTypeSpec);
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ilivtPieces:            Result := IL_SortCompareUInt32(fPieces,WithItem.Pieces);
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ilivtUserID:            If (Length(fUserID) > 0) and (Length(WithItem.UserID) > 0) then
                              Result := CompareText_Internal(fUserID,WithItem.UserID)
                            else If (Length(fUserID) > 0) and (Length(WithItem.UserID) <= 0) then
                              Result := IL_NegateValue(+1,Reversed)
                            else If (Length(fUserID) <= 0) and (Length(WithItem.UserID) > 0) then
                              Result := IL_NegateValue(-1,Reversed)
                            else
                              Result := 0;
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ilivtManufacturer:      If fManufacturer <> WithItem.Manufacturer then
                              begin
                                If not(fManufacturer in [ilimUnknown,ilimOthers]) and not(WithItem.Manufacturer in [ilimUnknown,ilimOthers]) then
                                  Result := CompareText_Internal(
                                    fDataProvider.ItemManufacturers[fManufacturer].Str,
                                    fDataProvider.ItemManufacturers[WithItem.Manufacturer].Str)
                                // push others and unknowns to the end
                                else If not(fManufacturer in [ilimUnknown,ilimOthers]) and (WithItem.Manufacturer in [ilimUnknown,ilimOthers]) then
                                  Result := IL_NegateValue(+1,Reversed)
                                else If (fManufacturer in [ilimUnknown,ilimOthers]) and not(WithItem.Manufacturer in [ilimUnknown,ilimOthers]) then
                                  Result := IL_NegateValue(-1,Reversed)
                                // both are either unknown or other, but differs, push unknown to the end...
                                else
                                  begin
                                    If fManufacturer = ilimOthers then
                                      Result := IL_NegateValue(+1,Reversed)
                                    else If WithItem.Manufacturer = ilimOthers then
                                      Result := IL_NegateValue(-1,Reversed)
                                    else
                                      Result := 0;  // this should not happen
                                  end;
                              end
                            else Result := 0;
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ilivtManufacturerStr:   Result := CompareText_Internal(fManufacturerStr,WithItem.ManufacturerStr);
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ilivtTextID:            Result := CompareText_Internal(fTextID,WithItem.TextID);
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ilivtNumID:             Result := IL_SortCompareInt32(fNumID,WithItem.NumID);
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ilivtIDStr:             Result := CompareText_Internal(IDStr,WithItem.IDStr);
  
    // flags = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
    ilivtFlagOwned:         Result := IL_SortCompareBool(ilifOwned in fFlags,ilifOwned in WithItem.Flags);
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ilivtFlagWanted:        Result := IL_SortCompareBool(ilifWanted in fFlags,ilifWanted in WithItem.Flags);
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ilivtFlagOrdered:       Result := IL_SortCompareBool(ilifOrdered in fFlags,ilifOrdered in WithItem.Flags);
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ilivtFlagBoxed:         Result := IL_SortCompareBool(ilifBoxed in fFlags,ilifBoxed in WithItem.Flags);
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ilivtFlagElsewhere:     Result := IL_SortCompareBool(ilifElsewhere in fFlags,ilifElsewhere in WithItem.Flags);
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ilivtFlagUntested:      Result := IL_SortCompareBool(ilifUntested in fFlags,ilifUntested in WithItem.Flags);
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ilivtFlagTesting:       Result := IL_SortCompareBool(ilifTesting in fFlags,ilifTesting in WithItem.Flags);
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ilivtFlagTested:        Result := IL_SortCompareBool(ilifTested in fFlags,ilifTested in WithItem.Flags);
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ilivtFlagDamaged:       Result := IL_SortCompareBool(ilifDamaged in fFlags,ilifDamaged in WithItem.Flags);
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ilivtFlagRepaired:      Result := IL_SortCompareBool(ilifRepaired in fFlags,ilifRepaired in WithItem.Flags);
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ilivtFlagPriceChange:   Result := IL_SortCompareBool(ilifPriceChange in fFlags,ilifPriceChange in WithItem.Flags);
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ilivtFlagAvailChange:   Result := IL_SortCompareBool(ilifAvailChange in fFlags,ilifAvailChange in WithItem.Flags);
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ilivtFlagNotAvailable:  Result := IL_SortCompareBool(ilifNotAvailable in fFlags,ilifNotAvailable in WithItem.Flags);
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ilivtFlagLost:          Result := IL_SortCompareBool(ilifLost in fFlags,ilifLost in WithItem.Flags);
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ilivtFlagDiscarded:     Result := IL_SortCompareBool(ilifDiscarded in fFlags,ilifDiscarded in WithItem.Flags);
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ilivtTextTag:           If (Length(fTextTag) > 0) and (Length(WithItem.TextTag) > 0) then
                              Result := CompareText_Internal(fTextTag,WithItem.TextTag)
                            else If (Length(fTextTag) > 0) and (Length(WithItem.TextTag) <= 0) then
                              Result := IL_NegateValue(+1,Reversed)
                            else If (Length(fTextTag) <= 0) and (Length(WithItem.TextTag) > 0) then
                              Result := IL_NegateValue(-1,Reversed)
                            else
                              Result := 0;
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ilivtNumTag:            If (fNumTag <> 0) and (WithItem.NumTag <> 0) then
                              Result := IL_SortCompareInt32(fNumTag,WithItem.NumTag)
                            else If (fNumTag <> 0) and (WithItem.NumTag = 0) then
                              Result := IL_NegateValue(+1,Reversed)
                            else If (fNumTag = 0) and (WithItem.NumTag <> 0) then
                              Result := IL_NegateValue(-1,Reversed)
                            else
                              Result := 0;
  
    // extended specs  = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
    ilivtWantedLevel:       If (ilifWanted in fFlags) and (ilifWanted in WithItem.Flags) then
                              Result := IL_SortCompareUInt32(fWantedLevel,WithItem.WantedLevel)
                            else If not(ilifWanted in fFlags) and (ilifWanted in WithItem.Flags) then
                              Result := IL_NegateValue(-1,Reversed) // those without the flag set goes at the end
                            else If (ilifWanted in fFlags) and not(ilifWanted in WithItem.Flags) then
                              Result := IL_NegateValue(+1,Reversed)
                            else
                              Result := 0;
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ilivtVariant:           Result := CompareText_Internal(fVariant,WithItem.Variant);
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ilivtVariantTag:        If (Length(fVariantTag) > 0) and (Length(WithItem.VariantTag) > 0) then
                              Result := CompareText_Internal(fVariantTag,WithItem.VariantTag)
                            else If (Length(fVariantTag) > 0) and (Length(WithItem.VariantTag) <= 0) then
                              Result := IL_NegateValue(+1,Reversed)
                            else If (Length(fVariantTag) <= 0) and (Length(WithItem.VariantTag) > 0) then
                              Result := IL_NegateValue(-1,Reversed)
                            else
                              Result := 0;
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ilivtUnitWeight:        If (fUnitWeight > 0) and (WithItem.UnitWeight > 0) then
                              Result := IL_SortCompareUInt32(fUnitWeight,WithItem.UnitWeight)
                            else If (fUnitWeight > 0) and (WithItem.UnitWeight <= 0) then
                              Result := IL_NegateValue(+1,Reversed) // push items with 0 weight to the end
                            else If (fUnitWeight <= 0) and (WithItem.UnitWeight > 0) then
                              Result := IL_NegateValue(-1,Reversed)
                            else
                              Result := 0;
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ilivtTotalWeight:       If (TotalWeight > 0) and (WithItem.TotalWeight > 0) then
                              Result := IL_SortCompareUInt32(TotalWeight,WithItem.TotalWeight)
                            else If (TotalWeight > 0) and (WithItem.TotalWeight <= 0) then
                              Result := IL_NegateValue(+1,Reversed) // push items with 0 total weight to the end
                            else If (TotalWeight <= 0) and (WithItem.TotalWeight > 0) then
                              Result := IL_NegateValue(-1,Reversed)
                            else
                              Result := 0;
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ilivtMaterial:          If fMaterial <> WithItem.Material then
                              begin
                                If not(fMaterial in [ilimtUnknown,ilimtOther]) and not(WithItem.Material in [ilimtUnknown,ilimtOther]) then
                                  Result := CompareText_Internal(
                                    fDataProvider.GetItemMaterialString(fMaterial),
                                    fDataProvider.GetItemMaterialString(WithItem.Material))
                                // push others and unknowns to the end
                                else If not(fMaterial in [ilimtUnknown,ilimtOther]) and (WithItem.Material in [ilimtUnknown,ilimtOther]) then
                                  Result := IL_NegateValue(+1,Reversed)
                                else If (fMaterial in [ilimtUnknown,ilimtOther]) and not(WithItem.Material in [ilimtUnknown,ilimtOther]) then
                                  Result := IL_NegateValue(-1,Reversed)
                                // both are either unknown or other, but differs, push unknown to the end...
                                else
                                  begin
                                    If fMaterial = ilimtOther then
                                      Result := IL_NegateValue(+1,Reversed)
                                    else If WithItem.Material = ilimtOther then
                                      Result := IL_NegateValue(-1,Reversed)
                                    else
                                      Result := 0;  // this should not happen
                                  end;
                              end
                            else Result := 0;
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ilivtSurface:           If (fSurface <> ilisfUnknown) and (WithItem.Surface <> ilisfUnknown) then
                              Result := CompareText_Internal(
                                fDataProvider.GetItemSurfaceString(fSurface),
                                fDataProvider.GetItemSurfaceString(WithItem.Surface))
                            else If (fSurface <> ilisfUnknown) and (WithItem.Surface = ilisfUnknown) then
                              Result := IL_NegateValue(+1,Reversed) // push items with unknown surface to the end
                            else If (fSurface = ilisfUnknown) and (WithItem.Surface <>ilisfUnknown) then
                              Result := IL_NegateValue(-1,Reversed)
                            else
                              Result := 0;
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ilivtThickness:         If (fThickness > 0) and (WithItem.Thickness > 0) then
                              Result := IL_SortCompareUInt32(fThickness,WithItem.Thickness)
                            else If (fThickness > 0) and (WithItem.Thickness <= 0) then
                              Result := IL_NegateValue(+1,Reversed) // push items with 0 thickness to the end
                            else If (fThickness <= 0) and (WithItem.Thickness > 0) then
                              Result := IL_NegateValue(-1,Reversed)
                            else
                              Result := 0;                            
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ilivtSizeX:             Result := IL_SortCompareUInt32(fSizeX,WithItem.SizeX);
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ilivtSizeY:             Result := IL_SortCompareUInt32(fSizeY,WithItem.SizeY);
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ilivtSizeZ:             Result := IL_SortCompareUInt32(fSizeZ,WithItem.SizeZ);
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ilivtTotalSize:         If (TotalSize > 0) and (WithItem.TotalSize > 0) then
                              Result := IL_SortCompareInt64(TotalSize,WithItem.TotalSize)
                            else If (TotalSize > 0) and (WithItem.TotalSize <= 0) then
                              Result := IL_NegateValue(+1,Reversed) // push items with 0 total size to the end
                            else If (TotalSize <= 0) and (WithItem.TotalSize > 0) then
                              Result := IL_NegateValue(-1,Reversed)
                            else
                              Result := 0;

    // others  = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
    ilivtNotes:             Result := CompareText_Internal(fNotes,WithItem.Notes);
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ilivtReviewURL:         Result := CompareText_Internal(fReviewURL,WithItem.ReviewURL);
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ilivtReview:            Result := IL_SortCompareBool(Length(fReviewURL) > 0,Length(WithItem.ReviewURL) > 0);
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ilivtUnitPriceDefault:  Result := IL_SortCompareUInt32(fUnitPriceDefault,WithItem.UnitPriceDefault);
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ilivtRating:            If ((ilifOwned in fFlags) and not(ilifWanted in fFlags)) and
                               ((ilifOwned in WithItem.Flags) and not(ilifWanted in WithItem.Flags)) then
                              Result := IL_SortCompareUInt32(fRating,WithItem.Rating)
                            // those without proper flag combination goes at the end
                            else If ((ilifOwned in fFlags) and not(ilifWanted in fFlags)) and
                                   not((ilifOwned in WithItem.Flags) and not(ilifWanted in WithItem.Flags)) then
                              Result := IL_NegateValue(+1,Reversed)
                            else If not((ilifOwned in fFlags) and not(ilifWanted in fFlags)) and
                                   ((ilifOwned in WithItem.Flags) and not(ilifWanted in WithItem.Flags)) then
                              Result := IL_NegateValue(-1,Reversed)
                            else
                              Result := 0;
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ilivtRatingDetails:     Result := CompareText_Internal(fRatingDetails,WithItem.RatingDetails);
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ilivtSomethingUnknown:  If (ilifOwned in fFlags) and (ilifOwned in WithItem.Flags) then
                              Result := IL_SortCompareBool(SomethingIsUnknown,WithItem.SomethingIsUnknown)
                            else If not(ilifOwned in fFlags) and (ilifOwned in WithItem.Flags) then
                              Result := IL_NegateValue(-1,Reversed) // those without the flag set goes at the end
                            else If (ilifOwned in fFlags) and not(ilifOwned in WithItem.Flags) then
                              Result := IL_NegateValue(+1,Reversed)
                            else
                              Result := 0;
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ilivtUnitPriceLowest:   Result := IL_SortCompareUInt32(fUnitPriceLowest,WithItem.UnitPriceLowest);
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ilivtTotalPriceLowest:  Result := IL_SortCompareUInt32(TotalPriceLowest,WithItem.TotalPriceLowest);
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ilivtUnitPriceSel:      Result := IL_SortCompareUInt32(fUnitPriceSelected,WithItem.UnitPriceSelected);
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ilivtTotalPriceSel:     Result := IL_SortCompareUInt32(TotalPriceSelected,WithItem.TotalPriceSelected);
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ilivtTotalPrice:        Result := IL_SortCompareUInt32(TotalPrice,WithItem.TotalPrice);
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ilivtAvailable:         If (fAvailableSelected < 0) and (WithItem.AvailableSelected < 0) then
                              Result := IL_SortCompareInt32(Abs(fAvailableSelected),Abs(WithItem.AvailableSelected))
                            else If (fAvailableSelected < 0) and (WithItem.AvailableSelected >= 0) then
                              begin
                                If Abs(fAvailableSelected) = WithItem.AvailableSelected then
                                  Result := IL_NegateValue(-1,Reversed)
                                else
                                  Result := IL_SortCompareInt32(Abs(fAvailableSelected),WithItem.AvailableSelected)
                              end
                            else If (fAvailableSelected >= 0) and (WithItem.AvailableSelected < 0) then
                              begin
                                If fAvailableSelected = Abs(WithItem.AvailableSelected) then
                                  Result := IL_NegateValue(+1,Reversed)
                                else
                                  Result := IL_SortCompareInt32(fAvailableSelected,Abs(WithItem.AvailableSelected))
                              end
                            else Result := IL_SortCompareInt32(fAvailableSelected,WithItem.AvailableSelected);
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ilivtShopCount:         Result := IL_SortCompareUInt32(fShopCount,WithItem.ShopCount);
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ilivtUsefulShopCount:   Result := IL_SortCompareUInt32(ShopsUsefulCount,WithItem.ShopsUsefulCount);
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ilivtUsefulShopRatio:   If (fShopCount > 0) and (WithItem.ShopCount > 0) then
                              Result := IL_SortCompareFloat(ShopsUsefulRatio,WithItem.ShopsUsefulRatio)
                            else If (fShopCount > 0) and (WithItem.ShopCount <= 0) then
                              Result := IL_NegateValue(+1,Reversed) // push items with no shop to the end
                            else If (fShopCount <= 0) and (WithItem.ShopCount > 0) then
                              Result := IL_NegateValue(-1,Reversed)
                            else
                              Result := 0;
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ilivtSelectedShop:      If ShopsSelected(SelShop1) and WithItem.ShopsSelected(SelShop2) then
                              Result := CompareText_Internal(SelShop1.Name,SelShop2.Name)
                            else If ShopsSelected(SelShop1) and not WithItem.ShopsSelected(SelShop2) then
                              Result := IL_NegateValue(+1,Reversed)
                            else If not ShopsSelected(SelShop1) and WithItem.ShopsSelected(SelShop2) then
                              Result := IL_NegateValue(-1,Reversed) // push items with no shop selected at the end
                            else
                              Result := 0;
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ilivtWorstUpdateResult: If (fShopCount > 0) and (WithItem.ShopCount > 0) then
                              Result := IL_SortCompareInt32(Ord(ShopsWorstUpdateResult),Ord(WithItem.ShopsWorstUpdateResult))
                            else If (fShopCount > 0) and (WithItem.ShopCount <= 0) then
                              Result := IL_NegateValue(+1,Reversed) // push items with no shop to the end
                            else If (fShopCount <= 0) and (WithItem.ShopCount > 0) then
                              Result := IL_NegateValue(-1,Reversed)
                            else
                              Result := 0;
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  else
    {vtNone}
    Result := 0;
  end
else
  begin
    // push items that have inaccessible data to the end
    If fDataAccessible and not WithItem.DataAccessible then
      Result := IL_NegateValue(+1,Reversed)
    else If not fDataAccessible and WithItem.DataAccessible then
      Result := IL_NegateValue(-1,Reversed)
    else
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
If fDataAccessible then
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
  end
else fFilteredOut := False;
end;

end.
