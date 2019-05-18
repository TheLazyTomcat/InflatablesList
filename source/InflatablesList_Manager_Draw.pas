unit InflatablesList_Manager_Draw;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  // unit Windows must be before graphics and classes
  Windows, Graphics, StdCtrls,
  InflatablesList_Types, InflatablesList_Manager_Templates;

type
  TILManager_Draw = class(TILManager_Templates)
  protected
    fRenderWidth:   Integer;
    fRenderHeight:  Integer;
    fFontSettings:  TFont;
    procedure ItemInitInternals(var Item: TILItem); override;
  public
    constructor Create(ListComponent: TListBox);
    procedure ItemReinitSize(ListComponent: TListBox); virtual;
    procedure ItemRedraw(var Item: TILItem); overload; virtual;
    procedure ItemRedraw; overload; virtual;
    property RenderWidth: Integer read fRenderWidth write fRenderWidth;
  end;

implementation

uses
  SysUtils, Classes,
  AuxTypes;

procedure TILManager_Draw.ItemInitInternals(var Item: TILItem);
begin
inherited ItemInitInternals(Item);
Item.ItemListRender.Width := fRenderWidth;
Item.ItemListRender.Height := fRenderHeight;
end;

//==============================================================================

constructor TILManager_Draw.Create(ListComponent: TListBox);
begin
inherited Create;
ItemReinitSize(ListComponent);
end;

//------------------------------------------------------------------------------

procedure TILManager_Draw.ItemReinitSize(ListComponent: TListBox);
var
  OldWidth: Integer;
begin
OldWidth := fRenderWidth;
fRenderWidth := ListComponent.ClientWidth;
fRenderHeight := ListComponent.ItemHeight;
fFontSettings := ListComponent.Font;
If OldWidth <> fRenderWidth then
  ItemRedraw;
end;

//------------------------------------------------------------------------------

procedure TILManager_Draw.ItemRedraw(var Item: TILItem);
const
  WL_STRIP_WIDTH  = 20;
var
  TempStr:  String;
  TempInt:  Integer;
  ItemFlag: TILItemFlag;
  SelShop:  TILItemShop;

  procedure DrawWantedLevelStrip(Canvas: TCanvas);
  const
    WL_STRIP_COLORS: array[0..7] of TColor =
      (clWhite,$00FEE3CC,$00FDD1AD,$00FBBF8E,$00FAAF71,$00F99D52,$00F78C34,$00F67A15);
  var
    ii: UInt32;
  begin
    with Canvas do
      For ii := 7 downto 0 do
        begin
          Brush.Color := WL_STRIP_COLORS[ii];
          If Item.WantedLevel >= ii then
            Rectangle(0,fRenderHeight - Trunc(fRenderHeight * (ii / 7)),
                      WL_STRIP_WIDTH,fRenderHeight);
        end;
  end;

