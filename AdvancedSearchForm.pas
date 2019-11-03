unit AdvancedSearchForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  InflatablesList_Types,
  InflatablesList_Manager;

type
  TfAdvancedSearchForm = class(TForm)
    leTextToFind: TLabeledEdit;
    btnSearch: TButton;
    grbSearchSettings: TGroupBox;
    cbPartialMatch: TCheckBox;
    cbCaseSensitive: TCheckBox;
    cbTextsOnly: TCheckBox;
    cbEditablesOnly: TCheckBox;
    cbSearchCalculated: TCheckBox;
    cbIncludeUnits: TCheckBox;
    cbSearchShops: TCheckBox;
    cbDeepScan: TCheckBox;
    bvlHorSplit: TBevel;
    lblSearchResults: TLabel;
    meSearchResults: TMemo;
    btnSaveReport: TButton;
    diaReportSave: TSaveDialog;
    procedure FormShow(Sender: TObject);    
    procedure leTextToFindKeyPress(Sender: TObject; var Key: Char);
    procedure btnSearchClick(Sender: TObject);
    procedure cbSearchShopsClick(Sender: TObject);
    procedure meSearchResultsKeyPress(Sender: TObject; var Key: Char);
    procedure btnSaveReportClick(Sender: TObject);
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
  i,j:  Integer;
  ISR:  TILAdvItemSearchResult;
  SSR:  TILAdvShopSearchResult;
  Temp: String;
begin
Screen.Cursor := crHourGlass;
try
  meSearchResults.Lines.BeginUpdate;
  try
    meSearchResults.Lines.Add(IL_Format('Search report %s',[IL_FormatDateTime('yyyy-mm-dd hh:nn:ss',Now)]));
    meSearchResults.Lines.Add('');
    meSearchResults.Lines.Add(IL_Format('  Searched string: "%s"',[leTextToFind.Text]));
    meSearchResults.Lines.Add('');
    meSearchResults.Lines.Add('  Search settings:');
    meSearchResults.Lines.Add('');
    meSearchResults.Lines.Add(IL_Format('    %s Allow partial match',[IL_BoolToStr(cbPartialMatch.Checked,'-','+')]));
    meSearchResults.Lines.Add(IL_Format('    %s Case sensitive comparisons',[IL_BoolToStr(cbCaseSensitive.Checked,'-','+')]));
    meSearchResults.Lines.Add(IL_Format('    %s Search only textual values',[IL_BoolToStr(cbTextsOnly.Checked,'-','+')]));
    meSearchResults.Lines.Add(IL_Format('    %s Search only editable values',[IL_BoolToStr(cbEditablesOnly.Checked,'-','+')]));
    meSearchResults.Lines.Add(IL_Format('    %s Search calculated values',[IL_BoolToStr(cbSearchCalculated.Checked,'-','+')]));
    meSearchResults.Lines.Add(IL_Format('    %s Include unit symbols',[IL_BoolToStr(cbIncludeUnits.Checked,'-','+')]));
    meSearchResults.Lines.Add(IL_Format('    %s Search item shops',[IL_BoolToStr(cbSearchShops.Checked,'-','+')]));
    meSearchResults.Lines.Add(IL_Format('    %s Deep scan',[IL_BoolToStr(cbDeepScan.Checked,'-','+')]));
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
        meSearchResults.Lines.Add('');  
        meSearchResults.Lines.Add(IL_Format('[%d] Item #%d - %s',
         [i,SearchResults[i].ItemIndex + 1,fILManager[SearchResults[i].ItemIndex].TitleStr]));
        // item values
        If SearchResults[i].ItemValue <> [] then
          begin
            meSearchResults.Lines.Add('');
            Temp := '';
            For ISR := Low(TILAdvItemSearchResult) to High(TILAdvItemSearchResult) do
              If ISR in SearchResults[i].ItemValue then
                begin
                  If Length(Temp) > 0 then
                    Temp := IL_Format('%s, %s',[Temp,fILManager.DataProvider.GetAdvancedItemSearchResultString(ISR)])
                  else
                    Temp := fILManager.DataProvider.GetAdvancedItemSearchResultString(ISR);
                end;
            meSearchResults.Lines.Add('  ' + Temp);    
          end;
        // item shop values
        If Length(SearchResults[i].Shops) > 0 then
          begin
            meSearchResults.Lines.Add('');
            meSearchResults.Lines.Add(IL_Format('Found in shops(%d):',[Length(SearchResults[i].Shops)]));
            meSearchResults.Lines.Add('');
            For j := Low(SearchResults[i].Shops) to High(SearchResults[i].Shops) do
              begin
                If j > 0 then
                  meSearchResults.Lines.Add('');
                meSearchResults.Lines.Add(IL_Format('  [%d] Shop #%d - %s',[j,SearchResults[i].Shops[j].ShopIndex,
                  fILManager[SearchResults[i].ItemIndex][SearchResults[i].Shops[j].ShopIndex].Name]));
                If SearchResults[i].Shops[j].ShopValue <> [] then
                  begin
                    meSearchResults.Lines.Add('');
                    Temp := '';
                    // values
                    For SSR := Low(TILAdvShopSearchResult) to High(TILAdvShopSearchResult) do
                      If SSR in SearchResults[i].Shops[j].ShopValue then
                        begin
                          If Length(Temp) > 0 then
                            Temp := IL_Format('%s, %s',[Temp,fILManager.DataProvider.GetAdvancedShopSearchResultString(SSR)])
                          else
                            Temp := fILManager.DataProvider.GetAdvancedShopSearchResultString(SSR);
                        end;
                    meSearchResults.Lines.Add('    ' + Temp);
                  end;
              end;
          end;
      end;
  finally
    meSearchResults.Lines.EndUpdate;
  end;
finally
  Screen.Cursor := crDefault;
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

//------------------------------------------------------------------------------

procedure TfAdvancedSearchForm.cbSearchShopsClick(Sender: TObject);
begin
cbDeepScan.Enabled := cbSearchShops.Checked;
end;

//------------------------------------------------------------------------------

procedure TfAdvancedSearchForm.meSearchResultsKeyPress(Sender: TObject;
  var Key: Char);
begin
If Key = ^A then
  begin
    meSearchResults.SelectAll;
    Key := #0;
  end;
end;

//------------------------------------------------------------------------------

procedure TfAdvancedSearchForm.btnSaveReportClick(Sender: TObject);
begin
If diaReportSave.Execute then
  meSearchResults.Lines.SaveToFile(diaReportSave.FileName);
end;

end.

