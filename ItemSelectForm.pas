unit ItemSelectForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CheckLst,
  CountedDynArrayInteger,
  InflatablesList_Manager;

type
  TfItemSelectForm = class(TForm)
    clbItems: TCheckListBox;
    lblItems: TLabel;
    btnAccept: TButton;
    btnClose: TButton;
    procedure clbItemsClick(Sender: TObject);
    procedure btnAcceptClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
  private
    fILManager: TILManager;
    fAccepted:  Boolean;
  protected
    procedure UpdateIndex;
  public
    procedure Initialize(ILManager: TILManager);
    procedure ShowItemSelect(const Title: String; var Indices: TCountedDynArrayInteger);
  end;

var
  fItemSelectForm: TfItemSelectForm;

implementation

{$R *.dfm}

procedure TfItemSelectForm.UpdateIndex;
begin
If clbItems.Count > 0 then
  lblItems.Caption := Format('Items (%d/%d):',[clbItems.ItemIndex + 1,clbItems.Count])
else
  lblItems.Caption := 'Items:';
end;

//==============================================================================

procedure TfItemSelectForm.Initialize(ILManager: TILManager);
begin
fILManager := ILManager;
end;

//------------------------------------------------------------------------------

procedure TfItemSelectForm.ShowItemSelect(const Title: String; var Indices: TCountedDynArrayInteger);
var
  i:  Integer;
begin
fAccepted := False;
Caption := Title;
// fill list
clbItems.Items.BeginUpdate;
try
  clbItems.Clear;
  For i := fIlManager.ItemLowIndex to fILManager.ItemHighIndex do
    If Length(fILManager[i].SizeStr) > 0 then
      clbItems.Items.Add(Format('%s (%s - %s)',[fILManager[i].TitleStr,fILManager[i].TypeStr,fILManager[i].SizeStr]))
    else
      clbItems.Items.Add(Format('%s (%s)',[fILManager[i].TitleStr,fILManager[i].TypeStr]));
finally
  clbItems.Items.EndUpdate;
end;
If clbItems.Count > 0 then
  clbItems.ItemIndex := 0;
clbItems.OnClick(nil);
UpdateIndex;
ShowModal;
CDA_Clear(Indices);
If fAccepted then
  For i := 0 to Pred(clbItems.Count) do
    If clbItems.Checked[i] then
      CDA_Add(Indices,i);
end;

//==============================================================================

procedure TfItemSelectForm.clbItemsClick(Sender: TObject);
begin
UpdateIndex;
end;

//------------------------------------------------------------------------------

procedure TfItemSelectForm.btnAcceptClick(Sender: TObject);
begin
fAccepted := True;
Close;
end;

//------------------------------------------------------------------------------

procedure TfItemSelectForm.btnCloseClick(Sender: TObject);
begin
fAccepted := False;
Close;
end;

end.
