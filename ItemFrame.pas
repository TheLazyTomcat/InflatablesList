unit ItemFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ExtCtrls, StdCtrls, Spin, Menus,
  InflatablesList_Types,
  InflatablesList_Item,
  InflatablesList_Manager;

type
  TILItemFramePicturesManagerEntry = record
    Image:        TImage;
    Background:   TControl;
    PicKind:      TLIItemPictureKind;
    PicAssigned:  Boolean;
  end;

  TILItemFramePicturesManager = class(TObject)
  private
    fImages:        array of TILItemFramePicturesManagerEntry;
    fPictureKinds:  TLIItemPictureKinds;
  public
    constructor Create;
    destructor Destroy; override;
    Function IndexOf(Image: TImage): Integer; virtual;
    Function Add(Image: TImage; Background: TControl): Integer; virtual;
    procedure Clear; virtual;
    Function Kind(Image: TImage): TLIItemPictureKind; virtual;
    Function OtherKinds(Image: TImage): TLIItemPictureKinds; virtual;
    procedure PictureAssignStart; virtual;
    Function PictureAssign(Picture: TBitmap; PictureKind: TLIItemPictureKind): Integer; virtual;
    procedure PictureAssignEnd; virtual;
  end;

//******************************************************************************
//==============================================================================
//******************************************************************************

type
  TILResizingEntry = record
    Control:  TControl;
    InitRect: TRect;  // initial bounding box of the control
  end;

  TILResizingGroup = array of TILResizingEntry;

