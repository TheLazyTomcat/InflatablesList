unit InflatablesList_HTML_ElementFinder;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  Classes,
  AuxTypes,
  InflatablesList_HTML_TagAttributeArray, InflatablesList_HTML_Document;

type
  TILSearchOperator = (ilsoAND,ilsoOR,ilsoXOR);

type
  TILComparatorBase = class(TObject)
  protected
    fNegate:    Boolean;
    fOperator:  TILSearchOperator;
    fResult:    Boolean;
  public
    constructor Create;
    procedure ReInit; virtual;
    procedure SaveToStream(Stream: TStream); virtual;
    procedure LoadFromStream(Stream: TStream); virtual;
    property Negate: Boolean read fNegate write fNegate;
    property Operator: TILSearchOperator read fOperator write fOperator;
    property Result: Boolean read fResult;
  end;

//==============================================================================

  TILTextComparatorBase = class(TILComparatorBase)
  private
    Function Compare(const Text: String): Boolean; virtual; abstract;  
  end;

//------------------------------------------------------------------------------

  TILTextComparator = class(TILTextComparatorBase)
  protected
    fStr:           String;
    fCaseSensitive: Boolean;
    fAllowPartial:  Boolean;
  public
    constructor Create;
    Function Compare(const Text: String): Boolean; override;
    procedure SaveToStream(Stream: TStream); override;
    procedure LoadFromStream(Stream: TStream); override;
    property Str: String read fStr write fStr;
    property CaseSensitive: Boolean read fCaseSensitive write fCaseSensitive;
    property AllowPartial: Boolean read fAllowPartial write fAllowPartial;
  end;

//------------------------------------------------------------------------------

  TILTextComparatorGroup = class(TILTextComparatorBase)
  protected
    fItems: array of TILTextComparatorBase;
    Function GetItemCount: Integer;
    Function GetItem(Index: Integer): TILTextComparatorBase;
  public
    constructor Create;
    destructor Destroy; override;
    procedure ReInit; override;
    Function AddComparator(const Str: String; CaseSensitive, AllowPartial, Negate: Boolean; Operator: TILSearchOperator): TILTextComparator; virtual;
    Function AddGroup(Negate: Boolean; Operator: TILSearchOperator): TILTextComparatorGroup; virtual;
    procedure Delete(Index: Integer); virtual;
    procedure Clear; virtual;
    Function Compare(const Text: String): Boolean; override;
    procedure SaveToStream(Stream: TStream); override;
    procedure LoadFromStream(Stream: TStream); override;
    property Count: Integer read GetItemCount;
    property Items[Index: Integer]: TILTextComparatorBase read GetItem;
  end;

//==============================================================================

  TILAttributeComparatorBase = class(TILComparatorBase)
  public
    Function Compare(TagAttribute: TILTagAttribute): Boolean; virtual; abstract;
  end;

//------------------------------------------------------------------------------

  TILAttributeComparator = class(TILAttributeComparatorBase)
  protected
    fName:  TILTextComparatorGroup;
    fValue: TILTextComparatorGroup;
  public
    constructor Create;
    destructor Destroy; override;
    Function Compare(TagAttribute: TILTagAttribute): Boolean; override;
    procedure SaveToStream(Stream: TStream); override;
    procedure LoadFromStream(Stream: TStream); override;    
    property Name: TILTextComparatorGroup read fName;
    property Value: TILTextComparatorGroup read fValue;
  end;

//------------------------------------------------------------------------------

  TILAttributeComparatorGroup = class(TILAttributeComparatorBase)
  protected
    fItems: array of TILAttributeComparatorBase;
    Function GetItemCount: Integer;
    Function GetItem(Index: Integer): TILAttributeComparatorBase;
    Function GetResult: Boolean; virtual;
  public
    constructor Create;
    destructor Destroy; override;
    procedure ReInit; override;
    Function AddComparator(Negate: Boolean; Operator: TILSearchOperator): TILAttributeComparator; virtual;
    Function AddGroup(Negate: Boolean; Operator: TILSearchOperator): TILAttributeComparatorGroup; virtual;
    procedure Delete(Index: Integer); virtual;
    procedure Clear; virtual;
    procedure Compare(TagAttribute: TILTagAttribute); reintroduce;
    procedure SaveToStream(Stream: TStream); override;
    procedure LoadFromStream(Stream: TStream); override;
    property Count: Integer read GetItemCount;
    property Items[Index: Integer]: TILAttributeComparatorBase read GetItem;
    property Result: Boolean read GetResult;
  end;

