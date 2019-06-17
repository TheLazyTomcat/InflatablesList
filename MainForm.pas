unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, Spin, Menus, ActnList, XPMan,
  ItemFrame, UpdateForm,
  InflatablesList_Manager;

type
  TfMainForm = class(TForm)
    lbList: TListBox;    
    gbDetails: TGroupBox;
    sbStatusBar: TStatusBar;
    frmItemFrame: TfrmItemFrame;
    oXPManifest: TXPManifest;    
    pmnListMenu: TPopupMenu;
    mniLM_Add: TMenuItem;
    mniLM_AddCopy: TMenuItem;    
    mniLM_Remove: TMenuItem;
    mniLM_Clear: TMenuItem;
    N1: TMenuItem;
    mniLM_MoveBeginning: TMenuItem;
    mniLM_MoveUp: TMenuItem;
    mniLM_MoveDown: TMenuItem;
    mniLM_MoveEnd: TMenuItem;
    N2: TMenuItem;
    mniLM_ItemShops: TMenuItem;
    mniLM_ItemExport: TMenuItem;
    mniLM_ItemExportMulti: TMenuItem;
    mniLM_ItemImport: TMenuItem;
    N3: TMenuItem;
    mniLM_Find: TMenuItem;
    mniLM_FindPrev: TMenuItem;
    mniLM_FindNext: TMenuItem;
    N4: TMenuItem;
    mniLM_SortSett: TMenuItem;
    mniLM_SortRev: TMenuItem;
    mniLM_Sort: TMenuItem;
    mniLM_SortBy: TMenuItem;
    N5: TMenuItem;
    mniLM_UpdateItem: TMenuItem;
    mniLM_UpdateAll: TMenuItem;
    mniLM_UpdateWanted: TMenuItem;
    mniLN_UpdateSelected: TMenuItem;
    N6: TMenuItem;
    mniLN_UpdateItemShopHistory: TMenuItem;    
    mniLN_UpdateShopsHistory: TMenuItem;
    N7: TMenuItem;
    mniLM_Sums: TMenuItem;
    mniLM_Overview: TMenuItem;
    mniLM_Selection: TMenuItem;
    N8: TMenuItem;
    mniLM_Save: TMenuItem;
    mniLM_Specials: TMenuItem;
    N9: TMenuItem;
    mniLM_Exit: TMenuItem;
    mniLM_SB_Default: TMenuItem;
    mniLM_SB_Actual: TMenuItem;
    N1_1: TMenuItem;
    eSearchFor: TEdit;
    btnFindPrev: TButton;
    btnFindNext: TButton;
    alShortcuts: TActionList;
    acItemShops: TAction;
    acFind: TAction;
    acFindPrev: TAction;
    acFindNext: TAction;
    acSortSett: TAction;
    acSortRev: TAction;
    acSort: TAction;
    acSortBy: TAction;
    acUpdateItem: TAction;
    acUpdateAll: TAction;
    acUpdateWanted: TAction;
    acUpdateSelected: TAction;
    acUpdateItemShopHistory: TAction;
    acUpdateShopsHistory: TAction;
    acSums: TAction;
    acOverview: TAction;
    acSelection: TAction;    
    acSave: TAction;
    acSpecials: TAction;    
    acExit: TAction;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);    
    procedure pmnListMenuPopup(Sender: TObject);
    // ---
    procedure mniLM_AddClick(Sender: TObject);
    procedure mniLM_AddCopyClick(Sender: TObject);
    procedure mniLM_RemoveClick(Sender: TObject);
    procedure mniLM_ClearClick(Sender: TObject);
    // ---
    procedure mniLM_MoveBeginningClick(Sender: TObject);
    procedure mniLM_MoveUpClick(Sender: TObject);
    procedure mniLM_MoveDownClick(Sender: TObject);
    procedure mniLM_MoveEndClick(Sender: TObject);
    // ---
    procedure mniLM_ItemShopsClick(Sender: TObject);
    procedure mniLM_ItemExportClick(Sender: TObject);
    procedure mniLM_ItemExportMultiClick(Sender: TObject);
    procedure mniLM_ItemImportClick(Sender: TObject);
    // ---
    procedure mniLM_FindClick(Sender: TObject);
    procedure mniLM_FindPrevClick(Sender: TObject);
    procedure mniLM_FindNextClick(Sender: TObject);
    // ---
    procedure mniLM_SortSettClick(Sender: TObject);
    procedure mniLM_SortRevClick(Sender: TObject);
    procedure mniLM_SortClick(Sender: TObject);
    procedure mniLM_SortCommon(Profile: Integer);
    procedure mniLM_SortByClick(Sender: TObject);
    // ---
    procedure mniLN_UpdateCommon(UpdateList: TILItemShopUpdateList);
    procedure mniLM_UpdateItemClick(Sender: TObject);
    procedure mniLM_UpdateAllClick(Sender: TObject);
    procedure mniLM_UpdateWantedClick(Sender: TObject);
    procedure mniLN_UpdateSelectedClick(Sender: TObject);
    // ---
    procedure mniLN_UpdateItemShopHistoryClick(Sender: TObject);    
    procedure mniLN_UpdateShopsHistoryClick(Sender: TObject);
    // ---
    procedure mniLM_SumsClick(Sender: TObject);
    procedure mniLM_OverviewClick(Sender: TObject);
    procedure mniLM_SelectionClick(Sender: TObject);
    // ---
    procedure mniLM_SaveClick(Sender: TObject);
    procedure mniLM_SpecialsClick(Sender: TObject);
    // ---
    procedure mniLM_ExitClick(Sender: TObject);
    // ---
    procedure lbListClick(Sender: TObject);
    procedure lbListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lbListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure eSearchForEnter(Sender: TObject);
    procedure eSearchForExit(Sender: TObject);
    procedure eSearchForKeyPress(Sender: TObject; var Key: Char);
    procedure btnFindPrevClick(Sender: TObject);
    procedure btnFindNextClick(Sender: TObject);
    // ---
    procedure acItemShopsExecute(Sender: TObject);
    procedure acFindExecute(Sender: TObject);
    procedure acFindPrevExecute(Sender: TObject);
    procedure acFindNextExecute(Sender: TObject);
    procedure acSortSettExecute(Sender: TObject);
    procedure acSortRevExecute(Sender: TObject);
    procedure acSortExecute(Sender: TObject);
    procedure acSortByExecute(Sender: TObject);
    procedure acUpdateItemExecute(Sender: TObject);
    procedure acUpdateAllExecute(Sender: TObject);
    procedure acUpdateWantedExecute(Sender: TObject);
    procedure acUpdateSelectedExecute(Sender: TObject);
    procedure acUpdateItemShopHistoryExecute(Sender: TObject);
    procedure acUpdateShopsHistoryExecute(Sender: TObject);
    procedure acSumsExecute(Sender: TObject);
    procedure acOverviewExecute(Sender: TObject);
    procedure acSelectionExecute(Sender: TObject);
    procedure acSaveExecute(Sender: TObject);
    procedure acSpecialsExecute(Sender: TObject);    
    procedure acExitExecute(Sender: TObject);
  private
    fSaveOnExit:  Boolean;
    fILManager:   TILManager;
  protected
    procedure FillCopyright;
    procedure BuildSortBySubmenu;
    procedure InvalidateList(Sender: TObject);
    procedure ShowSelectedItem(Sender: TObject);
    procedure FocusList(Sender: TObject);
    procedure UpdateIndexAndCount;
    procedure SaveList;
  public
    procedure InitOtherForms;
  end;

