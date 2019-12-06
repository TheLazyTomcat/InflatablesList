unit ItemPicturesForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Menus,
  InflatablesList_Item,
  InflatablesList_Manager;  

type
  TfItemPicturesForm = class(TForm)
    lbPictures: TListBox;
    lblPictures: TLabel;
    pmnPictures: TPopupMenu;
    mniIP_Add: TMenuItem;
    mniIP_LoadThumb: TMenuItem;
    mniIP_AddWithThumb: TMenuItem;
    mniIP_Remove: TMenuItem;
    mniIP_RemoveAll: TMenuItem;
    N1: TMenuItem;
    mniIP_ExportPic: TMenuItem;
    mniIP_ExportThumb: TMenuItem;
    mniIP_ExportPicAll: TMenuItem;
    mniIP_ExportThumbAll: TMenuItem;
    N2: TMenuItem;
    mniIP_ItemPicture: TMenuItem;
    mniIP_PackagePicture: TMenuItem;
    N3: TMenuItem;
    mniIP_MoveUp: TMenuItem;
    mniIP_MoveDown: TMenuItem;
    diaOpenDialog: TOpenDialog;
    diaSaveDialog: TSaveDialog;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lbPicturesClick(Sender: TObject);
    procedure lbPicturesDblClick(Sender: TObject);
    procedure lbPicturesMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lbPicturesDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure pmnPicturesPopup(Sender: TObject);
    procedure mniIP_AddClick(Sender: TObject);
    procedure mniIP_LoadThumbClick(Sender: TObject);
    procedure mniIP_AddWithThumbClick(Sender: TObject);
    procedure mniIP_RemoveClick(Sender: TObject);
    procedure mniIP_RemoveAllClick(Sender: TObject);
    procedure mniIP_ExportPicClick(Sender: TObject);
    procedure mniIP_ExportThumbClick(Sender: TObject);
    procedure mniIP_ExportPicAllClick(Sender: TObject);
    procedure mniIP_ExportThumbAllClick(Sender: TObject);
    procedure mniIP_ItemPictureClick(Sender: TObject);
    procedure mniIP_PackagePictureClick(Sender: TObject);
    procedure mniIP_MoveUpClick(Sender: TObject);
    procedure mniIP_MoveDownClick(Sender: TObject);
  private
    { Private declarations }
    fILManager:     TILManager;
    fCurrentItem:   TILItem;
    fDrawBuffer:    TBitmap;
    fDirPics:       String;
    fDirThumbs:     String;
    fDirExport:     String;
  protected
    procedure FillList;
    procedure UpdateIndex;
  public
    { Public declarations }
    procedure Initialize(ILManager: TILManager);
    procedure Finalize;
    procedure ShowPictures(Item: TILItem);
  end;

var
  fItemPicturesForm: TfItemPicturesForm;

implementation

{$R *.dfm}

uses
  WinFileInfo, StrRect,
  InflatablesList_Utils,
  InflatablesList_ItemPictures_Base;

procedure TfItemPicturesForm.FillList;
var
  i:  Integer;
begin
If Assigned(fCurrentItem) then
  begin
    lbPictures.Items.BeginUpdate;
    try
      // adjust count
      If lbPictures.Count < fCurrentItem.Pictures.Count then
        For i := lbPictures.Count to Pred(fCurrentItem.Pictures.Count) do
          lbPictures.Items.Add('')
      else If lbPictures.Count > fCurrentItem.Pictures.Count then
        For i := lbPictures.Count downto Pred(fCurrentItem.Pictures.Count) do
          lbPictures.Items.Delete(i);
      // fill
      For i := fCurrentItem.Pictures.LowIndex to fCurrentItem.Pictures.HighIndex do
        lbPictures.Items[i] := fCurrentItem.Pictures[i].PictureFile;
    finally
      lbPictures.Items.EndUpdate;
    end;
  end
else lbPictures.Clear;
end;

//------------------------------------------------------------------------------

procedure TfItemPicturesForm.UpdateIndex;
begin
If Assigned(fCurrentItem) then
  begin
    If lbPictures.ItemIndex >= 0 then
      lblPictures.Caption := IL_Format('Pictures (%d/%d):',[lbPictures.ItemIndex + 1,fCurrentItem.Pictures.Count])
    else
      lblPictures.Caption := IL_Format('Pictures (%d):',[fCurrentItem.Pictures.Count]);
  end
