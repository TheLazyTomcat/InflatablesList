unit InflatablesList_Utils;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  Windows, SysUtils, Graphics, Classes,
  AuxTypes, AuxClasses,
  InflatablesList_Types;

//==============================================================================
//- string functions redirection -----------------------------------------------

Function IL_CompareText(const A,B: String): Integer;
Function IL_CompareStr(const A,B: String): Integer;

Function IL_SameText(const A,B: String): Boolean;
Function IL_SameStr(const A,B: String): Boolean;

Function IL_ContainsText(const Text,SubText: String): Boolean;
Function IL_ContainsStr(const Text,SubText: String): Boolean;

Function IL_Format(const FormatStr: String; Args: array of const; const FormatSettings: TFormatSettings): String; overload;
Function IL_Format(const FormatStr: String; Args: array of const): String; overload;

Function IL_StringOfChar(Ch: Char; Count: Integer): String;

Function IL_MultiLineText(const Strs: array of String): String;

Function IL_UpperCase(const Str: String): String;
Function IL_LowerCase(const Str: String): String;

Function IL_FormatDateTime(const FormatStr: String; DateTIme: TDateTIme): String;

Function IL_ReplaceText(const Text, FromText, ToText: String): String;
Function IL_ReplaceStr(const Text, FromText, ToText: String): String;

//==============================================================================
//- comparison functions used in sorting ---------------------------------------

Function IL_SortCompareBool(A,B: Boolean): Integer;
Function IL_SortCompareInt32(A,B: Int32): Integer;
Function IL_SortCompareUInt32(A,B: UInt32): Integer;
Function IL_SortCompareInt64(A,B: Int64): Integer;
Function IL_SortCompareFloat(A,B: Double): Integer;
Function IL_SortCompareDateTime(A,B: TDateTime): Integer;
Function IL_SortCompareText(const A,B: String): Integer;
Function IL_SortCompareStr(const A,B: String): Integer;
Function IL_SortCompareGUID(const A,B: TGUID): Integer;

//==============================================================================
//- files/directories ----------------------------------------------------------

Function IL_PathRelative(const Base,Path: String; PrependDot: Boolean = True): String;
Function IL_PathAbsolute(const Base,Path: String): String;

Function IL_IncludeTrailingPathDelimiter(const Path: String): String;
Function IL_ExcludeTrailingPathDelimiter(const Path: String): String;

Function IL_ExtractFileDir(const FileName: String): String;
Function IL_ExtractFilePath(const FileName: String): String;
Function IL_ExtractFileNameNoExt(const FileName: String): String;
Function IL_ExtractFileExt(const FileName: String): String;

Function IL_ChangeFileExt(const FileName,NewExt: String): String;

Function IL_ExpandFileName(const FileName: String): String;

Function IL_MinimizeName(const FileName: String; Canvas: TCanvas; MaxLen: Integer): String;

procedure IL_CreateDirectory(const Directory: String);
procedure IL_CreateDirectoryPath(const Path: String);
procedure IL_CreateDirectoryPathForFile(const FileName: String);

Function IL_FileExists(const FileName: String): Boolean;
Function IL_DeleteFile(const FileName: String): Boolean;
Function IL_DeleteDir(const Dir: String): Boolean;

procedure IL_CopyFile(const Source,Destination: String);
procedure IL_MoveFile(const Source,Destination: String);

// non-recursive enumeration of files within give folder
procedure IL_EnumFiles(const BaseFolder: String; List: TStrings);

//==============================================================================
//- event handler assignment checking ------------------------------------------

Function IL_CheckHandler(Handler: TNotifyEvent): TNotifyEvent; overload;

Function IL_CheckHandler(Handler: TILObjectL1Event): TILObjectL1Event; overload;
Function IL_CheckHandler(Handler: TILObjectL2Event): TILObjectL2Event; overload;

Function IL_CheckHandler(Handler: TILIndexedObjectL1Event): TILIndexedObjectL1Event; overload;
Function IL_CheckHandler(Handler: TILIndexedObjectL2Event): TILIndexedObjectL2Event; overload;

Function IL_CheckHandler(Handler: TILPasswordRequest): TILPasswordRequest; overload;

//==============================================================================
//- pictures manipulation ------------------------------------------------------

procedure IL_PicShrink(Large,Small: TBitmap; Factor: Integer);

//==============================================================================
//- others ---------------------------------------------------------------------

