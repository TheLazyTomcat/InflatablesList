unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, Spin, Menus, ActnList, XPMan,
  ItemFrame, UpdateForm,
  InflatablesList_Manager;
            
type
  TfMainForm = class(TForm)
    mmMainMenu: TMainMenu;
    mniMM_File: TMenuItem;
    mniMMF_ListCompress: TMenuItem;
    mniMMF_ListEncrypt: TMenuItem;
    mniMMF_ListPassword: TMenuItem;
    mniMMF_Backups: TMenuItem;
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
    mniMML_GoToItemNum: TMenuItem;
    mniMML_PrevItem: TMenuItem;
    mniMML_NextItem: TMenuItem;
    N4: TMenuItem;
    mniMML_Sums: TMenuItem;
    mniMML_Overview: TMenuItem;
    N5: TMenuItem;
    mniMML_Rename: TMenuItem;
    mniMML_Notes: TMenuItem;
    mniMM_Item: TMenuItem;
    mniMMI_ItemPictures: TMenuItem;
    mniMMI_ItemShops: TMenuItem;
    N6: TMenuItem;
    mniMMI_ItemExport: TMenuItem;
    mniMMI_ItemExportMulti: TMenuItem;
    mniMMI_ItemImport: TMenuItem;
    N7: TMenuItem;
    mniMMI_Encrypted: TMenuItem;
    mniMMI_Decrypt: TMenuItem;
    mniMMI_DecryptAll: TMenuItem;
    mniMMI_ChangeItemsPswd: TMenuItem;
    N8: TMenuItem;
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
    N9: TMenuItem;
    mniMMS_FindPrevValue: TMenuItem;
    mniMMS_FindNextValue: TMenuItem;
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
    N10: TMenuItem;
    mniMMU_UpdateItemShopHistory: TMenuItem;
    mniMMU_UpdateShopsHistory: TMenuItem;
    mniMM_Tools: TMenuItem;
    mniMMT_Selection: TMenuItem;
    mniMMT_ItemShopTable: TMenuItem;
    mniMMT_ShopByItems: TMenuItem;    
    mniMMT_Specials: TMenuItem;
    N11: TMenuItem;
    mniMMT_ExportAllPics: TMenuItem;
    mniMMT_ExportAllThumbs: TMenuItem;       
    mniMM_Help: TMenuItem;
    mniMMH_ResMarkLegend: TMenuItem;
    mniMMH_SettingsLegend: TMenuItem;
    N12: TMenuItem;
    mniMMH_About: TMenuItem;
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
    procedure mniMMF_BackupsClick(Sender: TObject);    
    procedure mniMMF_SaveOnCloseClick(Sender: TObject);    
    procedure mniMMF_SaveClick(Sender: TObject);
    procedure mniMMF_ExitClick(Sender: TObject);
    // ---
    procedure mniMM_ListClick(Sender: TObject);
    procedure mniMML_AddClick(Sender: TObject);
    procedure mniMML_AddCopyClick(Sender: TObject);
    procedure mniMML_RemoveClick(Sender: TObject);
    procedure mniMML_ClearClick(Sender: TObject);
    procedure mniMML_GoToItemNumClick(Sender: TObject);
    procedure mniMML_PrevItemClick(Sender: TObject);
    procedure mniMML_NextItemClick(Sender: TObject);
    procedure mniMML_SumsClick(Sender: TObject);
    procedure mniMML_OverviewClick(Sender: TObject);
    procedure mniMML_NotesClick(Sender: TObject);
    procedure mniMML_RenameClick(Sender: TObject);
    // ---
    procedure mniMM_ItemClick(Sender: TObject);
    procedure mniMMI_ItemPicturesClick(Sender: TObject);    
    procedure mniMMI_ItemShopsClick(Sender: TObject);
    procedure mniMMI_ItemExportClick(Sender: TObject);
    procedure mniMMI_ItemExportMultiClick(Sender: TObject);
    procedure mniMMI_ItemImportClick(Sender: TObject);
    procedure mniMMI_EncryptedClick(Sender: TObject);
    procedure mniMMI_DecryptClick(Sender: TObject);
    procedure mniMMI_DecryptAllClick(Sender: TObject);
    procedure mniMMI_ChangeItemsPswdClick(Sender: TObject);
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
    procedure mniMMS_FindPrevValueClick(Sender: TObject);
    procedure mniMMS_FindNextValueClick(Sender: TObject);
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
    procedure mniMMT_ItemShopTableClick(Sender: TObject);
    procedure mniMMT_ShopByItemsClick(Sender: TObject);
    procedure mniMMT_SpecialsClick(Sender: TObject);
    procedure mniMMT_ExportAllPicsClick(Sender: TObject);
    procedure mniMMT_ExportAllThumbsClick(Sender: TObject);    
    // ---
    procedure mniMM_HelpClick(Sender: TObject);
    procedure mniMMH_ResMarkLegendClick(Sender: TObject);
    procedure mniMMH_SettingsLegendClick(Sender: TObject);
    procedure mniMMH_AboutClick(Sender: TObject);
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
    fInitialized:         Boolean;
    fILManager:           TILManager;
    fSaveOnExit:          Boolean;
    fWrongPswdMessage:    String;
    fDirExport:           String; // last directory for pictures export
  protected
    procedure RePositionMainForm;
    procedure ReSizeMainForm;
    procedure BuildSortBySubmenu;    
    procedure FillCopyright;
    procedure FillListFileName;
    procedure FillListName;
    procedure UpdateIndexAndCount;
    Function SaveList: Boolean;
    // event handlers
    procedure RestartProgram(Sender: TObject);                    // backups form event
    procedure DeferredRedraw(Sender: TObject; var Done: Boolean); // Application.OnIdle, transient
    procedure ShowSelectedItem(Sender: TObject);                  // item frame event
    procedure FocusList(Sender: TObject);                         // item frame event
    procedure InvalidateList(Sender: TObject);                    // manager event
    procedure SettingsChange(Sender: TObject);                    // manager event
    procedure ItemsPasswordRequest(Sender: TObject);              // manager event
    // init/finals
    procedure InitializeOtherForms;
    procedure FinalizeOtherForms;
    procedure Finalize;
  public
    procedure Initialize(ILManager: TILManager);
  end;

