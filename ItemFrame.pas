unit ItemFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ExtCtrls, StdCtrls, Spin, Menus,
  InflatablesList_Types, InflatablesList;

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
    lblItemType: TLabel;
    cmbItemType: TComboBox;
    leItemTypeSpecification: TLabeledEdit;
    lblCount: TLabel;
    seCount: TSpinEdit;
    lblManufacturer: TLabel;
    cmbManufacturer: TComboBox;
    leManufacturerString: TLabeledEdit;
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
    bvlTextTagSep: TBevel;
    leTextTag: TLabeledEdit;
    lblWantedLevel: TLabel;
    seWantedLevel: TSpinEdit;
    leVariant: TLabeledEdit;
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
    leReviewURL: TLabeledEdit;
    btnReviewOpen: TButton;    
    leMainPictureFile: TLabeledEdit;
    btnBrowseMainPictureFile: TButton;
    lePackagePictureFile: TLabeledEdit;
    btnBrowsePackagePictureFile: TButton;
    bvlInfoSep: TBevel;
    lblUnitDefaultPrice: TLabel;
    seUnitPriceDefault: TSpinEdit;
    btnUpdateShops: TButton;
    btnShops: TButton;
    lblTimeOfCreationTitle: TLabel;
    lblTimeOfCreation: TLabel;
    lblTotalWeightTitle: TLabel;
    lblTotalWeight: TLabel;
    lblSelectedShopTitle: TLabel;
    lblSelectedShop: TLabel;
    lblShopCountTitle: TLabel;
    lblShopCount: TLabel;
    lblUnitPriceLowestTitle: TLabel;
    lblUnitPriceLowest: TLabel;
    lblUnitPriceSelectedTitle: TLabel;
    lblUnitPriceSelected: TLabel;
    shpUnitPriceSelectedBcgr: TShape;
    lblAvailPiecesTitle: TLabel;
    lblAvailPieces: TLabel;
    lblTotalPriceLowestTitle: TLabel;
    lblTotalPriceLowest: TLabel;
    lblTotalPriceSelectedTitle: TLabel;
    lblTotalPriceSelected: TLabel;
    shpTotalPriceSelectedBcgr: TShape;
    diaImgOpenDialog: TOpenDialog;
    pmnImagesMenu: TPopupMenu;
    mniIM_Load: TMenuItem;
    mniIM_Export: TMenuItem;    
    N1: TMenuItem;
    mniIM_Remove: TMenuItem;
    mniIM_RemoveMain: TMenuItem;
    mniIM_RemovePackage: TMenuItem;
    N2: TMenuItem;
    mniIM_Switch: TMenuItem;
    diaImgExport: TSaveDialog;
    procedure lblItemTitleClick(Sender: TObject);    
    procedure imgPictureClick(Sender: TObject);
    procedure cmbItemTypeChange(Sender: TObject);
    procedure leItemTypeSpecificationChange(Sender: TObject);
    procedure seCountChange(Sender: TObject);
    procedure cmbManufacturerChange(Sender: TObject);
    procedure leManufacturerStringChange(Sender: TObject);
    procedure seIDChange(Sender: TObject);
    procedure CommonFlagClick(Sender: TObject);
    procedure leTextTagChange(Sender: TObject);
    procedure seWantedLevelChange(Sender: TObject);
    procedure leVariantChange(Sender: TObject);
    procedure seSizeXChange(Sender: TObject);
    procedure seSizeYChange(Sender: TObject);
    procedure seSizeZChange(Sender: TObject);
    procedure seUnitWeightChange(Sender: TObject);
    procedure meNotesDblClick(Sender: TObject);
    procedure meNotesKeyPress(Sender: TObject; var Key: Char);       
    procedure leReviewURLChange(Sender: TObject);
    procedure btnReviewOpenClick(Sender: TObject);        
    procedure leMainPictureFileChange(Sender: TObject);
    procedure btnBrowseMainPictureFileClick(Sender: TObject);
    procedure lePackagePictureFileChange(Sender: TObject);
    procedure btnBrowsePackagePictureFileClick(Sender: TObject);
    procedure seUnitPriceDefaultChange(Sender: TObject);
    procedure btnUpdateShopsClick(Sender: TObject);
    procedure btnShopsClick(Sender: TObject);
    procedure pmnImagesMenuPopup(Sender: TObject);
    procedure mniIM_LoadClick(Sender: TObject);
    procedure mniIM_ExportClick(Sender: TObject);
    procedure mniIM_RemoveClick(Sender: TObject);
    procedure mniIM_RemoveMainClick(Sender: TObject);
    procedure mniIM_RemovePackageClick(Sender: TObject);
    procedure mniIM_SwitchClick(Sender: TObject);
  private
    fInitializing:    Boolean;
    fILManager:       TILManager;
    fCurrentItemPtr:  PILItem;
    fLastSmallPicDir: String;
    fLastPicDir:      String;
  protected
    procedure DoTitleChange;
    procedure DoListItemChange;
    procedure ProcessAndShowReadOnlyInfo;
    procedure ShowPictures;
    procedure FrameSave;
    procedure FrameLoad;
    procedure FrameClear;
  public
    OnListInvalidate: TNotifyEvent;
    OnShowListItem: TNotifyEvent;
    procedure Initialize(ILManager: TILManager);
    procedure SaveItem;
    procedure LoadItem;
    procedure SetItem(ItemPtr: PILItem; ProcessChange: Boolean);
  end;

