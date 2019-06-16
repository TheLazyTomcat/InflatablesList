unit ShopsForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Spin, Menus,
  ShopFrame,
  IL_Types, IL_Item, IL_Manager;

const
  WM_USER_LVITEMSELECTED = WM_USER + 234;
  
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
    fWndCaption:  String;
    fILManager:   TILManager;
    fCurrentItem: TILItem;
  protected
    procedure BuildAddFromSubMenu;
    procedure TemplateChangeHandler(Sender: TObject); // called by shop frame
    procedure ShopsListSelect(ItemIndex: Integer);
    procedure UpdateList(Sender: TObject);
    procedure UpdateListItem(Sender: TObject; Index: Integer);
    procedure UpdateCurrentListItem;
    procedure UpdateShopCounts;
    procedure UpdateShopIndex;
    procedure UpdateAvailAndPrices(Sender: TObject; Index: Integer);
    procedure UpdateCurrentAvailAndPrices;
    procedure UpdateAvailHistory(Sender: TObject; Index: Integer);
    procedure UpdatePriceHistory(Sender: TObject; Index: Integer);
    procedure ListViewItemSelected(var Msg: TMessage); overload; message WM_USER_LVITEMSELECTED;
    procedure ListViewItemSelected; overload;
  public
    procedure Initialize(ILManager: TILManager);
    procedure ShowShops(Item: TILItem);
  end;

var
  fShopsForm: TfShopsForm;

implementation

uses
  AuxTypes,
  IL_Utils, TemplatesForm, UpdateForm;

{$R *.dfm}

procedure TfShopsForm.BuildAddFromSubMenu;
var
  i:    Integer;
  Temp: TMenuItem;
begin
// first clear the submenu
For i := Pred(mniSH_AddFromSub.Count) downto 0 do
  If mniSH_AddFromSub[i].Tag >= 0 then
    begin
      Temp := TMenuItem(mniSH_AddFromSub[i]);
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
BuildAddFromSubMenu;
end;

//------------------------------------------------------------------------------

procedure TfShopsForm.ShopsListSelect(ItemIndex: Integer);
begin
If (ItemIndex >= 0) and (ItemIndex < lvShops.Items.Count) then
  begin
    with lvShops.Items[ItemIndex] do
      begin
        Focused := True;
        Selected := True;
      end;
    lvShops.ItemIndex := ItemIndex;      
  end
else lvShops.ItemIndex := -1;
end;

//------------------------------------------------------------------------------

procedure TfShopsForm.UpdateList(Sender: TObject);
var
  i:  Integer;
begin
If Assigned(fCurrentItem) then
  begin
    lvShops.Items.BeginUpdate;
    try
      If lvShops.Items.Count > fCurrentItem.ShopCount then
        begin
          For i := Pred(lvShops.Items.Count) downto fCurrentItem.ShopCount do
            lvShops.Items.Delete(i);
        end
      else If lvShops.Items.Count < fCurrentItem.ShopCount then
        begin
          For i := Succ(lvShops.Items.Count) to fCurrentItem.ShopCount do
            with lvShops.Items.Add do
              begin
                Caption := '';
                SubItems.Add('');
                SubItems.Add('');
                SubItems.Add('');
                SubItems.Add('');
              end;
        end;
      For i := fCurrentItem.ShopLowIndex to fCurrentItem.ShopHighIndex do
        UpdateListItem(nil,i);
    finally
      lvShops.Items.EndUpdate;
    end;
  end
else lvShops.Clear;
end;

//------------------------------------------------------------------------------

procedure TfShopsForm.UpdateListItem(Sender: TObject; Index: Integer);
begin
If Assigned(fCurrentItem) and (Index >= 0) and (Index < lvShops.Items.Count) then
  with lvShops.Items[Index] do
    begin
      Caption := Format('%s%s',[
        IL_BoolToStr(fCurrentItem.Shops[Index].Selected,'','*'),
        IL_BoolToStr(fCurrentItem.Shops[Index].Untracked,'','^')]);
      SubItems[0] := fCurrentItem.Shops[Index].Name;
      SubItems[1] := fCurrentItem.Shops[Index].ItemURL;
      // avail
      If fCurrentItem.Shops[Index].Available < 0 then
        SubItems[2] := Format('more than %d',[Abs(fCurrentItem.Shops[Index].Available)])
      else If fCurrentItem.Shops[Index].Available > 0 then
        SubItems[2] := Format('%d',[Abs(fCurrentItem.Shops[Index].Available)])
      else
        SubItems[2] := '-';
      // price
      If fCurrentItem.Shops[Index].Price > 0 then
        SubItems[3] := Format('%d Kè',[fCurrentItem.Shops[Index].Price])
      else
        SubItems[3] := '-';
    end;
end;

//------------------------------------------------------------------------------

