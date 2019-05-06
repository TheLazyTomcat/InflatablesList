unit ExtractionFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, ExtCtrls,
  InflatablesList, InflatablesList_Types;

type
  TfrmExtractionFrame = class(TFrame)
    pnlMain: TPanel;
    lblExtractFrom: TLabel;
    cmbExtractFrom: TComboBox;
    lblExtractMethod: TLabel;    
    cmbExtractMethod: TComboBox;
    leExtractionData: TLabeledEdit;
    leNegativeTag: TLabeledEdit;
    bvlExtrSeparator: TBevel;
  private
    fILManager:   TILManager;
    fExtractSett: PILItemShopParsingExtrSett;
  protected
    procedure ClearFrame;
    procedure SaveFrame;
    procedure LoadFrame;
  public
    procedure SaveItem;
    procedure LoadItem;
    procedure Initialize(ILManager: TILManager);
    procedure SetExtractSett(ExtractSett: PILItemShopParsingExtrSett; ProcessChange: Boolean);
  end;

implementation

{$R *.dfm}

procedure TfrmExtractionFrame.ClearFrame;
begin
If cmbExtractFrom.Items.Count > 0 then
  cmbExtractFrom.ItemIndex := 0;
If cmbExtractMethod.Items.Count > 0 then
  cmbExtractMethod.ItemIndex := 0;
leExtractionData.Text := '';
leNegativeTag.Text := '';
end;

//------------------------------------------------------------------------------

procedure TfrmExtractionFrame.SaveFrame;
begin
If Assigned(fExtractSett) then
  begin
    fExtractSett^.ExtractFrom := TILItemShopParsingExtrFrom(cmbExtractFrom.ItemIndex);
    fExtractSett^.ExtractionMethod := TILItemShopParsingExtrMethod(cmbExtractMethod.ItemIndex);
    fExtractSett^.ExtractionData := leExtractionData.Text;
    fExtractSett^.NegativeTag := leNegativeTag.Text;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmExtractionFrame.LoadFrame;
begin
If Assigned(fExtractSett) then
  begin
    cmbExtractFrom.ItemIndex := Ord(fExtractSett^.ExtractFrom);
    cmbExtractMethod.ItemIndex := Ord(fExtractSett^.ExtractionMethod);
    leExtractionData.Text := fExtractSett^.ExtractionData;
    leNegativeTag.Text := fExtractSett^.NegativeTag;
  end;
end;

//==============================================================================

procedure TfrmExtractionFrame.SaveItem;
begin
SaveFrame;
end;

//------------------------------------------------------------------------------

procedure TfrmExtractionFrame.LoadItem;
begin
LoadFrame;
end;

//------------------------------------------------------------------------------

procedure TfrmExtractionFrame.Initialize(ILManager: TILManager);
var
  i:  Integer;
begin
fILManager := ILManager;
// fill drop lists...
// extract from
cmbExtractFrom.Items.BeginUpdate;
try
  cmbExtractFrom.Items.Clear;
  For i := Ord(Low(TILItemShopParsingExtrFrom)) to Ord(High(TILItemShopParsingExtrFrom)) do
    cmbExtractFrom.Items.Add(fILManager.DataProvider.
      GetShopParsingExtractFromString(TILItemShopParsingExtrFrom(i)));
finally
  cmbExtractFrom.Items.EndUpdate;
end;
If cmbExtractFrom.Items.Count > 0 then
  cmbExtractFrom.ItemIndex := 0;
// extraction method
cmbExtractMethod.Items.BeginUpdate;
try
  cmbExtractMethod.Items.Clear;
  For i := Ord(Low(TILItemShopParsingExtrMethod)) to Ord(High(TILItemShopParsingExtrMethod)) do
    cmbExtractMethod.Items.Add(fILManager.DataProvider.
      GetShopParsingExtractMethodString(TILItemShopParsingExtrMethod(i)));
finally
  cmbExtractMethod.Items.EndUpdate;
end;
If cmbExtractMethod.Items.Count > 0 then
  cmbExtractMethod.ItemIndex := 0;
end;

//------------------------------------------------------------------------------

procedure TfrmExtractionFrame.SetExtractSett(ExtractSett: PILItemShopParsingExtrSett; ProcessChange: Boolean);
begin
If ProcessChange then
  begin
    If Assigned(fExtractSett) then
      SaveFrame;
    If Assigned(ExtractSett) then
      begin
        fExtractSett := ExtractSett;
        LoadFrame;
      end
    else
      begin
        fExtractSett := nil;
        ClearFrame;
      end;
    Visible := Assigned(fExtractSett);
    Enabled := Assigned(fExtractSett);
  end
else fExtractSett := ExtractSett;
end;

end.