var
  fMainForm: TfMainForm;

implementation

uses
  CommCtrl,
  TextEditForm, ShopsForm, ParsingForm, TemplatesForm, SortForm, SumsForm,
  SpecialsForm, OverviewForm, SelectionForm, ItemSelectForm, UpdResLegendForm,
  SettingsLegendForm, AboutForm, PromptForm, BackupsForm, SplashForm, SaveForm,
  AdvancedSearchForm, ShopByItemsForm, ItemPicturesForm, ItemShopTableForm,
  WinFileInfo, BitOps, StrRect, CountedDynArrayInteger,
  InflatablesList_Types,
  InflatablesList_Utils,
  InflatablesList_Encryption;

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
WorkRect := Screen.MonitorFromWindow(Application.Handle).WorkAreaRect;
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

procedure TfMainForm.FillListName;
begin
If Length(fILManager.ListName) > 0 then
  Caption := IL_Format('Inflatables List - %s',[fILManager.ListName])
else
  Caption := 'Inflatables List';
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
frmItemFrame.Save;
If not fILManager.StaticSettings.NoSave then
  begin
    If fILManager.SlowSaving then
      fSaveForm.ShowAndPerformSave
    else
      fILManager.SaveToFile; // backup is done automatically here
    FillListFileName;
    Result := True;
  end;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.RestartProgram(Sender: TObject);
var
  Params: String;
  i:      Integer;
begin
Params := '';
For i := 1 to ParamCount do
  Params := Params + ' ' + ParamStr(i);
IL_ShellOpen(0,RTLToStr(ParamStr(0)),Params,fILManager.StaticSettings.DefaultPath);
fSaveOnExit := False;
Close;
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

