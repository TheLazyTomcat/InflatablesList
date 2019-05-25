unit SelectionForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids,
  CountedDynArrayString,
  InflatablesList, StdCtrls;

type
  TfSelectionForm = class(TForm)
    sgTable: TStringGrid;
    procedure sgTableDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure sgTableDblClick(Sender: TObject);
    procedure sgTableKeyPress(Sender: TObject; var Key: Char);
    procedure sgTableExit(Sender: TObject);
    procedure sgTableKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure sgTableMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure sgTableKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    fILManager:     TILManager;
    fShopList:      TStringCountedDynArray;
    fTableTracking: Boolean;
    fOldMouseX:     Integer;
    fOldMouseY:     Integer;
  protected
    procedure PrepareTable;
  public
    { Public declarations }
    procedure Initialize(ILManager: TILManager);
    procedure ShowTable;
  end;

var
  fSelectionForm: TfSelectionForm;

implementation

{$R *.dfm}

const
  IL_TABLE_TRACKSCALE_X = 10;
  IL_TABLE_TRACKSCALE_Y = 3;

procedure TfSelectionForm.PrepareTable;
var
  i,j:  Integer;
begin
// get list of all unique shops
CDA_Clear(fShopList);
For i := 0 to Pred(fILManager.ItemCount) do
  For j := Low(fILManager[i].Shops) to High(fILManager[i].Shops) do
    If not CDA_CheckIndex(fShopList,CDA_IndexOf(fShopList,fILManager[i].Shops[j].Name)) then
      CDA_Add(fShopList,fILManager[i].Shops[j].Name);
CDA_Sort(fShopList);
sgTable.ColCount := CDA_Count(fShopList) + 1;
sgTable.RowCount := fILManager.ItemCount + 1;
sgTable.DefaultColWidth := 95;
sgTable.DefaultRowHeight := 37;
sgTable.ColWidths[0] := 256;
sgTable.RowHeights[0] := 20;
// fill upper header, also ensure the shop names will fit
For i := CDA_Low(fShopList) to CDA_High(fShopList) do
  begin
    If (sgTable.Canvas.TextWidth(CDA_GetItem(fShopList,i)) + 10) > sgTable.ColWidths[i + 1] then
      sgTable.ColWidths[i + 1] := sgTable.Canvas.TextWidth(CDA_GetItem(fShopList,i)) + 10;
    sgTable.Cells[i + 1,0] := CDA_GetItem(fShopList,i);
  end;
end;

//==============================================================================

procedure TfSelectionForm.Initialize(ILManager: TILManager);
begin
fILManager := ILManager;
CDA_Init(fShopList);
end;

//------------------------------------------------------------------------------

procedure TfSelectionForm.ShowTable;
begin
fTableTracking := False;
//fILManager.ItemRedrawSmall;
PrepareTable;
ShowModal;
end;

//==============================================================================

procedure TfSelectionForm.sgTableDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  TempStr:    String;
  TempInt:    Integer;
  ShopIndex:  Integer;
