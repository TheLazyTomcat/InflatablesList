unit ILPP_ColorCorrection;

{$INCLUDE '.\ILPP_defs.inc'}

interface

uses
  ILPP_Base;

{===============================================================================
--------------------------------------------------------------------------------
                              Conversion using map
--------------------------------------------------------------------------------
===============================================================================}

procedure CompleteColorSpaceMap(IncompleteMap,CompletedMap: Pointer);

Function MapCorrectRGB(RGB: TRGBAQuadruplet; ConversionMap: Pointer): TRGBAQuadruplet; overload;
Function MapCorrectRGB(RGB: TRGBAQuadruplet): TRGBAQuadruplet; overload;

Function MapCorrectR(RGB: TRGBAQuadruplet; ConversionMap: Pointer): Byte; overload;
Function MapCorrectR(RGB: TRGBAQuadruplet): Byte; overload;

Function MapCorrectG(RGB: TRGBAQuadruplet; ConversionMap: Pointer): Byte; overload;
Function MapCorrectG(RGB: TRGBAQuadruplet): Byte; overload;

Function MapCorrectB(RGB: TRGBAQuadruplet; ConversionMap: Pointer): Byte; overload;
Function MapCorrectB(RGB: TRGBAQuadruplet): Byte; overload;

{===============================================================================
--------------------------------------------------------------------------------
                              Init/Final functions
--------------------------------------------------------------------------------
===============================================================================}

procedure Initialize;
procedure Finalize;

implementation

uses
  SysUtils, Classes, Math,
  StrRect,
  ILPP_Utils;

{===============================================================================
--------------------------------------------------------------------------------
                              Conversion using map                              
--------------------------------------------------------------------------------
===============================================================================}

{$R '..\resources\rgb_map.res'}

{===============================================================================
    Internal types, variables and constants
===============================================================================}
type
  TRGBColorSpaceMap = array[{R}Byte,{G}Byte,{B}Byte] of TRGBAQuadruplet{32bit, RGBA};
  PRGBColorSpaceMap = ^TRGBColorSpaceMap;

  TRGBColorSpaceChannel = (chRed,chGreen,chBlue);  

//------------------------------------------------------------------------------

  TRGBColorSpaceProcMapEntry = record
    Red,Green,Blue: Single;
    Reserved:       Integer;  // - = original   + = interpolated    0 = no value
  end;
  PRGBColorSpaceProcMapEntry = ^TRGBColorSpaceProcMapEntry;

  TRGBColorSpaceProcMap = array[Byte,Byte,Byte] of TRGBColorSpaceProcMapEntry;
  PRGBColorSpaceProcMap = ^TRGBColorSpaceProcMap;

  TRGBColorSpaceProcMapSurface = (srfNoRed,srfFullRed,srfNoGreen,srfFullGreen,srfNoBlue,srfFullBlue);

var
  DefaultMap: TRGBColorSpaceMap;

{===============================================================================
    Filling of incomplete map
===============================================================================}

Function GetSurfaceRed(X,Y,Z: Byte; Surface: TRGBColorSpaceProcMapSurface): Byte;
begin
case Surface of
  srfNoRed,
  srfFullRed:    Result := Z;
  srfNoGreen,
  srfFullGreen:  Result := X;
  srfNoBlue,
  srfFullBlue:   Result := X;
else
  raise Exception.CreateFmt('GetSurfaceRed: Invalid surface (%d).',[Ord(Surface)]);
end;
end;

//------------------------------------------------------------------------------

Function GetSurfaceGreen(X,Y,Z: Byte; Surface: TRGBColorSpaceProcMapSurface): Byte;
begin
case Surface of
  srfNoRed,
  srfFullRed:    Result := X;
  srfNoGreen,
  srfFullGreen:  Result := Z;
  srfNoBlue,
  srfFullBlue:   Result := Y;
else
  raise Exception.CreateFmt('GetSurfaceGreen: Invalid surface (%d).',[Ord(Surface)]);
