unit SumsForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, ExtCtrls,
  CountedDynArrayString,
  InflatablesList;

type
  TfSumsForm = class(TForm)
    bgFlagFilter: TGroupBox;
    rbOpAND: TRadioButton;
    rbOpOR: TRadioButton;
    rbOpXOR: TRadioButton;
    bvlFlagsSep: TBevel;
    cbFlagOwned: TCheckBox;
    cbFlagWanted: TCheckBox;
    cbFlagOrdered: TCheckBox;
    cbFlagBoxed: TCheckBox;
    cbFlagElsewhere: TCheckBox;
    cbFlagUntested: TCheckBox;
    cbFlagTesting: TCheckBox;
    cbFlagTested: TCheckBox;
    cbFlagDamaged: TCheckBox;
    cbFlagRepaired: TCheckBox;
    cbFlagPriceChange: TCheckBox;
    cbFlagAvailChange: TCheckBox;
    cbFlagNotAvailable: TCheckBox;
    bvlLegengSep: TBevel;
    cbStateUnchecked: TCheckBox;
    cbStateChecked: TCheckBox;
    cbStateGrayed: TCheckBox;
    sbMain: TScrollBox;       
    lblSumsGrandTotal: TLabel;
    sgSumsGrandTotal: TStringGrid;
    lblSumsByType: TLabel;
    sgSumsByType: TStringGrid;
    lblSumsByManufacturer: TLabel;
    sgSumsByManufacturer: TStringGrid;
    sgSumsBySelShop: TStringGrid;
    lblSumsBySelShop: TLabel;
    lblSumsByTextTag: TLabel;
    sgSumsByTextTag: TStringGrid;
    btnClose: TButton;
    procedure CommonFilterCheckBoxClick(Sender: TObject);
    procedure CommonStateCheckBoxClick(Sender: TObject);
    procedure CommonDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure btnCloseClick(Sender: TObject);
  private
    fFillingFilter: Boolean;
    fILManager:     TILManager;
    fSelectedShops: TStringCountedDynArray;
    fTextTags:      TStringCountedDynArray;
  protected
    procedure InitializeTable_SumsGrandTotal;
    procedure InitializeTable_SumsByType;
    procedure InitializeTable_SumsByManufacturer;
    procedure InitializeTable_SumsBySelectedShop;
    procedure InitializeTable_SumsByTextTag;
    procedure RecalculateAndFill_SumsGrandTotal;
    procedure RecalculateAndFill_SumsByType;
    procedure RecalculateAndFill_SumsByManufacturer;
    procedure RecalculateAndFill_SumsBySelectedShop;
    procedure RecalculateAndFill_SumsByTextTag;
    procedure LoadFilterSettings;
    procedure SaveFilterSettings;
    procedure ReCount;
  public
    { Public declarations }
    procedure Initialize(ILManager: TILManager);
    procedure ShowSums;
  end;

var
  fSumsForm: TfSumsForm;

implementation

{$R *.dfm}

uses
  InflatablesList_Types;

procedure WriteCellValueCond(Grid: TStringGrid; Col,Row: Integer; Value: Integer; const UnitStr: String; Marked: Boolean = False); overload;
begin
If Value > 0 then
  begin
    If Length(UnitStr) > 0 then
      Grid.Cells[Col,Row] := Format('%d %s',[Value,UnitStr])
    else
      Grid.Cells[Col,Row] := IntToStr(Value);
    If Marked then
      Grid.Cells[Col,Row] := Format('%%%s',[Grid.Cells[Col,Row]]);
  end
else Grid.Cells[Col,Row] := '-';
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

procedure WriteCellValueCond(Grid: TStringGrid; Col,Row: Integer; Value: Double; const UnitStr: String; Marked: Boolean = False); overload;
begin
If Value > 0 then
  begin
    If Length(UnitStr) > 0 then
      Grid.Cells[Col,Row] := Format('%g %s',[Value,UnitStr])
    else
      Grid.Cells[Col,Row] := Format('%g',[Value]);
    If Marked then
      Grid.Cells[Col,Row] := Format('%%%s',[Grid.Cells[Col,Row]]);
  end
else Grid.Cells[Col,Row] := '-';
end;

//==============================================================================

