{-------------------------------------------------------------------------------

  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at http://mozilla.org/MPL/2.0/.

-------------------------------------------------------------------------------}
{===============================================================================

  Counted dynamic arrays

    Main implementation template

  ©František Milt 2019-01-26

  Version 1.0.3

  Dependencies:
    AuxTypes    - github.com/ncs-sniper/Lib.AuxTypes
    ListSorters - github.com/ncs-sniper/Lib.ListSorters

===============================================================================}
{$IFDEF CDA_Interface}

{$IF not(Defined(CDA_DisableFunc_Valid) or Defined(CDA_HideFunc_Valid))}
  Function CDA_Valid(const Arr: TCDAArrayType): Boolean;{$IFDEF CanInline} inline; {$ENDIF}{$IFEND}
{$IF not(Defined(CDA_DisableFunc_Validate) or Defined(CDA_HideFunc_Validate))}
  procedure CDA_Validate(var Arr: TCDAArrayType);{$IFDEF CanInline} inline; {$ENDIF}{$IFEND}
{$IF not(Defined(CDA_DisableFunc_Init) or Defined(CDA_HideFunc_Init))}
  procedure CDA_Init(out Arr: TCDAArrayType); overload;{$IFEND}
{$IF not(Defined(CDA_DisableFunc_ArrayPtr) or Defined(CDA_HideFunc_ArrayPtr))}
  Function CDA_ArrayPtr(const Arr: TCDAArrayType): Pointer; overload;{$IFEND}

{$IF not(Defined(CDA_DisableFunc_Length) or Defined(CDA_HideFunc_Length))}
  Function CDA_Length(const Arr: TCDAArrayType): Integer; overload;{$IFEND}
{$IF not(Defined(CDA_DisableFunc_Capacity) or Defined(CDA_HideFunc_Capacity))}
  Function CDA_Capacity(const Arr: TCDAArrayType): Integer; overload;{$IFDEF CanInline} inline; {$ENDIF}{$IFEND}
{$IF not(Defined(CDA_DisableFunc_FreeCapacity) or Defined(CDA_HideFunc_FreeCapacity))}
  Function CDA_FreeCapacity(const Arr: TCDAArrayType): Integer; overload;{$IFEND}
{$IF not(Defined(CDA_DisableFunc_Count) or Defined(CDA_HideFunc_Count))}
  Function CDA_Count(const Arr: TCDAArrayType): Integer; overload;{$IFEND}

{$IF not(Defined(CDA_DisableFunc_Low) or Defined(CDA_HideFunc_Low))}
  Function CDA_Low(const Arr: TCDAArrayType): Integer; overload;{$IFDEF CanInline} inline; {$ENDIF}{$IFEND}
{$IF not(Defined(CDA_DisableFunc_High) or Defined(CDA_HideFunc_High))}
  Function CDA_High(const Arr: TCDAArrayType): Integer; overload;{$IFDEF CanInline} inline; {$ENDIF}{$IFEND}
{$IF not(Defined(CDA_DisableFunc_CheckIndex) or Defined(CDA_HideFunc_CheckIndex))}
  Function CDA_CheckIndex(const Arr: TCDAArrayType; Index: Integer): Boolean; overload;{$IFDEF CanInline} inline; {$ENDIF}{$IFEND}

{$IF not(Defined(CDA_DisableFunc_SetLength) or Defined(CDA_HideFunc_SetLength))}
  procedure CDA_SetLength(var Arr: TCDAArrayType; NewLength: Integer); overload;{$IFEND}
{$IF not(Defined(CDA_DisableFunc_SetCapacity) or Defined(CDA_HideFunc_SetCapacity))}
  procedure CDA_SetCapacity(var Arr: TCDAArrayType; NewCapacity: Integer); overload;{$IFDEF CanInline} inline; {$ENDIF}{$IFEND}

{$IF not(Defined(CDA_DisableFunc_Grow) or Defined(CDA_HideFunc_Grow))}
  Function CDA_Grow(var Arr: TCDAArrayType; GrowMode: TCDAGrowMode = agmFast; GrowFactor: Single = 1.0; DeltaMin: Integer = 1): Integer; overload;{$IFEND}
{$IF not(Defined(CDA_DisableFunc_Shrink) or Defined(CDA_HideFunc_Shrink))}
  procedure CDA_Shrink(var Arr: TCDAArrayType; ShrinkMode: TCDAShrinkMode = asmNormal); overload;{$IFEND}

