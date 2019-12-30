unit ItemShopTableForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, Menus,
  CountedDynArrayString,
  InflatablesList_ItemShop,  
  InflatablesList_Item,
  InflatablesList_Manager;

const
  IL_ITEMSHOPTABLE_ITEMCELL_WIDTH  = 300;
  IL_ITEMSHOPTABLE_ITEMCELL_HEIGHT = 35;

type
  TILItemShopTableRow = record
    Item:   TILItem;
    Shops:  array of TILItemShop;
  end;

  TILItemShopTable = array of TILItemShopTableRow;

  TfItemShopTableForm = class(TForm)
    dgTable: TDrawGrid;
    cbCompactView: TCheckBox;
    lblSelectedInfo: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure dgTableDblClick(Sender: TObject);
    procedure dgTableSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure dgTableDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure dgTableMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);      
    procedure cbCompactViewClick(Sender: TObject);
  private
    { Private declarations }
    fDrawBuffer:  TBitmap;
    fILManager:   TILManager;
    fKnownShops:  TCountedDynArrayString;
    fTable:       TILItemShopTable;
    fTracking:    Boolean;
    fTrackPoint:  TPoint;
  protected
    // table building
    procedure EnumShops;
    procedure BuildTable;
    procedure FillTable;
    procedure AdjustTable;
    // other methods
    procedure UpdateInfo(SelCol,SelRow: Integer);
  public
    { Public declarations }
    procedure Initialize(ILManager: TILManager);
    procedure Finalize;
    procedure ShowTable;    
  end;

var
  fItemShopTableForm: TfItemShopTableForm;

implementation

{$R *.dfm}

uses
  InflatablesList_Utils;

procedure TfItemShopTableForm.EnumShops;
var
  i,j:  Integer;
begin
// enumerate shops
CDA_Clear(fKnownShops);
For i := fILManager.ItemLowIndex to fILManager.ItemHighIndex do
  If fILManager[i].DataAccessible then
    For j := fILManager[i].ShopLowIndex to fILManager[i].ShopHighIndex do
      If not CDA_CheckIndex(fKnownShops,CDA_IndexOf(fKnownShops,fILManager[i][j].Name)) then
        CDA_Add(fKnownShops,fILManager[i][j].Name);
// sort the shop list
CDA_Sort(fKnownShops);
end;

//------------------------------------------------------------------------------

procedure TfItemShopTableForm.BuildTable;
var
  i,j:    Integer;
  Index:  Integer;
begin
SetLength(fTable,fILManager.ItemCount);
For i := fILManager.ItemLowIndex to fILManager.ItemHighIndex do
  begin
    fTable[i].Item := fILManager.Items[i];
    SetLength(fTable[i].Shops,CDA_Count(fKnownShops));
    // make sure the shops array contains only lin references
    For j := Low(fTable[i].Shops) to High(fTable[i].Shops) do
      fTable[i].Shops[j] := nil;
    // fill shops by name
    For j := fTable[i].Item.ShopLowIndex to fTable[i].Item.ShopHighIndex do
      begin
        Index := CDA_IndexOf(fKnownShops,fTable[i].Item[j].Name);
        If CDA_CheckIndex(fKnownShops,Index) then
          fTable[i].Shops[Index] := fTable[i].Item[j];
      end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfItemShopTableForm.FillTable;
var
  i:          Integer;
  MinHeight:  Integer;
  TempSize:   TSize;
begin
{$message 'rework'}
dgTable.FixedRows := 0;
dgTable.FixedCols := 0;
dgTable.RowCount := 0;
dgTable.ColCount := 0;
If Length(fTable) > 0 then
  If Length(fTable[Low(fTable)].Shops) > 0 then
    begin
      dgTable.RowCount := Length(fTable) + 1;
      dgTable.ColCount := Length(fTable[0].Shops) + 1;
      dgTable.FixedRows := 1;
      dgTable.FixedCols := 1;      
      dgTable.DefaultRowHeight := IL_ITEMSHOPTABLE_ITEMCELL_HEIGHT;
      // get minimal height of the first line
      MinHeight := 0;
      For i := CDA_Low(fKnownShops) to CDA_High(fKnownShops) do
        If IL_GetRotatedTextSize(dgTable.Canvas,CDA_GetItem(fKnownShops,i),90,TempSize) then
          If MinHeight < TempSize.cy + 20 then
            MinHeight := TempSize.cy + 20;
      If MinHeight > 50 then
        dgTable.RowHeights[0] := MinHeight
      else
        dgTable.RowHeights[0] := 50;
    end;
end;

//------------------------------------------------------------------------------

