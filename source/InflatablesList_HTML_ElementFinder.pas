unit InflatablesList_HTML_ElementFinder;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  Classes,
  AuxTypes,
  InflatablesList_Types,
  InflatablesList_HTML_TagAttributeArray,
  InflatablesList_HTML_Document;

type
  TILSearchOperator = (ilsoAND,ilsoOR,ilsoXOR);

  TILFinderBaseClass = class(TObject)
  protected
    fVariables:     TILItemShopParsingVariables;
    fStringPrefix:  String;   // all returned strings are prepended with, not saved
    fStringSuffix:  String;   // appended to all returned strings, not saved
    fIndex:         Integer;  // index in comparator croup
    fEmptyStrAllow: Boolean;  // marks whether AsString can return an empty string or must return at least a placeholder
    fIsLeading:     Boolean;  // transient (not copied in copy constructor)
    procedure SetStringPrefix(const Value: String);
    procedure SetStringSuffix(const Value: String);
    Function GetTotalItemCount: Integer; virtual;
    Function GetIsSimple: Boolean; virtual;
  public
    constructor Create;
    constructor CreateAsCopy(Source: TILFinderBaseClass; UniqueCopy: Boolean);
    procedure Prepare(Variables: TILItemShopParsingVariables); virtual;
    Function AsString(Decorate: Boolean = True): String; virtual; // returns string describing the comparator
    Function Search(const SearchSettings: TILAdvSearchSettings): Boolean; virtual;
    property Variables: TILItemShopParsingVariables read fVariables;
    property StringPrefix: String read fStringPrefix write SetStringPrefix;
    property StringSuffix: String read fStringSuffix write SetStringSuffix;
    property Index: Integer read fIndex write fIndex;
    property EmptyStringAllowed: Boolean read fEmptyStrAllow write fEmptyStrAllow;
    property TotalItemCount: Integer read GetTotalItemCount;
    {
      IsSimple is true for comparators and groups with only simple comparator,
      false for other groups (more than one subitem, or no subitem)
    }
    property IsSimple: Boolean read GetIsSimple;
    {
      IsLeading is true when object is first in a group or is standalone,
      false otherwise.
      It is initialized to true and must be managed externally.
    }
    property IsLeading: Boolean read fIsLeading write fIsLeading;
  end;

//------------------------------------------------------------------------------

  TILComparatorBase = class(TILFinderBaseClass)
  protected
    fVariableIdx: Integer;
    fNegate:      Boolean;
    fOperator:    TILSearchOperator;
    fResult:      Boolean;  // result of the comparison operation, not saved
  public
    constructor Create;
    constructor CreateAsCopy(Source: TILComparatorBase; UniqueCopy: Boolean);
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
  public
    // following methods must be implemented in all text comparators
    procedure Compare(const Text: String); overload; virtual; abstract;
    procedure Compare(const Text: TILReconvString); overload; virtual; abstract;
  end;

//------------------------------------------------------------------------------

  TILTextComparator = class(TILTextComparatorBase)
  protected
    fStr:           String;   // string that will be compared with text passed to Compare methods
    fCaseSensitive: Boolean;
    fAllowPartial:  Boolean;
    procedure SetStr(const Value: String);
  public
    constructor Create;
    constructor CreateAsCopy(Source: TILTextComparator; UniqueCopy: Boolean);
    Function AsString(Decorate: Boolean = True): String; override;
    Function Search(const SearchSettings: TILAdvSearchSettings): Boolean; override;
    procedure Compare(const Text: String); override;
    procedure Compare(const Text: TILReconvString); override;
    procedure SaveToStream(Stream: TStream); override;
    procedure LoadFromStream(Stream: TStream); override;
    property Str: String read fStr write SetStr;
    property CaseSensitive: Boolean read fCaseSensitive write fCaseSensitive;
    property AllowPartial: Boolean read fAllowPartial write fAllowPartial;
  end;

//------------------------------------------------------------------------------

  TILTextComparatorGroup = class(TILTextComparatorBase)
  protected
    fItems: array of TILTextComparatorBase;
    Function GetItemCount: Integer;
    Function GetItem(Index: Integer): TILTextComparatorBase;
    Function GetTotalItemCount: Integer; override;
    Function GetIsSimple: Boolean; override;
    procedure ReIndex; virtual;
    procedure MarkLeading; virtual;
  public
    constructor Create;
    constructor CreateAsCopy(Source: TILTextComparatorGroup; UniqueCopy: Boolean);
    destructor Destroy; override;
    Function AsString(Decorate: Boolean = True): String; override;
    Function Search(const SearchSettings: TILAdvSearchSettings): Boolean; override;
    procedure Prepare(Variables: TILItemShopParsingVariables); override;
    procedure ReInit; override;
    Function IndexOf(Item: TObject): Integer; virtual;
    Function AddComparator(Negate: Boolean = False; Operator: TILSearchOperator = ilsoAND): TILTextComparator; virtual;
    Function AddGroup(Negate: Boolean = False; Operator: TILSearchOperator = ilsoAND): TILTextComparatorGroup; virtual;
    Function Remove(Item: TObject): Integer; virtual;
    procedure Delete(Index: Integer); virtual;                       
    procedure Clear; virtual;
    procedure Compare(const Text: String); override;
    procedure Compare(const Text: TILReconvString); override;
    procedure SaveToStream(Stream: TStream); override;
    procedure LoadFromStream(Stream: TStream); override;
    property Count: Integer read GetItemCount;
    property Items[Index: Integer]: TILTextComparatorBase read GetItem; default;
  end;

//==============================================================================

  TILAttributeComparatorBase = class(TILComparatorBase)
  public
    procedure Compare(TagAttribute: TILHTMLTagAttribute); virtual; abstract;
  end;