implementation

uses
  ShellAPI, AuxTypes,
  InflatablesList_Utils,
  ShopsForm, TextEditForm, UpdateForm;

{$R *.dfm}

procedure TfrmItemFrame.DoTitleChange;
var
  ManufStr: String;
  TypeStr:  String;
begin
If Assigned(fCurrentItemPtr) then
  begin
    // construct manufacturer + ID string
    ManufStr := fILManager.ItemTitleStr(fCurrentItemPtr^);
    // constructy item type string
    TypeStr := fILManager.ItemTypeStr(fCurrentItemPtr^);
    // final concatenation
    If Length(TypeStr) > 0 then
      ManufStr := Format('%s - %s',[ManufStr,TypeStr]);
    If fCurrentItemPtr^.Count > 1 then
      ManufStr := Format('%s (%dx)',[ManufStr,fCurrentItemPtr^.Count]);
    lblItemTitle.Caption := ManufStr;
  end
else lblItemTitle.Caption := '';
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.DoListItemChange;
begin
// redraw item
If Assigned(fCurrentItemPtr) then
  begin
    If Assigned(fCurrentItemPtr) then
      fILManager.ItemRedraw(fCurrentItemPtr^);
    If Assigned(OnListInvalidate) then
      OnListInvalidate(Self);
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.ProcessAndShowReadOnlyInfo;
var
  SelectedShop: TILItemShop;
begin
If Assigned(fCurrentItemPtr) then
  begin
    // total weight
    lblTotalWeight.Caption := Format('%g kg',[fILManager.ItemTotalWeight(fCurrentItemPtr^) / 1000]);
    If fILManager.ItemSelectedShop(fCurrentItemPtr^,SelectedShop) then
      lblSelectedShop.Caption := SelectedShop.Name
    else
      lblSelectedShop.Caption := '';
    lblShopCount.Caption := IntToStr(Length(fCurrentItemPtr^.Shops));
    // available pieces
    If fCurrentItemPtr^.AvailablePieces <> 0 then
      begin
        If fCurrentItemPtr^.AvailablePieces < 0 then
          lblAvailPieces.Caption := 'more than ' + IntToStr(Abs(fCurrentItemPtr^.AvailablePieces))
        else
          lblAvailPieces.Caption := IntToStr(fCurrentItemPtr^.AvailablePieces);
      end
    else lblAvailPieces.Caption := '-';
    // unit price lowest
    If fCurrentItemPtr^.UnitPriceLowest > 0 then
      begin
        lblUnitPriceLowest.Caption := Format('%d Kè',[fCurrentItemPtr^.UnitPriceLowest]);
        lblTotalPriceLowest.Caption := Format('%d Kè',[fILManager.ItemTotalPriceLowest(fCurrentItemPtr^)]);
      end
    else
      begin
        lblUnitPriceLowest.Caption := '-';
        lblTotalPriceLowest.Caption := '-';
      end;
    // unit price selected
    If fCurrentItemPtr^.UnitPriceSelected > 0 then
      begin
        lblUnitPriceSelected.Caption := Format('%d Kè',[fCurrentItemPtr^.UnitPriceSelected]);
        lblTotalPriceSelected.Caption := Format('%d Kè',[fILManager.ItemTotalPriceSelected(fCurrentItemPtr^)]);
      end
    else
      begin
        lblUnitPriceSelected.Caption := '-';
        lblTotalPriceSelected.Caption := '-';
      end;
    // unit price selected background
    If (fCurrentItemPtr^.UnitPriceSelected <> fCurrentItemPtr^.UnitPriceLowest) and (fCurrentItemPtr^.UnitPriceSelected > 0) then
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
    lblSelectedShop.Caption := '';
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

