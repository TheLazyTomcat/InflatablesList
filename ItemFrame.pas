unit ItemFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ExtCtrls, StdCtrls, Spin, Menus,
  InflatablesList_Types,
  InflatablesList_ItemPictures,
  InflatablesList_Item,
  InflatablesList_Manager;

type
  TILItemFramePicturesManagerEntry = record
    PictureKind:  TLIItemPictureKind;
    OldPicture:   TBitmap;    
    Picture:      TBitmap;
    Image:        TImage;
    Background:   TControl;
  end;

  TILItemFramePicturesManager = class(TObject)
  private
    fILManager:     TILManager;
    fRightAnchor:   Integer;
    fLeft:          TControl;
    fRight:         TControl;
    fImages:        array[0..2] of TILItemFramePicturesManagerEntry;
    fPictures:      TILItemPictures;
  public
    constructor Create(ILManager: TILManager; RightAnchor: Integer; Left,Right: TControl; ImgA,ImgB,ImgC: TImage; BcgrA,BcgrB,BcgrC: TControl);
    Function Kind(Image: TImage): TLIItemPictureKind; virtual;
    Function Image(PictureKind: TLIItemPictureKind): TImage; virtual;
    procedure ShowPictures(Pictures: TILItemPictures);
    procedure UpdateSecondary; virtual;
  end;

//******************************************************************************
//==============================================================================
//******************************************************************************

type
  TfrmItemFrame = class(TFrame)
    pnlMain: TPanel;
    shpItemTitleBcgr: TShape;
    imgItemLock: TImage;    
    lblItemTitle: TLabel;
    lblItemTitleShadow: TLabel;
    shpHighlight: TShape;
    tmrSecondaryPics: TTimer;    
    tmrHighlightTimer: TTimer;
    imgManufacturerLogo: TImage;
    imgPrevPicture: TImage;
    imgNextPicture: TImage;
    imgPictureA: TImage;
    imgPictureB: TImage;
    imgPictureC: TImage;
    shpPictureABcgr: TShape;
    shpPictureBBcgr: TShape;
    shpPictureCBcgr: TShape;    
    lblUniqueID: TLabel;
    lblTimeOfAddition: TLabel;
    lblItemType: TLabel;
    cmbItemType: TComboBox;
    leItemTypeSpecification: TLabeledEdit;
    lblPieces: TLabel;
    sePieces: TSpinEdit;
    leUserID: TLabeledEdit;
    btnUserIDGen: TButton;
    lblManufacturer: TLabel;
    cmbManufacturer: TComboBox;
    leManufacturerString: TLabeledEdit;
    leTextID: TLabeledEdit;
    lblID: TLabel;
    seNumID: TSpinEdit;
    gbFlagsTags: TGroupBox;
    cbFlagOwned: TCheckBox;
    cbFlagWanted: TCheckBox;
    cbFlagOrdered: TCheckBox;
    cbFlagUntested: TCheckBox;
    cbFlagTesting: TCheckBox;
    cbFlagTested: TCheckBox;
    cbFlagBoxed: TCheckBox;
    cbFlagDamaged: TCheckBox;
    cbFlagRepaired: TCheckBox;
    cbFlagElsewhere: TCheckBox;
    cbFlagPriceChange: TCheckBox;
    cbFlagAvailChange: TCheckBox;
    cbFlagNotAvailable: TCheckBox;
    cbFlagLost: TCheckBox;
    cbFlagDiscarded: TCheckBox;
    btnFlagMacros: TButton;
    pmnFlagMacros: TPopupMenu;
    bvlTagSep: TBevel;
    lblTextTag: TLabel;
    eTextTag: TEdit;
    lblNumTag: TLabel;
    seNumTag: TSpinEdit;    
    lblWantedLevel: TLabel;
    seWantedLevel: TSpinEdit;
    leVariant: TLabeledEdit;
    leVariantTag: TLabeledEdit;
    lblSurfaceFinish: TLabel;
    cmbSurfaceFinish: TComboBox;
    lblMaterial: TLabel;
    cmbMaterial: TComboBox;
    lblThickness: TLabel;
    seThickness: TSpinEdit;
    lblSizeX: TLabel;
    seSizeX: TSpinEdit;
    lblSizeY: TLabel;
    seSizeY: TSpinEdit;
    lblSizeZ: TLabel;
    seSizeZ: TSpinEdit;
    lblUnitWeight: TLabel;
    seUnitWeight: TSpinEdit;
    lblNotes: TLabel;
    meNotes: TMemo;
    lblNotesEdit: TLabel;    
    leReviewURL: TLabeledEdit;
    btnReviewOpen: TButton;
    lblUnitDefaultPrice: TLabel;
    seUnitPriceDefault: TSpinEdit;
    lblRating: TLabel;
    seRating: TSpinEdit;
    lblRatingDetails: TLabel;    
    btnRatingDetails: TButton;    
    btnPictures: TButton;
    btnShops: TButton;
    btnUpdateShops: TButton;
    gbReadOnlyInfo: TGroupBox;
    lblPictureCountTitle: TLabel;
    lblPictureCount: TLabel;
    lblSelectedShop: TLabel;
    lblSelectedShopTitle: TLabel;
    lblShopCountTitle: TLabel;
    lblShopCount: TLabel;
    lblAvailPiecesTitle: TLabel;
    lblUnitPriceLowestTitle: TLabel;
    lblUnitPriceSelectedTitle: TLabel;
    lblAvailPieces: TLabel;
    lblUnitPriceLowest: TLabel;
    lblUnitPriceSelected: TLabel;
    shpUnitPriceSelectedBcgr: TShape;
    lblTotalWeightTitle: TLabel;
    lblTotalWeight: TLabel;
    lblTotalPriceLowest: TLabel;
    lblTotalPriceLowestTitle: TLabel;
    lblTotalPriceSelectedTitle: TLabel;
    lblTotalPriceSelected: TLabel;
    shpTotalPriceSelectedBcgr: TShape;
    procedure FrameResize(Sender: TObject);
    procedure lblItemTitleClick(Sender: TObject);
    procedure tmrSecondaryPicsTimer(Sender: TObject);
    procedure tmrHighlightTimerTimer(Sender: TObject);
    procedure imgPrevPictureMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure imgPrevPictureMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgNextPictureMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure imgNextPictureMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);      
    procedure imgPictureClick(Sender: TObject); 
    procedure cmbItemTypeChange(Sender: TObject);
    procedure leItemTypeSpecificationChange(Sender: TObject);
    procedure sePiecesChange(Sender: TObject);
    procedure leUserIDChange(Sender: TObject);
    procedure btnUserIDGenClick(Sender: TObject);    
    procedure cmbManufacturerChange(Sender: TObject);
    procedure leManufacturerStringChange(Sender: TObject);
    procedure leTextIDChange(Sender: TObject);
    procedure seNumIDChange(Sender: TObject);
    procedure CommonFlagClick(Sender: TObject);
    procedure btnFlagMacrosClick(Sender: TObject);
    procedure CommonFlagMacroClick(Sender: TObject);
    procedure eTextTagChange(Sender: TObject);
    procedure seNumTagChange(Sender: TObject);
    procedure seWantedLevelChange(Sender: TObject);
    procedure leVariantChange(Sender: TObject);
    procedure cmbSurfaceFinishChange(Sender: TObject);
    procedure cmbMaterialChange(Sender: TObject);
    procedure seSizeXChange(Sender: TObject);
    procedure seSizeYChange(Sender: TObject);
    procedure seSizeZChange(Sender: TObject);
    procedure seUnitWeightChange(Sender: TObject);
    procedure meNotesKeyPress(Sender: TObject; var Key: Char);
    procedure lblNotesEditClick(Sender: TObject);
    procedure lblNotesEditMouseEnter(Sender: TObject);
    procedure lblNotesEditMouseLeave(Sender: TObject);
    procedure leReviewURLChange(Sender: TObject);
    procedure btnReviewOpenClick(Sender: TObject);
    procedure seUnitPriceDefaultChange(Sender: TObject);
    procedure seRatingChange(Sender: TObject);
    procedure btnRatingDetailsClick(Sender: TObject);
    procedure btnPicturesClick(Sender: TObject);
    procedure btnShopsClick(Sender: TObject);
    procedure btnUpdateShopsClick(Sender: TObject);
  private
    // other fields
    fPicturesManager: TILItemFramePicturesManager;    
    fInitializing:    Boolean;
    fILManager:       TILManager;
    fCurrentItem:     TILItem;
    // searching
    fLastFoundValue:  TILItemSearchResult;
    // picture arrows
    fPicArrowLeft:    TBitmap;
    fPicArrowRight:   TBitmap;
    fPicArrowLeftD:   TBitmap;
    fPicArrowRightD:  TBitmap;
  protected
    // item event handlers (manager)
    procedure UpdateTitle(Sender: TObject; Item: TObject);
    procedure UpdatePictures(Sender: TObject; Item: TObject);
    procedure UpdateFlags(Sender: TObject; Item: TObject);
    procedure UpdateValues(Sender: TObject; Item: TObject);
    procedure UpdateOthers(Sender: TObject; Item: TObject);
    // helper methods
    procedure ReplaceManufacturerLogo;
    procedure FillFlagsFromItem;
    procedure FillValues;
    procedure FillSelectedShop(const SelectedShop: String);
    // searching
    procedure DisableHighlight;
    procedure Highlight(Control: TControl); overload;
    procedure HighLight(Value: TILItemSearchResult); overload;
    // initialization
    procedure BuildFlagMacrosMenu;
    procedure PrepareArrows;
    // frame methods
    procedure FrameClear;
    procedure FrameSave;
    procedure FrameLoad;
  public
    OnShowSelectedItem: TNotifyEvent;
    OnFocusList:        TNotifyEvent;
    procedure Initialize(ILManager: TILManager);
    procedure Finalize;
    procedure Save;
    procedure Load;
    procedure SetItem(Item: TILItem; ProcessChange: Boolean);
    procedure FindPrev(const Text: String);
    procedure FindNext(const Text: String);    
  end;

