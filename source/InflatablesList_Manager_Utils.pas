unit InflatablesList_Manager_Utils;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  AuxTypes,
  InflatablesList_Types, InflatablesList_Manager_Base;

const
  // how many times to repeat update when it fails in certain way
  IL_LISTFILE_UPDATE_TRYCOUNT = 5;

type
  TILManager_Utils = class(TILManager_Base)
  public
    // non-item methods
    Function SortingItemStr(const SortingItem: TILSortingItem): String; virtual;
    // items
    Function ItemTitleStr(const Item: TILItem): String; virtual;
    Function ItemTypeStr(const Item: TILItem): String; override;
    Function ItemSize(const Item: TILItem): Int64; virtual;
    Function ItemSizeStr(const Item: TILItem): String; virtual;
    Function ItemTotalWeight(const Item: TILItem): UInt32; virtual;
    Function ItemTotalWeightStr(const Item: TILItem): String; virtual;
    Function ItemUnitPrice(const Item: TILItem): UInt32; virtual;
    Function ItemTotalPriceLowest(const Item: TILItem): UInt32; virtual;
    Function ItemTotalPriceHighest(const Item: TILItem): UInt32; virtual;
    Function ItemTotalPriceSelected(const Item: TILItem): UInt32; virtual;
    Function ItemTotalPrice(const Item: TILItem): UInt32;
    procedure ItemUpdatePriceAndAvail(var Item: TILItem); virtual;
    procedure ItemFlagPriceAndAvail(var Item: TILItem; OldPrice: UInt32; OldAvail: Int32); virtual;
    Function ItemShopsCount(const Item: TILItem): Integer; virtual;
    Function ItemShopsUsefulCount(const Item: TILItem): Integer; virtual;
    Function ItemShopsUsefulRatio(const Item: TILItem): Double; virtual;
    Function ItemShopsCountStr(const Item: TILItem): String; virtual;
    Function ItemShopsSelected(const Item: TILItem; out Shop: TILItemShop): Boolean; virtual;
    procedure ItemShopsUpdateHistory(var Item: TILItem); virtual;
    Function ItemShopsWorstUpdateResult(const Item: TILItem): TILItemShopUpdateResult; virtual;
    class Function ItemShopUpdate(var Shop: TILItemShop; Options: TILCMDManagerOptions): Boolean; virtual;
  end;

implementation

uses
  SysUtils,
  InflatablesList_Utils, InflatablesList_ShopUpdate;

Function TILManager_Utils.SortingItemStr(const SortingItem: TILSortingItem): String;
begin
Result := Format('%s %s',[IL_BoolToChar(SortingItem.Reversed,'+','-'),
  fDataProvider.GetItemValueTagString(SortingItem.ItemValueTag)])
end;

//------------------------------------------------------------------------------

Function TILManager_Utils.ItemTitleStr(const Item: TILItem): String;
begin
If Item.Manufacturer = ilimOthers then
  begin
    If Length(Item.ManufacturerStr) > 0 then
      Result := Item.ManufacturerStr
    else
      Result :='<unknown_manuf>';
  end
else Result := fDataProvider.ItemManufacturers[Item.Manufacturer].Str;
If Item.ID <> 0 then
  begin
    If Length(Result) > 0 then
      Result := Format('%s %d',[Result,Item.ID])
    else
      Result := IntToStr(Item.ID);
  end;
end;

//------------------------------------------------------------------------------

Function TILManager_Utils.ItemTypeStr(const Item: TILItem): String;
begin
If not(Item.ItemType in [ilitUnknown,ilitOther]) then
  begin
    If Length(Item.ItemTypeSpec) > 0 then
      Result := Format('%s (%s)',[fDataProvider.GetItemTypeString(Item.ItemType),Item.ItemTypeSpec])
    else
      Result := fDataProvider.GetItemTypeString(Item.ItemType);
  end
else
  begin
    If Length(Item.ItemTypeSpec) > 0 then
      Result := Item.ItemTypeSpec
    else
      Result := '<unknown_type>';
  end;
end;

//------------------------------------------------------------------------------

Function TILManager_Utils.ItemSize(const Item: TILItem): Int64;
var
  szX,szY,szZ:  UInt32;
begin
If Item.SizeX = 0 then szX := 1
  else szX := Item.SizeX;
If Item.SizeY = 0 then szY := 1
  else szY := Item.SizeY;
