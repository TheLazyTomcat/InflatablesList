unit InflatablesList_ItemPictures;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  InflatablesList_ItemPictures_IO_00000001;

{
  Inheritance chain:

    TILItemPictures_Base
    TILItemPictures_IO
    TILItemPictures_IO_00000000
    TILItemPictures_IO_00000001
    TILItemPictures
}
type
  TILItemPictures = class(TILItemPictures_IO_00000001);

implementation

end.