implementation

uses
  Themes,
  StrRect,
  TextEditForm, ItemPicturesForm, ShopsForm, UpdateForm, 
  InflatablesList_Utils,
  InflatablesList_LocalStrings,
  InflatablesList_Data,
  InflatablesList_ItemShop;

{$R *.dfm}

{$R '..\resources\pic_arrows.res'}

const
  IL_SEARCH_HIGHLIGHT_TIMEOUT = 12; // 3 seconds highlight

  IL_FLAGMACRO_CAPTIONS: array[0..4] of String = (
    'Ordered item received',
    'Starting item testing',
    'Testing of item is finished',
    'Damage has been repaired',
    'Price and availability change checked');

//==============================================================================

constructor TILItemFramePicturesManager.Create(ILManager: TILManager; RightAnchor: Integer; Left,Right: TControl; ImgA,ImgB,ImgC: TImage; BcgrA,BcgrB,BcgrC: TControl);
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

Function TILItemFramePicturesManager.Kind(Image: TImage): TLIItemPictureKind;
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

Function TILItemFramePicturesManager.Image(PictureKind: TLIItemPictureKind): TImage;
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

procedure TILItemFramePicturesManager.ShowPictures(Pictures: TILItemPictures);
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

procedure TILItemFramePicturesManager.UpdateSecondary;
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

//******************************************************************************
//==============================================================================
//******************************************************************************

procedure TfrmItemFrame.UpdateTitle(Sender: TObject; Item: TObject);
var
  ManufStr: String;
  TypeStr:  String;
begin
If Assigned(fCurrentItem) and (Item = fCurrentItem) then
  begin
    // construct manufacturer + ID string
    ManufStr := fCurrentItem.TitleStr;
    // constructy item type string
    TypeStr := fCurrentItem.TypeStr;
    // final concatenation
    If Length(TypeStr) > 0 then
      ManufStr := IL_Format('%s - %s',[ManufStr,TypeStr]);
    If fCurrentItem.Pieces > 1 then
      ManufStr := IL_Format('%s (%dx)',[ManufStr,fCurrentItem.Pieces]);
    lblItemTitle.Caption := ManufStr;
    lblItemTitleShadow.Caption := lblItemTitle.Caption;
  end
else
  begin
    lblItemTitle.Caption := '';
    lblItemTitleShadow.Caption := '';
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.UpdatePictures(Sender: TObject; Item: TObject);
begin
DisableHighlight;
If Assigned(fCurrentItem) and (Item = fCurrentItem) and not fILManager.StaticSettings.NoPictures then
  fPicturesManager.ShowPictures(fCurrentItem.Pictures)
else
  fPicturesManager.ShowPictures(nil);
If Assigned(fCurrentItem) then
  lblPictureCount.Caption := fCurrentItem.PictureCountStr
else
  lblPictureCount.Caption := '-';
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.UpdateFlags(Sender: TObject; Item: TObject);
begin
If Assigned(fCurrentItem) and (Item = fCurrentItem) then
  begin
    fInitializing := True;
    try
      FillFlagsFromItem;
    finally
      fInitializing := False;
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.UpdateValues(Sender: TObject; Item: TObject);
begin
If Assigned(fCurrentItem) and (Item = fCurrentItem) then
  FillValues;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.UpdateOthers(Sender: TObject; Item: TObject);
begin
If Assigned(fCurrentItem) and (Item = fCurrentItem) then
  begin
    // item lock icon
    imgItemLock.Visible := fCurrentItem.Encrypted;
    lblRatingDetails.Visible := Length(fCurrentItem.RatingDetails) > 0;
  end
else
  begin
    imgItemLock.Visible := False;
    lblRatingDetails.Visible := False;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.ReplaceManufacturerLogo;