Function IL_CharInSet(C: Char; CharSet: TSysCharSet): Boolean;

Function IL_IndexWrap(Index,Low,High: Integer): Integer;

Function IL_NegateValue(Value: Integer; Negate: Boolean): Integer; 

Function IL_BoolToStr(Value: Boolean; FalseStr, TrueStr: String): String;
Function IL_BoolToNum(Value: Boolean): Integer;

procedure IL_ShellOpen(WindowHandle: HWND; const Path: String; const Params: String = ''; const Directory: String = '');

Function IL_SelectDirectory(const Title: String; var Directory: String): Boolean;

Function IL_GetTempPath: String;

//==============================================================================
//- roatated text drawing ------------------------------------------------------

Function IL_LogFontAssign(Src: TFont): TLogFont; // just auxiliary for following

Function IL_GetRotatedTextRect(Canvas: TCanvas; const Text: String; Angle: Integer; out Rect: TRect): Boolean;
Function IL_GetRotatedTextSize(Canvas: TCanvas; const Text: String; Angle: Integer; out Size: TSize): Boolean;

Function IL_DrawRotatedText(Canvas: TCanvas; const Text: String; Angle: Integer; X,Y: Integer): Boolean;

implementation

uses
  StrUtils, ShellAPI, Math, {$WARN UNIT_PLATFORM OFF}FileCtrl,{$WARN UNIT_PLATFORM ON}
  StrRect;

//==============================================================================
//- string functions redirection -----------------------------------------------

Function IL_CompareText(const A,B: String): Integer;
begin
Result := AnsiCompareText(A,B);
end;

//------------------------------------------------------------------------------

Function IL_CompareStr(const A,B: String): Integer;
begin
Result := AnsiCompareStr(A,B);
end;

//------------------------------------------------------------------------------

Function IL_SameText(const A,B: String): Boolean;
begin
Result := AnsiSameText(A,B);
end;

//------------------------------------------------------------------------------

Function IL_SameStr(const A,B: String): Boolean;
begin
Result := AnsiSameStr(A,B);
end;

//------------------------------------------------------------------------------

Function IL_ContainsText(const Text,SubText: String): Boolean;
begin
Result := AnsiContainsText(Text,SubText);
end;

//------------------------------------------------------------------------------

Function IL_ContainsStr(const Text,SubText: String): Boolean;
begin
Result := AnsiContainsStr(Text,SubText);
end;

//------------------------------------------------------------------------------

var
  ILLocalFormatSettings:  TFormatSettings;  // never make this public

Function IL_Format(const FormatStr: String; Args: array of const; const FormatSettings: TFormatSettings): String;
begin
Result := Format(FormatStr,Args,FormatSettings);
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

Function IL_Format(const FormatStr: String; Args: array of const): String;
begin
Result := IL_Format(FormatStr,Args,ILLocalFormatSettings);
end;

//------------------------------------------------------------------------------

Function IL_StringOfChar(Ch: Char; Count: Integer): String;
begin
Result := StringOfChar(Ch,Count);
end;
 
//------------------------------------------------------------------------------

Function IL_MultiLineText(const Strs: array of String): String;
var
  i:  Integer;
begin
with TStringList.Create do
try
  For i := Low(Strs) to High(Strs) do
    Add(Strs[i]);
  Result := Text;
finally
  Free;
end;
end;

//------------------------------------------------------------------------------

Function IL_UpperCase(const Str: String): String;
begin
Result := AnsiUpperCase(Str);
end;

//------------------------------------------------------------------------------

Function IL_LowerCase(const Str: String): String;
begin
Result := AnsiLowerCase(Str);
end;

//------------------------------------------------------------------------------

Function IL_FormatDateTime(const FormatStr: String; DateTIme: TDateTIme): String;
begin
Result := FormatDateTIme(FormatStr,DateTime,ILLocalFormatSettings);
end;

//------------------------------------------------------------------------------

Function IL_ReplaceText(const Text, FromText, ToText: String): String;
begin
Result := AnsiReplaceText(Text,FromText,ToText);
end;

//------------------------------------------------------------------------------

Function IL_ReplaceStr(const Text, FromText, ToText: String): String;
begin
Result := AnsiReplaceStr(Text,FromText,ToText);
end;


//==============================================================================
//- comparison functions, used in sorting --------------------------------------

Function IL_SortCompareBool(A,B: Boolean): Integer;
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

