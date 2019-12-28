unit InflatablesList_Backup;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  AuxTypes,
  InflatablesList_Types;

const
  IL_BACKUP_DEFAULT_MAX_DEPTH      = 25;
  IL_BACKUP_DEFAULT_MANGERFILENAME = 'backups.ini';

  IL_BACKUP_TEMP_SUFFIX = '.tmp';

type
  TILBackupEntry = record
    FileName:     String;     // only file name, not full path
    SaveTime:     TDateTime;
    SaveVersion:  Int64;
    BackupTime:   TDateTime;
    Size:         UInt64;
    Flags:        UInt32;
  end;

  TILBackupManager = class(TObject)
  protected
    fStaticSettings:  TILStaticManagerSettings;
    fMaxDepth:        Integer;
    fUtilFileName:    String;   // only file name, not full path
    fBackups:         array of TILBackupEntry;
    // getters, setters
    procedure SetStaticSettings(Value: TILStaticManagerSettings); virtual;
    procedure SetMaxDepth(Value: Integer);
    procedure SetUtilFileName(const Value: String);
    Function GetBackupCount: Integer;
    Function GetBackup(Index: Integer): TILBackupEntry;
    // other methods
    procedure Initialize; virtual;
    procedure Finalize; virtual;
    procedure AddToBeginning(Entry: TILBackupEntry); virtual;
    procedure AddToEnd(Entry: TILBackupEntry); virtual;
  public
    constructor Create;
    constructor CreateAsCopy(Source: TILBackupManager; UniqueCopy: Boolean);
    destructor Destroy; override;
    procedure Delete(Index: Integer); virtual;
    procedure LoadBackups; virtual;
    procedure SaveBackups; virtual;
    procedure Backup; virtual;
    procedure Restore(Index: Integer; BackupFirst: Boolean = True); virtual;
    property StaticSettings: TILStaticManagerSettings read fStaticSettings write SetStaticSettings;
    property MaxDepth: Integer read fMaxDepth write SetMaxDepth;
    property UtilFileName: String read fUtilFileName write SetUtilFileName;
    property BackupCount: Integer read GetBackupCount;
    property Backups[Index: Integer]: TILBackupEntry read GetBackup; default;
  end;

Function IL_ThreadSafeCopy(Value: TILBackupEntry): TILBackupEntry; overload;

implementation

uses
  SysUtils, IniFiles,
  StrRect, FloatHex, WinFileInfo,
  InflatablesList_Utils,
  InflatablesList_Manager;

Function IL_ThreadSafeCopy(Value: TILBackupEntry): TILBackupEntry;
begin
Result := Value;
UniqueString(Result.FileName);
end;

//==============================================================================

procedure TILBackupManager.SetStaticSettings(Value: TILStaticManagerSettings);
begin
fStaticSettings := IL_ThreadSafeCopy(Value);
end;

//------------------------------------------------------------------------------

procedure TILBackupManager.SetMaxDepth(Value: Integer);
begin
If Value >= 1 then
  fMaxDepth := Value;
end;

//------------------------------------------------------------------------------

procedure TILBackupManager.SetUtilFileName(const Value: String);
begin
fUtilFileName := Value;
UniqueString(fUtilFileName);
end;

//------------------------------------------------------------------------------

Function TILBackupManager.GetBackupCount: Integer;
begin
Result := Length(fBackups);
end;

//------------------------------------------------------------------------------

Function TILBackupManager.GetBackup(Index: Integer): TILBackupEntry;
begin
If (Index >= Low(fBackups)) and (Index <= High(fBackups)) then
  Result := fBackups[Index]