procedure TfItemShopTableForm.AdjustTable;
begin
If cbCompactView.Checked then
  dgTable.DefaultColWidth := 25
else
  dgTable.DefaultColWidth := 65;
dgTable.ColWidths[0] := IL_ITEMSHOPTABLE_ITEMCELL_WIDTH;
end;

//------------------------------------------------------------------------------

procedure TfItemShopTableForm.UpdateInfo(SelCol,SelRow: Integer);
var
  Shop:     TILItemShop;
  TempStr:  String;
begin
If (dgTable.Row > 0) and (SelCol > 0) then
  begin
    If Assigned(fTable[Pred(SelRow)].Shops[Pred(SelCol)]) then
      begin
        Shop := fTable[Pred(SelRow)].Shops[Pred(SelCol)];
        If Shop.Price > 0 then
          begin
            If (Shop.Price <= fTable[Pred(SelRow)].Item.UnitPriceLowest) and (Shop.Available <> 0) then
              TempStr := ' (lowest price)'
            else If (Shop.Price >= fTable[Pred(SelRow)].Item.UnitPriceHighest) and (Shop.Available <> 0) then
              TempStr := ' (highest price)'
            else
              TempStr := '';
            If Shop.Available <> 0 then
              begin
                If Shop.Available > 0 then
                  lblSelectedInfo.Caption := IL_Format('%s %sin %s: %d pcs at %d Kè%s',
                    [fTable[Pred(SelRow)].Item.TitleStr,IL_BoolToStr(Shop.Selected,'','selected '),
                     Shop.Name,Shop.Available,Shop.Price,TempStr])
                else
                  lblSelectedInfo.Caption := IL_Format('%s %sin %s: more than %d pcs at %d Kè%s',
                    [fTable[Pred(SelRow)].Item.TitleStr,IL_BoolToStr(Shop.Selected,'','selected '),
                     Shop.Name,Abs(Shop.Available),Shop.Price,TempStr])
              end
            else lblSelectedInfo.Caption := IL_Format('%s %sin %s: %d Kè%s, not available',
                   [fTable[Pred(SelRow)].Item.TitleStr,IL_BoolToStr(Shop.Selected,'','selected '),
                    Shop.Name,Shop.Price,TempStr]);
          end
        else lblSelectedInfo.Caption := IL_Format('%s is not available in %s',
               [fTable[Pred(SelRow)].Item.TitleStr,CDA_GetItem(fKnownShops,Pred(SelCol))]);
      end
    else lblSelectedInfo.Caption := IL_Format('%s is not available in %s',
           [fTable[Pred(SelRow)].Item.TitleStr,CDA_GetItem(fKnownShops,Pred(SelCol))]);
  end
else lblSelectedInfo.Caption := '';
end;

//==============================================================================

procedure TfItemShopTableForm.Initialize(ILManager: TILManager);
begin
fILManager := ILManager;
CDA_Init(fKnownShops);
end;

//------------------------------------------------------------------------------

procedure TfItemShopTableForm.Finalize;
begin
// nothing to do here
end;

//------------------------------------------------------------------------------

procedure TfItemShopTableForm.ShowTable;
begin
EnumShops;
BuildTable;
FillTable;
AdjustTable;
UpdateInfo(dgTable.Col,dgTable.Row);
fTracking := False;
ShowModal;
end;

//==============================================================================

procedure TfItemShopTableForm.FormCreate(Sender: TObject);
begin
fDrawBuffer := TBitmap.Create;
fDrawBuffer.PixelFormat := pf24bit;
fDrawBuffer.Canvas.Font.Assign(dgTable.Font);
dgTable.DoubleBuffered := True;
end;

//------------------------------------------------------------------------------

procedure TfItemShopTableForm.FormDestroy(Sender: TObject);
begin
FreeAndNil(fDrawBuffer);
end;

//------------------------------------------------------------------------------

procedure TfItemShopTableForm.dgTableDblClick(Sender: TObject);
var
  MousePos:   TPoint;
  CellCoords: TPoint;
  i,TempInt:  Integer;
  ItemShop:   TILItemShop;
  Dummy:      Boolean;
begin
// get which cell was clicked
MousePos := dgTable.ScreenToClient(Mouse.CursorPos);
CellCoords.X := -1;
CellCoords.Y := -1;
// get column
TempInt := dgTable.ColWidths[0];  // fixed col
For i := dgTable.LeftCol to Pred(dgTable.ColCount) do
  If (MousePos.X >= TempInt) and (MousePos.X < TempInt + dgTable.ColWidths[i]) then
    begin
      CellCoords.X := i;
      Break{For i};
    end
  else Inc(TempInt,dgTable.ColWidths[i]);
