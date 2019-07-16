unit InflatablesList_Item_Draw;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  Graphics, StdCtrls,
  InflatablesList_Item_Utils;

type
  TILItem_Draw = class(TILItem_Utils)
  protected
    fMainWidth:   Integer;
    fMainHeight:  Integer;
    fMainFont:    TFont;
    procedure ReDrawMain; virtual;
    procedure ReDrawSmall; virtual;
    procedure UpdateMainList; override;
    procedure UpdateSmallList; override;
  public
    procedure Initialize; override;
    procedure ReinitDrawSize(MainList: TListBox); virtual;
    procedure ReDraw; virtual;
  end;

implementation

uses
  SysUtils, Classes,
  AuxTypes,
  InflatablesList_Types,
  InflatablesList_ItemShop;

procedure TILItem_Draw.ReDrawMain;
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
          If fWantedLevel >= ii then
            Rectangle(0,fMainHeight - Trunc(fMainHeight * (ii / 7)),WL_STRIP_WIDTH,fMainHeight);
        end;
  end;

begin
with fRender,fRender.Canvas do
  begin
    Font := fMainFont;

    // background
    Pen.Style := psClear;
    Brush.Style := bsSolid;
    Brush.Color := clWhite;
    Rectangle(0,0,Width + 1,Height + 1);

    // wanted level strip
    Pen.Style := psClear;
    Brush.Style := bsSolid;
    If ilifDiscarded in fFlags then
      Brush.Color := $00D0D0D0
    else
      Brush.Color := $00F7F7F7;
    Rectangle(0,0,WL_STRIP_WIDTH,fMainHeight);
    If ilifWanted in fFlags then
      begin
        If Assigned(fDataProvider.GradientImage) then
          begin
            TempInt := fMainHeight - Trunc((fMainHeight / 7) * fWantedLevel);
            If fWantedLevel > 0 then
              CopyRect(Rect(0,TempInt,Pred(WL_STRIP_WIDTH),fMainHeight),
                fDataProvider.GradientImage.Canvas,
                Rect(0,TempInt,Pred(WL_STRIP_WIDTH),fMainHeight));
          end
        else DrawWantedLevelStrip(fRender.Canvas);
      end;

    // title + count
    Brush.Style := bsClear;
    Font.Size := 12;
    Font.Style := Font.Style + [fsBold];
    If fPieces > 1 then
      TextOut(WL_STRIP_WIDTH + 5,5,Format('%s (%dx)',[TitleStr,fPieces]))
    else
      TextOut(WL_STRIP_WIDTH + 5,5,TitleStr);

    // type + size
    Font.Size := 10;
    Font.Style := Font.Style - [fsBold];
    TempStr := SizeStr;
    If Length(TempStr) > 0 then
      TextOut(WL_STRIP_WIDTH + 5,30,Format('%s - %s',[TypeStr,TempStr]))
    else
      TextOut(WL_STRIP_WIDTH + 5,30,TypeStr);

    // variant/color
    TextOut(WL_STRIP_WIDTH + 5,50,fVariant);

    // flag icons
    TempInt := WL_STRIP_WIDTH + 5;
    For ItemFlag := Low(TILItemFlag) to High(TILItemFlag) do
      If ItemFlag in fFlags then
        begin
          Draw(TempInt,fMainHeight - (fDataProvider.ItemFlagIcons[ItemFlag].Height + 10),
               fDataProvider.ItemFlagIcons[ItemFlag]);
          Inc(TempInt,fDataProvider.ItemFlagIcons[ItemFlag].Width + 5);
        end;

    // review icon
    If Length(fReviewURL) > 0 then
      begin
        Draw(TempInt,fMainHeight - (fDataProvider.ItemReviewIcon.Height + 10),fDataProvider.ItemReviewIcon);
        Inc(TempInt,fDataProvider.ItemReviewIcon.Width + 5);
      end;

    // text tag
    If Length(fTextTag) > 0 then
      begin
        Font.Size := 8;
        Font.Style := Font.Style + [fsBold];
        TextOut(TempInt,fMainHeight - 25,fTextTag);
      end;

    // selected shop and available count
    Font.Size := 8;
    Font.Style := [];
    TempInt := 5;
    If ShopsSelected(SelShop) then
      begin
        If ShopCount > 1 then
          TempStr := Format('%s (%s)',[SelShop.Name,ShopsCountStr])
        else
          TempStr := SelShop.Name;
        TextOut(fMainWidth - (TextWidth(TempStr) + 122),TempInt,TempStr);
        Inc(TempInt,15);

        If fAvailableSelected <> 0 then
          begin
            If fAvailableSelected < 0 then
              TempStr := Format('more than %d pcs',[Abs(fAvailableSelected)])
            else
              TempStr := Format('%d pcs',[fAvailableSelected]);
            TextOut(fMainWidth - (TextWidth(TempStr) + 122),TempInt,TempStr);
            Inc(TempInt,15);
          end;
      end;

    // prices
    Font.Size := 12;
    Font.Style := Font.Style + [fsBold];
    If TotalPrice > 0 then
      begin
        If fPieces > 1 then
          TempStr := Format('%d (%d) Kè',[TotalPrice,UnitPrice])
        else
          TempStr := Format('%d Kè',[TotalPrice]);
        TextOut(fMainWidth - (TextWidth(TempStr) + 122),TempInt,TempStr);
      end;

    Font.Size := 10;
    Font.Style := Font.Style - [fsBold];
    If (fUnitPriceSelected <> fUnitPriceLowest) and (fUnitPriceSelected > 0) and (fUnitPriceLowest > 0) then
      begin
        If fPieces > 1 then
          TempStr := Format('%d (%d) Kè',[TotalPriceLowest,fUnitPriceLowest])
        else
          TempStr := Format('%d Kè',[TotalPriceLowest]);
        TextOut(fMainWidth - (TextWidth(TempStr) + 122),TempInt + 20,TempStr);
      end;

    // main picture
    If Assigned(fItemPicture) and not StaticOptions.NoPictures then
      Draw(fMainWidth - 102,2,fItemPicture)
    else
      Draw(fMainWidth - 102,2,fDataProvider.ItemDefaultPictures[fItemType]);

    // worst result indication
    If (fShopCount > 0) and (ilifWanted in fFlags) then
      begin
        Pen.Style := psClear;
        Brush.Style := bsSolid;
        Brush.Color := IL_ItemShopUpdateResultToColor(ShopsWorstUpdateResult);
        Polygon([Point(fMainWidth - 15,0),Point(fMainWidth,0),Point(fMainWidth,15)]);
      end;
  end;