//==============================================================================

  TILElementComparator = class(TObject)
  protected
    fTagName:           TILTextComparatorGroup;
    fAttributes:        TILAttributeComparatorGroup;
    fText:              TILTextComparatorGroup;
    fSearchNestedText:  Boolean;
    fResult:            Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    procedure ReInit; virtual;
    Function Compare(Element: TILHTMLElementNode): Boolean; virtual;
    property TagName: TILTextComparatorGroup read fTagName;
    property Attributes: TILAttributeComparatorGroup read fAttributes;
    property Text: TILTextComparatorGroup read fText;
    property SearchNestedText: Boolean read fSearchNestedText write fSearchNestedText;
    property Result: Boolean read fResult;
  end;

//******************************************************************************

Function IL_SearchOperatorToNum(SearchOperator: TILSearchOperator): Int32;
Function IL_NumToSearchOperator(Num: Int32): TILSearchOperator;

Function IL_CombineUsingOperator(A,B: Boolean; Operator: TILSearchOperator): Boolean;

implementation

uses
  SysUtils, StrUtils,
  BinaryStreaming;

const
  IL_SEARCH_TEXTCOMPARATOR      = 0;
  IL_SEARCH_TEXTCOMPARATORGROUP = 1;
  IL_SEARCH_ATTRCOMPARATOR      = 2;
  IL_SEARCH_ATTRCOMPARATORGROUP = 3;

Function IL_SearchOperatorToNum(SearchOperator: TILSearchOperator): Int32;
begin
case SearchOperator of
  ilsoOR:   Result := 1;
  ilsoXOR:  Result := 2;
else
  {ilsoAND}
  Result := 0;
end;
end;

//------------------------------------------------------------------------------

Function IL_NumToSearchOperator(Num: Int32): TILSearchOperator;
begin
case Num of
  1:  Result := ilsoOR;
  2:  Result := ilsoXOR;
else
  Result := ilsoAND;
end;
end;

//------------------------------------------------------------------------------

Function IL_CombineUsingOperator(A,B: Boolean; Operator: TILSearchOperator): Boolean;
begin
case Operator of
  ilsoOR:   Result := A or B;
  ilsoXOR:  Result := A xor B;
else
  {ilsoAND}
  Result := A and B;
end;
end;

//******************************************************************************
//******************************************************************************

constructor TILComparatorBase.Create;
begin
inherited Create;
fNegate := False;
fOperator := ilsoAND;
fResult := False;
end;

//------------------------------------------------------------------------------

procedure TILComparatorBase.ReInit;
begin
fResult := False;
end;

//------------------------------------------------------------------------------

procedure TILComparatorBase.SaveToStream(Stream: TStream);
begin
Stream_WriteBool(Stream,fNegate);
Stream_WriteInt32(Stream,IL_SearchOperatorToNum(fOperator));
end;

//------------------------------------------------------------------------------

procedure TILComparatorBase.LoadFromStream(Stream: TStream);
begin
fNegate := Stream_ReadBool(Stream);
fOperator := IL_NumToSearchOperator(Stream_ReadInt32(Stream));
end;

//******************************************************************************
//******************************************************************************

constructor TILTextComparator.Create;
begin
inherited Create;
fStr := '';
fCaseSensitive := False;
fAllowPartial := False;
end;

//------------------------------------------------------------------------------

Function TILTextComparator.Compare(const Text: String): Boolean;
begin
If fCaseSensitive then
  begin
    If fAllowPartial then
      Result := AnsiContainsStr(Text,fStr)
    else
      Result := AnsiSameStr(Text,fStr);
  end
else
  begin
    If fAllowPartial then
      Result := AnsiContainsText(Text,fStr)
    else
      Result := AnsiSameText(Text,fStr);
  end;
fResult := Result;
end;

//------------------------------------------------------------------------------

procedure TILTextComparator.SaveToStream(Stream: TStream);
begin
Stream_WriteUInt32(Stream,IL_SEARCH_TEXTCOMPARATOR);
inherited SaveToStream(Stream);
Stream_WriteString(Stream,fStr);
Stream_WriteBool(Stream,fCaseSensitive);
Stream_WriteBool(Stream,fAllowPartial);
end;

//------------------------------------------------------------------------------

