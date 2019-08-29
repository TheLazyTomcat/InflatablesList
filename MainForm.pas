unit MainForm;{$message 'revisit'}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, Spin, Menus, ActnList, XPMan,
  ItemFrame, UpdateForm,
  AuxTypes,
  InflatablesList_Manager;

type
  TfMainForm = class(TForm)
    lbList: TListBox;    
    gbDetails: TGroupBox;
    frmItemFrame: TfrmItemFrame;
    sbStatusBar: TStatusBar;
    oXPManifest: TXPManifest;
    pmnListMenu: TPopupMenu;
    mniLM_Add: TMenuItem;
    mniLM_AddCopy: TMenuItem;    
    mniLM_Remove: TMenuItem;
    mniLM_Clear: TMenuItem;
    N1: TMenuItem;
    mniLM_MoveBeginning: TMenuItem;
    mniLM_MoveUpBy: TMenuItem;
    mniLM_MoveUp: TMenuItem;
    mniLM_MoveDown: TMenuItem;
    mniLM_MoveDownBy: TMenuItem;    
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
    mniLM_AdvSearch: TMenuItem;
    N4: TMenuItem;
    mniLM_SortSett: TMenuItem;
    mniLM_SortRev: TMenuItem;
    mniLM_Sort: TMenuItem;
    mniLM_SortBy: TMenuItem;
    N5: TMenuItem;
    mniLM_UpdateItem: TMenuItem;
    mniLM_UpdateAll: TMenuItem;
    mniLM_UpdateWanted: TMenuItem;
    mniLM_UpdateSelected: TMenuItem;
    N6: TMenuItem;
    mniLM_UpdateItemShopHistory: TMenuItem;
    mniLM_UpdateShopsHistory: TMenuItem;
    N7: TMenuItem;
    mniLM_Sums: TMenuItem;
    mniLM_Overview: TMenuItem;
    mniLM_Selection: TMenuItem;
    N8: TMenuItem;
    mniLM_Notes: TMenuItem;    
    mniLM_Save: TMenuItem;
    mniLM_Specials: TMenuItem;
    N9: TMenuItem;
    mniLM_ResMarkLegend: TMenuItem;
    mniLM_OptionsLegend: TMenuItem;
    mniLM_About: TMenuItem;    
    N10: TMenuItem;
    mniLM_Exit: TMenuItem;
    mniLM_SB_Default: TMenuItem;
    mniLM_SB_Actual: TMenuItem;
    N1_1: TMenuItem;
    eSearchFor: TEdit;
    btnFindPrev: TButton;
    btnFindNext: TButton;
    alShortcuts: TActionList;
    acItemShops: TAction;
    acItemExport: TAction;
    acItemExportMulti: TAction;
    acItemImport: TAction;
    acFind: TAction;
    acFindPrev: TAction;
    acFindNext: TAction;
    acAdvSearch: TAction;    
    acSortSett: TAction;
    acSortRev: TAction;
    acSort: TAction;
    acUpdateItem: TAction;
    acUpdateAll: TAction;
    acUpdateWanted: TAction;
    acUpdateSelected: TAction;
    acUpdateItemShopHistory: TAction;
    acUpdateShopsHistory: TAction;
    acSums: TAction;
    acOverview: TAction;
    acSelection: TAction;
    acNotes: TAction;
    acSpecials: TAction;             
    acSave: TAction;
    acExit: TAction;
    acSortBy_0: TAction;
    acSortBy_1: TAction;
    acSortBy_2: TAction;
    acSortBy_3: TAction;
    acSortBy_4: TAction;
    acSortBy_5: TAction;
    acSortBy_6: TAction;
    acSortBy_7: TAction;
    acSortBy_8: TAction;
    acSortBy_9: TAction;
    diaItemsImport: TOpenDialog;
    diaItemsExport: TSaveDialog;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);      
    procedure pmnListMenuPopup(Sender: TObject);
    // ---
    procedure mniLM_AddClick(Sender: TObject);
    procedure mniLM_AddCopyClick(Sender: TObject);
    procedure mniLM_RemoveClick(Sender: TObject);
    procedure mniLM_ClearClick(Sender: TObject);
    // ---
    procedure mniLM_MoveBeginningClick(Sender: TObject);
    procedure mniLM_MoveUpByClick(Sender: TObject);
    procedure mniLM_MoveUpClick(Sender: TObject);
    procedure mniLM_MoveDownClick(Sender: TObject);
    procedure mniLM_MoveDownByClick(Sender: TObject);    
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
    procedure mniLM_AdvSearchClick(Sender: TObject);    
    // ---
    procedure mniLM_SortCommon(Profile: Integer);
    procedure mniLM_SortSettClick(Sender: TObject);
    procedure mniLM_SortRevClick(Sender: TObject);
    procedure mniLM_SortClick(Sender: TObject);
    procedure mniLM_SortByClick(Sender: TObject);
    // ---
    procedure mniLN_UpdateCommon(UpdateList: TILItemShopUpdateList);
    procedure mniLM_UpdateItemClick(Sender: TObject);
    procedure mniLM_UpdateAllClick(Sender: TObject);
    procedure mniLM_UpdateWantedClick(Sender: TObject);
    procedure mniLM_UpdateSelectedClick(Sender: TObject);
    // ---
    procedure mniLM_UpdateItemShopHistoryClick(Sender: TObject);
    procedure mniLM_UpdateShopsHistoryClick(Sender: TObject);
    // ---
    procedure mniLM_SumsClick(Sender: TObject);
    procedure mniLM_OverviewClick(Sender: TObject);
    procedure mniLM_SelectionClick(Sender: TObject);
    // ---
    procedure mniLM_NotesClick(Sender: TObject);
    procedure mniLM_SpecialsClick(Sender: TObject);
    procedure mniLM_SaveClick(Sender: TObject);
    // ---    
    procedure mniLM_ResMarkLegendClick(Sender: TObject);
    procedure mniLM_OptionsLegendClick(Sender: TObject);
    procedure mniLM_AboutClick(Sender: TObject);    
    // ---
    procedure mniLM_ExitClick(Sender: TObject);
    // ---
    procedure lbListClick(Sender: TObject);
    procedure lbListDblClick(Sender: TObject);    
    procedure lbListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lbListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure eSearchForEnter(Sender: TObject);
    procedure eSearchForExit(Sender: TObject);
    procedure eSearchForKeyPress(Sender: TObject; var Key: Char);
    procedure btnFindPrevClick(Sender: TObject);
    procedure btnFindNextClick(Sender: TObject);
    procedure sbStatusBarDrawPanel(StatusBar: TStatusBar;
      Panel: TStatusPanel; const Rect: TRect);
    procedure sbStatusBarMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    // ---
    procedure acItemShopsExecute(Sender: TObject);
    procedure acItemExportExecute(Sender: TObject);
    procedure acItemExportMultiExecute(Sender: TObject);
    procedure acItemImportExecute(Sender: TObject);    
    procedure acFindExecute(Sender: TObject);
    procedure acFindPrevExecute(Sender: TObject);
    procedure acFindNextExecute(Sender: TObject);
    procedure acAdvSearchExecute(Sender: TObject);
    procedure acSortSettExecute(Sender: TObject);
    procedure acSortRevExecute(Sender: TObject);
    procedure acSortExecute(Sender: TObject);
    procedure acUpdateItemExecute(Sender: TObject);
    procedure acUpdateAllExecute(Sender: TObject);
    procedure acUpdateWantedExecute(Sender: TObject);
    procedure acUpdateSelectedExecute(Sender: TObject);
    procedure acUpdateItemShopHistoryExecute(Sender: TObject);
    procedure acUpdateShopsHistoryExecute(Sender: TObject);
    procedure acSumsExecute(Sender: TObject);
    procedure acOverviewExecute(Sender: TObject);
    procedure acSelectionExecute(Sender: TObject);
    procedure acNotesExecute(Sender: TObject);
    procedure acSpecialsExecute(Sender: TObject);
    procedure acSaveExecute(Sender: TObject);
    procedure acExitExecute(Sender: TObject);
    procedure acSortByCommonExecute(Sender: TObject);
  private
    fSaveOnExit:  Boolean;
    fILManager:   TILManager;
    fActionMask:  UInt32;
  protected
    procedure RePositionMainForm;
    procedure FillCopyright;
    procedure FillListFileName(const FileName: String);
    procedure BuildSortBySubmenu;
    procedure UpdateIndexAndCount;
    Function SaveList: Boolean;
    // event handlers
    procedure InvalidateList(Sender: TObject);
    procedure ShowSelectedItem(Sender: TObject);
    procedure FocusList(Sender: TObject);
  public
    procedure InitializeOtherForms; // called before Application.Run from project file
    procedure FinalizeOtherForms;
  end;

