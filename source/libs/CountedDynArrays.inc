{-------------------------------------------------------------------------------

  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at http://mozilla.org/MPL/2.0/.

-------------------------------------------------------------------------------}
{===============================================================================

  Counted Dynamic Arrays

    Main implementation template

  Version 1.2.1 (2019-08-19)
  
  Last changed 2019-08-19

  ©2018-2019 František Milt

  Contacts:
    František Milt: frantisek.milt@gmail.com

  Support:
    If you find this code useful, please consider supporting its author(s) by
    making a small donation using the following link(s):

      https://www.paypal.me/FMilt

  Changelog:
    For detailed changelog and history please refer to this git repository:

      github.com/TheLazyTomcat/Lib.AuxClasses

  Dependencies:
    AuxTypes    - github.com/TheLazyTomcat/Lib.AuxTypes
    AuxClasses  - github.com/TheLazyTomcat/Lib.AuxClasses    
    ListSorters - github.com/TheLazyTomcat/Lib.ListSorters
    StrRect     - github.com/TheLazyTomcat/Lib.StrRect

===============================================================================}

{===============================================================================
--------------------------------------------------------------------------------
    Main record structure (common to all types)
--------------------------------------------------------------------------------
===============================================================================}

{$IFDEF CDA_Structure}
    Signature:    TCDASignature;
    Arr:          array of TCDABaseType;
    Count:        Integer;
    UserData:     PtrInt;
    InternalPtr:  Pointer;
    InternalInt:  PtrInt;
    Checksum:     TCDAChecksum;
{$ENDIF}

{===============================================================================
--------------------------------------------------------------------------------
    Interface section (declarations of functions)
--------------------------------------------------------------------------------
===============================================================================}

{$IFDEF CDA_Interface}

// internal structure manipulation
{$IFNDEF CDA_FuncReintroduce_Valid}
  Function CDA_Valid(const Arr: TCDAArrayType): Boolean; overload;{$IF Defined(CanInline) and Defined(FPC)} inline;{$IFEND}{$ENDIF}
{$IFNDEF CDA_FuncReintroduce_Validate}
  procedure CDA_Validate(var Arr: TCDAArrayType); overload;{$IFDEF CanInline} inline;{$ENDIF}{$ENDIF}
{$IFNDEF CDA_FuncReintroduce_Init}
  procedure CDA_Init(out Arr: TCDAArrayType); overload;{$ENDIF}

// user data access
{$IFNDEF CDA_FuncReintroduce_GetUserData}
  Function CDA_GetUserData(const Arr: TCDAArrayType): PtrInt; overload;{$IFDEF CanInline} inline;{$ENDIF}{$ENDIF}
{$IFNDEF CDA_FuncReintroduce_SetUserData}
  procedure CDA_SetUserData(var Arr: TCDAArrayType; UserData: PtrInt); overload;{$IFDEF CanInline} inline;{$ENDIF}{$ENDIF}

// capacity and count access
{$IFNDEF CDA_FuncReintroduce_Length}
  Function CDA_Length(const Arr: TCDAArrayType): Integer; overload;{$ENDIF}
{$IFNDEF CDA_FuncReintroduce_Capacity}
  Function CDA_Capacity(const Arr: TCDAArrayType): Integer; overload;{$IFDEF CanInline} inline;{$ENDIF}{$ENDIF}
{$IFNDEF CDA_FuncReintroduce_FreeCapacity}
  Function CDA_CapacityFree(const Arr: TCDAArrayType): Integer; overload;{$ENDIF}
{$IFNDEF CDA_FuncReintroduce_Count}
  Function CDA_Count(const Arr: TCDAArrayType): Integer; overload;{$ENDIF}

// explicit changing of capacity and count
{$IFNDEF CDA_FuncReintroduce_SetLength}
  procedure CDA_SetLength(var Arr: TCDAArrayType; NewLength: Integer); overload;{$ENDIF}
{$IFNDEF CDA_FuncReintroduce_SetCapacity}
  procedure CDA_SetCapacity(var Arr: TCDAArrayType; NewCapacity: Integer); overload;{$IFDEF CanInline} inline;{$ENDIF}{$ENDIF}
{$IFNDEF CDA_FuncReintroduce_SetCount}
  procedure CDA_SetCount(var Arr: TCDAArrayType; NewCount: Integer); overload;{$ENDIF}

// implicit changing of capacity
{$IFNDEF CDA_FuncReintroduce_Grow}
  Function CDA_Grow(var Arr: TCDAArrayType; GrowMode: TCDAGrowMode = agmFast; GrowFactor: Single = 1.0; DeltaMin: Integer = 1): Integer; overload;{$ENDIF}
{$IFNDEF CDA_FuncReintroduce_Shrink}
  procedure CDA_Shrink(var Arr: TCDAArrayType; ShrinkMode: TCDAShrinkMode = asmNormal); overload;{$ENDIF}

// secure copy
{$IFNDEF CDA_FuncReintroduce_UniqueArray}
  procedure CDA_UniqueArray(var Arr: TCDAArrayType); overload;{$ENDIF}
{$IFNDEF CDA_FuncReintroduce_CopyP}
  Function CDA_Copy(const Src: TCDAArrayType; Index, Count: Integer): TCDAArrayType; overload;{$ENDIF}
{$IFNDEF CDA_FuncReintroduce_Copy}
  Function CDA_Copy(const Src: TCDAArrayType): TCDAArrayType; overload;{$ENDIF}

// indices functions
{$IFNDEF CDA_FuncReintroduce_Low}
  Function CDA_Low(const Arr: TCDAArrayType): Integer; overload;{$IFDEF CanInline} inline;{$ENDIF}{$ENDIF}
{$IFNDEF CDA_FuncReintroduce_High}
  Function CDA_High(const Arr: TCDAArrayType): Integer; overload;{$ENDIF}
{$IFNDEF CDA_FuncReintroduce_CheckIndex}
  Function CDA_CheckIndex(const Arr: TCDAArrayType; Index: Integer): Boolean; overload;{$ENDIF}

// item access
{$IFNDEF CDA_FuncReintroduce_GetItem}
  Function CDA_GetItem(const Arr: TCDAArrayType; Index: Integer): TCDABaseType; overload;{$ENDIF}
{$IFNDEF CDA_FuncReintroduce_GetItemPtr}
  Function CDA_GetItemPtr(const Arr: TCDAArrayType; Index: Integer): PCDABaseType; overload;{$ENDIF}
{$IFNDEF CDA_FuncReintroduce_SetItem}
  procedure CDA_SetItem(var Arr: TCDAArrayType; Index: Integer;{$IFDEF CDA_ConstBaseType} const{$ENDIF} Item: TCDABaseType); overload;{$ENDIF}

