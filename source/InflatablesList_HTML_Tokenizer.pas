unit InflatablesList_HTML_Tokenizer;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  AuxTypes,
  InflatablesList_HTML_UnicodeCharArray,
  InflatablesList_HTML_UnicodeStringArray,
  InflatablesList_HTML_UnicodeTagAttributeArray;

type
  TILHTMLTokenizerState = (
    iltsData,iltsRCDATA,iltsRAWTEXT,iltsScriptData,iltsPLAINTEXT,iltsTagOpen,
    iltsEndTagOpen,iltsTagName,iltsRCDATALessThanSign,iltsRCDATAEndTagOpen,
    iltsRCDATAEndTagName,iltsRAWTEXTLessThanSign,iltsRAWTEXTEndTagOpen,
    iltsRAWTEXTEndTagName,iltsScriptDataLessThanSign,iltsScriptDataEndTagOpen,
    iltsScriptDataEndTagName,iltsScriptDataEscapeStart,iltsScriptDataEscapeStartDash,
    iltsScriptDataEscaped,iltsScriptDataEscapedDash,iltsScriptDataEscapedDashDash,
    iltsScriptDataEscapedLessThanSign,iltsScriptDataEscapedEndTagOpen,
    iltsScriptDataEscapedEndTagName,iltsScriptDataDoubleEscapeStart,
    iltsScriptDataDoubleEscaped,iltsScriptDataDoubleEscapedDash,
    iltsScriptDataDoubleEscapedDashDash,iltsScriptDataDoubleEscapedLessThanSign,
    iltsScriptDataDoubleEscapeEnd,iltsBeforeAttributeName,iltsAttributeName,
    iltsAfterAttributeName,iltsBeforeAttributeValue,iltsAttributeValue_DoubleQuoted,
    iltsAttributeValue_SingleQuoted,iltsAttributeValue_Unquoted,
    iltsAfterAttributeValue_Quoted,iltsSelfClosingStartTag,iltsBogusComment,
    iltsMarkupDeclarationOpen,iltsCommentStart,iltsCommentStartDash,iltsComment,
    iltsCommentLessThanSign,iltsCommentLessThanSignBang,iltsCommentLessThanSignBangDash,
    iltsCommentLessThanSignBangDashDash,iltsCommentEndDash,iltsCommentEnd,
    iltsCommentEndBang,iltsDOCTYPE,iltsBeforeDOCTYPEName,iltsDOCTYPEName,
    iltsAfterDOCTYPEName,iltsAfterDOCTYPEPublicKeyword,iltsBeforeDOCTYPEPublicIdentifier,
    iltsDOCTYPEPublicIdentifier_DoubleQuoted,iltsDOCTYPEPublicIdentifier_SingleQuoted,
    iltsAfterDOCTYPEPublicIdentifier,iltsBetweenDOCTYPEPublicAndSystemIdentifiers,
    iltsAfterDOCTYPESystemKeyword,iltsBeforeDOCTYPESystemIdentifier,
    iltsDOCTYPESystemIdentifier_DoubleQuoted,iltsDOCTYPESystemIdentifier_SingleQuoted,
    iltsAfterDOCTYPESystemIdentifier,iltsBogusDOCTYPE,iltsCDATASection,
    iltsCDATASectionBracket,iltsCDATASectionEnd,iltsCharacterReference,
    iltsNumericCharacterReference,iltsHexadecimalCharacterReferenceStart,
    iltsDecimalCharacterReferenceStart,iltsHexadecimalCharacterReference,
    iltsDecimalCharacterReference,iltsNumericCharacterReferenceEnd,
    iltsCharacterReferenceEnd);

  TILHTMLTokenType = (ilttDOCTYPE,ilttStartTag,ilttEndTag,ilttComment,
                      ilttCharacter,ilttEndOfFile);

  TILHTMLTokenField = (iltfName,iltfPublicIdent,iltfSystemIdent,iltfTagName,iltfData);

  TILHTMLTokenFields = set of TILHTMLTokenField;

  TILHTMLToken = record
    TokenType:          TILHTMLTokenType;
    // DOCTYPE fields
    PresentFields:      TILHTMLTokenFields; // presence of Name, PublicIdentifier and SystemIdentifier
    Name:               UnicodeString;
    PublicIdentifier:   UnicodeString;
    SystemIdentifier:   UnicodeString;
    ForceQuirks:        Boolean;
    // tag fields
    TagName:            UnicodeString;
    SelfClosing:        Boolean;
    Attributes:         TILUnicodeTagAttributeCountedDynArray;
    // comment and char fields
    Data:               UnicodeString;
    // other info
    AppropriateEndTag:  Boolean;
  end;

  TILHTMLTokenEvent = procedure(Sender: TObject; Token: TILHTMLToken; var Ack: Boolean) of object;

  TILHTMLTokenizer = class(TObject)
  private
    fData:            UnicodeString;
    fPosition:        Integer;
    // state machine
    fParserPause:     Boolean;
    fState:           TILHTMLTokenizerState;
    fReturnState:     TILHTMLTokenizerState;
    fTemporaryBuffer: TILUnicodeCharCountedDynArray;
    fCharRefCode:     UInt32;
    // helpers
    fCurrentToken:    TILHTMLToken;
    fLastStartTag:    TILUnicodeStringCountedDynArray;
    // others
    fRaiseParseErrs:  Boolean;
    fOnTokenEmit:     TILHTMLTokenEvent;
    Function GetProgress: Double;
  protected
    // parsing errors
    Function ParseError(const Msg: String): Boolean; overload; virtual;
    Function ParseError(const Msg: String; Args: array of const): Boolean; overload; virtual;
    Function ParseErrorInvalidChar(Char: UnicodeChar): Boolean; virtual;
    // helpers
    procedure CreateNewToken(out Token: TILHTMLToken; TokenType: TILHTMLTokenType); overload; virtual;
    procedure CreateNewToken(TokenType: TILHTMLTokenType); overload; virtual;
    Function IsAppropriateEndTagToken(Token: TILHTMLToken): Boolean; virtual;
    Function TemporaryBufferAsStr: UnicodeString; virtual;
    Function TemporaryBufferEquals(const Str: UnicodeString; CaseSensitive: Boolean): Boolean; virtual;
    Function IsCurrentInputString(const Str: UnicodeString; CaseSensitive: Boolean): Boolean; virtual;
    procedure AppendToCurrentToken(TokenField: TILHTMLTokenField; Char: UnicodeChar); virtual;
    procedure CreateNewAttribute(const Name,Value: UnicodeString); virtual;
    procedure AppendCurrentAttributeName(Char: UnicodeChar); virtual;
    procedure AppendCurrentAttributeValue(Char: UnicodeChar); virtual;
    // tokens emitting
    procedure EmitToken(Token: TILHTMLToken); virtual;
    procedure EmitCurrentToken; virtual;
    procedure EmitCurrentDOCTYPEToken; virtual;
    procedure EmitCurrentTagToken; virtual;
    procedure EmitCurrentCommentToken; virtual;
    procedure EmitCharToken(Char: UnicodeChar); virtual;
    procedure EmitEndOfFileToken; virtual;
    // state methods
    procedure State_Data; virtual; 
    procedure State_RCDATA; virtual; 
    procedure State_RAWTEXT; virtual; 
    procedure State_ScriptData; virtual; 
    procedure State_PLAINTEXT; virtual; 
    procedure State_TagOpen; virtual; 
    procedure State_EndTagOpen; virtual; 
    procedure State_TagName; virtual;
    procedure State_RCDATALessThanSign; virtual;
    procedure State_RCDATAEndTagOpen; virtual;
    procedure State_RCDATAEndTagName; virtual;
    procedure State_RAWTEXTLessThanSign; virtual;
    procedure State_RAWTEXTEndTagOpen; virtual; 
    procedure State_RAWTEXTEndTagName; virtual; 
    procedure State_ScriptDataLessThanSign; virtual; 
    procedure State_ScriptDataEndTagOpen; virtual; 
    procedure State_ScriptDataEndTagName; virtual; 
    procedure State_ScriptDataEscapeStart; virtual; 
    procedure State_ScriptDataEscapeStartDash; virtual;
    procedure State_ScriptDataEscaped; virtual; 
    procedure State_ScriptDataEscapedDash; virtual; 
    procedure State_ScriptDataEscapedDashDash; virtual; 
    procedure State_ScriptDataEscapedLessThanSign; virtual; 
    procedure State_ScriptDataEscapedEndTagOpen; virtual; 
    procedure State_ScriptDataEscapedEndTagName; virtual; 
    procedure State_ScriptDataDoubleEscapeStart; virtual; 
    procedure State_ScriptDataDoubleEscaped; virtual; 
    procedure State_ScriptDataDoubleEscapedDash; virtual; 
    procedure State_ScriptDataDoubleEscapedDashDash; virtual; 
    procedure State_ScriptDataDoubleEscapedLessThanSign; virtual; 
    procedure State_ScriptDataDoubleEscapeEnd; virtual; 
    procedure State_BeforeAttributeName; virtual; 
    procedure State_AttributeName; virtual; 
    procedure State_AfterAttributeName; virtual; 
    procedure State_BeforeAttributeValue; virtual; 
    procedure State_AttributeValue_DoubleQuoted; virtual; 
    procedure State_AttributeValue_SingleQuoted; virtual; 
    procedure State_AttributeValue_Unquoted; virtual; 
    procedure State_AfterAttributeValue_Quoted; virtual; 
    procedure State_SelfClosingStartTag; virtual; 
    procedure State_BogusComment; virtual; 
    procedure State_MarkupDeclarationOpen; virtual; 
    procedure State_CommentStart; virtual; 
    procedure State_CommentStartDash; virtual; 
    procedure State_Comment; virtual; 
    procedure State_CommentLessThanSign; virtual; 
    procedure State_CommentLessThanSignBang; virtual; 
    procedure State_CommentLessThanSignBangDash; virtual; 
    procedure State_CommentLessThanSignBangDashDash; virtual; 
    procedure State_CommentEndDash; virtual; 
    procedure State_CommentEnd; virtual; 
    procedure State_CommentEndBang; virtual; 
    procedure State_DOCTYPE; virtual; 
    procedure State_BeforeDOCTYPEName; virtual; 
    procedure State_DOCTYPEName; virtual; 
    procedure State_AfterDOCTYPEName; virtual; 
    procedure State_AfterDOCTYPEPublicKeyword; virtual; 
    procedure State_BeforeDOCTYPEPublicIdentifier; virtual; 
    procedure State_DOCTYPEPublicIdentifier_DoubleQuoted; virtual; 
    procedure State_DOCTYPEPublicIdentifier_SingleQuoted; virtual; 
    procedure State_AfterDOCTYPEPublicIdentifier; virtual; 
    procedure State_BetweenDOCTYPEPublicAndSystemIdentifiers; virtual; 
    procedure State_AfterDOCTYPESystemKeyword; virtual; 
    procedure State_BeforeDOCTYPESystemIdentifier; virtual; 
    procedure State_DOCTYPESystemIdentifier_DoubleQuoted; virtual; 
    procedure State_DOCTYPESystemIdentifier_SingleQuoted; virtual; 
    procedure State_AfterDOCTYPESystemIdentifier; virtual; 
    procedure State_BogusDOCTYPE; virtual; 
    procedure State_CDATASection; virtual; 
    procedure State_CDATASectionBracket; virtual; 
    procedure State_CDATASectionEnd; virtual;
    procedure State_CharacterReference_ResolveNamedReference; virtual;
    procedure State_CharacterReference; virtual;
    procedure State_NumericCharacterReference; virtual; 
    procedure State_HexadecimalCharacterReferenceStart; virtual; 
    procedure State_DecimalCharacterReferenceStart; virtual; 
    procedure State_HexadecimalCharacterReference; virtual; 
    procedure State_DecimalCharacterReference; virtual; 
    procedure State_NumericCharacterReferenceEnd; virtual; 
    procedure State_CharacterReferenceEnd; virtual;
    procedure State_Select; virtual;
    Function NextInputChar: UnicodeChar; virtual;
    Function CurrentInputChar: UnicodeChar; virtual;
    Function ConsumeNextInputChar: UnicodeChar; virtual;
    procedure ReconsumeInputChar; virtual;
    Function EndOfFile: Boolean; virtual;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Initialize(const Data: UnicodeString);
    Function Run: Boolean; virtual;
    property Data: UnicodeString read fData;
    property ParserPause: Boolean read fParserPause write fParserPause;
    property State: TILHTMLTokenizerState read fState write fState;
    property RaiseParseErrors: Boolean read fRaiseParseErrs write fRaiseParseErrs;
    property Progress: Double read GetProgress;
    property OnTokenEmit: TILHTMLTokenEvent read fOnTokenEmit write fOnTokenEmit;
  end;

