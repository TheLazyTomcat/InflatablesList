unit TextEditForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,
  InflatablesList_Manager;

type
  TfTextEditForm = class(TForm)
    meText: TMemo;
    procedure meTextKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    fILManager: TILManager;
  public
    { Public declarations }
    procedure Initialize(ILManager: TILManager);
    procedure Finalize;
    procedure ShowTextEditor(const Title: String; var Text: String; ProportionalFont: Boolean);
  end;

var
  fTextEditForm: TfTextEditForm;

implementation

{$R *.dfm}

procedure TfTextEditForm.Initialize(ILManager: TILManager);
begin
fILManager := ILManager;
end;

//------------------------------------------------------------------------------

procedure TfTextEditForm.Finalize;
begin
// nothing to do here
end;

//------------------------------------------------------------------------------

procedure TfTextEditForm.ShowTextEditor(const Title: String; var Text: String; ProportionalFont: Boolean);
begin
Caption := Title;
If ProportionalFont then
  meText.Font.Name := 'Tahoma'
else
  meText.Font.Name := 'Courier New';
meText.Text := Text;
// set cursor at the end of text
If Length(meText.Text) > 0 then
  meText.SelStart := Length(meText.Text);
ShowModal;
Text := meText.Text;
end;

//==============================================================================

procedure TfTextEditForm.meTextKeyPress(Sender: TObject; var Key: Char);
begin
case Key of
  ^A:   begin
          meText.SelectAll;
          Key := #0;
        end;
  #27:  Close;  // escape
end;
end;

end.
