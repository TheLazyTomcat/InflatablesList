unit SelectionForm;{$message 'revisit'}

{$INCLUDE '.\CountedDynArrays_defs.inc'}

{$DEFINE CDA_FuncOverride_ItemUnique}
{$DEFINE CDA_FuncOverride_ItemCompare}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, ComCtrls, Menus,
  AuxTypes, CountedDynArrays,
  InflatablesList_ShopSelectItemsArray,
  InflatablesList_Manager;

//-- Table declaration ---------------------------------------------------------

type
  TILSelectionShopEntry = record
    ShopName:   String;
    Items:      TILCountedDynArrayShopSelectItem;
    Available:  Integer;
    Selected:   Integer;
  end;

  TCDABaseType = TILSelectionShopEntry;
  PCDABaseType = ^TCDABaseType;

  TILCountedDynArraySelectionShops = record
  {$DEFINE CDA_Structure}
    {$INCLUDE '.\CountedDynArrays.inc'}
  {$UNDEF CDA_Structure}
  end;
  PILCountedDynArraySelectionShops = ^TILCountedDynArraySelectionShops;

  // aliases
  TILCountedDynArrayOfSelectionShops = TILCountedDynArraySelectionShops;
  PILCountedDynArrayOfSelectionShops = PILCountedDynArraySelectionShops;

  TILSelectionShopsCountedDynArray = TILCountedDynArraySelectionShops;
  PILSelectionShopsCountedDynArray = PILCountedDynArraySelectionShops;

  TCDAArrayType = TILCountedDynArraySelectionShops;
  PCDAArrayType = PILCountedDynArraySelectionShops;

{$DEFINE CDA_Interface}
{$INCLUDE '.\CountedDynArrays.inc'}
{$UNDEF CDA_Interface}

//******************************************************************************
//==============================================================================
//******************************************************************************

const
  WM_USER_LVITEMSELECTED = WM_USER + 234;

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
    fILManager:         TILManager;
    fShopTable:         TILCountedDynArraySelectionShops;
    fCurrentShopIndex:  Integer;
  protected
    procedure BuildTable;
    procedure FillShops;
    procedure FillItems;
    procedure FillItemShop;
    procedure RecountAndFillSelected;
    procedure ListViewItemSelected(var Msg: TMessage); overload; message WM_USER_LVITEMSELECTED;
    procedure ListViewItemSelected; overload;
    procedure ShopsListSelect(ItemIndex: Integer);
    procedure UpdateShopIndex;
    procedure UpdateItemIndex;
  public
    { Public declarations }
    procedure Initialize(ILManager: TILManager);
    procedure ShowSelection;
  end;

var
  fSelectionForm: TfSelectionForm;

implementation

{$R *.dfm}

uses
  ListSorters,
  InflatablesList_Utils,
  MainForm, PromptForm;

//-- Table implementation ------------------------------------------------------   

procedure CDA_ItemUnique(var Item: TCDABaseType); {$IFDEF CanInline} inline; {$ENDIF}
begin
UniqueString(Item.ShopName);
end;

//------------------------------------------------------------------------------  

Function CDA_ItemCompare(const A,B: TCDABaseType): Integer;
begin
Result := -AnsiCompareText(A.ShopName,B.ShopName);
end;

//------------------------------------------------------------------------------

{$DEFINE CDA_Implementation}
{$INCLUDE '.\CountedDynArrays.inc'}
{$UNDEF CDA_Implementation}


//******************************************************************************
//==============================================================================
//******************************************************************************

procedure TfSelectionForm.BuildTable;
var
  i,j:    Integer;
  Index:  Integer;
  Temp:   TILSelectionShopEntry;
  Entry:  TILShopSelectItemEntry;
