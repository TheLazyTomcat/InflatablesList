unit ShopsForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Spin, Menus,
  ShopFrame,
  InflatablesList_Types, InflatablesList;

const
  WM_LVITEMSELECTED = WM_USER + 666;

type
  TfShopsForm = class(TForm)
    lblShops: TLabel;
    lblLegend: TLabel;    
    lvShops: TListView;
    gbShopDetails: TGroupBox;    
    lePriceLowest: TLabeledEdit;
    lePriceSelected: TLabeledEdit;
    btnUpdateAll: TButton;
    btnUpdateHistory: TButton;
    btnClose: TButton;
    pmnShops: TPopupMenu;
    mniSH_Add: TMenuItem;
    mniSH_AddFromSub: TMenuItem;
    mniSH_AddFromTemplate: TMenuItem;    
    mniSH_Remove: TMenuItem;
    N1: TMenuItem;
    mniSH_MoveUp: TMenuItem;
    mniSH_MoveDown: TMenuItem;
    frmShopFrame: TfrmShopFrame;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);    
    procedure lvShopsSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
    procedure pmnShopsPopup(Sender: TObject);
    procedure mniSH_AddCommon;
    procedure mniSH_AddClick(Sender: TObject);
    procedure mniSH_AddFromSubClick(Sender: TObject);
    procedure mniSH_AddFromTemplateClick(Sender: TObject);
    procedure mniSH_RemoveClick(Sender: TObject);
    procedure mniSH_MoveUpClick(Sender: TObject);
    procedure mniSH_MoveDownClick(Sender: TObject);
    procedure btnUpdateAllClick(Sender: TObject);
    procedure btnUpdateHistoryClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
  private
    fWndCaption:      String;
    fILManager:       TILManager;
    fCurrentItemPtr:  PILItem;
  protected
    procedure CreateAddFromSubMenu;
    procedure TemplateChangeHandler(Sender: TObject);
    procedure ListViewItemSelected(var Message: TMessage); overload; message WM_LVITEMSELECTED;
    procedure ListViewItemSelected; overload;
    procedure UpdateListItem(Index: Integer);
    procedure UpdateCurrentListItem(Sender: TObject);
    procedure ClearSelected(Sender: TObject);
    procedure RecalcAndShowPrices(Sender: TObject);
    procedure UpdateShopsCounts;
    procedure UpdateShopIndex;
  public
    procedure Initialize(ILManager: TILManager);
    procedure ShowShops(ItemPtr: PILItem);
  end;

var
  fShopsForm: TfShopsForm;

implementation

uses
  AuxTypes,
  InflatablesList_Utils,
  UpdateForm, TemplatesForm;

{$R *.dfm}

procedure TfShopsForm.CreateAddFromSubMenu;
var
  i:    Integer;
  Temp: TMenuItem;
begin
// first clear the submenu
For i := Pred(mniSH_AddFromSub.Count) downto 0 do
  If mniSH_AddFromSub[i].Tag >= 0 then
    begin
      Temp := mniSH_AddFromSub[i];
      mniSH_AddFromSub.Delete(i);
      FreeAndNil(Temp);
    end;
// recreate the menu
For i := 0 to Pred(fILManager.ShopTemplateCount) do
  begin
    Temp := TMenuItem.Create(Self);
    Temp.Name := Format('mniSH_AS_Template%d',[i]);
    Temp.Caption := fILManager.ShopTemplates[i].Name;
    Temp.OnClick := mniSH_AddFromSubClick;
    Temp.Tag := i;
    If (Pred(fILManager.ShopTemplateCount) - i) <= 9 then
      Temp.ShortCut := ShortCut(Ord('0') +
        (((Pred(fILManager.ShopTemplateCount) - i) + 1) mod 10),[ssCtrl]);
    mniSH_AddFromSub.Add(Temp);
  end;
mniSH_AddFromSub.Enabled := mniSH_AddFromSub.Count > 0;
end;

//------------------------------------------------------------------------------

procedure TfShopsForm.TemplateChangeHandler(Sender: TObject);
begin
CreateAddFromSubMenu;
end;

