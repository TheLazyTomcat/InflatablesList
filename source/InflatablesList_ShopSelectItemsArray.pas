unit InflatablesList_ShopSelectItemsArray;
{$message 'll_rework'}

{$INCLUDE '.\InflatablesList_defs.inc'}

{$INCLUDE '.\CountedDynArrays_defs.inc'}

{$DEFINE CDA_FuncOverride_ItemCompare}

interface

uses
  AuxTypes, CountedDynArrays,
  InflatablesList_Item;

type
  TILShopSelectItemEntry = record
    ItemObject: TILItem;
    Available:  Boolean;
    Selected:   Boolean;
    Index:      Integer;
    Price:      UInt32;    
  end;

  TCDABaseType = TILShopSelectItemEntry;
  PCDABaseType = ^TCDABaseType;

  TILCountedDynArrayShopSelectItem = record
  {$DEFINE CDA_Structure}
    {$INCLUDE '.\CountedDynArrays.inc'}
  {$UNDEF CDA_Structure}
  end;
  PILCountedDynArrayShopSelectItem = ^TILCountedDynArrayShopSelectItem;

  // aliases
  TILCountedDynArrayOfShopSelectItem = TILCountedDynArrayShopSelectItem;
  PILCountedDynArrayOfShopSelectItem = PILCountedDynArrayShopSelectItem;

  TILShopSelectItemCountedDynArray = TILCountedDynArrayShopSelectItem;
  PILShopSelectItemCountedDynArray = PILCountedDynArrayShopSelectItem;

  TCDAArrayType = TILCountedDynArrayShopSelectItem;
  PCDAArrayType = PILCountedDynArrayShopSelectItem;

{$DEFINE CDA_Interface}
{$INCLUDE '.\CountedDynArrays.inc'}
{$UNDEF CDA_Interface}

implementation

uses
  SysUtils,
  ListSorters;

Function CDA_ItemCompare(const A,B: TCDABaseType): Integer;
begin
// first by selected, then by available, and at the end by index in the main list
If (A.Selected = B.Selected) and (A.Available = B.Available) then
  Result := B.Index - A.Index
else If A.Selected and not B.Selected then
  Result := +1
else If B.Selected and not A.Selected then
  Result := -1
else If A.Available and not B.Available then
  Result := +1
else If B.Available and not A.Available then
  Result := -1
else
  Result := 0;
end;

//------------------------------------------------------------------------------

{$DEFINE CDA_Implementation}
{$INCLUDE '.\CountedDynArrays.inc'}
{$UNDEF CDA_Implementation}

end.