type
  TfrmItemFrame = class(TFrame)
    pnlMain: TPanel;
    shpItemTitleBcgr: TShape;
    lblItemTitle: TLabel;
    imgManufacturerLogo: TImage;
    shpPictureABcgr: TShape;
    imgPictureA: TImage;
    shpPictureBBcgr: TShape;
    imgPictureB: TImage;
    shpPictureCBcgr: TShape;
    imgPictureC: TImage;
    diaPicOpenDialog: TOpenDialog;
    diaPicExport: TSaveDialog;
    pmnPicturesMenu: TPopupMenu;
    mniPM_ReplacePic: TMenuItem;
    mniPM_LoadItemPic: TMenuItem;
    mniPM_LoadSecondaryPic: TMenuItem;
    mniPM_LoadPackagePic: TMenuItem;
    mniPM_ExportPic: TMenuItem;
    N1: TMenuItem;
    mniPM_RemovePic: TMenuItem;
    mniPM_RemoveItemPic: TMenuItem;
    mniPM_RemoveSecondaryPic: TMenuItem;
    mniPM_RemovePackagePic: TMenuItem;
    N2: TMenuItem;
    mniPM_SwapItemPic: TMenuItem;
    mniPM_SwapSecondaryPic: TMenuItem;
    mniPM_SwapPackagePic: TMenuItem;    
    lblUniqueID: TLabel;
    lblTimeOfAddition: TLabel;
    lblItemType: TLabel;
    cmbItemType: TComboBox;
    leItemTypeSpecification: TLabeledEdit;
    lblPieces: TLabel;
    sePieces: TSpinEdit;
    lblManufacturer: TLabel;
    cmbManufacturer: TComboBox;
    leManufacturerString: TLabeledEdit;
    leTextID: TLabeledEdit;
    lblID: TLabel;
    seID: TSpinEdit;
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
    lblMaterial: TLabel;
    cmbMaterial: TComboBox;    
    lblSizeX: TLabel;
    seSizeX: TSpinEdit;
    lblSizeY: TLabel;
    seSizeY: TSpinEdit;
    lblSizeZ: TLabel;
    seSizeZ: TSpinEdit;
    lblUnitWeight: TLabel;
    seUnitWeight: TSpinEdit;
    lblThickness: TLabel;
    seThickness: TSpinEdit;    
    lblNotes: TLabel;
    meNotes: TMemo;
    lblNotesEdit: TLabel;    
    leReviewURL: TLabeledEdit;
    btnReviewOpen: TButton;
    leItemPictureFile: TLabeledEdit;
    btnBrowseItemPictureFile: TButton;
    leSecondaryPictureFile: TLabeledEdit;
    btnBrowseSecondaryPictureFile: TButton;
    lePackagePictureFile: TLabeledEdit;
    btnBrowsePackagePictureFile: TButton;
    lblUnitDefaultPrice: TLabel;
    seUnitPriceDefault: TSpinEdit;
    lblRating: TLabel;
    seRating: TSpinEdit;
    btnUpdateShops: TButton;
    btnShops: TButton;
    bvlInfoSep: TBevel;
    lblSelectedShopTitle: TLabel;
    lblSelectedShop: TLabel;
    lblShopCountTitle: TLabel;
    lblShopCount: TLabel;
    lblAvailPiecesTitle: TLabel;
    lblAvailPieces: TLabel;
    lblTotalWeightTitle: TLabel;
    lblTotalWeight: TLabel;
    lblUnitPriceLowestTitle: TLabel;
    lblUnitPriceLowest: TLabel;
    lblUnitPriceSelectedTitle: TLabel;
    lblUnitPriceSelected: TLabel;
    shpUnitPriceSelectedBcgr: TShape;
    lblTotalPriceLowestTitle: TLabel;
    lblTotalPriceLowest: TLabel;
    lblTotalPriceSelectedTitle: TLabel;
    lblTotalPriceSelected: TLabel;
    shpTotalPriceSelectedBcgr: TShape;
    shpFiller: TShape;
    lblItemTitleShadow: TLabel;
    Button1: TButton;
    tmrHighlightTimer: TTimer;
    shpHighlight: TShape;
    procedure FrameResize(Sender: TObject);
    procedure lblItemTitleClick(Sender: TObject);
    procedure imgPictureClick(Sender: TObject);
    procedure pmnPicturesMenuPopup(Sender: TObject);
    procedure mniPM_ReplacePicClick(Sender: TObject);
    procedure mniPM_LoadItemPicClick(Sender: TObject);
    procedure mniPM_LoadSecondaryPicClick(Sender: TObject);
    procedure mniPM_LoadPackagePicClick(Sender: TObject);
    procedure mniPM_ExportPicClick(Sender: TObject);
    procedure mniPM_RemovePicClick(Sender: TObject);
    procedure mniPM_RemoveItemPicClick(Sender: TObject);
    procedure mniPM_RemoveSecondaryPicClick(Sender: TObject);
    procedure mniPM_RemovePackagePicClick(Sender: TObject);
    procedure mniPM_SwapItemPicClick(Sender: TObject);
    procedure mniPM_SwapSecondaryPicClick(Sender: TObject);
    procedure mniPM_SwapPackagePicClick(Sender: TObject);
    procedure cmbItemTypeChange(Sender: TObject);
    procedure leItemTypeSpecificationChange(Sender: TObject);
    procedure sePiecesChange(Sender: TObject);
    procedure cmbManufacturerChange(Sender: TObject);
    procedure leManufacturerStringChange(Sender: TObject);
    procedure leTextIDChange(Sender: TObject);
    procedure seIDChange(Sender: TObject);
    procedure CommonFlagClick(Sender: TObject);
    procedure btnFlagMacrosClick(Sender: TObject);
    procedure CommonFlagMacroClick(Sender: TObject);
    procedure eTextTagChange(Sender: TObject);
    procedure seNumTagChange(Sender: TObject);
    procedure seWantedLevelChange(Sender: TObject);
    procedure leVariantChange(Sender: TObject);
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
    procedure leItemPictureFileChange(Sender: TObject);
    procedure btnBrowseItemPictureFileClick(Sender: TObject);
    procedure leSecondaryPictureFileChange(Sender: TObject);
    procedure btnBrowseSecondaryPictureFileClick(Sender: TObject);
    procedure lePackagePictureFileChange(Sender: TObject);
    procedure btnBrowsePackagePictureFileClick(Sender: TObject);
    procedure seUnitPriceDefaultChange(Sender: TObject);
    procedure seRatingChange(Sender: TObject);    
    procedure btnUpdateShopsClick(Sender: TObject);
    procedure btnShopsClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure tmrHighlightTimerTimer(Sender: TObject);
  private
    // resizing
    fInitialHeight:   Integer;
    fResizeGroupA:    TILResizingGroup;
    fResizeGroupB:    TILResizingGroup;
    fChangeThreshold: Integer;
    fFirstResize:     Boolean;
    // other fields
    fPicturesManager: TILItemFramePicturesManager;    
    fLastSmallPicDir: String;
    fLastPicDir:      String;
    fInitializing:    Boolean;
    fILManager:       TILManager;
    fCurrentItem:     TILItem;
    // searching
    fLastFoundValue:  TILItemSearchResult;
  protected
    // item event handlers (manager)
    procedure UpdateTitle(Sender: TObject; Item: TObject);
    procedure UpdatePictures(Sender: TObject; Item: TObject);
    procedure UpdateFlags(Sender: TObject; Item: TObject);
    procedure UpdateValues(Sender: TObject; Item: TObject);
    // helper methods
    procedure ReplaceManufacturerLogo;
    procedure BrowseSmallPicture(const FileStr: String; out Bitmap: TBitmap; StoredBitmap: TBitmap);
    procedure FillFlagsFromItem;
    procedure FillValues;
    procedure FillSelectedShop(const SelectedShop: String);
    Function BrowsePicture(const FileStr: String; var FileName: String): Boolean;
    // resizing
    procedure ResizingInitialize;
    procedure ResizingProcess;
    // searching
    procedure DisableHighlight;
    procedure Highlight(Control: TControl); overload;
    procedure HighLight(Value: TILItemSearchResult); overload;
    // initialization
    procedure BuildFlagMacrosMenu;
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
  TextEditForm, ShopsForm, UpdateForm,
  InflatablesList_Utils,
  InflatablesList_ItemShop;

{$R *.dfm}

const
  IL_SEARCH_HIGHLIGHT_TIMEOUT = 12; // 3 seconds highlight

  IL_FLAGMACRO_CAPTIONS: array[0..2] of String = (
    'Ordered item received',
    'Starting item testing',
    'Testing of item is finished');

//==============================================================================

constructor TILItemFramePicturesManager.Create;
begin
inherited Create;
SetLength(fImages,0);
fPictureKinds := [];
end;

//------------------------------------------------------------------------------

destructor TILItemFramePicturesManager.Destroy;
begin
Clear;
inherited;
end;

//------------------------------------------------------------------------------

Function TILItemFramePicturesManager.IndexOf(Image: TImage): Integer;
var
  i:  Integer;
begin
Result := -1;
For i := Low(fImages) to High(fImages) do
  If fImages[i].Image = Image then
    begin
      Result := i;
      Break{For i};
    end;
end;

//------------------------------------------------------------------------------

Function TILItemFramePicturesManager.Add(Image: TImage; Background: TControl): Integer;
begin
Result := IndexOf(Image);
If Result < 0 then
  begin
    Result := Length(fImages);
    SetLength(fImages,Length(fImages) + 1);
    fImages[Result].Image := Image;
    fImages[Result].Background := Background;
    fImages[Result].PicKind := ilipkUnknown;
    fImages[Result].PicAssigned := False;
  end;
end;

//------------------------------------------------------------------------------