var
  fMainForm: TfMainForm;

implementation

uses
  {$WARN UNIT_PLATFORM OFF}FileCtrl,{$WARN UNIT_PLATFORM ON} CommCtrl,
  WinFileInfo, BitOps, CountedDynArrayInteger, CountedDynArrayObject,
  TextEditForm, ShopsForm, ParsingForm, TemplatesForm, SortForm, SumsForm,
  SpecialsForm, OverviewForm, SelectionForm, ItemSelectForm, UpdResLegendForm,
  OptionsLegendForm, AboutForm, PromptForm,
  InflatablesList_Types,
  InflatablesList_Backup,
  InflatablesList_Item;

{$R *.dfm}

const
  DEFAULT_LIST_FILENAME = 'list.inl';

  STATUSBAR_PANEL_IDX_INDEX       = 0;
  STATUSBAR_PANEL_IDX_STATIC_OPTS = 1;
  STATUSBAR_PANEL_IDX_OPTIONS     = 2;
  STATUSBAR_PANEL_IDX_FILENAME    = 3;
  STATUSBAR_PANEL_IDX_COPYRIGHT   = 4;

//==============================================================================

procedure TfMainForm.RePositionMainForm;
var
  WorkRect:     TRect;
  WorkRectSize: TPoint;

  procedure PositionOnX;
  begin
    If Width > WorkRectSize.X then
      Left := WorkRect.Left
    else
      Left := WorkRect.Left + (WorkRectSize.X - Width) div 2;
  end;

