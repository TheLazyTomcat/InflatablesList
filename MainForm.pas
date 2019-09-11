unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, Spin, Menus, ActnList, XPMan,
  ItemFrame, UpdateForm,
  AuxTypes,
  InflatablesList_Manager;
            
type
  TfMainForm = class(TForm)
    mmMainMenu: TMainMenu;
    mniMM_File: TMenuItem;
    mniMMF_ListCompress: TMenuItem;
    mniMMF_ListEncrypt: TMenuItem;
    mniMMF_ListPassword: TMenuItem;
    N1: TMenuItem;
    mniMMF_SaveOnClose: TMenuItem;
    mniMMF_Save: TMenuItem;
    N2: TMenuItem;
    mniMMF_Exit: TMenuItem;
    mniMM_List: TMenuItem;
    mniMML_Add: TMenuItem;
    mniMML_AddCopy: TMenuItem;
    mniMML_Remove: TMenuItem;
    mniMML_Clear: TMenuItem;
    N3: TMenuItem;
    mniMML_Sums: TMenuItem;
    mniMML_Overview: TMenuItem;
    mniMML_Notes: TMenuItem;
    mniMM_Item: TMenuItem;
    mniMMI_ItemShops: TMenuItem;
    mniMMI_ItemExport: TMenuItem;
    mniMMI_ItemExportMulti: TMenuItem;
    mniMMI_ItemImport: TMenuItem;
    N4: TMenuItem;
    mniMMI_MoveBeginning: TMenuItem;
    mniMMI_MoveUpBy: TMenuItem;
    mniMMI_MoveUp: TMenuItem;
    mniMMI_MoveDown: TMenuItem;
    mniMMI_MoveDownBy: TMenuItem;
    mniMMI_MoveEnd: TMenuItem;
    mniMM_Search: TMenuItem;
    mniMMS_Find: TMenuItem;
    mniMMS_FindPrev: TMenuItem;
    mniMMS_FindNext: TMenuItem;
    mniMMS_AdvSearch: TMenuItem;
    mniMM_Sorting: TMenuItem;
    mniMMO_SortSett: TMenuItem;
    mniMMO_SortRev: TMenuItem;
    mniMMO_SortCase: TMenuItem;
    mniMMO_Sort: TMenuItem;
    mniMMO_SortBy: TMenuItem;
    mniMMO_SB_Default: TMenuItem;
    mniMMO_SB_Actual: TMenuItem;
    N1_1: TMenuItem;
    mniMM_Update: TMenuItem;
    mniMMU_UpdateItem: TMenuItem;
    mniMMU_UpdateAll: TMenuItem;
    mniMMU_UpdateWanted: TMenuItem;
    mniMMU_UpdateSelected: TMenuItem;
    N5: TMenuItem;
    mniMMU_UpdateItemShopHistory: TMenuItem;
    mniMMU_UpdateShopsHistory: TMenuItem;
    mniMM_Tools: TMenuItem;
    mniMMT_Selection: TMenuItem;
    mniMMT_Specials: TMenuItem;
    mniMM_Help: TMenuItem;
    mniMMH_ResMarkLegend: TMenuItem;
    mniMMH_SettingsLegend: TMenuItem;
    N6: TMenuItem;
    mniMMH_About: TMenuItem;
    // ---
    alShortcuts: TActionList;
    acSave: TAction;
    acExit: TAction;
    acItemShops: TAction;
    acItemExport: TAction;
    acItemExportMulti: TAction;
    acItemImport: TAction;
    acSums: TAction;
    acOverview: TAction;
    acNotes: TAction;
    acFind: TAction;
    acFindPrev: TAction;
    acFindNext: TAction;
    acAdvSearch: TAction;
    acSortSett: TAction;
    acSortRev: TAction;
    acSortCase: TAction;
    acSort: TAction;
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
    acSelection: TAction;
    acSpecials: TAction;
    acUpdateItem: TAction;
    acUpdateAll: TAction;
    acUpdateWanted: TAction;
    acUpdateSelected: TAction;
    acUpdateItemShopHistory: TAction;
    acUpdateShopsHistory: TAction;
    // ---    
    diaItemsImport: TOpenDialog;
    diaItemsExport: TSaveDialog;
    oXPManifest: TXPManifest;    
    lbList: TListBox;
    eSearchFor: TEdit;
    btnFindPrev: TButton;
    btnFindNext: TButton;
    gbDetails: TGroupBox;
    frmItemFrame: TfrmItemFrame;
    sbStatusBar: TStatusBar;
    shpListFiller: TShape;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    // ---
    procedure mniMM_FileClick(Sender: TObject);
    procedure mniMMF_ListCompressClick(Sender: TObject);
    procedure mniMMF_ListEncryptClick(Sender: TObject);
    procedure mniMMF_ListPasswordClick(Sender: TObject);
    procedure mniMMF_SaveOnCloseClick(Sender: TObject);    
    procedure mniMMF_SaveClick(Sender: TObject);
    procedure mniMMF_ExitClick(Sender: TObject);
    // ---
    procedure mniMM_ListClick(Sender: TObject);
    procedure mniMML_AddClick(Sender: TObject);
    procedure mniMML_AddCopyClick(Sender: TObject);
    procedure mniMML_RemoveClick(Sender: TObject);
    procedure mniMML_ClearClick(Sender: TObject);
    procedure mniMML_SumsClick(Sender: TObject);
    procedure mniMML_OverviewClick(Sender: TObject);
    procedure mniMML_NotesClick(Sender: TObject);    
    // ---
    procedure mniMM_ItemClick(Sender: TObject);
    procedure mniMMI_ItemShopsClick(Sender: TObject);
    procedure mniMMI_ItemExportClick(Sender: TObject);
    procedure mniMMI_ItemExportMultiClick(Sender: TObject);
    procedure mniMMI_ItemImportClick(Sender: TObject);
    procedure mniMMI_MoveBeginningClick(Sender: TObject);
    procedure mniMMI_MoveUpByClick(Sender: TObject);
    procedure mniMMI_MoveUpClick(Sender: TObject);
    procedure mniMMI_MoveDownClick(Sender: TObject);
    procedure mniMMI_MoveDownByClick(Sender: TObject);
    procedure mniMMI_MoveEndClick(Sender: TObject);
    // ---
    procedure mniMM_SearchClick(Sender: TObject);
    procedure mniMMS_FindClick(Sender: TObject);
    procedure mniMMS_FindPrevClick(Sender: TObject);
    procedure mniMMS_FindNextClick(Sender: TObject);
    procedure mniMMS_AdvSearchClick(Sender: TObject);
    // ---
    procedure mniMM_SortingClick(Sender: TObject);
    procedure mniMMO_SortCommon(Profile: Integer);
    procedure mniMMO_SortSettClick(Sender: TObject);
    procedure mniMMO_SortRevClick(Sender: TObject);
    procedure mniMMO_SortCaseClick(Sender: TObject);
    procedure mniMMO_SortClick(Sender: TObject);
    procedure mniMMO_SortByClick(Sender: TObject);
    // ---
    procedure mniMM_UpdateClick(Sender: TObject);
    procedure mniMMU_UpdateCommon(UpdateList: TILItemShopUpdateList);
    procedure mniMMU_UpdateItemClick(Sender: TObject);
    procedure mniMMU_UpdateAllClick(Sender: TObject);
    procedure mniMMU_UpdateWantedClick(Sender: TObject);
    procedure mniMMU_UpdateSelectedClick(Sender: TObject);
    procedure mniMMU_UpdateItemShopHistoryClick(Sender: TObject);
    procedure mniMMU_UpdateShopsHistoryClick(Sender: TObject);
    // ---
    procedure mniMM_ToolsClick(Sender: TObject);
    procedure mniMMT_SelectionClick(Sender: TObject);
    procedure mniMMT_SpecialsClick(Sender: TObject);
    // ---
    procedure mniMM_HelpClick(Sender: TObject);
    procedure mniMMH_ResMarkLegendClick(Sender: TObject);
    procedure mniMMH_SettingsLegendClick(Sender: TObject);
    procedure mniMMH_AboutClick(Sender: TObject);
    // ---
    procedure acSaveExecute(Sender: TObject);
    procedure acExitExecute(Sender: TObject);
    // ---
    procedure acItemShopsExecute(Sender: TObject);
    procedure acItemExportExecute(Sender: TObject);
    procedure acItemExportMultiExecute(Sender: TObject);
    procedure acItemImportExecute(Sender: TObject);
    // ---
    procedure acSumsExecute(Sender: TObject);
    procedure acOverviewExecute(Sender: TObject);
    procedure acNotesExecute(Sender: TObject);
    // ---
    procedure acFindExecute(Sender: TObject);
    procedure acFindPrevExecute(Sender: TObject);
    procedure acFindNextExecute(Sender: TObject);
    procedure acAdvSearchExecute(Sender: TObject);
    // ---
    procedure acSortSettExecute(Sender: TObject);
    procedure acSortRevExecute(Sender: TObject);
    procedure acSortCaseExecute(Sender: TObject);
    procedure acSortExecute(Sender: TObject);
    // ---
    procedure acSortByCommonExecute(Sender: TObject);
    // ---
    procedure acSelectionExecute(Sender: TObject);
    procedure acSpecialsExecute(Sender: TObject);
    // ---
    procedure acUpdateItemExecute(Sender: TObject);
    procedure acUpdateAllExecute(Sender: TObject);
    procedure acUpdateWantedExecute(Sender: TObject);
    procedure acUpdateSelectedExecute(Sender: TObject);
    procedure acUpdateItemShopHistoryExecute(Sender: TObject);
    procedure acUpdateShopsHistoryExecute(Sender: TObject);
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
  private
    // resizing
    fInitialFormWidth:    Integer;
    fInitialFrameHeight:  Integer;
    fInitialPanelWidth:   Integer;
    fFirstResize:         Boolean;
    // others
    fDrawBuffer:          TBitmap;
    fSaveOnExit:          Boolean;
    fILManager:           TILManager;
  {
    individual bits correspond to present sorting profiles
    when the bit is set, a profile exists at an index matching the bit index
    when the bit is not set, no profile exists at that position
  }
    fActionMask:  UInt32;
  protected
    procedure RePositionMainForm;
    procedure ReSizeMainForm;
    procedure BuildSortBySubmenu;    
    procedure FillCopyright;
    procedure FillListFileName;
    procedure UpdateIndexAndCount;
    Function SaveList: Boolean;
    Function LoadList: Boolean;
    // event handlers
    procedure DeferredRedraw(Sender: TObject; var Done: Boolean);
    procedure InvalidateList(Sender: TObject);
    procedure ShowSelectedItem(Sender: TObject);
    procedure FocusList(Sender: TObject);
    procedure SettingsChange(Sender: TObject);
  public
    ApplicationCanRun: Boolean;
    procedure InitializeOtherForms; // called before Application.Run from project file
    procedure FinalizeOtherForms;
  end;

