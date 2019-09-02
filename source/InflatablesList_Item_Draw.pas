unit InflatablesList_Item_Draw;
{$message 'll_rework'}

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
    fSmallWidth:  Integer;
    fSmallHeight: Integer;
    procedure ReDrawMain; virtual;
    procedure ReDrawSmall; virtual;
    class procedure RenderSmallPicture(LargePicture: TBitmap; var SmallPicture: TBitmap); virtual;
    procedure RenderSmallItemPicture; override;
    procedure RenderSmallSecondaryPicture; override;
    procedure RenderSmallPackagePicture; override;
    procedure UpdateMainList; override;
    procedure UpdateSmallList; override;
    procedure Initialize; override;
  public
    procedure ReinitDrawSize(MainList: TListBox; SmallList: TListBox); virtual;
    procedure ReinitSmallDrawSize(SmallWidth,SmallHeight: Integer; SmallFont: TFont); virtual;
    procedure ReDraw; virtual;
  end;

implementation

uses
  SysUtils, Classes, Math,
  AuxTypes,
  InflatablesList_Types,
  InflatablesList_Utils,
  InflatablesList_ItemShop;

procedure TILItem_Draw.ReDrawMain;
const
  SIDE_STRIP_WIDTH = 20;
var
  TempStr:  String;
  TempInt:  Integer;
  ItemFlag: TILItemFlag;
  SelShop:  TILItemShop;

  procedure SetCanvas(BStyle: TBrushStyle = bsClear; BColor: TColor = clWhite;
                      PStyle: TPenStyle = psSolid; PColor: TColor = clBlack;
                      FTStyle: TFontStyles = []; FTColor: TColor = clWindowText; FTSize: Integer = 10);
  begin
    fRender.Canvas.Brush.Style := BStyle;
    fRender.Canvas.Brush.Color := BColor;
    fRender.Canvas.Pen.Style := PStyle;
    fRender.Canvas.Pen.Color := PColor;
    fRender.Canvas.Font.Style := FTStyle;
    fRender.Canvas.Font.Color := FTColor;
    fRender.Canvas.Font.Size := FTSize;
  end;

  // called only when the gradient image is not present
  procedure DrawWantedLevelStrip;
  const
    WL_STRIP_COLORS: array[0..7] of TColor =
      (clWhite,$00FFB4D9,$00FF97CA,$00FF7CBD,$00FF60AF,$00FF44A1,$00FF2894,$00FF0C85);
  var
    ii: UInt32;
  begin
    with fRender,fRender.Canvas do
      For ii := 7 downto 0 do
        begin
          Brush.Color := WL_STRIP_COLORS[ii];
          If fWantedLevel >= ii then
            Rectangle(0,Height - Trunc(Height * (ii / 7)),SIDE_STRIP_WIDTH,Height);
        end;
  end;

  procedure DrawPictureIndication(Small,Large: Boolean; OffX,OffY: Integer);
  const
    PIC_INDICATOR_SIZE = 8;
  begin
    with fRender,fRender.Canvas do
      begin
        If Small then
          begin
            SetCanvas(bsSolid,$00E7E7E7,psClear);
            FillRect(Rect(
              Width - (OffX * PIC_INDICATOR_SIZE) - PIC_INDICATOR_SIZE,
              Height - (OffY * PIC_INDICATOR_SIZE) - (PIC_INDICATOR_SIZE + 1),
              Width - (OffX * PIC_INDICATOR_SIZE) - 1,
              Height - (OffY * PIC_INDICATOR_SIZE) - 2));
          end;
        If Large then
          begin
            SetCanvas(bsClear,clSilver,psClear);
            FrameRect(Rect(
              Width - (OffX * PIC_INDICATOR_SIZE) - PIC_INDICATOR_SIZE,
              Height - (OffY * PIC_INDICATOR_SIZE) - (PIC_INDICATOR_SIZE + 1),
              Width - (OffX * PIC_INDICATOR_SIZE) - 1,
              Height - (OffY * PIC_INDICATOR_SIZE) - 2));
          end;
      end;
  end;