else lblPictures.Caption := 'Pictures:';
end;

//==============================================================================

procedure TfItemPicturesForm.Initialize(ILManager: TILManager);
begin
fILManager := ILManager;
fDirPics := IL_ExcludeTrailingPathDelimiter(fILManager.StaticSettings.DefaultPath);
fDirThumbs := fDirPics;
fDirExport := fDirPics;
end;

//------------------------------------------------------------------------------

procedure TfItemPicturesForm.Finalize;
begin
// nothing to do
end;

//------------------------------------------------------------------------------

procedure TfItemPicturesForm.ShowPictures(Item: TILItem);
begin
If Assigned(Item) then
  begin
    fCurrentItem := Item;
    Caption := IL_Format('%s - pictures',[fCurrentItem.TitleStr]);
    FillList;
    If lbPictures.Count > 0 then
      lbPictures.ItemIndex := 0;
    lbPictures.OnClick(nil);
    ShowModal;
  end;
end;

//==============================================================================

procedure TfItemPicturesForm.FormCreate(Sender: TObject);
begin
fDrawBuffer := TBitmap.Create;
fDrawBuffer.PixelFormat := pf24bit;
fDrawBuffer.Canvas.Font.Assign(lbPictures.Font);
lbPictures.DoubleBuffered := True;
// shortcuts for popup menu
mniIP_ExportThumb.ShortCut := ShortCut(Ord('E'),[ssCtrl,ssShift]);
mniIP_MoveUp.ShortCut := ShortCut(VK_UP,[ssShift]);
mniIP_MoveDown.ShortCut := ShortCut(VK_DOWN,[ssShift]);
end;

//------------------------------------------------------------------------------

procedure TfItemPicturesForm.FormShow(Sender: TObject);
begin
lbPictures.SetFocus;
end;

//------------------------------------------------------------------------------

procedure TfItemPicturesForm.FormDestroy(Sender: TObject);
begin
FreeAndNil(fDrawBuffer);
end;

//------------------------------------------------------------------------------

procedure TfItemPicturesForm.lbPicturesClick(Sender: TObject);
begin
UpdateIndex;
end;

//------------------------------------------------------------------------------

procedure TfItemPicturesForm.lbPicturesDblClick(Sender: TObject);
begin
If fCurrentItem.Pictures.CheckIndex(lbPictures.ItemIndex) then
  fCurrentItem.Pictures.OpenPictureFile(lbPictures.ItemIndex);
end;

//------------------------------------------------------------------------------

procedure TfItemPicturesForm.lbPicturesMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Index:  Integer;
begin
If Button = mbRight then
  begin
    Index := lbPictures.ItemAtPos(Point(X,Y),True);
    If Index >= 0 then
      lbPictures.ItemIndex := Index
    else
      lbPictures.ItemIndex := -1;
    lbPictures.OnClick(nil);
  end;
end;

//------------------------------------------------------------------------------

procedure TfItemPicturesForm.lbPicturesDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  BoundsRect: TRect;
  TempInt:    Integer;
  TempStr:    String;