procedure TfSumsForm.InitializeTable_SumsGrandTotal;
begin
sgSumsGrandTotal.ColWidths[0] := 66;
sgSumsGrandTotal.ColWidths[1] := 66;
sgSumsGrandTotal.ColWidths[2] := 82;
sgSumsGrandTotal.ColWidths[3] := 82;
sgSumsGrandTotal.ColWidths[4] := 114;
sgSumsGrandTotal.ColWidths[5] := 114;
sgSumsGrandTotal.ColWidths[6] := 120;
sgSumsGrandTotal.ColWidths[7] := 120;
sgSumsGrandTotal.ColWidths[8] := 88;
sgSumsGrandTotal.Cells[0,0] := 'Items';
sgSumsGrandTotal.Cells[1,0] := 'Count';
sgSumsGrandTotal.Cells[2,0] := 'Unit weight';
sgSumsGrandTotal.Cells[3,0] := 'Total weight';
sgSumsGrandTotal.Cells[4,0] := 'Unit price (lowest)';
sgSumsGrandTotal.Cells[5,0] := 'Unit price (selected)';
sgSumsGrandTotal.Cells[6,0] := 'Total price (lowest)';
sgSumsGrandTotal.Cells[7,0] := 'Total price (selected)';
sgSumsGrandTotal.Cells[8,0] := 'Total price';
end;

//------------------------------------------------------------------------------

procedure TfSumsForm.InitializeTable_SumsByType;
var
  i:  Integer;
begin
// set table size
sgSumsByType.RowCount := 10;
sgSumsByType.ColCount := Ord(High(TILItemType)) + 2;
// set fixed column
sgSumsByType.ColWidths[0] := 132;
sgSumsByType.Cells[0,0] := '';
sgSumsByType.Cells[0,1] := 'Items';
sgSumsByType.Cells[0,2] := 'Count';
sgSumsByType.Cells[0,3] := 'Unit weight';
sgSumsByType.Cells[0,4] := 'Total weight';
sgSumsByType.Cells[0,5] := 'Unit price (lowest)';
sgSumsByType.Cells[0,6] := 'Unit price (selected)';
sgSumsByType.Cells[0,7] := 'Total price (lowest)';
sgSumsByType.Cells[0,8] := 'Total price (selected)';
sgSumsByType.Cells[0,9] := 'Total price';
For i := Ord(Low(TILItemType)) to Ord(High(TILItemType)) do
  sgSumsByType.Cells[i + 1,0] := fILManager.DataProvider.GetItemTypeString(TILItemType(i));
end;

//------------------------------------------------------------------------------

procedure TfSumsForm.InitializeTable_SumsByManufacturer;
var
  i:  Integer;
begin
// set table size
sgSumsByManufacturer.RowCount := 10;
sgSumsByManufacturer.ColCount := Ord(High(TILItemManufacturer)) + 2;
// set fixed column
sgSumsByManufacturer.ColWidths[0] := 132;
sgSumsByManufacturer.Cells[0,0] := '';
sgSumsByManufacturer.Cells[0,1] := 'Items';
sgSumsByManufacturer.Cells[0,2] := 'Count';
sgSumsByManufacturer.Cells[0,3] := 'Unit weight';
sgSumsByManufacturer.Cells[0,4] := 'Total weight';
sgSumsByManufacturer.Cells[0,5] := 'Unit price (lowest)';
sgSumsByManufacturer.Cells[0,6] := 'Unit price (selected)';
sgSumsByManufacturer.Cells[0,7] := 'Total price (lowest)';
sgSumsByManufacturer.Cells[0,8] := 'Total price (selected)';
sgSumsByManufacturer.Cells[0,9] := 'Total price';
For i := Ord(Low(TILItemManufacturer)) to Ord(High(TILItemManufacturer)) do
  sgSumsByManufacturer.Cells[i + 1,0] := fILManager.DataProvider.ItemManufacturers[TILItemManufacturer(i)].Str;
end;


//------------------------------------------------------------------------------

procedure TfSumsForm.InitializeTable_SumsBySelectedShop;
var
  i:        Integer;
  SelShop:  TILITemShop;
begin
CDA_Clear(fSelectedShops);
// enumerate all unique shops (by name)
For i := 0 to Pred(fILManager.ItemCount) do
  If fILManager.ItemSelectedShop(fIlManager[i],SelShop) then
    If not fIlManager[i].FilteredOut then
      If CDA_IndexOf(fSelectedShops,SelShop.Name,False) < 0 then
        CDA_Add(fSelectedShops,SelShop.Name);
CDA_Add(fSelectedShops,'<none>'); // for items without a selected shop
// set table size
sgSumsBySelShop.RowCount := 10;
sgSumsBySelShop.ColCount := 1 + CDA_Count(fSelectedShops);
// set fixed column
sgSumsBySelShop.DefaultColWidth := 80;
sgSumsBySelShop.ColWidths[0] := 132;
sgSumsBySelShop.Cells[0,0] := '';
sgSumsBySelShop.Cells[0,1] := 'Items';
sgSumsBySelShop.Cells[0,2] := 'Count';
sgSumsBySelShop.Cells[0,3] := 'Unit weight';
sgSumsBySelShop.Cells[0,4] := 'Total weight';
sgSumsBySelShop.Cells[0,5] := 'Unit price (lowest)';
sgSumsBySelShop.Cells[0,6] := 'Unit price (selected)';
sgSumsBySelShop.Cells[0,7] := 'Total price (lowest)';
sgSumsBySelShop.Cells[0,8] := 'Total price (selected)';
sgSumsBySelShop.Cells[0,9] := 'Total price';
// add shops
For i := CDA_Low(fSelectedShops) to CDA_High(fSelectedShops) do
  begin
    sgSumsBySelShop.Cells[i + 1,0] := CDA_GetItem(fSelectedShops,i);
    // ensure the name will fit
    If sgSumsBySelShop.Canvas.TextWidth(CDA_GetItem(fSelectedShops,i)) + 10 > sgSumsBySelShop.ColWidths[i + 1] then
      sgSumsBySelShop.ColWidths[i + 1] := sgSumsBySelShop.Canvas.TextWidth(CDA_GetItem(fSelectedShops,i)) + 10;
  end;