// special items access
{$IFNDEF CDA_FuncReintroduce_First}
  Function CDA_First(const Arr: TCDAArrayType): TCDABaseType; overload;{$ENDIF}
{$IFNDEF CDA_FuncReintroduce_Last}
  Function CDA_Last(const Arr: TCDAArrayType): TCDABaseType; overload;{$ENDIF}
{$IFNDEF CDA_FuncReintroduce_FirstPtr}
  Function CDA_FirstPtr(const Arr: TCDAArrayType): PCDABaseType; overload;{$ENDIF}
{$IFNDEF CDA_FuncReintroduce_LastPtr}
  Function CDA_LastPtr(const Arr: TCDAArrayType): PCDABaseType; overload;{$ENDIF}

// list-like funtions
{$IFNDEF CDA_FuncReintroduce_IndexOf}
  Function CDA_IndexOf(const Arr: TCDAArrayType;{$IFDEF CDA_ConstBaseType} const{$ENDIF} Item: TCDABaseType{$IFDEF CDA_CaseSensitiveBaseType}; CaseSensitive: Boolean = False{$ENDIF}): Integer; overload;{$ENDIF}
{$IFNDEF CDA_FuncReintroduce_Add}
  Function CDA_Add(var Arr: TCDAArrayType;{$IFDEF CDA_ConstBaseType} const{$ENDIF} Item: TCDABaseType): Integer; overload;{$ENDIF}
{$IFNDEF CDA_FuncReintroduce_Append}
  procedure CDA_Append(var Arr: TCDAArrayType; const Items: TCDAArrayType); overload;{$ENDIF}
{$IFNDEF CDA_FuncReintroduce_Insert}
  procedure CDA_Insert(var Arr: TCDAArrayType; Index: Integer;{$IFDEF CDA_ConstBaseType} const{$ENDIF} Item: TCDABaseType); overload;{$ENDIF}
{$IFNDEF CDA_FuncReintroduce_Exchange}
  procedure CDA_Exchange(var Arr: TCDAArrayType; Idx1, Idx2: Integer); overload;{$ENDIF}
{$IFNDEF CDA_FuncReintroduce_Move}
  procedure CDA_Move(var Arr: TCDAArrayType; SrcIdx, DstIdx: Integer); overload;{$ENDIF}
{$IFNDEF CDA_FuncReintroduce_Extract}
  Function CDA_Extract(var Arr: TCDAArrayType; Index: Integer): TCDABaseType; overload;{$ENDIF}
{$IFNDEF CDA_FuncReintroduce_Remove}
  Function CDA_Remove(var Arr: TCDAArrayType;{$IFDEF CDA_ConstBaseType} const{$ENDIF} Item: TCDABaseType{$IFDEF CDA_CaseSensitiveBaseType}; CaseSensitive: Boolean = False{$ENDIF}): Integer; overload;{$ENDIF}
{$IFNDEF CDA_FuncReintroduce_Delete}
  procedure CDA_Delete(var Arr: TCDAArrayType; Index: Integer); overload;{$ENDIF}
{$IFNDEF CDA_FuncReintroduce_Clear}
  procedure CDA_Clear(var Arr: TCDAArrayType); overload;{$IFDEF CanInline} inline;{$ENDIF}{$ENDIF}

// whole-array access/operation
{$IFNDEF CDA_FuncReintroduce_ArrayPtr}
  Function CDA_ArrayPtr(const Arr: TCDAArrayType): Pointer; overload;{$ENDIF}
{$IFNDEF CDA_FuncReintroduce_Compare}
  Function CDA_Compare(const Arr1, Arr2: TCDAArrayType{$IFDEF CDA_CaseSensitiveBaseType}; CaseSensitive: Boolean = False{$ENDIF}): Integer; overload;{$ENDIF}
{$IFNDEF CDA_FuncReintroduce_Same}
  Function CDA_Same(const Arr1, Arr2: TCDAArrayType{$IFDEF CDA_CaseSensitiveBaseType}; CaseSensitive: Boolean = False{$ENDIF}): Boolean; overload;{$ENDIF}
{$IFNDEF CDA_FuncReintroduce_Reverse}
  procedure CDA_Reverse(var Arr: TCDAArrayType); overload;{$ENDIF}
{$IFNDEF CDA_FuncReintroduce_Sort}
  procedure CDA_Sort(var Arr: TCDAArrayType; Reversed: Boolean = False{$IFDEF CDA_CaseSensitiveBaseType}; CaseSensitive: Boolean = False{$ENDIF}); overload;{$ENDIF}
{$IFNDEF CDA_FuncReintroduce_SortStabilized}
  procedure CDA_SortStabilized(var Arr: TCDAArrayType; Reversed: Boolean = False{$IFDEF CDA_CaseSensitiveBaseType}; CaseSensitive: Boolean = False{$ENDIF}); overload;{$ENDIF}

{$ENDIF}

{===============================================================================
--------------------------------------------------------------------------------
    Implementation section (implementation of functions)
--------------------------------------------------------------------------------
===============================================================================}

{$IFDEF CDA_Implementation}

{===============================================================================
    Auxiliary internal functions (cannot be overriden or reintroduced)
===============================================================================}

Function CDA_Signature: TCDASignature;
begin
{$IFDEF 64bit}
Result := (PtrUInt(Random($10000)) shl 48) or (PtrUInt(Random($10000)) shl 32) or
          (PtrUInt(Random($10000)) shl 16) or PtrUInt(Random($10000)) ;
{$ELSE}
Result := (PtrUInt(Random($10000)) shl 16) or PtrUInt(Random($10000));
{$ENDIF}
end;

//------------------------------------------------------------------------------

{$IFDEF FPCDWM}{$PUSH}W4055{$ENDIF}
Function CDA_Checksum(const Arr: TCDAArrayType): TCDAChecksum;
begin
{
  Checksum is obtained by only XOR-ing of some fields.
  Field Arr is by compiler implemented as a pointer to the dynamic array
  itself, so we can use it as such.
}
Result := Arr.Signature xor PtrUInt(Pointer(Arr.Arr)) xor not(PtrUInt(Arr.Count));
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{===============================================================================
    Internal functions
===============================================================================}

{$IFDEF FPCDWM}{$PUSH}W5024{$ENDIF}
{$IF Defined(CDA_FuncOverride_ItemInit) or Defined(CDA_FuncReintroduce_ItemInit)}
procedure _CDA_ItemInit(var Item: TCDABaseType);
{$ELSE}
procedure CDA_ItemInit(var Item: TCDABaseType);
{$IFEND}
begin
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

//------------------------------------------------------------------------------

