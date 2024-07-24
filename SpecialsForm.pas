unit SpecialsForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls,
  InflatablesList_Manager;

type
  TfSpecialsForm = class(TForm)
    pnlWarning: TPanel;
    leParam_1: TLabeledEdit;
    leParam_2: TLabeledEdit;
    leParam_3: TLabeledEdit;
    lblFunctions: TLabel;
    lbFunctions: TListBox;
    lblDescription: TLabel;
    meDescription: TMemo;
    cbCloseWhenDone: TCheckBox;
    btnRunSelected: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);    
    procedure FormDestroy(Sender: TObject);
    procedure lbFunctionsDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure lbFunctionsClick(Sender: TObject);
    procedure btnRunSelectedClick(Sender: TObject);
  private
    fILManager:   TILManager;
    fDrawBuffer:  TBitmap;
  protected
    procedure ProcessingDone;
    procedure SpecialSelect(Index: Integer);
    // special functions implementation
    procedure Special_0001;
    procedure Special_0002;
    procedure Special_0003;
    procedure Special_0004;
    procedure Special_0005;
    procedure Special_0006;
    procedure Special_0007;
    procedure Special_0008;
    procedure Special_0009;
    procedure Special_0010;
    procedure Special_0011;
    procedure Special_0012;
    procedure Special_0013;
    procedure Special_0014;
    procedure Special_0015;
    procedure Special_0016;
  public
    procedure Initialize(ILManager: TILManager);
    procedure Finalize;
  end;

var
  fSpecialsForm: TfSpecialsForm;

implementation

{$R *.dfm}

uses
  StrUtils,
  InflatablesList_Types,
  InflatablesList_Utils;

type
  TILSpecialsEntry = record
    Title:        String;
    Details:      String;
    Description:  String;
    FunctionIdx:  Integer;
  end;

