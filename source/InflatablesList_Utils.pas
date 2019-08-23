unit InflatablesList_Utils;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  Windows, SysUtils, Graphics,
  AuxTypes;

//==============================================================================
//- file path manipulation -----------------------------------------------------

Function IL_PathRelative(const Base,Path: String): String;
Function IL_PathAbsolute(const Base,Path: String): String;

procedure IL_CreateDirectoryPathForFile(const FileName: String);

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

Function IL_InputQuery(const Title,Prompt: String; Min,Max: Integer; var Value: Integer): Boolean;

implementation

uses
  Forms, Controls, StdCtrls, Spin, ShellAPI, dialogs;

//==============================================================================
//- file path manipulation -----------------------------------------------------

Function IL_PathRelative(const Base,Path: String): String;
begin
Result := ExtractRelativePath(Base,Path);
If Length(Result) <> Length(Path) then
  Result := '.\' + Result;
end;

//------------------------------------------------------------------------------

Function IL_PathAbsolute(const Base,Path: String): String;
begin
If Length(Path) > 0 then
  begin
    If Path[1] = '.' then
      Result := ExpandFileName(Base + Path)
    else
      Result := Path;
  end
else Result := '';
end;

//------------------------------------------------------------------------------

procedure IL_CreateDirectoryPathForFile(const FileName: String);
begin
ForceDirectories(ExtractFileDir(FileName));
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

//==============================================================================

const
  ILIQ_OK = 1;
  ILIQ_CANCEL = 2;

type
  TILIQHelper = class(TObject)
  private
    fForm:  TForm;
  public
    constructor Create(Form: TForm);
    procedure ValueKeyPress(Sender: TObject; var Key: Char); virtual;
    procedure ButtonClick(Sender: TObject); virtual;
  end;

  TILIQSpinEDit = class(TSpinEdit)
  protected
    Function IsValidChar(Key: Char): Boolean; override;
  end;

//------------------------------------------------------------------------------

constructor TILIQHelper.Create(Form: TForm);
begin
inherited Create;
fForm := Form;
fForm.ModalResult := mrNone;
end;

//------------------------------------------------------------------------------

procedure TILIQHelper.ValueKeyPress(Sender: TObject; var Key: Char);
begin
case Key of
  #13:  begin {return}
          Key := #0;
          fForm.Tag := ILIQ_OK;
          fForm.Close;
        end;
  #27:  begin {escape}
          Key := #0;
          fForm.Tag := ILIQ_CANCEL;
          fForm.Close;
        end;
end;
end;

//------------------------------------------------------------------------------

procedure TILIQHelper.ButtonClick(Sender: TObject);
begin
If Sender is TButton then
  begin
    fForm.Tag := TButton(Sender).Tag;
    fForm.Close;
  end;
end;

//------------------------------------------------------------------------------

Function TILIQSpinEDit.IsValidChar(Key: Char): Boolean;
begin
// TSpinEdit swallows return, so it cannot be handled in OnKeyPress event, this prevents it
If Key <> #13{return} then
  Result := inherited IsValidChar(Key)
else
  Result := True;
end;

//------------------------------------------------------------------------------

Function IL_InputQuery(const Title,Prompt: String; Min,Max: Integer; var Value: Integer): Boolean;
const
  SPACING = 8;
  MIN_WND_WIDTH = 300;
var
  Form:       TForm;
  PromptObj:  TLabel;
  ValueObj:   TILIQSpinEDit;
  BtnOK:      TButton;
  BtnCancel:  TButton;
  Helper:     TILIQHelper;
begin
Result := False;
// create and setup form
Form := TForm.Create(Application);
try
  Form.BorderStyle := bsDialog;
  Form.Caption := Title;
  // create and setup prompt label
  PromptObj := TLabel.Create(Form);
  PromptObj.Parent := Form;
  PromptObj.Left := SPACING;
  PromptObj.Top := SPACING;
  PromptObj.Caption := Prompt;
  // create and setup value spin edit
  ValueObj := TILIQSpinEDit.Create(Form);
  ValueObj.Parent := Form;
  ValueObj.Left := SPACING;
  ValueObj.Top := PromptObj.Top + 2 * SPACING;
  ValueObj.MinValue := Min;
  ValueObj.MaxValue := Max;
  ValueObj.Value := Value;
  // adjust window width and accordingly spin edit width
  If (PromptObj.Width + 2 * SPACING) > MIN_WND_WIDTH then
    Form.ClientWidth := PromptObj.Width + 2 * SPACING
  else
    Form.ClientWidth := MIN_WND_WIDTH;
  ValueObj.Width := Form.ClientWidth - 2 * SPACING; 
  // create and setup buttons
  BtnOK := TButton.Create(Form);
  BtnOK.Parent := Form;
  BtnOK.Top := ValueObj.BoundsRect.Bottom + SPACING;
  BtnOK.Caption := 'OK';
  BtnOK.Tag := ILIQ_OK;
  BtnCancel := TButton.Create(Form);
  BtnCancel.Parent := Form;
  BtnCancel.Top := ValueObj.BoundsRect.Bottom + SPACING;
  BtnCancel.Caption := 'Cancel';
  BtnCancel.Tag := ILIQ_CANCEL;
  // adjust horizontal buttons position
  BtnOK.Left := (Form.ClientWidth - (BtnOK.Width + BtnCancel.Width + SPACING)) div 2;
  BtnCancel.Left := BtnOK.BoundsRect.Right + SPACING;
  // finalize window size, position, ..., and show it
  ValueObj.SelectAll;  
  Form.ClientHeight := BtnCancel.BoundsRect.Bottom + SPACING;
  Form.Position := poMainFormCenter;  
  Helper := TILIQHelper.Create(Form);
  try
    ValueObj.OnKeyPress := Helper.ValueKeyPress;
    BtnOK.OnClick := Helper.ButtonClick;
    BtnCancel.OnClick := Helper.ButtonClick;
    Form.Tag := 0;
    Form.ShowModal;
    If Form.Tag = 1{OK} then
      begin
        Value := ValueObj.Value;
        Result := True;
      end;
  finally
    Helper.Free;
  end;
finally
  Form.Free;
end;
end;

end.
