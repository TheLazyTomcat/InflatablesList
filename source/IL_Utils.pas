unit IL_Utils;

{$INCLUDE '.\IL_defs.inc'}

interface

uses
  SysUtils,
  AuxTypes;

//==============================================================================
//- file path manipulation -----------------------------------------------------

Function IL_PathRelative(const Path: String): String;
Function IL_PathAbsolute(const Path: String): String;

//==============================================================================
//- comparison functions, used in sorting --------------------------------------

Function IL_CompareBool(A,B: Boolean): Integer;
Function IL_CompareInt32(A,B: Int32): Integer;
Function IL_CompareUInt32(A,B: UInt32): Integer;
Function IL_CompareInt64(A,B: Int64): Integer;
Function IL_CompareFloat(A,B: Double): Integer;
Function IL_CompareDateTime(A,B: TDateTime): Integer;
Function IL_CompareText(const A,B: String): Integer;

//==============================================================================
//- UTF-16 manipulation --------------------------------------------------------

{$message 'move to HTML_Utils'}
Function IL_UTF16LowSurrogate(CodePoint: UInt32): UnicodeChar;
Function IL_UTF16HighSurrogate(CodePoint: UInt32): UnicodeChar;
Function IL_UTF16CodePoint(HighSurrogate,LowSurrogate: UnicodeChar): UInt32;

Function IL_UTF16CharInSet(UTF16Char: UnicodeChar; CharSet: TSysCharSet): Boolean;

Function IL_UnicodeCompareString(const A,B: UnicodeString; CaseSensitive: Boolean): Integer;
Function IL_UnicodeSameString(const A,B: UnicodeString; CaseSensitive: Boolean): Boolean;

//==============================================================================
//- others ---------------------------------------------------------------------

Function IL_CharInSet(C: Char; CharSet: TSysCharSet): Boolean;

Function IL_IndexWrap(Index,Low,High: Integer): Integer;

Function IL_NegateValue(Value: Integer; Negate: Boolean): Integer; 

Function IL_BoolToChar(Value: Boolean; FalseChar,TrueChar: Char): Char;

implementation

//==============================================================================
//- file path manipulation -----------------------------------------------------

Function IL_PathRelative(const Path: String): String;
begin
Result := ExtractRelativePath(ExtractFilePath(ParamStr(0)),Path);
If Length(Result) <> Length(Path) then
  Result := '.\' + Result;
end;

//------------------------------------------------------------------------------

Function IL_PathAbsolute(const Path: String): String;
begin
If Length(Path) > 0 then
  begin
    If Path[1] = '.' then
      Result := ExpandFileName(ExtractFilePath(ParamStr(0)) + Path)
    else
      Result := Path;
  end
else Result := '';
end;

//==============================================================================
//- comparison functions, used in sorting --------------------------------------

Function IL_CompareBool(A,B: Boolean): Integer;
begin
If A <> B then
  begin
    If A = True then
      Result := -1
    else
      Result := +1;
  end
else Result := 0;
end;
 
//------------------------------------------------------------------------------

Function IL_CompareInt32(A,B: Int32): Integer;
begin
If A <> B then
  begin
    If A > B then
      Result := -1
    else
      Result := +1;
  end
else Result := 0;
end;
 
//------------------------------------------------------------------------------

Function IL_CompareUInt32(A,B: UInt32): Integer;
begin
If A <> B then
  begin
    If A > B then
      Result := -1
    else
      Result := +1;
  end
else Result := 0;
end;

//------------------------------------------------------------------------------

Function IL_CompareInt64(A,B: Int64): Integer;
begin
If A <> B then
  begin
    If A > B then
      Result := -1
    else
      Result := +1;
  end
else Result := 0;
end;
 
//------------------------------------------------------------------------------

Function IL_CompareFloat(A,B: Double): Integer;
begin
If A <> B then
  begin
    If A > B then
      Result := -1
    else
      Result := +1;
  end
else Result := 0;
end;

//------------------------------------------------------------------------------

Function IL_CompareDateTime(A,B: TDateTime): Integer;
begin
If A <> B then
  begin
    If A > B then
      Result := -1
    else
      Result := +1;
  end
else Result := 0;
end;

//------------------------------------------------------------------------------

Function IL_CompareText(const A,B: String): Integer;
begin
Result := AnsiCompareText(A,B);
If Result <> 0 then
  begin
    If Result > 0 then
      Result := -1
    else
      Result := +1;
  end;
end;

//==============================================================================
//- UTF-16 manipulation --------------------------------------------------------

Function IL_UTF16HighSurrogate(CodePoint: UInt32): UnicodeChar;
begin
If CodePoint >= $10000 then
  Result := UnicodeChar(((CodePoint - $10000) shr 10) + $D800)
else
  Result := UnicodeChar(CodePoint);
end;

//------------------------------------------------------------------------------

Function IL_UTF16LowSurrogate(CodePoint: UInt32): UnicodeChar;
begin
If CodePoint >= $10000 then
  Result := UnicodeChar(((CodePoint - $10000) and $3FF) + $DC00)
else
  Result := UnicodeChar(CodePoint);
end;

//------------------------------------------------------------------------------

Function IL_UTF16CodePoint(HighSurrogate,LowSurrogate: UnicodeChar): UInt32;
begin
Result := UInt32(((Ord(HighSurrogate) - $D800) shl 10) + (Ord(LowSurrogate) - $DC00) + $10000);
end;

//------------------------------------------------------------------------------

Function IL_UTF16CharInSet(UTF16Char: UnicodeChar; CharSet: TSysCharSet): Boolean;
begin
If Ord(UTF16Char) <= $FF then
  Result := AnsiChar(UTF16Char) in CharSet
else
  Result := False
end;

//------------------------------------------------------------------------------

Function IL_UnicodeCompareString(const A,B: UnicodeString; CaseSensitive: Boolean): Integer;
begin
{$IFDEF Unicode}
If CaseSensitive then
  Result := AnsiCompareStr(A,B)
else
  Result := AnsiCompareText(A,B);
{$ELSE}
If CaseSensitive then
  Result := WideCompareStr(A,B)
else
  Result := WideCompareText(A,B);
{$ENDIF}
end;

//------------------------------------------------------------------------------

Function IL_UnicodeSameString(const A,B: UnicodeString; CaseSensitive: Boolean): Boolean;
begin
{$IFDEF Unicode}
If CaseSensitive then
  Result := AnsiSameStr(A,B)
else
  Result := AnsiSameText(A,B);
{$ELSE}
If CaseSensitive then
  Result := WideSameStr(A,B)
else
  Result := WideSameText(A,B);
{$ENDIF}
end;

//==============================================================================
//- others ---------------------------------------------------------------------

Function IL_CharInSet(C: Char; CharSet: TSysCharSet): Boolean;
begin
{$IFDEF Unicode}
If Ord(C) > 255 then
  Result := False
else
{$ENDIF}
  Result := AnsiChar(C) in CharSet;
end;

//------------------------------------------------------------------------------

Function IL_IndexWrap(Index,Low,High: Integer): Integer;
begin
If (Index < Low) then
  Result := High
else If Index > High then
  Result := Low
else
  Result := Index;
end;

//------------------------------------------------------------------------------

Function IL_NegateValue(Value: Integer; Negate: Boolean): Integer;
begin
If Negate then
  Result := -Value
else
  Result := Value;
end;

//------------------------------------------------------------------------------

Function IL_BoolToChar(Value: Boolean; FalseChar,TrueChar: Char): Char;
begin
If Value then
  Result := TrueChar
else
  Result := FalseChar;
end;

end.