begin
ShopIndex := -1;
If Sender is TDrawGrid then
  with TStringGrid(Sender).Canvas do
    If (ACol <> 0) or (ARow = 0) then
      begin
        // manual drawing
        Font := sgTable.Font;
        
        // background
        Pen.Style := psClear;
        Brush.Style := bsSolid;
        If gdFixed in State then
          begin
            // fixed cells
            If (ACol = 0) and (ARow = 0) then
              begin
                // upper left corner
                Brush.Color := $00F5B86B;
                Rectangle(Rect);
              end
            else
              begin
                TempInt := Rect.Top + ((Rect.Bottom - Rect.Top) div 2);
                Brush.Color := $00F0F0F0;
                Rectangle(Rect.Left,Rect.Top,Rect.Right,TempInt);
                Brush.Color := $00E4E4E4;
                Rectangle(Rect.Left,TempInt - 1,Rect.Right,Rect.Bottom);
              end;
          end
        else
          begin
            If (ARow > 0) and (ARow <= fILManager.ItemCount) and
               (ACol > CDA_Low(fShopList)) and ((ACol - 1) <= CDA_High(fShopList)) then
              ShopIndex := fIlManager.ItemShopIndexOf(fIlManager[ARow - 1],CDA_GetItem(fShopList,ACol - 1));
            // normal cells, select background color according to price and availability
            If ShopIndex >= 0 then
              begin
                Brush.Color := clWhite;{$message 'implement color selection'}
                Rectangle(Rect);
                // shop selected?
                If fIlManager[ARow - 1].Shops[ShopIndex].Selected then
                  Brush.Color := clBlue
                else
                  Brush.Color := $00E1E1E1;
                Rectangle(Rect.Left,Rect.Top,Rect.Left + 15,Rect.Bottom);
              end
            else
              begin
                Brush.Color := $00F8F8F8;
                Rectangle(Rect);
              end;
          end;

        // text
        Brush.Style := bsClear;
        If (ARow = 0) and (ACol > 0) then
          begin
            // upper fixed
            TempInt := ((Rect.Right - Rect.Left) - TextWidth(sgTable.Cells[ACol,ARow])) div 2;
            TextOut(Rect.Left + TempInt,Rect.Top + 3,sgTable.Cells[ACol,ARow]);
          end
        else If (ARow > 0) and (ACol > 0) then
          begin
            // std. cells
            If ShopIndex >= 0 then
              begin
                TempStr := Format('%d Kè',[fIlManager[ARow - 1].Shops[ShopIndex].Price]);
                TextOut(Rect.Right - TextWidth(TempStr) - 5,Rect.Top + 20,TempStr);
                If fIlManager[ARow - 1].Shops[ShopIndex].Available < 0 then
                  TempStr := Format('more than %d',[Abs(fIlManager[ARow - 1].Shops[ShopIndex].Available)])
                else
                  TempStr := IntToStr(fIlManager[ARow - 1].Shops[ShopIndex].Available);
                TextOut(Rect.Right - TextWidth(TempStr) - 5,Rect.Top + 3,TempStr);
              end;
          end;
          
        // grid lines
        Pen.Style := psSolid;
        If gdFixed in State then
          Pen.Color := clGray
        else
          Pen.Color := clSilver;
        MoveTo(Rect.Left,Rect.Bottom - 1);
        LineTo(Rect.Right - 1,Rect.Bottom - 1);
        LineTo(Rect.Right - 1,Rect.Top - 1);

        // selection box
        Pen.Style := psSolid;
        Brush.Style := bsClear;
        If gdSelected in State then
          begin
            Pen.Color := clAqua;
            Rectangle(Rect);
            Rectangle(Rect.Left + 1,Rect.Top + 1,Rect.Right - 1,Rect.Bottom - 1);
          end;
      end
    // items, use predrawn graphics
    else
      begin
        Pen.Style := psClear;
        Brush.Style := bsSolid;
        Brush.Color := clWhite;
        Rectangle(Rect);
      end;
end;

//------------------------------------------------------------------------------

procedure TfSelectionForm.sgTableDblClick(Sender: TObject);
begin
ShowMessage(Format('col %d  row %d',[sgTable.Col,sgTable.Row]));
sgTable.Invalidate;
end;

//------------------------------------------------------------------------------

procedure TfSelectionForm.sgTableExit(Sender: TObject);
begin
fTableTracking := False;
end;

procedure TfSelectionForm.sgTableKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
If not fTableTracking and (Key = VK_SHIFT) then
  begin
    fTableTracking := True;
    fOldMouseX := Mouse.CursorPos.X;
    fOldMouseY := Mouse.CursorPos.Y;
  end;
end;

procedure TfSelectionForm.sgTableKeyPress(Sender: TObject; var Key: Char);
begin
If Key = #32{spacebar} then
  begin
    ShowMessage(Format('col %d  row %d',[sgTable.Col,sgTable.Row]));
    sgTable.Invalidate;
  end;
end;

procedure TfSelectionForm.sgTableKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
If Key = VK_SHIFT then
  fTableTracking := False;
end;

procedure TfSelectionForm.sgTableMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  i:  Integer;

  procedure MoveLeftCol(Negative: Boolean);
  begin
    If Negative then
      begin
        If sgTable.LeftCol > sgTable.FixedCols then
          sgTable.LeftCol := sgTable.LeftCol - 1;
      end
    else
      begin
        If (sgTable.LeftCol + sgTable.VisibleColCount) < sgTable.ColCount then
          sgTable.LeftCol := sgTable.LeftCol + 1;
      end;
  end;

  procedure MoveTopRow(Negative: Boolean);
  begin
    If Negative then
      begin
        If sgTable.TopRow > sgTable.FixedRows then
          sgTable.TopRow := sgTable.TopRow - 1;
      end
    else
      begin
        If (sgTable.TopRow + sgTable.VisibleRowCount) < sgTable.RowCount then
          sgTable.TopRow := sgTable.TopRow + 1;
      end;
  end;

begin
If fTableTracking and (ssShift in Shift) then
  begin
    If Abs(X - fOldMouseX) >= IL_TABLE_TRACKSCALE_X then
      begin
        For i := 1 to (Abs(X - fOldMouseX) div IL_TABLE_TRACKSCALE_X) do
          MoveLeftCol((X - fOldMouseX) < 0);
        fOldMouseX := X;
      end; 
    If Abs(Y - fOldMouseY) >= IL_TABLE_TRACKSCALE_Y then
      begin
        For i := 1 to (Abs(Y - fOldMouseY) div IL_TABLE_TRACKSCALE_Y) do
          MoveTopRow((Y - fOldMouseY) < 0);
        fOldMouseY := Y;
      end;
  end;
end;

end.