var
  fMainForm: TfMainForm;

implementation

uses
  CommCtrl,
  TextEditForm, ShopsForm, ParsingForm, TemplatesForm, SortForm,
  SumsForm, SpecialsForm, OverviewForm, SelectionForm, ItemSelectForm,
  UpdResLegendForm, SettingsLegendForm, AboutForm, PromptForm,
  WinFileInfo, BitOps, CountedDynArrayInteger,  
  InflatablesList_Types,
  InflatablesList_Utils,
  InflatablesList_Manager_IO;

{$R *.dfm}

const
  IL_STATUSBAR_PANEL_IDX_INDEX        = 0;
  IL_STATUSBAR_PANEL_IDX_STATIC_SETT  = 1;
  IL_STATUSBAR_PANEL_IDX_DYNAMIC_SETT = 2;
  IL_STATUSBAR_PANEL_IDX_FILENAME     = 3;
  IL_STATUSBAR_PANEL_IDX_COPYRIGHT    = 4;

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
WorkRect := Screen.MonitorFromWindow(Self.Handle).WorkAreaRect;
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

procedure TfMainForm.ReSizeMainForm;
begin
If fFirstResize then
  begin
    RePositionMainForm;
    fFirstResize := False;
  end;
{
  do NOT call anything Client* on gbDetails - it causes problems
}
// redraw items for new listbox size
If Assigned(fILManager) then
  begin
    // redraw only visible
    fILManager.ReinitDrawSize(lbList,True);
    lbList.Invalidate;
    // deffer redraw of ivisible item
    Application.OnIdle := DeferredRedraw;
  end;
