unit SplashForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  InflatablesList_Manager;

type
  TfSplashForm = class(TForm)
  private
    { Private declarations }
    fILManager: TILManager;
  public
    { Public declarations }
    procedure Initialize(ILManager: TILManager);
    procedure Finalize;
    procedure ShowSplash;
  end;

var
  fSplashForm: TfSplashForm;

implementation

{$R *.dfm}

procedure TfSplashForm.Initialize(ILManager: TILManager);
begin
fILManager := ILManager;
end;

//------------------------------------------------------------------------------

procedure TfSplashForm.Finalize;
begin
// nothing to do;
end;

//------------------------------------------------------------------------------

procedure TfSplashForm.ShowSplash;
begin
//Application.ShowMainForm := False;
Show;
end;

end.
