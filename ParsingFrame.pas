unit ParsingFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ExtCtrls, Menus, StdCtrls,
  InflatablesList_Types, InflatablesList;

type
  TfrmParsingFrame = class(TFrame)
    pnlMain: TPanel;
    lbStages: TListBox;
    lblStages: TLabel;
    pmnStages: TPopupMenu;
    mniSG_Add: TMenuItem;
    mniSG_Remove: TMenuItem;
    N1: TMenuItem;
    mniSG_MoveUp: TMenuItem;
    mniSG_MoveDown: TMenuItem;
    gbStage: TGroupBox;
    leStageAttributeName: TLabeledEdit;
    leStageElementName: TLabeledEdit;
    leStageAttributeValue: TLabeledEdit;
    cbStageTextFullMatch: TCheckBox;
    cbStageRecursiveSearch: TCheckBox;
    leStageText: TLabeledEdit;
    procedure lbStagesClick(Sender: TObject);
    procedure lbStagesMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);    
    procedure pmnStagesPopup(Sender: TObject);
    procedure mniSG_AddClick(Sender: TObject);
    procedure mniSG_RemoveClick(Sender: TObject);
    procedure mniSG_MoveUpClick(Sender: TObject);
    procedure mniSG_MoveDownClick(Sender: TObject);
    procedure leStageElementNameChange(Sender: TObject);
    procedure leStageAttributeNameChange(Sender: TObject);
    procedure leStageAttributeValueChange(Sender: TObject);
    procedure cbStageTextFullMatchClick(Sender: TObject);
    procedure leStageTextChange(Sender: TObject);
    procedure cbStageRecursiveSearchClick(Sender: TObject);
  private
    fInitializing:      Boolean;
    fILManager:         TILManager;
    fCurrentStagesPtr:  PILItemShopParsingStages;
    fCurrentStagePtr:   PILItemShopParsingStage;
  protected
    procedure SetStage(StagePtr: PILItemShopParsingStage; ProcessChange: Boolean);
    procedure UpdateShownStage(Index: Integer);
    procedure StageClear;
    procedure StageEnable(Enable: Boolean);
    procedure StageSave;
    procedure StageLoad;
    procedure FrameClear;
  public
    procedure SaveStages;
    procedure LoadStages;
    procedure Initialize(ILManager: TILManager);
    procedure SetStages(StagesPtr: PILItemShopParsingStages; ProcessChange: Boolean);
  end;

implementation

{$R *.dfm}

procedure TfrmParsingFrame.SetStage(StagePtr: PILItemShopParsingStage; ProcessChange: Boolean);
begin
If ProcessChange then
  begin
    If Assigned(fCurrentStagePtr) then
      StageSave;
    If Assigned(StagePtr) then
      begin
        fCurrentStagePtr := StagePtr;
        StageLoad;
      end
    else
      begin
        fCurrentStagePtr := nil;
        StageClear;
      end;
    StageEnable(Assigned(fCurrentStagePtr));
  end
else fCurrentStagePtr := StagePtr;
end;

//------------------------------------------------------------------------------

procedure TfrmParsingFrame.UpdateShownStage(Index: Integer);
begin
If Assigned(fCurrentStagePtr) then
  If (Index >= 0) and (Index < lbStages.Count) then
    lbStages.Items[Index] := fILManager.ItemShopParsingStageStr(fCurrentStagePtr^);
end;

//------------------------------------------------------------------------------

procedure TfrmParsingFrame.StageClear;
begin
leStageElementName.Text := '';
leStageAttributeName.Text := '';
leStageAttributeValue.Text := '';
cbStageTextFullMatch.Checked := False;
cbStageRecursiveSearch.Checked := False;
leStageText.Text := '';
end;

//------------------------------------------------------------------------------

procedure TfrmParsingFrame.StageEnable(Enable: Boolean);
begin
gbStage.Enabled := Enable;
leStageElementName.Enabled := Enable;
leStageAttributeName.Enabled := Enable;
leStageAttributeValue.Enabled := Enable;
cbStageTextFullMatch.Enabled := Enable;
cbStageRecursiveSearch.Enabled := Enable;
leStageText.Enabled := Enable;
end;

//------------------------------------------------------------------------------

procedure TfrmParsingFrame.StageSave;
begin
// no need to do anything
end;

//------------------------------------------------------------------------------

