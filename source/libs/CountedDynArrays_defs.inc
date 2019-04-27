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
// do not touch following...

{$UNDEF CDA_Interface}
{$UNDEF CDA_Implemantation}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{$UNDEF CDA_DisableFunc_ItemCompareSortFunc}
{$UNDEF CDA_DisableFunc_ItemExchangeSortFunc}
{$UNDEF CDA_DisableFunc_ItemFinal}
{$UNDEF CDA_DisableFunc_ItemUnique}

{$UNDEF CDA_DisableFunc_Valid}
{$UNDEF CDA_DisableFunc_Validate}
{$UNDEF CDA_DisableFunc_Init}
{$UNDEF CDA_DisableFunc_ArrayPtr}

{$UNDEF CDA_DisableFunc_Length}
{$UNDEF CDA_DisableFunc_Capacity}
{$UNDEF CDA_DisableFunc_FreeCapacity}
{$UNDEF CDA_DisableFunc_Count}

{$UNDEF CDA_DisableFunc_Low}
{$UNDEF CDA_DisableFunc_High}
{$UNDEF CDA_DisableFunc_CheckIndex}

{$UNDEF CDA_DisableFunc_SetLength}
{$UNDEF CDA_DisableFunc_SetCapacity}

{$UNDEF CDA_DisableFunc_Grow}
{$UNDEF CDA_DisableFunc_Shrink}

{$UNDEF CDA_DisableFunc_UniqueArray}
{$UNDEF CDA_DisableFunc_CopyP}
{$UNDEF CDA_DisableFunc_Copy}

{$UNDEF CDA_DisableFunc_GetData}
{$UNDEF CDA_DisableFunc_SetData}

{$UNDEF CDA_DisableFunc_GetItem}
{$UNDEF CDA_DisableFunc_GetItemPtr}
{$UNDEF CDA_DisableFunc_SetItem}

{$UNDEF CDA_DisableFunc_First}
{$UNDEF CDA_DisableFunc_Last}

{$UNDEF CDA_DisableFunc_IndexOf}
{$UNDEF CDA_DisableFunc_Add}
{$UNDEF CDA_DisableFunc_Insert}
{$UNDEF CDA_DisableFunc_Exchange}
{$UNDEF CDA_DisableFunc_Move}
{$UNDEF CDA_DisableFunc_Remove}
{$UNDEF CDA_DisableFunc_Delete}
{$UNDEF CDA_DisableFunc_Clear}

{$UNDEF CDA_DisableFunc_Same}
{$UNDEF CDA_DisableFunc_Reverse}
{$UNDEF CDA_DisableFunc_Sort}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{$UNDEF CDA_HideFunc_ItemCompareSortFunc}
{$UNDEF CDA_HideFunc_ItemExchangeSortFunc}
{$UNDEF CDA_HideFunc_ItemFinal}
{$UNDEF CDA_HideFunc_ItemUnique}

{$UNDEF CDA_HideFunc_Valid}
{$UNDEF CDA_HideFunc_Validate}
{$UNDEF CDA_HideFunc_Init}
{$UNDEF CDA_HideFunc_ArrayPtr}

{$UNDEF CDA_HideFunc_Length}
{$UNDEF CDA_HideFunc_Capacity}
{$UNDEF CDA_HideFunc_FreeCapacity}
{$UNDEF CDA_HideFunc_Count}

{$UNDEF CDA_HideFunc_Low}
{$UNDEF CDA_HideFunc_High}
{$UNDEF CDA_HideFunc_CheckIndex}

{$UNDEF CDA_HideFunc_SetLength}
{$UNDEF CDA_HideFunc_SetCapacity}

{$UNDEF CDA_HideFunc_Grow}
{$UNDEF CDA_HideFunc_Shrink}

{$UNDEF CDA_HideFunc_UniqueArray}
{$UNDEF CDA_HideFunc_CopyP}
{$UNDEF CDA_HideFunc_Copy}

{$UNDEF CDA_HideFunc_GetData}
{$UNDEF CDA_HideFunc_SetData}

{$UNDEF CDA_HideFunc_GetItem}
{$UNDEF CDA_HideFunc_GetItemPtr}
{$UNDEF CDA_HideFunc_SetItem}

{$UNDEF CDA_HideFunc_First}
{$UNDEF CDA_HideFunc_Last}

{$UNDEF CDA_HideFunc_IndexOf}
{$UNDEF CDA_HideFunc_Add}
{$UNDEF CDA_HideFunc_Insert}
{$UNDEF CDA_HideFunc_Exchange}
{$UNDEF CDA_HideFunc_Move}
{$UNDEF CDA_HideFunc_Remove}
{$UNDEF CDA_HideFunc_Delete}
{$UNDEF CDA_HideFunc_Clear}

{$UNDEF CDA_HideFunc_Same}
{$UNDEF CDA_HideFunc_Reverse}
{$UNDEF CDA_HideFunc_Sort}
