unit InflatablesList_ThreadedUpdater;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  Classes,
  InflatablesList_Types;

type
  TILUpdaterThread = class(TThread)
  private
    fItemShop:  TILItemShop;
    fSuccess:   Boolean;
    fOnFinish:  TNotifyEvent;
  protected
    procedure sync_DoFinish; virtual;
    procedure Execute; override;
  public
    constructor Create(ItemShop: TILItemShop);
    procedure Run; virtual;
    property ItemShop: TILItemShop read fItemShop; // for result retrieval
    property Success: Boolean read fSuccess;
    property OnFinish: TNotifyEvent read fOnFinish write fOnFinish;
  end;

//******************************************************************************

type
  TILThreadedUpdater = class(TObject)
  private
    fItemShopPtr:   PILItemShop;
    fCurrentThread: TILUpdaterThread;
    fDeferredFree:  array of TILUpdaterThread;
    fOnFinish:      TNotifyEvent;
    Function GetRunning: Boolean;
  protected
    procedure ThreadFinishHandler(Sender: TObject); virtual;
    procedure DeferFree(Thread: TILUpdaterThread); virtual;
    procedure DeferredFree; virtual;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Process(ItemShopPtr: PILItemShop); virtual;
    procedure WaitForThreadToFinish; virtual;
    property OnFinish: TNotifyEvent read fOnFinish write fOnFinish;
    property Running: Boolean read GetRunning;
  end;

implementation

uses
  SysUtils,
  InflatablesList;

procedure TILUpdaterThread.sync_DoFinish;
begin
If Assigned(fOnFinish) then
  fOnFinish(Self);
end;

//------------------------------------------------------------------------------

procedure TILUpdaterThread.Execute;
begin
fSuccess := TILManager.ItemShopUpdate(fItemShop);
Synchronize(sync_DoFinish);
end;

//==============================================================================

constructor TILUpdaterThread.Create(ItemShop: TILItemShop);
begin
inherited Create(True);
FreeOnTerminate := False;
TILManager.ItemShopCopy(ItemShop,fItemShop);
fSuccess := False;
fOnFinish := nil;
end;

//------------------------------------------------------------------------------

procedure TILUpdaterThread.Run;
begin
Resume;
end;

//******************************************************************************

Function TILThreadedUpdater.GetRunning: Boolean;
begin
Result := Assigned(fCurrentThread);
end;

//==============================================================================

procedure TILThreadedUpdater.ThreadFinishHandler(Sender: TObject);
var
  Temp: TILUpdaterThread;
begin
// threaad is stopped by this point, so it shoudl be safe to acces i
fItemShopPtr^.Available := fCurrentThread.ItemShop.Available;
fItemShopPtr^.Price := fCurrentThread.ItemShop.Price;
fItemShopPtr^.LastUpdateMsg := fCurrentThread.ItemShop.LastUpdateMsg;
UniqueString(fItemShopPtr^.LastUpdateMsg);
fItemShopPtr := nil;
Temp := fCurrentThread;
fCurrentThread := nil;
If Assigned(fOnFinish) then
  fOnFinish(Self);
DeferFree(Temp);
end;

//------------------------------------------------------------------------------

procedure TILThreadedUpdater.DeferFree(Thread: TILUpdaterThread);
begin
If Assigned(Thread) then
  begin
    SetLength(fDeferredFree,Length(fDeferredFree) + 1);
    fDeferredFree[High(fDeferredFree)] := Thread;
  end;
end;

//------------------------------------------------------------------------------

procedure TILThreadedUpdater.DeferredFree;
var
  i:  Integer;
begin
For i := Low(fDeferredFree) to High(fDeferredFree) do
  begin
    fDeferredFree[i].WaitFor;
    fDeferredFree[i].Free;
  end;
SetLength(fDeferredFree,0);
end;

//==============================================================================

constructor TILThreadedUpdater.Create;
begin
inherited Create;
fItemShopPtr := nil;
fCurrentThread := nil;
fOnFinish := nil;
end;

//------------------------------------------------------------------------------

destructor TILThreadedUpdater.Destroy;
begin
If Assigned(fCurrentThread) then
  DeferFree(fCurrentThread);
DeferredFree;
inherited;
end;

//------------------------------------------------------------------------------

procedure TILThreadedUpdater.Process(ItemShopPtr: PILItemShop);
begin
DeferredFree;
If Assigned(fCurrentThread) then
  begin
    fCurrentThread.WaitFor;
    DeferFree(fCurrentThread);
    fCurrentThread := nil;
  end;
fItemShopPtr := ItemShopPtr;
fCurrentThread := TILUpdaterThread.Create(fItemShopPtr^);
fCurrentThread.OnFinish := ThreadFinishHandler;
fCurrentThread.Run;
end;
 
//------------------------------------------------------------------------------

procedure TILThreadedUpdater.WaitForThreadToFinish;
begin
DeferredFree;
If Assigned(fCurrentThread) then
  begin
    fCurrentThread.WaitFor;
    DeferFree(fCurrentThread);
    fCurrentThread := nil;
  end;
end;

end.
