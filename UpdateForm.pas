unit UpdateForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Spin,
  ConcurrentTasks,
  InflatablesList_Item,
  InflatablesList_ItemShop,
  InflatablesList_Manager;

type
  TILItemShopUpdateItem = record
    Item:       TILItem;
    ItemTitle:  String;
    ItemShop:   TILItemShop;
    Done:       Boolean;
  end;

  TILItemShopUpdateList = array of TILItemShopUpdateItem;

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
    fUpdateList:      TILItemShopUpdateList;
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
    procedure Finalize;
    Function ShowUpdate(var UpdateList: TILItemShopUpdateList): Boolean;
  end;

var
  fUpdateForm: TfUpdateForm;

implementation

uses
  StrRect,
  InflatablesList_Utils;

{$R *.dfm}

const
  IL_NR_OF_THREADS_COEF = 2;

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
var
  Index:  Integer;
begin
inherited Create;
fProcessingIndex := ProcessingIndex;
fItemShop := TILItemShop.CreateAsCopy(ItemShop);
// resolve reference and make local copy of processing settings
Index := ILManager.ShopTemplateIndexOf(fItemShop.ParsingSettings.TemplateReference);
If Index >= 0 then
  fItemShop.ReplaceParsingSettings(ILManager.ShopTemplates[Index].ParsingSettings);
end;

//------------------------------------------------------------------------------

destructor TILUpdateTask.Destroy;
begin
fItemShop.Free;
inherited;
end;

//------------------------------------------------------------------------------

Function TILUpdateTask.Main: Boolean;
begin
If not Terminated then
  Result := fItemShop.Update
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
If not IL_SameText(fLastItemName,fUpdateList[Index].ItemTitle) then
  begin
    If meLog.Lines.Count > 0 then
      meLog.Lines.Add('');  // empty line
    meLog.Lines.Add(fUpdateList[Index].ItemTitle + sLineBreak);
    fLastItemName := fUpdateList[Index].ItemTitle;
  end;
If fUpdateList[Index].ItemShop.Selected then
  TagStr := '  * '
else
  TagStr := '    ';
meLog.Lines.Add(IL_Format('%s%s %s... %s',[TagStr,fUpdateList[Index].ItemShop.Name,
  StringOfChar('.',fMaxShopNameLen - Length(fUpdateList[Index].ItemShop.Name)),
  fUpdateList[Index].ItemShop.LastUpdateMsg]));
end;

//------------------------------------------------------------------------------

procedure TfUpdateForm.ContinueProcessing;
var
  Index:  Integer;
begin
If Assigned(fUpdater) and fCanContinue then
  while (fProcessedIndex <= High(fUpdateList)) and
    (fUpdater.GetActiveTaskCount < fUpdater.MaxConcurrentTasks) do
    begin
      Index := fUpdater.AddTask(
        TILUpdateTask.Create(fILManager,fUpdateList[fProcessedIndex].ItemShop,fProcessedIndex));
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
    fUpdateList[ProcessingIndex].ItemShop.SetValues(ItemShop.LastUpdateMsg,
      ItemShop.LastUpdateRes,ItemShop.Available,ItemShop.Price);
    fUpdateList[ProcessingIndex].Done := True;
  end;
// log
while fLoggedIndex <= High(fUpdateList) do
  begin
    If fUpdateList[fLoggedIndex].Done then
      begin
        MakeLog(fLoggedIndex);
        Inc(fLoggedIndex);
      end
    else Break{while...};
  end;
//progress
If fDoneCount < Length(fUpdateList) then
  begin
    // show progress
    If Length(fUpdateList) > 0 then
      pbProgress.Position := Trunc((fDoneCount / Length(fUpdateList)) * pbProgress.Max)
    else
      pbProgress.Position := pbProgress.Max;
    pnlInfo.Caption := IL_Format('%d item shops ready for update',[Length(fUpdateList) - fDoneCount]);
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
seNumberOfThreads.Value := TCNTSManager.GetProcessorCount * IL_NR_OF_THREADS_COEF;
end;

//------------------------------------------------------------------------------

procedure TfUpdateForm.Finalize;
begin
// nothing to do here
end;

//------------------------------------------------------------------------------

Function TfUpdateForm.ShowUpdate(var UpdateList: TILItemShopUpdateList): Boolean;
var
  i:  Integer;
begin
Result := False;
If Length(UpdateList) > 0 then
  begin
    // init form
    pnlInfo.Caption := IL_Format('%d item shops ready for update',[Length(UpdateList)]);
    btnAction.Tag := 0;
    btnAction.Caption := 'Start';
    pbProgress.Position := 0;
    meLog.Clear;
    // init list of shops for processing
    fUpdateList := UpdateList;
    For i := Low(fUpdateList) to High(fUpdateList) do
      fUpdateList[i].Done := False;  // should be false atm, but to be sure
    // init processing vars
    fProcessedIndex := 0;
    fLoggedIndex := 0;
    fDoneCount := 0;
    fLastItemName := '';
    // calculate indentation correction
    fMaxShopNameLen := 0;
    For i := Low(fUpdateList) to High(fUpdateList) do
      If Length(fUpdateList[i].ItemShop.Name) > fMaxShopNameLen then
        fMaxShopNameLen := Length(fUpdateList[i].ItemShop.Name);
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
    // save log
    If (meLog.Lines.Count > 0) and not fILManager.StaticSettings.NoUpdateAutoLog then
      meLog.Lines.SaveToFile(StrToRTL(fILManager.StaticSettings.ListPath +
        IL_ExtractFileNameNoExt(fILManager.StaticSettings.ListFile) + '.update.log'));
    // return the changed list (done flag is used)
    UpdateList := fUpdateList;
    // indicate whether something was done
    For i := Low(UpdateList) to High(UpdateList) do
      If UpdateList[i].Done then
        begin
          Result := True;
          Break{For i};
        end;
  end
else MessageDlg('No shop to update.',mtInformation,[mbOK],0);
end;

//==============================================================================

procedure TfUpdateForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
fCanContinue := False;
CanClose := True;
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
If Assigned(fUpdater) then
  begin
    fUpdater.Update;
    fUpdater.ClearCompletedTasks;
    If fCanContinue then
      ContinueProcessing;
  end;
end;

end.
