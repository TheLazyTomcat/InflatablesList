unit SpecialsForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls,
  InflatablesList, StdCtrls;

type
  TfSpecialsForm = class(TForm)
    pnlWarning: TPanel;
    btnClearTextTags: TButton;
    btnClearParsing: TButton;
    procedure btnClearTextTagsClick(Sender: TObject);
    procedure btnClearParsingClick(Sender: TObject);
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
  For j := Low(fILManager.ItemPtrs[i].Shops) to High(fILManager.ItemPtrs[i].Shops) do
    begin
      SetLength(fILManager.ItemPtrs[i].Shops[j].ParsingSettings.Available.Extraction,0);
      TILElementFinder(fILManager.ItemPtrs[i].Shops[j].ParsingSettings.Available.Finder).StageClear;
      SetLength(fILManager.ItemPtrs[i].Shops[j].ParsingSettings.Price.Extraction,0);
      TILElementFinder(fILManager.ItemPtrs[i].Shops[j].ParsingSettings.Price.Finder).StageClear;
    end;
Close;
end;

end.
