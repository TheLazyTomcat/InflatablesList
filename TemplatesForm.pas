unit TemplatesForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Menus,
  InflatablesList_ItemShop,
  InflatablesList_Manager;

type
  TfTemplatesForm = class(TForm)
    leName: TLabeledEdit;
    btnSave: TButton;
    lblTemplates: TLabel;
    lbTemplates: TListBox;
    pmnTemplates: TPopupMenu;
    mniTL_Rename: TMenuItem;
    N1: TMenuItem;
    mniTL_Remove: TMenuItem;
    mniTL_Clear: TMenuItem;
    N2: TMenuItem;
    mniTL_MoveUp: TMenuItem;
    mniTL_MoveDown: TMenuItem;
    N3: TMenuItem;
    mniTL_Export: TMenuItem;
    mniTL_Import: TMenuItem;
    btnLoad: TButton;
    diaExport: TSaveDialog;    
    diaImport: TOpenDialog;
    procedure FormShow(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure lbTemplatesClick(Sender: TObject);
    procedure lbTemplatesDblClick(Sender: TObject);
    procedure lbTemplatesMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pmnTemplatesPopup(Sender: TObject);
    procedure mniTL_RenameClick(Sender: TObject);
    procedure mniTL_RemoveClick(Sender: TObject);
    procedure mniTL_ClearClick(Sender: TObject);
    procedure mniTL_MoveUpClick(Sender: TObject);
    procedure mniTL_MoveDownClick(Sender: TObject);
    procedure mniTL_ExportClick(Sender: TObject);
    procedure mniTL_ImportClick(Sender: TObject);
    procedure btnLoadClick(Sender: TObject);
  private
    fILManager:   TILManager;
    fAsInit:      Boolean;
    fCurrentShop: TILItemShop;
  public
    procedure Initialize(ILManager: TILManager);
    procedure Finalize;
    procedure ShowTemplates(CurrentShop: TILItemShop; AsInit: Boolean);
  end;

var
  fTemplatesForm: TfTemplatesForm;

implementation

uses
  PromptForm,
  InflatablesList_Utils;

{$R *.dfm}

procedure TfTemplatesForm.Initialize(ILManager: TILManager);
begin
fILManager := ILManager;
mniTL_MoveUp.ShortCut := ShortCut(VK_UP,[ssShift]);
mniTL_MoveDown.ShortCut := ShortCut(VK_DOWN,[ssShift]);
end;

//------------------------------------------------------------------------------

procedure TfTemplatesForm.Finalize;
begin
// nothing to do here
end;

//------------------------------------------------------------------------------

procedure TfTemplatesForm.ShowTemplates(CurrentShop: TILItemShop; AsInit: Boolean);
var
  i:  Integer;
begin
fAsInit := AsInit;
fCurrentShop := CurrentShop;
btnSave.Enabled := not AsInit;
leName.Text := fCurrentShop.Name;
// fill list of templates
lbTemplates.Items.BeginUpdate;
try
  lbTemplates.Items.Clear;
  For i := 0 to Pred(fILManager.ShopTemplateCount) do
    lbTemplates.Items.Add(fILManager.ShopTemplates[i].Name);
finally
  lbTemplates.Items.EndUpdate;
end;
If lbTemplates.Count > 0  then
  lbTemplates.ItemIndex := 0
else
  lbTemplates.ItemIndex := -1;
lbTemplates.OnClick(nil);
ShowModal;
end;

//==============================================================================

procedure TfTemplatesForm.FormShow(Sender: TObject);
begin
lbTemplates.SetFocus;
end;

//------------------------------------------------------------------------------

procedure TfTemplatesForm.btnSaveClick(Sender: TObject);
var
  Index:  Integer;
begin
If Assigned(fCurrentShop) and not fAsInit then
  begin
    If Length(leName.Text) > 0 then
      begin
        Index := fILManager.ShopTemplateAdd(leName.Text,fCurrentShop);
        lbTemplates.Items.Add(fILManager.ShopTemplates[Index].Name);
        If lbTemplates.ItemIndex < 0 then
          begin
            lbTemplates.ItemIndex := 0;
            lbTemplates.OnClick(nil);
          end;
      end
    else MessageDlg('Empty name not allowed.',mtError,[mbOK],0);
  end;
end;

//------------------------------------------------------------------------------

procedure TfTemplatesForm.lbTemplatesClick(Sender: TObject);
begin
btnLoad.Enabled := lbTemplates.ItemIndex >= 0;
end;

//------------------------------------------------------------------------------

procedure TfTemplatesForm.lbTemplatesDblClick(Sender: TObject);
begin
If lbTemplates.ItemIndex >= 0 then
  btnLoad.OnClick(nil);
end;

//------------------------------------------------------------------------------

procedure TfTemplatesForm.lbTemplatesMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Index:  Integer;
begin
Index := lbTemplates.ItemAtPos(Point(X,Y),True);
If Index >= 0 then
  lbTemplates.ItemIndex := Index
else
  lbTemplates.ItemIndex := Pred(lbTemplates.Count);
lbTemplates.OnClick(nil);
end;

//------------------------------------------------------------------------------

procedure TfTemplatesForm.pmnTemplatesPopup(Sender: TObject);
begin
mniTL_Rename.Enabled := lbTemplates.ItemIndex >= 0;
mniTL_Remove.Enabled := lbTemplates.ItemIndex >= 0;
mniTL_Clear.Enabled := lbTemplates.Count > 0;
mniTL_MoveUp.Enabled := lbTemplates.ItemIndex > 0;
mniTL_MoveDown.Enabled := (lbTemplates.Count > 0) and (lbTemplates.ItemIndex < Pred(lbTemplates.Count));
mniTL_Export.Enabled := lbTemplates.ItemIndex >= 0;
end;

//------------------------------------------------------------------------------

procedure TfTemplatesForm.mniTL_RenameClick(Sender: TObject);
var
  NewName:  String;
begin
If Assigned(fCurrentShop) and (lbTemplates.ItemIndex >= 0) then
  begin
    NewName := lbTemplates.Items[lbTemplates.ItemIndex];
    If IL_InputQuery('New template name','Enter new template name:',NewName) then
      begin
        // following will also change all references to this template
        fILManager.ShopTemplateRename(lbTemplates.ItemIndex,NewName);
        lbTemplates.Items[lbTemplates.ItemIndex] := NewName;
      end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfTemplatesForm.mniTL_RemoveClick(Sender: TObject);
var
  Index:  Integer;
begin
If lbTemplates.ItemIndex >= 0 then
  If MessageDlg(IL_Format('Are you sure you want to remove template "%s"?',
      [fILManager.ShopTemplates[lbTemplates.ItemIndex].Name]),
      mtConfirmation,[mbYes,mbNo],0) = mrYes then
    begin
      Index := lbTemplates.ItemIndex;
      If lbTemplates.ItemIndex < Pred(lbTemplates.Count) then
        lbTemplates.ItemIndex := lbTemplates.ItemIndex + 1
      else If lbTemplates.ItemIndex > 0 then
        lbTemplates.ItemIndex := lbTemplates.ItemIndex - 1
      else
        lbTemplates.ItemIndex := -1;
      lbTemplates.OnClick(nil);
      lbTemplates.Items.Delete(Index);
      fILManager.ShopTemplateDelete(Index);
    end;
end;

//------------------------------------------------------------------------------

procedure TfTemplatesForm.mniTL_ClearClick(Sender: TObject);
begin
If lbTemplates.Count > 0 then
  If MessageDlg('Are you sure you want to remove all templates?',
      mtConfirmation,[mbYes,mbNo],0) = mrYes then
    begin
      lbTemplates.Clear;
      fILManager.ShopTemplateClear;
    end;
end;

//------------------------------------------------------------------------------

procedure TfTemplatesForm.mniTL_MoveUpClick(Sender: TObject);
var
  Index:  Integer;
begin
If lbTemplates.ItemIndex > 0 then
  begin
    Index := lbTemplates.ItemIndex;
    lbTemplates.Items.Exchange(Index,Index - 1);
    fILManager.ShopTemplateExchange(Index,Index - 1);
    lbTemplates.ItemIndex := Index - 1;    
  end;
end;

//------------------------------------------------------------------------------

procedure TfTemplatesForm.mniTL_MoveDownClick(Sender: TObject);
var
  Index:  Integer;
begin
If (lbTemplates.Count > 0) and (lbTemplates.ItemIndex < Pred(lbTemplates.Count)) then
  begin
    Index := lbTemplates.ItemIndex;
    lbTemplates.Items.Exchange(Index,Index + 1);
    fILManager.ShopTemplateExchange(Index,Index + 1);
    lbTemplates.ItemIndex := Index + 1;    
  end;
end;

//------------------------------------------------------------------------------

procedure TfTemplatesForm.mniTL_ExportClick(Sender: TObject);
begin
If lbTemplates.ItemIndex >= 0 then
  begin
    diaExport.FileName := lbTemplates.Items[lbTemplates.ItemIndex] + '.tpl';
    If diaExport.Execute then
      fILManager.ShopTemplateExport(diaExport.FileName,lbTemplates.ItemIndex);
  end;
end;

//------------------------------------------------------------------------------

procedure TfTemplatesForm.mniTL_ImportClick(Sender: TObject);
var
  Index:  Integer;
begin
If diaImport.Execute then
  begin
    Index := fILManager.ShopTemplateImport(diaImport.FileName);
    lbTemplates.Items.Add(fILManager.ShopTemplates[Index].Name);
    If lbTemplates.ItemIndex < 0 then
      begin
        lbTemplates.ItemIndex := 0;
        lbTemplates.OnClick(nil);
      end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfTemplatesForm.btnLoadClick(Sender: TObject);
var
  CanProceed: Boolean;
begin
If Assigned(fCurrentShop) and (lbTemplates.ItemIndex >= 0) then
  begin
    If fAsInit then
      CanProceed := True
    else
      CanProceed := MessageDlg(
        IL_Format('Are you sure you want to replace current shop settings with template "%s"?',
        [fILManager.ShopTemplates[lbTemplates.ItemIndex].Name]),mtConfirmation,[mbYes,mbNo],0) = mrYes;
    If CanProceed then
      begin
        fILManager.ShopTemplates[lbTemplates.ItemIndex].CopyTo(fCurrentShop);
        Close;
      end;
  end;
end;

end.
