unit InflatablesList_SimpleBitmap;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  AuxTypes, AuxClasses,
  Windows, Classes, Graphics;

type
  TILRGBAQuad = packed record
    R,G,B,A:  Byte;
  end;
  PILRGBAQuad = ^TILRGBAQuad;

  TILRGBAQuadArray = array[0..$FFFF] of TILRGBAQuad;
  PILRGBAQuadArray = ^TILRGBAQuadArray;

Function RGBAToColor(RGBA: TILRGBAQuad): TColor;
Function ColorToRGBA(Color: TColor): TILRGBAQuad;

Function RGBAToWinRGBA(RGBA: TILRGBAQuad): TRGBQuad;
Function WinRGBAToRGBA(WinRGBA: TRGBQuad): TILRGBAQuad;

Function RGBAToWinRGB(RGBA: TILRGBAQuad): TRGBTriple;
Function WinRGBToRGBA(WinRGB: TRGBTriple): TILRGBAQuad;

type
  TRGBTripleArray = array[0..$FFFF] of TRGBTriple;
  PRGBTripleArray = ^TRGBTripleArray;

//==============================================================================

const
  IL_SIMPLE_BITMAP_SIGNATURE = UInt32($42534C49); // ILSB

type
  TILSimpleBitmap = class(TCustomObject)
  private
    fMemory:  Pointer;
    fSize:    TMemSize;
    fWidth:   UInt32;
    fHeight:  UInt32;
    Function GetPixel(X,Y: UInt32): TILRGBAQuad;
    procedure SetPixel(X,Y: UInt32; Value: TILRGBAQuad);
    procedure SetWidth(Value: UInt32);
    procedure SetHeight(Value: UInt32);
  protected
    procedure Reallocate(NewSize: TMemSize);
  public
    constructor Create;
    constructor CreateFrom(Bitmap: TBitmap); overload; virtual;
    constructor CreateFrom(SimpleBitmap: TILSimpleBitmap); overload; virtual;
    destructor Destroy; override;
    Function ScanLine(Y: UInt32): Pointer; virtual;
    procedure AssignTo(Bitmap: TBitmap); virtual;
    procedure AssignFrom(Bitmap: TBitmap); overload; virtual;
    procedure AssignFrom(SimpleBitmap: TILSimpleBitmap); overload; virtual;
    procedure LoadFromStream(Stream: TStream); virtual;
    procedure SaveToStream(Stream: TStream); virtual;
    procedure DrawTo(Bitmap: TBitmap; AtX,AtY,Left,Top,Right,Bottom: Integer); overload; virtual;
    procedure DrawTo(Bitmap: TBitmap; AtX,AtY,Width,Height: Integer); overload; virtual;
    procedure DrawTo(Bitmap: TBitmap; AtX,AtY: Integer); overload; virtual;
    property Memory: Pointer read fMemory;
    property Size: TMemSize read fSize;
    property Pixels[X,Y: UInt32]: TILRGBAQuad read GetPixel write SetPixel; default;
    property Width: UInt32 read fWidth write SetWidth;
    property Height: UInt32 read fHeight write SetHeight;
  end;

implementation

uses
  SysUtils, Math,
  BinaryStreaming;

Function RGBAToColor(RGBA: TILRGBAQuad): TColor;
begin
{
  TILRGBAQuad and TColor has the same memory layout. First byte is red channel,
  second byte id green channel and third byte is blue channel. Fourth byte
  (alpha) is masked-out and set to 0 in the result.
}
Result := TColor(RGBA) and $00FFFFFF;
end;

//------------------------------------------------------------------------------

Function ColorToRGBA(Color: TColor): TILRGBAQuad;
begin
// alpha is set to 255 (fully opaque)
Result := TILRGBAQuad(Color or TColor($FF000000));
end;

//------------------------------------------------------------------------------

Function RGBAToWinRGBA(RGBA: TILRGBAQuad): TRGBQuad;
begin
Result.rgbBlue := RGBA.B;
Result.rgbGreen := RGBA.G;
Result.rgbRed := RGBA.R;
Result.rgbReserved := RGBA.A;
end;

//------------------------------------------------------------------------------

Function WinRGBAToRGBA(WinRGBA: TRGBQuad): TILRGBAQuad;
begin
Result.R := WinRGBA.rgbRed;
Result.G := WinRGBA.rgbGreen;
Result.B := WinRGBA.rgbBlue;
Result.A := WinRGBA.rgbReserved;
end;

//------------------------------------------------------------------------------

