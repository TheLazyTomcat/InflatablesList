unit IL_Types;

{$INCLUDE '.\IL_defs.inc'}

interface

uses
  Graphics,
  AuxTypes;

//==============================================================================
//- reconverted string ---------------------------------------------------------

type
  TILReconvString = record
    Str:        String;
    UTF8Reconv: String;
    AnsiReconv: String;
  end;

Function IL_UTF8Reconvert(const Str: String): String;
Function IL_ANSIReconvert(const Str: String): String;

Function IL_ReconvString(const Str: String): TILReconvString;

Function IL_ReconvCompareStr(const A,B: TILReconvString): Integer;
Function IL_ReconvCompareText(const A,B: TILReconvString): Integer;
Function IL_ReconvSameStr(const A,B: TILReconvString): Boolean;
Function IL_ReconvSameText(const A,B: TILReconvString): Boolean;

procedure IL_UniqueReconvStr(var Str: TILReconvString);

//==============================================================================
//- items ----------------------------------------------------------------------

type
  TILItemType = (ilitUnknown,ilitRing,ilitRingWithHandles,ilitBall,ilitRider,
                 ilitLounger,ilitLoungerChair,ilitChair,ilitSeat,ilitMattress,
                 ilitIsland,ilitBed,ilitBoat,ilitToy,ilitWings,ilitBalloon,
                 ilitOther);

  TILItemManufacturer = (ilimBestway,ilimIntex,ilimHappyPeople,ilimMondo,
                         ilimPolygroup,ilimSummerWaves,ilimSwimline,
                         ilimVetroPlus,ilimWehncke,ilimWIKY,ilimOthers);

  TILItemFlag = (ilifOwned,ilifWanted,ilifOrdered,ilifBoxed,ilifElsewhere,
                 ilifUntested,ilifTesting,ilifTested,ilifDamaged,ilifRepaired,
                 ilifPriceChange,ilifAvailChange,ilifNotAvailable,ilifLost);

  TILItemFlags = set of TILItemFlag;

Function IL_ItemTypeToNum(ItemType: TILItemType): Int32;
Function IL_NumToItemType(Num: Int32): TILItemType;

Function IL_ItemManufacturerToNum(ItemManufacturer: TILItemManufacturer): Int32;
Function IL_NumToItemManufacturer(Num: Int32): TILItemManufacturer;

Function IL_SetItemFlagValue(var ItemFlags: TILItemFlags; ItemFlag: TILItemFlag; NewValue: Boolean): Boolean;

Function IL_EncodeItemFlags(ItemFlags: TILItemFlags): UInt32;
Function IL_DecodeItemFlags(Flags: UInt32): TILItemFlags;

//==============================================================================
//- item shop parsing ----------------------------------------------------------

type
  TILItemShopParsingExtrFrom = (ilpefText,ilpefNestedText,ilpefAttrValue);

  TILItemShopParsingExtrMethod = (ilpemFirstInteger,ilpemFirstIntegerTag,
                                  ilpemNegTagIsCount,ilpemFirstNumber,
                                  ilpemFirstNumberTag);

  TILItemShopParsingExtrSett = record
    ExtractFrom:      TILItemShopParsingExtrFrom;
    ExtractionMethod: TILItemShopParsingExtrMethod;    
    ExtractionData:   String;
    NegativeTag:      String;
  end;
  PILItemShopParsingExtrSett = ^TILItemShopParsingExtrSett;

  TILItemShopParsingExtrSettList = array of TILItemShopParsingExtrSett;

  TILItemShopParsingVariables = record
    Vars: array[0..7] of String;  // never change the number (8 is enough for everyone :P)!
  end;
  PILItemShopParsingVariables = ^TILItemShopParsingVariables; 

Function IL_ExtractFromToNum(ExtractFrom: TILItemShopParsingExtrFrom): Int32;
Function IL_NumToExtractFrom(Num: Int32): TILItemShopParsingExtrFrom;

Function IL_ExtrMethodToNum(ExtrMethod: TILItemShopParsingExtrMethod): Int32;
Function IL_NumToExtrMethod(Num: Int32): TILItemShopParsingExtrMethod;

//==============================================================================
//- item shop ------------------------------------------------------------------