//------------------------------------------------------------------------------

procedure TfShopsForm.ListViewItemSelected(var Message: TMessage);
begin
ListViewItemSelected;
end;

//------------------------------------------------------------------------------

procedure TfShopsForm.ListViewItemSelected;
begin
If Assigned(fCurrentItemPtr) then
  begin
    If (lvShops.ItemIndex >= 0) then
      begin
        frmShopFrame.SetItemShop(Addr(fCurrentItemPtr^.Shops[lvShops.ItemIndex]),True);
        lvShops.Selected.MakeVisible(False);
      end
    else frmShopFrame.SetItemShop(nil,True);
  end;
UpdateShopIndex;
end;

//------------------------------------------------------------------------------

procedure TfShopsForm.UpdateListItem(Index: Integer);
begin
If Assigned(fCurrentItemPtr) and (Index >= 0) and (Index < lvShops.Items.Count) then
  begin
    lvShops.Items.BeginUpdate;
    try
      with lvShops.Items[Index] do
        begin
          Caption := Format('%s%s',[
            IL_BoolToChar(fCurrentItemPtr^.Shops[Index].Selected,' ','*'),
            IL_BoolToChar(fCurrentItemPtr^.Shops[Index].Untracked,' ','^')]);
          SubItems[0] := fCurrentItemPtr^.Shops[Index].Name;
          SubItems[1] := fCurrentItemPtr^.Shops[Index].ItemURL;
          If fCurrentItemPtr^.Shops[Index].Available < 0 then
            SubItems[2] := Format('more than %d',[Abs(fCurrentItemPtr^.Shops[Index].Available)])
          else If fCurrentItemPtr^.Shops[Index].Available > 0 then
            SubItems[2] := Format('%d',[Abs(fCurrentItemPtr^.Shops[Index].Available)])
          else
            SubItems[2] := '-';
          If fCurrentItemPtr^.Shops[Index].Price > 0 then
            SubItems[3] := Format('%d Kè',[fCurrentItemPtr^.Shops[Index].Price])
          else
            SubItems[3] := '-';
        end;
    finally
      lvShops.Items.EndUpdate;
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfShopsForm.UpdateCurrentListItem(Sender: TObject);
begin
If lvShops.ItemIndex >= 0 then
  UpdateListItem(lvShops.ItemIndex);
end;

//------------------------------------------------------------------------------

procedure TfShopsForm.ClearSelected(Sender: TObject);
var
  i:  Integer;
begin
If Assigned(fCurrentItemPtr) then
  For i := Low(fCurrentItemPtr^.Shops) to High(fCurrentItemPtr^.Shops) do
    begin
      If fCurrentItemPtr^.Shops[i].Selected then
        begin
          fCurrentItemPtr^.Shops[i].Selected := False;
          UpdateListItem(i);
        end
    end;
end;

//------------------------------------------------------------------------------

procedure TfShopsForm.RecalcAndShowPrices(Sender: TObject);
begin
If Assigned(fCurrentItemPtr) then
  begin
    fILManager.ItemUpdatePriceAndAvail(fCurrentItemPtr^);
    // show prices
    If fCurrentItemPtr^.UnitPriceLowest > 0 then
      lePriceLowest.Text := Format('%d Kè',[fCurrentItemPtr^.UnitPriceLowest])
    else
      lePriceLowest.Text := '-';
    If fCurrentItemPtr^.UnitPriceSelected > 0 then
      begin
        lePriceSelected.Text := Format('%d Kè',[fCurrentItemPtr^.UnitPriceSelected]);
        If fCurrentItemPtr^.UnitPriceSelected <> fCurrentItemPtr^.UnitPriceLowest then
          lePriceSelected.Color := clYellow
        else
          lePriceSelected.Color := clWindow;
      end
    else
      begin
        lePriceSelected.Text := '-';
        lePriceSelected.Color := clWindow;
      end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfShopsForm.UpdateShopsCounts;
