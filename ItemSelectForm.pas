unit ItemSelectForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,
  InflatablesList_Manager;

type
  TfItemSelectForm = class(TForm)
    lblItems: TLabel;
    lbItems: TListBox;
    btnAccept: TButton;
    btnCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);    
    procedure lbItemsClick(Sender: TObject);
    procedure lbItemsDblClick(Sender: TObject);
    procedure lbItemsDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure btnAcceptClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
    fDrawBuffer:  TBitmap;
    fILManager:   TILManager;
    fAccepted:    Boolean;
  protected
    procedure FillList;
    procedure UpdateIndex;
  public
    { Public declarations }
    procedure Initialize(ILManager: TILManager);
    procedure Finalize;
    Function ShowItemSelect(const Title: String): Integer;
  end;

var
  fItemSelectForm: TfItemSelectForm;

implementation

{$R *.dfm}

uses
  InflatablesList_Utils,
  InflatablesList_Item;

procedure TfItemSelectForm.FillList;
var
  i:  Integer;
begin
//don't forget fDataAccessible
lbItems.Items.BeginUpdate;
try
  lbItems.Items.Clear;
  For i := fILManager.ItemLowIndex to fILManager.ItemHighIndex do
    If fILManager[i].DataAccessible then
      lbItems.AddItem(fILManager[i].TitleStr,fILManager[i]);
finally
  lbItems.Items.EndUpdate;
end;
If lbItems.Count > 0 then
  lbItems.ItemIndex := 0;
lbItems.OnClick(nil);
end;

//------------------------------------------------------------------------------

procedure TfItemSelectForm.UpdateIndex;
begin
If lbItems.Count > 0 then
  begin
    If lbItems.ItemIndex >= 0 then
      lblItems.Caption := IL_Format('Items (%d/%d):',[lbItems.ItemIndex + 1,lbItems.Count])    
    else
      lblItems.Caption := IL_Format('Items (%d):',[lbItems.Count]);
  end
else lblItems.Caption := 'Items:';
end;

//==============================================================================

procedure TfItemSelectForm.Initialize(ILManager: TILManager);
begin
fILManager := ILManager;
end;

//------------------------------------------------------------------------------

procedure TfItemSelectForm.Finalize;
begin
// nothing to do here
end;

//------------------------------------------------------------------------------

Function TfItemSelectForm.ShowItemSelect(const Title: String): Integer;
var
  i:  Integer;
begin
Caption := Title;
FillList;
fAccepted := False;
// reinit renders
For i := 0 to Pred(lbItems.Count) do
  with TILItem(lbItems.Items.Objects[i]) do
    begin
      BeginUpdate;
      try
        ReinitSmallDrawSize(lbItems.ClientWidth,lbItems.ItemHeight,lbItems.Font);
        ChangeSmallStripSize(-1);
      finally
        EndUpdate;
      end;
    end;
ShowModal;
If fAccepted then
  Result := TILItem(lbItems.Items.Objects[lbItems.ItemIndex]).Index
else
  Result := -1;
end;

//==============================================================================

procedure TfItemSelectForm.FormCreate(Sender: TObject);
begin
fDrawBuffer := TBitmap.Create;
fDrawBuffer.PixelFormat := pf24bit;
fDrawBuffer.Canvas.Font.Assign(lbItems.Font);
lbItems.DoubleBuffered := True;
end;

//------------------------------------------------------------------------------

procedure TfItemSelectForm.FormDestroy(Sender: TObject);
begin
FreeAndNil(fDrawBuffer);
end;

//------------------------------------------------------------------------------

procedure TfItemSelectForm.lbItemsClick(Sender: TObject);
begin
UpdateIndex;
end;

//------------------------------------------------------------------------------

procedure TfItemSelectForm.lbItemsDblClick(Sender: TObject);
begin
UpdateIndex;
If lbItems.ItemIndex >= 0 then
  btnAccept.OnClick(nil);
end;

//------------------------------------------------------------------------------

procedure TfItemSelectForm.lbItemsDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  BoundsRect: TRect;
  TempItem:   TILItem;
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
        TempItem := TILItem(lbItems.Items.Objects[Index]);

        // content
        Draw(BoundsRect.Left,BoundsRect.Top,TempItem.RenderSmall);

        // separator line
        Pen.Style := psSolid;
        Pen.Color := clSilver;
        MoveTo(BoundsRect.Left,Pred(BoundsRect.Bottom));
        LineTo(BoundsRect.Right,Pred(BoundsRect.Bottom));

        // marker
        Pen.Style := psClear;
        Brush.Style := bsSolid;
        Brush.Color := $00F7F7F7;
        Rectangle(BoundsRect.Left,BoundsRect.Top,BoundsRect.Left +
          TempItem.SmallStrip,BoundsRect.Bottom);

        // indicate pictures by glyphs
        TempInt := fDrawBuffer.Width - 61;
        Pen.Style := psSolid;
        If TempItem.Pictures.SecondaryCount(False) > 0 then
          begin
            Dec(TempInt,14);
            Pen.Color := $00FFAC22;
            Brush.Style := bsSolid;            
            Brush.Color := $00FFBF55;
            Polygon([Point(TempInt,5),Point(TempInt,16),Point(TempInt + 11,11)]);          
            If TempItem.Pictures.SecondaryCount(False) > 1 then
              begin
                Font.Size := 8;
                Font.Style := [fsBold];
                Brush.Style := bsClear;
                TempStr := IL_Format('%dx',[TempItem.Pictures.SecondaryCount(False)]);
                Dec(TempInt,TextWidth(TempStr) + 3);
                TextOut(TempInt,4,TempStr);
              end;
          end;
        If TempItem.Pictures.CheckIndex(TempItem.Pictures.IndexOfPackagePicture) then
          begin
            Dec(TempInt,14);
            Pen.Color := $0000D3D9;
            Brush.Style := bsSolid;
            Brush.Color := $002BFAFF;
            Rectangle(TempInt,5,TempInt + 11,16);
          end;
        If TempItem.Pictures.CheckIndex(TempItem.Pictures.IndexOfItemPicture) then
          begin
            Dec(TempInt,14);          
            Pen.Color := $0000E700;
            Brush.Style := bsSolid;
            Brush.Color := clLime;
            Ellipse(TempInt,5,TempInt + 11,16);
          end;

        // states
        If odSelected	in State then
          begin
            Pen.Style := psClear;
            Brush.Style := bsSolid;
            Brush.Color := clLime;
            Rectangle(BoundsRect.Left,BoundsRect.Top,BoundsRect.Left + 11,BoundsRect.Bottom);
          end;        
      end;

    // move drawbuffer to the canvas
    lbItems.Canvas.CopyRect(Rect,fDrawBuffer.Canvas,BoundsRect);
    // disable focus rectangle
    If odFocused in State then
      lbItems.Canvas.DrawFocusRect(Rect);
  end;
end;
 
//------------------------------------------------------------------------------

procedure TfItemSelectForm.btnAcceptClick(Sender: TObject);
begin
fAccepted := True;
Close;
end;
 
//------------------------------------------------------------------------------

procedure TfItemSelectForm.btnCancelClick(Sender: TObject);
begin
fAccepted := False;
Close;
end;


end.