procedure TfShopsForm.UpdateCurrentListItem;
begin
If lvShops.ItemIndex >= 0 then
  UpdateListItem(nil,lvShops.ItemIndex);
UpdateShopCounts;
end;

//------------------------------------------------------------------------------

procedure TfShopsForm.UpdateShopCounts;
begin
If Assigned(fCurrentItem) then
  begin
    If fCurrentItem.ShopCount > 0 then
      Caption := Format('%s (%s)',[fWndCaption,fCurrentItem.ShopsCountStr])
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

//------------------------------------------------------------------------------

procedure TfShopsForm.UpdateAvailAndPrices(Sender: TObject; Index: Integer);
begin
If Assigned(fCurrentItem) and (Index = lvShops.ItemIndex) then
  begin
    fCurrentItem.UpdatePriceAndAvail;
    // show prices
    If fCurrentItem.UnitPriceLowest > 0 then
      lePriceLowest.Text := Format('%d Kè',[fCurrentItem.UnitPriceLowest])
    else
      lePriceLowest.Text := '-';
    If fCurrentItem.UnitPriceSelected > 0 then
      begin
        lePriceSelected.Text := Format('%d Kè',[fCurrentItem.UnitPriceSelected]);
        If fCurrentItem.UnitPriceSelected <> fCurrentItem.UnitPriceLowest then
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

procedure TfShopsForm.UpdateCurrentAvailAndPrices;
begin
If lvShops.ItemIndex >= 0 then
  UpdateAvailAndPrices(nil,lvShops.ItemIndex);
end;

//------------------------------------------------------------------------------

procedure TfShopsForm.UpdateAvailHistory(Sender: TObject; Index: Integer);
begin
If Index = lvShops.ItemIndex then
  frmShopFrame.UpdateAvailHistory;
end;

//------------------------------------------------------------------------------

procedure TfShopsForm.UpdatePriceHistory(Sender: TObject; Index: Integer);
begin
If Index = lvShops.ItemIndex then
  frmShopFrame.UpdatePriceHistory;
end;

//------------------------------------------------------------------------------

procedure TfShopsForm.ListViewItemSelected(var Msg: TMessage);
begin
If Msg.Msg = WM_USER_LVITEMSELECTED then
  ListViewItemSelected;
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

procedure TfShopsForm.ListViewItemSelected;
begin
If Assigned(fCurrentItem) then
  begin
    If (lvShops.ItemIndex >= 0) then
      begin
        frmShopFrame.SetItemShop(fCurrentItem.Shops[lvShops.ItemIndex],True);
        lvShops.Selected.MakeVisible(False);
      end
    else frmShopFrame.SetItemShop(nil,True);
  end;
UpdateShopIndex;
end;

//==============================================================================

procedure TfShopsForm.Initialize(ILManager: TILManager);
begin
fILManager := ILManager;
frmShopFrame.Initialize(fILManager);
BuildAddFromSubMenu;
end;

//------------------------------------------------------------------------------

procedure TfShopsForm.ShowShops(Item: TILItem);
var
  OldAvail: Int32;
  OldPrice: UInt32;
begin
If Assigned(Item) then
  begin
    OldAvail := Item.AvailableSelected;
    OldPrice := Item.UnitPriceSelected;
    fCurrentItem := Item;
    fWndCaption := fCurrentItem.TitleStr + ' - Shops';
    // fill list
    UpdateList(nil);
    ShopsListSelect(0);
    ListViewItemSelected;
    UpdateCurrentAvailAndPrices;
    UpdateShopCounts;
    // set event handlers
    fCurrentItem.OnShopListUpdate := UpdateList;
    fCurrentItem.OnShopListItemUpdate := UpdateListItem;
    fCurrentItem.OnShopValuesUpdate := UpdateAvailAndPrices;
    fCurrentItem.OnShopAvailHistoryUpdate := UpdateAvailHistory;
    fCurrentItem.OnShopPriceHistoryUpdate := UpdatePriceHistory;
    ShowModal;                            // <----
    fCurrentItem.Release(False);
    frmShopFrame.SetItemShop(nil,True);
    // update and set flags
    fCurrentItem.UpdatePriceAndAvail;
    fCurrentItem.FlagPriceAndAvail(OldPrice,OldAvail);
  end;
end;

//==============================================================================