type
  TILItemShopUpdateResult = (
    ilisurSuccess,    // lime     ilurSuccess
    ilisurMildSucc,   // green    ilurSuccess on untracked
    ilisurDataFail,   // blue     ilurNoLink, ilurNoData
    ilisurSoftFail,   // yellow   ilurFailAvailSearch, ilurFailAvailValGet
    ilisurHardFail,   // orange   ilurFailSearch, ilurFailValGet
    ilisurCritical,   // red      ilurFailDown, ilurFailParse
    ilisurFatal);     // black    ilurFail, unknown state

  TILItemShopHistoryEntry = record
    Value:  Int32;
    Time:   TDateTIme;
  end;

  TILItemShopHistory = array of TILItemShopHistoryEntry;

Function IL_ItemShopUpdateResultToNum(UpdateResult: TILItemShopUpdateResult): Int32;
Function IL_NumToItemShopUpdateResult(Num: Int32): TILItemShopUpdateResult;

Function IL_ItemShopUpdateResultToColor(UpdateResult: TILItemShopUpdateResult): TColor;

//==============================================================================
//- item -----------------------------------------------------------------------

type
  TILItemUpdatedFlag = (iliufMainList,iliufSmallList,iliufTitle,iliufPictures,
                        iliufShopList);

  TILItemUpdatedFlags = set of TILItemUpdatedFlag;

//==============================================================================
//- sorting --------------------------------------------------------------------  

type
  TILItemValueTag = (
    ilivtNone,ilivtMainPicture,ilivtPackagePicture,ilivtTimeOfAdd,ilivtItemType,
    ilivtItemTypeSpec,ilivtCount,ilivtManufacturer,ilivtManufacturerStr,ilivtID,
    ilivtFlagOwned,ilivtFlagWanted,ilivtFlagOrdered,ilivtFlagBoxed,ilivtFlagElsewhere,
    ilivtFlagUntested,ilivtFlagTesting,ilivtFlagTested,ilivtFlagDamaged,ilivtFlagRepaired,
    ilivtFlagPriceChange,ilivtFlagAvailChange,ilivtFlagNotAvailable,ilivtFlagLost,
    ilivtTextTag,ilivtWantedLevel,ilivtVariant,ilivtSizeX,ilivtSizeY,ilivtSizeZ,
    ilivtTotalSize,ilivtUnitWeight,ilivtTotalWeight,ilivtNotes,ilivtReviewURL,ilivtReview,
    ilivtMainPictureFile,ilivtMainPicFilePres,ilivtPackPictureFile,ilivtPackPicFilePres,
    ilivtUnitPriceDefault,ilivtUnitPriceLowest,ilivtTotalPriceLowest,ilivtUnitPriceSel,
    ilivtTotalPriceSel,ilivtTotalPrice,ilivtAvailable,ilivtShopCount,ilivtUsefulShopCount,
    ilivtUsefulShopRatio,ilivtSelectedShop,ilivtWorstUpdateResult);

  TILSortingItem = record
    ItemValueTag: TILItemValueTag;
    Reversed:     Boolean;
  end;

  TILSortingSettings = record
    Count:  Integer;
    Items:  array[0..29] of TILSortingItem;
  end;

  TILSortingProfile = record
    Name:     String;
    Settings: TILSortingSettings;
  end;
  PILSortingProfile = ^TILSortingProfile;

  TILSortingProfiles = array of TILSortingProfile;

Function IL_ItemValueTagToNum(ItemValueTag: TILItemValueTag): Int32;
Function IL_NumToItemValueTag(Num: Int32): TILItemValueTag;

//==============================================================================
//- sum filters ----------------------------------------------------------------

type
  TILFilterOperator = (ilfoAND,ilfoOR,ilfoXOR);

  TILFilterFlag = (
    ilffOwnedSet,ilffOwnedClr,ilffWantedSet,ilffWantedClr,
    ilffOrderedSet,ilffOrderedClr,ilffBoxedSet,ilffBoxedClr,
    ilffElsewhereSet,ilffElsewhereClr,ilffUntestedSet,ilffUntestedClr,
    ilffTestingSet,ilffTestingClr,ilffTestedSet,ilffTestedClr,
    ilffDamagedSet,ilffDamagedClr,ilffRepairedSet,ilffRepairedClr,
    ilffPriceChangeSet,ilffPriceChangeClr,ilffAvailChangeSet,ilffAvailChangeClr,
    ilffNotAvailableSet,ilffNotAvailableClr,ilffLostSet,ilffLostClr);

  TILFilterFlags = set of TILFilterFlag;

  TILFilterSettings = record
    Operator: TILFilterOperator;
    Flags:    TILFilterFlags;
  end;