procedure TfrmItemFrame.ShowPictures;
begin
imgPictureA.Tag := 0;
imgPictureB.Tag := 0;
If Assigned(fCurrentItemPtr) then
  begin
    If Assigned(fCurrentItemPtr^.MainPicture) and Assigned(fCurrentItemPtr^.PackagePicture) then
      begin
        imgPictureA.Picture.Assign(fCurrentItemPtr^.MainPicture);
        imgPictureB.Picture.Assign(fCurrentItemPtr^.PackagePicture);
        imgPictureA.Tag := $21;
        imgPictureB.Tag := $12;
      end
    else If Assigned(fCurrentItemPtr^.MainPicture) then
      begin
        imgPictureA.Picture.Assign(nil);
        imgPictureB.Picture.Assign(fCurrentItemPtr^.MainPicture);
        imgPictureA.Tag := $10;
        imgPictureB.Tag := $01;
      end
    else If Assigned(fCurrentItemPtr^.PackagePicture) then
      begin
        imgPictureA.Picture.Assign(nil);
        imgPictureB.Picture.Assign(fCurrentItemPtr^.PackagePicture);
        imgPictureA.Tag := $20;
        imgPictureB.Tag := $02;
      end
    else
      begin
        imgPictureA.Picture.Assign(nil);
        imgPictureB.Picture.Assign(nil);
      end;
  end
else
  begin
    imgPictureA.Picture.Assign(nil);
    imgPictureB.Picture.Assign(nil);
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.FrameSave;
begin
// pictures and shops are not needed to be saved, they are saved on the fly
// also lowest and selected prices are not saved, they are read only set by other processes
If Assigned(fCurrentItemPtr) then
  begin
    // basic specs
    fCurrentItemPtr^.ItemType := TILItemType(cmbItemType.ItemIndex);
    fCurrentItemPtr^.ItemTypeSpec := leItemTypeSpecification.Text;
    fCurrentItemPtr^.Count := seCount.Value;
    fCurrentItemPtr^.Manufacturer := TILItemManufacturer(cmbManufacturer.ItemIndex);
    fCurrentItemPtr^.ManufacturerStr := leManufacturerString.Text;
    fCurrentItemPtr^.ID := seID.Value;
    // tags, flags
    IL_SetItemFlagValue(fCurrentItemPtr^.Flags,ilifOwned,cbFlagOwned.Checked);
    IL_SetItemFlagValue(fCurrentItemPtr^.Flags,ilifWanted,cbFlagWanted.Checked);
    IL_SetItemFlagValue(fCurrentItemPtr^.Flags,ilifOrdered,cbFlagOrdered.Checked);
    IL_SetItemFlagValue(fCurrentItemPtr^.Flags,ilifBoxed,cbFlagBoxed.Checked);
    IL_SetItemFlagValue(fCurrentItemPtr^.Flags,ilifElsewhere,cbFlagElsewhere.Checked);
    IL_SetItemFlagValue(fCurrentItemPtr^.Flags,ilifUntested,cbFlagUntested.Checked);
    IL_SetItemFlagValue(fCurrentItemPtr^.Flags,ilifTesting,cbFlagTesting.Checked);
    IL_SetItemFlagValue(fCurrentItemPtr^.Flags,ilifTested,cbFlagTested.Checked);
    IL_SetItemFlagValue(fCurrentItemPtr^.Flags,ilifDamaged,cbFlagDamaged.Checked);
    IL_SetItemFlagValue(fCurrentItemPtr^.Flags,ilifRepaired,cbFlagRepaired.Checked);
    IL_SetItemFlagValue(fCurrentItemPtr^.Flags,ilifPriceChange,cbFlagPriceChange.Checked);
    IL_SetItemFlagValue(fCurrentItemPtr^.Flags,ilifAvailChange,cbFlagAvailChange.Checked);
    IL_SetItemFlagValue(fCurrentItemPtr^.Flags,ilifNotAvailable,cbFlagNotAvailable.Checked);
    fCurrentItemPtr^.TextTag := leTextTag.Text;
    // extended specs
    fCurrentItemPtr^.WantedLevel := seWantedLevel.Value;    
    fCurrentItemPtr^.Variant := leVariant.Text;
    fCurrentItemPtr^.SizeX := seSizeX.Value;
    fCurrentItemPtr^.SizeY := seSizeY.Value;
    fCurrentItemPtr^.SizeZ := seSizeZ.Value;
    fCurrentItemPtr^.UnitWeight := seUnitWeight.Value;
    // others
    fCurrentItemPtr^.Notes := meNotes.Text;
    fCurrentItemPtr^.ReviewURL := leReviewURL.Text;
    fCurrentItemPtr^.MainPictureFile := leMainPictureFile.Text;
    fCurrentItemPtr^.PackagePictureFile := lePackagePictureFile.Text;
    fCurrentItemPtr^.UnitPriceDefault := seUnitPriceDefault.Value;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.FrameLoad;
