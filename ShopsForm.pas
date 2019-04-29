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
    lvShops: TListView;
    gbShopDetails: TGroupBox;    
    lePriceLowest: TLabeledEdit;
    lePriceSelected: TLabeledEdit;
    btnUpdateAll: TButton;
    btnUpdateHistory: TButton;
    btnClose: TButton;
    pmnShops: TPopupMenu;
    mniSH_Add: TMenuItem;
    mniSH_AddFromTemplate: TMenuItem;    
    mniSH_Remove: TMenuItem;
    N1: TMenuItem;
    mniSH_MoveUp: TMenuItem;
    mniSH_MoveDown: TMenuItem;
    frmShopFrame: TfrmShopFrame;
    procedure FormCreate(Sender: TObject);
    procedure lvShopsSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
    procedure pmnShopsPopup(Sender: TObject);
    procedure mniSH_AddCommon;
    procedure mniSH_AddClick(Sender: TObject);
    procedure mniSH_AddFromTemplateClick(Sender: TObject);
    procedure mniSH_RemoveClick(Sender: TObject);
    procedure mniSH_MoveUpClick(Sender: TObject);
    procedure mniSH_MoveDownClick(Sender: TObject);
    procedure btnUpdateAllClick(Sender: TObject);
    procedure btnUpdateHistoryClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
  private
    fILManager:   TILManager;
    fCurrentItem: TILItem;
  protected
    procedure ListViewItemSelected(var Message: TMessage); overload; message WM_LVITEMSELECTED;
    procedure ListViewItemSelected; overload;
    procedure UpdateListItem(Index: Integer);
    procedure UpdateCurrentListItem(Sender: TObject);
    procedure ClearSelected(Sender: TObject);
    procedure RecalcAndShowPrices(Sender: TObject);
  public
    procedure Initialize(ILManager: TILManager);
    procedure ShowShops(var Item: TILItem);
  end;

var
  fShopsForm: TfShopsForm;

implementation

uses
  UpdateForm, TemplatesForm;

{$R *.dfm}

procedure TfShopsForm.ListViewItemSelected(var Message: TMessage);
begin
ListViewItemSelected;
end;

//------------------------------------------------------------------------------

procedure TfShopsForm.ListViewItemSelected;
begin
If (lvShops.ItemIndex >= 0) then
  frmShopFrame.SetItemShop(Addr(fCurrentItem.Shops[lvShops.ItemIndex]),True)
else
  frmShopFrame.SetItemShop(nil,True);
end;

//------------------------------------------------------------------------------

procedure TfShopsForm.UpdateListItem(Index: Integer);
begin
If (Index >= 0) and (Index < lvShops.Items.Count) then
  begin
    lvShops.Items.BeginUpdate;
    try
      with lvShops.Items[Index] do
        begin
          If fCurrentItem.Shops[Index].Selected then
            Caption := '*'
          else
            Caption := '';
          SubItems[0] := fCurrentItem.Shops[Index].Name;
          SubItems[1] := fCurrentItem.Shops[Index].ItemURL;
          If fCurrentItem.Shops[Index].Available < 0 then
            SubItems[2] := Format('more than %d',[Abs(fCurrentItem.Shops[Index].Available)])
          else If fCurrentItem.Shops[Index].Available > 0 then
            SubItems[2] := Format('%d',[Abs(fCurrentItem.Shops[Index].Available)])
          else
            SubItems[2] := '-';
          If fCurrentItem.Shops[Index].Price > 0 then
            SubItems[3] := Format('%d Kè',[fCurrentItem.Shops[Index].Price])
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
For i := Low(fCurrentItem.Shops) to High(fCurrentItem.Shops) do
  begin
    If fCurrentItem.Shops[i].Selected then
      begin
        fCurrentItem.Shops[i].Selected := False;
        UpdateListItem(i);
      end
  end;
end;

//------------------------------------------------------------------------------

procedure TfShopsForm.RecalcAndShowPrices(Sender: TObject);
begin
fILManager.ItemUpdatePriceAndAvail(fCurrentItem);
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

//==============================================================================

procedure TfShopsForm.Initialize(ILManager: TILManager);
begin
fILManager := ILManager;
frmShopFrame.Initialize(fILManager);
end;

//------------------------------------------------------------------------------

procedure TfShopsForm.ShowShops(var Item: TILItem);
var
  i:  Integer;
begin
fILManager.ItemCopy(Item,fCurrentItem);
Caption := fILManager.ItemTitleStr(fCurrentItem) + ' - Shops';
// fill list
lvShops.Items.BeginUpdate;
try
  lvShops.Clear;
  For i := Low(fCurrentItem.Shops) to High(fCurrentItem.Shops) do
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
frmShopFrame.tcParsingStages.TabIndex := 0;
frmShopFrame.tcParsingStages.OnChange(nil);
RecalcAndShowPrices(nil);
ShowModal;                            // <----
frmShopFrame.SetItemShop(nil,True);
// update and set flags
fILManager.ItemUpdatePriceAndAvail(fCurrentItem);
fILManager.ItemFlagPriceAndAvail(fCurrentItem,Item.AvailablePieces,Item.UnitPriceSelected);
fILManager.ItemCopy(fCurrentItem,Item);
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
end;

