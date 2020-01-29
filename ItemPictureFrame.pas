unit ItemPictureFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ExtCtrls, StdCtrls,
  InflatablesList_ItemPictures,
  InflatablesList_Manager;

type
  TfrmItemPictureFrame = class(TFrame)
    pnlMain: TPanel;
    shbPicsBackground: TShape;
    lblThumbFull: TLabel;
    imgThumbFull: TImage;
    shpThumbFull: TShape;
    lblThumbHalf: TLabel;
    imgThumbHalf: TImage;
    shpThumbHalf: TShape;
    lblThumbThirdth: TLabel;
    imgThumbThirdth: TImage;
    shpThumbThirdth: TShape;
    btnViewPicture: TButton;
    procedure imgThumbFullClick(Sender: TObject);
    procedure imgThumbHalfClick(Sender: TObject);
    procedure imgThumbThirdthClick(Sender: TObject);
    procedure btnViewPictureClick(Sender: TObject);
  private
    fILManager:       TILManager;
    fCurrentPictures: TILItemPictures;
    fCurrentPicture:  Integer;
    fInitializing:    Boolean;  // not really used, but meh...
  protected
    Function ValidItem(PicturesManager: TILItemPictures; Index: Integer): Boolean;
    Function ValidCurrentItem: Boolean;
    // frame methods
    procedure FrameClear;
    procedure FrameSave;
    procedure FrameLoad;
  public
    procedure Initialize(ILManager: TILManager);
    procedure Finalize;
    procedure Save;
    procedure Load;
    procedure SetPicture(PicturesManager: TILItemPictures; Index: Integer; ProcessChange: Boolean);
  end;

implementation

uses
  InflatablesList_ItemPictures_Base;

{$R *.dfm}

Function TfrmItemPictureFrame.ValidItem(PicturesManager: TILItemPictures; Index: Integer): Boolean;
begin
If Assigned(PicturesManager) then
  Result := PicturesManager.CheckIndex(Index)
else
  REsult := False;
end;

//------------------------------------------------------------------------------

Function TfrmItemPictureFrame.ValidCurrentItem: Boolean;
begin
Result := ValidItem(self.fCurrentPictures,fCurrentPicture);
end;

//------------------------------------------------------------------------------

procedure TfrmItemPictureFrame.FrameClear;
begin
imgThumbFull.Picture.Assign(nil);
shpThumbFull.Visible := True;
imgThumbHalf.Picture.Assign(nil);
shpThumbHalf.Visible := True;
imgThumbThirdth.Picture.Assign(nil);
shpThumbThirdth.Visible := True;
end;

//------------------------------------------------------------------------------

procedure TfrmItemPictureFrame.FrameSave;
begin
// do nothing
end;

//------------------------------------------------------------------------------

procedure TfrmItemPictureFrame.FrameLoad;
begin
If ValidCurrentItem then
  begin
    fInitializing := True;
    try
      imgThumbFull.Picture.Assign(fCurrentPictures[fCurrentPicture].Thumbnail);
      shpThumbFull.Visible := not Assigned(fCurrentPictures[fCurrentPicture].Thumbnail);
      imgThumbHalf.Picture.Assign(fCurrentPictures[fCurrentPicture].ThumbnailSmall);
      shpThumbHalf.Visible := not Assigned(fCurrentPictures[fCurrentPicture].ThumbnailSmall);
      imgThumbThirdth.Picture.Assign(fCurrentPictures[fCurrentPicture].ThumbnailMini);
      shpThumbThirdth.Visible := not Assigned(fCurrentPictures[fCurrentPicture].ThumbnailMini);
    finally
      fInitializing := False;
    end;
  end;
end;

//==============================================================================

procedure TfrmItemPictureFrame.Initialize(ILManager: TILManager);
begin
fILManager := ILManager;
end;

//------------------------------------------------------------------------------

procedure TfrmItemPictureFrame.Finalize;
begin
// nothing to do
end;

//------------------------------------------------------------------------------

procedure TfrmItemPictureFrame.Save;
begin
FrameSave;
end;

//------------------------------------------------------------------------------

procedure TfrmItemPictureFrame.Load;
begin
FrameLoad;
end;

//------------------------------------------------------------------------------

procedure TfrmItemPictureFrame.SetPicture(PicturesManager: TILItemPictures; Index: Integer; ProcessChange: Boolean);
var
  Reassigned: Boolean;
begin
Reassigned := (fCurrentPictures = PicturesManager) and (fCurrentPicture = Index);
If ProcessChange then
  begin
    If ValidCurrentItem and not Reassigned then
      FrameSave;
    If ValidItem(PicturesManager,Index) then
      begin
        fCurrentPictures := PicturesManager;
        fCurrentPicture := Index;
        If not Reassigned then
          FrameLoad;
      end
    else
      begin
        fCurrentPictures := nil;
        fCurrentPicture := -1;
        FrameClear;
      end;
    Visible := ValidCurrentItem;
    Enabled := ValidCurrentItem;
  end
else
  begin
    fCurrentPictures := PicturesManager;
    fCurrentPicture := Index;
  end;
end;

//==============================================================================

procedure TfrmItemPictureFrame.imgThumbFullClick(Sender: TObject);
begin
If ValidCurrentItem then
  fCurrentPictures.OpenThumbnailFile(fCurrentPicture,iltsFull);
end;

//------------------------------------------------------------------------------

procedure TfrmItemPictureFrame.imgThumbHalfClick(Sender: TObject);
begin
If ValidCurrentItem then
  fCurrentPictures.OpenThumbnailFile(fCurrentPicture,iltsSmall);
end;

//------------------------------------------------------------------------------

procedure TfrmItemPictureFrame.imgThumbThirdthClick(Sender: TObject);
begin
If ValidCurrentItem then
  fCurrentPictures.OpenThumbnailFile(fCurrentPicture,iltsMini);
end;

//------------------------------------------------------------------------------

procedure TfrmItemPictureFrame.btnViewPictureClick(Sender: TObject);
begin
If ValidCurrentItem then
  fCurrentPictures.OpenPictureFile(fCurrentPicture);
end;

end.
