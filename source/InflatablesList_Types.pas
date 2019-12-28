unit InflatablesList_Types;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  Graphics,
  AuxTypes;

const
  KiB = 1024;
  MiB = 1024 * KiB;

//==============================================================================
//- event prototypes -----------------------------------------------------------

type
  TILObjectL1Event = procedure(Sender: TObject; O1: TObject) of object;
  TILObjectL2Event = procedure(Sender: TObject; O1,O2: TObject) of object;

  TILIndexedObjectL1Event = procedure(Sender: TObject; IndexedObj: TObject; Index: Integer) of object;
  TILIndexedObjectL2Event = procedure(Sender: TObject; Obj: TObject; IndexedObj: TObject; Index: Integer) of object;

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

Function IL_ReconvString(const Str: String; RemoveNullChars: Boolean = True): TILReconvString;

Function IL_ReconvCompareStr(const A,B: TILReconvString): Integer;
Function IL_ReconvCompareText(const A,B: TILReconvString): Integer;
Function IL_ReconvSameStr(const A,B: TILReconvString): Boolean;
Function IL_ReconvSameText(const A,B: TILReconvString): Boolean;

procedure IL_UniqueReconvStr(var Str: TILReconvString);

Function IL_ThreadSafeCopy(const Str: TILReconvString): TILReconvString; overload;

//==============================================================================
//- items ----------------------------------------------------------------------

type
  TLIItemPictureKind  = (ilipkUnknown,ilipkMain,ilipkSecondary,ilipkPackage);
  TLIItemPictureKinds = set of TLIItemPictureKind;

  TILItemType = (ilitUnknown,ilitRing,ilitRingWithHandles,ilitRingSpecial,
                 ilitBall,ilitRider,ilitLounger,ilitLoungerChair,ilitSeat,
                 ilitWings,ilitToy,ilitIsland,ilitIslandExtra,ilitBoat,
                 ilitMattress,ilitBed,ilitChair,ilitSofa,ilitBalloon,ilitOther);

  TILItemManufacturer = (ilimBestway,ilimCrivit{Lidl},ilimIntex,ilimHappyPeople,
                         ilimMondo,ilimPolygroup,ilimSummerWaves,ilimSwimline,
                         ilimVetroPlus,ilimWehncke,ilimWIKY,ilimOthers);

  TILItemFlag = (ilifOwned,ilifWanted,ilifOrdered,ilifBoxed,ilifElsewhere,
                 ilifUntested,ilifTesting,ilifTested,ilifDamaged,ilifRepaired,
                 ilifPriceChange,ilifAvailChange,ilifNotAvailable,ilifLost,
                 ilifDiscarded);

  TILItemFlags = set of TILItemFlag;

  TILItemMaterial = (ilimtUnknown,ilimtPolyvinylchloride{PVC},ilimtPolyester{PES},
                     ilimtPolyetylene{PE},ilimtPolypropylene{PP},
                     ilimtAcrylonitrileButadieneStyrene{ABS},ilimtPolystyren{PS},
                     ilimtPolyurethane{PUR},ilimtFlockedPVC,ilimtLatex,
                     ilimtSilicone,ilimtGumoTex,ilimtOther);

Function IL_ItemPictureKindToStr(PictureKind: TLIItemPictureKind; FullString: Boolean = False): String;

Function IL_ItemTypeToNum(ItemType: TILItemType): Int32;
Function IL_NumToItemType(Num: Int32): TILItemType;

Function IL_ItemManufacturerToNum(ItemManufacturer: TILItemManufacturer): Int32;
Function IL_NumToItemManufacturer(Num: Int32): TILItemManufacturer;

Function IL_SetItemFlagValue(var ItemFlags: TILItemFlags; ItemFlag: TILItemFlag; NewValue: Boolean): Boolean;

Function IL_EncodeItemFlags(ItemFlags: TILItemFlags): UInt32;
Function IL_DecodeItemFlags(Flags: UInt32): TILItemFlags;

