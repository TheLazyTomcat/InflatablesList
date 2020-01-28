unit ShopsForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Spin, Menus,
  ShopFrame,
  InflatablesList_Item,
  InflatablesList_Manager;

const
  LI_WM_USER_LVITEMSELECTED = WM_USER + 234;
  
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
    mniSH_RemoveAll: TMenuItem;
    N1: TMenuItem;
    mniSH_MoveUp: TMenuItem;
    mniSH_MoveDown: TMenuItem;
    frmShopFrame: TfrmShopFrame;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);    
    procedure lvShopsSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
    procedure lvShopsDblClick(Sender: TObject);
    procedure pmnShopsPopup(Sender: TObject);
    procedure mniSH_AddCommon;
    procedure mniSH_AddClick(Sender: TObject);
    procedure mniSH_AddFromSubClick(Sender: TObject);
    procedure mniSH_AddFromTemplateClick(Sender: TObject);
    procedure mniSH_RemoveClick(Sender: TObject);
    procedure mniSH_RemoveAllClick(Sender: TObject);
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
    // item event handlers (manager)
    procedure ItemShopListUpdateHandler(Sender: TObject; Item: TObject);
    procedure ItemValuesUpdateHandler(Sender: TObject; Shop: TObject);
    // shop event handlers (manager)
    procedure ShopListItemUpdateHandler(Sender: TObject; Item: TObject; Shop: TObject; Index: Integer);
    // shop frame event handlers
    procedure TemplateChangeHandler(Sender: TObject);
    // other methods
    procedure BuildAddFromSubMenu;
    procedure ShopListSelect(ItemIndex: Integer);
    procedure UpdateCurrentListItem;
    procedure UpdateShopCounts;
    procedure UpdateShopIndex;
    procedure ListViewItemSelected(var Msg: TMessage); overload; message LI_WM_USER_LVITEMSELECTED;
    procedure ListViewItemSelected; overload;
  public
    procedure Initialize(ILManager: TILManager);
    procedure Finalize;
    procedure ShowShops(Item: TILItem);
  end;

var
  fShopsForm: TfShopsForm;

implementation

uses
  AuxTypes,
  TemplatesForm, UpdateForm,
  InflatablesList_Types,
  InflatablesList_Utils,
  InflatablesList_LocalStrings;

{$R *.dfm}

procedure TfShopsForm.ItemShopListUpdateHandler(Sender: TObject; Item: TObject);
var
  i:  Integer;
begin
If Assigned(fCurrentItem) and (Item = fCurrentItem) then
  begin
    lvShops.Items.BeginUpdate;
    try
      // adjust count
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
      // fill items  
      For i := fCurrentItem.ShopLowIndex to fCurrentItem.ShopHighIndex do
        ShopListItemUpdateHandler(nil,fCurrentItem,nil,i);
    finally
      lvShops.Items.EndUpdate;
    end;
  end;
UpdateShopCounts;  
end;

//------------------------------------------------------------------------------

procedure TfShopsForm.ItemValuesUpdateHandler(Sender: TObject; Shop: TObject);
begin
If Assigned(fCurrentItem) and (Shop = fCurrentItem) then
  begin
    // show prices
    If fCurrentItem.UnitPriceLowest > 0 then
      lePriceLowest.Text := IL_Format('%d %s',[fCurrentItem.UnitPriceLowest,IL_CURRENCY_SYMBOL])
    else
      lePriceLowest.Text := '-';
    If fCurrentItem.UnitPriceSelected > 0 then
      begin
        lePriceSelected.Text := IL_Format('%d %s',[fCurrentItem.UnitPriceSelected,IL_CURRENCY_SYMBOL]);
        If (fCurrentItem.UnitPriceSelected <> fCurrentItem.UnitPriceLowest) and (fCurrentItem.UnitPriceLowest > 0) then
          lePriceSelected.Color := clYellow
        else
          lePriceSelected.Color := clWindow;
      end
    else
      begin
        lePriceSelected.Text := '-';
        lePriceSelected.Color := clWindow;
      end;
    UpdateShopCounts;
  end;
end;

//------------------------------------------------------------------------------

