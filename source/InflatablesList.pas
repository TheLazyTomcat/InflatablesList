unit InflatablesList;

{$IFDEF DevelMsgs}
  {$message 'export/import (ini)'}
  {$message 'export/import of templates to/from ini'}
{$ENDIF}

{$message 'save last update result code - indicate worst in main listing, add sort by worst result'}

{
  manager inheritance chain:

    Base - Utils - Shops - IO - Sort - Filter - Templates - Draw - VER0 ... VERn - final

  when program or list settings are added...

    - failed download repeat count
    - history depth
    - smooth wanted strip
}

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  InflatablesList_Manager_00000005;

type
  TILManager = TILManager_00000005;

implementation

end.