Function IL_ItemMaterialToNum(Material: TILItemMaterial): Int32;
Function IL_NumToItemMaterial(Num: Int32): TILItemMaterial;

//==============================================================================
//- item shop parsing ----------------------------------------------------------

const
  IL_ITEMSHOP_PARSING_VARS_COUNT = 8; // never change the number (8 is enough for everyone :P)!

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
    Vars: array[0..Pred(IL_ITEMSHOP_PARSING_VARS_COUNT)] of String;
  end;

Function IL_ExtractFromToNum(ExtractFrom: TILItemShopParsingExtrFrom): Int32;
Function IL_NumToExtractFrom(Num: Int32): TILItemShopParsingExtrFrom;

Function IL_ExtrMethodToNum(ExtrMethod: TILItemShopParsingExtrMethod): Int32;
Function IL_NumToExtrMethod(Num: Int32): TILItemShopParsingExtrMethod;

Function IL_ThreadSafeCopy(const Value: TILItemShopParsingExtrSett): TILItemShopParsingExtrSett; overload;

Function IL_ThreadSafeCopy(const Value: TILItemShopParsingVariables): TILItemShopParsingVariables; overload;

//==============================================================================
//- item shop ------------------------------------------------------------------

type
  TILItemShopUpdateResult = (
    ilisurSuccess,    // lime     ilurSuccess
    ilisurMildSucc,   // green    ilurSuccess on untracked
    ilisurDataFail,   // blue     ilurNoLink, ilurNoData
    ilisurSoftFail,   // yellow   ilurFailAvailSearch, ilurFailAvailValGet
    ilisurHardFail,   // orange   ilurFailSearch, ilurFailValGet
    ilisurDownload,   // purple   ilurFailDown
    ilisurParsing,    // red      ilurFailParse
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
//- searching ------------------------------------------------------------------

type
  TILItemSearchResult = (ilisrNone,ilisrItemPicFile,ilisrSecondaryPicFile,
    ilisrPackagePicFile,ilisrType,ilisrTypeSpec,ilisrPieces,ilisrUserID,
    ilisrManufacturer,ilisrManufacturerStr,ilisrTextID,ilisrNumID,
    ilisrFlagOwned,ilisrFlagWanted,ilisrFlagOrdered,ilisrFlagBoxed,
    ilisrFlagElsewhere,ilisrFlagUntested,ilisrFlagTesting,ilisrFlagTested,
    ilisrFlagDamaged,ilisrFlagRepaired,ilisrFlagPriceChange,
    ilisrFlagAvailChange,ilisrFlagNotAvailable,ilisrFlagLost,ilisrFlagDiscarded,
    ilisrTextTag,ilisrNumTag,ilisrWantedLevel,ilisrVariant,ilisrVariantTag,
    ilisrUnitWeight,ilisrMaterial,ilisrThickness,ilisrSizeX,ilisrSizeY,
    ilisrSizeZ,ilisrNotes,ilisrReviewURL,ilisrUnitPriceDefault,ilisrRating,
    ilisrRatingDetails,ilisrSelectedShop);

Function IL_WrapSearchResult(Val: TILItemSearchResult): TILItemSearchResult;

type
  TILAdvItemSearchResult = (ilaisrListIndex,ilaisrUniqueID,ilaisrTimeOfAdd,
    ilaisrDescriptor,ilaisrTitleStr,ilaisrPictures,ilaisrMainPictureFile,
    ilaisrCurrSecPictureFile,ilaisrPackagePictureFile,ilaisrType,ilaisrTypeSpec,
    ilaisrTypeStr,ilaisrPieces,ilaisrUserID,ilaisrManufacturer,
    ilaisrManufacturerStr,ilaisrManufacturerTag,ilaisrTextID,ilaisrNumID,
    ilaisrIDStr,ilaisrFlags,ilaisrFlagOwned,ilaisrFlagWanted,ilaisrFlagOrdered,
    ilaisrFlagBoxed,ilaisrFlagElsewhere,ilaisrFlagUntested,ilaisrFlagTesting,
    ilaisrFlagTested,ilaisrFlagDamaged,ilaisrFlagRepaired,ilaisrFlagPriceChange,
    ilaisrFlagAvailChange,ilaisrFlagNotAvailable,ilaisrFlagLost,
    ilaisrFlagDiscarded,ilaisrTextTag,ilaisrNumTag,ilaisrWantedLevel,
    ilaisrVariant,ilaisrVariantTag,ilaisrUnitWeight,ilaisrTotalWeight,
    ilaisrTotalWeightStr,ilaisrMaterial,ilaisrThickness,ilaisrSizeX,ilaisrSizeY,
    ilaisrSizeZ,ilaisrTotalSize,ilaisrSizeStr,ilaisrNotes,ilaisrReviewURL,
    ilaisrUnitPriceDefault,ilaisrRating,ilaisrRatingDetails,ilaisrUnitPrice,
    ilaisrUnitPriceLowest,ilaisrTotalPriceLowest,ilaisrUnitPriceHighest,
    ilaisrTotalPriceHighest,ilaisrUnitPriceSel,ilaisrTotalPriceSel,
    ilaisrTotalPrice,ilaisrAvailableLowest,ilaisrAvailableHighest,
    ilaisrAvailableSel,ilaisrShopCount,ilaisrShopCountStr,ilaisrUsefulShopCount,
    ilaisrUsefulShopRatio,ilaisrSelectedShop,ilaisrWorstUpdateResult);

  TILAdvItemSearchResults = set of TILAdvItemSearchResult;

  TILAdvShopSearchResult = (ilassrListIndex,ilassrSelected,ilassrUntracked,
    ilassrAltDownMethod,ilassrName,ilassrShopURL,ilassrItemURL,ilassrAvailable,
    ilassrPrice,ilassrNotes,ilassrLastUpdResult,ilassrLastUpdMessage,
    ilassrLastUpdTime,ilassrParsingVariables,ilassrParsingTemplateRef,
    ilassrIgnoreParsErrors,{deep scan...}ilassrAvailHistory,ilassrPriceHistory,
    ilassrAvailExtrSettings,ilassrPriceExtrSettings,ilassrAvailFinder,
    ilassrPriceFinder);

  TILAdvShopSearchResults = set of TILAdvShopSearchResult;

  TILAdvSearchParsTemplResolve = Function(const Template: String): Pointer of object;
  TILAdvSearchCompareFunc = Function(const Value: String; IsText,IsEditable,IsCalculated: Boolean; const UnitStr: String = ''): Boolean of object;

  TILAdvSearchSettings = record
    Text:             String;
    PartialMatch:     Boolean;
    CaseSensitive:    Boolean;
    TextsOnly:        Boolean;
    EditablesOnly:    Boolean;
    SearchCalculated: Boolean;
    IncludeUnits:     Boolean;
    SearchShops:      Boolean;
    DeepScan:         Boolean;  // parsing settings, variables, incl. references
    // internals
    ParsTemplResolve: TILAdvSearchParsTemplResolve;
    CompareFunc:      TILAdvSearchCompareFunc;
  end;

  TILAdvSearchResultShop = record
    ShopIndex:  Integer;
    ShopValue:  TILAdvShopSearchResults;
  end;

  TILAdvSearchResult = record
    ItemIndex:  Integer;
    ItemValue:  TILAdvItemSearchResults;
    Shops:      array of TILAdvSearchResultShop;
  end;

  TILAdvSearchResults = array of TILAdvSearchResult;

Function IL_ThreadSafeCopy(const Value: TILAdvSearchSettings): TILAdvSearchSettings; overload;  

//==============================================================================
//- sorting --------------------------------------------------------------------  

type
  TILItemValueTag = (
    ilivtNone,ilivtItemEncrypted,ilivtUniqueID,ilivtTimeOfAdd,ilivtDescriptor,
    ilivtMainPicFilePres,ilivtMainPictureFile,ilivtMainPictureThumb,
    ilivtPackPicFilePres,ilivtPackPictureFile,ilivtPackPictureThumb,
    ilivtCurrSecPicPres,ilivtCurrSecPicFile,ilivtCurrSecPicThumb,
    ilivtPictureCount,ilivtSecPicCount,ilivtSecPicThumbCount,ilivtItemType,
    ilivtItemTypeSpec,ilivtPieces,ilivtUserID,ilivtManufacturer,
    ilivtManufacturerStr,ilivtTextID,ilivtNumID,ilivtIDStr,ilivtFlagOwned,
    ilivtFlagWanted,ilivtFlagOrdered,ilivtFlagBoxed,ilivtFlagElsewhere,
    ilivtFlagUntested,ilivtFlagTesting,ilivtFlagTested,ilivtFlagDamaged,
    ilivtFlagRepaired,ilivtFlagPriceChange,ilivtFlagAvailChange,
    ilivtFlagNotAvailable,ilivtFlagLost,ilivtFlagDiscarded,ilivtTextTag,
    ilivtNumTag,ilivtWantedLevel,ilivtVariant,ilivtVariantTag,ilivtUnitWeight,
    ilivtTotalWeight,ilivtMaterial,ilivtThickness,ilivtSizeX,ilivtSizeY,
    ilivtSizeZ,ilivtTotalSize,ilivtNotes,ilivtReviewURL,ilivtReview,
    ilivtUnitPriceDefault,ilivtRating,ilivtRatingDetails,ilivtUnitPriceLowest,
    ilivtTotalPriceLowest,ilivtUnitPriceSel,ilivtTotalPriceSel,ilivtTotalPrice,
    ilivtAvailable,ilivtShopCount,ilivtUsefulShopCount,ilivtUsefulShopRatio,
    ilivtSelectedShop,ilivtWorstUpdateResult);

  TILSortingItem = record
    ItemValueTag: TILItemValueTag;
    Reversed:     Boolean;
  end;

  TILSortingSettings = record
    Count:  Integer;
    Items:  array[0..29] of TILSortingItem; // length of this array will newer change ;)
  end;

  TILSortingProfile = record
    Name:     String;
    Settings: TILSortingSettings;
  end;

  TILSortingProfiles = array of TILSortingProfile;

Function IL_SameSortingSettings(A,B: TILSortingSettings): Boolean;

Function IL_ItemValueTagToNum(ItemValueTag: TILItemValueTag): Int32;
Function IL_NumToItemValueTag(Num: Int32): TILItemValueTag;

Function IL_ThreadSafeCopy(const Value: TILSortingProfile): TILSortingProfile; overload;

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
    ilffNotAvailableSet,ilffNotAvailableClr,ilffLostSet,ilffLostClr,
    ilffDiscardedSet,ilffDiscardedClr);

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
//- static settings ------------------------------------------------------------