procedure TfShopsForm.FormCreate(Sender: TObject);
begin
mniSH_MoveUp.ShortCut := Shortcut(VK_UP,[ssShift]);
mniSH_MoveDown.ShortCut := Shortcut(VK_Down,[ssShift]);
lvShops.DoubleBuffered := True;
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
PostMessage(Handle,WM_USER_LVITEMSELECTED,Ord(Selected),0);
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
If Assigned(fCurrentItem) then
  begin
    Index := fCurrentItem.ShopAdd;  // this will also update the listing
    fCurrentItem.Shops[Index].RequiredCount := fCurrentItem.Pieces;
    ShopsListSelect(Index);
    ListViewItemSelected;
    UpdateShopCounts;
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
begin
If Assigned(fCurrentItem) and (Sender is TMenuItem) then
  begin
    mniSH_AddCommon;
    If lvShops.ItemIndex >= 0 then
      begin
        frmShopFrame.SaveItemShop;
        // copy the settings from template
        fILManager.ShopTemplates[TMenuItem(Sender).Tag].CopyTo(
          fCurrentItem.Shops[lvShops.ItemIndex]);
        frmShopFrame.LoadItemShop;
        frmShopFrame.leShopItemURL.SetFocus;
      end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfShopsForm.mniSH_AddFromTemplateClick(Sender: TObject);
begin
If Assigned(fCurrentItem) then
  begin
    mniSH_AddCommon;
    If lvShops.ItemIndex >= 0 then  // should be valid after mniSH_AddCommon, but to be sure
      begin
        frmShopFrame.SaveItemShop;
        fTemplatesForm.ShowTemplates(fCurrentItem.Shops[lvShops.ItemIndex],True);
        frmShopFrame.LoadItemShop;
        BuildAddFromSubMenu;
        frmShopFrame.leShopItemURL.SetFocus;
      end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfShopsForm.mniSH_RemoveClick(Sender: TObject);
var
  Index:  Integer;
begin
If Assigned(fCurrentItem) and (lvShops.ItemIndex >= 0) then
  If MessageDlg(Format('Are you sure you want to remove shop "%s"?',
      [fCurrentItem.Shops[lvShops.ItemIndex].Name]),
      mtConfirmation,[mbYes,mbNo],0) = mrYes then
    begin
      If lvShops.ItemIndex < Pred(lvShops.Items.Count) then
        Index := lvShops.ItemIndex
      else If lvShops.ItemIndex > 0 then
        Index := lvShops.ItemIndex - 1
      else
        Index := -1;
      frmShopFrame.SaveItemShop;
      frmShopFrame.SetItemShop(nil,False);
      fCurrentItem.ShopDelete(lvShops.ItemIndex);        
      ShopsListSelect(Index);
      ListViewItemSelected;
      UpdateCurrentAvailAndPrices;
      UpdateShopCounts;
    end;
end;

//------------------------------------------------------------------------------

procedure TfShopsForm.mniSH_MoveUpClick(Sender: TObject);
var
  Index:  Integer;
begin
If Assigned(fCurrentItem) and (lvShops.ItemIndex > 0) then
  begin
    Index := lvShops.ItemIndex;
    fCurrentItem.ShopExchange(Index,Index - 1);
    ShopsListSelect(Index - 1);
    ListViewItemSelected;
  end;
end;

//------------------------------------------------------------------------------

procedure TfShopsForm.mniSH_MoveDownClick(Sender: TObject);
var
  Index:  Integer;
begin
If Assigned(fCurrentItem) and (lvShops.ItemIndex >= 0) and (lvShops.ItemIndex < Pred(lvShops.Items.Count)) then
  begin
    Index := lvShops.ItemIndex;
    fCurrentItem.ShopExchange(Index,Index + 1);
    ShopsListSelect(Index + 1);
    ListViewItemSelected;
  end;
end;

//------------------------------------------------------------------------------

procedure TfShopsForm.btnUpdateAllClick(Sender: TObject);
var
  i:    Integer;
  Temp: TILItemShopUpdateList;
begin
If Assigned(fCurrentItem) then
  begin
    If fCurrentItem.ShopCount > 0 then
      begin
        frmShopFrame.SaveItemShop;
        SetLength(Temp,fCurrentItem.ShopCount);
        For i := Low(Temp) to High(Temp) do
          begin
            Temp[i].ItemTitle := Format('[#%d] %s',[fCurrentItem.Index,fCurrentItem.TitleStr]);
            Temp[i].ItemShop := fCurrentItem.Shops[i];
            Temp[i].Done := False;
          end;
        fUpdateForm.ShowUpdate(Temp);
        frmShopFrame.LoadItemShop;
      end
    else MessageDlg('No shop to update.',mtInformation,[mbOK],0);
  end;
end;

//------------------------------------------------------------------------------

procedure TfShopsForm.btnUpdateHistoryClick(Sender: TObject);
var
  i:  Integer;
begin
If Assigned(fCurrentItem) then
  If fCurrentItem.ShopCount > 0 then
    begin
      frmShopFrame.SaveItemShop;
      For i := fCurrentItem.ShopLowIndex to fCurrentItem.ShopHighIndex do
        fCurrentItem.Shops[i].UpdateAvailAndPriceHistory;
    end;
end;

//------------------------------------------------------------------------------

procedure TfShopsForm.btnCloseClick(Sender: TObject);
begin
Close;
end;

end.
