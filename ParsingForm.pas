unit ParsingForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls,
  InflatablesList_Types, InflatablesList, InflatablesList_HTML_ElementFinder,
  ComparatorFrame, ExtCtrls;

type
  TfParsingForm = class(TForm)
    gbFinderSettings: TGroupBox;
    lblStages: TLabel;
    lbStages: TListBox;
    lblStageElements: TLabel;
    tvStageElements: TTreeView;
    lblAttrComps: TLabel;
    tvAttrComps: TTreeView;
    lblTextComps: TLabel;
    tvTextComps: TTreeView;
    gbSelectedDetails: TGroupBox;
    frmComparatorFrame: TfrmComparatorFrame;
    gbExtracSettings: TGroupBox;
    cmbExtractFrom: TComboBox;
    lblExtractFrom: TLabel;
    cmbExtractMethod: TComboBox;
    lblExtractMethod: TLabel;
    leExtractionData: TLabeledEdit;
    leNegativeTag: TLabeledEdit;
    procedure lbStagesClick(Sender: TObject);
    procedure tvStageElementsClick(Sender: TObject);
    procedure tvStageElementsChange(Sender: TObject; Node: TTreeNode);
    procedure tvStageElementsEnter(Sender: TObject);
    procedure tvAttrCompsClick(Sender: TObject);
    procedure tvAttrCompsChange(Sender: TObject; Node: TTreeNode);
    procedure tvAttrCompsEnter(Sender: TObject);
    procedure tvTextCompsClick(Sender: TObject);
    procedure tvTextCompsChange(Sender: TObject; Node: TTreeNode);
    procedure tvTextCompsEnter(Sender: TObject);
  private
    fILManager:           TILManager;
    fCurrentParsingEntry: PILItemShopParsingEntry;
  protected
    procedure FrameChangeHandler(Sender: TObject);
    procedure ListStageElements(Stage: TILElementFinderStage);
    procedure ListAttribute(Attr: TILAttributeComparatorGroup);
    procedure ListText(Text: TILTextComparatorGroup);
    procedure ListComparator(Comparator: TILComparatorBase);
    procedure SaveForm;
    procedure LoadForm;
  public
    procedure Initialize(ILManager: TILManager);
    procedure ShowParsingSettings(const Caption: String; ParsingEntryPtr: PILItemShopParsingEntry);
  end;

var
  fParsingForm: TfParsingForm;

implementation

{$R *.dfm}

{
options:

  text

      string
      case sensitive
      allow partial
      variable index
      negate
      operator

  text group

      negate
      operator

  attr

      negate
      operator

  attr group

      negate
      operator

  element

      nested text

  stage

      -
}
{$message 'options for stage elements (nested text)'}

procedure TfParsingForm.FrameChangeHandler(Sender: TObject);
begin
If Assigned(tvTextComps.Selected) then
  If TObject(tvTextComps.Selected.Data) is TILTextComparatorBase then
    tvTextComps.Selected.Text := TILTextComparatorBase(tvTextComps.Selected.Data).
      AsString(tvTextComps.Selected.Index <> 0,tvTextComps.Selected.Index);
If Assigned(tvAttrComps.Selected) then
  If TObject(tvAttrComps.Selected.Data) is TILAttributeComparatorBase then
    tvAttrComps.Selected.Text := TILAttributeComparatorBase(tvAttrComps.Selected.Data).
      AsString(tvAttrComps.Selected.Index <> 0,tvAttrComps.Selected.Index);
If Assigned(tvStageElements.Selected) then
  If TObject(tvStageElements.Selected.Data) is TILFinderBaseClass then
    tvStageElements.Selected.Text := TILFinderBaseClass(tvStageElements.Selected.Data).
      AsString(
        (tvStageElements.Selected.Index <> 0) and
        (TObject(tvStageElements.Selected.Data) is TILElementComparator),
        tvStageElements.Selected.Index);
If lbStages.ItemIndex >= 0 then
  If lbStages.Items.Objects[lbStages.ItemIndex] is TILElementFinderStage then
    lbStages.Items[lbStages.ItemIndex] :=
      TILElementFinderStage(lbStages.Items.Objects[lbStages.ItemIndex]).
        AsString(lbStages.ItemIndex <> 0,lbStages.ItemIndex);
