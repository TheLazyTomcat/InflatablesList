unit ShopByItemsForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, CheckLst,
  InflatablesList_Item,
  InflatablesList_Manager;

type
  TfShopByItems = class(TForm)
    clbItems: TCheckListBox;
    lvShops: TListView;
    lblItems: TLabel;
    lblShops: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure clbItemsClick(Sender: TObject);
    procedure clbItemsDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure clbItemsClickCheck(Sender: TObject);
  private
    { Private declarations }
    fDrawBuffer:  TBitmap;
    fILManager:   TILManager;
    procedure BuildTable;
    procedure RecountShops;
    procedure FillItems;
    procedure FillShops;
  public
    { Public declarations }
    procedure Initialize(ILManager: TILManager);
    procedure Finalize;
    procedure ShowSelection;
  end;

var
  fShopByItems: TfShopByItems;

implementation

{$R *.dfm}

procedure TfShopByItems.BuildTable;
begin
end;

//------------------------------------------------------------------------------

procedure TfShopByItems.RecountShops;
begin
end;

//------------------------------------------------------------------------------

procedure TfShopByItems.FillItems;
var
  i:  Integer;
begin
clbItems.Items.BeginUpdate;
try
  clbItems.Clear;
  For i := fILManager.ItemLowIndex to fILManager.ItemHighIndex do
    clbItems.Items.Add(fILManager[i].TitleStr);
  For i := 0 to Pred(clbItems.Count) do
    clbItems.Checked[i] := False;
finally
  clbItems.Items.EndUpdate;
end;
end;

//------------------------------------------------------------------------------

procedure TfShopByItems.FillShops;
begin
end;

//==============================================================================

procedure TfShopByItems.Initialize(ILManager: TILManager);
begin
fILManager := ILManager;
end;

//------------------------------------------------------------------------------

procedure TfShopByItems.Finalize;
begin
// nothing to do
end;

//------------------------------------------------------------------------------

procedure TfShopByItems.ShowSelection;
begin
BuildTable;
FillItems;
RecountShops;
FillShops;
ShowModal;
end;

//==============================================================================

procedure TfShopByItems.FormCreate(Sender: TObject);
begin
fDrawBuffer := TBitmap.Create;
fDrawBuffer.PixelFormat := pf24bit;
clbItems.DoubleBuffered := True;
lvShops.DoubleBuffered := True;
end;

//------------------------------------------------------------------------------

procedure TfShopByItems.FormDestroy(Sender: TObject);
begin
FreeAndNil(fDrawBuffer);
end;

//------------------------------------------------------------------------------

procedure TfShopByItems.clbItemsClick(Sender: TObject);
begin
//
end;

//------------------------------------------------------------------------------

procedure TfShopByItems.clbItemsDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
//
end;

//------------------------------------------------------------------------------

procedure TfShopByItems.clbItemsClickCheck(Sender: TObject);
begin
RecountShops;
FillShops;
end;

end.
