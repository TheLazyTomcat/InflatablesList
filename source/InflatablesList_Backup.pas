unit InflatablesList_Backup;{$message 'revisit'}

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

const
  BACKUP_MAX_DEPTH_DEFAULT  = 25;
  BACKUP_UTILFILENAME       = 'backups.ini';
  BACKUP_BACKUP_DIR_DEFAULT = 'list_backup';

procedure DoBackup(const FileName,BackupPath: String);

implementation

uses
  Windows, SysUtils, IniFiles;

type
  TILBackupManager = class(TObject)
  private
    fBackupPath:  String;
    fBackups:     array of String;
    Function GetBackupCount: Integer;
    Function GetBackup(Index: Integer): String;
  protected
    procedure Initialize; virtual;
    procedure Finalize; virtual;
    procedure Add(const FileName: String); virtual;
  public
    constructor Create(const BackupPath: String);
    destructor Destroy; override;
    procedure BackupFile(const FileName: String); virtual;
    property BackupPath: String read fBackupPath;
    property BackupCount: Integer read GetBackupCount;
    property Backups[Index: Integer]: String read GetBackup; default;
  end;

Function TILBackupManager.GetBackupCount: Integer;
begin
Result := Length(fBackups);
end;

//------------------------------------------------------------------------------

Function TILBackupManager.GetBackup(Index: Integer): String;
begin
If (Index >= Low(fBackups)) and (Index <= High(fBackups)) then
  Result := fBackups[Index]
else
  raise Exception.CreateFmt('TILBackupManager.GetBackup: Index (%d) out of bounds.',[Index]);
end;

//==============================================================================

procedure TILBackupManager.Initialize;
var
  Ini:  TIniFile;
  i:    Integer;
  Temp: String;
begin
SetLength(fBackups,0);
Ini := TIniFile.Create(fBackupPath + BACKUP_UTILFILENAME);
try
  For i := 0 to Pred(Ini.ReadInteger('Backups','Count',0)) do
    If Ini.ValueExists('Backups',Format('Backup[%d]',[i])) then
      begin
        Temp := Ini.ReadString('Backups',Format('Backup[%d]',[i]),'');
        If FileExists(fBackupPath + Temp) then
          begin
            // do not use Add here!
            SetLength(fBackups,Length(fBackups) + 1);
            fBackups[High(fBackups)] := Temp;
          end;
      end;
finally
  Ini.Free;
end;
end;

//------------------------------------------------------------------------------

procedure TILBackupManager.Finalize;
var
  i:    Integer;
  Ini:    TIniFile;
begin
// traverse list of backup files and delete all above depth limit
For i := BACKUP_MAX_DEPTH_DEFAULT to High(fBackups) do
  If FileExists(fBackupPath + fBackups[i]) then
    DeleteFile(fBackupPath + fBackups[i]);
// truncate the list
If Length(fBackups) > BACKUP_MAX_DEPTH_DEFAULT then
  SetLength(fBackups,BACKUP_MAX_DEPTH_DEFAULT);
// save the list
Ini := TIniFile.Create(fBackupPath + BACKUP_UTILFILENAME);
try
  Ini.WriteInteger('Backups','Count',Length(fBackups));
  For i := Low(fBackups) to High(fBackups) do
    Ini.WriteString('Backups',Format('Backup[%d]',[i]),fBackups[i]);
finally
  Ini.Free;
end;
end;

//------------------------------------------------------------------------------

procedure TILBackupManager.Add(const FileName: String);
var
  i:  Integer;
begin
SetLength(fBackups,Length(fBackups) + 1);
For i := High(fBackups) downto Succ(Low(fBackups)) do
  fBackups[i] := fBackups[i - 1];
fBackups[Low(fBackups)] := FileName;
end;

//==============================================================================

constructor TILBackupManager.Create(const BackupPath: String);
begin
inherited Create;
fBackupPath := BackupPath;
Initialize;
end;

//------------------------------------------------------------------------------

destructor TILBackupManager.Destroy;
begin
Finalize;
inherited;
end;

//------------------------------------------------------------------------------

procedure TILBackupManager.BackupFile(const FileName: String);
var
  BackupFileName: String;
begin
BackupFileName := FormatDateTime('yyyy-mm-dd-hh-nn-ss-zzz',Now) + '.inl';
If not DirectoryExists(ExtractFileDir(fBackupPath + BackupFileName)) then
  ForceDirectories(ExtractFileDir(fBackupPath + BackupFileName));
If FileExists(fBackupPath + BackupFileName) then
  DeleteFile(fBackupPath + BackupFileName);
CopyFile(PChar(FileName),PChar(fBackupPath + BackupFileName),False);
Add(BackupFileName);
end;

//==============================================================================
//------------------------------------------------------------------------------
//==============================================================================

procedure DoBackup(const FileName,BackupPath: String);
begin
with TILBackupManager.Create(BackupPath) do
try
  BackupFile(FileName);
finally
  Free;
end;
end;

end.
