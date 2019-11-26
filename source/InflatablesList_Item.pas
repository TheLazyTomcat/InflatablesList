unit InflatablesList_Item;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  InflatablesList_Item_Crypt;

{
  Inheritance chain:
  
    TILItem_Base
    TILItem_Utils
    TILItem_Draw
    TILItem_Comp
    TILItem_Search
    TILItem_IO
    TILItem_IO_00000008
    TILItem_IO_00000009    
    TILItem_Crypt
    TILItem
}
type
  TILItem = TILItem_IO_Crypt;

implementation

end.
