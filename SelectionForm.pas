unit SelectionForm;

{$INCLUDE '.\CountedDynArrays_defs.inc'}

{$DEFINE CDA_FuncOverride_ItemUnique}
{$DEFINE CDA_FuncOverride_ItemCompare}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, ComCtrls, Menus,
  InflatablesList_ShopSelectItemsArray,
  InflatablesList_ShopSelectArray,
  InflatablesList_Manager;

const
  IL_WM_USER_LVITEMSELECTED = WM_USER + 234;

type
  TfSelectionForm = class(TForm)
    lvShops: TListView;
    lblShops: TLabel;
    lblItems: TLabel;
    lblItemsHint: TLabel;
    lbItems: TListBox;
    pmnItems: TPopupMenu;
    mniIT_EditTextTag: TMenuItem;
    mniIT_EditNumTag: TMenuItem;
    N1: TMenuItem;
    mniIT_EditTextTagSelected: TMenuItem;
    mniIT_EditNumTagSelected: TMenuItem;
    N2: TMenuItem;
    mniIT_EditTextTagAvailable: TMenuItem;
    mniIT_EditNumTagAvailable: TMenuItem;
    N3: TMenuItem;
    mniIT_EditTextTagAll: TMenuItem;
    mniIT_EditNumTagAll: TMenuItem;
    grbItemShops: TGroupBox;
    lvItemShops: TListView;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);    
    procedure lvShopsSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure lbItemsDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure lbItemsClick(Sender: TObject);
    procedure lbItemsDblClick(Sender: TObject);
    procedure lbItemsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pmnItemsPopup(Sender: TObject);
    procedure mniIT_EditTextTagClick(Sender: TObject);
    procedure mniIT_EditNumTagClick(Sender: TObject);
    procedure mniIT_EditTextTagSelectedClick(Sender: TObject);
    procedure mniIT_EditNumTagSelectedClick(Sender: TObject);
    procedure mniIT_EditTextTagAvailableClick(Sender: TObject);
    procedure mniIT_EditNumTagAvailableClick(Sender: TObject);
    procedure mniIT_EditTextTagAllClick(Sender: TObject);
    procedure mniIT_EditNumTagAllClick(Sender: TObject);
    procedure lvItemShopsDblClick(Sender: TObject);
  private
    { Private declarations }
    fDrawBuffer:        TBitmap;
    fILManager:         TILManager;
    fShopTable:         TILCountedDynArraySelectionShops;
    fCurrentShopIndex:  Integer;
  protected
    procedure BuildTable;
    procedure FillShops;
    procedure FillItems;
    procedure FillItemShop;
    procedure RecountAndFillSelected;
    procedure ListViewItemSelected(var Msg: TMessage); overload; message IL_WM_USER_LVITEMSELECTED;
    procedure ListViewItemSelected; overload;
    procedure ShopsListSelect(ItemIndex: Integer);
    procedure UpdateShopIndex;
    procedure UpdateItemIndex;
  public
    { Public declarations }
    procedure Initialize(ILManager: TILManager);
    procedure Finalize;
    procedure ShowSelection;
  end;

var
  fSelectionForm: TfSelectionForm;

implementation

{$R *.dfm}

uses
  InflatablesList_Utils,
  InflatablesList_Item,
  MainForm, PromptForm;

procedure TfSelectionForm.BuildTable;
var
  i,j:    Integer;
  Index:  Integer;
  Temp:   TILSelectionShopEntry;
  Entry:  TILShopSelectItemEntry;
begin
CDA_Init(fShopTable);
For i := fILManager.ItemLowIndex to fILManager.ItemHighIndex do
  If fILManager[i].DataAccessible then
    begin
      For j := fILManager[i].ShopLowIndex to fILManager[i].ShopHighIndex do
        begin
          Temp.ShopName := fILManager[i][j].Name;
          Index := CDA_IndexOf(fShopTable,Temp);
          If not CDA_CheckIndex(fShopTable,Index) then
            begin
              // shop is not in the table, add it
              CDA_Init(Temp.Items);
              Temp.Available := 0;
              Temp.Selected := 0;
              Temp.PriceOfSel := 0;
              Index := CDA_Add(fShopTable,Temp);
            end;
          Entry.ItemObject := fILManager[i];
          Entry.Available := fILManager[i][j].Available <> 0;
          Entry.Selected :=  fILManager[i][j].Selected;
          Entry.Index := i;
          Entry.Price := fILManager[i][j].Price;
          CDA_Add(CDA_GetItemPtr(fShopTable,Index)^.Items,Entry);
          If fILManager[i][j].Available <> 0 then
            Inc(CDA_GetItemPtr(fShopTable,Index)^.Available);
          If fILManager[i][j].Selected then
            begin
              Inc(CDA_GetItemPtr(fShopTable,Index)^.Selected);
              Inc(CDA_GetItemPtr(fShopTable,Index)^.PriceOfSel,fILManager[i][j].Price);
            end;
        end;
    end;
