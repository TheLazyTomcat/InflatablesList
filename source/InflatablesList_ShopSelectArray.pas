unit InflatablesList_ShopSelectArray;

{$INCLUDE '.\InflatablesList_defs.inc'}

{$INCLUDE '.\CountedDynArrays_defs.inc'}

{$DEFINE CDA_FuncOverride_ItemUnique}
{$DEFINE CDA_FuncOverride_ItemCompare}

interface

uses
  AuxTypes, CountedDynArrays,
  InflatablesList_ShopSelectItemsArray;

type
  TILSelectionShopEntry = record
    ShopName:   String;
    Items:      TILCountedDynArrayShopSelectItem;
    Available:  Integer;
    Selected:   Integer;
    PriceOfSel: UInt32;
  end;

  TCDABaseType = TILSelectionShopEntry;
  PCDABaseType = ^TCDABaseType;

  TILCountedDynArraySelectionShops = record
  {$DEFINE CDA_Structure}
    {$INCLUDE '.\CountedDynArrays.inc'}
  {$UNDEF CDA_Structure}
  end;
  PILCountedDynArraySelectionShops = ^TILCountedDynArraySelectionShops;

  // aliases
  TILCountedDynArrayOfSelectionShops = TILCountedDynArraySelectionShops;
  PILCountedDynArrayOfSelectionShops = PILCountedDynArraySelectionShops;

  TILSelectionShopsCountedDynArray = TILCountedDynArraySelectionShops;
  PILSelectionShopsCountedDynArray = PILCountedDynArraySelectionShops;

  TCDAArrayType = TILCountedDynArraySelectionShops;
  PCDAArrayType = PILCountedDynArraySelectionShops;

{$DEFINE CDA_Interface}
{$INCLUDE '.\CountedDynArrays.inc'}
{$UNDEF CDA_Interface}

implementation

uses
  SysUtils,
  ListSorters,
  InflatablesList_Utils;

procedure CDA_ItemUnique(var Item: TCDABaseType); {$IFDEF CanInline} inline; {$ENDIF}
begin
UniqueString(Item.ShopName);
end;

//------------------------------------------------------------------------------

Function CDA_ItemCompare(const A,B: TCDABaseType): Integer;
begin
Result := -IL_CompareText(A.ShopName,B.ShopName);
end;

//------------------------------------------------------------------------------

{$DEFINE CDA_Implementation}
{$INCLUDE '.\CountedDynArrays.inc'}
{$UNDEF CDA_Implementation} 

end.