procedure TILItemFramePicturesManager.Clear;
begin
SetLength(fImages,0);
fPictureKinds := [];
end;

//------------------------------------------------------------------------------

Function TILItemFramePicturesManager.Kind(Image: TImage): TLIItemPictureKind;
var
  Index:  Integer;
begin
Index := IndexOf(Image);
If Index >= 0 then
  Result := fImages[Index].PicKind
else
  Result := ilipkUnknown;
end;

//------------------------------------------------------------------------------

Function TILItemFramePicturesManager.OtherKinds(Image: TImage): TLIItemPictureKinds;
var
  Index:  Integer;
begin
Index := IndexOf(Image);
If Index >= 0 then
  begin
    Result := fPictureKinds;
    Exclude(Result,fImages[Index].PicKind);
  end
else Result := [ilipkUnknown];
end;

//------------------------------------------------------------------------------

procedure TILItemFramePicturesManager.PictureAssignStart;
var
  i:  Integer;
begin
For i := Low(fImages) to High(fImages) do
  begin
    fImages[i].PicKind := ilipkUnknown;
    fImages[i].PicAssigned := False;
  end;
fPictureKinds := [];
end;

//------------------------------------------------------------------------------

Function TILItemFramePicturesManager.PictureAssign(Picture: TBitmap; PictureKind: TLIItemPictureKind): Integer;
var
  i:  Integer;
begin
Result := -1;
If Assigned(Picture) then
  For i := High(fImages) downto Low(fImages) do
    If not fImages[i].PicAssigned then
      begin
        fImages[i].Image.Picture.Assign(Picture);
        fImages[i].Background.Visible := False;
        fImages[i].PicKind := PictureKind;
        fImages[i].PicAssigned := True;
        fImages[i].Image.ShowHint := PictureKind <> ilipkUnknown;
        fImages[i].Image.Hint := IL_ItemPictureKindToStr(PictureKind,True);
        Include(fPictureKinds,PictureKind);
        Result := i;
        Break{For i};
      end;
end;

//------------------------------------------------------------------------------

procedure TILItemFramePicturesManager.PictureAssignEnd;
var
  i:  Integer;
begin
For i := Low(fImages) to High(fImages) do
  If not fImages[i].PicAssigned then
    begin
      fImages[i].Image.Picture.Assign(nil);
      fImages[i].Image.ShowHint := False;
      fImages[i].Background.Visible := True;
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
fPicturesManager.PictureAssignStart;
try
  If Assigned(fCurrentItem) and (Item = fCurrentItem) and
    not fILManager.StaticSettings.NoPictures then
  begin
    fPicturesManager.PictureAssign(fCurrentItem.PackagePicture,ilipkPackage);
    fPicturesManager.PictureAssign(fCurrentItem.SecondaryPicture,ilipkSecondary);
    fPicturesManager.PictureAssign(fCurrentItem.ItemPicture,ilipkMain);
  end;
finally
  fPicturesManager.PictureAssignEnd;
end;
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

procedure TfrmItemFrame.BrowseSmallPicture(const FileStr: String; out Bitmap: TBitmap; StoredBitmap: TBitmap);
begin
diaPicOpenDialog.Title := IL_Format('Select %s picture',[FileStr]);
diaPicOpenDialog.Filter := 'BMP image files|*.bmp|All files|*.*';
diaPicOpenDialog.FileName := '';
diaPicOpenDialog.InitialDir := fLastSmallPicDir;
If diaPicOpenDialog.Execute then
  try
    fLastSmallPicDir := IL_ExtractFileDir(diaPicOpenDialog.FileName);
    Bitmap := TBitmap.Create;
    Bitmap.LoadFromFile(StrToRTL(diaPicOpenDialog.FileName));
    If Assigned(StoredBitmap) then
      begin
        If MessageDlg(IL_Format('Replace current %s picture?',[FileStr]),mtConfirmation,[mbYes,mbNo],0) <> mrYes then
          FreeAndNil(Bitmap);
      end;
  except
    // supress error
    If Assigned(Bitmap) then
      FreeAndNil(Bitmap);
    MessageDlg('Error while loading the file.',mtError,[mbOK],0);
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
    If fCurrentItem.AvailableSelected <> 0 then
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
        lblUnitPriceLowest.Caption := IL_Format('%d Kè',[fCurrentItem.UnitPriceLowest]);
        lblTotalPriceLowest.Caption := IL_Format('%d Kè',[fCurrentItem.TotalPriceLowest]);
      end
    else
      begin
        lblUnitPriceLowest.Caption := '-';
        lblTotalPriceLowest.Caption := '-';
      end;
    // price selected
    If fCurrentItem.UnitPriceSelected > 0 then
      begin
        lblUnitPriceSelected.Caption := IL_Format('%d Kè',[fCurrentItem.UnitPriceSelected]);
        lblTotalPriceSelected.Caption := IL_Format('%d Kè',[fCurrentItem.TotalPriceSelected]);
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

