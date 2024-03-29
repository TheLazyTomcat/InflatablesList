unit InflatablesList_HTML_Preprocessor;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  Classes,
  AuxTypes, AuxClasses;

type
  TILHTMLInvalidCharBehaviour = (ilicbRemove,ilicbReplace,ilicbLeave);

  TILHTMLPreprocessor = class(TObject)
  private
    fInput:           UnicodeString;
    fOutput:          UnicodeString;
    fInputPos:        Integer;
    fOutputPos:       Integer;
    fLastProgress:    Double;
    fIvalidChars:     TILHTMLInvalidCharBehaviour;
    fOnProgress:      TFloatEvent;
    fRaiseParseErrs:  Boolean;
  protected
    Function ParseError(const Msg: String): Boolean; overload; virtual;
    Function ParseError(const Msg: String; Args: array of const): Boolean; overload; virtual;
    Function ParseErrorInvalidChar(Char: UnicodeChar): Boolean; virtual;
    procedure DoProgress; virtual;
    Function CharCurrent: UnicodeChar; virtual;
    Function CharPrev: UnicodeChar; virtual;
    Function CharNext: UnicodeChar; virtual;
    procedure EmitChar(Char: UnicodeChar); virtual;
    procedure ProcessInvalidChar; virtual;
    procedure ProcessChar; virtual;
  public
    constructor Create;
    Function Process(Stream: TStream; IsUFT8: Boolean): UnicodeString; virtual;
    property InvalidCharacterBahaviour: TILHTMLInvalidCharBehaviour read fIvalidChars write fIvalidChars;
    property OnProgress: TFloatEvent read fOnProgress write fOnProgress;
    property RaiseParseErrors: Boolean read fRaiseParseErrs write fRaiseParseErrs;
  end;

implementation

uses
  StrRect,
  InflatablesList_Utils,
  InflatablesList_HTML_Utils;

Function TILHTMLPreprocessor.ParseError(const Msg: String): Boolean;
begin
Result := fRaiseParseErrs;
If fRaiseParseErrs then
  raise EILHTMLParseError.Create(Msg);
end;

//------------------------------------------------------------------------------

Function TILHTMLPreprocessor.ParseError(const Msg: String; Args: array of const): Boolean;
begin
Result := ParseError(IL_Format(Msg,Args));
end;

//------------------------------------------------------------------------------

Function TILHTMLPreprocessor.ParseErrorInvalidChar(Char: UnicodeChar): Boolean;
begin
Result := ParseError('Invalid character (#%.4x).',[Ord(Char)]);
end;

//------------------------------------------------------------------------------

procedure TILHTMLPreprocessor.DoProgress;
var
  CurrentProgress:  Double;
begin
If Length(fInput) <> 0 then
  CurrentProgress := fInputPos / Length(fInput)
else
  CurrentProgress := 0.0;
If CurrentProgress >= (fLastProgress + 0.0001) then
  begin
    fLastProgress := CurrentProgress;
    If Assigned(fOnProgress) then
      fOnProgress(Self,CurrentProgress);
  end;
end;

//------------------------------------------------------------------------------

Function TILHTMLPreprocessor.CharCurrent: UnicodeChar;
begin
If (fInputPos >= 1) and (fInputPos <= Length(fInput)) then
  Result := fInput[fInputPos]