end;
end;

//------------------------------------------------------------------------------

Function GetSurfaceBlue(X,Y,Z: Byte; Surface: TRGBColorSpaceProcMapSurface): Byte;
begin
case Surface of
  srfNoRed,
  srfFullRed:    Result := Y;
  srfNoGreen,
  srfFullGreen:  Result := Y;
  srfNoBlue,
  srfFullBlue:   Result := Z;
else
  raise Exception.CreateFmt('GetSurfaceBlue: Invalid surface (%d).',[Ord(Surface)]);
end;
end;

//------------------------------------------------------------------------------

Function GetSurfaceChannnel(X,Y,Z: Byte; Surface: TRGBColorSpaceProcMapSurface; Channel: TRGBColorSpaceChannel): Byte;
begin
case Channel of
  chRed:    Result := GetSurfaceRed(X,Y,Z,Surface);
  chGreen:  Result := GetSurfaceGreen(X,Y,Z,Surface);
  chBlue:   Result := GetSurfaceBlue(X,Y,Z,Surface);
else
  raise Exception.CreateFmt('GetSurfaceChannnel: Invalid surface (%d).',[Ord(Channel)]);
end;
end;

//==============================================================================

procedure FillRGBColorSpaceMapSurface(Map: PRGBColorSpaceProcMap; Surface: TRGBColorSpaceProcMapSurface);
var
  X,Y,Z:  Integer;
  I1,I2:  Integer;
  i:      Integer;

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  Function GetMapEntryPtr(A,B,C: Byte): PRGBColorSpaceProcMapEntry;
  begin
    Result := Addr(Map^[
      GetSurfaceRed(A,B,C,Surface),
      GetSurfaceGreen(A,B,C,Surface),
      GetSurfaceBlue(A,B,C,Surface)]);
  end;

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  procedure InterpolateX(Secondary: Boolean);
  var
    II1,II2:  Integer;
    ii:       Integer;
  begin
    // lower
    II1 := -1;
    ii := X;
    repeat
      If (GetMapEntryPtr(ii,Y,Z)^.Reserved < 0) or
        (Secondary and (GetMapEntryPtr(ii,Y,Z)^.Reserved <> 0)) then
        II1 := ii;
      Dec(ii);
    until (II1 >= 0) or (ii < 0);
    // higher
    II2 := -1;
    ii := X;
    repeat
      If (GetMapEntryPtr(ii,Y,Z)^.Reserved < 0) or
        (Secondary and (GetMapEntryPtr(ii,Y,Z)^.Reserved <> 0)) then
        II2 := ii;
      Inc(ii);
    until (II2 >= 0) or (ii > 255);
    If (II1 >= 0) and (II2 >= 0) then
      begin
        GetMapEntryPtr(X,Y,Z)^.Red := GetMapEntryPtr(X,Y,Z)^.Red + EnsureRange(InterpolateLinear(II1,II2,GetMapEntryPtr(II1,Y,Z)^.Red,GetMapEntryPtr(II2,Y,Z)^.Red,X),0,1);
        GetMapEntryPtr(X,Y,Z)^.Green := GetMapEntryPtr(X,Y,Z)^.Green + EnsureRange(InterpolateLinear(II1,II2,GetMapEntryPtr(II1,Y,Z)^.Green,GetMapEntryPtr(II2,Y,Z)^.Green,X),0,1);
        GetMapEntryPtr(X,Y,Z)^.Blue := GetMapEntryPtr(X,Y,Z)^.Blue + EnsureRange(InterpolateLinear(II1,II2,GetMapEntryPtr(II1,Y,Z)^.Blue,GetMapEntryPtr(II2,Y,Z)^.Blue,X),0,1);
        Inc(GetMapEntryPtr(X,Y,Z)^.Reserved);
      end;
  end;

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  procedure InterpolateY(Secondary: Boolean);
  var
    II1,II2:  Integer;
    ii:       Integer;
  begin
    // lower
    II1 := -1;
    ii := Y;
    repeat
      If (GetMapEntryPtr(X,ii,Z)^.Reserved < 0) or
        (Secondary and (GetMapEntryPtr(X,ii,Z)^.Reserved <> 0)) then
        II1 := ii;
      Dec(ii);
    until (II1 >= 0) or (ii < 0);
    // higher
    II2 := -1;
    ii := Y;
    repeat
      If (GetMapEntryPtr(X,ii,Z)^.Reserved < 0) or
        (Secondary and (GetMapEntryPtr(X,ii,Z)^.Reserved <> 0)) then
        II2 := ii;
      Inc(ii);
    until (II2 >= 0) or (ii > 255);
    If (II1 >= 0) and (II2 >= 0) then
      begin
        GetMapEntryPtr(X,Y,Z)^.Red := GetMapEntryPtr(X,Y,Z)^.Red + EnsureRange(InterpolateLinear(II1,II2,GetMapEntryPtr(X,II1,Z)^.Red,GetMapEntryPtr(X,II2,Z)^.Red,Y),0,1);
        GetMapEntryPtr(X,Y,Z)^.Green := GetMapEntryPtr(X,Y,Z)^.Green + EnsureRange(InterpolateLinear(II1,II2,GetMapEntryPtr(X,II1,Z)^.Green,GetMapEntryPtr(X,II2,Z)^.Green,Y),0,1);
        GetMapEntryPtr(X,Y,Z)^.Blue := GetMapEntryPtr(X,Y,Z)^.Blue + EnsureRange(InterpolateLinear(II1,II2,GetMapEntryPtr(X,II1,Z)^.Blue,GetMapEntryPtr(X,II2,Z)^.Blue,Y),0,1);
        Inc(GetMapEntryPtr(X,Y,Z)^.Reserved);
      end;
  end;