const
  IL_SPECIALS: array[0..14] of TILSpecialsEntry = (
         (Title: 'Clear textual tags';
        Details: 'Item.TextTag := ''''';
    Description: 'Sets textual tag to an empty string for all items that have accesible data.' + sLineBreak +
                 sLineBreak +
                 'Parameters are not used in this function.';
    FunctionIdx: 1),
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
         (Title: 'Clear parsing settings';
        Details: 'Item.Shop.ParsingSettings.Clear';
    Description: 'For all items that have accessible data, the parsing settings in all shops are cleared. ' +
                 'This means the available and price extraction settings are cleared and all stages in available and price finders are removed.' + sLineBreak +
                 sLineBreak +
                 'Parameters are not used in this function.';
    FunctionIdx: 2),
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
         (Title: 'Alternative download method for selected shops';
        Details: 'Shop.Selected => Shop.AltDownloadMethod := True';
    Description: 'For all items that have accessible data, the function traverses all shops and activates alternative download method when ' +
                 'the shop name matches parameter 1 (case insensitive comparison).' + sLineBreak +
                 sLineBreak +
                 'Parameter 1 - item shop name';
    FunctionIdx: 3),
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
         (Title: 'Update and flag available count and price';
        Details: 'Item.GetAndFlagPriceAndAvail(Price,Available)';
    Description: 'Traverses all items and, for those with accessible data, calls method GetAndFlagPriceAndAvail with old price set to current price and old available count set to current count. ' +
                 'This effectively updates the prices and available count fields from shops and sets appropriate flags ("available change", "price change" and "not available" flags).' + sLineBreak +
                 sLineBreak +
                 'Parameters are not used in this function.';
    FunctionIdx: 4),
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
         (Title: 'Set material to polyvinylchloride (PVC)';   
        Details: '(Item.Material = Unknown) => Item.Material := Polyvinylchloride';
    Description: 'For all items that have accessible data, if the selected material is unknown, sets material to polyvinylchloride (PVC).' + sLineBreak +
                 sLineBreak +
                 'Parameters are not used in this function.';
    FunctionIdx: 5),
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
         (Title: 'Clear available change and price change flags'; 
        Details: 'Item.AvailChange := False; Item.PriceChange := False';
    Description: 'Traverses all items and, for those with accessible data, clears "available change" and "price change" flags (sets them to false).' + sLineBreak +
                 sLineBreak +
                 'Parameters are not used in this function.';
    FunctionIdx: 6),
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
         (Title: 'Replace textual tag when it matches';      
        Details: '(Item.TextTag = P1) => Item.TextTag := P2';
    Description: 'Traverses all items and, for those with accessible data, compares (case insensitive) textual tag to a parameter 1. When it matches, it is replaced by a text given in parameter 2.' + sLineBreak +
                 sLineBreak +
                 'Parameter 1 - tag to search for' + sLineBreak +
                 'Parameter 2 - replacement tag';
    FunctionIdx: 8),
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
         (Title: 'Remove all shops except the selected one'; 
        Details: 'not Item.Shop.Selected => Item.Remove(Shop)';
    Description: 'For all items that have accessible data, removes all shos except the selected one.' + sLineBreak +
                 sLineBreak +
                 'Parameters are not used in this function.';
    FunctionIdx: 9),
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
         (Title: 'Remove all shops from owned items';    
        Details: 'Item.Owned => Item.ShopsClear';
    Description: 'Removes all shops from all items that have accessible data and have "owned" flag set to true.' + sLineBreak +
                 sLineBreak +
                 'Parameters are not used in this function.';
    FunctionIdx: 10),
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
         (Title: 'Set wanted level to zero in owned items';
        Details: 'Item.Owned => Item.WantedLevel := 0';
    Description: 'Sets wanted level to zero for all items that have accessible data and have "owned" flag set to true.' + sLineBreak +
                 sLineBreak +
                 'Parameters are not used in this function.';
    FunctionIdx: 11),
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
         (Title: 'Generate user ID for owned items';
        Details: '(Item.Owned and (Item.UserID = '''')) => Item.GenerateUserID';
    Description: 'Generates user ID or all items that has accessible data and the current user ID is empty.' + sLineBreak +
                 sLineBreak +
                 'Parameters are not used in this function.';
    FunctionIdx: 12),
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
         (Title: 'Uncheck disabling of parsing error for templated shops';
        Details: 'Item.Shop.TemplRef => Item.Shop.DisableParsingErrors := False';
    Description: 'For all items that have accessible data, unchecks (sets to false) "disable parsing errors" options in ' +
                 'all shops that have their parsing settings referenced to a template.' + sLineBreak +
                 sLineBreak +
                 'Parameters are not used in this function.';
    FunctionIdx: 13),
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
         (Title: 'Auto-rename all pictures in all items';
        Details: 'Item.Pictures.AutoRename';
    Description: 'For all items that have accessible data, auto-rename all pictures. ' + sLineBreak +
                 sLineBreak +
                 'Parameters are not used in this function.';
    FunctionIdx: 14),
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
         (Title: 'Check existence of all automated picture files';
        Details: 'count (not FileExists(Items.Pictures))';
    Description: 'For all items that have accessible data, count not existing automated picture files.' + sLineBreak +
                 sLineBreak +
                 'Parameters are not used in this function.';
    FunctionIdx: 15),
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
         (Title: 'Create compact listing of owned items';
        Details: 'Item.Owned => List.Add(Item)';
    Description: 'Add all owned items that have accessible data to a compact listing and save it' +
                 'to a file (in the directory where the main file resides).' + sLineBreak +
                 sLineBreak +
                 'Parameter 1 - name of the file, including extension (If not set then name "list.txt" is used)';
    FunctionIdx: 16)
  );

//==============================================================================

procedure TfSpecialsForm.ProcessingDone;
begin
If cbCloseWhenDone.Checked then
  Close;
end;

//------------------------------------------------------------------------------

procedure TfSpecialsForm.SpecialSelect(Index: Integer);
begin
case Index of
  1:  Special_0001;
  2:  Special_0002;
  3:  Special_0003;
  4:  Special_0004;
  5:  Special_0005;
  6:  Special_0006;
  7:  Special_0007;
  8:  Special_0008;
  9:  Special_0009;
  10: Special_0010;
  11: Special_0011;
  12: Special_0012;
  13: Special_0013;
  14: Special_0014;
  15: Special_0015;
  16: Special_0016;
