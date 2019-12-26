unit ILPP_SaveLoad;

{$INCLUDE '.\ILPP_defs.inc'}

interface

uses
  ILPP_SimpleBitmap;

{===============================================================================
    Unit management functions
===============================================================================}

procedure Initialize;
procedure Finalize;

{===============================================================================
    Picture loading functions
===============================================================================}

Function LoadFile_GDIPlus(const FileName: String; Bitmap: TSimpleBitmap): Boolean;
Function LoadFile_DevIL(const FileName: String; Bitmap: TSimpleBitmap): Boolean;

{===============================================================================
    Picture saving functions
===============================================================================}

type
  TPictureFormat = (pfBMP,pfJPG,pfPNG,pfTGA);

Function SaveFile_DevIL(const FileName: String; Bitmap: TSimpleBitmap; Format: TPictureFormat; Quality: Integer = 80 {only for JPG, 0..100}): Boolean;

implementation

uses
  Windows, SysUtils,
  AuxTypes, StrRect,
  il{DevIL},
  ILPP_Base,ILPP_Utils,ILPP_System;

{$R '..\resources\devil_dll.res'}

{===============================================================================
    Unit management functions
===============================================================================}
var
  GDIPToken:  ULONG_PTR;

procedure Initialize;
var
  input:  TGdiplusStartupInput;
  output: TGdiplusStartupOutput;
begin
ExtractResourceToFile('devil_dll',ExpandFileName('.\DevIL.dll'));
DevIL_Initialize;
input.GdiplusVersion := 1;
input.DebugEventCallback := nil;
input.SuppressBackgroundThread := False;
input.SuppressExternalCodecs := True;
If GdiplusStartup(@GDIPToken,@input,@output) <> 0 then
  raise Exception.Create('Unable to initialize GDI+.');
end;

//------------------------------------------------------------------------------

procedure Finalize;
begin
GdiplusShutdown(GDIPToken);
DevIL_Finalize;
end;

{===============================================================================
    Picture loading functions
===============================================================================}

Function LoadFile_GDIPlus(const FileName: String; Bitmap: TSimpleBitmap): Boolean;
var
  GDIPBitmap:     Pointer;
  SWidth,SHeight: Single;
  Line:           PRGBALine;
  X,Y:            Integer;
{
  Color is returned as 32bit quantity with layout A8-R8-G8-B8, and since we are
  on little-endian system, it is actually in memory ordered in reverse (BGRA).
}
  Color:          TBGRAQuadruplet;
begin
try
  GDIPlusError(GdipCreateBitmapFromFile(PWideChar(StrToWide(FileName)),@GDIPBitmap));
  try
    GDIPlusError(GdipGetImageDimension(GDIPBitmap,@SWidth,@SHeight));
    Bitmap.Width := Trunc(SWidth);
    Bitmap.Height := Trunc(SHeight);
    For Y := 0 to Pred(Bitmap.Height) do
      begin
        Line := Bitmap.ScanLine(Y);
        For X := 0 to Pred(Bitmap.Width) do
          begin
            GDIPlusError(GdipBitmapGetPixel(GDIPBitmap,X,Y,@Color));
            Line^[X] := BGRAToRGBA(Color);
          end;
      end;
    Result := True;
  finally
    GdipDisposeImage(GDIPBitmap);
  end;
except
  Result := False;
end;
end;

//------------------------------------------------------------------------------

Function LoadFile_DevIL(const FileName: String; Bitmap: TSimpleBitmap): Boolean;
var
  Image:    ILuint;
  Inverted: Boolean;
  Line:     Pointer;
  Y:        UInt32;
begin
Result := False;
Image := ilGenImage;
try
  ilBindImage(Image);
  If ilLoadImage(PAnsiChar(StrToAnsi(FileName))) <> IL_FALSE then
    begin
      Bitmap.Width := ilGetInteger(IL_IMAGE_WIDTH);
      Bitmap.Height := ilGetInteger(IL_IMAGE_HEIGHT);
      Inverted := ilGetInteger(IL_IMAGE_ORIGIN) = IL_ORIGIN_LOWER_LEFT;
      For Y := 0 to Pred(Bitmap.Height) do
        begin
          If Inverted then
            Line := Bitmap.ScanLine(Pred(Bitmap.Height) - Y)
          else
            Line := Bitmap.ScanLine(Y);
          ilCopyPixels(0,Y,0,Bitmap.Width,1,1,IL_RGBA,IL_UNSIGNED_BYTE,Line);
        end;
      Result := True;
    end;
finally
  IlDeleteImage(Image);
end;
end;

{===============================================================================
    Picture saving functions
===============================================================================}

Function SaveFile_DevIL(const FileName: String; Bitmap: TSimpleBitmap; Format: TPictureFormat; Quality: Integer = 80): Boolean;
var
  Image:    ILuint;
  Inverted: Boolean;
  Line:     Pointer;
  Y:        UInt32;
begin
Result := False;
Image := ilGenImage;
try
  ilBindImage(Image);
  If ilTexImage(Bitmap.Width,Bitmap.Height,1,3,IL_RGB,IL_UNSIGNED_BYTE,nil) <> IL_FALSE then
    begin
      // set datay by lines
      Inverted := ilGetInteger(IL_IMAGE_ORIGIN) = IL_ORIGIN_LOWER_LEFT;
      For Y := 0 to Pred(Bitmap.Height) do
        begin
          If Inverted then
            Line := Bitmap.ScanLine(Pred(Bitmap.Height) - Y)
          else
            Line := Bitmap.ScanLine(Y);
          ilSetPixels(0,Y,0,Bitmap.Width,1,1,IL_RGBA,IL_UNSIGNED_BYTE,Line);
        end;
      // DevIL cannot save if the file already exists
      If FileExists(FileName) then
        DeleteFile(FileName);
      //save to selected format
      case Format of
        pfBMP:  Result := ilSave(IL_BMP,PAnsiChar(StrToAnsi(FileName))) <> IL_FALSE;
        pfJPG:  begin
                  ilSetInteger(IL_JPG_QUALITY,Quality);
                  Result := ilSave(IL_JPG,PAnsiChar(StrToAnsi(FileName))) <> IL_FALSE;
                end;
        pfPNG:  Result := ilSave(IL_PNG,PAnsiChar(StrToAnsi(FileName))) <> IL_FALSE;
        pfTGA:  Result := ilSave(IL_TGA,PAnsiChar(StrToAnsi(FileName))) <> IL_FALSE;
      else
        raise Exception.CreateFmt('SaveFile_DevIL: Invalid file format (%d).',[Ord(Format)]);
      end;
    end;
finally
  IlDeleteImage(Image);
end;
end;

end.
