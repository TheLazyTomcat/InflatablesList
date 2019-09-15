unit ParsingForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, Menus,
  ComparatorFrame, ExtractionFrame,
  InflatablesList_Types,
  InflatablesList_HTML_ElementFinder,
  InflatablesList_ItemShopParsingSettings,
  InflatablesList_Manager;

type
  TILItemShopParsingEntry = record
    Extraction: TILItemShopParsingExtrSettList;
    Finder:     TILElementFinder;
  end;

const
  IL_WM_USER_LVITEMSELECTED = WM_USER + 234;

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
    lblExtrIdx: TLabel;
    btnExtrNext: TButton;
    btnExtrPrev: TButton;
    btnExtrAdd: TButton;
    btnExtrRemove: TButton;
    frmExtractionFrame: TfrmExtractionFrame;
    pmnStages: TPopupMenu;
    mniSG_Add: TMenuItem;
    mniSG_Remove: TMenuItem;
    pmnElements: TPopupMenu;
    mniEL_Add: TMenuItem;
    mniEL_Remove: TMenuItem;
    pmnAttributes: TPopupMenu;
    mniAT_AddComp: TMenuItem;
    mniAT_AddGroup: TMenuItem;
    mniAT_Remove: TMenuItem;
    pmnTexts: TPopupMenu;
    mniTX_AddComp: TMenuItem;
    mniTX_AddGroup: TMenuItem;
    mniTX_Remove: TMenuItem;
    procedure FormCreate(Sender: TObject);    
    procedure lbStagesClick(Sender: TObject);
    procedure lbStagesMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pmnStagesPopup(Sender: TObject);
    procedure mniSG_AddClick(Sender: TObject);
    procedure mniSG_RemoveClick(Sender: TObject);
    procedure tvStageElementsSelect;
    procedure tvStageElementsClick(Sender: TObject);
    procedure tvStageElementsChange(Sender: TObject; Node: TTreeNode);
    procedure tvStageElementsEnter(Sender: TObject);
    procedure pmnElementsPopup(Sender: TObject);    
    procedure mniEL_AddClick(Sender: TObject);
    procedure mniEL_RemoveClick(Sender: TObject);
    procedure tvAttrCompsSelect;
    procedure tvAttrCompsClick(Sender: TObject);
    procedure tvAttrCompsChange(Sender: TObject; Node: TTreeNode);
    procedure tvAttrCompsEnter(Sender: TObject);
    procedure pmnAttributesPopup(Sender: TObject);
    procedure mniAT_AddCompClick(Sender: TObject);
    procedure mniAT_AddGroupClick(Sender: TObject);
    procedure mniAT_RemoveClick(Sender: TObject);
    procedure tvTextCompsSelect;   
    procedure tvTextCompsClick(Sender: TObject);
    procedure tvTextCompsChange(Sender: TObject; Node: TTreeNode);
    procedure tvTextCompsEnter(Sender: TObject);
    procedure pmnTextsPopup(Sender: TObject);
    procedure mniTX_AddCompClick(Sender: TObject);
    procedure mniTX_AddGroupClick(Sender: TObject);
    procedure mniTX_RemoveClick(Sender: TObject);
    procedure btnExtrAddClick(Sender: TObject);
    procedure btnExtrRemoveClick(Sender: TObject);
    procedure btnExtrPrevClick(Sender: TObject);
    procedure btnExtrNextClick(Sender: TObject);
  private
    fILManager:           TILManager;
    fCurrentParsingEntry: TILItemShopParsingEntry;
    fExtractionSettIndex: Integer;
  protected
    // frame events
    procedure FrameChangeHandler(Sender: TObject);
    // other methods
    procedure FillStageElements(Stage: TILElementFinderStage);
    procedure FillAttributes(Attr: TILAttributeComparatorGroup);
    procedure FillTexts(Text: TILTextComparatorGroup);
    procedure ShowComparator(Comparator: TILComparatorBase);
    procedure SetExtractionIndex(NewIndex: Integer);
    procedure ShowExtractionIndex;
    procedure ListViewItemSelected(var Msg: TMessage); message IL_WM_USER_LVITEMSELECTED;
  public
    procedure Initialize(ILManager: TILManager);
    procedure Finalize;
    procedure ShowParsingSettings(const Caption: String; ParsingSettings: TILItemShopParsingSettings; OnPrice: Boolean);
  end;

