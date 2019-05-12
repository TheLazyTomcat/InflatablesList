unit InflatablesList;

{$IFDEF DevelMsgs}
  {$message 'export/import (ini)'}
  {$message 'export/import of templates to/from ini'}
{$ENDIF}
{$message 'per shop flag untracked - prevents updates'}
{$message 'update selected shops'}

{
  when program or list settings are added...

    - failed download repeat count
    - history depth
}

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  InflatablesList_Manager_VER00000003;

type
  TILManager = TILManager_VER00000003;

implementation

end.

