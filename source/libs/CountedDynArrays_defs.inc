{$IF defined(CPU64) or defined(CPU64BITS)}
  {$DEFINE 64bit}
{$ELSEIF defined(CPU16)}
  {$DEFINE 16bit}
{$ELSE}
  {$DEFINE 32bit}
{$IFEND}

{$IF Defined(WINDOWS) or Defined(MSWINDOWS)}
  {$DEFINE Windows}
{$IFEND}

{$IFDEF FPC}
  {$MODE ObjFPC}{$H+}
  {$MODESWITCH CLASSICPROCVARS+}
  {$INLINE ON}
  {$DEFINE CanInline}
  {$DEFINE FPC_DisableWarns}
  {$MACRO ON}
{$ELSE}
  {$IF CompilerVersion >= 17 then}  // Delphi 2005+
    {$DEFINE CanInline}
  {$ELSE}
    {$UNDEF CanInline}
  {$IFEND}
{$ENDIF}

//------------------------------------------------------------------------------
// do not touch following defines...

{$UNDEF CDA_Structure}
{$UNDEF CDA_Interface}
{$UNDEF CDA_Implemantation}

{$UNDEF CDA_ConstBaseType}
{$UNDEF CDA_CaseSensitiveBaseType}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{$UNDEF CDA_FuncOverride_ItemInit}
{$UNDEF CDA_FuncOverride_ItemFinal}
{$UNDEF CDA_FuncOverride_ItemUnique}
{$UNDEF CDA_FuncOverride_ItemCompare}

{$UNDEF CDA_FuncOverride_SortFunc_ItemCompare}
{$UNDEF CDA_FuncOverride_SortFunc_ItemCompareStabilized}
{$UNDEF CDA_FuncOverride_SortFunc_ItemExchange}
{$UNDEF CDA_FuncOverride_SortFunc_ItemExchangeStabilized}

{$UNDEF CDA_FuncOverride_Valid}
{$UNDEF CDA_FuncOverride_Validate}
{$UNDEF CDA_FuncOverride_Init}

{$UNDEF CDA_FuncOverride_GetUserData}
{$UNDEF CDA_FuncOverride_SetUserData}

{$UNDEF CDA_FuncOverride_Length}
{$UNDEF CDA_FuncOverride_Capacity}
{$UNDEF CDA_FuncOverride_CapacityFree}
{$UNDEF CDA_FuncOverride_Count}

{$UNDEF CDA_FuncOverride_SetLength}
{$UNDEF CDA_FuncOverride_SetCapacity}
{$UNDEF CDA_FuncOverride_SetCount}

{$UNDEF CDA_FuncOverride_Grow}
{$UNDEF CDA_FuncOverride_Shrink}

{$UNDEF CDA_FuncOverride_UniqueArray}
{$UNDEF CDA_FuncOverride_CopyP}
{$UNDEF CDA_FuncOverride_Copy}

{$UNDEF CDA_FuncOverride_Low}
{$UNDEF CDA_FuncOverride_High}
{$UNDEF CDA_FuncOverride_CheckIndex}

{$UNDEF CDA_FuncOverride_GetItem}
{$UNDEF CDA_FuncOverride_GetItemPtr}
{$UNDEF CDA_FuncOverride_SetItem}

{$UNDEF CDA_FuncOverride_First}
{$UNDEF CDA_FuncOverride_Last}
{$UNDEF CDA_FuncOverride_FirstPtr}
{$UNDEF CDA_FuncOverride_LastPtr}

{$UNDEF CDA_FuncOverride_IndexOf}
{$UNDEF CDA_FuncOverride_Add}
{$UNDEF CDA_FuncOverride_Append}
{$UNDEF CDA_FuncOverride_Insert}
{$UNDEF CDA_FuncOverride_Exchange}
{$UNDEF CDA_FuncOverride_Move}
{$UNDEF CDA_FuncOverride_Extract}
{$UNDEF CDA_FuncOverride_Remove}
{$UNDEF CDA_FuncOverride_Delete}
{$UNDEF CDA_FuncOverride_Clear}