begin
If Surface in [srfNoRed,srfNoGreen,srfNoBlue] then
  Z := 0
else
  Z := 255;
// first round of interpolation
For X := 0 to 255 do
  For Y := 0 to 255 do
    If GetMapEntryPtr(X,Y,Z)^.Reserved = 0 then
      begin
        // interpolate from X
        InterpolateX(False);
        // intepolate from Y
        InterpolateY(False);
        // get average from interpolations
        If GetMapEntryPtr(X,Y,Z)^.Reserved > 1 then
          begin
            GetMapEntryPtr(X,Y,Z)^.Red := GetMapEntryPtr(X,Y,Z)^.Red / GetMapEntryPtr(X,Y,Z)^.Reserved;
            GetMapEntryPtr(X,Y,Z)^.Green := GetMapEntryPtr(X,Y,Z)^.Green / GetMapEntryPtr(X,Y,Z)^.Reserved;
            GetMapEntryPtr(X,Y,Z)^.Blue := GetMapEntryPtr(X,Y,Z)^.Blue / GetMapEntryPtr(X,Y,Z)^.Reserved;
            GetMapEntryPtr(X,Y,Z)^.Reserved := 1;
          end;
      end;
// second round of interpolation
For X := 0 to 255 do
  For Y := 0 to 255 do
    If GetMapEntryPtr(X,Y,Z)^.Reserved = 0 then
      begin
        // interpolate from X
        InterpolateX(True);
        // intepolate from Y 
        InterpolateY(True);
        // get average from interpolations
        If GetMapEntryPtr(X,Y,Z)^.Reserved > 1 then
          begin
            GetMapEntryPtr(X,Y,Z)^.Red := GetMapEntryPtr(X,Y,Z)^.Red / GetMapEntryPtr(X,Y,Z)^.Reserved;
            GetMapEntryPtr(X,Y,Z)^.Green := GetMapEntryPtr(X,Y,Z)^.Green / GetMapEntryPtr(X,Y,Z)^.Reserved;
            GetMapEntryPtr(X,Y,Z)^.Blue := GetMapEntryPtr(X,Y,Z)^.Blue / GetMapEntryPtr(X,Y,Z)^.Reserved;
            GetMapEntryPtr(X,Y,Z)^.Reserved := 1;
          end;  
      end;
