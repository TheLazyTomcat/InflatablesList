unit InflatablesList_HTML_ElementFinder;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  Classes,
  AuxTypes,
  InflatablesList_Types,
  InflatablesList_HTML_TagAttributeArray, InflatablesList_HTML_Document;

type
  TILSearchOperator = (ilsoAND,ilsoOR,ilsoXOR);

type
  TILFinderBaseClass = class(TObject)
  protected
    fVariablesPtr:  PILItemShopParsingVariables;
  public
    constructor Create;
    constructor CreateAsCopy(Source: TILFinderBaseClass);
    procedure Prepare(VariablesPtr: PILItemShopParsingVariables); virtual;
    property VariablesPtr: PILItemShopParsingVariables read fVariablesPtr;
  end;

  TILComparatorBase = class(TILFinderBaseClass)
  protected
    fVariableIdx: Integer;
    fNegate:      Boolean;
    fOperator:    TILSearchOperator;
    fResult:      Boolean;
  public
    constructor Create;
    constructor CreateAsCopy(Source: TILComparatorBase);
    procedure ReInit; virtual;
    procedure SaveToStream(Stream: TStream); virtual;
    procedure LoadFromStream(Stream: TStream); virtual;
    property VariableIndex: Integer read fVariableIdx write fVariableIdx;
    property Negate: Boolean read fNegate write fNegate;
    property Operator: TILSearchOperator read fOperator write fOperator;
    property Result: Boolean read fResult;
  end;

//==============================================================================

  TILTextComparatorBase = class(TILComparatorBase)
  private
    procedure Compare(const Text: String); virtual; abstract;
  end;

//------------------------------------------------------------------------------

  TILTextComparator = class(TILTextComparatorBase)
  protected
    fStr:           String;
    fCaseSensitive: Boolean;
    fAllowPartial:  Boolean;
  public
    constructor Create;
    constructor CreateAsCopy(Source: TILTextComparator);
    procedure Compare(const Text: String); override;
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
    constructor CreateAsCopy(Source: TILTextComparatorGroup);
    destructor Destroy; override;
    procedure Prepare(VariablesPtr: PILItemShopParsingVariables); override;
    procedure ReInit; override;
    Function AddComparator(Negate: Boolean = False; Operator: TILSearchOperator = ilsoAND): TILTextComparator; virtual;
    Function AddGroup(Negate: Boolean = False; Operator: TILSearchOperator = ilsoAND): TILTextComparatorGroup; virtual;
    procedure Delete(Index: Integer); virtual;
    procedure Clear; virtual;
    procedure Compare(const Text: String); override;
    procedure SaveToStream(Stream: TStream); override;
    procedure LoadFromStream(Stream: TStream); override;
    property Count: Integer read GetItemCount;
    property Items[Index: Integer]: TILTextComparatorBase read GetItem;
  end;

//==============================================================================

  TILAttributeComparatorBase = class(TILComparatorBase)
  public
    procedure Compare(TagAttribute: TILTagAttribute); virtual; abstract;
  end;

//------------------------------------------------------------------------------

  TILAttributeComparator = class(TILAttributeComparatorBase)
  protected
    fName:  TILTextComparatorGroup;
    fValue: TILTextComparatorGroup;
  public
    constructor Create;
    constructor CreateAsCopy(Source: TILAttributeComparator);
    destructor Destroy; override;
    procedure Prepare(VariablesPtr: PILItemShopParsingVariables); override;
    procedure ReInit; override;
    procedure Compare(TagAttribute: TILTagAttribute); override;
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
  public
    constructor Create;
    constructor CreateAsCopy(Source: TILAttributeComparatorGroup);
    destructor Destroy; override;
    procedure Prepare(VariablesPtr: PILItemShopParsingVariables); override;
    procedure ReInit; override;
    Function AddComparator(Negate: Boolean = False; Operator: TILSearchOperator = ilsoAND): TILAttributeComparator; virtual;
    Function AddGroup(Negate: Boolean = False; Operator: TILSearchOperator = ilsoAND): TILAttributeComparatorGroup; virtual;
    procedure Delete(Index: Integer); virtual;
    procedure Clear; virtual;
    procedure Compare(TagAttribute: TILTagAttribute); override;
    procedure SaveToStream(Stream: TStream); override;
    procedure LoadFromStream(Stream: TStream); override;
    property Count: Integer read GetItemCount;
    property Items[Index: Integer]: TILAttributeComparatorBase read GetItem;
  end;