// rearrange search editbox
eSearchFor.Top := lbList.BoundsRect.Bottom + 5;
btnFindPrev.Top := eSearchFor.Top;
btnFindNext.Top := eSearchFor.Top;
// listbox filler
shpListFiller.Top := eSearchFor.BoundsRect.Bottom + 8;
shpListFiller.Width := lbList.Width;
shpListFiller.Height := gbDetails.BoundsRect.Bottom - shpListFiller.Top;
shpListFiller.Visible := shpListFiller.Height >= 4;
// item frame is resized automatically
// resize status bar panels
sbStatusBar.Panels[IL_STATUSBAR_PANEL_IDX_FILENAME].Width :=
  fInitialPanelWidth + (Width - fInitialFormWidth);
FillListFileName;
sbStatusBar.Invalidate;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.BuildSortBySubmenu;
var
  i:      Integer;
  MITemp: TMenuItem;
begin
// remove menu items
For i := Pred(mniMMO_SortBy.Count) downto 0 do
  If mniMMO_SortBy[i].Tag >= 0 then
    begin
      MITemp := mniMMO_SortBy[i];
      mniMMO_SortBy.Delete(i);
      FreeAndNil(MITemp);
    end;
fActionMask := 0;
For i := 0 to Pred(fILManager.SortingProfileCount) do
  begin
    MITemp := TMenuItem.Create(Self);
    MITemp.Name := IL_Format('mniMM_SB_Profile%d',[i]);
    MITemp.Caption := fILManager.SortingProfiles[i].Name;
    MITemp.OnClick := mniMMO_SortByClick;
    MITemp.Tag := i;
    If i <= 9 then
      MITemp.ShortCut := ShortCut(Ord('0') + ((i + 1) mod 10),[ssCtrl]);
    mniMMO_SortBy.Add(MITemp);
    BitSetTo(fActionMask,Byte(i),True);
  end;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.FillCopyright;