procedure TfMainForm.InvalidateList(Sender: TObject);
begin
lbList.Invalidate;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.SettingsChange(Sender: TObject);
begin
sbStatusBar.Invalidate;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.ItemsPasswordRequest(Sender: TObject);
var
  Password: String;
begin
Password := '';
If IL_InputQuery('Items password','Enter items password (can be empty):',Password,'*') then
  try
    fILManager.ItemsPassword := Password;
  except
    on E: EILWrongPassword do
      begin
        If Length(fWrongPswdMessage) > 0 then
          MessageDlg(fWrongPswdMessage,mtError,[mbOk],0)
        else
          MessageDlg('Wrong password.',mtError,[mbOk],0);
      end
    else raise;
  end;
end;

//------------------------------------------------------------------------------

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
fBackupsForm.Initialize(fILManager);
fBackupsForm.OnRestartRequired := RestartProgram;
fUpdResLegendForm.Initialize(fIlManager);
fSettingsLegendForm.Initialize(fIlManager);
fAboutForm.Initialize(fIlManager);
fSplashForm.Initialize(fIlManager);
fSaveForm.Initialize(fIlManager);
fAdvancedSearchForm.Initialize(fIlManager);
fShopByItemsForm.Initialize(fIlManager);
fItemPicturesForm.Initialize(fIlManager);
fItemShopTableForm.Initialize(fILManager);
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
fBackupsForm.Finalize;
fUpdResLegendForm.Finalize;
fSettingsLegendForm.Finalize;
fAboutForm.Finalize;
fSplashForm.Finalize;
fSaveForm.Finalize;
fAdvancedSearchForm.Finalize;
fShopByItemsForm.Finalize;
fItemPicturesForm.Finalize;
fItemShopTableForm.Finalize;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.Finalize;
begin
If fSaveOnExit and mniMMF_SaveOnClose.Checked then
  SaveList;
If fInitialized then
  begin
    // finalize item frame
    frmItemFrame.SetItem(nil,True);
    frmItemFrame.OnShowSelectedItem := nil;
    frmItemFrame.OnFocusList := nil;
    frmItemFrame.Finalize;
    // deassign event handlers
    fILManager.OnMainListUpdate := nil;
    fILManager.OnSettingsChange := nil;
    // others
    lbList.Items.Clear; // to be sure
    FinalizeOtherForms;
  end;
end;

//==============================================================================

procedure TfMainForm.Initialize(ILManager: TILManager);
var
  i:  Integer;
begin
// the list is already loaded at this point
// fill some texts
FillCopyright;
eSearchFor.OnExit(nil);
// prepare variables/fields/objects
fInitialFormWidth := Width;
fInitialFrameHeight := frmItemFrame.Height;
fInitialPanelWidth := sbStatusBar.Panels[IL_STATUSBAR_PANEL_IDX_FILENAME].Width;
fFirstResize := True;
fInitialized := True;
fILManager := ILManager;
fILManager.OnMainListUpdate := InvalidateList;
fILManager.OnSettingsChange := SettingsChange;
fILManager.OnItemsPasswordRequest := ItemsPasswordRequest;
fSaveOnExit := True;
fWrongPswdMessage := '';
fDirExport := '';
// prepare item frame
frmItemFrame.Initialize(fILManager);
frmItemFrame.OnShowSelectedItem := ShowSelectedItem;
frmItemFrame.OnFocusList := FocusList;
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
// load other things from manager
mniMMF_SaveOnClose.Checked := True;
mniMMO_SortRev.Checked := fILManager.ReversedSort;
mniMMO_SortCase.Checked := fILManager.CaseSensitiveSort;
mniMMF_ListCompress.Checked := fILManager.Compressed;
mniMMF_ListEncrypt.Checked := fILManager.Encrypted;   
// position the window
RePositionMainForm;
// build some things and final touches
sbStatusBar.Invalidate; // to show settings
UpdateIndexAndCount;
BuildSortBySubmenu;
FillListFileName;
FillListName;
InitializeOtherForms;
end;

//==============================================================================