//------------------------------------------------------------------------------

procedure TfShopsForm.lvShopsSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
begin
//this deffers reaction to change and prefers flickering
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
Index := lvShops.ItemIndex;
SetLength(fCurrentItem.Shops,Length(fCurrentItem.Shops) + 1);
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
  frmShopFrame.SetItemShop(Addr(fCurrentItem.Shops[Index]),False);
lvShops.ItemIndex := Pred(lvShops.Items.Count);
ListViewItemSelected;
end;

//------------------------------------------------------------------------------

procedure TfShopsForm.mniSH_AddClick(Sender: TObject);
begin
mniSH_AddCommon;
frmShopFrame.leShopName.SetFocus;
end;

//------------------------------------------------------------------------------

procedure TfShopsForm.mniSH_AddFromTemplateClick(Sender: TObject);
begin
mniSH_AddCommon;
If lvShops.ItemIndex >= 0 then  // should be valid after mniSH_AddCommon, but to be sure
  begin
    frmShopFrame.SaveItemShop;
    fTemplatesForm.ShowTemplates(Addr(fCurrentItem.Shops[lvShops.ItemIndex]),True);
    frmShopFrame.LoadItemShop;
    frmShopFrame.leShopItemURL.SetFocus;
  end;
UpdateCurrentListItem(nil);
end;

//------------------------------------------------------------------------------

procedure TfShopsForm.mniSH_RemoveClick(Sender: TObject);
var
  Index,i:  Integer;
begin
If lvShops.ItemIndex >= 0 then
  If MessageDlg(Format('Are you sure you want to remove shop "%s"?',
      [fCurrentItem.Shops[lvShops.ItemIndex].Name]),
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
      For i := Index to Pred(High(fCurrentItem.Shops)) do
        fCurrentItem.Shops[i] := fCurrentItem.Shops[i + 1];
      SetLength(fCurrentItem.Shops,Length(fCurrentItem.Shops) - 1);
      If lvShops.ItemIndex >= 0 then
        frmShopFrame.SetItemShop(Addr(fCurrentItem.Shops[lvShops.ItemIndex]),False);
      RecalcAndShowPrices(nil);
    end;
end;

//------------------------------------------------------------------------------

procedure TfShopsForm.mniSH_MoveUpClick(Sender: TObject);
var
  Index:  Integer;
  Temp:   TILItemShop;
begin
If lvShops.ItemIndex > 0 then
  begin
    Index := lvShops.ItemIndex;
    Temp := fCurrentItem.Shops[Index];
    fCurrentItem.Shops[Index] := fCurrentItem.Shops[Index - 1];
    fCurrentItem.Shops[Index - 1] := Temp;
    frmShopFrame.SetItemShop(Addr(fCurrentItem.Shops[Index - 1]),False);
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
  Temp:   TILItemShop;
begin
If (lvShops.ItemIndex >= 0) and (lvShops.ItemIndex < Pred(lvShops.Items.Count)) then
  begin
    Index := lvShops.ItemIndex;
    Temp := fCurrentItem.Shops[Index];
    fCurrentItem.Shops[Index] := fCurrentItem.Shops[Index + 1];
    fCurrentItem.Shops[Index + 1] := Temp;
    frmShopFrame.SetItemShop(Addr(fCurrentItem.Shops[Index + 1]),False);
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
If Length(fCurrentItem.Shops) > 0 then
  begin
    frmShopFrame.SaveItemShop;
    SetLength(Temp,Length(fCurrentItem.Shops));
    For i := Low(Temp) to High(Temp) do
      begin
        Temp[i].ItemName := Format('[#%d] %s',[i,fILManager.ItemTitleStr(fCurrentItem)]);
        Temp[i].ItemShopPtr := Addr(fCurrentItem.Shops[i]);
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

//------------------------------------------------------------------------------

procedure TfShopsForm.btnUpdateHistoryClick(Sender: TObject);
var
  i:  Integer;
begin
If Length(fCurrentItem.Shops) > 0 then
  begin
    frmShopFrame.SaveItemShop;
    For i := Low(fCurrentItem.Shops) to High(fCurrentItem.Shops) do
      fILManager.ItemUpdateShopsHistory(fCurrentItem);
    frmShopFrame.LoadItemShop;
  end;
end;

//------------------------------------------------------------------------------

procedure TfShopsForm.btnCloseClick(Sender: TObject);
begin
Close;
end;

end.
