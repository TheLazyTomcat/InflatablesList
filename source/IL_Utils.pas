unit IL_Utils;

{$INCLUDE '.\IL_defs.inc'}

interface

uses
  Windows, SysUtils,
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
//- others ---------------------------------------------------------------------

Function IL_CharInSet(C: Char; CharSet: TSysCharSet): Boolean;

Function IL_IndexWrap(Index,Low,High: Integer): Integer;

Function IL_NegateValue(Value: Integer; Negate: Boolean): Integer; 

Function IL_BoolToChar(Value: Boolean; FalseChar,TrueChar: Char): Char;

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

//------------------------------------------------------------------------------

procedure IL_ShellOpen(WindowHandle: HWND; const Path: String);
begin
If Length(Path) > 0 then
  ShellExecute(WindowHandle,'open',PChar(Path),nil,nil,SW_SHOWNORMAL);
end;

end.