//------------------------------------------------------------------------------

  TILAttributeComparator = class(TILAttributeComparatorBase)
  protected
    fName:  TILTextComparatorGroup;
    fValue: TILTextComparatorGroup;
    Function GetTotalItemCount: Integer; override;
    Function GetIsSimple: Boolean; override;
  public
    constructor Create;
    constructor CreateAsCopy(Source: TILAttributeComparator; UniqueCopy: Boolean);
    destructor Destroy; override;
    Function AsString(Decorate: Boolean = True): String; override;
    Function Search(const SearchSettings: TILAdvSearchSettings): Boolean; override;
    procedure Prepare(Variables: TILItemShopParsingVariables); override;
    procedure ReInit; override;
    procedure Compare(TagAttribute: TILHTMLTagAttribute); override;
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
    Function GetTotalItemCount: Integer; override;
    Function GetIsSimple: Boolean; override;
    procedure ReIndex; virtual;
    procedure MarkLeading; virtual;
  public
    constructor Create;
    constructor CreateAsCopy(Source: TILAttributeComparatorGroup; UniqueCopy: Boolean);
    destructor Destroy; override;
    Function AsString(Decorate: Boolean = True): String; override;
    Function Search(const SearchSettings: TILAdvSearchSettings): Boolean; override;
    procedure Prepare(Variables: TILItemShopParsingVariables); override;
    procedure ReInit; override;
    Function IndexOf(Item: TObject): Integer; virtual;
    Function AddComparator(Negate: Boolean = False; Operator: TILSearchOperator = ilsoAND): TILAttributeComparator; virtual;
    Function AddGroup(Negate: Boolean = False; Operator: TILSearchOperator = ilsoAND): TILAttributeComparatorGroup; virtual;
    Function Remove(Item: TObject): Integer; virtual;
    procedure Delete(Index: Integer); virtual;
    procedure Clear; virtual;
    procedure Compare(TagAttribute: TILHTMLTagAttribute); override;
    procedure SaveToStream(Stream: TStream); override;
    procedure LoadFromStream(Stream: TStream); override;
    property Count: Integer read GetItemCount;
    property Items[Index: Integer]: TILAttributeComparatorBase read GetItem; default;
  end;

//==============================================================================

  TILElementComparator = class(TILFinderBaseClass)
  protected
    fTagName:     TILTextComparatorGroup;
    fAttributes:  TILAttributeComparatorGroup;
    fText:        TILTextComparatorGroup;
    fNestedText:  Boolean;
    fResult:      Boolean;
    Function GetTotalItemCount: Integer; override;
    Function GetIsSimple: Boolean; override;
  public
    constructor Create;
    constructor CreateAsCopy(Source: TILElementComparator; UniqueCopy: Boolean);
    destructor Destroy; override;
    Function AsString(Decorate: Boolean = True): String; override;
    Function Search(const SearchSettings: TILAdvSearchSettings): Boolean; override;
    procedure Prepare(Variables: TILItemShopParsingVariables); override;
    procedure ReInit; virtual;
    procedure Compare(Element: TILHTMLElementNode); virtual;
    procedure SaveToStream(Stream: TStream); virtual;
    procedure LoadFromStream(Stream: TStream); virtual;    
    property TagName: TILTextComparatorGroup read fTagName;
    property Attributes: TILAttributeComparatorGroup read fAttributes;
    property Text: TILTextComparatorGroup read fText;
    property NestedText: Boolean read fNestedText write fNestedText;
    property Result: Boolean read fResult;
  end;

//==============================================================================  

  TILElementFinderStage = class(TILFinderBaseClass)
  protected
    fItems: array of TILElementComparator;
    Function GetItemCount: Integer;
    Function GetItem(Index: Integer): TILElementComparator;
    Function GetTotalItemCount: Integer; override;
    procedure ReIndex; virtual;
  public
    constructor Create;
    constructor CreateAsCopy(Source: TILElementFinderStage; UniqueCopy: Boolean);
    destructor Destroy; override;
    Function AsString(Decorate: Boolean = True): String; override;
    Function Search(const SearchSettings: TILAdvSearchSettings): Boolean; override;
    procedure Prepare(Variables: TILItemShopParsingVariables); override;
    procedure ReInit; virtual;
    Function IndexOf(Item: TObject): Integer; virtual;
    Function AddComparator: TILElementComparator; virtual;
    Function Remove(Item: TObject): Integer; virtual;
    procedure Delete(Index: Integer); virtual;
    procedure Clear; virtual;
    Function Compare(Element: TILHTMLElementNode): Boolean; virtual;
    procedure SaveToStream(Stream: TStream); virtual;
    procedure LoadFromStream(Stream: TStream); virtual;
    property Count: Integer read GetItemCount;
    property Items[Index: Integer]: TILElementComparator read GetItem; default;
  end;

//------------------------------------------------------------------------------

  TILElementFinder = class(TILFinderBaseClass)
  private
    fStages: array of TILElementFinderStage;
    Function GetStageCount: Integer;
    Function GetStage(Index: Integer): TILElementFinderStage;
  protected
    Function GetTotalItemCount: Integer; override;
    procedure ReIndex; virtual;
  public
    constructor Create;
    constructor CreateAsCopy(Source: TILElementFinder; UniqueCopy: Boolean);
    destructor Destroy; override;
    Function Search(const SearchSettings: TILAdvSearchSettings): Boolean; override;
    procedure Prepare(Variables: TILItemShopParsingVariables); override;
    procedure ReInit; virtual;
    Function StageIndexOf(Stage: TObject): Integer; virtual;
    Function StageAdd: TILElementFinderStage; virtual;
    Function StageRemove(Stage: TObject): Integer; virtual;
    procedure StageDelete(Index: Integer); virtual;
    procedure StageClear; virtual;
    Function FindElements(Document: TILHTMLDocument; out Elements: TILHTMLElements): Boolean; virtual;
    procedure SaveToStream(Stream: TStream); virtual;
    procedure LoadFromStream(Stream: TStream); virtual;
    property StageCount: Integer read GetStageCount;
    property Stages[Index: Integer]: TILElementFinderStage read GetStage; default;
  end;

//******************************************************************************

Function IL_SearchOperatorToNum(SearchOperator: TILSearchOperator): Int32;
Function IL_NumToSearchOperator(Num: Int32): TILSearchOperator;

Function IL_SearchOperatorAsStr(SearchOperator: TILSearchOperator): String;
Function IL_NegateValue(Value,Negate: Boolean): Boolean; overload;

Function IL_CombineUsingOperator(A,B: Boolean; Operator: TILSearchOperator): Boolean;

implementation

uses
  SysUtils,
  BinaryStreaming, CountedDynArrayObject,
  InflatablesList_Utils;

const
  IL_SEARCH_TEXTCOMPARATOR         = UInt32($FFAA3400);
  IL_SEARCH_TEXTCOMPARATORGROUP    = UInt32($FFAA3401);
  IL_SEARCH_ATTRCOMPARATOR         = UInt32($FFAA3402);
  IL_SEARCH_ATTRCOMPARATORGROUP    = UInt32($FFAA3403);
  IL_SEARCH_ELEMENTCOMPARATOR      = UInt32($FFAA3404);
  IL_SEARCH_ELEMENTCOMPARATORGROUP = UInt32($FFAA3405);

//==============================================================================  

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

