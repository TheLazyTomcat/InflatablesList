unit SortForm;
{$message 'll_rework'}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Menus, 
  InflatablesList_Types,
  InflatablesList_Manager;

type
  TfSortForm = class(TForm)
    lblProfiles: TLabel;
    lbProfiles: TListBox;
    btnProfileLoad: TButton;
    btnLoadDefault: TButton;
    btnClear: TButton;    
    btnProfileSave: TButton;
    pmnProfiles: TPopupMenu;
    pmi_PR_Add: TMenuItem;
    pmi_PR_Remove: TMenuItem;
    pmi_PR_Rename: TMenuItem;
    N1: TMenuItem;
    pmi_PR_MoveUp: TMenuItem;
    pmi_PR_MoveDown: TMenuItem;  
    lblSortBy: TLabel;
    lbSortBy: TListBox;
    lblAvailable: TLabel;
    lbAvailable: TListBox;
    btnMoveUp: TButton;
    btnAdd: TButton;
    btnToggleOrder: TButton;
    btnRemove: TButton;
    btnMoveDown: TButton;
    bvlSplitter: TBevel;
    cbSortRev: TCheckBox;
    btnSort: TButton;
    btnClose: TButton;
    procedure FormCreate(Sender: TObject);
    procedure lbProfilesClick(Sender: TObject);
    procedure lbProfilesDblClick(Sender: TObject);    
    procedure lbProfilesMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure btnProfileLoadClick(Sender: TObject);
    procedure btnLoadDefaultClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);    
    procedure btnProfileSaveClick(Sender: TObject);
    procedure pmnProfilesPopup(Sender: TObject);
    procedure pmi_PR_AddClick(Sender: TObject);
    procedure pmi_PR_RenameClick(Sender: TObject);
    procedure pmi_PR_RemoveClick(Sender: TObject);
    procedure pmi_PR_MoveUpClick(Sender: TObject);
    procedure pmi_PR_MoveDownClick(Sender: TObject);
    procedure lbSortByDblClick(Sender: TObject);
    procedure btnMoveUpClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnToggleOrderClick(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
    procedure btnMoveDownClick(Sender: TObject);
    procedure lbAvailableDblClick(Sender: TObject);
    procedure btnSortClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
  private
    { Private declarations }
    fILManager:     TILManager;
    fLocalSortSett: TILSortingSettings;
    fSorted:        Boolean;
  protected
    procedure FillSortByList(Init: Boolean);
    procedure UpdateNumbers;
  public
    { Public declarations }
    procedure Initialize(ILManager: TILManager);
    procedure Finalize;
    Function ShowSortingSettings: Boolean;
  end;

var
  fSortForm: TfSortForm;

implementation

uses
  PromptForm;

{$R *.dfm}

procedure TfSortForm.FillSortByList(Init: Boolean);
var
  OldIndex: Integer;
  i:        Integer;
begin
OldIndex := lbSortBy.ItemIndex;
lbSortBy.Items.BeginUpdate;
try
  lbSortBy.Clear;
  For i := 0 to Pred(fLocalSortSett.Count) do
    lbSortBy.Items.Add(fILManager.SortingItemStr(fLocalSortSett.Items[i]));
finally
  lbSortBy.Items.EndUpdate;
end;
If lbSortBy.Count > 0  then
  begin
    If (OldIndex >= lbSortBy.Count) or (OldIndex < 0) or Init then
      lbSortBy.ItemIndex := 0
    else
      lbSortBy.ItemIndex := OldIndex;
  end;
UpdateNumbers;
end;

//------------------------------------------------------------------------------

procedure TfSortForm.UpdateNumbers;
begin
lblSortBy.Caption := Format('Sort by values (%d/30):',[fLocalSortSett.Count]);
end;

//==============================================================================

procedure TfSortForm.Initialize(ILManager: TILManager);
var
  i:  TILItemValueTag;
begin
fILManager := ILManager;
// fill list of available values 
lbAvailable.Items.BeginUpdate;
try
  lbAvailable.Clear;
  For i := Low(TILItemValueTag) to High(TILItemValueTag) do
    lbAvailable.Items.Add(fILManager.DataProvider.GetItemValueTagString(i));
finally
  lbAvailable.Items.EndUpdate;
end;
If lbAvailable.Count > 0  then
  lbAvailable.ItemIndex := 0;
end;

//------------------------------------------------------------------------------

procedure TfSortForm.Finalize;
begin
// nothing to do here
end;

//------------------------------------------------------------------------------

Function TfSortForm.ShowSortingSettings: Boolean;
var
  i:  Integer;
begin
fLocalSortSett := fILManager.ActualSortingSettings;
fSorted := False;
// fill list of profiles
lbProfiles.Items.BeginUpdate;
try
  lbProfiles.Clear;
  For i := 0 to Pred(fILManager.SortingProfileCount) do
    lbProfiles.Items.Add(Format('%s (%d)',
      [fILManager.SortingProfiles[i].Name,fILManager.SortingProfiles[i].Settings.Count]));
finally
  lbProfiles.Items.EndUpdate;
end;
If lbProfiles.Count > 0 then
  lbProfiles.ItemIndex := 0;
lbProfiles.OnClick(nil);
// fill list of used
FillSortByList(True);
cbSortRev.Checked := fILManager.ReversedSort;
// show the window
ShowModal;
fILManager.ActualSortingSettings := fLocalSortSett;
fILManager.ReversedSort := cbSortRev.Checked;
Result := fSorted;
end;

//==============================================================================

procedure TfSortForm.FormCreate(Sender: TObject);
begin
pmi_PR_MoveUp.ShortCut := ShortCut(VK_UP,[ssShift]);
pmi_PR_MoveDown.ShortCut := ShortCut(VK_DOWN,[ssShift]);
end;

//------------------------------------------------------------------------------

procedure TfSortForm.lbProfilesClick(Sender: TObject);
begin
btnProfileLoad.Enabled := lbProfiles.ItemIndex >= 0;
btnProfileSave.Enabled := lbProfiles.ItemIndex >= 0;
end;

//------------------------------------------------------------------------------

procedure TfSortForm.lbProfilesDblClick(Sender: TObject);
begin
If lbProfiles.ItemIndex >= 0 then
  btnProfileLoad.OnClick(nil);
end;

//------------------------------------------------------------------------------

procedure TfSortForm.lbProfilesMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Index:  Integer;
begin
If Button = mbRight then
  begin
    Index := lbProfiles.ItemAtPos(Point(X,Y),True);
    If Index >= 0 then
      begin
        lbProfiles.ItemIndex := Index;
        lbProfiles.OnClick(nil);
      end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfSortForm.btnProfileLoadClick(Sender: TObject);
begin
If lbProfiles.ItemIndex >= 0 then
  begin
    fLocalSortSett := fILManager.SortingProfiles[lbProfiles.ItemIndex].Settings;
    FillSortByList(False);
  end;
end;

//------------------------------------------------------------------------------

procedure TfSortForm.btnLoadDefaultClick(Sender: TObject);
begin
fLocalSortSett := fILManager.DefaultSortingSettings;
FillSortByList(False);
end;

//------------------------------------------------------------------------------

procedure TfSortForm.btnClearClick(Sender: TObject);
var
  i:  Integer;
begin
fLocalSortSett.Count := 0;
For i := Low(fLocalSortSett.Items) to High(fLocalSortSett.Items) do
  begin
    fLocalSortSett.Items[i].ItemValueTag := ilivtNone;
    fLocalSortSett.Items[i].Reversed := False;
  end;
FillSortByList(False);
end;

//------------------------------------------------------------------------------

procedure TfSortForm.btnProfileSaveClick(Sender: TObject);
begin
If lbProfiles.ItemIndex >= 0 then
  begin
    fILManager.SortingProfilePtrs[lbProfiles.ItemIndex]^.Settings := fLocalSortSett;
    lbProfiles.Items[lbProfiles.ItemIndex] := Format('%s (%d)',
      [fILManager.SortingProfiles[lbProfiles.ItemIndex].Name,
       fILManager.SortingProfiles[lbProfiles.ItemIndex].Settings.Count]);
  end;
end;

//------------------------------------------------------------------------------

procedure TfSortForm.pmnProfilesPopup(Sender: TObject);
begin
pmi_PR_Rename.Enabled := lbProfiles.ItemIndex >= 0;
pmi_PR_Remove.Enabled := lbProfiles.ItemIndex >= 0;
pmi_PR_MoveUp.Enabled := lbProfiles.ItemIndex > 0;
pmi_PR_MoveDown.Enabled := (lbProfiles.Count > 0) and (lbProfiles.ItemIndex < Pred(lbProfiles.Count));
end;

//------------------------------------------------------------------------------

procedure TfSortForm.pmi_PR_AddClick(Sender: TObject);
var
  ProfileName:  String;
begin
If IL_InputQuery('Sorting profile name','Enter name for the new sorting profile:',ProfileName) then
  begin
    If Length(ProfileName) > 0 then
      begin
        fILManager.SortingProfileAdd(ProfileName);
        lbProfiles.Items.Add(Format('%s (%d)',
          [ProfileName,fILManager.SortingProfiles[Pred(fILManager.SortingProfileCount)].Settings.Count]));
        lbProfiles.ItemIndex := Pred(lbProfiles.Count);
        lbProfiles.OnClick(nil);
      end
    else MessageDlg('Empty name not allowed.',mtError,[mbOK],0);
  end;
end;

//------------------------------------------------------------------------------

procedure TfSortForm.pmi_PR_RenameClick(Sender: TObject);
var
  ProfileName:  String;
begin
If lbProfiles.ItemIndex >= 0 then
  begin
    ProfileName := fILManager.SortingProfiles[lbProfiles.ItemIndex].Name;
    If IL_InputQuery('Sorting profile name','Enter new sorting profile name:',ProfileName) then
      begin
        If Length(ProfileName) > 0 then
          begin
            fILManager.SortingProfileRename(lbProfiles.ItemIndex,ProfileName);
            lbProfiles.Items[lbProfiles.ItemIndex] := Format('%s (%d)',
              [ProfileName,fILManager.SortingProfiles[lbProfiles.ItemIndex].Settings.Count]);
          end
        else MessageDlg('Empty name not allowed.',mtError,[mbOK],0);
      end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfSortForm.pmi_PR_RemoveClick(Sender: TObject);
var
  Index:  Integer;
begin
If lbProfiles.ItemIndex >= 0 then
  If MessageDlg(Format('Are you sure you want to remove the sorting profile "%s"?',
                [fILManager.SortingProfiles[lbProfiles.ItemIndex].Name]),
                 mtConfirmation,[mbYes,mbNo],0) = mrYes then
    begin
      Index := lbProfiles.ItemIndex;
      If lbProfiles.ItemIndex < Pred(lbProfiles.Count) then
        lbProfiles.ItemIndex := lbProfiles.ItemIndex + 1
      else If lbProfiles.ItemIndex > 0 then
        lbProfiles.ItemIndex := lbProfiles.ItemIndex - 1
      else
        lbProfiles.ItemIndex := -1;
      lbProfiles.OnClick(nil);
      lbProfiles.Items.Delete(Index);
      fILManager.SortingProfileDelete(Index);
    end;
end;

//------------------------------------------------------------------------------

procedure TfSortForm.pmi_PR_MoveUpClick(Sender: TObject);
var
  Index:  Integer;
begin
If lbProfiles.ItemIndex > 0 then
  begin
    Index := lbProfiles.ItemIndex;
    lbProfiles.Items.Exchange(Index,Index - 1);
    fILManager.SortingProfileExchange(Index,Index - 1);
    lbProfiles.ItemIndex := Index - 1;
    lbProfiles.OnClick(nil);
  end;
end;

//------------------------------------------------------------------------------

procedure TfSortForm.pmi_PR_MoveDownClick(Sender: TObject);
var
  Index:  Integer;
begin
If (lbProfiles.Count > 0) and (lbProfiles.ItemIndex < Pred(lbProfiles.Count)) then
  begin
    Index := lbProfiles.ItemIndex;
    lbProfiles.Items.Exchange(Index,Index + 1);
    fILManager.SortingProfileExchange(Index,Index + 1);
    lbProfiles.ItemIndex := Index + 1;
    lbProfiles.OnClick(nil);
  end;
end;

//------------------------------------------------------------------------------

procedure TfSortForm.lbSortByDblClick(Sender: TObject);
begin
btnRemove.OnClick(nil);
end;

//------------------------------------------------------------------------------

procedure TfSortForm.btnMoveUpClick(Sender: TObject);
var
  Temp: TILSortingItem;
begin
If (lbSortBy.ItemIndex > 0) then
  begin
    Temp := fLocalSortSett.Items[lbSortBy.ItemIndex];
    fLocalSortSett.Items[lbSortBy.ItemIndex] := fLocalSortSett.Items[lbSortBy.ItemIndex - 1];
    fLocalSortSett.Items[lbSortBy.ItemIndex - 1] := Temp;
    lbSortBy.Items[lbSortBy.ItemIndex] :=
      fILManager.SortingItemStr(fLocalSortSett.Items[lbSortBy.ItemIndex]);
    lbSortBy.Items[lbSortBy.ItemIndex - 1] :=
      fILManager.SortingItemStr(fLocalSortSett.Items[lbSortBy.ItemIndex - 1]);
    lbSortBy.ItemIndex := lbSortBy.ItemIndex - 1;
  end;
end;

//------------------------------------------------------------------------------

procedure TfSortForm.btnAddClick(Sender: TObject);
begin
If (lbAvailable.ItemIndex > 0) and (fLocalSortSett.Count < Length(fLocalSortSett.Items)) then
  begin
    fLocalSortSett.Items[fLocalSortSett.Count].ItemValueTag := TILItemValueTag(lbAvailable.ItemIndex);
    fLocalSortSett.Items[fLocalSortSett.Count].Reversed := False;
    lbSortBy.Items.Add(fILManager.SortingItemStr(fLocalSortSett.Items[fLocalSortSett.Count]));
    lbSortBy.ItemIndex := Pred(lbSortBy.Count);
    Inc(fLocalSortSett.Count);
    UpdateNumbers;
  end;
end;

//------------------------------------------------------------------------------

procedure TfSortForm.btnToggleOrderClick(Sender: TObject);
begin
If (lbSortBy.ItemIndex >= 0) then
  begin
    fLocalSortSett.Items[lbSortBy.ItemIndex].Reversed :=
      not fLocalSortSett.Items[lbSortBy.ItemIndex].Reversed;
    lbSortBy.Items[lbSortBy.ItemIndex] :=
      fILManager.SortingItemStr(fLocalSortSett.Items[lbSortBy.ItemIndex]);
  end;
end;
 
//------------------------------------------------------------------------------

procedure TfSortForm.btnRemoveClick(Sender: TObject);
var
  i,Index:  Integer;
begin
If (lbSortBy.ItemIndex >= 0) then
  begin
    For i := lbSortBy.ItemIndex to (fLocalSortSett.Count - 2) do
      fLocalSortSett.Items[i] := fLocalSortSett.Items[i + 1];
    Dec(fLocalSortSett.Count);
    Index := lbSortBy.ItemIndex;
    If lbSortBy.ItemIndex < Pred(lbSortBy.Count) then
      lbSortBy.ItemIndex := lbSortBy.ItemIndex + 1
    else If lbSortBy.ItemIndex > 0 then
      lbSortBy.ItemIndex := lbSortBy.ItemIndex - 1
    else
      lbSortBy.ItemIndex := -1;
    lbSortBy.Items.Delete(Index);
    UpdateNumbers;
  end;
end;

//------------------------------------------------------------------------------

procedure TfSortForm.btnMoveDownClick(Sender: TObject);
var
  Temp: TILSortingItem;
begin
If (lbSortBy.ItemIndex < Pred(lbSortBy.Count)) then
  begin
    Temp := fLocalSortSett.Items[lbSortBy.ItemIndex];
    fLocalSortSett.Items[lbSortBy.ItemIndex] := fLocalSortSett.Items[lbSortBy.ItemIndex + 1];
    fLocalSortSett.Items[lbSortBy.ItemIndex + 1] := Temp;
    lbSortBy.Items[lbSortBy.ItemIndex] :=
      fILManager.SortingItemStr(fLocalSortSett.Items[lbSortBy.ItemIndex]);
    lbSortBy.Items[lbSortBy.ItemIndex + 1] :=
      fILManager.SortingItemStr(fLocalSortSett.Items[lbSortBy.ItemIndex + 1]);
    lbSortBy.ItemIndex := lbSortBy.ItemIndex + 1;
  end;
end;

//------------------------------------------------------------------------------

procedure TfSortForm.lbAvailableDblClick(Sender: TObject);
begin
btnAdd.OnClick(nil);
end;

//------------------------------------------------------------------------------

procedure TfSortForm.btnSortClick(Sender: TObject);
begin
Screen.Cursor := crHourGlass;
try
  fSorted := True;
  fILManager.ActualSortingSettings := fLocalSortSett;
  fILManager.ReversedSort := cbSortRev.Checked;
  fILManager.ItemSort;
finally
  Screen.Cursor := crDefault;
end;
Close;
end;

//------------------------------------------------------------------------------

procedure TfSortForm.btnCloseClick(Sender: TObject);
begin
Close;
end;

end.