procedure TILTextComparator.LoadFromStream(Stream: TStream);
begin
If Stream_ReadUInt32(Stream) <> IL_SEARCH_TEXTCOMPARATOR then
  raise Exception.Create('TILTextComparator.LoadFromStream: Invalid stream format.');
inherited LoadFromStream(Stream);
fStr := Stream_ReadString(Stream);
fCaseSensitive := Stream_ReadBool(Stream);
fAllowPartial := Stream_ReadBool(Stream);
end;

//******************************************************************************
//******************************************************************************

Function TILTextComparatorGroup.GetItemCount: Integer;
begin
Result := Length(fItems);
end;

//------------------------------------------------------------------------------

Function TILTextComparatorGroup.GetItem(Index: Integer): TILTextComparatorBase;
begin
If (Index <= Low(fItems)) and (Index >= High(fItems)) then
  Result := fItems[Index]
else
  raise Exception.CreateFmt('TILTextComparatorGroup.GetItem: Index (%d) out of bounds.',[Index]);
end;

//==============================================================================

constructor TILTextComparatorGroup.Create;
begin
inherited Create;
SetLength(fItems,0);
end;

//------------------------------------------------------------------------------

destructor TILTextComparatorGroup.Destroy;
begin
Clear;
inherited;
end;

//------------------------------------------------------------------------------

procedure TILTextComparatorGroup.ReInit;
var
  i:  Integer;
begin
inherited;
For i := Low(fItems) to High(fItems) do
  fItems[i].ReInit;
end;

//------------------------------------------------------------------------------

Function TILTextComparatorGroup.AddComparator(const Str: String; CaseSensitive, AllowPartial, Negate: Boolean; Operator: TILSearchOperator): TILTextComparator;
begin
SetLength(fItems,Length(fItems) + 1);
fItems[High(fItems)] := TILTextComparator.Create;
Result := TILTextComparator(fItems[High(fItems)]);
Result.Negate := Negate;
Result.Operator := Operator;
Result.Str := Str;
Result.CaseSensitive := CaseSensitive;
Result.AllowPartial := AllowPartial;
end;

//------------------------------------------------------------------------------

Function TILTextComparatorGroup.AddGroup(Negate: Boolean; Operator: TILSearchOperator): TILTextComparatorGroup;
begin
SetLength(fItems,Length(fItems) + 1);
fItems[High(fItems)] := TILTextComparatorGroup.Create;
Result := TILTextComparatorGroup(fItems[High(fItems)]);
Result.Negate := Negate;
Result.Operator := Operator;
end;

//------------------------------------------------------------------------------

procedure TILTextComparatorGroup.Delete(Index: Integer);
var
  i:  Integer;
begin
If (Index <= Low(fItems)) and (Index >= High(fItems)) then
  begin
    fItems[Index].Free;
    For i := Index to Pred(High(fItems)) do
      fItems[i] := fItems[i + 1];
    SetLength(fItems,Length(fItems) - 1);
  end
