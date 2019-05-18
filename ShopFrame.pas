unit ShopFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ExtCtrls, StdCtrls, Spin, ComCtrls, Menus,
  InflatablesList_Types, InflatablesList;

type
  TfrmShopFrame = class(TFrame)
    pnlMain: TPanel;
    leShopName: TLabeledEdit;
    cbShopSelected: TCheckBox;
    cbShopUntracked: TCheckBox;
    cbShopAltDownMethod: TCheckBox;    
    leShopURL: TLabeledEdit;
    btnShopURLOpen: TButton;
    leShopItemURL: TLabeledEdit;
    btnShopItemURLOpen: TButton;
    lblAvailable: TLabel;
    seAvailable: TSpinEdit;
    btnAvailToHistory: TButton;
    lblAvailHistory: TLabel;
    lvAvailHistory: TListView;
    lblPrice: TLabel;
    sePrice: TSpinEdit;
    btnPriceToHistory: TButton;
    lblPriceHistory: TLabel;
    lvPriceHistory: TListView;
    pmnHistory: TPopupMenu;
    mniHI_Remove: TMenuItem;
    mniHI_Clear: TMenuItem;    
    leLastUpdateMsg: TLabeledEdit;
    bvlSplit: TBevel;
    btnUpdate: TButton;
    btnTemplates: TButton;
    lblNotes: TLabel;
    meNotes: TMemo;
    gbParsing: TGroupBox;
    leParsVar_1: TLabeledEdit;
    leParsVar_2: TLabeledEdit;
    leParsVar_3: TLabeledEdit;
    leParsVar_4: TLabeledEdit;
    leParsVar_5: TLabeledEdit;
    leParsVar_6: TLabeledEdit;
    leParsVar_7: TLabeledEdit;
    leParsVar_8: TLabeledEdit;
    bvlVarsSep: TBevel;
    lblParsTemplRef: TLabel;
    cmbParsTemplRef: TComboBox;
    btnParsCopyToLocal: TButton;
    btnParsAvail: TButton;
    btnParsPrice: TButton;
    bvlParsSep: TBevel;
    cbParsDisableErrs: TCheckBox;
    procedure leShopNameChange(Sender: TObject);
    procedure cbShopSelectedClick(Sender: TObject);
    procedure btnShopURLOpenClick(Sender: TObject);
    procedure leShopItemURLChange(Sender: TObject);
    procedure btnShopItemURLOpenClick(Sender: TObject);
    procedure seAvailableChange(Sender: TObject);
    procedure btnAvailToHistoryClick(Sender: TObject);
    procedure sePriceChange(Sender: TObject);
    procedure btnPriceToHistoryClick(Sender: TObject);
    procedure pmnHistoryPopup(Sender: TObject);
    procedure mniHI_RemoveClick(Sender: TObject);
    procedure mniHI_ClearClick(Sender: TObject);
    procedure meNotesDblClick(Sender: TObject);
    procedure meNotesKeyPress(Sender: TObject; var Key: Char);
    procedure btnParsCopyToLocalClick(Sender: TObject);    
    procedure btnParsAvailClick(Sender: TObject);
    procedure btnParsPriceClick(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
    procedure btnTemplatesClick(Sender: TObject);
    procedure cbShopUntrackedClick(Sender: TObject);
  private
    fInitializing:        Boolean;
    fILManager:           TILManager;
    fCurrentItemShopPtr:  PILItemShop;
  protected
    procedure DoListItemChange;
    procedure DoPriceChange;
    procedure FrameClear;
    procedure FillHistoryLists(Selector: Integer);
    procedure FillTemplatesList;
  public
    OnListUpdate:     TNotifyEvent;
    OnPriceChange:    TNotifyEvent;
    OnClearSelected:  TNotifyEvent;
    procedure SaveItemShop;
    procedure LoadItemShop;
    procedure Initialize(ILManager: TILManager);
    procedure SetItemShop(ItemShopPtr: PILItemShop; ProcessChange: Boolean);
  end;

implementation

{$R *.dfm}

uses
  ShellAPI,
  InflatablesList_HTML_ElementFinder,
  TemplatesForm, TextEditForm, ParsingForm;

procedure TfrmShopFrame.DoListItemChange;
begin
If Assigned(OnListUpdate) then
  OnListUpdate(Self);
end;

//------------------------------------------------------------------------------

procedure TfrmShopFrame.DoPriceChange;
begin
If Assigned(OnPriceChange) then
  OnPriceChange(Self);
end;

//------------------------------------------------------------------------------

procedure TfrmShopFrame.FrameClear;
begin
leShopName.Text := '';
cbShopSelected.Checked := False;
cbShopUntracked.Checked := False;
cbShopAltDownMethod.Checked := False;
leShopURL.Text := '';
leShopItemURL.Text := '';
seAvailable.Value := 0;
sePrice.Value := 0;
lvAvailHistory.Clear;
lvPriceHistory.Clear;
meNotes.Text := '';
// parsing
leParsVar_1.Text := '';
leParsVar_2.Text := '';
leParsVar_3.Text := '';
leParsVar_4.Text := '';
leParsVar_5.Text := '';
leParsVar_6.Text := '';
leParsVar_7.Text := '';
leParsVar_8.Text := '';
If cmbParsTemplRef.Items.Count > 0 then
  cmbParsTemplRef.ItemIndex := 0
else
  cmbParsTemplRef.ItemIndex := -1;
cbParsDisableErrs.Checked := False;
leLastUpdateMsg.Text := '';
end;

//------------------------------------------------------------------------------

procedure TfrmShopFrame.FillHistoryLists(Selector: Integer);
var
  i:  Integer;
begin
If Assigned(fCurrentItemShopPtr) then
  begin
    If Selector = 0 then
      begin
        // avail
        lvAvailHistory.Items.BeginUpdate;
        try
          lvAvailHistory.Items.Clear;
          For i := High(fCurrentItemShopPtr^.AvailHistory) downto Low(fCurrentItemShopPtr^.AvailHistory) do
            with lvAvailHistory.Items.Add do
              begin
                Caption := FormatDateTime('yyyy-mm-dd hh:nn',fCurrentItemShopPtr^.AvailHistory[i].Time);
                If fCurrentItemShopPtr^.AvailHistory[i].Value > 0 then
                  SubItems.Add(Format('%d',[fCurrentItemShopPtr^.AvailHistory[i].Value]))
                else If fCurrentItemShopPtr^.AvailHistory[i].Value < 0 then
                  SubItems.Add(Format('> %d',[Abs(fCurrentItemShopPtr^.AvailHistory[i].Value)]))
                else
                  SubItems.Add('-');
              end;
        finally
          lvAvailHistory.Items.EndUpdate;
        end;
      end
    else
      begin
        // price
        lvPriceHistory.Items.BeginUpdate;
        try
          lvPriceHistory.Items.Clear;
          For i := High(fCurrentItemShopPtr^.PriceHistory) downto Low(fCurrentItemShopPtr^.PriceHistory) do
            with lvPriceHistory.Items.Add do
              begin
                Caption := FormatDateTime('yyyy-mm-dd hh:nn',fCurrentItemShopPtr^.PriceHistory[i].Time);
                If fCurrentItemShopPtr^.PriceHistory[i].Value > 0 then
                  SubItems.Add(Format('%d Kè',[fCurrentItemShopPtr^.PriceHistory[i].Value]))
                else
                  SubItems.Add('-');
              end;
        finally
          lvPriceHistory.Items.EndUpdate;
        end;
      end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmShopFrame.FillTemplatesList;
var
  i:  Integer;
begin
cmbParsTemplRef.Items.BeginUpdate;
try
  cmbParsTemplRef.Clear;
  cmbParsTemplRef.Items.Add('<none - use local objects>');
  For i := 0 to Pred(fILManager.ShopTemplateCount) do
    cmbParsTemplRef.Items.Add(fILManager.ShopTemplates[i].Name);
finally
  cmbParsTemplRef.Items.EndUpdate;
end;
If cmbParsTemplRef.Items.Count > 0 then
  cmbParsTemplRef.ItemIndex := 0;
end;

//==============================================================================

procedure TfrmShopFrame.SaveItemShop;
begin
If Assigned(fCurrentItemShopPtr) then
  begin
    fCurrentItemShopPtr^.Selected := cbShopSelected.Checked;
    fCurrentItemShopPtr^.Untracked := cbShopUntracked.Checked;
    fCurrentItemShopPtr^.AltDownMethod := cbShopAltDownMethod.Checked;
    fCurrentItemShopPtr^.Name := leShopName.Text;
    fCurrentItemShopPtr^.ShopURL := leShopURL.Text;
    fCurrentItemShopPtr^.ItemURL := leShopItemURL.Text;
    fCurrentItemShopPtr^.Available := seAvailable.Value;
    fCurrentItemShopPtr^.Price := sePrice.Value;
    fCurrentItemShopPtr^.Notes := meNotes.Text;
    // parsing
    fCurrentItemShopPtr^.ParsingSettings.Variables.Vars[0] := leParsVar_1.Text;
    fCurrentItemShopPtr^.ParsingSettings.Variables.Vars[1] := leParsVar_2.Text;
    fCurrentItemShopPtr^.ParsingSettings.Variables.Vars[2] := leParsVar_3.Text;
    fCurrentItemShopPtr^.ParsingSettings.Variables.Vars[3] := leParsVar_4.Text;
    fCurrentItemShopPtr^.ParsingSettings.Variables.Vars[4] := leParsVar_5.Text;
    fCurrentItemShopPtr^.ParsingSettings.Variables.Vars[5] := leParsVar_6.Text;
    fCurrentItemShopPtr^.ParsingSettings.Variables.Vars[6] := leParsVar_7.Text;
    fCurrentItemShopPtr^.ParsingSettings.Variables.Vars[7] := leParsVar_8.Text;
    If (cmbParsTemplRef.ItemIndex > 0) and (cmbParsTemplRef.ItemIndex <= fILManager.ShopTemplateCount) then
      fCurrentItemShopPtr^.ParsingSettings.TemplateRef := fILManager.ShopTemplates[cmbParsTemplRef.ItemIndex - 1].Name
    else
      fCurrentItemShopPtr^.ParsingSettings.TemplateRef := '';
    fCurrentItemShopPtr^.ParsingSettings.DisableParsErrs := cbParsDisableErrs.Checked;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmShopFrame.LoadItemShop;
var
  Index:  Integer;
begin
If Assigned(fCurrentItemShopPtr) then
  begin
    fInitializing := True;
    try
      cbShopSelected.Checked := fCurrentItemShopPtr^.Selected;
      cbShopUntracked.Checked := fCurrentItemShopPtr^.Untracked;
      cbShopAltDownMethod.Checked := fCurrentItemShopPtr^.AltDownMethod;
      leShopName.Text := fCurrentItemShopPtr^.Name;
      leShopURL.Text := fCurrentItemShopPtr^.ShopURL;
      leShopItemURL.Text := fCurrentItemShopPtr^.ItemURL;
      seAvailable.Value := fCurrentItemShopPtr^.Available;
      sePrice.Value := fCurrentItemShopPtr^.Price;
      FillHistoryLists(0);
      FillHistoryLists(1);
      meNotes.Text := fCurrentItemShopPtr^.Notes;
      // parsing
      leParsVar_1.Text := fCurrentItemShopPtr^.ParsingSettings.Variables.Vars[0];
      leParsVar_2.Text := fCurrentItemShopPtr^.ParsingSettings.Variables.Vars[1];
      leParsVar_3.Text := fCurrentItemShopPtr^.ParsingSettings.Variables.Vars[2];
      leParsVar_4.Text := fCurrentItemShopPtr^.ParsingSettings.Variables.Vars[3];
      leParsVar_5.Text := fCurrentItemShopPtr^.ParsingSettings.Variables.Vars[4];
      leParsVar_6.Text := fCurrentItemShopPtr^.ParsingSettings.Variables.Vars[5];
      leParsVar_7.Text := fCurrentItemShopPtr^.ParsingSettings.Variables.Vars[6];
      leParsVar_8.Text := fCurrentItemShopPtr^.ParsingSettings.Variables.Vars[7];
      Index := fILManager.ShopTemplateIndexOf(fCurrentItemShopPtr^.ParsingSettings.TemplateRef);
      If Index >= 0 then
        cmbParsTemplRef.ItemIndex := Index + 1
      else
        cmbParsTemplRef.ItemIndex := 0;
      cbParsDisableErrs.Checked := fCurrentItemShopPtr^.ParsingSettings.DisableParsErrs;
      leLastUpdateMsg.Text := fCurrentItemShopPtr^.LastUpdateMsg;
    finally
      fInitializing := False;
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmShopFrame.Initialize(ILManager: TILManager);
begin
fILManager := ILManager;
FillTemplatesList;
end;

//------------------------------------------------------------------------------

procedure TfrmShopFrame.SetItemShop(ItemShopPtr: PILItemShop; ProcessChange: Boolean);
begin
If ProcessChange then
  begin
    If Assigned(fCurrentItemShopPtr) then
      SaveItemShop;
    If Assigned(ItemShopPtr) then
      begin
        fCurrentItemShopPtr := ItemShopPtr;
        LoadItemShop;
      end
    else
      begin
        fCurrentItemShopPtr := nil;
        FrameClear;
      end;
    Visible := Assigned(fCurrentItemShopPtr);
    Enabled := Assigned(fCurrentItemShopPtr);
  end
else fCurrentItemShopPtr := ItemShopPtr;
end;

//==============================================================================

procedure TfrmShopFrame.leShopNameChange(Sender: TObject);
begin
If not fInitializing then
  begin
    If Assigned(fCurrentItemShopPtr) then
      fCurrentItemShopPtr^.Name := leShopName.Text;
    DoListItemChange;
  end
end;

//------------------------------------------------------------------------------

procedure TfrmShopFrame.cbShopSelectedClick(Sender: TObject);
begin
If not fInitializing then
  begin
    If Assigned(fCurrentItemShopPtr) then
      begin
        If Assigned(OnClearSelected) then
          OnClearSelected(Self);
        fCurrentItemShopPtr^.Selected := cbShopSelected.Checked;
      end;
    DoListItemChange;
    DoPriceChange;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmShopFrame.cbShopUntrackedClick(Sender: TObject);
begin
If not fInitializing then
  begin
    If Assigned(fCurrentItemShopPtr) then
      fCurrentItemShopPtr^.Untracked := cbShopUntracked.Checked;
    DoListItemChange;
  end
end;

//------------------------------------------------------------------------------

procedure TfrmShopFrame.btnShopURLOpenClick(Sender: TObject);
begin
If Assigned(fCurrentItemShopPtr) then
  begin
    fCurrentItemShopPtr^.ShopURL := leShopURL.Text;
    If Length(fCurrentItemShopPtr^.ShopURL) > 0 then
      ShellExecute(Handle,'open',PChar(fCurrentItemShopPtr^.ShopURL),nil,nil,SW_SHOWNORMAL);
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmShopFrame.leShopItemURLChange(Sender: TObject);
begin
If not fInitializing then
  begin
    If Assigned(fCurrentItemShopPtr) then
      fCurrentItemShopPtr^.ItemURL := leShopItemURL.Text;
    DoListItemChange;
  end
end;

//------------------------------------------------------------------------------

procedure TfrmShopFrame.btnShopItemURLOpenClick(Sender: TObject);
begin
If Assigned(fCurrentItemShopPtr) then
  If Length(fCurrentItemShopPtr^.ItemURL) > 0 then
    ShellExecute(Handle,'open',PChar(fCurrentItemShopPtr^.ItemURL),nil,nil,SW_SHOWNORMAL);
end;
 
//------------------------------------------------------------------------------

procedure TfrmShopFrame.seAvailableChange(Sender: TObject);
begin
If not fInitializing then
  begin
    If Assigned(fCurrentItemShopPtr) then
      fCurrentItemShopPtr^.Available := seAvailable.Value;
    DoListItemChange;
    DoPriceChange;
  end
end;

//------------------------------------------------------------------------------

procedure TfrmShopFrame.btnAvailToHistoryClick(Sender: TObject);
begin
If Assigned(fCurrentItemShopPtr) then
  begin
    SaveItemShop;
    SetLength(fCurrentItemShopPtr^.AvailHistory,Length(fCurrentItemShopPtr^.AvailHistory) + 1);
    fCurrentItemShopPtr^.AvailHistory[High(fCurrentItemShopPtr^.AvailHistory)].Value :=
      fCurrentItemShopPtr^.Available;
    fCurrentItemShopPtr^.AvailHistory[High(fCurrentItemShopPtr^.AvailHistory)].Time := Now;
    FillHistoryLists(0);
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmShopFrame.sePriceChange(Sender: TObject);
begin
If not fInitializing then
  begin
    If Assigned(fCurrentItemShopPtr) then
      fCurrentItemShopPtr^.Price := sePrice.Value;
    DoListItemChange;
    DoPriceChange;
  end
end;

//------------------------------------------------------------------------------

procedure TfrmShopFrame.btnPriceToHistoryClick(Sender: TObject);
begin
If Assigned(fCurrentItemShopPtr) then
  begin
    SaveItemShop;
    SetLength(fCurrentItemShopPtr^.PriceHistory,Length(fCurrentItemShopPtr^.PriceHistory) + 1);
    fCurrentItemShopPtr^.PriceHistory[High(fCurrentItemShopPtr^.PriceHistory)].Value :=
      fCurrentItemShopPtr^.Price;
    fCurrentItemShopPtr^.PriceHistory[High(fCurrentItemShopPtr^.PriceHistory)].Time := Now;
    FillHistoryLists(1);
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmShopFrame.pmnHistoryPopup(Sender: TObject);
begin
mniHI_Remove.Enabled := False;
If Sender is TPopupMenu then
  If TPopupMenu(Sender).PopupComponent is TListView then
    begin
      mniHI_Remove.Enabled := TListView(TPopupMenu(Sender).PopupComponent).ItemIndex >= 0;
      mniHI_Clear.Enabled := TListView(TPopupMenu(Sender).PopupComponent).Items.Count > 0;
    end;
end;

//------------------------------------------------------------------------------

procedure TfrmShopFrame.mniHI_RemoveClick(Sender: TObject);
var
  Index,i:  Integer;
  Temp:     TListView;
begin
If Assigned(fCurrentItemShopPtr) and (Sender is TMenuItem) then
  If TPopupMenu(TMenuItem(Sender).GetParentMenu).PopupComponent is TListView then
    begin
      Temp := TListView(TPopupMenu(TMenuItem(Sender).GetParentMenu).PopupComponent);
      If Temp = lvAvailHistory then
        begin
          If Temp.ItemIndex >= 0 then
            begin
              Index := Pred(Temp.Items.Count) - Temp.ItemIndex;
              For i := Index to Pred(High(fCurrentItemShopPtr^.AvailHistory)) do
                fCurrentItemShopPtr^.AvailHistory[i] := fCurrentItemShopPtr^.AvailHistory[i + 1];
              SetLength(fCurrentItemShopPtr^.AvailHistory,Length(fCurrentItemShopPtr^.AvailHistory) - 1);
              FillHistoryLists(0);
            end;
        end
      else If Temp = lvPriceHistory then
        begin
          If Temp.ItemIndex >= 0 then
            begin
              Index := Pred(Temp.Items.Count) - Temp.ItemIndex;
              For i := Index to Pred(High(fCurrentItemShopPtr^.PriceHistory)) do
                fCurrentItemShopPtr^.PriceHistory[i] := fCurrentItemShopPtr^.PriceHistory[i + 1];
              SetLength(fCurrentItemShopPtr^.PriceHistory,Length(fCurrentItemShopPtr^.PriceHistory) - 1);
              FillHistoryLists(1);
            end;
        end;
    end;
end;

//------------------------------------------------------------------------------

procedure TfrmShopFrame.mniHI_ClearClick(Sender: TObject);
var
  Temp: TListView;
begin
If Assigned(fCurrentItemShopPtr) and (Sender is TMenuItem) then
  If TPopupMenu(TMenuItem(Sender).GetParentMenu).PopupComponent is TListView then
    begin
      Temp := TListView(TPopupMenu(TMenuItem(Sender).GetParentMenu).PopupComponent);
      If Temp.Items.Count > 0 then
        If MessageDlg('Are you sure you want to clear the entire history?',mtConfirmation,[mbYes,mbNo],0) = mrYes then
          begin
            If Temp = lvAvailHistory then
              begin
                SetLength(fCurrentItemShopPtr^.AvailHistory,0);
                FillHistoryLists(0);
              end
            else If Temp = lvPriceHistory then
              begin
                SetLength(fCurrentItemShopPtr^.PriceHistory,0);
                FillHistoryLists(1);
              end;
          end;
    end;
end;

//------------------------------------------------------------------------------

procedure TfrmShopFrame.meNotesDblClick(Sender: TObject);
var
  Temp: String;
begin
If Assigned(fCurrentItemShopPtr) then
  begin
    Temp := meNotes.Text;
    fTextEditForm.ShowTextEditor('Edit item notes',Temp,False);
    meNotes.Text := Temp;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmShopFrame.meNotesKeyPress(Sender: TObject; var Key: Char);
begin
If Key = ^A then
  begin
    meNotes.SelectAll;
    Key := #0;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmShopFrame.btnParsCopyToLocalClick(Sender: TObject);
begin
If Assigned(fCurrentItemShopPtr) then
  If MessageDlg('Are you sure you want to replace existing finder objects with the ones from selected template?',
    mtConfirmation,[mbYes,mbNo],0) = mrYes then
    with fILManager.ShopTemplates[cmbParsTemplRef.ItemIndex - 1].ShopData.ParsingSettings do
      begin
        fCurrentItemShopPtr^.ParsingSettings.Available.Extraction := Available.Extraction;
        fCurrentItemShopPtr^.ParsingSettings.Price.Extraction := Price.Extraction;
        SetLength(fCurrentItemShopPtr^.ParsingSettings.Available.Extraction,
          Length(fCurrentItemShopPtr^.ParsingSettings.Available.Extraction));
        SetLength(fCurrentItemShopPtr^.ParsingSettings.Price.Extraction,
          Length(fCurrentItemShopPtr^.ParsingSettings.Price.Extraction));
        FreeAndNil(fCurrentItemShopPtr^.ParsingSettings.Available.Finder);
        FreeAndNil(fCurrentItemShopPtr^.ParsingSettings.Price.Finder);
        fCurrentItemShopPtr^.ParsingSettings.Available.Finder :=
          TILElementFinder.CreateAsCopy(TILElementFinder(Available.Finder));
        fCurrentItemShopPtr^.ParsingSettings.Price.Finder :=
          TILElementFinder.CreateAsCopy(TILElementFinder(Price.Finder));
      end;
end;

//------------------------------------------------------------------------------

procedure TfrmShopFrame.btnParsAvailClick(Sender: TObject);
begin
If Assigned(fCurrentItemShopPtr) then
  fParsingForm.ShowParsingSettings('Available count parsing settings',
    Addr(fCurrentItemShopPtr^.ParsingSettings.Available));
end;

//------------------------------------------------------------------------------

procedure TfrmShopFrame.btnParsPriceClick(Sender: TObject);
begin
If Assigned(fCurrentItemShopPtr) then
  fParsingForm.ShowParsingSettings('Price parsing settings',
    Addr(fCurrentItemShopPtr^.ParsingSettings.Price));
end;

//------------------------------------------------------------------------------

procedure TfrmShopFrame.btnUpdateClick(Sender: TObject);
var
  Temp:   TILItemShop;
  Result: Boolean;
begin
If Assigned(fCurrentItemShopPtr) then
  begin
    SaveItemShop;
    Screen.Cursor := crHourGlass;
    try
      fILManager.ItemShopCopyForUpdate(fCurrentItemShopPtr^,Temp);
      try
        Result := fILManager.ItemShopUpdate(Temp);
        // retrieve results
        fCurrentItemShopPtr^.Available := Temp.Available;
        fCurrentItemShopPtr^.Price := Temp.Price;
        fCurrentItemShopPtr^.LastUpdateRes := Temp.LastUpdateRes;
        fCurrentItemShopPtr^.LastUpdateMsg := Temp.LastUpdateMsg;
      finally
        fILManager.ItemShopFinalize(Temp);
      end;
    finally
      Screen.Cursor := crDefault;
    end;
    If Result then
      MessageDlg('Update finished successfuly.',mtInformation,[mbOK],0)
    else
      MessageDlg('Update failed - see last update message for details.',mtInformation,[mbOK],0);
    LoadItemShop;
    DoListItemChange;
    DoPriceChange;    
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmShopFrame.btnTemplatesClick(Sender: TObject);
begin
If Assigned(fCurrentItemShopPtr) then
  begin
    SaveItemShop;
    fTemplatesForm.ShowTemplates(fCurrentItemShopPtr,False);
    // in case a template was deleted or added (must be before load, so proper item is selected]
    FillTemplatesList;
    LoadItemShop;
    DoListItemChange;
    leShopItemURL.SetFocus;
  end;
end;


end.