const
  IL_STATIC_SETTINGS_TAGS: array[0..8] of String =
    ('NPC','TSC','SVP','LDP','NSV','NBC','NUL','LOR','NPR');

  IL_DYNAMIC_SETTINGS_TAGS: array[0..4] of String =
    ('l.cmp','l.enc','l.sav','s.rev','s.cas');

type
  TILStaticManagerSettings = record
    // command-line options
    NoPictures:       Boolean;
    TestCode:         Boolean;
    SavePages:        Boolean;
    LoadPages:        Boolean;
    NoSave:           Boolean;
    NoBackup:         Boolean;
    NoUpdateAutoLog:  Boolean;
    ListOverride:     Boolean;
    NoParse:          Boolean;
    // automatically filled
    DefaultPath:      String; // initialized to program path
    ListPath:         String; // filled with list path (without file name)
    ListFile:         String; // file, where the list will be saved, or was loaded from
    ListName:         String; // list file without extension
    InstanceID:       String; // string unique for the program instance (calculated from ListPath)
    // folders
    PicturesPath:     String;
    BackupPath:       String;
    SavedPagesPath:   String;
    TempPath:         String; // path to program temporary folder
  end;

Function IL_ThreadSafeCopy(const Value: TILStaticManagerSettings): TILStaticManagerSettings; overload;