Function TfrmItemFrame.BrowsePicture(const FileStr: String; var FileName: String): Boolean;
begin
Result := False;
diaPicOpenDialog.Title := IL_Format('Select %s picture file',[FileStr]);
diaPicOpenDialog.Filter := 'JPEG image files|*.jpg|All files|*.*';
diaPicOpenDialog.FileName := '';
diaPicOpenDialog.InitialDir := fLastPicDir;
If diaPicOpenDialog.Execute then
  begin
    fLastPicDir := IL_ExtractFileDir(diaPicOpenDialog.FileName);
    Result := True;
    If Length(FileName) > 0 then
      begin
        If MessageDlg(IL_Format('Replace current %s picture file?',[FileStr]),mtConfirmation,[mbYes,mbNo],0) = mrYes then
          FileName := IL_PathRelative(fILManager.StaticSettings.ListPath,diaPicOpenDialog.FileName)
        else
          Result := False;
      end
    else FileName := IL_PathRelative(fILManager.StaticSettings.ListPath,diaPicOpenDialog.FileName);
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.ResizingInitialize;

  procedure ResizeGroupA_Fill(Controls: array of TControl);
  var
    ii: Integer;
  begin
    SetLength(fResizeGroupA,Length(Controls));
    For ii := Low(Controls) to High(Controls) do
      begin
        fResizeGroupA[ii].Control := Controls[ii];
        fResizeGroupA[ii].InitRect := Controls[ii].BoundsRect;
      end;
  end;

  procedure ResizeGroupB_Fill(Reference: TControl; Controls: array of TControl);
  var
    ii: Integer;
  begin
    SetLength(fResizeGroupB,Length(Controls));
    For ii := Low(Controls) to High(Controls) do
      begin
        fResizeGroupB[ii].Control := Controls[ii];
        fResizeGroupB[ii].InitRect := Rect(
          Controls[ii].BoundsRect.Left - Reference.BoundsRect.Left,
          Controls[ii].BoundsRect.Top - Reference.BoundsRect.Top,
          Controls[ii].BoundsRect.Right - Reference.BoundsRect.Right,
          Controls[ii].BoundsRect.Bottom - Reference.BoundsRect.Bottom);
      end;
  end;

begin
fInitialHeight := Height;
// fill group A - coordinates are absolute
ResizeGroupA_Fill([meNotes,lblNotesEdit,leReviewURL,btnReviewOpen,leItemPictureFile,
  btnBrowseItemPictureFile,leSecondaryPictureFile,btnBrowseSecondaryPictureFile,
  lePackagePictureFile,btnBrowsePackagePictureFile,lblUnitDefaultPrice]);
// fill group B - all coordinates are referenced from lblUnitDefaultPrice object
ResizeGroupB_Fill(lblUnitDefaultPrice,[
  seUnitPriceDefault,lblRating,seRating,btnUpdateShops,btnShops,bvlInfoSep,
  lblSelectedShopTitle,lblSelectedShop,lblShopCountTitle,lblShopCount,
  lblAvailPiecesTitle,lblAvailPieces,lblUnitPriceLowestTitle,lblUnitPriceLowest,
  lblUnitPriceSelectedTitle,lblUnitPriceSelected,shpUnitPriceSelectedBcgr,
  lblTotalWeightTitle,lblTotalWeight,lblTotalPriceLowestTitle,lblTotalPriceLowest,
  lblTotalPriceSelectedTitle,lblTotalPriceSelected,shpTotalPriceSelectedBcgr]);
fChangeThreshold := fInitialHeight + 40;
shpFiller.Width := CLientWidth;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.ResizingProcess;
var
  i:  Integer;

  Function GetAbsoluteRect(Reference: TControl; Rect: TRect): TRect;
  begin
    Result.Left := Rect.Left + Reference.BoundsRect.Left;
    Result.Top := Rect.Top + Reference.BoundsRect.Top;
    Result.Right := Rect.Right + Reference.BoundsRect.Right;
    Result.Bottom := Rect.Bottom + Reference.BoundsRect.Bottom;
  end;

  procedure SetControlBoundsRect(Control: TControl; BndRect: TRect);
  begin
    If (Control.BoundsRect.Left <> BndRect.Left) or
      (Control.BoundsRect.Top <> BndRect.Top) or
      (Control.BoundsRect.Right <> BndRect.Right) or
      (Control.BoundsRect.Bottom <> BndRect.Bottom) then
      Control.BoundsRect := BndRect;
  end;

begin
If fFirstResize then
  begin
    ResizingInitialize;
    fFirstResize := False;
  end;
If Height >= fChangeThreshold then
  begin
    // manually reposition group A...
    // widen the notes memo to full width and calculate it heigth
    meNotes.Width := ClientWidth;
    meNotes.Height := 101 + (Height - fChangeThreshold);
    lblNotesEdit.Left := ClientWidth - lblNotesEdit.Width;
    // position and adjust size of...
    // ...review
    leReviewURL.Left := 0;
    leReviewURL.Top := meNotes.BoundsRect.Bottom + 20;
    leReviewURL.Width := ((ClientWidth - 8) div 2) - btnReviewOpen.Width;
    btnReviewOpen.Left := leReviewURL.BoundsRect.Right;
    btnReviewOpen.Top := leReviewURL.Top;
    // ...item picture
    leItemPictureFile.Left := ClientWidth - ((ClientWidth - 8) div 2);
    leItemPictureFile.Top := meNotes.BoundsRect.Bottom + 20;
    leItemPictureFile.Width := ((ClientWidth - 8) div 2) - btnBrowseItemPictureFile.Width;
    btnBrowseItemPictureFile.Left := leItemPictureFile.BoundsRect.Right;
    btnBrowseItemPictureFile.Top := leItemPictureFile.Top;
    // ...secondary picture
    leSecondaryPictureFile.Left := 0;
    leSecondaryPictureFile.Top := leReviewURL.Top + 40;
    leSecondaryPictureFile.Width := ((ClientWidth - 8) div 2) - btnBrowseSecondaryPictureFile.Width;
    btnBrowseSecondaryPictureFile.Left := leSecondaryPictureFile.BoundsRect.Right;
    btnBrowseSecondaryPictureFile.Top := leSecondaryPictureFile.Top;
    // ...package picture
    lePackagePictureFile.Left := ClientWidth - ((ClientWidth - 8) div 2);
    lePackagePictureFile.Top := leItemPictureFile.Top + 40;
    lePackagePictureFile.Width := ((ClientWidth - 8) div 2) - btnBrowsePackagePictureFile.Width;
    btnBrowsePackagePictureFile.Left := lePackagePictureFile.BoundsRect.Right;
    btnBrowsePackagePictureFile.Top := lePackagePictureFile.Top;
    // reposition reference object
    lblUnitDefaultPrice.Top := leSecondaryPictureFile.Top + 24;
  end