var
  fMainForm: TfMainForm;

implementation

uses
  AuxTypes, WinFileInfo,
  TextEditForm, ShopsForm, ParsingForm, TemplatesForm, SortForm,
  SumsForm, SpecialsForm, OverviewForm, SelectionForm,
  InflatablesList_Types,
  InflatablesList_Backup;

{$R *.dfm}

const
  DEFAULT_LIST_FILENAME = 'list.inl';

//==============================================================================

procedure TfMainForm.FillCopyright;
begin
with TWinFileInfo.Create(WFI_LS_LoadVersionInfo or WFI_LS_LoadFixedFileInfo or WFI_LS_DecodeFixedFileInfo) do
try
  sbStatusBar.Panels[2].Text := Format('%s, version %d.%d.%d %s%s #%d %s',[
    VersionInfoValues[VersionInfoTranslations[0].LanguageStr,'LegalCopyright'],
    VersionInfoFixedFileInfoDecoded.FileVersionMembers.Major,
    VersionInfoFixedFileInfoDecoded.FileVersionMembers.Minor,
    VersionInfoFixedFileInfoDecoded.FileVersionMembers.Release,
    {$IFDEF FPC}'L'{$ELSE}'D'{$ENDIF},{$IFDEF x64}'64'{$ELSE}'32'{$ENDIF},
    VersionInfoFixedFileInfoDecoded.FileVersionMembers.Build,
    {$IFDEF Debug}'debug'{$ELSE}'release'{$ENDIF}]);
finally
  Free;
end;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.BuildSortBySubmenu;
var
  i:    Integer;
  Temp: TMenuItem;
begin
For i := Pred(mniLM_SortBy.Count) downto 0 do
  If mniLM_SortBy[i].Tag >= 0 then
    begin
      Temp := mniLM_SortBy[i];
      mniLM_SortBy.Delete(i);
      FreeAndNil(Temp);
    end;
For i := 0 to Pred(fILManager.SortingProfileCount) do
  begin
    Temp := TMenuItem.Create(Self);
    Temp.Name := Format('mniLM_SB_Profile%d',[i]);
    Temp.Caption := fILManager.SortingProfiles[i].Name;
    Temp.OnClick := mniLM_SortByClick;
    Temp.Tag := i;
    If i <= 9 then
      Temp.ShortCut := ShortCut(Ord('0') + ((i + 1) mod 10),[ssCtrl]);
    mniLM_SortBy.Add(Temp);
  end;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.InvalidateList(Sender: TObject);