//==============================================================================
//- preload information --------------------------------------------------------

type
  TILPreloadInfoVersion = packed record
    case Boolean of
      True:   (Full:    Int64);
      False:  (Major:   UInt16;
               Minor:   UInt16;
               Release: UInt16;
               Build:   UInt16);
  end;

  TILPreloadResultFlag = (ilprfError,ilprfInvalidFile,ilprfExtInfo,ilprfEncrypted,
                          ilprfCompressed,ilprfPictures,ilprfSlowLoad);

  TILPreloadResultFlags = set of TILPreloadResultFlag;

  TILPreloadInfo = record
    // basic info
    ResultFlags:  TILPreloadResultFlags;
    FileSize:     UInt64;
    Signature:    UInt32;
    Structure:    UInt32;
    // extended info, valid only when ResultFlags contains ilprfExtInfo
    Flags:        UInt32;
    Version:      TILPreloadInfoVersion;
    TimeRaw:      Int64;
    Time:         TDateTime;
    TimeStr:      String;
  end;

Function IL_ThreadSafeCopy(const Value: TILPreloadInfo): TILPreloadInfo; overload;

//==============================================================================
//- threaded IO ----------------------------------------------------------------

type
  TILLoadingResult = (illrSuccess,illrFailed,illrWrongPassword);

  TILLoadingDoneEvent = procedure(LoadingResult: TILLoadingResult) of object;