begin
with Item.ItemListRender,Item.ItemListRender.Canvas do
  begin
    Font := fFontSettings;

    // background
    Pen.Style := psClear;
    Brush.Style := bsSolid;
    Brush.Color := clWhite;
    Rectangle(0,0,Width,Height);

    // wanted level strip
    Pen.Style := psClear;
    Brush.Style := bsSolid;
    Brush.Color := $00F7F7F7;
    Rectangle(0,0,WL_STRIP_WIDTH,fRenderHeight);
    If ilifWanted in Item.Flags then
      begin
        If Assigned(fDataProvider.GradientImage) then
          begin
            TempInt := fRenderHeight - Trunc((fRenderHeight / 7) * Item.WantedLevel);
            If Item.WantedLevel > 0 then
              CopyRect(Rect(0,TempInt,Pred(WL_STRIP_WIDTH),fRenderHeight),
                fDataProvider.GradientImage.Canvas,
                Rect(0,TempInt,Pred(WL_STRIP_WIDTH),fRenderHeight));
          end
        else DrawWantedLevelStrip(Item.ItemListRender.Canvas);
      end;

    // title + count
    Brush.Style := bsClear;
    Font.Size := 12;
    Font.Style := Font.Style + [fsBold];
    If Item.Count > 1 then
      TextOut(WL_STRIP_WIDTH + 5,5,Format('%s (%dx)',[ItemTitleStr(Item),Item.Count]))
    else
      TextOut(WL_STRIP_WIDTH + 5,5,ItemTitleStr(Item));

    // type + size
    Font.Size := 10;
    Font.Style := Font.Style - [fsBold];
    TempStr := ItemSizeStr(Item);
    If Length(TempStr) > 0 then
      TextOut(WL_STRIP_WIDTH + 5,30,Format('%s - %s',[ItemTypeStr(Item),TempStr]))
    else
      TextOut(WL_STRIP_WIDTH + 5,30,ItemTypeStr(Item));

    // variant/color
    TextOut(WL_STRIP_WIDTH + 5,50,Item.Variant);

    // flag icons
    TempInt := WL_STRIP_WIDTH + 5;
    For ItemFlag := Low(TILItemFlag) to High(TILItemFlag) do
      If ItemFlag in Item.Flags then
        begin
          Draw(TempInt,fRenderHeight - (fDataProvider.ItemFlagIcons[ItemFlag].Height + 10),
               fDataProvider.ItemFlagIcons[ItemFlag]);
          Inc(TempInt,fDataProvider.ItemFlagIcons[ItemFlag].Width + 5);
        end;

    // review icon
    If Length(Item.ReviewURL) > 0 then
      begin
        Draw(TempInt,fRenderHeight - (fDataProvider.ItemReviewIcon.Height + 10),fDataProvider.ItemReviewIcon);
        Inc(TempInt,fDataProvider.ItemReviewIcon.Width + 5);
      end;

    // text tag
    If Length(Item.TextTag) > 0 then
      begin
        Font.Size := 8;
        Font.Style := Font.Style + [fsBold];
        TextOut(TempInt,fRenderHeight - 25,Item.TextTag);
      end;

    // selected shop and available count
    Font.Size := 8;
    Font.Style := [];
    TempInt := 5;
    If ItemSelectedShop(Item,SelShop) then
      begin
        If Length(Item.Shops) > 1 then
          TempStr := Format('%s [%d]',[SelShop.Name,Length(Item.Shops)])
        else
          TempStr := SelShop.Name;
        TextOut(fRenderWidth - (TextWidth(TempStr) + 122),TempInt,TempStr);
        Inc(TempInt,15);

        If Item.AvailablePieces <> 0 then
          begin
            If Item.AvailablePieces < 0 then
              TempStr := Format('more than %d pcs',[Abs(Item.AvailablePieces)])
            else
              TempStr := Format('%d pcs',[Item.AvailablePieces]);
            TextOut(fRenderWidth - (TextWidth(TempStr) + 122),TempInt,TempStr);
            Inc(TempInt,15);
          end;
      end;

    // prices
    Font.Size := 12;
    Font.Style := Font.Style + [fsBold];
    If ItemTotalPrice(Item) > 0 then
      begin
        If Item.Count > 1 then
          TempStr := Format('%d (%d) Kè',[ItemTotalPrice(Item),ItemUnitPrice(Item)])
        else
          TempStr := Format('%d Kè',[ItemTotalPrice(Item)]);
        TextOut(fRenderWidth - (TextWidth(TempStr) + 122),TempInt,TempStr);
      end;

    Font.Size := 10;
    Font.Style := Font.Style - [fsBold];
    If (Item.UnitPriceSelected <> Item.UnitPriceLowest) and (Item.UnitPriceSelected > 0) and (Item.UnitPriceLowest > 0) then
      begin
        If Item.Count > 1 then
          TempStr := Format('%d (%d) Kè',[ItemTotalPriceLowest(Item),Item.UnitPriceLowest])
        else
          TempStr := Format('%d Kè',[ItemTotalPriceLowest(Item)]);
        TextOut(fRenderWidth - (TextWidth(TempStr) + 122),TempInt + 20,TempStr);
      end;

    // main picture
    If Assigned(Item.MainPicture) and not fNoPictures then
      Draw(fRenderWidth - 102,2,Item.MainPicture)
    else
      Draw(fRenderWidth - 102,2,fDataProvider.ItemDefaultPictures[Item.ItemType]);

    // worst result bar
    If Length(Item.Shops) > 0 then
      begin
        Pen.Style := psClear;
        Brush.Style := bsSolid;
        Brush.Color := IL_ItemShopUpdateResultToColor(ItemWorstUpdateResult(Item));
        Polygon([Point(fRenderWidth - 15,0),Point(fRenderWidth,0),Point(fRenderWidth,15)]);
      end;
  end;
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

procedure TILManager_Draw.ItemRedraw;
var
  i:  Integer;
begin
For i := Low(fList) to High(fList) do
  ItemRedraw(fList[i]);
end;

end.
