unit InflatablesList_HTML_TagAttributeArray;

{$INCLUDE '.\InflatablesList_defs.inc'}
{$INCLUDE '.\CountedDynArrays_defs.inc'}

interface

uses
  AuxTypes, CountedDynArrays;

type
  TILTagAttribute = record
    Name:   String;
    Value:  String;
  end;
  PILTagAttribute = ^TILTagAttribute;

  TILTagAttributeCountedDynArray = record
    Arr:    array of TILTagAttribute;
    SigA:   UInt32;
    Count:  Integer;
    Data:   PtrInt;
    SigB:   UInt32;
  end;
  PILTagAttributeCountedDynArray = ^TILTagAttributeCountedDynArray;

  TCDABaseType = TILTagAttribute;
  PCDABaseType = PILTagAttribute;

  TCDAArrayType = TILTagAttributeCountedDynArray;
  PCDAArrayType = PILTagAttributeCountedDynArray;

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
Result := -AnsiCompareText(A.Name,B.Name);
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