// extrapolate where necessary
For X := 0 to 255 do
  For Y := 0 to 255 do
    If GetMapEntryPtr(X,Y,Z)^.Reserved = 0 then
      begin
        // extrapolate from Z axis
        If GetMapEntryPtr(X,Y,Z)^.Reserved = 0 then
          begin
            I1 := -1;
            I2 := -1;
            i := Z;
            repeat
              If GetMapEntryPtr(X,Y,i)^.Reserved < 0 then
                begin
                  If I1 < 0 then
                    I1 := i
                  else
                    I2 := i;
                end;
              If Surface in [srfNoRed,srfNoGreen,srfNoBlue] then
                Inc(i)
              else
                Dec(i);
            until ((I1 >= 0) and (I2 >= 0)) or ((i > 255) or (i < 0));
            If (I1 >= 0) and (I2 >= 0) then
              begin
                // extrapolate color
                GetMapEntryPtr(X,Y,Z)^.Red := EnsureRange(ExtrapolateLinear(I1,I2,GetMapEntryPtr(X,Y,I1)^.Red,GetMapEntryPtr(X,Y,I2)^.Red,Z),0,1);
                GetMapEntryPtr(X,Y,Z)^.Green := EnsureRange(ExtrapolateLinear(I1,I2,GetMapEntryPtr(X,Y,I1)^.Green,GetMapEntryPtr(X,Y,I2)^.Green,Z),0,1);
                GetMapEntryPtr(X,Y,Z)^.Blue := EnsureRange(ExtrapolateLinear(I1,I2,GetMapEntryPtr(X,Y,I1)^.Blue,GetMapEntryPtr(X,Y,I2)^.Blue,Z),0,1);
                GetMapEntryPtr(X,Y,Z)^.Reserved := 1;
              end
            else raise Exception.CreateFmt('FillRGBColorSpaceMapSurface: Cannot extrapolate (%d,%d,%d,%d)',[Ord(Surface),X,Y,Z]);
          end;
      end;
end;

//------------------------------------------------------------------------------

procedure FillRGBColorSpaceMapSurfaces(Map: PRGBColorSpaceProcMap);
var
  Surface:  TRGBColorSpaceProcMapSurface;
begin
For Surface := Low(TRGBColorSpaceProcMapSurface) to High(TRGBColorSpaceProcMapSurface) do
  FillRGBColorSpaceMapSurface(Map,Surface);
end;

//==============================================================================

procedure FillRGBColorSpaceMap(Map: PRGBColorSpaceProcMap);
var
  R,G,B:  Integer;
  I1,I2:  Integer;
  i:      Integer;
  Cntr:   Integer;
