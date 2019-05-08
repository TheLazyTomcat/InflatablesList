unit SpecialsForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls,
  InflatablesList, StdCtrls;

type
  TfSpecialsForm = class(TForm)
    pnlWarning: TPanel;
    btnClearTextTags: TButton;
    procedure btnClearTextTagsClick(Sender: TObject);
  private
    fILManager: TILManager;
  public
    procedure Initialize(ILManager: TILManager);
  end;

var
  fSpecialsForm: TfSpecialsForm;

implementation

{$R *.dfm}

procedure TfSpecialsForm.Initialize(ILManager: TILManager);
begin
fILManager := ILManager;
end;

//==============================================================================

procedure TfSpecialsForm.btnClearTextTagsClick(Sender: TObject);
var
  i:  Integer;
begin
For i := 0 to Pred(fILManager.ItemCount) do
  fILManager.ItemPtrs[i].TextTag := '';
Close;
end;

end.