end;

//------------------------------------------------------------------------------

procedure TfSumsForm.InitializeTable_SumsByTextTag;
var
  i:  Integer;
begin
CDA_Clear(fTextTags);
// enumerate all unique text tags, case-sensitive
For i := 0 to Pred(fILManager.ItemCount) do
  If not fIlManager[i].FilteredOut then
    If Length(fIlManager[i].TextTag) > 0 then
      If CDA_IndexOf(fTextTags,fIlManager[i].TextTag,True) < 0 then
        CDA_Add(fTextTags,fIlManager[i].TextTag);
CDA_Sort(fTextTags,False,True);
CDA_Add(fTextTags,'<none>');  // for items without a text tag
// set table size
sgSumsByTextTag.RowCount := 10;
sgSumsByTextTag.ColCount := 1 + CDA_Count(fTextTags);
// set fixed column
sgSumsByTextTag.ColWidths[0] := 132;
sgSumsByTextTag.Cells[0,0] := '';
sgSumsByTextTag.Cells[0,1] := 'Items';
sgSumsByTextTag.Cells[0,2] := 'Count';
sgSumsByTextTag.Cells[0,3] := 'Unit weight';
sgSumsByTextTag.Cells[0,4] := 'Total weight';
sgSumsByTextTag.Cells[0,5] := 'Unit price (lowest)';
sgSumsByTextTag.Cells[0,6] := 'Unit price (selected)';
sgSumsByTextTag.Cells[0,7] := 'Total price (lowest)';
sgSumsByTextTag.Cells[0,8] := 'Total price (selected)';
sgSumsByTextTag.Cells[0,9] := 'Total price';
// add tags
For i := CDA_Low(fTextTags) to CDA_High(fTextTags) do
  sgSumsByTextTag.Cells[i + 1,0] := CDA_GetItem(fTextTags,i);
end;

//------------------------------------------------------------------------------

procedure TfSumsForm.RecalculateAndFill_SumsGrandTotal;
var
  i:    Integer;
  Sums: TILSumRec;
begin
FillChar(Sums,SizeOf(TILSumRec),0);
// sum
For i := 0 to Pred(fILManager.ItemCount) do
  If not fIlManager[i].FilteredOut then
    begin
      Inc(Sums.Items);
      Inc(Sums.Count,fILManager[i].Count);
      Inc(Sums.UnitWeigth,fILManager[i].UnitWeight);
      Inc(Sums.TotalWeight,fILManager.ItemTotalWeight(fILManager[i]));
      Inc(Sums.UnitPriceLow,fILManager[i].UnitPriceLowest);
      Inc(Sums.UnitPriceSel,fILManager[i].UnitPriceSelected);
      Inc(Sums.TotalPriceLow,fILManager.ItemTotalPriceLowest(fILManager[i]));
      Inc(Sums.TotalPriceSel,fILManager.ItemTotalPriceSelected(fILManager[i]));
      Inc(Sums.TotalPrice,fILManager.ItemTotalPrice(fILManager[i]));
    end;
// fill table
WriteCellValueCond(sgSumsGrandTotal,0,1,Sums.Items,'');
WriteCellValueCond(sgSumsGrandTotal,1,1,Sums.Count,'');
WriteCellValueCond(sgSumsGrandTotal,2,1,Sums.UnitWeigth / 1000,'kg');
WriteCellValueCond(sgSumsGrandTotal,3,1,Sums.TotalWeight / 1000,'kg');
WriteCellValueCond(sgSumsGrandTotal,4,1,Sums.UnitPriceLow,'Kè');
WriteCellValueCond(sgSumsGrandTotal,5,1,Sums.UnitPriceSel,'Kè',
  (Sums.UnitPriceLow <> Sums.UnitPriceSel) and (Sums.UnitPriceSel > 0));
WriteCellValueCond(sgSumsGrandTotal,6,1,Sums.TotalPriceLow,'Kè');
WriteCellValueCond(sgSumsGrandTotal,7,1,Sums.TotalPriceSel,'Kè',
  (Sums.TotalPriceLow <> Sums.TotalPriceSel) and (Sums.TotalPriceSel > 0));
