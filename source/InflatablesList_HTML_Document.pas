unit InflatablesList_HTML_Document;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  AuxTypes, CountedDynArrayObject, classes,
  InflatablesList_Types, InflatablesList_HTML_UnicodeCharArray,
  InflatablesList_HTML_TagAttributeArray;

type
  TILHTMLElementNode = class(TObject)
  private
    fParent:      TILHTMLElementNode;
    fOpen:        Boolean;
    fName:        String;
    fAttributes:  TILTagAttributeCountedDynArray;
    fTextArr:     TILUnicodeCharCountedDynArray;
    fText:        String;
    fElements:    TObjectCountedDynArray;
    Function GetAttributeCount: Integer;
    Function GetAttribute(Index: Integer): TILTagAttribute;
    Function GetElementCount: Integer;
    Function GetElement(Index: Integer): TILHTMLElementNode;
  protected
    Function Corresponds(SearchSettings: TILItemShopParsingStage): Boolean; virtual;
  public
    constructor Create(Parent: TILHTMLElementNode; const Name: String);
    constructor CreateAsCopy(Parent: TILHTMLElementNode; Source: TILHTMLElementNode);
    destructor Destroy; override;
    procedure Close; virtual;
    Function AttributeIndexOfName(const Name: String): Integer; virtual;
    Function AttributeIndexOfValue(const Value: String): Integer; virtual;
    Function AttributeIndexOf(const Name, Value: String): Integer; virtual;
    Function AttributeAdd(const Name,Value: String): Integer; virtual;
    procedure AttributeDelete(Index: Integer); virtual;
    procedure TextAppend(const Str: UnicodeString); overload; virtual;
    procedure TextAppend(const Chr: UnicodeChar); overload; virtual;
    procedure TextFinalize; virtual;
    Function ElementIndexOf(const Name: String): Integer; virtual;
    Function ElementAdd(Element: TILHTMLElementNode): Integer; virtual;
    procedure ElementDelete(Index: Integer); virtual;
    Function GetSubElementsCount: Integer; virtual;
    Function GetLevel: Integer; virtual;
    Function TextMatch(SearchSettings: TILItemShopParsingStage): Boolean; virtual;
    Function Find(SearchSettings: TILItemShopParsingStage; IncludeSelf: Boolean; var Storage: TObjectCountedDynArray): Integer; virtual;
    procedure List(Strs: TStrings); virtual;
    property Parent: TILHTMLElementNode read fParent;
    property Open: Boolean read fOpen;
    property Name: String read fName;
    property AttributeCount: Integer read GetAttributeCount;
    property Attributes[Index: Integer]: TILTagAttribute read GetAttribute;
    property Text: String read fText;
    property ElementCount: Integer read GetElementCount;
    property Elements[Index: Integer]: TILHTMLElementNode read GetElement; default;
  end;

  TILHTMLDocument = class(TILHTMLElementNode);

implementation

uses
  SysUtils, StrUtils,
  StrRect;

Function TILHTMLElementNode.GetAttributeCount: Integer;
begin
Result := CDA_Count(fAttributes);
end;

//------------------------------------------------------------------------------

Function TILHTMLElementNode.GetAttribute(Index: Integer): TILTagAttribute;
begin
If (Index >= CDA_Low(fAttributes)) and (Index <= CDA_High(fAttributes)) then
  Result := CDA_GetItem(fAttributes,Index)