{$IFDEF FPCDWM}{$PUSH}W5024{$ENDIF}
{$IF Defined(CDA_FuncOverride_ItemFinal) or Defined(CDA_FuncReintroduce_ItemFinal)}
procedure _CDA_ItemFinal(var Item: TCDABaseType);
{$ELSE}
procedure CDA_ItemFinal(var Item: TCDABaseType);
{$IFEND}
begin
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

//------------------------------------------------------------------------------

{$IFDEF FPCDWM}{$PUSH}W5024{$ENDIF}
{$IF Defined(CDA_FuncOverride_ItemUnique) or Defined(CDA_FuncReintroduce_ItemUnique)}
procedure _CDA_ItemUnique(var Item: TCDABaseType);
{$ELSE}
procedure CDA_ItemUnique(var Item: TCDABaseType); 
{$IFEND}
begin
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

//------------------------------------------------------------------------------

{$IFDEF FPCDWM}{$PUSH}W5024{$ENDIF}
{$IF Defined(CDA_FuncOverride_ItemCompare) or Defined(CDA_FuncReintroduce_ItemCompare)}
Function _CDA_ItemCompare({$IFDEF CDA_ConstBaseType}const {$ENDIF}A,B: TCDABaseType{$IFDEF CDA_CaseSensitiveBaseType}; CaseSensitive: Boolean{$ENDIF}): Integer; {$IFDEF CanInline} inline;{$ENDIF}
{$ELSE}
Function CDA_ItemCompare({$IFDEF CDA_ConstBaseType}const {$ENDIF}A,B: TCDABaseType{$IFDEF CDA_CaseSensitiveBaseType}; CaseSensitive: Boolean{$ENDIF}): Integer; {$IFDEF CanInline} inline;{$ENDIF}
{$IFEND}
begin
Result := 0;
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

//==============================================================================

{$IF Defined(CDA_FuncOverride_SortFunc_ItemCompare) or Defined(CDA_FuncReintroduce_SortFunc_ItemCompare)}
Function _CDA_SortFunc_ItemCompare(Context: Pointer; Idx1,Idx2: Integer): Integer;{$IFDEF CanInline} inline;{$ENDIF}
{$ELSE}
Function CDA_SortFunc_ItemCompare(Context: Pointer; Idx1,Idx2: Integer): Integer;{$IFDEF CanInline} inline;{$ENDIF}
{$IFEND}
begin
{$IFDEF CDA_CaseSensitiveBaseType}
Result := CDA_ItemCompare(TCDAArrayType(Context^).Arr[Idx1],TCDAArrayType(Context^).Arr[Idx2],TCDAArrayType(Context^).InternalInt <> 0);
{$ELSE}
Result := CDA_ItemCompare(TCDAArrayType(Context^).Arr[Idx1],TCDAArrayType(Context^).Arr[Idx2]);
{$ENDIF}
end;

//------------------------------------------------------------------------------

{$IF Defined(CDA_FuncOverride_SortFunc_ItemCompareStabilized) or Defined(CDA_FuncReintroduce_SortFunc_ItemCompareStabilized)}
Function _CDA_SortFunc_ItemCompareStabilized(Context: Pointer; Idx1,Idx2: Integer): Integer;
{$ELSE}
Function CDA_SortFunc_ItemCompareStabilized(Context: Pointer; Idx1,Idx2: Integer): Integer;
{$IFEND}
begin
Result := CDA_SortFunc_ItemCompare(Context,Idx1,Idx2);
If Result = 0 then
  with TCDAArrayType(Context^) do
    begin
      If PCDAIndexArray(InternalPtr)^[Idx1] < PCDAIndexArray(InternalPtr)^[Idx2] then
        Result := +1
      else If PCDAIndexArray(InternalPtr)^[Idx1] > PCDAIndexArray(InternalPtr)^[Idx2] then
        Result := -1;
    end;
end;

//------------------------------------------------------------------------------

{$IF Defined(CDA_FuncOverride_SortFunc_ItemExchange) or Defined(CDA_FuncReintroduce_SortFunc_ItemExchange)}
procedure _CDA_SortFunc_ItemExchange(Context: Pointer; Idx1,Idx2: Integer);{$IFDEF CanInline} inline;{$ENDIF}
{$ELSE}
procedure CDA_SortFunc_ItemExchange(Context: Pointer; Idx1,Idx2: Integer);{$IFDEF CanInline} inline;{$ENDIF}
{$IFEND}
begin
CDA_Exchange(TCDAArrayType(Context^),Idx1,Idx2);
end;

//------------------------------------------------------------------------------

{$IF Defined(CDA_FuncOverride_SortFunc_ItemExchangeStabilized) or Defined(CDA_FuncReintroduce_SortFunc_ItemExchangeStabilized)}
procedure _CDA_SortFunc_ItemExchangeStabilized(Context: Pointer; Idx1,Idx2: Integer);
{$ELSE}
procedure CDA_SortFunc_ItemExchangeStabilized(Context: Pointer; Idx1,Idx2: Integer);
{$IFEND}
var
  Temp: Integer;
begin
CDA_SortFunc_ItemExchange(Context,Idx1,Idx2);
with TCDAArrayType(Context^) do
  begin
    Temp := PCDAIndexArray(InternalPtr)^[Idx1];
    PCDAIndexArray(InternalPtr)^[Idx1] := PCDAIndexArray(InternalPtr)^[Idx2];
    PCDAIndexArray(InternalPtr)^[Idx2] := Temp;
  end;
end;

{===============================================================================
    Public functions
===============================================================================}

{$IF Defined(CDA_FuncOverride_Valid) or Defined(CDA_FuncReintroduce_Valid)}
Function _CDA_Valid(const Arr: TCDAArrayType): Boolean;
{$ELSE}
Function CDA_Valid(const Arr: TCDAArrayType): Boolean;
{$IFEND}
begin
Result := Arr.Checksum = CDA_Checksum(Arr);
end;

//------------------------------------------------------------------------------

{$IF Defined(CDA_FuncOverride_Validate) or Defined(CDA_FuncReintroduce_Validate)}
procedure _CDA_Validate(var Arr: TCDAArrayType);
{$ELSE}
procedure CDA_Validate(var Arr: TCDAArrayType);
{$IFEND}
begin
If not CDA_Valid(Arr) then
  CDA_Init(Arr);
end;

//------------------------------------------------------------------------------

{$IF Defined(CDA_FuncOverride_Init) or Defined(CDA_FuncReintroduce_Init)}
procedure _CDA_Init(out Arr: TCDAArrayType);
{$ELSE}
procedure CDA_Init(out Arr: TCDAArrayType);
{$IFEND}
begin
Arr.Signature := CDA_Signature;
Arr.Arr := nil; // if the array is not empty this will free it automatically
Arr.Count := 0;
Arr.UserData := 0;
Arr.InternalPtr := nil;
Arr.InternalInt := 0;
Arr.Checksum := CDA_Checksum(Arr);
end;

