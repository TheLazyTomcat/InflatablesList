program InflatablesListApp;

uses
  FastMM4,
  Forms,
  MainForm in 'MainForm.pas' {fMainForm},
  SortForm in 'SortForm.pas' {fSortForm},
  SumsForm in 'SumsForm.pas' {fSumsForm},
  SpecialsForm in 'SpecialsForm.pas' {fSpecialsForm},
  ShopsForm in 'ShopsForm.pas' {fShopsForm},
  ParsingForm in 'ParsingForm.pas' {fParsingForm},
  TemplatesForm in 'TemplatesForm.pas' {fTemplatesForm},
  UpdateForm in 'UpdateForm.pas' {fUpdateForm},
  TextEditForm in 'TextEditForm.pas' {fTextEditForm},
  ItemFrame in 'ItemFrame.pas' {frmItemFrame: TFrame},
  ShopFrame in 'ShopFrame.pas' {frmShopFrame: TFrame},
  ComparatorFrame in 'ComparatorFrame.pas' {frmComparatorFrame: TFrame},
  ExtractionFrame in 'ExtractionFrame.pas' {frmExtractionFrame: TFrame},
  InflatablesList_Types in 'source\InflatablesList_Types.pas',
  InflatablesList_Utils in 'source\InflatablesList_Utils.pas',
  InflatablesList_Data in 'source\InflatablesList_Data.pas',
  InflatablesList_Backup in 'source\InflatablesList_Backup.pas',
  InflatablesList_ShopUpdate in 'source\InflatablesList_ShopUpdate.pas',
  InflatablesList_Manager_Base in 'source\InflatablesList_Manager_Base.pas',
  InflatablesList_Manager_Utils in 'source\InflatablesList_Manager_Utils.pas',
  InflatablesList_Manager_Shops in 'source\InflatablesList_Manager_Shops.pas',
  InflatablesList_Manager_IO in 'source\InflatablesList_Manager_IO.pas',
  InflatablesList_Manager_Sort in 'source\InflatablesList_Manager_Sort.pas',
  InflatablesList_Manager_Filter in 'source\InflatablesList_Manager_Filter.pas',
  InflatablesList_Manager_Templates in 'source\InflatablesList_Manager_Templates.pas',
  InflatablesList_Manager_Draw in 'source\InflatablesList_Manager_Draw.pas',
  InflatablesList_Manager_00000000 in 'source\InflatablesList_Manager_00000000.pas',
  InflatablesList_Manager_00000001 in 'source\InflatablesList_Manager_00000001.pas',
  InflatablesList_Manager_00000002 in 'source\InflatablesList_Manager_00000002.pas',
  InflatablesList_Manager_00000003 in 'source\InflatablesList_Manager_00000003.pas',
  InflatablesList_Manager_00000004 in 'source\InflatablesList_Manager_00000004.pas',
  InflatablesList_Manager_00000005 in 'source\InflatablesList_Manager_00000005.pas',
  InflatablesList_HTML_Common in 'source\InflatablesList_HTML_Common.pas',
  InflatablesList_HTML_NamedCharRefs in 'source\InflatablesList_HTML_NamedCharRefs.pas',
  InflatablesList_HTML_Download in 'source\InflatablesList_HTML_Download.pas',
  InflatablesList_HTML_UnicodeCharArray in 'source\InflatablesList_HTML_UnicodeCharArray.pas',
  InflatablesList_HTML_UnicodeStringArray in 'source\InflatablesList_HTML_UnicodeStringArray.pas',
  InflatablesList_HTML_UnicodeTagAttributeArray in 'source\InflatablesList_HTML_UnicodeTagAttributeArray.pas',
  InflatablesList_HTML_TagAttributeArray in 'source\InflatablesList_HTML_TagAttributeArray.pas',
  InflatablesList_HTML_Document in 'source\InflatablesList_HTML_Document.pas',
  InflatablesList_HTML_ElementFinder in 'source\InflatablesList_HTML_ElementFinder.pas',
  InflatablesList_HTML_Preprocessor in 'source\InflatablesList_HTML_Preprocessor.pas',
  InflatablesList_HTML_Tokenizer in 'source\InflatablesList_HTML_Tokenizer.pas',
  InflatablesList_HTML_Parser in 'source\InflatablesList_HTML_Parser.pas',
  InflatablesList in 'source\InflatablesList.pas',
  InflatablesList_Manager_00000006 in 'source\InflatablesList_Manager_00000006.pas',
  OverviewForm in 'OverviewForm.pas' {fOverviewForm},
  SelectionForm in 'SelectionForm.pas' {fSelectionForm},
  InflatablesList_Manager_00000007 in 'source\InflatablesList_Manager_00000007.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Inflatables List';
  Application.CreateForm(TfMainForm, fMainForm);
  Application.CreateForm(TfSortForm, fSortForm);
  Application.CreateForm(TfSumsForm, fSumsForm);
  Application.CreateForm(TfSpecialsForm, fSpecialsForm);
  Application.CreateForm(TfShopsForm, fShopsForm);
  Application.CreateForm(TfParsingForm, fParsingForm);
  Application.CreateForm(TfTemplatesForm, fTemplatesForm);
  Application.CreateForm(TfUpdateForm, fUpdateForm);
  Application.CreateForm(TfTextEditForm, fTextEditForm);
  Application.CreateForm(TfOverviewForm, fOverviewForm);
  Application.CreateForm(TfSelectionForm, fSelectionForm);
  fMainForm.DoOtherFormsInit;
  Application.Run;
end.
