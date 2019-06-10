unit IL_Manager_IO_Converter;

{$INCLUDE '.\IL_defs.inc'}

interface

uses
  Classes,
  AuxTypes,
  IL_Manager_IO;

type
  TILManager_IO_Converter = class(TILManager_IO)
  protected
    procedure Convert_7_to_8(Stream: TStream); override;
  end;

implementation

procedure TILManager_IO_Converter.Convert_7_to_8(Stream: TStream);
begin
{$message 'implement'}
end;

end.