procedure TfShopsForm.ShopListItemUpdateHandler(Sender: TObject; Item: TObject; Shop: TObject; Index: Integer);
begin
If Assigned(fCurrentItem) and (Item = fCurrentItem) and  (Index >= 0) and (Index < lvShops.Items.Count) then
  with lvShops.Items[Index] do
    begin
      Caption := IL_Format('%s%s%s',[
        IL_BoolToStr(fCurrentItem.Shops[Index].Selected,'','*'),
        IL_BoolToStr(fCurrentItem.Shops[Index].Untracked,'','^'),
        IL_BoolToStr((fCurrentItem.Shops[Index].LastUpdateRes >= fCurrentItem.ShopsWorstUpdateResult) and
                     (fCurrentItem.Shops[Index].LastUpdateRes <> ilisurSuccess),'','!')]);
      SubItems[0] := fCurrentItem.Shops[Index].Name;
      SubItems[1] := fCurrentItem.Shops[Index].ItemURL;
      // avail
      If fCurrentItem.Shops[Index].Available < 0 then
        SubItems[2] := IL_Format('more than %d',[Abs(fCurrentItem.Shops[Index].Available)])
      else If fCurrentItem.Shops[Index].Available > 0 then
        SubItems[2] := IL_Format('%d',[Abs(fCurrentItem.Shops[Index].Available)])
      else
        SubItems[2] := '-';
      // price
      If fCurrentItem.Shops[Index].Price > 0 then
        SubItems[3] := IL_Format('%d %s',[fCurrentItem.Shops[Index].Price,IL_CURRENCY_SYMBOL])
      else
        SubItems[3] := '-';
    end;
end;

//------------------------------------------------------------------------------

procedure TfShopsForm.TemplateChangeHandler(Sender: TObject);
begin
BuildAddFromSubMenu;
end;

//------------------------------------------------------------------------------

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
    Temp.Name := IL_Format('mniSH_AS_Template%d',[i]);
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

procedure TfShopsForm.ShopListSelect(ItemIndex: Integer);
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

procedure TfShopsForm.UpdateCurrentListItem;
begin
If lvShops.ItemIndex >= 0 then
  ShopListItemUpdateHandler(nil,fCurrentItem,nil,lvShops.ItemIndex);
UpdateShopCounts;
end;

//------------------------------------------------------------------------------

procedure TfShopsForm.UpdateShopCounts;
begin
If Assigned(fCurrentItem) then
  begin
    If fCurrentItem.ShopCount > 0 then
      Caption := IL_Format('%s (%s)',[fWndCaption,fCurrentItem.ShopsCountStr])
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
      lblShops.Caption := IL_Format('Shops (%d):',[lvShops.Items.Count])
    else
      lblShops.Caption := 'Shops:';
  end
else lblShops.Caption := IL_Format('Shops (%d/%d):',[lvShops.ItemIndex + 1,lvShops.Items.Count]);
end;

//------------------------------------------------------------------------------

procedure TfShopsForm.ListViewItemSelected(var Msg: TMessage);
begin
If Msg.Msg = LI_WM_USER_LVITEMSELECTED then
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
// shop events
fILManager.OnShopListItemUpdate := ShopListItemUpdateHandler;
// item events
fILManager.OnItemShopListUpdate := ItemShopListUpdateHandler;
fILManager.OnItemShopListValuesUpdate := ItemValuesUpdateHandler;
frmShopFrame.Initialize(fILManager);
frmShopFrame.OnTemplatesChange := TemplateChangeHandler;
BuildAddFromSubMenu;
end;

//------------------------------------------------------------------------------

procedure TfShopsForm.Finalize;
begin
frmShopFrame.OnTemplatesChange := nil;
fILManager.OnShopListItemUpdate := nil;
fILManager.OnItemShopListUpdate := nil;
fILManager.OnItemShopListValuesUpdate := nil;
frmShopFrame.Finalize;
end;

//------------------------------------------------------------------------------

procedure TfShopsForm.ShowShops(Item: TILItem);
var
  OldAvail: Int32;
  OldPrice: UInt32;
  OldFlags: TILItemFlags;
begin
If Assigned(Item) then
  begin
    OldAvail := Item._AvailableSelected;
    OldPrice := Item.UnitPriceSelected;
    OldFlags := Item.Flags;
    fCurrentItem := Item;
    fWndCaption := fCurrentItem.TitleStr + ' - Shops';
    // fill list
    ItemShopListUpdateHandler(nil,fCurrentItem);
    ShopListSelect(0);
    ListViewItemSelected;
    ItemValuesUpdateHandler(nil,fCurrentItem);
    ShowModal;                            // <----
    frmShopFrame.SetItemShop(nil,True);
    // manage flags
    If not(ilifPriceChange in OldFlags) then
      fCurrentItem.SetFlagValue(ilifPriceChange,False);
    If not(ilifAvailChange in OldFlags) then
      fCurrentItem.SetFlagValue(ilifAvailChange,False);
    If not(ilifNotAvailable in OldFlags) then
      fCurrentItem.SetFlagValue(ilifNotAvailable,False);
    fCurrentItem.GetAndFlagPriceAndAvail(OldPrice,OldAvail);
  end;