begin
If Assigned(fDrawBuffer) then
  begin
    // adjust draw buffer size
    If fDrawBuffer.Width < (Rect.Right - Rect.Left) then
      fDrawBuffer.Width := Rect.Right - Rect.Left;
    If fDrawBuffer.Height < (Rect.Bottom - Rect.Top) then
      fDrawBuffer.Height := Rect.Bottom - Rect.Top;
    BoundsRect := Classes.Rect(0,0,Rect.Right - Rect.Left,Rect.Bottom - Rect.Top);

    with fDrawBuffer.Canvas do
      begin
        // background
        Pen.Style := psClear;
        Brush.Style := bsSolid;
        Brush.Color := clWindow;
        Rectangle(BoundsRect.Left,BoundsRect.Top,BoundsRect.Right + 1,BoundsRect.Bottom);
        // side strip
        Brush.Color := $00F7F7F7;
        Rectangle(BoundsRect.Left,BoundsRect.Top,BoundsRect.Left + 10,BoundsRect.Bottom);
        // separator line
        Pen.Style := psSolid;
        Pen.Color := clSilver;
        MoveTo(BoundsRect.Left,BoundsRect.Bottom - 1);
        LineTo(BoundsRect.Right,BoundsRect.Bottom - 1);

        // text
        Brush.Style := bsClear;
        Font.Style := [fsBold];
        TextOut(12,3,fCurrentItem.Pictures[Index].PictureFile);

        // icons
        TempInt := 12;
        Pen.Style := psSolid;
        Brush.Style := bsSolid;
        If fCurrentItem.Pictures.CurrentSecondary = Index then
          begin
            Pen.Color := $00FFAC22;
            Brush.Color := $00FFBF55;
            Polygon([Point(TempInt,20),Point(TempInt,31),Point(TempInt + 11,26)]);
            Inc(TempInt,14);
          end;
        If fCurrentItem.Pictures[Index].ItemPicture then
          begin
            Pen.Color := $0000E700;
            Brush.Color := clLime;
            Ellipse(TempInt,20,TempInt + 11,31);
            Inc(TempInt,14);
          end;
        If fCurrentItem.Pictures[Index].PackagePicture then
          begin
            Pen.Color := $0000D3D9;
            Brush.Color := $002BFAFF;
            Rectangle(TempInt,20,TempInt + 11,31);
          end;

        // thumbnail
        TempInt := BoundsRect.Right - fILManager.DataProvider.EmptyPictureMini.Width - 5;
        If Assigned(fCurrentItem.Pictures[Index].ThumbnailMini) and not fILManager.StaticSettings.NoPictures then
          Draw(TempInt,BoundsRect.Top + 1,fCurrentItem.Pictures[Index].ThumbnailMini)
        else
          Draw(TempInt,BoundsRect.Top + 1,fILManager.DataProvider.EmptyPictureMini);
        Dec(TempInt,7);

        // size (bytes) and resolution
        Font.Style := Font.Style - [fsBold];
        Brush.Style := bsClear;
        TempStr := SizeToStr(fCurrentItem.Pictures[Index].PictureSize);
        TextOut(TempInt - TextWidth(TempStr),2,TempStr);
        If (fCurrentItem.Pictures[Index].PictureWidth > 0) and (fCurrentItem.Pictures[Index].PictureHeight > 0) then
          begin
            TempStr := IL_Format('%d x %d px',[fCurrentItem.Pictures[Index].PictureWidth,fCurrentItem.Pictures[Index].PictureHeight]);
            TextOut(TempInt - TextWidth(TempStr),17,TempStr);
          end;

        // state
        If odSelected in State then
          begin
            Pen.Style := psClear;
            Brush.Style := bsSolid;
            Brush.Color := clLime;
            Rectangle(BoundsRect.Left,BoundsRect.Top,BoundsRect.Left + 10,BoundsRect.Bottom);
          end;
      end;

    // move drawbuffer to the canvas
    lbPictures.Canvas.CopyRect(Rect,fDrawBuffer.Canvas,BoundsRect);
    // disable focus rect
    If odFocused in State then
      lbPictures.Canvas.DrawFocusRect(Rect);
  end;
end;

//------------------------------------------------------------------------------

procedure TfItemPicturesForm.pmnPicturesPopup(Sender: TObject);
begin
mniIP_LoadThumb.Enabled := lbPictures.ItemIndex >= 0;
mniIP_Remove.Enabled := lbPictures.ItemIndex >= 0;
mniIP_RemoveAll.Enabled := lbPictures.Count > 0;
mniIP_ExportPic.Enabled := lbPictures.ItemIndex >= 0;
mniIP_ExportThumb.Enabled := lbPictures.ItemIndex >= 0;
mniIP_ExportPicAll.Enabled := lbPictures.Count > 0;
mniIP_ExportThumbAll.Enabled := lbPictures.Count > 0;
If Assigned(fCurrentItem) and (lbPictures.ItemIndex >= 0) then
  begin
    mniIP_ItemPicture.Enabled := True;
    mniIP_ItemPicture.Checked := fCurrentItem.Pictures[lbPictures.ItemIndex].ItemPicture;
    mniIP_PackagePicture.Enabled := True;
    mniIP_PackagePicture.Checked := fCurrentItem.Pictures[lbPictures.ItemIndex].PackagePicture;
  end
else
  begin
    mniIP_ItemPicture.Enabled := False;
    mniIP_ItemPicture.Checked := False;
    mniIP_PackagePicture.Enabled := False;
    mniIP_PackagePicture.Checked := False;
  end;