begin
If Assigned(fCurrentItemPtr) then
  begin
    If fILManager.ItemShopsCount(fCurrentItemPtr^) > 0 then
      Caption := Format('%s (%s)',[fWndCaption,fILManager.ItemShopsCountStr(fCurrentItemPtr^)])
    else
      Caption := fWndCaption;
  end
else Caption := fWndCaption;
end;

//------------------------------------------------------------------------------

procedure TfShopsForm.UpdateShopIndex;
begin
If lvShops.ItemIndex < 0 then
  begin
    If lvShops.Items.Count > 0 then
      lblShops.Caption := Format('Shops [%d]:',[lvShops.Items.Count])
    else
      lblShops.Caption := 'Shops:';
  end
else lblShops.Caption := Format('Shops [%d/%d]:',[lvShops.ItemIndex + 1,lvShops.Items.Count]);
end;

//==============================================================================

procedure TfShopsForm.Initialize(ILManager: TILManager);
begin
fILManager := ILManager;
frmShopFrame.Initialize(fILManager);
CreateAddFromSubMenu;
end;

//------------------------------------------------------------------------------

procedure TfShopsForm.ShowShops(ItemPtr: PILItem);
var
  i:        Integer;
  OldAvail: Int32;
  OldPrice: UInt32;
begin
If Assigned(ItemPtr) then
  begin
    OldAvail := ItemPtr^.AvailableSelected;
    OldPrice := ItemPtr^.UnitPriceSelected;
    fCurrentItemPtr := ItemPtr;
    fWndCaption := fILManager.ItemTitleStr(fCurrentItemPtr^) + ' - Shops';
    // fill list
    lvShops.Items.BeginUpdate;
    try
      lvShops.Clear;
      For i := Low(fCurrentItemPtr^.Shops) to High(fCurrentItemPtr^.Shops) do
        with lvShops.Items.Add do
          begin
            Caption := '';
            SubItems.Add('');
            SubItems.Add('');
            SubItems.Add('');
            SubItems.Add('');
            UpdateListItem(i);
          end;
    finally
      lvShops.Items.EndUpdate;
    end;
    If lvShops.Items.Count > 0 then
      lvShops.ItemIndex := 0
    else
      lvShops.ItemIndex := -1;
    ListViewItemSelected;
    RecalcAndShowPrices(nil);
    UpdateShopsCounts;
    ShowModal;                            // <----
    frmShopFrame.SetItemShop(nil,True);
    // update and set flags
    fILManager.ItemUpdatePriceAndAvail(fCurrentItemPtr^);
    fILManager.ItemFlagPriceAndAvail(fCurrentItemPtr^,OldPrice,OldAvail);
  end;
end;

//==============================================================================

procedure TfShopsForm.FormCreate(Sender: TObject);
begin
mniSH_MoveUp.ShortCut := Shortcut(VK_UP,[ssShift]);
mniSH_MoveDown.ShortCut := Shortcut(VK_Down,[ssShift]);
lvShops.DoubleBuffered := True;
frmShopFrame.OnListUpdate := UpdateCurrentListItem;
frmShopFrame.OnPriceChange := RecalcAndShowPrices;
frmShopFrame.OnClearSelected := ClearSelected;
frmShopFrame.OnTemplatesChange := TemplateChangeHandler;
end;

//------------------------------------------------------------------------------

procedure TfShopsForm.FormShow(Sender: TObject);
begin
lvShops.SetFocus;
end;

//------------------------------------------------------------------------------

procedure TfShopsForm.lvShopsSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
begin
//this deffers reaction to change and prevents flickering
PostMessage(Handle,WM_LVITEMSELECTED,Ord(Selected),0);
end;

//------------------------------------------------------------------------------

procedure TfShopsForm.pmnShopsPopup(Sender: TObject);
begin
mniSH_Remove.Enabled := lvShops.ItemIndex >= 0;
mniSH_MoveUp.Enabled := lvShops.ItemIndex > 0;
mniSH_MoveDown.Enabled := (lvShops.ItemIndex >= 0) and (lvShops.ItemIndex < Pred(lvShops.Items.Count));
end;

//------------------------------------------------------------------------------

