unit ComparatorFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, ExtCtrls, Spin,
  InflatablesList_HTML_ElementFinder,
  InflatablesList_Manager;

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
    cbNestedText: TCheckBox;
    procedure leStringChange(Sender: TObject);
    procedure seVarIndexChange(Sender: TObject);
    procedure cbCaseSensitiveClick(Sender: TObject);
    procedure cbAllowPartialClick(Sender: TObject);
    procedure cmbOperatorChange(Sender: TObject);
    procedure cbNegateClick(Sender: TObject);
    procedure cbNestedTextClick(Sender: TObject);
  private
    fInitializing:  Boolean;  
    fILManager:     TILManager;
    fComparator:    TILFinderBaseClass;
  protected
    procedure PropagateChange;
    procedure FrameClear;
    procedure FramePrepare;
    procedure SaveSettings;
    procedure LoadSettings;
  public
    OnChange: TNotifyEvent;
    procedure Initialize(ILManager: TILManager);
    procedure SetComparator(Comparator: TILFinderBaseClass; ProcessChange: Boolean);
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
cbNestedText.Checked := False;
end;

//------------------------------------------------------------------------------

procedure TfrmComparatorFrame.FramePrepare;
begin
leString.Visible := fComparator is TILTextComparator;
lblVarIndex.Visible := fComparator is TILTextComparator;
seVarIndex.Visible := fComparator is TILTextComparator;
cbCaseSensitive.Visible := fComparator is TILTextComparator;
cbAllowPartial.Visible := fComparator is TILTextComparator;
bvlStrSeparator.Visible := fComparator is TILTextComparator;
lblOperator.Visible := fComparator is TILComparatorBase;
cmbOperator.Visible := fComparator is TILComparatorBase;
cbNegate.Visible := fComparator is TILComparatorBase; 
cbNestedText.Visible := fComparator is TILElementComparator;
end;

//------------------------------------------------------------------------------

procedure TfrmComparatorFrame.SaveSettings;
begin
If Assigned(fComparator) then
  begin
    If not(fComparator is TILElementComparator) then
      begin
        If fComparator is TILTextComparator then
          begin
            TILTextComparator(fComparator).Str := leString.Text;
            TILTextComparator(fComparator).VariableIndex := seVarIndex.Value - 1;
            TILTextComparator(fComparator).CaseSensitive := cbCaseSensitive.Checked;
            TILTextComparator(fComparator).AllowPartial := cbAllowPartial.Checked;
          end;
        If fComparator is TILComparatorBase then
          begin
            TILComparatorBase(fComparator).Operator := TILSearchOperator(cmbOperator.ItemIndex);
            TILComparatorBase(fComparator).Negate := cbNegate.Checked;
          end;
      end
    else TILElementComparator(fComparator).NestedText := cbNestedText.Checked;
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
      If not(fComparator is TILElementComparator) then
        begin
          If fComparator is TILTextComparator then
            begin
              leString.Text := TILTextComparator(fComparator).Str;
              seVarIndex.Value := TILTextComparator(fComparator).VariableIndex + 1;
              cbCaseSensitive.Checked := TILTextComparator(fComparator).CaseSensitive;
              cbAllowPartial.Checked := TILTextComparator(fComparator).AllowPartial;
            end;
          If fComparator is TILComparatorBase then
            begin
              cmbOperator.ItemIndex := Ord(TILComparatorBase(fComparator).Operator);
              cbNegate.Checked := TILComparatorBase(fComparator).Negate;
            end;
        end
      else cbNestedText.Checked := TILElementComparator(fComparator).NestedText;
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

procedure TfrmComparatorFrame.SetComparator(Comparator: TILFinderBaseClass; ProcessChange: Boolean);
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
If (fComparator is TILComparatorBase) and not fInitializing then
  begin
    TILTextComparator(fComparator).Operator := TILSearchOperator(cmbOperator.ItemIndex);
    PropagateChange;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmComparatorFrame.cbNegateClick(Sender: TObject);
begin
If (fComparator is TILComparatorBase) and not fInitializing then
  begin
    TILTextComparator(fComparator).Negate := cbNegate.Checked;
    PropagateChange;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmComparatorFrame.cbNestedTextClick(Sender: TObject);
begin
If (fComparator is TILElementComparator) and not fInitializing then
  begin
    TILElementComparator(fComparator).NestedText := cbNestedText.Checked;
    PropagateChange;
  end;
end;

end.