else
  raise Exception.CreateFmt('TILBackupManager.GetBackup: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

procedure TILBackupManager.Initialize;
begin
fMaxDepth := IL_BACKUP_DEFAULT_MAX_DEPTH;
fUtilFileName := IL_BACKUP_DEFAULT_MANGERFILENAME;
SetLength(fBackups,0);
end;

//------------------------------------------------------------------------------

procedure TILBackupManager.Finalize;
begin
SetLength(fBackups,0);
end;

//------------------------------------------------------------------------------

procedure TILBackupManager.AddToBeginning(Entry: TILBackupEntry); 
var
  i:  Integer;
begin
SetLength(fBackups,Length(fBackups) + 1);
For i := High(fBackups) downto Succ(Low(fBackups)) do
  fBackups[i] := fBackups[i - 1];
fBackups[Low(fBackups)] := Entry;
end;

//------------------------------------------------------------------------------

procedure TILBackupManager.AddToEnd(Entry: TILBackupEntry);
begin
SetLength(fBackups,Length(fBackups) + 1);
fBackups[High(fBackups)] := Entry;
end;

//==============================================================================

constructor TILBackupManager.Create;
begin
inherited Create;
Initialize;
end;

//------------------------------------------------------------------------------

constructor TILBackupManager.CreateAsCopy(Source: TILBackupManager; UniqueCopy: Boolean);
var
  i:  Integer;
begin
Create;
fStaticSettings := IL_ThreadSafeCopy(Source.StaticSettings);
fMaxDepth := Source.MaxDepth;
fUtilFileName := Source.UtilFileName;
UniqueString(fUtilFileName);
SetLength(fBackups,Source.BackupCount);
For i := Low(fBackups) to High(fBackups) do
  fBackups[i] := IL_ThreadSafeCopy(Source[i]);
end;

//------------------------------------------------------------------------------

destructor TILBackupManager.Destroy;
begin
Finalize;
inherited;
end;

//------------------------------------------------------------------------------

procedure TILBackupManager.Delete(Index: Integer);
var
  i:  Integer;
begin
If (Index >= Low(fBackups)) and (Index <= High(fBackups)) then
  begin
    // delete the backup file
    IL_DeleteFile(fStaticSettings.BackupPath + fBackups[Index].FileName);
    // remove entry
    For i := Index to Pred(High(fBackups)) do
      fBackups[i] := fBackups[i + 1];
    SetLength(fBackups,Length(fBackups) - 1);
  end
else raise Exception.CreateFmt('TILBackupManager.Delete: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

procedure TILBackupManager.LoadBackups;
var
  Ini:  TIniFile;
  i:    Integer;
  Temp: TILBackupEntry;
begin
SetLength(fBackups,0);
If IL_FileExists(fStaticSettings.BackupPath + fUtilFileName) then
  begin
    Ini := TIniFile.Create(StrToRTL(fStaticSettings.BackupPath + fUtilFileName));
    try
      For i := 0 to Pred(Ini.ReadInteger('Backups','Count',0)) do
        If Ini.ValueExists('Backups',IL_Format('Backup[%d].FileName',[i])) then
          begin
            Temp.FileName := Ini.ReadString('Backups',IL_Format('Backup[%d].FileName',[i]),'');
            Temp.SaveTime := TDateTime(HexToDouble(Ini.ReadString('Backups',IL_Format('Backup[%d].SaveTime',[i]),'0')));
            Temp.SaveVersion := StrToInt64Def('$' + Ini.ReadString('Backups',IL_Format('Backup[%d].SaveVersion',[i]),'0'),0);
            Temp.BackupTime := TDateTime(HexToDouble(Ini.ReadString('Backups',IL_Format('Backup[%d].BackupTime',[i]),'0')));
            Temp.Size := UInt64(StrToInt64Def(Ini.ReadString('Backups',IL_Format('Backup[%d].Size',[i]),'0'),0));
            Temp.Flags := UInt32(StrToIntDef('$' + Ini.ReadString('Backups',IL_Format('Backup[%d].Flags',[i]),'0'),0));
            If IL_FileExists(StrToRTL(fStaticSettings.BackupPath + Temp.FileName)) then
              AddToEnd(Temp);
          end;
    finally
      Ini.Free;
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TILBackupManager.SaveBackups;
var
  i:    Integer;
  Ini:  TIniFile;
begin
// traverse list of backup files and delete all above depth limit
For i := fMaxDepth to High(fBackups) do
  If IL_FileExists(fStaticSettings.BackupPath + fBackups[i].FileName) then
    IL_DeleteFile(fStaticSettings.BackupPath + fBackups[i].FileName);
// truncate the list
If Length(fBackups) > fMaxDepth then
  SetLength(fBackups,fMaxDepth);
// save the list
IL_CreateDirectoryPathForFile(fStaticSettings.BackupPath + fUtilFileName);
Ini := TIniFile.Create(StrToRTL(fStaticSettings.BackupPath + fUtilFileName));
try
  Ini.WriteInteger('Backups','Count',Length(fBackups));
  For i := Low(fBackups) to High(fBackups) do
    begin
      Ini.WriteString('Backups',IL_Format('Backup[%d].FileName',[i]),fBackups[i].FileName);
      Ini.WriteString('Backups',IL_Format('Backup[%d].SaveTime',[i]),DoubleToHex(Double(fBackups[i].SaveTime)));
      Ini.WriteString('Backups',IL_Format('Backup[%d].SaveVersion',[i]),IntToHex(fBackups[i].SaveVersion,16));
      Ini.WriteString('Backups',IL_Format('Backup[%d].BackupTime',[i]),DoubleToHex(Double(fBackups[i].BackupTime)));
      Ini.WriteString('Backups',IL_Format('Backup[%d].Size',[i]),IntToStr(Int64(fBackups[i].Size)));
      Ini.WriteString('Backups',IL_Format('Backup[%d].Flags',[i]),IntToHex(fBackups[i].Flags,8));
    end;
finally
  Ini.Free;
end;
end;

//------------------------------------------------------------------------------

procedure TILBackupManager.Backup;
var
  Time:     TDateTime;
  Temp:     TILBackupEntry;
  Preload:  TILPreloadInfo;
begin
If IL_FileExists(fStaticSettings.ListFile) then
  begin
    // fill entry
    Time := Now;
    Temp.FileName := IL_FormatDateTime('yyyy-mm-dd-hh-nn-ss-zzz',Time) + '.inl';
    with TILManager.CreateTransient do
    try
      Preload := PreloadFile(fStaticSettings.ListFile);
      If ilprfExtInfo in Preload.ResultFlags then
        begin
          Temp.SaveTime := Preload.Time;
          Temp.SaveVersion := Preload.Version.Full;
          Temp.Flags := Preload.Flags;
        end
      else
        begin
          Temp.SaveTime := 0.0;
          Temp.SaveVersion := 0;
          Temp.Flags := 0;
        end;
    finally
      Free;
    end;
    Temp.BackupTime := Time;
    with TWinFileInfo.Create(fStaticSettings.ListFile,WFI_LS_LoadSize) do
    try
      Temp.Size := Size;
    finally
      Free;
    end;
    // do file copy
    IL_CreateDirectoryPath(fStaticSettings.BackupPath);
    If IL_FileExists(fStaticSettings.BackupPath + Temp.FileName) then
      IL_DeleteFile(fStaticSettings.BackupPath + Temp.FileName);  // to be sure
    IL_CopyFile(fStaticSettings.ListFile,fStaticSettings.BackupPath + Temp.FileName);
    // add entry
    AddToBeginning(Temp);
    // save new list of backups (also deletes old backups)
    SaveBackups;
  end;
end;

//------------------------------------------------------------------------------

procedure TILBackupManager.Restore(Index: Integer; BackupFirst: Boolean = True);
var
  TempFileName: String;
begin
If (Index >= Low(fBackups)) and (Index <= High(fBackups)) then
  begin
    If BackupFirst then
      begin
        {
          backup will be called...
            - make copy of restored file
            - do backup (might delete the restored file)
            - delete list file
            - move copy of restored file (rename it in the process)
        }
        TempFileName := fStaticSettings.TempPath + fBackups[Index].FileName + IL_BACKUP_TEMP_SUFFIX;
        IL_CopyFile(fStaticSettings.BackupPath + fBackups[Index].FileName,TempFileName);
        Backup;
        IL_DeleteFile(fStaticSettings.ListFile);
        IL_MoveFile(TempFileName,fStaticSettings.ListFile);
      end
    else
      begin
        // no backup will be performed, delete list file and restore selected backup
        IL_DeleteFile(fStaticSettings.ListFile);
        IL_CopyFile(fStaticSettings.BackupPath + fBackups[Index].FileName,fStaticSettings.ListFile);
      end;
  end
else raise Exception.CreateFmt('TILBackupManager.Restore: Index (%d) out of bounds.',[Index]);
end;

end.