mniIP_MoveUp.Enabled := lbPictures.ItemIndex > 0;
mniIP_MoveDown.Enabled := (lbPictures.Count > 0) and ((lbPictures.ItemIndex >= 0) and (lbPictures.ItemIndex < Pred(lbPictures.Count)));
end;

//------------------------------------------------------------------------------

procedure TfItemPicturesForm.mniIP_AddClick(Sender: TObject);
var
  i:    Integer;
  Info: TILPictureAutomationInfo;
  Cntr: Integer;
begin
diaOpenDialog.Filter := 'JPEG/JFIF image (*.jpg;*jpeg)|*.jpg;*.jpeg|All files (*.*)|*.*';
diaOpenDialog.InitialDir := fDirPics;
diaOpenDialog.FileName := '';
diaOpenDialog.Title := 'Add pictures';
diaOpenDialog.Options := diaOpenDialog.Options + [ofAllowMultiselect];
If diaOpenDialog.Execute then
  begin
    If diaOpenDialog.Files.Count > 0 then
      fDirPics := IL_ExtractFileDir(diaOpenDialog.Files[Pred(diaOpenDialog.Files.Count)]);
    Cntr := 0;
    fCurrentItem.Pictures.BeginUpdate;
    try
      Screen.Cursor := crHourGlass;
      try
        For i := 0 to Pred(diaOpenDialog.Files.Count) do
          If fCurrentItem.Pictures.AutomatePictureFile(diaOpenDialog.Files[i],Info) then
            begin
              fCurrentItem.Pictures.Add(Info);
              Inc(Cntr);
            end;
      finally
        Screen.Cursor := crDefault;
      end;
    finally
      fCurrentItem.Pictures.EndUpdate;
    end;
    FillList;
    If Cntr > 0 then
      begin
        lbPictures.ItemIndex := Pred(lbPictures.Count);
        lbPictures.OnClick(nil);  // updates index  
      end
    else UpdateIndex;
  end;
end;

//------------------------------------------------------------------------------

procedure TfItemPicturesForm.mniIP_AddWithThumbClick(Sender: TObject);
var
  Info:         TILPictureAutomationInfo;
  PicFileName:  String;
  Index:        Integer;
  Thumbnail:    TBitmap;
begin
diaOpenDialog.Filter := 'JPEG/JFIF image (*.jpg;*jpeg)|*.jpg;*.jpeg|All files (*.*)|*.*';
diaOpenDialog.InitialDir := fDirPics;
diaOpenDialog.FileName := '';
diaOpenDialog.Title := 'Add picture';
diaOpenDialog.Options := diaOpenDialog.Options - [ofAllowMultiselect];
If diaOpenDialog.Execute then
  begin
    fDirPics := IL_ExtractFileDir(diaOpenDialog.FileName);
    PicFileName := diaOpenDialog.FileName;
    // now for thumbnail...
    diaOpenDialog.Filter := 'Windows bitmap image (*.bmp)|*.bmp|All files (*.*)|*.*';
    diaOpenDialog.InitialDir := fDirThumbs;
    diaOpenDialog.FileName := '';
    diaOpenDialog.Title := 'Select thumbnail for the picture';
    If diaOpenDialog.Execute then
      begin
        fDirThumbs := IL_ExtractFileDir(diaOpenDialog.FileName);      
        If fCurrentItem.Pictures.AutomatePictureFile(PicFileName,Info) then
          begin
            Thumbnail := TBitmap.Create;
            try
              Thumbnail.LoadFromFile(StrToRTL(diaOpenDialog.FileName));
              If (Thumbnail.Width = 96) and (Thumbnail.Height = 96) and (Thumbnail.PixelFormat = pf24bit) then
                begin
                  fCurrentItem.Pictures.BeginUpdate;
                  try
                    Index := fCurrentItem.Pictures.Add(Info);
                    fCurrentItem.Pictures.SetThumbnail(Index,Thumbnail,True);
                  finally
                    fCurrentItem.Pictures.EndUpdate;
                  end;
                  FillList;
                  lbPictures.ItemIndex := Pred(lbPictures.Count);
                  lbPictures.OnClick(nil);  // also updates index
                end
              else MessageDlg('Invalid format of the thumbnail.',mtError,[mbOK],0);
            finally
              Thumbnail.Free;
            end;
          end;
      end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfItemPicturesForm.mniIP_LoadThumbClick(Sender: TObject);
