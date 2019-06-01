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
  SortForm in 'SortForm.pas' {fSortForm};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Inflatables List';
  Application.CreateForm(TfMainForm, fMainForm);
  Application.CreateForm(TfTextEditForm, fTextEditForm);
  Application.CreateForm(TfSortForm, fSortForm);
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