Function IL_FilterOperatorToNum(Operator: TILFilterOperator): Int32;
Function IL_NumToFilterOperator(Num: Int32): TILFilterOperator;

Function IL_SetFilterSettingsFlagValue(var FilterFlags: TILFilterFlags; FilterFlag: TILFilterFlag; NewValue: Boolean): Boolean;

Function IL_EncodeFilterFlags(FilterFlags: TILFilterFlags): UInt32;
Function IL_DecodeFilterFlags(Flags: UInt32): TILFilterFlags;

//==============================================================================
//- sums -----------------------------------------------------------------------

type
  TILSumRec = record
    Items:          Integer;
    Pieces:         Integer;
    UnitWeigth:     Integer;
    TotalWeight:    Integer;
    UnitPriceLow:   Integer;
    UnitPriceSel:   Integer;
    TotalPriceLow:  Integer;
    TotalPriceSel:  Integer;
    TotalPrice:     Integer;
  end;

  TILSumsByType = array[TILItemType] of TILSumRec;

  TILSumsByManufacturer = array[TILItemManufacturer] of TILSumRec;

  TILSumsArray = array of TILSumRec;

//==============================================================================
//- command-line options -------------------------------------------------------

type
  TILCMDManagerOptions = record
    NoPictures: Boolean;
    TestCode:   Boolean;
    SavePages:  Boolean;
    LoadPages:  Boolean;
  end;

Function IL_ThreadSafeCopy(const Value: TILCMDManagerOptions): TILCMDManagerOptions;

implementation

uses
  SysUtils,
  BitOps, StrRect;

//==============================================================================
//- reconverted string ---------------------------------------------------------

Function IL_UTF8Reconvert(const Str: String): String;
var
  UTF8Temp: UTF8String;
  AnsiTemp: AnsiString;
begin
If Length(Str) > 0 then
  begin
    AnsiTemp := AnsiString(StrToUnicode(Str));
    SetLength(UTF8Temp,Length(AnsiTemp));
    Move(PAnsiChar(AnsiTemp)^,PUTF8Char(UTF8Temp)^,Length(UTF8Temp));
    Result := UnicodeToStr(UTF8Decode(UTF8Temp))
  end
else
  Result := '';
end;

//------------------------------------------------------------------------------

Function IL_ANSIReconvert(const Str: String): String;
var
  UTF8Temp: UTF8String;
  AnsiTemp: AnsiString;
begin
If Length(Str) > 0 then
  begin
    UTF8Temp := UTF8Encode(StrToUnicode(Str));
    SetLength(AnsiTemp,Length(UTF8Temp));
    Move(PUTF8Char(UTF8Temp)^,PAnsiChar(AnsiTemp)^,Length(AnsiTemp));
    Result := UnicodeToStr(UnicodeString(AnsiTemp))
  end
else
  Result := '';
end;

//------------------------------------------------------------------------------

Function IL_ReconvString(const Str: String): TILReconvString;
var
  i:  Integer;
begin
Result.Str := Str;
// remove null characters as they might break comparation function
For i := 1 to Length(Result.Str) do
  If Ord(Result.Str[i]) = 0 then
    Result.Str[i] := Char(' ');
Result.UTF8Reconv := IL_UTF8Reconvert(Str);
Result.AnsiReconv := IL_ANSIReconvert(Str);
end;

//------------------------------------------------------------------------------

Function IL_ReconvCompareStr(const A,B: TILReconvString): Integer;
begin
Result := AnsiCompareStr(A.Str,B.Str);
end;
 
//------------------------------------------------------------------------------

Function IL_ReconvCompareText(const A,B: TILReconvString): Integer;
begin
Result := AnsiCompareText(A.Str,B.Str);
end;

//------------------------------------------------------------------------------

Function IL_ReconvSameStr(const A,B: TILReconvString): Boolean;
begin
Result := AnsiSameStr(A.Str,B.Str);
end;

//------------------------------------------------------------------------------

Function IL_ReconvSameText(const A,B: TILReconvString): Boolean;
begin
Result := AnsiSameText(A.Str,B.Str);
end;

//------------------------------------------------------------------------------

procedure IL_UniqueReconvStr(var Str: TILReconvString);
begin
UniqueString(Str.Str);
UniqueString(Str.UTF8Reconv);
UniqueString(Str.AnsiReconv);
end;

//==============================================================================
//- list item ------------------------------------------------------------------