begin
lbList.Invalidate;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.ShowSelectedItem(Sender: TObject);
begin
If lbList.ItemIndex >= 0 then
  begin
    If (lbList.ItemIndex < lbList.TopIndex) then
      lbList.TopIndex := lbList.ItemIndex
    else If lbList.ItemIndex >= (lbList.TopIndex + (lbList.ClientHeight div lbList.ItemHeight)) then
      lbList.TopIndex := Succ(lbList.ItemIndex - (lbList.ClientHeight div lbList.ItemHeight));
    lbList.SetFocus;
  end;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.FocusList(Sender: TObject);
begin
lbList.SetFocus;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.UpdateIndexAndCount;
begin
If lbList.ItemIndex < 0 then
  begin
    If fILManager.ItemCount > 0 then
      sbStatusBar.Panels[0].Text := Format('-/%d',[fILManager.ItemCount])
    else
      sbStatusBar.Panels[0].Text := '-/-';
  end
else sbStatusBar.Panels[0].Text := Format('%d/%d',[lbList.ItemIndex + 1,fILManager.ItemCount]);
end;

//------------------------------------------------------------------------------

procedure TfMainForm.SaveList;
begin
If FileExists(ExtractFilePath(ParamStr(0)) + DEFAULT_LIST_FILENAME) then
  DoBackup(ExtractFilePath(ParamStr(0)) + DEFAULT_LIST_FILENAME,
    IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)) + BACKUP_BACKUP_DIR_DEFAULT));
fILManager.SaveToFile(ExtractFilePath(ParamStr(0)) + DEFAULT_LIST_FILENAME);
end;

//==============================================================================

procedure TfMainForm.InitOtherForms;
begin
fTextEditForm.Initialize(fILManager);
fShopsForm.Initialize(fILManager);
fParsingForm.Initialize(fILManager);
fTemplatesForm.Initialize(fILManager);
fSortForm.Initialize(fILManager);
fSumsForm.Initialize(fILManager);
fSpecialsForm.Initialize(fILManager);
fOverviewForm.Initialize(fILManager);
fSelectionForm.Initialize(fIlManager);
fUpdateForm.Initialize(fILManager);
end;

//==============================================================================

procedure TfMainForm.FormCreate(Sender: TObject);
var
  i:  Integer;
begin
// prepare form
sbStatusBar.DoubleBuffered := True;
lbList.DoubleBuffered := True;
// build shortcuts
mniLM_MoveBeginning.ShortCut := ShortCut(VK_UP,[ssCtrl,ssShift]);
mniLM_MoveUp.ShortCut := ShortCut(VK_UP,[ssShift]);
mniLM_MoveDown.ShortCut := ShortCut(VK_DOWN,[ssShift]);
mniLM_MoveEnd.ShortCut := ShortCut(VK_DOWN,[ssCtrl,ssShift]);
mniLM_SortSett.ShortCut := ShortCut(Ord('O'),[ssCtrl,ssShift]);
mniLM_UpdateWanted.ShortCut := ShortCut(Ord('U'),[ssCtrl,ssShift]);
mniLN_UpdateSelected.ShortCut := ShortCut(Ord('U'),[ssAlt,ssShift]);
acSortSett.ShortCut := ShortCut(Ord('O'),[ssCtrl,ssShift]);
acUpdateWanted.ShortCut := ShortCut(Ord('U'),[ssCtrl,ssShift]);
acUpdateSelected.ShortCut := ShortCut(Ord('U'),[ssAlt,ssShift]);
FillCopyright;
eSearchFor.OnExit(nil);
// prepare variables/fields
fSaveOnExit := True;
fILManager := TILManager.Create;
fILManager.OnListUpdate := InvalidateList;
// prepare item frame
frmItemFrame.Initialize(fILManager);
frmItemFrame.OnShowSelectedItem := ShowSelectedItem;
frmItemFrame.OnFocusList := FocusList;
// load list
If FileExists(ExtractFilePath(ParamStr(0)) + DEFAULT_LIST_FILENAME) then
  fILManager.LoadFromFile(ExtractFilePath(ParamStr(0)) + DEFAULT_LIST_FILENAME);
sbStatusBar.Panels[1].Text := fILManager.FileName;
// fill list
lbList.Items.Clear;
If fILManager.ItemCount > 0 then
  begin
    lbList.Items.BeginUpdate;
    try
      For i := 0 to Pred(fILManager.ItemCount) do
        lbList.Items.Add(IntToStr(i));
    finally
      lbList.Items.EndUpdate;
    end;
    lbList.ItemIndex := 0;
    lbList.OnClick(nil);
  end
else frmItemFrame.SetItem(nil,True);
UpdateIndexAndCount;
// load other things from manager
mniLM_SortRev.Checked := fILManager.ReversedSort;
BuildSortBySubmenu;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.FormDestroy(Sender: TObject);
begin
frmItemFrame.SetItem(nil,True);
lbList.Items.Clear; // to be sure
If fSaveOnExit then
  SaveList;
