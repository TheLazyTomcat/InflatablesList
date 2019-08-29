unit PromptForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Spin, StdCtrls;

type
  // interposer for spin edit
  TSpinEdit = class(Spin.TSpinEdit)
  protected
    Function IsValidChar(Key: Char): Boolean; override;
  end;

  TfPromptForm = class(TForm)
    lblPrompt: TLabel;
    eTextValue: TEdit;
    seIntValue: TSpinEdit;
    btnOK: TButton;
    btnCancel: TButton;
    procedure FormShow(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure ValueKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
    ResultState:  TModalResult;
  end;

Function IL_InputQuery(const Title,Prompt: String; var Value: String): Boolean; overload;
Function IL_InputQuery(const Title,Prompt: String; var Value: String; PasswordChar: Char): Boolean; overload;
Function IL_InputQuery(const Title,Prompt: String; var Value: Integer; Min: Integer = Low(Integer); Max: Integer = High(Integer)): Boolean; overload;

implementation

{$R *.dfm}

Function TSpinEdit.IsValidChar(Key: Char): Boolean;
begin
// TSpinEdit swallows return, so it cannot be handled in OnKeyPress event, this prevents it
If Key <> #13{return} then
  Result := inherited IsValidChar(Key)
else
  Result := True;
end;

//==============================================================================

procedure TfPromptForm.FormShow(Sender: TObject);
begin
ResultState := mrNone;
If lblPrompt.Width > ClientWidth + 16 then
  ClientWidth := lblPrompt.Width + 16;
eTextValue.Left := 8;
eTextValue.Width := ClientWidth - 16;
seIntValue.Left := 8;
seIntValue.Width := ClientWidth - 16;
end;

//------------------------------------------------------------------------------

procedure TfPromptForm.ValueKeyPress(Sender: TObject; var Key: Char);
begin
case Key of
  #13:  begin {return}
          Key := #0;
          ResultState := mrOK;
          Close;
        end;
  #27:  begin {escape}
          Key := #0;
          ResultState := mrCancel;
          Close;
        end;
end;
end;

//------------------------------------------------------------------------------

procedure TfPromptForm.btnOKClick(Sender: TObject);
begin
ResultState := mrOK;
Close;
end;

//------------------------------------------------------------------------------

procedure TfPromptForm.btnCancelClick(Sender: TObject);
begin
ResultState := mrCancel;
Close;
end;

//==============================================================================

Function IL_InputQuery(const Title,Prompt: String; var Value: String): Boolean; overload;
var
  PromptForm: TfPromptForm;
begin
Result := False;
PromptForm := TfPromptForm.Create(Application);
try
  PromptForm.Caption := Title;
  PromptForm.lblPrompt.Caption := Prompt;
  PromptForm.eTextValue.Visible := True;
  PromptForm.seIntValue.Visible := False;

  PromptForm.eTextValue.Text := Value;
  PromptForm.eTextValue.SelectAll;

  PromptForm.ShowModal;
  If PromptForm.ResultState = mrOK then
    begin
      Value := PromptForm.eTextValue.Text;
      Result := True;
    end;
finally
  PromptForm.Free;
end;
end;

//------------------------------------------------------------------------------

Function IL_InputQuery(const Title,Prompt: String; var Value: String; PasswordChar: Char): Boolean; overload;
var
  PromptForm: TfPromptForm;
begin
Result := False;
PromptForm := TfPromptForm.Create(Application);
try
  PromptForm.Caption := Title;
  PromptForm.lblPrompt.Caption := Prompt;
  PromptForm.eTextValue.Visible := True;
  PromptForm.seIntValue.Visible := False;

  PromptForm.eTextValue.Text := Value;
  PromptForm.eTextValue.SelectAll;
  PromptForm.eTextValue.PasswordChar := PasswordChar;

  PromptForm.ShowModal;
  If PromptForm.ResultState = mrOK then
    begin
      Value := PromptForm.eTextValue.Text;
      Result := True;
    end;
finally
  PromptForm.Free;
end;
end;

//------------------------------------------------------------------------------

Function IL_InputQuery(const Title,Prompt: String; var Value: Integer; Min: Integer = Low(Integer); Max: Integer = High(Integer)): Boolean; overload;
var
  PromptForm: TfPromptForm;
begin
Result := False;
PromptForm := TfPromptForm.Create(Application);
try
  PromptForm.Caption := Title;
  PromptForm.lblPrompt.Caption := Prompt;
  PromptForm.eTextValue.Visible := False;
  PromptForm.seIntValue.Visible := True;

  PromptForm.seIntValue.MinValue := Min;
  PromptForm.seIntValue.MaxValue := Max;
  PromptForm.seIntValue.Value := Value;
  PromptForm.seIntValue.SelectAll;
  
  PromptForm.ShowModal;
  If PromptForm.ResultState = mrOK then
    begin
      Value := PromptForm.seIntValue.Value;
      Result := True;
    end;
finally
  PromptForm.Free;
end;
end;

end.
