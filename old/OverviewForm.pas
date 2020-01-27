unit OverviewForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls,
  CountedDynArrayString,
  InflatablesList_Manager;

type
  TfOverviewForm = class(TForm)
    sgOverview: TStringGrid;
    cbStayOnTop: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure sgOverviewDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure cbStayOnTopClick(Sender: TObject);
  private
    { Private declarations }
    fILManager:   TILManager;
    fSelShopList: TStringCountedDynArray;
    fDrawBuffer:  TBitmap;
  protected
    // manager event handlers
    procedure OnOverviewUpdate(Sender: TObject);
    // other methods
    procedure InitializeTable;
    procedure UpdateOverview;
  public
    { Public declarations }
    procedure Initialize(ILManager: TILManager);
    procedure Finalize;
    procedure ShowOverview;
  end;

var
  fOverviewForm: TfOverviewForm;

implementation

{$R *.dfm}

uses
  InflatablesList_Types,
  InflatablesList_Utils,
  InflatablesList_ItemShop;

procedure TfOverviewForm.OnOverviewUpdate(Sender: TObject);
begin
UpdateOverview;
end;

//------------------------------------------------------------------------------

procedure TfOverviewForm.InitializeTable;
var
  i:        Integer;
  SelShop:  TILItemShop;
begin
// get list of selected shops
CDA_Clear(fSelShopList);
For i := fILManager.ItemLowIndex to fILManager.ItemHighIndex do
  If fILManager[i].DataAccessible then
    If fILManager[i].ShopsSelected(SelShop) then
      If not CDA_CheckIndex(fSelShopList,CDA_IndexOf(fSelShopList,SelShop.Name)) then
        CDA_Add(fSelShopList,SelShop.Name);
// sort the list
CDA_Sort(fSelShopList);
// fill table
sgOverview.ColWidths[0] := 135;
sgOverview.ColWidths[1] := 70;
sgOverview.ColWidths[2] := 70;
sgOverview.ColWidths[3] := 90;
sgOverview.ColWidths[4] := 90;
sgOverview.Cells[1,0] := 'Items';
sgOverview.Cells[2,0] := 'Count';
sgOverview.Cells[3,0] := 'Total weight';
sgOverview.Cells[4,0] := 'Total price';
If CDA_Count(fSelShopList) > 0 then
  begin
    // + header, separator row and combined total
    sgOverview.RowCount := CDA_Count(fSelShopList) + 3;
    // add the shop names
    For i := CDA_Low(fSelShopList) to CDA_High(fSelShopList) do
      begin
        sgOverview.Cells[0,1 + i] := CDA_GetItem(fSelShopList,i);
        // ensure the name will fit
        If (sgOverview.Canvas.TextWidth(sgOverview.Cells[0,1 + i]) + 16) > sgOverview.ColWidths[0] then
          sgOverview.ColWidths[0] := sgOverview.Canvas.TextWidth(sgOverview.Cells[0,1 + i]) + 10;
      end;
    // separator row
    sgOverview.Cells[0,sgOverview.RowCount - 2] := '';
    For i := 1 to Pred(sgOverview.ColCount) do
      sgOverview.Cells[i,sgOverview.RowCount - 2] := '%';
    // combined total (last row)
    sgOverview.Cells[0,Pred(sgOverview.RowCount)] := 'Combined total';
  end
else
  begin
    sgOverview.RowCount := 2;
    sgOverview.Cells[0,1] := '';
    For i := 1 to Pred(sgOverview.ColCount) do
      sgOverview.Cells[i,1] := '%';
  end;
end;

//------------------------------------------------------------------------------

procedure TfOverviewForm.UpdateOverview;
var
  i,Index:  Integer;
  SelShop:  TILItemShop;
  Sums:     TILSumsArray;
begin
InitializeTable;
// do sums
SetLength(Sums,CDA_Count(fSelShopList) + 1);  // last entry is total sum
For i := fILManager.ItemLowIndex to fILManager.ItemHighIndex do
  If fILManager[i].DataAccessible then
    If fILManager[i].ShopsSelected(SelShop) then
      begin
        Index := CDA_IndexOf(fSelShopList,SelShop.Name);
        If CDA_CheckIndex(fSelShopList,Index) then
          begin
            // add to proper sum
            Inc(Sums[Index].Items);
            Inc(Sums[Index].Pieces,fILManager[i].Pieces);
            Inc(Sums[Index].TotalWeight,fILManager[i].TotalWeight);
            Inc(Sums[Index].TotalPrice,fILManager[i].TotalPrice);
            // add to total sum
            Inc(Sums[High(Sums)].Items);
            Inc(Sums[High(Sums)].Pieces,fILManager[i].Pieces);
            Inc(Sums[High(Sums)].TotalWeight,fILManager[i].TotalWeight);
            Inc(Sums[High(Sums)].TotalPrice,fILManager[i].TotalPrice);
          end;
      end;
// fill the table
For i := Low(Sums) to Pred(High(Sums)) do
  begin
    sgOverview.Cells[1,i + 1] := IntToStr(Sums[i].Items);
    sgOverview.Cells[2,i + 1] := IntToStr(Sums[i].Pieces);
    sgOverview.Cells[3,i + 1] := IL_Format('%g kg',[Sums[i].TotalWeight / 1000]);
    sgOverview.Cells[4,i + 1] := IL_Format('%d Kè',[Sums[i].TotalPrice]);
  end;