Function IL_ItemTypeToNum(ItemType: TILItemType): Int32;
begin
case ItemType of
  ilitRing:             Result := 1;
  ilitRingWithHandles:  Result := 2;
  ilitBall:             Result := 3;
  ilitRider:            Result := 4;
  ilitLounger:          Result := 5;
  ilitLoungerChair:     Result := 6;
  ilitChair:            Result := 7;
  ilitSeat:             Result := 8;
  ilitMattress:         Result := 9;
  ilitIsland:           Result := 10;
  ilitBed:              Result := 11;
  ilitBoat:             Result := 12;
  ilitToy:              Result := 13;
  ilitWings:            Result := 14;
  ilitOther:            Result := 15;
  ilitBalloon:          Result := 16;
else
 {ilitUnknown}
 Result := 0;
end;
end;

//------------------------------------------------------------------------------

Function IL_NumToItemType(Num: Int32): TILItemType;
begin
case Num of
  1:  Result := ilitRing;
  2:  Result := ilitRingWithHandles;
  3:  Result := ilitBall;
  4:  Result := ilitRider;
  5:  Result := ilitLounger;
  6:  Result := ilitLoungerChair;
  7:  Result := ilitChair;
  8:  Result := ilitSeat;
  9:  Result := ilitMattress;
  10: Result := ilitIsland;
  11: Result := ilitBed;
  12: Result := ilitBoat;
  13: Result := ilitToy;
  14: Result := ilitWings;
  15: Result := ilitOther;
  16: Result := ilitBalloon;
else
  Result := ilitUnknown;
end;
end;

//------------------------------------------------------------------------------

Function IL_ItemManufacturerToNum(ItemManufacturer: TILItemManufacturer): Int32;
begin
case ItemManufacturer of
  ilimIntex:        Result := 1;
  ilimBestway:      Result := 2;
  ilimWIKY:         Result := 3;
  ilimHappyPeople:  Result := 4;
  ilimSwimline:     Result := 5;
  ilimMondo:        Result := 6;
  ilimWehncke:      Result := 7;
  ilimVetroPlus:    Result := 8;
  ilimPolygroup:    Result := 9;
  ilimSummerWaves:  Result := 10;
else
  {ilimOthers}
  Result := 0;
end;
end;

//------------------------------------------------------------------------------

Function IL_NumToItemManufacturer(Num: Int32): TILItemManufacturer;
begin
case Num of
  1:  Result := ilimIntex;
  2:  Result := ilimBestway;
  3:  Result := ilimWIKY;
  4:  Result := ilimHappyPeople;
  5:  Result := ilimSwimline;
  6:  Result := ilimMondo;
  7:  Result := ilimWehncke;
  8:  Result := ilimVetroPlus;
  9:  Result := ilimPolygroup;
  10: Result := ilimSummerWaves;
else
  Result := ilimOthers;
end;
end;

//------------------------------------------------------------------------------

Function IL_SetItemFlagValue(var ItemFlags: TILItemFlags; ItemFlag: TILItemFlag; NewValue: Boolean): Boolean;
begin
Result := ItemFlag in ItemFlags;
If NewValue then
  Include(ItemFlags,ItemFlag)
else
  Exclude(ItemFlags,ItemFlag);
end;

//------------------------------------------------------------------------------

Function IL_EncodeItemFlags(ItemFlags: TILItemFlags): UInt32;
begin
Result := 0;
SetFlagStateValue(Result,$00000001,ilifOwned in ItemFlags);
SetFlagStateValue(Result,$00000002,ilifWanted in ItemFlags);
SetFlagStateValue(Result,$00000004,ilifOrdered in ItemFlags);
SetFlagStateValue(Result,$00000008,ilifBoxed in ItemFlags);
SetFlagStateValue(Result,$00000010,ilifElsewhere in ItemFlags);
SetFlagStateValue(Result,$00000020,ilifUntested in ItemFlags);
SetFlagStateValue(Result,$00000040,ilifTesting in ItemFlags);
SetFlagStateValue(Result,$00000080,ilifTested in ItemFlags);
SetFlagStateValue(Result,$00000100,ilifDamaged in ItemFlags);
SetFlagStateValue(Result,$00000200,ilifRepaired in ItemFlags);
SetFlagStateValue(Result,$00000400,ilifPriceChange in ItemFlags);
SetFlagStateValue(Result,$00000800,ilifAvailChange in ItemFlags);
SetFlagStateValue(Result,$00001000,ilifNotAvailable in ItemFlags);
SetFlagStateValue(Result,$00002000,ilifLost in ItemFlags);
end;
 
