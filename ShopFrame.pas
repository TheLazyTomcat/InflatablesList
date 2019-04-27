unit ShopFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ExtCtrls, StdCtrls, Spin, ComCtrls, Menus,
  ParsingFrame,
  InflatablesList_Types, InflatablesList;

type
  TfrmShopFrame = class(TFrame)
    pnlMain: TPanel;
    leShopName: TLabeledEdit;
    cbShopSelected: TCheckBox;
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
    bgParsing: TGroupBox;
    leParsingMoreThanTag: TLabeledEdit;
    lblParsingAvailExtractMethod: TLabel;
    cmbParsingAvailExtractMethod: TComboBox;
    lblParsingPriceExtractMethod: TLabel;
    cmbParsingPriceExtractMethod: TComboBox;
    tcParsingStages: TTabControl;
    frmParsingFrame: TfrmParsingFrame;    
    leLastUpdateMsg: TLabeledEdit;
    bvlSplit: TBevel;
    btnUpdate: TButton;
    btnTemplates: TButton;
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
    procedure tcParsingStagesChange(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
    procedure btnTemplatesClick(Sender: TObject);
  private
    fInitializing:        Boolean;
    fILManager:           TILManager;
    fCurrentItemShopPtr:  PILItemShop;
  protected
    procedure DoListItemChange;
    procedure DoPriceChange;
    procedure FrameClear;
    procedure FillHistoryLists(Selector: Integer);
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
  TemplatesForm;

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
leShopURL.Text := '';
leShopItemURL.Text := '';
seAvailable.Value := 0;
sePrice.Value := 0;
lvAvailHistory.Clear;
lvPriceHistory.Clear;
// parsing
leParsingMoreThanTag.Text := '';
If cmbParsingAvailExtractMethod.Items.Count > 0 then
  cmbParsingAvailExtractMethod.ItemIndex := 0
else
  cmbParsingAvailExtractMethod.ItemIndex := -1;
If cmbParsingPriceExtractMethod.Items.Count > 0 then
  cmbParsingPriceExtractMethod.ItemIndex := 0
else
  cmbParsingPriceExtractMethod.ItemIndex := -1;
// do not touch tabs
frmParsingFrame.SetStages(nil,True);
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

//==============================================================================

procedure TfrmShopFrame.SaveItemShop;
begin
If Assigned(fCurrentItemShopPtr) then
  begin
    fCurrentItemShopPtr^.Selected := cbShopSelected.Checked;
    fCurrentItemShopPtr^.Name := leShopName.Text;
    fCurrentItemShopPtr^.ShopURL := leShopURL.Text;
    fCurrentItemShopPtr^.ItemURL := leShopItemURL.Text;
    fCurrentItemShopPtr^.Available := seAvailable.Value;
    fCurrentItemShopPtr^.Price := sePrice.Value;
    // parsing
    fCurrentItemShopPtr^.ParsingSettings.MoreThanTag := leParsingMoreThanTag.Text;
    fCurrentItemShopPtr^.ParsingSettings.AvailExtrMethod :=
      TILItemShopParsAvailExtrMethod(cmbParsingAvailExtractMethod.ItemIndex);
    fCurrentItemShopPtr^.ParsingSettings.PriceExtrMethod :=
      TILItemShopParsPriceExtrMethod(cmbParsingPriceExtractMethod.ItemIndex);
    frmParsingFrame.SaveStages;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmShopFrame.LoadItemShop;
begin
If Assigned(fCurrentItemShopPtr) then
  begin
    fInitializing := True;
    try
      cbShopSelected.Checked := fCurrentItemShopPtr^.Selected;
      leShopName.Text := fCurrentItemShopPtr^.Name;
      leShopURL.Text := fCurrentItemShopPtr^.ShopURL;
      leShopItemURL.Text := fCurrentItemShopPtr^.ItemURL;
      seAvailable.Value := fCurrentItemShopPtr^.Available;
      sePrice.Value := fCurrentItemShopPtr^.Price;
      FillHistoryLists(0);
      FillHistoryLists(1);
      // parsing
      leParsingMoreThanTag.Text := fCurrentItemShopPtr^.ParsingSettings.MoreThanTag;
      cmbParsingAvailExtractMethod.ItemIndex := Ord(fCurrentItemShopPtr^.ParsingSettings.AvailExtrMethod);
      cmbParsingPriceExtractMethod.ItemIndex := Ord(fCurrentItemShopPtr^.ParsingSettings.PriceExtrMethod);
      case tcParsingStages.TabIndex of
        0:  frmParsingFrame.SetStages(Addr(fCurrentItemShopPtr^.ParsingSettings.AvailStages),True);
        1:  frmParsingFrame.SetStages(Addr(fCurrentItemShopPtr^.ParsingSettings.PriceStages),True);
      else
        frmParsingFrame.SetStages(nil,True);
      end;
      leLastUpdateMsg.Text := fCurrentItemShopPtr^.LastUpdateMsg;
    finally
      fInitializing := False;
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmShopFrame.Initialize(ILManager: TILManager);
var
  i:  Integer;
begin
fILManager := ILManager;
// fill drop boxes
cmbParsingAvailExtractMethod.Items.BeginUpdate;
try
  cmbParsingAvailExtractMethod.Clear;
  For i := Ord(Low(TILItemShopParsAvailExtrMethod)) to Ord(High(TILItemShopParsAvailExtrMethod)) do
    cmbParsingAvailExtractMethod.Items.Add(
      fILManager.DataProvider.GetItemShopParsAvailExtrMethodString(TILItemShopParsAvailExtrMethod(i)));
finally
  cmbParsingAvailExtractMethod.Items.EndUpdate;
end;
cmbParsingPriceExtractMethod.Items.BeginUpdate;
try
  cmbParsingPriceExtractMethod.Clear;
  For i := Ord(Low(TILItemShopParsPriceExtrMethod)) to Ord(High(TILItemShopParsPriceExtrMethod)) do
    cmbParsingPriceExtractMethod.Items.Add(
      fILManager.DataProvider.GetItemShopParsPriceExtrMethodString(TILItemShopParsPriceExtrMethod(i)));
finally
  cmbParsingPriceExtractMethod.Items.EndUpdate;
end; 
If cmbParsingAvailExtractMethod.Items.Count > 0 then
  cmbParsingAvailExtractMethod.ItemIndex := 0;
If cmbParsingPriceExtractMethod.Items.Count > 0 then
  cmbParsingPriceExtractMethod.ItemIndex := 0;
frmParsingFrame.Initialize(fILManager);
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

procedure TfrmShopFrame.tcParsingStagesChange(Sender: TObject);
begin
If Assigned(fCurrentItemShopPtr) then
  begin
    case tcParsingStages.TabIndex of
      0:  frmParsingFrame.SetStages(Addr(fCurrentItemShopPtr^.ParsingSettings.AvailStages),True);
      1:  frmParsingFrame.SetStages(Addr(fCurrentItemShopPtr^.ParsingSettings.PriceStages),True);
    end;
  end
else frmParsingFrame.SetStages(nil,True);
end;

//------------------------------------------------------------------------------

procedure TfrmShopFrame.btnUpdateClick(Sender: TObject);
var
  Result: Boolean;
begin
If Assigned(fCurrentItemShopPtr) then
  begin
    SaveItemShop;
    Screen.Cursor := crHourGlass;
    try
      Result := fILManager.ItemShopUpdate(fCurrentItemShopPtr^);
    finally
      Screen.Cursor := crDefault;
    end;
    seAvailable.Value := fCurrentItemShopPtr^.Available;
    sePrice.Value := fCurrentItemShopPtr^.Price;
    leLastUpdateMsg.Text := fCurrentItemShopPtr^.LastUpdateMsg;
    If Result then
      MessageDlg('Update finished successfuly.',mtInformation,[mbOK],0)
    else
      MessageDlg('Update failed - see last update message for details.',mtInformation,[mbOK],0);
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmShopFrame.btnTemplatesClick(Sender: TObject);
begin
If Assigned(fCurrentItemShopPtr) then
  begin
    SaveItemShop;
    fTemplatesForm.ShowTemplates(fCurrentItemShopPtr,False);
    LoadItemShop;
    DoListItemChange;
    leShopItemURL.SetFocus;
  end;
end;

end.
