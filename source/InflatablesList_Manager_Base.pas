unit InflatablesList_Manager_Base;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  StdCtrls,
  AuxTypes,
  SimpleCmdLineParser,
  InflatablesList_Types, InflatablesList_Data;

type
  TILManager_Base = class(TObject)
  protected
    fDataProvider:  TILDataProvider;
    fCMDLineParser: TCLPParser;
    fFileName:      String;
    fNoPictures:    Boolean;    
    fSorting:       Boolean;
    // main list
    fList:          array of TILItem;
    // getters, setters
    Function GetItemCount: Integer;
    Function GetItem(Index: Integer): TILItem;
    Function GetItemPtr(Index: Integer): PILItem;
    // initialization / finalization
    procedure Initialize; virtual;
    procedure Finalize; virtual;
    // internal list item methods
    procedure ItemInitialize(out Item: TILItem); virtual;
    procedure ItemFinalize(var Item: TILItem; FreePics: Boolean = False); virtual;
    Function ItemContains(const Item: TILItem; const Text: String): Boolean; virtual;
    procedure ItemInitInternals(var Item: TILItem); virtual;
    procedure ItemFinalInternals(var Item: TILItem); virtual;
    // other methods
    procedure ReIndex; virtual;
  public
    // methods implemented in descendants
    class procedure ItemShopFinalize(var ItemShop: TILItemShop); virtual; abstract;
    class procedure ItemShopClear(var Item: TILItem); virtual; abstract;
    Function ItemTypeStr(const Item: TILItem): String; virtual; abstract;
    // utility functions
    class procedure ItemCopy(const Src: TILItem; out Dest: TILItem; CopyPics: Boolean = False); virtual;
    class procedure ItemShopCopy(const Src: TILItemShop; out Dest: TILItemShop); virtual;
    // constructors/destructors
    constructor Create;
    destructor Destroy; override;
    // list manipulation
    Function ItemAddEmpty: Integer; virtual;
    Function ItemAddCopy(SrcIndex: Integer): Integer; virtual;    
    procedure ItemExchange(Idx1,Idx2: Integer); virtual;
    procedure ItemDelete(Index: Integer); virtual;
    procedure ItemClear; virtual;
    // searching
    Function FindPrev(const Text: String; FromIndex: Integer = -1): Integer; virtual;
    Function FindNext(const Text: String; FromIndex: Integer = -1): Integer; virtual;
    // properties
    property DataProvider: TILDataProvider read fDataProvider;
    property CommandLineParser: TCLPParser read fCMDLineParser;
    property FileName: String read fFileName;
    property NoPictures: Boolean read fNoPictures write fNoPictures;
    property ItemCount: Integer read GetItemCount;
    property Items[Index: Integer]: TILItem read GetItem; default;
    property ItemPtrs[Index: Integer]: PILItem read GetItemPtr;
  end;

implementation

uses
  SysUtils, StrUtils, Graphics,
  InflatablesList_Utils, InflatablesList_HTML_ElementFinder;

Function TILManager_Base.GetItemCount: Integer;
begin
Result := Length(fList);
end;

//------------------------------------------------------------------------------

Function TILManager_Base.GetItem(Index: Integer): TILItem;
begin
If (Index >= Low(fList)) and (Index <= High(fList)) then
  Result := fList[Index]
