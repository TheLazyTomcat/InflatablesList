unit splash_preprocess_main;

interface

procedure Main;

implementation

uses
  Windows, SysUtils, Graphics;

procedure BitmapColorPremultiply(BMP: TBitmap);
type
  TRGBQuadArray = array[0..High(Word) - 1] of TRGBQuad;
  PRGBQuadArray = ^TRGBQuadArray;
var
  BlendValues:  Array[Byte,Byte] of Byte;
  BMPColor:     PRGBQuadArray;
  x,y:          Integer;
begin
For y := 0 to 255 do
  For x := 0 to 255 do
    BlendValues[x,y] := (x * y) div 255;
For y := 0 to Pred(BMP.Height) do
  begin
    BMPColor := BMP.ScanLine[y];
    For x := 0 to Pred(BMP.Width) do
      begin
        BMPColor[x].rgbBlue := BlendValues[BMPColor[x].rgbBlue,BMPColor[x].rgbReserved];
        BMPColor[x].rgbGreen := BlendValues[BMPColor[x].rgbGreen,BMPColor[x].rgbReserved];
        BMPColor[x].rgbRed := BlendValues[BMPColor[x].rgbRed,BMPColor[x].rgbReserved];
      end;
  end;
end;

//------------------------------------------------------------------------------

procedure Preprocess(const FileName: String);
var
  BMP:  TBitmap;
begin
BMP := TBitmap.Create;
try
  BMP.LoadFromFile(FileName);
  BitmapColorPremultiply(BMP);
  BMP.SaveToFile(FileName);
finally
  BMP.Free;
end;
end;

//------------------------------------------------------------------------------

procedure Main;
begin
try
  If ParamCount >= 1 then
    Preprocess(ExpandFileName(ParamStr(1)));
except
  on E: Exception do
    WriteLn('error - ',E.ClassName,': ',E.Message);
end;
end;

end.
