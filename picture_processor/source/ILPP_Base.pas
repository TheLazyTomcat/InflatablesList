unit ILPP_Base;

{$INCLUDE '.\ILPP_defs.inc'}

interface

uses
  Graphics;

{===============================================================================
    Basic color types
===============================================================================}
type
  TRGBTriplet = packed record
    R,G,B:  Byte;
  end;
  PRGBTriplet = ^TRGBTriplet;

  TRGBTripletFloat = record
    R,G,B:  Single;
  end;
  PRGBTripletFloat = ^TRGBTripletFloat;

//------------------------------------------------------------------------------

  TRGBAQuadruplet = packed record
    R,G,B,A:  Byte;
  end;
  PRGBAQuadruplet = ^TRGBAQuadruplet;

  TRGBAQuadrupletFloat = record
    R,G,B,A:  Single;
  end;
  PRGBAQuadrupletFloat = ^TRGBAQuadrupletFloat;

//------------------------------------------------------------------------------

  TCMYTriplet = packed record
    C,M,Y:  Byte;
  end;
  PCMYTriplet = ^TCMYTriplet;

  TCMYTripletFloat = record
    C,M,Y:  Single;
  end;
  PCMYTripletFloat = ^TCMYTripletFloat;

//------------------------------------------------------------------------------  

  TCMYKQuadruplet = packed record
    C,M,Y,K:  Byte;
  end;
  PCMYKQuadruplet = ^TCMYKQuadruplet;

  TCMYKQuadrupletFloat = record
    C,M,Y,K:  Single;
  end;
  PCMYKQuadrupletFloat = ^TCMYKQuadrupletFloat;

{===============================================================================
    Helper color types
===============================================================================}
type
  TBGRTriplet = packed record
    B,G,R:  Byte;
  end;
  PBGRTriplet = ^TBGRTriplet;

//------------------------------------------------------------------------------

  TBGRAQuadruplet = packed record
    B,G,R,A:  Byte;
  end;
  PBGRAQuadruplet = ^TBGRAQuadruplet;

//------------------------------------------------------------------------------

  TARGBQuadruplet = packed record
    A,R,G,B:  Byte;
  end;
  PARGBQuadruplet = ^TARGBQuadruplet;

//------------------------------------------------------------------------------

  TABGRQuadruplet = packed record
    A,B,G,R:  Byte;
  end;
  PABGRQuadruplet = ^TABGRQuadruplet;

{===============================================================================
    Scanline types
===============================================================================}
type
  TRGBLine = array[0..$FFFF] of TRGBTriplet;
  PRGBLine = ^TRGBLine;

  TRGBALine = array[0..$FFFF] of TRGBAQuadruplet;
  PRGBALine = ^TRGBALine;

  TBGRLine = array[0..$FFFF] of TBGRTriplet;
  PBGRLine = ^TBGRLine;

  TBGRALine = array[0..$FFFF] of TBGRAQuadruplet;
  PBGRALine = ^TBGRALine;

{===============================================================================
    Type conversion functions
===============================================================================}

Function RGBIntToFloat(RGB: TRGBTriplet): TRGBTripletFloat;
Function RGBFloatToInt(RGB: TRGBTripletFloat): TRGBTriplet;

Function RGBAIntToFloat(RGBA: TRGBAQuadruplet): TRGBAQuadrupletFloat;
Function RGBAFloatToInt(RGBA: TRGBAQuadrupletFloat): TRGBAQuadruplet;

Function CMYIntToFloat(CMY: TCMYTriplet): TCMYTripletFloat;
Function CMYFloatToInt(CMY: TCMYTripletFloat): TCMYTriplet;

Function CMYKIntToFloat(CMYK: TCMYKQuadruplet): TCMYKQuadrupletFloat;
Function CMYKFloatToInt(CMYK: TCMYKQuadrupletFloat): TCMYKQuadruplet;

//------------------------------------------------------------------------------