//==============================================================================
//- list and item flags --------------------------------------------------------

const
  IL_LIST_FLAG_BITMASK_ENCRYPTED  = UInt32($00000001);
  IL_LIST_FLAG_BITMASK_COMPRESSED = UInt32($00000002);

  IL_ITEM_FLAG_BITMASK_ENCRYPTED  = UInt32($00000001);

//==============================================================================
//- encryption -----------------------------------------------------------------

type
  TILPasswordRequest = Function(Sender: TObject; out Pswd: String): Boolean of object;

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

Function IL_ReconvString(const Str: String; RemoveNullChars: Boolean = True): TILReconvString;
var
  i:  Integer;
begin
Result.Str := Str;
UniqueString(Result.Str);
// null characters might break some functions
If RemoveNullChars then
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

//------------------------------------------------------------------------------

Function IL_ThreadSafeCopy(const Str: TILReconvString): TILReconvString;
begin
Result := Str;
IL_UniqueReconvStr(Result);
end;

//==============================================================================
//- list item ------------------------------------------------------------------

Function IL_ItemPictureKindToStr(PictureKind: TLIItemPictureKind; FullString: Boolean = False): String;
begin
case PictureKind of
  ilipkMain:      If FullString then Result := 'Item picture'
                    else Result := 'item';
  ilipkSecondary: If FullString then Result := 'Secondary picture'
                    else Result := 'secondary';
  ilipkPackage:   If FullString then Result := 'Package picture'
                    else Result := 'package';
else
  Result := '';
end;
end;

//------------------------------------------------------------------------------

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
  ilitIslandExtra:      Result := 17;
  ilitRingSpecial:      Result := 18;
  ilitSofa:             Result := 19;
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
  17: Result := ilitIslandExtra;
  18: Result := ilitRingSpecial;
  19: Result := ilitSofa;
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
  ilimCrivit:       Result := 11;
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
  11: Result := ilimCrivit;
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
SetFlagStateValue(Result,$00004000,ilifDiscarded in ItemFlags);
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
IL_SetItemFlagValue(Result,ilifDiscarded,GetFlagState(Flags,$00004000));
end;

//------------------------------------------------------------------------------


