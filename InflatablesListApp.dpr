program InflatablesListApp;

uses
  FastMM4,
  InflatablesList_Types in 'source\InflatablesList_Types.pas',
  InflatablesList_Utils in 'source\InflatablesList_Utils.pas',
  InflatablesList_Encryption in 'source\InflatablesList_Encryption.pas',
  InflatablesList_Data in 'source\InflatablesList_Data.pas',
  InflatablesList_Backup in 'source\InflatablesList_Backup.pas',
  InflatablesList_HTML_Utils in 'source\InflatablesList_HTML_Utils.pas',
  InflatablesList_HTML_NamedCharRefs in 'source\InflatablesList_HTML_NamedCharRefs.pas',
  InflatablesList_HTML_Download in 'source\InflatablesList_HTML_Download.pas',
  InflatablesList_HTML_TagAttributeArray in 'source\InflatablesList_HTML_TagAttributeArray.pas',
  InflatablesList_HTML_UnicodeTagAttributeArray in 'source\InflatablesList_HTML_UnicodeTagAttributeArray.pas',
  InflatablesList_HTML_Document in 'source\InflatablesList_HTML_Document.pas',
  InflatablesList_HTML_ElementFinder in 'source\InflatablesList_HTML_ElementFinder.pas',
  InflatablesList_HTML_Preprocessor in 'source\InflatablesList_HTML_Preprocessor.pas',
  InflatablesList_HTML_Tokenizer in 'source\InflatablesList_HTML_Tokenizer.pas',
  InflatablesList_HTML_Parser in 'source\InflatablesList_HTML_Parser.pas',
  InflatablesList_ItemShopParsingSettings_Base in 'source\InflatablesList_ItemShopParsingSettings_Base.pas',
  InflatablesList_ItemShopParsingSettings_IO in 'source\InflatablesList_ItemShopParsingSettings_IO.pas',
  InflatablesList_ItemShopParsingSettings_IO_00000000 in 'source\InflatablesList_ItemShopParsingSettings_IO_00000000.pas',
  InflatablesList_ItemShopParsingSettings_IO_00000001 in 'source\InflatablesList_ItemShopParsingSettings_IO_00000001.pas',
  InflatablesList_ItemShopParsingSettings in 'source\InflatablesList_ItemShopParsingSettings.pas',
  InflatablesList_ItemShopTemplate_Base in 'source\InflatablesList_ItemShopTemplate_Base.pas',
  InflatablesList_ItemShopTemplate_IO in 'source\InflatablesList_ItemShopTemplate_IO.pas',
  InflatablesList_ItemShopTemplate_IO_00000000 in 'source\InflatablesList_ItemShopTemplate_IO_00000000.pas',
  InflatablesList_ItemShopTemplate_IO_00000001 in 'source\InflatablesList_ItemShopTemplate_IO_00000001.pas',
  InflatablesList_ItemShopTemplate in 'source\InflatablesList_ItemShopTemplate.pas',
  InflatablesList_ItemShop_Base in 'source\InflatablesList_ItemShop_Base.pas',
  InflatablesList_ItemShop_IO in 'source\InflatablesList_ItemShop_IO.pas',
  InflatablesList_ItemShop_IO_00000000 in 'source\InflatablesList_ItemShop_IO_00000000.pas',
  InflatablesList_ItemShop_IO_00000001 in 'source\InflatablesList_ItemShop_IO_00000001.pas',
  InflatablesList_ItemShop_Update in 'source\InflatablesList_ItemShop_Update.pas',
  InflatablesList_ItemShop in 'source\InflatablesList_ItemShop.pas',
  InflatablesList_ShopUpdater in 'source\InflatablesList_ShopUpdater.pas',
  InflatablesList_Item_Base in 'source\InflatablesList_Item_Base.pas',
  InflatablesList_Item_Utils in 'source\InflatablesList_Item_Utils.pas',
  InflatablesList_Item_Draw in 'source\InflatablesList_Item_Draw.pas',
  InflatablesList_Item_Comp in 'source\InflatablesList_Item_Comp.pas',
  InflatablesList_Item_IO in 'source\InflatablesList_Item_IO.pas',
  InflatablesList_Item_IO_00000000 in 'source\InflatablesList_Item_IO_00000000.pas',
  InflatablesList_Item_IO_00000001 in 'source\InflatablesList_Item_IO_00000001.pas',
  InflatablesList_Item_IO_00000002 in 'source\InflatablesList_Item_IO_00000002.pas',
  InflatablesList_Item_IO_00000003 in 'source\InflatablesList_Item_IO_00000003.pas',
  InflatablesList_Item_IO_00000004 in 'source\InflatablesList_Item_IO_00000004.pas',
  InflatablesList_Item_IO_00000005 in 'source\InflatablesList_Item_IO_00000005.pas',
  InflatablesList_Item_IO_00000006 in 'source\InflatablesList_Item_IO_00000006.pas',
  InflatablesList_Item in 'source\InflatablesList_Item.pas',
  InflatablesList_ShopSelectItemsArray in 'source\InflatablesList_ShopSelectItemsArray.pas',
  InflatablesList_Manager_Base in 'source\InflatablesList_Manager_Base.pas',
  InflatablesList_Manager_Sort in 'source\InflatablesList_Manager_Sort.pas',
  InflatablesList_Manager_Filter in 'source\InflatablesList_Manager_Filter.pas',
  InflatablesList_Manager_Templates in 'source\InflatablesList_Manager_Templates.pas',
  InflatablesList_Manager_IO in 'source\InflatablesList_Manager_IO.pas',
  InflatablesList_Manager_IO_Threaded in 'source\InflatablesList_Manager_IO_Threaded.pas',
  InflatablesList_Manager_IO_00000008 in 'source\InflatablesList_Manager_IO_00000008.pas',
  InflatablesList_Manager_IO_00000009 in 'source\InflatablesList_Manager_IO_00000009.pas',
  InflatablesList_Manager_IO_0000000A in 'source\InflatablesList_Manager_IO_0000000A.pas',
  InflatablesList_Manager in 'source\InflatablesList_Manager.pas',
  InflatablesList_Master in 'source\InflatablesList_Master.pas',
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
  BackupsForm in 'BackupsForm.pas' {fBackupsForm},
  UpdResLegendForm in 'UpdResLegendForm.pas' {fUpdResLegendForm},
  SettingsLegendForm in 'SettingsLegendForm.pas' {fSettingsLegendForm},
  AboutForm in 'AboutForm.pas' {fAboutForm},
  PromptForm in 'PromptForm.pas' {fPromptForm},
  SplashForm in 'SplashForm.pas' {fSplashForm},
  SaveForm in 'SaveForm.pas' {fSaveForm},
  InflatablesList_Manager_IO_0000000B in 'source\InflatablesList_Manager_IO_0000000B.pas';

{$R *.res}

begin
with TILMaster.Create do
try
  Run;
finally
  Free;
end;
end.
