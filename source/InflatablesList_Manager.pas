unit InflatablesList_Manager;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  InflatablesList_Manager_IO_00000008;

{
  inheritance chain:

    base - sort - filter - templates - IO - IO_vers - converter - this
}

type
  TILManager = TILManager_IO_00000008;

implementation

end.
