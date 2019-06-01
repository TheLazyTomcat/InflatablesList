unit IL_Item;

{$INCLUDE '.\IL_defs.inc'}

interface

uses
  IL_Item_Comp;

{
  inheritance chain:

    base - utils - draw - comp - this
}

type
  TILItem = TILItem_Comp;

implementation

end.