Function IL_SortCompareInt32(A,B: Int32): Integer;
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

Function IL_SortCompareUInt32(A,B: UInt32): Integer;
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

Function IL_SortCompareInt64(A,B: Int64): Integer;
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

Function IL_SortCompareFloat(A,B: Double): Integer;
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

Function IL_SortCompareDateTime(A,B: TDateTime): Integer;
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

Function IL_SortCompareText(const A,B: String): Integer;
begin
Result := IL_CompareText(A,B);
If Result <> 0 then
  begin
    If Result > 0 then
      Result := -1
    else
      Result := +1;
  end;
end;

//------------------------------------------------------------------------------

Function IL_SortCompareStr(const A,B: String): Integer;
begin
Result := IL_CompareStr(A,B);
If Result <> 0 then
  begin
    If Result > 0 then
      Result := -1
    else
      Result := +1;
  end;
end;

//------------------------------------------------------------------------------

Function IL_SortCompareGUID(const A,B: TGUID): Integer;
begin
Result := IL_CompareText(GUIDToString(A),GUIDToString(B));
If Result <> 0 then
  begin
    If Result > 0 then
      Result := -1
    else
      Result := +1;
  end;
end;


//==============================================================================
//- files/directories ----------------------------------------------------------

Function IL_PathRelative(const Base,Path: String; PrependDot: Boolean = True): String;
begin
// path can be a filename, so watch for trailing delimiter (must be present when it is a directory)
Result := RTLToStr(ExtractRelativePath(IncludeTrailingPathDelimiter(StrToRTL(Base)),StrToRTL(Path)));
{
  if the paths are the same, it is assumed the path cannot be relativized,
  for example when it is on a different disk
}
If PrependDot and not IL_SameText(Result,Path) then
  Result := '.' + PathDelim + Result;
end;

//------------------------------------------------------------------------------

Function IL_PathAbsolute(const Base,Path: String): String;
begin
If Length(Path) > 0 then
  Result := RTLToStr(ExpandFileName(IncludeTrailingPathDelimiter(StrToRTL(Base)) + StrToRTL(Path)))
else
  Result := '';
end;

//------------------------------------------------------------------------------

Function IL_IncludeTrailingPathDelimiter(const Path: String): String;
begin
Result := RTLToStr(IncludeTrailingPathDelimiter(StrToRTL(Path)));
end;

//------------------------------------------------------------------------------

Function IL_ExcludeTrailingPathDelimiter(const Path: String): String;
begin
Result := RTLToStr(ExcludeTrailingPathDelimiter(StrToRTL(Path)));
end;

//------------------------------------------------------------------------------

Function IL_ExtractFileDir(const FileName: String): String;
begin
Result := RTLToStr(ExtractFileDir(StrToRTL(FileName)));
end;

//------------------------------------------------------------------------------

Function IL_ExtractFilePath(const FileName: String): String;
begin
Result := RTLToStr(ExtractFilePath(StrToRTL(FileName)));
end;

//------------------------------------------------------------------------------

Function IL_ExtractFileNameNoExt(const FileName: String): String;
begin
Result := IL_ChangeFileExt(RTLToStr(ExtractFileName(StrToRTL(FileName))),'');
end;

//------------------------------------------------------------------------------

Function IL_ExtractFileExt(const FileName: String): String;
begin
Result := RTLToStr(ExtractFileExt(StrToRTL(FileName)));
end;

//------------------------------------------------------------------------------

Function IL_ExpandFileName(const FileName: String): String;
begin
Result := RTLToStr(ExpandFileName(StrToRTL(FileName)));
end;

//------------------------------------------------------------------------------

Function IL_MinimizeName(const FileName: String; Canvas: TCanvas; MaxLen: Integer): String;
begin
Result := RTLToStr(MinimizeName(StrToRTL(FileName),Canvas,MaxLen));
end;

//------------------------------------------------------------------------------

Function IL_ChangeFileExt(const FileName,NewExt: String): String;
begin
Result := RTLToStr(ChangeFileExt(StrToRTL(FileName),StrToRTL(NewExt)));
end;

//------------------------------------------------------------------------------

procedure IL_CreateDirectory(const Directory: String);
begin
ForceDirectories(StrToRTL(Directory));
end;

//------------------------------------------------------------------------------