FreeAndNil(fILManager);
end;

//------------------------------------------------------------------------------

procedure TfMainForm.FormShow(Sender: TObject);
begin
fILManager.ReinitDrawSize(lbList);
lbList.SetFocus;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.pmnListMenuPopup(Sender: TObject);
begin
mniLM_AddCopy.Enabled := lbList.ItemIndex >= 0;
mniLM_Remove.Enabled := lbList.ItemIndex >= 0;
mniLM_Clear.Enabled := lbList.Count > 0;
mniLM_MoveBeginning.Enabled := lbList.ItemIndex > 0;
mniLM_MoveUp.Enabled := lbList.ItemIndex > 0;
mniLM_MoveDown.Enabled := (lbList.ItemIndex >= 0) and (lbList.ItemIndex < Pred(lbList.Count));
mniLM_MoveEnd.Enabled := (lbList.ItemIndex >= 0) and (lbList.ItemIndex < Pred(lbList.Count));
mniLM_ItemShops.Enabled := lbList.ItemIndex >= 0;
mniLM_ItemExport.Enabled := lbList.ItemIndex >= 0;
mniLM_ItemExportMulti.Enabled := lbList.Count > 0;
mniLM_UpdateItem.Enabled := lbList.ItemIndex >= 0;
mniLN_UpdateItemShopHistory.Enabled := lbList.ItemIndex >= 0;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniLM_AddClick(Sender: TObject);
var
  Index:  Integer;
begin 
Index := lbList.ItemIndex;
If Index >= 0 then
  frmItemFrame.SetItem(fILManager[Index],False);
lbList.Items.Add(IntToStr(lbList.Count));  
lbList.ItemIndex := fILManager.ItemAddEmpty;
fILManager.ReinitDrawSize(lbList);  // will also redraw and update the list
lbList.OnClick(nil);
UpdateIndexAndCount;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniLM_AddCopyClick(Sender: TObject);
var
  Index:  Integer;
begin
If lbList.ItemIndex >= 0 then
  begin
    Index := lbList.ItemIndex;
    If Index >= 0 then
      frmItemFrame.SetItem(fILManager[Index],False);
    lbList.Items.Add(IntToStr(lbList.Count));
    lbList.ItemIndex := fILManager.ItemAddCopy(Index);
    fILManager.ReinitDrawSize(lbList);
    lbList.OnClick(nil);
    UpdateIndexAndCount;
  end;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniLM_RemoveClick(Sender: TObject);
var
  Index:  Integer;
begin
If lbList.ItemIndex >= 0 then
  If MessageDlg(Format('Are you sure you want to remove the item "%s"?',
       [fILManager[lbList.ItemIndex].TitleStr]),mtConfirmation,[mbYes,mbNo],0) = mrYes then
    begin
      frmItemFrame.SaveItem;
      frmItemFrame.SetItem(nil,False);
      Index := lbList.ItemIndex;
      fILManager.ItemDelete(Index);
      lbList.Items.Delete(Index);
      fILManager.ReinitDrawSize(lbList);
      If lbList.Count > 0 then
        begin
          If Index < lbList.Count then
            lbList.ItemIndex := Index
          else
            lbList.ItemIndex := Pred(lbList.Count);
        end
      else lbList.ItemIndex := -1;
      lbList.OnClick(nil);
      UpdateIndexAndCount;
    end;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniLM_ClearClick(Sender: TObject);
begin
If lbList.Count > 0 then
  If MessageDlg('Are you sure you want to clear the entire list?',
       mtConfirmation,[mbYes,mbNo],0) = mrYes then
    begin
      lbList.ItemIndex := -1;
      lbList.OnClick(nil);
      lbList.Items.Clear;
      fILManager.ItemClear;
      UpdateIndexAndCount;
    end;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniLM_MoveBeginningClick(Sender: TObject);
var
  Index:  Integer;
begin
If lbList.ItemIndex > 0 then
  begin
    Index := lbList.ItemIndex;
    lbList.Items.Move(Index,0);
    fILManager.ItemMove(Index,0);
    lbList.ItemIndex := 0;
    frmItemFrame.SetItem(fILManager[lbList.ItemIndex],False);
    lbList.Invalidate;
    UpdateIndexAndCount;
  end;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniLM_MoveUpClick(Sender: TObject);
var
  Index:  Integer;
begin
If lbList.ItemIndex > 0 then
  begin
    Index := lbList.ItemIndex;
    lbList.Items.Exchange(Index,Index - 1);
    fILManager.ItemExchange(Index,Index - 1);
    lbList.ItemIndex := Index - 1;
    frmItemFrame.SetItem(fILManager[lbList.ItemIndex],False);
    lbList.Invalidate;
    UpdateIndexAndCount;
  end;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniLM_MoveDownClick(Sender: TObject);
var
  Index:  Integer;