If Item.SizeZ = 0 then szZ := 1
  else szZ := Item.SizeZ;
Result := Int64(szX) * Int64(szY) * Int64(szZ);
end;

//------------------------------------------------------------------------------

Function TILManager_Utils.ItemSizeStr(const Item: TILItem): String;
begin
Result := '';
If Item.SizeX > 0 then
  Result := Format('%g',[Item.SizeX / 10]);
If Item.SizeY > 0 then
  begin
    If Length(Result) > 0 then
      Result := Format('%s x %g',[Result,Item.SizeY / 10])
    else
      Result := Format('%g',[Item.SizeY / 10]);
  end;
If Item.SizeZ > 0 then
  begin
    If Length(Result) > 0 then
      Result := Format('%s x %g',[Result,Item.SizeZ / 10])
    else
      Result := Format('%g',[Item.SizeZ / 10]);
  end;
If Length(Result) > 0 then
  Result := Format('%s cm',[Result]);
end;

//------------------------------------------------------------------------------

Function TILManager_Utils.ItemTotalWeight(const Item: TILItem): UInt32;
begin
Result := Item.UnitWeight * Item.Count;
end;

//------------------------------------------------------------------------------

Function TILManager_Utils.ItemTotalWeightStr(const Item: TILItem): String;
var
  Temp: UInt32;
begin
Temp := ItemTotalWeight(Item);
If Temp > 0 then
  Result := Format('%g kg',[ItemTotalWeight(Item) / 1000])
else
  Result := '';
end;

//------------------------------------------------------------------------------

Function TILManager_Utils.ItemUnitPrice(const Item: TILItem): UInt32;
begin
If Item.UnitPriceSelected > 0 then
  Result := Item.UnitPriceSelected
else
  Result := Item.UnitPriceDefault;
end;

//------------------------------------------------------------------------------

Function TILManager_Utils.ItemTotalPriceLowest(const Item: TILItem): UInt32;
begin
Result := Item.UnitPriceLowest * Item.Count;
end;

//------------------------------------------------------------------------------

Function TILManager_Utils.ItemTotalPriceHighest(const Item: TILItem): UInt32;
begin
Result := Item.UnitPriceHighest * Item.Count;
end;

//------------------------------------------------------------------------------

Function TILManager_Utils.ItemTotalPriceSelected(const Item: TILItem): UInt32;
begin
Result := Item.UnitPriceSelected * Item.Count;
end;

//------------------------------------------------------------------------------

Function TILManager_Utils.ItemTotalPrice(const Item: TILItem): UInt32;
begin
Result := ItemUnitPrice(Item) * Item.Count;
end;

//------------------------------------------------------------------------------

procedure TILManager_Utils.ItemUpdatePriceAndAvail(var Item: TILItem);
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
For i := Low(Item.Shops) to High(Item.Shops) do
  If Item.Shops[i].Selected and not Selected then
    Selected := True
  else
    Item.Shops[i].Selected := False;
// get price and avail extremes (availability must be non-zero) and selected
LowPrice := 0;
HighPrice := 0;
LowAvail := 0;
HighAvail := 0;
Item.UnitPriceSelected := 0;
Item.AvailableSelected := 0;
For i := Low(Item.Shops) to High(Item.Shops) do
  begin
    If (Item.Shops[i].Available <> 0) and (Item.Shops[i].Price > 0) then
      begin
        If (Item.Shops[i].Price < LowPrice) or (LowPrice <= 0) then
          LowPrice := Item.Shops[i].Price;
        If (Item.Shops[i].Price > HighPrice) or (HighPrice <= 0) then
          HighPrice := Item.Shops[i].Price; 
        If AvailIsLess(Item.Shops[i].Available,LowAvail) or (LowAvail <= 0) then
          LowAvail := Item.Shops[i].Available;
        If AvailIsMore(Item.Shops[i].Available,HighAvail) or (HighAvail <= 0) then
          HighAvail := Item.Shops[i].Available;
      end;
    If Item.Shops[i].Selected then
      begin
        Item.UnitPriceSelected := Item.Shops[i].Price;
        Item.AvailableSelected := Item.Shops[i].Available;
      end;
  end;
Item.UnitPriceLowest := LowPrice;
Item.UnitPriceHighest := HighPrice;
Item.AvailableLowest := LowAvail;
Item.AvailableHighest := HighAvail;
end;

