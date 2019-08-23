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
    PicKind:      TLIItemPictureKind;
    PicAssigned:  Boolean;
  end;

  TILItemFramePicturesManager = class(TObject)
  private
    fImages:        array of TILItemFramePicturesManagerEntry;
    fPictureKinds:  TLIItemPictureKinds;
  protected
  public
    constructor Create;
    destructor Destroy; override;
    Function IndexOf(Image: TImage): Integer; virtual;
    Function Add(Image: TImage): Integer; virtual;
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
    procedure btnUpdateShopsClick(Sender: TObject);
    procedure btnShopsClick(Sender: TObject);
  private
    fInitializing:    Boolean;
    fILManager:       TILManager;
    fCurrentItem:     TILItem;
    fLastSmallPicDir: String;
    fLastPicDir:      String;
    fPicturesManager: TILItemFramePicturesManager;
  protected
    procedure UpdateTitle(Sender: TObject);
    procedure UpdateManufacturerLogo(Sender: TObject);
    procedure UpdatePictures(Sender: TObject);
    procedure ProcessAndShowReadOnlyInfo;
    procedure ShowSelectedShop(const SelectedShop: String);
    procedure FrameSave;
    procedure FrameLoad;
    procedure FrameClear;
    procedure BrowseSmallPicture(const FileStr: String; out Bitmap: TBitmap; StoredBitmap: TBitmap);
  public
    OnShowSelectedItem: TNotifyEvent;
    OnFocusList:        TNotifyEvent;
    procedure Initialize(ILManager: TILManager);
    procedure Finalize;
    procedure SaveItem;
    procedure LoadItem;
    procedure SetItem(Item: TILItem; ProcessChange: Boolean);
  end;

implementation

uses
  AuxTypes,
  TextEditForm, ShopsForm, UpdateForm,
  InflatablesList_Utils,
  InflatablesList_ItemShop;

{$R *.dfm}

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

Function TILItemFramePicturesManager.Add(Image: TImage): Integer;
begin
Result := IndexOf(Image);
If Result < 0 then
  begin
    Result := Length(fImages);
    SetLength(fImages,Length(fImages) + 1);
    fImages[Result].Image := Image;
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
        fImages[i].PicKind := PictureKind;
        fImages[i].PicAssigned := True;
        fImages[i].Image.ShowHint := PictureKind <> ilipkUnknown;
        case PictureKind of
          ilipkMain:      fImages[i].Image.Hint := 'Item picture';
          ilipkSecondary: fImages[i].Image.Hint := 'Secondary picture';
          ilipkPackage:   fImages[i].Image.Hint := 'Package picture';
        else
          fImages[i].Image.Hint := '';
        end;
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
    end;
end;

//******************************************************************************
//==============================================================================
//******************************************************************************

procedure TfrmItemFrame.UpdateTitle(Sender: TObject);
var
  ManufStr: String;
  TypeStr:  String;
begin
If Assigned(fCurrentItem) then
  begin
    // construct manufacturer + ID string
    ManufStr := fCurrentItem.TitleStr;
    // constructy item type string
    TypeStr := fCurrentItem.TypeStr;
    // final concatenation
    If Length(TypeStr) > 0 then
      ManufStr := Format('%s - %s',[ManufStr,TypeStr]);
    If fCurrentItem.Pieces > 1 then
      ManufStr := Format('%s (%dx)',[ManufStr,fCurrentItem.Pieces]);
    lblItemTitle.Caption := ManufStr;
  end
else lblItemTitle.Caption := '';
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.UpdateManufacturerLogo(Sender: TObject);
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

procedure TfrmItemFrame.UpdatePictures(Sender: TObject);
begin
fPicturesManager.PictureAssignStart;
try
  If Assigned(fCurrentItem) and not fILManager.StaticOptions.NoPictures then
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

procedure TfrmItemFrame.ProcessAndShowReadOnlyInfo;
var
  SelectedShop: TILItemShop;
