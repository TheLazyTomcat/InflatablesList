program InflatablesListApp;

uses
  Forms,
  MainForm in 'MainForm.pas' {fMainForm},
  ItemFrame in 'ItemFrame.pas' {frmItemFrame: TFrame},
  IL_Types in 'source\IL_Types.pas',
  IL_Item in 'source\IL_Item.pas',
  IL_Data in 'source\IL_Data.pas',
  IL_Utils in 'source\IL_Utils.pas',
  IL_ItemShop in 'source\IL_ItemShop.pas',
  IL_Item_Base in 'source\IL_Item_Base.pas',
  IL_Manager_Base in 'source\IL_Manager_Base.pas',
  IL_Manager in 'source\IL_Manager.pas',
  InflatablesList_Backup in 'source\InflatablesList_Backup.pas',
  IL_Item_Draw in 'source\IL_Item_Draw.pas',
  IL_Item_Utils in 'source\IL_Item_Utils.pas',
  IL_Item_Comp in 'source\IL_Item_Comp.pas',
  TextEditForm in 'TextEditForm.pas' {fTextEditForm},
  IL_Manager_Sort in 'source\IL_Manager_Sort.pas',
  SortForm in 'SortForm.pas' {fSortForm},
  IL_Manager_Filter in 'source\IL_Manager_Filter.pas',
  SumsForm in 'SumsForm.pas' {fSumsForm},
  IL_Manager_Templates in 'source\IL_Manager_Templates.pas',
  IL_ItemShop_Base in 'source\IL_ItemShop_Base.pas',
  IL_ItemShopTemplate_Base in 'source\IL_ItemShopTemplate_Base.pas',
  IL_ItemShopTemplate in 'source\IL_ItemShopTemplate.pas',
  InflatablesList_HTML_UnicodeTagAttributeArray in 'source\InflatablesList_HTML_UnicodeTagAttributeArray.pas',
  InflatablesList_HTML_Common in 'source\InflatablesList_HTML_Common.pas',
  InflatablesList_HTML_Document in 'source\InflatablesList_HTML_Document.pas',
  InflatablesList_HTML_Download in 'source\InflatablesList_HTML_Download.pas',
  InflatablesList_HTML_ElementFinder in 'source\InflatablesList_HTML_ElementFinder.pas',
  InflatablesList_HTML_NamedCharRefs in 'source\InflatablesList_HTML_NamedCharRefs.pas',
  InflatablesList_HTML_Parser in 'source\InflatablesList_HTML_Parser.pas',
  InflatablesList_HTML_Preprocessor in 'source\InflatablesList_HTML_Preprocessor.pas',
  InflatablesList_HTML_TagAttributeArray in 'source\InflatablesList_HTML_TagAttributeArray.pas',
  InflatablesList_HTML_Tokenizer in 'source\InflatablesList_HTML_Tokenizer.pas',
  InflatablesList_HTML_UnicodeCharArray in 'source\InflatablesList_HTML_UnicodeCharArray.pas',
  InflatablesList_HTML_UnicodeStringArray in 'source\InflatablesList_HTML_UnicodeStringArray.pas',
  InflatablesList_HTML_Utils in 'source\InflatablesList_HTML_Utils.pas',
  IL_ItemShopParsingSettings_Base in 'source\IL_ItemShopParsingSettings_Base.pas',
  IL_ItemShopParsingSettings in 'source\IL_ItemShopParsingSettings.pas',
  IL_ItemShopTemplate_IO in 'source\IL_ItemShopTemplate_IO.pas',
  IL_ItemShopTemplate_IO_00000000 in 'source\IL_ItemShopTemplate_IO_00000000.pas',
  IL_ItemShopParsingSettings_IO in 'source\IL_ItemShopParsingSettings_IO.pas',
  IL_ItemShopParsingSettings_IO_00000000 in 'source\IL_ItemShopParsingSettings_IO_00000000.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Inflatables List';
  Application.CreateForm(TfMainForm, fMainForm);
  Application.CreateForm(TfTextEditForm, fTextEditForm);
  Application.CreateForm(TfSortForm, fSortForm);
  Application.CreateForm(TfSumsForm, fSumsForm);
  //Application.CreateForm(TfSortForm, fSortForm);
  //Application.CreateForm(TfSumsForm, fSumsForm);
  //Application.CreateForm(TfSpecialsForm, fSpecialsForm);
  //Application.CreateForm(TfShopsForm, fShopsForm);
  //Application.CreateForm(TfParsingForm, fParsingForm);
  //Application.CreateForm(TfTemplatesForm, fTemplatesForm);
  //Application.CreateForm(TfUpdateForm, fUpdateForm);
  //Application.CreateForm(TfTextEditForm, fTextEditForm);
  //Application.CreateForm(TfOverviewForm, fOverviewForm);
  //Application.CreateForm(TfSelectionForm, fSelectionForm);
  fMainForm.InitOtherForms;
  Application.Run;
end.
