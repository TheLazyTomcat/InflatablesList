unit InflatablesList_ItemShop;
{$message 'll_rework'}

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  InflatablesList_ItemShop_IO_00000000;

{
  Inheritance chain:
  
    TILItemShop_Base
    TILItemShop_Update
    TILItemShop_IO
    TILItemShop_IO_00000000
    TILItemShop
}
type
  TILItemShop = TILItemShop_IO_00000000;

implementation

end.