WriteCellValueCond(sgSumsGrandTotal,8,1,Sums.TotalPrice,'Kè');
end;

//------------------------------------------------------------------------------

procedure TfSumsForm.RecalculateAndFill_SumsByType;
var
  i:    Integer;
  Sums: TILSumsByType;
begin
FillChar(Sums,SizeOf(TILSumsByType),0);
// sum
For i := 0 to Pred(fILManager.ItemCount) do
  If not fIlManager[i].FilteredOut then
    begin
      Inc(Sums[fILManager[i].ItemType].Items);
      Inc(Sums[fILManager[i].ItemType].Count,fILManager[i].Count);
      Inc(Sums[fILManager[i].ItemType].UnitWeigth,fILManager[i].UnitWeight);
      Inc(Sums[fILManager[i].ItemType].TotalWeight,fILManager.ItemTotalWeight(fILManager[i]));
      Inc(Sums[fILManager[i].ItemType].UnitPriceLow,fILManager[i].UnitPriceLowest);
      Inc(Sums[fILManager[i].ItemType].UnitPriceSel,fILManager[i].UnitPriceSelected);
      Inc(Sums[fILManager[i].ItemType].TotalPriceLow,fILManager.ItemTotalPriceLowest(fILManager[i]));
      Inc(Sums[fILManager[i].ItemType].TotalPriceSel,fILManager.ItemTotalPriceSelected(fILManager[i]));
      Inc(Sums[fILManager[i].ItemType].TotalPrice,fILManager.ItemTotalPrice(fILManager[i]));
    end;
// fill table
For i := Ord(Low(Sums)) to Ord(High(Sums)) do
  begin
    WriteCellValueCond(sgSumsByType,i + 1,1,Sums[TILItemType(i)].Items,'');
    WriteCellValueCond(sgSumsByType,i + 1,2,Sums[TILItemType(i)].Count,'');
    WriteCellValueCond(sgSumsByType,i + 1,3,Sums[TILItemType(i)].UnitWeigth / 1000,'kg');
    WriteCellValueCond(sgSumsByType,i + 1,4,Sums[TILItemType(i)].TotalWeight / 1000,'kg');
    WriteCellValueCond(sgSumsByType,i + 1,5,Sums[TILItemType(i)].UnitPriceLow,'Kè');
    WriteCellValueCond(sgSumsByType,i + 1,6,Sums[TILItemType(i)].UnitPriceSel,'Kè',
      (Sums[TILItemType(i)].UnitPriceLow <> Sums[TILItemType(i)].UnitPriceSel) and (Sums[TILItemType(i)].UnitPriceSel > 0));
    WriteCellValueCond(sgSumsByType,i + 1,7,Sums[TILItemType(i)].TotalPriceLow,'Kè');
    WriteCellValueCond(sgSumsByType,i + 1,8,Sums[TILItemType(i)].TotalPriceSel,'Kè',
      (Sums[TILItemType(i)].TotalPriceLow <> Sums[TILItemType(i)].TotalPriceSel) and (Sums[TILItemType(i)].TotalPriceSel > 0));
    WriteCellValueCond(sgSumsByType,i + 1,9,Sums[TILItemType(i)].TotalPrice,'Kè');
  end;
end;

//------------------------------------------------------------------------------

procedure TfSumsForm.RecalculateAndFill_SumsByManufacturer;
var
  i:    Integer;
  Sums: TILSumsByManufacturer;
begin
FillChar(Sums,SizeOf(TILSumsByManufacturer),0);
// sum
For i := 0 to Pred(fILManager.ItemCount) do
  If not fIlManager[i].FilteredOut then
    begin
      Inc(Sums[fILManager[i].Manufacturer].Items);
      Inc(Sums[fILManager[i].Manufacturer].Count,fILManager[i].Count);
      Inc(Sums[fILManager[i].Manufacturer].UnitWeigth,fILManager[i].UnitWeight);
      Inc(Sums[fILManager[i].Manufacturer].TotalWeight,fILManager.ItemTotalWeight(fILManager[i]));
      Inc(Sums[fILManager[i].Manufacturer].UnitPriceLow,fILManager[i].UnitPriceLowest);
      Inc(Sums[fILManager[i].Manufacturer].UnitPriceSel,fILManager[i].UnitPriceSelected);
      Inc(Sums[fILManager[i].Manufacturer].TotalPriceLow,fILManager.ItemTotalPriceLowest(fILManager[i]));
      Inc(Sums[fILManager[i].Manufacturer].TotalPriceSel,fILManager.ItemTotalPriceSelected(fILManager[i]));
      Inc(Sums[fILManager[i].Manufacturer].TotalPrice,fILManager.ItemTotalPrice(fILManager[i]));
    end;