//------------------------------------------------------------------------------

Function IL_DecodeItemFlags(Flags: UInt32): TILItemFlags;
begin
Result := [];
IL_SetItemFlagValue(Result,ilifOwned,GetFlagState(Flags,$00000001));
IL_SetItemFlagValue(Result,ilifWanted,GetFlagState(Flags,$00000002));
IL_SetItemFlagValue(Result,ilifOrdered,GetFlagState(Flags,$00000004));
IL_SetItemFlagValue(Result,ilifBoxed,GetFlagState(Flags,$00000008));
IL_SetItemFlagValue(Result,ilifElsewhere,GetFlagState(Flags,$00000010));
IL_SetItemFlagValue(Result,ilifUntested,GetFlagState(Flags,$00000020));
IL_SetItemFlagValue(Result,ilifTesting,GetFlagState(Flags,$00000040));
IL_SetItemFlagValue(Result,ilifTested,GetFlagState(Flags,$00000080));
IL_SetItemFlagValue(Result,ilifDamaged,GetFlagState(Flags,$00000100));
IL_SetItemFlagValue(Result,ilifRepaired,GetFlagState(Flags,$00000200));
IL_SetItemFlagValue(Result,ilifPriceChange,GetFlagState(Flags,$00000400));
IL_SetItemFlagValue(Result,ilifAvailChange,GetFlagState(Flags,$00000800));
IL_SetItemFlagValue(Result,ilifNotAvailable,GetFlagState(Flags,$00001000));
IL_SetItemFlagValue(Result,ilifLost,GetFlagState(Flags,$00002000));
end;

//==============================================================================
//- item shop parsing ----------------------------------------------------------

Function IL_ExtractFromToNum(ExtractFrom: TILItemShopParsingExtrFrom): Int32;
begin
case ExtractFrom of
  ilpefNestedText:  Result := 1;
  ilpefAttrValue:   Result := 2;
else
  {ilpefText}
  Result := 0;
end;
end;

//------------------------------------------------------------------------------

Function IL_NumToExtractFrom(Num: Int32): TILItemShopParsingExtrFrom;
begin
case Num of
  1:  Result := ilpefNestedText;
  2:  Result := ilpefAttrValue;
else
  Result := ilpefText;
end;
end;

//------------------------------------------------------------------------------

Function IL_ExtrMethodToNum(ExtrMethod: TILItemShopParsingExtrMethod): Int32;
begin
case ExtrMethod of
  ilpemFirstIntegerTag: Result := 1;
  ilpemNegTagIsCount:   Result := 2;
  ilpemFirstNumber:     Result := 3;
  ilpemFirstNumberTag:  Result := 4;
else
  {ilpemFirstInteger}
  Result := 0;
end;
end;

//------------------------------------------------------------------------------

Function IL_NumToExtrMethod(Num: Int32): TILItemShopParsingExtrMethod;
begin
case Num of
  1:  Result := ilpemFirstIntegerTag;
  2:  Result := ilpemNegTagIsCount;
  3:  Result := ilpemFirstNumber;
  4:  Result := ilpemFirstNumberTag;
else
  Result := ilpemFirstInteger;
end;
end;

//==============================================================================
//- item shop ------------------------------------------------------------------

Function IL_ItemShopUpdateResultToNum(UpdateResult: TILItemShopUpdateResult): Int32;
begin
case UpdateResult of
  ilisurMildSucc: Result := 1;
  ilisurDataFail: Result := 2;
  ilisurSoftFail: Result := 3;
  ilisurHardFail: Result := 4;
  ilisurCritical: Result := 5;
  ilisurFatal:    Result := 6;
else
 {ilisurSuccess}
  Result := 0;
end;
end;

//------------------------------------------------------------------------------

Function IL_NumToItemShopUpdateResult(Num: Int32): TILItemShopUpdateResult;
begin
case Num of
  1:  Result := ilisurMildSucc;
  2:  Result := ilisurDataFail;
  3:  Result := ilisurSoftFail;
  4:  Result := ilisurHardFail;
  5:  Result := ilisurCritical;
  6:  Result := ilisurFatal;
else
  Result := ilisurSuccess;
end;
end;

//------------------------------------------------------------------------------