begin
If Assigned(fCurrentItemPtr) then
  begin
    fInitializing := True;
    try
      // internals
      lblTimeOfCreation.Caption := FormatDateTime('yyyy-mm-dd hh:nn:ss',fCurrentItemPtr^.TimeOfAddition);
      // basic specs
      ShowPictures;
      cmbItemType.ItemIndex := Ord(fCurrentItemPtr^.ItemType);
      leItemTypeSpecification.Text := fCurrentItemPtr^.ItemTypeSpec;
      seCount.Value := fCurrentItemPtr^.Count;
      cmbManufacturer.ItemIndex := Ord(fCurrentItemPtr^.Manufacturer);
      leManufacturerString.Text := fCurrentItemPtr^.ManufacturerStr;
      seID.Value := fCurrentItemPtr^.ID;
      // tags, flags
      cbFlagOwned.Checked := ilifOwned in fCurrentItemPtr^.Flags;
      cbFlagWanted.Checked := ilifWanted in fCurrentItemPtr^.Flags;
      cbFlagOrdered.Checked := ilifOrdered in fCurrentItemPtr^.Flags;
      cbFlagBoxed.Checked := ilifBoxed in fCurrentItemPtr^.Flags;
      cbFlagElsewhere.Checked := ilifElsewhere in fCurrentItemPtr^.Flags;
      cbFlagUntested.Checked := ilifUntested in fCurrentItemPtr^.Flags;
      cbFlagTesting.Checked := ilifTesting in fCurrentItemPtr^.Flags;
      cbFlagTested.Checked := ilifTested in fCurrentItemPtr^.Flags;
      cbFlagDamaged.Checked := ilifDamaged in fCurrentItemPtr^.Flags;
      cbFlagRepaired.Checked := ilifRepaired in fCurrentItemPtr^.Flags;
      cbFlagPriceChange.Checked := ilifPriceChange in fCurrentItemPtr^.Flags;
      cbFlagAvailChange.Checked := ilifAvailChange in fCurrentItemPtr^.Flags;
      cbFlagNotAvailable.Checked := ilifNotAvailable in fCurrentItemPtr^.Flags;
      leTextTag.Text := fCurrentItemPtr^.TextTag;
      // extended specs
      seWantedLevel.Value := fCurrentItemPtr^.WantedLevel;
      leVariant.Text := fCurrentItemPtr^.Variant;
      seSizeX.Value := fCurrentItemPtr^.SizeX;
      seSizeY.Value := fCurrentItemPtr^.SizeY;
      seSizeZ.Value := fCurrentItemPtr^.SizeZ;
      seUnitWeight.Value := fCurrentItemPtr^.UnitWeight;
      // others
      meNotes.Text := fCurrentItemPtr^.Notes;
      leReviewURL.Text := fCurrentItemPtr^.ReviewURL;
      leMainPictureFile.Text := fCurrentItemPtr^.MainPictureFile;
      lePackagePictureFile.Text := fCurrentItemPtr^.PackagePictureFile;
      seUnitPriceDefault.Value := fCurrentItemPtr^.UnitPriceDefault;
      ProcessAndShowReadOnlyInfo;
    finally
      fInitializing := False;
    end;
    DoTitleChange;
    cmbManufacturer.OnChange(nil);
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.FrameClear;
begin
// only called in init
DoTitleChange;
// basic specs
imgManufacturerLogo.Picture.Assign(nil);
imgPictureA.Picture.Assign(nil);
imgPictureB.Picture.Assign(nil);
imgPictureA.Tag := 0;
imgPictureB.Tag := 0;
cmbItemType.ItemIndex := 0;
cmbItemType.OnChange(nil);
leItemTypeSpecification.Text := '';
seCount.Value := 1;
cmbManufacturer.ItemIndex := 0;
cmbManufacturer.OnChange(nil);
leManufacturerString.Text := '';
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
leTextTag.Text := '';
// ext. specs
seWantedLevel.Value := 0;
leVariant.Text := '';
seSizeX.Value := 0;
seSizeY.Value := 0;
seSizeZ.Value := 0;
seUnitWeight.Value := 0;
// other info
meNotes.Text := '';
leReviewURL.Text := '';
leMainPictureFile.Text := '';
lePackagePictureFile.Text := '';
seUnitPriceDefault.Value := 0;
// read-only things
lblTotalWeight.Caption := '-';
lblSelectedShop.Caption := '';
lblShopCount.Caption := '0';
lblUnitPriceLowest.Caption := '-';
lblUnitPriceSelected.Caption := '-';
shpUnitPriceSelectedBcgr.Visible := False;
lblAvailPieces.Caption := '0';
lblTotalPriceLowest.Caption := '-';
lblTotalPriceSelected.Caption := '-';
shpTotalPriceSelectedBcgr.Visible := False;
end;

//==============================================================================

procedure TfrmItemFrame.Initialize(ILManager: TILManager);
var
  i:  Integer;
begin
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
SetItem(nil,True);
fLastSmallPicDir := '';
fLastPicDir := '';
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.SaveItem;
begin
FrameSave;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.LoadItem;
begin
If Assigned(fCurrentItemPtr) then
  FrameLoad
else
  FrameClear;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.SetItem(ItemPtr: PILItem; ProcessChange: Boolean);