implementation

uses
  SysUtils,
  StrRect,
  InflatablesList_Utils,
  InflatablesList_HTML_Common, InflatablesList_HTML_NamedCharRefs;

type
  TILCharReplaceEntry = record
    OldChar:      UnicodeChar;
    Replacement:  UnicodeChar;
  end;

const
  IL_TOKENIZER_CHAR_REPLACE: array[0..27] of TILCharReplaceEntry = (
    (OldChar: #$0000; Replacement: #$FFFD),(OldChar: #$0080; Replacement: #$20AC),
    (OldChar: #$0082; Replacement: #$201A),(OldChar: #$0083; Replacement: #$0192),
    (OldChar: #$0084; Replacement: #$201E),(OldChar: #$0085; Replacement: #$2026),
    (OldChar: #$0086; Replacement: #$2020),(OldChar: #$0087; Replacement: #$2021),
    (OldChar: #$0088; Replacement: #$02C6),(OldChar: #$0089; Replacement: #$3030),
    (OldChar: #$008A; Replacement: #$0160),(OldChar: #$008B; Replacement: #$2039),
    (OldChar: #$008C; Replacement: #$0152),(OldChar: #$008E; Replacement: #$017D),
    (OldChar: #$0091; Replacement: #$2018),(OldChar: #$0092; Replacement: #$2019),
    (OldChar: #$0093; Replacement: #$201C),(OldChar: #$0094; Replacement: #$201D),
    (OldChar: #$0095; Replacement: #$2022),(OldChar: #$0096; Replacement: #$2013),
    (OldChar: #$0097; Replacement: #$2014),(OldChar: #$0098; Replacement: #$02DC),
    (OldChar: #$0099; Replacement: #$2122),(OldChar: #$009A; Replacement: #$0161),
    (OldChar: #$009B; Replacement: #$203A),(OldChar: #$009C; Replacement: #$0153),
    (OldChar: #$009E; Replacement: #$017E),(OldChar: #$009F; Replacement: #$0178));

  IL_TOKENIZER_CHAR_FORBIDDEN: array[0..34] of UInt32 = (
     $000B,  $FFFE,  $FFFF, $1FFFE, $1FFFF, $2FFFE, $2FFFF, $3FFFE,
    $3FFFF, $4FFFE, $4FFFF, $5FFFE, $5FFFF, $6FFFE, $6FFFF, $7FFFE,
    $7FFFF, $8FFFE, $8FFFF, $9FFFE, $9FFFF, $AFFFE, $AFFFF, $BFFFE,
    $BFFFF, $CFFFE, $CFFFF, $DFFFE, $DFFFF, $EFFFE, $EFFFF, $FFFFE,
    $FFFFF,$10FFFE,$10FFFF);

//==============================================================================

Function TILHTMLTokenizer.GetProgress: Double;
begin
If Length(fData) > 0 then
  begin
    If fPosition <= 1 then
      Result := 0.0
    else If fPosition >= Length(fData) then
      Result := 1.0
    else
      Result := fPosition / Length(fData);
  end
else Result := 0.0;
end;

//==============================================================================

Function TILHTMLTokenizer.ParseError(const Msg: String): Boolean;
begin
Result := fRaiseParseErrs;
If fRaiseParseErrs then
  raise EILParseError.Create(Msg);
end;

//------------------------------------------------------------------------------

Function TILHTMLTokenizer.ParseError(const Msg: String; Args: array of const): Boolean;
begin
Result := ParseError(Format(Msg,Args));
end;

//------------------------------------------------------------------------------

Function TILHTMLTokenizer.ParseErrorInvalidChar(Char: UnicodeChar): Boolean;
begin
Result := ParseError('Invalid character (#%.4x) for this state (%d @ %d).',[Ord(Char),Ord(fState),Pred(fPosition)]);
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.CreateNewToken(out Token: TILHTMLToken; TokenType: TILHTMLTokenType);
begin
Token.TokenType := TokenType;
// doctype
Token.PresentFields := [];
Token.Name := '';
Token.PublicIdentifier := '';
Token.SystemIdentifier := '';
Token.ForceQuirks := False;
// tags
Token.TagName := '';
Token.SelfClosing := False;
CDA_Clear(Token.Attributes);
// comment, char
Token.Data := '';
// others
Token.AppropriateEndTag := False;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.CreateNewToken(TokenType: TILHTMLTokenType);
begin
CreateNewToken(fCurrentToken,TokenType);
end;

//------------------------------------------------------------------------------

Function TILHTMLTokenizer.IsAppropriateEndTagToken(Token: TILHTMLToken): Boolean;
begin
If (Token.TokenType = ilttEndTag) and (CDA_Count(fLastStartTag) > 0) then
  Result := IL_UnicodeSameString(CDA_Last(fLastStartTag),Token.TagName,False)
else
  Result := False;
end;

//------------------------------------------------------------------------------

Function TILHTMLTokenizer.TemporaryBufferAsStr: UnicodeString;
var
  i:  Integer;
begin
SetLength(Result,CDA_Count(fTemporaryBuffer));
For i := CDA_Low(fTemporaryBuffer) to CDA_High(fTemporaryBuffer) do
  Result[i + 1] := CDA_GetItem(fTemporaryBuffer,i);
end;

//------------------------------------------------------------------------------

Function TILHTMLTokenizer.TemporaryBufferEquals(const Str: UnicodeString; CaseSensitive: Boolean): Boolean;
begin
Result := IL_UnicodeSameString(TemporaryBufferAsStr,Str,CaseSensitive)
end;

//------------------------------------------------------------------------------

Function TILHTMLTokenizer.IsCurrentInputString(const Str: UnicodeString; CaseSensitive: Boolean): Boolean;
var
  TempStr:  String;
begin
TempStr := Copy(fData,fPosition - 1,Length(Str));
Result := IL_UnicodeSameString(TempStr,Str,CaseSensitive);
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.AppendToCurrentToken(TokenField: TILHTMLTokenField; Char: UnicodeChar);
begin
case TokenField of
  iltfName:         fCurrentToken.Name := fCurrentToken.Name + Char;
  iltfPublicIdent:  fCurrentToken.PublicIdentifier := fCurrentToken.PublicIdentifier + Char;
  iltfSystemIdent:  fCurrentToken.SystemIdentifier := fCurrentToken.SystemIdentifier + Char; 
  iltfTagName:      fCurrentToken.TagName := fCurrentToken.TagName + Char;
  iltfData:         fCurrentToken.Data := fCurrentToken.Data + Char;
end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.CreateNewAttribute(const Name,Value: UnicodeString);
var
  NewItem:  TILUnicodeTagAttribute;
begin
NewItem.Name := Name;
NewItem.Value := Value;
CDA_Add(fCurrentToken.Attributes,NewItem);
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.AppendCurrentAttributeName(Char: UnicodeChar);
begin
If CDA_Count(fCurrentToken.Attributes) > 0 then
  CDA_GetItemPtr(fCurrentToken.Attributes,CDA_High(fCurrentToken.Attributes))^.Name :=
    CDA_GetItemPtr(fCurrentToken.Attributes,CDA_High(fCurrentToken.Attributes))^.Name + Char
else
  ParseError('Cannot append to attribute name, no attribute exists.');
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.AppendCurrentAttributeValue(Char: UnicodeChar);
begin
If CDA_Count(fCurrentToken.Attributes) > 0 then
  CDA_GetItemPtr(fCurrentToken.Attributes,CDA_High(fCurrentToken.Attributes))^.Value :=
    CDA_GetItemPtr(fCurrentToken.Attributes,CDA_High(fCurrentToken.Attributes))^.Value + Char
else
  ParseError('Cannot append to attribute value, no attribute exists.');
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.EmitToken(Token: TILHTMLToken);
var
  Acknowledged: Boolean;
  i,Index:      Integer;
begin
Acknowledged := False;
// remove duplicit attributes
If CDA_Count(Token.Attributes) > 0 then
  For i := CDA_High(Token.Attributes) downto CDA_Low(Token.Attributes) do
    begin
      Index := CDA_IndexOf(Token.Attributes,CDA_GetItem(Token.Attributes,i));
      If (Index >= 0) and (Index < i) then
        If not ParseError('Duplicit attribute %s',[CDA_GetItem(Token.Attributes,i).Name]) then
          CDA_Delete(Token.Attributes,i);
    end;
If Assigned(fOnTokenEmit) then
  case Token.TokenType of
    ilttStartTag: begin
                    fOnTokenEmit(Self,Token,Acknowledged);
                    CDA_Add(fLastStartTag,Token.TagName);
                    If Token.SelfClosing and not Acknowledged then
                      ParseError('Self closing start tag not acknowledged.');
                  end;
    ilttEndTag:   If CDA_Count(Token.Attributes) <= 0 then
                    begin
                      If not Token.SelfClosing then
                        begin
                          Token.AppropriateEndTag := IsAppropriateEndTagToken(Token);
                          fOnTokenEmit(Self,Token,Acknowledged);
                          If Token.AppropriateEndTag then
                            CDA_Delete(fLastStartTag,CDA_High(fLastStartTag));
                        end
                      else ParseError('Emitted end tag token with self-closing flag set.');
                    end
                  else ParseError('Emitted end tag token with attributes.');
    ilttDOCTYPE:  begin
                    If Length(Token.PublicIdentifier) > 0 then
                      Include(Token.PresentFields,iltfPublicIdent);
                    If Length(Token.SystemIdentifier) > 0 then
                      Include(Token.PresentFields,iltfSystemIdent);
                    fOnTokenEmit(Self,Token,Acknowledged);
                  end;
  else
    {Comment,Character,EndOfFile}
    fOnTokenEmit(Self,Token,Acknowledged);
  end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.EmitCurrentToken;
begin
EmitToken(fCurrentToken);
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.EmitCurrentDOCTYPEToken;
begin
If fCurrentToken.TokenType = ilttDOCTYPE then
  EmitCurrentToken
else
  ParseError('Current token (%d) is not of expected type (DOCTYPE).',[Ord(fCurrentToken.TokenType)]);
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.EmitCurrentTagToken;
begin
If fCurrentToken.TokenType in [ilttStartTag,ilttEndTag] then
  EmitCurrentToken
else
  ParseError('Current token (%d) is not of expected type (tag).',[Ord(fCurrentToken.TokenType)]);
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.EmitCurrentCommentToken;
begin
If fCurrentToken.TokenType = ilttComment then
  EmitCurrentToken
else
  ParseError('Current token (%d) is not of expected type (comment).',[Ord(fCurrentToken.TokenType)]);
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.EmitCharToken(Char: UnicodeChar);
var
  Token:  TILHTMLToken;
begin
CreateNewToken(Token,ilttCharacter);
Token.Data := Char;
EmitToken(Token);
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.EmitEndOfFileToken;
var
  Token:  TILHTMLToken;
begin
CreateNewToken(Token,ilttEndOfFile);
EmitToken(Token);
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_Data;
begin
If not EndOfFile then
  begin
  case ConsumeNextInputChar of
    UnicodeChar('&'): begin
                        fReturnState := iltsData;
                        fState := iltsCharacterReference;
                      end;
    UnicodeChar('<'): fState := iltsTagOpen;
    UnicodeChar(#0):  If not ParseErrorInvalidChar(CurrentInputChar) then
                        EmitCharToken(CurrentInputChar);
  else
    EmitCharToken(CurrentInputChar);
  end;
  end
else EmitEndOfFileToken;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_RCDATA;
begin
If not EndOfFile then
  case ConsumeNextInputChar of
    UnicodeChar('&'): begin
                        fReturnState := iltsRCDATA;
                        fState := iltsCharacterReference;
                      end;
    UnicodeChar('<'): fState := iltsRCDATALessThanSign;
    UnicodeChar(#0):  If not ParseErrorInvalidChar(CurrentInputChar) then
                        EmitCharToken(#$FFFD);
  else
    EmitCharToken(CurrentInputChar);
  end
else EmitEndOfFileToken;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_RAWTEXT;
begin
If not EndOfFile then
  case ConsumeNextInputChar of
    UnicodeChar('<'): fState := iltsRAWTEXTLessThanSign;
    UnicodeChar(#0):  If not ParseErrorInvalidChar(CurrentInputChar) then
                        EmitCharToken(#$FFFD);
  else
    EmitCharToken(CurrentInputChar);
  end
else EmitEndOfFileToken;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_ScriptData;
begin
If not EndOfFile then
  case ConsumeNextInputChar of
    UnicodeChar('<'): fState := iltsScriptDataLessThanSign;
    UnicodeChar(#0):  If not ParseErrorInvalidChar(CurrentInputChar) then
                        EmitCharToken(#$FFFD);
  else
    EmitCharToken(CurrentInputChar);
  end
else EmitEndOfFileToken;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_PLAINTEXT;
begin
If not EndOfFile then
  case ConsumeNextInputChar of
    UnicodeChar(#0):  If not ParseErrorInvalidChar(CurrentInputChar) then
                        EmitCharToken(#$FFFD);
  else
    EmitCharToken(CurrentInputChar);
  end
else EmitEndOfFileToken;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_TagOpen;
begin
case ConsumeNextInputChar of
  UnicodeChar('!'):   fState := iltsMarkupDeclarationOpen;
  UnicodeChar('/'):   fState := iltsEndTagOpen;
  UnicodeChar('a')..
  UnicodeChar('z'),
  UnicodeChar('A')..
  UnicodeChar('Z'):   begin
                        CreateNewToken(ilttStartTag);
                        ReconsumeInputChar;
                        fState := iltsTagName;
                      end;
  UnicodeChar('?'):   If not ParseErrorInvalidChar(CurrentInputChar) then
                        begin
                          CreateNewToken(ilttComment);
                          ReconsumeInputChar;
                          fState := iltsBogusComment;
                        end;
else
  If not ParseErrorInvalidChar(CurrentInputChar) then
    begin
      EmitCharToken(UnicodeChar('<'));
      ReconsumeInputChar;
      fState := iltsData;
    end;
end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_EndTagOpen;
begin
If not EndOfFile then
  case ConsumeNextInputChar of
    UnicodeChar('a')..
    UnicodeChar('z'),
    UnicodeChar('A')..
    UnicodeChar('Z'): begin
                        CreateNewToken(ilttEndTag);
                        ReconsumeInputChar;
                        fState := iltsTagName;
                      end;
    UnicodeChar('>'): If not ParseErrorInvalidChar(CurrentInputChar) then
                        fState := iltsData;
  else
    If not ParseErrorInvalidChar(CurrentInputChar) then
      begin
        CreateNewToken(ilttComment);
        ReconsumeInputChar;
        fState := iltsBogusComment;
      end;
  end
else
  begin
    If not ParseError('Unexpected end of file.') then
      begin
        EmitCharToken(UnicodeChar('<'));
        EmitCharToken(UnicodeChar('/'));
        EmitEndOfFileToken;
      end;
  end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_TagName;
begin
If not EndOfFile then
  case ConsumeNextInputChar of
    #$0009,
    #$000A,
    #$000C,
    #$0020:           fState := iltsBeforeAttributeName;
    UnicodeChar('/'): fState := iltsSelfClosingStartTag;
    UnicodeChar('>'): begin
                        fState := iltsData;
                        EmitCurrentTagToken;
                      end;
    UnicodeChar('A')..
    UnicodeChar('Z'): AppendToCurrentToken(iltfTagName,UnicodeChar(Ord(CurrentInputChar) + $20));
    UnicodeChar(#0):  If not ParseErrorInvalidChar(CurrentInputChar) then
                        AppendToCurrentToken(iltfTagName,#$FFFD);
  else
    AppendToCurrentToken(iltfTagName,CurrentInputChar);
  end
else
  begin
    If not ParseError('Unexpected end of file.') then
      EmitEndOfFileToken;
  end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_RCDATALessThanSign;
begin
case ConsumeNextInputChar of
  UnicodeChar('/'): begin
                      CDA_Clear(fTemporaryBuffer);
                      fState := iltsRCDATAEndTagOpen;
                    end;
else
  EmitCharToken(UnicodeChar('<'));
  ReconsumeInputChar;
  fState := iltsRCDATA;
end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_RCDATAEndTagOpen;
begin
case ConsumeNextInputChar of
  UnicodeChar('a')..
  UnicodeChar('z'),
  UnicodeChar('A')..
  UnicodeChar('Z'): begin
                      CreateNewToken(ilttEndTag);
                      ReconsumeInputChar;
                      fState := iltsRCDATAEndTagName;
                    end;
else
  EmitCharToken(UnicodeChar('<'));
  EmitCharToken(UnicodeChar('/'));
  ReconsumeInputChar;
  fState := iltsRCDATA;
end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_RCDATAEndTagName;

  procedure DefaultAction;
  var
    i:  Integer;
  begin
    EmitCharToken(UnicodeChar('<'));
    EmitCharToken(UnicodeChar('/'));
    For i := CDA_Low(fTemporaryBuffer) to CDA_High(fTemporaryBuffer) do
      EmitCharToken(CDA_GetItem(fTemporaryBuffer,i));
    ReconsumeInputChar;
    fState := iltsRCDATA;
  end;

begin
case ConsumeNextInputChar of
  #$0009,
  #$000A,
  #$000C,
  #$0020:           If IsAppropriateEndTagToken(fCurrentToken) then
                      fState := iltsBeforeAttributeName
                    else
                      DefaultAction;
  UnicodeChar('/'): If IsAppropriateEndTagToken(fCurrentToken) then
                      fState := iltsSelfClosingStartTag
                    else
                      DefaultAction;
  UnicodeChar('>'): If IsAppropriateEndTagToken(fCurrentToken) then
                      begin
                        fState := iltsData;
                        EmitCurrentTagToken;
                      end
                    else DefaultAction;
  UnicodeChar('A')..
  UnicodeChar('Z'): begin
                      AppendToCurrentToken(iltfTagName,UnicodeChar(Ord(CurrentInputChar) + $20));
                      CDA_Add(fTemporaryBuffer,CurrentInputChar);
                    end;
  UnicodeChar('a')..
  UnicodeChar('z'): begin
                      AppendToCurrentToken(iltfTagName,CurrentInputChar);
                      CDA_Add(fTemporaryBuffer,CurrentInputChar);
                    end;
else
  DefaultAction;
end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_RAWTEXTLessThanSign;
begin
case ConsumeNextInputChar of
  UnicodeChar('/'): begin
                      CDA_Clear(fTemporaryBuffer);
                      fState := iltsRAWTEXTEndTagOpen;
                    end;
else
  EmitCharToken(UnicodeChar('<'));
  ReconsumeInputChar;
  fState := iltsRAWTEXT;
end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_RAWTEXTEndTagOpen;
begin
case ConsumeNextInputChar of
  UnicodeChar('a')..
  UnicodeChar('z'),
  UnicodeChar('A')..
  UnicodeChar('Z'): begin
                      CreateNewToken(ilttEndTag);
                      ReconsumeInputChar;
                      fState := iltsRAWTEXTEndTagName;
                    end;
else
  EmitCharToken(UnicodeChar('<'));
  EmitCharToken(UnicodeChar('/'));
  ReconsumeInputChar;
  fState := iltsRAWTEXT;
end;
end;

//------------------------------------------------------------------------------
 
procedure TILHTMLTokenizer.State_RAWTEXTEndTagName;

  procedure DefaultAction;
  var
    i:  Integer;
  begin
    EmitCharToken(UnicodeChar('<'));
    EmitCharToken(UnicodeChar('/'));
    For i := CDA_Low(fTemporaryBuffer) to CDA_High(fTemporaryBuffer) do
      EmitCharToken(CDA_GetItem(fTemporaryBuffer,i));
    ReconsumeInputChar;
    fState := iltsRAWTEXT;
  end;

begin
case ConsumeNextInputChar of
  #$0009,
  #$000A,
  #$000C,
  #$0020:           If IsAppropriateEndTagToken(fCurrentToken) then
                      fState := iltsBeforeAttributeName
                    else
                      DefaultAction;
  UnicodeChar('/'): If IsAppropriateEndTagToken(fCurrentToken) then
                      fState := iltsSelfClosingStartTag
                    else
                      DefaultAction;
  UnicodeChar('>'): If IsAppropriateEndTagToken(fCurrentToken) then
                      begin
                        fState := iltsData;
                        EmitCurrentTagToken;
                      end
                    else DefaultAction;
  UnicodeChar('A')..
  UnicodeChar('Z'): begin
                      AppendToCurrentToken(iltfTagName,UnicodeChar(Ord(CurrentInputChar) + $20));
                      CDA_Add(fTemporaryBuffer,CurrentInputChar);
                    end;
  UnicodeChar('a')..
  UnicodeChar('z'): begin
                      AppendToCurrentToken(iltfTagName,CurrentInputChar);
                      CDA_Add(fTemporaryBuffer,CurrentInputChar);
                    end;
else
  DefaultAction;
end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_ScriptDataLessThanSign;
begin
case ConsumeNextInputChar of
  UnicodeChar('/'): begin
                      CDA_Clear(fTemporaryBuffer);
                      fState := iltsScriptDataEndTagOpen;
                    end;
  UnicodeChar('!'): begin
                      fState := iltsScriptDataEscapeStart;
                      EmitCharToken(UnicodeChar('<'));
                      EmitCharToken(UnicodeChar('!'));
                    end;
else
  EmitCharToken(UnicodeChar('<'));
  ReconsumeInputChar;
  fState := iltsScriptData;
end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_ScriptDataEndTagOpen;
begin
case ConsumeNextInputChar of
  UnicodeChar('a')..
  UnicodeChar('z'),
  UnicodeChar('A')..
  UnicodeChar('Z'): begin
                      CreateNewToken(ilttEndTag);
                      ReconsumeInputChar;
                      fState := iltsScriptDataEndTagName;
                    end;
else
  EmitCharToken(UnicodeChar('<'));
  EmitCharToken(UnicodeChar('/'));
  ReconsumeInputChar;
  fState := iltsScriptData;
end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_ScriptDataEndTagName;

  procedure DefaultAction;
  var
    i:  Integer;
  begin
    EmitCharToken(UnicodeChar('<'));
    EmitCharToken(UnicodeChar('/'));
    For i := CDA_Low(fTemporaryBuffer) to CDA_High(fTemporaryBuffer) do
      EmitCharToken(CDA_GetItem(fTemporaryBuffer,i));
    ReconsumeInputChar;
    fState := iltsScriptData;
  end;

begin
case ConsumeNextInputChar of
  #$0009,
  #$000A,
  #$000C,
  #$0020:           If IsAppropriateEndTagToken(fCurrentToken) then
                      fState := iltsBeforeAttributeName
                    else
                      DefaultAction;
  UnicodeChar('/'): If IsAppropriateEndTagToken(fCurrentToken) then
                      fState := iltsSelfClosingStartTag
                    else
                      DefaultAction;
  UnicodeChar('>'): If IsAppropriateEndTagToken(fCurrentToken) then
                      begin
                        fState := iltsData;
                        EmitCurrentTagToken;
                      end
                    else DefaultAction;
  UnicodeChar('A')..
  UnicodeChar('Z'): begin
                      AppendToCurrentToken(iltfTagName,UnicodeChar(Ord(CurrentInputChar) + $20));
                      CDA_Add(fTemporaryBuffer,CurrentInputChar);
                    end;
  UnicodeChar('a')..
  UnicodeChar('z'): begin
                      AppendToCurrentToken(iltfTagName,CurrentInputChar);
                      CDA_Add(fTemporaryBuffer,CurrentInputChar);
                    end;
else
  DefaultAction;
end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_ScriptDataEscapeStart;
begin
case ConsumeNextInputChar of
  UnicodeChar('-'): begin
                      fState := iltsScriptDataEscapeStartDash;
                      EmitCharToken(UnicodeChar('-'));
                    end;
else
  ReconsumeInputChar;
  fState := iltsScriptData;
end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_ScriptDataEscapeStartDash;
begin
case ConsumeNextInputChar of
  UnicodeChar('-'): begin
                      fState := iltsScriptDataEscapedDashDash;
                      EmitCharToken(UnicodeChar('-'));
                    end;
else
  ReconsumeInputChar;
  fState := iltsScriptData;
end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_ScriptDataEscaped;
begin
If not EndOfFile then
  case ConsumeNextInputChar of
    UnicodeChar('-'): begin
                        fState := iltsScriptDataEscapedDash;
                        EmitCharToken(UnicodeChar('-'));
                      end;
    UnicodeChar('<'): fState := iltsScriptDataEscapedLessThanSign;
    UnicodeChar(#0):  If not ParseErrorInvalidChar(CurrentInputChar) then
                        EmitCharToken(#$FFFD);
  else
    EmitCharToken(CurrentInputChar);
  end
else
  begin
    If not ParseError('Unexpected end of file.') then
      EmitEndOfFileToken;
  end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_ScriptDataEscapedDash;
begin
If not EndOfFile then
  case ConsumeNextInputChar of
    UnicodeChar('-'): begin
                        fState := iltsScriptDataEscapedDashDash;
                        EmitCharToken(UnicodeChar('-'));
                      end;
    UnicodeChar('<'): fState := iltsScriptDataEscapedLessThanSign;
    UnicodeChar(#0):  If not ParseErrorInvalidChar(CurrentInputChar) then
                        begin
                          fState := iltsScriptDataEscaped;
                          EmitCharToken(#$FFFD);
                        end;
  else
    fState := iltsScriptDataEscaped;
    EmitCharToken(CurrentInputChar);
  end
else
  begin
    If not ParseError('Unexpected end of file.') then
      EmitEndOfFileToken;
  end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_ScriptDataEscapedDashDash;
begin
If not EndOfFile then
  case ConsumeNextInputChar of
    UnicodeChar('-'): EmitCharToken(UnicodeChar('-'));
    UnicodeChar('<'): fState := iltsScriptDataEscapedLessThanSign;
    UnicodeChar('>'): begin
                        fState := iltsScriptData;
                        EmitCharToken(UnicodeChar('>'));
                      end;
    UnicodeChar(#0):  If not ParseErrorInvalidChar(CurrentInputChar) then
                        begin
                          fState := iltsScriptDataEscaped;
                          EmitCharToken(#$FFFD);
                        end;
  else
    fState := iltsScriptDataEscaped;
    EmitCharToken(CurrentInputChar);
  end
else
  begin
    If not ParseError('Unexpected end of file.') then
      EmitEndOfFileToken;
  end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_ScriptDataEscapedLessThanSign;
begin
case ConsumeNextInputChar of
  UnicodeChar('/'): begin
                      CDA_Clear(fTemporaryBuffer);
                      fState := iltsScriptDataEscapedEndTagOpen;
                    end;
  UnicodeChar('a')..
  UnicodeChar('z'),
  UnicodeChar('A')..
  UnicodeChar('Z'): begin
                      CDA_Clear(fTemporaryBuffer);
                      EmitCharToken(UnicodeChar('<'));
                      ReconsumeInputChar;
                      fState := iltsScriptDataDoubleEscapeStart;
                    end;
else
  EmitCharToken(UnicodeChar('<'));
  ReconsumeInputChar;
  fState := iltsScriptDataEscaped;
end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_ScriptDataEscapedEndTagOpen;
begin
case ConsumeNextInputChar of
  UnicodeChar('a')..
  UnicodeChar('z'),
  UnicodeChar('A')..
  UnicodeChar('Z'): begin
                      CreateNewToken(ilttEndTag);
                      ReconsumeInputChar;
                      fState := iltsScriptDataEscapedEndTagName;
                    end;
else
  EmitCharToken(UnicodeChar('<'));
  EmitCharToken(UnicodeChar('/'));
  ReconsumeInputChar;
  fState := iltsScriptDataEscaped;
end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_ScriptDataEscapedEndTagName;

  procedure DefaultAction;
  var
    i:  Integer;
  begin
    EmitCharToken(UnicodeChar('<'));
    EmitCharToken(UnicodeChar('/'));
    For i := CDA_Low(fTemporaryBuffer) to CDA_High(fTemporaryBuffer) do
      EmitCharToken(CDA_GetItem(fTemporaryBuffer,i));
    ReconsumeInputChar;
    fState := iltsScriptDataEscaped;
  end;

begin
case ConsumeNextInputChar of
  #$0009,
  #$000A,
  #$000C,
  #$0020:           If IsAppropriateEndTagToken(fCurrentToken) then
                      fState := iltsBeforeAttributeName
                    else
                      DefaultAction;
  UnicodeChar('/'): If IsAppropriateEndTagToken(fCurrentToken) then
                      fState := iltsSelfClosingStartTag
                    else
                    DefaultAction;
  UnicodeChar('>'): If IsAppropriateEndTagToken(fCurrentToken) then
                      begin
                        fState := iltsData;
                        EmitCurrentTagToken;
                      end
                    else DefaultAction;
  UnicodeChar('A')..
  UnicodeChar('Z'): begin
                      AppendToCurrentToken(iltfTagName,UnicodeChar(Ord(CurrentInputChar) + $20));
                      CDA_Add(fTemporaryBuffer,CurrentInputChar);
                    end;
  UnicodeChar('a')..
  UnicodeChar('z'): begin
                      AppendToCurrentToken(iltfTagName,CurrentInputChar);
                      CDA_Add(fTemporaryBuffer,CurrentInputChar);
                    end;
else
  DefaultAction;
end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_ScriptDataDoubleEscapeStart;
begin
case ConsumeNextInputChar of
  #$0009,
  #$000A,
  #$000C,
  #$0020,
  UnicodeChar('/'),
  UnicodeChar('>'): begin
                      If TemporaryBufferEquals('script',False) then
                        fState := iltsScriptDataDoubleEscaped
                      else
                        fState := iltsScriptDataEscaped;
                      EmitCharToken(CurrentInputChar);
                    end;
  UnicodeChar('A')..
  UnicodeChar('Z'): begin
                      CDA_Add(fTemporaryBuffer,UnicodeChar(Ord(CurrentInputChar) + $20));
                      EmitCharToken(CurrentInputChar);
                    end;
  UnicodeChar('a')..
  UnicodeChar('z'): begin
                      CDA_Add(fTemporaryBuffer,CurrentInputChar);
                      EmitCharToken(CurrentInputChar);
                    end;
else
  ReconsumeInputChar;
  fState := iltsScriptDataEscaped;
end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_ScriptDataDoubleEscaped;
begin
If not EndOfFile then
  case ConsumeNextInputChar of
    UnicodeChar('-'): begin
                        fState := iltsScriptDataDoubleEscapedDash;
                        EmitCharToken(UnicodeChar('-'));
                      end;
    UnicodeChar('<'): begin
                        fState := iltsScriptDataDoubleEscapedLessThanSign;
                        EmitCharToken(UnicodeChar('<'));
                      end;
    UnicodeChar(#0):  If not ParseErrorInvalidChar(CurrentInputChar) then
                        EmitCharToken(#$FFFD);
  else
    EmitCharToken(CurrentInputChar);
  end
else
  begin
    If not ParseError('Unexpected end of file.') then
      EmitEndOfFileToken;
  end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_ScriptDataDoubleEscapedDash;
begin
If not EndOfFile then
  case ConsumeNextInputChar of
    UnicodeChar('-'): begin
                        fState := iltsScriptDataDoubleEscapedDashDash;
                        EmitCharToken(UnicodeChar('-'));
                      end;
    UnicodeChar('<'): begin
                        fState := iltsScriptDataDoubleEscapedLessThanSign;
                        EmitCharToken(UnicodeChar('<'));
                      end;
    UnicodeChar(#0):  If not ParseErrorInvalidChar(CurrentInputChar) then
                        begin
                          fState := iltsScriptDataDoubleEscaped;
                          EmitCharToken(#$FFFD);
                        end;
  else
    fState := iltsScriptDataDoubleEscaped;
    EmitCharToken(CurrentInputChar);
  end
else
  begin
    If not ParseError('Unexpected end of file.') then
      EmitEndOfFileToken;
  end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_ScriptDataDoubleEscapedDashDash;
begin
If not EndOfFile then
  case ConsumeNextInputChar of
    UnicodeChar('-'): EmitCharToken(UnicodeChar('-'));
    UnicodeChar('<'): begin
                        fState := iltsScriptDataDoubleEscapedLessThanSign;
                        EmitCharToken(UnicodeChar('<'));
                      end;
    UnicodeChar('>'): begin
                        fState := iltsScriptData;
                        EmitCharToken(UnicodeChar('>'));
                      end;
    UnicodeChar(#0):  If not ParseErrorInvalidChar(CurrentInputChar) then
                        begin
                          fState := iltsScriptDataDoubleEscaped;
                          EmitCharToken(#$FFFD);
                        end;
  else
    fState := iltsScriptDataDoubleEscaped;
    EmitCharToken(CurrentInputChar);
  end
else
  begin
    If not ParseError('Unexpected end of file.') then
      EmitEndOfFileToken;
  end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_ScriptDataDoubleEscapedLessThanSign;
begin
case ConsumeNextInputChar of
  UnicodeChar('/'): begin
                      CDA_Clear(fTemporaryBuffer);
                      fState := iltsScriptDataDoubleEscapeEnd;
                      EmitCharToken(UnicodeChar('/'));
                    end;
else
  ReconsumeInputChar;
  fState := iltsScriptDataDoubleEscaped;
end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_ScriptDataDoubleEscapeEnd;
begin
case ConsumeNextInputChar of
  #$0009,
  #$000A,
  #$000C,
  #$0020,
  UnicodeChar('/'),
  UnicodeChar('>'): begin
                      If TemporaryBufferEquals('script',False) then
                        fState := iltsScriptDataEscaped
                      else
                        fState := iltsScriptDataDoubleEscaped;
                      EmitCharToken(CurrentInputChar);
                    end;
  UnicodeChar('A')..
  UnicodeChar('Z'): begin
                      CDA_Add(fTemporaryBuffer,UnicodeChar(Ord(CurrentInputChar) + $20));
                      EmitCharToken(CurrentInputChar);
                    end;
  UnicodeChar('a')..
  UnicodeChar('z'): begin
                      CDA_Add(fTemporaryBuffer,CurrentInputChar);
                      EmitCharToken(CurrentInputChar);
                    end;
else
  ReconsumeInputChar;
  fState := iltsScriptDataDoubleEscaped;
end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_BeforeAttributeName;
begin
If not EndOfFile then
  case ConsumeNextInputChar of
    #$0009,
    #$000A,
    #$000C,
    #$0020:;  // ignore the character
    UnicodeChar('/'),
    UnicodeChar('>'): begin
                        ReconsumeInputChar;
                        fState := iltsAfterAttributeName;
                      end;
    UnicodeChar('='): If not ParseErrorInvalidChar(CurrentInputChar) then
                        begin
                          CreateNewAttribute(CurrentInputChar,'');
                          fState := iltsAttributeName;
                        end;
  else
    CreateNewAttribute('','');
    ReconsumeInputChar;
    fState := iltsAttributeName;
  end
else
  begin
    ReconsumeInputChar;
    fState := iltsAfterAttributeName;
  end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_AttributeName;
begin
If not EndOfFile then
  case ConsumeNextInputChar of
    #$0009,
    #$000A,
    #$000C,
    #$0020,
    UnicodeChar('/'),
    UnicodeChar('>'): begin
                        ReconsumeInputChar;
                        fState := iltsAfterAttributeName;
                      end;
    UnicodeChar('='): fState := iltsBeforeAttributeValue;
    UnicodeChar('A')..
    UnicodeChar('Z'): AppendCurrentAttributeName(UnicodeChar(Ord(CurrentInputChar) + $20));
    UnicodeChar(#0):  AppendCurrentAttributeName(#$FFFD);
    UnicodeChar('"'),
    UnicodeChar(''''),
    UnicodeChar('<'): If not ParseErrorInvalidChar(CurrentInputChar) then
                        AppendCurrentAttributeName(CurrentInputChar);
  else
    AppendCurrentAttributeName(CurrentInputChar);
  end
else
  begin
    ReconsumeInputChar;
    fState := iltsAfterAttributeName;
  end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_AfterAttributeName;
begin
If not EndOfFile then
  case ConsumeNextInputChar of
    #$0009,
    #$000A,
    #$000C,
    #$0020:;// ignore the character
    UnicodeChar('/'): fState := iltsSelfClosingStartTag;
    UnicodeChar('='): fState := iltsBeforeAttributeValue;
    UnicodeChar('>'): begin
                        fState := iltsData;
                        EmitCurrentTagToken;
                      end;
  else
    CreateNewAttribute('','');
    ReconsumeInputChar;
    fState := iltsAttributeName;
  end
else
  begin
    If not ParseError('Unexpected end of file.') then
      EmitEndOfFileToken;
  end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_BeforeAttributeValue;
begin
case ConsumeNextInputChar of
  #$0009,
  #$000A,
  #$000C,
  #$0020:;// ignore the character
  UnicodeChar('"'):   fState := iltsAttributeValue_DoubleQuoted;
  UnicodeChar(''''):  fState := iltsAttributeValue_SingleQuoted;
  UnicodeChar('>'):   If not ParseErrorInvalidChar(CurrentInputChar) then
                        begin
                          ReconsumeInputChar;
                          fState := iltsAttributeValue_Unquoted;
                        end;
else
  ReconsumeInputChar;
  fState := iltsAttributeValue_Unquoted;
end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_AttributeValue_DoubleQuoted;
begin
If not EndOfFile then
  case ConsumeNextInputChar of
    UnicodeChar('"'): fState := iltsAfterAttributeValue_Quoted;
    UnicodeChar('&'): begin
                        fReturnState := iltsAttributeValue_DoubleQuoted;
                        fState := iltsCharacterReference;
                      end;
    UnicodeChar(#0):  If not ParseErrorInvalidChar(CurrentInputchar) then
                        AppendCurrentAttributeValue(#$FFFD);
  else
    AppendCurrentAttributeValue(CurrentInputchar);
  end
else
  begin
    If not ParseError('Unexpected end of file.') then
      EmitEndOfFileToken;
  end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_AttributeValue_SingleQuoted;
begin
If not EndOfFile then
  case ConsumeNextInputChar of
    UnicodeChar(''''):  fState := iltsAfterAttributeValue_Quoted;
    UnicodeChar('&'):   begin
                          fReturnState := iltsAttributeValue_SingleQuoted;
                          fState := iltsCharacterReference;
                        end;
    UnicodeChar(#0):    If not ParseErrorInvalidChar(CurrentInputchar) then
                          AppendCurrentAttributeValue(#$FFFD);
  else
    AppendCurrentAttributeValue(CurrentInputchar);
  end
else
  begin
    If not ParseError('Unexpected end of file.') then
      EmitEndOfFileToken;
  end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_AttributeValue_Unquoted;
begin
If not EndOfFile then
  case ConsumeNextInputChar of
    #$0009,
    #$000A,
    #$000C,
    #$0020:           fState := iltsBeforeAttributeName;
    UnicodeChar('&'): begin
                        fReturnState := iltsAttributeValue_Unquoted;
                        fState := iltsCharacterReference;
                      end;
    UnicodeChar('>'): begin
                        fState := iltsData;
                        EmitCurrentTagToken;
                      end;
    UnicodeChar(#0):  If not ParseErrorInvalidChar(CurrentInputChar) then
                        AppendCurrentAttributeValue(#$FFFD);
    UnicodeChar('"'),
    UnicodeChar(''''),
    UnicodeChar('<'),
    UnicodeChar('='),
    UnicodeChar('`'): If not ParseErrorInvalidChar(CurrentInputChar) then
                        AppendCurrentAttributeValue(CurrentInputchar);
  else
    AppendCurrentAttributeValue(CurrentInputchar);
  end
else
  begin
    If not ParseError('Unexpected end of file.') then
      EmitEndOfFileToken;
  end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_AfterAttributeValue_Quoted;
begin
If not EndOfFile then
  case ConsumeNextInputChar of
    #$0009,
    #$000A,
    #$000C,
    #$0020:           fState := iltsBeforeAttributeName;
    UnicodeChar('/'): fState := iltsSelfClosingStartTag;
    UnicodeChar('>'): begin
                        fState := iltsData;
                        EmitCurrentTagToken;
                      end;
  else
    If not ParseError('Unexpected end of file.') then
      begin
        ReconsumeInputChar;
        fState := iltsBeforeAttributeName;
      end;
  end
else
  begin
    If not ParseError('Unexpected end of file.') then
      EmitEndOfFileToken;
  end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_SelfClosingStartTag;
begin
If not EndOfFile then
  case ConsumeNextInputChar of
    UnicodeChar('>'): begin
                        fcurrentToken.SelfClosing := True;
                        fState := iltsData;
                        EmitCurrentTagToken;
                      end;
  else
    If not ParseError('Unexpected end of file.') then
      begin
        ReconsumeInputChar;
        fState := iltsBeforeAttributeName;
      end;
  end
else
  begin
    If not ParseError('Unexpected end of file.') then
      EmitEndOfFileToken;
  end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_BogusComment;
begin
If not EndOfFile then
  case ConsumeNextInputChar of
    UnicodeChar('>'): begin
                        fState := iltsData;
                        EmitCurrentCommentToken;
                      end;
    UnicodeChar(#0):  AppendToCurrentToken(iltfData,#$FFFD);
  else
    AppendToCurrentToken(iltfData,CurrentInputChar);
  end
else
  begin
    EmitCurrentCommentToken;
    EmitEndOfFileToken;
  end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_MarkupDeclarationOpen;
begin
ConsumeNextInputChar;
If IsCurrentInputString(UnicodeString('--'),False) then
  begin
    ConsumeNextInputChar;
    CreateNewToken(ilttComment);
    fState := iltsCommentStart;
  end
else If IsCurrentInputString(UnicodeString('DOCTYPE'),False) then
  begin
    Inc(fPosition,6);
    fState := iltsDOCTYPE;
  end
else If IsCurrentInputString(UnicodeString('[CDATA['),False) then
  begin
  {$IFDEF DevelMsgs}
    {$message 'implement'}
  {$ENDIF}
    raise Exception.Create('not implemented');
  end
else
  begin
    If not ParseErrorInvalidChar(CurrentInputchar) then
      begin
        CreateNewToken(ilttComment);
        fState := iltsBogusComment;
        ReconsumeInputChar;
      end;
  end
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_CommentStart;
begin
case ConsumeNextInputChar of
  UnicodeChar('-'): fState := iltsCommentStartDash;
  UnicodeChar('>'): If not ParseErrorInvalidChar(CurrentInputchar) then
                      begin
                        fState := iltsData;
                        EmitCurrentCommentToken;
                      end;
else
  ReconsumeInputChar;
  fState := iltsComment;
end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_CommentStartDash;
begin
If not EndOfFile then
  case ConsumeNextInputChar of
    UnicodeChar('-'): fState := iltsCommentEnd;
    UnicodeChar('>'): If not ParseErrorInvalidChar(CurrentInputChar) then
                        begin
                          fState := iltsData;
                          EmitCurrentCommentToken;
                        end;
  else
    AppendToCurrentToken(iltfData,UnicodeChar('-'));
    ReconsumeInputChar;
    fState := iltsComment;
  end
else
  begin
    If not ParseError('Unexpected end of file.') then
      begin
        EmitCurrentCommentToken;
        EmitEndOfFileToken;
      end;
  end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_Comment;
begin
If not EndOfFile then
  case ConsumeNextInputChar of
    UnicodeChar('<'): begin
                        AppendToCurrentToken(iltfData,CurrentInputChar);
                        fState := iltsCommentLessThanSign;
                      end;
    UnicodeChar('-'): fState := iltsCommentEndDash;
    UnicodeChar(#0):  If not ParseErrorInvalidChar(CurrentInputchar) then
                        AppendToCurrentToken(iltfData,#$FFFD);
  else
    AppendToCurrentToken(iltfData,CurrentInputChar);
  end
else
  begin
    If not ParseError('Unexpected end of file.') then
      begin
        EmitCurrentCommentToken;
        EmitEndOfFileToken;
      end;
  end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_CommentLessThanSign;
begin
case ConsumeNextInputChar of
  UnicodeChar('!'): begin
                      AppendToCurrentToken(iltfData,CurrentInputChar);
                      fState := iltsCommentLessThanSignBang;
                    end;
  UnicodeChar('<'): AppendToCurrentToken(iltfData,CurrentInputChar);
else
  ReconsumeInputChar;
  fState := iltsComment;
end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_CommentLessThanSignBang;
begin
case ConsumeNextInputChar of
  UnicodeChar('-'): fState := iltsCommentLessThanSignBangDash;
else
  ReconsumeInputChar;
  fState := iltsComment;
end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_CommentLessThanSignBangDash;
begin
case ConsumeNextInputChar of
  UnicodeChar('-'): fState := iltsCommentLessThanSignBangDashDash;
else
  ReconsumeInputChar;
  fState := iltsCommentEndDash;
end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_CommentLessThanSignBangDashDash;
begin
If not EndOfFile then
  case ConsumeNextInputChar of
    UnicodeChar('>'): begin
                        ReconsumeInputChar;
                        fState := iltsCommentEnd;
                      end;
  else
    If not ParseErrorInvalidChar(CurrentInputchar) then
      begin
        ReconsumeInputChar;
        fState := iltsCommentEnd;
      end;
  end
else
  begin
    ReconsumeInputChar;
    fState := iltsCommentEnd;
  end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_CommentEndDash;
begin
If not EndOfFile then
  case ConsumeNextInputChar of
    UnicodeChar('-'): fState := iltsCommentEnd;
  else
    AppendToCurrentToken(iltfData,UnicodeChar('-'));
    ReconsumeInputChar;
    fState := iltsComment;
  end
else
  begin
    If not ParseError('Unexpected end of file.') then
      begin
        EmitCurrentCommentToken;
        EmitEndOfFileToken;
      end;
  end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_CommentEnd;
begin
If not EndOfFile then
  case ConsumeNextInputChar of
    UnicodeChar('>'): begin
                        fState := iltsData;
                        EmitCurrentCommentToken;
                      end;
    UnicodeChar('!'): fState := iltsCommentEndBang;
    UnicodeChar('-'): AppendToCurrentToken(iltfData,UnicodeChar('-'));
  else
    AppendToCurrentToken(iltfData,UnicodeChar('-'));
    AppendToCurrentToken(iltfData,UnicodeChar('-'));
    ReconsumeInputChar;
    fState := iltsComment;
  end
else
  begin
    If not ParseError('Unexpected end of file.') then
      begin
        EmitCurrentCommentToken;
        EmitEndOfFileToken;
      end;
  end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_CommentEndBang;
begin
If not EndOfFile then
  case ConsumeNextInputChar of
    UnicodeChar('-'): begin
                        AppendToCurrentToken(iltfData,UnicodeChar('-'));
                        AppendToCurrentToken(iltfData,UnicodeChar('-'));
                        AppendToCurrentToken(iltfData,UnicodeChar('!'));
                        fState := iltsCommentEndDash;
                      end;
    UnicodeChar('>'): If not ParseErrorInvalidChar(CurrentInputchar) then
                        begin
                          fState := iltsData;
                          EmitCurrentCommentToken;
                        end;
  else
    AppendToCurrentToken(iltfData,UnicodeChar('-'));
    AppendToCurrentToken(iltfData,UnicodeChar('-'));
    AppendToCurrentToken(iltfData,UnicodeChar('!'));
    ReconsumeInputChar;
    fState := iltsComment;
  end
else
  begin
    If not ParseError('Unexpected end of file.') then
      begin
        EmitCurrentCommentToken;
        EmitEndOfFileToken;
      end;
  end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_DOCTYPE;
begin
If not EndOfFile then
  case ConsumeNextInputChar of
    #$0009,
    #$000A,
    #$000C,
    #$0020: fState := iltsBeforeDOCTYPEName;
  else
    If not ParseErrorInvalidChar(CurrentInputchar) then
      begin
        ReconsumeInputChar;
        fState := iltsBeforeDOCTYPEName;
      end;
  end
else
  begin
    If not ParseError('Unexpected end of file.') then
      begin
        CreateNewToken(ilttDOCTYPE);
        fCurrentToken.ForceQuirks := True;
        EmitCurrentDOCTYPEToken;
        EmitEndOfFileToken;
      end;
  end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_BeforeDOCTYPEName;
begin
If not EndOfFile then
  case ConsumeNextInputChar of
    #$0009,
    #$000A,
    #$000C,
    #$0020:;  // ignore the character
    UnicodeChar('A')..
    UnicodeChar('Z'): begin
                        CreateNewToken(ilttDOCTYPE);
                        fCurrentToken.Name := UnicodeChar(Ord(CurrentInputChar) + $20);
                        fState := iltsDOCTYPEName;
                      end;
    UnicodeChar(#0):  If not ParseErrorInvalidChar(CurrentInputchar) then
                        begin
                          CreateNewToken(ilttDOCTYPE);
                          fCurrentToken.Name := #$FFFD;
                          fState := iltsDOCTYPEName;
                        end;
    UnicodeChar('>'): If not ParseErrorInvalidChar(CurrentInputchar) then
                        begin
                          CreateNewToken(ilttDOCTYPE);
                          fCurrentToken.ForceQuirks := True;
                          fState := iltsData;
                          EmitCurrentDOCTYPEToken;
                        end;
  else
    CreateNewToken(ilttDOCTYPE);
    fCurrentToken.Name := CurrentInputChar;
    fState := iltsDOCTYPEName;
  end
else
  begin
    If not ParseError('Unexpected end of file.') then
      begin
        CreateNewToken(ilttDOCTYPE);
        fCurrentToken.ForceQuirks := True;
        EmitCurrentDOCTYPEToken;
        EmitEndOfFileToken;
      end;
  end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_DOCTYPEName;
begin
If not EndOfFile then
  case ConsumeNextInputChar of
    #$0009,
    #$000A,
    #$000C,
    #$0020:           fState := iltsAfterDOCTYPEName;
    UnicodeChar('>'): begin
                        fState := iltsData;
                        EmitCurrentDOCTYPEToken;
                      end;
    UnicodeChar('A')..
    UnicodeChar('Z'): AppendToCurrentToken(iltfName,UnicodeChar(Ord(CurrentInputChar) + $20));
    UnicodeChar(#0):  If not ParseErrorInvalidChar(CurrentInputchar) then
                        AppendToCurrentToken(iltfName,#$FFFD);
  else
    AppendToCurrentToken(iltfName,CurrentInputChar);
  end
else
  begin
    If not ParseError('Unexpected end of file.') then
      begin
        fCurrentToken.ForceQuirks := True;
        EmitCurrentDOCTYPEToken;
        EmitEndOfFileToken;
      end;
  end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_AfterDOCTYPEName;
begin
If not EndOfFile then
  case ConsumeNextInputChar of
    #$0009,
    #$000A,
    #$000C,
    #$0020:;// ignore the character
    UnicodeChar('>'): begin
                        fState := iltsData;
                        EmitCurrentDOCTYPEToken;
                      end;
  else
    If IsCurrentInputString('PUBLIC',False) then
      begin
        Inc(fPosition,5);
        fState := iltsAfterDOCTYPEPublicKeyword;
      end
    else If IsCurrentInputString('SYSTEM',False) then
      begin
        Inc(fPosition,5);
        fState := iltsAfterDOCTYPESystemKeyword;
      end
    else
      begin
        If not ParseErrorInvalidChar(CurrentInputchar) then
          begin
            fCurrentToken.ForceQuirks := True;
            fState := iltsBogusDOCTYPE;
          end;
      end;
  end
else
  begin
    If not ParseError('Unexpected end of file.') then
      begin
        fCurrentToken.ForceQuirks := True;
        EmitCurrentDOCTYPEToken;
        EmitEndOfFileToken;
      end;
  end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_AfterDOCTYPEPublicKeyword;
begin
If not EndOfFile then
  case ConsumeNextInputChar of
    #$0009,
    #$000A,
    #$000C,
    #$0020:           fState := iltsBeforeDOCTYPEPublicIdentifier;
    UnicodeChar('"'): If not ParseErrorInvalidChar(CurrentInputchar) then
                        begin
                          fCurrentToken.PublicIdentifier := UnicodeString('');
                          Include(fCurrentToken.PresentFields,iltfPublicIdent);
                          fState := iltsDOCTYPEPublicIdentifier_DoubleQuoted;
                        end;
    UnicodeChar(''''):  If not ParseErrorInvalidChar(CurrentInputchar) then
                          begin
                            fCurrentToken.PublicIdentifier := UnicodeString('');
                            Include(fCurrentToken.PresentFields,iltfPublicIdent);
                            fState := iltsDOCTYPEPublicIdentifier_SingleQuoted;
                        end;
    UnicodeChar('>'):   If not ParseErrorInvalidChar(CurrentInputchar) then
                          begin
                            fCurrentToken.ForceQuirks := True;
                            fState := iltsData;
                            EmitCurrentDOCTYPEToken;
                          end;
  else
    If not ParseErrorInvalidChar(CurrentInputchar) then
      begin
        fCurrentToken.ForceQuirks := True;
        fState := iltsBogusDOCTYPE;
      end;
  end
else
  begin
    If not ParseError('Unexpected end of file.') then
      begin
        fCurrentToken.ForceQuirks := True;
        EmitCurrentDOCTYPEToken;
        EmitEndOfFileToken;
      end;
  end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_BeforeDOCTYPEPublicIdentifier;
begin
If not EndOfFile then
  case ConsumeNextInputChar of
    #$0009,
    #$000A,
    #$000C,
    #$0020:;// ignore the character
    UnicodeChar('"'):   If not ParseErrorInvalidChar(CurrentInputchar) then
                          begin
                            fCurrentToken.PublicIdentifier := '';
                            Include(fCurrentToken.PresentFields,iltfPublicIdent);
                            fState := iltsDOCTYPEPublicIdentifier_DoubleQuoted;
                          end;
    UnicodeChar(''''):  If not ParseErrorInvalidChar(CurrentInputchar) then
                          begin
                            fCurrentToken.PublicIdentifier := '';
                            Include(fCurrentToken.PresentFields,iltfPublicIdent);
                            fState := iltsDOCTYPEPublicIdentifier_SingleQuoted;
                          end;
    UnicodeChar('>'):   If not ParseErrorInvalidChar(CurrentInputchar) then
                          begin
                            fCurrentToken.ForceQuirks := True;
                            fState := iltsData;
                            EmitCurrentDOCTYPEToken;
                          end;
  else
    If not ParseErrorInvalidChar(CurrentInputchar) then
      begin
        fCurrentToken.ForceQuirks := True;
        fState := iltsBogusDOCTYPE;
      end;
  end
else
  begin
    If not ParseError('Unexpected end of file.') then
      begin
        fCurrentToken.ForceQuirks := True;
        EmitCurrentDOCTYPEToken;
        EmitEndOfFileToken;
      end;
  end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_DOCTYPEPublicIdentifier_DoubleQuoted;
begin
If not EndOfFile then
  case ConsumeNextInputChar of
    UnicodeChar('"'): fState := iltsAfterDOCTYPEPublicIdentifier;
    UnicodeChar(#0):  If not ParseErrorInvalidChar(CurrentInputchar) then
                        AppendToCurrentToken(iltfPublicIdent,#$FFFD);
    UnicodeChar('>'): begin
                        fCurrentToken.ForceQuirks := True;
                        fState := iltsData;
                        EmitCurrentDOCTYPEToken;
                      end;
  else
    AppendToCurrentToken(iltfPublicIdent,CurrentInputchar);
  end
else
  begin
    If not ParseError('Unexpected end of file.') then
      begin
        fCurrentToken.ForceQuirks := True;
        EmitCurrentDOCTYPEToken;
        EmitEndOfFileToken;
      end;
  end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_DOCTYPEPublicIdentifier_SingleQuoted;
begin
If not EndOfFile then
  case ConsumeNextInputChar of
    UnicodeChar(''''):  fState := iltsAfterDOCTYPEPublicIdentifier;
    UnicodeChar(#0):    If not ParseErrorInvalidChar(CurrentInputchar) then
                          AppendToCurrentToken(iltfPublicIdent,#$FFFD);
    UnicodeChar('>'):   begin
                          fCurrentToken.ForceQuirks := True;
                          fState := iltsData;
                          EmitCurrentDOCTYPEToken;
                        end;
  else
    AppendToCurrentToken(iltfPublicIdent,CurrentInputchar);
  end
else
  begin
    If not ParseError('Unexpected end of file.') then
      begin
        fCurrentToken.ForceQuirks := True;
        EmitCurrentDOCTYPEToken;
        EmitEndOfFileToken;
      end;
  end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_AfterDOCTYPEPublicIdentifier;
begin
If not EndOfFile then
  case ConsumeNextInputChar of
    #$0009,
    #$000A,
    #$000C,
    #$0020:             fState := iltsBetweenDOCTYPEPublicAndSystemIdentifiers;
    UnicodeChar('>'):   If not ParseErrorInvalidChar(CurrentInputchar) then
                          begin
                            fState := iltsData;
                            EmitCurrentDOCTYPEToken;
                          end;
    UnicodeChar('"'):   If not ParseErrorInvalidChar(CurrentInputchar) then
                          begin
                            fCurrentToken.SystemIdentifier := '';
                            Include(fCurrentToken.PresentFields,iltfSystemIdent);
                            fState := iltsDOCTYPESystemIdentifier_DoubleQuoted;
                          end;
    UnicodeChar(''''):  If not ParseErrorInvalidChar(CurrentInputchar) then
                          begin
                            fCurrentToken.SystemIdentifier := '';
                            Include(fCurrentToken.PresentFields,iltfSystemIdent);
                            fState := iltsDOCTYPESystemIdentifier_SingleQuoted;
                          end;
  else
    If not ParseErrorInvalidChar(CurrentInputchar) then
      begin
        fCurrentToken.ForceQuirks := True;
        fState := iltsBogusDOCTYPE;
      end;
  end
else
  begin
    If not ParseError('Unexpected end of file.') then
      begin
        fCurrentToken.ForceQuirks := True;
        EmitCurrentDOCTYPEToken;
        EmitEndOfFileToken;
      end;
  end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_BetweenDOCTYPEPublicAndSystemIdentifiers;
begin
If not EndOfFile then
  case ConsumeNextInputChar of
    #$0009,
    #$000A,
    #$000C,
    #$0020:;// ignore the character
    UnicodeChar('>'):   begin
                          fState := iltsData;
                          EmitCurrentDOCTYPEToken;
                        end;
    UnicodeChar('"'):   begin
                          fCurrentToken.SystemIdentifier := '';
                          Include(fCurrentToken.PresentFields,iltfSystemIdent);
                          fState := iltsDOCTYPESystemIdentifier_DoubleQuoted;
                        end;
    UnicodeChar(''''):  begin
                          fCurrentToken.SystemIdentifier := '';
                          Include(fCurrentToken.PresentFields,iltfSystemIdent);
                          fState := iltsDOCTYPESystemIdentifier_SingleQuoted;
                        end;
  else
    If not ParseErrorInvalidChar(CurrentInputchar) then
      begin
        fCurrentToken.ForceQuirks := True;
        fState := iltsBogusDOCTYPE;
      end;
  end
else
  begin
    If not ParseError('Unexpected end of file.') then
      begin
        fCurrentToken.ForceQuirks := True;
        EmitCurrentDOCTYPEToken;
        EmitEndOfFileToken;
      end;
  end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_AfterDOCTYPESystemKeyword;
begin
If not EndOfFile then
  case ConsumeNextInputChar of
    #$0009,
    #$000A,
    #$000C,
    #$0020: fState := iltsBeforeDOCTYPESystemIdentifier;
    UnicodeChar('"'):   If not ParseErrorInvalidChar(CurrentInputchar) then
                          begin
                            fCurrentToken.SystemIdentifier := '';
                            Include(fCurrentToken.PresentFields,iltfSystemIdent);
                            fState := iltsDOCTYPESystemIdentifier_DoubleQuoted;
                        end;
    UnicodeChar(''''):  If not ParseErrorInvalidChar(CurrentInputchar) then
                          begin
                            fCurrentToken.SystemIdentifier := '';
                            Include(fCurrentToken.PresentFields,iltfSystemIdent);
                            fState := iltsDOCTYPESystemIdentifier_SingleQuoted;
                        end;
    UnicodeChar('>'):   If not ParseErrorInvalidChar(CurrentInputchar) then
                          begin
                            fCurrentToken.ForceQuirks := True;
                            fState := iltsData;
                            EmitCurrentDOCTYPEToken;
                          end;
  else
    If not ParseErrorInvalidChar(CurrentInputchar) then
      begin
        fCurrentToken.ForceQuirks := True;
        fState := iltsBogusDOCTYPE;
      end;
  end
else
  begin
    If not ParseError('Unexpected end of file.') then
      begin
        fCurrentToken.ForceQuirks := True;
        EmitCurrentDOCTYPEToken;
        EmitEndOfFileToken;
      end;
  end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_BeforeDOCTYPESystemIdentifier;
begin
If not EndOfFile then
  case ConsumeNextInputChar of
    #$0009,
    #$000A,
    #$000C,
    #$0020:;// ignore the character
    UnicodeChar('"'):   begin
                          fCurrentToken.SystemIdentifier := '';
                          Include(fCurrentToken.PresentFields,iltfSystemIdent);
                          fState := iltsDOCTYPESystemIdentifier_DoubleQuoted;
                        end;
    UnicodeChar(''''):  begin
                          fCurrentToken.SystemIdentifier := '';
                          Include(fCurrentToken.PresentFields,iltfSystemIdent);
                          fState := iltsDOCTYPESystemIdentifier_SingleQuoted;
                        end;
    UnicodeChar('>'):   If not ParseErrorInvalidChar(CurrentInputchar) then
                          begin
                            fCurrentToken.ForceQuirks := True;
                            fState := iltsData;
                            EmitCurrentDOCTYPEToken;
                          end;
  else
    If not ParseErrorInvalidChar(CurrentInputchar) then
      begin
        fCurrentToken.ForceQuirks := True;
        fState := iltsBogusDOCTYPE;
      end;
  end
else
  begin
    If not ParseError('Unexpected end of file.') then
      begin
        fCurrentToken.ForceQuirks := True;
        EmitCurrentDOCTYPEToken;
        EmitEndOfFileToken;
      end;
  end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_DOCTYPESystemIdentifier_DoubleQuoted;
begin
If not EndOfFile then
  case ConsumeNextInputChar of
    UnicodeChar('"'): fState := iltsAfterDOCTYPESystemIdentifier;
    UnicodeChar(#0):  If not ParseErrorInvalidChar(CurrentInputchar) then
                        AppendToCurrentToken(iltfSystemIdent,#$FFFD);
    UnicodeChar('>'): If not ParseErrorInvalidChar(CurrentInputchar) then
                        begin
                          fCurrentToken.ForceQuirks := True;
                          fState := iltsData;
                          EmitCurrentDOCTYPEToken;
                        end;
  else
    AppendToCurrentToken(iltfSystemIdent,CurrentInputChar);
  end
else
  begin
    If not ParseError('Unexpected end of file.') then
      begin
        fCurrentToken.ForceQuirks := True;
        EmitCurrentDOCTYPEToken;
        EmitEndOfFileToken;
      end;
  end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_DOCTYPESystemIdentifier_SingleQuoted;
begin
If not EndOfFile then
  case ConsumeNextInputChar of
    UnicodeChar(''''):  fState := iltsAfterDOCTYPESystemIdentifier;
    UnicodeChar(#0):    If not ParseErrorInvalidChar(CurrentInputchar) then
                          AppendToCurrentToken(iltfSystemIdent,#$FFFD);
    UnicodeChar('>'):   If not ParseErrorInvalidChar(CurrentInputchar) then
                          begin
                            fCurrentToken.ForceQuirks := True;
                            fState := iltsData;
                            EmitCurrentDOCTYPEToken;
                          end;
  else
    AppendToCurrentToken(iltfSystemIdent,CurrentInputChar);
  end
else
  begin
    If not ParseError('Unexpected end of file.') then
      begin
        fCurrentToken.ForceQuirks := True;
        EmitCurrentDOCTYPEToken;
        EmitEndOfFileToken;
      end;
  end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_AfterDOCTYPESystemIdentifier;
begin
If not EndOfFile then
  case ConsumeNextInputChar of
    #$0009,
    #$000A,
    #$000C,
    #$0020:;          // ignore the character
    UnicodeChar('>'): begin
                        fState := iltsData;
                        EmitCurrentDOCTYPEToken;
                      end;
  else
    If not ParseErrorInvalidChar(CurrentInputchar) then
      fState := iltsBogusDOCTYPE;
  end
else
  begin
    If not ParseError('Unexpected end of file.') then
      begin
        fCurrentToken.ForceQuirks := True;
        EmitCurrentDOCTYPEToken;
        EmitEndOfFileToken;
      end;
  end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_BogusDOCTYPE;
begin
If not EndOfFile then
  case ConsumeNextInputChar of
    UnicodeChar('>'): begin
                        fState := iltsData;
                        EmitCurrentDOCTYPEToken;
                      end;
  else
    // ignore the character
  end
else
  begin
    EmitCurrentDOCTYPEToken;
    EmitEndOfFileToken;
  end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_CDATASection;
begin
If not EndOfFile then
  case ConsumeNextInputChar of
    UnicodeChar(']'): fState := iltsCDATASectionBracket;
  else
    EmitCharToken(CurrentInputChar);
  end
else
  begin
    If not ParseError('Unexpected end of file.') then
      EmitEndOfFileToken;
  end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_CDATASectionBracket;
begin
case ConsumeNextInputChar of
  UnicodeChar(']'): fState := iltsCDATASectionEnd;
else
  EmitCharToken(UnicodeChar(']'));
  ReconsumeInputChar;
  fState := iltsCDATASection;
end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_CDATASectionEnd;
begin
case ConsumeNextInputChar of
  UnicodeChar(']'): EmitCharToken(UnicodeChar(']'));
  UnicodeChar('>'): fState := iltsData;
else
  EmitCharToken(UnicodeChar(']'));
  EmitCharToken(UnicodeChar(']'));
  ReconsumeInputChar;
  fState := iltsCDATASection;
end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_CharacterReference_ResolveNamedReference;
var
  Index: Integer;

  Function IndexOfNamedRef(const Ref: UnicodeString): Integer;
  var
    i:  Integer;
  begin
    // find index of named refrence stored in a temporary buffer
    // if not found, returns -1
    Result := -1;
    For i := Low(IL_TOKENIZER_CHAR_NAMEDREF) to High(IL_TOKENIZER_CHAR_NAMEDREF) do
      If IL_UnicodeSameString(IL_TOKENIZER_CHAR_NAMEDREF[i].Name,Ref,True) then
        begin
          If NextInputChar = UnicodeChar(';') then
            begin
              Result := IndexOfNamedRef(Ref + UnicodeChar(';'));
              If Result >= 0 then
                CDA_Add(fTemporaryBuffer,ConsumeNextInputChar)
              else
                Result := i;
            end
          else Result := i;
          Break{For i};
        end;
  end;

  Function CheckTempBuffForCharRef: Boolean;
  var
    i:  Integer;
  begin
    Result := False;
    If CDA_Count(fTemporaryBuffer) > 2 then
      If (CDA_First(fTemporaryBuffer) = '&') and (CDA_Last(fTemporaryBuffer) = ';') then
        begin
          Result := True;
          For i := Succ(CDA_Low(fTemporaryBuffer)) to Pred(CDA_High(fTemporaryBuffer)) do
            If not IL_UTF16CharInSet(CDA_GetItem(fTemporaryBuffer,i),['0'..'9','a'..'z','A'..'Z']) then
              begin
                Result := False;
                Break{For i};
              end;
        end
  end;

begin
Index := -1;
while not EndOfFile and not fParserPause do
  begin
    CDA_Add(fTemporaryBuffer,ConsumeNextInputChar);
    // search the table only when there is really chance to find anything
    If CDA_Count(fTemporaryBuffer) <= IL_TOKENIZER_CHAR_NAMEDREF_MAXLEN then
      begin
        Index := IndexOfNamedRef(TemporaryBufferAsStr);
        If Index >= 0 then
          Break{while...};
      end;
  end;
If Index >= 0 then
  begin
    // reference was successfuly resolved
    If not((fReturnState in [iltsAttributeValue_DoubleQuoted,iltsAttributeValue_SingleQuoted,iltsAttributeValue_Unquoted]) and
      (CDA_Last(fTemporaryBuffer) <> UnicodeChar(';')) and IL_UTF16CharInSet(NextInputChar,['=','0'..'9','a'..'Z','A'..'Z'])) then
      begin
        // not in attribute value
        If CDA_Last(fTemporaryBuffer) <> UnicodeChar(';') then
          ParseError('Invalid character reference "%s".',[UnicodeToStr(TemporaryBufferAsStr)]);
        // put resolved chars to temp. buffer
        CDA_Clear(fTemporaryBuffer);
        If IL_TOKENIZER_CHAR_NAMEDREF[Index].CodePointA >= $10000 then
          begin
            CDA_Add(fTemporaryBuffer,IL_UTF16HighSurrogate(IL_TOKENIZER_CHAR_NAMEDREF[Index].CodePointA));
            CDA_Add(fTemporaryBuffer,IL_UTF16LowSurrogate(IL_TOKENIZER_CHAR_NAMEDREF[Index].CodePointA));
          end
        else CDA_Add(fTemporaryBuffer,UnicodeChar(IL_TOKENIZER_CHAR_NAMEDREF[Index].CodePointA));
        If IL_TOKENIZER_CHAR_NAMEDREF[Index].CodePointA > 0 then
          begin
            If IL_TOKENIZER_CHAR_NAMEDREF[Index].CodePointB >= $10000 then
              begin
                CDA_Add(fTemporaryBuffer,IL_UTF16HighSurrogate(IL_TOKENIZER_CHAR_NAMEDREF[Index].CodePointB));
                CDA_Add(fTemporaryBuffer,IL_UTF16LowSurrogate(IL_TOKENIZER_CHAR_NAMEDREF[Index].CodePointB));
              end
            else CDA_Add(fTemporaryBuffer,UnicodeChar(IL_TOKENIZER_CHAR_NAMEDREF[Index].CodePointB));
          end;
        fState := iltsCharacterReferenceEnd;
      end
    else fState := iltsCharacterReferenceEnd;  // in attribute value
  end
else
  begin
    // reference could not be resolved, temp. buffer by now contains rest of the file
    If CheckTempBuffForCharRef then
      begin
        If CDA_Count(fTemporaryBuffer) <= IL_TOKENIZER_CHAR_NAMEDREF_MAXLEN then
          ParseError('Invalid character reference "%s".',[UnicodeToStr(TemporaryBufferAsStr)])
        else
          ParseError('Invalid character reference.')
      end;
    fState := iltsCharacterReferenceEnd;
  end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_CharacterReference;
begin
CDA_Clear(fTemporaryBuffer);
CDA_Add(fTemporaryBuffer,UnicodeChar('&'));
If not EndOfFile then
  case ConsumeNextInputChar of
    #$0009,
    #$000A,
    #$000C,
    #$0020,
    UnicodeChar('<'),
    UnicodeChar('&'): begin
                        ReconsumeInputChar;
                        fState := iltsCharacterReferenceEnd;
                      end;
    UnicodeChar('#'): begin
                        CDA_Add(fTemporaryBuffer,CurrentInputChar);
                        fState := iltsNumericCharacterReference;
                      end;
  else
    ReconsumeInputChar;
    State_CharacterReference_ResolveNamedReference;
  end
else
  begin
    ReconsumeInputChar;
    fState := iltsCharacterReferenceEnd;
  end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_NumericCharacterReference;
begin
fCharRefCode := 0;
case ConsumeNextInputChar of
  UnicodeChar('x'),
  UnicodeChar('X'): begin
                      CDA_Add(fTemporaryBuffer,CurrentInputChar);
                      fState := iltsHexadecimalCharacterReferenceStart;
                    end;
else
  ReconsumeInputChar;
  fState := iltsDecimalCharacterReferenceStart;
end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_HexadecimalCharacterReferenceStart;
begin
case ConsumeNextInputChar of
  UnicodeChar('0')..
  UnicodeChar('9'),
  UnicodeChar('a')..
  UnicodeChar('f'),
  UnicodeChar('A')..
  UnicodeChar('F'): begin
                      ReconsumeInputChar;
                      fState := iltsHexadecimalCharacterReference;
                    end;
else
  If not ParseErrorInvalidChar(CurrentInputchar) then
    begin
      ReconsumeInputChar;
      fState := iltsCharacterReferenceEnd;
    end;
end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_DecimalCharacterReferenceStart;
begin
case ConsumeNextInputChar of
  UnicodeChar('0')..
  UnicodeChar('9'): begin
                      ReconsumeInputChar;
                      fState := iltsDecimalCharacterReference;
                    end;
else
  If not ParseErrorInvalidChar(CurrentInputchar) then
    begin
      ReconsumeInputChar;
      fState := iltsCharacterReferenceEnd;
    end;
end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_HexadecimalCharacterReference;
begin
case ConsumeNextInputChar of
  UnicodeChar('0')..
  UnicodeChar('9'): begin
                      fCharRefCode := fCharRefCode * 16;
                      fCharRefCode := fCharRefCode + UInt32(Ord(CurrentInputchar) - $30);
                    end;
  UnicodeChar('A')..
  UnicodeChar('F'): begin
                      fCharRefCode := fCharRefCode * 16;
                      fCharRefCode := fCharRefCode + UInt32(Ord(CurrentInputchar) - $37);
                    end;
  UnicodeChar('a')..
  UnicodeChar('f'): begin
                      fCharRefCode := fCharRefCode * 16;
                      fCharRefCode := fCharRefCode + UInt32(Ord(CurrentInputchar) - $57);
                    end;
  UnicodeChar(';'): fState := iltsNumericCharacterReferenceEnd;
else
  If not ParseErrorInvalidChar(CurrentInputchar) then
    begin
      ReconsumeInputChar;
      fState := iltsNumericCharacterReferenceEnd;
    end;
end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_DecimalCharacterReference;
begin
case ConsumeNextInputChar of
  UnicodeChar('0')..
  UnicodeChar('9'): begin
                      fCharRefCode := fCharRefCode * 10;
                      fCharRefCode := fCharRefCode + UInt32(Ord(CurrentInputchar) - $30);
                    end;
  UnicodeChar(';'): fState := iltsNumericCharacterReferenceEnd;
else
  If not ParseErrorInvalidChar(CurrentInputchar) then
    begin
      ReconsumeInputChar;
      fState := iltsNumericCharacterReferenceEnd;
    end;
end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_NumericCharacterReferenceEnd;
var
  i:  Integer;

  Function CharIsForbidden(CharRefCode: UInt32): Boolean;
  var
    ii: Integer;
  begin
    Result := False;
    For ii := Low(IL_TOKENIZER_CHAR_FORBIDDEN) to High(IL_TOKENIZER_CHAR_FORBIDDEN) do
      If CharRefCode = IL_TOKENIZER_CHAR_FORBIDDEN[ii] then
        begin
          Result := True;
          Break{For ii};
        end;
  end;

begin
// replacement table
For i := Low(IL_TOKENIZER_CHAR_REPLACE) to High(IL_TOKENIZER_CHAR_REPLACE) do
  If fCharRefCode = Ord(IL_TOKENIZER_CHAR_REPLACE[i].OldChar) then
    begin
      If not ParseErrorInvalidChar(UnicodeChar(fCharRefCode)) then
        fCharRefCode := Ord(IL_TOKENIZER_CHAR_REPLACE[i].Replacement);
      Break{For i};
    end;
// check ranges
If ((fCharRefCode >= $D800) and (fCharRefCode <= $DFFF)) or (fCharRefCode > $10FFFF) then
  If not ParseErrorInvalidChar(UnicodeChar(fCharRefCode)) then
    fCharRefCode := $FFFD;
// other checks
If ((fCharRefCode >= $0001) and (fCharRefCode <= $0008)) or ((fCharRefCode >= $000D) and (fCharRefCode <= $001F)) or
   ((fCharRefCode >= $007F) and (fCharRefCode <= $009F)) or ((fCharRefCode >= $FDD0) and (fCharRefCode <= $FDEF)) or
   CharIsForbidden(fCharRefCode) then
  ParseErrorInvalidChar(UnicodeChar(fCharRefCode));
// output char
CDA_Clear(fTemporaryBuffer); 
If fCharRefCode >= $10000 then
  begin
    CDA_Add(fTemporaryBuffer,IL_UTF16HighSurrogate(fCharRefCode));
    CDA_Add(fTemporaryBuffer,IL_UTF16LowSurrogate(fCharRefCode));
  end
else CDA_Add(fTemporaryBuffer,UnicodeChar(fCharRefCode));
fState := iltsCharacterReferenceEnd;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_CharacterReferenceEnd;
var
  i:  Integer;
begin
ConsumeNextInputChar;
case fReturnState of
  iltsAttributeValue_DoubleQuoted,
  iltsAttributeValue_SingleQuoted,
  iltsAttributeValue_Unquoted:
    For i := CDA_Low(fTemporaryBuffer) to CDA_High(fTemporaryBuffer) do
      AppendCurrentAttributeValue(CDA_GetItem(fTemporaryBuffer,i));
else
  For i := CDA_Low(fTemporaryBuffer) to CDA_High(fTemporaryBuffer) do
    EmitCharToken(CDA_GetItem(fTemporaryBuffer,i));
end;
ReconsumeInputChar;
fState := fReturnState;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.State_Select;
begin
case fState of
  iltsData:                                     State_Data;
  iltsRCDATA:                                   State_RCDATA;
  iltsRAWTEXT:                                  State_RAWTEXT;
  iltsScriptData:                               State_ScriptData;
  iltsPLAINTEXT:                                State_PLAINTEXT;
  iltsTagOpen:                                  State_TagOpen;
  iltsEndTagOpen:                               State_EndTagOpen;
  iltsTagName:                                  State_TagName;
  iltsRCDATALessThanSign:                       State_RCDATALessThanSign;
  iltsRCDATAEndTagOpen:                         State_RCDATAEndTagOpen;
  iltsRCDATAEndTagName:                         State_RCDATAEndTagName;
  iltsRAWTEXTLessThanSign:                      State_RAWTEXTLessThanSign;
  iltsRAWTEXTEndTagOpen:                        State_RAWTEXTEndTagOpen;
  iltsRAWTEXTEndTagName:                        State_RAWTEXTEndTagName;
  iltsScriptDataLessThanSign:                   State_ScriptDataLessThanSign;
  iltsScriptDataEndTagOpen:                     State_ScriptDataEndTagOpen;
  iltsScriptDataEndTagName:                     State_ScriptDataEndTagName;
  iltsScriptDataEscapeStart:                    State_ScriptDataEscapeStart;
  iltsScriptDataEscapeStartDash:                State_ScriptDataEscapeStartDash;
  iltsScriptDataEscaped:                        State_ScriptDataEscaped;
  iltsScriptDataEscapedDash:                    State_ScriptDataEscapedDash;
  iltsScriptDataEscapedDashDash:                State_ScriptDataEscapedDashDash;
  iltsScriptDataEscapedLessThanSign:            State_ScriptDataEscapedLessThanSign;
  iltsScriptDataEscapedEndTagOpen:              State_ScriptDataEscapedEndTagOpen;
  iltsScriptDataEscapedEndTagName:              State_ScriptDataEscapedEndTagName;
  iltsScriptDataDoubleEscapeStart:              State_ScriptDataDoubleEscapeStart;
  iltsScriptDataDoubleEscaped:                  State_ScriptDataDoubleEscaped;
  iltsScriptDataDoubleEscapedDash:              State_ScriptDataDoubleEscapedDash;
  iltsScriptDataDoubleEscapedDashDash:          State_ScriptDataDoubleEscapedDashDash;
  iltsScriptDataDoubleEscapedLessThanSign:      State_ScriptDataDoubleEscapedLessThanSign;
  iltsScriptDataDoubleEscapeEnd:                State_ScriptDataDoubleEscapeEnd;
  iltsBeforeAttributeName:                      State_BeforeAttributeName;
  iltsAttributeName:                            State_AttributeName;
  iltsAfterAttributeName:                       State_AfterAttributeName;
  iltsBeforeAttributeValue:                     State_BeforeAttributeValue;
  iltsAttributeValue_DoubleQuoted:              State_AttributeValue_DoubleQuoted;
  iltsAttributeValue_SingleQuoted:              State_AttributeValue_SingleQuoted;
  iltsAttributeValue_Unquoted:                  State_AttributeValue_Unquoted;
  iltsAfterAttributeValue_Quoted:               State_AfterAttributeValue_Quoted;
  iltsSelfClosingStartTag:                      State_SelfClosingStartTag;
  iltsBogusComment:                             State_BogusComment;
  iltsMarkupDeclarationOpen:                    State_MarkupDeclarationOpen;
  iltsCommentStart:                             State_CommentStart;
  iltsCommentStartDash:                         State_CommentStartDash;
  iltsComment:                                  State_Comment;
  iltsCommentLessThanSign:                      State_CommentLessThanSign;
  iltsCommentLessThanSignBang:                  State_CommentLessThanSignBang;
  iltsCommentLessThanSignBangDash:              State_CommentLessThanSignBangDash;
  iltsCommentLessThanSignBangDashDash:          State_CommentLessThanSignBangDashDash;
  iltsCommentEndDash:                           State_CommentEndDash;
  iltsCommentEnd:                               State_CommentEnd;
  iltsCommentEndBang:                           State_CommentEndBang;
  iltsDOCTYPE:                                  State_DOCTYPE;
  iltsBeforeDOCTYPEName:                        State_BeforeDOCTYPEName;
  iltsDOCTYPEName:                              State_DOCTYPEName;
  iltsAfterDOCTYPEName:                         State_AfterDOCTYPEName;
  iltsAfterDOCTYPEPublicKeyword:                State_AfterDOCTYPEPublicKeyword;
  iltsBeforeDOCTYPEPublicIdentifier:            State_BeforeDOCTYPEPublicIdentifier;
  iltsDOCTYPEPublicIdentifier_DoubleQuoted:     State_DOCTYPEPublicIdentifier_DoubleQuoted;
  iltsDOCTYPEPublicIdentifier_SingleQuoted:     State_DOCTYPEPublicIdentifier_SingleQuoted;
  iltsAfterDOCTYPEPublicIdentifier:             State_AfterDOCTYPEPublicIdentifier;
  iltsBetweenDOCTYPEPublicAndSystemIdentifiers: State_BetweenDOCTYPEPublicAndSystemIdentifiers;
  iltsAfterDOCTYPESystemKeyword:                State_AfterDOCTYPESystemKeyword;
  iltsBeforeDOCTYPESystemIdentifier:            State_BeforeDOCTYPESystemIdentifier;
  iltsDOCTYPESystemIdentifier_DoubleQuoted:     State_DOCTYPESystemIdentifier_DoubleQuoted;
  iltsDOCTYPESystemIdentifier_SingleQuoted:     State_DOCTYPESystemIdentifier_SingleQuoted;
  iltsAfterDOCTYPESystemIdentifier:             State_AfterDOCTYPESystemIdentifier;
  iltsBogusDOCTYPE:                             State_BogusDOCTYPE;
  iltsCDATASection:                             State_CDATASection;
  iltsCDATASectionBracket:                      State_CDATASectionBracket;
  iltsCDATASectionEnd:                          State_CDATASectionEnd;
  iltsCharacterReference:                       State_CharacterReference;
  iltsNumericCharacterReference:                State_NumericCharacterReference;
  iltsHexadecimalCharacterReferenceStart:       State_HexadecimalCharacterReferenceStart;
  iltsDecimalCharacterReferenceStart:           State_DecimalCharacterReferenceStart;
  iltsHexadecimalCharacterReference:            State_HexadecimalCharacterReference;
  iltsDecimalCharacterReference:                State_DecimalCharacterReference;
  iltsNumericCharacterReferenceEnd:             State_NumericCharacterReferenceEnd;
  iltsCharacterReferenceEnd:                    State_CharacterReferenceEnd;
else
  raise Exception.CreateFmt('TILHTMLTokenizer.State_Select: Invalid tokenizer state (%d).',[Ord(fState)]);
end;
end;

//------------------------------------------------------------------------------

Function TILHTMLTokenizer.NextInputChar: UnicodeChar;
begin
If (fPosition >= 1) and (fPosition <= Length(fData)) then
  Result := fData[fPosition]
else
  Result := #0;
end;

//------------------------------------------------------------------------------

Function TILHTMLTokenizer.CurrentInputChar: UnicodeChar;
begin
If (fPosition > 1) and (fPosition <= Length(fData)) then
  Result := fData[fPosition - 1]
else
  Result := #0;
end;

//------------------------------------------------------------------------------

Function TILHTMLTokenizer.ConsumeNextInputChar: UnicodeChar;
begin
Result := NextInputChar;
Inc(fPosition);
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.ReconsumeInputChar;
begin
Dec(fPosition);
end;

//------------------------------------------------------------------------------

Function TILHTMLTokenizer.EndOfFile: Boolean;
begin
Result := fPosition > Length(fData);
end;

//==============================================================================

constructor TILHTMLTokenizer.Create;
begin
inherited Create;
fRaiseParseErrs := False;
end;

//------------------------------------------------------------------------------

destructor TILHTMLTokenizer.Destroy;
begin
inherited;
end;

//------------------------------------------------------------------------------

procedure TILHTMLTokenizer.Initialize(const Data: UnicodeString);
begin
// internals
fData := Data;
fPosition := 1;
// state machine
fParserPause := False;
fState := iltsData;
fReturnState := iltsData;
CDA_Init(fTemporaryBuffer);
fCharRefCode := 0;
// helpers
CDA_Init(fLastStartTag);
CDA_Init(fCurrentToken.Attributes);
CreateNewToken(ilttEndOfFile);  // this will initialize current token
end;

//------------------------------------------------------------------------------

Function TILHTMLTokenizer.Run: Boolean;
begin
while not EndOfFile and not fParserPause do
  State_Select;
Result := not fParserPause and (fPosition > Length(fData));
end;

end.