else
  begin
    // set group A to initial positions
    For i := Low(fResizeGroupA) to High(fResizeGroupA) do
      SetControlBoundsRect(fResizeGroupA[i].Control,fResizeGroupA[i].InitRect);
  end;
For i := Low(fResizeGroupB) to High(fResizeGroupB) do
  SetControlBoundsRect(fResizeGroupB[i].Control,GetAbsoluteRect(lblUnitDefaultPrice,fResizeGroupB[i].InitRect));
FillSelectedShop(lblSelectedShop.Caption);
// show filler if necessary
shpFiller.Top := lblUnitPriceSelectedTitle.BoundsRect.Bottom + 8;
shpFiller.Height := ClientHeight - shpFiller.Top;
shpFiller.Visible := shpFiller.Height >= 4;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.DisableHighlight;
begin
shpHighlight.Visible := False;
// ...selected shop
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
// special cases
else If (Control = seNumTag) or (Control = eTextTag) then
  begin
    shpHighlight.Left := Control.Left - 5;
    shpHighlight.Top := Control.Top;
    shpHighlight.Width := 5;
    shpHighlight.Height := Control.Height + 1;
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
  ilisrType:              Highlight(cmbItemType);
  ilisrTypeSpec:          Highlight(leItemTypeSpecification);
  ilisrPieces:            Highlight(sePieces);
  ilisrManufacturer:      Highlight(cmbManufacturer);
  ilisrManufacturerStr:   Highlight(leManufacturerString);
  ilisrTextID:            Highlight(leTextID);
  ilisrNumID:             Highlight(seID);
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
  ilisrMaterial:          Highlight(cmbMaterial);
  ilisrSizeX:             Highlight(seSizeX);
  ilisrSizeY:             Highlight(seSizeY);
  ilisrSizeZ:             Highlight(seSizeZ);
  ilisrUnitWeight:        Highlight(seUnitWeight);
  ilisrThickness:         Highlight(seThickness);
  ilisrNotes:             Highlight(meNotes);
  ilisrReviewURL:         Highlight(leReviewURL);
  ilisrItemPicFile:       Highlight(leItemPictureFile);
  ilisrSecondaryPicFile:  Highlight(leSecondaryPictureFile);
  ilisrPackagePicFile:    Highlight(lePackagePictureFile);
  ilisrUnitPriceDefault:  Highlight(seUnitPriceDefault);
  ilisrRating:            Highlight(seRating);
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

