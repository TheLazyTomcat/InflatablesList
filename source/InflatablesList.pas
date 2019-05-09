unit InflatablesList;

{$IFDEF DevelMsgs}
  {$message 'export/import (ini)'}
{$ENDIF}
{$message 'add per-shop parsing error raise disable'}
{.$message 'retry failde downloads'}
{$message 'search trees - allow reference to templates (select local or reference - dropdown list)'}

{
  when program or list settings are added...

    - failed download repeat count
    - history depth
}

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  InflatablesList_Manager_VER00000002;

type
  TILManager = TILManager_VER00000002;

implementation

end.

