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
    fSmallWidth:  Integer;
    fSmallHeight: Integer;
    fSmallFont:   TFont;
    procedure ReDrawMain; virtual;
    procedure ReDrawSmall; virtual;
    procedure RenderSmallItemPicture; override;
    procedure RenderSmallSecondaryPicture; override;
    procedure RenderSmallPackagePicture; override;
    procedure UpdateMainList; override;
    procedure UpdateSmallList; override;
  public
    procedure Initialize; override;
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
  WL_STRIP_WIDTH  = 20;
var
  TempStr:  String;
  TempInt:  Integer;
  ItemFlag: TILItemFlag;
  SelShop:  TILItemShop;

  procedure SetCanvas(BStyle: TBrushStyle = bsClear; BColor: TColor = clWhite;
                      PStyle: TPenStyle = psSolid; PColor: TColor = clBlack;
                      FTStyle: TFontStyles = []; FTColor: TColor = clWindowText; FTSize: Integer = 10);
  begin
    // reset brush, pen and font to default settings
    fRender.Canvas.Brush.Style := BStyle;
    fRender.Canvas.Brush.Color := BColor;
    fRender.Canvas.Pen.Style := PStyle;
    fRender.Canvas.Pen.Color := PColor;
    fRender.Canvas.Font.Style := FTStyle;
    fRender.Canvas.Font.Color := FTColor;
    fRender.Canvas.Font.Size := FTSize;
  end;

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
    SetCanvas(bsSolid,clWhite,psClear);
    Rectangle(0,0,Width + 1,Height + 1);

    // wanted level strip
    SetCanvas(bsSolid,$00F7F7F7,psClear);
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
    If fPieces > 1 then
      TempStr := Format('%s (%dx)',[TitleStr,fPieces])
    else
      TempStr := TitleStr;
    If ilifDiscarded in fFlags then
      begin
        SetCanvas(bsSolid,clBlack,psSolid,clBlack,[fsBold],clWhite,12);
        Rectangle(WL_STRIP_WIDTH - 1,0,WL_STRIP_WIDTH + TextWidth(TempStr) + 11,TextHeight(TempStr) + 10);
      end
    else SetCanvas(bsClear,clWhite,psSolid,clBlack,[fsBold],clWindowText,12);
    TextOut(WL_STRIP_WIDTH + 5,5,TempStr);

    // type + size
    SetCanvas(bsClear,clWhite,psSolid,clBlack,[],clWindowText,10);
    TempStr := SizeStr;
    If Length(TempStr) > 0 then
      TextOut(WL_STRIP_WIDTH + 5,30,Format('%s - %s',[TypeStr,TempStr]))
    else
      TextOut(WL_STRIP_WIDTH + 5,30,TypeStr);

    // variant/color
    SetCanvas;
    TextOut(WL_STRIP_WIDTH + 5,50,fVariant);

    // flag icons
    SetCanvas;
    TempInt := WL_STRIP_WIDTH + 5;
    For ItemFlag := Low(TILItemFlag) to High(TILItemFlag) do
      If ItemFlag in fFlags then
        begin
          Draw(TempInt,fMainHeight - (fDataProvider.ItemFlagIcons[ItemFlag].Height + 10),
               fDataProvider.ItemFlagIcons[ItemFlag]);
          Inc(TempInt,fDataProvider.ItemFlagIcons[ItemFlag].Width + 5);
        end;

    // review icon
    SetCanvas;
    If Length(fReviewURL) > 0 then
      begin
        Draw(TempInt,fMainHeight - (fDataProvider.ItemReviewIcon.Height + 10),fDataProvider.ItemReviewIcon);
        Inc(TempInt,fDataProvider.ItemReviewIcon.Width + 5);
      end;

    // text and num tag
    SetCanvas;
    If Length(fTextTag) > 0 then
      begin
        SetCanvas(bsClear,clWhite,psSolid,clBlack,[fsBold],clWindowText,8);
        TextOut(TempInt,fMainHeight - 25,fTextTag);
        Inc(TempInt,TextWidth(fTextTag) + 5);
      end;
    If fNumTag <> 0 then
      begin
        SetCanvas(bsClear,clWhite,psSolid,clBlack,[fsBold],clWindowText,8);
        TextOut(TempInt,fMainHeight - 25,Format('[%d]',[fNumTag]))
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
        TextOut(fMainWidth - (TextWidth(TempStr) + 122),TempInt,TempStr);
        Inc(TempInt,17);

        If fAvailableSelected <> 0 then
          begin
            If fAvailableSelected < 0 then
              TempStr := Format('more than %d pcs',[Abs(fAvailableSelected)])
            else
              TempStr := Format('%d pcs',[fAvailableSelected]);
            TextOut(fMainWidth - (TextWidth(TempStr) + 122),TempInt,TempStr);
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
        TextOut(fMainWidth - (TextWidth(TempStr) + 122),TempInt,TempStr);
      end;

    SetCanvas(bsClear,clWhite,psSolid,clBlack,[],clWindowText,10);
    If (fUnitPriceSelected <> fUnitPriceLowest) and (fUnitPriceSelected > 0) and (fUnitPriceLowest > 0) then
      begin
        If fPieces > 1 then
          TempStr := Format('%d (%d) Kè',[TotalPriceLowest,fUnitPriceLowest])
        else
          TempStr := Format('%d Kè',[TotalPriceLowest]);
        TextOut(fMainWidth - (TextWidth(TempStr) + 122),TempInt + 20,TempStr);
      end;

    // rating strip
    If (fRating <> 0) and (ilifOwned in fFLags) and not(ilifWanted in fFlags) then
      begin
        TempInt := fMainHeight - Ceil((fMainHeight * Integer(fRating)) / 100);
        CopyRect(Rect(fMainWidth - 5,TempInt,fMainWidth,fMainHeight),
                 fDataProvider.RatingGradientImage.Canvas,
                 Rect(0,TempInt,5,fMainHeight)); 
      end;

    // main picture
    If Assigned(fItemPicture) and not StaticOptions.NoPictures then
      Draw(fMainWidth - 106,5,fItemPicture)
    else
      Draw(fMainWidth - 106,5,fDataProvider.ItemDefaultPictures[fItemType]);

    // worst result indication
    If (fShopCount > 0) and (ilifWanted in fFlags) then
      begin
        SetCanvas(bsSolid,IL_ItemShopUpdateResultToColor(ShopsWorstUpdateResult),psClear);
        Polygon([Point(fMainWidth - 15,0),Point(fMainWidth,0),Point(fMainWidth,15)]);
      end;
  end;