procedure TfMainForm.FormCreate(Sender: TObject);
begin
fInitialized := False;
// prepare form
lbList.DoubleBuffered := True;
sbStatusBar.DoubleBuffered := True;
// build shortcuts
mniMML_AddCopy.ShortCut := ShortCut(VK_INSERT,[ssCtrl,ssShift]);
mniMML_Clear.ShortCut := ShortCut(VK_DELETE,[ssCtrl,ssShift]);
mniMML_PrevItem.ShortCut := ShortCut(VK_TAB,[ssCtrl,ssShift]);
mniMML_NextItem.ShortCut := ShortCut(VK_TAB,[ssCtrl]);  
mniMMI_MoveBeginning.ShortCut := ShortCut(VK_UP,[ssCtrl,ssAlt]);
mniMMI_MoveUpBy.ShortCut := ShortCut(VK_UP,[ssShift,ssCtrl]);
mniMMI_MoveUp.ShortCut := ShortCut(VK_UP,[ssCtrl]);
mniMMI_MoveDown.ShortCut := ShortCut(VK_DOWN,[ssCtrl]);
mniMMI_MoveDownBy.ShortCut := ShortCut(VK_DOWN,[ssShift,ssCtrl]);
mniMMI_MoveEnd.ShortCut := ShortCut(VK_DOWN,[ssCtrl,ssAlt]);
mniMMO_SortSett.ShortCut := ShortCut(Ord('O'),[ssCtrl,ssShift]);
mniMMO_SortCase.ShortCut := ShortCut(Ord('R'),[ssCtrl,ssShift]);
mniMMU_UpdateWanted.ShortCut := ShortCut(Ord('U'),[ssCtrl,ssShift]);
mniMMU_UpdateSelected.ShortCut := ShortCut(Ord('U'),[ssAlt,ssShift]);
// prepare draw buffer
fDrawBuffer := TBitmap.Create;
fDrawBuffer.PixelFormat := pf24bit;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.FormDestroy(Sender: TObject);
begin
FreeAndNil(fDrawBuffer);
end;

//------------------------------------------------------------------------------

procedure TfMainForm.FormShow(Sender: TObject);
begin
// first drawing
fILManager.ReinitDrawSize(lbList,fSelectionForm.lbItems);
end;

//------------------------------------------------------------------------------

procedure TfMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Finalize; // must not be called from OnDestroy event
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

procedure TfMainForm.mniMMF_BackupsClick(Sender: TObject);
begin
fBackupsForm.ShowBackups;
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
If lbList.ItemIndex >= 0 then
  mniMML_AddCopy.Enabled := fILManager[lbList.ItemIndex].DataAccessible
else
  mniMML_AddCopy.Enabled := False;
mniMML_Remove.Enabled := lbList.ItemIndex >= 0;
mniMML_Clear.Enabled := lbList.Count > 0;
mniMML_GoToItemNum.Enabled := lbList.Count > 0;
mniMML_PrevItem.Enabled := lbList.ItemIndex > 0;
mniMML_NextItem.Enabled := (lbList.Count > 0) and (lbList.ItemIndex < Pred(lbList.Count));
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniMML_AddClick(Sender: TObject);
begin
frmItemFrame.Save;
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
  If fILManager[lbList.ItemIndex].DataAccessible then
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
frmItemFrame.Save;
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
      // move list if last item was removed and there is an empty place
      If ((lbList.TopIndex + (lbList.ClientHeight div lbList.ItemHeight)) > lbList.Count) and
        (lbList.Count >= (lbList.ClientHeight div lbList.ItemHeight)) then
        lbList.TopIndex := lbList.Count - (lbList.ClientHeight div lbList.ItemHeight);
    end;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniMML_ClearClick(Sender: TObject);
begin
frmItemFrame.Save;
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

procedure TfMainForm.mniMML_GoToItemNumClick(Sender: TObject);
var
  Index:  Integer;
