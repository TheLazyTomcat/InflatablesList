program ILPictureProcessor;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  ILPP_Base in 'source\ILPP_Base.pas',
  ILPP_Utils in 'source\ILPP_Utils.pas',
  ILPP_System in 'source\ILPP_System.pas',
  ILPP_SimpleBitmap in 'source\ILPP_SimpleBitmap.pas',
  ILPP_SaveLoad in 'source\ILPP_SaveLoad.pas',
  ILPP_ColorCorrection in 'source\ILPP_ColorCorrection.pas',
  ILPP_Program in 'source\ILPP_Program.pas';

begin
  ILPP_Program.Main;
end.