// fill table
For i := Ord(Low(Sums)) to Ord(High(Sums)) do
  begin
    WriteCellValueCond(sgSumsByManufacturer,i + 1,1,Sums[TILItemManufacturer(i)].Items,'');
    WriteCellValueCond(sgSumsByManufacturer,i + 1,2,Sums[TILItemManufacturer(i)].Count,'');
    WriteCellValueCond(sgSumsByManufacturer,i + 1,3,Sums[TILItemManufacturer(i)].UnitWeigth / 1000,'kg');
    WriteCellValueCond(sgSumsByManufacturer,i + 1,4,Sums[TILItemManufacturer(i)].TotalWeight / 1000,'kg');
    WriteCellValueCond(sgSumsByManufacturer,i + 1,5,Sums[TILItemManufacturer(i)].UnitPriceLow,'Kè');
    WriteCellValueCond(sgSumsByManufacturer,i + 1,6,Sums[TILItemManufacturer(i)].UnitPriceSel,'Kè',
      (Sums[TILItemManufacturer(i)].UnitPriceLow <> Sums[TILItemManufacturer(i)].UnitPriceSel) and (Sums[TILItemManufacturer(i)].UnitPriceSel > 0));
    WriteCellValueCond(sgSumsByManufacturer,i + 1,7,Sums[TILItemManufacturer(i)].TotalPriceLow,'Kè');
    WriteCellValueCond(sgSumsByManufacturer,i + 1,8,Sums[TILItemManufacturer(i)].TotalPriceSel,'Kè',
      (Sums[TILItemManufacturer(i)].TotalPriceLow <> Sums[TILItemManufacturer(i)].TotalPriceSel) and (Sums[TILItemManufacturer(i)].TotalPriceSel > 0));
    WriteCellValueCond(sgSumsByManufacturer,i + 1,9,Sums[TILItemManufacturer(i)].TotalPrice,'Kè');
  end;
end;

//------------------------------------------------------------------------------

procedure TfSumsForm.RecalculateAndFill_SumsBySelectedShop;
var
  i:        Integer;
  Index:    Integer;
  Sums:     TILSumsArray;
  SelShop:  TILItemShop;
begin
SetLength(Sums,CDA_Count(fSelectedShops));
// sum
For i := 0 to Pred(fILManager.ItemCount) do
  If not fIlManager[i].FilteredOut then
    begin
      Index := -1;
      If fILManager.ItemSelectedShop(fILManager[i],SelShop) then
        Index := CDA_IndexOf(fSelectedShops,SelShop.Name,False);
      If CDA_CheckIndex(fSelectedShops,Index) then
        begin
          Inc(Sums[Index].Items);
          Inc(Sums[Index].Count,fILManager[i].Count);
          Inc(Sums[Index].UnitWeigth,fILManager[i].UnitWeight);
          Inc(Sums[Index].TotalWeight,fILManager.ItemTotalWeight(fILManager[i]));
          Inc(Sums[Index].UnitPriceLow,fILManager[i].UnitPriceLowest);
          Inc(Sums[Index].UnitPriceSel,fILManager[i].UnitPriceSelected);
          Inc(Sums[Index].TotalPriceLow,fILManager.ItemTotalPriceLowest(fILManager[i]));
          Inc(Sums[Index].TotalPriceSel,fILManager.ItemTotalPriceSelected(fILManager[i]));
          Inc(Sums[Index].TotalPrice,fILManager.ItemTotalPrice(fILManager[i]));
        end
      else
        begin
          // no selected shop, add values to last
          Inc(Sums[High(Sums)].Items);
          Inc(Sums[High(Sums)].Count,fILManager[i].Count);
          Inc(Sums[High(Sums)].UnitWeigth,fILManager[i].UnitWeight);
          Inc(Sums[High(Sums)].TotalWeight,fILManager.ItemTotalWeight(fILManager[i]));
          Inc(Sums[High(Sums)].UnitPriceLow,fILManager[i].UnitPriceLowest);
          Inc(Sums[High(Sums)].UnitPriceSel,fILManager[i].UnitPriceSelected);
          Inc(Sums[High(Sums)].TotalPriceLow,fILManager.ItemTotalPriceLowest(fILManager[i]));
          Inc(Sums[High(Sums)].TotalPriceSel,fILManager.ItemTotalPriceSelected(fILManager[i]));
          Inc(Sums[High(Sums)].TotalPrice,fILManager.ItemTotalPrice(fILManager[i]));
        end;
    end;