begin
If ProcessChange then
  begin
    If Assigned(fCurrentItemPtr) then
      FrameSave;
    If Assigned(ItemPtr) then
      begin
        fCurrentItemPtr := ItemPtr;
        FrameLoad;
      end
    else
      begin
        fCurrentItemPtr := nil;
        FrameClear;
      end;
    Visible := Assigned(fCurrentItemPtr);
    Enabled := Assigned(fCurrentItemPtr);
  end
else fCurrentItemPtr := ItemPtr;
end;

//==============================================================================

procedure TfrmItemFrame.lblItemTitleClick(Sender: TObject);
begin
If Assigned(OnShowListItem) then
  OnShowListItem(Self);
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.imgPictureClick(Sender: TObject);

  procedure OpenPicture(const FileName: String);
  begin
    If Length(FileName) > 0 then
      If FileExists(IL_PathAbsolute(FileName)) then
        ShellExecute(Handle,'open',PChar(IL_PathAbsolute(FileName)),nil,nil,SW_SHOWNORMAL);
  end;

begin
If Assigned(fCurrentItemPtr) and (Sender is TImage) then
  case TImage(Sender).Tag and $0F of
    1:  OpenPicture(fCurrentItemPtr^.MainPictureFile);
    2:  OpenPicture(fCurrentItemPtr^.PackagePictureFile);
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.cmbItemTypeChange(Sender: TObject);
begin
If not fInitializing then
  begin
    If Assigned(fCurrentItemPtr) then
      fCurrentItemPtr^.ItemType := TILItemType(cmbItemType.ItemIndex);
    DoTitleChange;
    DoListItemChange;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.leItemTypeSpecificationChange(Sender: TObject);
begin
If not fInitializing then
  begin
    If Assigned(fCurrentItemPtr) then
      fCurrentItemPtr^.ItemTypeSpec := leItemTypeSpecification.Text;
    DoTitleChange;
    DoListItemChange;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.seCountChange(Sender: TObject);
begin
If not fInitializing then
  begin
    If Assigned(fCurrentItemPtr) then
      begin
        SaveItem;
        fCurrentItemPtr^.Count := seCount.Value;
        fILManager.ItemFlagPriceAndAvail(fCurrentItemPtr^,fCurrentItemPtr^.AvailablePieces,fCurrentItemPtr^.UnitPriceSelected);
        LoadItem;
      end;
    DoTitleChange;
    DoListItemChange;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.cmbManufacturerChange(Sender: TObject);
begin
If not fInitializing then
  begin
    If Assigned(fCurrentItemPtr) then
      begin
        fCurrentItemPtr^.Manufacturer := TILItemManufacturer(cmbManufacturer.ItemIndex);
        imgManufacturerLogo.Picture.Assign(
          fILManager.DataProvider.ItemManufacturers[fCurrentItemPtr^.Manufacturer].Logo);
      end
    else imgManufacturerLogo.Picture.Assign(nil);
    DoTitleChange;
    DoListItemChange;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.leManufacturerStringChange(Sender: TObject);
begin
If not fInitializing then
  begin
    If Assigned(fCurrentItemPtr) then
      fCurrentItemPtr^.ManufacturerStr := leManufacturerString.Text;
    DoTitleChange;
    DoListItemChange;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.seIDChange(Sender: TObject);
begin
If not fInitializing then
  begin
    If Assigned(fCurrentItemPtr) then
      fCurrentItemPtr^.ID := seID.Value;
    DoTitleChange;
    DoListItemChange;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.CommonFlagClick(Sender: TObject);
begin
If Sender is TCheckBox then
  If not fInitializing then
    begin
      If Assigned(fCurrentItemPtr) then
        case TCheckBox(Sender).Tag of
          1:  IL_SetItemFlagValue(fCurrentItemPtr^.Flags,ilifOwned,cbFlagOwned.Checked);
          2:  begin
                SaveItem;
                IL_SetItemFlagValue(fCurrentItemPtr^.Flags,ilifWanted,cbFlagWanted.Checked);
                fILManager.ItemFlagPriceAndAvail(fCurrentItemPtr^,fCurrentItemPtr^.AvailablePieces,fCurrentItemPtr^.UnitPriceSelected);
                LoadItem;
              end;
          3:  IL_SetItemFlagValue(fCurrentItemPtr^.Flags,ilifOrdered,cbFlagOrdered.Checked);
          4:  IL_SetItemFlagValue(fCurrentItemPtr^.Flags,ilifBoxed,cbFlagBoxed.Checked);
          5:  IL_SetItemFlagValue(fCurrentItemPtr^.Flags,ilifElsewhere,cbFlagElsewhere.Checked);
          6:  IL_SetItemFlagValue(fCurrentItemPtr^.Flags,ilifUntested,cbFlagUntested.Checked);
          7:  IL_SetItemFlagValue(fCurrentItemPtr^.Flags,ilifTesting,cbFlagTesting.Checked);
          8:  IL_SetItemFlagValue(fCurrentItemPtr^.Flags,ilifTested,cbFlagTested.Checked);
          9:  IL_SetItemFlagValue(fCurrentItemPtr^.Flags,ilifDamaged,cbFlagDamaged.Checked);
          10: IL_SetItemFlagValue(fCurrentItemPtr^.Flags,ilifRepaired,cbFlagRepaired.Checked);
          11: IL_SetItemFlagValue(fCurrentItemPtr^.Flags,ilifPriceChange,cbFlagPriceChange.Checked);
          12: IL_SetItemFlagValue(fCurrentItemPtr^.Flags,ilifAvailChange,cbFlagAvailChange.Checked);
          13: IL_SetItemFlagValue(fCurrentItemPtr^.Flags,ilifNotAvailable,cbFlagNotAvailable.Checked);
        else
          Exit;
        end;
      DoListItemChange;
    end;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.leTextTagChange(Sender: TObject);