begin
with TWinFileInfo.Create(WFI_LS_LoadVersionInfo or WFI_LS_LoadFixedFileInfo or WFI_LS_DecodeFixedFileInfo) do
try
  sbStatusBar.Panels[IL_STATUSBAR_PANEL_IDX_COPYRIGHT].Text := IL_Format('%s, version %d.%d.%d %s%s #%d %s',[
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

procedure TfMainForm.FillListFileName;
begin
If sbStatusBar.Canvas.TextWidth(fILManager.StaticSettings.ListFile) >
  (sbStatusBar.Panels[IL_STATUSBAR_PANEL_IDX_FILENAME].Width -
   (2 * GetSystemMetrics(SM_CXFIXEDFRAME))) then
  begin
    sbStatusBar.Panels[IL_STATUSBAR_PANEL_IDX_FILENAME].Text :=
      IL_MinimizeName(fILManager.StaticSettings.ListFile,sbStatusBar.Canvas,
        sbStatusBar.Panels[IL_STATUSBAR_PANEL_IDX_FILENAME].Width -
        (2 * GetSystemMetrics(SM_CXFIXEDFRAME)));
  end
else sbStatusBar.Panels[IL_STATUSBAR_PANEL_IDX_FILENAME].Text := fILManager.StaticSettings.ListFile;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.UpdateIndexAndCount;
begin
If lbList.ItemIndex < 0 then
  begin
    If fILManager.ItemCount > 0 then
      sbStatusBar.Panels[IL_STATUSBAR_PANEL_IDX_INDEX].Text := IL_Format('-/%d',[fILManager.ItemCount])
    else
      sbStatusBar.Panels[IL_STATUSBAR_PANEL_IDX_INDEX].Text := '-/-';
  end
else sbStatusBar.Panels[IL_STATUSBAR_PANEL_IDX_INDEX].Text := IL_Format('%d/%d',[lbList.ItemIndex + 1,fILManager.ItemCount]);
end;

//------------------------------------------------------------------------------

Function TfMainForm.SaveList: Boolean;
begin
Result := False;
If not fILManager.StaticSettings.NoSave and mniMMF_SaveOnClose.Checked then
  begin
    fILManager.SaveToFile;  // backup is done automatically here
    FillListFileName;
    Result := True;
  end;
end;

//------------------------------------------------------------------------------

Function TfMainForm.LoadList: Boolean;
var
  PreloadRes: TILPreloadResultFlags;
  Password:   String;
begin
Result := False;
PreloadRes := fILManager.PreloadFile;
If not([ilprfInvalidFile,ilprfError] <= PreloadRes) then
  begin
    // when the file is encrypted, ask for password
    If ilprfEncrypted in PreloadRes then
      begin
        If IL_InputQuery('List password','Enter list password (can be empty):',Password,'*') then
          fILManager.ListPassword := Password
        else
          Exit; // exit with result set to false
      end;
    // load the file and catch wrong password exceptions
    try
      fILManager.LoadFromFile;
      Result := True;
    except
      on E: EILWrongPassword do
        MessageDlg('You have entered wrong password, program willl not terminate.',mtError,[mbOk],0);
      else
        raise;
    end;
  end
else MessageDlg('Invalid list file, cannot continue.',mtError,[mbOk],0);
end;

//------------------------------------------------------------------------------

procedure TfMainForm.DeferredRedraw(Sender: TObject; var Done: Boolean);
begin
Done := True;
Application.OnIdle := nil;  // de-assign this routine 
fILManager.ReinitDrawSize(lbList,False);
lbList.Invalidate;
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

procedure TfMainForm.SettingsChange(Sender: TObject);
begin
sbStatusBar.Invalidate;
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
fSettingsLegendForm.Initialize(fIlManager);
fAboutForm.Initialize(fIlManager);
end;

//------------------------------------------------------------------------------

procedure TfMainForm.FinalizeOtherForms;
begin
fTextEditForm.Finalize;
fShopsForm.Finalize;
fParsingForm.Finalize;
fTemplatesForm.Finalize;
fSortForm.Finalize;
fSumsForm.Finalize;
fSpecialsForm.Finalize;
fOverviewForm.Finalize;
fSelectionForm.Finalize;
fUpdateForm.Finalize;
fItemSelectForm.Finalize;
fUpdResLegendForm.Finalize;
fSettingsLegendForm.Finalize;
fAboutForm.Finalize;
end;

//==============================================================================

procedure TfMainForm.FormCreate(Sender: TObject);
var
  i:  Integer;
begin
// prepare form
lbList.DoubleBuffered := True;
sbStatusBar.DoubleBuffered := True;
// build shortcuts
mniMMI_MoveBeginning.ShortCut := ShortCut(VK_UP,[ssShift,ssAlt]);
mniMMI_MoveUpBy.ShortCut := ShortCut(VK_UP,[ssShift,ssCtrl]);
mniMMI_MoveUp.ShortCut := ShortCut(VK_UP,[ssShift]);
mniMMI_MoveDown.ShortCut := ShortCut(VK_DOWN,[ssShift]);
mniMMI_MoveDownBy.ShortCut := ShortCut(VK_DOWN,[ssShift,ssCtrl]);
mniMMI_MoveEnd.ShortCut := ShortCut(VK_DOWN,[ssShift,ssAlt]);
mniMMO_SortSett.ShortCut := ShortCut(Ord('O'),[ssCtrl,ssShift]);
mniMMO_SortCase.ShortCut := ShortCut(Ord('R'),[ssCtrl,ssShift]);
mniMMU_UpdateWanted.ShortCut := ShortCut(Ord('U'),[ssCtrl,ssShift]);
mniMMU_UpdateSelected.ShortCut := ShortCut(Ord('U'),[ssAlt,ssShift]);
acSortSett.ShortCut := ShortCut(Ord('O'),[ssCtrl,ssShift]);
acSortCase.ShortCut := ShortCut(Ord('R'),[ssCtrl,ssShift]);
acUpdateWanted.ShortCut := ShortCut(Ord('U'),[ssCtrl,ssShift]);
acUpdateSelected.ShortCut := ShortCut(Ord('U'),[ssAlt,ssShift]);
// shortcuts of sort-by actions (menu items are set in creation)
For i := 0 to Pred(ComponentCount) do
  If Components[i] is TAction then
    If IL_SameText(TAction(Components[i]).Category,'sorting_by') then
      TAction(Components[i]).ShortCut := ShortCut(Ord('0') +
        ((TAction(Components[i]).Tag + 1) mod 10),[ssCtrl]);
// fill some texts
FillCopyright;
eSearchFor.OnExit(nil);
// prepare variables/fields
fInitialFormWidth := Width;
fInitialFrameHeight := frmItemFrame.Height;
fInitialPanelWidth := sbStatusBar.Panels[IL_STATUSBAR_PANEL_IDX_FILENAME].Width;
fFirstResize := True;
fDrawBuffer := TBitmap.Create;
fDrawBuffer.PixelFormat := pf24bit;
fSaveOnExit := True;
fILManager := TILManager.Create;
fILManager.OnMainListUpdate := InvalidateList;
fILManager.OnSettingsChange := SettingsChange;
fActionMask := 0;
// prepare item frame
frmItemFrame.Initialize(fILManager);
frmItemFrame.OnShowSelectedItem := ShowSelectedItem;
frmItemFrame.OnFocusList := FocusList;
// preload list and ask for password if necessary, catch EWrongPassword
// load list
ApplicationCanRun := LoadList;
If not ApplicationCanRun then
  fSaveOnExit := False;
FillListFileName;
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
mniMMF_SaveOnClose.Checked := True;
mniMMO_SortRev.Checked := fILManager.ReversedSort;
mniMMO_SortCase.Checked := fILManager.CaseSensitiveSort;
mniMMF_ListCompress.Checked := fILManager.Compressed;
mniMMF_ListEncrypt.Checked := fILManager.Encrypted;
sbStatusBar.Invalidate; // to show settings
// build some things and final touches
BuildSortBySubmenu;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.FormDestroy(Sender: TObject);
begin
frmItemFrame.SetItem(nil,True);
frmItemFrame.Finalize;
If fSaveOnExit then
  SaveList;
lbList.Items.Clear; // to be sure
FreeAndNil(fILManager);
FreeAndNil(fDrawBuffer);
end;

//------------------------------------------------------------------------------

procedure TfMainForm.FormShow(Sender: TObject);
begin
// first drawing
fILManager.ReinitDrawSize(lbList,fSelectionForm.lbItems);
lbList.SetFocus;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
FinalizeOtherForms;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.FormResize(Sender: TObject);
begin
If Visible then
  ReSizeMainForm;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniMM_FileClick(Sender: TObject);
begin
mniMMF_ListPassword.Enabled := fILManager.Encrypted;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniMMF_ListCompressClick(Sender: TObject);
begin
mniMMF_ListCompress.Checked := not mniMMF_ListCompress.Checked;
fIlManager.Compressed := mniMMF_ListCompress.Checked;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniMMF_ListEncryptClick(Sender: TObject);
var
  Password: String;
begin
If not fIlManager.Encrypted then
  begin
    If IL_InputQuery('List password','Enter list password (can be empty):',Password,'*') then
      begin
        fIlManager.ListPassword := Password;
        fIlManager.Encrypted := True;
      end;
  end
else fIlManager.Encrypted := False;
mniMMF_ListEncrypt.Checked := fIlManager.Encrypted;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniMMF_ListPasswordClick(Sender: TObject);
var
  Password: String;
begin
If fIlManager.Encrypted then
  If IL_InputQuery('List password','Enter list password (can be empty):',Password,'*') then
    fIlManager.ListPassword := Password;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniMMF_SaveOnCloseClick(Sender: TObject);
begin
mniMMF_SaveOnClose.Checked := not mniMMF_SaveOnClose.Checked;
sbStatusBar.Invalidate;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniMMF_SaveClick(Sender: TObject);
begin
Screen.Cursor := crHourGlass;
try
  frmItemFrame.Save;
  If not SaveList then
    Beep;
finally
  Screen.Cursor := crDefault;
end;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniMMF_ExitClick(Sender: TObject);
begin
fSaveOnExit := False;
Close;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniMM_ListClick(Sender: TObject);
begin
mniMML_AddCopy.Enabled := lbList.ItemIndex >= 0;
mniMML_Remove.Enabled := lbList.ItemIndex >= 0;
mniMML_Clear.Enabled := lbList.Count > 0;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniMML_AddClick(Sender: TObject);
begin
lbList.Items.Add(IntToStr(lbList.Count));
lbList.ItemIndex := fILManager.ItemAddEmpty;
// following will also redraw new item and update the list
fILManager.ReinitDrawSize(lbList,fSelectionForm.lbItems);
lbList.OnClick(nil);  // also calls UpdateIndexAndCount
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniMML_AddCopyClick(Sender: TObject);
var
  Index:  Integer;
begin
If lbList.ItemIndex >= 0 then
  begin
    frmItemFrame.Save;  // save unsaved data for copying
    Index := lbList.ItemIndex;
    lbList.Items.Add(IntToStr(lbList.Count));
    lbList.ItemIndex := fILManager.ItemAddCopy(Index);
    fILManager.ReinitDrawSize(lbList,fSelectionForm.lbItems);
    lbList.OnClick(nil);
  end;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniMML_RemoveClick(Sender: TObject);
var
  Index:  Integer;
begin
If lbList.ItemIndex >= 0 then
  If MessageDlg(IL_Format('Are you sure you want to remove the item "%s"?',
       [fILManager[lbList.ItemIndex].TitleStr]),mtConfirmation,[mbYes,mbNo],0) = mrYes then
    begin
      frmItemFrame.SetItem(nil,False);  // the item will be delted, so unbind it
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
    end;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniMML_ClearClick(Sender: TObject);
begin
If lbList.Count > 0 then
  If MessageDlg('Are you sure you want to clear the entire list?',
       mtWarning,[mbYes,mbNo],0) = mrYes then
    begin
      lbList.ItemIndex := -1;
      lbList.OnClick(nil);  // also clears item frame
      lbList.Items.Clear;
      fILManager.ItemClear;
      UpdateIndexAndCount;
    end;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniMML_SumsClick(Sender: TObject);
begin
frmItemFrame.Save;
fSumsForm.ShowSums;
lbList.SetFocus;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniMML_OverviewClick(Sender: TObject);
begin
fOverviewForm.ShowOverview;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniMML_NotesClick(Sender: TObject);
var
  Temp: String;
begin
Temp := fILManager.Notes;
fTextEditForm.ShowTextEditor('Inflatables list notes',Temp,False);
fILManager.Notes := Temp;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniMM_ItemClick(Sender: TObject);
begin
mniMMI_MoveBeginning.Enabled := lbList.ItemIndex > 0;
mniMMI_MoveUpBy.Enabled := lbList.ItemIndex > 0;
mniMMI_MoveUp.Enabled := lbList.ItemIndex > 0;
mniMMI_MoveDown.Enabled := (lbList.ItemIndex >= 0) and (lbList.ItemIndex < Pred(lbList.Count));
mniMMI_MoveDownBy.Enabled := (lbList.ItemIndex >= 0) and (lbList.ItemIndex < Pred(lbList.Count));
mniMMI_MoveEnd.Enabled := (lbList.ItemIndex >= 0) and (lbList.ItemIndex < Pred(lbList.Count));
mniMMI_ItemShops.Enabled := lbList.ItemIndex >= 0;
mniMMI_ItemExport.Enabled := lbList.ItemIndex >= 0;
mniMMI_ItemExportMulti.Enabled := lbList.Count > 0;
end;

//------------------------------------------------------------------------------


procedure TfMainForm.mniMMI_ItemShopsClick(Sender: TObject);
begin
If lbList.ItemIndex >= 0 then
  begin
    fILManager[lbList.ItemIndex].BroadcastReqCount;
    fShopsForm.ShowShops(fILManager[lbList.ItemIndex]);
    lbList.SetFocus;
  end;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniMMI_ItemExportClick(Sender: TObject);
begin
If lbList.ItemIndex >= 0 then
  If diaItemsExport.Execute then
    begin
      frmItemFrame.Save;
      fILManager.ItemsExport(diaItemsExport.FileName,[lbList.ItemIndex]);
    end;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniMMI_ItemExportMultiClick(Sender: TObject);
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
      MessageDlg(IL_Format('%d items exported.',[Length(IndicesArr)]),mtInformation,[mbOK],0);
      lbList.SetFocus;
    end;
end;
 
//------------------------------------------------------------------------------

procedure TfMainForm.mniMMI_ItemImportClick(Sender: TObject);
var
  Cntr,i: Integer;
begin
If diaItemsImport.Execute then
  begin
    Cntr := fILManager.ItemsImport(diaItemsImport.FileName);
    If Cntr > 0 then
      begin
        For i := 1 to Cntr do
          lbList.Items.Add(IntToStr(lbList.Count));
        lbList.ItemIndex := Pred(lbList.Count);
        fILManager.ReinitDrawSize(lbList,fSelectionForm.lbItems);
      end;
    lbList.OnClick(nil);
    If Cntr > 0 then
      MessageDlg(IL_Format('%d items imported.',[Cntr]),mtInformation,[mbOK],0)
    else
      MessageDlg('No item imported.',mtInformation,[mbOK],0)
  end;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniMMI_MoveBeginningClick(Sender: TObject);
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

procedure TfMainForm.mniMMI_MoveUpByClick(Sender: TObject);
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

procedure TfMainForm.mniMMI_MoveUpClick(Sender: TObject);
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

procedure TfMainForm.mniMMI_MoveDownClick(Sender: TObject);
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

procedure TfMainForm.mniMMI_MoveDownByClick(Sender: TObject);
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

procedure TfMainForm.mniMMI_MoveEndClick(Sender: TObject);
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

procedure TfMainForm.mniMM_SearchClick(Sender: TObject);
begin
// nothing to do
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniMMS_FindClick(Sender: TObject);
begin
eSearchFor.SetFocus;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniMMS_FindPrevClick(Sender: TObject);
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

procedure TfMainForm.mniMMS_FindNextClick(Sender: TObject);
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

procedure TfMainForm.mniMMS_AdvSearchClick(Sender: TObject);
begin
{$message 'implement'}
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniMM_SortingClick(Sender: TObject);
begin
//
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniMMO_SortCommon(Profile: Integer);
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

procedure TfMainForm.mniMMO_SortSettClick(Sender: TObject);
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
mniMMO_SortRev.Checked := fILManager.ReversedSort;
mniMMO_SortCase.Checked := fILManager.CaseSensitiveSort;
BuildSortBySubmenu;
lbList.SetFocus;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniMMO_SortRevClick(Sender: TObject);
begin
mniMMO_SortRev.Checked := not mniMMO_SortRev.Checked;
fILManager.ReversedSort := mniMMO_SortRev.Checked;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniMMO_SortCaseClick(Sender: TObject);
begin
mniMMO_SortCase.Checked := not mniMMO_SortCase.Checked;
fIlManager.CaseSensitiveSort := mniMMO_SortCase.Checked;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniMMO_SortClick(Sender: TObject);
begin
mniMMO_SortCommon(-1);
lbList.SetFocus;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniMMO_SortByClick(Sender: TObject);
begin
If Sender is TMenuItem then
  begin
    mniMMO_SortCommon(TMenuItem(Sender).Tag);
    lbList.SetFocus;
  end;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniMM_UpdateClick(Sender: TObject);
begin
mniMMU_UpdateItem.Enabled := lbList.ItemIndex >= 0;
mniMMU_UpdateItemShopHistory.Enabled := lbList.ItemIndex >= 0;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniMMU_UpdateCommon(UpdateList: TILItemShopUpdateList);
begin
If Length(UpdateList) > 0 then
  fUpdateForm.ShowUpdate(UpdateList)
else
  MessageDlg('No shop to update.',mtInformation,[mbOK],0);
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniMMU_UpdateItemClick(Sender: TObject);
var
  List: TILItemShopUpdateList;
  i:    Integer;
begin
If lbList.ItemIndex >= 0 then
  begin
    fILManager[lbList.ItemIndex].BroadcastReqCount;  
    // create update list
    SetLength(List,fILManager[lbList.ItemIndex].ShopCount);
    For i := fILManager[lbList.ItemIndex].ShopLowIndex to fILManager[lbList.ItemIndex].ShopHighIndex do
      begin
        List[i].Item := fILManager[lbList.ItemIndex];
        List[i].ItemTitle := IL_Format('[#%d] %s',[lbList.ItemIndex + 1,fILManager[lbList.ItemIndex].TitleStr]);
        List[i].ItemShop := fILManager[lbList.ItemIndex].Shops[i];
        List[i].Done := False;
      end;
    mniMMU_UpdateCommon(List);
    lbList.SetFocus;
  end;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniMMU_UpdateAllClick(Sender: TObject);
var
  List: TILItemShopUpdateList;
  i,j:  Integer;
  Cntr: Integer;
begin
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
      List[Cntr].ItemTitle := IL_Format('[#%d] %s',[i + 1,fILManager[i].TitleStr]);
      List[Cntr].ItemShop := fILManager[i].Shops[j];
      List[Cntr].Done := False;
      Inc(Cntr);
    end;
mniMMU_UpdateCommon(List);
lbList.SetFocus;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniMMU_UpdateWantedClick(Sender: TObject);
var
  List: TILItemShopUpdateList;
  i,j:  Integer;
  Cntr: Integer;
begin
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
        List[Cntr].ItemTitle := IL_Format('[#%d] %s',[i + 1,fILManager[i].TitleStr]);
        List[Cntr].ItemShop := fILManager[i].Shops[j];
        List[Cntr].Done := False;
        Inc(Cntr);
      end;
mniMMU_UpdateCommon(List);
lbList.SetFocus;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniMMU_UpdateSelectedClick(Sender: TObject);
var
  List: TILItemShopUpdateList;
  i,j:  Integer;
  Cntr: Integer;
begin
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
        List[Cntr].ItemTitle := IL_Format('[#%d] %s',[i + 1,fILManager[i].TitleStr]);
        List[Cntr].ItemShop := fILManager[i].Shops[j];
        List[Cntr].Done := False;
        Inc(Cntr);
      end;
mniMMU_UpdateCommon(List);
lbList.SetFocus;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniMMU_UpdateItemShopHistoryClick(Sender: TObject);
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

procedure TfMainForm.mniMMU_UpdateShopsHistoryClick(Sender: TObject);
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

procedure TfMainForm.mniMM_ToolsClick(Sender: TObject);
begin
// nothing to do
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniMMT_SelectionClick(Sender: TObject);
begin
frmItemFrame.Save;
fSelectionForm.ShowSelection;
// load potential changes (tags mainly)
frmItemFrame.Load;
lbList.SetFocus;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniMMT_SpecialsClick(Sender: TObject);
begin
frmItemFrame.Save;
fSpecialsForm.ShowModal;
frmItemFrame.Load;
lbList.SetFocus;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniMM_HelpClick(Sender: TObject);
begin
// nothing to do
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniMMH_ResMarkLegendClick(Sender: TObject);
begin
fUpdResLegendForm.ShowLegend;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniMMH_SettingsLegendClick(Sender: TObject);
begin
fSettingsLegendForm.ShowLegend;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniMMH_AboutClick(Sender: TObject);
begin
fAboutForm.ShowInfo;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.acSaveExecute(Sender: TObject);
begin
mniMMF_Save.OnClick(nil);
end;

//------------------------------------------------------------------------------

procedure TfMainForm.acExitExecute(Sender: TObject);
begin
mniMMF_Exit.OnClick(nil);
end;

//------------------------------------------------------------------------------

procedure TfMainForm.acItemShopsExecute(Sender: TObject);
begin
mniMMI_ItemShops.OnClick(nil);
end;

//------------------------------------------------------------------------------

procedure TfMainForm.acItemExportExecute(Sender: TObject);
begin
mniMMI_ItemExport.OnClick(nil);
end;

//------------------------------------------------------------------------------

procedure TfMainForm.acItemExportMultiExecute(Sender: TObject);
begin
mniMMI_ItemExportMulti.OnClick(nil);
end;

//------------------------------------------------------------------------------

procedure TfMainForm.acItemImportExecute(Sender: TObject);
begin
mniMMI_ItemImport.OnClick(nil);
end;

//------------------------------------------------------------------------------

procedure TfMainForm.acSumsExecute(Sender: TObject);
begin
mniMML_Sums.OnClick(nil);
end;

//------------------------------------------------------------------------------

procedure TfMainForm.acOverviewExecute(Sender: TObject);
begin
mniMML_Overview.OnClick(nil);
end;

//------------------------------------------------------------------------------

procedure TfMainForm.acNotesExecute(Sender: TObject);
begin
mniMML_Notes.OnClick(nil);
end;

//------------------------------------------------------------------------------

procedure TfMainForm.acFindExecute(Sender: TObject);
begin
mniMMS_Find.OnClick(nil);
end;

//------------------------------------------------------------------------------

procedure TfMainForm.acFindPrevExecute(Sender: TObject);
begin
mniMMS_FindPrev.OnClick(nil);
end;
 
//------------------------------------------------------------------------------

procedure TfMainForm.acFindNextExecute(Sender: TObject);
begin
mniMMS_FindNext.OnClick(nil);
end;

//------------------------------------------------------------------------------

procedure TfMainForm.acAdvSearchExecute(Sender: TObject);
begin
mniMMS_AdvSearch.OnClick(nil);
end;

//------------------------------------------------------------------------------

procedure TfMainForm.acSortSettExecute(Sender: TObject);
begin
mniMMO_SortSett.OnClick(nil);
end;

//------------------------------------------------------------------------------

procedure TfMainForm.acSortRevExecute(Sender: TObject);
begin
mniMMO_SortRev.OnClick(nil);
end;

//------------------------------------------------------------------------------

procedure TfMainForm.acSortCaseExecute(Sender: TObject);
begin
mniMMO_SortCase.OnClick(nil);
end;

//------------------------------------------------------------------------------

procedure TfMainForm.acSortExecute(Sender: TObject);
begin
mniMMO_Sort.OnClick(nil);
end;

//------------------------------------------------------------------------------

procedure TfMainForm.acSortByCommonExecute(Sender: TObject);
begin
If Sender is TAction then
  If BT(fActionMask,Byte(TAction(Sender).Tag)) then
    begin
      mniMMO_SortCommon(TAction(Sender).Tag);
      lbList.SetFocus;
    end;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.acSelectionExecute(Sender: TObject);
begin
mniMMT_Selection.OnClick(nil);
end;

//------------------------------------------------------------------------------

procedure TfMainForm.acSpecialsExecute(Sender: TObject);
begin
mniMMT_Specials.OnClick(nil);
end;

//------------------------------------------------------------------------------

procedure TfMainForm.acUpdateItemExecute(Sender: TObject);
begin
mniMMU_UpdateItem.OnClick(nil);
end;

//------------------------------------------------------------------------------

procedure TfMainForm.acUpdateAllExecute(Sender: TObject);
begin
mniMMU_UpdateAll.OnClick(nil);
end;

//------------------------------------------------------------------------------

procedure TfMainForm.acUpdateWantedExecute(Sender: TObject);
begin
mniMMU_UpdateWanted.OnClick(nil);
end;

//------------------------------------------------------------------------------

procedure TfMainForm.acUpdateSelectedExecute(Sender: TObject);
begin
mniMMU_UpdateSelected.OnClick(nil);
end;

//------------------------------------------------------------------------------

procedure TfMainForm.acUpdateItemShopHistoryExecute(Sender: TObject);
begin
mniMMU_UpdateItemShopHistory.OnClick(nil);
end;

//------------------------------------------------------------------------------

procedure TfMainForm.acUpdateShopsHistoryExecute(Sender: TObject);
begin
mniMMU_UpdateShopsHistory.OnClick(nil);
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
mniMMI_ItemShops.OnClick(nil);
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
var
  BoundsRect: TRect;
begin
If Assigned(fDrawBuffer) then
  begin
    // adjust draw buffer size
    If fDrawBuffer.Width < (Rect.Right - Rect.Left) then
      fDrawBuffer.Width := Rect.Right - Rect.Left;
    If fDrawBuffer.Height < (Rect.Bottom - Rect.Top) then
      fDrawBuffer.Height := Rect.Bottom - Rect.Top;
    BoundsRect := Classes.Rect(0,0,Rect.Right - Rect.Left,Rect.Bottom - Rect.Top);
    with fDrawBuffer.Canvas do
      begin
        // background if required
        If (BoundsRect.Right - BoundsRect.Left) > fILManager.Items[Index].Render.Width then
          begin
            Pen.Style := psClear;
            Brush.Style := bsSolid;
            Brush.Color := clWhite;
            Rectangle(BoundsRect);
          end;
        // content
        Draw(BoundsRect.Left,BoundsRect.Top,fILManager.Items[Index].Render);
        // separator line
        Pen.Style := psSolid;
        Pen.Color := clSilver;
        MoveTo(BoundsRect.Left,Pred(BoundsRect.Bottom));
        LineTo(BoundsRect.Right,Pred(BoundsRect.Bottom));
        // states
        If odSelected	in State then
          begin
            Pen.Style := psClear;
            Brush.Style := bsSolid;
            Brush.Color := clLime;
            Rectangle(BoundsRect.Left,BoundsRect.Top,BoundsRect.Left + 11,BoundsRect.Bottom);
          end;
      end;
    // move drawbuffer to the canvas
    lbList.Canvas.CopyRect(Rect,fDrawBuffer.Canvas,BoundsRect);
    // disable focus rect
    If odFocused in State then
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
    mniMMS_FindNext.OnClick(nil);
  end;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.btnFindPrevClick(Sender: TObject);
begin
mniMMS_FindPrev.OnClick(nil);
end;

//------------------------------------------------------------------------------

procedure TfMainForm.btnFindNextClick(Sender: TObject);
begin
mniMMS_FindNext.OnClick(nil);
end;

//------------------------------------------------------------------------------

procedure TfMainForm.sbStatusBarDrawPanel(StatusBar: TStatusBar;
  Panel: TStatusPanel; const Rect: TRect);
const
  OPTS_SPC = 5;
var
  BoundsRect: TRect;
  i:          Integer;
  TempInt:    Integer;

  procedure DrawOptText(const Text: String; var Left: Integer; Enabled: Boolean; Shift: Integer = 0);
  begin
    If Enabled then
      fDrawBuffer.Canvas.Font.Color := sbStatusBar.Font.Color
    else
      fDrawBuffer.Canvas.Font.Color := clGrayText;
    fDrawBuffer.Canvas.TextOut(Left,BoundsRect.Top,Text);
    If Shift > 0 then
      Inc(Left,fDrawBuffer.Canvas.TextWidth(Text) + Shift);
  end;

begin
If Assigned(fDrawBuffer) then
  begin
    // adjust draw buffer size
    If fDrawBuffer.Width < (Rect.Right - Rect.Left) then
      fDrawBuffer.Width := Rect.Right - Rect.Left;
    If fDrawBuffer.Height < (Rect.Bottom - Rect.Top) then
      fDrawBuffer.Height := Rect.Bottom - Rect.Top;
    BoundsRect := Classes.Rect(0,0,Rect.Right - Rect.Left,Rect.Bottom - Rect.Top);
    fDrawBuffer.Canvas.Font.Assign(sbStatusBar.Canvas.Font);
    // get background (it is pre-drawn by the system)
    fDrawBuffer.Canvas.CopyRect(BoundsRect,sbStatusBar.Canvas,Rect);
    // draw panels
    case Panel.Index of
      IL_STATUSBAR_PANEL_IDX_STATIC_SETT:
        with fDrawBuffer.Canvas do
          begin
            TempInt := 0;
            For i := Low(IL_STATIC_SETTINGS_TAGS) to High(IL_STATIC_SETTINGS_TAGS) do
              If i < High(IL_STATIC_SETTINGS_TAGS) then
                Inc(TempInt,TextWidth(IL_STATIC_SETTINGS_TAGS[i]) + OPTS_SPC)
              else
                Inc(TempInt,TextWidth(IL_STATIC_SETTINGS_TAGS[i]));
            TempInt := BoundsRect.Left + (BoundsRect.Right - BoundsRect.Left - TempInt) div 2;
            Brush.Style := bsClear;
            Pen.Style := psClear;
            DrawOptText(IL_STATIC_SETTINGS_TAGS[0],TempInt,fILManager.StaticSettings.NoPictures,OPTS_SPC);
            DrawOptText(IL_STATIC_SETTINGS_TAGS[1],TempInt,fILManager.StaticSettings.TestCode,OPTS_SPC);
            DrawOptText(IL_STATIC_SETTINGS_TAGS[2],TempInt,fILManager.StaticSettings.SavePages,OPTS_SPC);
            DrawOptText(IL_STATIC_SETTINGS_TAGS[3],TempInt,fILManager.StaticSettings.LoadPages,OPTS_SPC);
            DrawOptText(IL_STATIC_SETTINGS_TAGS[4],TempInt,fILManager.StaticSettings.NoSave,OPTS_SPC);
            DrawOptText(IL_STATIC_SETTINGS_TAGS[5],TempInt,fILManager.StaticSettings.NoBackup,OPTS_SPC);
            DrawOptText(IL_STATIC_SETTINGS_TAGS[6],TempInt,fILManager.StaticSettings.NoUpdateAutoLog,OPTS_SPC);
            DrawOptText(IL_STATIC_SETTINGS_TAGS[7],TempInt,fILManager.StaticSettings.ListOverride,OPTS_SPC);
          end;
      IL_STATUSBAR_PANEL_IDX_DYNAMIC_SETT:
        with fDrawBuffer.Canvas do
          begin
            TempInt := 0;
            For i := Low(IL_DYNAMIC_SETTINGS_TAGS) to High(IL_DYNAMIC_SETTINGS_TAGS) do
              If i < High(IL_DYNAMIC_SETTINGS_TAGS) then
                Inc(TempInt,TextWidth(IL_DYNAMIC_SETTINGS_TAGS[i]) + OPTS_SPC)
              else
                Inc(TempInt,TextWidth(IL_DYNAMIC_SETTINGS_TAGS[i]));
            TempInt := BoundsRect.Left + (BoundsRect.Right - BoundsRect.Left - TempInt) div 2;
            Brush.Style := bsClear;
            Pen.Style := psClear;
            DrawOptText(IL_DYNAMIC_SETTINGS_TAGS[0],TempInt,fILManager.Compressed,OPTS_SPC);
            DrawOptText(IL_DYNAMIC_SETTINGS_TAGS[1],TempInt,fILManager.Encrypted,OPTS_SPC);
            DrawOptText(IL_DYNAMIC_SETTINGS_TAGS[2],TempInt,mniMMF_SaveOnClose.Checked,OPTS_SPC);
            DrawOptText(IL_DYNAMIC_SETTINGS_TAGS[3],TempInt,fILManager.ReversedSort,OPTS_SPC);
             DrawOptText(IL_DYNAMIC_SETTINGS_TAGS[4],TempInt,fILManager.CaseSensitiveSort,OPTS_SPC);
          end;
    end;
    // move drawbuffer to the canvas
    sbStatusBar.Canvas.CopyRect(Rect,fDrawBuffer.Canvas,BoundsRect);
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
      IL_STATUSBAR_PANEL_IDX_STATIC_SETT,
      IL_STATUSBAR_PANEL_IDX_DYNAMIC_SETT: mniMMH_SettingsLegend.OnClick(nil);
      IL_STATUSBAR_PANEL_IDX_COPYRIGHT:    mniMMH_About.OnClick(nil);
    end;
  end;
end;

end.