procedure TfrmItemFrame.FrameClear;
begin
fInitializing := True;
try
  UpdateTitle(nil,nil);
  ReplaceManufacturerLogo;
  UpdatePictures(nil,nil);
  // basic specs
  cmbItemType.ItemIndex := 0;
  cmbItemType.OnChange(nil);
  leItemTypeSpecification.Text := '';
  sePieces.Value := 1;
  cmbManufacturer.ItemIndex := 0;
  cmbManufacturer.OnChange(nil);
  leManufacturerString.Text := '';
  leTextID.Text := '';
  seID.Value := 0;
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
  cmbMaterial.ItemIndex := 0; 
  seSizeX.Value := 0;
  seSizeY.Value := 0;
  seSizeZ.Value := 0;
  seUnitWeight.Value := 0;
  seThickness.Value := 0;
  // other info
  meNotes.Text := '';
  leReviewURL.Text := '';
  leItemPictureFile.Text := '';
  leSecondaryPictureFile.Text := '';
  lePackagePictureFile.Text := '';
  seUnitPriceDefault.Value := 0;
  seRating.Value := 0;
  // read-only things
  lblTotalWeight.Caption := '-';
  FillSelectedShop('-');
  lblShopCount.Caption := '0';
  lblUnitPriceLowest.Caption := '-';
  lblUnitPriceSelected.Caption := '-';
  shpUnitPriceSelectedBcgr.Visible := False;
  lblAvailPieces.Caption := '0';
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
      fCurrentItem.Count := sePieces.Value;
      fCurrentItem.Manufacturer := TILItemManufacturer(cmbManufacturer.ItemIndex);
      fCurrentItem.ManufacturerStr := leManufacturerString.Text;
      fCurrentItem.TextID := leTextID.Text;
      fCurrentItem.ID := seID.Value;
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
      fCurrentItem.Material := TILItemMaterial(cmbMaterial.ItemIndex);
      fCurrentItem.SizeX := seSizeX.Value;
      fCurrentItem.SizeY := seSizeY.Value;
      fCurrentItem.SizeZ := seSizeZ.Value;
      fCurrentItem.UnitWeight := seUnitWeight.Value;
      fCurrentItem.Thickness := seThickness.Value;
      // others
      fCurrentItem.Notes := meNotes.Text;
      fCurrentItem.ReviewURL := leReviewURL.Text;
      fCurrentItem.ItemPictureFile := leItemPictureFile.Text;
      fCurrentItem.SecondaryPictureFile := leSecondaryPictureFile.Text;
      fCurrentItem.PackagePictureFile := lePackagePictureFile.Text;
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
      cmbManufacturer.ItemIndex := Ord(fCurrentItem.Manufacturer);
      leManufacturerString.Text := fCurrentItem.ManufacturerStr;
      leTextID.Text := fCurrentItem.TextID;
      seID.Value := fCurrentItem.ID;
      // tags, flags
      FillFlagsFromItem;
      eTextTag.Text := fCurrentItem.TextTag;
      seNumTag.Value := fCurrentITem.NumTag;
      // extended specs
      seWantedLevel.Value := fCurrentItem.WantedLevel;
      leVariant.Text := fCurrentItem.Variant;
      cmbMaterial.ItemIndex := Ord(fCurrentItem.Material);
      seSizeX.Value := fCurrentItem.SizeX;
      seSizeY.Value := fCurrentItem.SizeY;
      seSizeZ.Value := fCurrentItem.SizeZ;
      seUnitWeight.Value := fCurrentItem.UnitWeight;
      seThickness.Value := fCurrentItem.Thickness;
      // others
      meNotes.Text := fCurrentItem.Notes;
      leReviewURL.Text := fCurrentItem.ReviewURL;
      leItemPictureFile.Text := fCurrentItem.ItemPictureFile;
      leSecondaryPictureFile.Text := fCurrentItem.SecondaryPictureFile;
      lePackagePictureFile.Text := fCurrentItem.PackagePictureFile;
      seUnitPriceDefault.Value := fCurrentItem.UnitPriceDefault;
      seRating.Value := fCurrentItem.Rating;
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
fFirstResize := True;
fPicturesManager := TILItemFramePicturesManager.Create;
fPicturesManager.Add(imgPictureA,shpPictureABcgr);
fPicturesManager.Add(imgPictureB,shpPictureBBcgr);
fPicturesManager.Add(imgPictureC,shpPictureCBcgr);
fLastSmallPicDir := '';
fLastPicDir := '';
fInitializing := False;
fCurrentItem := nil;
fLastFoundValue := ilisrNone;
fILManager := ILManager;
fILManager.OnItemTitleUpdate := UpdateTitle;
fILManager.OnItemPicturesUpdate := UpdatePictures;
fILManager.OnItemFlagsUpdate := UpdateFlags;
fILManager.OnItemValuesUpdate := UpdateValues;
SetItem(nil,True);
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
// initialization
DisableHighlight;
BuildFlagMacrosMenu;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.Finalize;
begin
fILManager.OnItemTitleUpdate := nil;
fILManager.OnItemPicturesUpdate := nil;
fILManager.OnItemFlagsUpdate := nil;
fILManager.OnItemValuesUpdate := nil;
FreeAndNil(fPicturesManager);
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
    Visible := Assigned(fCurrentItem);
    Enabled := Assigned(fCurrentItem);
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
ResizingProcess;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.lblItemTitleClick(Sender: TObject);
begin
If Assigned(OnShowSelectedItem) then
  OnShowSelectedItem(Self);
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.imgPictureClick(Sender: TObject);

  procedure OpenPicture(const FileName: String);
  begin
    If IL_FileExists(IL_PathAbsolute(fILManager.StaticSettings.ListPath,FileName)) then
      IL_ShellOpen(Handle,IL_PathAbsolute(fILManager.StaticSettings.ListPath,FileName));
  end;

begin
If Assigned(fCurrentItem) and (Sender is TImage) then
  case fPicturesManager.Kind(TImage(Sender)) of
    ilipkMain:      OpenPicture(fCurrentItem.ItemPictureFile);
    ilipkSecondary: OpenPicture(fCurrentItem.SecondaryPictureFile);
    ilipkPackage:   OpenPicture(fCurrentItem.PackagePictureFile);
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.pmnPicturesMenuPopup(Sender: TObject);
var
  PicKind:  TLIItemPictureKind;
begin
If Assigned(fCurrentItem) and (pmnPicturesMenu.PopupComponent is TImage) then
  begin
    PicKind := fPicturesManager.Kind(TImage(pmnPicturesMenu.PopupComponent));
    mniPM_ReplacePic.Visible := PicKind <> ilipkUnknown;
    mniPM_LoadItemPic.Visible := PicKind <> ilipkMain;
    mniPM_LoadItemPic.Enabled := mniPM_LoadItemPic.Visible;
    mniPM_LoadSecondaryPic.Visible := PicKind <> ilipkSecondary;
    mniPM_LoadSecondaryPic.Enabled := mniPM_LoadSecondaryPic.Visible;
    mniPM_LoadPackagePic.Visible := PicKind <> ilipkPackage;
    mniPM_LoadPackagePic.Enabled := mniPM_LoadPackagePic.Visible;
    mniPM_ExportPic.Visible := PicKind <> ilipkUnknown;
    N1.Visible := True;
    mniPM_RemovePic.Visible := PicKind <> ilipkUnknown;
    mniPM_RemoveItemPic.Visible := (PicKind <> ilipkMain) and Assigned(fCurrentItem.ItemPicture);
    mniPM_RemoveSecondaryPic.Visible := (PicKind <> ilipkSecondary) and Assigned(fCurrentItem.SecondaryPicture);
    mniPM_RemovePackagePic.Visible := (PicKind <> ilipkPackage) and Assigned(fCurrentItem.PackagePicture);
    mniPM_SwapItemPic.Visible := not(PicKind in [ilipkUnknown,ilipkMain]) and Assigned(fCurrentItem.ItemPicture);
    mniPM_SwapSecondaryPic.Visible := not(PicKind in [ilipkUnknown,ilipkSecondary]) and Assigned(fCurrentItem.SecondaryPicture);
    mniPM_SwapPackagePic.Visible := not(PicKind in [ilipkUnknown,ilipkPackage]) and Assigned(fCurrentItem.PackagePicture);
    N2.Visible := mniPM_SwapItemPic.Visible or mniPM_SwapSecondaryPic.Visible or mniPM_SwapPackagePic.Visible;
  end