begin
If not fInitializing then
  begin
    If Assigned(fCurrentItemPtr) then
      fCurrentItemPtr^.TextTag := leTextTag.Text;
    DoListItemChange;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.seWantedLevelChange(Sender: TObject);
begin
If not fInitializing then
  begin
    If Assigned(fCurrentItemPtr) then
      fCurrentItemPtr^.WantedLevel := seWantedLevel.Value;
    DoListItemChange;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.leVariantChange(Sender: TObject);
begin
If not fInitializing then
  begin
    If Assigned(fCurrentItemPtr) then
      fCurrentItemPtr^.Variant := leVariant.Text;
    DoListItemChange;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.seSizeXChange(Sender: TObject);
begin
If not fInitializing then
  begin
    If Assigned(fCurrentItemPtr) then
      fCurrentItemPtr^.SizeX := seSizeX.Value;
    DoListItemChange;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.seSizeYChange(Sender: TObject);
begin
If not fInitializing then
  begin
    If Assigned(fCurrentItemPtr) then
      fCurrentItemPtr^.SizeY := seSizeY.Value;
    DoListItemChange;
  end;
end;
 
//------------------------------------------------------------------------------

procedure TfrmItemFrame.seSizeZChange(Sender: TObject);
begin
If not fInitializing then
  begin
    If Assigned(fCurrentItemPtr) then
      fCurrentItemPtr^.SizeZ := seSizeZ.Value;
    DoListItemChange;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.seUnitWeightChange(Sender: TObject);
begin
If not fInitializing then
  begin
    If Assigned(fCurrentItemPtr) then
      fCurrentItemPtr^.UnitWeight := seUnitWeight.Value;
    ProcessAndShowReadOnlyInfo;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.meNotesDblClick(Sender: TObject);
var
  Temp: String;
begin
If Assigned(fCurrentItemPtr) then
  begin
    Temp := meNotes.Text;
    fTextEditForm.ShowTextEditor('Edit item notes',Temp,False);
    meNotes.Text := Temp;
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

procedure TfrmItemFrame.leReviewURLChange(Sender: TObject);
begin
If not fInitializing then
  begin
    If Assigned(fCurrentItemPtr) then
      fCurrentItemPtr^.ReviewURL := leReviewURL.Text;
    DoListItemChange;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.btnReviewOpenClick(Sender: TObject);
begin
If Assigned(fCurrentItemPtr) then
  If Length(fCurrentItemPtr^.ReviewURL) > 0 then
    ShellExecute(Handle,'open',PChar(fCurrentItemPtr^.ReviewURL),nil,nil,SW_SHOWNORMAL);
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.leMainPictureFileChange(Sender: TObject);
begin
If not fInitializing and Assigned(fCurrentItemPtr) then
  fCurrentItemPtr^.MainPictureFile := leMainPictureFile.Text;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.btnBrowseMainPictureFileClick(Sender: TObject);
begin
If Assigned(fCurrentItemPtr) then
  begin
    diaImgOpenDialog.Title := 'Select main picture file';
    diaImgOpenDialog.Filter := 'JPEG image files|*.jpg|All files|*.*';
    diaImgOpenDialog.FileName := '';
    diaImgOpenDialog.InitialDir := fLastPicDir;
    If diaImgOpenDialog.Execute then
    begin
      fLastPicDir := ExtractFileDir(diaImgOpenDialog.FileName);
      If Length(fCurrentItemPtr^.MainPictureFile) > 0 then
        begin
          If MessageDlg('Replace current main picture file?',mtConfirmation,[mbYes,mbNo],0) = mrYes then
            fCurrentItemPtr^.MainPictureFile := IL_PathRelative(diaImgOpenDialog.FileName);
        end
      else fCurrentItemPtr^.MainPictureFile := IL_PathRelative(diaImgOpenDialog.FileName);
      leMainPictureFile.Text := fCurrentItemPtr^.MainPictureFile;
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.lePackagePictureFileChange(Sender: TObject);
begin
If not fInitializing and Assigned(fCurrentItemPtr) then
  fCurrentItemPtr^.PackagePictureFile := lePackagePictureFile.Text;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.btnBrowsePackagePictureFileClick(Sender: TObject);