else
  raise Exception.CreateFmt('TILHTMLElementNode.GetAttribute: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

Function TILHTMLElementNode.GetElementCount: Integer;
begin
Result := CDA_Count(fElements);
end;

//------------------------------------------------------------------------------

Function TILHTMLElementNode.GetElement(Index: Integer): TILHTMLElementNode;
begin
If (Index >= CDA_Low(fElements)) and (Index <= CDA_High(fElements)) then
  Result := TILHTMLElementNode(CDA_GetItem(fElements,Index))
else
  raise Exception.CreateFmt('TILHTMLElementNode.GetElement: Index (%d) out of bounds.',[Index]);
end;

//==============================================================================

Function TILHTMLElementNode.Corresponds(SearchSettings: TILItemShopParsingStage): Boolean;
begin
If Length(SearchSettings.ElementName) > 0 then
  begin
    Result := AnsiSameText(fName,SearchSettings.ElementName);
    If (Length(SearchSettings.AttributeName) > 0) and (Length(SearchSettings.AttributeValue) > 0) then
      Result := Result and (AttributeIndexOf(SearchSettings.AttributeName,SearchSettings.AttributeValue) >= 0)
    else If Length(SearchSettings.AttributeName) > 0 then
      Result := Result and (AttributeIndexOfName(SearchSettings.AttributeName) >= 0)
    else If Length(SearchSettings.AttributeValue) > 0 then
      Result := Result and (AttributeIndexOfValue(SearchSettings.AttributeValue) >= 0);
    If Result and (Length(SearchSettings.Text) > 0) then
      Result := TextMatch(SearchSettings);
  end
else Result := False;
end;

//==============================================================================

constructor TILHTMLElementNode.Create(Parent: TILHTMLElementNode; const Name: String);
begin
inherited Create;
fParent := Parent;
fOpen := True;
fName := Name;
CDA_Init(fAttributes);
CDA_Init(fTextArr);
fText := '';
CDA_Init(fElements);
end;

//------------------------------------------------------------------------------

constructor TILHTMLElementNode.CreateAsCopy(Parent: TILHTMLElementNode; Source: TILHTMLElementNode);
var
  Temp: UnicodeString;
  i:    Integer;
begin
Create(Parent,Source.Name);
fOpen := Source.Open;
Source.TextFinalize;
// copy attributes
For i := 0 to Pred(Source.AttributeCount) do
  CDA_Add(fAttributes,Source.Attributes[i]);
fText := Source.Text;
CDA_Clear(fTextArr);
Temp := StrToUnicode(fText);
For i := 1 to Length(Temp) do
  CDA_Add(fTextArr,Temp[i]);
// copy elements
For i := 0 to Pred(Source.ElementCount) do
  CDA_Add(fElements,TILHTMLElementNode.CreateAsCopy(Self,Source.Elements[i]));
end;

//------------------------------------------------------------------------------

destructor TILHTMLElementNode.Destroy;
var
  i:  Integer;
begin
CDA_Clear(fAttributes);
CDA_Clear(fTextArr);
For i := CDA_Low(fElements) to CDA_High(fElements) do
  FreeAndNil(CDA_GetItemPtr(fElements,i)^);
CDA_Clear(fElements);
inherited;
end;

//------------------------------------------------------------------------------

procedure TILHTMLElementNode.Close;
begin
fOpen := False;
TextFinalize;
end;

//------------------------------------------------------------------------------

Function TILHTMLElementNode.AttributeIndexOfName(const Name: String): Integer;
var
  i:  Integer;
begin
Result := -1;
For i := CDA_Low(fAttributes) to CDA_High(fAttributes) do
  If AnsiSameText(CDA_GetItem(fAttributes,i).Name,Name) then
    begin
      Result := i;
      Break{For i};
    end;
end;

//------------------------------------------------------------------------------

Function TILHTMLElementNode.AttributeIndexOfValue(const Value: String): Integer;
var
  i:  Integer;
begin
Result := -1;
For i := CDA_Low(fAttributes) to CDA_High(fAttributes) do
  If AnsiSameText(CDA_GetItem(fAttributes,i).Value,Value) then
    begin
      Result := i;
      Break{For i};
    end;
end;

//------------------------------------------------------------------------------

Function TILHTMLElementNode.AttributeIndexOf(const Name, Value: String): Integer;
var
  i:  Integer;
begin
Result := -1;
For i := CDA_Low(fAttributes) to CDA_High(fAttributes) do
  If AnsiSameText(CDA_GetItem(fAttributes,i).Name,Name) and
     AnsiSameText(CDA_GetItem(fAttributes,i).Value,Value) then
    begin
      Result := i;
      Break{For i};
    end;
end;

//------------------------------------------------------------------------------

Function TILHTMLElementNode.AttributeAdd(const Name,Value: String): Integer;
var
  Temp: TILTagAttribute;
begin
Temp.Name := Name;
Temp.Value := Value;
Result := CDA_Add(fAttributes,Temp);
end;

//------------------------------------------------------------------------------

procedure TILHTMLElementNode.AttributeDelete(Index: Integer);
begin
If (Index >= CDA_Low(fAttributes)) and (Index <= CDA_High(fAttributes)) then
  CDA_Delete(fAttributes,Index)
else
  raise Exception.CreateFmt('TILHTMLElementNode.AttributeDelete: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

procedure TILHTMLElementNode.TextAppend(const Str: UnicodeString);
var
  i:  Integer;
begin
For i := 1 to Length(Str) do
  CDA_Add(fTextArr,Str[i]);
end;

//------------------------------------------------------------------------------

procedure TILHTMLElementNode.TextAppend(const Chr: UnicodeChar);
begin
CDA_Add(fTextArr,Chr);
end;

//------------------------------------------------------------------------------

procedure TILHTMLElementNode.TextFinalize;
var
  Temp: UnicodeString;
  i:    Integer;
begin
SetLength(Temp,CDA_Count(fTextArr));
For i := CDA_Low(fTextArr) to CDA_High(fTextArr) do
  Temp[i + 1] := CDA_GetItem(fTextArr,i);
fText := UnicodeToStr(Temp);
end;

//------------------------------------------------------------------------------

Function TILHTMLElementNode.ElementIndexOf(const Name: String): Integer;
var
  i:  Integer;
begin
Result := -1;
For i := CDA_Low(fElements) to CDA_High(fElements) do
  If AnsiSameText(TILHTMLElementNode(CDA_GetItem(fElements,i)).Name,Name) then
    begin
      Result := i;
      Break{For i};
    end;
end;

//------------------------------------------------------------------------------

Function TILHTMLElementNode.ElementAdd(Element: TILHTMLElementNode): Integer;
begin
Result := CDA_Add(fElements,Element);
end;

//------------------------------------------------------------------------------

procedure TILHTMLElementNode.ElementDelete(Index: Integer);
begin
If (Index >= CDA_Low(fElements)) and (Index <= CDA_High(fElements)) then
  begin
    FreeAndNil(CDA_GetItemPtr(fElements,Index)^);
    CDA_Delete(fElements,Index);
  end
else raise Exception.CreateFmt('TILHTMLElementNode.ElementDelete: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

Function TILHTMLElementNode.GetSubElementsCount: Integer;
var
  i:  Integer;
begin
Result := CDA_Count(fElements);
For i := CDA_Low(fElements) to CDA_High(fElements) do
  Inc(Result,TILHTMLElementNode(CDA_GetItem(fElements,i)).GetElementCount);
end;

//------------------------------------------------------------------------------

Function TILHTMLElementNode.GetLevel: Integer;
begin
If Assigned(fParent) then
  Result := fParent.GetLevel + 1
else
  Result := 0;
end;

//------------------------------------------------------------------------------

Function TILHTMLElementNode.TextMatch(SearchSettings: TILItemShopParsingStage): Boolean;
var
  i:  Integer;
begin
If SearchSettings.FullTextMatch then
  Result := AnsiSameText(fText,SearchSettings.Text)
else
  Result := AnsiContainsText(fText,SearchSettings.Text);
If not Result and SearchSettings.RecursiveSearch then
  begin
    For i := CDA_Low(fElements) to CDA_High(fElements) do
      If TILHTMLElementNode(CDA_GetItem(fElements,i)).TextMatch(SearchSettings) then
        begin
          Result := True;
          Break{For i};
        end;
  end;
end;

//------------------------------------------------------------------------------

Function TILHTMLElementNode.Find(SearchSettings: TILItemShopParsingStage; IncludeSelf: Boolean; var Storage: TObjectCountedDynArray): Integer;
var
  i:  Integer;
begin
Result := 0;
If IncludeSelf then
  If Corresponds(SearchSettings) then
    begin
      CDA_Add(Storage,Self);
      Inc(Result);
    end;
For i := CDA_Low(fElements) to CDA_High(fElements) do
  begin
    If TILHTMLElementNode(CDA_GetItem(fElements,i)).Corresponds(SearchSettings) then
      begin
        CDA_Add(Storage,CDA_GetItem(fElements,i));
        Inc(Result);
      end;
    // recurse
    Inc(Result,TILHTMLElementNode(CDA_GetItem(fElements,i)).Find(SearchSettings,False,Storage));
  end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLElementNode.List(Strs: TStrings);
var
  i:  Integer;
begin
Strs.Add(StringOfChar(' ',GetLevel * 2) + '<' + fName + '>');
For i := CDA_Low(fElements) to CDA_High(fElements) do
  TILHTMLElementNode(CDA_GetItem(fElements,i)).List(Strs);
If CDA_Count(fElements) > 0 then
  Strs.Add(StringOfChar(' ',GetLevel * 2) + '</' + fName + '>');
end;

end.