begin
// fill color space surfaces
FillRGBColorSpaceMapSurfaces(Map);
// interpolate missing points
For R := 1 to 254 do
  For G := 1 to 254 do
    For B := 1 to 254 do
      If Map^[R,G,B].Reserved = 0 then
        begin
          Cntr := 0;
          // interpolate in direction of red channel
          // lower
          I1 := -1;
          i := R;
          repeat
            If Map^[i,G,B].Reserved <> 0 then
              I1 := i;
            Dec(i);
          until (I1 >= 0) or (i < 0);
          // higher
          I2 := -1;
          i := R;
          repeat
            If Map^[i,G,B].Reserved <> 0 then
              I2 := i;
            Inc(i);
          until (I2 >= 0) or (i > 255);
          If (I1 >= 0) and (I2 >= 0) then
            begin
              Map^[R,G,B].Red := Map^[R,G,B].Red + EnsureRange(InterpolateLinear(I1,I2,Map^[I1,G,B].Red,Map^[I2,G,B].Red,R),0,1);
              Map^[R,G,B].Green := Map^[R,G,B].Green + EnsureRange(InterpolateLinear(I1,I2,Map^[I1,G,B].Green,Map^[I2,G,B].Green,R),0,1);
              Map^[R,G,B].Blue := Map^[R,G,B].Blue + EnsureRange(InterpolateLinear(I1,I2,Map^[I1,G,B].Blue,Map^[I2,G,B].Blue,R),0,1);
              Inc(Cntr);
            end;
          // interpolate in direction of green channel
          // lower
          I1 := -1;
          i := G;
          repeat
            If Map^[R,i,B].Reserved <> 0 then
              I1 := i;
            Dec(i);
          until (I1 >= 0) or (i < 0);
          // higher
          I2 := -1;
          i := G;
          repeat
            If Map^[R,i,B].Reserved <> 0 then
              I2 := i;
            Inc(i);
          until (I2 >= 0) or (i > 255);
          If (I1 >= 0) and (I2 >= 0) then
            begin
              Map^[R,G,B].Red := Map^[R,G,B].Red + EnsureRange(InterpolateLinear(I1,I2,Map^[R,I1,B].Red,Map^[R,I2,B].Red,G),0,1);
              Map^[R,G,B].Green := Map^[R,G,B].Green + EnsureRange(InterpolateLinear(I1,I2,Map^[R,I1,B].Green,Map^[R,I2,B].Green,G),0,1);
              Map^[R,G,B].Blue := Map^[R,G,B].Blue + EnsureRange(InterpolateLinear(I1,I2,Map^[R,I1,B].Blue,Map^[R,I2,B].Blue,G),0,1);
              Inc(Cntr);
            end;
          // interpolate in direction of blue channel
          // lower
          I1 := -1;
          i := B;
          repeat
            If Map^[R,G,i].Reserved <> 0 then
              I1 := i;
            Dec(i);
          until (I1 >= 0) or (i < 0);
          // higher
          I2 := -1;
          i := B;
          repeat
            If Map^[R,G,i].Reserved <> 0 then
              I2 := i;
            Inc(i);
          until (I2 >= 0) or (i > 255);
          If (I1 >= 0) and (I2 >= 0) then
            begin
              Map^[R,G,B].Red := Map^[R,G,B].Red + EnsureRange(InterpolateLinear(I1,I2,Map^[R,G,I1].Red,Map^[R,G,I2].Red,B),0,1);
              Map^[R,G,B].Green := Map^[R,G,B].Green + EnsureRange(InterpolateLinear(I1,I2,Map^[R,G,I1].Green,Map^[R,G,I2].Green,B),0,1);
              Map^[R,G,B].Blue := Map^[R,G,B].Blue + EnsureRange(InterpolateLinear(I1,I2,Map^[R,G,I1].Blue,Map^[R,G,I2].Blue,B),0,1);
              Inc(Cntr);
            end;
          // get average from interpolations
          If Cntr > 1 then
            begin
              Map^[R,G,B].Red := Map^[R,G,B].Red / Cntr;
              Map^[R,G,B].Green := Map^[R,G,B].Green / Cntr;
              Map^[R,G,B].Blue := Map^[R,G,B].Blue / Cntr;
            end;
          Map^[R,G,B].Reserved := 1;
        end;
// check if all points are set
For R := 0 to 255 do
  For G := 0 to 255 do
    For B := 0 to 255 do
      If Map^[R,G,B].Reserved = 0 then
        raise Exception.CreateFmt('FillRGBColorSpaceMap: Invalid value [%d,%d,%d].',[R,G,B]);
end;

//------------------------------------------------------------------------------

procedure CompleteColorSpaceMap(IncompleteMap,CompletedMap: Pointer);
var
  R,G,B:  Byte;
  Map:    PRGBColorSpaceProcMap;
