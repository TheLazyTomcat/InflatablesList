unit SettingsLegendForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,
  InflatablesList_Manager;

type
  TfSettingsLegendForm = class(TForm)
    grbStaticSettings: TGroupBox;
    grbDynamicSettings: TGroupBox;
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
  fSettingsLegendForm: TfSettingsLegendForm;

implementation

uses
  InflatablesList_Types;

{$R *.dfm}

procedure TfSettingsLegendForm.BuildForm;
const
  STAT_SETT_CMDS: array[0..Pred(Length(IL_STATIC_SETTINGS_TAGS))] of String = (
    'no_pics','test_code','save_pages','load_pages','no_save','no_backup',
    'no_updlog','list_override <filename>');
  STAT_SETT_DESCR: array[0..Pred(Length(IL_STATIC_SETTINGS_TAGS))] of String = (
    'Pictures are not shown in the list and in the item header (internally they are still maintained).',
    'Test code will be executed where available.',
    'Pages downloaded during updates are saved to the disk.',
    'Pages required during updates are not downloaded from the internet, they are instead loaded from the disk.',
    'Saving of the list, both implicit and explicit, is disabled.',
    'Automatic backup during saving of the list is not performed (has no meaning when saving is disabled).',
    'Update log is not automatically saved.',
    'Overrides file name of loaded and saved list file, also disables automatic backups (equivalent to no_backup).');
  SETTINGS_TAGS: array[0..0] of String = (
    's.rev');
  SETTINGS_DESCR: array[0..Pred(Length(SETTINGS_TAGS))] of String = (
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
// add static settings
TempInt := 2 * LABELS_SPACE;
grbStaticSettings.Tag := grbStaticSettings.Width;
For i := Low(IL_STATIC_SETTINGS_TAGS) to High(IL_STATIC_SETTINGS_TAGS) do
  begin
    // tag
    TempLabel := AddLabel(grbStaticSettings,LABELS_SPACE,TempInt,[fsBold],IL_STATIC_SETTINGS_TAGS[i]);
    // command
    TempLabel := AddLabel(grbStaticSettings,TempLabel.BoundsRect.Right + LABELS_SPACE,TempInt,[],STAT_SETT_CMDS[i]);
    If (TempLabel.BoundsRect.Right + LABELS_SPACE) > grbStaticSettings.Tag then
      grbStaticSettings.Tag := TempLabel.BoundsRect.Right + LABELS_SPACE;
    // description
    TempLabel := AddLabel(grbStaticSettings,LABELS_SPACE,TempInt + LABELS_HEIGHT,[],STAT_SETT_DESCR[i]);
    If (TempLabel.BoundsRect.Right + LABELS_SPACE) > grbStaticSettings.Tag then
      grbStaticSettings.Tag := TempLabel.BoundsRect.Right + LABELS_SPACE;
    Inc(TempInt,(2 * LABELS_HEIGHT) + LABELS_SPACE);
  end;
// adjust box size
If grbStaticSettings.Width < grbStaticSettings.Tag then
  grbStaticSettings.Width := grbStaticSettings.Tag;
If grbStaticSettings.Height < TempInt then
  grbStaticSettings.Height := TempInt;
// add dynamic settings
TempInt := 2 * LABELS_SPACE;
grbDynamicSettings.Tag := grbDynamicSettings.Width;
For i := Low(SETTINGS_TAGS) to High(SETTINGS_TAGS) do
  begin
    // tag
    TempLabel := AddLabel(grbDynamicSettings,LABELS_SPACE,TempInt,[fsBold],SETTINGS_TAGS[i]);
    If (TempLabel.BoundsRect.Right + LABELS_SPACE) > grbDynamicSettings.Tag then
      grbDynamicSettings.Tag := TempLabel.BoundsRect.Right + LABELS_SPACE;
    // description
    TempLabel := AddLabel(grbDynamicSettings,LABELS_SPACE,TempInt + LABELS_HEIGHT,[],SETTINGS_DESCR[i]);
    If (TempLabel.BoundsRect.Right + LABELS_SPACE) > grbDynamicSettings.Tag then
      grbDynamicSettings.Tag := TempLabel.BoundsRect.Right + LABELS_SPACE;
    Inc(TempInt,(2 * LABELS_HEIGHT) + LABELS_SPACE);
  end;
// adjust box size
If grbDynamicSettings.Width < grbDynamicSettings.Tag then
  grbDynamicSettings.Width := grbDynamicSettings.Tag;
If grbDynamicSettings.Height < TempInt then
  grbDynamicSettings.Height := TempInt;
// arrange group boxes
grbDynamicSettings.Top := grbStaticSettings.BoundsRect.Bottom + LABELS_SPACE;
// adjust boxes width
If grbDynamicSettings.Width < grbStaticSettings.Width then
  grbDynamicSettings.Width := grbStaticSettings.Width
else If grbStaticSettings.Width < grbDynamicSettings.Width then
  grbStaticSettings.Width := grbDynamicSettings.Width;
// adjust window size
If ClientWidth < (grbDynamicSettings.BoundsRect.Right + LABELS_SPACE) then
  ClientWidth := grbDynamicSettings.BoundsRect.Right + LABELS_SPACE;
ClientHeight := grbDynamicSettings.BoundsRect.Bottom + LABELS_SPACE;
end;

//==============================================================================

procedure TfSettingsLegendForm.Initialize(ILManager: TILManager);
begin
fILManager := ILManager;
end;

//------------------------------------------------------------------------------

procedure TfSettingsLegendForm.Finalize;
begin
// nothing to do here
end;

//------------------------------------------------------------------------------

procedure TfSettingsLegendForm.ShowLegend;
begin
ShowModal;
end;

//==============================================================================

procedure TfSettingsLegendForm.FormCreate(Sender: TObject);
begin
BuildForm;
end;

end.