begin
If Assigned(fCurrentItem) then
  begin
    If imgManufacturerLogo.Tag <> Ord(fCurrentItem.Manufacturer) then
      imgManufacturerLogo.Picture.Assign(
        fILManager.DataProvider.ItemManufacturers[fCurrentItem.Manufacturer].Logo);
    imgManufacturerLogo.Tag := Ord(fCurrentItem.Manufacturer);
  end
else
  begin
    imgManufacturerLogo.Picture.Assign(nil);
    imgManufacturerLogo.Tag := -1;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.FillFlagsFromItem;
begin
If fInitializing and Assigned(fCurrentItem) then
  begin
    cbFlagOwned.Checked := ilifOwned in fCurrentItem.Flags;
    cbFlagWanted.Checked := ilifWanted in fCurrentItem.Flags;
    cbFlagOrdered.Checked := ilifOrdered in fCurrentItem.Flags;
    cbFlagBoxed.Checked := ilifBoxed in fCurrentItem.Flags;
    cbFlagElsewhere.Checked := ilifElsewhere in fCurrentItem.Flags;
    cbFlagUntested.Checked := ilifUntested in fCurrentItem.Flags;
    cbFlagTesting.Checked := ilifTesting in fCurrentItem.Flags;
    cbFlagTested.Checked := ilifTested in fCurrentItem.Flags;
    cbFlagDamaged.Checked := ilifDamaged in fCurrentItem.Flags;
    cbFlagRepaired.Checked := ilifRepaired in fCurrentItem.Flags;
    cbFlagPriceChange.Checked := ilifPriceChange in fCurrentItem.Flags;
    cbFlagAvailChange.Checked := ilifAvailChange in fCurrentItem.Flags;
    cbFlagNotAvailable.Checked := ilifNotAvailable in fCurrentItem.Flags;
    cbFlagLost.Checked := ilifLost in fCurrentItem.Flags;
    cbFlagDiscarded.Checked := ilifDiscarded in fCurrentItem.Flags;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.FillValues;
var
  SelectedShop: TILItemShop;
begin
If Assigned(fCurrentItem) then
  begin
    // selected shop
    If fCurrentItem.ShopsSelected(SelectedShop) then
      FillSelectedShop(SelectedShop.Name)
    else
      FillSelectedShop('-');
    // number of shops
    If fCurrentItem.ShopCount > 0 then
      lblShopCount.Caption := fCurrentItem.ShopsCountStr
    else
      lblShopCount.Caption := '-';
    // available pieces
    If fCurrentItem.IsAvailable(False) then
      begin
        If fCurrentItem.AvailableSelected < 0 then
          lblAvailPieces.Caption := 'more than ' + IntToStr(Abs(fCurrentItem.AvailableSelected))
        else
          lblAvailPieces.Caption := IntToStr(fCurrentItem.AvailableSelected);
      end
    else lblAvailPieces.Caption := '-';
    // total weight
    If fCurrentItem.TotalWeight > 0 then
      lblTotalWeight.Caption := fCurrentItem.TotalWeightStr
    else
      lblTotalWeight.Caption := '-';
    // price lowest
    If fCurrentItem.UnitPriceLowest > 0 then
      begin
        lblUnitPriceLowest.Caption := IL_Format('%d %s',[fCurrentItem.UnitPriceLowest,IL_CURRENCY_SYMBOL]);
        lblTotalPriceLowest.Caption := IL_Format('%d %s',[fCurrentItem.TotalPriceLowest,IL_CURRENCY_SYMBOL]);
      end
    else
      begin
        lblUnitPriceLowest.Caption := '-';
        lblTotalPriceLowest.Caption := '-';
      end;
    // price selected
    If fCurrentItem.UnitPriceSelected > 0 then
      begin
        lblUnitPriceSelected.Caption := IL_Format('%d %s',[fCurrentItem.UnitPriceSelected,IL_CURRENCY_SYMBOL]);
        lblTotalPriceSelected.Caption := IL_Format('%d %s',[fCurrentItem.TotalPriceSelected,IL_CURRENCY_SYMBOL]);
      end
    else
      begin
        lblUnitPriceSelected.Caption := '-';
        lblTotalPriceSelected.Caption := '-';
      end;
    // price selected background
    If (fCurrentItem.UnitPriceSelected <> fCurrentItem.UnitPriceLowest) and
      (fCurrentItem.UnitPriceSelected > 0) and (fCurrentItem.UnitPriceLowest > 0) then
      begin
        shpUnitPriceSelectedBcgr.Visible := True;
        shpTotalPriceSelectedBcgr.Visible := True;
      end
    else
      begin
        shpUnitPriceSelectedBcgr.Visible := False;
        shpTotalPriceSelectedBcgr.Visible := False;
      end;
  end
else
  begin
    FillSelectedShop('-');
    lblShopCount.Caption := '-';
    lblAvailPieces.Caption := '-';
    lblTotalWeight.Caption := '-';
    lblUnitPriceLowest.Caption := '-';
    lblTotalPriceLowest.Caption := '-';    
    lblUnitPriceSelected.Caption := '-';
    shpUnitPriceSelectedBcgr.Visible := False; 
    lblTotalPriceSelected.Caption := '-';
    shpTotalPriceSelectedBcgr.Visible := False;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.FillSelectedShop(const SelectedShop: String);
begin
If lblSelectedShop.Canvas.TextWidth(SelectedShop) <=
  (lblShopCount.BoundsRect.Right - lblSelectedShopTitle.BoundsRect.Right - 8) then
  lblSelectedShop.Left := lblShopCount.BoundsRect.Right - lblSelectedShop.Canvas.TextWidth(SelectedShop)
else
  lblSelectedShop.Left := lblSelectedShopTitle.BoundsRect.Right + 8;
lblSelectedShop.Caption := SelectedShop;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.DisableHighlight;
begin
shpHighlight.Visible := False;
fLastFoundValue := ilisrNone;
tmrHighlightTimer.Tag := 0;
tmrHighlightTimer.Enabled := False;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.Highlight(Control: TControl);
begin
If (Control is TComboBox) or (Control is TLabeledEdit) or
  ((Control is TSpinEdit) and (Control <> seNumTag)) then
  begin
    shpHighlight.Left := Control.Left + Control.Width - 15;
    shpHighlight.Top := Control.Top - 13;
    shpHighlight.Width := 16;
    shpHighlight.Height := 10;
  end
else If Control is TCheckBox then
  begin
    shpHighlight.Left := Control.Left - 5;
    shpHighlight.Top := Control.Top + 2;
    shpHighlight.Width := 5;
    shpHighlight.Height := Control.Height - 3;
  end
else If Control is TMemo then
  begin
    shpHighlight.Left := Control.Left + Control.Width - 35;
    shpHighlight.Top := Control.Top - 13;
    shpHighlight.Width := 16;
    shpHighlight.Height := 10;
  end