//==============================================================================

  TILElementComparator = class(TILFinderBaseClass)
  protected
    fTagName:           TILTextComparatorGroup;
    fAttributes:        TILAttributeComparatorGroup;
    fText:              TILTextComparatorGroup;
    fSearchNestedText:  Boolean;
    fResult:            Boolean;
  public
    constructor Create;
    constructor CreateAsCopy(Source: TILElementComparator);
    destructor Destroy; override;
    procedure Prepare(VariablesPtr: PILItemShopParsingVariables); override;
    procedure ReInit; virtual;
    procedure Compare(Element: TILHTMLElementNode); virtual;
    procedure SaveToStream(Stream: TStream); virtual;
    procedure LoadFromStream(Stream: TStream); virtual;    
    property TagName: TILTextComparatorGroup read fTagName;
    property Attributes: TILAttributeComparatorGroup read fAttributes;
    property Text: TILTextComparatorGroup read fText;
    property SearchNestedText: Boolean read fSearchNestedText write fSearchNestedText;
    property Result: Boolean read fResult;
  end;

  TILElementComparatorGroup = class(TILFinderBaseClass)
  protected
    fItems: array of TILElementComparator;
    Function GetItemCount: Integer;
    Function GetItem(Index: Integer): TILElementComparator;
  public
    constructor Create;
    constructor CreateAsCopy(Source: TILElementComparatorGroup);
    destructor Destroy; override;
    procedure Prepare(VariablesPtr: PILItemShopParsingVariables); override;
    procedure ReInit; virtual;
    Function AddComparator: TILElementComparator; virtual;
    procedure Delete(Index: Integer); virtual;
    procedure Clear; virtual;
    Function Compare(Element: TILHTMLElementNode): Boolean; virtual;
    procedure SaveToStream(Stream: TStream); virtual;
    procedure LoadFromStream(Stream: TStream); virtual;
    property Count: Integer read GetItemCount;
    property Items[Index: Integer]: TILElementComparator read GetItem;
  end;

//==============================================================================

  TILElementFinder = class(TILFinderBaseClass)
  private
    fStages: array of TILElementComparatorGroup;
    Function GetStageCount: Integer;
    Function GetStage(Index: Integer): TILElementComparatorGroup;
  public
    constructor Create;
    constructor CreateAsCopy(Source: TILElementFinder);
    destructor Destroy; override;
    procedure Prepare(VariablesPtr: PILItemShopParsingVariables); override;
    procedure ReInit; virtual;
    Function StageAdd: TILElementComparatorGroup; virtual;
    procedure StageDelete(Index: Integer); virtual;
    procedure StageClear; virtual;
    Function FindElement(Document: TILHTMLDocument; out Element: TILHTMLElementNode): Boolean; virtual;
    procedure SaveToStream(Stream: TStream); virtual;
    procedure LoadFromStream(Stream: TStream); virtual;
    property StageCount: Integer read GetStageCount;
    property Stages[Index: Integer]: TILElementComparatorGroup read GetStage; default;
  end;

//******************************************************************************

Function IL_SearchOperatorToNum(SearchOperator: TILSearchOperator): Int32;
Function IL_NumToSearchOperator(Num: Int32): TILSearchOperator;

Function IL_CombineUsingOperator(A,B: Boolean; Operator: TILSearchOperator): Boolean;

implementation

uses
  SysUtils, StrUtils,
  BinaryStreaming, CountedDynArrayObject;