end;

//------------------------------------------------------------------------------

procedure TfParsingForm.ListStageElements(Stage: TILElementFinderStage);
var
  i:    Integer;
  Node: TTreeNode;
begin
tvStageElements.Enabled := Assigned(Stage);
tvStageElements.Items.BeginUpdate;
try
  tvStageElements.Items.Clear;
  If Assigned(Stage) then
    begin
      For i := 0 to Pred(Stage.Count) do
        begin
          Node := tvStageElements.Items.AddChildObject(nil,
            Stage[i].AsString(tvStageElements.Items.Count <> 0,tvStageElements.Items.Count),Stage[i]);
          tvStageElements.Items.AddChildObject(Node,Stage[i].TagName.AsString(False,-1),Stage[i].TagName);
          tvStageElements.Items.AddChildObject(Node,Stage[i].Attributes.AsString(False,-1),Stage[i].Attributes);
          tvStageElements.Items.AddChildObject(Node,Stage[i].Text.AsString(False,-1),Stage[i].Text);
          Node.Expand(True);
        end;
      If tvStageElements.Items.Count > 0 then
        tvStageElements.Select(tvStageElements.Items[0]);
    end;
finally
  tvStageElements.Items.EndUpdate;
end;
tvStageElements.OnClick(nil);
end;

//------------------------------------------------------------------------------

procedure TfParsingForm.ListAttribute(Attr: TILAttributeComparatorGroup);
var
  i:  Integer;

  procedure ListComparator(Comparator: TILAttributeComparatorBase; ParentNode: TTreeNode);
  var
    ii:   Integer;
    Node: TTreeNode;
  begin
    If Comparator is TILAttributeComparatorGroup then
      begin
        Node := tvAttrComps.Items.AddChildObject(ParentNode,
          Comparator.AsString(tvAttrComps.Items.Count <> 0,tvAttrComps.Items.Count),Comparator);
        For ii := 0 to Pred(TILAttributeComparatorGroup(Comparator).Count) do
          ListComparator(TILAttributeComparatorGroup(Comparator)[ii],Node);
        Node.Expand(True);
      end
    else If Comparator is TILAttributeComparator then
      begin
        Node := tvAttrComps.Items.AddChildObject(ParentNode,
          Comparator.AsString(tvAttrComps.Items.Count <> 0,tvAttrComps.Items.Count),Comparator);
        tvAttrComps.Items.AddChildObject(Node,
          TILAttributeComparator(Comparator).Name.AsString(False,-1),
          TILAttributeComparator(Comparator).Name);
        tvAttrComps.Items.AddChildObject(Node,
          TILAttributeComparator(Comparator).Value.AsString(False,-1),
          TILAttributeComparator(Comparator).Value);
        Node.Expand(True);
      end;
  end;  

begin
tvAttrComps.Enabled := Assigned(Attr);
tvAttrComps.Items.BeginUpdate;
try
  tvAttrComps.Items.Clear;
  If Assigned(Attr) then
    begin
      tvAttrComps.Color := clWindow;
      // recursively go trough the text comparators
      For i := 0 to Pred(Attr.Count) do
        ListComparator(Attr[i],nil);
      If tvAttrComps.Items.Count > 0 then
        tvAttrComps.Select(tvAttrComps.Items[0]);
    end
  else tvTextComps.Color := clBtnFace;
finally
  tvAttrComps.Items.EndUpdate;
end;
tvAttrComps.OnClick(nil);
end;

//------------------------------------------------------------------------------

procedure TfParsingForm.ListText(Text: TILTextComparatorGroup);
var
  i:  Integer;

  procedure ListComparator(Comparator: TILTextComparatorBase; ParentNode: TTreeNode);
  var
    ii:   Integer;
    Node: TTreeNode;
  begin
    If Comparator is TILTextComparatorGroup then
      begin
        Node := tvTextComps.Items.AddChildObject(
          ParentNode,Comparator.AsString(tvTextComps.Items.Count <> 0),Comparator);
        For ii := 0 to Pred(TILTextComparatorGroup(Comparator).Count) do
          ListComparator(TILTextComparatorGroup(Comparator)[ii],Node);
        Node.Expand(True);
      end
    else If Comparator is TILTextComparator then
      begin
        tvTextComps.Items.AddChildObject(
          ParentNode,Comparator.AsString(tvTextComps.Items.Count <> 0),Comparator);
      end;
  end;