// fill table
For i := Ord(Low(Sums)) to Ord(High(Sums)) do
  begin
    WriteCellValueCond(sgSumsBySelShop,i + 1,1,Sums[i].Items,'');
    WriteCellValueCond(sgSumsBySelShop,i + 1,2,Sums[i].Count,'');
    WriteCellValueCond(sgSumsBySelShop,i + 1,3,Sums[i].UnitWeigth / 1000,'kg');
    WriteCellValueCond(sgSumsBySelShop,i + 1,4,Sums[i].TotalWeight / 1000,'kg');
    WriteCellValueCond(sgSumsBySelShop,i + 1,5,Sums[i].UnitPriceLow,'Kè');
    WriteCellValueCond(sgSumsBySelShop,i + 1,6,Sums[i].UnitPriceSel,'Kè',
      (Sums[i].UnitPriceLow <> Sums[i].UnitPriceSel) and (Sums[i].UnitPriceSel > 0));
    WriteCellValueCond(sgSumsBySelShop,i + 1,7,Sums[i].TotalPriceLow,'Kè');
    WriteCellValueCond(sgSumsBySelShop,i + 1,8,Sums[i].TotalPriceSel,'Kè',
      (Sums[i].TotalPriceLow <> Sums[i].TotalPriceSel) and (Sums[i].TotalPriceSel > 0));
    WriteCellValueCond(sgSumsBySelShop,i + 1,9,Sums[i].TotalPrice,'Kè');
  end;
end;

//------------------------------------------------------------------------------

procedure TfSumsForm.RecalculateAndFill_SumsByTextTag;
var
  i:      Integer;
  Index:  Integer;
  Sums:   TILSumsArray;
begin
SetLength(Sums,CDA_Count(fTextTags));
// sum
For i := 0 to Pred(fILManager.ItemCount) do
  If not fIlManager[i].FilteredOut then
    begin
      Index := -1;
      If Length(fILManager[i].TextTag) > 0 then
        Index := CDA_IndexOf(fTextTags,fILManager[i].TextTag,True);
      If CDA_CheckIndex(fTextTags,Index) then
        begin
          Inc(Sums[Index].Items);
          Inc(Sums[Index].Count,fILManager[i].Count);
          Inc(Sums[Index].UnitWeigth,fILManager[i].UnitWeight);
          Inc(Sums[Index].TotalWeight,fILManager.ItemTotalWeight(fILManager[i]));
          Inc(Sums[Index].UnitPriceLow,fILManager[i].UnitPriceLowest);
          Inc(Sums[Index].UnitPriceSel,fILManager[i].UnitPriceSelected);
          Inc(Sums[Index].TotalPriceLow,fILManager.ItemTotalPriceLowest(fILManager[i]));
          Inc(Sums[Index].TotalPriceSel,fILManager.ItemTotalPriceSelected(fILManager[i]));
          Inc(Sums[Index].TotalPrice,fILManager.ItemTotalPrice(fILManager[i]));
        end
      else
        begin
          // no selected shop, add values to last
          Inc(Sums[High(Sums)].Items);
          Inc(Sums[High(Sums)].Count,fILManager[i].Count);
          Inc(Sums[High(Sums)].UnitWeigth,fILManager[i].UnitWeight);
          Inc(Sums[High(Sums)].TotalWeight,fILManager.ItemTotalWeight(fILManager[i]));
          Inc(Sums[High(Sums)].UnitPriceLow,fILManager[i].UnitPriceLowest);
          Inc(Sums[High(Sums)].UnitPriceSel,fILManager[i].UnitPriceSelected);
          Inc(Sums[High(Sums)].TotalPriceLow,fILManager.ItemTotalPriceLowest(fILManager[i]));
          Inc(Sums[High(Sums)].TotalPriceSel,fILManager.ItemTotalPriceSelected(fILManager[i]));
          Inc(Sums[High(Sums)].TotalPrice,fILManager.ItemTotalPrice(fILManager[i]));
        end;
    end;
// fill table
For i := Ord(Low(Sums)) to Ord(High(Sums)) do
  begin
    WriteCellValueCond(sgSumsByTextTag,i + 1,1,Sums[i].Items,'');
    WriteCellValueCond(sgSumsByTextTag,i + 1,2,Sums[i].Count,'');
    WriteCellValueCond(sgSumsByTextTag,i + 1,3,Sums[i].UnitWeigth / 1000,'kg');
    WriteCellValueCond(sgSumsByTextTag,i + 1,4,Sums[i].TotalWeight / 1000,'kg');
    WriteCellValueCond(sgSumsByTextTag,i + 1,5,Sums[i].UnitPriceLow,'Kè');
    WriteCellValueCond(sgSumsByTextTag,i + 1,6,Sums[i].UnitPriceSel,'Kè',
      (Sums[i].UnitPriceLow <> Sums[i].UnitPriceSel) and (Sums[i].UnitPriceSel > 0));
    WriteCellValueCond(sgSumsByTextTag,i + 1,7,Sums[i].TotalPriceLow,'Kè');
    WriteCellValueCond(sgSumsByTextTag,i + 1,8,Sums[i].TotalPriceSel,'Kè',
      (Sums[i].TotalPriceLow <> Sums[i].TotalPriceSel) and (Sums[i].TotalPriceSel > 0));
    WriteCellValueCond(sgSumsByTextTag,i + 1,9,Sums[i].TotalPrice,'Kè');
  end;