const
  IL_SEARCH_TEXTCOMPARATOR         = 0;
  IL_SEARCH_TEXTCOMPARATORGROUP    = 1;
  IL_SEARCH_ATTRCOMPARATOR         = 2;
  IL_SEARCH_ATTRCOMPARATORGROUP    = 3;
  IL_SEARCH_ELEMENTCOMPARATOR      = 4;
  IL_SEARCH_ELEMENTCOMPARATORGROUP = 5;

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

constructor TILFinderBaseClass.Create;
begin
inherited Create;
fVariablesPtr := nil;
end;

//------------------------------------------------------------------------------

constructor TILFinderBaseClass.CreateAsCopy(Source: TILFinderBaseClass);
begin
Create;
fVariablesPtr := Source.VariablesPtr;
end;

//------------------------------------------------------------------------------

procedure TILFinderBaseClass.Prepare(VariablesPtr: PILItemShopParsingVariables);
begin
fVariablesPtr := VariablesPtr;
end;

//******************************************************************************
//******************************************************************************

constructor TILComparatorBase.Create;
begin
inherited Create;
fVariableIdx := -1;
fNegate := False;
fOperator := ilsoAND;
fResult := False;
end;

//------------------------------------------------------------------------------

constructor TILComparatorBase.CreateAsCopy(Source: TILComparatorBase);
begin
inherited CreateAsCopy(Source);
fVariableIdx := Source.VariableIndex;
fNegate := Source.Negate;
fOperator := Source.Operator;
fResult := Source.Result;
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

constructor TILTextComparator.CreateAsCopy(Source: TILTextComparator);
begin
inherited CreateAsCopy(Source);
fStr := Source.Str;
UniqueString(fStr);
fCaseSensitive := Source.CaseSensitive;
fAllowPartial := Source.AllowPartial;
end;

//------------------------------------------------------------------------------

procedure TILTextComparator.Compare(const Text: String);
var
  Temp: String;
begin
If Assigned(fVariablesPtr) then
  begin
    If (fVariableIdx >= Low(fVariablesPtr^.Vars)) and (fVariableIdx <= High(fVariablesPtr^.Vars)) then
      Temp := fVariablesPtr^.Vars[fVariableIdx]
    else
      Temp := Text;
    If fCaseSensitive then
      begin
        If fAllowPartial then
          fResult := AnsiContainsStr(Temp,fStr)
        else
          fResult := AnsiSameStr(Temp,fStr);
      end
    else
      begin
        If fAllowPartial then
          fResult := AnsiContainsText(Temp,fStr)
        else
          fResult := AnsiSameText(Temp,fStr);
      end;
  end
else fResult := False;
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

constructor TILTextComparatorGroup.CreateAsCopy(Source: TILTextComparatorGroup);
var
  i:  Integer;
begin
inherited CreateAsCopy(Source);
SetLength(fItems,Source.Count);
For i := Low(fItems) to High(fItems) do
  If Source.Items[i] is TILTextComparatorGroup then
    fItems[i] := TILTextComparatorGroup.CreateAsCopy(TILTextComparatorGroup(Source.Items[i]))
  else
    fItems[i] := TILTextComparator.CreateAsCopy(TILTextComparator(Source.Items[i]));
end;

//------------------------------------------------------------------------------

destructor TILTextComparatorGroup.Destroy;
begin
Clear;
inherited;
end;

//------------------------------------------------------------------------------

procedure TILTextComparatorGroup.Prepare(VariablesPtr: PILItemShopParsingVariables);
var
  i:  Integer;
begin
inherited Prepare(VariablesPtr);
For i := Low(fItems) to High(fItems) do
  fItems[i].Prepare(VariablesPtr);
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

Function TILTextComparatorGroup.AddComparator(Negate: Boolean = False; Operator: TILSearchOperator = ilsoAND): TILTextComparator;
begin
SetLength(fItems,Length(fItems) + 1);
fItems[High(fItems)] := TILTextComparator.Create;
Result := TILTextComparator(fItems[High(fItems)]);
Result.Negate := Negate;
Result.Operator := Operator;
end;