Function IL_ItemShopUpdateResultToColor(UpdateResult: TILItemShopUpdateResult): TColor;
begin
case UpdateResult of
  ilisurMildSucc: Result := clGreen;
  ilisurDataFail: Result := clBlue;
  ilisurSoftFail: Result := clYellow;
  ilisurHardFail: Result := $00409BFF;  // orange
  ilisurCritical: Result := clRed;
  ilisurFatal:    Result := clBlack;
else
 {ilisurSuccess}
  Result := clLime;
end;
end;

//==============================================================================
//- sorting --------------------------------------------------------------------

Function IL_ItemValueTagToNum(ItemValueTag: TILItemValueTag): Int32;
begin
case ItemValueTag of
  ilivtMainPicture:       Result := 1;
  ilivtPackagePicture:    Result := 2;
  ilivtTimeOfAdd:         Result := 3;
  ilivtItemType:          Result := 4;
  ilivtItemTypeSpec:      Result := 5;
  ilivtCount:             Result := 6;
  ilivtManufacturer:      Result := 7;
  ilivtManufacturerStr:   Result := 8;
  ilivtID:                Result := 9;
  ilivtFlagOwned:         Result := 10;
  ilivtFlagWanted:        Result := 11;
  ilivtFlagOrdered:       Result := 12;
  ilivtFlagBoxed:         Result := 13;
  ilivtFlagElsewhere:     Result := 14;
  ilivtFlagUntested:      Result := 15;
  ilivtFlagTesting:       Result := 16;
  ilivtFlagTested:        Result := 17;
  ilivtFlagDamaged:       Result := 18;
  ilivtFlagRepaired:      Result := 19;
  ilivtFlagPriceChange:   Result := 20;
  ilivtFlagAvailChange:   Result := 21;
  ilivtFlagNotAvailable:  Result := 22;
  ilivtTextTag:           Result := 23;
  ilivtWantedLevel:       Result := 24;
  ilivtVariant:           Result := 25;
  ilivtSizeX:             Result := 26;
  ilivtSizeY:             Result := 27;
  ilivtSizeZ:             Result := 28;
  ilivtTotalSize:         Result := 29;
  ilivtUnitWeight:        Result := 30;
  ilivtTotalWeight:       Result := 31;
  ilivtNotes:             Result := 32;
  ilivtReviewURL:         Result := 33;
  ilivtReview:            Result := 34;
  ilivtMainPictureFile:   Result := 35;
  ilivtMainPicFilePres:   Result := 36;
  ilivtPackPictureFile:   Result := 37;
  ilivtPackPicFilePres:   Result := 38;
  ilivtUnitPriceDefault:  Result := 39;
  ilivtUnitPriceLowest:   Result := 40;
  ilivtTotalPriceLowest:  Result := 41;
  ilivtUnitPriceSel:      Result := 42;
  ilivtTotalPriceSel:     Result := 43;
  ilivtTotalPrice:        Result := 44;
  ilivtAvailable:         Result := 45;
  ilivtShopCount:         Result := 46;
  ilivtSelectedShop:      Result := 47;
  // newly added
  ilivtFlagLost:          Result := 48;
  ilivtWorstUpdateResult: Result := 49;
  ilivtUsefulShopCount:   Result := 50;
  ilivtUsefulShopRatio:   Result := 51;
else
  {ilivtNone}
  Result := 0;
end;
end;

//------------------------------------------------------------------------------