end;

//------------------------------------------------------------------------------

procedure TfSumsForm.LoadFilterSettings;

  procedure SetFlagCheckBoxState(CheckBox: TCheckBox; FlagSet, FlagClr: TILFilterFlag);
  begin
    If FlagSet in fILManager.FilterSettings.Flags then
      CheckBox.State := cbChecked
    else If FlagClr in fILManager.FilterSettings.Flags then
      CheckBox.State := cbUnchecked
    else
      CheckBox.State := cbGrayed;
  end;

begin
fFillingFilter := True;
try
  //operators
  case fILManager.FilterSettings.Operator of
    ilfoOR:   rbOpOR.Checked := True;
    ilfoXOR:  rbOpXOR.Checked := True;
  else
   {ilfoAND, ...}
    rbOpAND.Checked := True;
  end;
  // flags
  SetFlagCheckBoxState(cbFlagOwned,ilffOwnedSet,ilffOwnedClr);
  SetFlagCheckBoxState(cbFlagWanted,ilffWantedSet,ilffWantedClr);
  SetFlagCheckBoxState(cbFlagOrdered,ilffOrderedSet,ilffOrderedClr);
  SetFlagCheckBoxState(cbFlagBoxed,ilffBoxedSet,ilffBoxedClr);
  SetFlagCheckBoxState(cbFlagElsewhere,ilffElsewhereSet,ilffElsewhereClr);
  SetFlagCheckBoxState(cbFlagUntested,ilffUntestedSet,ilffUntestedClr);
  SetFlagCheckBoxState(cbFlagTesting,ilffTestingSet,ilffTestingClr);
  SetFlagCheckBoxState(cbFlagTested,ilffTestedSet,ilffTestedClr);
  SetFlagCheckBoxState(cbFlagDamaged,ilffDamagedSet,ilffDamagedClr);
  SetFlagCheckBoxState(cbFlagRepaired,ilffRepairedSet,ilffRepairedClr);
  SetFlagCheckBoxState(cbFlagPriceChange,ilffPriceChangeSet,ilffPriceChangeClr);
  SetFlagCheckBoxState(cbFlagAvailChange,ilffAvailChangeSet,ilffAvailChangeClr);
  SetFlagCheckBoxState(cbFlagNotAvailable,ilffNotAvailableSet,ilffNotAvailableClr);
finally
  fFillingFilter := False;
end;
end;

//------------------------------------------------------------------------------

procedure TfSumsForm.SaveFilterSettings;
var
  TempFilterSettings: TILFilterSettings;

  procedure GetFlagCheckBoxState(CheckBox: TCheckBox; FlagSet, FlagClr: TILFilterFlag);
  begin
    case CheckBox.State of
      cbChecked:    Include(TempFilterSettings.Flags,FlagSet);
      cbUnchecked:  Include(TempFilterSettings.Flags,FlagClr);
    else
     {cbGrayed}
     // do nothing
    end;
  end;

begin
//operators
If rbOpOR.Checked then
  TempFilterSettings.Operator := ilfoOR
else If rbOpXOR.Checked then
  TempFilterSettings.Operator := ilfoXOR
else
  TempFilterSettings.Operator := ilfoAND;
// flags
TempFilterSettings.Flags := [];
GetFlagCheckBoxState(cbFlagOwned,ilffOwnedSet,ilffOwnedClr);
GetFlagCheckBoxState(cbFlagWanted,ilffWantedSet,ilffWantedClr);
GetFlagCheckBoxState(cbFlagOrdered,ilffOrderedSet,ilffOrderedClr);
GetFlagCheckBoxState(cbFlagBoxed,ilffBoxedSet,ilffBoxedClr);
GetFlagCheckBoxState(cbFlagElsewhere,ilffElsewhereSet,ilffElsewhereClr);
GetFlagCheckBoxState(cbFlagUntested,ilffUntestedSet,ilffUntestedClr);
GetFlagCheckBoxState(cbFlagTesting,ilffTestingSet,ilffTestingClr);
GetFlagCheckBoxState(cbFlagTested,ilffTestedSet,ilffTestedClr);
GetFlagCheckBoxState(cbFlagDamaged,ilffDamagedSet,ilffDamagedClr);
GetFlagCheckBoxState(cbFlagRepaired,ilffRepairedSet,ilffRepairedClr);
GetFlagCheckBoxState(cbFlagPriceChange,ilffPriceChangeSet,ilffPriceChangeClr);
GetFlagCheckBoxState(cbFlagAvailChange,ilffAvailChangeSet,ilffAvailChangeClr);
GetFlagCheckBoxState(cbFlagNotAvailable,ilffNotAvailableSet,ilffNotAvailableClr);
fILManager.FilterSettings := TempFilterSettings;
end;