begin
frmItemFrame.Save;
If lbList.Count > 0 then
  begin
    Index := Succ(lbList.ItemIndex);
    If (Index < 1) or (Index > lbList.Count) then
      Index := 1;
    If IL_InputQuery('Go to item #','Item number to go to:',Index,1,lbList.Count) then
      begin
        If (Index >= 1) and (Index <= lbList.Count) then
          begin
            lbList.ItemIndex := Pred(Index);
            lbList.OnClick(nil);
            lbList.SetFocus;
          end
        else MessageDlg(IL_Format('Invalid item number (%d).',[Index]),mtError,[mbOK],0);
      end;
  end;
end; 

//------------------------------------------------------------------------------

procedure TfMainForm.mniMML_PrevItemClick(Sender: TObject);
begin
If lbList.ItemIndex > 0 then
  begin
    frmItemFrame.Save;
    lbList.ItemIndex := lbList.ItemIndex - 1;
    lbList.OnClick(nil);
  end;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniMML_NextItemClick(Sender: TObject);
begin
If (lbList.Count > 0) and (lbList.ItemIndex < Pred(lbList.Count)) then
  begin
    frmItemFrame.Save;
    lbList.ItemIndex := lbList.ItemIndex + 1;
    lbList.OnClick(nil);
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
frmItemFrame.Save;
fOverviewForm.ShowOverview;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniMML_RenameClick(Sender: TObject);
var
  ListName: String;
begin
frmItemFrame.Save;
ListName := fILManager.ListName;
If IL_InputQuery('List name','Enter list name:',ListName) then
  begin
    fIlManager.ListName := ListName;
    FillListName;
  end;
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
If lbList.ItemIndex >= 0 then
  begin
    mniMMI_ItemShops.Enabled := fILManager[lbList.ItemIndex].DataAccessible;
    mniMMI_ItemPictures.Enabled := fILManager[lbList.ItemIndex].DataAccessible;
    mniMMI_ItemExport.Enabled := fILManager[lbList.ItemIndex].DataAccessible;
  end
else
  begin
    mniMMI_ItemShops.Enabled := False;
    mniMMI_ItemPictures.Enabled := False;
    mniMMI_ItemExport.Enabled := False;
  end;
mniMMI_ItemExportMulti.Enabled := lbList.Count > 0;
mniMMI_Encrypted.Enabled := lbList.ItemIndex >= 0;
If lbList.ItemIndex >= 0 then
  begin
    mniMMI_Encrypted.Checked := fILManager[lbList.ItemIndex].Encrypted;
    mniMMI_Decrypt.Enabled := fILManager[lbList.ItemIndex].Encrypted and not fILManager[lbList.ItemIndex].DataAccessible;
  end
else
  begin
    mniMMI_Encrypted.Checked := False;
    mniMMI_Decrypt.Enabled := False;
  end;
mniMMI_DecryptAll.Enabled := fILManager.EncryptedItemCount(False) > 0;
mniMMI_MoveBeginning.Enabled := lbList.ItemIndex > 0;
mniMMI_MoveUpBy.Enabled := lbList.ItemIndex > 0;
mniMMI_MoveUp.Enabled := lbList.ItemIndex > 0;
mniMMI_MoveDown.Enabled := (lbList.ItemIndex >= 0) and (lbList.ItemIndex < Pred(lbList.Count));
mniMMI_MoveDownBy.Enabled := (lbList.ItemIndex >= 0) and (lbList.ItemIndex < Pred(lbList.Count));
mniMMI_MoveEnd.Enabled := (lbList.ItemIndex >= 0) and (lbList.ItemIndex < Pred(lbList.Count));
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniMMI_ItemPicturesClick(Sender: TObject);
begin
If lbList.ItemIndex >= 0 then
  If fILManager[lbList.ItemIndex].DataAccessible then
    begin
      frmItemFrame.Save;
      fItemPicturesForm.ShowPictures(fILManager[lbList.ItemIndex]);
      lbList.SetFocus;
    end;
end;

//------------------------------------------------------------------------------