begin
If Assigned(fCurrentItem) then
  begin
    // total weight
    If fCurrentItem.TotalWeight > 0 then
      lblTotalWeight.Caption := fCurrentItem.TotalWeightStr
    else
      lblTotalWeight.Caption := '-';
    // selected shop
    If fCurrentItem.ShopsSelected(SelectedShop) then
      ShowSelectedShop(SelectedShop.Name)
    else
      ShowSelectedShop('-');
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
    // unit price lowest
    If fCurrentItem.UnitPriceLowest > 0 then
      begin
        lblUnitPriceLowest.Caption := Format('%d Kè',[fCurrentItem.UnitPriceLowest]);
        lblTotalPriceLowest.Caption := Format('%d Kè',[fCurrentItem.TotalPriceLowest]);
      end
    else
      begin
        lblUnitPriceLowest.Caption := '-';
        lblTotalPriceLowest.Caption := '-';
      end;
    // unit price selected
    If fCurrentItem.UnitPriceSelected > 0 then
      begin
        lblUnitPriceSelected.Caption := Format('%d Kè',[fCurrentItem.UnitPriceSelected]);
        lblTotalPriceSelected.Caption := Format('%d Kè',[fCurrentItem.TotalPriceSelected]);
      end
    else
      begin
        lblUnitPriceSelected.Caption := '-';
        lblTotalPriceSelected.Caption := '-';
      end;
    // unit price selected background
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
    // ignore time of creation, it is set in loading
    lblTotalWeight.Caption := '-';
    ShowSelectedShop('');
    lblShopCount.Caption := '0';
    lblUnitPriceLowest.Caption := '-';
    lblUnitPriceSelected.Caption := '-';
    shpUnitPriceSelectedBcgr.Visible := False;
    lblAvailPieces.Caption := '0';
    lblTotalPriceLowest.Caption := '-';
    lblTotalPriceSelected.Caption := '-';
    shpTotalPriceSelectedBcgr.Visible := False;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.ShowSelectedShop(const SelectedShop: String);
begin
If lblSelectedShop.Canvas.TextWidth(SelectedShop) <=
  (lblShopCount.BoundsRect.Right - lblSelectedShopTitle.BoundsRect.Right - 8) then
  lblSelectedShop.Left := lblShopCount.BoundsRect.Right - lblSelectedShop.Canvas.TextWidth(SelectedShop)
else
  lblSelectedShop.Left := lblSelectedShopTitle.BoundsRect.Right + 8;
lblSelectedShop.Caption := SelectedShop;
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
      lblTimeOfAddition.Caption := FormatDateTime('yyyy-mm-dd hh:nn:ss',fCurrentItem.TimeOfAddition);
      // basic specs
      UpdateTitle(nil);
      UpdateManufacturerLogo(nil);      
      UpdatePictures(nil);
      cmbItemType.ItemIndex := Ord(fCurrentItem.ItemType);
      leItemTypeSpecification.Text := fCurrentItem.ItemTypeSpec;
      sePieces.Value := fCurrentItem.Pieces;
      cmbManufacturer.ItemIndex := Ord(fCurrentItem.Manufacturer);
      leManufacturerString.Text := fCurrentItem.ManufacturerStr;
      leTextID.Text := fCurrentItem.TextID;
      seID.Value := fCurrentItem.ID;
      // tags, flags
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
      ProcessAndShowReadOnlyInfo;
    finally
      fInitializing := False;
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.FrameClear;
begin
fInitializing := True;
try
  // only called in init
  UpdateTitle(nil);
  UpdateManufacturerLogo(nil);
  UpdatePictures(nil);
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
  // read-only things
  lblTotalWeight.Caption := '-';
  ShowSelectedShop('');
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

procedure TfrmItemFrame.BrowseSmallPicture(const FileStr: String; out Bitmap: TBitmap; StoredBitmap: TBitmap);
begin
diaPicOpenDialog.Title := Format('Select %s picture',[FileStr]);
diaPicOpenDialog.Filter := 'BMP image files|*.bmp|All files|*.*';
diaPicOpenDialog.FileName := '';
diaPicOpenDialog.InitialDir := fLastSmallPicDir;
If diaPicOpenDialog.Execute then
  try
    fLastSmallPicDir := ExtractFileDir(diaPicOpenDialog.FileName);
    Bitmap := TBitmap.Create;
    Bitmap.LoadFromFile(diaPicOpenDialog.FileName);
    If Assigned(StoredBitmap) then
      begin
        If MessageDlg(Format('Replace current %s picture?',[FileStr]),mtConfirmation,[mbYes,mbNo],0) <> mrYes then
          FreeAndNil(Bitmap);
      end;
  except
    // supress error
    If Assigned(Bitmap) then
      FreeAndNil(Bitmap);
    MessageDlg('Error while loading the file.',mtError,[mbOK],0);
  end;
