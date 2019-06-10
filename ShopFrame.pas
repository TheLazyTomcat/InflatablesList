unit ShopFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ExtCtrls, StdCtrls, Spin, ComCtrls, Menus,
  IL_Types, IL_ItemShop, IL_Manager;

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
    lblNotesEdit: TLabel;
    btnPredefNotes: TButton;
    pmnPredefNotes: TPopupMenu;        
    gbParsing: TGroupBox;
    leParsVar_0: TLabeledEdit;
    leParsVar_1: TLabeledEdit;
    leParsVar_2: TLabeledEdit;
    leParsVar_3: TLabeledEdit;
    leParsVar_4: TLabeledEdit;
    leParsVar_5: TLabeledEdit;
    leParsVar_6: TLabeledEdit;
    leParsVar_7: TLabeledEdit;
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
    procedure meNotesKeyPress(Sender: TObject; var Key: Char);
    procedure lblNotesEditClick(Sender: TObject);
    procedure lblNotesEditMouseEnter(Sender: TObject);
    procedure lblNotesEditMouseLeave(Sender: TObject);
    procedure btnPredefNotesClick(Sender: TObject);
    procedure mniPredefNotesClick(Sender: TObject);
    procedure btnParsCopyToLocalClick(Sender: TObject);
    procedure btnParsAvailClick(Sender: TObject);
    procedure btnParsPriceClick(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
    procedure btnTemplatesClick(Sender: TObject);
    procedure cbShopUntrackedClick(Sender: TObject);
  private
    fInitializing:    Boolean;
    fILManager:       TILManager;
    fCurrentItemShop: TILItemShop;
  protected
    procedure FrameClear;
    procedure FillTemplatesList;
    procedure CreatePredefNotesMenu;
  public
    OnTemplatesChange:  TNotifyEvent;
    procedure SaveItemShop;
    procedure LoadItemShop;
    procedure UpdateAvailHistory;
    procedure UpdatePriceHistory;
    procedure Initialize(ILManager: TILManager);
    procedure SetItemShop(ItemShop: TILItemShop; ProcessChange: Boolean);
  end;

implementation

{$R *.dfm}

uses
  IL_Utils,
  InflatablesList_HTML_ElementFinder,
  TextEditForm, TemplatesForm;

const
  IL_SHOP_PREDEFNOTES: array[0..3] of String = (
    'nelze vybrat variantu',
    'konkrétní typ není k dispozici',
    'dostupnost varianty je nejistá',
    'pravdìpodonì nelze vybar variantu');

//==============================================================================

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
leParsVar_0.Text := '';
leParsVar_1.Text := '';
leParsVar_2.Text := '';
leParsVar_3.Text := '';
leParsVar_4.Text := '';
leParsVar_5.Text := '';
leParsVar_6.Text := '';
leParsVar_7.Text := '';
If cmbParsTemplRef.Items.Count > 0 then
  cmbParsTemplRef.ItemIndex := 0
else
  cmbParsTemplRef.ItemIndex := -1;
cbParsDisableErrs.Checked := False;
leLastUpdateMsg.Text := '';
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

//------------------------------------------------------------------------------

procedure TfrmShopFrame.CreatePredefNotesMenu;
var
  i:    Integer;
  Temp: TMenuItem;
begin
pmnPredefNotes.Items.Clear;
For i := Low(IL_SHOP_PREDEFNOTES) to High(IL_SHOP_PREDEFNOTES) do
  begin
    Temp := TMenuItem.Create(Self);
    Temp.Name := Format('mniPN_Item%d',[i]);
    Temp.Caption := IL_SHOP_PREDEFNOTES[i];
    Temp.Tag := i;
    Temp.OnClick := self.mniPredefNotesClick;
    pmnPredefNotes.Items.Add(Temp);
  end;
end;

//==============================================================================

procedure TfrmShopFrame.SaveItemShop;
begin
If Assigned(fCurrentItemShop) then
  begin
    fCurrentItemShop.BeginListUpdate;
    try
      fCurrentItemShop.Selected := cbShopSelected.Checked;
      fCurrentItemShop.Untracked := cbShopUntracked.Checked;
      fCurrentItemShop.AltDownMethod := cbShopAltDownMethod.Checked;
      fCurrentItemShop.Name := leShopName.Text;
      fCurrentItemShop.ShopURL := leShopURL.Text;
      fCurrentItemShop.ItemURL := leShopItemURL.Text;
      fCurrentItemShop.Available := seAvailable.Value;
      fCurrentItemShop.Price := sePrice.Value;
      fCurrentItemShop.Notes := meNotes.Text;
      // parsing
      fCurrentItemShop.ParsingSettings.Variables[0] := leParsVar_0.Text;
      fCurrentItemShop.ParsingSettings.Variables[1] := leParsVar_1.Text;
      fCurrentItemShop.ParsingSettings.Variables[2] := leParsVar_2.Text;
      fCurrentItemShop.ParsingSettings.Variables[3] := leParsVar_3.Text;
      fCurrentItemShop.ParsingSettings.Variables[4] := leParsVar_4.Text;
      fCurrentItemShop.ParsingSettings.Variables[5] := leParsVar_5.Text;
      fCurrentItemShop.ParsingSettings.Variables[6] := leParsVar_6.Text;
      fCurrentItemShop.ParsingSettings.Variables[7] := leParsVar_7.Text;
      If (cmbParsTemplRef.ItemIndex > 0) and (cmbParsTemplRef.ItemIndex <= fILManager.ShopTemplateCount) then
        fCurrentItemShop.ParsingSettings.TemplateReference := fILManager.ShopTemplates[cmbParsTemplRef.ItemIndex - 1].Name
      else
        fCurrentItemShop.ParsingSettings.TemplateReference := '';
      fCurrentItemShop.ParsingSettings.DisableParsingErrors := cbParsDisableErrs.Checked;
    finally
      fCurrentItemShop.EndListUpdate;
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmShopFrame.LoadItemShop;
var
  Index:  Integer;
begin
If Assigned(fCurrentItemShop) then
  begin
    fInitializing := True;
    try
      cbShopSelected.Checked := fCurrentItemShop.Selected;
      cbShopUntracked.Checked := fCurrentItemShop.Untracked;
      cbShopAltDownMethod.Checked := fCurrentItemShop.AltDownMethod;
      leShopName.Text := fCurrentItemShop.Name;
      leShopURL.Text := fCurrentItemShop.ShopURL;
      leShopItemURL.Text := fCurrentItemShop.ItemURL;
      seAvailable.Value := fCurrentItemShop.Available;
      sePrice.Value := fCurrentItemShop.Price;
      UpdateAvailHistory;
      UpdatePriceHistory;
      meNotes.Text := fCurrentItemShop.Notes;
      // parsing
      leParsVar_0.Text := fCurrentItemShop.ParsingSettings.Variables[0];
      leParsVar_1.Text := fCurrentItemShop.ParsingSettings.Variables[1];
      leParsVar_2.Text := fCurrentItemShop.ParsingSettings.Variables[2];
      leParsVar_3.Text := fCurrentItemShop.ParsingSettings.Variables[3];
      leParsVar_4.Text := fCurrentItemShop.ParsingSettings.Variables[4];
      leParsVar_5.Text := fCurrentItemShop.ParsingSettings.Variables[5];
      leParsVar_6.Text := fCurrentItemShop.ParsingSettings.Variables[6];
      leParsVar_7.Text := fCurrentItemShop.ParsingSettings.Variables[7];
      Index := fILManager.ShopTemplateIndexOf(fCurrentItemShop.ParsingSettings.TemplateReference);
      If Index >= 0 then
        cmbParsTemplRef.ItemIndex := Index + 1  // first (0) is noref
      else
        cmbParsTemplRef.ItemIndex := 0;
      cbParsDisableErrs.Checked := fCurrentItemShop.ParsingSettings.DisableParsingErrors;
      leLastUpdateMsg.Text := fCurrentItemShop.LastUpdateMsg;
    finally
      fInitializing := False;
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmShopFrame.UpdateAvailHistory;
var
  i:  Integer;
begin
If Assigned(fCurrentItemShop) then
  begin
    lvAvailHistory.Items.BeginUpdate;
    try
      // set proper item count
      If lvAvailHistory.Items.Count > fCurrentItemShop.AvailHistoryEntryCount then
        begin
          For i := Pred(lvAvailHistory.Items.Count) downto fCurrentItemShop.AvailHistoryEntryCount do
            lvAvailHistory.Items.Delete(i);
        end
      else If lvAvailHistory.Items.Count < fCurrentItemShop.AvailHistoryEntryCount then
        begin
          For i := Succ(lvAvailHistory.Items.Count) to fCurrentItemShop.AvailHistoryEntryCount do
            with lvAvailHistory.Items.Add do
              begin
                Caption := '';
                SubItems.Add('');
              end;
        end;
      // fill the list
      For i := Pred(fCurrentItemShop.AvailHistoryEntryCount) downto 0 do
        with lvAvailHistory.Items[Pred(lvAvailHistory.Items.Count) - i] do
          begin
            Caption := FormatDateTime('yyyy-mm-dd hh:nn',fCurrentItemShop.AvailHistoryEntries[i].Time);
            If fCurrentItemShop.AvailHistoryEntries[i].Value > 0 then
              SubItems[0] := Format('%d',[fCurrentItemShop.AvailHistoryEntries[i].Value])
            else If fCurrentItemShop.AvailHistoryEntries[i].Value < 0 then
              SubItems[0] := Format('> %d',[Abs(fCurrentItemShop.AvailHistoryEntries[i].Value)])
            else
              SubItems[0] := '-';
          end;
    finally
      lvAvailHistory.Items.EndUpdate;
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmShopFrame.UpdatePriceHistory;
var
  i:  Integer;
begin
If Assigned(fCurrentItemShop) then
  begin
    lvPriceHistory.Items.BeginUpdate;
    try
      // set proper item count
      If lvPriceHistory.Items.Count > fCurrentItemShop.PriceHistoryEntryCount then
        begin
          For i := Pred(lvPriceHistory.Items.Count) downto fCurrentItemShop.PriceHistoryEntryCount do
            lvPriceHistory.Items.Delete(i);
        end
      else If lvPriceHistory.Items.Count < fCurrentItemShop.PriceHistoryEntryCount then
        begin
          For i := Succ(lvPriceHistory.Items.Count) to fCurrentItemShop.PriceHistoryEntryCount do
            with lvPriceHistory.Items.Add do
              begin
                Caption := '';
                SubItems.Add('');
              end;
        end;
      // fill the list
      For i := Pred(fCurrentItemShop.PriceHistoryEntryCount) downto 0 do
        with lvPriceHistory.Items[Pred(lvPriceHistory.Items.Count) - i] do
          begin
            Caption := FormatDateTime('yyyy-mm-dd hh:nn',fCurrentItemShop.PriceHistoryEntries[i].Time);
            If fCurrentItemShop.PriceHistoryEntries[i].Value > 0 then
              SubItems[0] := Format('%d Kè',[fCurrentItemShop.PriceHistoryEntries[i].Value])
            else
              SubItems[0] := '-';
          end;
    finally
      lvPriceHistory.Items.EndUpdate;
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmShopFrame.Initialize(ILManager: TILManager);
begin
fILManager := ILManager;
FillTemplatesList;
CreatePredefNotesMenu;
end;

//------------------------------------------------------------------------------

procedure TfrmShopFrame.SetItemShop(ItemShop: TILItemShop; ProcessChange: Boolean);
var
  Reassigned: Boolean;
begin
Reassigned := fCurrentItemShop = ItemShop;
If ProcessChange then
  begin
    If Assigned(fCurrentItemShop) and not Reassigned then
      SaveItemShop;
    If Assigned(ItemShop) then
      begin
        fCurrentItemShop := ItemShop;
        If not Reassigned then
          LoadItemShop;
      end
    else
      begin
        fCurrentItemShop := nil;
        FrameClear;
      end;
    Visible := Assigned(fCurrentItemShop);
    Enabled := Assigned(fCurrentItemShop);
  end
else fCurrentItemShop := ItemShop;
end;

//==============================================================================

procedure TfrmShopFrame.leShopNameChange(Sender: TObject);
begin
If not fInitializing and Assigned(fCurrentItemShop) then
  fCurrentItemShop.Name := leShopName.Text;
end;

//------------------------------------------------------------------------------

procedure TfrmShopFrame.cbShopSelectedClick(Sender: TObject);
begin
If not fInitializing and Assigned(fCurrentItemShop) then
  fCurrentItemShop.Selected := cbShopSelected.Checked;
end;

//------------------------------------------------------------------------------

procedure TfrmShopFrame.cbShopUntrackedClick(Sender: TObject);
begin
If not fInitializing and Assigned(fCurrentItemShop) then
  fCurrentItemShop.Untracked := cbShopUntracked.Checked;
end;

//------------------------------------------------------------------------------

procedure TfrmShopFrame.btnShopURLOpenClick(Sender: TObject);
begin
If Assigned(fCurrentItemShop) then
  begin
    fCurrentItemShop.ShopURL := leShopURL.Text;
    IL_ShellOpen(Handle,fCurrentItemShop.ShopURL);
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmShopFrame.leShopItemURLChange(Sender: TObject);
begin
If not fInitializing and Assigned(fCurrentItemShop) then
  fCurrentItemShop.ItemURL := leShopItemURL.Text;
end;

//------------------------------------------------------------------------------

procedure TfrmShopFrame.btnShopItemURLOpenClick(Sender: TObject);
begin
If Assigned(fCurrentItemShop) then
  IL_ShellOpen(Handle,fCurrentItemShop.ItemURL);
end;
 
//------------------------------------------------------------------------------

procedure TfrmShopFrame.seAvailableChange(Sender: TObject);
begin
If not fInitializing and Assigned(fCurrentItemShop) then
  fCurrentItemShop.Available := seAvailable.Value;
end;

//------------------------------------------------------------------------------

procedure TfrmShopFrame.btnAvailToHistoryClick(Sender: TObject);
begin
If Assigned(fCurrentItemShop) then
  fCurrentItemShop.AvailHistoryAdd;
end;

//------------------------------------------------------------------------------

procedure TfrmShopFrame.sePriceChange(Sender: TObject);
begin
If not fInitializing and Assigned(fCurrentItemShop) then
  fCurrentItemShop.Price := sePrice.Value;
end;

//------------------------------------------------------------------------------

procedure TfrmShopFrame.btnPriceToHistoryClick(Sender: TObject);
begin
If Assigned(fCurrentItemShop) then
  fCurrentItemShop.PriceHistoryAdd;
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
  Temp: TListView;
begin
If Assigned(fCurrentItemShop) and (Sender is TMenuItem) then
  If TPopupMenu(TMenuItem(Sender).GetParentMenu).PopupComponent is TListView then
    begin
      Temp := TListView(TPopupMenu(TMenuItem(Sender).GetParentMenu).PopupComponent);
      If Temp = lvAvailHistory then
        begin
          If Temp.ItemIndex >= 0 then
            fCurrentItemShop.AvailHistoryDelete(Pred(Temp.Items.Count) - Temp.ItemIndex);
        end
      else If Temp = lvPriceHistory then
        begin
          If Temp.ItemIndex >= 0 then
            fCurrentItemShop.PriceHistoryDelete(Pred(Temp.Items.Count) - Temp.ItemIndex);
        end;
    end;
end;

//------------------------------------------------------------------------------

procedure TfrmShopFrame.mniHI_ClearClick(Sender: TObject);
var
  Temp: TListView;
begin
If Assigned(fCurrentItemShop) and (Sender is TMenuItem) then
  If TPopupMenu(TMenuItem(Sender).GetParentMenu).PopupComponent is TListView then
    begin
      Temp := TListView(TPopupMenu(TMenuItem(Sender).GetParentMenu).PopupComponent);
      If Temp.Items.Count > 0 then
        If MessageDlg('Are you sure you want to clear the entire history?',mtConfirmation,[mbYes,mbNo],0) = mrYes then
          begin
            If Temp = lvAvailHistory then
              fCurrentItemShop.AvailHistoryClear
            else If Temp = lvPriceHistory then
              fCurrentItemShop.PriceHistoryClear;
          end;
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

procedure TfrmShopFrame.lblNotesEditClick(Sender: TObject);
var
  Temp: String;
begin
If Assigned(fCurrentItemShop) then
  begin
    Temp := meNotes.Text;
    fTextEditForm.ShowTextEditor('Edit item notes',Temp,False);
    meNotes.Text := Temp;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmShopFrame.lblNotesEditMouseEnter(Sender: TObject);
begin
lblNotesEdit.Font.Style := lblNotesEdit.Font.Style + [fsBold];
end;

//------------------------------------------------------------------------------

procedure TfrmShopFrame.lblNotesEditMouseLeave(Sender: TObject);
begin
lblNotesEdit.Font.Style := lblNotesEdit.Font.Style - [fsBold];
end;

//------------------------------------------------------------------------------

procedure TfrmShopFrame.btnPredefNotesClick(Sender: TObject);
var
  ScreenPoint:  TPoint;
begin
ScreenPoint := btnPredefNotes.ClientToScreen(
  Point(btnPredefNotes.Width,btnPredefNotes.Height));
pmnPredefNotes.Popup(ScreenPoint.X,ScreenPoint.Y);
end;

//------------------------------------------------------------------------------

procedure TfrmShopFrame.mniPredefNotesClick(Sender: TObject);
begin
If (Sender is TMenuItem) and Assigned(fCurrentItemShop) then
  If (TMenuItem(Sender).Tag >= Low(IL_SHOP_PREDEFNOTES)) and
     (TMenuItem(Sender).Tag <= High(IL_SHOP_PREDEFNOTES)) then
    meNotes.Text := meNotes.Text + IL_SHOP_PREDEFNOTES[TMenuItem(Sender).Tag];
end;

//------------------------------------------------------------------------------

procedure TfrmShopFrame.btnParsCopyToLocalClick(Sender: TObject);
begin
(*
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
      *)
end;

//------------------------------------------------------------------------------

procedure TfrmShopFrame.btnParsAvailClick(Sender: TObject);
begin
(*
If Assigned(fCurrentItemShopPtr) then
  fParsingForm.ShowParsingSettings('Available count parsing settings',
    Addr(fCurrentItemShopPtr^.ParsingSettings.Available));
    *)
end;

//------------------------------------------------------------------------------

procedure TfrmShopFrame.btnParsPriceClick(Sender: TObject);
begin
(*
If Assigned(fCurrentItemShopPtr) then
  fParsingForm.ShowParsingSettings('Price parsing settings',
    Addr(fCurrentItemShopPtr^.ParsingSettings.Price));
    *)
end;

//------------------------------------------------------------------------------

procedure TfrmShopFrame.btnUpdateClick(Sender: TObject);
var
  //Temp:   TILItemShop;
  Result: Boolean;
begin
(*
If Assigned(fCurrentItemShopPtr) then
  begin
    SaveItemShop;
    Screen.Cursor := crHourGlass;
    try
      fILManager.ItemShopCopyForUpdate(fCurrentItemShopPtr^,Temp);
      try
        Result := fILManager.ItemShopUpdate(Temp,fILManager.Options);
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
  *)
end;

//------------------------------------------------------------------------------

procedure TfrmShopFrame.btnTemplatesClick(Sender: TObject);
begin
If Assigned(fCurrentItemShop) then
  begin
    SaveItemShop;
    fTemplatesForm.ShowTemplates(fCurrentItemShop,False);
    // in case a template was deleted or added (must be before load, so proper item is selected]
    FillTemplatesList;
    LoadItemShop;
    leShopItemURL.SetFocus;
    If Assigned(OnTemplatesChange) then
      OnTemplatesChange(Self);
  end;
end;

end.