Function IL_ItemMaterialToNum(Material: TILItemMaterial): Int32;
begin
case Material of
  ilimtOther:                         Result := 1;
  ilimtPolyvinylchloride:             Result := 2;
  ilimtFlockedPVC:                    Result := 3;
  ilimtLatex:                         Result := 4;
  ilimtSilicone:                      Result := 5;
  ilimtGumoTex:                       Result := 6;
  ilimtPolyester:                     Result := 7;
  ilimtPolyetylene:                   Result := 8;
  ilimtPolypropylene:                 Result := 9;
  ilimtAcrylonitrileButadieneStyrene: Result := 10;
  ilimtPolystyren:                    Result := 11;
  // new
  ilimtPolyurethane:                  Result := 12;
else
 {ilimUnknown}
  Result := 0;
end;
end;

//------------------------------------------------------------------------------

Function IL_NumToItemMaterial(Num: Int32): TILItemMaterial;
begin
case Num of
  1:  Result := ilimtOther;
  2:  Result := ilimtPolyvinylchloride;
  3:  Result := ilimtFlockedPVC;
  4:  Result := ilimtLatex;
  5:  Result := ilimtSilicone;
  6:  Result := ilimtGumoTex;
  7:  Result := ilimtPolyester;
  8:  Result := ilimtPolyetylene;
  9:  Result := ilimtPolypropylene;
  10: Result := ilimtAcrylonitrileButadieneStyrene;
  11: Result := ilimtPolystyren;
  12: Result := ilimtPolyurethane;
else
  Result := ilimtUnknown;
end;
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

//------------------------------------------------------------------------------

Function IL_ThreadSafeCopy(const Value: TILItemShopParsingExtrSett): TILItemShopParsingExtrSett;
begin
Result := Value;
UniqueString(Result.ExtractionData);
UniqueString(Result.NegativeTag);
end;

//------------------------------------------------------------------------------

Function IL_ThreadSafeCopy(const Value: TILItemShopParsingVariables): TILItemShopParsingVariables;
var
  i:  Integer;
begin
For i := Low(Value.Vars) to High(Value.Vars) do
  begin
    Result.Vars[i] := Value.Vars[i];
    UniqueString(Result.Vars[i]);
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
  ilisurParsing:  Result := 5;
  ilisurFatal:    Result := 6;
  ilisurDownload: Result := 7;
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
  5:  Result := ilisurParsing;
  6:  Result := ilisurFatal;
  7:  Result := ilisurDownload;
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
  ilisurDownload: Result := clPurple;
  ilisurParsing:  Result := clRed;
  ilisurFatal:    Result := clBlack;
else
 {ilisurSuccess}
  Result := clLime;
end;
end;

//==============================================================================
//- searching ------------------------------------------------------------------

Function IL_WrapSearchResult(Val: TILItemSearchResult): TILItemSearchResult;
begin
If Ord(Val) < Ord(Low(TILItemSearchResult)) then
  Result := High(TILItemSearchResult)
else If Ord(Val) > Ord(High(TILItemSearchResult)) then
  Result := Low(TILItemSearchResult)
else
  Result := Val;
end;

//------------------------------------------------------------------------------

Function IL_ThreadSafeCopy(const Value: TILAdvSearchSettings): TILAdvSearchSettings;
begin
Result := Value;
UniqueString(Result.Text);
end;

//==============================================================================
//- sorting --------------------------------------------------------------------

Function IL_SameSortingSettings(A,B: TILSortingSettings): Boolean;
var
  i:  Integer;
begin
If A.Count = B.Count then
  begin
    Result := True;
    For i := 0 to Pred(A.Count) do
      If (A.Items[i].ItemValueTag <> B.Items[i].ItemValueTag) or
        (A.Items[i].Reversed <> B.Items[i].Reversed) then
        begin
          Result := False;
          Break{For i};
        end;
  end
else Result := False;
end;

//------------------------------------------------------------------------------

