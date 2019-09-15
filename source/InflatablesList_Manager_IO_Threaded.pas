unit InflatablesList_Manager_IO_Threaded;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  InflatablesList_Types,
  InflatablesList_Manager_IO;

type
  TILManager_IO_Threaded = class(TILManager_IO)
  protected
    procedure LoadedDataCopyHandler(Sender: TObject); virtual;
  public
    procedure LoadFromFileThreaded(EndNotificationHandler: TILLoadingDoneEvent); virtual;
  end;

implementation

uses
  Classes,
  InflatablesList_Manager_Base,
  InflatablesList_Manager;

type
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
fLocalManager := TILManager.CreateAsCopy(ILManager);
fOnEndNotify := EndNotificationHandler;
fOnDataCopy := DataCopyHandler;
fResult := illrSuccess;
end;

//------------------------------------------------------------------------------

destructor TILLoadingThread.Destroy;
begin
fLocalManager.Free;
end;

//==============================================================================
//------------------------------------------------------------------------------
//==============================================================================

procedure TILManager_IO_Threaded.LoadedDataCopyHandler(Sender: TObject);
begin
// sender is expected to be of type TILManager
If Sender is TILManager then
  CopyFrom(TILManager(Sender));
end;

//==============================================================================

procedure TILManager_IO_Threaded.LoadFromFileThreaded(EndNotificationHandler: TILLoadingDoneEvent);
begin
// no need to assign the created object anywhere
TILLoadingThread.Create(Self,EndNotificationHandler,LoadedDataCopyHandler);
end;

end.
