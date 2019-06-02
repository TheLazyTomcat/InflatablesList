unit IL_ItemShopParsingSettings_Base;

{$INCLUDE '.\IL_defs.inc'}

interface

uses
  AuxTypes,
  IL_Types,
  InflatablesList_HTML_ElementFinder;

type
  TILItemShopParsingSettings_Base = class(TObject)
  protected
    // internals, used only in parsing process (not saved)
    fRequiredCount:   UInt32;
    // data
    fVariables:       TILItemShopParsingVariables;
    fTemplateRef:     String;
    fDisableParsErrs: Boolean;
    fAvailExtrSetts:  array of TILItemShopParsingExtrSett;
    fAvailFinder:     TILElementFinder;
    fPriceExtrSetts:  array of TILItemShopParsingExtrSett;
    fPriceFinder:     TILElementFinder;
    // data getters and setters
    Function GetVariableCount: Integer; virtual;
    Function GetVariable(Index: Integer): String; virtual;
    procedure SetVariable(Index: Integer; const Value: String); virtual;
    Function GetAvailExtrSettCount: Integer; virtual;
    Function GetAvailExtrSettPtr(Index: Integer): PILItemShopParsingExtrSett; virtual;
    Function GetPriceExtrSettCount: Integer; virtual;
    Function GetPriceExtrSettPtr(Index: Integer): PILItemShopParsingExtrSett; virtual;
    // other protected methods
    procedure InitializeData; virtual;
    procedure FinalizeData; virtual;
    procedure Initialize; virtual;
    procedure Finalize; virtual;
  public
    constructor Create;
    constructor CreateAsCopy(Source: TILItemShopParsingSettings_Base);
    destructor Destroy; override;
    // properties
    property RequiredCount: UInt32 read fRequiredCount write fRequiredCount;
    // data
    property VariableCount: Integer read GetVariableCount;
    property Variables[Index: Integer]: String read GetVariable write SetVariable;
    property TemplateReference: String read fTemplateRef write fTemplateRef;
    property DisableParsingErrors: Boolean read fDisableParsErrs write fDisableParsErrs;
    property AvailExtractionSettingsCount: Integer read GetAvailExtrSettCount;
    property AvailExtractionSettingsPtrs[Index: Integer]: PILItemShopParsingExtrSett read GetAvailExtrSettPtr;
    property AvailFinder: TILElementFinder read fAvailFinder;
    property PriceExtractionSettingsCount: Integer read GetPriceExtrSettCount;
    property PriceExtractionSettingsPtrs[Index: Integer]: PILItemShopParsingExtrSett read GetPRiceExtrSettPtr;
    property PriceFinder: TILElementFinder read fPriceFinder;    
  end;

implementation

uses
  SysUtils;

Function TILItemShopParsingSettings_Base.GetVariableCount: Integer;
begin
Result := Length(fVariables.Vars);
end;

//------------------------------------------------------------------------------

Function TILItemShopParsingSettings_Base.GetVariable(Index: Integer): String;
begin
If (Index >= Low(fVariables.Vars)) and (Index <= High(fVariables.Vars)) then
  Result := fVariables.Vars[Index]