var
  fParsingForm: TfParsingForm;                           

implementation

uses
  InflatablesList_Utils;

{$R *.dfm}

const
  IL_MSG_PARAM_LIST_IDX_ELEMENTS   = 1;
  IL_MSG_PARAM_LIST_IDX_ATTRIBUTES = 2;
  IL_MSG_PARAM_LIST_IDX_TEXTS      = 3;

procedure TfParsingForm.FrameChangeHandler(Sender: TObject);
var
  Node: TTreeNode;
begin
// change texts in all nodes...
// texts
Node := tvTextComps.Selected;
while Assigned(Node) do
  begin
    If TObject(Node.Data) is TILFinderBaseClass then
      Node.Text := TILFinderBaseClass(Node.Data).AsString;
    Node := Node.Parent;
  end;
// attributes
Node := tvAttrComps.Selected;
while Assigned(Node) do
  begin
    If TObject(Node.Data) is TILFinderBaseClass then
      Node.Text := TILFinderBaseClass(Node.Data).AsString;
    Node := Node.Parent;
  end;
// stage elements
Node := tvStageElements.Selected;
while Assigned(Node) do
  begin
    If TObject(Node.Data) is TILFinderBaseClass then
      Node.Text := TILFinderBaseClass(Node.Data).AsString;
    Node := Node.Parent;
  end;
// stages
If lbStages.ItemIndex >= 0 then
  If lbStages.Items.Objects[lbStages.ItemIndex] is TILFinderBaseClass then
    lbStages.Items[lbStages.ItemIndex] := TILFinderBaseClass(
      lbStages.Items.Objects[lbStages.ItemIndex]).AsString;
end;

//------------------------------------------------------------------------------

procedure TfParsingForm.FillStageElements(Stage: TILElementFinderStage);
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
          Node := tvStageElements.Items.AddChildObject(nil,Stage[i].AsString,Stage[i]);
          tvStageElements.Items.AddChildObject(Node,Stage[i].TagName.AsString,Stage[i].TagName);
          tvStageElements.Items.AddChildObject(Node,Stage[i].Attributes.AsString,Stage[i].Attributes);
          tvStageElements.Items.AddChildObject(Node,Stage[i].Text.AsString,Stage[i].Text);
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

procedure TfParsingForm.FillAttributes(Attr: TILAttributeComparatorGroup);
var
  i:  Integer;

  procedure FillComparatorLocal(Comparator: TILAttributeComparatorBase; ParentNode: TTreeNode);
  var
    ii:   Integer;
    Node: TTreeNode;
  begin
    If Comparator is TILAttributeComparatorGroup then
      begin
        Node := tvAttrComps.Items.AddChildObject(ParentNode,Comparator.AsString,Comparator);
        For ii := 0 to Pred(TILAttributeComparatorGroup(Comparator).Count) do
          FillComparatorLocal(TILAttributeComparatorGroup(Comparator)[ii],Node);
        Node.Expand(True);
      end
    else If Comparator is TILAttributeComparator then
      begin
        Node := tvAttrComps.Items.AddChildObject(ParentNode,Comparator.AsString,Comparator);
        tvAttrComps.Items.AddChildObject(Node,
          TILAttributeComparator(Comparator).Name.AsString,TILAttributeComparator(Comparator).Name);
        tvAttrComps.Items.AddChildObject(Node,
          TILAttributeComparator(Comparator).Value.AsString,TILAttributeComparator(Comparator).Value);
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
        FillComparatorLocal(Attr[i],nil);
      If tvAttrComps.Items.Count > 0 then
        tvAttrComps.Select(tvAttrComps.Items[0]);
    end
  else tvTextComps.Color := $00F8F8F8;
finally
  tvAttrComps.Items.EndUpdate;
end;
tvAttrComps.OnClick(nil);
end;

//------------------------------------------------------------------------------