procedure TfShopsForm.mniSH_AddCommon;
var
  Index:  Integer;
begin
If Assigned(fCurrentItemPtr) then
  begin
    Index := fILManager.ItemShopAdd(fCurrentItemPtr^);
    fCurrentItemPtr^.Shops[Index].RequiredCount := fCurrentItemPtr^.Count;
    Index := lvShops.ItemIndex;
    with lvShops.Items.Add do
      begin
        Caption := '';
        SubItems.Add('');
        SubItems.Add('');
        SubItems.Add('');
        SubItems.Add('');
      end;
    UpdateListItem(Pred(lvShops.Items.Count));
    If Index >= 0 then
      frmShopFrame.SetItemShop(Addr(fCurrentItemPtr^.Shops[Index]),False);
    lvShops.ItemIndex := Pred(lvShops.Items.Count);
    ListViewItemSelected;
    UpdateShopsCounts;
  end;
end;

//------------------------------------------------------------------------------

procedure TfShopsForm.mniSH_AddClick(Sender: TObject);
begin
mniSH_AddCommon;
frmShopFrame.leShopName.SetFocus;
end;

//------------------------------------------------------------------------------

procedure TfShopsForm.mniSH_AddFromSubClick(Sender: TObject);
var
  i:  Integer;
begin
If Assigned(fCurrentItemPtr) and (Sender is TMenuItem) then
  begin
    mniSH_AddCommon;
    If lvShops.ItemIndex >= 0 then
      begin
        frmShopFrame.SaveItemShop;
        // copy the settings from template
        with fCurrentItemPtr^.Shops[lvShops.ItemIndex],
             fILManager.ShopTemplates[TMenuItem(Sender).Tag] do
          begin
            Untracked := ShopData.Untracked;
            AltDownMethod := ShopData.AltDownMethod;
            fCurrentItemPtr^.Shops[lvShops.ItemIndex].Name := ShopData.Name;  
            ShopURL := ShopData.ShopURL;
            // variables (copy only when destination is empty)
            For i := Low(ParsingSettings.Variables.Vars) to High(ParsingSettings.Variables.Vars) do
              If Length(ParsingSettings.Variables.Vars[i]) <= 0 then
                ParsingSettings.Variables.Vars[i] := ShopData.ParsingSettings.Variables.Vars[i];
            // other options
            ParsingSettings.DisableParsErrs := ShopData.ParsingSettings.DisableParsErrs;
            ParsingSettings.TemplateRef := fILManager.ShopTemplates[TMenuItem(Sender).Tag].Name;
          end;
        frmShopFrame.LoadItemShop;
        frmShopFrame.leShopItemURL.SetFocus;
      end;
    UpdateCurrentListItem(nil);
  end;
end;

//------------------------------------------------------------------------------

procedure TfShopsForm.mniSH_AddFromTemplateClick(Sender: TObject);
begin
If Assigned(fCurrentItemPtr) then
  begin
    mniSH_AddCommon;
    If lvShops.ItemIndex >= 0 then  // should be valid after mniSH_AddCommon, but to be sure
      begin
        frmShopFrame.SaveItemShop;
        fTemplatesForm.ShowTemplates(Addr(fCurrentItemPtr^.Shops[lvShops.ItemIndex]),True);
        frmShopFrame.LoadItemShop;
        CreateAddFromSubMenu;
        frmShopFrame.leShopItemURL.SetFocus;
      end;
    UpdateCurrentListItem(nil);
  end;
end;

//------------------------------------------------------------------------------

procedure TfShopsForm.mniSH_RemoveClick(Sender: TObject);
var
  Index:  Integer;
