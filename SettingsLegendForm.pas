unit SettingsLegendForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,
  InflatablesList_Types,
  InflatablesList_Manager;

type
  TfSettingsLegendForm = class(TForm)
    grbStaticSettings: TGroupBox;
    grbDynamicSettings: TGroupBox;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    fILManager:   TILManager;
    fStatLabels:  array[0..Pred(Length(IL_STATIC_SETTINGS_TAGS))] of TLabel;
    fDynLabels:   array[0..Pred(Length(IL_DYNAMIC_SETTINGS_TAGS))] of TLabel;
  protected
    procedure BuildForm;
    procedure IndicateState;
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
  MainForm;

{$R *.dfm}

procedure TfSettingsLegendForm.BuildForm;
const
  STAT_SETT_CMDS: array[0..Pred(Length(IL_STATIC_SETTINGS_TAGS))] of String = (
    'no_pics','test_code','save_pages','load_pages','no_save','no_backup',
    'no_updlog','list_override <filename>','no_parse');
  STAT_SETT_DESCRS: array[0..Pred(Length(IL_STATIC_SETTINGS_TAGS))] of String = (
    'Pictures are not shown in the list and in the item header (internally they are still maintained).',
    'Test code will be executed where available.',
    'Pages downloaded during updates are saved to the disk.',
    'Pages required during updates are not downloaded from the internet, they are instead loaded from the disk.',
    'Saving of the list, both implicit and explicit, is disabled.',
    'Automatic backup during saving of the list is not performed (has no meaning when saving is disabled).',
    'Update log is not automatically saved.',
    'Overrides default file name of loaded and saved list file.',
    'When updating, no parsing is performed. It means the pages are only downloaded, and, when save_pages is active, saved.');
  DYN_SETTINGS_NAMES: array[0..Pred(Length(IL_DYNAMIC_SETTINGS_TAGS))] of String = (
    'list.compression',
    'list.encryption',
    'list.save_on_close',
    'sort.reversal',
    'sort.case_sensitive');
  DYN_SETTINGS_DESCRS: array[0..Pred(Length(IL_DYNAMIC_SETTINGS_TAGS))] of String = (
    'List will be saved compressed (reduced size). Can significantly slow down saving and loading. Applied before encryption.',
    'List will be ecnrypted using provided list password. Can slow down saving and loading of the list.',
    'List will be automatically saved when you close the program. Has no effect when you close the program using command "Close without saving" or when you start it with command-line parameter no_save.',
    'List will be sorted in reversed order (Z..A, 9..0). Does not affect ordering by values, only final global order.',
    'When comparing two strings (textual values) for ordering, the comparison is done with case sensitivity.');
  LABELS_SPACE = 8;
  LABELS_HEIGHT = 16;
  ENTRY_SPACE = 10;
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
    Result.Constraints.MaxWidth := 640;
    Result.WordWrap := True;
  end;

begin
// add static settings
TempInt := 2 * LABELS_SPACE;
grbStaticSettings.Tag := grbStaticSettings.Width;
For i := Low(IL_STATIC_SETTINGS_TAGS) to High(IL_STATIC_SETTINGS_TAGS) do
  begin
    // tag
    TempLabel := AddLabel(grbStaticSettings,LABELS_SPACE,TempInt,[fsBold],IL_STATIC_SETTINGS_TAGS[i]);
    fStatLabels[i] := TempLabel;
    // command
    TempLabel := AddLabel(grbStaticSettings,TempLabel.BoundsRect.Right + LABELS_SPACE,TempInt,[],STAT_SETT_CMDS[i]);
    If (TempLabel.BoundsRect.Right + LABELS_SPACE) > grbStaticSettings.Tag then
      grbStaticSettings.Tag := TempLabel.BoundsRect.Right + LABELS_SPACE;
    // description
    TempLabel := AddLabel(grbStaticSettings,LABELS_SPACE,TempInt + LABELS_HEIGHT,[],STAT_SETT_DESCRS[i]);
    If (TempLabel.BoundsRect.Right + LABELS_SPACE) > grbStaticSettings.Tag then
      grbStaticSettings.Tag := TempLabel.BoundsRect.Right + LABELS_SPACE;
    TempInt := TempLabel.BoundsRect.Bottom + ENTRY_SPACE;
  end;