procedure TfParsingForm.FillTexts(Text: TILTextComparatorGroup);
var
  i:  Integer;

  procedure FillComparatorLocal(Comparator: TILTextComparatorBase; ParentNode: TTreeNode);
  var
    ii:   Integer;
    Node: TTreeNode;
  begin
    If Comparator is TILTextComparatorGroup then
      begin
        Node := tvTextComps.Items.AddChildObject(ParentNode,Comparator.AsString,Comparator);
        For ii := 0 to Pred(TILTextComparatorGroup(Comparator).Count) do
          FillComparatorLocal(TILTextComparatorGroup(Comparator)[ii],Node);
        Node.Expand(True);
      end
    else If Comparator is TILTextComparator then
      begin
        tvTextComps.Items.AddChildObject(ParentNode,Comparator.AsString,Comparator);
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
        FillComparatorLocal(Text[i],nil);
      If tvTextComps.Items.Count > 0 then
        tvTextComps.Select(tvTextComps.Items[0]);
    end
  else tvTextComps.Color := $00F8F8F8;
finally
  tvTextComps.Items.EndUpdate;
end;
tvTextComps.OnClick(nil);
end;

//------------------------------------------------------------------------------

procedure TfParsingForm.ShowComparator(Comparator: TILComparatorBase);
begin
If Comparator is TILAttributeComparatorGroup then
  begin
    // attributes
    tvAttrComps.Enabled := True;
    tvAttrComps.Color := clWindow;
    tvTextComps.Enabled := True;
    tvTextComps.Color := clWindow;
    FillAttributes(TILAttributeComparatorGroup(Comparator));
  end
else If Comparator is TILTextComparatorGroup then
  begin
    // tag name or text
    tvAttrComps.Items.Clear;
    tvAttrComps.Enabled := False;
    tvAttrComps.Color := $00F8F8F8;
    tvTextComps.Enabled := True;
    tvTextComps.Color := clWindow;
    FillTexts(TILTextComparatorGroup(Comparator));
  end
else
  begin
    // any other (eg. element comparator), clear and disable treeviews
    tvAttrComps.Items.Clear;
    tvAttrComps.Enabled := False;
    tvAttrComps.Color := $00F8F8F8;
    tvTextComps.Items.Clear;
    tvTextComps.Enabled := False;
    tvTextComps.Color := $00F8F8F8;
  end;
end;

//------------------------------------------------------------------------------

procedure TfParsingForm.SetExtractionIndex(NewIndex: Integer);
begin
If (NewIndex >= Low(fCurrentParsingEntry.Extraction)) and
   (NewIndex <= High(fCurrentParsingEntry.Extraction)) then
  begin
    fExtractionSettIndex := NewIndex;
    frmExtractionFrame.SetExtractSett(Addr(fCurrentParsingEntry.Extraction[fExtractionSettIndex]),True);
    ShowExtractionIndex;
  end
else
  begin
    fExtractionSettIndex := -1;
    frmExtractionFrame.SetExtractSett(nil,True);
    ShowExtractionIndex;
  end;
end;

//------------------------------------------------------------------------------

procedure TfParsingForm.ShowExtractionIndex;
begin
If (fExtractionSettIndex >= 0) and (Length(fCurrentParsingEntry.Extraction) > 0) then
  lblExtrIdx.Caption := IL_Format('%d/%d',[fExtractionSettIndex + 1,Length(fCurrentParsingEntry.Extraction)])
else
  lblExtrIdx.Caption := '-';
btnExtrRemove.Enabled := fExtractionSettIndex >= 0;
btnExtrPrev.Enabled := (fExtractionSettIndex >= 0) and (fExtractionSettIndex > Low(fCurrentParsingEntry.Extraction));
btnExtrNext.Enabled := (fExtractionSettIndex >= 0) and (fExtractionSettIndex < High(fCurrentParsingEntry.Extraction));
end;

//------------------------------------------------------------------------------

