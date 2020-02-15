unit InflatablesList_ShownPicturesManager;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  Graphics, Controls, ExtCtrls,
  InflatablesList_Types,
  InflatablesList_ItemPictures,
  InflatablesList_Manager;

type
  TILShownPicturesManagerEntry = record
    PictureKind:  TLIItemPictureKind;
    OldPicture:   TBitmap;
    Picture:      TBitmap;
    Image:        TImage;
    Background:   TControl;
  end;

  TILShownPicturesManager = class(TObject)
  private
    fILManager:     TILManager;
    fRightAnchor:   Integer;
    fLeft:          TControl;
    fRight:         TControl;
    fImages:        array[0..2] of TILShownPicturesManagerEntry;
    fPictures:      TILItemPictures;
  public
    constructor Create(ILManager: TILManager; RightAnchor: Integer; Left,Right: TControl; ImgA,ImgB,ImgC: TImage; BcgrA,BcgrB,BcgrC: TControl);
    Function Kind(Image: TImage): TLIItemPictureKind; virtual;
    Function Image(PictureKind: TLIItemPictureKind): TImage; virtual;
    procedure ShowPictures(Pictures: TILItemPictures);
    procedure UpdateSecondary; virtual;
  end;

implementation

uses
  InflatablesList_Utils,
  InflatablesList_Item;

constructor TILShownPicturesManager.Create(ILManager: TILManager; RightAnchor: Integer; Left,Right: TControl; ImgA,ImgB,ImgC: TImage; BcgrA,BcgrB,BcgrC: TControl);
begin
inherited Create;
fILManager := ILManager;
fRightAnchor := RightAnchor;
fLeft := Left;
fRight := Right;
Fillchar(fImages,SizeOf(fImages),0);
fImages[0].Image := ImgC;
fImages[0].Background := BcgrC;
fImages[1].Image := ImgB;
fImages[1].Background := BcgrB;
fImages[2].Image := ImgA;
fImages[2].Background := BcgrA;
fPictures := nil;
end;

//------------------------------------------------------------------------------

Function TILShownPicturesManager.Kind(Image: TImage): TLIItemPictureKind;
var
  i:  Integer;
begin
Result := ilipkUnknown;
For i := Low(fImages) to High(fImages) do
  If fImages[i].Image = Image then
    begin
      Result := fImages[i].PictureKind;
      Break{For i};
    end;
end;

//------------------------------------------------------------------------------

Function TILShownPicturesManager.Image(PictureKind: TLIItemPictureKind): TImage;
var
  i:  Integer;
begin
Result := nil;
For i := Low(fImages) to High(fImages) do
  If fImages[i].PictureKind = PictureKind then
    begin
      Result := fImages[i].Image;
      Break{For i};
    end;
end;

//------------------------------------------------------------------------------

procedure TILShownPicturesManager.ShowPictures(Pictures: TILItemPictures);
const
  SPACING = 8;
var
  i:              Integer;
  TempInt:        Integer;
  ArrowsVisible:  Boolean;
  SecCount:       Integer;

  Function AssignPic(Index: Integer; PictureKind: TLIItemPictureKind): Boolean;
  begin
    Result := False;
    If fPictures.CheckIndex(Index) then
      begin
        fImages[i].PictureKind := PictureKind;
        fImages[i].Picture := fPictures[Index].Thumbnail;
        Result := True;
      end
  end;