//==============================================================================
  
{$IF Defined(CDA_FuncOverride_GetUserData) or Defined(CDA_FuncReintroduce_GetUserData)}
Function _CDA_GetUserData(const Arr: TCDAArrayType): PtrInt;  
{$ELSE}
Function CDA_GetUserData(const Arr: TCDAArrayType): PtrInt;
{$IFEND}
begin
If CDA_Valid(Arr) then
  Result := Arr.UserData
else
  Result := 0;
end;

//------------------------------------------------------------------------------

{$IF Defined(CDA_FuncOverride_SetUserData) or Defined(CDA_FuncReintroduce_SetUserData)}
procedure _CDA_SetUserData(var Arr: TCDAArrayType; UserData: PtrInt);
{$ELSE}
procedure CDA_SetUserData(var Arr: TCDAArrayType; UserData: PtrInt);
{$IFEND}
begin
CDA_Validate(Arr);
Arr.UserData := UserData;
end;

//==============================================================================

{$IF Defined(CDA_FuncOverride_Length) or Defined(CDA_FuncReintroduce_Length)}
Function _CDA_Length(const Arr: TCDAArrayType): Integer;
{$ELSE}
Function CDA_Length(const Arr: TCDAArrayType): Integer;
{$IFEND}
begin
If CDA_Valid(Arr) then
  Result := Length(Arr.Arr)
else
  Result := 0;
end;

//------------------------------------------------------------------------------

{$IF Defined(CDA_FuncOverride_Capacity) or Defined(CDA_FuncReintroduce_Capacity)}
Function _CDA_Capacity(const Arr: TCDAArrayType): Integer;
{$ELSE}
Function CDA_Capacity(const Arr: TCDAArrayType): Integer;
{$IFEND}
begin
Result := CDA_Length(Arr);
end;

//------------------------------------------------------------------------------

{$IF Defined(CDA_FuncOverride_FreeCapacity) or Defined(CDA_FuncReintroduce_FreeCapacity)}
Function _CDA_CapacityFree(const Arr: TCDAArrayType): Integer;
{$ELSE}
Function CDA_CapacityFree(const Arr: TCDAArrayType): Integer;
{$IFEND}
begin
If CDA_Valid(Arr) then
  Result := Length(Arr.Arr) - Arr.Count
else
  Result := 0;
end;

//------------------------------------------------------------------------------

{$IF Defined(CDA_FuncOverride_Count) or Defined(CDA_FuncReintroduce_Count)}
Function _CDA_Count(const Arr: TCDAArrayType): Integer;
{$ELSE}
Function CDA_Count(const Arr: TCDAArrayType): Integer;
{$IFEND}
begin
If CDA_Valid(Arr) then
  Result := Arr.Count
else
  Result := 0;
end;

//==============================================================================

{$IF Defined(CDA_FuncOverride_SetLength) or Defined(CDA_FuncReintroduce_SetLength)}
procedure _CDA_SetLength(var Arr: TCDAArrayType; NewLength: Integer);
{$ELSE}
procedure CDA_SetLength(var Arr: TCDAArrayType; NewLength: Integer);
{$IFEND}
var
  i:  Integer;
begin
CDA_Validate(Arr);
If NewLength >= 0 then
  begin
    If NewLength < Arr.Count then
      For i := NewLength to Pred(Arr.Count) do
        CDA_ItemFinal(Arr.Arr[i]);
    SetLength(Arr.Arr,NewLength);
    If NewLength < Arr.Count then
      Arr.Count := NewLength;
    Arr.Checksum := CDA_Checksum(Arr);
  end
else raise ERangeError.CreateFmt('CDA_SetLength: New length (%d) out of range.',[NewLength]);
end;

//------------------------------------------------------------------------------

{$IF Defined(CDA_FuncOverride_SetCapacity) or Defined(CDA_FuncReintroduce_SetCapacity)}
procedure _CDA_SetCapacity(var Arr: TCDAArrayType; NewCapacity: Integer);
{$ELSE}
procedure CDA_SetCapacity(var Arr: TCDAArrayType; NewCapacity: Integer);
{$IFEND}
begin
CDA_SetLength(Arr,NewCapaCity);
end;

//------------------------------------------------------------------------------

{$IF Defined(CDA_FuncOverride_SetCount) or Defined(CDA_FuncReintroduce_SetCount)}
procedure _CDA_SetCount(var Arr: TCDAArrayType; NewCount: Integer);
{$ELSE}
procedure CDA_SetCount(var Arr: TCDAArrayType; NewCount: Integer);
{$IFEND}
var
  i:  Integer;
begin
CDA_Validate(Arr);
If NewCount >= 0 then
  begin
    If NewCount < Arr.Count then
      begin
        // remove existing items
        For i := Pred(Arr.Count) downto NewCount do
          CDA_ItemFinal(Arr.Arr[i]);
        Arr.Count := NewCount;
        CDA_Shrink(Arr);
      end
    else If NewCount > Arr.Count then
      begin
        // add new items
        If NewCount > Length(Arr.Arr) then
          CDA_SetCapacity(Arr,NewCount);
        For i := Arr.Count to Pred(NewCount) do
          CDA_ItemInit(Arr.Arr[i]);
        Arr.Count := NewCount;
      end;
    Arr.Checksum := CDA_Checksum(Arr);
  end
else raise ERangeError.CreateFmt('CDA_SetCount: New count (%d) out of range.',[NewCount])
end;

//==============================================================================

{$IF Defined(CDA_FuncOverride_Grow) or Defined(CDA_FuncReintroduce_Grow)}
Function _CDA_Grow(var Arr: TCDAArrayType; GrowMode: TCDAGrowMode = agmFast; GrowFactor: Single = 1.0; DeltaMin: Integer = 1): Integer;
{$ELSE}
Function CDA_Grow(var Arr: TCDAArrayType; GrowMode: TCDAGrowMode = agmFast; GrowFactor: Single = 1.0; DeltaMin: Integer = 1): Integer;
{$IFEND}
begin
CDA_Validate(Arr);
If DeltaMin < 1 then
  DeltaMin := 1;