else
  raise Exception.CreateFmt('TILItemShopParsingSettings_Base.GetVariable: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

procedure TILItemShopParsingSettings_Base.SetVariable(Index: Integer; const Value: String);
begin
If (Index >= Low(fVariables.Vars)) and (Index <= High(fVariables.Vars)) then
  fVariables.Vars[Index] := Value
else
  raise Exception.CreateFmt('TILItemShopParsingSettings_Base.SetVariable: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

Function TILItemShopParsingSettings_Base.GetAvailExtrSettCount: Integer;
begin
Result := Length(fAvailExtrSetts);
end;

//------------------------------------------------------------------------------

Function TILItemShopParsingSettings_Base.GetAvailExtrSettPtr(Index: Integer): PILItemShopParsingExtrSett;
begin
If (Index >= Low(fAvailExtrSetts)) and (Index <= High(fAvailExtrSetts)) then
  Result := Addr(fAvailExtrSetts[Index])
else
  raise Exception.CreateFmt('TILItemShopParsingSettings_Base.GetAvailExtrSettPtr: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

Function TILItemShopParsingSettings_Base.GetPriceExtrSettCount: Integer;
begin
Result := Length(fPriceExtrSetts);
end;

//------------------------------------------------------------------------------

Function TILItemShopParsingSettings_Base.GetPriceExtrSettPtr(Index: Integer): PILItemShopParsingExtrSett;
begin
If (Index >= Low(fPriceExtrSetts)) and (Index <= High(fPriceExtrSetts)) then
  Result := Addr(fPriceExtrSetts[Index])
else
  raise Exception.CreateFmt('TILItemShopParsingSettings_Base.GetPriceExtrSettPtr: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

procedure TILItemShopParsingSettings_Base.InitializeData;
var
  i:  Integer;
begin
For i := Low(fVariables.Vars) to High(fVariables.Vars) do
  fVariables.Vars[i] := '';
fTemplateRef := '';
fDisableParsErrs := False;
SetLength(fAvailExtrSetts,0);
fAvailFinder := TILElementFinder.Create;
SetLength(fPriceExtrSetts,0);
fPriceFinder := TILElementFinder.Create;
end;

//------------------------------------------------------------------------------

procedure TILItemShopParsingSettings_Base.FinalizeData;
begin
SetLength(fAvailExtrSetts,0);
FreeAndNil(fAvailFinder);
SetLength(fPriceExtrSetts,0);
FreeAndNil(fPriceFinder);
end;

//------------------------------------------------------------------------------

procedure TILItemShopParsingSettings_Base.Initialize;
begin
fRequiredCount := 1;
InitializeData;
end;

//------------------------------------------------------------------------------

procedure TILItemShopParsingSettings_Base.Finalize;
begin
FinalizeData;
end;

//==============================================================================

constructor TILItemShopParsingSettings_Base.Create;
begin
inherited Create;
Initialize;
end;

//------------------------------------------------------------------------------

constructor TILItemShopParsingSettings_Base.CreateAsCopy(Source: TILItemShopParsingSettings_Base);
var
  i:  Integer;
begin
inherited Create;
// copy fields
fRequiredCount := Source.RequiredCount;
// copy data
For i := Low(fVariables.Vars) to High(fVariables.Vars) do
  begin
    fVariables.Vars[i] := Source.Variables[i];
    UniqueString(fVariables.Vars[i]);
  end;
fTemplateRef := Source.TemplateReference;
UniqueString(fTemplateRef);
fDisableParsErrs := Source.DisableParsingErrors;
SetLength(fAvailExtrSetts,Source.AvailExtractionSettingsCount);
For i := Low(fAvailExtrSetts) to High(fAvailExtrSetts) do
  begin
    fAvailExtrSetts[i] := Source.AvailExtractionSettingsPtrs[i]^;
    UniqueString(fAvailExtrSetts[i].ExtractionData);
    UniqueString(fAvailExtrSetts[i].NegativeTag);
  end;
fAvailFinder := TILElementFinder.CreateAsCopy(Source.AvailFinder);
SetLength(fPriceExtrSetts,Source.PriceExtractionSettingsCount);
For i := Low(fPriceExtrSetts) to High(fPriceExtrSetts) do
  begin
    fPriceExtrSetts[i] := Source.PriceExtractionSettingsPtrs[i]^;
    UniqueString(fPriceExtrSetts[i].ExtractionData);
    UniqueString(fPriceExtrSetts[i].NegativeTag);
  end;
fPriceFinder := TILElementFinder.CreateAsCopy(Source.PriceFinder);
end;

//------------------------------------------------------------------------------

destructor TILItemShopParsingSettings_Base.Destroy;
begin
Finalize;
inherited;
end;

end.