// adjust box size
If grbStaticSettings.Width < grbStaticSettings.Tag then
  grbStaticSettings.Width := grbStaticSettings.Tag;
If grbStaticSettings.Height < TempInt then
  grbStaticSettings.Height := TempInt;
// add dynamic settings
TempInt := 2 * LABELS_SPACE;
grbDynamicSettings.Tag := grbDynamicSettings.Width;
For i := Low(IL_DYNAMIC_SETTINGS_TAGS) to High(IL_DYNAMIC_SETTINGS_TAGS) do
  begin
    // tag
    TempLabel := AddLabel(grbDynamicSettings,LABELS_SPACE,TempInt,[fsBold],IL_DYNAMIC_SETTINGS_TAGS[i]);
    fDynLabels[i] := TempLabel;
    If (TempLabel.BoundsRect.Right + LABELS_SPACE) > grbDynamicSettings.Tag then
      grbDynamicSettings.Tag := TempLabel.BoundsRect.Right + LABELS_SPACE;
    // name
    TempLabel := AddLabel(grbDynamicSettings,TempLabel.BoundsRect.Right + LABELS_SPACE,TempInt,[],DYN_SETTINGS_NAMES[i]);
    If (TempLabel.BoundsRect.Right + LABELS_SPACE) > grbDynamicSettings.Tag then
      grbDynamicSettings.Tag := TempLabel.BoundsRect.Right + LABELS_SPACE;
    // description
    TempLabel := AddLabel(grbDynamicSettings,LABELS_SPACE,TempInt + LABELS_HEIGHT,[],DYN_SETTINGS_DESCRS[i]);
    If (TempLabel.BoundsRect.Right + LABELS_SPACE) > grbDynamicSettings.Tag then
      grbDynamicSettings.Tag := TempLabel.BoundsRect.Right + LABELS_SPACE;
    TempInt := TempLabel.BoundsRect.Bottom + ENTRY_SPACE;
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

//------------------------------------------------------------------------------

procedure TfSettingsLegendForm.IndicateState;

  procedure InidicateOnLabel(aLabel: TLabel; State: Boolean);
  begin
    If State then
      aLabel.Font.Color := clWindowText
    else
      aLabel.Font.Color := clGrayText;
  end;

begin
// static settings
InidicateOnLabel(fStatLabels[0],fILManager.StaticSettings.NoPictures);
InidicateOnLabel(fStatLabels[1],fILManager.StaticSettings.TestCode);
InidicateOnLabel(fStatLabels[2],fILManager.StaticSettings.SavePages);
InidicateOnLabel(fStatLabels[3],fILManager.StaticSettings.LoadPages);
InidicateOnLabel(fStatLabels[4],fILManager.StaticSettings.NoSave);
InidicateOnLabel(fStatLabels[5],fILManager.StaticSettings.NoBackup);
InidicateOnLabel(fStatLabels[6],fILManager.StaticSettings.NoUpdateAutoLog);
InidicateOnLabel(fStatLabels[7],fILManager.StaticSettings.ListOverride);
InidicateOnLabel(fStatLabels[8],fILManager.StaticSettings.NoParse);
// dynamic settings
InidicateOnLabel(fDynLabels[0],fILManager.Compressed);
InidicateOnLabel(fDynLabels[1],fILManager.Encrypted);
InidicateOnLabel(fDynLabels[2],fMainForm.mniMMF_SaveOnClose.Checked);
InidicateOnLabel(fDynLabels[3],fILManager.ReversedSort);
InidicateOnLabel(fDynLabels[4],fILManager.CaseSensitiveSort);
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
IndicateState;
ShowModal;
end;

//==============================================================================

procedure TfSettingsLegendForm.FormCreate(Sender: TObject);
begin
BuildForm;
end;

end.