If (Arr.Count + DeltaMin) > Length(Arr.Arr) then
  begin
    If (Length(Arr.Arr) > 0) or (GrowMode = agmSlow) then
      case GrowMode of
        agmLinear:
          Result := Trunc(GrowFactor);
        agmFast:
          Result := Trunc(Length(Arr.Arr) * GrowFactor);
        agmFastAttenuated:
          If Length(Arr.Arr) >= CDA_GROW_ATTENUATE_THRESHOLD then
            Result := Trunc(CDA_GROW_ATTENUATE_THRESHOLD / 16)
          else
            Result := Trunc(Length(Arr.Arr) * GrowFactor);
      else
       {agmSlow}
        Result := 1;
      end
    else Result := CDA_INITIAL_CAPACITY;
    If Result < DeltaMin then
      Result := DeltaMin;
    If Result < 1 then
      Result := 1;
    // do the growing
    CDA_SetCapacity(Arr,Length(Arr.Arr) + Result);
  end
else Result := 0;
end;

//------------------------------------------------------------------------------
 
{$IF Defined(CDA_FuncOverride_Shrink) or Defined(CDA_FuncReintroduce_Shrink)}
procedure _CDA_Shrink(var Arr: TCDAArrayType; ShrinkMode: TCDAShrinkMode = asmNormal);
{$ELSE}
procedure CDA_Shrink(var Arr: TCDAArrayType; ShrinkMode: TCDAShrinkMode = asmNormal);
{$IFEND}
begin
CDA_Validate(Arr);
If Length(Arr.Arr) > 0 then
  case ShrinkMode of
    asmNormal:  If Length(Arr.Arr) > CDA_INITIAL_CAPACITY then
                  begin
                    If Arr.Count < (Length(Arr.Arr) div 4) then
                      CDA_SetCapacity(Arr,Length(Arr.Arr) div 4)
                  end
                else
                  begin
                    If Arr.Count <= 0 then
                      CDA_SetCapacity(Arr,0);
                  end;
    asmToCount: CDA_SetCapacity(Arr,Arr.Count);
  else
   {asmKeepCap}
    // do nothing
  end;
end;

//==============================================================================

{$IF Defined(CDA_FuncOverride_UniqueArray) or Defined(CDA_FuncReintroduce_UniqueArray)}
procedure _CDA_UniqueArray(var Arr: TCDAArrayType);
{$ELSE}
procedure CDA_UniqueArray(var Arr: TCDAArrayType);
{$IFEND}
var
  i:  Integer;
begin
// CDA_SetLength validates the array
CDA_SetLength(Arr,Length(Arr.Arr));
For i := 0 to Pred(Arr.Count) do
  CDA_ItemUnique(Arr.Arr[i]);
end;

//------------------------------------------------------------------------------

{$IF Defined(CDA_FuncOverride_CopyP) or Defined(CDA_FuncReintroduce_CopyP)}
Function _CDA_Copy(const Src: TCDAArrayType; Index, Count: Integer): TCDAArrayType; overload;
{$ELSE}
Function CDA_Copy(const Src: TCDAArrayType; Index, Count: Integer): TCDAArrayType;
{$IFEND}
var
  i:  Integer;
begin
CDA_Init(Result);
// CDA_CheckIndex checks for validity of the source array
If CDA_CheckIndex(Src,Index) then
  begin
    If (Index + Count) > Src.Count then
      Count := Src.Count - Index;
    Result.Arr := Copy(Src.Arr,Index,Count);
    Result.Count := Count;
    Result.UserData := Src.UserData;
    For i := 0 to Pred(Result.Count) do
      CDA_ItemUnique(Result.Arr[i]);
    Result.Checksum := CDA_Checksum(Result);
  end;
end;

//------------------------------------------------------------------------------

{$IF Defined(CDA_FuncOverride_Copy) or Defined(CDA_FuncReintroduce_Copy)}
Function _CDA_Copy(const Src: TCDAArrayType): TCDAArrayType; overload;
{$ELSE}
Function CDA_Copy(const Src: TCDAArrayType): TCDAArrayType;
{$IFEND}
var
  i:  Integer;
begin
CDA_Init(Result);
If CDA_Valid(Src) then
  begin
    Result.Arr := Copy(Src.Arr);
    Result.Count := Src.Count;
    Result.UserData := Src.UserData;
    For i := 0 to Pred(Result.Count) do
      CDA_ItemUnique(Result.Arr[i]);
    Result.Checksum := CDA_Checksum(Result);
  end;
end;

//==============================================================================

{$IFDEF FPCDWM}{$PUSH}W5024{$ENDIF}
{$IF Defined(CDA_FuncOverride_Low) or Defined(CDA_FuncReintroduce_Low)}
Function _CDA_Low(const Arr: TCDAArrayType): Integer;
{$ELSE}
Function CDA_Low(const Arr: TCDAArrayType): Integer;
{$IFEND}
begin
// no need to check validity, this will always return 0
Result := 0;
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

//------------------------------------------------------------------------------
 
{$IF Defined(CDA_FuncOverride_High) or Defined(CDA_FuncReintroduce_High)}
Function _CDA_High(const Arr: TCDAArrayType): Integer;
{$ELSE}
Function CDA_High(const Arr: TCDAArrayType): Integer;
{$IFEND}
begin
If CDA_Valid(Arr) then
  Result := Pred(Arr.Count)
else
  Result := -1;
end;

//------------------------------------------------------------------------------
 
{$IF Defined(CDA_FuncOverride_CheckIndex) or Defined(CDA_FuncReintroduce_CheckIndex)}
Function _CDA_CheckIndex(const Arr: TCDAArrayType; Index: Integer): Boolean;
{$ELSE}
Function CDA_CheckIndex(const Arr: TCDAArrayType; Index: Integer): Boolean;
{$IFEND}
begin
If CDA_Valid(Arr) then
  Result := (Index >= 0) and (Index < Arr.Count)
else
  Result := False;
end;

//==============================================================================

{$IF Defined(CDA_FuncOverride_GetItem) or Defined(CDA_FuncReintroduce_GetItem)}
Function _CDA_GetItem(const Arr: TCDAArrayType; Index: Integer): TCDABaseType;
{$ELSE}
Function CDA_GetItem(const Arr: TCDAArrayType; Index: Integer): TCDABaseType;
{$IFEND}
begin
// CDA_CheckIndex checks for validity, exception is raised for an invalid array
If CDA_CheckIndex(Arr,Index) then
  Result := Arr.Arr[Index]