end;

//==============================================================================

procedure TfrmItemFrame.Initialize(ILManager: TILManager);
var
  i:  Integer;
begin
fPicturesManager := TILItemFramePicturesManager.Create;
fPicturesManager.Add(imgPictureA);
fPicturesManager.Add(imgPictureB);
fPicturesManager.Add(imgPictureC);
fInitializing := False;
fILManager := ILManager;
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
SetItem(nil,True);
fLastSmallPicDir := '';
fLastPicDir := '';
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.Finalize;
begin
FreeAndNil(fPicturesManager);
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.SaveItem;
begin
FrameSave;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.LoadItem;
begin
If Assigned(fCurrentItem) then
  FrameLoad
else
  FrameClear;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.SetItem(Item: TILItem; ProcessChange: Boolean);
var
  Reassigned: Boolean;
begin
Reassigned := fCurrentItem = Item;
If Assigned(fCurrentItem) then
  fCurrentItem.Release(True);
If ProcessChange then
  begin
    If Assigned(fCurrentItem) and not Reassigned then
      FrameSave;
    If Assigned(Item) then
      begin
        fCurrentItem := Item;
        fCurrentItem.OnTitleUpdate := UpdateTitle;
        fCurrentItem.OnPicturesUpdate := UpdatePictures;
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
end;

//==============================================================================

procedure TfrmItemFrame.lblItemTitleClick(Sender: TObject);
begin
If Assigned(OnShowSelectedItem) then
  OnShowSelectedItem(Self);
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.imgPictureClick(Sender: TObject);

  procedure OpenPicture(const FileName: String);
  begin
    If FileExists(IL_PathAbsolute(fILManager.ListFilePath,FileName)) then
      IL_ShellOpen(Self.Handle,IL_PathAbsolute(fILManager.ListFilePath,FileName));
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
    mniPM_RemoveItemPic.Visible := (PicKind <> ilipkMain) and Assigned(fCurrentItem.ItemPicture);;
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
      ilipkMain:      BrowseSmallPicture('item',TempBitmap,fCurrentItem.ItemPicture);
      ilipkSecondary: BrowseSmallPicture('secondary',TempBitmap,fCurrentItem.SecondaryPicture);
      ilipkPackage:   BrowseSmallPicture('package',TempBitmap,fCurrentItem.PackagePicture);
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
BrowseSmallPicture('item',TempBitmap,fCurrentItem.ItemPicture);
If Assigned(TempBitmap) then
  fCurrentItem.ItemPicture := TempBitmap;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.mniPM_LoadSecondaryPicClick(Sender: TObject);
var
  TempBitmap: TBitmap;
begin
TempBitmap := nil;
BrowseSmallPicture('secondary',TempBitmap,fCurrentItem.SecondaryPicture);
If Assigned(TempBitmap) then
  fCurrentItem.SecondaryPicture := TempBitmap;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.mniPM_LoadPackagePicClick(Sender: TObject);
var
  TempBitmap: TBitmap;
begin
TempBitmap := nil;
BrowseSmallPicture('package',TempBitmap,fCurrentItem.PackagePicture);
If Assigned(TempBitmap) then
  fCurrentItem.PackagePicture := TempBitmap;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.mniPM_ExportPicClick(Sender: TObject);

  procedure ExportPicture(const FileStr: String; StoredBitmap: TBitmap);
  begin
    If Assigned(StoredBitmap) then
      begin
        diaPicExport.Title := Format('Export %s picture',[FileStr]);
        diaPicExport.FileName := '';
        If diaPicExport.Execute then
          StoredBitmap.SaveToFile(diaPicExport.FileName);
      end;
  end;

