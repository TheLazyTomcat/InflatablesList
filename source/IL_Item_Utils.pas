unit IL_Item_Utils;

{$INCLUDE '.\IL_defs.inc'}

interface

uses
  AuxTypes,
  IL_Item_Base, IL_ItemShop;

type
  TILItem_Utils = class(TILItem_Base)
  public
    Function TitleStr: String; virtual;
    Function TypeStr: String; virtual;
    Function SizeStr: String; virtual;
    Function TotalWeight: UInt32; virtual;
    Function TotalWeightStr: String; virtual;
    Function UnitPrice: UInt32; virtual;
    Function TotalPriceLowest: UInt32; virtual;
    Function TotalPriceHighest: UInt32; virtual;
    Function TotalPriceSelected: UInt32; virtual;
    Function TotalPrice: UInt32; virtual;
    procedure FlagPriceAndAvail(OldPrice: UInt32; OldAvail: Int32); virtual;
    Function ShopsUsefulCount: Integer; virtual;
    Function ShopsCountStr: String; virtual;
    Function ShopsSelected(out Shop: TILItemShop): Boolean; virtual;
    Function ShopsWorstUpdateResult: TILItemShopUpdateResult; virtual;
  end;

implementation

uses
  SysUtils,
  IL_Types;

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
If fID <> 0 then
  begin
    If Length(Result) > 0 then
      Result := Format('%s %d',[Result,fID])
    else
      Result := IntToStr(fID);
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
  end;
end;

//------------------------------------------------------------------------------

Function TILItem_Utils.ShopsUsefulCount: Integer;
var
  i:  Integer;
begin
Result := 0;
For i := ShopLowIndex to ShopHighIndex do
  If (fShops_[i].Available <> 0) and (fShops_[i].Price > 0) then
    Inc(Result); 
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
  If fShops_[i].Selected then
    begin
      Shop := fShops_[i];
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
  If fShops_[i].LastUpdateRes > Result then
    Result := fShops_[i].LastUpdateRes;
end;

end.