CDA_Sort(fShopTable);
For i := CDA_Low(fShopTable) to CDA_High(fShopTable) do
  CDA_Sort(CDA_GetItemPtr(fShopTable,i)^.Items);
end;

//------------------------------------------------------------------------------

procedure TfSelectionForm.FillShops;
var
  i:  Integer;
begin
lvShops.Items.BeginUpdate;
try
  lvShops.Clear;
  For i := CDA_Low(fShopTable) to CDA_High(fShopTable) do
    with lvShops.Items.Add do
      begin
        Caption := CDA_GetItem(fShopTable,i).ShopName;
        SubItems.Add(IntToStr(CDA_Count(CDA_GetItem(fShopTable,i).Items)));
        SubItems.Add(IntToStr(CDA_GetItem(fShopTable,i).Available));
        SubItems.Add(IntToStr(CDA_GetItem(fShopTable,i).Selected));
        If CDA_GetItem(fShopTable,i).PriceOfSel > 0 then
          SubItems.Add(IL_Format('%d Kè',[CDA_GetItem(fShopTable,i).PriceOfSel]))
        else
          SubItems.Add('');
      end;
finally
  lvShops.Items.EndUpdate;
end;
ShopsListSelect(0);
end;

//------------------------------------------------------------------------------

procedure TfSelectionForm.FillItems;
var
  i:        Integer;
  VScroll:  Boolean;
  Temp:     Integer;
begin
VScroll := lbItems.Count > (lbItems.ClientHeight div lbItems.ItemHeight);
lbItems.Items.BeginUpdate;
try
  CDA_Sort(CDA_GetItemPtr(fShopTable,fCurrentShopIndex)^.Items);
  lbItems.Clear;
  If CDA_CheckIndex(fShopTable,fCurrentShopIndex) then
    For i := CDA_Low(CDA_GetItem(fShopTable,fCurrentShopIndex).Items) to
             CDA_High(CDA_GetItem(fShopTable,fCurrentShopIndex).Items) do
      lbItems.Items.Add(IntToStr(i));
  // get width for drawing
  If (lbItems.Count > (lbItems.ClientHeight div lbItems.ItemHeight)) then
    begin
      If VScroll then
        Temp := lbItems.ClientWidth
      else
        Temp := lbItems.ClientWidth - GetSystemMetrics(SM_CXVSCROLL);
    end
  else
    begin
      If VScroll then
        Temp := lbItems.ClientWidth + GetSystemMetrics(SM_CXVSCROLL)
      else
        Temp := lbItems.ClientWidth;
    end;
  // reinit draw size only for items that are shown, not for everything in the list
  If CDA_CheckIndex(fShopTable,fCurrentShopIndex) then
    For i := CDA_Low(CDA_GetItem(fShopTable,fCurrentShopIndex).Items) to
             CDA_High(CDA_GetItem(fShopTable,fCurrentShopIndex).Items) do
      CDA_GetItem(CDA_GetItem(fShopTable,fCurrentShopIndex).Items,i).ItemObject.
        ReinitDrawSize(Temp,lbItems.ItemHeight,lbItems.Font);
finally
  lbItems.Items.EndUpdate;
end;
If lbItems.Count > 0 then
  lbItems.ItemIndex := 0
else
  lbItems.ItemIndex := -1;
lbItems.OnClick(nil);
lbItems.Invalidate;
end;

//------------------------------------------------------------------------------

procedure TfSelectionForm.FillItemShop;
var
  i:        Integer;
  TempStr:  String;
