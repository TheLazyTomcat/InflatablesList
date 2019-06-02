unit IL_Manager;

{$INCLUDE '.\IL_defs.inc'}

interface

uses
  IL_Manager_Templates;

{
  inheritance chain:

    base - sort - filter - templates - this
}

type
  TILManager = TILManager_Templates;

implementation

end.