begin
tvTextComps.Enabled := Assigned(Text);
tvTextComps.Items.BeginUpdate;
try
  tvTextComps.Items.Clear;
  If Assigned(Text) then
    begin
      tvTextComps.Color := clWindow;
      // recursively go trough the text comparators
      For i := 0 to Pred(Text.Count) do
        ListComparator(Text[i],nil);
      If tvTextComps.Items.Count > 0 then
        tvTextComps.Select(tvTextComps.Items[0]);
    end
  else tvTextComps.Color := clBtnFace;
finally
  tvTextComps.Items.EndUpdate;
end;
tvTextComps.OnClick(nil);
end;

//------------------------------------------------------------------------------

procedure TfParsingForm.ListComparator(Comparator: TILComparatorBase);
begin
If Comparator is TILAttributeComparatorGroup then
  begin
    // attributes
    tvAttrComps.Enabled := True;
    tvAttrComps.Color := clWindow;
    tvTextComps.Enabled := True;
    tvTextComps.Color := clWindow;
    ListAttribute(TILAttributeComparatorGroup(Comparator));
  end
else If Comparator is TILTextComparatorGroup then
  begin
    // tag name or text 
    tvTextComps.Enabled := True;
    tvTextComps.Color := clWindow;
    ListText(TILTextComparatorGroup(Comparator));
    tvAttrComps.Items.Clear;
    tvAttrComps.Enabled := False;
    tvAttrComps.Color := clBtnFace;
  end
else
  begin
    // any other (eg. element comparator), clear and disable treeviews
    tvAttrComps.Items.Clear;
    tvAttrComps.Enabled := False;
    tvAttrComps.Color := clBtnFace;
    tvTextComps.Items.Clear;
    tvTextComps.Enabled := False;
    tvTextComps.Color := clBtnFace;
  end;
end;

//------------------------------------------------------------------------------

procedure TfParsingForm.SaveForm;
begin
If Assigned(fCurrentParsingEntry) then
  begin
    fCurrentParsingEntry^.Extraction.ExtractFrom :=
      TILItemShopParsingExtrFrom(cmbExtractFrom.ItemIndex);
    fCurrentParsingEntry^.Extraction.ExtractionMethod :=
      TILItemShopParsingExtrMethod(cmbExtractMethod.ItemIndex);
    fCurrentParsingEntry^.Extraction.ExtractionData := leExtractionData.Text;
    fCurrentParsingEntry^.Extraction.NegativeTag := leNegativeTag.Text;
  end;
end;

//------------------------------------------------------------------------------

procedure TfParsingForm.LoadForm;
begin
If Assigned(fCurrentParsingEntry) then
  begin
    cmbExtractFrom.ItemIndex := Ord(fCurrentParsingEntry^.Extraction.ExtractFrom);
    cmbExtractMethod.ItemIndex := Ord(fCurrentParsingEntry^.Extraction.ExtractionMethod);
    leExtractionData.Text := fCurrentParsingEntry^.Extraction.ExtractionData;
    leNegativeTag.Text := fCurrentParsingEntry^.Extraction.NegativeTag;
  end;
end;

//==============================================================================

procedure TfParsingForm.Initialize(ILManager: TILManager);
var
  i:  Integer;
begin
fILManager := ILManager;
frmComparatorFrame.Initialize(fIlManager);
frmComparatorFrame.OnChange := FrameChangeHandler;
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

procedure TfParsingForm.ShowParsingSettings(const Caption: String; ParsingEntryPtr: PILItemShopParsingEntry);
var
  i:  Integer;
begin
Self.Caption := Caption;
fCurrentParsingEntry := ParsingEntryPtr;
// fill list of stages
lbStages.Items.BeginUpdate;
try
  lbStages.Clear;
  For i := 0 to Pred(TILElementFinder(fCurrentParsingEntry^.Finder).StageCount) do
    lbStages.Items.AddObject(
      TILElementFinder(fCurrentParsingEntry^.Finder).Stages[i].AsString(i <> 0,i),
      TILElementFinder(fCurrentParsingEntry^.Finder).Stages[i])