procedure TfrmParsingFrame.StageLoad;
begin
If Assigned(fCurrentStagePtr) then
  begin
    fInitializing := True;
    try
      leStageElementName.Text := fCurrentStagePtr^.ElementName;
      leStageAttributeName.Text := fCurrentStagePtr^.AttributeName;
      leStageAttributeValue.Text := fCurrentStagePtr^.AttributeValue;
      cbStageTextFullMatch.Checked := fCurrentStagePtr^.FullTextMatch;
      cbStageRecursiveSearch.Checked := fCurrentStagePtr^.RecursiveSearch;
      leStageText.Text := fCurrentStagePtr^.Text;
    finally
      fInitializing := False;
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmParsingFrame.FrameClear;
begin
lbStages.Clear;
fCurrentStagePtr := nil;
StageClear;
end;

//==============================================================================

procedure TfrmParsingFrame.SaveStages;
begin
// no need to do anything
end;

//------------------------------------------------------------------------------

procedure TfrmParsingFrame.LoadStages;
var
  i:  Integer;
begin
If Assigned(fCurrentStagesPtr) then
  begin
    fInitializing := True;
    try
      lbStages.Items.BeginUpdate;
      try
        lbStages.Items.Clear;
        For i := Low(fCurrentStagesPtr^) to High(fCurrentStagesPtr^) do
          lbStages.Items.Add(fILManager.ItemShopParsingStageStr(fCurrentStagesPtr^[i]));
      finally
        lbStages.Items.EndUpdate;
      end;
      If lbStages.Count > 0 then
        lbStages.ItemIndex := 0
      else
        lbStages.ItemIndex := -1;
    finally
      fInitializing := False;
    end;
    lbStages.OnClick(nil);  // all other fields are filled here
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmParsingFrame.Initialize(ILManager: TILManager);
begin
fILManager := ILManager;
mniSG_MoveUp.ShortCut := ShortCut(VK_UP,[ssCtrl]);
mniSG_MoveDown.ShortCut := ShortCut(VK_DOWN,[ssCtrl]);
end;

//------------------------------------------------------------------------------

procedure TfrmParsingFrame.SetStages(StagesPtr: PILItemShopParsingStages; ProcessChange: Boolean);
begin
If ProcessChange then
  begin
    If Assigned(fCurrentStagesPtr) then
      SaveStages;
    If Assigned(StagesPtr) then
      begin
        fCurrentStagesPtr := StagesPtr;
        LoadStages;
      end
    else
      begin
        fCurrentStagesPtr := nil;
        FrameClear;
      end;
    Visible := Assigned(fCurrentStagesPtr);
    Enabled := Assigned(fCurrentStagesPtr);
  end
else
  begin
    fCurrentStagesPtr := StagesPtr;
    If Assigned(fCurrentStagesPtr) then
      begin
        If lbStages.ItemIndex >= 0 then
          SetStage(Addr(fCurrentStagesPtr^[lbStages.ItemIndex]),False)
        else
          SetStage(nil,False);
      end
    else SetStage(nil,False);
  end;
end;

//==============================================================================

procedure TfrmParsingFrame.lbStagesClick(Sender: TObject);
begin
If lbStages.ItemIndex >= 0 then
  begin
    If Assigned(fCurrentStagesPtr) then
      SetStage(Addr(fCurrentStagesPtr^[lbStages.ItemIndex]),True)
    else
      SetStage(nil,True);
  end
else SetStage(nil,True);
end;

//------------------------------------------------------------------------------

procedure TfrmParsingFrame.lbStagesMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
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

procedure TfrmParsingFrame.pmnStagesPopup(Sender: TObject);
begin
mniSG_Add.Enabled := Assigned(fCurrentStagesPtr);
mniSG_Remove.Enabled := lbStages.ItemIndex >= 0;
mniSG_MoveUp.Enabled := lbStages.ItemIndex > 0;
mniSG_MoveDown.Enabled := (lbStages.ItemIndex >= 0) and (lbStages.ItemIndex < Pred(lbStages.Count));
end;

//------------------------------------------------------------------------------

procedure TfrmParsingFrame.mniSG_AddClick(Sender: TObject);
var
  Index:  Integer;
begin
If Assigned(fCurrentStagesPtr) then
  begin
    Index := lbStages.ItemIndex;
    SetLength(fCurrentStagesPtr^,Length(fCurrentStagesPtr^) + 1);
    lbStages.Items.Add(fILManager.ItemShopParsingStageStr(fCurrentStagesPtr^[High(fCurrentStagesPtr^)]));
    // update the list item
    If Index >= 0 then
      SetStage(Addr(fCurrentStagesPtr^[Index]),False);
    lbStages.ItemIndex := Pred(lbStages.Count);
    lbStages.OnClick(nil);
    leStageElementName.SetFocus;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmParsingFrame.mniSG_RemoveClick(Sender: TObject);
