unit InflatablesList_ItemShop;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  InflatablesList_ItemShop_IO_00000001;

{
  Inheritance chain:
  
    TILItemShop_Base
    TILItemShop_Update
    TILItemShop_IO
    TILItemShop_IO_00000000
    TILItemShop_IO_00000001
    TILItemShop
}
type
  TILItemShop = TILItemShop_IO_00000001;

implementation

end.