end;

//==============================================================================

procedure TfShopsForm.FormCreate(Sender: TObject);
begin
lvShops.DoubleBuffered := True;
mniSH_MoveUp.ShortCut := Shortcut(VK_UP,[ssShift]);
mniSH_MoveDown.ShortCut := Shortcut(VK_Down,[ssShift]);
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
PostMessage(Handle,LI_WM_USER_LVITEMSELECTED,Ord(Selected),0);
end;

//------------------------------------------------------------------------------

procedure TfShopsForm.lvShopsDblClick(Sender: TObject);
begin
If (lvShops.ItemIndex >= 0) and Assigned(fCurrentItem) then
  begin
    frmShopFrame.Save;
    fCurrentItem[lvShops.ItemIndex].Selected := True;
    frmShopFrame.Load;
  end;
end;

//------------------------------------------------------------------------------

procedure TfShopsForm.pmnShopsPopup(Sender: TObject);
begin
mniSH_Remove.Enabled := lvShops.ItemIndex >= 0;
mniSH_RemoveAll.Enabled := lvShops.Items.Count > 0;
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
    ShopListSelect(Index);
    ListViewItemSelected;
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
        // copy the settings from template
        fILManager.ShopTemplates[TMenuItem(Sender).Tag].CopyTo(
          fCurrentItem.Shops[lvShops.ItemIndex]);
        frmShopFrame.Load;
        frmShopFrame.leShopItemURL.SetFocus;
      end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfShopsForm.mniSH_AddFromTemplateClick(Sender: TObject);
var
  Index:  Integer;
begin
If Assigned(fCurrentItem) then
  begin
    Index := fTemplatesForm.ShowTemplates(nil);
    frmShopFrame.Load(True);  // only refill templates list
    BuildAddFromSubMenu;    
    If Index >= 0 then
      begin
        mniSH_AddCommon;
        If lvShops.ItemIndex >= 0 then  // should be valid after mniSH_AddCommon, but to be sure
          begin
            fILManager.ShopTemplates[Index].CopyTo(fCurrentItem.Shops[lvShops.ItemIndex]);
            frmShopFrame.Load;
            frmShopFrame.leShopItemURL.SetFocus;
          end;
      end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfShopsForm.mniSH_RemoveClick(Sender: TObject);
var
  Index:  Integer;
begin
If Assigned(fCurrentItem) and (lvShops.ItemIndex >= 0) then
  If MessageDlg(IL_Format('Are you sure you want to remove shop "%s"?',
      [fCurrentItem.Shops[lvShops.ItemIndex].Name]),
      mtConfirmation,[mbYes,mbNo],0) = mrYes then
    begin
      If lvShops.ItemIndex < Pred(lvShops.Items.Count) then
        Index := lvShops.ItemIndex
      else If lvShops.ItemIndex > 0 then
        Index := lvShops.ItemIndex - 1
      else
        Index := -1;
      frmShopFrame.SetItemShop(nil,False);
      fCurrentItem.ShopDelete(lvShops.ItemIndex);
      ShopListSelect(Index);
      ListViewItemSelected;
    end;
end;

//------------------------------------------------------------------------------

procedure TfShopsForm.mniSH_RemoveAllClick(Sender: TObject);
begin
If Assigned(fCurrentItem) and (lvShops.Items.Count > 0) then
  If MessageDlg('Are you sure you want to remove all shops?',mtWarning,[mbYes,mbNo],0) = mrYes then
    begin
      frmShopFrame.SetItemShop(nil,False);
      fCurrentItem.ShopClear;
      lvShops.Items.Clear;
      ShopListSelect(-1);
      ListViewItemSelected;
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
    ShopListSelect(Index - 1);
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
    ShopListSelect(Index + 1);
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
        frmShopFrame.Save;
        SetLength(Temp,fCurrentItem.ShopCount);
        For i := Low(Temp) to High(Temp) do
          begin
            Temp[i].Item := fCurrentItem;
            Temp[i].ItemTitle := IL_Format('[#%d] %s',[fCurrentItem.Index + 1,fCurrentItem.TitleStr]);
            Temp[i].ItemShop := fCurrentItem.Shops[i];
            Temp[i].Done := False;
          end;
        fUpdateForm.ShowUpdate(Temp);
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
      frmShopFrame.Save;
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
