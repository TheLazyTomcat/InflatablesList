unit OverviewForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, ExtCtrls, Spin,
  CountedDynArrayString,
  InflatablesList;

type
  TfOverviewForm = class(TForm)
    sgOverview: TStringGrid;
    cbStayOnTop: TCheckBox;
    cbAutoUpdate: TCheckBox;
    lblUpdateInterval: TLabel;
    seUpdateInterval: TSpinEdit;
    btnUpdate: TButton;
    tmrUpdate: TTimer; 
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);    
    procedure sgOverviewDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure cbStayOnTopClick(Sender: TObject);
    procedure cbAutoUpdateClick(Sender: TObject);
    procedure seUpdateIntervalChange(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
    procedure tmrUpdateTimer(Sender: TObject);
  private
    { Private declarations }
    fILManager:   TILManager;
    fSelShopList: TStringCountedDynArray;
  protected
    procedure InitializeTable;
    procedure UpdateOverview;
  public
    { Public declarations }
    procedure Initialize(ILManager: TILManager);
  end;

var
  fOverviewForm: TfOverviewForm;

implementation

{$R *.dfm}

uses
  InflatablesList_Types;

procedure TfOverviewForm.InitializeTable;
var
  i:        Integer;
  SelShop:  TILItemShop;
begin
// get list of selected shops
CDA_Clear(fSelShopList);
For i := 0 to Pred(fILManager.ItemCount) do
  If fILManager.ItemSelectedShop(fILManager[i],SelShop) then
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
        If (sgOverview.Canvas.TextWidth(sgOverview.Cells[0,1 + i]) + 10) > sgOverview.ColWidths[0] then
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
For i := 0 to Pred(fILManager.ItemCount) do
  If fILManager.ItemSelectedShop(fILManager[i],SelShop) then
    begin
      Index := CDA_IndexOf(fSelShopList,SelShop.Name);
      If CDA_CheckIndex(fSelShopList,Index) then
        begin
          // add to proper sum
          Inc(Sums[Index].Items);
          Inc(Sums[Index].Count,fILManager[i].Count);
          Inc(Sums[Index].TotalWeight,fILManager.ItemTotalWeight(fILManager[i]));
          Inc(Sums[Index].TotalPrice,SelShop.Price);
          // add to total sum
          Inc(Sums[High(Sums)].Items);
          Inc(Sums[High(Sums)].Count,fILManager[i].Count);
          Inc(Sums[High(Sums)].TotalWeight,fILManager.ItemTotalWeight(fILManager[i]));
          Inc(Sums[High(Sums)].TotalPrice,SelShop.Price);
        end;
    end;
// fill the table
For i := Low(Sums) to Pred(High(Sums)) do
  begin
    sgOverview.Cells[1,i + 1] := IntToStr(Sums[i].Items);
    sgOverview.Cells[2,i + 1] := IntToStr(Sums[i].Count);
    sgOverview.Cells[3,i + 1] := Format('%g kg',[Sums[i].TotalWeight / 1000]);
    sgOverview.Cells[4,i + 1] := Format('%d Kè',[Sums[i].TotalPrice]);
  end;
// last row (combined total)
sgOverview.Cells[1,Pred(sgOverview.RowCount)] := IntToStr(Sums[High(Sums)].Items);
sgOverview.Cells[2,Pred(sgOverview.RowCount)] := IntToStr(Sums[High(Sums)].Count);
sgOverview.Cells[3,Pred(sgOverview.RowCount)] := Format('%g kg',[Sums[High(Sums)].TotalWeight / 1000]);
sgOverview.Cells[4,Pred(sgOverview.RowCount)] := Format('%d Kè',[Sums[High(Sums)].TotalPrice]);
end;

//------------------------------------------------------------------------------

procedure TfOverviewForm.Initialize(ILManager: TILManager);
begin
fILManager := ILManager;
CDA_Init(fSelShopList);
end;

//==============================================================================

procedure TfOverviewForm.FormShow(Sender: TObject);
begin
UpdateOverview;
tmrUpdate.Interval := seUpdateInterval.Value;
tmrUpdate.Enabled := True;
end;

//------------------------------------------------------------------------------

procedure TfOverviewForm.FormHide(Sender: TObject);
begin
tmrUpdate.Enabled := False;
end;

//------------------------------------------------------------------------------

procedure TfOverviewForm.sgOverviewDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  TempInt:  Integer;
begin
If Sender is TStringGrid then
  with TStringGrid(Sender).Canvas do
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
          // normal cells
          If AnsiSameText(TStringGrid(Sender).Cells[ACol,ARow],'%') then
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
          Rectangle(Rect);
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
      // text
      Font := TStringGrid(Sender).Font;
      Brush.Style := bsClear;
      If gdFixed in State then
        begin
          // fixed cells
          If ARow = 0 then
            begin
              TempInt := ((Rect.Right - Rect.Left) - TextWidth(TStringGrid(Sender).Cells[ACol,ARow])) div 2;
              TextOut(Rect.Left + TempInt,Rect.Top + 3,TStringGrid(Sender).Cells[ACol,ARow]);
            end
          else TextOut(Rect.Left + 5,Rect.Top + 3,TStringGrid(Sender).Cells[ACol,ARow]);
        end
      else
        begin
          // normal cells
          If not AnsiSameText(TStringGrid(Sender).Cells[ACol,ARow],'%') then
            begin
              TempInt := TextWidth(TStringGrid(Sender).Cells[ACol,ARow]);
              TextOut(Rect.Right - TempInt - 5,Rect.Top + 3,TStringGrid(Sender).Cells[ACol,ARow]);
            end;
        end;
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
 
//------------------------------------------------------------------------------

procedure TfOverviewForm.cbAutoUpdateClick(Sender: TObject);
begin
// nothing implemented atm.
end;
 
//------------------------------------------------------------------------------

procedure TfOverviewForm.seUpdateIntervalChange(Sender: TObject);
begin
tmrUpdate.Interval := seUpdateInterval.Value;
end;
  
//------------------------------------------------------------------------------

procedure TfOverviewForm.btnUpdateClick(Sender: TObject);
begin
UpdateOverview;
end;
 
//------------------------------------------------------------------------------

procedure TfOverviewForm.tmrUpdateTimer(Sender: TObject);
begin
If cbAutoUpdate.Checked then
  UpdateOverview;
end;

end.