{$IF not(Defined(CDA_DisableFunc_UniqueArray) or Defined(CDA_HideFunc_UniqueArray))}
  procedure CDA_UniqueArray(var Arr: TCDAArrayType); overload;{$IFEND}
{$IF not(Defined(CDA_DisableFunc_CopyP) or Defined(CDA_HideFunc_CopyP))}
  Function CDA_Copy(const Src: TCDAArrayType; Index, Count: Integer): TCDAArrayType; overload;{$IFEND}
{$IF not(Defined(CDA_DisableFunc_Copy) or Defined(CDA_HideFunc_Copy))}
  Function CDA_Copy(const Src: TCDAArrayType): TCDAArrayType; overload;{$IFEND}

{$IF not(Defined(CDA_DisableFunc_GetData) or Defined(CDA_HideFunc_GetData))}
  Function CDA_GetData(const Arr: TCDAArrayType): PtrInt; overload;{$IFDEF CanInline} inline; {$ENDIF}{$IFEND}
{$IF not(Defined(CDA_DisableFunc_SetData) or Defined(CDA_HideFunc_SetData))}
  procedure CDA_SetData(var Arr: TCDAArrayType; Data: PtrInt); overload;{$IFDEF CanInline} inline; {$ENDIF}{$IFEND}

{$IF not(Defined(CDA_DisableFunc_GetItem) or Defined(CDA_HideFunc_GetItem))}
  Function CDA_GetItem(const Arr: TCDAArrayType; Index: Integer): TCDABaseType; overload;{$IFEND}
{$IF not(Defined(CDA_DisableFunc_GetItemPtr) or Defined(CDA_HideFunc_GetItemPtr))}
  Function CDA_GetItemPtr(const Arr: TCDAArrayType; Index: Integer): PCDABaseType; overload;{$IFEND}
{$IF not(Defined(CDA_DisableFunc_SetItem) or Defined(CDA_HideFunc_SetItem))}
  procedure CDA_SetItem(var Arr: TCDAArrayType; Index: Integer; const Item: TCDABaseType); overload;{$IFEND}

{$IF not(Defined(CDA_DisableFunc_First) or Defined(CDA_HideFunc_First))}
  Function CDA_First(const Arr: TCDAArrayType): TCDABaseType; overload;{$IFEND}
{$IF not(Defined(CDA_DisableFunc_Last) or Defined(CDA_HideFunc_Last))}
  Function CDA_Last(const Arr: TCDAArrayType): TCDABaseType; overload;{$IFEND}

{$IF not(Defined(CDA_DisableFunc_IndexOf) or Defined(CDA_HideFunc_IndexOf))}
  Function CDA_IndexOf(const Arr: TCDAArrayType; const Item: TCDABaseType): Integer; overload;{$IFEND}
{$IF not(Defined(CDA_DisableFunc_Add) or Defined(CDA_HideFunc_Add))}
  Function CDA_Add(var Arr: TCDAArrayType; const Item: TCDABaseType): Integer; overload;{$IFEND}
{$IF not(Defined(CDA_DisableFunc_Insert) or Defined(CDA_HideFunc_Insert))}
  procedure CDA_Insert(var Arr: TCDAArrayType; Index: Integer; const Item: TCDABaseType); overload;{$IFEND}
{$IF not(Defined(CDA_DisableFunc_Exchange) or Defined(CDA_HideFunc_Exchange))}
  procedure CDA_Exchange(var Arr: TCDAArrayType; Idx1, Idx2: Integer); overload;{$IFEND}
{$IF not(Defined(CDA_DisableFunc_Move) or Defined(CDA_HideFunc_Move))}
  procedure CDA_Move(var Arr: TCDAArrayType; SrcIdx, DstIdx: Integer); overload;{$IFEND}
{$IF not(Defined(CDA_DisableFunc_Remove) or Defined(CDA_HideFunc_Remove))}
  Function CDA_Remove(var Arr: TCDAArrayType; const Item: TCDABaseType): Integer; overload;{$IFEND}
{$IF not(Defined(CDA_DisableFunc_Delete) or Defined(CDA_HideFunc_Delete))}
  procedure CDA_Delete(var Arr: TCDAArrayType; Index: Integer); overload;{$IFEND}
{$IF not(Defined(CDA_DisableFunc_Clear) or Defined(CDA_HideFunc_Clear))}
  procedure CDA_Clear(var Arr: TCDAArrayType); overload;{$IFDEF CanInline} inline; {$ENDIF}{$IFEND}