begin
If (lbList.ItemIndex >= 0) and (lbList.ItemIndex < Pred(lbList.Count)) then
  begin
    Index := lbList.ItemIndex;
    lbList.Items.Exchange(Index,Index + 1);
    fILManager.ItemExchange(Index,Index + 1);
    lbList.ItemIndex := Index + 1;
    frmItemFrame.SetItem(fILManager[lbList.ItemIndex],False);
    lbList.Invalidate;
    UpdateIndexAndCount;
  end;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniLM_MoveEndClick(Sender: TObject);
var
  Index:  Integer;
begin
If (lbList.ItemIndex >= 0) and (lbList.ItemIndex < Pred(lbList.Count)) then
  begin
    Index := lbList.ItemIndex;
    lbList.Items.Move(Index,Pred(lbList.Count));
    fILManager.ItemMove(Index,Pred(lbList.Count));
    lbList.ItemIndex := Pred(lbList.Count);
    frmItemFrame.SetItem(fILManager[lbList.ItemIndex],False);
    lbList.Invalidate;
    UpdateIndexAndCount;
  end;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniLM_ItemShopsClick(Sender: TObject);
begin
If lbList.ItemIndex >= 0 then
  begin
    frmItemFrame.SaveItem;
    fILManager[lbList.ItemIndex].BroadcastReqCount;
    fShopsForm.ShowShops(fILManager[lbList.ItemIndex]);
    // load potential changes
    frmItemFrame.LoadItem;
    fILManager[lbList.ItemIndex].ReDraw;
    lbList.SetFocus;
  end;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniLM_ItemExportClick(Sender: TObject);
begin
//
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniLM_ItemExportMultiClick(Sender: TObject);
begin
//
end;
 
//------------------------------------------------------------------------------

procedure TfMainForm.mniLM_ItemImportClick(Sender: TObject);
begin
//
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniLM_FindClick(Sender: TObject);
begin
eSearchFor.SetFocus;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniLM_FindPrevClick(Sender: TObject);
var
  Index:  Integer;
begin
If Length(eSearchFor.Text) > 0 then
  begin
    Index := fILManager.FindPrev(eSearchFor.Text,lbList.ItemIndex);
    If Index >= 0 then
      begin
        lbList.ItemIndex := Index;
        lbList.OnClick(nil);
      end
    else Beep;
  end;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniLM_FindNextClick(Sender: TObject);
var
  Index:  Integer;
begin
If Length(eSearchFor.Text) > 0 then
  begin
    Index := fILManager.FindNext(eSearchFor.Text,lbList.ItemIndex);
    If Index >= 0 then
      begin
        lbList.ItemIndex := Index;
        lbList.OnClick(nil);
      end
    else Beep;
  end;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniLM_SortSettClick(Sender: TObject);
begin
frmItemFrame.SaveItem;
frmItemFrame.SetItem(nil,False);  // not really needed, but to be sure
If fSortForm.ShowSortingSettings then
  begin
    // sorting was performed
    If lbList.ItemIndex >= 0 then
      begin
        frmItemFrame.SetItem(fILManager[lbList.ItemIndex],False);
        frmItemFrame.LoadItem;
      end;
    lbList.Invalidate;
    UpdateIndexAndCount;
  end
else
  begin
    If lbList.ItemIndex >= 0 then
      frmItemFrame.SetItem(fILManager[lbList.ItemIndex],False);
  end;
mniLM_SortRev.Checked := fILManager.ReversedSort;
BuildSortBySubmenu;
lbList.SetFocus;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniLM_SortRevClick(Sender: TObject);
begin
mniLM_SortRev.Checked := not mniLM_SortRev.Checked;
fILManager.ReversedSort := mniLM_SortRev.Checked;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniLM_SortClick(Sender: TObject);
begin
mniLM_SortCommon(-1);
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniLM_SortCommon(Profile: Integer);
begin
frmItemFrame.SaveItem;
frmItemFrame.SetItem(nil,False);  // not really needed, but to be sure
Screen.Cursor := crHourGlass;
try
  fILManager.ItemSort(Profile);
finally
  Screen.Cursor := crDefault;
end;
If lbList.ItemIndex >= 0 then
  begin
    frmItemFrame.SetItem(fILManager[lbList.ItemIndex],False);
    frmItemFrame.LoadItem;
  end;
lbList.Invalidate;
UpdateIndexAndCount;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniLM_SortByClick(Sender: TObject);
begin
If Sender is TMenuItem then
  mniLM_SortCommon(TMenuItem(Sender).Tag);
end;

