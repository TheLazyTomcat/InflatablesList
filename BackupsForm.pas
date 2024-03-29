unit BackupsForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, Menus,
  InflatablesList_Manager;

type
  TfBackupsForm = class(TForm)
    lvBackups: TListView;
    leBackupFolder: TLabeledEdit;
    btnOpenBckFolder: TButton;
    pmnBackups: TPopupMenu;
    mniBU_Delete: TMenuItem;
    N1: TMenuItem;
    mniBU_Backup: TMenuItem;
    mniBU_Restore: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure btnOpenBckFolderClick(Sender: TObject);
    procedure pmnBackupsPopup(Sender: TObject);
    procedure mniBU_DeleteClick(Sender: TObject);
    procedure mniBU_RestoreClick(Sender: TObject);
    procedure mniBU_BackupClick(Sender: TObject);
  private
    { Private declarations }
    fILManager: TILManager;
  protected
    procedure FillBackupList;
    procedure UpdateTitle;
  public
    { Public declarations }
    OnRestartRequired: TNotifyEvent;
    procedure Initialize(ILManager: TILManager);
    procedure Finalize;
    procedure ShowBackups;
  end;

var
  fBackupsForm: TfBackupsForm;

implementation

uses
  AuxTypes, WinFileInfo, BitOps,
  InflatablesList_Types,  
  InflatablesList_Utils;

{$R *.dfm}

procedure TfBackupsForm.FillBackupList;
var
  i:  Integer;

  Function FlagsToStr(Flags: UInt32): String;

    procedure AddToResult(const S: String);
    begin
      If Length(Result) > 0 then
        Result := IL_Format('%s, %s',[Result,S])
      else
        Result := S;
    end;

  begin
    Result := '';
    If GetFlagState(Flags,IL_LIST_FLAG_BITMASK_ENCRYPTED) then
      AddToResult('encrypted');
    If GetFlagState(Flags,IL_LIST_FLAG_BITMASK_COMPRESSED) then
      AddToResult('compressed');
  end;

begin
leBackupFolder.Text := fILManager.BackupManager.StaticSettings.BackupPath;
lvBackups.Items.BeginUpdate;
try
  // adjust count
  If lvBackups.Items.Count > fILManager.BackupManager.BackupCount then
    begin
      For i := Pred(lvBackups.Items.Count) downto fILManager.BackupManager.BackupCount do
        lvBackups.Items.Delete(i);
    end
  else If lvBackups.Items.Count < fILManager.BackupManager.BackupCount then
    begin
      For i := Succ(lvBackups.Items.Count) to fILManager.BackupManager.BackupCount do
        with lvBackups.Items.Add do
          begin
            Caption := '';
            SubItems.Add('');
            SubItems.Add('');
            SubItems.Add('');
            SubItems.Add('');
            SubItems.Add('');
          end;
    end;
  // fill the list
  For i := 0 to Pred(fILManager.BackupManager.BackupCount) do
    with lvBackups.Items[i] do
      begin
        Caption := fILManager.BackupManager[i].FileName;
        SubItems[0] := IL_Format('%s (%d bytes)',[
          WinFileInfo.SizeToStr(fILManager.BackupManager[i].Size),
          fILManager.BackupManager[i].Size]);
        If fILManager.BackupManager[i].SaveVersion <> 0 then
          SubItems[1] := IL_Format('%d.%d.%d (build #%d)',[
            TILPreloadInfoVersion(fILManager.BackupManager[i].SaveVersion).Major,
            TILPreloadInfoVersion(fILManager.BackupManager[i].SaveVersion).Minor,
            TILPreloadInfoVersion(fILManager.BackupManager[i].SaveVersion).Release,
            TILPreloadInfoVersion(fILManager.BackupManager[i].SaveVersion).Build])
        else
          SubItems[1] := 'unknown';
        If fILManager.BackupManager[i].SaveTime <> 0.0 then
          SubItems[2] := IL_FormatDateTime('yyyy-mm-dd  hh:nn:ss',fILManager.BackupManager[i].SaveTime)
        else
          SubItems[2] := 'unknown';
        SubItems[3] := IL_FormatDateTime('yyyy-mm-dd  hh:nn:ss',fILManager.BackupManager[i].BackupTime);
        SubItems[4] := FlagsToStr(fILManager.BackupManager[i].Flags);
      end;
