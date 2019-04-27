unit UpdateForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls,
  InflatablesList_Types, InflatablesList, InflatablesList_ThreadedUpdater;

type
  TfUpdateForm = class(TForm)
    pnlInfo: TPanel;
    btnAction: TButton;
    pbProgress: TProgressBar;
    bvlSplit: TBevel;
    lblLog: TLabel;
    meLog: TMemo;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnActionClick(Sender: TObject);
    procedure meLogKeyPress(Sender: TObject; var Key: Char);
  private
    fILManager:       TILManager;
    fShopsToUpdate:   TILItemShopUpdates;
    fLastItemName:    String;
    fProcessedIndex:  Integer;
    fCanContinue:     Boolean;
    fMaxShopNameLen:  Integer;
    fUpdater:         TILThreadedUpdater;
  protected
    procedure ItemFinishHandler(Sender: TObject);
  public
    procedure Initialize(ILManager: TILManager);
    procedure ShowUpdate(ShopsToUpdate: TILItemShopUpdates);
  end;

var
  fUpdateForm: TfUpdateForm;

implementation

{$R *.dfm}

procedure TfUpdateForm.ItemFinishHandler(Sender: TObject);
begin
//log
If not AnsiSameText(fLastItemName,fShopsToUpdate[fProcessedIndex].ItemName) then
  begin
    If meLog.Lines.Count > 0 then
      meLog.Lines.Add('');
    meLog.Lines.Add(fShopsToUpdate[fProcessedIndex].ItemName + sLineBreak);
    fLastItemName := fShopsToUpdate[fProcessedIndex].ItemName;
  end;
If fShopsToUpdate[fProcessedIndex].ItemShopPtr^.Selected then
  meLog.Lines.Add(Format('  * %s %s... %s',[fShopsToUpdate[fProcessedIndex].ItemShopPtr^.Name,
    StringOfChar('.',fMaxShopNameLen - Length(fShopsToUpdate[fProcessedIndex].ItemShopPtr^.Name)),
    fShopsToUpdate[fProcessedIndex].ItemShopPtr^.LastUpdateMsg]))
else
  meLog.Lines.Add(Format('    %s %s... %s',[fShopsToUpdate[fProcessedIndex].ItemShopPtr^.Name,
    StringOfChar('.',fMaxShopNameLen - Length(fShopsToUpdate[fProcessedIndex].ItemShopPtr^.Name)),
    fShopsToUpdate[fProcessedIndex].ItemShopPtr^.LastUpdateMsg]));
// advance
Inc(fProcessedIndex);
If fProcessedIndex <= High(fShopsToUpdate) then
  begin
    // show progress
    If Length(fShopsToUpdate) > 0 then
      pbProgress.Position := Trunc((fProcessedIndex / Length(fShopsToUpdate)) * pbProgress.Max)
    else
      pbProgress.Position := pbProgress.Max;
    pnlInfo.Caption := Format('%d item shops ready for update',[Length(fShopsToUpdate) - fProcessedIndex]);
    // start new processing
    If fCanContinue then
      fUpdater.Process(fShopsToUpdate[fProcessedIndex].ItemShopPtr);
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
end;

//------------------------------------------------------------------------------

procedure TfUpdateForm.ShowUpdate(ShopsToUpdate: TILItemShopUpdates);
var
  i:  Integer;
begin
If Length(ShopsToUpdate) > 0 then
  begin
    fShopsToUpdate := ShopsToUpdate;
    SetLength(fShopsToUpdate,Length(fShopsToUpdate));
    pnlInfo.Caption := Format('%d item shops ready for update',[Length(fShopsToUpdate)]);
    btnAction.Tag := 0;
    btnAction.Caption := 'Start';
    pbProgress.Position := 0;
    meLog.Text := '';
    fLastItemName := '';
    fProcessedIndex := 0;
    fCanContinue := True;
    // calculate indentation correction
    fMaxShopNameLen := 0;
    For i := Low(fShopsToUpdate) to High(fShopsToUpdate) do
      If Length(fShopsToUpdate[i].ItemShopPtr^.Name) > fMaxShopNameLen then
        fMaxShopNameLen := Length(fShopsToUpdate[i].ItemShopPtr^.Name);
    // create updater and show the window
    fUpdater := TILThreadedUpdater.Create;
    try
      fUpdater.OnFinish := ItemFinishHandler;
      ShowModal;
      fUpdater.WaitForThreadToFinish;
    finally
      FreeAndNil(fUpdater);
    end;
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
        fCanContinue := True;        
        btnAction.Tag := 1;
        btnAction.Caption := 'Stop';
        fUpdater.Process(fShopsToUpdate[fProcessedIndex].ItemShopPtr);
      end;
  1:  begin
        // stop
        fCanContinue := False;
        btnAction.Tag := 0;
        btnAction.Caption := 'Start';
        fUpdater.WaitForThreadToFinish;        
      end;
else
  // finished, do nothing
  Close;
end;
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

end.