//------------------------------------------------------------------------------

procedure TfSumsForm.ReCount;
begin
InitializeTable_SumsBySelectedShop;
InitializeTable_SumsByTextTag;
RecalculateAndFill_SumsGrandTotal;
RecalculateAndFill_SumsByType;
RecalculateAndFill_SumsByManufacturer;
RecalculateAndFill_SumsBySelectedShop;
RecalculateAndFill_SumsByTextTag;
sgSumsGrandTotal.Invalidate;
sgSumsByType.Invalidate;
sgSumsByManufacturer.Invalidate;
sgSumsBySelShop.Invalidate;
sgSumsByTextTag.Invalidate;
end;

//==============================================================================

procedure TfSumsForm.Initialize(ILManager: TILManager);
begin
fFillingFilter := False;
fILManager := ILManager;
CDA_Init(fSelectedShops);
CDA_Init(fTextTags);
InitializeTable_SumsGrandTotal;
InitializeTable_SumsByType;
InitializeTable_SumsByManufacturer;
sbMain.VertScrollBar.Position := 0;
end;

//------------------------------------------------------------------------------

procedure TfSumsForm.ShowSums;
begin
// fill filter
LoadFilterSettings;
fILManager.ItemFilter;
ReCount;
ShowModal;
SaveFilterSettings;
end;

//==============================================================================

procedure TfSumsForm.CommonFilterCheckBoxClick(Sender: TObject);
begin
If not fFillingFilter then
  begin
    SaveFilterSettings;
    fILManager.ItemFilter;
    ReCount;
  end;
end;

//------------------------------------------------------------------------------

procedure TfSumsForm.CommonStateCheckBoxClick(Sender: TObject);
begin
cbStateUnchecked.State := cbUnchecked;
cbStateChecked.State := cbChecked;
cbStateGrayed.State := cbGrayed;
end;

//------------------------------------------------------------------------------

procedure TfSumsForm.CommonDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  TempInt:  Integer;
  TempStr:  String;
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
          If (ACol = 0) and (ARow = 0) and (Sender <> sgSumsGrandTotal) then
            begin
              // upper left corner
              Brush.Color := $00F5B86B;
              Rectangle(Rect);
            end
          else
            begin
              TempInt := Rect.Top + ((Rect.Bottom - Rect.Top) div 2);
              If Sender = sgSumsGrandTotal then
                begin
                  // grand totals table
                  Brush.Color := $00D7FFD8;
                  Rectangle(Rect.Left,Rect.Top,Rect.Right,TempInt);
                  Brush.Color := $0095FF98;
                end
              else
                begin
                  // other tables
                  TempInt := Rect.Top + ((Rect.Bottom - Rect.Top) div 2);
                  Brush.Color := $00F0F0F0;
                  Rectangle(Rect.Left,Rect.Top,Rect.Right,TempInt);
                  Brush.Color := $00E4E4E4;
                end;
              Rectangle(Rect.Left,TempInt - 1,Rect.Right,Rect.Bottom);                
            end;
        end
      else
        begin
          // normal cells
          If Length(TStringGrid(Sender).Cells[ACol,ARow]) > 0 then
            case TStringGrid(Sender).Cells[ACol,ARow][1] of
              '-':  If gdSelected in State then Brush.Color := $00D6D6D6
                      else Brush.Color := $00F8F8F8;
              '%':  If gdSelected in State then Brush.Color := clYellow
                      else Brush.Color := $0097FFFF;
            else
              If gdSelected in State then Brush.Color := $00D6D6D6
                else Brush.Color := clWhite;
            end
          else Brush.Color := clWhite;
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
          If Length(TStringGrid(Sender).Cells[ACol,ARow]) > 0 then
            case TStringGrid(Sender).Cells[ACol,ARow][1] of
              '-':  ; // draw nothing
              '%':  begin
                      TempStr := Copy(TStringGrid(Sender).Cells[ACol,ARow],2,Length(TStringGrid(Sender).Cells[ACol,ARow]));
                      TextOut(Rect.Right - TextWidth(TempStr) - 5,Rect.Top + 3,TempStr);
                    end;
            else
              TempInt := TextWidth(TStringGrid(Sender).Cells[ACol,ARow]);
              TextOut(Rect.Right - TempInt - 5,Rect.Top + 3,TStringGrid(Sender).Cells[ACol,ARow]);
            end;
        end;
      // focus box
      If gdFocused in State then
        begin
          Pen.Style := psDot;
          Pen.Color := clBlack;
          Brush.Style := bsClear;
          Rectangle(Rect);
        end;
    end;
end;

//------------------------------------------------------------------------------

procedure TfSumsForm.btnCloseClick(Sender: TObject);
begin
Close;
end;

end.