procedure TfParsingForm.ListViewItemSelected(var Msg: TMessage);
begin
If Msg.Msg = IL_WM_USER_LVITEMSELECTED then
  case Msg.LParam of
    IL_MSG_PARAM_LIST_IDX_ELEMENTS:   tvStageElementsSelect;
    IL_MSG_PARAM_LIST_IDX_ATTRIBUTES: tvAttrCompsSelect;
    IL_MSG_PARAM_LIST_IDX_TEXTS:      tvTextCompsSelect;
  end;
end;

//==============================================================================

procedure TfParsingForm.Initialize(ILManager: TILManager);
begin
fILManager := ILManager;
frmComparatorFrame.Initialize(fIlManager);
frmComparatorFrame.OnChange := FrameChangeHandler;
frmExtractionFrame.Initialize(fIlManager);
end;

//------------------------------------------------------------------------------

procedure TfParsingForm.Finalize;
begin
frmExtractionFrame.Finalize;
frmComparatorFrame.OnChange := nil;
frmComparatorFrame.Finalize;
end;

//------------------------------------------------------------------------------

procedure  TfParsingForm.ShowParsingSettings(const Caption: String; ParsingSettings: TILItemShopParsingSettings; OnPrice: Boolean);
var
  i:  Integer;
begin
Self.Caption := Caption;
If OnPrice then
  begin
    SetLength(fCurrentParsingEntry.Extraction,ParsingSettings.PriceExtractionSettingsCount);
    For i := Low(fCurrentParsingEntry.Extraction) to High(fCurrentParsingEntry.Extraction) do
      fCurrentParsingEntry.Extraction[i] := IL_ThreadSafeCopy(ParsingSettings.PriceExtractionSettings[i]);
    fCurrentParsingEntry.Finder := ParsingSettings.PriceFinder;
  end
else
  begin
    SetLength(fCurrentParsingEntry.Extraction,ParsingSettings.AvailExtractionSettingsCount);
    For i := Low(fCurrentParsingEntry.Extraction) to High(fCurrentParsingEntry.Extraction) do
      fCurrentParsingEntry.Extraction[i] := IL_ThreadSafeCopy(ParsingSettings.AvailExtractionSettings[i]);
    fCurrentParsingEntry.Finder := ParsingSettings.AvailFinder;
  end;
// fill list of stages
lbStages.Items.BeginUpdate;
try
  lbStages.Clear;
  For i := 0 to Pred(TILElementFinder(fCurrentParsingEntry.Finder).StageCount) do
    lbStages.Items.AddObject(fCurrentParsingEntry.Finder.Stages[i].AsString,fCurrentParsingEntry.Finder.Stages[i])
finally
  lbStages.Items.EndUpdate;
end;
If lbStages.Count > 0 then
  lbStages.ItemIndex := 0;
lbStages.OnClick(nil);
// set extraction frame
fExtractionSettIndex := -1;
If Length(fCurrentParsingEntry.Extraction) > 0 then
  SetExtractionIndex(0)
else
  SetExtractionIndex(-1);
ShowModal;
// do cleanup
frmComparatorFrame.SetComparator(nil,True);
frmExtractionFrame.SetExtractSett(nil,True);
lbStages.Clear;
tvStageElements.Items.Clear;
tvAttrComps.Items.Clear;
tvTextComps.Items.Clear;
// get results
If OnPrice then
  begin
    ParsingSettings.PriceExtractionSettingsClear;
    For i := Low(fCurrentParsingEntry.Extraction) to High(fCurrentParsingEntry.Extraction) do
      begin
        ParsingSettings.PriceExtractionSettingsAdd;
        ParsingSettings.PriceExtractionSettings[i] := fCurrentParsingEntry.Extraction[i];
      end;
  end
else
  begin
    ParsingSettings.AvailExtractionSettingsClear;
    For i := Low(fCurrentParsingEntry.Extraction) to High(fCurrentParsingEntry.Extraction) do
      begin
        ParsingSettings.AvailExtractionSettingsAdd;
        ParsingSettings.AvailExtractionSettings[i] := fCurrentParsingEntry.Extraction[i];
      end;
  end;
end;

//==============================================================================

procedure TfParsingForm.FormCreate(Sender: TObject);
begin
tvStageElements.DoubleBuffered := True;
tvAttrComps.DoubleBuffered := True;
tvTextComps.DoubleBuffered := True;
end;

