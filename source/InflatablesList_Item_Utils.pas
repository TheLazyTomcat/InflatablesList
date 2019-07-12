unit InflatablesList_Item_Utils;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  AuxTypes,
  InflatablesList_Types,
  InflatablesList_Item_Base,
  InflatablesList_ItemShop;

type
  TILItem_Utils = class(TILItem_Base)
  public
    Function TitleStr: String; virtual;
    Function TypeStr: String; virtual;
    Function IDStr: String; virtual;
    Function TotalSize: Int64; virtual;
    Function SizeStr: String; virtual;
    Function TotalWeight: UInt32; virtual;
    Function TotalWeightStr: String; virtual;
    Function UnitPrice: UInt32; virtual;
    Function TotalPriceLowest: UInt32; virtual;
    Function TotalPriceHighest: UInt32; virtual;
    Function TotalPriceSelected: UInt32; virtual;
    Function TotalPrice: UInt32; virtual;
    procedure UpdatePriceAndAvail; virtual;
    procedure FlagPriceAndAvail(OldPrice: UInt32; OldAvail: Int32); virtual;
    procedure UpdateAndFlagPriceAndAvail(OldPrice: UInt32; OldAvail: Int32); virtual;
    Function ShopsUsefulCount: Integer; virtual;
    Function ShopsUsefulRatio: Double; virtual;
    Function ShopsCountStr: String; virtual;
    Function ShopsSelected(out Shop: TILItemShop): Boolean; virtual;
    Function ShopsWorstUpdateResult: TILItemShopUpdateResult; virtual;
  end;

implementation

uses
  SysUtils;

Function TILItem_Utils.TitleStr: String;
begin
If fManufacturer = ilimOthers then
  begin
    If Length(fManufacturerStr) > 0 then
      Result := fManufacturerStr
    else
      Result :='<unknown_manuf>';
  end
else Result := fDataProvider.ItemManufacturers[fManufacturer].Str;
If Length(IDStr) <> 0 then
  begin
    If Length(Result) > 0 then
      Result := Format('%s %s',[Result,IDStr])
    else
      Result := IDStr;
  end;
end;

//------------------------------------------------------------------------------

Function TILItem_Utils.TypeStr: String;
begin
If not(fItemType in [ilitUnknown,ilitOther]) then
  begin
    If Length(fItemTypeSpec) > 0 then
      Result := Format('%s (%s)',[fDataProvider.GetItemTypeString(fItemType),fItemTypeSpec])
    else
      Result := fDataProvider.GetItemTypeString(fItemType);
  end
else
  begin
    If Length(fItemTypeSpec) > 0 then
      Result := fItemTypeSpec
    else
      Result := '<unknown_type>';
  end;
end;

//------------------------------------------------------------------------------

Function TILItem_Utils.IDStr: String;
begin
If Length(fTextID) <= 0 then
  begin
    If fID <> 0 then
      Result := IntToStr(fID)
    else
      Result := '';
  end
else Result := fTextID;
end;

//------------------------------------------------------------------------------

Function TILItem_Utils.TotalSize: Int64;
var
  szX,szY,szZ:  UInt32;
begin
If (fSizeX = 0) and ((fSizeY <> 0) or (fSizeZ <> 0)) then szX := 1
  else szX := fSizeX;
If (fSizeY = 0) and ((fSizeX <> 0) or (fSizeZ <> 0)) then szY := 1
  else szY := fSizeY;
If (fSizeZ = 0) and ((fSizeX <> 0) or (fSizeY <> 0)) then szZ := 1
  else szZ := fSizeZ;
Result := Int64(szX) * Int64(szY) * Int64(szZ);
end;

//------------------------------------------------------------------------------

Function TILItem_Utils.SizeStr: String;
begin
Result := '';
If fSizeX > 0 then
  Result := Format('%g',[fSizeX / 10]);
If fSizeY > 0 then
  begin
    If Length(Result) > 0 then
      Result := Format('%s x %g',[Result,fSizeY / 10])
    else
      Result := Format('%g',[fSizeY / 10]);
  end;
If fSizeZ > 0 then
  begin
    If Length(Result) > 0 then
      Result := Format('%s x %g',[Result,fSizeZ / 10])
    else
      Result := Format('%g',[fSizeZ / 10]);
  end;
If Length(Result) > 0 then
  Result := Format('%s cm',[Result]);
end;

//------------------------------------------------------------------------------

Function TILItem_Utils.TotalWeight: UInt32;
begin
Result := fUnitWeight * fPieces;
end;

//------------------------------------------------------------------------------

Function TILItem_Utils.TotalWeightStr: String;
begin
If TotalWeight > 0 then
  Result := Format('%g kg',[TotalWeight / 1000])
else
  Result := '';
end;

//------------------------------------------------------------------------------

Function TILItem_Utils.UnitPrice: UInt32;
begin
If fUnitPriceSelected > 0 then
  Result := fUnitPriceSelected
else
  Result := fUnitPriceDefault;
end;

//------------------------------------------------------------------------------

Function TILItem_Utils.TotalPriceLowest: UInt32;
begin
Result := fUnitPriceLowest * fPieces;
end;

//------------------------------------------------------------------------------

Function TILItem_Utils.TotalPriceHighest: UInt32;
begin
Result := fUnitPriceHighest * fPieces;
end;

//------------------------------------------------------------------------------

Function TILItem_Utils.TotalPriceSelected: UInt32;
begin
Result := fUnitPriceSelected * fPieces;
end;

