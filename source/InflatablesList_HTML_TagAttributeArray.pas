unit InflatablesList_HTML_TagAttributeArray;

{$INCLUDE '.\InflatablesList_defs.inc'}

{$INCLUDE '.\CountedDynArrays_defs.inc'}

{$DEFINE CDA_FuncOverride_ItemUnique}
{$DEFINE CDA_FuncOverride_ItemCompare}

interface

uses
  AuxTypes, CountedDynArrays,
  InflatablesList_Types;

type
  TILHTMLTagAttribute = record
    Name:   TILReconvString;
    Value:  TILReconvString;
  end;

procedure IL_UniqueHTMLTagAtribute(var Value: TILHTMLTagAttribute);

Function IL_ThreadSafeCopy(Value: TILHTMLTagAttribute): TILHTMLTagAttribute; overload;

//==============================================================================

type
  TCDABaseType = TILHTMLTagAttribute;
  PCDABaseType = ^TCDABaseType;

  TILCountedDynArrayTagAttribute = record
  {$DEFINE CDA_Structure}
    {$INCLUDE '.\CountedDynArrays.inc'}
  {$UNDEF CDA_Structure}
  end;
  PILCountedDynArrayTagAttribute = ^TILCountedDynArrayTagAttribute;

  // aliases
  TILCountedDynArrayOfTagAttribute = TILCountedDynArrayTagAttribute;
  PILCountedDynArrayOfTagAttribute = PILCountedDynArrayTagAttribute;

  TILTagAttributeCountedDynArray = TILCountedDynArrayTagAttribute;
  PILTagAttributeCountedDynArray = PILCountedDynArrayTagAttribute;

  TCDAArrayType = TILCountedDynArrayTagAttribute;
  PCDAArrayType = PILCountedDynArrayTagAttribute;

{$DEFINE CDA_Interface}
{$INCLUDE '.\CountedDynArrays.inc'}
{$UNDEF CDA_Interface}

implementation

uses
  SysUtils,
  ListSorters;

procedure IL_UniqueHTMLTagAtribute(var Value: TILHTMLTagAttribute);
begin
IL_UniqueReconvStr(Value.Name);
IL_UniqueReconvStr(Value.Value);
end;

//------------------------------------------------------------------------------

Function IL_ThreadSafeCopy(Value: TILHTMLTagAttribute): TILHTMLTagAttribute;
begin
Result := Value;
IL_UniqueHTMLTagAtribute(Result);
end;

//==============================================================================

Function CDA_ItemCompare(const A,B: TCDABaseType): Integer;
begin
Result := -IL_ReconvCompareText(A.Name,B.Name);
end;

//------------------------------------------------------------------------------

procedure CDA_ItemUnique(var Item: TCDABaseType); {$IFDEF CanInline} inline; {$ENDIF}
begin
IL_UniqueHTMLTagAtribute(Item);
end;

//------------------------------------------------------------------------------

{$DEFINE CDA_Implementation}
{$INCLUDE '.\CountedDynArrays.inc'}
{$UNDEF CDA_Implementation}

end.
