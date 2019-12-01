unit ItemShopTableForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids,
  CountedDynArrayString,
  InflatablesList_ItemShop,  
  InflatablesList_Item,
  InflatablesList_Manager;

type
  TILItemShopTableRow = record
    Item:   TILItem;
    Shops:  array of TILItemShop;
  end;

  TILItemShopTable = array of TILItemShopTableRow;

  TfItemShopTableForm = class(TForm)
    dgTable: TDrawGrid;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure dgTableDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
  private
    { Private declarations }
    fDrawBuffer:  TBitmap;
    fILManager:   TILManager;
    fKnownShops:  TCountedDynArrayString;
    fTable:       TILItemShopTable;
    procedure EnumShops;
    procedure BuildTable;
    procedure FillTable;
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
  i:        Integer;
  MinWidth: Integer;
begin
dgTable.RowCount := Length(fTable) + 1;
If Length(fTable) > 0 then
  dgTable.ColCount := Length(fTable[0].Shops) + 1
else
  dgTable.ColCount := 1;
dgTable.DefaultRowHeight := 35;
dgTable.RowHeights[0] := 20;
// get default column width from shop names
MinWidth := 32;
For i := CDA_Low(fKnownShops) to CDA_High(fKnownShops) do
  If MinWidth < (dgTable.Canvas.TextWidth(CDA_GetItem(fKnownShops,i)) + 16) then
    MinWidth := dgTable.Canvas.TextWidth(CDA_GetItem(fKnownShops,i)) + 16;
dgTable.DefaultColWidth := MinWidth;
dgTable.ColWidths[0] := 300;
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

procedure TfItemShopTableForm.dgTableDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  BoundsRect: TRect;
  TempInt:    Integer;
  TempStr:    String;
  Index:      Integer;
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
        // background
        Pen.Style := psClear;
        Brush.Style := bsSolid;
        If (gdFixed in State) and ((ACol > 0) or (ARow = 0)) then
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
                // shops
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
            (*If IL_SameText(TStringGrid(Sender).Cells[ACol,ARow],'%') then
              begin
                If gdSelected in State then
                  Brush.Color := $00D6D6D6
                else
                  Brush.Color := $00E0E0E0;
              end
            else*)
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
        If (gdFixed in State) and ((ACol > 0) or (ARow = 0)) then
          Pen.Color := clGray
        else
          Pen.Color := clSilver;
        MoveTo(BoundsRect.Left,BoundsRect.Bottom - 1);
        LineTo(BoundsRect.Right - 1,BoundsRect.Bottom - 1);
        LineTo(BoundsRect.Right - 1,BoundsRect.Top - 1);

        // content
        Brush.Style := bsClear;
        If gdFixed in State then
          begin
            // header cells
            If ARow = 0 then
              begin
                If ACol > 0 then
                  begin
                    // top row - shop names
                    TempStr := CDA_GetItem(fKnownShops,Pred(ACol));
                    TempInt := ((BoundsRect.Right - BoundsRect.Left) - TextWidth(TempStr)) div 2;
                    TextOut(BoundsRect.Left + TempInt,BoundsRect.Top + 3,TempStr);
                  end;
              end
            else
              begin
                If ACol = 0 then
                  begin
                    // left column - items
                    Font.Style := Font.Style + [fsBold];
                    TextOut(BoundsRect.Left + 5,BoundsRect.Top + 2,fTable[Pred(ARow)].Item.TitleStr);
                    Font.Style := Font.Style - [fsBold];
                    TempStr := fTable[Pred(ARow)].Item.SizeStr;
                    If Length(TempStr) > 0 then
                      TextOut(BoundsRect.Left + 5,BoundsRect.Top + 17,IL_Format('%s - %s',[fTable[Pred(ARow)].Item.TypeStr,TempStr]))
                    else
                      TextOut(BoundsRect.Left + 5,BoundsRect.Top + 17,fTable[Pred(ARow)].Item.TypeStr);
                    // thumbnail
                    Index := fTable[Pred(ARow)].Item.Pictures.IndexOfItemPicture;
                    If fTable[Pred(ARow)].Item.Pictures.CheckIndex(Index) then
                      begin
                        If Assigned(fTable[Pred(ARow)].Item.Pictures[Index].ThumbnailMini) and not fILManager.StaticSettings.NoPictures then
                          Draw(BoundsRect.Right - fILManager.DataProvider.EmptyPictureMini.Width - 5,
                               BoundsRect.Top + 1,fTable[Pred(ARow)].Item.Pictures[Index].ThumbnailMini)
                        else
                          Draw(BoundsRect.Right - fILManager.DataProvider.EmptyPictureMini.Width - 5,
                               BoundsRect.Top + 1,fILManager.DataProvider.ItemDefaultPicturesMini[fTable[Pred(ARow)].Item.ItemType]);
                      end
                    else Draw(BoundsRect.Right - fILManager.DataProvider.EmptyPictureMini.Width - 5,
                              BoundsRect.Top + 1,fILManager.DataProvider.ItemDefaultPicturesMini[fTable[Pred(ARow)].Item.ItemType]);
                  end;
              end;
          end
        else
          begin
            // normal cells
            
          end;
      end;

    // move drawbuffer to the canvas
    TStringGrid(Sender).Canvas.CopyRect(Rect,fDrawBuffer.Canvas,BoundsRect);
  end;      
end;

end.