finally
  lvBackups.Items.EndUpdate;
end;
end;

//------------------------------------------------------------------------------

procedure TfBackupsForm.UpdateTitle;
begin
If fILManager.BackupManager.BackupCount > 0 then
  Caption := IL_Format('Backups (%d)',[fILManager.BackupManager.BackupCount])
else
  Caption := 'Backups';
end;

//==============================================================================

procedure TfBackupsForm.Initialize(ILManager: TILManager);
begin
fILManager := ILManager;
end;

//------------------------------------------------------------------------------

procedure TfBackupsForm.Finalize;
begin
// nothing to do
end;

//------------------------------------------------------------------------------

procedure TfBackupsForm.ShowBackups;
begin
FillBackupList;
UpdateTitle;
ShowModal;
end;

//==============================================================================

procedure TfBackupsForm.FormCreate(Sender: TObject);
begin
lvBackups.DoubleBuffered := True;
end;

//------------------------------------------------------------------------------

procedure TfBackupsForm.btnOpenBckFolderClick(Sender: TObject);
begin
IL_ShellOpen(Handle,fILManager.BackupManager.StaticSettings.BackupPath);
end;

//------------------------------------------------------------------------------

procedure TfBackupsForm.pmnBackupsPopup(Sender: TObject);
begin
mniBU_Delete.Enabled := lvBackups.ItemIndex >= 0;
mniBU_Restore.Enabled := lvBackups.ItemIndex >= 0;
mniBU_Backup.Enabled := IL_FileExists(fILManager.BackupManager.StaticSettings.ListFile);
end;

//------------------------------------------------------------------------------

procedure TfBackupsForm.mniBU_DeleteClick(Sender: TObject);
begin
If lvBackups.ItemIndex >= 0 then
  If MessageDlg(IL_Format('Are you sure you want to delete backup file "%s"?',
      [fILManager.BackupManager[lvBackups.ItemIndex].FileName]),
      mtConfirmation,[mbOk,mbCancel],0) = mrOK then
    begin
      fILManager.BackupManager.Delete(lvBackups.ItemIndex);
      fILManager.BackupManager.SaveBackups;
      FillBackupList;
      UpdateTitle;
    end;
end;

//------------------------------------------------------------------------------

procedure TfBackupsForm.mniBU_RestoreClick(Sender: TObject);
var
  DoBackup: Boolean;
begin
If lvBackups.ItemIndex >= 0 then
  begin
  If MessageDlg(IL_Format('Are you sure you want to restore file "%s"?' + sLineBreak +
    'This will replace current list file with the restored one and restarts this program.',
      [fILManager.BackupManager[lvBackups.ItemIndex].FileName]),
      mtConfirmation,[mbOk,mbCancel],0) = mrOK then
    begin
      If IL_FileExists(fILManager.BackupManager.StaticSettings.ListFile) then
        DoBackup := MessageDlg('Backup current list before restoring?',mtConfirmation,[mbYes,mbNo],0) = mrYes
      else
        DoBackup := False;
      fILManager.BackupManager.Restore(lvBackups.ItemIndex,DoBackup);
      FillBackupList;
      UpdateTitle;
      Close;
      If Assigned(OnRestartRequired) then
        OnRestartRequired(Self);
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfBackupsForm.mniBU_BackupClick(Sender: TObject);
begin
If IL_FileExists(fILManager.BackupManager.StaticSettings.ListFile) then
  If MessageDlg('Are you sure you want to perform backup right now?',mtConfirmation,[mbOk,mbCancel],0) = mrOK then
    begin
      fILManager.BackupManager.Backup;
      FillBackupList;
      UpdateTitle;
    end;
end;

end.
