program InflatablesListApp;
{$message 'll_rework'}

uses
  FastMM4,
  Forms,
  ItemFrame in 'ItemFrame.pas' {frmItemFrame: TFrame},
  ShopFrame in 'ShopFrame.pas' {frmShopFrame: TFrame},
  ComparatorFrame in 'ComparatorFrame.pas' {frmComparatorFrame: TFrame},
  ExtractionFrame in 'ExtractionFrame.pas' {frmExtractionFrame: TFrame},
  MainForm in 'MainForm.pas' {fMainForm},
  TextEditForm in 'TextEditForm.pas' {fTextEditForm},
  ShopsForm in 'ShopsForm.pas' {fShopsForm},
  ParsingForm in 'ParsingForm.pas' {fParsingForm},
  TemplatesForm in 'TemplatesForm.pas' {fTemplatesForm},
  SortForm in 'SortForm.pas' {fSortForm},
  SumsForm in 'SumsForm.pas' {fSumsForm},
  SpecialsForm in 'SpecialsForm.pas' {fSpecialsForm},
  OverviewForm in 'OverviewForm.pas' {fOverviewForm},
  SelectionForm in 'SelectionForm.pas' {fSelectionForm},
  UpdateForm in 'UpdateForm.pas' {fUpdateForm},
  ItemSelectForm in 'ItemSelectForm.pas' {fItemSelectForm},
  UpdResLegendForm in 'UpdResLegendForm.pas' {fUpdResLegendForm},
  OptionsLegendForm in 'OptionsLegendForm.pas' {fOptionsLegendForm},
  AboutForm in 'AboutForm.pas' {fAboutForm},
  PromptForm in 'PromptForm.pas' {fPromptForm};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Inflatables List';
  Application.CreateForm(TfMainForm, fMainForm);
  Application.CreateForm(TfTextEditForm, fTextEditForm);
  Application.CreateForm(TfShopsForm, fShopsForm);
  Application.CreateForm(TfParsingForm, fParsingForm);
  Application.CreateForm(TfTemplatesForm, fTemplatesForm);
  Application.CreateForm(TfSortForm, fSortForm);
  Application.CreateForm(TfSumsForm, fSumsForm);
  Application.CreateForm(TfSpecialsForm, fSpecialsForm);
  Application.CreateForm(TfOverviewForm, fOverviewForm);
  Application.CreateForm(TfSelectionForm, fSelectionForm);
  Application.CreateForm(TfUpdateForm, fUpdateForm);
  Application.CreateForm(TfItemSelectForm, fItemSelectForm);
  Application.CreateForm(TfUpdResLegendForm, fUpdResLegendForm);
  Application.CreateForm(TfOptionsLegendForm, fOptionsLegendForm);
  Application.CreateForm(TfAboutForm, fAboutForm);
  // do not automatically create prompt form
  fMainForm.InitializeOtherForms; // must be run after create but before show
  Application.Run;
end.
