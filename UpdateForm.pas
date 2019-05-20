unit UpdateForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Spin,
  ConcurrentTasks,
  InflatablesList_Types, InflatablesList;

type
  TfUpdateForm = class(TForm)
    pnlInfo: TPanel;
    btnAction: TButton;
    pbProgress: TProgressBar;
    seNumberOfThreads: TSpinEdit;
    lblNumberOfThreads: TLabel;    
    bvlSplit: TBevel;
    lblLog: TLabel;
    meLog: TMemo;
    tmrUpdate: TTimer;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnActionClick(Sender: TObject);
    procedure seNumberOfThreadsChange(Sender: TObject);
    procedure meLogKeyPress(Sender: TObject; var Key: Char);
    procedure tmrUpdateTimer(Sender: TObject);
  private
    fILManager:       TILManager;
    fShopsToUpdate:   TILItemShopUpdates;
    fUpdater:         TCNTSManager;
    fCanContinue:     Boolean;
    fProcessedIndex:  Integer;  // index of next item to be processed
    fLoggedIndex:     Integer;  // index of next item to be logged
    fDoneCount:       Integer;
    fLastItemName:    String;
    fMaxShopNameLen:  Integer;
  protected
    procedure MakeLog(Index: Integer);
    procedure ContinueProcessing;
    procedure TaskFinishHandler(Sender: TObject; TaskIndex: Integer);
  public
    procedure Initialize(ILManager: TILManager);
    procedure ShowUpdate(ShopsToUpdate: TILItemShopUpdates);
  end;

var
  fUpdateForm: TfUpdateForm;

implementation

{$R *.dfm}

const
  NR_OF_THREADS_COEF = 2;

//==============================================================================  

type
  TILUpdateTask = class(TCNTSTask)
  private
    fProcessingIndex: Integer;
    fItemShop:        TILItemShop;
  public
    constructor Create(ILManager: TILManager; ItemShop: TILItemShop; ProcessingIndex: Integer);
    destructor Destroy; override;
    Function Main: Boolean; override;
    property ProcessingIndex: Integer read fProcessingIndex;
    property ItemShop: TILItemShop read fItemShop;
  end;

//==============================================================================

constructor TILUpdateTask.Create(ILManager: TILManager; ItemShop: TILItemShop; ProcessingIndex: Integer);
begin
inherited Create;
fProcessingIndex := ProcessingIndex;
ILManager.ItemShopCopyForUpdate(ItemShop,fItemShop);
end;

//------------------------------------------------------------------------------

destructor TILUpdateTask.Destroy;
begin
TILManager.ItemShopFinalize(fItemShop);
inherited;
end;

//------------------------------------------------------------------------------

Function TILUpdateTask.Main: Boolean;
begin
If not Terminated then
  Result := TILManager.ItemShopUpdate(fItemShop)
else
  Result := False;
Cycle;
end;

//==============================================================================
//------------------------------------------------------------------------------
//==============================================================================

procedure TfUpdateForm.MakeLog(Index: Integer);
var
  TagStr: String;
begin
If not AnsiSameText(fLastItemName,fShopsToUpdate[Index].ItemName) then
  begin
    If meLog.Lines.Count > 0 then
      meLog.Lines.Add('');
    meLog.Lines.Add(fShopsToUpdate[Index].ItemName + sLineBreak);
    fLastItemName := fShopsToUpdate[Index].ItemName;
  end;
If fShopsToUpdate[Index].ItemShopPtr^.Selected then
  TagStr := '  * '
else
  TagStr := '    ';
meLog.Lines.Add(Format('%s%s %s... %s',[TagStr,fShopsToUpdate[Index].ItemShopPtr^.Name,
  StringOfChar('.',fMaxShopNameLen - Length(fShopsToUpdate[Index].ItemShopPtr^.Name)),
  fShopsToUpdate[Index].ItemShopPtr^.LastUpdateMsg]));
end;

//------------------------------------------------------------------------------

procedure TfUpdateForm.ContinueProcessing;
var
  Index:  Integer;
begin
If Assigned(fUpdater) and fCanContinue then
  while (fProcessedIndex <= High(fShopsToUpdate)) and
    (fUpdater.GetActiveTaskCount < fUpdater.MaxConcurrentTasks) do
    begin
      Index := fUpdater.AddTask(
        TILUpdateTask.Create(fILManager,fShopsToUpdate[fProcessedIndex].ItemShopPtr^,fProcessedIndex));
      fUpdater.StartTask(Index);
      Inc(fProcessedIndex);
    end;
end;

//------------------------------------------------------------------------------

procedure TfUpdateForm.TaskFinishHandler(Sender: TObject; TaskIndex: Integer);
begin
Inc(fDoneCount);
// retrieve results from the task
with TILUpdateTask(fUpdater.Tasks[TaskIndex].TaskObject) do
  begin
    fShopsToUpdate[ProcessingIndex].ItemShopPtr^.Available := ItemShop.Available;
    fShopsToUpdate[ProcessingIndex].ItemShopPtr^.Price := ItemShop.Price;
    fShopsToUpdate[ProcessingIndex].ItemShopPtr^.LastUpdateRes := ItemShop.LastUpdateRes;
    fShopsToUpdate[ProcessingIndex].ItemShopPtr^.LastUpdateMsg := ItemShop.LastUpdateMsg;
    UniqueString(fShopsToUpdate[ProcessingIndex].ItemShopPtr^.LastUpdateMsg);
    fShopsToUpdate[ProcessingIndex].Done := True;
  end;
