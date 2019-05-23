unit InflatablesList_Manager_Shops;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  InflatablesList_Types, InflatablesList_Manager_Utils;

type
  TILManager_Shops = class(TILManager_Utils)
  public
    class procedure ItemShopInitialize(out ItemShop: TILItemShop); virtual;    
    class procedure ItemShopFinalize(var ItemShop: TILItemShop); override;
    class Function ItemShopIndexOf(const Item: TILItem; const Name: String): Integer; virtual;
    class Function ItemShopAdd(var Item: TILItem): Integer; virtual;
    class procedure ItemShopExchange(var Item: TILItem; Idx1,Idx2: Integer); virtual;
    class procedure ItemShopDelete(var Item: TILItem; Index: Integer); virtual;
    class procedure ItemShopClear(var Item: TILItem); override;  
  end;

implementation

uses
  SysUtils,
  InflatablesList_HTML_ElementFinder;

class procedure TILManager_Shops.ItemShopInitialize(out ItemShop: TILItemShop);
var
  i:  Integer;
begin
ItemShop.Selected := False;
ItemShop.Untracked := False;
ItemShop.AltDownMethod := False;
ItemShop.Name := '';
ItemShop.ShopURL := '';
ItemShop.ItemURL := '';
ItemShop.Available := 0;
ItemShop.Price := 0;
SetLength(ItemShop.AvailHistory,0);
SetLength(ItemShop.PriceHistory,0);
ItemShop.Notes := '';
with ItemShop.ParsingSettings do
  begin
    For i := Low(Variables.Vars) to High(Variables.Vars) do
      Variables.Vars[i] := '';
    TemplateRef := '';
    DisableParsErrs := False;
    SetLength(Available.Extraction,0);
    Available.Finder := nil;
    SetLength(Price.Extraction,0);
    Price.Finder := nil;
  end;
ItemShop.LastUpdateRes := ilisurSuccess;
ItemShop.LastUpdateMsg := '';
ItemShop.RequiredCount := 0;
end;

//------------------------------------------------------------------------------

class procedure TILManager_Shops.ItemShopFinalize(var ItemShop: TILITemShop);
begin
FreeAndNil(ItemShop.ParsingSettings.Available.Finder);
FreeAndNil(ItemShop.ParsingSettings.Price.Finder);
end;

//------------------------------------------------------------------------------

class Function TILManager_Shops.ItemShopIndexOf(const Item: TILItem; const Name: String): Integer;
var
  i:  Integer;
begin
Result := -1;
For i := Low(Item.Shops) to High(Item.Shops) do
  If AnsiSameText(Item.Shops[i].Name,Name) then
    begin
      Result := i;
      Break{For i};
    end;
end;

//------------------------------------------------------------------------------

class Function TILManager_Shops.ItemShopAdd(var Item: TILItem): Integer;
begin
SetLength(Item.Shops,Length(Item.Shops) + 1);
Result := High(Item.Shops);
FillChar(Item.Shops[Result],SizeOf(TILItemShop),0);
Item.Shops[Result].ParsingSettings.Available.Finder := TILElementFinder.Create;
Item.Shops[Result].ParsingSettings.Price.Finder := TILElementFinder.Create;
end;

//------------------------------------------------------------------------------

class procedure TILManager_Shops.ItemShopExchange(var Item: TILItem; Idx1,Idx2: Integer);
var
  Temp: TILItemShop;
begin
If Idx1 <> Idx2 then
  begin
    // sanity checks
    If (Idx1 < Low(Item.Shops)) or (Idx1 > High(Item.Shops)) then
      raise Exception.CreateFmt('TILManager_Shops.ItemShopExchange: Index 1 (%d) out of bounds.',[Idx1]);
    If (Idx2 < Low(Item.Shops)) or (Idx2 > High(Item.Shops)) then
      raise Exception.CreateFmt('TILManager_Shops.ItemShopExchange: Index 2 (%d) out of bounds.',[Idx1]);
    Temp := Item.Shops[Idx1];
    Item.Shops[Idx1] := Item.Shops[Idx2];
    Item.Shops[Idx2] := Temp;
  end;
end;

//------------------------------------------------------------------------------

class procedure TILManager_Shops.ItemShopDelete(var Item: TILItem; Index: Integer);
var
  i:  Integer;
begin
If (Index >= Low(Item.Shops)) and (Index <= High(Item.Shops)) then
  begin
    ItemShopFinalize(Item.Shops[Index]);
    For i := Index to Pred(High(Item.Shops)) do
      Item.Shops[i] := Item.Shops[i + 1];
    SetLength(Item.Shops,Length(Item.Shops) - 1);
  end
else raise Exception.CreateFmt('TILManager_Shops.ItemShopDelete: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

class procedure TILManager_Shops.ItemShopClear(var Item: TILItem);
var
  i:  Integer;
begin
For i := Low(Item.Shops) to High(Item.Shops) do
  ItemShopFinalize(Item.Shops[i]);
SetLength(Item.Shops,0);
end;

end.