// last row (combined total)
If sgOverview.RowCount > 2 then
  begin
    sgOverview.Cells[1,Pred(sgOverview.RowCount)] := IntToStr(Sums[High(Sums)].Items);
    sgOverview.Cells[2,Pred(sgOverview.RowCount)] := IntToStr(Sums[High(Sums)].Pieces);
    sgOverview.Cells[3,Pred(sgOverview.RowCount)] := IL_Format('%g kg',[Sums[High(Sums)].TotalWeight / 1000]);
    sgOverview.Cells[4,Pred(sgOverview.RowCount)] := IL_Format('%d Kè',[Sums[High(Sums)].TotalPrice]);
  end;
end;

//------------------------------------------------------------------------------

procedure TfOverviewForm.Initialize(ILManager: TILManager);
begin
fILManager := ILManager;
fILManager.OnOverviewUpdate := OnOverviewUpdate;
CDA_Init(fSelShopList);
end;

//------------------------------------------------------------------------------

procedure TfOverviewForm.Finalize;
begin
fILManager.OnOverviewUpdate := nil;
end;

//------------------------------------------------------------------------------

procedure TfOverviewForm.ShowOverview;
begin
UpdateOverview;
Show;
BringToFront;
end;

//==============================================================================

procedure TfOverviewForm.FormCreate(Sender: TObject);
begin
fDrawBuffer := TBitmap.Create;
fDrawBuffer.PixelFormat := pf24bit;
fDrawBuffer.Canvas.Font.Assign(sgOverview.Font);
end;
 
//------------------------------------------------------------------------------

procedure TfOverviewForm.FormDestroy(Sender: TObject);
begin
FreeAndNil(fDrawBuffer);
end;

//------------------------------------------------------------------------------

procedure TfOverviewForm.sgOverviewDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  TempInt:    Integer;
  BoundsRect: TRect;
begin
If (Sender is TStringGrid) and Assigned(fDrawBuffer) then
  begin
    // adjust draw buffer size
    If fDrawBuffer.Width < (Rect.Right - Rect.Left) then
      fDrawBuffer.Width := Rect.Right - Rect.Left;
    If fDrawBuffer.Height < (Rect.Bottom - Rect.Top) then
      fDrawBuffer.Height := Rect.Bottom - Rect.Top;
    BoundsRect := Classes.Rect(0,0,Rect.Right - Rect.Left,Rect.Bottom - Rect.Top);
    with fDrawBuffer.Canvas do
      begin
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
                Rectangle(BoundsRect);
              end
            else
              begin
                TempInt := (BoundsRect.Bottom - BoundsRect.Top) div 2;
                Brush.Color := $00F0F0F0;
                Rectangle(0,0,fDrawBuffer.Width,TempInt);
                Brush.Color := $00E4E4E4;
                Rectangle(0,TempInt - 1,fDrawBuffer.Width,fDrawBuffer.Height);
              end;
          end
        else
          begin
            // normal cells
            If IL_SameText(TStringGrid(Sender).Cells[ACol,ARow],'%') then
              begin
                If gdSelected in State then
                  Brush.Color := $00D6D6D6
                else
                  Brush.Color := $00E0E0E0;
              end
            else
              begin
                If gdSelected in State then
                  Brush.Color := $00D6D6D6
                else
                  Brush.Color := clWhite;
              end;
            Rectangle(BoundsRect);
          end;
        // grid lines
        Pen.Style := psSolid;
        If gdFixed in State then
          Pen.Color := clGray
        else
          Pen.Color := clSilver;
        MoveTo(BoundsRect.Left,BoundsRect.Bottom - 1);
        LineTo(BoundsRect.Right - 1,BoundsRect.Bottom - 1);
        LineTo(BoundsRect.Right - 1,BoundsRect.Top - 1);
        // text
        Brush.Style := bsClear;
        If gdFixed in State then
          begin
            // fixed cells
            If ARow = 0 then
              begin
                TempInt := ((BoundsRect.Right - BoundsRect.Left) - TextWidth(TStringGrid(Sender).Cells[ACol,ARow])) div 2;
                TextOut(BoundsRect.Left + TempInt,BoundsRect.Top + 3,TStringGrid(Sender).Cells[ACol,ARow]);
              end
            else TextOut(BoundsRect.Left + 5,BoundsRect.Top + 3,TStringGrid(Sender).Cells[ACol,ARow]);
          end
        else
          begin
            // normal cells
            If not IL_SameText(TStringGrid(Sender).Cells[ACol,ARow],'%') then
              begin
                TempInt := TextWidth(TStringGrid(Sender).Cells[ACol,ARow]);
                TextOut(BoundsRect.Right - TempInt - 5,BoundsRect.Top + 3,TStringGrid(Sender).Cells[ACol,ARow]);
              end;
          end;
      end;
    // move drawbuffer to the canvas
    TStringGrid(Sender).Canvas.CopyRect(Rect,fDrawBuffer.Canvas,BoundsRect);
  end;
end;
 
//------------------------------------------------------------------------------

procedure TfOverviewForm.cbStayOnTopClick(Sender: TObject);
begin
If cbStayOnTop.Checked then
  FormStyle := fsStayOnTop
else
  FormStyle := fsNormal;
end;

end.
