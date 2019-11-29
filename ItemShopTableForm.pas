unit ItemShopTableForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids,
  CountedDynArrayString,
  InflatablesList_Manager;

type
  TfItemShopTableForm = class(TForm)
    dgTable: TDrawGrid;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    fDrawBuffer:  TBitmap;
    fILManager:   TILManager;
    fKnownShops:  TCountedDynArrayString;
    procedure EnumShops;
    procedure FillTable;
  public
    { Public declarations }
    procedure Initialize(ILManager: TILManager);
    procedure Finalize;
    procedure ShowTable;    
  end;

var
  fItemShopTableForm: TfItemShopTableForm;

implementation

{$R *.dfm}

procedure TfItemShopTableForm.EnumShops;
var
  i,j:  Integer;
begin
// enumerate shops
CDA_Clear(fKnownShops);
For i := fILManager.ItemLowIndex to fILManager.ItemHighIndex do
  If fILManager[i].DataAccessible then
    For j := fILManager[i].ShopLowIndex to fILManager[i].ShopHighIndex do
      If not CDA_CheckIndex(fKnownShops,CDA_IndexOf(fKnownShops,fILManager[i][j].Name)) then
        CDA_Add(fKnownShops,fILManager[i][j].Name);
// sort the shop list
CDA_Sort(fKnownShops);
end;

//------------------------------------------------------------------------------

procedure TfItemShopTableForm.FillTable;
begin
end;

//==============================================================================

procedure TfItemShopTableForm.Initialize(ILManager: TILManager);
begin
fILManager := ILManager;
CDA_Init(fKnownShops);
end;

//------------------------------------------------------------------------------

procedure TfItemShopTableForm.Finalize;
begin
// nothing to do here
end;

//------------------------------------------------------------------------------

procedure TfItemShopTableForm.ShowTable;
begin
EnumShops;
FillTable;
ShowModal;
end;

//==============================================================================

procedure TfItemShopTableForm.FormCreate(Sender: TObject);
begin
fDrawBuffer := TBitmap.Create;
fDrawBuffer.PixelFormat := pf24bit;
fDrawBuffer.Canvas.Font.Assign(dgTable.Font);
dgTable.DoubleBuffered := True;
end;

//------------------------------------------------------------------------------

procedure TfItemShopTableForm.FormDestroy(Sender: TObject);
begin
FreeAndNil(fDrawBuffer);
end;

end.