procedure IL_CreateDirectoryPath(const Path: String);
begin
IL_CreateDirectory(RTLToStr(ExcludeTrailingPathDelimiter(StrToRTL(Path))));
end;

//------------------------------------------------------------------------------

procedure IL_CreateDirectoryPathForFile(const FileName: String);
begin
IL_CreateDirectory(RTLToStr(ExtractFileDir(StrToRTL(FileName))));
end;

//------------------------------------------------------------------------------

Function IL_FileExists(const FileName: String): Boolean;
begin
Result := FileExists(StrToRTL(FileName));
end;

//------------------------------------------------------------------------------

Function IL_DeleteFile(const FileName: String): Boolean;
begin
Result := DeleteFile(StrToRTL(FileName));
end;

//------------------------------------------------------------------------------

Function IL_DeleteDir(const Dir: String): Boolean;
var
  FileOp:   TSHFileOpStruct;
  TempStr:  String;
begin
TempStr := IL_ExcludeTrailingPathDelimiter(Dir) + #0;
FillChar(FileOp,SizeOf(TSHFileOpStruct),0);
FileOp.Wnd := 0;
FileOp.wFunc := FO_DELETE;
FileOp.pFrom := PChar(TempStr);
FileOp.pTo := nil;
FileOp.fFlags := FOF_NOCONFIRMATION or FOF_NOERRORUI or FOF_SILENT;
FileOp.lpszProgressTitle := nil;
Result := SHFileOperation(FileOp) = 0;
end;

//------------------------------------------------------------------------------

procedure IL_CopyFile(const Source,Destination: String);
begin
CopyFile(PChar(StrToWin(Source)),PChar(StrToWin(Destination)),False);
end;

//------------------------------------------------------------------------------

procedure IL_MoveFile(const Source,Destination: String);
begin
MoveFileEx(PChar(StrToWin(Source)),PChar(StrToWin(Destination)),
  MOVEFILE_COPY_ALLOWED or MOVEFILE_REPLACE_EXISTING or MOVEFILE_WRITE_THROUGH);
end;

//------------------------------------------------------------------------------

procedure IL_EnumFiles(const BaseFolder: String; List: TStrings);
var
  FoldersList:  TStringList;
  CurrentLevel: TStringList;
  i:            Integer;

  procedure ListFolder(const Folder: String; Files,Folders: TStrings);
  var
    SearchRec:  TSearchRec;
  begin
    If FindFirst(IL_IncludeTrailingPathDelimiter(Folder) + '*.*',faAnyFile,SearchRec) = 0 then
    begin
      repeat
        If (SearchRec.Attr and faDirectory)	<> 0 then
          begin
            If (SearchRec.Name <> '.') and (SearchRec.Name <> '..') then
              Folders.Add(IL_IncludeTrailingPathDelimiter(Folder) + SearchRec.Name)
          end
        else
          begin
          {$WARN SYMBOL_PLATFORM OFF}
            If (SearchRec.Attr and faHidden) = 0 then
          {$WARN SYMBOL_PLATFORM ON}
              Files.Add(SearchRec.Name); // add only file names, not full paths
          end;
      until FindNext(SearchRec) <> 0;
      FindClose(SearchRec);
    end;
  end;

begin
FoldersList := TStringList.Create;
try
  CurrentLevel := TStringList.Create;
  try
    FoldersList.Add(IL_IncludeTrailingPathDelimiter(BaseFolder));
    repeat
      CurrentLevel.Assign(FoldersList);
      FoldersList.Clear;
      For i := 0 to Pred(CurrentLevel.Count) do
        ListFolder(CurrentLevel[i],List,FoldersList);
    until FoldersList.Count <= 0;
  finally
    CurrentLevel.Free;
  end;
finally
  FoldersList.Free;
end;
end;


//==============================================================================
//- event handler assignment checking ------------------------------------------

Function IL_CheckHandler(Handler: TNotifyEvent): TNotifyEvent;
begin
If Assigned(Handler) then
  Result := Handler
else
  raise Exception.Create('IL_CheckAndAssign(TNotifyEvent): Handler not assigned');
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

Function IL_CheckHandler(Handler: TILObjectL1Event): TILObjectL1Event;
begin
If Assigned(Handler) then
  Result := Handler
else
  raise Exception.Create('IL_CheckAndAssign(TILObjectL1Event): Handler not assigned');
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

Function IL_CheckHandler(Handler: TILObjectL2Event): TILObjectL2Event;
begin
If Assigned(Handler) then
  Result := Handler