else If Control is TLabel then
  begin
    shpHighlight.Left := Control.Left - 6;
    shpHighlight.Top := Control.Top;
    shpHighlight.Width := 5;
    shpHighlight.Height := Control.Height + 1;
  end
else If Control is TImage then
  begin
    shpHighlight.Left := Control.Left;
    shpHighlight.Top := Control.Top + Control.Height + 1;
    shpHighlight.Width := Control.Width + 1;
    shpHighlight.Height := 5;
  end
// special cases
else If (Control = seNumTag) or (Control = eTextTag) then
  begin
    shpHighlight.Left := Control.Left - 5;
    shpHighlight.Top := Control.Top;
    shpHighlight.Width := 5;
    shpHighlight.Height := Control.Height + 1;
  end
else If Control = btnRatingDetails then
  begin
    shpHighlight.Left := Control.Left;
    shpHighlight.Top := Control.Top - 6;
    shpHighlight.Width := lblRatingDetails.Left - shpHighlight.Left;
    shpHighlight.Height := 5;
  end
else Exit;  // control is not valid
shpHighlight.Parent := Control.Parent;
shpHighlight.Visible := True;
If Control is TLabel then
  Control.BringToFront
else
  shpHighlight.BringToFront;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.HighLight(Value: TILItemSearchResult);
begin
case Value of
  ilisrItemPicFile:       Highlight(fPicturesManager.Image(ilipkMain));
  ilisrSecondaryPicFile:  Highlight(fPicturesManager.Image(ilipkSecondary));
  ilisrPackagePicFile:    Highlight(fPicturesManager.Image(ilipkPackage));
  ilisrType:              Highlight(cmbItemType);
  ilisrTypeSpec:          Highlight(leItemTypeSpecification);
  ilisrPieces:            Highlight(sePieces);
  ilisrUserID:            Highlight(leUserID);
  ilisrManufacturer:      Highlight(cmbManufacturer);
  ilisrManufacturerStr:   Highlight(leManufacturerString);
  ilisrTextID:            Highlight(leTextID);
  ilisrNumID:             Highlight(seNumID);
  ilisrFlagOwned:         Highlight(cbFlagOwned);
  ilisrFlagWanted:        Highlight(cbFlagWanted);
  ilisrFlagOrdered:       Highlight(cbFlagOrdered);
  ilisrFlagBoxed:         Highlight(cbFlagBoxed);
  ilisrFlagElsewhere:     Highlight(cbFlagElsewhere);
  ilisrFlagUntested:      Highlight(cbFlagUntested);
  ilisrFlagTesting:       Highlight(cbFlagTesting);
  ilisrFlagTested:        Highlight(cbFlagTested);
  ilisrFlagDamaged:       Highlight(cbFlagDamaged);
  ilisrFlagRepaired:      Highlight(cbFlagRepaired);
  ilisrFlagPriceChange:   Highlight(cbFlagPriceChange);
  ilisrFlagAvailChange:   Highlight(cbFlagAvailChange);
  ilisrFlagNotAvailable:  Highlight(cbFlagNotAvailable);
  ilisrFlagLost:          Highlight(cbFlagLost);
  ilisrFlagDiscarded:     Highlight(cbFlagDiscarded);
  ilisrTextTag:           Highlight(eTextTag);
  ilisrNumTag:            Highlight(seNumTag);
  ilisrWantedLevel:       Highlight(seWantedLevel);
  ilisrVariant:           Highlight(leVariant);
  ilisrVariantTag:        Highlight(leVariantTag);
  ilisrSurfaceFinish:     Highlight(cmbSurfaceFinish);
  ilisrMaterial:          Highlight(cmbMaterial);
  ilisrThickness:         Highlight(seThickness);
  ilisrSizeX:             Highlight(seSizeX);
  ilisrSizeY:             Highlight(seSizeY);
  ilisrSizeZ:             Highlight(seSizeZ);
  ilisrUnitWeight:        Highlight(seUnitWeight);
  ilisrNotes:             Highlight(meNotes);
  ilisrReviewURL:         Highlight(leReviewURL);
  ilisrUnitPriceDefault:  Highlight(seUnitPriceDefault);
  ilisrRating:            Highlight(seRating);
  ilisrRatingDetails:     Highlight(btnRatingDetails);
  ilisrSelectedShop:      Highlight(lblSelectedShop);
else
  DisableHighlight;
  Exit; // so timer is not enabled
end;
tmrHighlightTimer.Tag := IL_SEARCH_HIGHLIGHT_TIMEOUT;
tmrHighlightTimer.Enabled := True;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.BuildFlagMacrosMenu;
var
  i:      Integer;
  MITemp: TMenuItem;
begin
pmnFlagMacros.Items.Clear;
For i := Low(IL_FLAGMACRO_CAPTIONS) to High(IL_FLAGMACRO_CAPTIONS) do
  begin
    MITemp := TMenuItem.Create(Self);
    MITemp.Name := IL_Format('mniFM_Macro_%d',[i]);
    MITemp.Caption := IL_FLAGMACRO_CAPTIONS[i];
    MITemp.OnClick := CommonFlagMacroClick;
    MITemp.Tag := i;
    pmnFlagMacros.Items.Add(MITemp);
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.PrepareArrows;
begin
fPicArrowLeft := TBitmap.Create;
TILDataProvider.LoadBitmapFromResource('pic_arr_l',fPicArrowLeft);
fPicArrowRight := TBitmap.Create;
TILDataProvider.LoadBitmapFromResource('pic_arr_r',fPicArrowRight);
fPicArrowLeftD := TBitmap.Create;
TILDataProvider.LoadBitmapFromResource('pic_arr_l_d',fPicArrowLeftD);
fPicArrowRightD := TBitmap.Create;
TILDataProvider.LoadBitmapFromResource('pic_arr_r_d',fPicArrowRightD);
imgPrevPicture.Picture.Assign(fPicArrowLeft);
imgNextPicture.Picture.Assign(fPicArrowRight);
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.FrameClear;
begin
fInitializing := True;
try
  imgItemLock.Visible := False;
  UpdateTitle(nil,nil);
  ReplaceManufacturerLogo;
  UpdatePictures(nil,nil);
  // basic specs
  cmbItemType.ItemIndex := 0;
  cmbItemType.OnChange(nil);
  leItemTypeSpecification.Text := '';
  sePieces.Value := 1;
  leUserID.Text := '';
  cmbManufacturer.ItemIndex := 0;
  cmbManufacturer.OnChange(nil);
  leManufacturerString.Text := '';
  leTextID.Text := '';
  seNumID.Value := 0;
  // flags
  cbFlagOwned.Checked := False;
  cbFlagWanted.Checked := False;
  cbFlagOrdered.Checked := False;
  cbFlagUntested.Checked := False;
  cbFlagTesting.Checked := False;
  cbFlagTested.Checked := False;
  cbFlagBoxed.Checked := False;
  cbFlagDamaged.Checked := False;
  cbFlagRepaired.Checked := False;
  cbFlagElsewhere.Checked := False;
  cbFlagPriceChange.Checked := False;
  cbFlagAvailChange.Checked := False;
  cbFlagNotAvailable.Checked := False;
  cbFlagLost.Checked := False;
  cbFlagDiscarded.Checked := False;
  eTextTag.Text := '';
  seNumTag.Value := 0;
  // ext. specs
  seWantedLevel.Value := 0;
  leVariant.Text := '';
  leVariantTag.Text := '';
  cmbSurfaceFinish.ItemIndex := 0;
  cmbMaterial.ItemIndex := 0;
  seThickness.Value := 0;
  seSizeX.Value := 0;
  seSizeY.Value := 0;
  seSizeZ.Value := 0;
  seUnitWeight.Value := 0;
  // other info
  meNotes.Text := '';
  leReviewURL.Text := '';
  seUnitPriceDefault.Value := 0;
  seRating.Value := 0;
  lblRatingDetails.Visible := False;
  // read-only things
  lblPictureCount.Caption := '0';
  FillSelectedShop('-');
  lblShopCount.Caption := '0';  
  lblAvailPieces.Caption := '0';
  lblUnitPriceLowest.Caption := '-';
  lblUnitPriceSelected.Caption := '-';
  shpUnitPriceSelectedBcgr.Visible := False;
  lblTotalWeight.Caption := '-';
  lblTotalPriceLowest.Caption := '-';
  lblTotalPriceSelected.Caption := '-';
  shpTotalPriceSelectedBcgr.Visible := False;