begin
GetMem(Map,SizeOf(TRGBColorSpaceMap));
try
  // copy all valid entries
  FillChar(Map^,SizeOf(TRGBColorSpaceMap),0);
  For R := 0 to 255 do
    For G := 0 to 255 do
      For B := 0 to 255 do
        If PRGBColorSpaceMap(IncompleteMap)^[R,G,B].A <> 0 then
          begin
            Map^[R,G,B].Red := PRGBColorSpaceMap(IncompleteMap)^[R,G,B].R / 255;
            Map^[R,G,B].Green := PRGBColorSpaceMap(IncompleteMap)^[R,G,B].G / 255;
            Map^[R,G,B].Blue := PRGBColorSpaceMap(IncompleteMap)^[R,G,B].B / 255;
            Map^[R,G,B].Reserved := -1;
          end;
  // do the actual calculations        
  FillRGBColorSpaceMap(Map);
  // fill result
  FillChar(CompletedMap^,SizeOf(TRGBColorSpaceMap),0);
  For R := 0 to 255 do
    For G := 0 to 255 do
      For B := 0 to 255 do
        begin
          PRGBColorSpaceMap(IncompleteMap)^[R,G,B].R := EnsureRange(Round(Map^[R,G,B].Red * 255),0,255);
          PRGBColorSpaceMap(IncompleteMap)^[R,G,B].G := EnsureRange(Round(Map^[R,G,B].Green * 255),0,255);
          PRGBColorSpaceMap(IncompleteMap)^[R,G,B].B := EnsureRange(Round(Map^[R,G,B].Blue * 255),0,255);
          PRGBColorSpaceMap(IncompleteMap)^[R,G,B].A := 1;
        end;
finally
  FreeMem(Map,SizeOf(TRGBColorSpaceMap));
end;
end;

//==============================================================================

Function MapCorrectRGB(RGB: TRGBAQuadruplet; ConversionMap: Pointer): TRGBAQuadruplet;
begin
Result := PRGBColorSpaceMap(ConversionMap)^[RGB.R,RGB.G,RGB.B];
Result.A := 0;
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

Function MapCorrectRGB(RGB: TRGBAQuadruplet): TRGBAQuadruplet;
begin
Result := MapCorrectRGB(RGB,@DefaultMap);
end;

//------------------------------------------------------------------------------

Function MapCorrectR(RGB: TRGBAQuadruplet; ConversionMap: Pointer): Byte;
begin
Result := MapCorrectRGB(RGB,ConversionMap).R;
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

Function MapCorrectR(RGB: TRGBAQuadruplet): Byte;
begin
Result := MapCorrectR(RGB,@DefaultMap);
end;

//------------------------------------------------------------------------------

Function MapCorrectG(RGB: TRGBAQuadruplet; ConversionMap: Pointer): Byte;
begin
Result := MapCorrectRGB(RGB,ConversionMap).G;
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

Function MapCorrectG(RGB: TRGBAQuadruplet): Byte;
begin
Result := MapCorrectG(RGB,@DefaultMap);
end;

//------------------------------------------------------------------------------

Function MapCorrectB(RGB: TRGBAQuadruplet; ConversionMap: Pointer): Byte;
begin
Result := MapCorrectRGB(RGB,ConversionMap).B;
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

Function MapCorrectB(RGB: TRGBAQuadruplet): Byte;
begin
Result := MapCorrectB(RGB,@DefaultMap);
end;

{===============================================================================
--------------------------------------------------------------------------------
                              Init/Final functions
--------------------------------------------------------------------------------
===============================================================================}

procedure Initialize;
var
  ResStream:  TResourceStream;
begin
ResStream := TResourceStream.Create(hInstance,StrToRTL('rgb_map'),PChar(10));
try
  ResStream.ReadBuffer(DefaultMap,SizeOf(TRGBColorSpaceMap));
finally
  ResStream.Free;
end;
end;

//------------------------------------------------------------------------------

procedure Finalize;
begin
// nothing to do
end;

end.