begin
lvItemShops.Items.BeginUpdate;
try
  lvItemShops.Clear;
  If CDA_CheckIndex(fShopTable,fCurrentShopIndex) then
    If CDA_CheckIndex(CDA_GetItem(fShopTable,fCurrentShopIndex).Items,lbItems.ItemIndex) then
      with CDA_GetItemPtr(CDA_GetItem(fShopTable,fCurrentShopIndex).Items,lbItems.ItemIndex)^ do
        begin
          // adjust count
          If lvItemShops.Items.Count < ItemObject.ShopCount then
            For i := lvItemShops.Items.Count to Pred(ItemObject.ShopCount) do
              with lvItemShops.Items.Add do
                begin
                  SubItems.Add(''); // name
                  SubItems.Add(''); // url
                  SubItems.Add(''); // avail
                  SubItems.Add(''); // price
                end
          else If lvItemShops.Items.Count > ItemObject.ShopCount then
            For i := Pred(lvItemShops.Items.Count) downto ItemObject.ShopCount do
               lvItemShops.Items.Delete(i);
          // fill the list
          For i := ItemObject.ShopLowIndex to ItemObject.ShopHighIndex do
            with lvItemShops.Items[i] do
              begin
                // don't mark worst result here, it is pointless
                Caption := IL_Format('%s%s',[
                  IL_BoolToStr(ItemObject[i].Selected,'','*'),
                  IL_BoolToStr(ItemObject[i].Untracked,'','^')]);
                SubItems[0] := ItemObject[i].Name;
                SubItems[1] := ItemObject[i].ItemURL;
                // avail
                If ItemObject[i].Available < 0 then
                  SubItems[2] := IL_Format('more than %d',[Abs(ItemObject[i].Available)])
                else If ItemObject[i].Available > 0 then
                  SubItems[2] := IL_Format('%d',[Abs(ItemObject[i].Available)])
                else
                  SubItems[2] := '-';
                // price
                If ItemObject[i].Price > 0 then
                  SubItems[3] := IL_Format('%d Kè',[ItemObject[i].Price])
                else
                  SubItems[3] := '-';
              end;
        end;
finally
  lvItemShops.Items.EndUpdate;
end;
If lvItemShops.Items.Count > 0 then
  begin
    TempStr := IL_Format('Item shops for %s',[
      // if there is something in the list, indices were already successfully checked
      CDA_GetItem(CDA_GetItem(fShopTable,fCurrentShopIndex).Items,lbItems.ItemIndex).ItemObject.TitleStr]);
    If lvItemShops.Items.Count > 1 then
      TempStr := IL_Format('%s (%d)',[TempStr,lvItemShops.Items.Count]);
  end
else TempStr := 'Item shops';
grbItemShops.Caption := TempStr;
end;

//------------------------------------------------------------------------------

procedure TfSelectionForm.RecountAndFillSelected;
var
  i,j:    Integer;
  Index:  Integer;
begin
For i := CDA_Low(fShopTable) to CDA_High(fShopTable) do
  begin
    CDA_GetItemPtr(fShopTable,i)^.Selected := 0;
    CDA_GetItemPtr(fShopTable,i)^.PriceOfSel := 0;
    For j := CDA_Low(CDA_GetItem(fShopTable,i).Items) to CDA_High(CDA_GetItem(fShopTable,i).Items) do
      begin
        Index := CDA_GetItem(CDA_GetItem(fShopTable,i).Items,j).ItemObject.ShopIndexOf(CDA_GetItem(fShopTable,i).ShopName);
        If Index >= 0 then
          begin
            CDA_GetItemPtr(CDA_GetItem(fShopTable,i).Items,j)^.Selected :=
              CDA_GetItem(CDA_GetItem(fShopTable,i).Items,j).ItemObject.Shops[Index].Selected;
            If CDA_GetItem(CDA_GetItem(fShopTable,i).Items,j).Selected then
              begin
                Inc(CDA_GetItemPtr(fShopTable,i)^.Selected);
                Inc(CDA_GetItemPtr(fShopTable,i)^.PriceOfSel,
                  CDA_GetItem(CDA_GetItem(fShopTable,i).Items,j).Price);
              end;  
          end
        else raise Exception.Create('Some weird things are happening...');
      end;
    lvShops.Items[i].SubItems[2] := IntToStr(CDA_GetItem(fShopTable,i).Selected);
    If CDA_GetItem(fShopTable,i).PriceOfSel > 0 then
      lvShops.Items[i].SubItems[3] := IL_Format('%d Kè',[CDA_GetItem(fShopTable,i).PriceOfSel])
    else
      lvShops.Items[i].SubItems[3] := '';
  end;