else
  begin
    mniPM_ReplacePic.Visible := False;
    mniPM_LoadItemPic.Visible := True;
    mniPM_LoadItemPic.Enabled := False;
    mniPM_LoadSecondaryPic.Visible := True;
    mniPM_LoadSecondaryPic.Enabled := False;
    mniPM_LoadPackagePic.Visible := True;
    mniPM_LoadPackagePic.Enabled := False;
    mniPM_ExportPic.Visible := False;
    N1.Visible := False;
    mniPM_RemovePic.Visible := False;
    mniPM_RemoveItemPic.Visible := False;
    mniPM_RemoveSecondaryPic.Visible := False;
    mniPM_RemovePackagePic.Visible := False;
    mniPM_SwapItemPic.Visible := False;
    mniPM_SwapSecondaryPic.Visible := False;
    mniPM_SwapPackagePic.Visible := False;
    N2.Visible := False;    
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.mniPM_ReplacePicClick(Sender: TObject);
var
  TempBitmap: TBitmap;
begin
If Assigned(fCurrentItem) and (pmnPicturesMenu.PopupComponent is TImage) then
  begin
    TempBitmap := nil;
    case fPicturesManager.Kind(TImage(pmnPicturesMenu.PopupComponent)) of
      ilipkMain:
        BrowseSmallPicture(IL_ItemPictureKindToStr(ilipkMain),TempBitmap,fCurrentItem.ItemPicture);
      ilipkSecondary:
        BrowseSmallPicture(IL_ItemPictureKindToStr(ilipkSecondary),TempBitmap,fCurrentItem.SecondaryPicture);
      ilipkPackage:
        BrowseSmallPicture(IL_ItemPictureKindToStr(ilipkPackage),TempBitmap,fCurrentItem.PackagePicture);
    else
      raise Exception.CreateFmt('Invalid picture kind (%d).',
        [Ord(fPicturesManager.Kind(TImage(pmnPicturesMenu.PopupComponent)))]);
    end;
    If Assigned(TempBitmap) then
      case fPicturesManager.Kind(TImage(pmnPicturesMenu.PopupComponent)) of
        ilipkMain:      fCurrentItem.ItemPicture := TempBitmap;
        ilipkSecondary: fCurrentItem.SecondaryPicture := TempBitmap;
        ilipkPackage:   fCurrentItem.PackagePicture := TempBitmap;
      end;
    // do not free the bitmap, is is directly assigned to the item
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.mniPM_LoadItemPicClick(Sender: TObject);
var
  TempBitmap: TBitmap;
begin
TempBitmap := nil;
BrowseSmallPicture(IL_ItemPictureKindToStr(ilipkMain),TempBitmap,fCurrentItem.ItemPicture);
If Assigned(TempBitmap) then
  fCurrentItem.ItemPicture := TempBitmap;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.mniPM_LoadSecondaryPicClick(Sender: TObject);
var
  TempBitmap: TBitmap;
begin
TempBitmap := nil;
BrowseSmallPicture(IL_ItemPictureKindToStr(ilipkSecondary),TempBitmap,fCurrentItem.SecondaryPicture);
If Assigned(TempBitmap) then
  fCurrentItem.SecondaryPicture := TempBitmap;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.mniPM_LoadPackagePicClick(Sender: TObject);
var
  TempBitmap: TBitmap;
begin
TempBitmap := nil;
BrowseSmallPicture(IL_ItemPictureKindToStr(ilipkPackage),TempBitmap,fCurrentItem.PackagePicture);
If Assigned(TempBitmap) then
  fCurrentItem.PackagePicture := TempBitmap;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.mniPM_ExportPicClick(Sender: TObject);

  procedure ExportPicture(const FileStr: String; StoredBitmap: TBitmap);
  begin
    If Assigned(StoredBitmap) then
      begin
        diaPicExport.Title := IL_Format('Export %s picture',[FileStr]);
        diaPicExport.FileName := '';
        If diaPicExport.Execute then
          StoredBitmap.SaveToFile(StrToRTL(diaPicExport.FileName));
      end;
  end;

begin
If Assigned(fCurrentItem) and (pmnPicturesMenu.PopupComponent is TImage) then
  case fPicturesManager.Kind(TImage(pmnPicturesMenu.PopupComponent)) of
    ilipkMain:
      ExportPicture(IL_ItemPictureKindToStr(ilipkMain),fCurrentItem.ItemPicture);
    ilipkSecondary:
      ExportPicture(IL_ItemPictureKindToStr(ilipkSecondary),fCurrentItem.SecondaryPicture);
    ilipkPackage:
      ExportPicture(IL_ItemPictureKindToStr(ilipkPackage),fCurrentItem.PackagePicture);
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.mniPM_RemovePicClick(Sender: TObject);
begin
If Assigned(fCurrentItem) and (pmnPicturesMenu.PopupComponent is TImage) then
  If MessageDlg(IL_Format('Are you sure you want to remove %s picture?',
       [IL_ItemPictureKindToStr(fPicturesManager.Kind(TImage(pmnPicturesMenu.PopupComponent)))]),
       mtConfirmation,[mbYes,mbNo],0) = mrYes then
    case fPicturesManager.Kind(TImage(pmnPicturesMenu.PopupComponent)) of
      ilipkMain:      fCurrentItem.ItemPicture := nil;
      ilipkSecondary: fCurrentItem.SecondaryPicture := nil;
      ilipkPackage:   fCurrentItem.PackagePicture := nil;
    end;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.mniPM_RemoveItemPicClick(Sender: TObject);