Function RGBToRGBA(RGB: TRGBTriplet; Alpha: Byte = 255): TRGBAQuadruplet;
Function RGBAtoRGB(RGBA: TRGBAQuadruplet): TRGBTriplet;

Function CMYToCMYK(CMY: TCMYTriplet; Black: Byte = 0): TCMYKQuadruplet;
Function CMYKToCMY(CMYK: TCMYKQuadruplet; DiscardBlack: Boolean): TCMYTriplet; overload;

Function BGRToRGBA(BGR: TBGRTriplet; Alpha: Byte = 255): TRGBAQuadruplet;
Function RGBAToBGR(RGBA: TRGBAQuadruplet): TBGRTriplet;

Function BGRAToRGBA(BGRA: TBGRAQuadruplet): TRGBAQuadruplet;
Function RGBAToBGRA(RGBA: TRGBAQuadruplet): TBGRAQuadruplet;

Function ARGBToRGBA(ARGB: TARGBQuadruplet): TRGBAQuadruplet;
Function RGBAToARGB(RGBA: TRGBAQuadruplet): TARGBQuadruplet;

Function ABGRToRGBA(ABGR: TABGRQuadruplet): TRGBAQuadruplet;
Function RGBAToABGR(RGBA: TRGBAQuadruplet): TABGRQuadruplet;

Function ColorToRGBA(Color: TColor; Alpha: Byte = 255): TRGBAQuadruplet;
Function RGBAToColor(RGBA: TRGBAQuadruplet): TColor;

{===============================================================================
    Color space conversion functions
===============================================================================}

Function RGBAToCMYK(RGBA: TRGBAQuadruplet; AlphaIsBlack: Boolean = False; AlternativeConversion: Boolean = False): TCMYKQuadruplet;
Function CMYKToRGBA(CMYK: TCMYKQuadruplet; Alpha: Byte = 255): TRGBAQuadruplet;

Function CMYKToCMY(CMYK: TCMYKQuadruplet): TCMYTriplet; overload;

implementation

uses
  Math;

{===============================================================================
    Type conversion functions
===============================================================================}

Function RGBIntToFloat(RGB: TRGBTriplet): TRGBTripletFloat;
begin
Result.R := RGB.R / 255;
Result.G := RGB.G / 255;
Result.B := RGB.B / 255;
end;

//------------------------------------------------------------------------------

Function RGBFloatToInt(RGB: TRGBTripletFloat): TRGBTriplet;
begin
Result.R := Trunc(RGB.R * 255);
Result.G := Trunc(RGB.G * 255);
Result.B := Trunc(RGB.B * 255);
end;

//------------------------------------------------------------------------------

Function RGBAIntToFloat(RGBA: TRGBAQuadruplet): TRGBAQuadrupletFloat;
begin
Result.R := RGBA.R / 255;
Result.G := RGBA.G / 255;
Result.B := RGBA.B / 255;
Result.A := RGBA.A / 255;
end;
 
//------------------------------------------------------------------------------

Function RGBAFloatToInt(RGBA: TRGBAQuadrupletFloat): TRGBAQuadruplet;
begin
Result.R := Trunc(RGBA.R * 255);
Result.G := Trunc(RGBA.G * 255);
Result.B := Trunc(RGBA.B * 255);
Result.A := Trunc(RGBA.A * 255);
end;

//------------------------------------------------------------------------------

Function CMYIntToFloat(CMY: TCMYTriplet): TCMYTripletFloat;
begin
Result.C := CMY.C / 255;
Result.M := CMY.M / 255;
Result.Y := CMY.Y / 255;
end;

//------------------------------------------------------------------------------

Function CMYFloatToInt(CMY: TCMYTripletFloat): TCMYTriplet;
begin
Result.C := Trunc(CMY.C * 255);
Result.M := Trunc(CMY.M * 255);
Result.Y := Trunc(CMY.Y * 255);
end;

//------------------------------------------------------------------------------