begin
with fRender,fRender.Canvas do
  begin
    // background
    SetCanvas(bsSolid,clWhite,psClear);
    Rectangle(0,0,Width + 1,Height + 1);

    // side strip
    SetCanvas(bsSolid,$00F7F7F7,psClear);
    Rectangle(0,0,SIDE_STRIP_WIDTH,Height);
    If ilifWanted in fFlags then
      begin
        // wanted level strip
        If Assigned(fDataProvider.WantedGradientImage) then
          begin
            TempInt := Height - Trunc((Height / 7) * fWantedLevel);
            If fWantedLevel > 0 then
              CopyRect(Rect(0,TempInt,Pred(SIDE_STRIP_WIDTH),Height),
                fDataProvider.WantedGradientImage.Canvas,
                Rect(0,TempInt,Pred(SIDE_STRIP_WIDTH),Height));
          end
        else DrawWantedLevelStrip;
      end
    else If (fRating <> 0) and (ilifOwned in fFLags) then
      begin
        // rating strip
        TempInt := Height - Ceil((Height * Integer(fRating)) / 100);
        CopyRect(Rect(0,TempInt,Pred(SIDE_STRIP_WIDTH),Height),
                 fDataProvider.RatingGradientImage.Canvas,
                 Rect(0,TempInt,Pred(SIDE_STRIP_WIDTH),Height));
      end;

    // title + count
    If fPieces > 1 then
      TempStr := Format('%s (%dx)',[TitleStr,fPieces])
    else
      TempStr := TitleStr;
    If ilifDiscarded in fFlags then
      begin
        SetCanvas(bsSolid,clBlack,psSolid,clBlack,[fsBold],clWhite,12);
        Rectangle(SIDE_STRIP_WIDTH - 1,0,SIDE_STRIP_WIDTH + TextWidth(TempStr) + 11,TextHeight(TempStr) + 10);
      end
    else SetCanvas(bsClear,clWhite,psSolid,clBlack,[fsBold],clWindowText,12);
    TextOut(SIDE_STRIP_WIDTH + 5,5,TempStr);

    // type + size
    SetCanvas(bsClear,clWhite,psSolid,clBlack,[],clWindowText,10);
    TempStr := SizeStr;
    If Length(TempStr) > 0 then
      TextOut(SIDE_STRIP_WIDTH + 5,30,Format('%s - %s',[TypeStr,TempStr]))
    else
      TextOut(SIDE_STRIP_WIDTH + 5,30,TypeStr);

    // variant/color
    SetCanvas;
    TextOut(SIDE_STRIP_WIDTH + 5,50,fVariant);

    // flag icons
    SetCanvas;
    TempInt := SIDE_STRIP_WIDTH + 5;
    For ItemFlag := Low(TILItemFlag) to High(TILItemFlag) do
      If ItemFlag in fFlags then
        begin
          Draw(TempInt,Height - (fDataProvider.ItemFlagIcons[ItemFlag].Height + 10),
               fDataProvider.ItemFlagIcons[ItemFlag]);
          Inc(TempInt,fDataProvider.ItemFlagIcons[ItemFlag].Width + 5);
        end;

    // review icon
    SetCanvas;
    If Length(fReviewURL) > 0 then
      begin
        Draw(TempInt,Height - (fDataProvider.ItemReviewIcon.Height + 10),fDataProvider.ItemReviewIcon);
        Inc(TempInt,fDataProvider.ItemReviewIcon.Width + 5);
      end;

    // text and num tag
    SetCanvas;
    If Length(fTextTag) > 0 then
      begin
        SetCanvas(bsClear,clWhite,psSolid,clBlack,[fsBold],clWindowText,8);
        TextOut(TempInt,Height - 25,fTextTag);
        Inc(TempInt,TextWidth(fTextTag) + 5);
      end;
    If fNumTag <> 0 then
      begin
        SetCanvas(bsClear,clWhite,psSolid,clBlack,[fsBold],clWindowText,8);
        TextOut(TempInt,Height - 25,Format('[%d]',[fNumTag]))
      end;

    // selected shop and available count
    SetCanvas(bsClear,clWhite,psSolid,clBlack,[],clWindowText,8);
    TempInt := 5;
    If ShopsSelected(SelShop) then
      begin
        If ShopCount > 1 then
          TempStr := Format('%s (%s)',[SelShop.Name,ShopsCountStr])
        else
          TempStr := SelShop.Name;
        TextOut(Width - (TextWidth(TempStr) + 122),TempInt,TempStr);
        Inc(TempInt,17);

        If fAvailableSelected <> 0 then
          begin
            If fAvailableSelected < 0 then
              TempStr := Format('more than %d pcs',[Abs(fAvailableSelected)])
            else
              TempStr := Format('%d pcs',[fAvailableSelected]);
            TextOut(Width - (TextWidth(TempStr) + 122),TempInt,TempStr);
            Inc(TempInt,17);
          end;
      end;

    // prices
    SetCanvas(bsClear,clWhite,psSolid,clBlack,[fsBold],clWindowText,12);
    If TotalPrice > 0 then
      begin
        If fPieces > 1 then
          TempStr := Format('%d (%d) Kè',[TotalPrice,UnitPrice])
        else
          TempStr := Format('%d Kè',[TotalPrice]);
        TextOut(Width - (TextWidth(TempStr) + 122),TempInt,TempStr);
      end;

    SetCanvas(bsClear,clWhite,psSolid,clBlack,[],clWindowText,10);
    If (fUnitPriceSelected <> fUnitPriceLowest) and (fUnitPriceSelected > 0) and (fUnitPriceLowest > 0) then
      begin
        If fPieces > 1 then
          TempStr := Format('%d (%d) Kè',[TotalPriceLowest,fUnitPriceLowest])
        else
          TempStr := Format('%d Kè',[TotalPriceLowest]);
        TextOut(Width - (TextWidth(TempStr) + 122),TempInt + 20,TempStr);
      end;

    // main picture
    If Assigned(fItemPicture) and not StaticOptions.NoPictures then
      Draw(Width - 103,5,fItemPicture)
    else
      Draw(Width - 103,5,fDataProvider.ItemDefaultPictures[fItemType]);

    // worst result indication
    If (fShopCount > 0) and (ilifWanted in fFlags) then
      begin
        SetCanvas(bsSolid,IL_ItemShopUpdateResultToColor(ShopsWorstUpdateResult),psClear);
        Polygon([Point(Width - 15,0),Point(Width,0),Point(Width,15)]);
      end;

    // picture presence indication
    DrawPictureIndication(Assigned(fItemPicture),Length(fItemPictureFile) > 0,0,0);
    DrawPictureIndication(Assigned(fSecondaryPicture),Length(fSecondaryPictureFile) > 0,0,1);
    DrawPictureIndication(Assigned(fPackagePicture),Length(fPackagePictureFile) > 0,1,0);
  end;