{$UNDEF CDA_FuncOverride_ArrayPtr}
{$UNDEF CDA_FuncOverride_Compare}
{$UNDEF CDA_FuncOverride_Same}
{$UNDEF CDA_FuncOverride_Reverse}
{$UNDEF CDA_FuncOverride_Sort}
{$UNDEF CDA_FuncOverride_SortStabilized}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{$UNDEF CDA_FuncReintroduce_ItemInit}
{$UNDEF CDA_FuncReintroduce_ItemFinal}
{$UNDEF CDA_FuncReintroduce_ItemUnique}
{$UNDEF CDA_FuncReintroduce_ItemCompare}

{$UNDEF CDA_FuncReintroduce_SortFunc_ItemCompare}
{$UNDEF CDA_FuncReintroduce_SortFunc_ItemCompareStabilized}
{$UNDEF CDA_FuncReintroduce_SortFunc_ItemExchange}
{$UNDEF CDA_FuncReintroduce_SortFunc_ItemExchangeStabilized}

{$UNDEF CDA_FuncReintroduce_Valid}
{$UNDEF CDA_FuncReintroduce_Validate}
{$UNDEF CDA_FuncReintroduce_Init}

{$UNDEF CDA_FuncReintroduce_GetUserData}
{$UNDEF CDA_FuncReintroduce_SetUserData}

{$UNDEF CDA_FuncReintroduce_Length}
{$UNDEF CDA_FuncReintroduce_Capacity}
{$UNDEF CDA_FuncReintroduce_CapacityFree}
{$UNDEF CDA_FuncReintroduce_Count}

{$UNDEF CDA_FuncReintroduce_SetLength}
{$UNDEF CDA_FuncReintroduce_SetCapacity}
{$UNDEF CDA_FuncReintroduce_SetCount}

{$UNDEF CDA_FuncReintroduce_Grow}
{$UNDEF CDA_FuncReintroduce_Shrink}

{$UNDEF CDA_FuncReintroduce_UniqueArray}
{$UNDEF CDA_FuncReintroduce_CopyP}
{$UNDEF CDA_FuncReintroduce_Copy}

{$UNDEF CDA_FuncReintroduce_Low}
{$UNDEF CDA_FuncReintroduce_High}
{$UNDEF CDA_FuncReintroduce_CheckIndex}

{$UNDEF CDA_FuncReintroduce_GetItem}
{$UNDEF CDA_FuncReintroduce_GetItemPtr}
{$UNDEF CDA_FuncReintroduce_SetItem}

{$UNDEF CDA_FuncReintroduce_First}
{$UNDEF CDA_FuncReintroduce_Last}
{$UNDEF CDA_FuncReintroduce_FirstPtr}
{$UNDEF CDA_FuncReintroduce_LastPtr}

{$UNDEF CDA_FuncReintroduce_IndexOf}
{$UNDEF CDA_FuncReintroduce_Add}
{$UNDEF CDA_FuncReintroduce_Append}
{$UNDEF CDA_FuncReintroduce_Insert}
{$UNDEF CDA_FuncReintroduce_Exchange}
{$UNDEF CDA_FuncReintroduce_Move}
{$UNDEF CDA_FuncReintroduce_Extract}
{$UNDEF CDA_FuncReintroduce_Remove}
{$UNDEF CDA_FuncReintroduce_Delete}
{$UNDEF CDA_FuncReintroduce_Clear}

{$UNDEF CDA_FuncReintroduce_ArrayPtr}
{$UNDEF CDA_FuncReintroduce_Compare}
{$UNDEF CDA_FuncReintroduce_Same}
{$UNDEF CDA_FuncReintroduce_Reverse}
{$UNDEF CDA_FuncReintroduce_Sort}
{$UNDEF CDA_FuncReintroduce_SortStabilized}