else
  raise Exception.Create('IL_CheckAndAssign(TILObjectL2Event): Handler not assigned');
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

Function IL_CheckHandler(Handler: TILIndexedObjectL1Event): TILIndexedObjectL1Event;
begin
If Assigned(Handler) then
  Result := Handler
else
  raise Exception.Create('IL_CheckAndAssign(TILIndexedObjectL1Event): Handler not assigned');
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

Function IL_CheckHandler(Handler: TILIndexedObjectL2Event): TILIndexedObjectL2Event;
begin
If Assigned(Handler) then
  Result := Handler
else
  raise Exception.Create('IL_CheckAndAssign(TILIndexedObjectL2Event): Handler not assigned');
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

Function IL_CheckHandler(Handler: TILPasswordRequest): TILPasswordRequest;
begin
If Assigned(Handler) then
  Result := Handler
else
  raise Exception.Create('IL_CheckAndAssign(TILPasswordRequest): Handler not assigned');
end;

//==============================================================================
//- pictures manipulation ------------------------------------------------------

procedure IL_PicShrink(Large,Small: TBitmap; Factor: Integer);
type
  TRGBTriple = packed record
    rgbtRed, rgbtGreen, rgbtBlue: Byte;
  end;
  TRGBTripleArray = array[0..$FFFF] of TRGBTriple;
  PRGBTripleArray = ^TRGBTripleArray;
var
  LargeH: Boolean;
  SmallH: Boolean;
  Y,X:    Integer;
  Lines:  array of PRGBTripleArray;
  LineR:  PRGBTripleArray;
  R,G,B:  UInt32;
  i,j:    Integer;
begin
LargeH := Large.HandleAllocated;
SmallH := Small.HandleAllocated;
// ensure GDI handle is allocated in both bitmaps
Large.Handle;
Small.Handle;
SetLength(Lines,Factor);
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
If not LargeH then
  Large.Dormant;
If not SmallH then
  Small.Dormant;
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

Function IL_BoolToNum(Value: Boolean): Integer;
begin
If Value then
  Result := 1
else
  Result := 0;
end;

//------------------------------------------------------------------------------

procedure IL_ShellOpen(WindowHandle: HWND; const Path: String; const Params: String = ''; const Directory: String = '');
begin
If Length(Path) > 0 then
  ShellExecute(WindowHandle,'open',PChar(StrToWin(Path)),PChar(StrToWin(Params)),PChar(StrToWin(Directory)),SW_SHOWNORMAL);
end;

//------------------------------------------------------------------------------

Function IL_SelectDirectory(const Title: String; var Directory: String): Boolean;
begin
Result := SelectDirectory(Title,'',Directory);
end;

//------------------------------------------------------------------------------

Function IL_GetTempPath: String;
begin
Result := '';
SetLength(Result,GetTempPath(0,nil));
SetLength(Result,GetTempPath(Length(Result),PChar(Result)));
end;


//==============================================================================
//- roatated text drawing ------------------------------------------------------

Function IL_LogFontAssign(Src: TFont): TLogFont;
begin
FillChar(Result,SizeOf(TLogFont),0);
Result.lfHeight := Src.Height;
If fsBold in Src.Style then
  Result.lfWeight := FW_BOLD
else
  Result.lfWeight := FW_NORMAL;
Result.lfItalic := IL_BoolToNum(fsItalic in Src.Style);
Result.lfUnderline := IL_BoolToNum(fsUnderline in Src.Style);
Result.lfStrikeOut := IL_BoolToNum(fsStrikeOut in Src.Style);
Result.lfQuality := DEFAULT_QUALITY;
Result.lfCharSet := Src.Charset;
StrLCopy(Result.lfFaceName,PChar(Src.Name),Length(Src.Name));
end;

//------------------------------------------------------------------------------

Function IL_GetRotatedTextRect(Canvas: TCanvas; const Text: String; Angle: Integer; out Rect: TRect): Boolean;
var
  Font:               TLogFont;
  BackgroundMode:     Integer;
  CurrFont,OldFont:   HFONT;
  TextSize:           TSize;
  // corners of the bounding box - first, text origin, is ignored, others are taken ccw
  PointsIn,PointsOut: array[0..2] of TPoint;
  SinAngle,CosAngle:  Double;
  i:                  Integer;
