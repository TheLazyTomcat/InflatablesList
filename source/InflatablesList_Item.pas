unit InflatablesList_Item;
{$message 'll_rework'}

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  InflatablesList_Item_IO_00000005;

{
  Inheritance chain:
  
    TILItem_Base
    TILItem_Utils
    TILItem_Draw
    TILItem_Comp
    TILItem_IO
    TILItem_IO_00000000
    TILItem_IO_00000001
    TILItem_IO_00000002
    TILItem_IO_00000003
    TILItem_IO_00000004
    TILItem_IO_00000005
    TILItem
}
type
  TILItem = TILItem_IO_00000005;

implementation

end.