{$IF not(Defined(CDA_DisableFunc_Same) or Defined(CDA_HideFunc_Same))}
  Function CDA_Same(const Arr1, Arr2: TCDAArrayType): Boolean; overload;{$IFEND}
{$IF not(Defined(CDA_DisableFunc_Reverse) or Defined(CDA_HideFunc_Reverse))}
  procedure CDA_Reverse(var Arr: TCDAArrayType); overload;{$IFEND}
{$IF not(Defined(CDA_DisableFunc_Sort) or Defined(CDA_HideFunc_Sort))}
  procedure CDA_Sort(var Arr: TCDAArrayType; Reversed: Boolean = False); overload;{$IFEND}

{$ENDIF}

//==============================================================================

{$IFDEF CDA_Implementation}

{$IFNDEF CDA_DisableFunc_ItemCompareSortFunc}
{$IFDEF CDA_HideFunc_ItemCompareSortFunc}
Function _CDA_ItemCompareSortFunc(Context: Pointer; Idx1,Idx2: Integer): Integer;{$IFDEF CanInline} inline; {$ENDIF}
{$ELSE}
Function CDA_ItemCompareSortFunc(Context: Pointer; Idx1,Idx2: Integer): Integer;{$IFDEF CanInline} inline; {$ENDIF}
{$ENDIF}
begin
Result := CDA_CompareFunc(TCDAArrayType(Context^).Arr[Idx1],TCDAArrayType(Context^).Arr[Idx2]);
end;
{$ENDIF}

//------------------------------------------------------------------------------

{$IFNDEF CDA_DisableFunc_ItemExchangeSortFunc}
{$IFDEF CDA_HideFunc_ItemExchangeSortFunc}
procedure _CDA_ItemExchangeSortFunc(Context: Pointer; Idx1,Idx2: Integer);{$IFDEF CanInline} inline; {$ENDIF}
{$ELSE}
procedure CDA_ItemExchangeSortFunc(Context: Pointer; Idx1,Idx2: Integer);{$IFDEF CanInline} inline; {$ENDIF}
{$ENDIF}
begin
CDA_Exchange(TCDAArrayType(Context^),Idx1,Idx2);
end;
{$ENDIF}

//------------------------------------------------------------------------------

{$IFNDEF CDA_DisableFunc_ItemFinal}
{$IFDEF FPCDWM}{$PUSH}W5024{$ENDIF}
{$IFDEF CDA_HideFunc_ItemFinal}
procedure _CDA_ItemFinal(var Item: TCDABaseType); {$IFDEF CanInline} inline; {$ENDIF}
{$ELSE}
procedure CDA_ItemFinal(var Item: TCDABaseType); {$IFDEF CanInline} inline; {$ENDIF}
{$ENDIF}
begin
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}
{$ENDIF}

//------------------------------------------------------------------------------

{$IFNDEF CDA_DisableFunc_ItemUnique}
{$IFDEF FPCDWM}{$PUSH}W5024{$ENDIF}
{$IFDEF CDA_HideFunc_ItemUnique}
procedure _CDA_ItemUnique(var Item: TCDABaseType); {$IFDEF CanInline} inline; {$ENDIF}
{$ELSE}
procedure CDA_ItemUnique(var Item: TCDABaseType); {$IFDEF CanInline} inline; {$ENDIF}
{$ENDIF}
begin
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}
{$ENDIF}

//==============================================================================

{$IFNDEF CDA_DisableFunc_Valid}
{$IFDEF CDA_HideFunc_Valid}
Function _CDA_Valid(const Arr: TCDAArrayType): Boolean;
{$ELSE}
Function CDA_Valid(const Arr: TCDAArrayType): Boolean;
{$ENDIF}
begin
Result := (Arr.SigA = CDA_SIGA) and (Arr.SigB = CDA_SIGB) and (Arr.Count <= Length(Arr.Arr));
end;
{$ENDIF}

//------------------------------------------------------------------------------

{$IFNDEF CDA_DisableFunc_Validate}
{$IFDEF CDA_HideFunc_Validate}
procedure _CDA_Validate(var Arr: TCDAArrayType);
{$ELSE}
procedure CDA_Validate(var Arr: TCDAArrayType);
{$ENDIF}
begin
If not CDA_Valid(Arr) then
  CDA_Init(Arr);
end;
{$ENDIF}

//------------------------------------------------------------------------------

{$IFNDEF CDA_DisableFunc_Init}
{$IFDEF CDA_HideFunc_Init}
procedure _CDA_Init(out Arr: TCDAArrayType);
{$ELSE}
procedure CDA_Init(out Arr: TCDAArrayType);
{$ENDIF}
begin
SetLength(Arr.Arr,0);
Arr.SigA := CDA_SIGA;
Arr.Count := 0;
Arr.Data := 0;
Arr.SigB := CDA_SIGB;
end;
{$ENDIF}