end;

//------------------------------------------------------------------------------

procedure TfSelectionForm.ListViewItemSelected(var Msg: TMessage);
begin
If Msg.Msg = IL_WM_USER_LVITEMSELECTED then
  ListViewItemSelected;
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

procedure TfSelectionForm.ListViewItemSelected;
begin
If lvShops.ItemIndex <> fCurrentShopIndex then
  begin
    fCurrentShopIndex := lvShops.ItemIndex;
    FillItems;
  end;
If (lvShops.ItemIndex >= 0) and Assigned(lvShops.Selected) then
  lvShops.Selected.MakeVisible(False);
UpdateShopIndex;
end;

//------------------------------------------------------------------------------

procedure TfSelectionForm.ShopsListSelect(ItemIndex: Integer);
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

procedure TfSelectionForm.UpdateShopIndex;
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

procedure TfSelectionForm.UpdateItemIndex;
begin
If lbItems.ItemIndex < 0 then
  begin
    If lbItems.Items.Count > 0 then
      lblItems.Caption := IL_Format('Items available in the selected shop (%d):',[lbItems.Items.Count])
    else
      lblItems.Caption := 'Items available in the selected shop:';
  end
else lblItems.Caption := IL_Format('Items available in the selected shop (%d/%d):',[lbItems.ItemIndex + 1,lbItems.Items.Count]);
end;

//==============================================================================

procedure TfSelectionForm.Initialize(ILManager: TILManager);
begin
fILManager := ILManager;
end;

//------------------------------------------------------------------------------

procedure TfSelectionForm.Finalize;
begin
// nothing to do here
end;

//------------------------------------------------------------------------------

procedure TfSelectionForm.ShowSelection;
begin
fCurrentShopIndex := -2; // must be below -1
BuildTable;
FillShops;
ShowModal;
end;

//==============================================================================

procedure TfSelectionForm.FormCreate(Sender: TObject);
begin
fDrawBuffer := TBitmap.Create;
fDrawBuffer.PixelFormat := pf24bit;
lvShops.DoubleBuffered := True;
lbItems.DoubleBuffered := True;
lvItemShops.DoubleBuffered := True;
end;

//------------------------------------------------------------------------------

procedure TfSelectionForm.FormShow(Sender: TObject);
begin
lvShops.SetFocus;
end;

//------------------------------------------------------------------------------

procedure TfSelectionForm.FormDestroy(Sender: TObject);
begin
FreeAndNil(fDrawBuffer);
end;

//------------------------------------------------------------------------------

procedure TfSelectionForm.lvShopsSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
//this deffers reaction to change and prevents flickering
PostMessage(Handle,IL_WM_USER_LVITEMSELECTED,Ord(Selected),0);
end;

//------------------------------------------------------------------------------

procedure TfSelectionForm.lbItemsDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  TempStr:    String;
  BoundsRect: TRect;
  TempItem:   TILShopSelectItemEntry;
