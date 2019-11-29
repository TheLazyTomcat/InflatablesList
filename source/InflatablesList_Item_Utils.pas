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
    Function Descriptor: String; virtual;
    Function PictureCountStr: String; virtual;
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
    Function ShopsUsefulCount: Integer; virtual;
    Function ShopsUsefulRatio: Double; virtual;
    Function ShopsCountStr: String; virtual;
    Function ShopsSelected(out Shop: TILItemShop): Boolean; virtual;
    Function ShopsWorstUpdateResult: TILItemShopUpdateResult; virtual;
  end;

implementation

uses
  SysUtils,
  InflatablesList_Utils;

Function TILItem_Utils.Descriptor: String;
begin
If (Length(IDStr) > 0) then
  begin
    If Length(fVariantTag) > 0 then
      Result := IL_Format('%s%s_%s',[fDataProvider.ItemManufacturers[fManufacturer].Tag,IDStr,fVariantTag])
    else
      Result := IL_Format('%s%s',[fDataProvider.ItemManufacturers[fManufacturer].Tag,IDStr])
  end
else Result := GUIDToString(fUniqueID);
end;

//------------------------------------------------------------------------------

Function TILItem_Utils.PictureCountStr: String;
var
  SecCnt:   Integer;
  SecCntWT: Integer;
begin
SecCnt := fPictures.SecondaryCount(False);
SecCntWT := fPictures.SecondaryCount(True);
If SecCnt > 0 then
  begin
    If SecCnt <> SecCntWT then
      REsult := IL_Format('%d - %d/%d',[fPictures.Count,SecCnt,SecCntWT])
    else
      Result := IL_Format('%d - %d',[fPictures.Count,SecCnt]);
  end
else Result := IntToStr(fPictures.Count);
end;

//------------------------------------------------------------------------------

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
      Result := IL_Format('%s %s',[Result,IDStr])
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
      Result := IL_Format('%s (%s)',[fDataProvider.GetItemTypeString(fItemType),fItemTypeSpec])
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
    If fNumID <> 0 then
      Result := IntToStr(fNumID)
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
  Result := IL_Format('%g',[fSizeX / 10]);
If fSizeY > 0 then
  begin
    If Length(Result) > 0 then
      Result := IL_Format('%s x %g',[Result,fSizeY / 10])
    else
      Result := IL_Format('%g',[fSizeY / 10]);
  end;
If fSizeZ > 0 then
  begin
    If Length(Result) > 0 then
      Result := IL_Format('%s x %g',[Result,fSizeZ / 10])
    else
      Result := IL_Format('%g',[fSizeZ / 10]);
  end;
If Length(Result) > 0 then
  Result := IL_Format('%s cm',[Result]);
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
  Result := IL_Format('%g kg',[TotalWeight / 1000])
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
  Result := IL_Format('%d/%d',[ShopsUsefulCount,ShopCount])
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
      Break{For i}; // there should be only one selected shop, no need to continue
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