//------------------------------------------------------------------------------

procedure TILManager_Utils.ItemFlagPriceAndAvail(var Item: TILItem; OldPrice: UInt32; OldAvail: Int32);
begin
If (ilifWanted in Item.Flags) and (Length(Item.Shops) > 0) then
  begin
    Exclude(Item.Flags,ilifNotAvailable);
    If (Item.AvailableSelected <> 0) and (Item.UnitPriceSelected > 0) then
      begin
        If Item.AvailableSelected > 0 then
          begin
            If UInt32(Item.AvailableSelected) < Item.Count then
              Include(Item.Flags,ilifNotAvailable);
          end
        else
          begin
            If UInt32(Abs(Item.AvailableSelected) * 2) < Item.Count then
              Include(Item.Flags,ilifNotAvailable);
          end;
        If Item.AvailableSelected <> OldAvail then
          Include(Item.Flags,ilifAvailChange);
        If Item.UnitPriceSelected <> OldPrice then
          Include(Item.Flags,ilifPriceChange);
      end
    else
      begin
        Include(Item.Flags,ilifNotAvailable);
        If (Item.AvailableSelected <> OldAvail) then
          Include(Item.Flags,ilifAvailChange);
      end;
  end;
end;

//------------------------------------------------------------------------------

Function TILManager_Utils.ItemShopsCount(const Item: TILItem): Integer;
begin
Result := Length(Item.Shops);
end;

//------------------------------------------------------------------------------

Function TILManager_Utils.ItemShopsUsefulCount(const Item: TILItem): Integer;
var
  i:  Integer;
begin
Result := 0;
For i := Low(Item.Shops) to High(Item.Shops) do
  If (Item.Shops[i].Available <> 0) and (Item.Shops[i].Price > 0) then
    Inc(Result); 
end;

//------------------------------------------------------------------------------

Function TILManager_Utils.ItemShopsUsefulRatio(const Item: TILItem): Double;
begin
If ItemShopsCount(Item) > 0 then
  Result := ItemShopsUsefulCount(Item) / ItemShopsCount(Item)
else
  Result := -1;
end;

//------------------------------------------------------------------------------

Function TILManager_Utils.ItemShopsCountStr(const Item: TILItem): String;
begin
If ItemShopsUsefulCount(Item) <> ItemShopsCount(Item) then
  Result := Format('%d/%d',[ItemShopsUsefulCount(Item),ItemShopsCount(Item)])
else
  Result := IntToStr(ItemShopsCount(Item));
end;

//------------------------------------------------------------------------------

Function TILManager_Utils.ItemShopsSelected(const Item: TILItem; out Shop: TILItemShop): Boolean;
var
  i:  Integer;
begin
Result := False;
For i := Low(Item.Shops) to High(Item.Shops) do
  If Item.Shops[i].Selected then
    begin
      Shop := Item.Shops[i];
      Result := True;
    end;
end;

//------------------------------------------------------------------------------

procedure TILManager_Utils.ItemShopsUpdateHistory(var Item: TILItem);
var
  i:  Integer;

  procedure DoAddToHistory(var Shop: TILItemShop);
  begin
    SetLength(Shop.AvailHistory,Length(Shop.AvailHistory) + 1);
    Shop.AvailHistory[High(Shop.AvailHistory)].Value := Shop.Available;
    Shop.AvailHistory[High(Shop.AvailHistory)].Time := Now;
    SetLength(Shop.PriceHistory,Length(Shop.PriceHistory) + 1);
    Shop.PriceHistory[High(Shop.PriceHistory)].Value := Int32(Shop.Price);
    // make sure the time is the same...
    Shop.PriceHistory[High(Shop.PriceHistory)].Time :=
      Shop.AvailHistory[High(Shop.AvailHistory)].Time;
  end;