procedure TfMainForm.mniMMI_ItemShopsClick(Sender: TObject);
begin
If lbList.ItemIndex >= 0 then
  If fILManager[lbList.ItemIndex].DataAccessible then
    begin
      frmItemFrame.Save;
      fILManager[lbList.ItemIndex].BroadcastReqCount;
      fShopsForm.ShowShops(fILManager[lbList.ItemIndex]);
      lbList.SetFocus;
    end;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniMMI_ItemExportClick(Sender: TObject);
begin
If lbList.ItemIndex >= 0 then
  If fILManager[lbList.ItemIndex].DataAccessible then
    begin
      If diaItemsExport.Execute then
        begin
          frmItemFrame.Save;
          fILManager.ItemsExport(diaItemsExport.FileName,[lbList.ItemIndex]);
        end;
    end;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniMMI_ItemExportMultiClick(Sender: TObject);
var
  Indices:    TCountedDynArrayInteger;
  IndicesArr: array of Integer;
  i:          Integer;
begin
If fILManager.EncryptedItemCount(False) <= 0 then
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
  end
else MessageDlg('Some of the items are encrypted and their data are not accessible.' + sLineBreak +
       'You have to decrypt all items before you will be able to export any of them.',mtInformation,[mbOK],0);
end;
 
//------------------------------------------------------------------------------

procedure TfMainForm.mniMMI_ItemImportClick(Sender: TObject);
var
  Cntr,i: Integer;
begin
frmItemFrame.Save;
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

procedure TfMainForm.mniMMI_EncryptedClick(Sender: TObject);
begin
If lbList.ItemIndex >= 0 then
  begin
    If fILManager[lbList.ItemIndex].Encrypted then
      fWrongPswdMessage := 'Wrong password entered, cannot decrypt the item.'
    else
      fWrongPswdMessage := 'Entered password does not match with already encrypted items.';
    fILManager[lbList.ItemIndex].Encrypted := not fILManager[lbList.ItemIndex].Encrypted;
    frmItemFrame.SetItem(nil,False);
    frmItemFrame.SetItem(fILManager[lbList.ItemIndex],True);
  end;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniMMI_DecryptClick(Sender: TObject);
begin
If lbList.ItemIndex >= 0 then
  begin
    fWrongPswdMessage := 'Wrong password entered, cannot decrypt the item.';
    fILManager[lbList.ItemIndex].Decrypt;
    frmItemFrame.SetItem(nil,False);
    frmItemFrame.SetItem(fILManager[lbList.ItemIndex],True);
  end;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniMMI_DecryptAllClick(Sender: TObject);
begin
Screen.Cursor := crHourGlass;
try
  fWrongPswdMessage := 'Wrong password entered, cannot decrypt items.';
  fILManager.DecryptAllItems;
finally
  Screen.Cursor := crDefault;
end;
If lbList.ItemIndex >= 0 then
  begin
    frmItemFrame.SetItem(nil,False);
    frmItemFrame.SetItem(fILManager[lbList.ItemIndex],True);
  end;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniMMI_ChangeItemsPswdClick(Sender: TObject);
var
  Password: String;
begin
If fILManager.HasItemsPassword then
  begin
    Password := fILManager.ItemsPassword;
    If fILManager.EncryptedItemCount(False) > 0 then
      If MessageDlg('Existing encrypted items must be decrypted before changing the password.' + sLineBreak +
           'Do you want to continue and decrypt all encrypted items?',mtConfirmation,[mbYes,mbNo],0) = mrYes then
        begin
          Screen.Cursor := crHourGlass;
          try
            fILManager.DecryptAllItems;          
          finally
            Screen.Cursor := crDefault;
          end;
        end
      else Exit;
    If IL_InputQuery('Items password','Enter items password (can be empty):',Password,'*') then
      fILManager.ItemsPassword := Password;
  end
else
  begin
    Password := '';
    If IL_InputQuery('Items password','Enter items password (can be empty):',Password,'*') then
      begin
        If fILManager.CheckItemPassword(Password) then
          fILManager.ItemsPassword := Password
        else
          MessageDlg('Entered password does not match with already encrypted items.',mtError,[mbOk],0);
      end;    
  end;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniMMI_MoveBeginningClick(Sender: TObject);
var
  Index:  Integer;
