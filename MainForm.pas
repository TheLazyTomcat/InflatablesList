unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, XPMan;

type
  TfMainform = class(TForm)
    StatusBar1: TStatusBar;
    XPManifest1: TXPManifest;
    procedure StatusBar1DrawPanel(StatusBar: TStatusBar;
      Panel: TStatusPanel; const Rect: TRect);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fMainform: TfMainform;

implementation

{$R *.dfm}

procedure TfMainform.StatusBar1DrawPanel(StatusBar: TStatusBar;
  Panel: TStatusPanel; const Rect: TRect);
begin
StatusBar1.Canvas.Brush.Style := bsSolid;
StatusBar1.Canvas.Brush.Color := clRed;
StatusBar1.Canvas.Rectangle(Rect);
end;

end.