Function IL_ItemValueTagToNum(ItemValueTag: TILItemValueTag): Int32;
begin
{
  no, the numbers are not in the correct order  
  MAX = 70
}
case ItemValueTag of
  ilivtItemEncrypted:         Result := 63;
  ilivtUniqueID:              Result := 57;
  ilivtTimeOfAdd:             Result := 3;
  ilivtDescriptor:            Result := 66;
  ilivtMainPicFilePres:       Result := 36;
  ilivtMainPictureFile:       Result := 35;
  ilivtMainPictureThumb:      Result := 1;
  ilivtPackPicFilePres:       Result := 38;
  ilivtPackPictureFile:       Result := 37;
  ilivtPackPictureThumb:      Result := 2;
  ilivtCurrSecPicPres:        Result := 61;
  ilivtCurrSecPicFile:        Result := 60;
  ilivtCurrSecPicThumb:       Result := 59;
  ilivtPictureCount:          Result := 67;
  ilivtSecPicCount:           Result := 68;
  ilivtSecPicThumbCount:      Result := 69;
  ilivtItemType:              Result := 4;
  ilivtItemTypeSpec:          Result := 5;
  ilivtPieces:                Result := 6;
  ilivtUserID:                Result := 64;
  ilivtManufacturer:          Result := 7;
  ilivtManufacturerStr:       Result := 8;
  ilivtTextID:                Result := 55;
  ilivtNumID:                 Result := 9;
  ilivtIDStr:                 Result := 56;
  ilivtFlagOwned:             Result := 10;
  ilivtFlagWanted:            Result := 11;
  ilivtFlagOrdered:           Result := 12;
  ilivtFlagBoxed:             Result := 13;
  ilivtFlagElsewhere:         Result := 14;
  ilivtFlagUntested:          Result := 15;
  ilivtFlagTesting:           Result := 16;
  ilivtFlagTested:            Result := 17;
  ilivtFlagDamaged:           Result := 18;
  ilivtFlagRepaired:          Result := 19;
  ilivtFlagPriceChange:       Result := 20;
  ilivtFlagAvailChange:       Result := 21;
  ilivtFlagNotAvailable:      Result := 22;
  ilivtFlagLost:              Result := 48;
  ilivtFlagDiscarded:         Result := 54;
  ilivtTextTag:               Result := 23;
  ilivtNumTag:                Result := 58;
  ilivtWantedLevel:           Result := 24;
  ilivtVariant:               Result := 25;
  ilivtVariantTag:            Result := 65;
  ilivtUnitWeight:            Result := 30;
  ilivtTotalWeight:           Result := 31;
  ilivtMaterial:              Result := 52;
  ilivtThickness:             Result := 53;
  ilivtSizeX:                 Result := 26;
  ilivtSizeY:                 Result := 27;
  ilivtSizeZ:                 Result := 28;
  ilivtTotalSize:             Result := 29;
  ilivtNotes:                 Result := 32;
  ilivtReviewURL:             Result := 33;
  ilivtReview:                Result := 34;
  ilivtUnitPriceDefault:      Result := 39;
  ilivtRating:                Result := 62;
  ilivtRatingDetails:         Result := 70;
  ilivtUnitPriceLowest:       Result := 40;
  ilivtTotalPriceLowest:      Result := 41;
  ilivtUnitPriceSel:          Result := 42;
  ilivtTotalPriceSel:         Result := 43;
  ilivtTotalPrice:            Result := 44;
  ilivtAvailable:             Result := 45;
  ilivtShopCount:             Result := 46;
  ilivtUsefulShopCount:       Result := 50;
  ilivtUsefulShopRatio:       Result := 51;
  ilivtSelectedShop:          Result := 47;
  ilivtWorstUpdateResult:     Result := 49;
else
  {ilivtNone}
  Result := 0;
end;
end;

//------------------------------------------------------------------------------