begin
CDA_Init(fShopTable);
For i := fILManager.ItemLowIndex to fILManager.ItemHighIndex do
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
          Inc(CDA_GetItemPtr(fShopTable,Index)^.Selected);
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
  lbItems.Clear;
  If CDA_CheckIndex(fShopTable,fCurrentShopIndex) then
    For i := CDA_Low(CDA_GetItem(fShopTable,fCurrentShopIndex).Items) to
             CDA_High(CDA_GetItem(fShopTable,fCurrentShopIndex).Items) do
      lbItems.Items.Add(IntToStr(i));
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
  If CDA_CheckIndex(fShopTable,fCurrentShopIndex) then
    For i := CDA_Low(CDA_GetItem(fShopTable,fCurrentShopIndex).Items) to
             CDA_High(CDA_GetItem(fShopTable,fCurrentShopIndex).Items) do
      CDA_GetItem(CDA_GetItem(fShopTable,fCurrentShopIndex).Items,i).ItemObject.
        ReinitSmallDrawSize(Temp,lbItems.ItemHeight,lbItems.Font);
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
                Caption := Format('%s%s',[
                  IL_BoolToStr(ItemObject[i].Selected,'','*'),
                  IL_BoolToStr(ItemObject[i].Untracked,'','^')]);
                SubItems[0] := ItemObject[i].Name;
                SubItems[1] := ItemObject[i].ItemURL;
                // avail
                If ItemObject[i].Available < 0 then
                  SubItems[2] := Format('more than %d',[Abs(ItemObject[i].Available)])
                else If ItemObject[i].Available > 0 then
                  SubItems[2] := Format('%d',[Abs(ItemObject[i].Available)])
                else
                  SubItems[2] := '-';
                // price
                If ItemObject[i].Price > 0 then
                  SubItems[3] := Format('%d Kè',[ItemObject[i].Price])
                else
                  SubItems[3] := '-';
              end;
        end;
finally
  lvItemShops.Items.EndUpdate;
end;
If lvItemShops.Items.Count > 0 then
  begin
    TempStr := Format('Item shops for %s',[
      // if there is something in the list, indices were already successfully checked
      CDA_GetItem(CDA_GetItem(fShopTable,fCurrentShopIndex).Items,lbItems.ItemIndex).ItemObject.TitleStr]);
    If lvItemShops.Items.Count > 1 then
      TempStr := TempStr + Format('%s (%d)',[TempStr,lvItemShops.Items.Count]);
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
    For j := CDA_Low(CDA_GetItem(fShopTable,i).Items) to CDA_High(CDA_GetItem(fShopTable,i).Items) do
      begin
        Index := CDA_GetItem(CDA_GetItem(fShopTable,i).Items,j).ItemObject.ShopIndexOf(CDA_GetItem(fShopTable,i).ShopName);
        If Index >= 0 then
          begin
            CDA_GetItemPtr(CDA_GetItem(fShopTable,i).Items,j)^.Selected :=
              CDA_GetItem(CDA_GetItem(fShopTable,i).Items,j).ItemObject[Index].Selected;
            If CDA_GetItem(CDA_GetItem(fShopTable,i).Items,j).Selected then
              Inc(CDA_GetItemPtr(fShopTable,i)^.Selected);
          end
        else raise Exception.Create('Some wierd shit is happening...');
      end;
    lvShops.Items[i].SubItems[2] := IntToStr(CDA_GetItem(fShopTable,i).Selected);
  end;
end;

//------------------------------------------------------------------------------

procedure TfSelectionForm.ListViewItemSelected(var Msg: TMessage);
begin
If Msg.Msg = WM_USER_LVITEMSELECTED then
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
If (lvShops.ItemIndex >= 0) then
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
      lblShops.Caption := Format('Shops (%d):',[lvShops.Items.Count])
    else
      lblShops.Caption := 'Shops:';
  end
else lblShops.Caption := Format('Shops (%d/%d):',[lvShops.ItemIndex + 1,lvShops.Items.Count]);
end;

//------------------------------------------------------------------------------

procedure TfSelectionForm.UpdateItemIndex;
begin
If lbItems.ItemIndex < 0 then
  begin
    If lbItems.Items.Count > 0 then
      lblItems.Caption := Format('Items available in the selected shop (%d):',[lbItems.Items.Count])
    else
      lblItems.Caption := 'Items available in the selected shop:';
  end
else lblItems.Caption := Format('Items available in the selected shop (%d/%d):',[lbItems.ItemIndex + 1,lbItems.Items.Count]);
end;

//==============================================================================

procedure TfSelectionForm.Initialize(ILManager: TILManager);
begin
fILManager := ILManager;
end;

//------------------------------------------------------------------------------

procedure TfSelectionForm.ShowSelection;
begin
fCurrentShopIndex := -2; // must not be -1
BuildTable;
FillShops;
ShowModal;
end;

//==============================================================================

procedure TfSelectionForm.FormCreate(Sender: TObject);
begin
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

procedure TfSelectionForm.lvShopsSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
//this deffers reaction to change and prevents flickering
PostMessage(Handle,WM_USER_LVITEMSELECTED,Ord(Selected),0);
end;