//------------------------------------------------------------------------------

Function TILItem_Utils.TotalPrice: UInt32;
begin
Result := UnitPrice * fPieces;
end;

//------------------------------------------------------------------------------

procedure TILItem_Utils.UpdatePriceAndAvail;
var
  i:          Integer;
  Selected:   Boolean;
  LowPrice:   Int64;
  HighPrice:  Int64;
  LowAvail:   Int64;
  HighAvail:  Int64;

  Function AvailIsLess(A,B: Int32): Boolean;
  begin
    If Abs(A) = Abs(B) then
      Result := B > 0
    else
      Result := Abs(A) < Abs(B);
  end;

  Function AvailIsMore(A,B: Int32): Boolean;
  begin
    If Abs(A) = Abs(B) then
      Result := A < 0
    else
      Result := Abs(A) > Abs(B);
  end;

begin
// first make sure only one shop is selected
Selected := False;
For i := ShopLowIndex to ShopHighIndex do
  If fShops[i].Selected and not Selected then
    Selected := True
  else
    fShops[i].Selected := False;
// get price and avail extremes (availability must be non-zero) and selected
LowPrice := 0;
HighPrice := 0;
LowAvail := 0;
HighAvail := 0;
fUnitPriceSelected := 0;
fAvailableSelected := 0;
For i := ShopLowIndex to ShopHighIndex do
  begin
    If (fShops[i].Available <> 0) and (fShops[i].Price > 0) then
      begin
        If (fShops[i].Price < LowPrice) or (LowPrice <= 0) then
          LowPrice := fShops[i].Price;
        If (fShops[i].Price > HighPrice) or (HighPrice <= 0) then
          HighPrice := fShops[i].Price;
        If AvailIsLess(fShops[i].Available,LowAvail) or (LowAvail <= 0) then
          LowAvail := fShops[i].Available;
        If AvailIsMore(fShops[i].Available,HighAvail) or (HighAvail <= 0) then
          HighAvail := fShops[i].Available;
      end;
    If fShops[i].Selected then
      begin
        fUnitPriceSelected := fShops[i].Price;
        fAvailableSelected := fShops[i].Available;
      end;
  end;
fUnitPriceLowest := LowPrice;
fUnitPriceHighest := HighPrice;
fAvailableLowest := LowAvail;
fAvailableHighest := HighAvail;
UpdateMainList;
UpdateOverview;
end;

//------------------------------------------------------------------------------

procedure TILItem_Utils.FlagPriceAndAvail(OldPrice: UInt32; OldAvail: Int32);
begin
If (ilifWanted in fFlags) and (fShopCount > 0) then
  begin
    Exclude(fFlags,ilifNotAvailable);
    If (fAvailableSelected <> 0) and (fUnitPriceSelected > 0) then
      begin
        If fAvailableSelected > 0 then
          begin
            If UInt32(fAvailableSelected) < fPieces then
              Include(fFlags,ilifNotAvailable);
          end
        else
          begin
            If UInt32(Abs(fAvailableSelected) * 2) < fPieces then
              Include(fFlags,ilifNotAvailable);
          end;
        If fAvailableSelected <> OldAvail then
          Include(fFlags,ilifAvailChange);
        If fUnitPriceSelected <> OldPrice then
          Include(fFlags,ilifPriceChange);
      end
    else
      begin
        Include(fFlags,ilifNotAvailable);
        If (fAvailableSelected <> OldAvail) then
          Include(fFlags,ilifAvailChange);
      end;
    UpdateMainList;
  end;
end;

//------------------------------------------------------------------------------

procedure TILItem_Utils.UpdateAndFlagPriceAndAvail(OldPrice: UInt32; OldAvail: Int32);
begin
BeginUpdate;
try
  UpdatePriceAndAvail;
  FlagPriceAndAvail(OldPrice,OldAvail);
finally
  EndUpdate;
end;
end;

//------------------------------------------------------------------------------

Function TILItem_Utils.ShopsUsefulCount: Integer;
var
  i:  Integer;
begin
Result := 0;
For i := ShopLowIndex to ShopHighIndex do
  If (fShops[i].Available <> 0) and (fShops[i].Price > 0) then
    Inc(Result); 
end;

//------------------------------------------------------------------------------

Function TILItem_Utils.ShopsUsefulRatio: Double;
begin
If fShopCount > 0 then
  Result := ShopsUsefulCount / fShopCount
else
  Result := -1;
end;

//------------------------------------------------------------------------------

Function TILItem_Utils.ShopsCountStr: String;
begin
If ShopsUsefulCount <> ShopCount then
  Result := Format('%d/%d',[ShopsUsefulCount,ShopCount])
else
  Result := IntToStr(ShopCount);
end;

//------------------------------------------------------------------------------

Function TILItem_Utils.ShopsSelected(out Shop: TILItemShop): Boolean;
var
  i:  Integer;
begin
Result := False;
For i := ShopLowIndex to ShopHighIndex do
  If fShops[i].Selected then
    begin
      Shop := fShops[i];
      Result := True;
    end;
end;

//------------------------------------------------------------------------------

Function TILItem_Utils.ShopsWorstUpdateResult: TILItemShopUpdateResult;
var
  i:  Integer;
begin
Result := ilisurSuccess;
For i := ShopLowIndex to ShopHighIndex do
  If fShops[i].LastUpdateRes > Result then
    Result := fShops[i].LastUpdateRes;
end;

end.
