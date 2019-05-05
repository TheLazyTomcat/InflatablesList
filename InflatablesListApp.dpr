program InflatablesListApp;

uses
  FastMM4,
  Forms,
  MainForm in 'MainForm.pas' {fMainForm},
  SortForm in 'SortForm.pas' {fSortForm},
  SumsForm in 'SumsForm.pas' {fSumsForm},
  ShopsForm in 'ShopsForm.pas' {fShopsForm},
  TemplatesForm in 'TemplatesForm.pas' {fTemplatesForm},
  TextEditForm in 'TextEditForm.pas' {fTextEditForm},
  UpdateForm in 'UpdateForm.pas' {fUpdateForm},
  ItemFrame in 'ItemFrame.pas' {frmItemFrame: TFrame},
  ShopFrame in 'ShopFrame.pas' {frmShopFrame: TFrame},
  InflatablesList_Types in 'source\InflatablesList_Types.pas',
  InflatablesList_Utils in 'source\InflatablesList_Utils.pas',
  InflatablesList_Data in 'source\InflatablesList_Data.pas',
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
  InflatablesList_ShopUpdate in 'source\InflatablesList_ShopUpdate.pas',
  InflatablesList_Manager_Base in 'source\InflatablesList_Manager_Base.pas',
  InflatablesList_Manager_VER00000000 in 'source\InflatablesList_Manager_VER00000000.pas',
  InflatablesList_Manager_VER00000001 in 'source\InflatablesList_Manager_VER00000001.pas',
  InflatablesList in 'source\InflatablesList.pas',
  InflatablesList_Backup in 'source\InflatablesList_Backup.pas',
  InflatablesList_Manager_VER00000002 in 'source\InflatablesList_Manager_VER00000002.pas',
  ParsingForm in 'ParsingForm.pas' {fParsingForm},
  ComparatorFrame in 'ComparatorFrame.pas' {frmComparatorFrame: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Inflatables List';
  Application.CreateForm(TfMainForm, fMainForm);
  Application.CreateForm(TfSortForm, fSortForm);
  Application.CreateForm(TfSumsForm, fSumsForm);
  Application.CreateForm(TfShopsForm, fShopsForm);
  Application.CreateForm(TfTemplatesForm, fTemplatesForm);
  Application.CreateForm(TfTextEditForm, fTextEditForm);
  Application.CreateForm(TfUpdateForm, fUpdateForm);
  Application.CreateForm(TfParsingForm, fParsingForm);
  fMainForm.DoOtherFormsInit;
  Application.Run;
end.