else
  MessageDlg(IL_Format('Invalid special function index (%d).',[Index]),mtError,[mbOK],0);
end;
ProcessingDone;
end;

//------------------------------------------------------------------------------

procedure TfSpecialsForm.Special_0001;
var
  i:  Integer;
begin
For i := fILManager.ItemLowIndex to fILManager.ItemHighIndex do
  If fILManager[i].DataAccessible then
    fILManager[i].TextTag := '';
end;

//------------------------------------------------------------------------------

procedure TfSpecialsForm.Special_0002;
var
  i,j:  Integer;
begin
For i := fILManager.ItemLowIndex to fILManager.ItemHighIndex do
  If fILManager[i].DataAccessible then
    For j := fILManager[i].ShopLowIndex to fILManager[i].ShopHighIndex do
      begin
        fILManager[i][j].ParsingSettings.AvailExtractionSettingsClear;
        fILManager[i][j].ParsingSettings.AvailFinder.StageClear;
        fILManager[i][j].ParsingSettings.PriceExtractionSettingsClear;
        fILManager[i][j].ParsingSettings.PriceFinder.StageClear;
      end;
end;

//------------------------------------------------------------------------------

procedure TfSpecialsForm.Special_0003;
var
  i,j:  Integer;
begin
For i := fILManager.ItemLowIndex to fILManager.ItemHighIndex do
  If fILManager[i].DataAccessible then
    For j := fILManager[i].ShopLowIndex to fILManager[i].ShopHighIndex do
      If IL_SameText(fILManager[i][j].Name,leParam_1.Text) then
        fILManager[i][j].AltDownMethod := True;
end;
  
//------------------------------------------------------------------------------

procedure TfSpecialsForm.Special_0004;
var
  i:  Integer;
begin
For i := fILManager.ItemLowIndex to fILManager.ItemHighIndex do
  If fILManager[i].DataAccessible then
    fILManager[i].GetAndFlagPriceAndAvail(
      fILManager[i].UnitPriceSelected,fILManager[i].AvailableSelected);
end;

//------------------------------------------------------------------------------

procedure TfSpecialsForm.Special_0005;
var
  i:  Integer;
begin
For i := fILManager.ItemLowIndex to fILManager.ItemHighIndex do
  If fILManager[i].DataAccessible then
    If fILManager[i].Material = ilimtUnknown then
      fILManager[i].Material := ilimtPolyvinylchloride;
end;
   
//------------------------------------------------------------------------------

procedure TfSpecialsForm.Special_0006;
var
  i:  Integer;
begin
For i := fILManager.ItemLowIndex to fILManager.ItemHighIndex do
  If fILManager[i].DataAccessible then
    begin
      fILManager[i].SetFlagValue(ilifPriceChange,False);
      fILManager[i].SetFlagValue(ilifAvailChange,False)
    end;
end;
 
//------------------------------------------------------------------------------

procedure TfSpecialsForm.Special_0007;
begin
// not needed anymore
end;
 
//------------------------------------------------------------------------------

procedure TfSpecialsForm.Special_0008;
var
  i:  Integer;
begin
For i := fILManager.ItemLowIndex to fILManager.ItemHighIndex do
  If fILManager[i].DataAccessible then
    If IL_SameText(fILManager[i].TextTag,leParam_1.Text) then
      fILManager[i].TextTag := leParam_2.Text;
end;
 
//------------------------------------------------------------------------------

procedure TfSpecialsForm.Special_0009;
var
  i,j:  Integer;
begin
For i := fILManager.ItemLowIndex to fILManager.ItemHighIndex do
  If fILManager[i].DataAccessible then
    For j := fILManager[i].ShopHighIndex downto fILManager[i].ShopLowIndex do
      If not fILManager[i][j].Selected then
        fILManager[i].ShopDelete(j);
end;
 
//------------------------------------------------------------------------------

procedure TfSpecialsForm.Special_0010;
var
  i:  Integer;
