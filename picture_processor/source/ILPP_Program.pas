unit ILPP_Program;

{$INCLUDE '.\ILPP_defs.inc'}

interface

procedure Initialize;
procedure Finalize;

//------------------------------------------------------------------------------

procedure Main;

implementation

uses
  ILPP_SimpleBitmap, ILPP_SaveLoad, ILPP_ColorCorrection;

procedure Initialize;
begin
ILPP_SaveLoad.Initialize;
ILPP_ColorCorrection.Initialize;
end;

//------------------------------------------------------------------------------

procedure Finalize;
begin
ILPP_ColorCorrection.Finalize;
ILPP_SaveLoad.Finalize;
end;

//==============================================================================

procedure Main;
begin
Initialize;
try
  Readln;
finally
  Finalize;
end;
end;

end.