begin
For i := Low(Item.Shops) to High(Item.Shops) do
  begin
    If Item.Shops[i].Price > 0 then
      begin
        // price is nonzero, add only when current price or avail differs from last entry
        // or there is no prior entry
        If (Length(Item.Shops[i].PriceHistory) <= 0) then
          DoAddToHistory(Item.Shops[i])
        else If (Item.Shops[i].AvailHistory[High(Item.Shops[i].AvailHistory)].Value <> Item.Shops[i].Available) or
                (Item.Shops[i].PriceHistory[High(Item.Shops[i].PriceHistory)].Value <> Int32(Item.Shops[i].Price)) then
          DoAddToHistory(Item.Shops[i]);
      end
    else
      begin
        // price is zero, add only when there is already a price entry and
        // current price or avail differs from last entry
        If (Length(Item.Shops[i].PriceHistory) > 0) then
          If ((Item.Shops[i].AvailHistory[High(Item.Shops[i].AvailHistory)].Value <> Item.Shops[i].Available) or
              (Item.Shops[i].PriceHistory[High(Item.Shops[i].PriceHistory)].Value <> Int32(Item.Shops[i].Price))) then
          DoAddToHistory(Item.Shops[i]);
      end
  end;
end;

//------------------------------------------------------------------------------

Function TILManager_Utils.ItemShopsWorstUpdateResult(const Item: TILItem): TILItemShopUpdateResult;
var
  i:  Integer;
begin
Result := ilisurSuccess;
For i := Low(Item.Shops) to High(Item.Shops) do
  If Item.Shops[i].LastUpdateRes > Result then
    Result := Item.Shops[i].LastUpdateRes;
end;

//------------------------------------------------------------------------------

class Function TILManager_Utils.ItemShopUpdate(var Shop: TILItemShop; Options: TILCMDManagerOptions): Boolean;
var
  Updater:        TILShopUpdater;
  UpdaterResult:  TILShopUpdaterResult;
  TryCounter:     Integer;

  procedure SetValues(const Msg: String; Res: TILItemShopUpdateResult; Avail: Int32; Price: UInt32);
  begin
    Shop.Available := Avail;
    Shop.Price := Price;
    Shop.LastUpdateRes := Res;
    Shop.LastUpdateMsg := Msg;
  end;

begin
If not Shop.Untracked then
  begin
    TryCounter := IL_LISTFILE_UPDATE_TRYCOUNT;
    Result := False;
    Updater := TILShopUpdater.Create(Shop,IL_ThreadSafeCopy(Options));
    try
      repeat
        UpdaterResult := Updater.Run(Shop.AltDownMethod);
        case UpdaterResult of
          ilurSuccess:          begin
                                  SetValues(Format(
                                    'Success (%d bytes downloaded) - Avail: %d  Price: %d',
                                    [Updater.DownloadSize,Updater.Available,Updater.Price]),
                                    ilisurSuccess,Updater.Available,Updater.Price);
                                  Result := True;
                                end;
          ilurNoLink:           SetValues('No item link',ilisurDataFail,0,0);
          ilurNoData:           SetValues('Insufficient search data',ilisurDataFail,0,0);
          // when download fails, keep old price (assumes the item vent unavailable)
          ilurFailDown:         SetValues(Format('Download failed (code: %d)',[Updater.DownloadResultCode]),ilisurCritical,0,Shop.Price);
          // when parsing fails, keep old values (assumes bad download or internal exception)
          ilurFailParse:        SetValues(Format('Parsing failed (%s)',[Updater.ErrorString]),ilisurCritical,Shop.Available,Shop.Price);
          // following assumes the item is unavailable
          ilurFailAvailSearch:  SetValues('Search of available count failed',ilisurSoftFail,0,Updater.Price);
          // following assumes the item is unavailable, keep old price
          ilurFailSearch:       SetValues('Search failed',ilisurHardFail,0,Shop.Price);
          // following assumes the item is unavailable
          ilurFailAvailValGet:  SetValues('Unable to obtain available count',ilisurSoftFail,0,Updater.Price);
          // following assumes the item is unavailable, keep old price
          ilurFailValGet:       SetValues('Unable to obtain values',ilisurHardFail,0,Shop.Price);
          // general fail, invalidate
          ilurFail:             SetValues('Failed (general error)',ilisurFatal,0,0);
        else
          SetValues('Failed (unknown state)',ilisurFatal,0,0);
        end;
        Dec(TryCounter);
      until (TryCounter <= 0) or not(UpdaterResult in [ilurFailDown,ilurFailParse]);
    finally
      Updater.Free;
    end;
  end
else
  begin
    SetValues(Format('Success (untracked) - Avail: %d  Price: %d',
      [Shop.Available,Shop.Price]),ilisurMildSucc,Shop.Available,Shop.Price);
    Result := True;
  end;
end;

end.