Function IL_NumToItemValueTag(Num: Int32): TILItemValueTag;
begin
case Num of
  1:  Result := ilivtMainPicture;
  2:  Result := ilivtPackagePicture;
  3:  Result := ilivtTimeOfAdd;
  4:  Result := ilivtItemType;
  5:  Result := ilivtItemTypeSpec;
  6:  Result := ilivtCount;
  7:  Result := ilivtManufacturer;
  8:  Result := ilivtManufacturerStr;
  9:  Result := ilivtID;
  10: Result := ilivtFlagOwned;
  11: Result := ilivtFlagWanted;
  12: Result := ilivtFlagOrdered;
  13: Result := ilivtFlagBoxed;
  14: Result := ilivtFlagElsewhere;
  15: Result := ilivtFlagUntested;
  16: Result := ilivtFlagTesting;
  17: Result := ilivtFlagTested;
  18: Result := ilivtFlagDamaged;
  19: Result := ilivtFlagRepaired;
  20: Result := ilivtFlagPriceChange;
  21: Result := ilivtFlagAvailChange;
  22: Result := ilivtFlagNotAvailable;
  23: Result := ilivtTextTag;
  24: Result := ilivtWantedLevel;
  25: Result := ilivtVariant;
  26: Result := ilivtSizeX;
  27: Result := ilivtSizeY;
  28: Result := ilivtSizeZ;
  29: Result := ilivtTotalSize;
  30: Result := ilivtUnitWeight;
  31: Result := ilivtTotalWeight;
  32: Result := ilivtNotes;
  33: Result := ilivtReviewURL;
  34: Result := ilivtReview;
  35: Result := ilivtMainPictureFile;
  36: Result := ilivtMainPicFilePres;
  37: Result := ilivtPackPictureFile;
  38: Result := ilivtPackPicFilePres;
  39: Result := ilivtUnitPriceDefault;
  40: Result := ilivtUnitPriceLowest;
  41: Result := ilivtTotalPriceLowest;
  42: Result := ilivtUnitPriceSel;
  43: Result := ilivtTotalPriceSel;
  44: Result := ilivtTotalPrice;
  45: Result := ilivtAvailable;
  46: Result := ilivtShopCount;
  47: Result := ilivtSelectedShop;
  // newly added
  48: Result := ilivtFlagLost;
  49: Result := ilivtWorstUpdateResult;
  50: Result := ilivtUsefulShopCount;
  51: Result := ilivtUsefulShopRatio;
else
  Result := ilivtNone;
end;
end;

//==============================================================================
//- sum filters ----------------------------------------------------------------

Function IL_FilterOperatorToNum(Operator: TILFilterOperator): Int32;
begin
case Operator of
  ilfoOR:   Result := 1;
  ilfoXOR:  Result := 2;
else
  {ilfoAND}
  Result := 0;
end;
end;

//------------------------------------------------------------------------------

Function IL_NumToFilterOperator(Num: Int32): TILFilterOperator;
begin
case Num of
  1:  Result := ilfoOR;
  2:  Result := ilfoXOR;
else
  Result := ilfoAND;
end;
end;

//------------------------------------------------------------------------------

Function IL_SetFilterSettingsFlagValue(var FilterFlags: TILFilterFlags; FilterFlag: TILFilterFlag; NewValue: Boolean): Boolean;
begin
Result := FilterFlag in FilterFlags;
If NewValue then
  Include(FilterFlags,FilterFlag)
else
  Exclude(FilterFlags,FilterFlag);
end;

//------------------------------------------------------------------------------

Function IL_EncodeFilterFlags(FilterFlags: TILFilterFlags): UInt32;
begin
Result := 0;
SetFlagStateValue(Result,$00000001,ilffOwnedSet in FilterFlags);
SetFlagStateValue(Result,$00000002,ilffOwnedClr in FilterFlags);
SetFlagStateValue(Result,$00000004,ilffWantedSet in FilterFlags);
SetFlagStateValue(Result,$00000008,ilffWantedClr in FilterFlags);
SetFlagStateValue(Result,$00000010,ilffOrderedSet in FilterFlags);
SetFlagStateValue(Result,$00000020,ilffOrderedClr in FilterFlags);
SetFlagStateValue(Result,$00000040,ilffBoxedSet in FilterFlags);
SetFlagStateValue(Result,$00000080,ilffBoxedClr in FilterFlags);
SetFlagStateValue(Result,$00000100,ilffElsewhereSet in FilterFlags);
SetFlagStateValue(Result,$00000200,ilffElsewhereClr in FilterFlags);
SetFlagStateValue(Result,$00000400,ilffUntestedSet in FilterFlags);
SetFlagStateValue(Result,$00000800,ilffUntestedClr in FilterFlags);
SetFlagStateValue(Result,$00001000,ilffTestingSet in FilterFlags);
SetFlagStateValue(Result,$00002000,ilffTestingClr in FilterFlags);
SetFlagStateValue(Result,$00004000,ilffTestedSet in FilterFlags);
SetFlagStateValue(Result,$00008000,ilffTestedClr in FilterFlags);
SetFlagStateValue(Result,$00010000,ilffDamagedSet in FilterFlags);
SetFlagStateValue(Result,$00020000,ilffDamagedClr in FilterFlags);
SetFlagStateValue(Result,$00040000,ilffRepairedSet in FilterFlags);
SetFlagStateValue(Result,$00080000,ilffRepairedClr in FilterFlags);
SetFlagStateValue(Result,$00100000,ilffPriceChangeSet in FilterFlags);
SetFlagStateValue(Result,$00200000,ilffPriceChangeClr in FilterFlags);
SetFlagStateValue(Result,$00400000,ilffAvailChangeSet in FilterFlags);
SetFlagStateValue(Result,$00800000,ilffAvailChangeClr in FilterFlags);
SetFlagStateValue(Result,$01000000,ilffNotAvailableSet in FilterFlags);
SetFlagStateValue(Result,$02000000,ilffNotAvailableClr in FilterFlags);
SetFlagStateValue(Result,$04000000,ilffLostSet in FilterFlags);
SetFlagStateValue(Result,$08000000,ilffLostClr in FilterFlags);
end;