//------------------------------------------------------------------------------
(*
procedure TfMainForm.mniLN_UpdateCommon(OnlyWanted,OnlySelected: Boolean);
var
  i,j,k:    Integer;
  Temp:     TILItemShopUpdateList;
  OldAvail: Int32;
  OldPrice: UInt32;
begin
frmItemFrame.SaveItem;
// preallocate array
k := 0;
For i := fILManager.ItemLowIndex to fILManager.ItemHighIndex do
  begin
    fILManager[i].BroadcastReqCount;
    If (ilifWanted in fILManager[i].Flags) or not OnlyWanted then
      For j := fILManager[i].ShopLowIndex to fILManager[i].ShopHighIndex do
        If fILManager[i].Shops[j].Selected or not OnlySelected then
          Inc(k);
  end;
SetLength(Temp,k);
// fill the array
k := 0;
For i := fILManager.ItemLowIndex to fILManager.ItemHighIndex do
  If (ilifWanted in fILManager[i].Flags) or not OnlyWanted then
    For j := fILManager[i].ShopLowIndex to fILManager[i].ShopHighIndex do
      If fILManager[i].Shops[j].Selected or not OnlySelected then
        begin
          Temp[k].ItemTitle := Format('[#%d] %s',[i + 1,fILManager[i].TitleStr]);
          Temp[k].ItemShop := fILManager[i].Shops[j];
          Temp[k].Done := False;
          Inc(k);
        end;
If Length(Temp) > 0 then
  begin
    // update
    fUpdateForm.ShowUpdate(Temp);
    // recalc prices
    For i := fILManager.ItemLowIndex to fILManager.ItemHighIndex do
      If ilifWanted in fILManager[i].Flags then
        begin
          OldAvail := fILManager[i].AvailableSelected;
          OldPrice := fILManager[i].UnitPriceSelected;
          fILManager[i].UpdatePriceAndAvail;
          fILManager[i].FlagPriceAndAvail(OldPrice,OldAvail);
        end;
    // show changes
    frmItemFrame.LoadItem;
  end
else MessageDlg('No shop to update.',mtInformation,[mbOK],0);
end;
*)
procedure TfMainForm.mniLN_UpdateCommon(UpdateList: TILItemShopUpdateList);
var
  i:        Integer;
  OldAvail: Int32;
  OldPrice: UInt32;
begin
If Length(UpdateList) > 0 then
  begin
    // update
    fUpdateForm.ShowUpdate(UpdateList);
    // recalc prices
    For i := fILManager.ItemLowIndex to fILManager.ItemHighIndex do
      begin
        OldAvail := fILManager[i].AvailableSelected;
        OldPrice := fILManager[i].UnitPriceSelected;
        fILManager[i].UpdatePriceAndAvail;
        fILManager[i].FlagPriceAndAvail(OldPrice,OldAvail);
      end;
    // show changes
    frmItemFrame.LoadItem;
  end
else MessageDlg('No shop to update.',mtInformation,[mbOK],0);
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniLM_UpdateItemClick(Sender: TObject);
var
  List: TILItemShopUpdateList;
  i:    Integer;
begin
If lbList.ItemIndex >= 0 then
  begin
    frmItemFrame.SaveItem;
    // create update list
    SetLength(List,fILManager[lbList.ItemIndex].ShopCount);
    fILManager[lbList.ItemIndex].BroadcastReqCount;
    For i := fILManager[lbList.ItemIndex].ShopLowIndex to fILManager[lbList.ItemIndex].ShopHighIndex do
      begin
        List[i].ItemTitle := Format('[#%d] %s',[i + 1,fILManager[lbList.ItemIndex].TitleStr]);
        List[i].ItemShop := fILManager[lbList.ItemIndex].Shops[i];
        List[i].Done := False;
      end;
    mniLN_UpdateCommon(List);
    lbList.SetFocus;
  end;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniLM_UpdateAllClick(Sender: TObject);
var
  List: TILItemShopUpdateList;
  i,j:  Integer;
  Cntr: Integer;
begin
frmItemFrame.SaveItem;
// prealocate update list
Cntr := 0;
For i := fILManager.ItemLowIndex to fILManager.ItemHighIndex do
  begin
    fILManager[i].BroadcastReqCount;
    For j := fILManager[i].ShopLowIndex to fILManager[i].ShopHighIndex do
      Inc(Cntr);
  end;
// create update list
SetLength(List,Cntr);
Cntr := Low(List);
For i := fILManager.ItemLowIndex to fILManager.ItemHighIndex do
  For j := fILManager[i].ShopLowIndex to fILManager[i].ShopHighIndex do
    begin
      List[Cntr].ItemTitle := Format('[#%d] %s',[i + 1,fILManager[i].TitleStr]);
      List[Cntr].ItemShop := fILManager[i].Shops[j];
      List[Cntr].Done := False;
      Inc(Cntr);
    end;
mniLN_UpdateCommon(List);
lbList.SetFocus;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniLM_UpdateWantedClick(Sender: TObject);
var
  List: TILItemShopUpdateList;
  i,j:  Integer;
  Cntr: Integer;
begin
frmItemFrame.SaveItem;
// prealocate update list
Cntr := 0;
For i := fILManager.ItemLowIndex to fILManager.ItemHighIndex do
  If ilifWanted in fILManager[i].Flags then
    begin
      fILManager[i].BroadcastReqCount;
      For j := fILManager[i].ShopLowIndex to fILManager[i].ShopHighIndex do
        Inc(Cntr);
    end;
