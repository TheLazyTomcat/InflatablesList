unit ILPP_Program;

{$INCLUDE '.\ILPP_defs.inc'}

interface

{===============================================================================
    Init/final functions
===============================================================================}

procedure Initialize;
procedure Finalize;

{===============================================================================
    Main function
===============================================================================}

procedure Main;

implementation

uses
  SysUtils, Classes,
  StrRect, SimpleCMDLineParser,
  ILPP_SimpleBitmap, ILPP_SaveLoad, ILPP_ColorCorrection;

{===============================================================================
    Init/final functions
===============================================================================}

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

{===============================================================================
    Processing subroutines
===============================================================================}

procedure ConvertCMYKToRGB(const FileName: String);
var
  Bitmap: TSimpleBitmap;
begin
WriteLn('***  Coverting CMYK to RGB  ***');
WriteLn;
Bitmap := TSimpleBitmap.Create;
try
  WriteLn('Loading input picture...');
  LoadFile_GDIPlus(FileName,Bitmap);
  WriteLn('Saving converted picture...');
  SaveFile_DevIL(ChangeFileExt(FileName,'.jpg'),Bitmap,pfJPG,80);
finally
  Bitmap.Free;
end;
end;

//------------------------------------------------------------------------------

procedure CorrectColors(const FileName: String);
var
  Bitmap: TSimpleBitmap;
  X,Y:    Integer;
begin
WriteLn('***  Correcting picture colors  ***');
WriteLn;
Bitmap := TSimpleBitmap.Create;
try
  WriteLn('Loading input picture...');
  LoadFile_DevIL(FileName,Bitmap);
  WriteLn('Correcting colors...');
  For Y := 0 to Pred(Bitmap.Height) do
    For X := 0 to Pred(Bitmap.Width) do
      Bitmap.Pixels[X,Y] := MapCorrectRGB(Bitmap.Pixels[X,Y]);
  WriteLn('Saving result to output JPG file...');    
  SaveFile_DevIL(ChangeFileExt(FileName,'.jpg'),Bitmap,pfJPG,80);
finally
  Bitmap.Free;
end;
end;

//------------------------------------------------------------------------------

procedure CompleteMap(const FileName: String);
var
  Temp: TMemoryStream;
begin
WriteLn('***  Completing conversion map  ***');
WriteLn;
Temp := TMemoryStream.Create;
try
  WriteLn('Loading incomplete map...');
  Temp.LoadFromFile(StrToRTL(FileName));
  WriteLn('Completing map...');
  CompleteColorSpaceMap(Temp.Memory,Temp.Memory);
  WriteLn('Saving completed map...');
  Temp.SaveToFile(StrToRTL(FileName));
finally
  Temp.Free;
end;
end;

{===============================================================================
    Main function
===============================================================================}

procedure Main;
var
  Params: TCLPParser;
begin
try
Params := TCLPParser.Create;
try
  If Params.Count <> 2 then
    begin
      WriteLn('******************************************');
      WriteLn('*  Inflatables List - Picture processor  *');
      WriteLn('******************************************');
      WriteLn;
      WriteLn('usage:');
      WriteLn;
      WriteLn('  ILPictureProcessor.exe -Mode FileNane');
      WriteLn;
      WriteLn('        Mode - can be one of the following:');
      WriteLn('                 C - convert input picture from CMYK to RGB');
      WriteLn('                 R - repair colors after bad conversion');
      WriteLn('                 M - complete conversion map');
      WriteLn('    FileName - input and output file');
      WriteLn;
      Write('Press enter to continue...'); ReadLn;
    end
  else
    begin
      Initialize;
      try
        // param 0 is program path
        If (Params[1].ParamType = ptShortCommand) and (Length(Params[1].Arguments) = 1) then
          begin
            If Params[1].Str = 'C' then
              ConvertCMYKToRGB(ExpandFileName(Params[1].Arguments[0]))
            else If Params[1].Str = 'R' then
              CorrectColors(ExpandFileName(Params[1].Arguments[0]))
            else If Params[1].Str = 'M' then
              CompleteMap(ExpandFileName(Params[1].Arguments[0]));
          end
        else
          begin
            WriteLn('Invalid parameters.');
            Write('Press enter to continue...'); ReadLn;
          end;
      finally
        Finalize;
      end;
    end;
finally
  Params.Free;
end;
except
  On E: Exception do
    begin
      WriteLn;
      WriteLn('  error - ',E.ClassName,': ',E.Message); ReadLn;
    end;
end;
end;

end.