else
  raise Exception.CreateFmt('CDA_GetItem: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

{$IF Defined(CDA_FuncOverride_GetItemPtr) or Defined(CDA_FuncReintroduce_GetItemPtr)}
Function _CDA_GetItemPtr(const Arr: TCDAArrayType; Index: Integer): PCDABaseType;
{$ELSE}
Function CDA_GetItemPtr(const Arr: TCDAArrayType; Index: Integer): PCDABaseType;
{$IFEND}
begin
// CDA_CheckIndex checks for validity, exception is raised for an invalid array
If CDA_CheckIndex(Arr,Index) then
  Result := Addr(Arr.Arr[Index])
else
  raise Exception.CreateFmt('CDA_GetItemPtr: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------
  
{$IF Defined(CDA_FuncOverride_SetItem) or Defined(CDA_FuncReintroduce_SetItem)}
procedure _CDA_SetItem(var Arr: TCDAArrayType; Index: Integer;{$IFDEF CDA_ConstBaseType} const{$ENDIF} Item: TCDABaseType);
{$ELSE}
procedure CDA_SetItem(var Arr: TCDAArrayType; Index: Integer;{$IFDEF CDA_ConstBaseType} const{$ENDIF} Item: TCDABaseType);
{$IFEND}
begin
// CDA_CheckIndex checks for validity, exception is raised for an invalid array
If CDA_CheckIndex(Arr,Index) then
  Arr.Arr[Index] := Item
else
  raise Exception.CreateFmt('CDA_SetItem: Index (%d) out of bounds.',[Index]);
end;

//==============================================================================

{$IF Defined(CDA_FuncOverride_First) or Defined(CDA_FuncReintroduce_First)}
Function _CDA_First(const Arr: TCDAArrayType): TCDABaseType;
{$ELSE}
Function CDA_First(const Arr: TCDAArrayType): TCDABaseType;
{$IFEND}
begin
// CDA_Count checks for validity, exception is raised for invalid array
If CDA_Count(Arr) > 0 then
  Result := Arr.Arr[0]
else
  raise Exception.Create('CDA_First: Array is empty.');
end;

//------------------------------------------------------------------------------

{$IF Defined(CDA_FuncOverride_Last) or Defined(CDA_FuncReintroduce_Last)}
Function _CDA_Last(const Arr: TCDAArrayType): TCDABaseType;
{$ELSE}
Function CDA_Last(const Arr: TCDAArrayType): TCDABaseType;
{$IFEND}
begin
// CDA_Count checks for validity, exception is raised for invalid array
If CDA_Count(Arr) > 0 then
  Result := Arr.Arr[Pred(Arr.Count)]
else
  raise Exception.Create('CDA_Last: Array is empty.');
end;

//------------------------------------------------------------------------------

{$IF Defined(CDA_FuncOverride_FirstPtr) or Defined(CDA_FuncReintroduce_FirstPtr)}
Function _CDA_FirstPtr(const Arr: TCDAArrayType): PCDABaseType;
{$ELSE}
Function CDA_FirstPtr(const Arr: TCDAArrayType): PCDABaseType;
{$IFEND}
begin
// CDA_Count checks for validity, exception is raised for invalid array
If CDA_Count(Arr) > 0 then
  Result := Addr(Arr.Arr[0])
else
  raise Exception.Create('CDA_FirstPtr: Array is empty.');
end;

//------------------------------------------------------------------------------
    
{$IF Defined(CDA_FuncOverride_LastPtr) or Defined(CDA_FuncReintroduce_LastPtr)}
Function _CDA_LastPtr(const Arr: TCDAArrayType): PCDABaseType;
{$ELSE}
Function CDA_LastPtr(const Arr: TCDAArrayType): PCDABaseType;
{$IFEND}
begin
// CDA_Count checks for validity, exception is raised for invalid array
If CDA_Count(Arr) > 0 then
  Result := Addr(Arr.Arr[Pred(Arr.Count)])
else
  raise Exception.Create('CDA_LastPtr: Array is empty.');
end;

//==============================================================================

{$IF Defined(CDA_FuncOverride_IndexOf) or Defined(CDA_FuncReintroduce_IndexOf)}
Function _CDA_IndexOf(const Arr: TCDAArrayType;{$IFDEF CDA_ConstBaseType} const{$ENDIF} Item: TCDABaseType{$IFDEF CDA_CaseSensitiveBaseType}; CaseSensitive: Boolean = False{$ENDIF}): Integer;
{$ELSE}
Function CDA_IndexOf(const Arr: TCDAArrayType;{$IFDEF CDA_ConstBaseType} const{$ENDIF} Item: TCDABaseType{$IFDEF CDA_CaseSensitiveBaseType}; CaseSensitive: Boolean = False{$ENDIF}): Integer;
{$IFEND}
var
  i:  Integer;
begin
Result := -1;
If CDA_Valid(Arr) then
  For i := 0 to Pred(Arr.Count) do
    If CDA_ItemCompare(Arr.Arr[i],Item{$IFDEF CDA_CaseSensitiveBaseType},CaseSensitive{$ENDIF}) = 0 then
      begin
        Result := i;
        Break{For i};
      end;
end;

//------------------------------------------------------------------------------
    
{$IF Defined(CDA_FuncOverride_Add) or Defined(CDA_FuncReintroduce_Add)}
Function _CDA_Add(var Arr: TCDAArrayType;{$IFDEF CDA_ConstBaseType} const{$ENDIF} Item: TCDABaseType): Integer;
{$ELSE}
Function CDA_Add(var Arr: TCDAArrayType;{$IFDEF CDA_ConstBaseType} const{$ENDIF} Item: TCDABaseType): Integer;
{$IFEND}
begin
// CDA_Grow calls CDA_Validate
CDA_Grow(Arr);
Result := Arr.Count;
Arr.Arr[Result] := Item;
Inc(Arr.Count);
Arr.Checksum := CDA_Checksum(Arr);
end;

//------------------------------------------------------------------------------

{$IF Defined(CDA_FuncOverride_Append) or Defined(CDA_FuncReintroduce_Append)}
procedure _CDA_Append(var Arr: TCDAArrayType; const Items: TCDAArrayType);
{$ELSE}
procedure CDA_Append(var Arr: TCDAArrayType; const Items: TCDAArrayType);
{$IFEND}
var
  i,Idx:  Integer;
begin
CDA_Validate(Arr);
If CDA_Valid(Items) then
  begin
    If Length(Arr.Arr) < (Arr.Count + Items.Count) then
      CDA_SetCapacity(Arr,Arr.Count + Items.Count);
    Idx := Arr.Count;
    For i := 0 to Pred(Items.Count) do
      begin
        Arr.Arr[Idx] := Items.Arr[i];
        CDA_ItemUnique(Arr.Arr[Idx]);
        Inc(Idx);
      end;
    Inc(Arr.Count,Items.Count);
    Arr.Checksum := CDA_Checksum(Arr);
  end;
end;

//------------------------------------------------------------------------------

{$IF Defined(CDA_FuncOverride_Insert) or Defined(CDA_FuncReintroduce_Insert)}
procedure _CDA_Insert(var Arr: TCDAArrayType; Index: Integer;{$IFDEF CDA_ConstBaseType} const{$ENDIF} Item: TCDABaseType);
{$ELSE}
procedure CDA_Insert(var Arr: TCDAArrayType; Index: Integer;{$IFDEF CDA_ConstBaseType} const{$ENDIF} Item: TCDABaseType);
{$IFEND}
var
  i:  Integer;
begin
CDA_Validate(Arr);
If CDA_CheckIndex(Arr,Index) then
  begin
    CDA_Grow(Arr);
    For i := Pred(Arr.Count) downto Index do
      Arr.Arr[i + 1] := Arr.Arr[i];
    Arr.Arr[Index] := Item;
    Inc(Arr.Count);
    Arr.Checksum := CDA_Checksum(Arr);
  end
else CDA_Add(Arr,Item);
end;

//------------------------------------------------------------------------------

{$IF Defined(CDA_FuncOverride_Exchange) or Defined(CDA_FuncReintroduce_Exchange)}
procedure _CDA_Exchange(var Arr: TCDAArrayType; Idx1, Idx2: Integer);
{$ELSE}
procedure CDA_Exchange(var Arr: TCDAArrayType; Idx1, Idx2: Integer);
{$IFEND}
var
  Temp: TCDABaseType;
begin
CDA_Validate(Arr);
If Idx1 <> Idx2 then
  begin
    If not CDA_CheckIndex(Arr,Idx1) then
      raise Exception.CreateFmt('CDA_Exchange: First index (%d) out of bounds.',[Idx1]);
    If not CDA_CheckIndex(Arr,Idx2) then
      raise Exception.CreateFmt('CDA_Exchange: Second index (%d) out of bounds.',[Idx2]);
    Temp := Arr.Arr[Idx1];
    Arr.Arr[Idx1] := Arr.Arr[Idx2];
    Arr.Arr[Idx2] := Temp;
  end;
end;

//------------------------------------------------------------------------------

{$IF Defined(CDA_FuncOverride_Move) or Defined(CDA_FuncReintroduce_Move)}
procedure _CDA_Move(var Arr: TCDAArrayType; SrcIdx, DstIdx: Integer);
{$ELSE}
procedure CDA_Move(var Arr: TCDAArrayType; SrcIdx, DstIdx: Integer);
{$IFEND}
var
  Temp: TCDABaseType;
  i:    Integer;
begin
CDA_Validate(Arr);
If SrcIdx <> DstIdx then
  begin
    If not CDA_CheckIndex(Arr,SrcIdx) then
      raise Exception.CreateFmt('CDA_Move: Source index (%d) out of bounds.',[SrcIdx]);
    If not CDA_CheckIndex(Arr,DstIdx) then
      raise Exception.CreateFmt('CDA_Move: Destination index (%d) out of bounds.',[DstIdx]);
    Temp := Arr.Arr[SrcIdx];
    If SrcIdx > DstIdx then
      For i := SrcIdx downto Succ(DstIdx) do
        Arr.Arr[i] := Arr.Arr[i - 1]
    else
      For i := SrcIdx to Pred(DstIdx) do
        Arr.Arr[i] := Arr.Arr[i + 1]; 
    Arr.Arr[DstIdx] := Temp;    
  end;
end;

//------------------------------------------------------------------------------

{$IF Defined(CDA_FuncOverride_Extract) or Defined(CDA_FuncReintroduce_Extract)}
Function _CDA_Extract(var Arr: TCDAArrayType; Index: Integer): TCDABaseType;
{$ELSE}
Function CDA_Extract(var Arr: TCDAArrayType; Index: Integer): TCDABaseType;
{$IFEND}
var
  i:  Integer;
begin
CDA_Validate(Arr);
If CDA_CheckIndex(Arr,Index) then
  begin
    Result := Arr.Arr[Index];
    For i := Index to (Arr.Count - 2) do
      Arr.Arr[i] := Arr.Arr[i + 1];
    Dec(Arr.Count);
    Arr.Checksum := CDA_Checksum(Arr);     
    CDA_Shrink(Arr);
  end
else raise Exception.CreateFmt('CDA_Extract: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------
     
{$IF Defined(CDA_FuncOverride_Remove) or Defined(CDA_FuncReintroduce_Remove)}
Function _CDA_Remove(var Arr: TCDAArrayType;{$IFDEF CDA_ConstBaseType} const{$ENDIF} Item: TCDABaseType{$IFDEF CDA_CaseSensitiveBaseType}; CaseSensitive: Boolean = False{$ENDIF}): Integer;
{$ELSE}
Function CDA_Remove(var Arr: TCDAArrayType;{$IFDEF CDA_ConstBaseType} const{$ENDIF} Item: TCDABaseType{$IFDEF CDA_CaseSensitiveBaseType}; CaseSensitive: Boolean = False{$ENDIF}): Integer;
{$IFEND}
begin
CDA_Validate(Arr);
Result := CDA_IndexOf(Arr,Item{$IFDEF CDA_CaseSensitiveBaseType},CaseSensitive{$ENDIF});
If CDA_CheckIndex(Arr,Result) then
  CDA_Delete(Arr,Result);
end;

//------------------------------------------------------------------------------
    
{$IF Defined(CDA_FuncOverride_Delete) or Defined(CDA_FuncReintroduce_Delete)}
procedure _CDA_Delete(var Arr: TCDAArrayType; Index: Integer);
{$ELSE}
procedure CDA_Delete(var Arr: TCDAArrayType; Index: Integer);
{$IFEND}
var
  i:  Integer;
begin
CDA_Validate(Arr);
If CDA_CheckIndex(Arr,Index) then
  begin
    CDA_ItemFinal(Arr.Arr[Index]);
    For i := Index to (Arr.Count - 2) do
      Arr.Arr[i] := Arr.Arr[i + 1];
    Dec(Arr.Count);
    Arr.Checksum := CDA_Checksum(Arr);
    CDA_Shrink(Arr);
  end
else raise Exception.CreateFmt('CDA_Delete: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------
       
{$IF Defined(CDA_FuncOverride_Clear) or Defined(CDA_FuncReintroduce_Clear)}
procedure _CDA_Clear(var Arr: TCDAArrayType);
{$ELSE}
procedure CDA_Clear(var Arr: TCDAArrayType);
{$IFEND}
begin
CDA_SetLength(Arr,0);
end;

//==============================================================================

{$IF Defined(CDA_FuncOverride_ArrayPtr) or Defined(CDA_FuncReintroduce_ArrayPtr)}
Function _CDA_ArrayPtr(const Arr: TCDAArrayType): Pointer;
{$ELSE}
Function CDA_ArrayPtr(const Arr: TCDAArrayType): Pointer;
{$IFEND}
begin
If CDA_Valid(Arr) then
  begin
    If Arr.Count > 0 then
      Result := Addr(Arr.Arr[0])
    else
      Result := nil;
  end
else Result := nil;
end;

//------------------------------------------------------------------------------

{$IF Defined(CDA_FuncOverride_Compare) or Defined(CDA_FuncReintroduce_Compare)}
Function _CDA_Compare(const Arr1, Arr2: TCDAArrayType{$IFDEF CDA_CaseSensitiveBaseType}; CaseSensitive: Boolean = False{$ENDIF}): Integer;
{$ELSE}
Function CDA_Compare(const Arr1, Arr2: TCDAArrayType{$IFDEF CDA_CaseSensitiveBaseType}; CaseSensitive: Boolean = False{$ENDIF}): Integer;
{$IFEND}
var
  i:    Integer;
  Temp: Int64;
begin
If CDA_Valid(Arr1) then
  begin
    If CDA_Valid(Arr2) then
      begin
        If Arr1.Count < Arr2.Count then
          Result := +1
        else If Arr1.Count > Arr2.Count then
          Result := -1
        else {both arrays have the same number of elements}
          begin
            Temp := 0;
            For i := 0 to Pred(Arr1.Count) do
              Temp := Temp + CDA_ItemCompare(Arr1.Arr[i],Arr2.Arr[i]{$IFDEF CDA_CaseSensitiveBaseType},CaseSensitive{$ENDIF});
            If Temp > Int64(High(Integer)) then
              Result := +1
            else If Temp < Int64(Low(Integer)) then
              Result := -1
            else
              Result := Integer(Temp);
          end
      end
    else raise Exception.Create('CDA_Compare: Invalid array #2.');
  end
else raise Exception.Create('CDA_Compare: Invalid array #1.');
end;

//------------------------------------------------------------------------------

{$IF Defined(CDA_FuncOverride_Same) or Defined(CDA_FuncReintroduce_Same)}
Function _CDA_Same(const Arr1, Arr2: TCDAArrayType{$IFDEF CDA_CaseSensitiveBaseType}; CaseSensitive: Boolean = False{$ENDIF}): Boolean;
{$ELSE}
Function CDA_Same(const Arr1, Arr2: TCDAArrayType{$IFDEF CDA_CaseSensitiveBaseType}; CaseSensitive: Boolean = False{$ENDIF}): Boolean;
{$IFEND}
var
  i:  Integer;
begin
If CDA_Valid(Arr1) and CDA_Valid(Arr2) and (Arr1.Count = Arr2.Count) then
  begin
    Result := True;
    For i := 0 to Pred(Arr1.Count) do
      If CDA_ItemCompare(Arr1.Arr[i],Arr2.Arr[i]{$IFDEF CDA_CaseSensitiveBaseType},CaseSensitive{$ENDIF}) <> 0 then
        begin
          Result := False;
          Break{For i};
        end;
  end
else Result := False;
end;

//------------------------------------------------------------------------------
   
{$IF Defined(CDA_FuncOverride_Reverse) or Defined(CDA_FuncReintroduce_Reverse)}
procedure _CDA_Reverse(var Arr: TCDAArrayType);
{$ELSE}
procedure CDA_Reverse(var Arr: TCDAArrayType);
{$IFEND}
var
  i:    Integer;
  Temp: TCDABaseType;
begin
CDA_Validate(Arr);
If Arr.Count > 1 then
  For i := 0 to Pred(Arr.Count shr 1) do
    begin
      Temp := Arr.Arr[i];
      Arr.Arr[i] := Arr.Arr[Pred(Arr.Count) - i];
      Arr.Arr[Pred(Arr.Count) - i] := Temp;
    end;
end;

//------------------------------------------------------------------------------

{$IF Defined(CDA_FuncOverride_Sort) or Defined(CDA_FuncReintroduce_Sort)}
procedure _CDA_Sort(var Arr: TCDAArrayType; Reversed: Boolean = False{$IFDEF CDA_CaseSensitiveBaseType}; CaseSensitive: Boolean = False{$ENDIF});
{$ELSE}
procedure CDA_Sort(var Arr: TCDAArrayType; Reversed: Boolean = False{$IFDEF CDA_CaseSensitiveBaseType}; CaseSensitive: Boolean = False{$ENDIF});
{$IFEND}
var
  Sorter: TListQuickSorter;
begin
CDA_Validate(Arr);
If Arr.Count > 1 then
  begin
  {$IFDEF CDA_CaseSensitiveBaseType}
    If CaseSensitive then
      Arr.InternalInt := -1
    else
      Arr.InternalInt := 0;
  {$ENDIF}
    Sorter := TListQuickSorter.Create(@Arr,CDA_SortFunc_ItemCompare,CDA_SortFunc_ItemExchange);
    try
      Sorter.Reversed := Reversed;
      Sorter.Sort(0,Pred(Arr.Count));
    finally
      Sorter.Free;
    end;
  end;
end;

//------------------------------------------------------------------------------
                                                 
{$IF Defined(CDA_FuncOverride_SortStabilized) or Defined(CDA_FuncReintroduce_SortStabilized)}
procedure _CDA_SortStabilized(var Arr: TCDAArrayType; Reversed: Boolean = False{$IFDEF CDA_CaseSensitiveBaseType}; CaseSensitive: Boolean = False{$ENDIF});
{$ELSE}
procedure CDA_SortStabilized(var Arr: TCDAArrayType; Reversed: Boolean = False{$IFDEF CDA_CaseSensitiveBaseType}; CaseSensitive: Boolean = False{$ENDIF});
{$IFEND}
var
  i:      Integer;
  Sorter: TListQuickSorter;
begin
CDA_Validate(Arr);
If Arr.Count > 1 then
  begin
    New(PCDAIndexArray(Arr.InternalPtr));
    try
      SetLength(PCDAIndexArray(Arr.InternalPtr)^,Arr.Count);
      For i := Low(PCDAIndexArray(Arr.InternalPtr)^) to High(PCDAIndexArray(Arr.InternalPtr)^) do
        PCDAIndexArray(Arr.InternalPtr)^[i] := i;
    {$IFDEF CDA_CaseSensitiveBaseType}
      If CaseSensitive then
        Arr.InternalInt := -1
      else
        Arr.InternalInt := 0;
    {$ENDIF}
      Sorter := TListQuickSorter.Create(@Arr,CDA_SortFunc_ItemCompareStabilized,CDA_SortFunc_ItemExchangeStabilized);
      try
        Sorter.Reversed := Reversed;
        Sorter.Sort(0,Pred(Arr.Count));
      finally
        Sorter.Free;
      end;
      SetLength(PCDAIndexArray(Arr.InternalPtr)^,0);
    finally
      Dispose(PCDAIndexArray(Arr.InternalPtr));
      Arr.InternalPtr := nil;      
    end;
  end;
end;

{$ENDIF}