//------------------------------------------------------------------------------

Function IL_DecodeFilterFlags(Flags: UInt32): TILFilterFlags;
begin
Result := [];
IL_SetFilterSettingsFlagValue(Result,ilffOwnedSet,GetFlagState(Flags,$00000001));
IL_SetFilterSettingsFlagValue(Result,ilffOwnedClr,GetFlagState(Flags,$00000002));
IL_SetFilterSettingsFlagValue(Result,ilffWantedSet,GetFlagState(Flags,$00000004));
IL_SetFilterSettingsFlagValue(Result,ilffWantedClr,GetFlagState(Flags,$00000008));
IL_SetFilterSettingsFlagValue(Result,ilffOrderedSet,GetFlagState(Flags,$00000010));
IL_SetFilterSettingsFlagValue(Result,ilffOrderedClr,GetFlagState(Flags,$00000020));
IL_SetFilterSettingsFlagValue(Result,ilffBoxedSet,GetFlagState(Flags,$00000040));
IL_SetFilterSettingsFlagValue(Result,ilffBoxedClr,GetFlagState(Flags,$00000080));
IL_SetFilterSettingsFlagValue(Result,ilffElsewhereSet,GetFlagState(Flags,$00000100));
IL_SetFilterSettingsFlagValue(Result,ilffElsewhereClr,GetFlagState(Flags,$00000200));
IL_SetFilterSettingsFlagValue(Result,ilffUntestedSet,GetFlagState(Flags,$00000400));
IL_SetFilterSettingsFlagValue(Result,ilffUntestedClr,GetFlagState(Flags,$00000800));
IL_SetFilterSettingsFlagValue(Result,ilffTestingSet,GetFlagState(Flags,$00001000));
IL_SetFilterSettingsFlagValue(Result,ilffTestingClr,GetFlagState(Flags,$00002000));
IL_SetFilterSettingsFlagValue(Result,ilffTestedSet,GetFlagState(Flags,$00004000));
IL_SetFilterSettingsFlagValue(Result,ilffTestedClr,GetFlagState(Flags,$00008000));
IL_SetFilterSettingsFlagValue(Result,ilffDamagedSet,GetFlagState(Flags,$00010000));
IL_SetFilterSettingsFlagValue(Result,ilffDamagedClr,GetFlagState(Flags,$00020000));
IL_SetFilterSettingsFlagValue(Result,ilffRepairedSet,GetFlagState(Flags,$00040000));
IL_SetFilterSettingsFlagValue(Result,ilffRepairedClr,GetFlagState(Flags,$00080000));
IL_SetFilterSettingsFlagValue(Result,ilffPriceChangeSet,GetFlagState(Flags,$00100000));
IL_SetFilterSettingsFlagValue(Result,ilffPriceChangeClr,GetFlagState(Flags,$00200000));
IL_SetFilterSettingsFlagValue(Result,ilffAvailChangeSet,GetFlagState(Flags,$00400000));
IL_SetFilterSettingsFlagValue(Result,ilffAvailChangeClr,GetFlagState(Flags,$00800000));
IL_SetFilterSettingsFlagValue(Result,ilffNotAvailableSet,GetFlagState(Flags,$01000000));
IL_SetFilterSettingsFlagValue(Result,ilffNotAvailableClr,GetFlagState(Flags,$02000000));
IL_SetFilterSettingsFlagValue(Result,ilffLostSet,GetFlagState(Flags,$04000000));
IL_SetFilterSettingsFlagValue(Result,ilffLostClr,GetFlagState(Flags,$08000000));
end;

//==============================================================================
//- command-line options -------------------------------------------------------

Function IL_ThreadSafeCopy(const Value: TILCMDManagerOptions): TILCMDManagerOptions;
begin
Result := Value;
// no need to do anything more atm.
end;

end.
