unit SaveForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  SimpleTimer,
  InflatablesList_Manager;

type
  TfSaveForm = class(TForm)
    bvlInnerFrame: TBevel;
    lblText: TLabel;
    bvlOuterFrame: TBevel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    fILManager: TILManager;
    fRunTimer:  TSimpleTimer;
  protected
    procedure SavingDoneHandler(Sender: TObject);
    procedure OnRunTimerHandler(Sender: TObject);
  public
    { Public declarations }
    procedure Initialize(ILManager: TILManager);
    procedure Finalize;
    procedure ShowAndPerformSave;
  end;

var
  fSaveForm: TfSaveForm;

implementation

{$R *.dfm}

procedure TfSaveForm.SavingDoneHandler(Sender: TObject);
begin
Close;
end;

//------------------------------------------------------------------------------

procedure TfSaveForm.OnRunTimerHandler(Sender: TObject);
begin
fRunTimer.Enabled := False;
fILManager.SaveToFileThreaded(SavingDoneHandler);
end;

//==============================================================================

procedure TfSaveForm.Initialize(ILManager: TILManager);
begin
fILManager := ILManager;
end;

//------------------------------------------------------------------------------

procedure TfSaveForm.Finalize;
begin
// nothing to do
end;

//------------------------------------------------------------------------------

procedure TfSaveForm.ShowAndPerformSave;
begin
fRunTimer.Enabled := True;
ShowModal;
end;

//==============================================================================

procedure TfSaveForm.FormCreate(Sender: TObject);
begin
fRunTimer := TSimpleTimer.Create;
fRunTimer.Enabled := False;
fRunTimer.Interval := 500; // 0.5s delay
fRunTimer.OnTimer := OnRunTimerHandler;
end;

//------------------------------------------------------------------------------

procedure TfSaveForm.FormDestroy(Sender: TObject);
begin
FreeAndNil(fRunTimer);
end;

end.
