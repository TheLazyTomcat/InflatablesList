unit SpecialsForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls,
  InflatablesList, StdCtrls;

type
  TfSpecialsForm = class(TForm)
    pnlWarning: TPanel;
    leParam: TLabeledEdit;
    btnClearTextTags: TButton;
    btnClearParsing: TButton;
    btnSetAltDownMethod: TButton;
    btnUpdateAllAPF: TButton;
    procedure btnClearTextTagsClick(Sender: TObject);
    procedure btnClearParsingClick(Sender: TObject);
    procedure btnSetAltDownMethodClick(Sender: TObject);
    procedure btnUpdateAllAPFClick(Sender: TObject);
  private
    fILManager: TILManager;
  public
    procedure Initialize(ILManager: TILManager);
  end;

var
  fSpecialsForm: TfSpecialsForm;

implementation

{$R *.dfm}

uses
  AuxTypes,
  InflatablesList_HTML_ElementFinder;

procedure TfSpecialsForm.Initialize(ILManager: TILManager);
begin
fILManager := ILManager;
end;

//==============================================================================

procedure TfSpecialsForm.btnClearTextTagsClick(Sender: TObject);
var
  i:  Integer;
begin
For i := 0 to Pred(fILManager.ItemCount) do
  fILManager.ItemPtrs[i].TextTag := '';
Close;
end;

//------------------------------------------------------------------------------

procedure TfSpecialsForm.btnClearParsingClick(Sender: TObject);
var
  i,j:  Integer;
begin
For i := 0 to Pred(fILManager.ItemCount) do
  For j := Low(fILManager.ItemPtrs[i]^.Shops) to High(fILManager.ItemPtrs[i]^.Shops) do
    begin
      SetLength(fILManager.ItemPtrs[i]^.Shops[j].ParsingSettings.Available.Extraction,0);
      TILElementFinder(fILManager.ItemPtrs[i]^.Shops[j].ParsingSettings.Available.Finder).StageClear;
      SetLength(fILManager.ItemPtrs[i]^.Shops[j].ParsingSettings.Price.Extraction,0);
      TILElementFinder(fILManager.ItemPtrs[i]^.Shops[j].ParsingSettings.Price.Finder).StageClear;
    end;
Close;
end;

//------------------------------------------------------------------------------

procedure TfSpecialsForm.btnSetAltDownMethodClick(Sender: TObject);
var
  i,j:  Integer;
begin
For i := 0 to Pred(fILManager.ItemCount) do
  For j := Low(fILManager.ItemPtrs[i]^.Shops) to High(fILManager.ItemPtrs[i]^.Shops) do
    If AnsiSameText(fILManager.ItemPtrs[i]^.Shops[j].Name,leParam.Text) then
      fILManager.ItemPtrs[i]^.Shops[j].AltDownMethod := True;
end;

//------------------------------------------------------------------------------

procedure TfSpecialsForm.btnUpdateAllAPFClick(Sender: TObject);
var
  i:        Integer;
  OldPrice: UInt32;
  OldAvail: Int32;
begin
For i := 0 to Pred(fILManager.ItemCount) do
  begin
    OldPrice := fILManager.ItemPtrs[i]^.UnitPriceSelected;
    OldAvail := fILManager.ItemPtrs[i]^.AvailableSelected;
    fILManager.ItemUpdatePriceAndAvail(fILManager.ItemPtrs[i]^);
    fILManager.ItemFlagPriceAndAvail(fILManager.ItemPtrs[i]^,OldPrice,OldAvail);
  end;
end;

end.