begin
frmItemFrame.Save;
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
frmItemFrame.Save;
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
frmItemFrame.Save;
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
frmItemFrame.Save;
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
frmItemFrame.Save;
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
frmItemFrame.Save;
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
mniMMS_FindPrevValue.Enabled := lbList.ItemIndex >= 0;
mniMMS_FindNextValue.Enabled := lbList.ItemIndex >= 0;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniMMS_FindClick(Sender: TObject);
begin
frmItemFrame.Save;
eSearchFor.SetFocus;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniMMS_FindPrevClick(Sender: TObject);
var
  Index:  Integer;
begin
frmItemFrame.Save;
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
frmItemFrame.Save;
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
frmItemFrame.Save;
fAdvancedSearchForm.ShowAdvancedSearch;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniMMS_FindPrevValueClick(Sender: TObject);
var
  Index:  Integer;
begin
frmItemFrame.Save;
If (Length(eSearchFor.Text) > 0) and (lbList.ItemIndex >= 0) then
  begin
    If not fILManager[lbList.ItemIndex].Contains(eSearchFor.Text) then
      begin
        Screen.Cursor := crHourGlass;
        try
          Index := fILManager.FindPrev(eSearchFor.Text,lbList.ItemIndex);
        finally
          Screen.Cursor := crDefault;
        end;
      end
    else Index := lbList.ItemIndex;
    If Index >= 0 then
      begin
        If Index <> lbList.ItemIndex then
          begin
            lbList.ItemIndex := Index;
            lbList.OnClick(nil);
          end;
        frmItemFrame.FindPrev(eSearchFor.Text);
      end
    else Beep;
  end;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniMMS_FindNextValueClick(Sender: TObject);
var
  Index:  Integer;
begin
frmItemFrame.Save;
If (Length(eSearchFor.Text) > 0) and (lbList.ItemIndex >= 0) then
  begin
    If not fILManager[lbList.ItemIndex].Contains(eSearchFor.Text) then
      begin
        Screen.Cursor := crHourGlass;
        try
          Index := fILManager.FindNext(eSearchFor.Text,lbList.ItemIndex);
        finally
          Screen.Cursor := crDefault;
        end;
      end
    else Index := lbList.ItemIndex;
    If Index >= 0 then
      begin
        If Index <> lbList.ItemIndex then
          begin
            lbList.ItemIndex := Index;
            lbList.OnClick(nil);
          end;
        frmItemFrame.FindNext(eSearchFor.Text);
      end
    else Beep;
  end;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniMM_SortingClick(Sender: TObject);
begin
// nothing to do
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
frmItemFrame.Save;
mniMMO_SortCommon(-1);
lbList.SetFocus;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniMMO_SortByClick(Sender: TObject);
begin
If Sender is TMenuItem then
  begin
    frmItemFrame.Save;
    mniMMO_SortCommon(TMenuItem(Sender).Tag);
    lbList.SetFocus;
  end;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniMM_UpdateClick(Sender: TObject);
begin
If lbList.ItemIndex >= 0 then
  begin
    mniMMU_UpdateItem.Enabled := fILManager[lbList.ItemIndex].DataAccessible;
    mniMMU_UpdateItemShopHistory.Enabled := fILManager[lbList.ItemIndex].DataAccessible;
  end
else
  begin
    mniMMU_UpdateItem.Enabled := False;
    mniMMU_UpdateItemShopHistory.Enabled := False;
  end;
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
  If fILManager[lbList.ItemIndex].DataAccessible then
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
  If fILManager[i].DataAccessible then
    begin
      fILManager[i].BroadcastReqCount;
      For j := fILManager[i].ShopLowIndex to fILManager[i].ShopHighIndex do
        Inc(Cntr);
    end;
// create update list
SetLength(List,Cntr);
Cntr := Low(List);
For i := fILManager.ItemLowIndex to fILManager.ItemHighIndex do
  If fILManager[i].DataAccessible then
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
  If fILManager[i].DataAccessible and (ilifWanted in fILManager[i].Flags) then
    begin
      fILManager[i].BroadcastReqCount;
      For j := fILManager[i].ShopLowIndex to fILManager[i].ShopHighIndex do
        Inc(Cntr);
    end;