//------------------------------------------------------------------------------

procedure TfParsingForm.lbStagesClick(Sender: TObject);
begin
If lbStages.ItemIndex >= 0 then
  begin
    If lbStages.Items.Objects[lbStages.ItemIndex] is TILElementFinderStage then
      FillStageElements(TILElementFinderStage(lbStages.Items.Objects[lbStages.ItemIndex]))
    else
      FillStageElements(nil);
  end
else FillStageElements(nil);
frmComparatorFrame.SetComparator(nil,True);
end;

//------------------------------------------------------------------------------

procedure TfParsingForm.lbStagesMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Index:  Integer;
begin
If Button = mbRight then
  begin
    Index := lbStages.ItemAtPos(Point(X,Y),True);
    If Index >= 0 then
      begin
        lbStages.ItemIndex := Index;
        lbStages.OnClick(nil);
      end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfParsingForm.pmnStagesPopup(Sender: TObject);
begin
mniSG_Remove.Enabled := lbStages.ItemIndex >= 0;
end;

//------------------------------------------------------------------------------

procedure TfParsingForm.mniSG_AddClick(Sender: TObject);
var
  Temp: TILElementFinderStage;
begin
Temp := fCurrentParsingEntry.Finder.StageAdd;
lbStages.Items.AddObject(Temp.AsString,Temp);
If lbStages.Items.Count > 0 then
  begin
    lbStages.ItemIndex := Pred(lbStages.Count);
    lbStages.OnClick(nil);
    FrameChangeHandler(nil);
  end;
end;

//------------------------------------------------------------------------------

procedure TfParsingForm.mniSG_RemoveClick(Sender: TObject);
var
  Index:  Integer;
begin
If lbStages.ItemIndex >= 0 then
  If MessageDlg(IL_Format('Are you sure you want to delete stage "%s"?',
    [lbStages.Items[lbStages.ItemIndex]]),mtConfirmation,[mbYes,mbNo],0) = mrYes then
    begin
      Index := lbStages.ItemIndex;
      If lbStages.ItemIndex < Pred(lbStages.Count) then
        lbStages.ItemIndex := lbStages.ItemIndex + 1
      else If lbStages.ItemIndex > 0 then
        lbStages.ItemIndex := lbStages.ItemIndex - 1
      else
        lbStages.ItemIndex := -1;
      lbStages.OnClick(nil);
      lbStages.Items.Delete(Index);
      fCurrentParsingEntry.Finder.StageDelete(Index);
      FrameChangeHandler(nil);
    end;
end;

//------------------------------------------------------------------------------

procedure TfParsingForm.tvStageElementsSelect;
begin
If Assigned(tvStageElements.Selected) then
  begin
    If TObject(tvStageElements.Selected.Data) is TILComparatorBase then
      ShowComparator(TILComparatorBase(tvStageElements.Selected.Data))
    else
      ShowComparator(nil);
  end
else ShowComparator(nil);
If tvStageElements.Focused then
  begin
    If Assigned(tvStageElements.Selected) and (TObject(tvStageElements.Selected.Data) is TILFinderBaseClass) then
      frmComparatorFrame.SetComparator(TILComparatorBase(tvStageElements.Selected.Data),True)
    else
      frmComparatorFrame.SetComparator(nil,True);
  end;
end;

//------------------------------------------------------------------------------

procedure TfParsingForm.tvStageElementsClick(Sender: TObject);
begin
//this deffers reaction to change and prevents flickering
PostMessage(Handle,IL_WM_USER_LVITEMSELECTED,0,IL_MSG_PARAM_LIST_IDX_ELEMENTS);
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


procedure TfParsingForm.pmnElementsPopup(Sender: TObject);
begin
If Assigned(tvStageElements.Selected) then
  mniEL_Remove.Enabled := TObject(tvStageElements.Selected.Data) is TILElementComparator
else
  mniEL_Remove.Enabled := False;
end;

//------------------------------------------------------------------------------

procedure TfParsingForm.mniEL_AddClick(Sender: TObject);
var
  Temp: TILElementComparator;
  Node: TTreeNode;