// get row
TempInt := dgTable.RowHeights[0];  // fixed row
For i := dgTable.TopRow to Pred(dgTable.RowCount) do
  If (MousePos.Y >= TempInt) and (MousePos.Y < TempInt + dgTable.RowHeights[i]) then
    begin
      CellCoords.Y := i;
      Break{For i};
    end
  else Inc(TempInt,dgTable.RowHeights[i]);
// do the (un)selection  
If (CellCoords.X >= 0) and (CellCoords.Y >= 0) then
  begin
    ItemShop := fTable[Pred(CellCoords.Y)].Shops[Pred(CellCoords.X)];
    If Assigned(ItemShop) then
      ItemShop.Selected := not ItemShop.Selected;
    Dummy := True;
    dgTableSelectCell(nil,CellCoords.X,CellCoords.Y,Dummy);
    dgTable.Invalidate;    
  end
else Beep;
end;

//------------------------------------------------------------------------------

procedure TfItemShopTableForm.dgTableSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
UpdateInfo(ACol,ARow);
end;

//------------------------------------------------------------------------------

procedure TfItemShopTableForm.dgTableDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  BoundsRect: TRect;
  TempStr:    String;
  Shop:       TILItemShop;
  TempSize:   TSize;

  procedure SetBrushColors(Brush: TBrush; TrueColor,FalseColor: TColor; Switch: Boolean);
  begin
    If Switch then
      Brush.Color := TrueColor
    else
      Brush.Color := FalseColor;
  end;

begin
If (Sender is TDrawGrid) and Assigned(fDrawBuffer) then
  begin
    // adjust draw buffer size
    If fDrawBuffer.Width < (Rect.Right - Rect.Left) then
      fDrawBuffer.Width := Rect.Right - Rect.Left;
    If fDrawBuffer.Height < (Rect.Bottom - Rect.Top) then
      fDrawBuffer.Height := Rect.Bottom - Rect.Top;
    BoundsRect := Classes.Rect(0,0,Rect.Right - Rect.Left,Rect.Bottom - Rect.Top);
    with fDrawBuffer.Canvas do
      begin
        Font.Style := [];
        Pen.Style := psClear;
        Brush.Style := bsSolid;

        If gdFixed in State then
          begin // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
            If (ARow > 0) and (ACol = 0) then
              begin
                // items
                Draw(BoundsRect.Left,BoundsRect.Top,fTable[Pred(ARow)].Item.RenderMini);
                fTable[Pred(ARow)].Item.RenderMini.Dormant;
                Pen.Color := clSilver;  // for grid lines
              end
            else If (ARow = 0) and (ACol > 0) then
              begin
                // shops
                Brush.Color := $00E4E4E4;
                Rectangle(BoundsRect);
                If IL_GetRotatedTextSize(fDrawBuffer.Canvas,CDA_GetItem(fKnownShops,Pred(ACol)),90,TempSize) then
                  IL_DrawRotatedText(fDrawBuffer.Canvas,CDA_GetItem(fKnownShops,Pred(ACol)),90,
                    ((BoundsRect.Right - BoundsRect.Left) - TempSize.cx) div 2,
                    ((BoundsRect.Bottom - BoundsRect.Top) - TempSize.cy) div 2 + TempSize.cy);
                Pen.Color := clGray;
              end
            else
              begin
                // other fixed cells (upper left corner)
                Brush.Color := $00FFE8EA; // shade of blue
                Rectangle(BoundsRect);
                Pen.Color := clGray;
              end;
          end
        else    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
          begin
            // shop cells
            Shop := fTable[Pred(ARow)].Shops[Pred(ACol)];
            If Assigned(Shop) then
              begin

                // background
                If (Shop.Price > 0) and (Shop.Available <> 0) then
                  begin   
                    // valid shop
                    If Shop.Price <= fTable[Pred(ARow)].Item.UnitPriceLowest then
                      SetBrushColors(Brush,$0069FF62,$00CEFFCC,gdSelected in State)
                    else If Shop.Price >= fTable[Pred(ARow)].Item.UnitPriceHighest then
                      SetBrushColors(Brush,$003CFAFF,$00C4FEFF,gdSelected in State)
                    else
                      SetBrushColors(Brush,$00E6E6E6,clWhite,gdSelected in State);
                  end
                // invalid shop (item not available here
                else SetBrushColors(Brush,$005EBAFF,$00B7E0FF,gdSelected in State);
                Rectangle(BoundsRect);

                // text
                Brush.Style := bsClear;
                If cbCompactView.Checked then
                  begin
                    // price rotated by 90deg and without currency symbol
                    Font.Style := font.Style + [fsBold];
                    If Shop.Price > 0 then
                      TempStr := IL_Format('%d',[Shop.Price])
                    else
                      TempStr := '-';
                    If IL_GetRotatedTextSize(fDrawBuffer.Canvas,TempStr,90,TempSize) then
                      IL_DrawRotatedText(fDrawBuffer.Canvas,TempStr,90,
                        BoundsRect.Right - TempSize.cx - 1,
                        BoundsRect.Top + TempSize.cy + 2);
                  end
                else
                  begin
                    // price
                    Font.Style := Font.Style + [fsBold];
                    If Shop.Price > 0 then
                      TempStr := IL_Format('%d Kè',[Shop.Price])
                    else
                      TempStr := '-';
                    TextOut(BoundsRect.Right - TextWidth(TempStr) - 5,2,TempStr);

                    // available
                    Font.Style := font.Style - [fsBold];
                    If Shop.Available > 0 then
                      TempStr := IL_Format('%d pcs',[Shop.Available])
                    else If Shop.Available < 0 then
                      TempStr := IL_Format('%d+ pcs',[Abs(Shop.Available)])
                    else
                      TempStr := '';
                    TextOut(BoundsRect.Right - TextWidth(TempStr) - 5,18,TempStr);
                  end;

                // selection mark
                If Shop.Selected then
                  begin
                    Pen.Style := psClear;
                    Brush.Style := bsSolid;
                    Brush.Color := clBlue;
                    Rectangle(BoundsRect.Left,BoundsRect.Top,BoundsRect.Left + 10,BoundsRect.Bottom);
                  end;
                  
              end
            else
              begin
                // shop not assigned
                SetBrushColors(Brush,$00D6D6D6,$00F7F7F7,gdSelected in State);
                Rectangle(BoundsRect);
              end;
              
            Pen.Color := clSilver;
          end;  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        Pen.Style := psSolid;
        MoveTo(BoundsRect.Left,BoundsRect.Bottom - 1);
        LineTo(BoundsRect.Right - 1,BoundsRect.Bottom - 1);
        LineTo(BoundsRect.Right - 1,BoundsRect.Top - 1);
      end;
    // move drawbuffer to the canvas
    TDrawGrid(Sender).Canvas.CopyRect(Rect,fDrawBuffer.Canvas,BoundsRect);
  end;      
