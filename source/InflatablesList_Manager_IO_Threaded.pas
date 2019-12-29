unit InflatablesList_Manager_IO_Threaded;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  Classes,
  InflatablesList_Types,
  InflatablesList_Manager_IO;

type
  TILManager_IO_Threaded = class(TILManager_IO)
  protected
    procedure LoadedDataCopyHandler(Sender: TObject); virtual;
  public
    procedure SaveToFileThreaded(EndNotificationHandler: TNotifyEvent); virtual;
    procedure LoadFromFileThreaded(EndNotificationHandler: TILLoadingDoneEvent); virtual;
  end;

implementation

uses
  InflatablesList_Encryption,
  InflatablesList_Manager_Base,
  InflatablesList_Manager;

type
  TILSavingThread = class(TThread)
  private
    fLocalManager:  TILManager;
    fOnEndNotify:   TNotifyEvent;
  protected
    procedure sync_NotifyEnd; virtual;
    procedure Execute; override;
  public
    constructor Create(ILManager: TILManager_Base; EndNotificationHandler: TNotifyEvent);
    destructor Destroy; override;
  end;

//------------------------------------------------------------------------------

  TILLoadingThread = class(TThread)
  private
    fLocalManager:  TILManager;
    fOnEndNotify:   TILLoadingDoneEvent;
    fOnDataCopy:    TNotifyEvent;
    fResult:        TILLoadingResult;
  protected
    procedure sync_NotifyEnd; virtual;
    procedure sync_CopyData; virtual;
    procedure Execute; override;
  public
    constructor Create(ILManager: TILManager_Base; EndNotificationHandler: TILLoadingDoneEvent; DataCopyHandler: TNotifyEvent);
    destructor Destroy; override;
  end;

//==============================================================================

procedure TILSavingThread.sync_NotifyEnd;
begin
If Assigned(fOnEndNotify) then
  fOnEndNotify(nil);
end;

//------------------------------------------------------------------------------

procedure TILSavingThread.Execute;
begin
try
  fLocalManager.SaveToFile;
except
  // just suppress exceptions
end;
Synchronize(sync_NotifyEnd);
end;

//==============================================================================

constructor TILSavingThread.Create(ILManager: TILManager_Base; EndNotificationHandler: TNotifyEvent);
begin
inherited Create(False);
FreeOnTerminate := True;
{
  do backup here not in thread, changes in backup list are not propagated back
  into main manager
}
If not ILManager.StaticSettings.NoBackup then
  ILManager.BackupManager.Backup;
fLocalManager := TILManager.CreateAsCopy(ILManager,False);
fOnEndNotify := EndNotificationHandler;
end;

//------------------------------------------------------------------------------

destructor TILSavingThread.Destroy;
begin
fLocalManager.Free;
inherited;
end;

//==============================================================================
//------------------------------------------------------------------------------
//==============================================================================

procedure TILLoadingThread.sync_NotifyEnd;
begin
If Assigned(fOnEndNotify) then
  fOnEndNotify(fResult);
end;

//------------------------------------------------------------------------------

procedure TILLoadingThread.sync_CopyData;
begin
If Assigned(fOnDataCopy) then
  fOnDataCopy(fLocalManager);
end;

//------------------------------------------------------------------------------

procedure TILLoadingThread.Execute;
begin
try
  fLocalManager.LoadFromFile;
  fResult := illrSuccess;
  Synchronize(sync_CopyData);
except
  on E: EILWrongPassword do
    fResult := illrWrongPassword
  else
    fResult := illrFailed;
end;
Synchronize(sync_NotifyEnd);
end;

//==============================================================================

constructor TILLoadingThread.Create(ILManager: TILManager_Base; EndNotificationHandler: TILLoadingDoneEvent; DataCopyHandler: TNotifyEvent);
begin
inherited Create(False);
FreeOnTerminate := True;
fLocalManager := TILManager.CreateAsCopy(ILManager,False);
fOnEndNotify := EndNotificationHandler;
fOnDataCopy := DataCopyHandler;
fResult := illrSuccess;
end;

//------------------------------------------------------------------------------

destructor TILLoadingThread.Destroy;
begin
fLocalManager.Free;
inherited;
end;

//==============================================================================
//------------------------------------------------------------------------------
//==============================================================================

procedure TILManager_IO_Threaded.LoadedDataCopyHandler(Sender: TObject);
begin
// sender is expected to be of type TILManager
If Sender is TILManager then
  begin
    CopyFrom(TILManager(Sender),False);
    AssignInternalEventHandlers;
  end;
end;

//==============================================================================

procedure TILManager_IO_Threaded.SaveToFileThreaded(EndNotificationHandler: TNotifyEvent);
begin
// no need to assign the created object anywhere
TILSavingThread.Create(Self,EndNotificationHandler);
end;

//------------------------------------------------------------------------------

procedure TILManager_IO_Threaded.LoadFromFileThreaded(EndNotificationHandler: TILLoadingDoneEvent);
begin
TILLoadingThread.Create(Self,EndNotificationHandler,LoadedDataCopyHandler);
end;

end.