Function IL_SearchOperatorAsStr(SearchOperator: TILSearchOperator): String;
begin
case SearchOperator of
  ilsoOR:   Result := 'or';
  ilsoXOR:  Result := 'xor';
else
  {ilsoAND}
  Result := 'and';
end;
end;

//------------------------------------------------------------------------------

Function IL_NegateValue(Value,Negate: Boolean): Boolean;
begin
If Negate then
  Result := not Value
else
  Result := Value;
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

procedure TILFinderBaseClass.SetStringPrefix(const Value: String);
begin
fStringPrefix := Value;
UniqueString(fStringPrefix);
end;

//------------------------------------------------------------------------------

procedure TILFinderBaseClass.SetStringSuffix(const Value: String);
begin
fStringSuffix := Value;
UniqueString(fStringSuffix);
end;

//------------------------------------------------------------------------------

Function TILFinderBaseClass.GetTotalItemCount: Integer;
begin
Result := 1;
end;

//------------------------------------------------------------------------------

Function TILFinderBaseClass.GetIsSimple: Boolean;
begin
Result := True;
end;

//==============================================================================

constructor TILFinderBaseClass.Create;
var
  i:  Integer;
begin
inherited Create;
For i := Low(fVariables.Vars) to High(fVariables.Vars) do
  fVariables.Vars[i] := '';
fStringPrefix := '';
fStringSuffix := '';
fIndex := -1;
fEmptyStrAllow := True;
fIsLeading := True;
end;

//------------------------------------------------------------------------------

constructor TILFinderBaseClass.CreateAsCopy(Source: TILFinderBaseClass; UniqueCopy: Boolean);
begin
Create;
fVariables := IL_ThreadSafeCopy(Source.Variables);
fStringPrefix := Source.StringPrefix;
UniqueString(fStringPrefix);
fStringSuffix := Source.StringSuffix;
UniqueString(fStringSuffix);
fIndex := Source.Index;
fEmptyStrAllow := Source.EmptyStringAllowed;
end;

//------------------------------------------------------------------------------

procedure TILFinderBaseClass.Prepare(Variables: TILItemShopParsingVariables);
begin
fVariables := IL_ThreadSafeCopy(Variables);
end;

//------------------------------------------------------------------------------

Function TILFinderBaseClass.AsString(Decorate: Boolean = True): String;
begin
If Decorate then
  Result := IL_Format('%s%s(%p)%s',[fStringPrefix,Self.ClassName,Pointer(Self),fStringSuffix])
else
  Result := IL_Format('%s(%p)',[Self.ClassName,Pointer(Self)])
end;

//------------------------------------------------------------------------------

Function TILFinderBaseClass.Search(const SearchSettings: TILAdvSearchSettings): Boolean;
begin
Result := False;
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

constructor TILComparatorBase.CreateAsCopy(Source: TILComparatorBase; UniqueCopy: Boolean);
begin
inherited CreateAsCopy(Source,UniqueCopy);
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
Stream_WriteInt32(Stream,fVariableIdx);
Stream_WriteBool(Stream,fNegate);
Stream_WriteInt32(Stream,IL_SearchOperatorToNum(fOperator));
end;

//------------------------------------------------------------------------------

procedure TILComparatorBase.LoadFromStream(Stream: TStream);
begin
fVariableIdx := Stream_ReadInt32(Stream);
fNegate := Stream_ReadBool(Stream);
fOperator := IL_NumToSearchOperator(Stream_ReadInt32(Stream));
end;

//******************************************************************************
//******************************************************************************

procedure TILTextComparator.SetStr(const Value: String);
begin
fStr := Value;
UniqueString(fStr);
end;

//==============================================================================

constructor TILTextComparator.Create;
begin
inherited Create;
fStr := '';
fCaseSensitive := False;
fAllowPartial := False;
end;

//------------------------------------------------------------------------------

constructor TILTextComparator.CreateAsCopy(Source: TILTextComparator; UniqueCopy: Boolean);
begin
inherited CreateAsCopy(Source,UniqueCopy);
fStr := Source.Str;
UniqueString(fStr);
fCaseSensitive := Source.CaseSensitive;
fAllowPartial := Source.AllowPartial;
end;

//------------------------------------------------------------------------------

Function TILTextComparator.AsString(Decorate: Boolean = True): String;
begin
If fCaseSensitive or fAllowPartial or fNegate or (fIndex > 0) then
  Result := '"%s"'
else
  Result := '%s';
If fCaseSensitive then
  Result := IL_Format('?^%s',[Result]);
If fAllowPartial then
  Result := IL_Format('*.%s.*',[Result]);
If fNegate then
  Result := IL_Format('not(%s)',[Result]);
If Decorate then
  begin
    If fIndex > 0 then
      Result := IL_Format('%s%s %s%s',[fStringPrefix,IL_SearchOperatorAsStr(fOperator),Result,fStringSuffix])
    else
      Result := IL_Format('%s%s%s',[fStringPrefix,Result,fStringSuffix]);
  end
else
  begin
    If fIndex > 0 then
      Result := IL_Format('%s %s',[IL_SearchOperatorAsStr(fOperator),Result]);
    // current result does not change for fIndex <= 0
  end;
If fVariableIdx < 0 then
  begin
    If Length(Result) + Length(fStr) > 25 then
      Result := IL_Format(Result,['...'])
    else
      Result := IL_Format(Result,[fStr]);
  end
else Result := IL_Format(Result,[IL_Format('#VAR%d#',[fVariableIdx + 1])]);
end;

//------------------------------------------------------------------------------

Function TILTextComparator.Search(const SearchSettings: TILAdvSearchSettings): Boolean;
begin
Result := SearchSettings.CompareFunc(fStr,True,True,False);
end;

//------------------------------------------------------------------------------

procedure TILTextComparator.Compare(const Text: String);
var
  Temp: String;
begin
If (fVariableIdx >= Low(fVariables.Vars)) and (fVariableIdx <= High(fVariables.Vars)) then
  Temp := fVariables.Vars[fVariableIdx]
else
  Temp := fStr;
If fCaseSensitive then
  begin
    If fAllowPartial then
      fResult := IL_ContainsStr(Text,Temp)
    else
      fResult := IL_SameStr(Text,Temp);
  end
else
  begin
    If fAllowPartial then
      fResult := IL_ContainsText(Text,Temp)
    else
      fResult := IL_SameText(Text,Temp);
  end;
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

