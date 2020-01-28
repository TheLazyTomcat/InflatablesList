unit ShopByItemsForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, CheckLst, Menus,
  InflatablesList_ShopSelectArray,
  InflatablesList_Manager;

type
  TfShopByItemsForm = class(TForm)
    lblItems: TLabel;
    clbItems: TCheckListBox;
    lblShops: TLabel;
    lvShops: TListView;
    pmnItems: TPopupMenu;
    mniSL_UnselectAll: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure clbItemsClickCheck(Sender: TObject);
    procedure clbItemsDrawItem(Control: TWinControl; aIndex: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure mniSL_UnselectAllClick(Sender: TObject);
  private
    { Private declarations }
    fDrawBuffer:  TBitmap;
    fILManager:   TILManager;
    fWorkTable:   TILCountedDynArraySelectionShops;
    procedure BuildTable;
    procedure RecountShops;
    procedure FillItems;
    procedure FillShops;
    procedure UpdateSelCount;
  public
    { Public declarations }
    procedure Initialize(ILManager: TILManager);
    procedure Finalize;
    procedure ShowSelection;
  end;

var
  fShopByItemsForm: TfShopByItemsForm;

implementation

{$R *.dfm}

uses
  InflatablesList_Utils,
  InflatablesList_ShopSelectItemsArray,
  InflatablesList_Item;

procedure TfShopByItemsForm.BuildTable;
var
  i,j:    Integer;
  Index:  Integer;
  Temp:   TILSelectionShopEntry;
  Entry:  TILShopSelectItemEntry;
begin
// enumerate existing shops by name
CDA_Init(fWorkTable);
For i := fILManager.ItemLowIndex to fILManager.ItemHighIndex do
  If fILManager[i].DataAccessible and (fILManager[i].ShopsUsefulCount > 0) then
    For j := fILManager[i].ShopLowIndex to fILManager[i].ShopHighIndex do
      begin
        Temp.ShopName := fILManager[i][j].Name;
        Index := CDA_IndexOf(fWorkTable,Temp);
        If not CDA_CheckIndex(fWorkTable,Index) then
          begin
            // shop is not in the table, add it
            CDA_Init(Temp.Items);
            Index := CDA_Add(fWorkTable,Temp);
          end;
        If fILManager[i][j].IsAvailableHere(True) then
          begin
            Entry.ItemObject := fILManager[i];
            Entry.Price := fILManager[i][j].Price;  // price of this item in this shop
            CDA_Add(CDA_GetItemPtr(fWorkTable,Index)^.Items,Entry);
          end;
      end;
CDA_Sort(fWorkTable);
end;

//------------------------------------------------------------------------------

procedure TfShopByItemsForm.RecountShops;
var
  i,j:        Integer;
  Index:      Integer;
  CheckCount: Integer;
begin
// init counters
For i := CDA_Low(fWorkTable) to CDA_High(fWorkTable) do
  with CDA_GetItemPtr(fWorkTable,i)^ do
    begin
      Selected := 0;
      PriceOfSel := 0;
    end;
// do the counting
CheckCount := 0;
For i := 0 to Pred(clbItems.Count) do
  If clbItems.Checked[i] then
    begin
      Inc(CheckCount);
      For j := CDA_Low(fWorkTable) to CDA_High(fWorkTable) do
        begin
          Index := CDA_IndexOfObject(CDA_GetItem(fWorkTable,j).Items,TILItem(clbItems.Items.Objects[i]));
          If CDA_CheckIndex(CDA_GetItem(fWorkTable,j).Items,Index) then
            with CDA_GetItemPtr(fWorkTable,j)^ do
              begin
                Inc(Selected);
                with CDA_GetItem(CDA_GetItem(fWorkTable,j).Items,Index) do
                  Inc(PriceOfSel,Price * ItemObject.Pieces);
              end;
        end;
    end;
// finalize
If CheckCount > 0 then
  begin
    For i := CDA_Low(fWorkTable) to CDA_High(fWorkTable) do
      with CDA_GetItemPtr(fWorkTable,i)^ do
        If Selected < CheckCount then
          Selected := 0;
  end
else
  begin
    // to show all shops when nothing is selected...
    For i := CDA_Low(fWorkTable) to CDA_High(fWorkTable) do
      with CDA_GetItemPtr(fWorkTable,i)^ do
        begin
          Selected := 1;
          PriceOfSel := 0;
        end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfShopByItemsForm.FillItems;
var
  i:  Integer;
begin
clbItems.Items.BeginUpdate;
try
  clbItems.Clear;
  For i := fILManager.ItemLowIndex to fILManager.ItemHighIndex do
    If fILManager[i].DataAccessible and (fILManager[i].ShopsUsefulCount > 0) then
      clbItems.AddItem(fILManager[i].TitleStr,fILManager[i]);
  For i := 0 to Pred(clbItems.Count) do
    clbItems.Checked[i] := False;
finally
  clbItems.Items.EndUpdate;
end;
end;

//------------------------------------------------------------------------------

procedure TfShopByItemsForm.FillShops;
var
  i:    Integer;
  Cntr: Integer;
begin
// count numer of shops that will be shown
Cntr := 0;
For i := CDA_Low(fWorkTable) to CDA_High(fWorkTable) do
  If CDA_GetItem(fWorkTable,i).Selected > 0 then
    Inc(Cntr);
// adjust item count
lvShops.Items.BeginUpdate;
try
  If lvShops.Items.Count < Cntr then
    begin
      For i := lvShops.Items.Count to Pred(Cntr) do
        with lvShops.Items.Add do
          SubItems.Add(''); // price
    end
  else If lvShops.Items.Count > Cntr then
    begin
      For i := Pred(lvShops.Items.Count) downto Cntr do
        lvShops.Items.Delete(i);
    end;
finally
  lvShops.Items.EndUpdate;
end;
// fill the list
Cntr := 0;
For i := CDA_Low(fWorkTable) to CDA_High(fWorkTable) do
  If (CDA_GetItem(fWorkTable,i).Selected > 0) and (Cntr < lvShops.Items.Count) then
    begin
      lvShops.Items[Cntr].Caption := CDA_GetItem(fWorkTable,i).ShopName;
      If CDA_GetItem(fWorkTable,i).PriceOfSel > 0 then
        lvShops.Items[Cntr].SubItems[0] := IL_Format('%d Kè',[CDA_GetItem(fWorkTable,i).PriceOfSel])
      else
        lvShops.Items[Cntr].SubItems[0] := '';
      Inc(Cntr);
    end;
end;

//------------------------------------------------------------------------------

procedure TfShopByItemsForm.UpdateSelCount;
var
  i,Cntr: Integer;
begin
Cntr := 0;
For i := 0 to Pred(clbItems.Count) do
  If clbItems.Checked[i] then
    Inc(Cntr);
lblItems.Caption := IL_Format('Items (%d selected):',[Cntr]);
end;

//==============================================================================

procedure TfShopByItemsForm.Initialize(ILManager: TILManager);
begin
fILManager := ILManager;
end;

//------------------------------------------------------------------------------

procedure TfShopByItemsForm.Finalize;
begin
// nothing to do
end;

//------------------------------------------------------------------------------

procedure TfShopByItemsForm.ShowSelection;
var
  i:  Integer;
begin
BuildTable;
FillItems;
RecountShops;
FillShops;
// reinit only for actually shown, not all
For i := 0 to Pred(clbItems.Count) do
  with TILItem(clbItems.Items.Objects[i]) do
    begin
      BeginUpdate;
      try
        ReinitSmallDrawSize(clbItems.ClientWidth,clbItems.ItemHeight,clbItems.Font);
        ChangeSmallStripSize(16);
      finally
        EndUpdate;
      end;
    end;
UpdateSelCount;    
ShowModal;
end;

//==============================================================================

procedure TfShopByItemsForm.FormCreate(Sender: TObject);
begin
fDrawBuffer := TBitmap.Create;
fDrawBuffer.PixelFormat := pf24bit;
fDrawBuffer.Canvas.Font.Assign(clbItems.Font);
clbItems.DoubleBuffered := True;
lvShops.DoubleBuffered := True;
end;

//------------------------------------------------------------------------------

procedure TfShopByItemsForm.FormDestroy(Sender: TObject);
begin
FreeAndNil(fDrawBuffer);
end;

//------------------------------------------------------------------------------

procedure TfShopByItemsForm.clbItemsClickCheck(Sender: TObject);
begin
RecountShops;
FillShops;
UpdateSelCount;
end;

//------------------------------------------------------------------------------

procedure TfShopByItemsForm.clbItemsDrawItem(Control: TWinControl; aIndex: Integer; Rect: TRect; State: TOwnerDrawState);
var
  BoundsRect: TRect;
  TempStr:    String;
  TempInt:    Integer;
begin
If Assigned(fDrawBuffer) then
  begin
    // adjust draw buffer size
    If fDrawBuffer.Width < Rect.Right then
      fDrawBuffer.Width := Rect.Right;
    If fDrawBuffer.Height < (Rect.Bottom - Rect.Top) then
      fDrawBuffer.Height := Rect.Bottom - Rect.Top;
    BoundsRect := Classes.Rect(0,0,Rect.Right,Rect.Bottom - Rect.Top);

    with fDrawBuffer.Canvas do
      begin
        // content
        Draw(BoundsRect.Left,BoundsRect.Top,TILItem(clbItems.Items.Objects[aIndex]).RenderSmall);
        TILItem(clbItems.Items.Objects[aIndex]).RenderSmall.Dormant;

        // separator line
        Pen.Style := psSolid;
        Pen.Color := clSilver;
        MoveTo(BoundsRect.Left,Pred(BoundsRect.Bottom));
        LineTo(BoundsRect.Right,Pred(BoundsRect.Bottom));

        // marker
        Pen.Style := psClear;
        Brush.Style := bsSolid;
        Brush.Color := $00F7F7F7;
        Rectangle(BoundsRect.Left,BoundsRect.Top,BoundsRect.Left +
          TILItem(clbItems.Items.Objects[aIndex]).SmallStrip,BoundsRect.Bottom);

        // shop price
        TempStr := IL_Format('%d Kè',[TILItem(clbItems.Items.Objects[aIndex]).UnitPrice]);
        Brush.Style := bsClear;
        Font.Style := [fsBold];
        Font.Color := clWindowText;
        Font.Size := 10;
        TextOut(BoundsRect.Right - TextWidth(TempStr) - 64,BoundsRect.Top + 2,TempStr);
        
        // states
        If odSelected	in State then
          begin
            Pen.Style := psClear;
            Brush.Style := bsSolid;
            Brush.Color := clLime;
            Rectangle(BoundsRect.Left,BoundsRect.Top,BoundsRect.Left +
              TILItem(clbItems.Items.Objects[aIndex]).SmallStrip,BoundsRect.Bottom);
          end;

        // checkbox
        Pen.Style := psSolid;
        Pen.Color := clGray;
        Brush.Style := bsSolid;
        Brush.Color := clWindow;
        TempInt := BoundsRect.Top + (clbItems.ItemHeight - 13) div 2;
        with TILItem(clbItems.Items.Objects[aIndex]) do
          begin
            Rectangle(BoundsRect.Left + 1,TempInt,BoundsRect.Left + SmallStrip - 2,TempInt + 13);
            If clbItems.Checked[aIndex] then
              begin
                Pen.Style := psClear;
                Brush.Style := bsSolid;
                Brush.Color := clBlue;
                Rectangle(BoundsRect.Left + 3,TempInt + 2,BoundsRect.Left + SmallStrip - 3,TempInt + 12);
              end;
          end;
      end;

    // move drawbuffer to the canvas
    clbItems.Canvas.CopyRect(Classes.Rect(0,Rect.Top,Rect.Right,Rect.Bottom),fDrawBuffer.Canvas,BoundsRect);

    // remove focus rect
    If odFocused in State then
      clbItems.Canvas.DrawFocusRect(Rect);
  end;
end;

//------------------------------------------------------------------------------

procedure TfShopByItemsForm.mniSL_UnselectAllClick(Sender: TObject);
var
  i:  Integer;
begin
For i := 0 to Pred(clbItems.Count) do
  clbItems.Checked[i] := False;
RecountShops;
FillShops;  
UpdateSelCount;
end;

end.