begin
For i := fILManager.ItemLowIndex to fILManager.ItemHighIndex do
  If fILManager[i].DataAccessible and (ilifOwned in fILManager[i].Flags) then
      fILManager[i].ShopClear;
end;

//------------------------------------------------------------------------------

procedure TfSpecialsForm.Special_0011;
var
  i:  Integer;
begin
For i := fILManager.ItemLowIndex to fILManager.ItemHighIndex do
  If fILManager[i].DataAccessible and (ilifOwned in fILManager[i].Flags) then
    fILManager[i].WantedLevel := 0;
end;

//------------------------------------------------------------------------------

procedure TfSpecialsForm.Special_0012;
var
  i:    Integer;
  Temp: String;
begin
For i := fILManager.ItemLowIndex to fILManager.ItemHighIndex do
  If fILManager[i].DataAccessible then
    If (ilifOwned in fILManager[i].Flags) and (Length(fILManager[i].UserID) <= 0) then
      If fILManager.GenerateUserID(Temp) then
        fILManager[i].UserID := Temp;
end;

//------------------------------------------------------------------------------

procedure TfSpecialsForm.Special_0013;
var
  i,j:  Integer;
begin
For i := fILManager.ItemLowIndex to fILManager.ItemHighIndex do
  If fILManager[i].DataAccessible then
    For j := fILManager[i].ShopLowIndex to fILManager[i].ShopHighIndex do
      If Length(fILManager[i][j].ParsingSettings.TemplateReference) > 0 then
        fILManager[i][j].ParsingSettings.DisableParsingErrors := False;
end;

//------------------------------------------------------------------------------

procedure TfSpecialsForm.Special_0014;
var
  i,j:  Integer;
begin
For i := fILManager.ItemLowIndex to fILManager.ItemHighIndex do
  If fILManager[i].DataAccessible then
    For j := fILManager[i].Pictures.LowIndex to fILManager[i].Pictures.HighIndex do
      fILManager[i].Pictures.AutoRenameFile(j);
end;

//------------------------------------------------------------------------------

procedure TfSpecialsForm.Special_0015;
var
  i:    Integer;
  Temp: TStringList;
  Cnt:  Integer;
begin
Temp := TStringList.Create;
try
  Cnt := 0;
  For i := fILManager.ItemLowIndex to fILManager.ItemHighIndex do
    begin
      fILManager[i].Pictures.MissingFiles(Temp);
      Inc(Cnt,Temp.Count);
    end;
  If Cnt > 0 then
    MessageDlg(Format('Number of missing picture files: %d.',[Cnt]),mtError,[mbOK],0);
finally
  Temp.Free;
end;
end;

//------------------------------------------------------------------------------

procedure TfSpecialsForm.Special_0016;
var
  Temp: TStringList;
  i:    Integer;

  Function GetTagStr(Index: Integer): String;
  begin
    Result := '  ';
    If (ilifBoxed in fILManager[i].Flags) then
      Result[1] := 'B';
    If (ilifDiscarded in fILManager[i].Flags) then
      Result[2] := 'E' else
    If (ilifRepaired in fILManager[i].Flags) then
      Result[2] := 'R' else
    If (ilifDamaged in fILManager[i].Flags) then
      Result[2] := 'D';
  end;

begin
Temp := TStringList.Create;
try
  For i := fILManager.ItemLowIndex to fILManager.ItemHighIndex do
    If fILManager[i].DataAccessible and (ilifOwned in fILManager[i].Flags) then
      begin
        // [user id] (flag) TitleStr - TypeStr SizeStr - Variant <VariantTag> [TextTag]
        Temp.Add(Format('[%s](%s) %s - %s %s' + sLineBreak + '           %s%s [%s]',[
          IfThen(Length(fILManager[i].UserID) <> 0,fILManager[i].UserID,'    '),
          GetTagStr(i),
          fILManager[i].TitleStr,
          fILManager[i].TypeStr,
          fILManager[i].SizeStr,
          fILManager[i].Variant,
          IfThen(Length(fILManager[i].VariantTag) <> 0,Format(' <%s>',[fILManager[i].VariantTag]),''),
          fILManager[i].TextTag]));
      end;
  If Length(leParam_1.Text) > 0 then
    Temp.SaveToFile(fILManager.StaticSettings.ListPath + leParam_1.Text)
  else
    Temp.SaveToFile(fILManager.StaticSettings.ListPath + 'list.txt')