finally
  lbStages.Items.EndUpdate;
end;
If lbStages.Count > 0 then
  lbStages.ItemIndex := 0;
lbStages.OnClick(nil);
LoadForm;
ShowModal;
SaveForm;
frmComparatorFrame.SetComparator(nil,True);
end;

//==============================================================================

procedure TfParsingForm.lbStagesClick(Sender: TObject);
begin
If lbStages.ItemIndex >= 0 then
  begin
    If lbStages.Items.Objects[lbStages.ItemIndex] is TILElementFinderStage then
      ListStageElements(TILElementFinderStage(lbStages.Items.Objects[lbStages.ItemIndex]))
    else
      ListStageElements(nil);
  end
else ListStageElements(nil);
frmComparatorFrame.SetComparator(nil,True);
end;

//------------------------------------------------------------------------------

procedure TfParsingForm.tvStageElementsClick(Sender: TObject);
begin
If Assigned(tvStageElements.Selected) then
  begin
    If TObject(tvStageElements.Selected.Data) is TILComparatorBase then
      ListComparator(TILComparatorBase(tvStageElements.Selected.Data))
    else
      ListComparator(nil);
  end
else ListComparator(nil);
If tvStageElements.Focused and Assigned(tvStageElements.Selected) then
  begin
    If TObject(tvStageElements.Selected.Data) is TILComparatorBase then
      frmComparatorFrame.SetComparator(TILComparatorBase(tvStageElements.Selected.Data),True)
    else
      frmComparatorFrame.SetComparator(nil,True);
  end;
end;

//------------------------------------------------------------------------------

procedure TfParsingForm.tvStageElementsChange(Sender: TObject; Node: TTreeNode);
begin
tvStageElements.OnClick(nil);
end;

//------------------------------------------------------------------------------

procedure TfParsingForm.tvStageElementsEnter(Sender: TObject);
begin
tvStageElements.OnClick(nil);
end;

//------------------------------------------------------------------------------

procedure TfParsingForm.tvAttrCompsClick(Sender: TObject);
begin
If Assigned(tvAttrComps.Selected) then
  begin
    If TObject(tvAttrComps.Selected.Data) is TILTextComparatorGroup then
      ListText(TILTextComparatorGroup(tvAttrComps.Selected.Data))
    else
      ListText(nil);
  end
else ListText(nil);
If tvAttrComps.Focused and Assigned(tvAttrComps.Selected) then
  begin
    If TObject(tvAttrComps.Selected.Data) is TILComparatorBase then
      frmComparatorFrame.SetComparator(TILComparatorBase(tvAttrComps.Selected.Data),True)
    else
      frmComparatorFrame.SetComparator(nil,True);
  end;
end;

//------------------------------------------------------------------------------

procedure TfParsingForm.tvAttrCompsChange(Sender: TObject; Node: TTreeNode);
begin
tvAttrComps.OnClick(nil);
end;

//------------------------------------------------------------------------------

procedure TfParsingForm.tvAttrCompsEnter(Sender: TObject);
begin
tvAttrComps.OnClick(nil);
end;

//------------------------------------------------------------------------------

procedure TfParsingForm.tvTextCompsClick(Sender: TObject);
begin
If tvTextComps.Focused and Assigned(tvTextComps.Selected) then
  begin
    If TObject(tvTextComps.Selected.Data) is TILComparatorBase then
      frmComparatorFrame.SetComparator(TILComparatorBase(tvTextComps.Selected.Data),True)
    else
      frmComparatorFrame.SetComparator(nil,True);
  end;
end;

//------------------------------------------------------------------------------

procedure TfParsingForm.tvTextCompsChange(Sender: TObject; Node: TTreeNode);
begin
tvTextComps.OnClick(nil);
end;

//------------------------------------------------------------------------------

procedure TfParsingForm.tvTextCompsEnter(Sender: TObject);
begin
tvTextComps.OnClick(nil);
end;

end.