Function IL_NumToItemValueTag(Num: Int32): TILItemValueTag;
begin
case Num of
  63: Result := ilivtItemEncrypted;
  57: Result := ilivtUniqueID;
  3:  Result := ilivtTimeOfAdd;
  66: Result := ilivtDescriptor;
  36: Result := ilivtMainPicFilePres;
  35: Result := ilivtMainPictureFile;
  1:  Result := ilivtMainPictureThumb;
  38: Result := ilivtPackPicFilePres;
  37: Result := ilivtPackPictureFile;
  2:  Result := ilivtPackPictureThumb;
  61: Result := ilivtCurrSecPicPres; 
  60: Result := ilivtCurrSecPicFile;
  59: Result := ilivtCurrSecPicThumb;
  67: Result := ilivtPictureCount;
  68: Result := ilivtSecPicCount;
  69: Result := ilivtSecPicThumbCount;
  4:  Result := ilivtItemType;
  5:  Result := ilivtItemTypeSpec;
  6:  Result := ilivtPieces;
  64: Result := ilivtUserID;
  7:  Result := ilivtManufacturer;
  8:  Result := ilivtManufacturerStr;
  55: Result := ilivtTextID;
  9:  Result := ilivtNumID;
  56: Result := ilivtIDStr;
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
  48: Result := ilivtFlagLost;
  54: Result := ilivtFlagDiscarded;
  23: Result := ilivtTextTag;
  58: Result := ilivtNumTag;
  24: Result := ilivtWantedLevel;
  25: Result := ilivtVariant;
  65: Result := ilivtVariantTag;
  30: Result := ilivtUnitWeight;
  31: Result := ilivtTotalWeight;
  52: Result := ilivtMaterial;
  53: Result := ilivtThickness;
  26: Result := ilivtSizeX;
  27: Result := ilivtSizeY;
  28: Result := ilivtSizeZ;
  29: Result := ilivtTotalSize;
  32: Result := ilivtNotes;
  33: Result := ilivtReviewURL;
  34: Result := ilivtReview;
  39: Result := ilivtUnitPriceDefault;
  62: Result := ilivtRating;
  70: Result := ilivtRatingDetails; 
  40: Result := ilivtUnitPriceLowest;
  41: Result := ilivtTotalPriceLowest;
  42: Result := ilivtUnitPriceSel;
  43: Result := ilivtTotalPriceSel;
  44: Result := ilivtTotalPrice;
  45: Result := ilivtAvailable;
  46: Result := ilivtShopCount;
  50: Result := ilivtUsefulShopCount;
  51: Result := ilivtUsefulShopRatio;
  47: Result := ilivtSelectedShop;
  49: Result := ilivtWorstUpdateResult;
else
  Result := ilivtNone;
end;
end;

//------------------------------------------------------------------------------

Function IL_ThreadSafeCopy(const Value: TILSortingProfile): TILSortingProfile;
begin
Result := Value;
UniqueString(Result.Name);
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
SetFlagStateValue(Result,$10000000,ilffDiscardedSet in FilterFlags);
SetFlagStateValue(Result,$20000000,ilffDiscardedClr in FilterFlags);
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
IL_SetFilterSettingsFlagValue(Result,ilffDiscardedSet,GetFlagState(Flags,$10000000));
IL_SetFilterSettingsFlagValue(Result,ilffDiscardedClr,GetFlagState(Flags,$20000000));
end;

//==============================================================================
//- static settings ------------------------------------------------------------

Function IL_ThreadSafeCopy(const Value: TILStaticManagerSettings): TILStaticManagerSettings;
begin
Result := Value;
UniqueString(Result.TempPath);
UniqueString(Result.DefaultPath);
UniqueString(Result.ListPath);
UniqueString(Result.ListFile);
UniqueString(Result.ListName);
UniqueString(Result.InstanceID);
UniqueString(Result.PicturesPath);
UniqueString(Result.BackupPath);
UniqueString(Result.SavedPagesPath);
end;

//==============================================================================
//- preload information --------------------------------------------------------

Function IL_ThreadSafeCopy(const Value: TILPreloadInfo): TILPreloadInfo;
begin
Result := Value;
UniqueString(Result.TimeStr);
end;

end.
