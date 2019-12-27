unit ILPP_Utils;

{$INCLUDE '.\ILPP_defs.inc'}

interface

{===============================================================================
    (Extra/Inter)polation routines
===============================================================================}

Function NormalizeInBounds(Low,High: Single; Value: Single): Single;

Function ExtrapolateLinear(LowX,HighX,LowY,HighY: Single; Value: Single): Single; overload;
Function ExtrapolateLinear(Value: Single): Single; overload;

Function InterpolateLinear(LowX,HighX,LowY,HighY: Single; Value: Single): Single; overload;
Function InterpolateLinear(Value: Single): Single; overload;

Function InterpolateBiLinear(LowX,HighX,LowY,HighY,ChangeX,ChangeY: Single; Value: Single): Single; overload;
Function InterpolateBiLinear(ChangeX,ChangeY: Single; Value: Single): Single; overload;

{===============================================================================
    Other routines
===============================================================================}

procedure ExtractResourceToFile(const ResourceName,FileName: String);

implementation

uses
  SysUtils, Classes, Math,
  StrRect;

{===============================================================================
    (Extra/Inter)polation routines
===============================================================================}

Function NormalizeInBounds(Low,High: Single; Value: Single): Single;
begin
If High <> Low then
  Result := EnsureRange((Value - Low) / (High - Low),0.0,1.0)
else
  Result := 0.0;
end;

//------------------------------------------------------------------------------

Function ExtrapolateLinear(LowX,HighX,LowY,HighY: Single; Value: Single): Single;
begin
If HighX <> LowX then
  Result := LowY + (((Value - LowX) / (HighX - LowX)) * (HighY - LowY))
else
  Result := 0.0;
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

Function ExtrapolateLinear(Value: Single): Single;
begin
Result := ExtrapolateLinear(0.0,1.0,0.0,1.0,Value);
end;

//------------------------------------------------------------------------------

Function InterpolateLinear(LowX,HighX,LowY,HighY: Single; Value: Single): Single;
begin
If Value < LowX then
  Result := LowY
else If Value > HighX then
  Result := HighY
else
  Result := LowY + (NormalizeInBounds(LowX,HighX,Value) * (HighY - LowY));
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

Function InterpolateLinear(Value: Single): Single;
begin
Result := InterpolateLinear(0.0,1.0,0.0,1.0,Value);
end;

//------------------------------------------------------------------------------

Function InterpolateBiLinear(LowX,HighX,LowY,HighY,ChangeX,ChangeY: Single; Value: Single): Single;
begin
If ChangeX <> LowX then
  begin
    If Value > ChangeX then
      Result := InterpolateLinear(ChangeX,HighX,ChangeY,HighY,Value)
    else
      Result := InterpolateLinear(LowX,ChangeX,LowY,ChangeY,Value);
  end
else Result := InterpolateLinear(LowX,HighX,LowY,highY,Value);
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

Function InterpolateBiLinear(ChangeX,ChangeY: Single; Value: Single): Single;
begin
Result := InterpolateBiLinear(0.0,1.0,0.0,1.0,ChangeX,ChangeY,Value);
end;

{===============================================================================
    Other routines
===============================================================================}

procedure ExtractResourceToFile(const ResourceName,FileName: String);
var
  ResStream:  TResourceStream;
begin
If not FileExists(StrToRTL(FileName)) then
  begin
    ResStream := TResourceStream.Create(hInstance,StrToRTL(ResourceName),PChar(10));
    try
      ResStream.SaveToFile(StrToRTL(FileName));
    finally
      ResStream.Free;
    end;
  end;
end;


end.