finally
  fInitializing := False;
end;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.FrameSave;
begin
{
  pictures and shops are not needed to be saved, they are saved on the fly
  (when selected/changed)

  also lowest and selected prices are not saved, they are read only and set
  by other processes
}
If Assigned(fCurrentItem) then
  begin
    fCurrentItem.BeginUpdate;
    try
      // basic specs
      fCurrentItem.ItemType := TILItemType(cmbItemType.ItemIndex);
      fCurrentItem.ItemTypeSpec := leItemTypeSpecification.Text;
      fCurrentItem.Pieces := sePieces.Value;
      fCurrentItem.UserID := leUserID.Text;
      fCurrentItem.Manufacturer := TILItemManufacturer(cmbManufacturer.ItemIndex);
      fCurrentItem.ManufacturerStr := leManufacturerString.Text;
      fCurrentItem.TextID := leTextID.Text;
      fCurrentItem.NumID := seNumID.Value;
      // tags, flags
      fCurrentItem.SetFlagValue(ilifOwned,cbFlagOwned.Checked);
      fCurrentItem.SetFlagValue(ilifWanted,cbFlagWanted.Checked);
      fCurrentItem.SetFlagValue(ilifOrdered,cbFlagOrdered.Checked);
      fCurrentItem.SetFlagValue(ilifBoxed,cbFlagBoxed.Checked);
      fCurrentItem.SetFlagValue(ilifElsewhere,cbFlagElsewhere.Checked);
      fCurrentItem.SetFlagValue(ilifUntested,cbFlagUntested.Checked);
      fCurrentItem.SetFlagValue(ilifTesting,cbFlagTesting.Checked);
      fCurrentItem.SetFlagValue(ilifTested,cbFlagTested.Checked);
      fCurrentItem.SetFlagValue(ilifDamaged,cbFlagDamaged.Checked);
      fCurrentItem.SetFlagValue(ilifRepaired,cbFlagRepaired.Checked);
      fCurrentItem.SetFlagValue(ilifPriceChange,cbFlagPriceChange.Checked);
      fCurrentItem.SetFlagValue(ilifAvailChange,cbFlagAvailChange.Checked);
      fCurrentItem.SetFlagValue(ilifNotAvailable,cbFlagNotAvailable.Checked);
      fCurrentItem.SetFlagValue(ilifLost,cbFlagLost.Checked);
      fCurrentItem.SetFlagValue(ilifDiscarded,cbFlagDiscarded.Checked);
      fCurrentItem.TextTag := eTextTag.Text;
      fCurrentItem.NumTag := seNumTag.Value;
      // extended specs
      fCurrentItem.WantedLevel := seWantedLevel.Value;
      fCurrentItem.Variant := leVariant.Text;
      fCurrentItem.VariantTag := leVariantTag.Text;
      fCurrentItem.SurfaceFinish := TILItemSurfaceFinish(cmbSurfaceFinish.ItemIndex);
      fCurrentItem.Material := TILItemMaterial(cmbMaterial.ItemIndex);
      fCurrentItem.Thickness := seThickness.Value;
      fCurrentItem.SizeX := seSizeX.Value;
      fCurrentItem.SizeY := seSizeY.Value;
      fCurrentItem.SizeZ := seSizeZ.Value;
      fCurrentItem.UnitWeight := seUnitWeight.Value;
      // others
      fCurrentItem.Notes := meNotes.Text;
      fCurrentItem.ReviewURL := leReviewURL.Text;
      fCurrentItem.UnitPriceDefault := seUnitPriceDefault.Value;
      fCurrentItem.Rating := seRating.Value;
    finally
      fCurrentItem.EndUpdate;
    end
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.FrameLoad;
begin
If Assigned(fCurrentItem) then
  begin
    fInitializing := True;
    try
      imgItemLock.Visible := fCurrentItem.Encrypted;
      // internals
      lblUniqueID.Caption := GUIDToString(fCurrentItem.UniqueID);
      lblTimeOfAddition.Caption := IL_FormatDateTime('yyyy-mm-dd hh:nn:ss',fCurrentItem.TimeOfAddition);
      // header
      UpdateTitle(nil,fCurrentItem);
      ReplaceManufacturerLogo;
      UpdatePictures(nil,fCurrentItem);
      // basic specs
      cmbItemType.ItemIndex := Ord(fCurrentItem.ItemType);
      leItemTypeSpecification.Text := fCurrentItem.ItemTypeSpec;
      sePieces.Value := fCurrentItem.Pieces;
      leUserID.Text := fCurrentItem.UserID;
      cmbManufacturer.ItemIndex := Ord(fCurrentItem.Manufacturer);
      leManufacturerString.Text := fCurrentItem.ManufacturerStr;
      leTextID.Text := fCurrentItem.TextID;
      seNumID.Value := fCurrentItem.NumID;
      // tags, flags
      FillFlagsFromItem;
      eTextTag.Text := fCurrentItem.TextTag;
      seNumTag.Value := fCurrentITem.NumTag;
      // extended specs
      seWantedLevel.Value := fCurrentItem.WantedLevel;
      leVariant.Text := fCurrentItem.Variant;
      leVariantTag.Text := fCurrentItem.VariantTag;
      cmbSurfaceFinish.ItemIndex := Ord(fCurrentItem.SurfaceFinish);
      cmbMaterial.ItemIndex := Ord(fCurrentItem.Material);
      seThickness.Value := fCurrentItem.Thickness;
      seSizeX.Value := fCurrentItem.SizeX;
      seSizeY.Value := fCurrentItem.SizeY;
      seSizeZ.Value := fCurrentItem.SizeZ;
      seUnitWeight.Value := fCurrentItem.UnitWeight;
      // others
      meNotes.Text := fCurrentItem.Notes;
      leReviewURL.Text := fCurrentItem.ReviewURL;
      seUnitPriceDefault.Value := fCurrentItem.UnitPriceDefault;
      seRating.Value := fCurrentItem.Rating;
      lblRatingDetails.Visible := Length(fCurrentItem.RatingDetails) > 0;
      FillValues;
    finally
      fInitializing := False;
    end;
  end;