begin
Temp := fCurrentParsingEntry.Finder[lbStages.ItemIndex].AddComparator;
Node := tvStageElements.Items.AddChildObject(nil,Temp.AsString,Temp);
tvStageElements.Items.AddChildObject(Node,Temp.TagName.AsString,Temp.TagName);
tvStageElements.Items.AddChildObject(Node,Temp.Attributes.AsString,Temp.Attributes);
tvStageElements.Items.AddChildObject(Node,Temp.Text.AsString,Temp.Text);
Node.Expand(True);
FrameChangeHandler(nil);
end;

//------------------------------------------------------------------------------

procedure TfParsingForm.mniEL_RemoveClick(Sender: TObject);
var
  Node: TTreeNode;
  Temp: TILElementComparator;
begin
If Assigned(tvStageElements.Selected) then
  If TObject(tvStageElements.Selected.Data) is TILElementComparator then
    begin
      Node := tvStageElements.Selected;
      Temp := TILElementComparator(tvStageElements.Selected.Data);
      If MessageDlg(IL_Format('Are you sure you want to delete element option "%s"?',
        [Temp.AsString]),mtConfirmation,[mbYes,mbNo],0) = mrYes then
        begin
          tvStageElements.Items.Delete(Node);
          tvStageElements.OnClick(nil);
          fCurrentParsingEntry.Finder[lbStages.ItemIndex].Remove(Temp);
          FrameChangeHandler(nil);
        end;
    end;
end;

//------------------------------------------------------------------------------

procedure TfParsingForm.tvAttrCompsSelect;
begin
If Assigned(tvAttrComps.Selected) then
  begin
    If TObject(tvAttrComps.Selected.Data) is TILTextComparatorGroup then
      FillTexts(TILTextComparatorGroup(tvAttrComps.Selected.Data))
    else
      FillTexts(nil);
  end
else FillTexts(nil);
If tvAttrComps.Focused then
  begin
    If Assigned(tvAttrComps.Selected) and (TObject(tvAttrComps.Selected.Data) is TILComparatorBase) then
      frmComparatorFrame.SetComparator(TILComparatorBase(tvAttrComps.Selected.Data),True)
    else
      frmComparatorFrame.SetComparator(nil,True);
  end;
end;

//------------------------------------------------------------------------------

procedure TfParsingForm.tvAttrCompsClick(Sender: TObject);
begin
PostMessage(Handle,IL_WM_USER_LVITEMSELECTED,0,IL_MSG_PARAM_LIST_IDX_ATTRIBUTES);
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

procedure TfParsingForm.pmnAttributesPopup(Sender: TObject);
begin
If Assigned(tvAttrComps.Selected) then
  mniAT_Remove.Enabled := TObject(tvAttrComps.Selected.Data) is TILAttributeComparatorBase
else
  mniAT_Remove.Enabled := False;
end;

//------------------------------------------------------------------------------

procedure TfParsingForm.mniAT_AddCompClick(Sender: TObject);
var
  Group:  TILAttributeComparatorGroup;
  Temp:   TILAttributeComparator;
  Node:   TTreeNode;
begin
Group := TObject(tvStageElements.Selected.Data) as TILAttributeComparatorGroup;
Node := nil;
If Assigned(tvAttrComps.Selected) then
  If TObject(tvAttrComps.Selected.Data) is TILAttributeComparatorGroup then
    begin
      Group := TILAttributeComparatorGroup(tvAttrComps.Selected.Data);
      Node := tvAttrComps.Selected;
    end;
Temp := Group.AddComparator;
Node := tvAttrComps.Items.AddChildObject(Node,Temp.AsString,Temp);
tvAttrComps.Items.AddChildObject(Node,Temp.Name.AsString,Temp.Name);
tvAttrComps.Items.AddChildObject(Node,Temp.Value.AsString,Temp.Value);
Node.Expand(True);
tvAttrComps.Select(Node);
FrameChangeHandler(nil);
end;

//------------------------------------------------------------------------------