end;

//------------------------------------------------------------------------------

procedure TILItem_Draw.ReDrawSmall;
const
  WL_STRIP_WIDTH  = 20;
var
  TempStr:  String;

  procedure SetCanvas(BStyle: TBrushStyle = bsClear; BColor: TColor = clWhite;
                      PStyle: TPenStyle = psSolid; PColor: TColor = clBlack;
                      FTStyle: TFontStyles = []; FTColor: TColor = clWindowText; FTSize: Integer = 8);
  begin
    // reset brush, pen and font to default settings
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
    Font := fSmallFont;

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
        Rectangle(WL_STRIP_WIDTH - 1,0,WL_STRIP_WIDTH + TextWidth(TempStr) + 11,TextHeight(TempStr) + 10);
      end
    else SetCanvas(bsClear,clWhite,psSolid,clBlack,[fsBold],clWindowText,10);
    TextOut(WL_STRIP_WIDTH + 5,2,TempStr); 

    // type + size
    SetCanvas;
    TempStr := SizeStr;
    If Length(TempStr) > 0 then
      TextOut(WL_STRIP_WIDTH + 5,20,Format('%s - %s',[TypeStr,TempStr]))
    else
      TextOut(WL_STRIP_WIDTH + 5,20,TypeStr);

    // variant/color
    SetCanvas;
    TextOut(WL_STRIP_WIDTH + 5,35,fVariant);

    // lowest price
    SetCanvas;
    If fUnitPriceLowest > 0 then
      begin
        TempStr := Format('%d Kè',[fUnitPriceLowest]);
        TextOut(fSmallWidth - 64 - TextWidth(TempStr),20,TempStr);
      end;

    // text and num tag
    SetCanvas(bsClear,clWhite,psSolid,clBlack,[],clGrayText);
    TempStr := '';
    If Length(fTextTag) > 0 then
      TempStr := fTextTag;
    If fNumTag <> 0 then
      TempStr := Format('%s [%d]',[TempStr,fNumTag]);
    If Length(TempStr) > 0 then
      TextOut(fSmallWidth - 64 - TextWidth(TempStr),35,TempStr);

    // picture
    If Assigned(fItemPictureSmall) and not StaticOptions.NoPictures then
      Draw(fSmallWidth - 54,2,fItemPictureSmall)
    else
      Draw(fSmallWidth - 54,2,fDataProvider.ItemDefaultPicturesSmall[fItemType]);
  end;
