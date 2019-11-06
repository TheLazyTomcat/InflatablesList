unit SpecialsForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls,
  InflatablesList_Manager;

type
  TfSpecialsForm = class(TForm)
    pnlWarning: TPanel;
    leParam_1: TLabeledEdit;
    btnClearTextTags: TButton;
    btnClearParsing: TButton;
    btnSetAltDownMethod: TButton;
    btnUpdateAllAPF: TButton;
    leParam_2: TLabeledEdit;
    btnSetMaterialToPVC: TButton;
    btnClearACPCFlags: TButton;
    btnReplaceInPicPaths: TButton;
    btnReplaceTextTag: TButton;
    btnRemoveShops: TButton;
    cbCloseWhenDone: TCheckBox;
    btnRemShopsFromOwned: TButton;
    btnRemoveWLFromOwned: TButton;
    procedure btnClearTextTagsClick(Sender: TObject);
    procedure btnClearParsingClick(Sender: TObject);
    procedure btnSetAltDownMethodClick(Sender: TObject);
    procedure btnUpdateAllAPFClick(Sender: TObject);
    procedure btnSetMaterialToPVCClick(Sender: TObject);
    procedure btnClearACPCFlagsClick(Sender: TObject);
    procedure btnReplaceInPicPathsClick(Sender: TObject);
    procedure btnReplaceTextTagClick(Sender: TObject);
    procedure btnRemoveShopsClick(Sender: TObject);
    procedure btnRemShopsFromOwnedClick(Sender: TObject);
    procedure btnRemoveWLFromOwnedClick(Sender: TObject);
  private
    fILManager: TILManager;
  protected
    procedure ProcessingDone;
  public
    procedure Initialize(ILManager: TILManager);
    procedure Finalize;
  end;

var
  fSpecialsForm: TfSpecialsForm;

implementation

{$R *.dfm}

uses
  InflatablesList_Types,
  InflatablesList_Utils;

procedure TfSpecialsForm.ProcessingDone;
begin
If cbCloseWhenDone.Checked then
  Close;
end;

//==============================================================================

procedure TfSpecialsForm.Initialize(ILManager: TILManager);
begin
fILManager := ILManager;
end;

//------------------------------------------------------------------------------

procedure TfSpecialsForm.Finalize;
begin
// nothing to do here
end;

//==============================================================================

procedure TfSpecialsForm.btnClearTextTagsClick(Sender: TObject);
var
  i:  Integer;
begin
For i := fILManager.ItemLowIndex to fILManager.ItemHighIndex do
  If fILManager[i].DataAccessible then
    fILManager[i].TextTag := '';
ProcessingDone;
end;

//------------------------------------------------------------------------------

procedure TfSpecialsForm.btnClearParsingClick(Sender: TObject);
var
  i,j:  Integer;
begin
For i := fILManager.ItemLowIndex to fILManager.ItemHighIndex do
  If fILManager[i].DataAccessible then
    For j := fILManager[i].ShopLowIndex to fILManager[i].ShopHighIndex do
      begin
        fILManager[i][j].ParsingSettings.AvailExtractionSettingsClear;
        fILManager[i][j].ParsingSettings.AvailFinder.StageClear;
        fILManager[i][j].ParsingSettings.PriceExtractionSettingsClear;
        fILManager[i][j].ParsingSettings.PriceFinder.StageClear;
      end;
ProcessingDone;
end;

//------------------------------------------------------------------------------

procedure TfSpecialsForm.btnSetAltDownMethodClick(Sender: TObject);
var
  i,j:  Integer;
begin
For i := fILManager.ItemLowIndex to fILManager.ItemHighIndex do
  If fILManager[i].DataAccessible then
    For j := fILManager[i].ShopLowIndex to fILManager[i].ShopHighIndex do
      If IL_SameText(fILManager[i][j].Name,leParam_1.Text) then
        fILManager[i][j].AltDownMethod := True;
ProcessingDone;
end;

//------------------------------------------------------------------------------

procedure TfSpecialsForm.btnUpdateAllAPFClick(Sender: TObject);
var
  i:  Integer;
begin
For i := fILManager.ItemLowIndex to fILManager.ItemHighIndex do
  If fILManager[i].DataAccessible then
    fILManager[i].GetAndFlagPriceAndAvail(
      fILManager[i].UnitPriceSelected,fILManager[i].AvailableSelected);
ProcessingDone;
end;

//------------------------------------------------------------------------------

procedure TfSpecialsForm.btnSetMaterialToPVCClick(Sender: TObject);
var
  i:  Integer;
begin
For i := fILManager.ItemLowIndex to fILManager.ItemHighIndex do
  If fILManager[i].DataAccessible then
    fILManager[i].Material := ilimtPolyvinylchloride;   
ProcessingDone;
end;

//------------------------------------------------------------------------------

procedure TfSpecialsForm.btnClearACPCFlagsClick(Sender: TObject);
var
  i:  Integer;
begin
For i := fILManager.ItemLowIndex to fILManager.ItemHighIndex do
  If fILManager[i].DataAccessible then
    begin
      fILManager[i].SetFlagValue(ilifPriceChange,False);
      fILManager[i].SetFlagValue(ilifAvailChange,False)
    end;    
ProcessingDone;
end;

//------------------------------------------------------------------------------

procedure TfSpecialsForm.btnReplaceInPicPathsClick(Sender: TObject);
var
  i:  Integer;
begin
For i := fILManager.ItemLowIndex to fILManager.ItemHighIndex do
  If fILManager[i].DataAccessible then
    begin
      fILManager[i].ItemPictureFile := IL_ReplaceText(fILManager[i].ItemPictureFile,leParam_1.Text,leParam_2.Text);
      fILManager[i].PackagePictureFile := IL_ReplaceText(fILManager[i].PackagePictureFile,leParam_1.Text,leParam_2.Text);
    end;   
ProcessingDone;
end;

//------------------------------------------------------------------------------

procedure TfSpecialsForm.btnReplaceTextTagClick(Sender: TObject);
var
  i:  Integer;
begin
For i := fILManager.ItemLowIndex to fILManager.ItemHighIndex do
  If fILManager[i].DataAccessible then
    If IL_SameText(fILManager[i].TextTag,leParam_1.Text) then
      fILManager[i].TextTag := leParam_2.Text; 
ProcessingDone;
end;

//------------------------------------------------------------------------------

procedure TfSpecialsForm.btnRemoveShopsClick(Sender: TObject);
var
  i,j:  Integer;
begin
For i := fILManager.ItemLowIndex to fILManager.ItemHighIndex do
  If fILManager[i].DataAccessible then
    For j := fILManager[i].ShopHighIndex downto fILManager[i].ShopLowIndex do
      If not fILManager[i][j].Selected then
        fILManager[i].ShopDelete(j);
ProcessingDone;
end;

//------------------------------------------------------------------------------

procedure TfSpecialsForm.btnRemShopsFromOwnedClick(Sender: TObject);
var
  i:  Integer;
begin
For i := fILManager.ItemLowIndex to fILManager.ItemHighIndex do
  If fILManager[i].DataAccessible and (ilifOwned in fILManager[i].Flags) then
      fILManager[i].ShopClear;
ProcessingDone;
end;

//------------------------------------------------------------------------------

procedure TfSpecialsForm.btnRemoveWLFromOwnedClick(Sender: TObject);
var
  i:  Integer;
begin
For i := fILManager.ItemLowIndex to fILManager.ItemHighIndex do
  If ilifOwned in fILManager[i].Flags then
    fILManager[i].WantedLevel := 0;
ProcessingDone;
end;

end.