end;

//------------------------------------------------------------------------------

procedure TILItem_Draw.ReDrawSmall;
const
  SIDE_STRIP_WIDTH  = 20;
var
  TempStr:  String;

  procedure SetCanvas(BStyle: TBrushStyle = bsClear; BColor: TColor = clWhite;
                      PStyle: TPenStyle = psSolid; PColor: TColor = clBlack;
                      FTStyle: TFontStyles = []; FTColor: TColor = clWindowText; FTSize: Integer = 8);
  begin
    fRenderSmall.Canvas.Brush.Style := BStyle;
    fRenderSmall.Canvas.Brush.Color := BColor;
    fRenderSmall.Canvas.Pen.Style := PStyle;
    fRenderSmall.Canvas.Pen.Color := PColor;
    fRenderSmall.Canvas.Font.Style := FTStyle;
    fRenderSmall.Canvas.Font.Color := FTColor;
    fRenderSmall.Canvas.Font.Size := FTSize;
  end;

begin
with fRenderSmall,fRenderSmall.Canvas do
  begin
    // background
    SetCanvas(bsSolid,clWhite,psClear);
    Rectangle(0,0,Width + 1,Height + 1);

    // title + count
    If fPieces > 1 then
      TempStr := Format('%s (%dx)',[TitleStr,fPieces])
    else
      TempStr := TitleStr;
    If ilifDiscarded in fFlags then
      begin
        SetCanvas(bsSolid,clBlack,psSolid,clBlack,[fsBold],clWhite,10);
        Rectangle(SIDE_STRIP_WIDTH - 1,0,SIDE_STRIP_WIDTH + TextWidth(TempStr) + 11,TextHeight(TempStr) + 10);
      end
    else SetCanvas(bsClear,clWhite,psSolid,clBlack,[fsBold],clWindowText,10);
    TextOut(SIDE_STRIP_WIDTH + 5,2,TempStr); 

    // type + size
    SetCanvas;
    TempStr := SizeStr;
    If Length(TempStr) > 0 then
      TextOut(SIDE_STRIP_WIDTH + 5,20,Format('%s - %s',[TypeStr,TempStr]))
    else
      TextOut(SIDE_STRIP_WIDTH + 5,20,TypeStr);

    // variant/color
    SetCanvas;
    TextOut(SIDE_STRIP_WIDTH + 5,35,fVariant);

    // lowest price
    SetCanvas;
    If fUnitPriceLowest > 0 then
      begin
        TempStr := Format('%d Kè',[fUnitPriceLowest]);
        TextOut(Width - 64 - TextWidth(TempStr),20,TempStr);
      end;

    // text and num tag
    SetCanvas(bsClear,clWhite,psSolid,clBlack,[],clGrayText);
    TempStr := '';
    If Length(fTextTag) > 0 then
      TempStr := fTextTag;
    If fNumTag <> 0 then
      TempStr := Format('%s [%d]',[TempStr,fNumTag]);
    If Length(TempStr) > 0 then
      TextOut(Width - 64 - TextWidth(TempStr),35,TempStr);

    // picture
    If Assigned(fItemPictureSmall) and not StaticOptions.NoPictures then
      Draw(Width - 54,2,fItemPictureSmall)
    else
      Draw(Width - 54,2,fDataProvider.ItemDefaultPicturesSmall[fItemType]);
  end;