procedure TfParsingForm.mniAT_AddGroupClick(Sender: TObject);
var
  Group:  TILAttributeComparatorGroup;
  Temp:   TILAttributeComparatorGroup;
  Node:   TTreeNode;
begin
Group := TObject(tvStageElements.Selected.Data) as TILAttributeComparatorGroup;
Node := nil;
If Assigned(tvAttrComps.Selected) then
  If TObject(tvAttrComps.Selected.Data) is TILAttributeComparatorGroup then
    begin
      Group := TILAttributeComparatorGroup(tvAttrComps.Selected.Data);
      Node := tvAttrComps.Selected;
    end;
Temp := Group.AddGroup;
Node := tvAttrComps.Items.AddChildObject(Node,Temp.AsString,Temp);
Node.Expand(True);
tvAttrComps.Select(Node);
FrameChangeHandler(nil);
end;

//------------------------------------------------------------------------------

procedure TfParsingForm.mniAT_RemoveClick(Sender: TObject);
var
  Group:    TILAttributeComparatorGroup;
  ToDelete: TObject;
begin
If Assigned(tvAttrComps.Selected) then
  begin
    Group := TObject(tvStageElements.Selected.Data) as TILAttributeComparatorGroup;
    If Assigned(tvAttrComps.Selected.Parent) then
      If TObject(tvAttrComps.Selected.Parent.Data) is TILAttributeComparatorGroup then
        Group := TILAttributeComparatorGroup(tvAttrComps.Selected.Parent.Data);
    If MessageDlg(IL_Format('Are you sure you want to delete node "%s"?',
      [tvAttrComps.Selected.Text]),mtConfirmation,[mbYes,mbNo],0) = mrYes then
      begin
        ToDelete := TObject(tvAttrComps.Selected.Data);
        tvAttrComps.Items.Delete(tvAttrComps.Selected);
        tvAttrComps.OnClick(nil);
        Group.Remove(ToDelete);
        FrameChangeHandler(nil);
      end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfParsingForm.tvTextCompsSelect;
begin
If tvTextComps.Focused then
  begin
    If Assigned(tvTextComps.Selected) and (TObject(tvTextComps.Selected.Data) is TILComparatorBase) then
      frmComparatorFrame.SetComparator(TILComparatorBase(tvTextComps.Selected.Data),True)
    else
      frmComparatorFrame.SetComparator(nil,True);
  end;
end;

//------------------------------------------------------------------------------

procedure TfParsingForm.tvTextCompsClick(Sender: TObject);
begin
PostMessage(Handle,IL_WM_USER_LVITEMSELECTED,0,IL_MSG_PARAM_LIST_IDX_TEXTS);
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

//------------------------------------------------------------------------------

procedure TfParsingForm.pmnTextsPopup(Sender: TObject);
begin
begin
If Assigned(tvTextComps.Selected) then
  mniTX_Remove.Enabled := TObject(tvTextComps.Selected.Data) is TILTextComparatorBase
else
  mniTX_Remove.Enabled := False;
end;
end;

//------------------------------------------------------------------------------

procedure TfParsingForm.mniTX_AddCompClick(Sender: TObject);
var
  Group:  TILTextComparatorGroup;
  Temp:   TILTextComparator;
  Node:   TTreeNode;
begin
If Assigned(tvAttrComps.Selected) then
  Group := TObject(tvAttrComps.Selected.Data) as TILTextComparatorGroup
else
  Group := TObject(tvStageElements.Selected.Data) as TILTextComparatorGroup;
Node := nil;
If Assigned(tvTextComps.Selected) then
  If TObject(tvTextComps.Selected.Data) is TILTextComparatorGroup then
    begin
      Group := TILTextComparatorGroup(tvTextComps.Selected.Data);
      Node := tvTextComps.Selected;
    end;
Temp := Group.AddComparator;
Node := tvTextComps.Items.AddChildObject(Node,Temp.AsString,Temp);
Node.Expand(True);
tvTextComps.Select(Node);
FrameChangeHandler(nil);
end;

//------------------------------------------------------------------------------

procedure TfParsingForm.mniTX_AddGroupClick(Sender: TObject);
var
  Group:  TILTextComparatorGroup;
  Temp:   TILTextComparatorGroup;
  Node:   TTreeNode;