begin
fPictures := Pictures;
If Assigned(fPictures) then
  begin
    For i := Low(fImages) to High(fImages) do
      begin
        fImages[i].PictureKind := ilipkUnknown;
        fImages[i].OldPicture := fImages[i].Picture;
        fImages[i].Picture := nil;
      end;
    i := Low(fImages);
    // assign pictures
    If AssignPic(fPictures.IndexOfPackagePicture,ilipkPackage) then Inc(i);
    If AssignPic(fPictures.CurrentSecondary,ilipkSecondary) then Inc(i);
    If AssignPic(fPictures.IndexOfItemPicture,ilipkMain) then Inc(i);
    For i := Low(fImages) to High(fImages) do
      begin
        If not Assigned(fImages[i].Picture) and (fImages[i].PictureKind <> ilipkUnknown) then
          begin
            If fImages[i].PictureKind = ilipkMain then
              fImages[i].Picture := fILManager.DataProvider.ItemDefaultPictures[TILItem(fPictures.Owner).ItemType]
            else
              fImages[i].Picture := fILManager.DataProvider.EmptyPicture;
          end;
        If fImages[i].Picture <> fImages[i].OldPicture then
          begin
            fImages[i].Image.Picture.Assign(fImages[i].Picture);
            fImages[i].Image.ShowHint := fImages[i].PictureKind <> ilipkUnknown;
            fImages[i].Background.Visible := not Assigned(fImages[i].Picture);
          end;
        If (fImages[i].PictureKind = ilipkSecondary) and (fPictures.SecondaryCount(False) > 1) then
          fImages[i].Image.Hint := IL_ItemPictureKindToStr(fImages[i].PictureKind,True) + IL_Format(' %d/%d',
            [fPictures.SecondaryIndex(fPictures.CurrentSecondary) + 1,fPictures.SecondaryCount(False)])
        else
          fImages[i].Image.Hint := IL_ItemPictureKindToStr(fImages[i].PictureKind,True);
      end; 
    // realign
    TempInt := fRightAnchor;
    ArrowsVisible := False;
    SecCount := fPictures.SecondaryCount(False);
    For i := Low(fImages) to High(fImages) do
      begin
        If (fImages[i].PictureKind = ilipkSecondary) and (SecCount > 1) then
          begin
            fRight.Left := TempInt - fRight.Width;
            fImages[i].Image.Left := fRight.Left - fImages[i].Image.Width - SPACING;
            fLeft.Left := fImages[i].Image.Left - fLeft.Width - SPACING;
            TempInt := fLeft.Left - SPACING;
            ArrowsVisible := True;
          end
        else
          begin
            fImages[i].Image.Left := TempInt - fImages[i].Image.Width;
            TempInt := fImages[i].Image.Left - SPACING;
          end;
        fImages[i].Background.Left := fImages[i].Image.Left + (fImages[i].Image.Width - fImages[i].Background.Width) div 2;
      end;
    fLeft.Visible := ArrowsVisible;
    fRight.Visible := ArrowsVisible;
  end
else
  begin
    TempInt := fRightAnchor;
    For i := Low(fImages) to High(fImages) do
      begin
        fImages[i].PictureKind := ilipkUnknown;
        fImages[i].Picture := nil;
        fImages[i].Image.Picture.Assign(nil);
        fImages[i].Image.ShowHint := False;
        fImages[i].Image.Left := TempInt - fImages[i].Image.Width;
        fImages[i].Background.Visible := True;        
        fImages[i].Background.Left := fImages[i].Image.Left + (fImages[i].Image.Width - fImages[i].Background.Width) div 2;        
        Dec(TempInt,fImages[i].Image.Width + SPACING);
      end;
  end;
end;

//------------------------------------------------------------------------------

procedure TILShownPicturesManager.UpdateSecondary;
var
  i:  Integer;
begin
// find where is secondary assigned
If Assigned(fPictures) then
  For i := Low(fImages) to High(fImages) do
    If fImages[i].PictureKind = ilipkSecondary then
      begin
        If fPictures.CheckIndex(fPictures.CurrentSecondary) then
          begin
            If fImages[i].Picture <> fPictures[fPictures.CurrentSecondary].Thumbnail then
              begin
                If Assigned(fPictures[fPictures.CurrentSecondary].Thumbnail) then
                  fImages[i].Picture := fPictures[fPictures.CurrentSecondary].Thumbnail
                else
                  fImages[i].Picture := fILManager.DataProvider.EmptyPicture;
                fImages[i].Image.Picture.Assign(fImages[i].Picture);
              end;
            If fPictures.SecondaryCount(False) > 1 then
              fImages[i].Image.Hint := IL_ItemPictureKindToStr(fImages[i].PictureKind,True) + IL_Format(' %d/%d',
                [fPictures.SecondaryIndex(fPictures.CurrentSecondary) + 1,fPictures.SecondaryCount(False)])
            else
              fImages[i].Image.Hint := IL_ItemPictureKindToStr(fImages[i].PictureKind,True);
          end;
        Break{For i};
      end;
end;

end.