end;

//------------------------------------------------------------------------------

procedure TILItem_Draw.ReDrawSmall;
begin
end;

//------------------------------------------------------------------------------

procedure TILItem_Draw.UpdateMainList;
begin
If fUpdateCounter <= 0 then
  ReDrawMain;
inherited;
end;

//------------------------------------------------------------------------------

procedure TILItem_Draw.UpdateSmallList;
begin
If fUpdateCounter <= 0 then
  ReDrawSmall;
inherited;
end;

//==============================================================================

procedure TILItem_Draw.Initialize;
begin
inherited;
fMainWidth := 0;
fMainHeight := 0;
fMainFont := nil;
fRender.Width := fMainWidth;
fRender.Height := fMainHeight;
end;

//------------------------------------------------------------------------------

procedure TILItem_Draw.ReinitDrawSize(MainList: TListBox);
begin
If (fMainWidth <> MainList.ClientWidth) or (fMainHeight <> MainList.ItemHeight) then
  begin
    fMainWidth := MainList.ClientWidth;
    fMainHeight := MainList.ItemHeight;
    fMainFont := MainList.Font;
    fRender.Width := fMainWidth;
    fRender.Height := fMainHeight;
    ReDrawMain;
    inherited UpdateMainList; // so redraw is not called again
  end;
// implement for small
end;

//------------------------------------------------------------------------------

procedure TILItem_Draw.ReDraw;
begin
ReDrawMain;
inherited UpdateMainList;
end;

end.