begin
If Assigned(tvAttrComps.Selected) then
  Group := TObject(tvAttrComps.Selected.Data) as TILTextComparatorGroup
else
  Group := TObject(tvStageElements.Selected.Data) as TILTextComparatorGroup;
Node := nil;
If Assigned(tvTextComps.Selected) then
  If TObject(tvTextComps.Selected.Data) is TILTextComparatorGroup then
    begin
      Group := TILTextComparatorGroup(tvTextComps.Selected.Data);
      Node := tvTextComps.Selected;
    end;
Temp := Group.AddGroup;
Node := tvTextComps.Items.AddChildObject(Node,Temp.AsString,Temp);
Node.Expand(True);
tvTextComps.Select(Node);
FrameChangeHandler(nil);
end;

//------------------------------------------------------------------------------

procedure TfParsingForm.mniTX_RemoveClick(Sender: TObject);
var
  Group:    TILTextComparatorGroup;
  ToDelete: TObject;
begin
If Assigned(tvTextComps.Selected) then
  begin
    If Assigned(tvAttrComps.Selected) then
      Group := TObject(tvAttrComps.Selected.Data) as TILTextComparatorGroup
    else
      Group := TObject(tvStageElements.Selected.Data) as TILTextComparatorGroup;
    If Assigned(tvTextComps.Selected.Parent) then
      If TObject(tvTextComps.Selected.Parent.Data) is TILTextComparatorGroup then
        Group := TILTextComparatorGroup(tvTextComps.Selected.Parent.Data);
    If MessageDlg(IL_Format('Are you sure you want to delete node "%s"?',
      [tvTextComps.Selected.Text]),mtConfirmation,[mbYes,mbNo],0) = mrYes then
      begin
        ToDelete := TObject(tvTextComps.Selected.Data);
        tvTextComps.Items.Delete(tvTextComps.Selected);
        tvTextComps.OnClick(nil);
        Group.Remove(ToDelete);
        FrameChangeHandler(nil);
      end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfParsingForm.btnExtrAddClick(Sender: TObject);
begin
frmExtractionFrame.Save;
frmExtractionFrame.SetExtractSett(nil,False);
SetLength(fCurrentParsingEntry.Extraction,Length(fCurrentParsingEntry.Extraction) + 1);
// following also calls frmExtractionFrame.SetExtractSett
SetExtractionIndex(High(fCurrentParsingEntry.Extraction));
end;

//------------------------------------------------------------------------------

procedure TfParsingForm.btnExtrRemoveClick(Sender: TObject);
var
  Index:  Integer;
  i:      Integer;
begin
If Length(fCurrentParsingEntry.Extraction) > 0 then
  If MessageDlg('Are you sure you want to delete this extraction setting?',mtConfirmation,[mbYes,mbNo],0) = mrYes then
    begin
      frmExtractionFrame.Save;
      frmExtractionFrame.SetExtractSett(nil,False);
      Index := fExtractionSettIndex;
      If Length(fCurrentParsingEntry.Extraction) <= 1 then
        fExtractionSettIndex := -1
      else If fExtractionSettIndex >= High(fCurrentParsingEntry.Extraction) then
        fExtractionSettIndex := fExtractionSettIndex - 1;
      For i := Index to Pred(High(fCurrentParsingEntry.Extraction)) do
        fCurrentParsingEntry.Extraction[i] := fCurrentParsingEntry.Extraction[i + 1];
      SetLength(fCurrentParsingEntry.Extraction,Length(fCurrentParsingEntry.Extraction) - 1);
      SetExtractionIndex(fExtractionSettIndex); // will also call frmExtractionFrame.SetExtractSett
    end;
end;

//------------------------------------------------------------------------------

procedure TfParsingForm.btnExtrPrevClick(Sender: TObject);
begin
SetExtractionIndex(fExtractionSettIndex - 1);
end;

//------------------------------------------------------------------------------

procedure TfParsingForm.btnExtrNextClick(Sender: TObject);
begin
SetExtractionIndex(fExtractionSettIndex + 1);
end;

end.