//------------------------------------------------------------------------------

Function TILTextComparatorGroup.AddGroup(Negate: Boolean = False; Operator: TILSearchOperator = ilsoAND): TILTextComparatorGroup;
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

procedure TILTextComparatorGroup.Compare(const Text: String);
var
  i:  Integer;
begin
If Length(fItems) > 0 then
  begin
    // do comparison
    For i := Low(fItems) to High(fItems) do
      fItems[i].Compare(Text);
    // combine results
    fResult := fItems[Low(fItems)].Result;
    For i := Succ(Low(fItems)) to High(fItems) do
      If fItems[i].Negate then
        fResult := IL_CombineUsingOperator(fResult,not fItems[i].Result,fItems[i].Operator)
      else
        fResult := IL_CombineUsingOperator(fResult,fItems[i].Result,fItems[i].Operator);
  end
else fResult := False;
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

constructor TILAttributeComparator.CreateAsCopy(Source: TILAttributeComparator);
begin
inherited CreateAsCopy(Source);
fName := TILTextComparatorGroup.CreateAsCopy(Source.Name);
fValue := TILTextComparatorGroup.CreateAsCopy(Source.Value);
end;

//------------------------------------------------------------------------------

destructor TILAttributeComparator.Destroy;
begin
fValue.Free;
fName.Free;
inherited;
end;

//------------------------------------------------------------------------------

procedure TILAttributeComparator.Prepare(VariablesPtr: PILItemShopParsingVariables);
begin
inherited Prepare(VariablesPtr);
fName.Prepare(VariablesPtr);
fValue.Prepare(VariablesPtr);
end;

//------------------------------------------------------------------------------

procedure TILAttributeComparator.ReInit;
begin
inherited;
fName.ReInit;
fValue.ReInit;
end;

//------------------------------------------------------------------------------

procedure TILAttributeComparator.Compare(TagAttribute: TILTagAttribute);
begin
// compare
fName.Compare(TagAttribute.Name);
fValue.Compare(TagAttribute.Value);
// combine results
If (fName.Count > 0) and (fValue.Count > 0) then
  fResult := fName.Result and fValue.Result
else If fName.Count > 0 then
  fResult := fName.Result
else If fValue.Count > 0  then
  fResult := fValue.Result
else
  fResult := False;
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

//==============================================================================

constructor TILAttributeComparatorGroup.Create;
begin
inherited Create;
SetLength(fItems,0);
end;

//------------------------------------------------------------------------------

constructor TILAttributeComparatorGroup.CreateAsCopy(Source: TILAttributeComparatorGroup);
var
  i:  Integer;
begin
inherited CreateAsCopy(Source);
SetLength(fItems,Source.Count);
For i := Low(fItems) to High(fItems) do
  If Source.Items[i] is TILAttributeComparatorGroup then
    fItems[i] := TILAttributeComparatorGroup.CreateAsCopy(TILAttributeComparatorGroup(Source.Items[i]))
  else
    fItems[i] := TILAttributeComparator.CreateAsCopy(TILAttributeComparator(Source.Items[i]));
end;

//------------------------------------------------------------------------------

destructor TILAttributeComparatorGroup.Destroy;
begin
Clear;
inherited;
end;

//------------------------------------------------------------------------------

procedure TILAttributeComparatorGroup.Prepare(VariablesPtr: PILItemShopParsingVariables);
var
  i:  Integer;
begin
inherited Prepare(VariablesPtr);
For i := Low(fItems) to High(fItems) do
  fItems[i].Prepare(VariablesPtr);
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

Function TILAttributeComparatorGroup.AddComparator(Negate: Boolean = False; Operator: TILSearchOperator = ilsoAND): TILAttributeComparator;
begin
SetLength(fItems,Length(fItems) + 1);
fItems[High(fItems)] := TILAttributeComparator.Create;
Result := TILAttributeComparator(fItems[High(fItems)]);
Result.Negate := Negate;
Result.Operator := Operator;
end;

