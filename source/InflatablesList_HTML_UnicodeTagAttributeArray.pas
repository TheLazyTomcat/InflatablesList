unit InflatablesList_HTML_UnicodeTagAttributeArray;

{$INCLUDE '.\InflatablesList_defs.inc'}

{$INCLUDE '.\CountedDynArrays_defs.inc'}

{$DEFINE CDA_FuncOverride_ItemUnique}
{$DEFINE CDA_FuncOverride_ItemCompare}

interface

uses
  AuxTypes, CountedDynArrays,
  InflatablesList_HTML_Common;

type
  TILUnicodeTagAttribute = record
    Name:   UnicodeString;
    Value:  UnicodeString;
  end;
  PILUnicodeTagAttribute = ^TILUnicodeTagAttribute;

  TCDABaseType = TILUnicodeTagAttribute;
  PCDABaseType = ^TCDABaseType;

  TCountedDynArrayUnicodeTagAttribute = record
  {$DEFINE CDA_Structure}
    {$INCLUDE '.\CountedDynArrays.inc'}
  {$UNDEF CDA_Structure}
  end;
  PCountedDynArrayUnicodeTagAttribute = ^TCountedDynArrayUnicodeTagAttribute;

  // aliases
  TCountedDynArrayOfUnicodeTagAttribute = TCountedDynArrayUnicodeTagAttribute;
  PCountedDynArrayOfUnicodeTagAttribute = PCountedDynArrayUnicodeTagAttribute;

  TUnicodeTagAttributeCountedDynArray = TCountedDynArrayUnicodeTagAttribute;
  PUnicodeTagAttributeCountedDynArray = PCountedDynArrayUnicodeTagAttribute;

  TCDAArrayType = TCountedDynArrayUnicodeTagAttribute;
  PCDAArrayType = PCountedDynArrayUnicodeTagAttribute;

{$DEFINE CDA_Interface}
{$INCLUDE '.\CountedDynArrays.inc'}
{$UNDEF CDA_Interface}

implementation

uses
  SysUtils,
  ListSorters,
  InflatablesList_HTML_Utils;

Function CDA_ItemCompare(const A,B: TCDABaseType): Integer;
begin
Result := -IL_UnicodeCompareString(A.Name,B.Name,False);
end;

//------------------------------------------------------------------------------

procedure CDA_ItemUnique(var Item: TCDABaseType); {$IFDEF CanInline} inline; {$ENDIF}
begin
UniqueString(Item.Name);
UniqueString(Item.Value);
end;

//------------------------------------------------------------------------------

{$DEFINE CDA_Implementation}
{$INCLUDE '.\CountedDynArrays.inc'}
{$UNDEF CDA_Implementation}

end.
