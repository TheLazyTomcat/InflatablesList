unit InflatablesList_Manager_Sort;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  InflatablesList_Types, InflatablesList_Manager_IO;

type
  TILManager_Sort = class(TILManager_IO)
  protected
    fReversedSort:          Boolean;
    fUsedSortSett:          TILSortingSettings;
    fDefaultSortSett:       TILSortingSettings;
    fActualSortSett:        TILSortingSettings;
    fSortingProfiles:       TILSortingProfiles;
    Function GetSortProfileCount: Integer;
    Function GetSortProfile(Index: Integer): TILSortingProfile;
    Function GetSortProfilePtr(Index: Integer): PILSortingProfile;
    procedure InitializeSortingSettings; virtual;
    procedure FinalizeSortingSettings; virtual;
    procedure Initialize; override;
    procedure Finalize; override;
    Function ItemCompare(Idx1,Idx2: Integer): Integer; virtual;
  public
    Function SortingProfileAdd(const Name: String): Integer; virtual;
    procedure SortingProfileRename(Index: Integer; const NewName: String); virtual;
    procedure SortingProfileExchange(Idx1,Idx2: Integer); virtual;
    procedure SortingProfileDelete(Index: Integer); virtual;
    procedure ItemSort(SortingProfile: Integer); overload; virtual;
    procedure ItemSort; overload; virtual;
    property ReversedSort: Boolean read fReversedSort write fReversedSort;
    property DefaultSortingSettings: TILSortingSettings read fDefaultSortSett write fDefaultSortSett;
    property ActualSortingSettings: TILSortingSettings read fActualSortSett write fActualSortSett;
    property SortingProfileCount: Integer read GetSortProfileCount;
    property SortingProfiles[Index: Integer]: TILSortingProfile read GetSortProfile;
    property SortingProfilePtrs[Index: Integer]: PILSortingProfile read GetSortProfilePtr;
  end;

implementation

uses
  SysUtils,
  ListSorters,
  InflatablesList_Utils;

Function TILManager_Sort.GetSortProfileCount: Integer;
begin
Result := Length(fSortingProfiles);
end;

//------------------------------------------------------------------------------

Function TILManager_Sort.GetSortProfile(Index: Integer): TILSortingProfile;
begin
If (Index >= Low(fSortingProfiles)) and (Index <= High(fSortingProfiles)) then
  Result := fSortingProfiles[Index]
