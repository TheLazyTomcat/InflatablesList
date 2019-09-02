unit ItemSelectForm;
{$message 'll_rework'}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CheckLst, Menus,
  CountedDynArrayInteger,
  InflatablesList_Manager;

type
  TfItemSelectForm = class(TForm)
    clbItems: TCheckListBox;
    lblItems: TLabel;
    pmItemsMenu: TPopupMenu;
    mniIM_CheckSelected: TMenuItem;
    mniIM_UncheckSelected: TMenuItem;
    mniIM_InvertSelected: TMenuItem;
    N1: TMenuItem;
    mniIM_CheckAll: TMenuItem;
    mniIM_UncheckAll: TMenuItem;
    mniIM_InvertAll: TMenuItem;       
    btnAccept: TButton;
    btnClose: TButton;
    procedure FormCreate(Sender: TObject);
    procedure clbItemsClick(Sender: TObject);
    procedure clbItemsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure mniIM_CheckSelectedClick(Sender: TObject);
    procedure mniIM_UncheckSelectedClick(Sender: TObject);
    procedure mniIM_InvertSelectedClick(Sender: TObject);
    procedure mniIM_CheckAllClick(Sender: TObject);
    procedure mniIM_UncheckAllClick(Sender: TObject);
    procedure mniIM_InvertAllClick(Sender: TObject);      
    procedure btnAcceptClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
  private
    fILManager: TILManager;
    fAccepted:  Boolean;
  protected
    procedure UpdateIndex;
    procedure SelectItem(Index: Integer);
  public
    procedure Initialize(ILManager: TILManager);
    procedure Finalize;
    procedure ShowItemSelect(const Title: String; var Indices: TCountedDynArrayInteger);
  end;

var
  fItemSelectForm: TfItemSelectForm;

implementation

{$R *.dfm}

procedure TfItemSelectForm.UpdateIndex;
begin
If clbItems.SelCount <= 1 then
  begin
    If clbItems.Count > 0 then
      lblItems.Caption := Format('Items (%d/%d):',[clbItems.ItemIndex + 1,clbItems.Count])
    else
      lblItems.Caption := 'Items:';
  end
else lblItems.Caption := Format('Items (%d/%d)(%d):',[clbItems.ItemIndex + 1,clbItems.Count,clbItems.SelCount])
end;

//------------------------------------------------------------------------------

procedure TfItemSelectForm.SelectItem(Index: Integer);
var
  i:  Integer;
begin
clbItems.ItemIndex := Index;
clbItems.Items.BeginUpdate;
try
  For i := 0 to Pred(clbItems.Count) do
    clbItems.Selected[i] := i = Index;
finally
  clbItems.Items.EndUpdate;
end;
end;

//==============================================================================

procedure TfItemSelectForm.Initialize(ILManager: TILManager);
begin
fILManager := ILManager;
end;

//------------------------------------------------------------------------------

procedure TfItemSelectForm.Finalize;
begin
// nothing to do here
end;

//------------------------------------------------------------------------------

procedure TfItemSelectForm.ShowItemSelect(const Title: String; var Indices: TCountedDynArrayInteger);
var
  i:        Integer;
  TempStr:  String;
begin
fAccepted := False;
Caption := Title;
// fill list
clbItems.Items.BeginUpdate;
try
  clbItems.Clear;
  For i := fIlManager.ItemLowIndex to fILManager.ItemHighIndex do
    begin
      If Length(fILManager[i].SizeStr) > 0 then
        TempStr := Format('%s (%s - %s)',[fILManager[i].TitleStr,fILManager[i].TypeStr,fILManager[i].SizeStr])
      else
        TempStr :=Format('%s (%s)',[fILManager[i].TitleStr,fILManager[i].TypeStr]);
      If Length(fILManager[i].TextTag) > 0 then
        TempStr := TempStr + Format(' {%s}',[fILManager[i].TextTag]);
      clbItems.Items.Add(TempStr);
    end;
finally
  clbItems.Items.EndUpdate;
end;
If clbItems.Count > 0 then
  SelectItem(0);
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

procedure TfItemSelectForm.FormCreate(Sender: TObject);
begin
clbItems.MultiSelect := True; // cannot be set design-time
end;

//------------------------------------------------------------------------------

procedure TfItemSelectForm.clbItemsClick(Sender: TObject);
begin
UpdateIndex;
end;

//------------------------------------------------------------------------------

procedure TfItemSelectForm.clbItemsMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Index:  Integer;
begin
If Button = mbRight then
  begin
    Index := clbItems.ItemAtPos(Point(X,Y),True);
    If Index >= 0 then
      begin
        If clbItems.SelCount <= 1 then
          SelectItem(Index);
        clbItems.OnClick(nil);
      end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfItemSelectForm.mniIM_CheckSelectedClick(Sender: TObject);
var
  i:  Integer;
begin
clbItems.Items.BeginUpdate;
try
  For i := 0 to Pred(clbItems.Count) do
    If clbItems.Selected[i] then
      clbItems.Checked[i] := True;
finally
  clbItems.Items.EndUpdate;
end;
end;

//------------------------------------------------------------------------------

procedure TfItemSelectForm.mniIM_UncheckSelectedClick(Sender: TObject);
var
  i:  Integer;
begin
clbItems.Items.BeginUpdate;
try
  For i := 0 to Pred(clbItems.Count) do
    If clbItems.Selected[i] then
      clbItems.Checked[i] := False;
finally
  clbItems.Items.EndUpdate;
end;
end;

//------------------------------------------------------------------------------

procedure TfItemSelectForm.mniIM_InvertSelectedClick(Sender: TObject);
var
  i:  Integer;
begin
clbItems.Items.BeginUpdate;
try
  For i := 0 to Pred(clbItems.Count) do
    If clbItems.Selected[i] then
      clbItems.Checked[i] := not clbItems.Checked[i];
finally
  clbItems.Items.EndUpdate;
end;
end;

//------------------------------------------------------------------------------

procedure TfItemSelectForm.mniIM_CheckAllClick(Sender: TObject);
var
  i:  Integer;
begin
clbItems.Items.BeginUpdate;
try
  For i := 0 to Pred(clbItems.Count) do
    clbItems.Checked[i] := True;
finally
  clbItems.Items.EndUpdate;
end;
end;

//------------------------------------------------------------------------------

procedure TfItemSelectForm.mniIM_UncheckAllClick(Sender: TObject);
var
  i:  Integer;
begin
clbItems.Items.BeginUpdate;
try
  For i := 0 to Pred(clbItems.Count) do
    clbItems.Checked[i] := False;
finally
  clbItems.Items.EndUpdate;
end;
end;

//------------------------------------------------------------------------------

procedure TfItemSelectForm.mniIM_InvertAllClick(Sender: TObject);
var
  i:  Integer;
begin
clbItems.Items.BeginUpdate;
try
  For i := 0 to Pred(clbItems.Count) do
    clbItems.Checked[i] := not clbItems.Checked[i];
finally
  clbItems.Items.EndUpdate;
end;
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
