{-------------------------------------------------------------------------------

  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at http://mozilla.org/MPL/2.0/.

-------------------------------------------------------------------------------}
{===============================================================================

  Counted dynamic arrays

    Counted dynamic array of String values

  ©František Milt 2019-01-26

  Version 1.0.3

  Dependencies:
    AuxTypes    - github.com/ncs-sniper/Lib.AuxTypes
    ListSorters - github.com/ncs-sniper/Lib.ListSorters

===============================================================================}
unit CountedDynArrayString;

{$INCLUDE '.\CountedDynArrays_defs.inc'}

interface

uses
  AuxTypes,
  CountedDynArrays;

type
  TStringCountedDynArray = record
    Arr:    array of String;
    SigA:   UInt32;
    Count:  Integer;
    Data:   PtrInt;
    SigB:   UInt32;
  end;
  PStringCountedDynArray = ^TStringCountedDynArray;

  TCDABaseType = String;
  PCDABaseType = PString;

  TCDAArrayType = TStringCountedDynArray;
  PCDAArrayType = PStringCountedDynArray;

{$DEFINE CDA_DisableFunc_ItemCompareSortFunc}
{$DEFINE CDA_DisableFunc_ItemUnique}

{$DEFINE CDA_DisableFunc_IndexOf}
{$DEFINE CDA_DisableFunc_Remove}
{$DEFINE CDA_DisableFunc_Same}
{$DEFINE CDA_DisableFunc_Sort}

{$DEFINE CDA_Interface}
{$INCLUDE '.\CountedDynArrays.inc'}
{$UNDEF CDA_Interface}

// overriden functions
Function CDA_IndexOf(const Arr: TCDAArrayType; const Item: TCDABaseType; CaseSensitive: Boolean = False): Integer; overload;
Function CDA_Remove(var Arr: TCDAArrayType; const Item: TCDABaseType; CaseSensitive: Boolean = False): Integer; overload;
Function CDA_Same(const Arr1, Arr2: TCDAArrayType; CaseSensitive: Boolean = False): Boolean; overload;
procedure CDA_Sort(var Arr: TCDAArrayType; Reversed: Boolean = False; CaseSensitive: Boolean = False); overload;

implementation

uses
  SysUtils,
  ListSorters;

{$IFDEF FPC_DisableWarns}
  {$DEFINE FPCDWM}
  {$DEFINE W5024:={$WARN 5024 OFF}} // Parameter "$1" not used   
  {$PUSH}{$WARN 2005 OFF} // Comment level $1 found
  {$IF Defined(FPC) and (FPC_FULLVERSION >= 30000)}
    {$DEFINE W5093:={$WARN 5093 OFF}} // Function result variable of a managed type does not seem to initialized
    {$DEFINE W5094:={$WARN 5094 OFF}} // Function result variable of a managed type does not seem to initialized
    {$DEFINE W5060:=}
  {$ELSE}
    {$DEFINE W5093:=}
    {$DEFINE W5094:=}
    {$DEFINE W5060:={$WARN 5060 OFF}} // Function result variable does not seem to be initialized
  {$IFEND}
  {$POP}
{$ENDIF}

Function CDA_CompareFunc(const A,B: String; CaseSensitive: Boolean): Integer;
begin
If CaseSensitive then
  Result := -AnsiCompareStr(A,B)
else
  Result := -AnsiCompareText(A,B);
end;

//------------------------------------------------------------------------------

Function CDA_ItemCompareFuncCS(Context: Pointer; Idx1,Idx2: Integer): Integer;{$IFDEF CanInline} inline; {$ENDIF}
begin
Result := CDA_CompareFunc(TCDAArrayType(Context^).Arr[Idx1],TCDAArrayType(Context^).Arr[Idx2],True);
end;

//------------------------------------------------------------------------------

Function CDA_ItemCompareFuncCI(Context: Pointer; Idx1,Idx2: Integer): Integer;{$IFDEF CanInline} inline; {$ENDIF}
begin
Result := CDA_CompareFunc(TCDAArrayType(Context^).Arr[Idx1],TCDAArrayType(Context^).Arr[Idx2],True);
end;

//------------------------------------------------------------------------------

procedure CDA_ItemUnique(var Item: TCDABaseType); {$IFDEF CanInline} inline; {$ENDIF}
begin
UniqueString(Item);
end;

//------------------------------------------------------------------------------

{$DEFINE CDA_Implementation}
{$INCLUDE '.\CountedDynArrays.inc'}
{$UNDEF CDA_Implementation}

//------------------------------------------------------------------------------

Function CDA_IndexOf(const Arr: TCDAArrayType; const Item: TCDABaseType; CaseSensitive: Boolean = False): Integer;
var
  i:  Integer;
begin
Result := -1;
// CDA_High checks for validity, -1 is returned for invalid array
For i := CDA_Low(Arr) to CDA_High(Arr) do
  If CDA_CompareFunc(Arr.Arr[i],Item,CaseSensitive) = 0 then
    begin
      Result := i;
      Break{For i};
    end;
end;

//------------------------------------------------------------------------------

Function CDA_Remove(var Arr: TCDAArrayType; const Item: TCDABaseType; CaseSensitive: Boolean = False): Integer;
begin
CDA_Validate(Arr);
Result := CDA_IndexOf(Arr,Item,CaseSensitive);
If CDA_CheckIndex(Arr,Result) then
  CDA_Delete(Arr,Result);
end;

//------------------------------------------------------------------------------

Function CDA_Same(const Arr1, Arr2: TCDAArrayType; CaseSensitive: Boolean = False): Boolean;
var
  i:  Integer;
begin
If CDA_Valid(Arr1) and CDA_Valid(Arr2) and (CDA_Count(Arr1) = CDA_Count(Arr2)) then
  begin
    Result := True;
    For i := CDA_Low(Arr1) to CDA_High(Arr1) do
      If CDA_CompareFunc(Arr1.Arr[i],Arr2.Arr[i],CaseSensitive) <> 0 then
        begin
          Result := False;
          Break{For i};
        end;
  end
else Result := False;
end;

//------------------------------------------------------------------------------

procedure CDA_Sort(var Arr: TCDAArrayType; Reversed: Boolean = False; CaseSensitive: Boolean = False);
var
  Sorter: TListQuickSorter;
begin
CDA_Validate(Arr);
If CaseSensitive then
  Sorter := TListQuickSorter.Create(@Arr,CDA_ItemCompareFuncCS,CDA_ItemExchangeSortFunc)
else
  Sorter := TListQuickSorter.Create(@Arr,CDA_ItemCompareFuncCI,CDA_ItemExchangeSortFunc);
try
  Sorter.Reversed := Reversed;
  Sorter.Sort(CDA_Low(Arr),CDA_High(Arr));
finally
  Sorter.Free;
end;
end;

end.