else raise Exception.CreateFmt('TILTextComparatorGroup.Delete: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

procedure TILTextComparatorGroup.Clear;
var
  i:  Integer;
begin
For i := Low(fItems) to High(fItems) do
  fItems[i].Free;
SetLength(fItems,0);
end;

//------------------------------------------------------------------------------

Function TILTextComparatorGroup.Compare(const Text: String): Boolean;
var
  i:  Integer;
begin
If Length(fItems) > 0 then
  begin
    Result := fItems[Low(fItems)].Compare(Text);
    For i := Succ(Low(fItems)) to High(fItems) do
      If fItems[i].Negate then
        Result := IL_CombineUsingOperator(Result,not fItems[i].Compare(Text),fItems[i].Operator)
      else
        Result := IL_CombineUsingOperator(Result,fItems[i].Compare(Text),fItems[i].Operator);
  end
else Result := False;
fResult := Result;
end;

//------------------------------------------------------------------------------

procedure TILTextComparatorGroup.SaveToStream(Stream: TStream);
var
  i:  Integer;
begin
Stream_WriteUInt32(Stream,IL_SEARCH_TEXTCOMPARATORGROUP);
inherited SaveToStream(Stream);
Stream_WriteUInt32(Stream,Length(fItems));
For i := Low(fItems) to High(fItems) do
  fItems[i].SaveToStream(Stream);
end;

//------------------------------------------------------------------------------

procedure TILTextComparatorGroup.LoadFromStream(Stream: TStream);
var
  i:  Integer;
begin
Clear;
If not Stream_ReadUInt32(Stream) <> IL_SEARCH_TEXTCOMPARATORGROUP then
  raise Exception.Create('TILTextComparatorGroup.LoadFromStream: Invalid stream format.');
inherited LoadFromStream(Stream);
SetLength(fItems,Stream_ReadUInt32(Stream));
For i := Low(fItems) to High(fItems) do
  begin
    case Stream_ReadUInt32(Stream,False) of
      IL_SEARCH_TEXTCOMPARATOR:       fItems[i] := TILTextComparator.Create;
      IL_SEARCH_TEXTCOMPARATORGROUP:  fItems[i] := TILTextComparatorGroup.Create;
    else
      raise Exception.Create('TILTextComparatorGroup.LoadFromStream: Invalid subitem.');
    end;
    fItems[i].LoadFromStream(Stream);
  end;
end;

//******************************************************************************
//******************************************************************************

constructor TILAttributeComparator.Create;
begin
inherited Create;
fName := TILTextComparatorGroup.Create;
fValue := TILTextComparatorGroup.Create;
end;

//------------------------------------------------------------------------------

destructor TILAttributeComparator.Destroy;
begin
fValue.Free;
fName.Free;
inherited;
end;

//------------------------------------------------------------------------------

Function TILAttributeComparator.Compare(TagAttribute: TILTagAttribute): Boolean;
begin
If (fName.Count > 0) and (fValue.Count > 0) then
  Result := fName.Compare(TagAttribute.Name) and fValue.Compare(TagAttribute.Value)
else If fName.Count > 0 then
  Result := fName.Compare(TagAttribute.Name)
else If fValue.Count > 0  then
  Result := fValue.Compare(TagAttribute.Value)
else
  Result := False;
end;

//------------------------------------------------------------------------------

procedure TILAttributeComparator.SaveToStream(Stream: TStream);
begin
Stream_WriteUInt32(Stream,IL_SEARCH_ATTRCOMPARATOR);
inherited SaveToStream(Stream);
fName.SaveToStream(Stream);
fValue.SaveToStream(Stream);
end;

//------------------------------------------------------------------------------

procedure TILAttributeComparator.LoadFromStream(Stream: TStream);
begin
If not Stream_ReadUInt32(Stream) <> IL_SEARCH_ATTRCOMPARATOR then
  raise Exception.Create('TILAttributeComparator.LoadFromStream: Invalid stream format.');
inherited LoadFromStream(Stream);
fName.LoadFromStream(Stream);
fValue.LoadFromStream(Stream);
end;

//******************************************************************************
//******************************************************************************

Function TILAttributeComparatorGroup.GetItemCount: Integer;
begin
Result := Length(fItems);
end;

//------------------------------------------------------------------------------

Function TILAttributeComparatorGroup.GetItem(Index: Integer): TILAttributeComparatorBase;
begin
If (Index <= Low(fItems)) and (Index >= High(fItems)) then
  Result := fItems[Index]
else
  raise Exception.CreateFmt('TILAttributeComparator.GetItem: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

Function TILAttributeComparatorGroup.GetResult: Boolean;
var
  i:  Integer;
begin
If Length(fItems) > 0 then
  begin
    Result := fItems[Low(fItems)].Result;
    For i := Succ(Low(fItems)) to High(fItems) do
      If fItems[i].Negate then
        Result := IL_CombineUsingOperator(Result,not fItems[i].Result,fItems[i].Operator)
      else
        Result := IL_CombineUsingOperator(Result,fItems[i].Result,fItems[i].Operator);
  end
else Result := False;
end;

//==============================================================================

constructor TILAttributeComparatorGroup.Create;
begin
inherited Create;
SetLength(fItems,0);
end;

//------------------------------------------------------------------------------

destructor TILAttributeComparatorGroup.Destroy;
begin
Clear;
inherited;
end;

//------------------------------------------------------------------------------

procedure TILAttributeComparatorGroup.ReInit;
var
  i:  Integer;
begin
inherited;
For i := Low(fItems) to High(fItems) do
  fItems[i].ReInit;
end;

//------------------------------------------------------------------------------

Function TILAttributeComparatorGroup.AddComparator(Negate: Boolean; Operator: TILSearchOperator): TILAttributeComparator;
begin
SetLength(fItems,Length(fItems) + 1);
fItems[High(fItems)] := TILAttributeComparator.Create;
Result := TILAttributeComparator(fItems[High(fItems)]);
Result.Negate := Negate;
Result.Operator := Operator;
end;

//------------------------------------------------------------------------------

Function TILAttributeComparatorGroup.AddGroup(Negate: Boolean; Operator: TILSearchOperator): TILAttributeComparatorGroup;
begin
SetLength(fItems,Length(fItems) + 1);
fItems[High(fItems)] := TILAttributeComparatorGroup.Create;
Result := TILAttributeComparatorGroup(fItems[High(fItems)]);
Result.Negate := Negate;
Result.Operator := Operator;
end;

//------------------------------------------------------------------------------

procedure TILAttributeComparatorGroup.Delete(Index: Integer);
var
  i:  Integer;
begin
If (Index <= Low(fItems)) and (Index >= High(fItems)) then
  begin
    fItems[Index].Free;
    For i := Index to Pred(High(fItems)) do
      fItems[i] := fItems[i + 1];
    SetLength(fItems,Length(fItems) - 1);
  end
else raise Exception.CreateFmt('TILAttributeComparatorGroup.Delete: Index (%d) out of bounds.',[Index]);
end;


//------------------------------------------------------------------------------

procedure TILAttributeComparatorGroup.Clear;
var
  i:  Integer;
begin
For i := Low(fItems) to High(fItems) do
  fItems[i].Free;
SetLength(fItems,0);
end;

//------------------------------------------------------------------------------

procedure TILAttributeComparatorGroup.Compare(TagAttribute: TILTagAttribute);
var
  i:  Integer;
begin
For i := Low(fItems) to High(fItems) do
  If not fItems[i].Result then
    fItems[i].Compare(TagAttribute);
end;

//------------------------------------------------------------------------------

procedure TILAttributeComparatorGroup.SaveToStream(Stream: TStream);
var
  i:  Integer;
begin
Stream_WriteUInt32(Stream,IL_SEARCH_ATTRCOMPARATORGROUP);
inherited SaveToStream(Stream);
Stream_WriteUInt32(Stream,Length(fItems));
For i := Low(fItems) to High(fItems) do
  fItems[i].SaveToStream(Stream);
end;

//------------------------------------------------------------------------------

procedure TILAttributeComparatorGroup.LoadFromStream(Stream: TStream);
var
  i:  Integer;
begin
Clear;
If not Stream_ReadUInt32(Stream) <> IL_SEARCH_TEXTCOMPARATORGROUP then
  raise Exception.Create('TILAttributeComparatorGroup.LoadFromStream: Invalid stream format.');
inherited LoadFromStream(Stream);
SetLength(fItems,Stream_ReadUInt32(Stream));
For i := Low(fItems) to High(fItems) do
  begin
    case Stream_ReadUInt32(Stream,False) of
      IL_SEARCH_ATTRCOMPARATOR:       fItems[i] := TILAttributeComparator.Create;
      IL_SEARCH_ATTRCOMPARATORGROUP:  fItems[i] := TILAttributeComparatorGroup.Create;
    else
      raise Exception.Create('TILAttributeComparatorGroup.LoadFromStream: Invalid subitem.');
    end;
    fItems[i].LoadFromStream(Stream);
  end;
end;

//******************************************************************************
//******************************************************************************

constructor TILElementComparator.Create;
begin
inherited Create;
fTagName := TILTextComparatorGroup.Create;
fAttributes := TILAttributeComparatorGroup.Create;
fText := TILTextComparatorGroup.Create;
end;

//------------------------------------------------------------------------------

destructor TILElementComparator.Destroy;
begin
fText.Free;
fAttributes.Free;
fTagName.Free;
inherited;
end;

//------------------------------------------------------------------------------

procedure TILElementComparator.ReInit;
begin
fTagName.ReInit;
fAttributes.ReInit;
fText.ReInit;
fResult := False;
end;

//------------------------------------------------------------------------------

Function TILElementComparator.Compare(Element: TILHTMLElementNode): Boolean;
var
  i:  Integer;
begin
If fTagName.Compare(Element.Name) then
  begin
    If fAttributes.Count > 0 then
      begin
        For i := 0 to Pred(Element.AttributeCount) do
          fAttributes.Compare(Element.Attributes[i]);

      end
  end
else Result := False;
fResult := Result;
end;

end.