end;

//------------------------------------------------------------------------------

procedure TfItemShopTableForm.dgTableMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
If ssRight in Shift then
  begin
    If fTracking then
      begin
        // horizontal movement
        If Abs(fTrackPoint.X - Mouse.CursorPos.X) >= dgTable.DefaultColWidth then
          begin
            If (fTrackPoint.X - Mouse.CursorPos.X) > 0 then
              begin
                // cursor moved left
                If dgTable.LeftCol < (dgTable.ColCount - ((dgTable.ClientWidth - dgTable.ColWidths[0]) div dgTable.DefaultColWidth)) then
                  dgTable.LeftCol := dgTable.LeftCol + 1;
                fTrackPoint.X := fTrackPoint.X - dgTable.DefaultColWidth;
              end
            else
              begin
                // cursor moved right
                If dgTable.LeftCol > 1 then
                  dgTable.LeftCol := dgTable.LeftCol - 1;
                fTrackPoint.X := fTrackPoint.X + dgTable.DefaultColWidth;
              end;
          end;
        // vertical movement
        If Abs(fTrackPoint.Y - Mouse.CursorPos.Y) >= dgTable.DefaultRowHeight then
          begin
            If (fTrackPoint.Y - Mouse.CursorPos.Y) > 0 then
              begin
                // cursor moved up
                If dgTable.TopRow < (dgTable.RowCount - ((dgTable.ClientHeight - dgTable.RowHeights[0]) div dgTable.DefaultRowHeight)) then
                  dgTable.TopRow := dgTable.TopRow + 1;
                fTrackPoint.Y := fTrackPoint.Y - dgTable.DefaultRowHeight;
              end
            else
              begin
                // cursor moved down
                If dgTable.TopRow > 1 then
                  dgTable.TopRow := dgTable.TopRow - 1;
                fTrackPoint.Y := fTrackPoint.Y + dgTable.DefaultRowHeight;
              end;
          end;
      end
    else
      begin
        fTracking := True;
        fTrackPoint := Mouse.CursorPos;
      end;
  end
else fTracking := False;
end;

//------------------------------------------------------------------------------

procedure TfItemShopTableForm.cbCompactViewClick(Sender: TObject);
begin
AdjustTable;
end;

end.