// create update list
SetLength(List,Cntr);
Cntr := Low(List);
For i := fILManager.ItemLowIndex to fILManager.ItemHighIndex do
  If fILManager[i].DataAccessible and (ilifWanted in fILManager[i].Flags) then
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
  If fILManager[i].DataAccessible then
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
  If fILManager[i].DataAccessible then
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
 If fILManager[lbList.ItemIndex].DataAccessible then
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
    If fILManager[i].DataAccessible then
      For j := fILManager[i].ShopLowIndex to fILManager[i].ShopHighIndex do
        fILManager[i][j].UpdateAvailAndPriceHistory;
finally
  Screen.Cursor := crDefault;
end;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniMM_ToolsClick(Sender: TObject);
begin
mniMMT_ExportAllPics.Enabled := lbList.Count > 0;
mniMMT_ExportAllThumbs.Enabled := lbList.Count > 0;
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

procedure TfMainForm.mniMMT_ItemShopTableClick(Sender: TObject);
begin
frmItemFrame.Save;
fItemShopTableForm.ShowTable;
frmItemFrame.Load;
lbList.SetFocus;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.mniMMT_ShopByItemsClick(Sender: TObject);
begin
frmItemFrame.Save;
fShopByItemsForm.ShowSelection;
// no need to load changes, this window is only informative
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

procedure TfMainForm.mniMMT_ExportAllPicsClick(Sender: TObject);
var
  Directory:  String;
  i,j,CA,CS:  Integer;
begin
If lbList.Count > 0 then
  begin
    Directory := fDirExport;
    If IL_SelectDirectory('Select directory for pictures export',Directory) then
      begin
        fDirExport := IL_ExcludeTrailingPathDelimiter(Directory);
        CA := 0;
        CS := 0;
        Screen.Cursor := crHourGlass;
        try
          For i := fILManager.ItemLowIndex to fILManager.ItemHighIndex do
            If fILManager[i].DataAccessible then
              For j := fILManager[i].Pictures.LowIndex to fILManager[i].Pictures.HighIndex do
                begin
                  Inc(CA);
                  If fILManager[i].Pictures.ExportPicture(j,IL_ExcludeTrailingPathDelimiter(Directory)) then
                    Inc(CS);
                end;
        finally
          Screen.Cursor := crDefault;
        end;
        MessageDlg(IL_Format('%d pictures successfully exported, %d failed.',[CS,CA - CS]),mtInformation,[mbOK],0);
      end;
  end;
end;
 
//------------------------------------------------------------------------------

procedure TfMainForm.mniMMT_ExportAllThumbsClick(Sender: TObject);
var
  Directory:  String;
  i,j,CA,CS:  Integer;
begin
If lbList.Count > 0 then
  begin
    Directory := fDirExport;
    If IL_SelectDirectory('Select directory for thumbnails export',Directory) then
      begin
        fDirExport := IL_ExcludeTrailingPathDelimiter(Directory);
        CA := 0;
        CS := 0;
        Screen.Cursor := crHourGlass;
        try
          For i := fILManager.ItemLowIndex to fILManager.ItemHighIndex do
            If fILManager[i].DataAccessible then
              For j := fILManager[i].Pictures.LowIndex to fILManager[i].Pictures.HighIndex do
                begin
                  Inc(CA);
                  If fILManager[i].Pictures.ExportThumbnail(j,IL_ExcludeTrailingPathDelimiter(Directory)) then
                    Inc(CS);
                end;
        finally
          Screen.Cursor := crDefault;
        end;
        MessageDlg(IL_Format('%d picture thumbnails successfully exported, %d failed.',[CS,CA - CS]),mtInformation,[mbOK],0);
      end;
  end;
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
            DrawOptText(IL_STATIC_SETTINGS_TAGS[8],TempInt,fILManager.StaticSettings.NoParse,OPTS_SPC);
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