var
  Thumbnail:  TBitmap;
begin
If lbPictures.ItemIndex >= 0 then
  begin
    diaOpenDialog.Filter := 'Windows bitmap image (*.bmp)|*.bmp|All files (*.*)|*.*';
    diaOpenDialog.InitialDir := fDirThumbs;
    diaOpenDialog.FileName := '';
    diaOpenDialog.Title := 'Select thumbnail';
    diaOpenDialog.Options := diaOpenDialog.Options - [ofAllowMultiselect];
    If diaOpenDialog.Execute then
      begin
        fDirThumbs := IL_ExtractFileDir(diaOpenDialog.FileName);
        Thumbnail := TBitmap.Create;
        try
          Thumbnail.LoadFromFile(StrToRTL(diaOpenDialog.FileName));
          If (Thumbnail.Width = 96) and (Thumbnail.Height = 96) and (Thumbnail.PixelFormat = pf24bit) then
            begin
              fCurrentItem.Pictures.SetThumbnail(lbPictures.ItemIndex,Thumbnail,True);
              FillList;
            end
          else MessageDlg('Invalid format of the thumbnail.',mtError,[mbOK],0);
        finally
          Thumbnail.Free;
        end;
      end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfItemPicturesForm.mniIP_RemoveClick(Sender: TObject);
var
  Index:  Integer;
begin
If lbPictures.ItemIndex >= 0 then
  If MessageDlg('Are you sure you want to remove the following picture?' + sLineBreak +
                sLineBreak +
                fCurrentItem.Pictures[lbPictures.ItemIndex].PictureFile,
                mtConfirmation,[mbYes,mbNo],0) = mrYes then
    begin
      Index := lbPictures.ItemIndex;
      fCurrentItem.Pictures.Delete(lbPictures.ItemIndex);
      lbPictures.Items.Delete(lbPictures.ItemIndex);
      If lbPictures.Count > 0 then
        begin
          If Index < lbPictures.Count then
            lbPictures.ItemIndex := Index
          else
            lbPictures.ItemIndex := Pred(lbPictures.Count);
        end
      else lbPictures.ItemIndex := -1;
      lbPictures.OnClick(nil);
    end;
end;

//------------------------------------------------------------------------------

procedure TfItemPicturesForm.mniIP_RemoveAllClick(Sender: TObject);
begin
If lbPictures.Count > 0 then
  If MessageDlg('Are you sure you want to remove all pictures?',mtConfirmation,[mbYes,mbNo],0) = mrYes then
    begin
      lbPictures.ItemIndex := -1;
      fCurrentItem.Pictures.Clear;
      lbPictures.Items.Clear;
      lbPictures.OnClick(nil);
    end;
end;

//------------------------------------------------------------------------------

procedure TfItemPicturesForm.mniIP_ExportPicClick(Sender: TObject);
var
  Directory:  String;
begin
If lbPictures.ItemIndex >= 0 then
  begin
    Directory := fDirExport;
    If IL_SelectDirectory('Select directory for picture export',Directory) then
      begin
        fDirExport := IL_ExcludeTrailingPAthDelimiter(Directory);
        If fCurrentItem.Pictures.ExportPicture(lbPictures.ItemIndex,IL_ExcludeTrailingPathDelimiter(Directory)) then
          MessageDlg('Picture successfully exported.',mtInformation,[mbOK],0)
        else
          MessageDlg('Picture export has failed.',mtError,[mbOK],0)
      end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfItemPicturesForm.mniIP_ExportThumbClick(Sender: TObject);
var
  Directory:  String;
begin
If lbPictures.ItemIndex >= 0 then
  If Assigned(fCurrentItem.Pictures[lbPictures.ItemIndex].Thumbnail) then
    begin
      Directory := fDirExport;
      If IL_SelectDirectory('Select directory for thumbnail export',Directory) then
        begin
          fDirExport := IL_ExcludeTrailingPAthDelimiter(Directory);
          If fCurrentItem.Pictures.ExportThumbnail(lbPictures.ItemIndex,IL_ExcludeTrailingPathDelimiter(Directory)) then
            MessageDlg('Picture thumbnail successfully exported.',mtInformation,[mbOK],0)
          else
            MessageDlg('Picture thumbnail export has failed.',mtError,[mbOK],0)
        end;
    end
  else MessageDlg('No thumbnail is assigned to this picture.',mtInformation,[mbOK],0)
