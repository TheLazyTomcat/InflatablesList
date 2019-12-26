unit ILPP_SimpleBitmap;

{$INCLUDE '.\ILPP_defs.inc'}

interface

uses
  AuxTypes,
  ILPP_Base;

{===============================================================================
--------------------------------------------------------------------------------
                                 TSimpleBitmap                                  
--------------------------------------------------------------------------------    
===============================================================================}
{===============================================================================
    TSimpleBitmap - class declaration
===============================================================================}
type
  TSimpleBitmap = class(TObject)
  private
    fMemory:  Pointer;
    fSize:    TMemSize;
    fWidth:   UInt32;
    fHeight:  UInt32;
    Function GetPixel(X,Y: UInt32): TRGBAQuadruplet;
    procedure SetPixel(X,Y: UInt32; Value: TRGBAQuadruplet);
    procedure SetWidth(Value: UInt32);
    procedure SetHeight(Value: UInt32);
  protected
    procedure Reallocate(NewSize: TMemSize);
  public
    constructor Create;
    destructor Destroy; override;
    Function ScanLine(Y: UInt32): Pointer; virtual;
    property Memory: Pointer read fMemory;
    property Size: TMemSize read fSize;
    property Pixels[X,Y: UInt32]: TRGBAQuadruplet read GetPixel write SetPixel; default;
    property Width: UInt32 read fWidth write SetWidth;
    property Height: UInt32 read fHeight write SetHeight;
  end;

implementation

uses
  SysUtils;

{===============================================================================
--------------------------------------------------------------------------------
                                 TSimpleBitmap                                  
--------------------------------------------------------------------------------    
===============================================================================}
{===============================================================================
    TSimpleBitmap - class implementation
===============================================================================}
{-------------------------------------------------------------------------------
    TSimpleBitmap - private methods
-------------------------------------------------------------------------------}

Function TSimpleBitmap.GetPixel(X,Y: UInt32): TRGBAQuadruplet;
begin
If (Y < fHeight) and (X < fWidth) then
  begin
    Result := PRGBAQuadruplet(PtrUInt(fMemory) + (((PtrUInt(fWidth) * PtrUInt(Y)) + PtrUInt(X)) * SizeOf(TRGBAQuadruplet)))^;
  end
else raise Exception.CreateFmt('Invalid coordinates [%d,%d].',[X,Y]);
end;

//------------------------------------------------------------------------------

procedure TSimpleBitmap.SetPixel(X,Y: UInt32; Value: TRGBAQuadruplet);
begin
If (Y < fHeight) and (X < fWidth) then
  begin
    PRGBAQuadruplet(PtrUInt(fMemory) + (((PtrUInt(fWidth) * PtrUInt(Y)) + PtrUInt(X)) * SizeOf(TRGBAQuadruplet)))^ := Value;
  end
else raise Exception.CreateFmt('Invalid coordinates [%d,%d].',[X,Y]);
end;
//------------------------------------------------------------------------------

procedure TSimpleBitmap.SetWidth(Value: UInt32);
var
  NewSize:  TMemSize;
begin
If Value <> fWidth then
  begin
    NewSize := TMemSize(Value) * TMemSize(fHeight) * SizeOf(TRGBAQuadruplet);
    Reallocate(NewSize);
    fWidth := Value;
  end;
end;

//------------------------------------------------------------------------------

procedure TSimpleBitmap.SetHeight(Value: UInt32);
var
  NewSize:  TMemSize;
begin
If Value <> fHeight then
  begin
    NewSize := TMemSize(fWidth) * TMemSize(Value) * SizeOf(TRGBAQuadruplet);
    Reallocate(NewSize);
    fHeight := Value;
  end;
end;

{-------------------------------------------------------------------------------
    TSimpleBitmap - protected methods
-------------------------------------------------------------------------------}

procedure TSimpleBitmap.Reallocate(NewSize: TMemSize);
begin
If NewSize <> fSize then
  begin
    ReallocMem(fMemory,NewSize);
    fSize := NewSize;
  end;
end;

{-------------------------------------------------------------------------------
    TSimpleBitmap - public methods
-------------------------------------------------------------------------------}

constructor TSimpleBitmap.Create;
begin
inherited Create;
fMemory := nil;
fSize := 0;
fWidth := 0;
fHeight := 0;
end;

//------------------------------------------------------------------------------

destructor TSimpleBitmap.Destroy;
begin
If Assigned(fMemory) and (fSize > 0) then
  FreeMem(fMemory,fSize);
inherited;
end;

//------------------------------------------------------------------------------

Function TSimpleBitmap.ScanLine(Y: UInt32): Pointer;
begin
Result := Pointer(PtrUInt(fMemory) + ((PtrUInt(fWidth) * PtrUInt(Y)) * SizeOf(TRGBAQuadruplet)));
end;

end.