//------------------------------------------------------------------------------

{$IFNDEF CDA_DisableFunc_ArrayPtr}
{$IFDEF CDA_HideFunc_ArrayPtr}
Function _CDA_ArrayPtr(const Arr: TCDAArrayType): Pointer;
{$ELSE}
Function CDA_ArrayPtr(const Arr: TCDAArrayType): Pointer;
{$ENDIF}
begin
If Arr.Count > 0 then
  Result := Addr(Arr.Arr[0])
else
  Result := nil;
end;
{$ENDIF}

//==============================================================================

{$IFNDEF CDA_DisableFunc_Length}
{$IFDEF CDA_HideFunc_Length}
Function _CDA_Length(const Arr: TCDAArrayType): Integer;
{$ELSE}
Function CDA_Length(const Arr: TCDAArrayType): Integer;
{$ENDIF}
begin
If CDA_Valid(Arr) then
  Result := Length(Arr.Arr)
else
  Result := 0;
end;
{$ENDIF}

//------------------------------------------------------------------------------

{$IFNDEF CDA_DisableFunc_Capacity}
{$IFDEF CDA_HideFunc_Capacity}
Function _CDA_Capacity(const Arr: TCDAArrayType): Integer;
{$ELSE}
Function CDA_Capacity(const Arr: TCDAArrayType): Integer;
{$ENDIF}
begin
Result := CDA_Length(Arr);
end;
{$ENDIF}

//------------------------------------------------------------------------------

{$IFNDEF CDA_DisableFunc_FreeCapacity}
{$IFDEF CDA_HideFunc_FreeCapacity}
Function _CDA_FreeCapacity(const Arr: TCDAArrayType): Integer;
{$ELSE}
Function CDA_FreeCapacity(const Arr: TCDAArrayType): Integer;
{$ENDIF}
begin
If CDA_Valid(Arr) then
  Result := Length(Arr.Arr) - Arr.Count
else
  Result := 0;
end;
{$ENDIF}

//------------------------------------------------------------------------------

{$IFNDEF CDA_DisableFunc_Count}
{$IFDEF CDA_HideFunc_Count}
Function _CDA_Count(const Arr: TCDAArrayType): Integer;
{$ELSE}
Function CDA_Count(const Arr: TCDAArrayType): Integer;
{$ENDIF}
begin
If CDA_Valid(Arr) then
  Result := Arr.Count
else
  Result := 0;
end;
{$ENDIF}

//------------------------------------------------------------------------------

{$IFNDEF CDA_DisableFunc_Low}
{$IFDEF CDA_HideFunc_Low}
Function _CDA_Low(const Arr: TCDAArrayType): Integer;
{$ELSE}
Function CDA_Low(const Arr: TCDAArrayType): Integer;
{$ENDIF}
begin
// no need to check validity, this will always return 0
Result := Low(Arr.Arr);
end;
{$ENDIF}

//------------------------------------------------------------------------------
 
{$IFNDEF CDA_DisableFunc_High}
{$IFDEF CDA_HideFunc_High}
Function _CDA_High(const Arr: TCDAArrayType): Integer;
{$ELSE}
Function CDA_High(const Arr: TCDAArrayType): Integer;
{$ENDIF}
begin
// CDA_Count checks for validity
Result := Pred(CDA_Count(Arr));
end;
{$ENDIF}

//------------------------------------------------------------------------------
 
{$IFNDEF CDA_DisableFunc_CheckIndex}
{$IFDEF CDA_HideFunc_CheckIndex}
Function _CDA_CheckIndex(const Arr: TCDAArrayType; Index: Integer): Boolean;
{$ELSE}
Function CDA_CheckIndex(const Arr: TCDAArrayType; Index: Integer): Boolean;
{$ENDIF}
begin
// CDA_High checks for validity
Result := (Index >= CDA_Low(Arr)) and (Index <= CDA_High(Arr));
end;
{$ENDIF}

//------------------------------------------------------------------------------
 
{$IFNDEF CDA_DisableFunc_SetLength}
{$IFDEF CDA_HideFunc_SetLength}
procedure _CDA_SetLength(var Arr: TCDAArrayType; NewLength: Integer);
{$ELSE}
procedure CDA_SetLength(var Arr: TCDAArrayType; NewLength: Integer);
{$ENDIF}
var
  i:  Integer;
begin
CDA_Validate(Arr);
If NewLength >= 0 then
  begin
    If NewLength < CDA_Count(Arr) then
      For i := NewLength to CDA_High(Arr) do
        CDA_ItemFinal(Arr.Arr[i]);
    SetLength(Arr.Arr,NewLength);
    If NewLength < CDA_Count(Arr) then
      Arr.Count := NewLength;
  end