begin
// draw on bitmap and then copy it using copyrect, this flickers
If CDA_CheckIndex(fShopTable,fCurrentShopIndex) and Assigned(fDrawBuffer) then
  If CDA_CheckIndex(CDA_GetItem(fShopTable,fCurrentShopIndex).Items,Index) then
    begin
      // adjust draw buffer size
      If fDrawBuffer.Width < (Rect.Right - Rect.Left) then
        fDrawBuffer.Width := Rect.Right - Rect.Left;
      If fDrawBuffer.Height < (Rect.Bottom - Rect.Top) then
        fDrawBuffer.Height := Rect.Bottom - Rect.Top;
      BoundsRect := Classes.Rect(0,0,Rect.Right - Rect.Left,Rect.Bottom - Rect.Top);

      with fDrawBuffer.Canvas do
        begin
          TempItem := CDA_GetItem(CDA_GetItem(fShopTable,fCurrentShopIndex).Items,Index);
          Font.Assign(lbItems.Font);
          
          // content
          Draw(BoundsRect.Left,BoundsRect.Top,TempItem.ItemObject.RenderSmall);

          // separator line
          Pen.Style := psSolid;
          Pen.Color := clSilver;
          MoveTo(BoundsRect.Left,Pred(BoundsRect.Bottom));
          LineTo(BoundsRect.Right,Pred(BoundsRect.Bottom));

          // marker
          Pen.Style := psClear;
          Brush.Style := bsSolid;
          If TempItem.Selected then
            Brush.Color := clBlue
          else If TempItem.Available then
            Brush.Color := $00D5FFD2
          else
            Brush.Color := $00F7F7F7;
          Rectangle(BoundsRect.Left,BoundsRect.Top,BoundsRect.Left + 20,BoundsRect.Bottom);

          // shop price
          TempStr := IL_Format('%d Kè',[TempItem.Price]);
          Brush.Style := bsClear;
          Font.Style := [fsBold];
          Font.Color := clWindowText;
          Font.Size := 10;
          TextOut(
            BoundsRect.Left + lbItems.ClientWidth - TextWidth(TempStr) - 64,
            BoundsRect.Top + 2,TempStr);

          // states
          If odSelected	in State then
            begin
              Pen.Style := psClear;
              Brush.Style := bsSolid;
              Brush.Color := clLime;
              Rectangle(BoundsRect.Left,BoundsRect.Top,BoundsRect.Left + 11,BoundsRect.Bottom);
            end;
        end;
      // move drawbuffer to the canvas
      lbItems.Canvas.CopyRect(Rect,fDrawBuffer.Canvas,BoundsRect);
      // as focus rect is drawn automatically, following pretty much removes it (it looks ugly)
      If odFocused in State then
        lbItems.Canvas.DrawFocusRect(Rect);
    end;
end;

//------------------------------------------------------------------------------

procedure TfSelectionForm.lbItemsClick(Sender: TObject);
begin
UpdateItemIndex;
FillItemShop;
end;

//------------------------------------------------------------------------------

procedure TfSelectionForm.lbItemsDblClick(Sender: TObject);
var
  LocalItemObject:  TILItem;
  ShopIndex:        Integer;
begin
If CDA_CheckIndex(fShopTable,fCurrentShopIndex) then
  If CDA_CheckIndex(CDA_GetItem(fShopTable,fCurrentShopIndex).Items,lbItems.ItemIndex) then
    with CDA_GetItemPtr(CDA_GetItem(fShopTable,fCurrentShopIndex).Items,lbItems.ItemIndex)^ do
      begin
        LocalItemObject := ItemObject;
        ShopIndex := LocalItemObject.ShopIndexOf(CDA_GetItem(fShopTable,fCurrentShopIndex).ShopName);
        If ShopIndex >= 0 then
          begin
            LocalItemObject[ShopIndex].Selected := not LocalItemObject[ShopIndex].Selected;
            Selected := LocalItemObject[ShopIndex].Selected;
            CDA_Sort(CDA_GetItemPtr(fShopTable,fCurrentShopIndex)^.Items);
            RecountAndFillSelected;
            lbItems.Invalidate;
            // get new index of the double-clicked item
            lbItems.ItemIndex := CDA_IndexOfObject(CDA_GetItem(fShopTable,fCurrentShopIndex).Items,LocalItemObject);
            lbItems.OnClick(nil); // calls FillItemShop
          end;
      end;
end;

//------------------------------------------------------------------------------

procedure TfSelectionForm.lbItemsMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Index:  Integer;
begin
If Button = mbRight then
  begin
    Index := lbItems.ItemAtPos(Point(X,Y),True);
    If Index >= 0 then
      begin
        lbItems.ItemIndex := Index;
        lbItems.OnClick(nil);
      end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfSelectionForm.pmnItemsPopup(Sender: TObject);
begin
mniIT_EditTextTag.Enabled := lbItems.ItemIndex >= 0;
mniIT_EditNumTag.Enabled := lbItems.ItemIndex >= 0;
If CDA_CheckIndex(fShopTable,fCurrentShopIndex) then
  begin
    mniIT_EditTextTagSelected.Enabled := (lbItems.Count > 0) and (CDA_GetItem(fShopTable,fCurrentShopIndex).Selected > 0);
    mniIT_EditNumTagSelected.Enabled := mniIT_EditTextTagSelected.Enabled;
    mniIT_EditTextTagAvailable.Enabled := (lbItems.Count > 0) and (CDA_GetItem(fShopTable,fCurrentShopIndex).Available > 0);
    mniIT_EditNumTagAvailable.Enabled := mniIT_EditTextTagAvailable.Enabled;
    mniIT_EditTextTagAll.Enabled := (lbItems.Count > 0) and (CDA_Count(CDA_GetItem(fShopTable,fCurrentShopIndex).Items) > 0);
    mniIT_EditNumTagAll.Enabled := mniIT_EditTextTagAll.Enabled;
  end