begin
Result := False;
If Assigned(Canvas) and (Length(Text) > 0) then
  begin
    Font := IL_LogFontAssign(Canvas.Font);
    Font.lfEscapement := Angle * 10;
    Font.lfOrientation := Angle * 10;
    BackgroundMode := SetBkMode(Canvas.Handle,TRANSPARENT);
    try
      CurrFont := CreateFontIndirect(Font);
      try
        OldFont := SelectObject(Canvas.Handle,CurrFont);
        try
          If GetTextExtentPoint32(Canvas.Handle,PChar(Text),Length(Text),TextSize) then
            begin
              If (Angle mod 360) <> 0 then
                begin
                  PointsIn[0] := Point(0,TextSize.cy);
                  PointsIn[1] := Point(TextSize.cx,TextSize.cy);
                  PointsIn[2] := Point(TextSize.cx,0);
                  SinAngle := Sin(DegToRad(Angle));
                  CosAngle := Cos(DegToRad(Angle));
                  For i := Low(PointsIn) to High(PointsIn) do
                    begin
                      PointsOut[i].X := Round(CosAngle * PointsIn[i].X + SinAngle * PointsIn[i].Y);
                      PointsOut[i].Y := Round(-(SinAngle * PointsIn[i].X) + CosAngle * PointsIn[i].Y)
                    end;
                  Rect.Left := MinIntValue([0,PointsOut[0].X,PointsOut[1].X,PointsOut[2].X]);
                  Rect.Top := MinIntValue([0,PointsOut[0].Y,PointsOut[1].Y,PointsOut[2].Y]);
                  Rect.Right := MaxIntValue([0,PointsOut[0].X,PointsOut[1].X,PointsOut[2].X]);
                  Rect.Bottom := MaxIntValue([0,PointsOut[0].Y,PointsOut[1].Y,PointsOut[2].Y]);
                end
              else
                begin
                  Rect.Left := 0;
                  Rect.Top := 0;
                  Rect.Right := TextSize.cx;
                  Rect.Bottom := TextSize.cy;
                end;
              Result := True;
            end;
        finally
          SelectObject(Canvas.Handle,OldFont);
        end;
      finally
        DeleteObject(CurrFont);
      end;
    finally
      SetBkMode(Canvas.Handle,BackgroundMode);
    end;
  end;
end;

//------------------------------------------------------------------------------

Function IL_GetRotatedTextSize(Canvas: TCanvas; const Text: String; Angle: Integer; out Size: TSize): Boolean;
var
  TextRect: TRect;
begin
If IL_GetRotatedTextRect(Canvas,Text,Angle,TextRect) then
  begin
    Size.cx := TextRect.Right - TextRect.Left;
    Size.cy := TextRect.Bottom - TextRect.Top;
    Result := True;
  end
else Result := False;
end;

//------------------------------------------------------------------------------

Function IL_DrawRotatedText(Canvas: TCanvas; const Text: String; Angle: Integer; X,Y: Integer): Boolean;
var
  Font:             TLogFont;
  BackgroundMode:   Integer;
  CurrFont,OldFont: HFONT;
begin
Result := False;
If Assigned(Canvas) and (Length(Text) > 0) then
  begin
    Font := IL_LogFontAssign(Canvas.Font);
    Font.lfEscapement := Angle * 10;
    Font.lfOrientation := Angle * 10;
    BackgroundMode := SetBkMode(Canvas.Handle,TRANSPARENT);
    try
      CurrFont := CreateFontIndirect(Font);
      try
        OldFont := SelectObject(Canvas.Handle,CurrFont);
        try
          Result := TextOut(Canvas.Handle,X,Y,PChar(Text),Length(Text));
        finally
          SelectObject(Canvas.Handle,OldFont);
        end;
      finally
        DeleteObject(CurrFont);
      end;
    finally
      SetBkMode(Canvas.Handle,BackgroundMode);
    end;
  end;
end;

//==============================================================================

initialization
{$WARN SYMBOL_PLATFORM OFF}
{$IF not Defined(FPC) and (CompilerVersion >= 18)} // Delphi 2006+
  ILLocalFormatSettings := TFormatSettings.Create(LOCALE_USER_DEFAULT);
{$ELSE}
  GetLocaleFormatSettings(LOCALE_USER_DEFAULT,ILLocalFormatSettings);
{$IFEND}
{$WARN SYMBOL_PLATFORM ON}

end.