begin
If Assigned(fCurrentItem) then
  If MessageDlg(IL_Format('Are you sure you want to remove %s picture?',
                [IL_ItemPictureKindToStr(ilipkMain)]),
                mtConfirmation,[mbYes,mbNo],0) = mrYes then
    fCurrentItem.ItemPicture := nil;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.mniPM_RemoveSecondaryPicClick(Sender: TObject);
begin
If Assigned(fCurrentItem) then
  If MessageDlg(IL_Format('Are you sure you want to remove %s picture?',
                [IL_ItemPictureKindToStr(ilipkSecondary)]),
                mtConfirmation,[mbYes,mbNo],0) = mrYes then
    fCurrentItem.SecondaryPicture := nil;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.mniPM_RemovePackagePicClick(Sender: TObject);
begin
If Assigned(fCurrentItem) then
  If MessageDlg(IL_Format('Are you sure you want to remove %s picture?',
                [IL_ItemPictureKindToStr(ilipkPackage)]),
                mtConfirmation,[mbYes,mbNo],0) = mrYes then
    fCurrentItem.PackagePicture := nil;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.mniPM_SwapItemPicClick(Sender: TObject);
begin
If Assigned(fCurrentItem) and (pmnPicturesMenu.PopupComponent is TImage) then
  fCurrentItem.SwapPictures(fPicturesManager.Kind(TImage(pmnPicturesMenu.PopupComponent)),ilipkMain);
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.mniPM_SwapSecondaryPicClick(Sender: TObject);
begin
If Assigned(fCurrentItem) and (pmnPicturesMenu.PopupComponent is TImage) then
  fCurrentItem.SwapPictures(fPicturesManager.Kind(TImage(pmnPicturesMenu.PopupComponent)),ilipkSecondary);
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.mniPM_SwapPackagePicClick(Sender: TObject);
begin
If Assigned(fCurrentItem) and (pmnPicturesMenu.PopupComponent is TImage) then
  fCurrentItem.SwapPictures(fPicturesManager.Kind(TImage(pmnPicturesMenu.PopupComponent)),ilipkPackage);
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

procedure TfrmItemFrame.seIDChange(Sender: TObject);
begin
If not fInitializing and Assigned(fCurrentItem) then
  fCurrentItem.ID := seID.Value;
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
ScreenPoint := btnFlagMacros.ClientToScreen(
  Point(0,btnFlagMacros.Height));
pmnFlagMacros.Popup(ScreenPoint.X,ScreenPoint.Y);
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.CommonFlagMacroClick(Sender: TObject);
begin
If (Sender is TMenuItem) and Assigned(fCurrentItem) then
  case TMenuItem(Sender).Tag of
    0:  If [ilifWanted,ilifOrdered] <= fCurrentItem.Flags then  // ordered item received
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
    1:  If ilifUntested in fCurrentItem.Flags then  // starting item testing
          begin
            fCurrentItem.BeginUpdate;
            try
              fCurrentItem.SetFlagValue(ilifUntested,False);
              fCurrentItem.SetFlagValue(ilifTesting,True);
            finally
              fCurrentItem.EndUpdate;
            end;
          end;
    2:  If ilifTesting in fCurrentItem.Flags then // testing of item is finished
          begin
            fCurrentItem.BeginUpdate;
            try
              fCurrentItem.SetFlagValue(ilifTesting,False);
              fCurrentItem.SetFlagValue(ilifTested,True);
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

procedure TfrmItemFrame.leItemPictureFileChange(Sender: TObject);
begin
If not fInitializing and Assigned(fCurrentItem) then
  fCurrentItem.ItemPictureFile := leItemPictureFile.Text;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.btnBrowseItemPictureFileClick(Sender: TObject);
var
  Temp: String;
begin
If not fInitializing and Assigned(fCurrentItem) then
  begin
    Temp := fCurrentItem.ItemPictureFile;
    If BrowsePicture(IL_ItemPictureKindToStr(ilipkMain),Temp) then
      leItemPictureFile.Text := Temp; // also sets field in current item
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.leSecondaryPictureFileChange(Sender: TObject);
begin
If not fInitializing and Assigned(fCurrentItem) then
  fCurrentItem.SecondaryPictureFile := leSecondaryPictureFile.Text;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.btnBrowseSecondaryPictureFileClick(Sender: TObject);
var
  Temp: String;
begin
If not fInitializing and Assigned(fCurrentItem) then
  begin
    Temp := fCurrentItem.SecondaryPictureFile;
    If BrowsePicture(IL_ItemPictureKindToStr(ilipkSecondary),Temp) then
      leSecondaryPictureFile.Text := Temp;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.lePackagePictureFileChange(Sender: TObject);
begin
If not fInitializing and Assigned(fCurrentItem) then
  fCurrentItem.PackagePictureFile := lePackagePictureFile.Text;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.btnBrowsePackagePictureFileClick(Sender: TObject);
var
  Temp: String;
begin
If not fInitializing and Assigned(fCurrentItem) then
  begin
    Temp := fCurrentItem.PackagePictureFile;
    If BrowsePicture(IL_ItemPictureKindToStr(ilipkPackage),Temp) then
      lePackagePictureFile.Text := Temp;
  end;
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
If not fInitializing and Assigned(fCurrentItem)then
  fCurrentItem.Rating := seRating.Value;
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

procedure TfrmItemFrame.Button1Click(Sender: TObject);
begin
If Assigned(fCurrentItem) then
  begin
    fCurrentItem.Encrypted := not fCurrentItem.Encrypted;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.tmrHighlightTimerTimer(Sender: TObject);
begin
tmrHighlightTimer.Tag := tmrHighlightTimer.Tag - 1;
If tmrHighlightTimer.Tag <= 0 then
  DisableHighlight;
end;

end.
