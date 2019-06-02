unit InflatablesList_HTML_Utils;

{$INCLUDE '.\IL_defs.inc'}

interface

uses
  SysUtils,
  AuxTypes;

Function IL_UTF16LowSurrogate(CodePoint: UInt32): UnicodeChar;
Function IL_UTF16HighSurrogate(CodePoint: UInt32): UnicodeChar;
Function IL_UTF16CodePoint(HighSurrogate,LowSurrogate: UnicodeChar): UInt32;

Function IL_UTF16CharInSet(UTF16Char: UnicodeChar; CharSet: TSysCharSet): Boolean;

Function IL_UnicodeCompareString(const A,B: UnicodeString; CaseSensitive: Boolean): Integer;
Function IL_UnicodeSameString(const A,B: UnicodeString; CaseSensitive: Boolean): Boolean;

implementation

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

end.