Function CMYKIntToFloat(CMYK: TCMYKQuadruplet): TCMYKQuadrupletFloat;
begin
Result.C := CMYK.C / 255;
Result.M := CMYK.M / 255;
Result.Y := CMYK.Y / 255;
Result.K := CMYK.K / 255;
end;

//------------------------------------------------------------------------------

Function CMYKFloatToInt(CMYK: TCMYKQuadrupletFloat): TCMYKQuadruplet;
begin
Result.C := Trunc(CMYK.C * 255);
Result.M := Trunc(CMYK.M * 255);
Result.Y := Trunc(CMYK.Y * 255);
Result.K := Trunc(CMYK.K * 255);
end;

//==============================================================================

Function RGBToRGBA(RGB: TRGBTriplet; Alpha: Byte = 255): TRGBAQuadruplet;
begin
Result.R := RGB.R;
Result.G := RGB.G;
Result.B := RGB.B;
Result.A := Alpha;
end;

//------------------------------------------------------------------------------

Function RGBAtoRGB(RGBA: TRGBAQuadruplet): TRGBTriplet;
begin
Result.R := RGBA.R;
Result.G := RGBA.G;
Result.B := RGBA.B;
// alpha is discarded
end;

//------------------------------------------------------------------------------

Function CMYToCMYK(CMY: TCMYTriplet; Black: Byte = 0): TCMYKQuadruplet;
begin
Result.C := CMY.C;
Result.M := CMY.M;
Result.Y := CMY.Y;
Result.K := Black;
end;

//------------------------------------------------------------------------------

Function CMYKToCMY(CMYK: TCMYKQuadruplet; DiscardBlack: Boolean): TCMYTriplet;
begin
If DiscardBlack then
  begin
    Result.C := CMYK.C;
    Result.M := CMYK.M;
    Result.Y := CMYK.Y;
  end
else Result := CMYKToCMY(CMYK);
end;

//------------------------------------------------------------------------------

Function BGRToRGBA(BGR: TBGRTriplet; Alpha: Byte = 255): TRGBAQuadruplet;
begin
Result.R := BGR.R;
Result.G := BGR.G;
Result.B := BGR.B;
Result.A := Alpha;
end;

//------------------------------------------------------------------------------

Function RGBAToBGR(RGBA: TRGBAQuadruplet): TBGRTriplet;
begin
Result.B := RGBA.B;
Result.G := RGBA.G;
Result.R := RGBA.R;
// alpha is discarded
end;

//------------------------------------------------------------------------------

Function BGRAToRGBA(BGRA: TBGRAQuadruplet): TRGBAQuadruplet;
begin
Result.R := BGRA.R;
Result.G := BGRA.G;
Result.B := BGRA.B;
Result.A := BGRA.A;
end;

//------------------------------------------------------------------------------

Function RGBAToBGRA(RGBA: TRGBAQuadruplet): TBGRAQuadruplet;
begin
Result.B := RGBA.B;
Result.G := RGBA.G;
Result.R := RGBA.R;
Result.A := RGBA.A;
end;

//------------------------------------------------------------------------------

Function ARGBToRGBA(ARGB: TARGBQuadruplet): TRGBAQuadruplet;
begin
Result.R := ARGB.R;
Result.G := ARGB.G;
Result.B := ARGB.B;
Result.A := ARGB.A;
end;

//------------------------------------------------------------------------------

Function RGBAToARGB(RGBA: TRGBAQuadruplet): TARGBQuadruplet;
begin
Result.A := RGBA.A;
Result.R := RGBA.R;
Result.G := RGBA.G;
Result.B := RGBA.B;
end;

//------------------------------------------------------------------------------

Function ABGRToRGBA(ABGR: TABGRQuadruplet): TRGBAQuadruplet;
begin
Result.R := ABGR.R;
Result.G := ABGR.G;
Result.B := ABGR.B;
Result.A := ABGR.A;
end;

//------------------------------------------------------------------------------