// create update list
SetLength(List,Cntr);
Cntr := Low(List);
For i := fILManager.ItemLowIndex to fILManager.ItemHighIndex do
  If ilifWanted in fILManager[i].Flags then
    For j := fILManager[i].ShopLowIndex to fILManager[i].ShopHighIndex do
      begin
        List[Cntr].ItemTitle := Format('[#%d] %s',[i + 1,fILManager[i].TitleStr]);
        List[Cntr].ItemShop := fILManager[i].Shops[j];
        List[Cntr].Done := False;
        Inc(Cntr);
      end;
mniLN_UpdateCommon(List);
lbList.SetFocus;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniLN_UpdateSelectedClick(Sender: TObject);
var
  List: TILItemShopUpdateList;
  i,j:  Integer;
  Cntr: Integer;
begin
frmItemFrame.SaveItem;
// prealocate update list
Cntr := 0;
For i := fILManager.ItemLowIndex to fILManager.ItemHighIndex do
  begin
    fILManager[i].BroadcastReqCount;
    For j := fILManager[i].ShopLowIndex to fILManager[i].ShopHighIndex do
      If fILManager[i].Shops[j].Selected then
        Inc(Cntr);
  end;
// create update list
SetLength(List,Cntr);
Cntr := Low(List);
For i := fILManager.ItemLowIndex to fILManager.ItemHighIndex do
  For j := fILManager[i].ShopLowIndex to fILManager[i].ShopHighIndex do
    If fILManager[i].Shops[j].Selected then
      begin
        List[Cntr].ItemTitle := Format('[#%d] %s',[i + 1,fILManager[i].TitleStr]);
        List[Cntr].ItemShop := fILManager[i].Shops[j];
        List[Cntr].Done := False;
        Inc(Cntr);
      end;
mniLN_UpdateCommon(List);
lbList.SetFocus;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniLN_UpdateItemShopHistoryClick(Sender: TObject);
var
  i:  Integer;
begin
If lbList.ItemIndex >= 0 then
  begin
    Screen.Cursor := crHourGlass;
    try
      For i := fILManager[lbList.ItemIndex].ShopLowIndex to
               fILManager[lbList.ItemIndex].ShopHighIndex do
        fILManager[lbList.ItemIndex][i].UpdateAvailAndPriceHistory;
    finally
      Screen.Cursor := crDefault;
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniLN_UpdateShopsHistoryClick(Sender: TObject);
var
  i,j:  Integer;
begin
Screen.Cursor := crHourGlass;
try
  For i := fILManager.ItemLowIndex to fILManager.ItemHighIndex do
    For j := fILManager[i].ShopLowIndex to fILManager[i].ShopHighIndex do
      fILManager[i][j].UpdateAvailAndPriceHistory;
finally
  Screen.Cursor := crDefault;
end;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniLM_SumsClick(Sender: TObject);
begin
frmItemFrame.SaveItem;
fSumsForm.ShowSums;
lbList.SetFocus;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniLM_OverviewClick(Sender: TObject);
begin
fOverviewForm.Show;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniLM_SelectionClick(Sender: TObject);
begin
fSelectionForm.ShowTable;
lbList.SetFocus;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniLM_SaveClick(Sender: TObject);
begin
Screen.Cursor := crHourGlass;
try
  frmItemFrame.SaveItem;
  SaveList;
  sbStatusBar.Panels[1].Text := fILManager.FileName;
finally
  Screen.Cursor := crDefault;
end;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniLM_SpecialsClick(Sender: TObject);
begin
frmItemFrame.SaveItem;
fSpecialsForm.ShowModal;
frmItemFrame.LoadItem;
lbList.SetFocus;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniLM_ExitClick(Sender: TObject);
begin
fSaveOnExit := False;
Close;
end;


//------------------------------------------------------------------------------

procedure TfMainForm.lbListClick(Sender: TObject);
begin
If lbList.ItemIndex >= 0 then
  frmItemFrame.SetItem(fILManager[lbList.ItemIndex],True)
else
  frmItemFrame.SetItem(nil,True);
UpdateIndexAndCount;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.lbListMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Index:  Integer;
begin
If Button = mbRight then
  begin
    Index := lbList.ItemAtPos(Point(X,Y),True);
    If Index >= 0 then
      begin
        lbList.ItemIndex := Index;
        lbList.OnClick(nil);
      end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.lbListDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
// content
lbList.Canvas.Draw(Rect.Left,Rect.Top,fILManager.Items[Index].Render);
// separator line
lbList.Canvas.Pen.Style := psSolid;
lbList.Canvas.Pen.Color := clSilver;
lbList.Canvas.MoveTo(Rect.Left,Pred(Rect.Bottom));
lbList.Canvas.LineTo(Rect.Right,Pred(Rect.Bottom));
// states
If odSelected	in State then
  begin
    lbList.Canvas.Pen.Style := psClear;
    lbList.Canvas.Brush.Style := bsSolid;
    lbList.Canvas.Brush.Color := clLime;
    lbList.Canvas.Rectangle(Rect.Left,Rect.Top,Rect.Left + 11,Rect.Bottom);
  end;
