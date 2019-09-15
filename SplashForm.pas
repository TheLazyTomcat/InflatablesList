unit SplashForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  InflatablesList_Manager;

type
  TfSplashForm = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    fILManager:           TILManager;
    fSplashBitmap:        TBitmap;
    fSplashPosition:      TPoint;
    fSplashSize:          TSize;
    fSplashBlendFunction: TBlendFunction;
  public
    { Public declarations }
    procedure Initialize(ILManager: TILManager);
    procedure Finalize;
    procedure ShowSplash;
  end;

var
  fSplashForm: TfSplashForm;

implementation

uses
  StrRect;

{$R *.dfm}

// resource containing the splash bitmap
{$R '..\resources\splash.res'}

procedure TfSplashForm.Initialize(ILManager: TILManager);
begin
fILManager := ILManager;
end;

//------------------------------------------------------------------------------

procedure TfSplashForm.Finalize;
begin
// nothing to do
end;

//------------------------------------------------------------------------------

procedure TfSplashForm.ShowSplash;
begin
Show;
end;

//==============================================================================

procedure TfSplashForm.FormCreate(Sender: TObject);
var
  ResStream:  TResourceStream;
begin
// this all must be here, because the window is shown before a call to initialize
// get splash bitmap
ResStream := TResourceStream.Create(hInstance,StrToRTL('splash'),PChar(10){RT_RCDATA});
try
  ResStream.Seek(0,soBeginning);
  fSplashBitmap := TBitmap.Create;
  fSplashBitmap.LoadFromStream(ResStream);
finally
  ResStream.Free;
end;
// fill some required info
fSplashPosition := Point(0,0);
fSplashSize.cx := fSplashBitmap.Width;
fSplashSize.cy := fSplashBitmap.Height;
fSplashBlendFunction.BlendOp := AC_SRC_OVER;
fSplashBlendFunction.BlendFlags := 0;
fSplashBlendFunction.SourceConstantAlpha := 255;
fSplashBlendFunction.AlphaFormat := AC_SRC_ALPHA;
// adjust window style, size and position
BorderStyle := bsNone;
FormStyle := fsStayOnTop;
ClientWidth := fSplashBitmap.Width;
ClientHeight := fSplashBitmap.Height;
Position := poScreenCenter;
// layered window calls (low-level)
SetWindowLong(Handle,GWL_EXSTYLE,GetWindowLong(Handle,GWL_EXSTYLE) or WS_EX_LAYERED);
UpdateLayeredWindow(Handle,0,nil,@fSplashSize,fSplashBitmap.Canvas.Handle,@fSplashPosition,0,@fSplashBlendFunction,ULW_ALPHA);
end;

//------------------------------------------------------------------------------

procedure TfSplashForm.FormDestroy(Sender: TObject);
begin
FreeAndNil(fSplashBitmap);
end;

end.