else
  raise Exception.CreateFmt('TILManager_Sort.GetSortProfile: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

Function TILManager_Sort.GetSortProfilePtr(Index: Integer): PILSortingProfile;
begin
If (Index >= Low(fSortingProfiles)) and (Index <= High(fSortingProfiles)) then
  Result := Addr(fSortingProfiles[Index])
else
  raise Exception.CreateFmt('TILManager_Sort.GetSortProfilePtr: Index (%d) out of bounds.',[Index]);
end;

//==============================================================================

procedure TILManager_Sort.InitializeSortingSettings;
begin
fSorting := False;
FillChar(fDefaultSortSett,SizeOf(fDefaultSortSett),0);
fDefaultSortSett.Count := 2;
fDefaultSortSett.Items[0].ItemValueTag := ilivtManufacturer;
fDefaultSortSett.Items[0].Reversed := False;
fDefaultSortSett.Items[1].ItemValueTag := ilivtID;
fDefaultSortSett.Items[1].Reversed := False;
fActualSortSett := fDefaultSortSett;
fUsedSortSett := fDefaultSortSett;
SetLength(fSortingProfiles,0);
end;

//------------------------------------------------------------------------------

procedure TILManager_Sort.FinalizeSortingSettings;
begin
SetLength(fSortingProfiles,0);
end;

//------------------------------------------------------------------------------

procedure TILManager_Sort.Initialize;
begin
inherited Initialize;
InitializeSortingSettings;
end;

//------------------------------------------------------------------------------

procedure TILManager_Sort.Finalize;
begin
FinalizeSortingSettings;
inherited Finalize;
end;

//------------------------------------------------------------------------------

Function TILManager_Sort.ItemCompare(Idx1,Idx2: Integer): Integer;
var
  i:  Integer;

  Function CompareValues(ItemValueTag: TILItemValueTag; Reversed: Boolean): Integer;
  var
    SelShop1: TILItemShop;
    SelShop2: TILItemShop;
  begin
    case ItemValueTag of
// internals = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
      ilivtTimeOfAdd:         Result := IL_CompareDateTime(fList[Idx1].TimeOfAddition,fList[Idx2].TimeOfAddition);
// basic specs = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
      ilivtMainPicture:       Result := IL_CompareBool(Assigned(fList[Idx1].MainPicture),Assigned(fList[Idx2].MainPicture));
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      ilivtPackagePicture:    Result := IL_CompareBool(Assigned(fList[Idx1].PackagePicture),Assigned(fList[Idx2].PackagePicture));
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      ilivtItemType:          Result := IL_CompareText(
                                fDataProvider.GetItemTypeString(fList[Idx1].ItemType),
                                fDataProvider.GetItemTypeString(fList[Idx2].ItemType));
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      ilivtItemTypeSpec:      Result := IL_CompareText(fList[Idx1].ItemTypeSpec,fList[Idx2].ItemTypeSpec);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      ilivtCount:             Result := IL_CompareUInt32(fList[Idx1].Count,fList[Idx2].Count);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      ilivtManufacturer:      Result := IL_CompareText(
                                fDataProvider.ItemManufacturers[fList[Idx1].Manufacturer].Str,
                                fDataProvider.ItemManufacturers[fList[Idx2].Manufacturer].Str,);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      ilivtManufacturerStr:   Result := IL_CompareText(fList[Idx1].ManufacturerStr,fList[Idx2].ManufacturerStr);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      ilivtID:                Result := IL_CompareInt32(fList[Idx1].ID,fList[Idx2].ID);
// flags = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
      ilivtFlagOwned:         Result := IL_CompareBool(ilifOwned in fList[Idx1].Flags,ilifOwned in fList[Idx2].Flags);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      ilivtFlagWanted:        Result := IL_CompareBool(ilifWanted in fList[Idx1].Flags,ilifWanted in fList[Idx2].Flags);
      
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      ilivtFlagOrdered:       Result := IL_CompareBool(ilifOrdered in fList[Idx1].Flags,ilifOrdered in fList[Idx2].Flags);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

      ilivtFlagBoxed:         Result := IL_CompareBool(ilifBoxed in fList[Idx1].Flags,ilifBoxed in fList[Idx2].Flags);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      ilivtFlagElsewhere:     Result := IL_CompareBool(ilifElsewhere in fList[Idx1].Flags,ilifElsewhere in fList[Idx2].Flags);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      ilivtFlagUntested:      Result := IL_CompareBool(ilifUntested in fList[Idx1].Flags,ilifUntested in fList[Idx2].Flags);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      ilivtFlagTesting:       Result := IL_CompareBool(ilifTesting in fList[Idx1].Flags,ilifTesting in fList[Idx2].Flags);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      ilivtFlagTested:        Result := IL_CompareBool(ilifTested in fList[Idx1].Flags,ilifTested in fList[Idx2].Flags);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      ilivtFlagDamaged:       Result := IL_CompareBool(ilifDamaged in fList[Idx1].Flags,ilifDamaged in fList[Idx2].Flags);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      ilivtFlagRepaired:      Result := IL_CompareBool(ilifRepaired in fList[Idx1].Flags,ilifRepaired in fList[Idx2].Flags);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      ilivtFlagPriceChange:   Result := IL_CompareBool(ilifPriceChange in fList[Idx1].Flags,ilifPriceChange in fList[Idx2].Flags);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      ilivtFlagAvailChange:   Result := IL_CompareBool(ilifAvailChange in fList[Idx1].Flags,ilifAvailChange in fList[Idx2].Flags);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      ilivtFlagNotAvailable:  Result := IL_CompareBool(ilifNotAvailable in fList[Idx1].Flags,ilifNotAvailable in fList[Idx2].Flags);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      ilivtFlagLost:          Result := IL_CompareBool(ilifLost in fList[Idx1].Flags,ilifLost in fList[Idx2].Flags);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      ilivtTextTag:           Result := IL_CompareText(fList[Idx1].TextTag,fList[Idx2].TextTag);
// extended specs  = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
      ilivtWantedLevel:       If (ilifWanted in fList[Idx1].Flags) and (ilifWanted in fList[Idx2].Flags) then
                               Result := IL_CompareUInt32(fList[Idx1].WantedLevel,fList[Idx2].WantedLevel)
                              else If ilifWanted in fList[Idx1].Flags then
                                Result := IL_NegateValue(+1,Reversed)
                              else If ilifWanted in fList[Idx2].Flags then
                                Result := IL_NegateValue(-1,Reversed) // those without the flag set goes at the end
                              else
                                Result := 0;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      ilivtVariant:           Result := IL_CompareText(fList[Idx1].Variant,fList[Idx2].Variant);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      ilivtSizeX:             Result := IL_CompareUInt32(fList[Idx1].SizeX,fList[Idx2].SizeX);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      ilivtSizeY:             Result := IL_CompareUInt32(fList[Idx1].SizeY,fList[Idx2].SizeY);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      ilivtSizeZ:             Result := IL_CompareUInt32(fList[Idx1].SizeZ,fList[Idx2].SizeZ);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      ilivtSize:              Result := IL_CompareInt64(ItemSize(fList[Idx1]),ItemSize(fList[Idx2]));
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      ilivtUnitWeight:        Result := IL_CompareUInt32(fList[Idx1].UnitWeight,fList[Idx2].UnitWeight);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      ilivtTotalWeight:       Result := IL_CompareUInt32(ItemTotalWeight(fList[Idx1]),ItemTotalWeight(fList[Idx2]));
// others  = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
      ilivtNotes:             Result := IL_CompareText(fList[Idx1].Notes,fList[Idx2].Notes);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      ilivtReviewURL:         Result := IL_CompareText(fList[Idx1].ReviewURL,fList[Idx2].ReviewURL);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      ilivtReview:            Result := IL_CompareBool(Length(fList[Idx1].ReviewURL) > 0,Length(fList[Idx2].ReviewURL) > 0);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      ilivtMainPictureFile:   Result := IL_CompareText(fList[Idx1].MainPictureFile,fList[Idx2].MainPictureFile);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      ilivtMainPicFilePres:   Result := IL_CompareBool(Length(fList[Idx1].MainPictureFile) > 0,Length(fList[Idx2].MainPictureFile) > 0);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      ilivtPackPictureFile:   Result := IL_CompareText(fList[Idx1].PackagePictureFile,fList[Idx2].PackagePictureFile);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      ilivtPackPicFilePres:   Result := IL_CompareBool(Length(fList[Idx1].PackagePictureFile) > 0,Length(fList[Idx2].PackagePictureFile) > 0);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      ilivtUnitPriceDefault:  Result := IL_CompareUInt32(fList[Idx1].UnitPriceDefault,fList[Idx2].UnitPriceDefault);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      ilivtUnitPriceLowest:   Result := IL_CompareUInt32(fList[Idx1].UnitPriceLowest,fList[Idx2].UnitPriceLowest);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      ilivtTotalPriceLowest:  Result := IL_CompareUInt32(ItemTotalPriceLowest(fList[Idx1]),ItemTotalPriceLowest(fList[Idx2]));
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      ilivtUnitPriceSel:      Result := IL_CompareUInt32(fList[Idx1].UnitPriceSelected,fList[Idx2].UnitPriceSelected);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      ilivtTotalPriceSel:     Result := IL_CompareUInt32(ItemTotalPriceSelected(fList[Idx1]),ItemTotalPriceSelected(fList[Idx2]));
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      ilivtTotalPrice:        Result := IL_CompareUInt32(ItemTotalPrice(fList[Idx1]),ItemTotalPrice(fList[Idx2]));
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      ilivtAvailable:         If (fList[Idx1].AvailableSelected < 0) and (fList[Idx2].AvailableSelected < 0) then
                                Result := IL_CompareInt32(Abs(fList[Idx1].AvailableSelected),Abs(fList[Idx2].AvailableSelected))
                              else If (fList[Idx1].AvailableSelected < 0) then
                                Result := IL_CompareInt32(Abs(fList[Idx1].AvailableSelected) + 1,fList[Idx2].AvailableSelected)
                              else If (fList[Idx2].AvailableSelected < 0) then
                                Result := IL_CompareInt32(fList[Idx1].AvailableSelected,Abs(fList[Idx2].AvailableSelected) + 1)
                              else
                                Result := IL_CompareInt32(fList[Idx1].AvailableSelected,fList[Idx2].AvailableSelected);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      ilivtShopCount:         Result := IL_CompareUInt32(ItemShopsCount(fList[Idx1]),ItemShopsCount(fList[Idx2]));
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      ilivtUsefulShopCount:   Result := IL_CompareUInt32(ItemShopsUsefulCount(fList[Idx1]),ItemShopsUsefulCount(fList[Idx2]));
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      ilivtUsefulShopRatio:   If (ItemShopsCount(fList[Idx1]) > 0) and (ItemShopsCount(fList[Idx2]) > 0) then
                                Result := IL_CompareFloat(ItemShopsUsefulRatio(fList[Idx1]),ItemShopsUsefulRatio(fList[Idx2]))
                              else If ItemShopsCount(fList[Idx1]) > 0 then
                                Result := IL_NegateValue(+1,Reversed) // push items with no shop to the end
                              else If ItemShopsCount(fList[Idx2]) > 0 then
                                Result := IL_NegateValue(-1,Reversed)
                              else
                                Result := 0;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      ilivtSelectedShop:      If ItemShopsSelected(fList[Idx1],SelShop1) and ItemShopsSelected(fList[Idx2],SelShop2) then
                                Result := IL_CompareText(SelShop1.Name,SelShop2.Name)
                              else If ItemShopsSelected(fList[Idx1],SelShop1) then
                                Result := IL_NegateValue(+1,Reversed)
                              else If ItemShopsSelected(fList[Idx2],SelShop2) then
                                Result := IL_NegateValue(-1,Reversed) // push items with no shop selected at the end
                              else
                                Result := 0;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      ilivtWorstUpdateResult: If (Length(fList[Idx1].Shops) > 0) and (Length(fList[Idx2].Shops) > 0) then
                                Result := IL_CompareInt32(Ord(ItemShopsWorstUpdateResult(fList[Idx1])),Ord(ItemShopsWorstUpdateResult(fList[Idx2])))
                              else If Length(fList[Idx1].Shops) > 0 then
                                Result := IL_NegateValue(+1,Reversed) // push items with no shop to the end
                              else If Length(fList[Idx2].Shops) > 0 then
                                Result := IL_NegateValue(-1,Reversed)
                              else
                                Result := 0;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    else
      {vtNone}
      Result := 0;
    end;
    If Reversed then
      Result := -Result;
  end;

begin
Result := 0;
If Idx1 <> Idx2 then
  begin
    For i := Low(fUsedSortSett.Items) to Pred(fUsedSortSett.Count) do
      Result := (Result shl 1) +
        CompareValues(fUsedSortSett.Items[i].ItemValueTag,fUsedSortSett.Items[i].Reversed);
    // stabilize sorting using indices
    If Result = 0 then
      Result := (Result shl 1) + IL_CompareInt32(fList[Idx1].Index,fList[Idx2].Index);
  end;
end;

//==============================================================================

Function TILManager_Sort.SortingProfileAdd(const Name: String): Integer;
begin
SetLength(fSortingProfiles,Length(fSortingProfiles) + 1);
Result := High(fSortingProfiles);
fSortingProfiles[Result].Name := Name;
FillChar(fSortingProfiles[Result].Settings,SizeOf(TILSortingSettings),0);
end;

//------------------------------------------------------------------------------

procedure TILManager_Sort.SortingProfileRename(Index: Integer; const NewName: String);
begin
If (Index >= Low(fSortingProfiles)) and (Index <= High(fSortingProfiles)) then
  fSortingProfiles[Index].Name := NewName
else
  raise Exception.CreateFmt('TILManager_Sort.SortingProfileRename: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

procedure TILManager_Sort.SortingProfileExchange(Idx1,Idx2: Integer);
var
  Temp: TILSortingProfile;
begin
If Idx1 <> Idx2 then
  begin
    // sanity checks
    If (Idx1 < Low(fSortingProfiles)) or (Idx1 > High(fSortingProfiles)) then
      raise Exception.CreateFmt('TILManager_Sort.SortingProfileExchange: First index (%d) out of bounds.',[Idx1]);
    If (Idx2 < Low(fSortingProfiles)) or (Idx2 > High(fSortingProfiles)) then
      raise Exception.CreateFmt('TILManager_Sort.SortingProfileExchange: Second index (%d) out of bounds.',[Idx2]);
    Temp := fSortingProfiles[Idx1];
    fSortingProfiles[Idx1] := fSortingProfiles[Idx2];
    fSortingProfiles[Idx2] := Temp;
  end;
end;

//------------------------------------------------------------------------------

procedure TILManager_Sort.SortingProfileDelete(Index: Integer);
var
  i:  Integer;
begin
If (Index >= Low(fSortingProfiles)) and (Index <= High(fSortingProfiles)) then
  begin
    For i := Index to Pred(High(fSortingProfiles)) do
      fSortingProfiles[Index] := fSortingProfiles[Index + 1];
    SetLength(fSortingProfiles,Length(fSortingProfiles) - 1);
  end
else raise Exception.CreateFmt('TILManager_Sort.SortingProfileDelete: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

procedure TILManager_Sort.ItemSort(SortingProfile: Integer);
var
  i:      Integer;
  Sorter: TListSorter;
begin
ReIndex;  // to be sure
case SortingProfile of
  -2: fUsedSortSett := fDefaultSortSett;
  -1: fUsedSortSett := fActualSortSett;
else
  If (SortingProfile >= Low(fSortingProfiles)) and (SortingProfile <= High(fSortingProfiles)) then
    fUsedSortSett := fSortingProfiles[SortingProfile].Settings
  else
    raise Exception.CreateFmt('TILManager_Sort.ItemSort: Invalid sorting profile index (%d).',[SortingProfile]);
end;
If fReversedSort then
  For i := Low(fUsedSortSett.Items) to Pred(fUsedSortSett.Count) do
    fUsedSortSett.Items[i].Reversed := not fUsedSortSett.Items[i].Reversed;
If Length(fList) > 1 then
  begin
    Sorter := TListQuickSorter.Create(ItemCompare,ItemExchange);
    try
      fSorting := True;
      try
        Sorter.Sort(Low(fList),High(fList));
      finally
        fSorting := False;
      end;
    finally
      Sorter.Free;
    end;
    ReIndex;
  end;
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

procedure TILManager_Sort.ItemSort;
begin
ItemSort(-1);
end;


end.