else
  Result := UnicodeChar(#0);
end;

//------------------------------------------------------------------------------

Function TILHTMLPreprocessor.CharPrev: UnicodeChar;
begin
If (Pred(fInputPos) >= 1) and (Pred(fInputPos) <= Length(fInput)) then
  Result := fInput[Pred(fInputPos)]
else
  Result := UnicodeChar(#0);
end;

//------------------------------------------------------------------------------

Function TILHTMLPreprocessor.CharNext: UnicodeChar;
begin
If (Succ(fInputPos) >= 1) and (Succ(fInputPos) <= Length(fInput)) then
  Result := fInput[Succ(fInputPos)]
else
  Result := UnicodeChar(#0);
end;

//------------------------------------------------------------------------------

procedure TILHTMLPreprocessor.EmitChar(Char: UnicodeChar);
begin
Inc(fOutputPos);
// allocate new space if required
If Length(fOutput) < fOutputPos then
  begin
    If Length(fOutput) < 1024 then
      SetLength(fOutput,1024)
    else
      SetLength(fOutput,Length(fOutput) * 2);
  end;
fOutput[fOutputPos] := Char;
end;

//------------------------------------------------------------------------------

procedure TILHTMLPreprocessor.ProcessInvalidChar;
begin
case fIvalidChars of
  ilicbRemove:  ; // do nothing, char is skipped
  ilicbReplace: EmitChar(#$FFFD);
else
 {ilicbLeave}
  EmitChar(CharCurrent);
end;
end;

//------------------------------------------------------------------------------

procedure TILHTMLPreprocessor.ProcessChar;
var
  TempChar: UnicodeChar;

  Function IsValidCodepoint(High,Low: UnicodeChar): Boolean;
  var
    CodePoint:  UInt32;
  begin
    // check if the codepoint can be in HTML
    CodePoint := IL_UTF16CodePoint(High,Low);
    Result := not(
      ((CodePoint >= $0001) and (CodePoint <= $0008)) or
      ((CodePoint >= $000E) and (CodePoint <= $001F)) or
      ((CodePoint >= $007F) and (CodePoint <= $009F)) or
      ((CodePoint >= $FDD0) and (CodePoint <= $FDEF)) or
      ((CodePoint or not UInt32($000F0000)) = $FFFE) or
      ((CodePoint or not UInt32($000F0000)) = $FFFF) or       
      (CodePoint = $000B) or (CodePoint = $10FFFE) or (CodePoint = $10FFFF ));
  end;

begin
TempChar := CharCurrent;
// detect isolated surrogates
If (TempChar >= #$D800) and (TempChar <= #$DBFF) then
  begin
    // high surrogate, must be followed by a low surrogate
    If (CharNext >= #$DC00) and (CharNext <= #$DFFF) then
      begin
        // followed by a low surrogate
        If not IsValidCodepoint(TempChar,CharNext) then
          begin
            // the codepoint is invalid
            If not ParseErrorInvalidChar(TempChar) then
              begin
                ProcessInvalidChar;
                Inc(fInputPos); // skip the next char
              end;
          end
        else EmitChar(TempChar);
      end
    else
      begin
        // NOT followed by a low surrogate, the next char will be processed in next round
        If not ParseErrorInvalidChar(TempChar) then
          ProcessInvalidChar;
      end;
  end
else If ((CharNext >= #$DC00) and (CharNext <= #$DFFF)) then
  begin
    // low surrogate, must be preceded by a high surrogate
    If not ((CharPrev >= #$D800) and (CharPrev <= #$DBFF)) then
      begin
        If not ParseErrorInvalidChar(TempChar) then
          ProcessInvalidChar;
      end
    else EmitChar(TempChar);
  end
else If TempChar = #$000D{CR} then
  begin
    // preprocess line breaks
    EmitChar(#$000A{LF});
    If CharNext = #$000A{LF} then
      Inc(fInputPos); // skip next char when it is LF
  end
else EmitChar(TempChar);
Inc(fInputPos);
end;

//==============================================================================

constructor TILHTMLPreprocessor.Create;
begin
inherited Create;
fIvalidChars := ilicbRemove;
fRaiseParseErrs := False;
end;

//------------------------------------------------------------------------------

Function TILHTMLPreprocessor.Process(Stream: TStream; IsUFT8: Boolean): UnicodeString;
var
  UTF8Temp: UTF8String;
  AnsiTemp: AnsiString;
begin
fInput := '';
fOutput := '';
fInputPos := 1;
fOutputPos := 0;
fLastProgress := 0.0;
// processing
If Stream.Size > 0 then
  begin
    // decode stream to unicode string
    If IsUFT8 then
      begin
        SetLength(UTF8Temp,(Stream.Size - Stream.Position) div SizeOf(UTF8Char));
        Stream.Read(PUTF8Char(UTF8Temp)^,Length(UTF8Temp) * SizeOf(UTF8Char));
        fInput := UTF8ToString(UTF8Temp);
      end
    else
      begin
        SetLength(AnsiTemp,(Stream.Size - Stream.Position) div SizeOf(AnsiChar));
        Stream.Read(PAnsiChar(AnsiTemp)^,Length(AnsiTemp) * SizeOf(AnsiChar));
        fInput := UnicodeString(AnsiTemp);
      end;
    DoProgress;
    // preallocate
    SetLength(fOutput,Length(fInput));
    while fInputPos <= Length(fInput) do
      begin
        ProcessChar;
        DoProgress;
      end;
    SetLength(fOutput,fOutputPos);
  end;
Result := fOutput;
end;

end.