//------------------------------------------------------------------------------

Function TILAttributeComparatorGroup.AddGroup(Negate: Boolean = False; Operator: TILSearchOperator = ilsoAND): TILAttributeComparatorGroup;
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
// compare
For i := Low(fItems) to High(fItems) do
  If not fItems[i].Result then
    fItems[i].Compare(TagAttribute);
// combine results
If Length(fItems) > 0 then
  begin
    fResult := fItems[Low(fItems)].Result;
    For i := Succ(Low(fItems)) to High(fItems) do
      If fItems[i].Negate then
        fResult := IL_CombineUsingOperator(fResult,not fItems[i].Result,fItems[i].Operator)
      else
        fResult := IL_CombineUsingOperator(fResult,fItems[i].Result,fItems[i].Operator);
  end
else fResult := False;
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

constructor TILElementComparator.CreateAsCopy(Source: TILElementComparator);
begin
inherited CreateAsCopy(Source);
fTagName := TILTextComparatorGroup.CreateAsCopy(Source.TagName);
fAttributes := TILAttributeComparatorGroup.CreateAsCopy(Source.Attributes);
fText := TILTextComparatorGroup.CreateAsCopy(Source.Text);
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

procedure TILElementComparator.Prepare(VariablesPtr: PILItemShopParsingVariables);
begin
inherited Prepare(VariablesPtr);
fTagName.Prepare(VariablesPtr);
fAttributes.Prepare(VariablesPtr);
fText.Prepare(VariablesPtr);
end;

//------------------------------------------------------------------------------

procedure TILElementComparator.ReInit;
begin
inherited;
fTagName.ReInit;
fAttributes.ReInit;
fText.ReInit;
fResult := False;
end;

//------------------------------------------------------------------------------

procedure TILElementComparator.Compare(Element: TILHTMLElementNode);
var
  i:  Integer;
begin
fTagName.Compare(Element.Name);
fResult := fTagName.Result;
If fResult then
  begin
    // name match, look for attributes match...
    If fAttributes.Count > 0 then
      begin
        For i := 0 to Pred(Element.AttributeCount) do
          fAttributes.Compare(Element.Attributes[i]);
        // get result and combine it with name
        fResult := fResult and fAttributes.Result;
      end;
    // and now for the text...
    If fText.Count > 0 then
      begin
        If fSearchNestedText then
          fText.Compare(Element.NestedText)
        else
          fText.Compare(Element.Text);
        fResult := fResult and fText.Result;
      end;
  end;
end;

//------------------------------------------------------------------------------

procedure TILElementComparator.SaveToStream(Stream: TStream);
begin
Stream_WriteUInt32(Stream,IL_SEARCH_ELEMENTCOMPARATOR);
fTagName.SaveToStream(Stream);
fAttributes.SaveToStream(Stream);
fText.SaveToStream(Stream);
Stream_WriteBool(Stream,fSearchNestedText);
end;

//------------------------------------------------------------------------------

procedure TILElementComparator.LoadFromStream(Stream: TStream);
begin
If not Stream_ReadUInt32(Stream) <> IL_SEARCH_ELEMENTCOMPARATOR then
  raise Exception.Create('TILElementComparator.LoadFromStream: Invalid stream format.');
fTagName.LoadFromStream(Stream);
fAttributes.LoadFromStream(Stream);
fText.LoadFromStream(Stream);
fSearchNestedText := Stream_ReadBool(Stream);
end;

//******************************************************************************
//******************************************************************************

Function TILElementComparatorGroup.GetItemCount: Integer;
begin
Result := Length(fItems);
end;

//------------------------------------------------------------------------------

Function TILElementComparatorGroup.GetItem(Index: Integer): TILElementComparator;
begin
If (Index <= Low(fItems)) and (Index >= High(fItems)) then
  Result := fItems[Index]
else
  raise Exception.CreateFmt('TILElementComparatorGroup.GetItem: Index (%d) out of bounds.',[Index]);
end;