// log
while fLoggedIndex <= High(fShopsToUpdate) do
  begin
  If fShopsToUpdate[fLoggedIndex].Done then
    begin
      MakeLog(fLoggedIndex);
      Inc(fLoggedIndex);
    end
  else Break{while...};
  end;
//progress
If fDoneCount < Length(fShopsToUpdate) then
  begin
    // show progress
    If Length(fShopsToUpdate) > 0 then
      pbProgress.Position := Trunc((fDoneCount / Length(fShopsToUpdate)) * pbProgress.Max)
    else
      pbProgress.Position := pbProgress.Max;
    pnlInfo.Caption := Format('%d item shops ready for update',[Length(fShopsToUpdate) - fDoneCount]);
  end
else
  begin
    pnlInfo.Caption := 'All shops updated, see log for details';
    pbProgress.Position := pbProgress.Max;
    btnAction.Tag := 2;
    btnAction.Caption := 'Done';
  end;
end;

//==============================================================================

procedure TfUpdateForm.Initialize(ILManager: TILManager);
begin
fILManager := ILManager;
fUpdater := nil;
seNumberOfThreads.Value := TCNTSManager.GetProcessorCount * NR_OF_THREADS_COEF;
end;

//------------------------------------------------------------------------------

procedure TfUpdateForm.ShowUpdate(ShopsToUpdate: TILItemShopUpdates);
var
  i:  Integer;
begin
If Length(ShopsToUpdate) > 0 then
  begin
    // init form
    pnlInfo.Caption := Format('%d item shops ready for update',[Length(ShopsToUpdate)]);
    btnAction.Tag := 0;
    btnAction.Caption := 'Start';
    pbProgress.Position := 0;
    meLog.Clear;
    // init list of shops for processing
    fShopsToUpdate := ShopsToUpdate;
    SetLength(fShopsToUpdate,Length(fShopsToUpdate));
    For i := Low(fShopsToUpdate) to High(fShopsToUpdate) do
      fShopsToUpdate[i].Done := False;  // should be false atm, but to be sure
    // init processing vars
    fProcessedIndex := 0;
    fLoggedIndex := 0;
    fDoneCount := 0;
    fLastItemName := '';
    // calculate indentation correction
    fMaxShopNameLen := 0;
    For i := Low(fShopsToUpdate) to High(fShopsToUpdate) do
      If Length(fShopsToUpdate[i].ItemShopPtr^.Name) > fMaxShopNameLen then
        fMaxShopNameLen := Length(fShopsToUpdate[i].ItemShopPtr^.Name);
    // create updater and show the window
    tmrUpdate.Enabled := True;
    fUpdater := TCNTSManager.Create(True);
    try
      fUpdater.MaxConcurrentTasks := seNumberOfThreads.Value;
      fUpdater.OnTaskCompleted := TaskFinishHandler;
      fCanContinue := False;
      ShowModal;
      fUpdater.WaitForRunningTasksToComplete;
    finally
      FreeAndNil(fUpdater);
    end;
    tmrUpdate.Enabled := False;
    If meLog.Lines.Count > 0 then
      meLog.Lines.SaveToFile(ExtractFilePath(ParamStr(0)) + 'list.update.log');
  end
else MessageDlg('No shop to update.',mtInformation,[mbOK],0);
end;

//==============================================================================

procedure TfUpdateForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
fCanContinue := False;
end;

//------------------------------------------------------------------------------

procedure TfUpdateForm.btnActionClick(Sender: TObject);
begin
case btnAction.Tag of
  0:  begin
        // start
        btnAction.Tag := 1;
        btnAction.Caption := 'Stop';
        fCanContinue := True;
        ContinueProcessing;
      end;
  1:  begin
        // stop
        btnAction.Tag := 0;
        btnAction.Caption := 'Start';
        fCanContinue := False;
      end;
else
  // finished, do nothing
  Close;
end;
end;

//------------------------------------------------------------------------------

procedure TfUpdateForm.seNumberOfThreadsChange(Sender: TObject);
begin
If Assigned(fUpdater) then
  fUpdater.MaxConcurrentTasks := seNumberOfThreads.Value;
end;

//------------------------------------------------------------------------------

procedure TfUpdateForm.meLogKeyPress(Sender: TObject; var Key: Char);
begin
If Key = ^A then
  begin
    meLog.SelectAll;
    Key := #0;
  end;
end;

//------------------------------------------------------------------------------

procedure TfUpdateForm.tmrUpdateTimer(Sender: TObject);
begin
if Assigned(fUpdater) then
  begin
    fUpdater.Update;
    fUpdater.ClearCompletedTasks;
    If fCanContinue then
      ContinueProcessing;
  end;
end;

end.
