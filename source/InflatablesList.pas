unit InflatablesList;

{$IFDEF DevelMsgs}
  {$message 'export/import (ini)'}
  {$message 'export/import of templates to/from ini'}
{$ENDIF}
{.$message 'shops wnd - check the list size, move view to newly added'}
{$message 'per shop flag - alternative download (add spec to set this flag in selected shops)'}
{.$message 'when renaming template - rename all references to it'}

{
  when program or list settings are added...

    - failed download repeat count
    - history depth
}

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  InflatablesList_Manager_VER00000004;

type
  TILManager = TILManager_VER00000004;

implementation

end.