begin
If Assigned(fCurrentItemPtr) then
  begin
    diaImgOpenDialog.Title := 'Select package picture file';
    diaImgOpenDialog.Filter := 'JPEG image files|*.jpg|All files|*.*';
    diaImgOpenDialog.FileName := '';
    diaImgOpenDialog.InitialDir := fLastPicDir;
    If diaImgOpenDialog.Execute then
    begin
      fLastPicDir := ExtractFileDir(diaImgOpenDialog.FileName);
      If Length(fCurrentItemPtr^.PackagePictureFile) > 0 then
        begin
          If MessageDlg('Replace current package picture file?',mtConfirmation,[mbYes,mbNo],0) = mrYes then
            fCurrentItemPtr^.PackagePictureFile := IL_PathRelative(diaImgOpenDialog.FileName);
        end
      else fCurrentItemPtr^.PackagePictureFile := IL_PathRelative(diaImgOpenDialog.FileName);
      lePackagePictureFile.Text := fCurrentItemPtr^.PackagePictureFile;
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.seUnitPriceDefaultChange(Sender: TObject);
begin
If not fInitializing then
  begin
    If Assigned(fCurrentItemPtr) then
      fCurrentItemPtr^.UnitPriceDefault := seUnitPriceDefault.Value;
    ProcessAndShowReadOnlyInfo;
    DoListItemChange;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.btnUpdateShopsClick(Sender: TObject);
var
  i:        Integer;
  Temp:     TILItemShopUpdates;
  OldAvail: Int32;
  OldPrice: UInt32;
begin
If Assigned(fCurrentItemPtr) then
  begin
    If Length(fCurrentItemPtr^.Shops) > 0 then
      begin
        SaveItem;
        SetLength(Temp,Length(fCurrentItemPtr^.Shops));
        For i := Low(Temp) to High(Temp) do
          begin
            Temp[i].ItemName := Format('[#%d] %s',[fCurrentItemPtr^.Index,fILManager.ItemTitleStr(fCurrentItemPtr^)]);
            Temp[i].ItemShopPtr := Addr(fCurrentItemPtr^.Shops[i]);
            Temp[i].ItemShopPtr^.RequiredCount := fCurrentItemPtr^.Count;
            Temp[i].Done := False;
          end;
        fUpdateForm.ShowUpdate(Temp);
        OldAvail := fCurrentItemPtr^.AvailablePieces;
        OldPrice := fCurrentItemPtr^.UnitPriceSelected;
        fILManager.ItemUpdatePriceAndAvail(fCurrentItemPtr^);
        fILManager.ItemFlagPriceAndAvail(fCurrentItemPtr^,OldAvail,OldPrice);
        LoadItem;
        DoListItemChange;
      end
    else MessageDlg('No shop to update.',mtInformation,[mbOK],0);
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.btnShopsClick(Sender: TObject);
var
  i:  Integer;
begin
If Assigned(fCurrentItemPtr) then
  begin
    SaveItem;
    For i := Low(fCurrentItemPtr^.Shops) to High(fCurrentItemPtr^.Shops) do
      fCurrentItemPtr^.Shops[i].RequiredCount := fCurrentItemPtr^.Count;
    fShopsForm.ShowShops(fCurrentItemPtr^);
    // flags are set in shops form
    LoadItem;
    DoListItemChange;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.pmnImagesMenuPopup(Sender: TObject);
begin
If Assigned(fCurrentItemPtr) and (pmnImagesMenu.PopupComponent is TImage) then
  begin
    mniIM_Export.Enabled := (TImage(pmnImagesMenu.PopupComponent).Tag and $F) <> 0;
    mniIM_Remove.Enabled := (TImage(pmnImagesMenu.PopupComponent).Tag and $F) <> 0;
    mniIM_RemoveMain.Enabled := Assigned(fCurrentItemPtr^.MainPicture);
    mniIM_RemovePackage.Enabled := Assigned(fCurrentItemPtr^.PackagePicture);
    mniIM_Switch.Enabled := Assigned(fCurrentItemPtr^.MainPicture) or Assigned(fCurrentItemPtr^.PackagePicture);
  end