end;

//==============================================================================

procedure TfrmItemFrame.Initialize(ILManager: TILManager);
var
  i:  Integer;
begin
fPicturesManager := TILItemFramePicturesManager.Create(
  ILManager,imgPictureC.BoundsRect.Right,imgPrevPicture,imgNextPicture,
  imgPictureA,imgPictureB,imgPictureC,shpPictureABcgr,shpPictureBBcgr,shpPictureCBcgr);
fInitializing := False;
fCurrentItem := nil;
fLastFoundValue := ilisrNone;
fILManager := ILManager;
fILManager.OnItemTitleUpdate := UpdateTitle;
fILManager.OnItemPicturesUpdate := UpdatePictures;
fILManager.OnItemFlagsUpdate := UpdateFlags;
fILManager.OnItemValuesUpdate := UpdateValues;
fILManager.OnItemOthersUpdate := UpdateOthers;
SetItem(nil,True);
// prepare objects
imgPrevPicture.Tag := 0;
imgNextPicture.Tag := 0;
// fill drop-down lists...
// types
cmbItemType.Items.BeginUpdate;
try
  cmbItemType.Items.Clear;
  For i := Ord(Low(TILItemType)) to Ord(High(TILItemType)) do
    cmbItemType.Items.Add(fILManager.DataProvider.GetItemTypeString(TILItemType(i)))
finally
  cmbItemType.Items.EndUpdate;
end;
// manufacturers
cmbManufacturer.Items.BeginUpdate;
try
  cmbManufacturer.Items.Clear;
  For i := Ord(Low(TILItemManufacturer)) to Ord(High(TILItemManufacturer)) do
    cmbManufacturer.Items.Add(fILManager.DataProvider.ItemManufacturers[TILItemManufacturer(i)].Str);
finally
  cmbManufacturer.Items.EndUpdate;
end;
// material
cmbMaterial.Items.BeginUpdate;
try
  cmbMaterial.Items.Clear;
  For i := Ord(Low(TILItemMaterial)) to Ord(High(TILItemMaterial)) do
    cmbMaterial.Items.Add(fILManager.DataProvider.GetItemMaterialString(TILItemMaterial(i)));
finally
  cmbMaterial.Items.EndUpdate;
end;
// surface
cmbSurfaceFinish.Items.BeginUpdate;
try
  cmbSurfaceFinish.Items.Clear;
  For i := Ord(Low(TILItemSurfaceFinish)) to Ord(High(TILItemSurfaceFinish)) do
    cmbSurfaceFinish.Items.Add(fILManager.DataProvider.GetItemSurfaceFinishString(TILItemSurfaceFinish(i)));
finally
  cmbSurfaceFinish.Items.EndUpdate;
end;
// initialization
seNumTag.MinValue := IL_ITEM_NUM_TAG_MIN;
seNumTag.MaxValue := IL_ITEM_NUM_TAG_MAX;
lblUnitDefaultPrice.Caption := IL_Format(lblUnitDefaultPrice.Caption,[IL_CURRENCY_SYMBOL]);
DisableHighlight;
BuildFlagMacrosMenu;
PrepareArrows;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.Finalize;
begin
fILManager.OnItemTitleUpdate := nil;
fILManager.OnItemPicturesUpdate := nil;
fILManager.OnItemFlagsUpdate := nil;
fILManager.OnItemValuesUpdate := nil;
fILManager.OnItemOthersUpdate := nil;
FreeAndNil(fPicturesManager);
FreeAndNil(fPicArrowLeft);
FreeAndNil(fPicArrowRight);
FreeAndNil(fPicArrowLeftD);
FreeAndNil(fPicArrowRightD);
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.Save;
begin
FrameSave;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.Load;
begin
If Assigned(fCurrentItem) then
  FrameLoad
else
  FrameClear;
DisableHighlight;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.SetItem(Item: TILItem; ProcessChange: Boolean);
var
  Reassigned: Boolean;
begin
Reassigned := fCurrentItem = Item;
If ProcessChange then
  begin
    If Assigned(fCurrentItem) and not Reassigned then
      FrameSave;
    If Assigned(Item) then
      begin
        fCurrentItem := Item;
        If not Reassigned then
          FrameLoad;
      end
    else
      begin
        fCurrentItem := nil;
        FrameClear;
      end;
    Visible := Assigned(fCurrentItem) and fCurrentItem.DataAccessible;
    Enabled := Assigned(fCurrentItem) and fCurrentItem.DataAccessible;
  end
else fCurrentItem := Item;
DisableHighlight;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.FindPrev(const Text: String);
var
  FoundValue: TILItemSearchResult;
begin
If Assigned(fCurrentItem) then
  begin
    FrameSave;
    FoundValue := fCurrentItem.FindPrev(Text,fLastFoundValue);
    If FoundValue <> ilisrNone then
      begin
        DisableHighlight;
        Highlight(FoundValue);
        fLastFoundValue := FoundValue;
      end
    else
      begin
        If tmrHighlightTimer.Enabled then
          tmrHighlightTimer.Tag := IL_SEARCH_HIGHLIGHT_TIMEOUT;
        Beep;
      end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.FindNext(const Text: String);
var
  FoundValue: TILItemSearchResult;
begin
If Assigned(fCurrentItem) then
  begin
    FrameSave;
    FoundValue := fCurrentItem.FindNext(Text,fLastFoundValue);
    If FoundValue <> ilisrNone then
      begin
        DisableHighlight;
        Highlight(FoundValue);
        fLastFoundValue := FoundValue;
      end
    else
      begin
        If tmrHighlightTimer.Enabled then
          tmrHighlightTimer.Tag := IL_SEARCH_HIGHLIGHT_TIMEOUT;
        Beep;
      end;
  end;
end;

//==============================================================================

procedure TfrmItemFrame.FrameResize(Sender: TObject);
begin
DisableHighlight;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.lblItemTitleClick(Sender: TObject);
begin
If Assigned(OnShowSelectedItem) then
  OnShowSelectedItem(Self);
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.tmrSecondaryPicsTimer(Sender: TObject);
begin
If imgNextPicture.Tag <> 0 then
  imgNextPicture.OnMouseDown(nil,mbLeft,[],0,0)
