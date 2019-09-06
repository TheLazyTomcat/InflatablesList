unit InflatablesList_HTML_UnicodeTagAttributeArray;

{$INCLUDE '.\InflatablesList_defs.inc'}

{$INCLUDE '.\CountedDynArrays_defs.inc'}

{$DEFINE CDA_FuncOverride_ItemUnique}
{$DEFINE CDA_FuncOverride_ItemCompare}

interface

uses
  AuxTypes, CountedDynArrays;

type
  TILHTMLUnicodeTagAttribute = record
    Name:   UnicodeString;
    Value:  UnicodeString;
  end;

procedure IL_UniqueHTMLUnicodeTagAtribute(var Value: TILHTMLUnicodeTagAttribute);

Function IL_ThreadSafeCopy(Value: TILHTMLUnicodeTagAttribute): TILHTMLUnicodeTagAttribute; overload;

//==============================================================================

type
  TCDABaseType = TILHTMLUnicodeTagAttribute;
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

procedure IL_UniqueHTMLUnicodeTagAtribute(var Value: TILHTMLUnicodeTagAttribute);
begin
UniqueString(Value.Name);
UniqueString(Value.Value);
end;

//------------------------------------------------------------------------------

Function IL_ThreadSafeCopy(Value: TILHTMLUnicodeTagAttribute): TILHTMLUnicodeTagAttribute;
begin
Result := Value;
IL_UniqueHTMLUnicodeTagAtribute(Result);
end;

//==============================================================================

Function CDA_ItemCompare(const A,B: TCDABaseType): Integer;
begin
Result := -IL_UnicodeCompareString(A.Name,B.Name,False);
end;

//------------------------------------------------------------------------------

procedure CDA_ItemUnique(var Item: TCDABaseType); {$IFDEF CanInline} inline; {$ENDIF}
begin
IL_UniqueHTMLUnicodeTagAtribute(Item);
end;

//------------------------------------------------------------------------------

{$DEFINE CDA_Implementation}
{$INCLUDE '.\CountedDynArrays.inc'}
{$UNDEF CDA_Implementation}

end.
