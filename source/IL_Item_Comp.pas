unit IL_Item_Comp;

{$INCLUDE '.\IL_defs.inc'}

interface

uses
  IL_Item_Draw;

type
  TILItem_Comp = class(TILItem_Draw)
  public
    Function Contains(const Text: String): Boolean; virtual;
  end;

implementation

uses
  SysUtils, StrUtils,
  IL_ItemShop;

Function TILItem_Comp.Contains(const Text: String): Boolean;
var
  SelShop:  TILItemShop;
begin
Result :=
  AnsiContainsText(TypeStr,Text) or
  AnsiContainsText(fItemTypeSpec,Text) or
  AnsiContainsText(IntToStr(fPieces),Text) or
  AnsiContainsText(fDataProvider.ItemManufacturers[fManufacturer].Str,Text) or
  AnsiContainsText(fManufacturerStr,Text) or
  AnsiContainsText(IntToStr(fID),Text) or
  AnsiContainsText(fTextTag,Text) or
  AnsiContainsText(IntToStr(fWantedLevel),Text) or
  AnsiContainsText(fVariant,Text) or
  AnsiContainsText(IntToStr(fSizeX),Text) or
  AnsiContainsText(IntToStr(fSizeY),Text) or
  AnsiContainsText(IntToStr(fSizeZ),Text) or
  AnsiContainsText(IntToStr(fUnitWeight),Text) or
  AnsiContainsText(fNotes,Text);
If not Result and ShopsSelected(SelShop) then
  Result := AnsiContainsText(SelShop.Name,Text);
end;

end.