procedure TILTextComparator.Compare(const Text: TILReconvString);
begin
fResult := False;
Compare(Text.Str);
If not Result then
  begin
    Compare(Text.UTF8Reconv);
    If not Result then
      Compare(Text.AnsiReconv);
  end;
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
If (Index >= Low(fItems)) and (Index <= High(fItems)) then
  Result := fItems[Index]
else
  raise Exception.CreateFmt('TILTextComparatorGroup.GetItem: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

Function TILTextComparatorGroup.GetTotalItemCount: Integer;
var
  i:  Integer;
begin
Result := inherited GetTotalItemCount;
For i := Low(fItems) to High(fItems) do
  Inc(Result,fItems[i].TotalItemCount);
end;

//------------------------------------------------------------------------------

Function TILTextComparatorGroup.GetIsSimple: Boolean;
begin
If Length(fItems) = 1 then
  Result := fItems[Low(fItems)] is TILTextComparator
else
  Result := False;
end;

//------------------------------------------------------------------------------

procedure TILTextComparatorGroup.ReIndex;
var
  i:  Integer;
begin
For i := Low(fItems) to High(fItems) do
  fItems[i].Index := i;
end;

//------------------------------------------------------------------------------

procedure TILTextComparatorGroup.MarkLeading;
var
  i:  Integer;
begin
For i := Low(fItems) to High(fItems) do
  fItems[i].IsLeading := i <= Low(fItems);
end;

//==============================================================================

constructor TILTextComparatorGroup.Create;
begin
inherited Create;
SetLength(fItems,0);
end;

//------------------------------------------------------------------------------

constructor TILTextComparatorGroup.CreateAsCopy(Source: TILTextComparatorGroup; UniqueCopy: Boolean);
var
  i:  Integer;
begin
inherited CreateAsCopy(Source,UniqueCopy);
SetLength(fItems,Source.Count);
For i := Low(fItems) to High(fItems) do
  If Source.Items[i] is TILTextComparatorGroup then
    fItems[i] := TILTextComparatorGroup.CreateAsCopy(TILTextComparatorGroup(Source.Items[i]),UniqueCopy)
  else
    fItems[i] := TILTextComparator.CreateAsCopy(TILTextComparator(Source.Items[i]),UniqueCopy);
MarkLeading;
end;

//------------------------------------------------------------------------------

destructor TILTextComparatorGroup.Destroy;
begin
Clear;
inherited;
end;

//------------------------------------------------------------------------------

Function TILTextComparatorGroup.AsString(Decorate: Boolean = True): String;
begin
If GetIsSimple then
  begin
    // there is exactly one subnode and that is a plain text comparator
    // do not decorate it, it will be done further here
    Result := fItems[Low(fItems)].AsString(False);
    If (Length(Result) <= 0) and not fEmptyStrAllow then
      Result := '(...)';
  end
else
  begin
    If Length(fItems) > 1 then
      Result := IL_Format('(...x%d)',[Length(fItems)])
    else If Length(fItems) = 1 then
      Result := '(...)'
    else If not fEmptyStrAllow then
      Result := '()'
    else
      Result := '';
  end;
If fNegate then
  Result := IL_Format('not(%s)',[Result]);
If Decorate then
  begin
    If fIndex > 0 then
      Result := IL_Format('%s%s %s%s',[fStringPrefix,IL_SearchOperatorAsStr(fOperator),Result,fStringSuffix])
    else
      Result := IL_Format('%s%s%s',[fStringPrefix,Result,fStringSuffix]);
  end
else
  begin
    If fIndex > 0 then
      Result := IL_Format('%s %s',[IL_SearchOperatorAsStr(fOperator),Result]);
  end;
end;

//------------------------------------------------------------------------------

Function TILTextComparatorGroup.Search(const SearchSettings: TILAdvSearchSettings): Boolean;
var
  i:  Integer;
begin
Result := False;
For i := Low(fItems) to High(fItems) do
  If fItems[i].Search(SearchSettings) then
    begin
      Result := True;
      Break{For i};
    end;
end;

//------------------------------------------------------------------------------

procedure TILTextComparatorGroup.Prepare(Variables: TILItemShopParsingVariables);
var
  i:  Integer;
begin
inherited Prepare(Variables);
For i := Low(fItems) to High(fItems) do
  fItems[i].Prepare(Variables);
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

Function TILTextComparatorGroup.IndexOf(Item: TObject): Integer;
var
  i:  Integer;
begin
Result := -1;
For i := Low(fItems) to High(fItems) do
  If fItems[i] = Item then
    begin
      Result := i;
      Break{For i};
    end;
end;

//------------------------------------------------------------------------------

Function TILTextComparatorGroup.AddComparator(Negate: Boolean = False; Operator: TILSearchOperator = ilsoAND): TILTextComparator;
begin
SetLength(fItems,Length(fItems) + 1);
Result := TILTextComparator.Create;
fItems[High(fItems)] := Result;
Result.Index := High(fItems);
Result.Negate := Negate;
Result.Operator := Operator;
MarkLeading;
end;

//------------------------------------------------------------------------------

Function TILTextComparatorGroup.AddGroup(Negate: Boolean = False; Operator: TILSearchOperator = ilsoAND): TILTextComparatorGroup;
begin
SetLength(fItems,Length(fItems) + 1);
Result := TILTextComparatorGroup.Create;
fItems[High(fItems)] := Result;
Result.Index := High(fItems);
Result.EmptyStringAllowed := False;
Result.Negate := Negate;
Result.Operator := Operator;
MarkLeading;
end;

//------------------------------------------------------------------------------

Function TILTextComparatorGroup.Remove(Item: TObject): Integer;
begin
Result := IndexOf(Item);
If Result >= 0 then
  Delete(Result);
end;

//------------------------------------------------------------------------------

procedure TILTextComparatorGroup.Delete(Index: Integer);
var
  i:  Integer;
begin
If (Index >= Low(fItems)) and (Index <= High(fItems)) then
  begin
    fItems[Index].Free;
    For i := Index to Pred(High(fItems)) do
      fItems[i] := fItems[i + 1];
    SetLength(fItems,Length(fItems) - 1);
    ReIndex;
    MarkLeading;
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
    // get result from first item and then combine it with other results
    fResult := IL_NegateValue(fItems[Low(fItems)].Result,fItems[Low(fItems)].Negate);
    For i := Succ(Low(fItems)) to High(fItems) do
      fResult := IL_CombineUsingOperator(
        fResult,IL_NegateValue(fItems[i].Result,fItems[i].Negate),fItems[i].Operator)
  end
else fResult := False;
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

procedure TILTextComparatorGroup.Compare(const Text: TILReconvString); 
begin
fResult := False;
Compare(Text.Str);
If not Result then
  begin
    Compare(Text.UTF8Reconv);
    If not Result then
      Compare(Text.AnsiReconv);
  end;
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
If Stream_ReadUInt32(Stream) <> IL_SEARCH_TEXTCOMPARATORGROUP then
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
    fItems[i].Index := i;
    If fItems[i] is TILTextComparatorGroup then
      fItems[i].EmptyStringAllowed := False;
    fItems[i].IsLeading := i <= Low(fItems);
  end;
end;

//******************************************************************************
//******************************************************************************

Function TILAttributeComparator.GetTotalItemCount: Integer;
begin
Result := inherited GetTotalItemCount;
Inc(Result,fName.TotalItemCount);
Inc(Result,fValue.TotalItemCount);
end;

//------------------------------------------------------------------------------

Function TILAttributeComparator.GetIsSimple: Boolean;
begin
Result := fName.IsSimple and fValue.IsSimple;
end;

//==============================================================================

constructor TILAttributeComparator.Create;
begin
inherited Create;
fName := TILTextComparatorGroup.Create;
fName.StringPrefix := 'Name: ';
fValue := TILTextComparatorGroup.Create;
fValue.StringPrefix := 'Value: ';
end;

//------------------------------------------------------------------------------

constructor TILAttributeComparator.CreateAsCopy(Source: TILAttributeComparator; UniqueCopy: Boolean);
begin
inherited CreateAsCopy(Source,UniqueCopy);
fName := TILTextComparatorGroup.CreateAsCopy(Source.Name,UniqueCopy);
fName.StringPrefix := 'Name: ';
fValue := TILTextComparatorGroup.CreateAsCopy(Source.Value,UniqueCopy);
fValue.StringPrefix := 'Value: ';
end;

//------------------------------------------------------------------------------

destructor TILAttributeComparator.Destroy;
begin
fValue.Free;
fName.Free;
inherited;
end;

//------------------------------------------------------------------------------

Function TILAttributeComparator.AsString(Decorate: Boolean = True): String;
begin
If GetIsSimple then
  begin
    // exactly one string comparator in both name and value
    Result := IL_Format('%s="%s"',[fName.AsString(False),fValue.AsString(False)]);
  end
else
  begin
    If (fName.Count > 0) and (fValue.Count > 0) then
      Result := 'attribute name="value"'
    else If fName.Count > 0 then
      Result := 'attribute name'
    else If fValue.Count > 0 then
      Result := 'attribute *="value"'
    else
      Result := 'attribute';
  end;
If fNegate then
  Result := IL_Format('not(%s)',[Result]);
If Decorate then
  begin
    If fIndex > 0 then
      Result := IL_Format('%s%s %s%s',[fStringPrefix,IL_SearchOperatorAsStr(fOperator),Result,fStringSuffix])
    else
      Result := IL_Format('%s%s%s',[fStringPrefix,Result,fStringSuffix]);
  end
else
  begin
    If fIndex > 0 then
      Result := IL_Format('%s %s',[IL_SearchOperatorAsStr(fOperator),Result])
  end;
end;

//------------------------------------------------------------------------------

Function TILAttributeComparator.Search(const SearchSettings: TILAdvSearchSettings): Boolean;
begin
Result := fName.Search(SearchSettings) or fValue.Search(SearchSettings);
end;

//------------------------------------------------------------------------------

procedure TILAttributeComparator.Prepare(Variables: TILItemShopParsingVariables);
begin
inherited Prepare(Variables);
fName.Prepare(Variables);
fValue.Prepare(Variables);
end;

//------------------------------------------------------------------------------

procedure TILAttributeComparator.ReInit;
begin
inherited;
fName.ReInit;
fValue.ReInit;
end;

//------------------------------------------------------------------------------

procedure TILAttributeComparator.Compare(TagAttribute: TILHTMLTagAttribute);
begin
// compare
fName.Compare(TagAttribute.Name);
fValue.Compare(TagAttribute.Value);
// combine results
If (fName.Count > 0) and (fValue.Count > 0) then
  fResult := IL_NegateValue(fName.Result,fName.Negate) and
             IL_NegateValue(fValue.Result,fValue.Negate)
else If fName.Count > 0 then
  fResult := IL_NegateValue(fName.Result,fName.Negate)
else If fValue.Count > 0  then
  fResult := IL_NegateValue(fValue.Result,fValue.Negate)
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
If Stream_ReadUInt32(Stream) <> IL_SEARCH_ATTRCOMPARATOR then
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
If (Index >= Low(fItems)) and (Index <= High(fItems)) then
  Result := fItems[Index]
else
  raise Exception.CreateFmt('TILAttributeComparator.GetItem: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

Function TILAttributeComparatorGroup.GetTotalItemCount: Integer;
var
  i:  Integer;
begin
Result := inherited GetTotalItemCount;
For i := Low(fItems) to High(fItems) do
  Inc(Result,fItems[i].TotalItemCount);
end;

//------------------------------------------------------------------------------

Function TILAttributeComparatorGroup.GetIsSimple: Boolean;
begin
If Length(fItems) = 1 then
  begin
    {
      there is one subnode, which is of type TILAttributeComparator
      this subnode has exactly one name and one value subnode, both of type
      TILTextComparator
    }
    If fItems[Low(fItems)] is TILAttributeComparator then
      Result := fItems[Low(fItems)].IsSimple
    else
      Result := False;
  end
else Result := False;
end;

//------------------------------------------------------------------------------

procedure TILAttributeComparatorGroup.ReIndex;
var
  i:  Integer;
begin
For i := Low(fItems) to High(fItems) do
  fItems[i].Index := i;
end;

//------------------------------------------------------------------------------

procedure TILAttributeComparatorGroup.MarkLeading;
var
  i:  Integer;
begin
For i := Low(fItems) to High(fItems) do
  fItems[i].IsLeading := i <= Low(fItems);
end;

//==============================================================================

constructor TILAttributeComparatorGroup.Create;
begin
inherited Create;
SetLength(fItems,0);
end;

//------------------------------------------------------------------------------

constructor TILAttributeComparatorGroup.CreateAsCopy(Source: TILAttributeComparatorGroup; UniqueCopy: Boolean);
var
  i:  Integer;
begin
inherited CreateAsCopy(Source,UniqueCopy);
SetLength(fItems,Source.Count);
For i := Low(fItems) to High(fItems) do
  If Source.Items[i] is TILAttributeComparatorGroup then
    fItems[i] := TILAttributeComparatorGroup.CreateAsCopy(TILAttributeComparatorGroup(Source.Items[i]),UniqueCopy)
  else
    fItems[i] := TILAttributeComparator.CreateAsCopy(TILAttributeComparator(Source.Items[i]),UniqueCopy);
MarkLeading;
end;

//------------------------------------------------------------------------------

destructor TILAttributeComparatorGroup.Destroy;
begin
Clear;
inherited;
end;

//------------------------------------------------------------------------------

Function TILAttributeComparatorGroup.AsString(Decorate: Boolean = True): String;
begin
If GetIsSimple then
  begin
    Result := fItems[Low(fItems)].AsString(False);
    If (Length(Result) <= 0) and not fEmptyStrAllow then
      Result := '(...)';
  end
else
  begin
    If Length(fItems) > 1 then
      Result := IL_Format('(...x%d)',[Length(fItems)])
    else If Length(fItems) = 1 then
      Result := '(...)'
    else If not fEmptyStrAllow then
      Result := '()'
    else
      Result := '';
  end;
If fNegate then
  Result := IL_Format('not%s',[Result]);
If Decorate then
  begin
    If fIndex > 0 then
      Result := IL_Format('%s%s %s%s',[fStringPrefix,IL_SearchOperatorAsStr(fOperator),Result,fStringSuffix])
    else
      Result := IL_Format('%s%s%s',[fStringPrefix,Result,fStringSuffix]);
  end
else
  begin
    If fIndex > 0 then
      Result := IL_Format('%s %s',[IL_SearchOperatorAsStr(fOperator),Result])
  end;
end;

//------------------------------------------------------------------------------

Function TILAttributeComparatorGroup.Search(const SearchSettings: TILAdvSearchSettings): Boolean;
var
  i:  Integer;
begin
Result := False;
For i := Low(fItems) to High(fItems) do
  If fItems[i].Search(SearchSettings) then
    begin
      Result := True;
      Break{For i};
    end;
end;

//------------------------------------------------------------------------------

procedure TILAttributeComparatorGroup.Prepare(Variables: TILItemShopParsingVariables);
var
  i:  Integer;
begin
inherited Prepare(Variables);
For i := Low(fItems) to High(fItems) do
  fItems[i].Prepare(Variables);
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

Function TILAttributeComparatorGroup.IndexOf(Item: TObject): Integer;
var
  i:  Integer;
begin
Result := -1;
For i := Low(fItems) to High(fItems) do
  If fItems[i] = Item then
    begin
      Result := i;
      Break{For i};
    end;
end;

//------------------------------------------------------------------------------

Function TILAttributeComparatorGroup.AddComparator(Negate: Boolean = False; Operator: TILSearchOperator = ilsoAND): TILAttributeComparator;
begin
SetLength(fItems,Length(fItems) + 1);
Result := TILAttributeComparator.Create;
fItems[High(fItems)] := Result;
Result.Index := High(fItems);
Result.EmptyStringAllowed := False;
Result.Negate := Negate;
Result.Operator := Operator;
MarkLeading;
end;

//------------------------------------------------------------------------------

Function TILAttributeComparatorGroup.AddGroup(Negate: Boolean = False; Operator: TILSearchOperator = ilsoAND): TILAttributeComparatorGroup;
begin
SetLength(fItems,Length(fItems) + 1);
Result := TILAttributeComparatorGroup.Create;
fItems[High(fItems)] := Result;
Result.Index := High(fItems);
Result.Negate := Negate;
Result.Operator := Operator;
MarkLeading;
end;

//------------------------------------------------------------------------------

Function TILAttributeComparatorGroup.Remove(Item: TObject): Integer;
begin
Result := IndexOf(Item);
If Result >= 0 then
  Delete(Result);
end;

//------------------------------------------------------------------------------

procedure TILAttributeComparatorGroup.Delete(Index: Integer);
var
  i:  Integer;
begin
If (Index >= Low(fItems)) and (Index <= High(fItems)) then
  begin
    fItems[Index].Free;
    For i := Index to Pred(High(fItems)) do
      fItems[i] := fItems[i + 1];
    SetLength(fItems,Length(fItems) - 1);
    ReIndex;
    MarkLeading;
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

procedure TILAttributeComparatorGroup.Compare(TagAttribute: TILHTMLTagAttribute);
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
    fResult := IL_NegateValue(fItems[Low(fItems)].Result,fItems[Low(fItems)].Negate);
    For i := Succ(Low(fItems)) to High(fItems) do
      fResult := IL_CombineUsingOperator(
        fResult,IL_NegateValue(fItems[i].Result,fItems[i].Negate),fItems[i].Operator);
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
If Stream_ReadUInt32(Stream) <> IL_SEARCH_ATTRCOMPARATORGROUP then
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
    fItems[i].Index := i;
    If fItems[i] is TILAttributeComparatorGroup then
      fItems[i].EmptyStringAllowed := False;
    fItems[i].IsLeading := i <= Low(fItems);
  end;
end;

//******************************************************************************
//******************************************************************************

Function TILElementComparator.GetTotalItemCount: Integer;
begin
Result := inherited GetTotalItemCount;
Inc(Result,fTagName.TotalItemCount);
Inc(Result,fAttributes.TotalItemCount);
Inc(Result,fText.TotalItemCount);
end;

//------------------------------------------------------------------------------

Function TILElementComparator.GetIsSimple: Boolean;
begin
Result := fTagName.IsSimple and (fAttributes.IsSimple or (fAttributes.Count <= 0)) and
          (fText.IsSimple or (fText.Count <= 0));
end;

//==============================================================================

constructor TILElementComparator.Create;
begin
inherited Create;
fTagName := TILTextComparatorGroup.Create;
fTagName.StringPrefix := 'Tag name: ';
fAttributes := TILAttributeComparatorGroup.Create;
fAttributes.StringPrefix := 'Attributes: ';
fText := TILTextComparatorGroup.Create;
fText.StringPrefix := 'Text: ';
fNestedText := False;
end;

//------------------------------------------------------------------------------

constructor TILElementComparator.CreateAsCopy(Source: TILElementComparator; UniqueCopy: Boolean);
begin
inherited CreateAsCopy(Source,UniqueCopy);
fTagName := TILTextComparatorGroup.CreateAsCopy(Source.TagName,UniqueCopy);
fTagName.StringPrefix := 'Tag name: ';
fAttributes := TILAttributeComparatorGroup.CreateAsCopy(Source.Attributes,UniqueCopy);
fAttributes.StringPrefix := 'Attributes: ';
fText := TILTextComparatorGroup.CreateAsCopy(Source.Text,UniqueCopy);
fText.StringPrefix := 'Text: ';
fNestedText := Source.NestedText;
fResult := Source.Result;
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

Function TILElementComparator.AsString(Decorate: Boolean = True): String;
begin
If GetIsSimple then
  begin
    If fAttributes.Count > 0 then
      Result := IL_Format('<%s %s>%s',[fTagName.AsString(False),
        fAttributes.AsString(False),fText.AsString(False)])
    else
      Result := IL_Format('<%s>%s',[fTagName.AsString(False),
        fText.AsString(False)]);
  end
else
  begin
    If fIndex >= 0 then
      Result := IL_Format('<element #%d>',[fIndex])
    else
      Result := '<element>';
  end;
If fIndex > 0 then
  Result := IL_Format('or %s',[Result]);
If fNestedText then
  Result := IL_Format('%s<<>>',[Result]);
end;

//------------------------------------------------------------------------------

Function TILElementComparator.Search(const SearchSettings: TILAdvSearchSettings): Boolean;
begin
Result := fTagName.Search(SearchSettings) or fAttributes.Search(SearchSettings) or fText.Search(SearchSettings);
end;

//------------------------------------------------------------------------------

procedure TILElementComparator.Prepare(Variables: TILItemShopParsingVariables);
begin
inherited Prepare(Variables);
fTagName.Prepare(Variables);
fAttributes.Prepare(Variables);
fText.Prepare(Variables);
end;

//------------------------------------------------------------------------------

procedure TILElementComparator.ReInit;
begin
inherited;
fTagName.ReInit;
fAttributes.ReInit;
fText.ReInit;
end;

//------------------------------------------------------------------------------

procedure TILElementComparator.Compare(Element: TILHTMLElementNode);
var
  i:  Integer;
begin
fTagName.Compare(Element.Name);
fResult := IL_NegateValue(fTagName.Result,fTagName.Negate);
If fResult then
  begin
    // name match, look for attributes match...
    If fAttributes.Count > 0 then
      begin
        For i := 0 to Pred(Element.AttributeCount) do
          begin
            fAttributes.Compare(Element.Attributes[i]);
            If fAttributes.Result then
              Break{For i}; // no need to continue when match was found
          end;
        // get result and combine it with name
        fResult := fResult and IL_NegateValue(fAttributes.Result,fAttributes.Negate);
      end;
    // and now for the text...
    If (fText.Count > 0) and fResult then
      begin
        If fNestedText then
          fText.Compare(Element.NestedText)
        else
          fText.Compare(Element.Text);
        fResult := fResult and IL_NegateValue(fText.Result,fText.Negate);
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
Stream_WriteBool(Stream,fNestedText);
end;

//------------------------------------------------------------------------------

procedure TILElementComparator.LoadFromStream(Stream: TStream);
begin
If Stream_ReadUInt32(Stream) <> IL_SEARCH_ELEMENTCOMPARATOR then
  raise Exception.Create('TILElementComparator.LoadFromStream: Invalid stream format.');
fTagName.LoadFromStream(Stream);
fAttributes.LoadFromStream(Stream);
fText.LoadFromStream(Stream);
fNestedText := Stream_ReadBool(Stream);
end;

//******************************************************************************
//******************************************************************************

Function TILElementFinderStage.GetItemCount: Integer;
begin
Result := Length(fItems);
end;

//------------------------------------------------------------------------------

Function TILElementFinderStage.GetItem(Index: Integer): TILElementComparator;
begin
If (Index >= Low(fItems)) and (Index <= High(fItems)) then
  Result := fItems[Index]
else
  raise Exception.CreateFmt('TILElementFinderStage.GetItem: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

Function TILElementFinderStage.GetTotalItemCount: Integer;
var
  i:  Integer;
begin
Result := inherited GetTotalItemCount;
For i := Low(fItems) to High(fItems) do
  Inc(Result,fItems[i].TotalItemCount);
end;

//------------------------------------------------------------------------------

procedure TILElementFinderStage.ReIndex;
var
  i:  Integer;
begin
For i := Low(fItems) to High(fItems) do
  fItems[i].Index := i;
end;

//==============================================================================

constructor TILElementFinderStage.Create;
begin
inherited Create;
SetLength(fItems,0);
end;

//------------------------------------------------------------------------------

constructor TILElementFinderStage.CreateAsCopy(Source: TILElementFinderStage; UniqueCopy: Boolean);
var
  i:  Integer;
begin
inherited CreateAsCopy(Source,UniqueCopy);
SetLength(fItems,Source.Count);
For i := Low(fItems) to High(fItems) do
  fItems[i] := TILElementComparator.CreateAsCopy(Source.Items[i],UniqueCopy);
end;

//------------------------------------------------------------------------------

destructor TILElementFinderStage.Destroy;
begin
Clear;
inherited;
end;

//------------------------------------------------------------------------------

Function TILElementFinderStage.AsString(Decorate: Boolean = True): String;
begin
If Length(fItems) = 1 then
  Result := IL_Format('Stage #%d (1 element option)',[Index])
else If Length(fItems) > 1 then
  Result := IL_Format('Stage #%d (%d element options)',[Index,Length(fItems)])
else
  Result := IL_Format('Stage #%d',[Index]);
// both index and operator are ignored
end;

//------------------------------------------------------------------------------

Function TILElementFinderStage.Search(const SearchSettings: TILAdvSearchSettings): Boolean;
var
  i:  Integer;
begin
Result := False;
For i := Low(fItems) to High(fItems) do
  If fItems[i].Search(SearchSettings) then
    begin
      Result := True;
      Break{For i};
    end;
end;

//------------------------------------------------------------------------------

procedure TILElementFinderStage.Prepare(Variables: TILItemShopParsingVariables);
var
  i:  Integer;
begin
inherited Prepare(Variables);
For i := Low(fItems) to High(fItems) do
  fItems[i].Prepare(Variables);
end;

//------------------------------------------------------------------------------

procedure TILElementFinderStage.ReInit;
var
  i:  Integer;
begin
For i := Low(fItems) to High(fItems) do
  fItems[i].ReInit;
end;

//------------------------------------------------------------------------------

Function TILElementFinderStage.IndexOf(Item: TObject): Integer;
var
  i:  Integer;
begin
Result := -1;
For i := Low(fItems) to High(fItems) do
  If fItems[i] = Item then
    begin
      Result := i;
      Break{For i};
    end;
end;

//------------------------------------------------------------------------------

Function TILElementFinderStage.AddComparator: TILElementComparator;
begin
SetLength(fItems,Length(fItems) + 1);
Result := TILElementComparator.Create;
fItems[High(fItems)] := Result;
Result.Index := High(fITems);
end;

//------------------------------------------------------------------------------

Function TILElementFinderStage.Remove(Item: TObject): Integer;
begin
Result := IndexOf(Item);
If Result >= 0 then
  Delete(Result);
end;

//------------------------------------------------------------------------------

procedure TILElementFinderStage.Delete(Index: Integer);
var
  i:  Integer;
begin
If (Index >= Low(fItems)) and (Index <= High(fItems)) then
  begin
    fItems[Index].Free;
    For i := Index to Pred(High(fItems)) do
      fItems[i] := fItems[i + 1];
    SetLength(fItems,Length(fItems) - 1);
    ReIndex;
  end
else raise Exception.CreateFmt('TILElementFinderStage.Delete: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

procedure TILElementFinderStage.Clear;
var
  i:  Integer;
begin
For i := Low(fItems) to High(fItems) do
  fItems[i].Free;
SetLength(fItems,0);
end;

//------------------------------------------------------------------------------

Function TILElementFinderStage.Compare(Element: TILHTMLElementNode): Boolean;
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

procedure TILElementFinderStage.SaveToStream(Stream: TStream);
var
  i:  Integer;
begin
Stream_WriteUInt32(Stream,IL_SEARCH_ELEMENTCOMPARATORGROUP);
Stream_WriteUInt32(Stream,Length(fItems));
For i := Low(fItems) to High(fItems) do
  fItems[i].SaveToStream(Stream);
end;

//------------------------------------------------------------------------------

procedure TILElementFinderStage.LoadFromStream(Stream: TStream);
var
  i:  Integer;
begin
Clear;
If Stream_ReadUInt32(Stream) <> IL_SEARCH_ELEMENTCOMPARATORGROUP then
  raise Exception.Create('TILElementFinderStage.LoadFromStream: Invalid stream format.');
SetLength(fItems,Stream_ReadUInt32(Stream));
For i := Low(fItems) to High(fItems) do
  begin
    fItems[i] := TILElementComparator.Create;
    fItems[i].LoadFromStream(Stream);
    fItems[i].Index := i;
  end;
end;

//******************************************************************************
//******************************************************************************

Function TILElementFinder.GetStageCount: Integer;
begin
Result := Length(fStages);
end;

//------------------------------------------------------------------------------

Function TILElementFinder.GetStage(Index: Integer): TILElementFinderStage;
begin
If (Index >= Low(fStages)) and (Index <= High(fStages)) then
  Result := fStages[Index]
else
  raise Exception.CreateFmt('TILElementFinder.GetStage: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

Function TILElementFinder.GetTotalItemCount: Integer;
var
  i:  Integer;
begin
Result := inherited GetTotalItemCount;
For i := Low(fStages) to High(fStages) do
  Inc(Result,fStages[i].TotalItemCount);
end;

//------------------------------------------------------------------------------

procedure TILElementFinder.ReIndex;
var
  i:  Integer;
begin
For i := Low(fStages) to High(fStages) do
  fStages[i].Index := i;
end;

//==============================================================================

constructor TILElementFinder.Create;
begin
inherited Create;
SetLength(fStages,0);
end;

//------------------------------------------------------------------------------

constructor TILElementFinder.CreateAsCopy(Source: TILElementFinder; UniqueCopy: Boolean);
var
  i:  Integer;
begin
inherited CreateAsCopy(Source,UniqueCopy);
SetLength(fStages,Source.StageCount);
For i := Low(fStages) to High(fStages) do
  fStages[i] := TILElementFinderStage.CreateAsCopy(Source.Stages[i],UniqueCopy);
end;

//------------------------------------------------------------------------------

destructor TILElementFinder.Destroy;
begin
StageClear;
inherited;
end;

//------------------------------------------------------------------------------

Function TILElementFinder.Search(const SearchSettings: TILAdvSearchSettings): Boolean;
var
  i:  Integer;
begin
Result := False;
For i := Low(fStages) to High(fStages) do
  If fStages[i].Search(SearchSettings) then
    begin
      Result := True;
      Break{For i};
    end;
end;

//------------------------------------------------------------------------------

procedure TILElementFinder.Prepare(Variables: TILItemShopParsingVariables);
var
  i:  Integer;
begin
inherited Prepare(Variables);
For i := Low(fStages) to High(fStages) do
  fStages[i].Prepare(Variables);
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

Function TILElementFinder.StageIndexOf(Stage: TObject): Integer;
var
  i:  Integer;
begin
Result := -1;
For i := Low(fStages) to High(fStages) do
  If fStages[i] = Stage then
    begin
      Result := i;
      Break{For i};
    end;
end;

//------------------------------------------------------------------------------

Function TILElementFinder.StageAdd: TILElementFinderStage;
begin
SetLength(fStages,Length(fStages) + 1);
Result := TILElementFinderStage.Create;
fStages[High(fStages)] := Result;
Result.Index := High(fStages);
end;

//------------------------------------------------------------------------------

Function TILElementFinder.StageRemove(Stage: TObject): Integer;
begin
Result := StageIndexOf(Stage);
If Result >= 0 then
  StageDelete(Result);
end;
 
//------------------------------------------------------------------------------

procedure TILElementFinder.StageDelete(Index: Integer);
var
  i:  Integer;
begin
If (Index >= Low(fStages)) and (Index <= High(fStages)) then
  begin
    fStages[Index].Free;
    For i := Index to Pred(High(fStages)) do
      fStages[i] := fStages[i + 1];
    SetLength(fStages,Length(fStages) - 1);
    ReIndex;
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

Function TILElementFinder.FindElements(Document: TILHTMLDocument; out Elements: TILHTMLElements): Boolean;
var
  FoundNodesL1: TObjectCountedDynArray;
  FoundNodesL2: TObjectCountedDynArray;
  i,j:          Integer;
begin
SetLength(Elements,0);
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
If (CDA_Count(FoundNodesL1) >= 1) and (Length(fStages) > 0) then
  begin
    SetLength(Elements,CDA_Count(FoundNodesL1));
    For i := Low(Elements) to High(Elements) do
      Elements[i] := TILHTMLElementNode(CDA_GetItem(FoundNodesL1,i));
  end;
Result := Length(Elements) > 0;
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
    fStages[i] := TILElementFinderStage.Create;
    fStages[i].LoadFromStream(Stream);
    fStages[i].Index := i;
  end;
end;

end.
