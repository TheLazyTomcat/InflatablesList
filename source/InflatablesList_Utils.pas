unit InflatablesList_Utils;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  Windows, SysUtils, Graphics,
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
Function IL_CompareGUID(const A,B: TGUID): Integer;

//==============================================================================
//- pictures -------------------------------------------------------------------

procedure IL_PicShrink(Large,Small: TBitmap);

//==============================================================================
//- others ---------------------------------------------------------------------

Function IL_CharInSet(C: Char; CharSet: TSysCharSet): Boolean;

Function IL_IndexWrap(Index,Low,High: Integer): Integer;

Function IL_NegateValue(Value: Integer; Negate: Boolean): Integer; 

Function IL_BoolToStr(Value: Boolean; FalseStr, TrueStr: String): String;

procedure IL_ShellOpen(WindowHandle: HWND; const Path: String);

implementation

uses
  ShellAPI;

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

//------------------------------------------------------------------------------

Function IL_CompareGUID(const A,B: TGUID): Integer;
begin
Result := AnsiCompareText(GUIDToString(A),GUIDToString(B));
If Result <> 0 then
  begin
    If Result > 0 then
      Result := -1
    else
      Result := +1;
  end;
end;

//==============================================================================
//- pictures -------------------------------------------------------------------

procedure IL_PicShrink(Large,Small: TBitmap);
const
  Factor = 2;
type
  TRGBTriple = packed record
    rgbtRed, rgbtGreen, rgbtBlue: Byte;
  end;
  TRGBTripleArray = array[0..$FFFF] of TRGBTriple;
  PRGBTripleArray = ^TRGBTripleArray;
var
  Y,X:    Integer;
  Lines:  array[0..Pred(Factor)] of PRGBTripleArray;
  LineR:  PRGBTripleArray;
  R,G,B:  UInt32;
  i,j:    Integer;
begin
For Y := 0 to Pred(Large.Height div Factor) do
  begin
    For i := 0 to Pred(Factor) do
      Lines[i] := Large.ScanLine[(Y * Factor) + i];
    For X := 0 to Pred(Large.Width div Factor) do
      begin
        R := 0;
        G := 0;
        B := 0;
        For i := 0 to Pred(Factor) do
          For j := 0 to Pred(Factor) do
            begin
              Inc(R,Sqr(Integer(Lines[i]^[(X * Factor) + j].rgbtRed)));
              Inc(G,Sqr(Integer(Lines[i]^[(X * Factor) + j].rgbtGreen)));
              Inc(B,Sqr(Integer(Lines[i]^[(X * Factor) + j].rgbtBlue)));
            end;
        LineR := Small.ScanLine[Y];
        LineR^[X].rgbtRed   := Trunc(Sqrt(R / Sqr(Factor)));
        LineR^[X].rgbtGreen := Trunc(Sqrt(G / Sqr(Factor)));
        LineR^[X].rgbtBlue  := Trunc(Sqrt(B / Sqr(Factor)));
      end;
  end;
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

Function IL_BoolToStr(Value: Boolean; FalseStr, TrueStr: String): String;
begin
If Value then
  Result := TrueStr
else
  Result := FalseStr;
end;

//------------------------------------------------------------------------------

procedure IL_ShellOpen(WindowHandle: HWND; const Path: String);
begin
If Length(Path) > 0 then
  ShellExecute(WindowHandle,'open',PChar(Path),nil,nil,SW_SHOWNORMAL);
end;

end.