//==============================================================================

constructor TILElementComparatorGroup.Create;
begin
inherited Create;
SetLength(fItems,0);
end;

//------------------------------------------------------------------------------

constructor TILElementComparatorGroup.CreateAsCopy(Source: TILElementComparatorGroup);
var
  i:  Integer;
begin
inherited CreateAsCopy(Source);
SetLength(fItems,Source.Count);
For i := Low(fItems) to High(fItems) do
  fItems[i] := TILElementComparator.CreateAsCopy(Source.Items[i]);
end;

//------------------------------------------------------------------------------

destructor TILElementComparatorGroup.Destroy;
begin
Clear;
inherited;
end;

//------------------------------------------------------------------------------

procedure TILElementComparatorGroup.Prepare(VariablesPtr: PILItemShopParsingVariables);
var
  i:  Integer;
begin
inherited Prepare(VariablesPtr);
For i := Low(fItems) to High(fItems) do
  fItems[i].Prepare(VariablesPtr);
end;

//------------------------------------------------------------------------------

procedure TILElementComparatorGroup.ReInit;
var
  i:  Integer;
begin
For i := Low(fItems) to High(fItems) do
  fItems[i].ReInit;
end;

//------------------------------------------------------------------------------

Function TILElementComparatorGroup.AddComparator: TILElementComparator;
begin
SetLength(fItems,Length(fItems) + 1);
fItems[High(fItems)] := TILElementComparator.Create;
Result := fItems[High(fItems)];
end;

//------------------------------------------------------------------------------