finally
  Temp.Free;
end;
end;

//==============================================================================

procedure TfSpecialsForm.Initialize(ILManager: TILManager);
var
  i:  Integer;
begin
fILManager := ILManager;
// fill list of special functions
lbFunctions.Items.BeginUpdate;
try
  lbFunctions.Items.Clear;
  For i := Low(IL_SPECIALS) to High(IL_SPECIALS) do
    lbFunctions.Items.Add(IL_SPECIALS[i].Title);
finally
  lbFunctions.Items.EndUpdate;
end;
If lbFunctions.Items.Count > 0 then
  lbFunctions.ItemIndex := 0;
lbFunctions.OnClick(nil);
end;

//------------------------------------------------------------------------------

procedure TfSpecialsForm.Finalize;
begin
// nothing to do here
end;

//==============================================================================

procedure TfSpecialsForm.FormCreate(Sender: TObject);
begin
fDrawBuffer := TBitmap.Create;
fDrawBuffer.PixelFormat := pf24bit;
fDrawBuffer.Canvas.Font.Assign(lbFunctions.Font);
end;

//------------------------------------------------------------------------------

procedure TfSpecialsForm.FormShow(Sender: TObject);
begin
lbFunctions.SetFocus;
end;

//------------------------------------------------------------------------------

procedure TfSpecialsForm.FormDestroy(Sender: TObject);
begin
FreeAndNil(fDrawBuffer);
end;

//------------------------------------------------------------------------------

procedure TfSpecialsForm.lbFunctionsDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  BoundsRect: TRect;
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
        If odSelected in State then
          Brush.Color := $00E5E5E5
        else
          Brush.Color := clWindow;
        Rectangle(BoundsRect.Left,BoundsRect.Top,BoundsRect.Right + 1,BoundsRect.Bottom);
        // side strip
        Brush.Color := clSilver;
        Rectangle(BoundsRect.Left,BoundsRect.Top,BoundsRect.Left + 5,BoundsRect.Bottom);
        // separator line
        Pen.Style := psSolid;
        Pen.Color := clSilver;
        MoveTo(BoundsRect.Left,BoundsRect.Bottom - 1);
        LineTo(BoundsRect.Right,BoundsRect.Bottom - 1);
        // text
        Brush.Style := bsClear;
        Pen.Style := psClear;
        Font.Style := Font.Style + [fsBold];
        font.Color := clWindowText;
        TextOut(7,2,IL_SPECIALS[Index].Title);
        Font.Style := Font.Style - [fsBold];
        font.Color := clGray;
        TextOut(7,17,IL_SPECIALS[Index].Details);
      end;
    // move drawbuffer to the canvas
    lbFunctions.Canvas.CopyRect(Rect,fDrawBuffer.Canvas,BoundsRect);
  end;
end;

//------------------------------------------------------------------------------

procedure TfSpecialsForm.lbFunctionsClick(Sender: TObject);
begin
If lbFunctions.ItemIndex >= 0 then
  meDescription.Text := IL_SPECIALS[lbFunctions.ItemIndex].Description
else
  meDescription.Lines.Clear;
end;

//------------------------------------------------------------------------------

procedure TfSpecialsForm.btnRunSelectedClick(Sender: TObject);
begin
If lbFunctions.ItemIndex >= 0 then
  begin
    If MessageDlg(IL_Format('You are about to execute function "%s".' + sLineBreak +
           'There will be no further dialogs, warnings or prompts, even in case of destructive actions' +
           sLineBreak + sLineBreak + 'Are you sure you want to continue?',[IL_SPECIALS[lbFunctions.ItemIndex].Title]),
         mtWarning,[mbYes,mbNo],0) = mrYes then
      SpecialSelect(IL_SPECIALS[lbFunctions.ItemIndex].FunctionIdx);
  end
else MessageDlg('No function selected.',mtError,[mbOK],0);
end;

end.