else If imgPrevPicture.Tag <> 0 then
  imgPrevPicture.OnMouseDown(nil,mbLeft,[],0,0);
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.tmrHighlightTimerTimer(Sender: TObject);
begin
tmrHighlightTimer.Tag := tmrHighlightTimer.Tag - 1;
If tmrHighlightTimer.Tag <= 0 then
  DisableHighlight;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.imgPrevPictureMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
imgPrevPicture.Picture.Assign(fPicArrowLeftD);
If Assigned(fCurrentItem) then
  begin
    fCurrentItem.Pictures.PrevSecondary;
    fPicturesManager.UpdateSecondary;
    imgPrevPicture.Tag := -1;
    tmrSecondaryPics.Enabled := True;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.imgPrevPictureMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
imgPrevPicture.Picture.Assign(fPicArrowLeft);
imgPrevPicture.Tag := 0;
tmrSecondaryPics.Enabled := False;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.imgNextPictureMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
imgNextPicture.Picture.Assign(fPicArrowRightD);
If Assigned(fCurrentItem) then
  begin
    fCurrentItem.Pictures.NextSecondary;
    fPicturesManager.UpdateSecondary;
    imgNextPicture.Tag := -1;
    tmrSecondaryPics.Enabled := True;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.imgNextPictureMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
imgNextPicture.Picture.Assign(fPicArrowRight);
imgNextPicture.Tag := 0;
tmrSecondaryPics.Enabled := False;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.imgPictureClick(Sender: TObject);

  procedure OpenPicture(Index: Integer);
  begin
    If fCurrentItem.Pictures.CheckIndex(Index) then
      fCurrentItem.Pictures.OpenPictureFile(Index);
  end;

begin
If Assigned(fCurrentItem) and (Sender is TImage) then
  case fPicturesManager.Kind(TImage(Sender)) of
    ilipkMain:      OpenPicture(fCurrentItem.Pictures.IndexOfItemPicture);
    ilipkSecondary: OpenPicture(fCurrentItem.Pictures.CurrentSecondary);
    ilipkPackage:   OpenPicture(fCurrentItem.Pictures.IndexOfPackagePicture);
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.cmbItemTypeChange(Sender: TObject);
begin
If not fInitializing and Assigned(fCurrentItem) then
  fCurrentItem.ItemType := TILItemType(cmbItemType.ItemIndex);
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.leItemTypeSpecificationChange(Sender: TObject);
begin
If not fInitializing and Assigned(fCurrentItem) then
  fCurrentItem.ItemTypeSpec := leItemTypeSpecification.Text;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.sePiecesChange(Sender: TObject);
begin
If not fInitializing and Assigned(fCurrentItem) then
  fCurrentItem.Pieces := sePieces.Value;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.leUserIDChange(Sender: TObject);
begin
If not fInitializing and Assigned(fCurrentItem) then
  fCurrentItem.UserID := leUserID.Text;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.btnUserIDGenClick(Sender: TObject);
var
  NewID:  String;
begin
If Assigned(fCurrentItem) then
  If Length(fCurrentItem.UserID) <= 0 then
    begin
      If fILManager.GenerateUserID(NewID) then
        leUserID.Text := NewID  // this will also set it in the current item
      else
        MessageDlg('Unable to generate unique user ID.',mtError,[mbOK],0);
    end;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.cmbManufacturerChange(Sender: TObject);
begin
If not fInitializing and Assigned(fCurrentItem) then
  begin
    fCurrentItem.Manufacturer := TILItemManufacturer(cmbManufacturer.ItemIndex);
    ReplaceManufacturerLogo;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.leManufacturerStringChange(Sender: TObject);
begin
If not fInitializing and Assigned(fCurrentItem) then
  fCurrentItem.ManufacturerStr := leManufacturerString.Text;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.leTextIDChange(Sender: TObject);
begin
If not fInitializing and Assigned(fCurrentItem) then
  fCurrentItem.TextID := leTextID.Text;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.seNumIDChange(Sender: TObject);
begin
If not fInitializing and Assigned(fCurrentItem) then
  fCurrentItem.NumID := seNumID.Value;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.CommonFlagClick(Sender: TObject);
begin
If Sender is TCheckBox then
  If not fInitializing and Assigned(fCurrentItem) then
    case TCheckBox(Sender).Tag of
      1:  fCurrentItem.SetFlagValue(ilifOwned,cbFlagOwned.Checked);
      2:  fCurrentItem.SetFlagValue(ilifWanted,cbFlagWanted.Checked);
      3:  fCurrentItem.SetFlagValue(ilifOrdered,cbFlagOrdered.Checked);
      4:  fCurrentItem.SetFlagValue(ilifBoxed,cbFlagBoxed.Checked);
      5:  fCurrentItem.SetFlagValue(ilifElsewhere,cbFlagElsewhere.Checked);
      6:  fCurrentItem.SetFlagValue(ilifUntested,cbFlagUntested.Checked);
      7:  fCurrentItem.SetFlagValue(ilifTesting,cbFlagTesting.Checked);
      8:  fCurrentItem.SetFlagValue(ilifTested,cbFlagTested.Checked);
      9:  fCurrentItem.SetFlagValue(ilifDamaged,cbFlagDamaged.Checked);
      10: fCurrentItem.SetFlagValue(ilifRepaired,cbFlagRepaired.Checked);
      11: fCurrentItem.SetFlagValue(ilifPriceChange,cbFlagPriceChange.Checked);
      12: fCurrentItem.SetFlagValue(ilifAvailChange,cbFlagAvailChange.Checked);
      13: fCurrentItem.SetFlagValue(ilifNotAvailable,cbFlagNotAvailable.Checked);
      14: fCurrentItem.SetFlagValue(ilifLost,cbFlagLost.Checked);
      15: fCurrentItem.SetFlagValue(ilifDiscarded,cbFlagDiscarded.Checked);
    else
      Exit;
    end;
end;

//------------------------------------------------------------------------------  

procedure TfrmItemFrame.btnFlagMacrosClick(Sender: TObject);
var
  ScreenPoint:  TPoint;
