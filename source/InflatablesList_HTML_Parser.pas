unit InflatablesList_HTML_Parser;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  Classes,
  AuxTypes, CountedDynArrayObject,
  InflatablesList_HTML_Tokenizer, InflatablesList_HTML_Document;

type
  TILHTMLParser = class(TObject)
  private
    fSource:          TStream;
    fText:            UnicodeString;
    fRootAssigned:    Boolean;
    fRootElement:     TILHTMLElementNode;
    fCurrentElement:  TILHTMLElementNode;
    fOpenElements:    TObjectCountedDynArray;
  protected
    class Function IsVoidElement(const Name: String): Boolean; virtual;
    procedure TokenHandler(Sender: TObject; Token: TILHTMLToken; var Ack: Boolean); virtual;
    procedure Preprocess; virtual;
    procedure Parse; virtual;
  public
    constructor Create(Source: TStream);
    destructor Destroy; override;
    procedure Run; virtual;
    Function GetDocument: TILHTMLDocument; virtual;
  end;

implementation

uses
  SysUtils,
  StrRect,
  InflatablesList_Types, InflatablesList_HTML_UnicodeTagAttributeArray,
  InflatablesList_HTML_Preprocessor;

class Function TILHTMLParser.IsVoidElement(const Name: String): Boolean;
const
  VOID_ELEMENT_NAMES: array[0..13] of String = ('area','base','br','col','embed',
    'hr','img','input','link','meta','param','source','track','wbr');
var
  i:  Integer;
begin
Result := False;
For i := Low(VOID_ELEMENT_NAMES) to High(VOID_ELEMENT_NAMES) do
  If AnsiSameText(VOID_ELEMENT_NAMES[i],Name) then
    begin
      Result := True;
      Break{For i};
    end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLParser.TokenHandler(Sender: TObject; Token: TILHTMLToken; var Ack: Boolean);
var
  NewElement: TILHTMLElementNode;
  i:          Integer;
begin
case Token.TokenType of
  ilttStartTag:   begin
                    NewElement := TILHTMLElementNode.Create(fCurrentElement,IL_ReconvString(UnicodeToStr(Token.TagName)));
                    // add attributes
                    For i := CDA_Low(Token.Attributes) to CDA_High(Token.Attributes) do
                      NewElement.AttributeAdd(UnicodeToStr(CDA_GetItem(Token.Attributes,i).Name),
                                              UnicodeToStr(CDA_GetItem(Token.Attributes,i).Value));
                    If Token.SelfClosing or IsVoidElement(NewElement.Name.Str) then
                      NewElement.Close;
                    If not Assigned(fRootElement) then
                      begin
                        If fRootAssigned then
                          raise Exception.Create('Root was already assigned and now is nil.')
                        else
                          fRootAssigned := True;
                        fRootElement := NewElement;
                        fCurrentElement := fRootElement;
                        If NewElement.Open then
                          CDA_Add(fOpenElements,NewElement);
                      end
                    else If Assigned(fCurrentElement) then
                      begin
                        fCurrentElement.ElementAdd(NewElement);  
                        If NewElement.Open then
                          begin
                            CDA_Add(fOpenElements,NewElement);
                            fCurrentElement := NewElement;
                          end;
                      end
                    else fCurrentElement.Free;
                    If (Sender is TILHTMLTokenizer) then
                      begin
                        If AnsiSameText(UnicodeToStr('script'),Token.TagName) then
                          TILHTMLTokenizer(Sender).State := iltsScriptData
                        else If AnsiSameText(UnicodeToStr('noscript'),Token.TagName) then
                          TILHTMLTokenizer(Sender).State := iltsRAWText;
                      end;
                  end;
  ilttEndTag:     If Assigned(fCurrentElement) then
                    begin
                      If AnsiSameText(fCurrentElement.Name.Str,UnicodeToStr(Token.TagName)) then
                        begin
                          fCurrentElement.Close;
                          fCurrentElement := fCurrentElement.Parent;
                          CDA_Delete(fOpenElements,CDA_High(fOpenElements));
                        end
                      else
                        begin
                          // misnested
                          For i := CDA_High(fOpenElements) downto CDA_Low(fOpenElements) do
                            If AnsiSameText(TILHTMLElementNode(CDA_GetItem(fOpenElements,i)).Name.Str,UnicodeToStr(Token.TagName)) then
                              begin
                                fCurrentElement := TILHTMLElementNode(CDA_GetItem(fOpenElements,i)).Parent;
                                TILHTMLElementNode(CDA_GetItem(fOpenElements,i)).Close;
                                CDA_Delete(fOpenElements,i);
                                Break{For i};
                              end
                        end;
                    end;
  ilttCharacter:  If Assigned(fCurrentElement) then
                    fCurrentElement.TextAppend(Token.Data);
  ilttEndOfFile:  begin
                    For i := CDA_Low(fOpenElements) to CDA_High(fOpenElements) do
                      TILHTMLElementNode(CDA_GetItem(fOpenElements,i)).Close;
                    CDA_Clear(fOpenElements);
                  end;
else
 {ilttDOCTYPE,ilttComment}
  // ignore these tokens
end;
Ack := True;
end;

//------------------------------------------------------------------------------

procedure TILHTMLParser.Preprocess;
var
  Preprocessor: TILHTMLPreprocessor;
begin
Preprocessor := TILHTMLPreprocessor.Create;
try
  fSource.Seek(0,soBeginning);
  fText := Preprocessor.Process(fSource,True);
  If (Length(fText) <= 0) and (fSource.Size > 0) then
    begin
      fSource.Seek(0,soBeginning);
      fText := Preprocessor.Process(fSource,False);
    end;
finally
  Preprocessor.Free;
end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLParser.Parse;
var
  Tokenizer:  TILHTMLTokenizer;
begin
Tokenizer := TILHTMLTokenizer.Create;
try
  Tokenizer.RaiseParseErrors := True;
  Tokenizer.OnTokenEmit := TokenHandler;
  Tokenizer.Initialize(fText);
  Tokenizer.Run;
finally
  Tokenizer.Free;
end;
end;

//==============================================================================

constructor TILHTMLParser.Create(Source: TStream);
begin
inherited Create;
fSource := Source;
fText := '';
fRootAssigned := False;
fRootElement := nil;
fCurrentElement := nil;
CDA_Init(fOpenElements);
end;

//------------------------------------------------------------------------------

destructor TILHTMLParser.Destroy;
begin
If Assigned(fRootElement) then
  fRootElement.Free;
inherited;
end;

//------------------------------------------------------------------------------

procedure TILHTMLParser.Run;
begin
fRootAssigned := False;
If Assigned(fRootElement) then
  FreeAndNil(fRootElement); // this will also free all other elements
fCurrentElement := nil;
CDA_Clear(fOpenElements);
Preprocess;
Parse;
If not Assigned(fRootElement) then
  raise Exception.Create('Empty document.');
fRootElement.TextFinalize;
fRootElement.Close;
end;

//------------------------------------------------------------------------------

Function TILHTMLParser.GetDocument: TILHTMLDocument;
begin
Result := TILHTMLDocument.CreateAsCopy(nil,fRootElement)
end;

end.
