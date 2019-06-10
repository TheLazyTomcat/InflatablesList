unit IL_Manager;

{$INCLUDE '.\IL_defs.inc'}

interface

uses
  IL_Manager_IO_00000008;

{
  inheritance chain:

    base - sort - filter - templates - IO - IO_vers - this
}

type
  TILManager = TILManager_IO_00000008;

implementation

end.
