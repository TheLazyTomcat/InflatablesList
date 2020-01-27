unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, XPMan, Menus, StdCtrls;

type
  TfMainform = class(TForm)
    StatusBar1: TStatusBar;
    XPManifest1: TXPManifest;
    MainMenu1: TMainMenu;
    file1: TMenuItem;
    Button1: TButton;
    procedure StatusBar1DrawPanel(StatusBar: TStatusBar;
      Panel: TStatusPanel; const Rect: TRect);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure file1DrawItem(Sender: TObject; ACanvas: TCanvas;
      ARect: TRect; Selected: Boolean);
  private
    { Private declarations }
  protected
    procedure WndProc(var Msg: TMessage); override;
  public
    { Public declarations }
  end;

var
  fMainform: TfMainform;

implementation

{$R *.dfm}

procedure TfMainform.WndProc(var Msg: TMessage);
begin
If Msg.Msg = WM_DRAWITEM then
  begin
    If PDrawItemStruct(Msg.LParam)^.CtlID = StatusBar1.Handle then
      PDrawItemStruct(Msg.LParam)^.CtlType := 0;
  end;
inherited;
end;

procedure TfMainform.StatusBar1DrawPanel(StatusBar: TStatusBar;
  Panel: TStatusPanel; const Rect: TRect);
begin
StatusBar1.Canvas.Brush.Style := bsSolid;
StatusBar1.Canvas.Brush.Color := clRed;
StatusBar1.Canvas.Rectangle(Rect);
end;

procedure TfMainform.FormCreate(Sender: TObject);
begin
statusbar1.DoubleBuffered := true;
end;

procedure TfMainform.Button1Click(Sender: TObject);
begin
statusbar1.Invalidate;
end;

procedure TfMainform.file1DrawItem(Sender: TObject; ACanvas: TCanvas;
  ARect: TRect; Selected: Boolean);
begin
ACanvas.Brush.Style := bsSolid;
ACanvas.Brush.Color := clGreen;
ACanvas.Rectangle(ARect);
end;

end.