else
  begin
    mniIT_EditTextTagSelected.Enabled := False;
    mniIT_EditNumTagSelected.Enabled := False;
    mniIT_EditTextTagAvailable.Enabled := False;
    mniIT_EditNumTagAvailable.Enabled := False;
    mniIT_EditTextTagAll.Enabled := False;
    mniIT_EditNumTagAll.Enabled := False;
  end;
end;

//------------------------------------------------------------------------------

procedure TfSelectionForm.mniIT_EditTextTagClick(Sender: TObject);
var
  Temp: String;
begin
If CDA_CheckIndex(fShopTable,fCurrentShopIndex) then
  If CDA_CheckIndex(CDA_GetItem(fShopTable,fCurrentShopIndex).Items,lbItems.ItemIndex) then
    with CDA_GetItemPtr(CDA_GetItem(fShopTable,fCurrentShopIndex).Items,lbItems.ItemIndex)^ do
      begin
        Temp := ItemObject.TextTag;
        If IL_InputQuery(IL_Format('Edit textual tag of %s',[ItemObject.TitleStr]),'Textual tag:',Temp) then
          begin
            ItemObject.TextTag := Temp;
            lbItems.Invalidate;
          end;
      end;
end;

//------------------------------------------------------------------------------

procedure TfSelectionForm.mniIT_EditNumTagClick(Sender: TObject);
var
  Temp: Integer;
begin
If CDA_CheckIndex(fShopTable,fCurrentShopIndex) then
  If CDA_CheckIndex(CDA_GetItem(fShopTable,fCurrentShopIndex).Items,lbItems.ItemIndex) then
    with CDA_GetItemPtr(CDA_GetItem(fShopTable,fCurrentShopIndex).Items,lbItems.ItemIndex)^ do
      begin
        Temp := Integer(ItemObject.NumTag);
        If IL_InputQuery(IL_Format('Edit numerical tag of %s',[ItemObject.TitleStr]),
          'Numerical tag:',Temp,fMainForm.frmItemFrame.seNumTag.MinValue,
          fMainForm.frmItemFrame.seNumTag.MaxValue) then
          begin
            ItemObject.NumTag := Temp;
            lbItems.Invalidate;
          end;
      end;
end;

//------------------------------------------------------------------------------

procedure TfSelectionForm.mniIT_EditTextTagSelectedClick(Sender: TObject);
var
  Temp: String;
  i:    Integer;
begin
// note that fCurrentShopIndex was checked on menu popup
Temp := '';
If IL_InputQuery('Edit textual tag of selected items','Textual tag:',Temp) then
  begin
    For i := CDA_Low(CDA_GetItem(fShopTable,fCurrentShopIndex).Items) to
             CDA_High(CDA_GetItem(fShopTable,fCurrentShopIndex).Items) do
      If CDA_GetItem(CDA_GetItem(fShopTable,fCurrentShopIndex).Items,i).Selected then
        CDA_GetItem(CDA_GetItem(fShopTable,fCurrentShopIndex).Items,i).ItemObject.TextTag := Temp;
    lbItems.Invalidate;
  end;  
end;
 
//------------------------------------------------------------------------------

procedure TfSelectionForm.mniIT_EditNumTagSelectedClick(Sender: TObject);
var
  Temp: Integer;
  i:    Integer;
begin
Temp := 0;
If IL_InputQuery('Edit numerical tag of selected items','Numerical tag:',Temp,
  fMainForm.frmItemFrame.seNumTag.MinValue,fMainForm.frmItemFrame.seNumTag.MaxValue) then
  begin
    For i := CDA_Low(CDA_GetItem(fShopTable,fCurrentShopIndex).Items) to
             CDA_High(CDA_GetItem(fShopTable,fCurrentShopIndex).Items) do
      If CDA_GetItem(CDA_GetItem(fShopTable,fCurrentShopIndex).Items,i).Selected then
        CDA_GetItem(CDA_GetItem(fShopTable,fCurrentShopIndex).Items,i).ItemObject.NumTag := Temp;
    lbItems.Invalidate;
  end;
