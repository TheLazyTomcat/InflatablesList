unit IL_Types;

{$INCLUDE '.\IL_defs.inc'}

interface

uses
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
//- list item ------------------------------------------------------------------

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

Function IL_ExtractFromToNum(ExtractFrom: TILItemShopParsingExtrFrom): Int32;
Function IL_NumToExtractFrom(Num: Int32): TILItemShopParsingExtrFrom;

Function IL_ExtrMethodToNum(ExtrMethod: TILItemShopParsingExtrMethod): Int32;
Function IL_NumToExtrMethod(Num: Int32): TILItemShopParsingExtrMethod;

//==============================================================================
//- item shop ------------------------------------------------------------------



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

Function IL_SetItemFlagValue(var ItemFlags: TILItemFlags; ItemFlag: TILItemFlag; NewValue: Boolean): Boolean; overload;
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
//- command-line options -------------------------------------------------------

Function IL_ThreadSafeCopy(const Value: TILCMDManagerOptions): TILCMDManagerOptions;
begin
Result := Value;
// no need to do anything more atm.
end;

end.
