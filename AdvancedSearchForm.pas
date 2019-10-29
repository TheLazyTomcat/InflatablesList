unit AdvancedSearchForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  InflatablesList_Manager;

type
  TfAdvancedSearchForm = class(TForm)
    grbSearchSettings: TGroupBox;
    leTextToFind: TLabeledEdit;
    btnSearch: TButton;
    meSearchResults: TMemo;
    bvlHorSplit: TBevel;
    lblSearchResults: TLabel;
    cbPartialMatch: TCheckBox;
    cbSearchComposites: TCheckBox;
    cbCaseSensitive: TCheckBox;
    cbSearchShops: TCheckBox;
    cbTextsOnly: TCheckBox;
    cbIncludeUnits: TCheckBox;
    cbDeepScan: TCheckBox;
  private
    { Private declarations }
    fILManager: TILManager;    
  public
    { Public declarations }
    procedure Initialize(ILManager: TILManager);
    procedure Finalize;
    procedure ShowAdvancedSearch;
  end;

var
  fAdvancedSearchForm: TfAdvancedSearchForm;

implementation

{$R *.dfm}

procedure TfAdvancedSearchForm.Initialize(ILManager: TILManager);
begin
fILManager := ILManager;
end;

//------------------------------------------------------------------------------

procedure TfAdvancedSearchForm.Finalize;
begin
// nothing to do atm.
end;

//------------------------------------------------------------------------------

procedure TfAdvancedSearchForm.ShowAdvancedSearch;
begin
ShowModal;
end;

end.