Function RGBAToWinRGB(RGBA: TILRGBAQuad): TRGBTriple;
begin
Result.rgbtBlue := RGBA.B;
Result.rgbtGreen := RGBA.G;
Result.rgbtRed := RGBA.R;
// alpha is ignored
end;

//------------------------------------------------------------------------------

Function WinRGBToRGBA(WinRGB: TRGBTriple): TILRGBAQuad;
begin
Result.R := WinRGB.rgbtRed;
Result.G := WinRGB.rgbtGreen;
Result.B := WinRGB.rgbtBlue;
Result.A := 255;  // alpha is set to fully opaque
end;

//==============================================================================
//------------------------------------------------------------------------------
//==============================================================================

Function TILSimpleBitmap.GetPixel(X,Y: UInt32): TILRGBAQuad;
begin
If (Y < fHeight) and (X < fWidth) then
  Result := PILRGBAQuad(PtrUInt(fMemory) + (((PtrUInt(fWidth) * PtrUInt(Y)) + PtrUInt(X)) * SizeOf(TILRGBAQuad)))^
else
  raise Exception.CreateFmt('TILSimpleBitmap.GetPixel: Invalid coordinates [%d,%d].',[X,Y]);
end;

//------------------------------------------------------------------------------

procedure TILSimpleBitmap.SetPixel(X,Y: UInt32; Value: TILRGBAQuad);
begin
If (Y < fHeight) and (X < fWidth) then
  PILRGBAQuad(PtrUInt(fMemory) + (((PtrUInt(fWidth) * PtrUInt(Y)) + PtrUInt(X)) * SizeOf(TILRGBAQuad)))^ := Value
else
  raise Exception.CreateFmt('TILSimpleBitmap.SetPixel: Invalid coordinates [%d,%d].',[X,Y]);
end;

//------------------------------------------------------------------------------

procedure TILSimpleBitmap.SetWidth(Value: UInt32);
var
  NewSize:  TMemSize;
begin
If Value <> fWidth then
  begin
    NewSize := TMemSize(Value) * TMemSize(fHeight) * SizeOf(TILRGBAQuad);
    Reallocate(NewSize);
    fWidth := Value;
  end;
end;

//------------------------------------------------------------------------------

procedure TILSimpleBitmap.SetHeight(Value: UInt32);
var
  NewSize:  TMemSize;
begin
If Value <> fHeight then
  begin
    NewSize := TMemSize(fWidth) * TMemSize(Value) * SizeOf(TILRGBAQuad);
    Reallocate(NewSize);
    fHeight := Value;
  end;
end;

//==============================================================================

procedure TILSimpleBitmap.Reallocate(NewSize: TMemSize);
begin
If NewSize <> fSize then
  begin
    If NewSize > 0 then
      ReallocMem(fMemory,NewSize)
    else
      FreeMem(fMemory,NewSize);
    fSize := NewSize;
  end;
end;

//==============================================================================

constructor TILSimpleBitmap.Create;
begin
inherited Create;
fMemory := nil;
fSize := 0;
fWidth := 0;
fHeight := 0;
end;

//------------------------------------------------------------------------------

constructor TILSimpleBitmap.CreateFrom(Bitmap: TBitmap);
begin
Create;
AssignFrom(Bitmap);
end;

//------------------------------------------------------------------------------

constructor TILSimpleBitmap.CreateFrom(SimpleBitmap: TILSimpleBitmap);
begin
Create;
AssignFrom(SimpleBitmap);
end;

//------------------------------------------------------------------------------

destructor TILSimpleBitmap.Destroy;
begin
If Assigned(fMemory) and (fSize > 0) then
  FreeMem(fMemory,fSize);
inherited;
end;

//------------------------------------------------------------------------------

Function TILSimpleBitmap.ScanLine(Y: UInt32): Pointer;
begin
Result := Pointer(PtrUInt(fMemory) + ((PtrUInt(fWidth) * PtrUInt(Y)) * SizeOf(TILRGBAQuad)));
end;

//------------------------------------------------------------------------------

procedure TILSimpleBitmap.AssignTo(Bitmap: TBitmap);
var
  SrcScanLine:  Pointer;
  DstScanLine:  Pointer;
  X,Y:          Integer;
begin
// prepare destination bitmap
Bitmap.PixelFormat := pf24bit;
Bitmap.Width := fWidth;
Bitmap.Height := fHeight;
For Y := 0 to Pred(fHeight) do
  begin
    SrcScanLine := ScanLine(Y);
    DstScanLine := Bitmap.ScanLine[Y];    
    For X := 0 to Pred(fWidth) do
      PRGBTripleArray(DstScanLine)^[X] := RGBAToWinRGB(PILRGBAQuadArray(SrcScanLine)^[X]);
  end;