If odFocused in State then
  begin
    lbList.Canvas.Pen.Style := psDot;
    lbList.Canvas.Pen.Color := clSilver;
    lbList.Canvas.Brush.Style := bsClear;
    lbList.Canvas.DrawFocusRect(Rect);
  end;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.eSearchForEnter(Sender: TObject);
begin
If eSearchFor.Tag = 0 then
  begin
    eSearchFor.Font.Color := clWindowText;
    eSearchFor.Text := '';
  end
end;

//------------------------------------------------------------------------------

procedure TfMainForm.eSearchForExit(Sender: TObject);
begin
If Length(eSearchFor.Text) <= 0 then
  begin
    eSearchFor.Font.Color := clGrayText;
    eSearchFor.Text := 'Search for...';
    eSearchFor.Tag := 0;
  end
else eSearchFor.Tag := 1;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.eSearchForKeyPress(Sender: TObject; var Key: Char);
begin
If Key = #13 then
  begin
    Key := #0;  
    mniLM_FindNext.OnClick(nil);
  end;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.btnFindPrevClick(Sender: TObject);
begin
mniLM_FindPrev.OnClick(nil);
end;

//------------------------------------------------------------------------------

procedure TfMainForm.btnFindNextClick(Sender: TObject);
begin
mniLM_FindNext.OnClick(nil);
end;

//------------------------------------------------------------------------------

procedure TfMainForm.acItemShopsExecute(Sender: TObject);
begin
mniLM_ItemShops.OnClick(nil);
end;
 
//------------------------------------------------------------------------------

procedure TfMainForm.acFindExecute(Sender: TObject);
begin
mniLM_Find.OnClick(nil);
end;

//------------------------------------------------------------------------------

procedure TfMainForm.acFindPrevExecute(Sender: TObject);
begin
mniLM_FindPrev.OnClick(nil);
end;
 
//------------------------------------------------------------------------------

procedure TfMainForm.acFindNextExecute(Sender: TObject);
begin
mniLM_FindNext.OnClick(nil);
end;

//------------------------------------------------------------------------------

procedure TfMainForm.acSortSettExecute(Sender: TObject);
begin
mniLM_SortSett.OnClick(nil);
end;

//------------------------------------------------------------------------------

procedure TfMainForm.acSortRevExecute(Sender: TObject);
begin
mniLM_SortRev.OnClick(nil);
end;

//------------------------------------------------------------------------------

procedure TfMainForm.acSortExecute(Sender: TObject);
begin
mniLM_Sort.OnClick(nil);
end;

//------------------------------------------------------------------------------

procedure TfMainForm.acSortByExecute(Sender: TObject);
begin
{$message 'implement'}
end;

//------------------------------------------------------------------------------

procedure TfMainForm.acUpdateItemExecute(Sender: TObject);
begin
mniLM_UpdateItem.OnClick(nil);
end;

//------------------------------------------------------------------------------

procedure TfMainForm.acUpdateAllExecute(Sender: TObject);
begin
mniLM_UpdateAll.OnClick(nil);
end;

//------------------------------------------------------------------------------

procedure TfMainForm.acUpdateWantedExecute(Sender: TObject);
begin
mniLM_UpdateWanted.OnClick(nil);
end;
 
//------------------------------------------------------------------------------

procedure TfMainForm.acUpdateSelectedExecute(Sender: TObject);
begin
mniLN_UpdateSelected.OnClick(nil);
end;

//------------------------------------------------------------------------------

procedure TfMainForm.acUpdateItemShopHistoryExecute(Sender: TObject);
begin
mniLN_UpdateItemShopHistory.OnClick(nil);
end;

//------------------------------------------------------------------------------

procedure TfMainForm.acUpdateShopsHistoryExecute(Sender: TObject);
begin
mniLN_UpdateShopsHistory.OnClick(nil);
end;

//------------------------------------------------------------------------------

procedure TfMainForm.acSumsExecute(Sender: TObject);
begin
mniLM_Sums.OnClick(nil);
end;

//------------------------------------------------------------------------------

procedure TfMainForm.acOverviewExecute(Sender: TObject);
begin
mniLM_Overview.OnClick(nil);
end;

//------------------------------------------------------------------------------

procedure TfMainForm.acSelectionExecute(Sender: TObject);
begin
mniLM_Selection.OnClick(nil);
end;

//------------------------------------------------------------------------------

procedure TfMainForm.acSaveExecute(Sender: TObject);
begin
mniLM_Save.OnClick(nil);
end;

//------------------------------------------------------------------------------

procedure TfMainForm.acSpecialsExecute(Sender: TObject);
begin
mniLM_Specials.OnClick(nil);
end;

//------------------------------------------------------------------------------

procedure TfMainForm.acExitExecute(Sender: TObject);
begin
mniLM_Exit.OnClick(nil);
end;

end.
