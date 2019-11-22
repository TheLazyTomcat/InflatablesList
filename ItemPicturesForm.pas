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
    grbPicture: TGroupBox;
    cbItemPicture: TCheckBox;
    cbPackagePicture: TCheckBox;
    btnLoadThumbnail: TButton;
    btnExportPicture: TButton;
    btnExportThumbnail: TButton;
    pmnPictures: TPopupMenu;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    fILManager:   TILManager;
    fCurrentItem: TILItem;
    fDrawBuffer:  TBitmap;       
  protected

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

procedure TfItemPicturesForm.Initialize(ILManager: TILManager);
begin
fILManager := ILManager;
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
    ShowModal;
  end;
end;

//==============================================================================

procedure TfItemPicturesForm.FormCreate(Sender: TObject);
begin
fDrawBuffer := TBitmap.Create;
fDrawBuffer.PixelFormat := pf24bit;
fDrawBuffer.Canvas.Font.Assign(lbPictures.Font);
end;

//------------------------------------------------------------------------------

procedure TfItemPicturesForm.FormShow(Sender: TObject);
begin
//
end;

//------------------------------------------------------------------------------

procedure TfItemPicturesForm.FormDestroy(Sender: TObject);
begin
FreeAndNil(fDrawBuffer);
end;

end.