var
  Index,i:  Integer;
begin
If Assigned(fCurrentStagesPtr) and (lbStages.ItemIndex >= 0) then
  If MessageDlg(Format('Are you sure you want to remove the stage "%s"?',
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
      For i := Index to Pred(High(fCurrentStagesPtr^)) do
        fCurrentStagesPtr^[i] := fCurrentStagesPtr^[i + 1];
      SetLength(fCurrentStagesPtr^,Length(fCurrentStagesPtr^) - 1);
      If lbStages.ItemIndex >= 0 then
        SetStage(Addr(fCurrentStagesPtr^[lbStages.ItemIndex]),False);
    end;
end;

//------------------------------------------------------------------------------

procedure TfrmParsingFrame.mniSG_MoveUpClick(Sender: TObject);
var
  Index:  Integer;
  Temp:   TILItemShopParsingStage;
begin
If Assigned(fCurrentStagesPtr) and (lbStages.ItemIndex > 0) then
  begin
    Index := lbStages.ItemIndex;
    Temp := fCurrentStagesPtr^[Index];
    fCurrentStagesPtr^[Index] := fCurrentStagesPtr^[Index - 1];
    fCurrentStagesPtr^[Index - 1] := Temp;
    lbStages.Items.Exchange(Index,Index - 1);
    lbStages.ItemIndex := Index - 1;
    SetStage(Addr(fCurrentStagesPtr^[Index - 1]),False);
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmParsingFrame.mniSG_MoveDownClick(Sender: TObject);
var
  Index:  Integer;
  Temp:   TILItemShopParsingStage;
begin
If Assigned(fCurrentStagesPtr) and (lbStages.ItemIndex >= 0) and (lbStages.ItemIndex < Pred(lbStages.Count)) then
  begin
    Index := lbStages.ItemIndex;
    Temp := fCurrentStagesPtr^[Index];
    fCurrentStagesPtr^[Index] := fCurrentStagesPtr^[Index + 1];
    fCurrentStagesPtr^[Index + 1] := Temp;
    lbStages.Items.Exchange(Index,Index + 1);
    lbStages.ItemIndex := Index + 1;
    SetStage(Addr(fCurrentStagesPtr^[Index + 1]),False);
  end;
end;
 
//------------------------------------------------------------------------------

procedure TfrmParsingFrame.leStageElementNameChange(Sender: TObject);
begin
If Assigned(fCurrentStagePtr) and not fInitializing then
  begin
    fCurrentStagePtr^.ElementName := leStageElementName.Text;
    UpdateShownStage(lbStages.ItemIndex);
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmParsingFrame.leStageAttributeNameChange(Sender: TObject);
begin
If Assigned(fCurrentStagePtr) and not fInitializing then
  begin
    fCurrentStagePtr^.AttributeName := leStageAttributeName.Text;
    UpdateShownStage(lbStages.ItemIndex);
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmParsingFrame.leStageAttributeValueChange(Sender: TObject);
begin
If Assigned(fCurrentStagePtr) and not fInitializing then
  begin
    fCurrentStagePtr^.AttributeValue := leStageAttributeValue.Text;
    UpdateShownStage(lbStages.ItemIndex);
  end;
end;
 
//------------------------------------------------------------------------------

procedure TfrmParsingFrame.cbStageTextFullMatchClick(Sender: TObject);
begin
If Assigned(fCurrentStagePtr) and not fInitializing then
  begin
    fCurrentStagePtr^.FullTextMatch := cbStageTextFullMatch.Checked;
    UpdateShownStage(lbStages.ItemIndex);
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmParsingFrame.cbStageRecursiveSearchClick(Sender: TObject);
begin
If Assigned(fCurrentStagePtr) and not fInitializing then
  begin
    fCurrentStagePtr^.RecursiveSearch := cbStageRecursiveSearch.Checked;
    UpdateShownStage(lbStages.ItemIndex);
  end;
end;
 
//------------------------------------------------------------------------------

procedure TfrmParsingFrame.leStageTextChange(Sender: TObject);
begin
If Assigned(fCurrentStagePtr) and not fInitializing then
  begin
    fCurrentStagePtr^.Text := leStageText.Text;
    UpdateShownStage(lbStages.ItemIndex);
  end;
end;

end.