else raise ERangeError.CreateFmt('CDA_SetLength: New length (%d) out of range.',[NewLength]);
end;
{$ENDIF}

//------------------------------------------------------------------------------

{$IFNDEF CDA_DisableFunc_SetCapacity}
{$IFDEF CDA_HideFunc_SetCapacity}
procedure _CDA_SetCapacity(var Arr: TCDAArrayType; NewCapacity: Integer);
{$ELSE}
procedure CDA_SetCapacity(var Arr: TCDAArrayType; NewCapacity: Integer);
{$ENDIF}
begin
CDA_SetLength(Arr,NewCapaCity);
end;
{$ENDIF}

//------------------------------------------------------------------------------

{$IFNDEF CDA_DisableFunc_Grow}
{$IFDEF CDA_HideFunc_Grow}
Function _CDA_Grow(var Arr: TCDAArrayType; GrowMode: TCDAGrowMode = agmFast; GrowFactor: Single = 1.0; DeltaMin: Integer = 1): Integer;
{$ELSE}
Function CDA_Grow(var Arr: TCDAArrayType; GrowMode: TCDAGrowMode = agmFast; GrowFactor: Single = 1.0; DeltaMin: Integer = 1): Integer;
{$ENDIF}
begin
CDA_Validate(Arr);
If DeltaMin < 1 then
  DeltaMin := 1;
If (CDA_Count(Arr) + DeltaMin) > CDA_Capacity(Arr) then
  begin
    If (CDA_Capacity(Arr) > 0) or (GrowMode = agmSlow) then
      case GrowMode of
        agmLinear:
          Result := Trunc(GrowFactor);
        agmFast:
          Result := Trunc(CDA_Capacity(Arr) * GrowFactor);
        agmFastAttenuated:
          If CDA_Capacity(Arr) >= CDA_GROW_ATTENUATE_THRESHOLD then
            Result := Trunc(CDA_GROW_ATTENUATE_THRESHOLD / 16)
          else
            Result := Trunc(CDA_Capacity(Arr) * GrowFactor);
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
    CDA_SetCapacity(Arr,CDA_Capacity(Arr) + Result);
  end
else Result := 0;
end;
{$ENDIF}

//------------------------------------------------------------------------------
 
{$IFNDEF CDA_DisableFunc_Shrink}
{$IFDEF CDA_HideFunc_Shrink}
procedure _CDA_Shrink(var Arr: TCDAArrayType; ShrinkMode: TCDAShrinkMode = asmNormal);
{$ELSE}
procedure CDA_Shrink(var Arr: TCDAArrayType; ShrinkMode: TCDAShrinkMode = asmNormal);
{$ENDIF}
begin
CDA_Validate(Arr);
If CDA_Capacity(Arr) > 0 then
  case ShrinkMode of
    asmNormal:  If CDA_Capacity(Arr) > CDA_INITIAL_CAPACITY then
                  begin
                    If CDA_Count(Arr) < (CDA_Capacity(Arr) div 4) then
                      CDA_SetCapacity(Arr,CDA_Capacity(Arr) div 4)
                  end
                else
                  begin
                    If CDA_Count(Arr) <= 0 then
                      CDA_SetCapacity(Arr,0);
                  end;
    asmToCount: CDA_SetCapacity(Arr,CDA_Count(Arr));
  else
   {asmKeepCap}
    // do nothing
  end;
end;
{$ENDIF}

//------------------------------------------------------------------------------

{$IFNDEF CDA_DisableFunc_UniqueArray}
{$IFDEF CDA_HideFunc_UniqueArray}
procedure _CDA_UniqueArray(var Arr: TCDAArrayType);
{$ELSE}
procedure CDA_UniqueArray(var Arr: TCDAArrayType);
{$ENDIF}
var
  i:  Integer;
begin
// CDA_SetLength validates the array
CDA_SetLength(Arr,CDA_Capacity(Arr));
For i := CDA_Low(Arr) to CDA_High(Arr) do
  CDA_ItemUnique(Arr.Arr[i]);
end;
{$ENDIF}

//------------------------------------------------------------------------------

{$IFNDEF CDA_DisableFunc_CopyP}
{$IFDEF FPCDWM}{$PUSH}W5093 W5094 W5060{$ENDIF}
{$IFDEF CDA_HideFunc_CopyP}
Function _CDA_Copy(const Src: TCDAArrayType; Index, Count: Integer): TCDAArrayType; overload;
{$ELSE}
Function CDA_Copy(const Src: TCDAArrayType; Index, Count: Integer): TCDAArrayType;
{$ENDIF}
var
  i:  Integer;
