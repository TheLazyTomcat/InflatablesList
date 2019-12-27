unit ILPP_System;

{$INCLUDE '.\ILPP_defs.inc'}

interface

uses
  Windows,
  AuxTypes;

{===============================================================================
    GDI+ stuff (simplified)
===============================================================================}

type
  ULONG_PTR = PUInt32;  PULONG_PTR = ^ULONG_PTR;

  TGdiplusStartupInput = record
    GdiplusVersion:           UInt32;
    DebugEventCallback:       Pointer;
    SuppressBackgroundThread: BOOL;
    SuppressExternalCodecs:   BOOL;
  end;
  PGdiplusStartupInput = ^TGdiplusStartupInput;

  TGdiplusStartupOutput = record
    NotificationHook:   Pointer;
    NotificationUnhook: Pointer;
  end;
  PGdiplusStartupOutput = ^TGdiplusStartupOutput;

//------------------------------------------------------------------------------  

Function GdiplusStartup(token: PULONG_PTR; input: PGdiplusStartupInput; output: PGdiplusStartupOutput): Int32; stdcall; external 'gdiplus.dll';
procedure GdiplusShutdown(token: ULONG_PTR); stdcall; external 'gdiplus.dll';

Function GdipCreateBitmapFromFile(filename: PWideChar; bitmap: Pointer): Int32; stdcall; external 'gdiplus.dll';
Function GdipCreateBitmapFromFileICM(filename: PWideChar; bitmap: Pointer): Int32; stdcall; external 'gdiplus.dll';
Function GdipDisposeImage(image: Pointer): Int32; stdcall; external 'gdiplus.dll';

Function GdipGetImageDimension(image: Pointer; width, height: PSingle): Int32; stdcall; external 'gdiplus.dll';
Function GdipGetImagePixelFormat(image: Pointer; format: PInt32): Int32; stdcall; external 'gdiplus.dll';
Function GdipBitmapGetPixel(bitmap: Pointer; x,y: Integer; color: PUInt32): Int32; stdcall; external 'gdiplus.dll';

//------------------------------------------------------------------------------

procedure GDIPlusError(Status: Integer);

implementation

uses
  SysUtils;

procedure GDIPlusError(Status: Integer);
begin
If Status <> 0 then
  raise Exception.CreateFmt('GDI+ error %d (%d).',[status,GetLastError]);
end;

end.