else
  raise Exception.CreateFmt('TILManager_Base.GetItem: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

Function TILManager_Base.GetItemPtr(Index: Integer): PILItem;
begin
If (Index >= Low(fList)) and (Index <= High(fList)) then
  Result := Addr(fList[Index])
else
  raise Exception.CreateFmt('TILManager_Base.GetItemPtr: Index (%d) out of bounds.',[Index]);
end;

//==============================================================================

procedure TILManager_Base.Initialize;
begin
fDataProvider := TILDataProvider.Create;
fCMDLineParser := TCLPParser.Create;
fNoPictures := fCMDLineParser.CommandPresent('no_pics');
fSorting := False;
SetLength(fList,0);
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.Finalize;
begin
ItemClear;
FreeAndNil(fCMDLineParser);
FreeAndNil(fDataProvider);
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.ItemInitialize(out Item: TILItem);
begin
// basic specs
Item.MainPicture := nil;
Item.PackagePicture := nil;
Item.ItemType := ilitUnknown;
Item.ItemTypeSpec := '';
Item.Count := 1;
Item.Manufacturer := ilimOthers;
Item.ManufacturerStr := '';
Item.ID := 0;
// flags
Item.Flags := [];
Item.TextTag := '';
// ext. specs
Item.WantedLevel := 0;
Item.Variant := '';
Item.SizeX := 0;
Item.SizeY := 0;
Item.SizeZ := 0;
Item.UnitWeight := 0;
// other info
Item.Notes := '';
Item.ReviewURL := '';
Item.MainPictureFile := '';
Item.PackagePictureFile := '';
Item.UnitPriceDefault := 0;
Item.UnitPriceLowest := 0;
Item.UnitPriceSelected := 0;
Item.AvailablePieces := 0;
// shops
SetLength(Item.Shops,0);
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.ItemFinalize(var Item: TILItem; FreePics: Boolean = False);
var
  i:  Integer;
begin
If FreePics then
  begin
    If Assigned(Item.MainPicture) then
      FreeAndNil(Item.MainPicture);
    If Assigned(Item.PackagePicture) then
      FreeAndNil(Item.PackagePicture);
    ItemFinalInternals(Item);
  end;
For i := Low(Item.Shops) to High(Item.Shops) do
  ItemShopFinalize(Item.Shops[i]);
end;

//------------------------------------------------------------------------------

Function TILManager_Base.ItemContains(const Item: TILItem; const Text: String): Boolean;
begin
Result :=
  AnsiContainsText(ItemTypeStr(Item),Text) or
  AnsiContainsText(Item.ItemTypeSpec,Text) or
  AnsiContainsText(IntToStr(Item.Count),Text) or
  AnsiContainsText(fDataProvider.ItemManufacturers[Item.Manufacturer].Str,Text) or
  AnsiContainsText(Item.ManufacturerStr,Text) or
  AnsiContainsText(IntToStr(Item.ID),Text) or
  AnsiContainsText(Item.TextTag,Text) or
  AnsiContainsText(IntToStr(Item.WantedLevel),Text) or
  AnsiContainsText(Item.Variant,Text) or
  AnsiContainsText(IntToStr(Item.SizeX),Text) or
  AnsiContainsText(IntToStr(Item.SizeY),Text) or
  AnsiContainsText(IntToStr(Item.SizeZ),Text) or
  AnsiContainsText(IntToStr(Item.UnitWeight),Text) or
  AnsiContainsText(Item.Notes,Text);
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.ItemInitInternals(var Item: TILItem);
begin
Item.ItemListRender := TBitmap.Create;
Item.ItemListRender.PixelFormat := pf24bit;
Item.FilteredOut := False;
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.ItemFinalInternals(var Item: TILItem);
begin
If Assigned(Item.ItemListRender) then
  FreeAndNil(Item.ItemListRender);
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.ReIndex;
var
  i:  Integer;
begin
For i := Low(fList) to High(fList) do
  fList[i].Index := i;
end;

//==============================================================================

class procedure TILManager_Base.ItemCopy(const Src: TILItem; out Dest: TILItem; CopyPics: Boolean = False);
var
  i:  Integer;
begin
Dest := Src;
If CopyPics then
  begin
    If Assigned(Src.MainPicture) then
      begin
        Dest.MainPicture := TBitmap.Create;
        Dest.MainPicture.Assign(Src.MainPicture);
      end;
    If Assigned(Src.PackagePicture) then
      begin
        Dest.PackagePicture := TBitmap.Create;
        Dest.PackagePicture.Assign(Src.PackagePicture);
      end;
    If Assigned(Src.ItemListRender) then
      begin
        Dest.ItemListRender := TBitmap.Create;
        Dest.ItemListRender.Assign(Src.ItemListRender);
      end;
  end;
UniqueString(Dest.ItemTypeSpec);
UniqueString(Dest.ManufacturerStr);
UniqueString(Dest.TextTag);
UniqueString(Dest.Variant);
UniqueString(Dest.Notes);
UniqueString(Dest.ReviewURL);
UniqueString(Dest.MainPictureFile);
UniqueString(Dest.PackagePictureFile);
SetLength(Dest.Shops,Length(Dest.Shops));
For i := Low(Dest.Shops) to High(Dest.Shops) do
  ItemShopCopy(Src.Shops[i],Dest.Shops[i]);
end;

//------------------------------------------------------------------------------

class procedure TILManager_Base.ItemShopCopy(const Src: TILItemShop; out Dest: TILItemShop);
var
  i:  Integer;
begin
Dest := Src;
UniqueString(Dest.Name);
UniqueString(Dest.ShopURL);
UniqueString(Dest.ItemURL);
SetLength(Dest.AvailHistory,Length(Dest.AvailHistory));
SetLength(Dest.PriceHistory,Length(Dest.PriceHistory));
UniqueString(Dest.Notes);
with Dest.ParsingSettings do
  begin
    For i := Low(Variables.Vars) to High(Variables.Vars) do
      UniqueString(Variables.Vars[i]);
    SetLength(Available.Extraction,Length(Available.Extraction));
    For i := Low(Available.Extraction) to High(Available.Extraction) do
      begin
        UniqueString(Available.Extraction[i].ExtractionData);
        UniqueString(Available.Extraction[i].NegativeTag);
      end;
    Available.Finder := TILElementFinder.CreateAsCopy(
      TILElementFinder(Src.ParsingSettings.Available.Finder));
    SetLength(Price.Extraction,Length(Price.Extraction));
    For i := Low(Price.Extraction) to High(Price.Extraction) do
      begin
        UniqueString(Price.Extraction[i].ExtractionData);
        UniqueString(Price.Extraction[i].NegativeTag);
      end;
    Price.Finder := TILElementFinder.CreateAsCopy(
      TILElementFinder(Src.ParsingSettings.Price.Finder));
  end;
UniqueString(Dest.LastUpdateMsg);
end;

//------------------------------------------------------------------------------

constructor TILManager_Base.Create;
begin
inherited Create;
fFileName := '';
Initialize;
end;

//------------------------------------------------------------------------------

destructor TILManager_Base.Destroy;
begin
Finalize;
inherited;
end;

//------------------------------------------------------------------------------

Function TILManager_Base.ItemAddEmpty: Integer;
begin
SetLength(fList,Length(fList) + 1);
Result := High(fList);
ItemInitialize(fList[Result]);
// internals
fList[Result].Index := Result;
fList[Result].TimeOfAddition := Now;
ItemInitInternals(fList[Result]);
end;

//------------------------------------------------------------------------------

Function TILManager_Base.ItemAddCopy(SrcIndex: Integer): Integer;
begin
If (SrcIndex >= Low(fList)) and (SrcIndex <= High(fList)) then
  begin
    Result := ItemAddEmpty;
    // free the internals as they will be recreated
    ItemFinalInternals(fList[Result]);
    If Result >= 0 then
      ItemCopy(fList[SrcIndex],fList[Result],True);
    fList[Result].Index := Result;
    fList[Result].TimeOfAddition := Now;      
  end
else raise Exception.CreateFmt('TILManager_Base.ItemAddCopy: Source index (%d) out of bounds.',[SrcIndex]);
end;


//------------------------------------------------------------------------------

procedure TILManager_Base.ItemExchange(Idx1,Idx2: Integer);
var
  Temp: TILItem;
begin
If Idx1 <> Idx2 then
  begin
    // sanity checks
    If (Idx1 < Low(fList)) or (Idx1 > High(fList)) then
      raise Exception.CreateFmt('TILManager_Base.ItemExchange: Index 1 (%d) out of bounds.',[Idx1]);
    If (Idx2 < Low(fList)) or (Idx2 > High(fList)) then
      raise Exception.CreateFmt('TILManager_Base.ItemExchange: Index 2 (%d) out of bounds.',[Idx1]);
    Temp := fList[Idx1];
    fList[Idx1] := fList[Idx2];
    fList[Idx2] := Temp;
    If not fSorting then
      begin
        // full reindex not needed
        fList[Idx1].Index := Idx1;
        fList[Idx2].Index := Idx2;
      end;
  end;
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.ItemDelete(Index: Integer);
var
  i:  Integer;
begin
If (Index >= Low(fList)) and (Index <= High(fList)) then
  begin
    FreeAndNil(fList[Index].MainPicture);
    FreeAndNil(fList[Index].PackagePicture);
    ItemShopClear(fList[Index]);
    ItemFinalInternals(fList[Index]);
    For i := Index to Pred(High(fList)) do
      fList[i] := fList[i + 1];
    SetLength(fList,Length(fList) - 1);
    ReIndex;
  end
else raise Exception.CreateFmt('TILManager_Base.ItemDelete: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.ItemClear;
var
  i:  Integer;
begin
For i := Low(fList) to High(fList) do
  begin
    FreeAndNil(fList[i].MainPicture);
    FreeAndNil(fList[i].PackagePicture);
    ItemShopClear(fList[i]);
    ItemFinalInternals(fList[i]);
  end;
SetLength(fList,0);
end;

//------------------------------------------------------------------------------

Function TILManager_Base.FindPrev(const Text: String; FromIndex: Integer = -1): Integer;
var
  i:  Integer;
begin
Result := -1;
i := IL_IndexWrap(Pred(FromIndex),Low(fList),High(fList));
while i <> FromIndex do
  begin
    If ItemContains(fList[i],Text) then
      begin
        Result := i;
        Break{while...};
      end;
    i := IL_IndexWrap(Pred(i),Low(fList),High(fList));
  end;
end;

//------------------------------------------------------------------------------

Function TILManager_Base.FindNext(const Text: String; FromIndex: Integer = -1): Integer;
var
  i:  Integer;
begin
Result := -1;
i := IL_IndexWrap(Succ(FromIndex),Low(fList),High(fList));
while i <> FromIndex do
  begin
    If ItemContains(fList[i],Text) then
      begin
        Result := i;
        Break{while...};
      end;
    i := IL_IndexWrap(Succ(i),Low(fList),High(fList));
  end;
end;

end.
