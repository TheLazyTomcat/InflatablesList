unit UpdResLegendForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  InflatablesList_Manager;

type
  TfUpdResLegendForm = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    fILManager: TILManager;
  protected
    procedure BuildForm;
  public
    { Public declarations }
    procedure Initialize(ILManager: TILManager);
    procedure Finalize;
    procedure ShowLegend;
  end;

var
  fUpdResLegendForm: TfUpdResLegendForm;

implementation

{$R *.dfm}

uses
  InflatablesList_Types;

procedure TfUpdResLegendForm.BuildForm;
const
  BOX_WIDTH = 33;
  BOX_HEIGH = 33;
  TEXT_VSPACE = 15;
  RES_NAMES: array[TILItemShopUpdateResult] of String = (
    'Success','Mild success','Data fail','Soft fail','Hard fail',
    'Download fail','Parsing fail','Fatal error');
  RES_TEXTS: array[TILItemShopUpdateResult] of String = (
    'Update was completed succesfully',
    'Successful update on untracked link',
    'No download link or no parsing data',
    'Failed to find or extract available count',
    'Failed to find or extract price',
    'Download was not successfull',
    'Failed parsing of downloaded page',
    'Unknown exception or other fatal error occured');
var
  CurrentRes: TILItemShopUpdateResult;
  VOrigin:    Integer;
  TempShape:  TShape;
  TempLabel:  TLabel;
  MaxWidth:   Integer;
begin
VOrigin := 8;
MaxWidth := 0;
For CurrentRes := Low(TILItemShopUpdateResult) to High(TILItemShopUpdateResult) do
  begin
    // box
    TempShape := TShape.Create(Self);
    TempShape.Parent := Self;
    TempShape.Width := BOX_WIDTH;
    TempShape.Height := BOX_HEIGH;
    TempShape.Pen.Style := psClear;
    TempShape.Brush.Color := IL_ItemShopUpdateResultToColor(CurrentRes);
    TempShape.Left := 8;
    TempShape.Top := VOrigin;
    // name label
    TempLabel := TLabel.Create(Self);
    TempLabel.Parent := Self;
    TempLabel.Left := BOX_WIDTH + 15;
    TempLabel.Top := VOrigin + 2;
    TempLabel.Font.Style := [fsBold];
    TempLabel.Caption := RES_NAMES[CurrentRes];
    If TempLabel.Width > MaxWidth then
      MaxWidth := TempLabel.Width;
    // text label
    TempLabel := TLabel.Create(Self);
    TempLabel.Parent := Self;
    TempLabel.Left := BOX_WIDTH + 16;
    TempLabel.Top := VOrigin + TEXT_VSPACE;
    TempLabel.Caption := RES_TEXTS[CurrentRes];
    If TempLabel.Width > MaxWidth then
      MaxWidth := TempLabel.Width;
    // move origin
    Inc(VOrigin,BOX_HEIGH + 8);
  end;
Self.ClientHeight := VOrigin;
Self.ClientWidth := MaxWidth + BOX_WIDTH + 24;
end;

//==============================================================================

procedure TfUpdResLegendForm.Initialize(ILManager: TILManager);
begin
fILManager := ILManager;
end;

//------------------------------------------------------------------------------

procedure TfUpdResLegendForm.Finalize;
begin
// nothing to do here
end;

//------------------------------------------------------------------------------

procedure TfUpdResLegendForm.ShowLegend;
begin
ShowModal;
end;

//==============================================================================

procedure TfUpdResLegendForm.FormCreate(Sender: TObject);
begin
BuildForm;
end;

end.