Function RGBAToABGR(RGBA: TRGBAQuadruplet): TABGRQuadruplet;
begin
Result.A := RGBA.A;
Result.B := RGBA.B;
Result.G := RGBA.G;
Result.R := RGBA.R;
end;

//------------------------------------------------------------------------------

Function ColorToRGBA(Color: TColor; Alpha: Byte = 255): TRGBAQuadruplet;
begin
Result.R := Color and 255;
Result.G := (Color shr 8) and 255;
Result.B := (Color shr 16) and 255;
Result.A := Alpha;
end;

//------------------------------------------------------------------------------

Function RGBAToColor(RGBA: TRGBAQuadruplet): TColor;
begin
Result := TColor(RGBA.R) or (TColor(RGBA.G) shl 8) or (TColor(RGBA.B) shl 16);
end;

{===============================================================================
    Color space conversion functions
===============================================================================}

Function RGBAToCMYK(RGBA: TRGBAQuadruplet; AlphaIsBlack: Boolean = False; AlternativeConversion: Boolean = False): TCMYKQuadruplet;
var
  RGBAF:  TRGBAQuadrupletFloat;
  CMYKF:  TCMYKQuadrupletFloat;
begin
If AlternativeConversion then
  begin
    {
      use this when converting RGBA which was obtained as a product of improper
      CMYK -> RGBA conversion, where K channel was ignored and copied as alpha
      (A = 1 - K)
    }
    Result.C := 255 - RGBA.R;
    Result.M := 255 - RGBA.G;
    Result.Y := 255 - RGBA.B;
    Result.K := 255 - RGBA.A;
  end
else
  begin
    RGBAF := RGBAIntToFloat(RGBA);
    // get black channel
    If AlphaIsBlack then
      CMYKF.K := 1.0 - RGBAF.A
    else
      CMYKF.K := (1.0 - MaxValue([RGBAF.R,RGBAF.G,RGBAF.B])) / 255;
    // calculate other channels
    If CMYKF.K <> 1.0 then
      begin
        CMYKF.C := (1 - RGBAF.R - CMYKF.K) / (1 - CMYKF.K);
        CMYKF.M := (1 - RGBAF.G - CMYKF.K) / (1 - CMYKF.K);
        CMYKF.Y := (1 - RGBAF.B - CMYKF.K) / (1 - CMYKF.K);
      end
    else
      begin
        CMYKF.C := (1 - RGBAF.R - CMYKF.K);
        CMYKF.M := (1 - RGBAF.G - CMYKF.K);
        CMYKF.Y := (1 - RGBAF.B - CMYKF.K);
      end;
    // store result
    Result := CMYKFloatToInt(CMYKF);
  end;
end;

//------------------------------------------------------------------------------

Function CMYKToRGBA(CMYK: TCMYKQuadruplet; Alpha: Byte = 255): TRGBAQuadruplet;
var
  CMYKF:  TCMYKQuadrupletFloat;
  RGBAF:  TRGBAQuadrupletFloat;
begin
CMYKF := CMYKIntToFloat(CMYK);
// calculate channels
If CMYKF.K <> 1.0 then  // optimization for full black color
  begin
    RGBAF.R := (1 - CMYKF.C) * (1 - CMYKF.K);
    RGBAF.G := (1 - CMYKF.M) * (1 - CMYKF.K);
    RGBAF.B := (1 - CMYKF.Y) * (1 - CMYKF.K);
  end
else
  begin
    RGBAF.R := 0;
    RGBAF.G := 0;
    RGBAF.B := 0;
  end;
// store result
Result := RGBAFloatToInt(RGBAF);
end;

//------------------------------------------------------------------------------

Function CMYKToCMY(CMYK: TCMYKQuadruplet): TCMYTriplet;
var
  RGBA: TRGBAQuadruplet;
begin
RGBA := CMYKToRGBA(CMYK);
Result.C := 255 - RGBA.R;
Result.M := 255 - RGBA.G;
Result.Y := 255 - RGBA.B;
end;

end.