begin
CDA_Validate(Result);
// CDA_CheckIndex checks for validity of the source array
If CDA_CheckIndex(Src,Index) then
  begin
    If (Index + Count) > CDA_Count(Src) then
      Count := CDA_Count(Src) - Index;
    Result.Arr := Copy(Src.Arr,Index,Count);
    Result.SigA := CDA_SIGA;
    Result.Count := Count;
    Result.Data := Src.Data;
    Result.SigB := CDA_SIGB;
    For i := CDA_Low(Result) to CDA_High(Result) do
      CDA_ItemUnique(Result.Arr[i]);
  end;
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}
{$ENDIF}

//------------------------------------------------------------------------------

{$IFNDEF CDA_DisableFunc_Copy}
{$IFDEF FPCDWM}{$PUSH}W5093 W5094 W5060{$ENDIF}
{$IFDEF CDA_HideFunc_Copy}
Function _CDA_Copy(const Src: TCDAArrayType): TCDAArrayType; overload;
{$ELSE}
Function CDA_Copy(const Src: TCDAArrayType): TCDAArrayType;
{$ENDIF}
var
  i:  Integer;
begin
CDA_Validate(Result);
If CDA_Valid(Src) then
  begin
    Result.Arr := Copy(Src.Arr);
    Result.SigA := CDA_SIGA;
    Result.Count := Src.Count;
    Result.Data := Src.Data;
    Result.SigB := CDA_SIGB;
    For i := CDA_Low(Result) to CDA_High(Result) do
      CDA_ItemUnique(Result.Arr[i]);    
  end;
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}
{$ENDIF}

//------------------------------------------------------------------------------
  
{$IFNDEF CDA_DisableFunc_GetData}
{$IFDEF CDA_HideFunc_GetData}
Function _CDA_GetData(const Arr: TCDAArrayType): PtrInt;
{$ELSE}
Function CDA_GetData(const Arr: TCDAArrayType): PtrInt;
{$ENDIF}
begin
If CDA_Valid(Arr) then
  Result := Arr.Data
else
  Result := 0;
end;
{$ENDIF}

//------------------------------------------------------------------------------

{$IFNDEF CDA_DisableFunc_SetData}
{$IFDEF CDA_HideFunc_SetData}
procedure _CDA_SetData(var Arr: TCDAArrayType; Data: PtrInt);
{$ELSE}
procedure CDA_SetData(var Arr: TCDAArrayType; Data: PtrInt);
{$ENDIF}
begin
CDA_Validate(Arr);
Arr.Data := Data;
end;
{$ENDIF}

//------------------------------------------------------------------------------
   
{$IFNDEF CDA_DisableFunc_GetItem}
{$IFDEF CDA_HideFunc_GetItem}
Function _CDA_GetItem(const Arr: TCDAArrayType; Index: Integer): TCDABaseType;
{$ELSE}
Function CDA_GetItem(const Arr: TCDAArrayType; Index: Integer): TCDABaseType;
{$ENDIF}
begin
// CDA_CheckIndex checks for validity, exception is raised for invalid array
If CDA_CheckIndex(Arr,Index) then
  Result := Arr.Arr[Index]
else
  raise Exception.CreateFmt('CDA_GetItem: Index (%d) out of bounds.',[Index]);
end;
{$ENDIF}

//------------------------------------------------------------------------------

{$IFNDEF CDA_DisableFunc_GetItemPtr}
{$IFDEF CDA_HideFunc_GetItemPtr}
Function _CDA_GetItemPtr(const Arr: TCDAArrayType; Index: Integer): PCDABaseType;
{$ELSE}
Function CDA_GetItemPtr(const Arr: TCDAArrayType; Index: Integer): PCDABaseType;
{$ENDIF}
begin
// CDA_CheckIndex checks for validity, exception is raised for invalid array
If CDA_CheckIndex(Arr,Index) then
  Result := Addr(Arr.Arr[Index])
else
  raise Exception.CreateFmt('CDA_GetItemPtr: Index (%d) out of bounds.',[Index]);
end;
{$ENDIF}

//------------------------------------------------------------------------------
  
{$IFNDEF CDA_DisableFunc_SetItem}
{$IFDEF CDA_HideFunc_SetItem}
procedure _CDA_SetItem(var Arr: TCDAArrayType; Index: Integer; const Item: TCDABaseType);
{$ELSE}
procedure CDA_SetItem(var Arr: TCDAArrayType; Index: Integer; const Item: TCDABaseType);
{$ENDIF}
begin
// CDA_CheckIndex checks for validity, exception is raised for invalid array
If CDA_CheckIndex(Arr,Index) then
  Arr.Arr[Index] := Item