procedure TILElementComparatorGroup.Delete(Index: Integer);
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
else raise Exception.CreateFmt('TILElementComparatorGroup.Delete: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

procedure TILElementComparatorGroup.Clear;
var
  i:  Integer;
begin
For i := Low(fItems) to High(fItems) do
  fItems[i].Free;
SetLength(fItems,0);
end;

//------------------------------------------------------------------------------

Function TILElementComparatorGroup.Compare(Element: TILHTMLElementNode): Boolean;
var
  i:  Integer;
begin
If Length(fItems) > 0 then
  begin
    // compare
    For i := Low(fItems) to High(fItems) do
      fItems[i].Compare(Element);
    // get result
    Result := fItems[Low(fItems)].Result;
    For i := Succ(Low(fItems)) to High(fItems) do
      Result := Result or fItems[i].Result;
  end
else Result := False;
end;

//------------------------------------------------------------------------------

procedure TILElementComparatorGroup.SaveToStream(Stream: TStream);
var
  i:  Integer;
begin
Stream_WriteUInt32(Stream,IL_SEARCH_ELEMENTCOMPARATORGROUP);
Stream_WriteUInt32(Stream,Length(fItems));
For i := Low(fItems) to High(fItems) do
  fItems[i].SaveToStream(Stream);
end;

//------------------------------------------------------------------------------

procedure TILElementComparatorGroup.LoadFromStream(Stream: TStream);
var
  i:  Integer;
begin
Clear;
If not Stream_ReadUInt32(Stream) <> IL_SEARCH_ELEMENTCOMPARATORGROUP then
  raise Exception.Create('TILElementComparatorGroup.LoadFromStream: Invalid stream format.');
SetLength(fItems,Stream_ReadUInt32(Stream));
For i := Low(fItems) to High(fItems) do
  begin
    fItems[i] := TILElementComparator.Create;
    fItems[i].LoadFromStream(Stream);
  end;
end;

//******************************************************************************
//******************************************************************************

Function TILElementFinder.GetStageCount: Integer;
begin
Result := Length(fStages);
end;

//------------------------------------------------------------------------------

Function TILElementFinder.GetStage(Index: Integer): TILElementComparatorGroup;
begin
If (Index <= Low(fStages)) and (Index >= High(fStages)) then
  Result := fStages[Index]
else
  raise Exception.CreateFmt('TILElementFinder.GetStage: Index (%d) out of bounds.',[Index]);
end;

//==============================================================================

constructor TILElementFinder.Create;
begin
inherited Create;
SetLength(fStages,0);
end;

//------------------------------------------------------------------------------

constructor TILElementFinder.CreateAsCopy(Source: TILElementFinder);
var
  i:  Integer;
begin
inherited CreateAsCopy(Source);
SetLength(fStages,Source.StageCount);
For i := Low(fStages) to High(fStages) do
  fStages[i] := TILElementComparatorGroup.CreateAsCopy(Source.Stages[i]);
end;

//------------------------------------------------------------------------------

destructor TILElementFinder.Destroy;
begin
StageClear;
inherited;
end;

//------------------------------------------------------------------------------

procedure TILElementFinder.Prepare(VariablesPtr: PILItemShopParsingVariables);
var
  i:  Integer;
begin
inherited Prepare(VariablesPtr);
For i := Low(fStages) to High(fStages) do
  fStages[i].Prepare(VariablesPtr);
end;

//------------------------------------------------------------------------------

procedure TILElementFinder.ReInit;
var
  i:  Integer;
begin
For i := Low(fStages) to High(fStages) do
  fStages[i].ReInit;
end;

//------------------------------------------------------------------------------

Function TILElementFinder.StageAdd: TILElementComparatorGroup;
begin
SetLength(fStages,Length(fStages) + 1);
fStages[High(fStages)] := TILElementComparatorGroup.Create;
Result := fStages[High(fStages)];
end;
 
//------------------------------------------------------------------------------

procedure TILElementFinder.StageDelete(Index: Integer);
var
  i:  Integer;
begin
If (Index <= Low(fStages)) and (Index >= High(fStages)) then
  begin
    fStages[Index].Free;
    For i := Index to Pred(High(fStages)) do
      fStages[i] := fStages[i + 1];
    SetLength(fStages,Length(fStages) - 1);
  end
else raise Exception.CreateFmt('TILElementFinder.StageDelete: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

procedure TILElementFinder.StageClear;
var
  i:  Integer;
begin
For i := Low(fStages) to High(fStages) do
  fStages[i].Free;
SetLength(fStages,0);
end;

//------------------------------------------------------------------------------

Function TILElementFinder.FindElement(Document: TILHTMLDocument; out Element: TILHTMLElementNode): Boolean;
var
  FoundNodesL1: TObjectCountedDynArray;
  FoundNodesL2: TObjectCountedDynArray;
  i,j:          Integer;
begin
Element := nil;
CDA_Init(FoundNodesL1);
CDA_Init(FoundNodesL2);
CDA_Add(FoundNodesL1,Document);
// traverse stages
For i := Low(fStages) to High(fStages) do
  begin
    CDA_Clear(FoundNodesL2);
    For j := CDA_Low(FoundNodesL1) to CDA_High(FoundNodesL1) do
      TILHTMLElementNode(CDA_GetItem(FoundNodesL1,j)).
        Find(fStages[i],(i = Low(fStages)),FoundNodesL2);
    CDA_Clear(FoundNodesL1);
    FoundNodesL1 := CDA_Copy(FoundNodesL2);
  end;
If CDA_Count(FoundNodesL1) = 1 then
  Element := TILHTMLElementNode(CDA_GetItem(FoundNodesL1,0));
Result := Assigned(Element);
end;

//------------------------------------------------------------------------------

procedure TILElementFinder.SaveToStream(Stream: TStream);
var
  i:  Integer;
begin
Stream_WriteUInt32(Stream,Length(fStages));
For i := Low(fStages) to High(fStages) do
  fStages[i].SaveToStream(Stream);
end;

//------------------------------------------------------------------------------

procedure TILElementFinder.LoadFromStream(Stream: TStream);
var
  i:  Integer;
begin
StageClear;
SetLength(fStages,Stream_ReadUInt32(Stream));
For i := Low(fStages) to High(fStages) do
  begin
    fStages[i] := TILElementComparatorGroup.Create;
    fStages[i].LoadFromStream(Stream);
  end;
end;

end.