begin
If Assigned(fCurrentItem) and (pmnPicturesMenu.PopupComponent is TImage) then
  case fPicturesManager.Kind(TImage(pmnPicturesMenu.PopupComponent)) of
    ilipkMain:      ExportPicture('item',fCurrentItem.ItemPicture);
    ilipkSecondary: ExportPicture('secondary',fCurrentItem.SecondaryPicture);
    ilipkPackage:   ExportPicture('package',fCurrentItem.PackagePicture);
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.mniPM_RemovePicClick(Sender: TObject);
begin
If Assigned(fCurrentItem) and (pmnPicturesMenu.PopupComponent is TImage) then
  If MessageDlg('Are you sure you want to remove this picture?',
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
  If MessageDlg('Are you sure you want to remove item picture?',
                mtConfirmation,[mbYes,mbNo],0) = mrYes then
    fCurrentItem.ItemPicture := nil;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.mniPM_RemoveSecondaryPicClick(Sender: TObject);
begin
If Assigned(fCurrentItem) then
  If MessageDlg('Are you sure you want to remove secondary picture?',
                mtConfirmation,[mbYes,mbNo],0) = mrYes then
    fCurrentItem.SecondaryPicture := nil;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.mniPM_RemovePackagePicClick(Sender: TObject);
begin
If Assigned(fCurrentItem) then
  If MessageDlg('Are you sure you want to remove package picture?',
                mtConfirmation,[mbYes,mbNo],0) = mrYes then
    fCurrentItem.PackagePicture := nil;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.mniPM_SwapItemPicClick(Sender: TObject);
begin
If Assigned(fCurrentItem) and (pmnPicturesMenu.PopupComponent is TImage) then
  fCurrentItem.SwitchPictures(fPicturesManager.Kind(TImage(pmnPicturesMenu.PopupComponent)),ilipkMain);
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.mniPM_SwapSecondaryPicClick(Sender: TObject);
begin
If Assigned(fCurrentItem) and (pmnPicturesMenu.PopupComponent is TImage) then
  fCurrentItem.SwitchPictures(fPicturesManager.Kind(TImage(pmnPicturesMenu.PopupComponent)),ilipkSecondary);
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.mniPM_SwapPackagePicClick(Sender: TObject);
begin
If Assigned(fCurrentItem) and (pmnPicturesMenu.PopupComponent is TImage) then
  fCurrentItem.SwitchPictures(fPicturesManager.Kind(TImage(pmnPicturesMenu.PopupComponent)),ilipkPackage);
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
  begin
    SaveItem;
    fCurrentItem.BeginUpdate;
    try
      fCurrentItem.Pieces := sePieces.Value;
      fCurrentItem.FlagPriceAndAvail(fCurrentItem.UnitPriceSelected,fCurrentItem.AvailableSelected);
    finally
      fCurrentItem.EndUpdate;
    end;
    LoadItem;
    // no need to explicitly update render and list, it is done when setting pieces
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.cmbManufacturerChange(Sender: TObject);
begin
If not fInitializing and Assigned(fCurrentItem) then
  begin
    fCurrentItem.Manufacturer := TILItemManufacturer(cmbManufacturer.ItemIndex);
    UpdateManufacturerLogo(nil);
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
  If not fInitializing then
    begin
      If Assigned(fCurrentItem) then
        case TCheckBox(Sender).Tag of
          1:  fCurrentItem.SetFlagValue(ilifOwned,cbFlagOwned.Checked);
          2:  begin
                fCurrentItem.BeginUpdate;
                try
                  SaveItem; // wanted flag is set here
                  fCurrentItem.FlagPriceAndAvail(fCurrentItem.UnitPriceSelected,fCurrentItem.AvailableSelected);
                  LoadItem;
                finally
                  fCurrentItem.EndUpdate;
                end;
              end;
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
If not fInitializing then
  begin
    If Assigned(fCurrentItem) then
      fCurrentItem.UnitWeight := seUnitWeight.Value;
    ProcessAndShowReadOnlyInfo;
  end;
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
begin
If Assigned(fCurrentItem) then
  begin
    diaPicOpenDialog.Title := 'Select item picture file';
    diaPicOpenDialog.Filter := 'JPEG image files|*.jpg|All files|*.*';
    diaPicOpenDialog.FileName := '';
    diaPicOpenDialog.InitialDir := fLastPicDir;
    If diaPicOpenDialog.Execute then
    begin
      fLastPicDir := ExtractFileDir(diaPicOpenDialog.FileName);
      If Length(fCurrentItem.ItemPictureFile) > 0 then
        begin
          If MessageDlg('Replace current main picture file?',mtConfirmation,[mbYes,mbNo],0) = mrYes then
            fCurrentItem.ItemPictureFile := IL_PathRelative(fILManager.ListFilePath,diaPicOpenDialog.FileName);
        end
      else fCurrentItem.ItemPictureFile := IL_PathRelative(fILManager.ListFilePath,diaPicOpenDialog.FileName);
      leItemPictureFile.Text := fCurrentItem.ItemPictureFile;
    end;
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
begin
If Assigned(fCurrentItem) then
  begin
    diaPicOpenDialog.Title := 'Select secondary picture file';
    diaPicOpenDialog.Filter := 'JPEG image files|*.jpg|All files|*.*';
    diaPicOpenDialog.FileName := '';
    diaPicOpenDialog.InitialDir := fLastPicDir;
    If diaPicOpenDialog.Execute then
    begin
      fLastPicDir := ExtractFileDir(diaPicOpenDialog.FileName);
      If Length(fCurrentItem.SecondaryPictureFile) > 0 then
        begin
          If MessageDlg('Replace current secondary picture file?',mtConfirmation,[mbYes,mbNo],0) = mrYes then
            fCurrentItem.SecondaryPictureFile := IL_PathRelative(fILManager.ListFilePath,diaPicOpenDialog.FileName);
        end
      else fCurrentItem.SecondaryPictureFile := IL_PathRelative(fILManager.ListFilePath,diaPicOpenDialog.FileName);
      leSecondaryPictureFile.Text := fCurrentItem.SecondaryPictureFile;
    end;
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
begin
If Assigned(fCurrentItem) then
  begin
    diaPicOpenDialog.Title := 'Select package picture file';
    diaPicOpenDialog.Filter := 'JPEG image files|*.jpg|All files|*.*';
    diaPicOpenDialog.FileName := '';
    diaPicOpenDialog.InitialDir := fLastPicDir;
    If diaPicOpenDialog.Execute then
    begin
      fLastPicDir := ExtractFileDir(diaPicOpenDialog.FileName);
      If Length(fCurrentItem.PackagePictureFile) > 0 then
        begin
          If MessageDlg('Replace current package picture file?',mtConfirmation,[mbYes,mbNo],0) = mrYes then
            fCurrentItem.PackagePictureFile := IL_PathRelative(fILManager.ListFilePath,diaPicOpenDialog.FileName);
        end
      else fCurrentItem.PackagePictureFile := IL_PathRelative(fILManager.ListFilePath,diaPicOpenDialog.FileName);
      lePackagePictureFile.Text := fCurrentItem.PackagePictureFile;
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.seUnitPriceDefaultChange(Sender: TObject);
begin
If not fInitializing then
  begin
    If Assigned(fCurrentItem) then
      fCurrentItem.UnitPriceDefault := seUnitPriceDefault.Value;
    ProcessAndShowReadOnlyInfo;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.btnUpdateShopsClick(Sender: TObject);
var
  i:        Integer;
  Temp:     TILItemShopUpdateList;
  OldAvail: Int32;
  OldPrice: UInt32;
begin
If Assigned(fCurrentItem) then
  begin
    If fCurrentItem.ShopCount > 0 then
      begin
        SaveItem;
        fCurrentItem.BroadcastReqCount;
        SetLength(Temp,fCurrentItem.ShopCount);
        For i := Low(Temp) to High(Temp) do
          begin
            Temp[i].Item := fCurrentItem;
            Temp[i].ItemTitle := Format('[#%d] %s',[fCurrentItem.Index + 1,fCurrentItem.TitleStr]);
            Temp[i].ItemShop := fCurrentItem.Shops[i];
            Temp[i].Done := False;
          end;
        fUpdateForm.ShowUpdate(Temp);
        OldAvail := fCurrentItem.AvailableSelected;
        OldPrice := fCurrentItem.UnitPriceSelected;
        fCurrentItem.UpdatePriceAndAvail;
        fCurrentItem.FlagPriceAndAvail(OldPrice,OldAvail);
        LoadItem;
        fCurrentItem.ReDraw;
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
    SaveItem;
    fCurrentItem.BroadcastReqCount;
    fShopsForm.ShowShops(fCurrentItem);
    // load potential changes
    LoadItem;
    fCurrentItem.ReDraw;
    If Assigned(OnFocusList) then
      OnFocusList(Self);
  end;
end;

end.
