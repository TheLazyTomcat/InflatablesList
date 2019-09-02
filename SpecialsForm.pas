unit SpecialsForm;
{$message 'll_rework'}

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
    procedure btnClearTextTagsClick(Sender: TObject);
    procedure btnClearParsingClick(Sender: TObject);
    procedure btnSetAltDownMethodClick(Sender: TObject);
    procedure btnUpdateAllAPFClick(Sender: TObject);
    procedure btnSetMaterialToPVCClick(Sender: TObject);
    procedure btnClearACPCFlagsClick(Sender: TObject);
    procedure btnReplaceInPicPathsClick(Sender: TObject);
    procedure btnReplaceTextTagClick(Sender: TObject);
    procedure btnRemoveShopsClick(Sender: TObject);
  private
    fILManager: TILManager;
  public
    procedure Initialize(ILManager: TILManager);
    procedure Finalize;
  end;

var
  fSpecialsForm: TfSpecialsForm;

implementation

{$R *.dfm}

uses
  StrUtils,
  InflatablesList_Types;

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
  fILManager[i].TextTag := '';
end;

//------------------------------------------------------------------------------

procedure TfSpecialsForm.btnClearParsingClick(Sender: TObject);
var
  i,j:  Integer;
begin
For i := fILManager.ItemLowIndex to fILManager.ItemHighIndex do
  For j := fILManager[i].ShopLowIndex to fILManager[i].ShopHighIndex do
    begin
      fILManager[i][j].ParsingSettings.AvailExtractionSettingsClear;
      fILManager[i][j].ParsingSettings.AvailFinder.StageClear;
      fILManager[i][j].ParsingSettings.PriceExtractionSettingsClear;
      fILManager[i][j].ParsingSettings.PriceFinder.StageClear;
    end;
end;

//------------------------------------------------------------------------------

procedure TfSpecialsForm.btnSetAltDownMethodClick(Sender: TObject);
var
  i,j:  Integer;
begin
For i := fILManager.ItemLowIndex to fILManager.ItemHighIndex do
  For j := fILManager[i].ShopLowIndex to fILManager[i].ShopHighIndex do
    If AnsiSameText(fILManager[i][j].Name,leParam_1.Text) then
      fILManager[i][j].AltDownMethod := True;
end;

//------------------------------------------------------------------------------

procedure TfSpecialsForm.btnUpdateAllAPFClick(Sender: TObject);
var
  i:  Integer;
begin
For i := fILManager.ItemLowIndex to fILManager.ItemHighIndex do
  fILManager[i].GetAndFlagPriceAndAvail(
    fILManager[i].UnitPriceSelected,fILManager[i].AvailableSelected);
end;

//------------------------------------------------------------------------------

procedure TfSpecialsForm.btnSetMaterialToPVCClick(Sender: TObject);
var
  i:  Integer;
begin
For i := fILManager.ItemLowIndex to fILManager.ItemHighIndex do
  fILManager[i].Material := ilimtPolyvinylchloride;
end;

//------------------------------------------------------------------------------

procedure TfSpecialsForm.btnClearACPCFlagsClick(Sender: TObject);
var
  i:  Integer;
begin
For i := fILManager.ItemLowIndex to fILManager.ItemHighIndex do
  begin
    fILManager[i].SetFlagValue(ilifPriceChange,False);
    fILManager[i].SetFlagValue(ilifAvailChange,False)
  end;
end;

//------------------------------------------------------------------------------

procedure TfSpecialsForm.btnReplaceInPicPathsClick(Sender: TObject);
var
  i:  Integer;
begin
For i := fILManager.ItemLowIndex to fILManager.ItemHighIndex do
  begin
    fILManager[i].ItemPictureFile := AnsiReplaceText(fILManager[i].ItemPictureFile,leParam_1.Text,leParam_2.Text);
    fILManager[i].PackagePictureFile := AnsiReplaceText(fILManager[i].PackagePictureFile,leParam_1.Text,leParam_2.Text);
  end;
end;

//------------------------------------------------------------------------------

procedure TfSpecialsForm.btnReplaceTextTagClick(Sender: TObject);
var
  i:  Integer;
begin
For i := fILManager.ItemLowIndex to fILManager.ItemHighIndex do
  If AnsiSameText(fILManager[i].TextTag,leParam_1.Text) then
    fILManager[i].TextTag := leParam_2.Text;
end;

//------------------------------------------------------------------------------

procedure TfSpecialsForm.btnRemoveShopsClick(Sender: TObject);
var
  i,j:  Integer;
begin
For i := fILManager.ItemLowIndex to fILManager.ItemHighIndex do
  For j := fILManager[i].ShopHighIndex downto fILManager[i].ShopLowIndex do
    If not fILManager[i][j].Selected then
      begin
        fILManager[i].ShopDelete(j);
        fILManager[i].GetAndFlagPriceAndAvail(
          fILManager[i].UnitPriceSelected,fILManager[i].AvailableSelected);
      end;
end;

end.