begin
ScreenPoint := btnFlagMacros.ClientToScreen(Point(btnFlagMacros.Width,btnFlagMacros.Height));
pmnFlagMacros.Popup(ScreenPoint.X,ScreenPoint.Y);
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.CommonFlagMacroClick(Sender: TObject);
begin
If (Sender is TMenuItem) and Assigned(fCurrentItem) then
  case TMenuItem(Sender).Tag of
        // ordered item received
    0:  If [ilifWanted,ilifOrdered] <= fCurrentItem.Flags then
          begin
            fCurrentItem.BeginUpdate;
            try
              fCurrentItem.SetFlagValue(ilifWanted,False);
              fCurrentItem.SetFlagValue(ilifOrdered,False);
              fCurrentItem.SetFlagValue(ilifOwned,True);
              fCurrentItem.SetFlagValue(ilifUntested,True);
            finally
              fCurrentItem.EndUpdate;
            end;
          end;
        // starting item testing
    1:  If ilifUntested in fCurrentItem.Flags then
          begin
            fCurrentItem.BeginUpdate;
            try
              fCurrentItem.SetFlagValue(ilifUntested,False);
              fCurrentItem.SetFlagValue(ilifTesting,True);
            finally
              fCurrentItem.EndUpdate;
            end;
          end;
        // testing of item is finished
    2:  If ilifTesting in fCurrentItem.Flags then
          begin
            fCurrentItem.BeginUpdate;
            try
              fCurrentItem.SetFlagValue(ilifTesting,False);
              fCurrentItem.SetFlagValue(ilifTested,True);
            finally
              fCurrentItem.EndUpdate;
            end;
          end;
        // damage has been repaired
    3:  If ilifDamaged in fCurrentItem.Flags then
          begin
            fCurrentItem.BeginUpdate;
            try
              fCurrentItem.SetFlagValue(ilifDamaged,False);
              fCurrentItem.SetFlagValue(ilifRepaired,True);
            finally
              fCurrentItem.EndUpdate;
            end;
          end;
        // price and availability change checked
    4:  begin
          fCurrentItem.BeginUpdate;
          try
            fCurrentItem.SetFlagValue(ilifPriceChange,False);
            fCurrentItem.SetFlagValue(ilifAvailChange,False);
          finally
            fCurrentItem.EndUpdate;
          end;
        end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.eTextTagChange(Sender: TObject);
begin
If not fInitializing and Assigned(fCurrentItem) then
  fCurrentItem.TextTag := eTextTag.Text;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.seNumTagChange(Sender: TObject);
begin
If not fInitializing and Assigned(fCurrentItem) then
  fCurrentItem.NumTag := seNumTag.Value;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.seWantedLevelChange(Sender: TObject);
begin
If not fInitializing and Assigned(fCurrentItem) then
  fCurrentItem.WantedLevel := seWantedLevel.Value;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.leVariantChange(Sender: TObject);
begin
If not fInitializing and Assigned(fCurrentItem) then
  fCurrentItem.Variant := leVariant.Text;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.cmbSurfaceFinishChange(Sender: TObject);
begin
If not fInitializing and Assigned(fCurrentItem) then
  fCurrentItem.SurfaceFinish := TILItemSurfaceFinish(cmbSurfaceFinish.ItemIndex);
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.cmbMaterialChange(Sender: TObject);
begin
If not fInitializing and Assigned(fCurrentItem) then
  fCurrentItem.Material := TILItemMaterial(cmbMaterial.ItemIndex);
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.seSizeXChange(Sender: TObject);
begin
If not fInitializing and Assigned(fCurrentItem) then
  fCurrentItem.SizeX := seSizeX.Value;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.seSizeYChange(Sender: TObject);
begin
If not fInitializing and Assigned(fCurrentItem) then
  fCurrentItem.SizeY := seSizeY.Value;
end;
 
//------------------------------------------------------------------------------

procedure TfrmItemFrame.seSizeZChange(Sender: TObject);
begin
If not fInitializing and Assigned(fCurrentItem) then
  fCurrentItem.SizeZ := seSizeZ.Value;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.seUnitWeightChange(Sender: TObject);
begin
If not fInitializing and Assigned(fCurrentItem) then
  fCurrentItem.UnitWeight := seUnitWeight.Value;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.meNotesKeyPress(Sender: TObject; var Key: Char);
begin
If Key = ^A then
  begin
    meNotes.SelectAll;
    Key := #0;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.lblNotesEditClick(Sender: TObject);
var
  Temp: String;
begin
If Assigned(fCurrentItem) then
  begin
    Temp := meNotes.Text;
    fTextEditForm.ShowTextEditor('Edit item notes',Temp,False);
    meNotes.Text := Temp;
    meNotes.SelStart := Length(meNotes.Text);
    meNotes.SelLength := 0;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.lblNotesEditMouseEnter(Sender: TObject);
begin
lblNotesEdit.Font.Style := lblNotesEdit.Font.Style + [fsBold];
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.lblNotesEditMouseLeave(Sender: TObject);
begin
lblNotesEdit.Font.Style := lblNotesEdit.Font.Style - [fsBold];
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.leReviewURLChange(Sender: TObject);
begin
If not fInitializing and Assigned(fCurrentItem) then
  fCurrentItem.ReviewURL := leReviewURL.Text;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.btnReviewOpenClick(Sender: TObject);
begin
If Assigned(fCurrentItem) then
  IL_ShellOpen(Self.Handle,fCurrentItem.ReviewURL);
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.seUnitPriceDefaultChange(Sender: TObject);
begin
If not fInitializing and Assigned(fCurrentItem) then
  fCurrentItem.UnitPriceDefault := seUnitPriceDefault.Value;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.seRatingChange(Sender: TObject);
begin
If not fInitializing and Assigned(fCurrentItem) then
  fCurrentItem.Rating := seRating.Value;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.btnRatingDetailsClick(Sender: TObject);
var
  Temp: String;
begin
If Assigned(fCurrentItem) then
  begin
    Temp := fCurrentItem.RatingDetails;
    fTextEditForm.ShowTextEditor('Edit item rating details',Temp,False);
    fCurrentItem.RatingDetails := Temp;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.btnPicturesClick(Sender: TObject);
begin
If Assigned(fCurrentItem) then
  begin
    fItemPicturesForm.ShowPictures(fCurrentItem);
    If Assigned(OnFocusList) then
      OnFocusList(Self);
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.btnShopsClick(Sender: TObject);
begin
If Assigned(fCurrentItem) then
  begin
    fCurrentItem.BroadcastReqCount; // should not be needed, but to be sure
    fShopsForm.ShowShops(fCurrentItem);
    If Assigned(OnFocusList) then
      OnFocusList(Self);
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.btnUpdateShopsClick(Sender: TObject);
var
  i:    Integer;
  Temp: TILItemShopUpdateList;
begin
If Assigned(fCurrentItem) then
  begin
    If fCurrentItem.ShopCount > 0 then
      begin
        fCurrentItem.BroadcastReqCount; // should not be needed
        SetLength(Temp,fCurrentItem.ShopCount);
        For i := Low(Temp) to High(Temp) do
          begin
            Temp[i].Item := fCurrentItem;
            Temp[i].ItemTitle := IL_Format('[#%d] %s',[fCurrentItem.Index + 1,fCurrentItem.TitleStr]);
            Temp[i].ItemShop := fCurrentItem.Shops[i];
            Temp[i].Done := False;
          end;
        fUpdateForm.ShowUpdate(Temp);
        // changes are loaded automatically
        If Assigned(OnFocusList) then
          OnFocusList(Self);
      end
    else MessageDlg('No shop to update.',mtInformation,[mbOK],0);
  end;
end;

end.