end;

//------------------------------------------------------------------------------

procedure TILItem_Draw.RenderSmallItemPicture;
begin
If Assigned(fItemPicture) then
  begin
    If not Assigned(fItemPictureSmall) then
      begin
        fItemPictureSmall := TBitmap.Create;
        fItemPictureSmall.PixelFormat := pf24bit;
        fItemPictureSmall.Width := 48;
        fItemPictureSmall.Height := 48;
      end;
    IL_PicShrink(fItemPicture,fItemPictureSmall);
  end
else
  If Assigned(fItemPictureSmall) then
    FreeAndNil(fItemPictureSmall);
end;

//------------------------------------------------------------------------------

procedure TILItem_Draw.RenderSmallSecondaryPicture;
begin
If Assigned(fSecondaryPicture) then
  begin
    If not Assigned(fSecondaryPictureSmall) then
      begin
        fSecondaryPictureSmall := TBitmap.Create;
        fSecondaryPictureSmall.PixelFormat := pf24bit;
        fSecondaryPictureSmall.Width := 48;
        fSecondaryPictureSmall.Height := 48;
      end;
    IL_PicShrink(fSecondaryPicture,fSecondaryPictureSmall);
  end
else
  If Assigned(fSecondaryPictureSmall) then
    FreeAndNil(fSecondaryPictureSmall);
end;

//------------------------------------------------------------------------------

procedure TILItem_Draw.RenderSmallPackagePicture;
begin
If Assigned(fPackagePicture) then
  begin
    If not Assigned(fPackagePictureSmall) then
      begin
        fPackagePictureSmall := TBitmap.Create;
        fPackagePictureSmall.PixelFormat := pf24bit;
        fPackagePictureSmall.Width := 48;
        fPackagePictureSmall.Height := 48;
      end;
    IL_PicShrink(fPackagePicture,fPackagePictureSmall);
  end
else
  If Assigned(fPackagePictureSmall) then
    FreeAndNil(fPackagePictureSmall);
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
fSmallWidth := 0;
fSmallHeight := 0;
fSmallFont := nil;
fRender.Width := fMainWidth;
fRender.Height := fMainHeight;
fRenderSmall.Width := fSmallWidth;
fRenderSmall.Height := fSmallHeight;
end;

//------------------------------------------------------------------------------

procedure TILItem_Draw.ReinitDrawSize(MainList: TListBox; SmallList: TListBox);
begin
If (fMainWidth <> MainList.ClientWidth) or (fMainHeight <> MainList.ItemHeight) then
  begin
    fMainWidth := MainList.ClientWidth;
    fMainHeight := MainList.ItemHeight;
    fMainFont := MainList.Font;
    fRender.Width := fMainWidth;
    fRender.Height := fMainHeight;
    ReDrawMain;
    inherited UpdateMainList;   // so redraw is not called again
  end;
If (fSmallWidth <> SmallList.ClientWidth) or (fSmallHeight <> SmallList.ItemHeight) then
  begin
    fSmallWidth := SmallList.ClientWidth;
    fSmallHeight := SmallList.ItemHeight;
    fSmallFont := SmallList.Font;
    fRenderSmall.Width := fSmallWidth;
    fRenderSmall.Height := fSmallHeight;
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
    fSmallFont := SmallFont;
    fRenderSmall.Width := fSmallWidth;
    fRenderSmall.Height := fSmallHeight;
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