end;
 
//------------------------------------------------------------------------------

procedure TfSelectionForm.mniIT_EditTextTagAvailableClick(Sender: TObject);
var
  Temp: String;
  i:    Integer;
begin
Temp := '';
If IL_InputQuery('Edit textual tag of available items','Textual tag:',Temp) then
  begin
    For i := CDA_Low(CDA_GetItem(fShopTable,fCurrentShopIndex).Items) to
             CDA_High(CDA_GetItem(fShopTable,fCurrentShopIndex).Items) do
      If CDA_GetItem(CDA_GetItem(fShopTable,fCurrentShopIndex).Items,i).Available then
        CDA_GetItem(CDA_GetItem(fShopTable,fCurrentShopIndex).Items,i).ItemObject.TextTag := Temp;
    lbItems.Invalidate;
  end;
end;
  
//------------------------------------------------------------------------------

procedure TfSelectionForm.mniIT_EditNumTagAvailableClick(Sender: TObject);
var
  Temp: Integer;
  i:    Integer;
begin
Temp := 0;
If IL_InputQuery('Edit numerical tag of available items','Numerical tag:',Temp,
  fMainForm.frmItemFrame.seNumTag.MinValue,fMainForm.frmItemFrame.seNumTag.MaxValue) then
  begin
    For i := CDA_Low(CDA_GetItem(fShopTable,fCurrentShopIndex).Items) to
             CDA_High(CDA_GetItem(fShopTable,fCurrentShopIndex).Items) do
      If CDA_GetItem(CDA_GetItem(fShopTable,fCurrentShopIndex).Items,i).Available then
        CDA_GetItem(CDA_GetItem(fShopTable,fCurrentShopIndex).Items,i).ItemObject.NumTag := Temp;
    lbItems.Invalidate;
  end;
end;
 
//------------------------------------------------------------------------------

procedure TfSelectionForm.mniIT_EditTextTagAllClick(Sender: TObject);
var
  Temp: String;
  i:    Integer;
begin
Temp := '';
If IL_InputQuery('Edit textual tag of all items','Textual tag:',Temp) then
  begin
    For i := CDA_Low(CDA_GetItem(fShopTable,fCurrentShopIndex).Items) to
             CDA_High(CDA_GetItem(fShopTable,fCurrentShopIndex).Items) do
      CDA_GetItem(CDA_GetItem(fShopTable,fCurrentShopIndex).Items,i).ItemObject.TextTag := Temp;
    lbItems.Invalidate;
  end;
end;
 
//------------------------------------------------------------------------------

procedure TfSelectionForm.mniIT_EditNumTagAllClick(Sender: TObject);
var
  Temp: Integer;
  i:    Integer;
begin
Temp := 0;
If IL_InputQuery('Edit numerical tag of all items','Numerical tag:',Temp,
  fMainForm.frmItemFrame.seNumTag.MinValue,fMainForm.frmItemFrame.seNumTag.MaxValue) then
  begin
    For i := CDA_Low(CDA_GetItem(fShopTable,fCurrentShopIndex).Items) to
             CDA_High(CDA_GetItem(fShopTable,fCurrentShopIndex).Items) do
      CDA_GetItem(CDA_GetItem(fShopTable,fCurrentShopIndex).Items,i).ItemObject.NumTag := Temp;
    lbItems.Invalidate;
  end;
end;

//------------------------------------------------------------------------------

procedure TfSelectionForm.lvItemShopsDblClick(Sender: TObject);
begin
If CDA_CheckIndex(fShopTable,fCurrentShopIndex) then
  If CDA_CheckIndex(CDA_GetItem(fShopTable,fCurrentShopIndex).Items,lbItems.ItemIndex) then
    with CDA_GetItemPtr(CDA_GetItem(fShopTable,fCurrentShopIndex).Items,lbItems.ItemIndex)^ do
      If ItemObject.CheckIndex(lvItemShops.ItemIndex) then
        IL_ShellOpen(Self.Handle,ItemObject[lvItemShops.ItemIndex].ItemURL);
end;

end.