else
  raise Exception.CreateFmt('CDA_SetItem: Index (%d) out of bounds.',[Index]);
end;
{$ENDIF}

//------------------------------------------------------------------------------
    
{$IFNDEF CDA_DisableFunc_First}
{$IFDEF CDA_HideFunc_First}
Function _CDA_First(const Arr: TCDAArrayType): TCDABaseType;
{$ELSE}
Function CDA_First(const Arr: TCDAArrayType): TCDABaseType;
{$ENDIF}
begin
// CDA_Count checks for validity, exception is raised for invalid array
If CDA_Count(Arr) > 0 then
  Result := Arr.Arr[CDA_Low(Arr)]
else
  raise Exception.Create('CDA_First: Array is empty.');
end;
{$ENDIF}

//------------------------------------------------------------------------------
    
{$IFNDEF CDA_DisableFunc_Last}
{$IFDEF CDA_HideFunc_Last}
Function _CDA_Last(const Arr: TCDAArrayType): TCDABaseType;
{$ELSE}
Function CDA_Last(const Arr: TCDAArrayType): TCDABaseType;
{$ENDIF}
begin
// CDA_Count checks for validity, exception is raised for invalid array
If CDA_Count(Arr) > 0 then
  Result := Arr.Arr[CDA_High(Arr)]
else
  raise Exception.Create('CDA_Last: Array is empty.');
end;
{$ENDIF}

//------------------------------------------------------------------------------
    
{$IFNDEF CDA_DisableFunc_IndexOf}
{$IFDEF CDA_HideFunc_IndexOf}
Function _CDA_IndexOf(const Arr: TCDAArrayType; const Item: TCDABaseType): Integer;
{$ELSE}
Function CDA_IndexOf(const Arr: TCDAArrayType; const Item: TCDABaseType): Integer;
{$ENDIF}
var
  i:  Integer;
begin
Result := -1;
// CDA_High checks for validity, -1 is returned for invalid array
For i := CDA_Low(Arr) to CDA_High(Arr) do
  If CDA_CompareFunc(Arr.Arr[i],Item) = 0 then
    begin
      Result := i;
      Break{For i};
    end;
end;
{$ENDIF}

//------------------------------------------------------------------------------
    
{$IFNDEF CDA_DisableFunc_Add}
{$IFDEF CDA_HideFunc_Add}
Function _CDA_Add(var Arr: TCDAArrayType; const Item: TCDABaseType): Integer;
{$ELSE}
Function CDA_Add(var Arr: TCDAArrayType; const Item: TCDABaseType): Integer;
{$ENDIF}
begin
CDA_Validate(Arr);
CDA_Grow(Arr);
Result := CDA_Count(Arr);
Arr.Arr[Result] := Item;
Inc(Arr.Count);
end;
{$ENDIF}

//------------------------------------------------------------------------------

{$IFNDEF CDA_DisableFunc_Insert}
{$IFDEF CDA_HideFunc_Insert}
procedure _CDA_Insert(var Arr: TCDAArrayType; Index: Integer; const Item: TCDABaseType);
{$ELSE}
procedure CDA_Insert(var Arr: TCDAArrayType; Index: Integer; const Item: TCDABaseType);
{$ENDIF}
var
  i:  Integer;
begin
CDA_Validate(Arr);
If CDA_CheckIndex(Arr,Index) then
  begin
    CDA_Grow(Arr);
    For i := CDA_High(Arr) downto Index do
      Arr.Arr[i + 1] := Arr.Arr[i];
    Arr.Arr[Index] := Item;
    Inc(Arr.Count);
  end
else CDA_Add(Arr,Item);
end;
{$ENDIF}

//------------------------------------------------------------------------------
   
{$IFNDEF CDA_DisableFunc_Exchange}
{$IFDEF CDA_HideFunc_Exchange}
procedure _CDA_Exchange(var Arr: TCDAArrayType; Idx1, Idx2: Integer);
{$ELSE}
procedure CDA_Exchange(var Arr: TCDAArrayType; Idx1, Idx2: Integer);
{$ENDIF}
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
{$ENDIF}

//------------------------------------------------------------------------------
    
{$IFNDEF CDA_DisableFunc_Move}
{$IFDEF CDA_HideFunc_Move}
procedure _CDA_Move(var Arr: TCDAArrayType; SrcIdx, DstIdx: Integer);
{$ELSE}
procedure CDA_Move(var Arr: TCDAArrayType; SrcIdx, DstIdx: Integer);
{$ENDIF}
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
{$ENDIF}