end;

//------------------------------------------------------------------------------

class procedure TILItem_Draw.RenderSmallPicture(LargePicture: TBitmap; var SmallPicture: TBitmap);
begin
If Assigned(LargePicture) then
  begin
    If not Assigned(SmallPicture) then
      begin
        SmallPicture := TBitmap.Create;
        SmallPicture.PixelFormat := pf24bit;
        SmallPicture.Width := 48;
        SmallPicture.Height := 48;
      end;
    IL_PicShrink(LargePicture,SmallPicture);
  end
else
  If Assigned(SmallPicture) then
    FreeAndNil(SmallPicture);
end;

//------------------------------------------------------------------------------

procedure TILItem_Draw.RenderSmallItemPicture;
begin
RenderSmallPicture(fItemPicture,fItemPictureSmall);
end;

//------------------------------------------------------------------------------

procedure TILItem_Draw.RenderSmallSecondaryPicture;
begin
RenderSmallPicture(fSecondaryPicture,fSecondaryPictureSmall);
end;

//------------------------------------------------------------------------------

procedure TILItem_Draw.RenderSmallPackagePicture;
begin
RenderSmallPicture(fPackagePicture,fPackagePictureSmall);
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

//------------------------------------------------------------------------------

procedure TILItem_Draw.Initialize;
begin
inherited;
fMainWidth := 0;
fMainHeight := 0;
fSmallWidth := 0;
fSmallHeight := 0;
fRender.Width := fMainWidth;
fRender.Height := fMainHeight;
fRenderSmall.Width := fSmallWidth;
fRenderSmall.Height := fSmallHeight;
end;

//==============================================================================

procedure TILItem_Draw.ReinitDrawSize(MainList: TListBox; SmallList: TListBox);
begin
If (fMainWidth <> MainList.ClientWidth) or (fMainHeight <> MainList.ItemHeight) then
  begin
    fMainWidth := MainList.ClientWidth;
    fMainHeight := MainList.ItemHeight;
    fRender.Width := fMainWidth;
    fRender.Height := fMainHeight;
    fRender.Canvas.Font.Assign(MainList.Font);
    ReDrawMain;
    inherited UpdateMainList;   // so redraw is not called again
  end;
If (fSmallWidth <> SmallList.ClientWidth) or (fSmallHeight <> SmallList.ItemHeight) then
  begin
    fSmallWidth := SmallList.ClientWidth;
    fSmallHeight := SmallList.ItemHeight;
    fRenderSmall.Width := fSmallWidth;
    fRenderSmall.Height := fSmallHeight;
    fRenderSmall.Canvas.Font.Assign(SmallList.Font);
    ReDrawSmall;
    inherited UpdateSmallList;
  end;
end;

//------------------------------------------------------------------------------

procedure TILItem_Draw.ReinitSmallDrawSize(SmallWidth,SmallHeight: Integer; SmallFont: TFont);
begin
If (fSmallWidth <> SmallWidth) or (fSmallHeight <> SmallHeight) then
  begin
    fSmallWidth := SmallWidth;
    fSmallHeight := SmallHeight;
    fRenderSmall.Width := fSmallWidth;
    fRenderSmall.Height := fSmallHeight;
    fRenderSmall.Canvas.Font.Assign(SmallFont);
    ReDrawSmall;
    inherited UpdateSmallList;
  end;
end;

//------------------------------------------------------------------------------

procedure TILItem_Draw.ReDraw;
begin
ReDrawMain;
inherited UpdateMainList;
ReDrawSmall;
inherited UpdateSmallList;
end;

end.