begin
If Assigned(fCurrentItemPtr) and (lvShops.ItemIndex >= 0) then
  If MessageDlg(Format('Are you sure you want to remove shop "%s"?',
      [fCurrentItemPtr^.Shops[lvShops.ItemIndex].Name]),
      mtConfirmation,[mbYes,mbNo],0) = mrYes then
    begin
      Index := lvShops.ItemIndex;
      If lvShops.ItemIndex < Pred(lvShops.Items.Count) then
        lvShops.ItemIndex := lvShops.ItemIndex + 1
      else If lvShops.ItemIndex > 0 then
        lvShops.ItemIndex := lvShops.ItemIndex - 1
      else
        lvShops.ItemIndex := -1;
      ListViewItemSelected;
      lvShops.Items.Delete(Index);
      fILManager.ItemShopDelete(fCurrentItemPtr^,Index);
      If lvShops.ItemIndex >= 0 then
        frmShopFrame.SetItemShop(Addr(fCurrentItemPtr^.Shops[lvShops.ItemIndex]),False);
      RecalcAndShowPrices(nil);
      UpdateShopsCounts;
    end;
end;

//------------------------------------------------------------------------------

procedure TfShopsForm.mniSH_MoveUpClick(Sender: TObject);
var
  Index:  Integer;
begin
If Assigned(fCurrentItemPtr) and (lvShops.ItemIndex > 0) then
  begin
    Index := lvShops.ItemIndex;
    fILManager.ItemShopExchange(fCurrentItemPtr^,Index,Index - 1);
    frmShopFrame.SetItemShop(Addr(fCurrentItemPtr^.Shops[Index - 1]),False);
    lvShops.ItemIndex := Index - 1;
    ListViewItemSelected;
    UpdateListItem(Index - 1);
    UpdateListItem(Index);
  end;
end;

//------------------------------------------------------------------------------

procedure TfShopsForm.mniSH_MoveDownClick(Sender: TObject);
var
  Index:  Integer;
begin
If Assigned(fCurrentItemPtr) and (lvShops.ItemIndex >= 0) and (lvShops.ItemIndex < Pred(lvShops.Items.Count)) then
  begin
    Index := lvShops.ItemIndex;
    fILManager.ItemShopExchange(fCurrentItemPtr^,Index,Index + 1);
    frmShopFrame.SetItemShop(Addr(fCurrentItemPtr^.Shops[Index + 1]),False);
    lvShops.ItemIndex := Index + 1;
    ListViewItemSelected;
    UpdateListItem(Index);
    UpdateListItem(Index + 1);
  end;
end;

//------------------------------------------------------------------------------

procedure TfShopsForm.btnUpdateAllClick(Sender: TObject);
var
  i:    Integer;
  Temp: TILItemShopUpdates;
begin
If Assigned(fCurrentItemPtr) then
  begin
    If Length(fCurrentItemPtr^.Shops) > 0 then
      begin
        frmShopFrame.SaveItemShop;
        SetLength(Temp,Length(fCurrentItemPtr^.Shops));
        For i := Low(Temp) to High(Temp) do
          begin
            Temp[i].ItemName := Format('[#%d] %s',[fCurrentItemPtr^.Index,fILManager.ItemTitleStr(fCurrentItemPtr^)]);
            Temp[i].ItemShopPtr := Addr(fCurrentItemPtr^.Shops[i]);
            Temp[i].ItemShopPtr^.RequiredCount := fCurrentItemPtr^.Count;
            Temp[i].Done := False;
          end;
        fUpdateForm.ShowUpdate(Temp);
        For i := 0 to Pred(lvShops.Items.Count) do
          UpdateListItem(i);
        frmShopFrame.LoadItemShop;
        RecalcAndShowPrices(nil);
      end
    else MessageDlg('No shop to update.',mtInformation,[mbOK],0);
  end;
end;

//------------------------------------------------------------------------------

procedure TfShopsForm.btnUpdateHistoryClick(Sender: TObject);
var
  i:  Integer;
begin
If Assigned(fCurrentItemPtr) then
  If Length(fCurrentItemPtr^.Shops) > 0 then
    begin
      frmShopFrame.SaveItemShop;
      For i := Low(fCurrentItemPtr^.Shops) to High(fCurrentItemPtr^.Shops) do
        fILManager.ItemShopsUpdateHistory(fCurrentItemPtr^);
      frmShopFrame.LoadItemShop;
    end;
end;

//------------------------------------------------------------------------------

procedure TfShopsForm.btnCloseClick(Sender: TObject);
begin
Close;
end;

end.