end;

//------------------------------------------------------------------------------

procedure TfItemPicturesForm.mniIP_ExportPicAllClick(Sender: TObject);
var
  Directory:  String;
  i,Cntr:     Integer;
begin
If lbPictures.ItemIndex >= 0 then
  begin
    Directory := fDirExport;
    If IL_SelectDirectory('Select directory for pictures export',Directory) then
      begin
        fDirExport := IL_ExcludeTrailingPAthDelimiter(Directory);
        Cntr := 0;
        Screen.Cursor := crHourGlass;
        try
          For i := fCurrentItem.Pictures.LowIndex to fCurrentItem.Pictures.HighIndex do
            If fCurrentItem.Pictures.ExportPicture(i,IL_ExcludeTrailingPathDelimiter(Directory)) then
               Inc(Cntr);
        finally
          Screen.Cursor := crDefault;
        end;
        MessageDlg(IL_Format('%d pictures successfully exported, %d failed.',
          [Cntr,fCurrentItem.Pictures.Count - Cntr]),mtInformation,[mbOK],0);
      end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfItemPicturesForm.mniIP_ExportThumbAllClick(Sender: TObject);
var
  Directory:  String;
  i,Cntr:     Integer;
begin
If lbPictures.ItemIndex >= 0 then
  begin
    Directory := fDirExport;
    If IL_SelectDirectory('Select directory for thumbnails export',Directory) then
      begin
        fDirExport := IL_ExcludeTrailingPAthDelimiter(Directory);
        Cntr := 0;
        Screen.Cursor := crHourGlass;
        try
          For i := fCurrentItem.Pictures.LowIndex to fCurrentItem.Pictures.HighIndex do
            If fCurrentItem.Pictures.ExportThumbnail(i,IL_ExcludeTrailingPathDelimiter(Directory)) then
               Inc(Cntr);
        finally
          Screen.Cursor := crDefault;
        end;
        MessageDlg(IL_Format('%d picture thumbnails successfully exported, %d failed.',
          [Cntr,fCurrentItem.Pictures.Count - Cntr]),mtInformation,[mbOK],0);
      end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfItemPicturesForm.mniIP_ItemPictureClick(Sender: TObject);
begin
If mniIP_ItemPicture.Enabled then
  begin
    fCurrentItem.Pictures.SetItemPicture(lbPictures.ItemIndex,not mniIP_ItemPicture.Checked);
    mniIP_ItemPicture.Checked := not mniIP_ItemPicture.Checked;
    lbPictures.Invalidate;
  end;
end;

//------------------------------------------------------------------------------

procedure TfItemPicturesForm.mniIP_PackagePictureClick(Sender: TObject);
begin
If mniIP_PackagePicture.Enabled then
  begin
    fCurrentItem.Pictures.SetPackagePicture(lbPictures.ItemIndex,not mniIP_PackagePicture.Checked);
    mniIP_PackagePicture.Checked := not mniIP_PackagePicture.Checked;
    lbPictures.Invalidate;
  end;
end;

//------------------------------------------------------------------------------

procedure TfItemPicturesForm.mniIP_MoveUpClick(Sender: TObject);
var
  Index:  Integer;
begin
If lbPictures.ItemIndex > 0 then
  begin
    Index := lbPictures.ItemIndex;
    lbPictures.Items.Exchange(Index,Index - 1);
    fCurrentItem.Pictures.Exchange(Index,Index - 1);
    lbPictures.ItemIndex := Index - 1;
    lbPictures.Invalidate;
    UpdateIndex;
  end;
end;

//------------------------------------------------------------------------------

procedure TfItemPicturesForm.mniIP_MoveDownClick(Sender: TObject);
var
  Index:  Integer;
begin
If (lbPictures.Count > 0) and ((lbPictures.ItemIndex >= 0) and (lbPictures.ItemIndex < Pred(lbPictures.Count))) then
  begin
    Index := lbPictures.ItemIndex;
    lbPictures.Items.Exchange(Index,Index + 1);
    fCurrentItem.Pictures.Exchange(Index,Index + 1);
    lbPictures.ItemIndex := Index + 1;
    lbPictures.Invalidate;
    UpdateIndex;
  end;
end;

end.