else
  begin
    mniIM_Export.Enabled := False;
    mniIM_Remove.Enabled := False;
    mniIM_RemoveMain.Enabled := False;
    mniIM_RemovePackage.Enabled := False;
    mniIM_Switch.Enabled := False;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.mniIM_LoadClick(Sender: TObject);

  procedure BrowsePicture(const FileStr: String; var StoredBitmap: TBitmap);
  var
    Bitmap: TBitmap;
  begin
    diaImgOpenDialog.Title := Format('Select %s picture',[FileStr]);
    diaImgOpenDialog.Filter := 'BMP image files|*.bmp|All files|*.*';
    diaImgOpenDialog.FileName := '';
    diaImgOpenDialog.InitialDir := fLastSmallPicDir;
    Bitmap := nil;
    If diaImgOpenDialog.Execute then
    try
      fLastSmallPicDir := ExtractFileDir(diaImgOpenDialog.FileName);
      Bitmap := TBitmap.Create;
      Bitmap.LoadFromFile(diaImgOpenDialog.FileName);
      If Assigned(StoredBitmap) then
        begin
          If MessageDlg(Format('Replace current %s picture?',[FileStr]),mtConfirmation	,[mbYes,mbNo],0) = mrYes then
            begin
              FreeAndNil(StoredBitmap);
              StoredBitmap := Bitmap;
              ShowPictures;
              DoListItemChange;
            end
          else FreeAndNil(Bitmap);
        end
      else
        begin
          StoredBitmap := Bitmap;
          ShowPictures;
          DoListItemChange;
        end;
    except
      // supress error
      If Assigned(Bitmap) then
        FreeAndNil(Bitmap);
      MessageDlg('Error while loading the file.',mtError,[mbOK],0);
    end;
  end;

begin
If Assigned(fCurrentItemPtr) and (pmnImagesMenu.PopupComponent is TImage) then
  case TImage(pmnImagesMenu.PopupComponent).Tag and $0F of
    1:  BrowsePicture('main',fCurrentItemPtr^.MainPicture);
    2:  BrowsePicture('package',fCurrentItemPtr^.PackagePicture);
  else
    // prompt for what is missing, if both are then for main picture
    case (TImage(pmnImagesMenu.PopupComponent).Tag shr 4) and $0F of
      1:  BrowsePicture('package',fCurrentItemPtr^.PackagePicture);
      2:  BrowsePicture('main',fCurrentItemPtr^.MainPicture);
    else
      BrowsePicture('main',fCurrentItemPtr^.MainPicture);
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.mniIM_ExportClick(Sender: TObject);

  procedure ExportPicture(const FileStr: String; StoredBitmap: TBitmap);
  begin
    If Assigned(StoredBitmap) then
      begin
        diaImgExport.Title := Format('Export %s picture',[FileStr]);
        diaImgExport.FileName := '';
        If diaImgExport.Execute then
          StoredBitmap.SaveToFile(diaImgExport.FileName);
      end;
  end;

begin
If Assigned(fCurrentItemPtr) and (pmnImagesMenu.PopupComponent is TImage) then
  case TImage(pmnImagesMenu.PopupComponent).Tag and $0F of
    1:  ExportPicture('main',fCurrentItemPtr^.MainPicture);
    2:  ExportPicture('package',fCurrentItemPtr^.PackagePicture);
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.mniIM_RemoveClick(Sender: TObject);
begin
If Assigned(fCurrentItemPtr) and (pmnImagesMenu.PopupComponent is TImage) then
  If MessageDlg('Are you sure you want to remove this picture?',mtConfirmation,[mbYes,mbNo],0) = mrYes then
    begin
      case (TImage(pmnImagesMenu.PopupComponent).Tag and $F) of
        1:  FreeAndNil(fCurrentItemPtr^.MainPicture);
        2:  FreeAndNil(fCurrentItemPtr^.PackagePicture);
      end;
      ShowPictures;
      DoListItemChange;
    end;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.mniIM_RemoveMainClick(Sender: TObject);
begin
If Assigned(fCurrentItemPtr) then
  If MessageDlg('Are you sure you want to remove main picture?',mtConfirmation,[mbYes,mbNo],0) = mrYes then
    begin
      FreeAndNil(fCurrentItemPtr^.MainPicture);
      ShowPictures;
      DoListItemChange;
    end;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.mniIM_RemovePackageClick(Sender: TObject);
begin
If Assigned(fCurrentItemPtr) then
  If MessageDlg('Are you sure you want to remove package picture?',mtConfirmation,[mbYes,mbNo],0) = mrYes then
    begin
      FreeAndNil(fCurrentItemPtr^.PackagePicture);
      ShowPictures;
    end;
end;

//------------------------------------------------------------------------------

procedure TfrmItemFrame.mniIM_SwitchClick(Sender: TObject);
var
  Temp: TBitmap;
begin
If Assigned(fCurrentItemPtr) then
  begin
    Temp := fCurrentItemPtr^.MainPicture;
    fCurrentItemPtr^.MainPicture := fCurrentItemPtr^.PackagePicture;
    fCurrentItemPtr^.PackagePicture := Temp;
    ShowPictures;
    DoListItemChange;
  end;
end;

end.