//------------------------------------------------------------------------------

procedure TfSelectionForm.lbItemsDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  TempStr:  String;
begin
If CDA_CheckIndex(fShopTable,fCurrentShopIndex) then
  If CDA_CheckIndex(CDA_GetItem(fShopTable,fCurrentShopIndex).Items,Index) then
    begin
      // content
      lbItems.Canvas.Draw(Rect.Left,Rect.Top,
        CDA_GetItem(CDA_GetItem(fShopTable,fCurrentShopIndex).Items,Index).ItemObject.RenderSmall);
      // separator line
      lbItems.Canvas.Pen.Style := psSolid;
      lbItems.Canvas.Pen.Color := clSilver;
      lbItems.Canvas.MoveTo(Rect.Left,Pred(Rect.Bottom));
      lbItems.Canvas.LineTo(Rect.Right,Pred(Rect.Bottom));
      // marker
      lbItems.Canvas.Pen.Style := psClear;
      lbItems.Canvas.Brush.Style := bsSolid;
      If CDA_GetItem(CDA_GetItem(fShopTable,fCurrentShopIndex).Items,Index).Selected then
        lbItems.Canvas.Brush.Color := clBlue
      else If CDA_GetItem(CDA_GetItem(fShopTable,fCurrentShopIndex).Items,Index).Available then
        lbItems.Canvas.Brush.Color := $00D5FFD2
      else
        lbItems.Canvas.Brush.Color := $00F7F7F7;
      lbItems.Canvas.Rectangle(Rect.Left,Rect.Top,Rect.Left + 20,Rect.Bottom);
      // shop price
      TempStr := Format('%d Kè',[CDA_GetItem(CDA_GetItem(fShopTable,fCurrentShopIndex).Items,Index).Price]);
      lbItems.Canvas.Brush.Style := bsClear;
      lbItems.Canvas.Font.Style := [fsBold];
      lbItems.Canvas.Font.Color := clWindowText;
      lbItems.Canvas.Font.Size := 10;
      lbItems.Canvas.TextOut(
        Rect.Left + lbItems.ClientWidth - lbItems.Canvas.TextWidth(TempStr) - 64,
        Rect.Top + 2,TempStr);
      // states
      If odSelected	in State then
        begin
          lbItems.Canvas.Pen.Style := psClear;
          lbItems.Canvas.Brush.Style := bsSolid;
          lbItems.Canvas.Brush.Color := clLime;
          lbItems.Canvas.Rectangle(Rect.Left,Rect.Top,Rect.Left + 11,Rect.Bottom);
        end;
      If odFocused in State then
        begin
          lbItems.Canvas.Pen.Style := psDot;
          lbItems.Canvas.Pen.Color := clSilver;
          lbItems.Canvas.Brush.Style := bsClear;
          lbItems.Canvas.DrawFocusRect(Rect);
        end;
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
  ShopIndex:  Integer;
begin
If CDA_CheckIndex(fShopTable,fCurrentShopIndex) then
  If CDA_CheckIndex(CDA_GetItem(fShopTable,fCurrentShopIndex).Items,lbItems.ItemIndex) then
    with CDA_GetItemPtr(CDA_GetItem(fShopTable,fCurrentShopIndex).Items,lbItems.ItemIndex)^ do
      begin
        ShopIndex := ItemObject.ShopIndexOf(CDA_GetItem(fShopTable,fCurrentShopIndex).ShopName);
        If ShopIndex >= 0 then
          begin
            ItemObject[ShopIndex].Selected := not ItemObject[ShopIndex].Selected;
            //ItemObject.UpdatePriceAndAvail;
            Selected := ItemObject[ShopIndex].Selected;
            RecountAndFillSelected;
            FillItemShop;
            lbItems.Invalidate;            
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
        If IL_InputQuery(Format('Edit textual tag of %s',[ItemObject.TitleStr]),'Textual tag:',Temp) then
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
        If IL_InputQuery(Format('Edit numerical tag of %s',[ItemObject.TitleStr]),
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
      If (lvItemShops.ItemIndex >= ItemObject.ShopLowIndex) and
         (lvItemShops.ItemIndex <= ItemObject.ShopHighIndex) then
        IL_ShellOpen(Self.Handle,ItemObject[lvItemShops.ItemIndex].ItemURL);
end;

end.