end;

//------------------------------------------------------------------------------

procedure TILSimpleBitmap.AssignFrom(Bitmap: TBitmap);
var
  SrcScanLine:  Pointer;
  DstScanLine:  Pointer;
  X,Y:          Integer;
begin
If Bitmap.PixelFormat = pf24Bit then
  begin
    Width := Bitmap.Width;
    Height := Bitmap.Height;
    For Y := 0 to Pred(fHeight) do
      begin
        SrcScanLine := Bitmap.ScanLine[Y];
        DstScanLine := ScanLine(Y);
        For X := 0 to Pred(fWidth) do
          PILRGBAQuadArray(DstScanLine)^[X] := WinRGBToRGBA(PRGBTripleArray(SrcScanLine)^[X]);
      end;
  end
else raise Exception.CreateFmt('TILSimpleBitmap.AssignFrom: Unsupported pixel format (%d).',[Ord(Bitmap.PixelFormat)]);
end;

//------------------------------------------------------------------------------

procedure TILSimpleBitmap.AssignFrom(SimpleBitmap: TILSimpleBitmap);
begin
fWidth := SimpleBitmap.Width;
fHeight := SimpleBitmap.Height;
Reallocate(SimpleBitmap.Size);
Move(SimpleBitmap.Memory^,fMemory^,fSize);
end;

//------------------------------------------------------------------------------

procedure TILSimpleBitmap.LoadFromStream(Stream: TStream);
begin
If Stream_ReadUInt32(Stream) = IL_SIMPLE_BITMAP_SIGNATURE then
  begin
    Stream_ReadUInt32(Stream);  // drop this value
    Width := Stream_ReadUInt32(Stream);
    Height := Stream_ReadUInt32(Stream);
    // setting width and height has allocated the memory
    Stream_ReadBuffer(Stream,fMemory^,fSize);    
  end
else raise Exception.Create('TILSimpleBitmap.LoadFromStream: Invalid signature.');
end;

//------------------------------------------------------------------------------

procedure TILSimpleBitmap.SaveToStream(Stream: TStream);
begin
Stream_WriteUInt32(Stream,IL_SIMPLE_BITMAP_SIGNATURE);
Stream_WriteUInt32(Stream,0); // reserved for future use
Stream_WriteUInt32(Stream,fWidth);
Stream_WriteUInt32(Stream,fHeight);
Stream_WriteBuffer(Stream,fMemory^,fSize);
end;

//------------------------------------------------------------------------------

procedure TILSimpleBitmap.DrawTo(Bitmap: TBitmap; AtX,AtY,Left,Top,Right,Bottom: Integer);
var
  SrcScanLine:  Pointer;
  DstScanLine:  Pointer;
  X,Y:          Integer;
begin
If Bitmap.PixelFormat = pf24Bit then
  begin
    // rectify coordinates
    If Left < 0 then
      Left := 0;
    If Right >= Integer(fWidth) then
      Right := Pred(fWidth);
    If Top < 0 then
      Top := 0;
    If Bottom >= Integer(fHeight) then
      Bottom := Pred(fHeight);
    // traversing
    For Y := Top to Bottom do
      If ((Y + AtY - Top) >= 0) and ((Y + AtY - Top) < Bitmap.Height) then
        begin
          SrcScanLine := ScanLine(Y);
          DstScanLine := Bitmap.ScanLine[Y + AtY - Top];
          For X := Left to Right do
            If ((X + AtX - Left) >= 0) and ((X + AtX - Left) < Bitmap.Width) then
              PRGBTripleArray(DstScanLine)^[X + AtX - Left] := RGBAToWinRGB(PILRGBAQuadArray(SrcScanLine)^[X]);
        end;
  end
else raise Exception.CreateFmt('TILSimpleBitmap.DrawTo: Unsupported pixel format (%d).',[Ord(Bitmap.PixelFormat)]);
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

procedure TILSimpleBitmap.DrawTo(Bitmap: TBitmap; AtX,AtY,Width,Height: Integer);
begin
DrawTo(Bitmap,AtX,AtY,0,0,Pred(Width),Pred(Height));
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

procedure TILSimpleBitmap.DrawTo(Bitmap: TBitmap; AtX,AtY: Integer);
begin
DrawTo(Bitmap,AtX,AtY,0,0,Pred(fWidth),Pred(fHeight));
end;

end.