begin
WorkRect := Screen.MonitorFromWindow(Self.Handle).WorkareaRect;
WorkRectSize := Point(WorkRect.Right - WorkRect.Left,WorkRect.Bottom - WorkRect.Top);
If Height > WorkRectSize.Y then
  begin
    Position := poDesigned;
    PositionOnX;
    Top := WorkRect.Top;
  end
else If BoundsRect.Bottom > WorkRect.Bottom then
  begin
    Position := poDesigned;
    PositionOnX;    
    Top := WorkRect.Top + (WorkRectSize.Y - Height) div 2;
  end;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.FillCopyright;
begin
with TWinFileInfo.Create(WFI_LS_LoadVersionInfo or WFI_LS_LoadFixedFileInfo or WFI_LS_DecodeFixedFileInfo) do
try
  sbStatusBar.Panels[STATUSBAR_PANEL_IDX_COPYRIGHT].Text := Format('%s, version %d.%d.%d %s%s #%d %s',[
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

procedure TfMainForm.FillListFileName(const FileName: String);
begin
If sbStatusBar.Canvas.TextWidth(FileName) >
  (sbStatusBar.Panels[STATUSBAR_PANEL_IDX_FILENAME].Width - (2 * GetSystemMetrics(SM_CXFIXEDFRAME))) then
  begin
    sbStatusBar.Panels[STATUSBAR_PANEL_IDX_FILENAME].Text :=
      MinimizeName(FileName,sbStatusBar.Canvas,
        sbStatusBar.Panels[STATUSBAR_PANEL_IDX_FILENAME].Width -
        (2 * GetSystemMetrics(SM_CXFIXEDFRAME)));
  end
else sbStatusBar.Panels[STATUSBAR_PANEL_IDX_FILENAME].Text := FileName;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.BuildSortBySubmenu;
var
  i:      Integer;
  MITemp: TMenuItem;
begin
// remove menu items
For i := Pred(mniLM_SortBy.Count) downto 0 do
  If mniLM_SortBy[i].Tag >= 0 then
    begin
      MITemp := mniLM_SortBy[i];
      mniLM_SortBy.Delete(i);
      FreeAndNil(MITemp);
    end;
fActionMask := 0;
For i := 0 to Pred(fILManager.SortingProfileCount) do
  begin
    MITemp := TMenuItem.Create(Self);
    MITemp.Name := Format('mniLM_SB_Profile%d',[i]);
    MITemp.Caption := fILManager.SortingProfiles[i].Name;
    MITemp.OnClick := mniLM_SortByClick;
    MITemp.Tag := i;
    If i <= 9 then
      MITemp.ShortCut := ShortCut(Ord('0') + ((i + 1) mod 10),[ssCtrl]);
    mniLM_SortBy.Add(MITemp);
    BitSetTo(fActionMask,Byte(i),True);
  end;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.UpdateIndexAndCount;
begin
If lbList.ItemIndex < 0 then
  begin
    If fILManager.ItemCount > 0 then
      sbStatusBar.Panels[STATUSBAR_PANEL_IDX_INDEX].Text := Format('-/%d',[fILManager.ItemCount])
    else
      sbStatusBar.Panels[STATUSBAR_PANEL_IDX_INDEX].Text := '-/-';
  end
else sbStatusBar.Panels[STATUSBAR_PANEL_IDX_INDEX].Text := Format('%d/%d',[lbList.ItemIndex + 1,fILManager.ItemCount]);
end;

//------------------------------------------------------------------------------

Function TfMainForm.SaveList: Boolean;
var
  FileName: String;
begin
Result := False;
If not fILManager.StaticOptions.NoSave then
  begin
    If Length(fILManager.StaticOptions.ListOverride) > 0 then
      FileName := fILManager.StaticOptions.ListOverride
    else
      FileName := fILManager.ListFilePath + DEFAULT_LIST_FILENAME;
    If not fILManager.StaticOptions.NoBackup then
      If FileExists(FileName) then
        DoBackup(FileName,IncludeTrailingPathDelimiter(fILManager.ListFilePath + BACKUP_BACKUP_DIR_DEFAULT));
    fILManager.SaveToFile(FileName);
    Result := True;
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

//==============================================================================

procedure TfMainForm.InitializeOtherForms;
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
fItemSelectForm.Initialize(fIlManager);
fUpdResLegendForm.Initialize(fIlManager);
fOptionsLegendForm.Initialize(fIlManager);
fAboutForm.Initialize(fIlManager);
end;

//------------------------------------------------------------------------------

procedure TfMainForm.FinalizeOtherForms;
begin
fTextEditForm.Finalize;
//fShopsForm.Finalize;
//fParsingForm.Finalize;
//fTemplatesForm.Finalize;
fSortForm.Finalize;
//fSumsForm.Finalize;
fSpecialsForm.Finalize;
fOverviewForm.Finalize;
//fSelectionForm.Finalize;
//fUpdateForm.Finalize;
fItemSelectForm.Finalize;
fUpdResLegendForm.Finalize;
fOptionsLegendForm.Finalize;
fAboutForm.Finalize;
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
mniLM_MoveBeginning.ShortCut := ShortCut(VK_UP,[ssShift,ssAlt]);
mniLM_MoveUpBy.ShortCut := ShortCut(VK_UP,[ssShift,ssCtrl]);
mniLM_MoveUp.ShortCut := ShortCut(VK_UP,[ssShift]);
mniLM_MoveDown.ShortCut := ShortCut(VK_DOWN,[ssShift]);
mniLM_MoveDownBy.ShortCut := ShortCut(VK_DOWN,[ssShift,ssCtrl]);
mniLM_MoveEnd.ShortCut := ShortCut(VK_DOWN,[ssShift,ssAlt]);
mniLM_SortSett.ShortCut := ShortCut(Ord('O'),[ssCtrl,ssShift]);
mniLM_UpdateWanted.ShortCut := ShortCut(Ord('U'),[ssCtrl,ssShift]);
mniLM_UpdateSelected.ShortCut := ShortCut(Ord('U'),[ssAlt,ssShift]);
acSortSett.ShortCut := ShortCut(Ord('O'),[ssCtrl,ssShift]);
acUpdateWanted.ShortCut := ShortCut(Ord('U'),[ssCtrl,ssShift]);
acUpdateSelected.ShortCut := ShortCut(Ord('U'),[ssAlt,ssShift]);
// shortcuts of sort-by actions
For i := 0 to Pred(ComponentCount) do
  If Components[i] is TAction then
    If AnsiSameText(TAction(Components[i]).Category,'sorting_by') then
      TAction(Components[i]).ShortCut :=
        ShortCut(Ord('0') + ((TAction(Components[i]).Tag + 1) mod 10),[ssCtrl]);
FillCopyright;
eSearchFor.OnExit(nil);
// prepare variables/fields
fSaveOnExit := True;
fILManager := TILManager.Create;
fILManager.OnMainListUpdate := InvalidateList;
// prepare item frame
frmItemFrame.Initialize(fILManager);
frmItemFrame.OnShowSelectedItem := ShowSelectedItem;
frmItemFrame.OnFocusList := FocusList;
// preload list and ask for password if necessary, catch EWrongPassword
// load list
If Length(fILManager.StaticOptions.ListOverride) > 0 then
  begin
    // overriden list
    If FileExists(fILManager.StaticOptions.ListOverride) then
      fILManager.LoadFromFile(fILManager.StaticOptions.ListOverride);
  end
else
  begin
    // default list
    If FileExists(fILManager.ListFilePath + DEFAULT_LIST_FILENAME) then
      fILManager.LoadFromFile(fILManager.ListFilePath + DEFAULT_LIST_FILENAME);
  end;
FillListFileName(fILManager.ListFileName);
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
sbStatusBar.Invalidate;
BuildSortBySubmenu;
RePositionMainForm;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.FormDestroy(Sender: TObject);
begin
frmItemFrame.SetItem(nil,True);
frmItemFrame.Finalize;
lbList.Items.Clear; // to be sure
If fSaveOnExit then
  SaveList;
FreeAndNil(fILManager);
end;

//------------------------------------------------------------------------------

procedure TfMainForm.FormShow(Sender: TObject);
begin
fILManager.ReinitDrawSize(lbList,fSelectionForm.lbItems);
lbList.SetFocus;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
FinalizeOtherForms;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.pmnListMenuPopup(Sender: TObject);
begin
mniLM_AddCopy.Enabled := lbList.ItemIndex >= 0;
mniLM_Remove.Enabled := lbList.ItemIndex >= 0;
mniLM_Clear.Enabled := lbList.Count > 0;
mniLM_MoveBeginning.Enabled := lbList.ItemIndex > 0;
mniLM_MoveUpBy.Enabled := lbList.ItemIndex > 0;
mniLM_MoveUp.Enabled := lbList.ItemIndex > 0;
mniLM_MoveDown.Enabled := (lbList.ItemIndex >= 0) and (lbList.ItemIndex < Pred(lbList.Count));
mniLM_MoveDownBy.Enabled := (lbList.ItemIndex >= 0) and (lbList.ItemIndex < Pred(lbList.Count));
mniLM_MoveEnd.Enabled := (lbList.ItemIndex >= 0) and (lbList.ItemIndex < Pred(lbList.Count));
mniLM_ItemShops.Enabled := lbList.ItemIndex >= 0;
mniLM_ItemExport.Enabled := lbList.ItemIndex >= 0;
mniLM_ItemExportMulti.Enabled := lbList.Count > 0;
mniLM_UpdateItem.Enabled := lbList.ItemIndex >= 0;
mniLM_UpdateItemShopHistory.Enabled := lbList.ItemIndex >= 0;
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
fILManager.ReinitDrawSize(lbList,fSelectionForm.lbItems); // will also redraw and update the list
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
    fILManager.ReinitDrawSize(lbList,fSelectionForm.lbItems);
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
      frmItemFrame.Save;
      frmItemFrame.SetItem(nil,False);
      Index := lbList.ItemIndex;
      fILManager.ItemDelete(Index);
      lbList.Items.Delete(Index);
      fILManager.ReinitDrawSize(lbList,fSelectionForm.lbItems);
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
       mtWarning,[mbYes,mbNo],0) = mrYes then
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

procedure TfMainForm.mniLM_MoveUpByClick(Sender: TObject);
var
  Index:  Integer;
  NewPos: Integer;
begin
If lbList.ItemIndex > 0 then
  begin
    Index := lbList.ItemIndex;
    If (Index - 10) >= 0 then
      NewPos := Index - 10
    else
      NewPos := 0;
    lbList.Items.Move(Index,NewPos);
    fILManager.ItemMove(Index,NewPos);
    lbList.ItemIndex := NewPos;
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

procedure TfMainForm.mniLM_MoveDownByClick(Sender: TObject);
var
  Index:  Integer;
  NewPos: Integer;
begin
If (lbList.ItemIndex >= 0) and (lbList.ItemIndex < Pred(lbList.Count)) then
  begin
    Index := lbList.ItemIndex;
    If (Index + 10) < lbList.Count then
      NewPos := Index + 10
    else
      NewPos := Pred(lbList.Count);
    lbList.Items.Move(Index,NewPos);
    fILManager.ItemMove(Index,NewPos);
    lbList.ItemIndex := NewPos;
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
    frmItemFrame.Save;
    fILManager[lbList.ItemIndex].BroadcastReqCount;
    fShopsForm.ShowShops(fILManager[lbList.ItemIndex]);
    // load potential changes
    frmItemFrame.Load;
    fILManager[lbList.ItemIndex].ReDraw;
    lbList.SetFocus;
  end;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniLM_ItemExportClick(Sender: TObject);
begin
If lbList.ItemIndex >= 0 then
  If diaItemsExport.Execute then
    begin
      frmItemFrame.Save;
      fILManager.ItemsExport(diaItemsExport.FileName,[lbList.ItemIndex]);
    end;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniLM_ItemExportMultiClick(Sender: TObject);
var
  Indices:    TCountedDynArrayInteger;
  IndicesArr: array of Integer;
  i:          Integer;
begin
frmItemFrame.Save;
CDA_Init(Indices);
fItemSelectForm.ShowItemSelect('Select items for export',Indices);
If CDA_Count(Indices) > 0 then
  If diaItemsExport.Execute then
    begin
      SetLength(IndicesArr,CDA_Count(Indices));
      For i := Low(IndicesArr) to High(IndicesArr) do
        IndicesArr[i] := CDA_GetItem(Indices,i);
      fILManager.ItemsExport(diaItemsExport.FileName,IndicesArr);
      MessageDlg(Format('%d items exported.',[Length(IndicesArr)]),mtInformation,[mbOK],0);
      lbList.SetFocus;
    end;
end;
 
//------------------------------------------------------------------------------

procedure TfMainForm.mniLM_ItemImportClick(Sender: TObject);
var
  Cntr,i: Integer;
begin
If diaItemsImport.Execute then
  begin
    If lbList.ItemIndex >= 0 then
      frmItemFrame.SetItem(fILManager[lbList.ItemIndex],False);
    Cntr := fILManager.ItemsImport(diaItemsImport.FileName);
    If Cntr > 0 then
      begin
        For i := 1 to Cntr do
          lbList.Items.Add(IntToStr(lbList.Count));
        lbList.ItemIndex := Pred(lbList.Count);
        fILManager.ReinitDrawSize(lbList,fSelectionForm.lbItems);
      end;
    lbList.OnClick(nil);
    UpdateIndexAndCount;
    If Cntr > 0 then
      MessageDlg(Format('%d items imported.',[Cntr]),mtInformation,[mbOK],0)
    else
      MessageDlg('No item imported.',mtInformation,[mbOK],0)
  end;
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
    Screen.Cursor := crHourGlass;
    try
      Index := fILManager.FindPrev(eSearchFor.Text,lbList.ItemIndex);
    finally
      Screen.Cursor := crDefault;
    end;      
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
    Screen.Cursor := crHourGlass;
    try
      Index := fILManager.FindNext(eSearchFor.Text,lbList.ItemIndex);
    finally
      Screen.Cursor := crDefault;
    end;
    If Index >= 0 then
      begin
        lbList.ItemIndex := Index;
        lbList.OnClick(nil);
      end
    else Beep;
  end;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniLM_AdvSearchClick(Sender: TObject);
begin
{$message 'implement'}
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniLM_SortCommon(Profile: Integer);
begin
frmItemFrame.Save;
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
    frmItemFrame.Load;
  end;
lbList.Invalidate;
UpdateIndexAndCount;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniLM_SortSettClick(Sender: TObject);
begin
frmItemFrame.Save;
frmItemFrame.SetItem(nil,False);  // not really needed, but to be sure
If fSortForm.ShowSortingSettings then
  begin
    // sorting was performed
    If lbList.ItemIndex >= 0 then
      begin
        frmItemFrame.SetItem(fILManager[lbList.ItemIndex],False);
        frmItemFrame.Load;
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
sbStatusBar.Invalidate;
BuildSortBySubmenu;
lbList.SetFocus;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniLM_SortRevClick(Sender: TObject);
begin
mniLM_SortRev.Checked := not mniLM_SortRev.Checked;
fILManager.ReversedSort := mniLM_SortRev.Checked;
sbStatusBar.Invalidate;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniLM_SortClick(Sender: TObject);
begin
mniLM_SortCommon(-1);
lbList.SetFocus;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniLM_SortByClick(Sender: TObject);
begin
If Sender is TMenuItem then
  begin
    mniLM_SortCommon(TMenuItem(Sender).Tag);
    lbList.SetFocus;
  end;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniLN_UpdateCommon(UpdateList: TILItemShopUpdateList);
var
  i:        Integer;
  OldAvail: Int32;
  OldPrice: UInt32;
  ItemList: TCountedDynArrayObject;
begin
If Length(UpdateList) > 0 then
  begin
    // update
    fUpdateForm.ShowUpdate(UpdateList);
    // build list of updated items
    CDA_Init(ItemList);
    For i := Low(UpdateList) to High(UpdateList) do
      If UpdateList[i].Done and not CDA_CheckIndex(ItemList,CDA_IndexOf(ItemList,UpdateList[i].Item)) then
        CDA_Add(ItemList,UpdateList[i].Item);
    // recalc prices
    For i := CDA_Low(ItemList) to CDA_High(ItemList) do
      begin
        OldAvail := TILItem(CDA_GetItem(ItemList,i)).AvailableSelected;
        OldPrice := TILItem(CDA_GetItem(ItemList,i)).UnitPriceSelected;
        //TILItem(CDA_GetItem(ItemList,i)).UpdatePriceAndAvail;
        //TILItem(CDA_GetItem(ItemList,i)).FlagPriceAndAvail(OldPrice,OldAvail);
      end;
    // show changes
    frmItemFrame.Load;
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
    frmItemFrame.Save;
    // create update list
    SetLength(List,fILManager[lbList.ItemIndex].ShopCount);
    fILManager[lbList.ItemIndex].BroadcastReqCount;
    For i := fILManager[lbList.ItemIndex].ShopLowIndex to fILManager[lbList.ItemIndex].ShopHighIndex do
      begin
        List[i].Item := fILManager[lbList.ItemIndex];
        List[i].ItemTitle := Format('[#%d] %s',[lbList.ItemIndex + 1,fILManager[lbList.ItemIndex].TitleStr]);
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
frmItemFrame.Save;
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
      List[Cntr].Item := fILManager[i];
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
frmItemFrame.Save;
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
        List[Cntr].Item := fILManager[i];
        List[Cntr].ItemTitle := Format('[#%d] %s',[i + 1,fILManager[i].TitleStr]);
        List[Cntr].ItemShop := fILManager[i].Shops[j];
        List[Cntr].Done := False;
        Inc(Cntr);
      end;
mniLN_UpdateCommon(List);
lbList.SetFocus;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniLM_UpdateSelectedClick(Sender: TObject);
var
  List: TILItemShopUpdateList;
  i,j:  Integer;
  Cntr: Integer;
begin
frmItemFrame.Save;
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
        List[Cntr].Item := fILManager[i];
        List[Cntr].ItemTitle := Format('[#%d] %s',[i + 1,fILManager[i].TitleStr]);
        List[Cntr].ItemShop := fILManager[i].Shops[j];
        List[Cntr].Done := False;
        Inc(Cntr);
      end;
mniLN_UpdateCommon(List);
lbList.SetFocus;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniLM_UpdateItemShopHistoryClick(Sender: TObject);
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

procedure TfMainForm.mniLM_UpdateShopsHistoryClick(Sender: TObject);
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
frmItemFrame.Save;
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
frmItemFrame.Save;
fSelectionForm.ShowSelection;
// load potential changes
frmItemFrame.Load;
lbList.Invalidate;
lbList.SetFocus;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniLM_NotesClick(Sender: TObject);
var
  Temp: String;
begin
Temp := fILManager.Notes;
fTextEditForm.ShowTextEditor('Inflatables list notes',Temp,False);
fILManager.Notes := Temp;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniLM_SpecialsClick(Sender: TObject);
begin
frmItemFrame.Save;
fSpecialsForm.ShowModal;
frmItemFrame.Load;
lbList.SetFocus;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniLM_SaveClick(Sender: TObject);
begin
Screen.Cursor := crHourGlass;
try
  frmItemFrame.Save;
  If not SaveList then
    Beep;
  FillListFileName(fILManager.ListFileName);
finally
  Screen.Cursor := crDefault;
end;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniLM_ResMarkLegendClick(Sender: TObject);
begin
fUpdResLegendForm.ShowLegend;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniLM_OptionsLegendClick(Sender: TObject);
begin
fOptionsLegendForm.ShowLegend;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniLM_AboutClick(Sender: TObject);
begin
fAboutForm.ShowInfo;
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

procedure TfMainForm.lbListDblClick(Sender: TObject);
begin
mniLM_ItemShops.OnClick(nil);
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

procedure TfMainForm.sbStatusBarDrawPanel(StatusBar: TStatusBar;
  Panel: TStatusPanel; const Rect: TRect);
const
  STAT_OPTS_SPC = 5;
var
  i:        Integer;
  TempInt:  Integer;

  procedure DrawOptText(const Text: String; var Left: Integer; Enabled: Boolean; Shift: Integer = 0);
  begin
    If Enabled then
      sbStatusBar.Canvas.Font.Color := sbStatusBar.Font.Color
    else
      sbStatusBar.Canvas.Font.Color := clGrayText;
    sbStatusBar.Canvas.TextOut(Left,Rect.Top,Text);
    If Shift > 0 then
      Inc(Left,sbStatusBar.Canvas.TextWidth(Text) + Shift);
  end;

begin
case Panel.Index of
  STATUSBAR_PANEL_IDX_STATIC_OPTS:
    with sbStatusBar.Canvas do
      begin
        TempInt := 0;
        For i := Low(IL_STAT_OPT_TAGS) to High(IL_STAT_OPT_TAGS) do
          If i < High(IL_STAT_OPT_TAGS) then
            Inc(TempInt,TextWidth(IL_STAT_OPT_TAGS[i]) + STAT_OPTS_SPC)
          else
            Inc(TempInt,TextWidth(IL_STAT_OPT_TAGS[i]));
        TempInt := Rect.Left + (Rect.Right - Rect.Left - TempInt) div 2;
        Brush.Style := bsClear;
        Pen.Style := psClear;           
        DrawOptText(IL_STAT_OPT_TAGS[0],TempInt,fILManager.StaticOptions.NoPictures,STAT_OPTS_SPC);
        DrawOptText(IL_STAT_OPT_TAGS[1],TempInt,fILManager.StaticOptions.TestCode,STAT_OPTS_SPC);
        DrawOptText(IL_STAT_OPT_TAGS[2],TempInt,fILManager.StaticOptions.SavePages,STAT_OPTS_SPC);
        DrawOptText(IL_STAT_OPT_TAGS[3],TempInt,fILManager.StaticOptions.LoadPages,STAT_OPTS_SPC);
        DrawOptText(IL_STAT_OPT_TAGS[4],TempInt,fILManager.StaticOptions.NoSave,STAT_OPTS_SPC);
        DrawOptText(IL_STAT_OPT_TAGS[5],TempInt,fILManager.StaticOptions.NoBackup,STAT_OPTS_SPC);
        DrawOptText(IL_STAT_OPT_TAGS[6],TempInt,fILManager.StaticOptions.NoUpdateAutoLog,STAT_OPTS_SPC);
        DrawOptText(IL_STAT_OPT_TAGS[7],TempInt,Length(fILManager.StaticOptions.ListOverride) > 0,STAT_OPTS_SPC);
      end;
  STATUSBAR_PANEL_IDX_OPTIONS:
    with sbStatusBar.Canvas do
      begin
        TempInt := Rect.Left + (Rect.Right - Rect.Left - TextWidth('s.rev')) div 2;
        Brush.Style := bsClear;
        Pen.Style := psClear;
        DrawOptText('s.rev',TempInt,fILManager.ReversedSort);
      end;
end;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.sbStatusBarMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  i,Index:    Integer;
  PanelRect:  Windows.TRect;

  Function PointInRect(X,Y: Integer; Rect: Windows.TRect): Boolean;
  begin
    Result := (X >= Rect.Left) and (X <= Rect.Right) and
              (Y >= Rect.Top) and (Y <= Rect.Bottom); 
  end;
  
begin
If Button = mbLeft then
  begin
    Index := -1;
    // get index of clicked panel
    For i := 0 to Pred(sbStatusBar.Panels.Count) do
      If SendMessage(sbStatusBar.Handle,SB_GETRECT,wParam(i),lParam(@PanelRect)) <> 0 then
        If PointInRect(X,Y,PanelRect) then
          begin
            Index := i;
            Break{For i};
          end;
    case Index of
      STATUSBAR_PANEL_IDX_STATIC_OPTS,
      STATUSBAR_PANEL_IDX_OPTIONS:      mniLM_OptionsLegend.OnClick(nil);
      STATUSBAR_PANEL_IDX_COPYRIGHT:    mniLM_About.OnClick(nil);
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.acItemShopsExecute(Sender: TObject);
begin
mniLM_ItemShops.OnClick(nil);
end;

//------------------------------------------------------------------------------

procedure TfMainForm.acItemExportExecute(Sender: TObject);
begin
mniLM_ItemExport.OnClick(nil);
end;

//------------------------------------------------------------------------------

procedure TfMainForm.acItemExportMultiExecute(Sender: TObject);
begin
mniLM_ItemExportMulti.OnClick(nil);
end;

//------------------------------------------------------------------------------

procedure TfMainForm.acItemImportExecute(Sender: TObject);
begin
mniLM_ItemImport.OnClick(nil);
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

procedure TfMainForm.acAdvSearchExecute(Sender: TObject);
begin
mniLM_AdvSearch.OnClick(nil);
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
mniLM_UpdateSelected.OnClick(nil);
end;

//------------------------------------------------------------------------------

procedure TfMainForm.acUpdateItemShopHistoryExecute(Sender: TObject);
begin
mniLM_UpdateItemShopHistory.OnClick(nil);
end;

//------------------------------------------------------------------------------

procedure TfMainForm.acUpdateShopsHistoryExecute(Sender: TObject);
begin
mniLM_UpdateShopsHistory.OnClick(nil);
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

procedure TfMainForm.acNotesExecute(Sender: TObject);
begin
mniLM_Notes.OnClick(nil);
end;

//------------------------------------------------------------------------------

procedure TfMainForm.acSpecialsExecute(Sender: TObject);
begin
mniLM_Specials.OnClick(nil);
end;

//------------------------------------------------------------------------------

procedure TfMainForm.acSaveExecute(Sender: TObject);
begin
mniLM_Save.OnClick(nil);
end;

//------------------------------------------------------------------------------

procedure TfMainForm.acExitExecute(Sender: TObject);
begin
mniLM_Exit.OnClick(nil);
end;

//------------------------------------------------------------------------------

procedure TfMainForm.acSortByCommonExecute(Sender: TObject);
begin
If Sender is TAction then
  If BT(fActionMask,Byte(TAction(Sender).Tag)) then
    begin
      mniLM_SortCommon(TAction(Sender).Tag);
      lbList.SetFocus;
    end;
end;

end.
