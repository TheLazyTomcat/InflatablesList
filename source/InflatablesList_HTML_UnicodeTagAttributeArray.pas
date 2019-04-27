unit InflatablesList_HTML_UnicodeTagAttributeArray;

{$INCLUDE '.\InflatablesList_defs.inc'}
{$INCLUDE '.\CountedDynArrays_defs.inc'}

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

  TILUnicodeTagAttributeCountedDynArray = record
    Arr:    array of TILUnicodeTagAttribute;
    SigA:   UInt32;
    Count:  Integer;
    Data:   PtrInt;
    SigB:   UInt32;
  end;
  PILUnicodeTagAttributeCountedDynArray = ^TILUnicodeTagAttributeCountedDynArray;

  TCDABaseType = TILUnicodeTagAttribute;
  PCDABaseType = PILUnicodeTagAttribute;

  TCDAArrayType = TILUnicodeTagAttributeCountedDynArray;
  PCDAArrayType = PILUnicodeTagAttributeCountedDynArray;

{$DEFINE CDA_DisableFunc_ItemUnique}

{$DEFINE CDA_Interface}
{$INCLUDE '.\CountedDynArrays.inc'}
{$UNDEF CDA_Interface}

implementation

uses
  SysUtils,
  ListSorters,
  InflatablesList_Utils;

Function CDA_CompareFunc(const A,B: TCDABaseType): Integer;
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
