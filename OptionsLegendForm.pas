unit OptionsLegendForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,
  InflatablesList_Manager;

type
  TfOptionsLegendForm = class(TForm)
    grbStaticOptions: TGroupBox;
    grbOptions: TGroupBox;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    fILManager: TILManager;
  protected
    procedure BuildForm;
  public
    { Public declarations }
    procedure Initialize(ILManager: TILManager);
    procedure ShowLegend;
  end;

var
  fOptionsLegendForm: TfOptionsLegendForm;

implementation

uses
  InflatablesList_Types;

{$R *.dfm}

procedure TfOptionsLegendForm.BuildForm;
const
  STAT_OPT_CMDS: array[0..Pred(Length(IL_STAT_OPT_TAGS))] of String = (
    'no_pics','test_code','save_pages','load_pages','no_save','no_backup',
    'no_updlog','list_override <filename>');
  STAT_OPT_DESCR: array[0..Pred(Length(IL_STAT_OPT_TAGS))] of String = (
    'Pictures are not shown in the list and in the item header.',
    'Test code is executed.',
    'Pages downloaded during updates are saved to the disk.',
    'Pages required during updates are not downloaded from internet, they are instead loaded from the disk.',
    'Saving of the list (both implicit and explicit) is disabled.',
    'Automatic backup during saving of the list is not performed (has no meaning when saving is disabled).',
    'Update log is not automatically saved.',
    'Overrides file name of loaded and saved list file, also disables automatic backups (equivalent to no_backup).');
  OPTIONS_TAGS: array[0..0] of String = (
    's.rev');
  OPTIONS_DESCR: array[0..Pred(Length(OPTIONS_TAGS))] of String = (
    'Reversed sorting is activated.');
  LABELS_SPACE = 8;
  LABELS_HEIGHT = 16;
var
  TempInt:    Integer;
  i:          Integer;
  TempLabel:  TLabel;

  Function AddLabel(Parent: TWinControl; Left, Top: Integer; FontStyles: TFontStyles; const Caption: String): TLabel;
  begin
    Result := TLabel.Create(Self);
    Result.Parent := Parent;
    Result.Left := Left;
    Result.Top := Top;
    Result.Font.Style := FontStyles;
    Result.Caption := Caption;
  end;

begin
// add static options
TempInt := 2 * LABELS_SPACE;
grbStaticOptions.Tag := grbStaticOptions.Width;
For i := Low(IL_STAT_OPT_TAGS) to High(IL_STAT_OPT_TAGS) do
  begin
    // tag
    TempLabel := AddLabel(grbStaticOptions,LABELS_SPACE,TempInt,[fsBold],IL_STAT_OPT_TAGS[i]);
    // command
    TempLabel := AddLabel(grbStaticOptions,TempLabel.BoundsRect.Right + LABELS_SPACE,TempInt,[],STAT_OPT_CMDS[i]);
    If (TempLabel.BoundsRect.Right + LABELS_SPACE) > grbStaticOptions.Tag then
      grbStaticOptions.Tag := TempLabel.BoundsRect.Right + LABELS_SPACE;
    // description
    TempLabel := AddLabel(grbStaticOptions,LABELS_SPACE,TempInt + LABELS_HEIGHT,[],STAT_OPT_DESCR[i]);
    If (TempLabel.BoundsRect.Right + LABELS_SPACE) > grbStaticOptions.Tag then
      grbStaticOptions.Tag := TempLabel.BoundsRect.Right + LABELS_SPACE;
    Inc(TempInt,(2 * LABELS_HEIGHT) + LABELS_SPACE);
  end;
// adjust box size
If grbStaticOptions.Width < grbStaticOptions.Tag then
  grbStaticOptions.Width := grbStaticOptions.Tag;
If grbStaticOptions.Height < TempInt then
  grbStaticOptions.Height := TempInt;
// add (dynamic) options
TempInt := 2 * LABELS_SPACE;
grbOptions.Tag := grbOptions.Width;
For i := Low(OPTIONS_TAGS) to High(OPTIONS_TAGS) do
  begin
    // tag
    TempLabel := AddLabel(grbOptions,LABELS_SPACE,TempInt,[fsBold],OPTIONS_TAGS[i]);
    If (TempLabel.BoundsRect.Right + LABELS_SPACE) > grbOptions.Tag then
      grbOptions.Tag := TempLabel.BoundsRect.Right + LABELS_SPACE;
    // description
    TempLabel := AddLabel(grbOptions,LABELS_SPACE,TempInt + LABELS_HEIGHT,[],OPTIONS_DESCR[i]);
    If (TempLabel.BoundsRect.Right + LABELS_SPACE) > grbOptions.Tag then
      grbOptions.Tag := TempLabel.BoundsRect.Right + LABELS_SPACE;
    Inc(TempInt,(2 * LABELS_HEIGHT) + LABELS_SPACE);
  end;
// adjust box size
If grbOptions.Width < grbOptions.Tag then
  grbOptions.Width := grbOptions.Tag;
If grbOptions.Height < TempInt then
  grbOptions.Height := TempInt;
// arrange group boxes
grbOptions.Top := grbStaticOptions.BoundsRect.Bottom + LABELS_SPACE;
// adjust boxes width
If grbOptions.Width < grbStaticOptions.Width then
  grbOptions.Width := grbStaticOptions.Width
else If grbStaticOptions.Width < grbOptions.Width then
  grbStaticOptions.Width := grbOptions.Width;
// adjust window size
If ClientWidth < (grbOptions.BoundsRect.Right + LABELS_SPACE) then
  ClientWidth := grbOptions.BoundsRect.Right + LABELS_SPACE;
ClientHeight := grbOptions.BoundsRect.Bottom + LABELS_SPACE;
end;

//==============================================================================

procedure TfOptionsLegendForm.Initialize(ILManager: TILManager);
begin
fILManager := ILManager;
end;

//------------------------------------------------------------------------------

procedure TfOptionsLegendForm.ShowLegend;
begin
ShowModal;
end;

//==============================================================================

procedure TfOptionsLegendForm.FormCreate(Sender: TObject);
begin
BuildForm;
end;

end.
