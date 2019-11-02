unit AdvancedSearchForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  InflatablesList_Types,
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
    cbSearchCalculated: TCheckBox;
    cbCaseSensitive: TCheckBox;
    cbSearchShops: TCheckBox;
    cbTextsOnly: TCheckBox;
    cbIncludeUnits: TCheckBox;
    cbDeepScan: TCheckBox;
    cbEditablesOnly: TCheckBox;
    procedure FormShow(Sender: TObject);    
    procedure leTextToFindKeyPress(Sender: TObject; var Key: Char);
    procedure btnSearchClick(Sender: TObject);
  private
    { Private declarations }
    fILManager: TILManager;
    procedure CreateReport(SearchResults: TILAdvSearchResults);
  public
    { Public declarations }
    procedure Initialize(ILManager: TILManager);
    procedure Finalize;
    procedure ShowAdvancedSearch;
  end;

var
  fAdvancedSearchForm: TfAdvancedSearchForm;

implementation

uses
  InflatablesList_Utils;

{$R *.dfm}

procedure TfAdvancedSearchForm.CreateReport(SearchResults: TILAdvSearchResults);
var
  i:  Integer;
  j:  TILAdvItemSearchResult;
begin
meSearchResults.Lines.BeginUpdate;
try
  meSearchResults.Lines.Add(IL_Format('Search report %s',[IL_FormatDateTime('yyyy-mm-dd hh:nn:ss',Now)]));
  meSearchResults.Lines.Add('');
  meSearchResults.Lines.Add(IL_Format('  Searched string: "%s"',[leTextToFind.Text]));
  meSearchResults.Lines.Add(IL_Format('  Search settings: %s',['<<<todo>>>']));
  meSearchResults.Lines.Add('');
  meSearchResults.Lines.Add(IL_Format('Found in %d item(s)...',[Length(SearchResults)]));
  meSearchResults.Lines.Add('');
  If Length(SearchResults) > 0 then
    meSearchResults.Lines.Add(IL_StringOfChar('-',60));
  For i := Low(SearchResults) to High(SearchResults) do
    begin
      If i > 0 then
        begin
          meSearchResults.Lines.Add('');
          meSearchResults.Lines.Add(IL_StringOfChar('-',60));
        end;
      meSearchResults.Lines.Add(IL_Format('[%d] Item #%d - %s',
        [i,SearchResults[i].ItemIndex + 1,fILManager[SearchResults[i].ItemIndex].TitleStr]));
      // item values
      If SearchResults[i].ItemValue <> [] then
        begin
          meSearchResults.Lines.Add('');        
          meSearchResults.Lines.Add('Found in values:');
          meSearchResults.Lines.Add('');
          For j := Low(TILAdvItemSearchResult) to High(TILAdvItemSearchResult) do
            If j in SearchResults[i].ItemValue then
              meSearchResults.Lines.Add('  ' + fILManager.DataProvider.GetAdvancedItemSearchResultString(j));
        end;
      // item shop values
      If Length(SearchResults[i].Shops) > 0 then
        begin
          meSearchResults.Lines.Add('');
          meSearchResults.Lines.Add(IL_Format('Found in shops(%d):',[Length(SearchResults[i].Shops)]));
          meSearchResults.Lines.Add('');
          {$message 'implement'}
        end;
    end;
finally
  meSearchResults.Lines.EndUpdate;
end;
end;

//==============================================================================

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

//==============================================================================

procedure TfAdvancedSearchForm.FormShow(Sender: TObject);
begin
leTextToFind.SetFocus;
end;

//------------------------------------------------------------------------------

procedure TfAdvancedSearchForm.leTextToFindKeyPress(Sender: TObject; var Key: Char);
begin
If Key = #13{return} then
  begin
    Key := #0;
    btnSearch.OnClick(nil);
  end;
end;

//------------------------------------------------------------------------------

procedure TfAdvancedSearchForm.btnSearchClick(Sender: TObject);
var
  SearchSettings: TILAdvSearchSettings;
  SearchResults:  TILAdvSearchResults;
begin
If Length(leTextToFind.Text) > 0 then
  begin
    // create in-place search settings
    SearchSettings.Text := leTextToFind.Text;
    SearchSettings.PartialMatch := cbPartialMatch.Checked;
    SearchSettings.CaseSensitive := cbCaseSensitive.Checked;
    SearchSettings.TextsOnly := cbTextsOnly.Checked;
    SearchSettings.EditablesOnly := cbEditablesOnly.Checked;
    SearchSettings.SearchCalculated := cbSearchCalculated.Checked;
    SearchSettings.IncludeUnits := cbIncludeUnits.Checked;
    SearchSettings.SearchShops := cbSearchShops.Checked;
    SearchSettings.DeepScan := cbDeepScan.Checked;
    // init result array
    SetLength(SearchResults,0);
    // do the search
    Screen.Cursor := crHourGlass;
    try
      fILManager.FindAll(SearchSettings,SearchResults);
    finally
      Screen.Cursor := crDefault;
    end;
    // show the results
    meSearchResults.Lines.Clear;
    If Length(SearchResults) > 0 then
      CreateReport(SearchResults)
    else
      MessageDlg('No match was found.',mtInformation,[mbOk],0);
  end
else MessageDlg('Cannot search for an empty string.',mtInformation,[mbOk],0);
end;

end.

