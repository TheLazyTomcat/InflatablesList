unit ComparatorFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, ExtCtrls, Spin,
  InflatablesList, InflatablesList_HTML_ElementFinder;

type
  TfrmComparatorFrame = class(TFrame)
    pnlMain: TPanel;
    leString: TLabeledEdit;
    lblVarIndex: TLabel;
    seVarIndex: TSpinEdit;
    cbCaseSensitive: TCheckBox;
    cbAllowPartial: TCheckBox;
    bvlStrSeparator: TBevel;
    lblOperator: TLabel;
    cmbOperator: TComboBox;
    cbNegate: TCheckBox;
    procedure leStringChange(Sender: TObject);
    procedure seVarIndexChange(Sender: TObject);
    procedure cbCaseSensitiveClick(Sender: TObject);
    procedure cbAllowPartialClick(Sender: TObject);
    procedure cmbOperatorChange(Sender: TObject);
    procedure cbNegateClick(Sender: TObject);
  private
    fInitializing:  Boolean;  
    fILManager:     TILManager;
    fComparator:    TILComparatorBase;
  protected
    procedure PropagateChange;
    procedure FrameClear;
    procedure FramePrepare;
    procedure SaveSettings;
    procedure LoadSettings;
  public
    OnChange: TNotifyEvent;
    procedure Initialize(ILManager: TILManager);
    procedure SetComparator(Comparator: TILComparatorBase; ProcessChange: Boolean);
  end;

implementation

{$R *.dfm}

procedure TfrmComparatorFrame.PropagateChange;
begin
If Assigned(OnChange) then
  OnChange(Self);
end;

//------------------------------------------------------------------------------

procedure TfrmComparatorFrame.FrameClear;
begin
leString.Text := '';
seVarIndex.Value := 0;
cbCaseSensitive.Checked := False;
cbAllowPartial.Checked := False;
cmbOperator.ItemIndex := 0;
cbNegate.Checked := False;
end;

//------------------------------------------------------------------------------

procedure TfrmComparatorFrame.FramePrepare;
var
  Temp: Boolean;
begin
Temp := fComparator is TILTextComparator;
leString.Visible := Temp;
lblVarIndex.Visible := Temp;
seVarIndex.Visible := Temp;
cbCaseSensitive.Visible := Temp;
cbAllowPartial.Visible := Temp;
bvlStrSeparator.Visible := Temp;
end;

//------------------------------------------------------------------------------

procedure TfrmComparatorFrame.SaveSettings;
begin
If Assigned(fComparator) then
  begin
    If fComparator is TILTextComparator then
      begin
        TILTextComparator(fComparator).Str := leString.Text;
        TILTextComparator(fComparator).VariableIndex := seVarIndex.Value - 1;
        TILTextComparator(fComparator).CaseSensitive := cbCaseSensitive.Checked;
        TILTextComparator(fComparator).AllowPartial := cbAllowPartial.Checked;
      end;
    fComparator.Operator := TILSearchOperator(cmbOperator.ItemIndex);
    fComparator.Negate := cbNegate.Checked;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmComparatorFrame.LoadSettings;
begin
If Assigned(fComparator) then
  begin
    FramePrepare;
    fInitializing := True;
    try
      If fComparator is TILTextComparator then
        begin
          leString.Text := TILTextComparator(fComparator).Str;
          seVarIndex.Value := TILTextComparator(fComparator).VariableIndex + 1;
          cbCaseSensitive.Checked := TILTextComparator(fComparator).CaseSensitive;
          cbAllowPartial.Checked := TILTextComparator(fComparator).AllowPartial;
        end;
      cmbOperator.ItemIndex := Ord(fComparator.Operator);
      cbNegate.Checked := fComparator.Negate;
    finally
      fInitializing := False;
    end;
  end;
end;

//==============================================================================

procedure TfrmComparatorFrame.Initialize(ILManager: TILManager);
var
  i:  TILSearchOperator;
begin
fILManager := ILManager;
// fill combobox
cmbOperator.Clear;
For i := Low(TILSearchOperator) to High(TILSearchOperator) do
  cmbOperator.Items.Add(IL_SearchOperatorAsStr(i));
If cmbOperator.Items.Count > 0 then
  cmbOperator.ItemIndex := 0;
end;

//------------------------------------------------------------------------------

procedure TfrmComparatorFrame.SetComparator(Comparator: TILComparatorBase; ProcessChange: Boolean);
begin
If ProcessChange then
  begin
    If Assigned(fComparator) then
      SaveSettings;
    If Assigned(Comparator) then
      begin
        fComparator := Comparator;
        LoadSettings;
      end
    else
      begin
        fComparator := nil;
        FrameClear;
      end;
    Visible := Assigned(fComparator);
    Enabled := Assigned(fComparator);
  end
else fComparator := Comparator;
end;

//==============================================================================

procedure TfrmComparatorFrame.leStringChange(Sender: TObject);
begin
If (fComparator is TILTextComparator) and not fInitializing then
  begin
    TILTextComparator(fComparator).Str := leString.Text;
    PropagateChange;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmComparatorFrame.seVarIndexChange(Sender: TObject);
begin
If (fComparator is TILTextComparator) and not fInitializing then
  begin
    TILTextComparator(fComparator).VariableIndex := seVarIndex.Value  - 1;
    PropagateChange;
  end;
end;
 
//------------------------------------------------------------------------------

procedure TfrmComparatorFrame.cbCaseSensitiveClick(Sender: TObject);
begin
If (fComparator is TILTextComparator) and not fInitializing then
  begin
    TILTextComparator(fComparator).CaseSensitive := cbCaseSensitive.Checked;
    PropagateChange;
  end;
end;
 
//------------------------------------------------------------------------------

procedure TfrmComparatorFrame.cbAllowPartialClick(Sender: TObject);
begin
If (fComparator is TILTextComparator) and not fInitializing then
  begin
    TILTextComparator(fComparator).AllowPartial := cbAllowPartial.Checked;
    PropagateChange;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmComparatorFrame.cmbOperatorChange(Sender: TObject);
begin
If Assigned(fComparator) and not fInitializing then
  begin
    TILTextComparator(fComparator).Operator := TILSearchOperator(cmbOperator.ItemIndex);
    PropagateChange;
  end;
end;
 
//------------------------------------------------------------------------------

procedure TfrmComparatorFrame.cbNegateClick(Sender: TObject);
begin
If Assigned(fComparator) and not fInitializing then
  begin
    TILTextComparator(fComparator).Negate := cbNegate.Checked;
    PropagateChange;
  end;
end;

end.