//------------------------------------------------------------------------------
     
{$IFNDEF CDA_DisableFunc_Remove}
{$IFDEF CDA_HideFunc_Remove}
Function _CDA_Remove(var Arr: TCDAArrayType; const Item: TCDABaseType): Integer;
{$ELSE}
Function CDA_Remove(var Arr: TCDAArrayType; const Item: TCDABaseType): Integer;
{$ENDIF}
begin
CDA_Validate(Arr);
Result := CDA_IndexOf(Arr,Item);
If CDA_CheckIndex(Arr,Result) then
  CDA_Delete(Arr,Result);
end;
{$ENDIF}

//------------------------------------------------------------------------------
    
{$IFNDEF CDA_DisableFunc_Delete}
{$IFDEF CDA_HideFunc_Delete}
procedure _CDA_Delete(var Arr: TCDAArrayType; Index: Integer);
{$ELSE}
procedure CDA_Delete(var Arr: TCDAArrayType; Index: Integer);
{$ENDIF}
var
  i:  Integer;
begin
CDA_Validate(Arr);
If CDA_CheckIndex(Arr,Index) then
  begin
    CDA_ItemFinal(Arr.Arr[Index]);
    For i := Index to Pred(CDA_High(Arr)) do
      Arr.Arr[i] := Arr.Arr[i + 1];
    Dec(Arr.Count);
    CDA_Shrink(Arr);
  end
else raise Exception.CreateFmt('CDA_Delete: Index (%d) out of bounds.',[Index]);
end;
{$ENDIF}

//------------------------------------------------------------------------------
       
{$IFNDEF CDA_DisableFunc_Clear}
{$IFDEF CDA_HideFunc_Clear}
procedure _CDA_Clear(var Arr: TCDAArrayType);
{$ELSE}
procedure CDA_Clear(var Arr: TCDAArrayType);
{$ENDIF}
begin
CDA_SetLength(Arr,0);
end;
{$ENDIF}

//------------------------------------------------------------------------------
      
{$IFNDEF CDA_DisableFunc_Same}
{$IFDEF CDA_HideFunc_Same}
Function _CDA_Same(const Arr1, Arr2: TCDAArrayType): Boolean;
{$ELSE}
Function CDA_Same(const Arr1, Arr2: TCDAArrayType): Boolean;
{$ENDIF}
var
  i:  Integer;
begin
If CDA_Valid(Arr1) and CDA_Valid(Arr2) and (CDA_Count(Arr1) = CDA_Count(Arr2)) then
  begin
    Result := True;
    For i := CDA_Low(Arr1) to CDA_High(Arr1) do
      If CDA_CompareFunc(Arr1.Arr[i],Arr2.Arr[i]) <> 0 then
        begin
          Result := False;
          Break{For i};
        end;
  end
else Result := False;
end;
{$ENDIF}

//------------------------------------------------------------------------------
   
{$IFNDEF CDA_DisableFunc_Reverse}
{$IFDEF CDA_HideFunc_Reverse}
procedure _CDA_Reverse(var Arr: TCDAArrayType);
{$ELSE}
procedure CDA_Reverse(var Arr: TCDAArrayType);
{$ENDIF}
var
  i:    Integer;
  Temp: TCDABaseType;
begin
CDA_Validate(Arr);
If CDA_Count(Arr) > 1 then
  For i := CDA_Low(Arr) to Pred(CDA_Count(Arr) shr 1) do
    begin
      Temp := Arr.Arr[i];
      Arr.Arr[i] := Arr.Arr[CDA_High(Arr) - i];
      Arr.Arr[CDA_High(Arr) - i] := Temp;
    end;
end;
{$ENDIF}

//------------------------------------------------------------------------------

{$IFNDEF CDA_DisableFunc_Sort}
{$IFDEF CDA_HideFunc_Sort}
procedure _CDA_Sort(var Arr: TCDAArrayType; Reversed: Boolean = False);
{$ELSE}
procedure CDA_Sort(var Arr: TCDAArrayType; Reversed: Boolean = False);
{$ENDIF}
var
  Sorter: TListQuickSorter;
begin
CDA_Validate(Arr);
If CDA_Count(Arr) > 1 then
  begin
    Sorter := TListQuickSorter.Create(@Arr,CDA_ItemCompareSortFunc,CDA_ItemExchangeSortFunc);
    try
      Sorter.Reversed := Reversed;
      Sorter.Sort(CDA_Low(Arr),CDA_High(Arr));
    finally
      Sorter.Free;
    end;
  end;
end;
{$ENDIF}

{$ENDIF}
