unit InflatablesList_Backup2;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

const
  IL_BACKUP_DEFAULT_MAX_DEPTH      = 25;
  IL_BACKUP_DEFAULT_MANGERFILENAME = 'backups.ini';
  
  IL_BACKUP_BACKUP_DIR_SUFFIX = 'list_backup';  // used outside this unit

type
  TILBackupEntry = record
    FileName:   String;
    SaveTime:   TDateTime;    
    BackupTime: TDateTime;
  end;

  TILBackupManager = class(TObject)
  private
    fStoragePath:     String;
    fMaxDepth:        Integer;
    fManagerFileName: String;
    fBackups:         array of TILBackupEntry;
    // getters, setters
    procedure SetMaxDepth(Value: Integer);
    procedure SetManagerFileName(const Value: String);
    Function GetBackupCount: Integer;
    Function GetBackup(Index: Integer): TILBackupEntry;
  protected
    procedure Initialize; virtual;
    procedure Finalize; virtual;
    //Function ScanAndCopyFile(const SrcFileName,DestFileName: String): TDateTime; virtual;
    procedure AddToBeginning(Entry: TILBackupEntry); virtual;
    procedure AddToEnd(Entry: TILBackupEntry); virtual;
  public
    constructor Create(const StoragePath: String);
    constructor CreateAsCopy(Source: TILBackupManager);
    destructor Destroy; override;
    procedure LoadBackups; virtual;
    procedure SaveBackups; virtual;
    //procedure DoBackup(const FileName: String); virtual;
    //procedure RestoreFile(Index: Integer; const Into: String); virtual;
    property StoragePath: String read fStoragePath;
    property MaxDepth: Integer read fMaxDepth write SetMaxDepth;
    property ManagerFileName: String read fManagerFileName write SetManagerFileName;
    property BackupCount: Integer read GetBackupCount;
    property Backups[Index: Integer]: TILBackupEntry read GetBackup; default;
  end;

Function IL_ThreadSafeCopy(Value: TILBackupEntry): TILBackupEntry; overload;

implementation

uses
  SysUtils, IniFiles,
  StrRect, FloatHex,
  InflatablesList_Utils;

Function IL_ThreadSafeCopy(Value: TILBackupEntry): TILBackupEntry;
begin
Result := Value;
UniqueString(Result.FileName);
end;

//==============================================================================

procedure TILBackupManager.SetMaxDepth(Value: Integer);
begin
fMaxDepth := Value;
end;

//------------------------------------------------------------------------------

procedure TILBackupManager.SetManagerFileName(const Value: String);
begin
fManagerFileName := Value;
UniqueString(fManagerFileName);
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

//==============================================================================

procedure TILBackupManager.Initialize;
begin
// fStoragePath is set in constructor;
fMaxDepth := IL_BACKUP_DEFAULT_MAX_DEPTH;
fManagerFileName := IL_BACKUP_DEFAULT_MANGERFILENAME;
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

constructor TILBackupManager.Create(const StoragePath: String);
begin
inherited Create;
fStoragePath := IL_IncludeTrailingPathDelimiter(StoragePath);
Initialize;
end;

//------------------------------------------------------------------------------

constructor TILBackupManager.CreateAsCopy(Source: TILBackupManager);
var
  i:  Integer;
begin
Create(Source.StoragePath);
fMaxDepth := Source.MaxDepth;
fManagerFileName := Source.ManagerFileName;
UniqueString(fManagerFileName);
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

procedure TILBackupManager.LoadBackups;
var
  Ini:  TIniFile;
  i:    Integer;
  Temp: TILBackupEntry;
begin
SetLength(fBackups,0);
Ini := TIniFile.Create(StrToRTL(fStoragePath + fManagerFileName));
try
  For i := 0 to Pred(Ini.ReadInteger('Backups','Count',0)) do
    begin
      If Ini.ValueExists('Backups',IL_Format('Backup[%d].FileName',[i])) and
         Ini.ValueExists('Backups',IL_Format('Backup[%d].SaveTime',[i])) and
         Ini.ValueExists('Backups',IL_Format('Backup[%d].BackupTime',[i])) then
        begin
          Temp.FileName := Ini.ReadString('Backups',IL_Format('Backup[%d].FileName',[i]),'');
          Temp.SaveTime := TDateTime(HexToDouble(Ini.ReadString('Backups',IL_Format('Backup[%d].SaveTime',[i]),'0')));
          Temp.BackupTime := TDateTime(HexToDouble(Ini.ReadString('Backups',IL_Format('Backup[%d].BackupTime',[i]),'0')));
          If IL_FileExists(StrToRTL(fStoragePath + Temp.FileName)) then
            AddToEnd(Temp);
      end;
    end;
finally
  Ini.Free;
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
  If IL_FileExists(fStoragePath + fBackups[i].FileName) then
    IL_DeleteFile(fStoragePath + fBackups[i].FileName);
// truncate the list
If Length(fBackups) > fMaxDepth then
  SetLength(fBackups,fMaxDepth);
// save the list
Ini := TIniFile.Create(StrToRTL(fStoragePath + fManagerFileName));
try
  Ini.WriteInteger('Backups','Count',Length(fBackups));
  For i := Low(fBackups) to High(fBackups) do
    begin
      Ini.WriteString('Backups',Format('Backup[%d].FileName',[i]),fBackups[i].FileName);
      Ini.WriteString('Backups',Format('Backup[%d].SaveTime',[i]),DoubleToHex(Double(fBackups[i].SaveTime)));
      Ini.WriteString('Backups',Format('Backup[%d].BackupTime',[i]),DoubleToHex(Double(fBackups[i].SaveTime)));
    end;
finally
  Ini.Free;
end;
end;

end.
