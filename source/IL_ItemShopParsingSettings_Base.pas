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
    // internals
    fRequiredCount:   UInt32;
    fStaticOptions:   TILStaticManagerOptions;
    // data
    fVariables:       TILItemShopParsingVariables;
    fTemplateRef:     String;
    fDisableParsErrs: Boolean;
    fAvailExtrSetts:  TILItemShopParsingExtrSettList;
    fAvailFinder:     TILElementFinder;
    fPriceExtrSetts:  TILItemShopParsingExtrSettList;
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
    // extraction settings lists
    Function AvailExtractionSettingsAdd: Integer; virtual;
    procedure AvailExtractionSettingsDelete(Index: Integer); virtual;
    procedure AvailExtractionSettingsClear; virtual;
    Function PriceExtractionSettingsAdd: Integer; virtual;
    procedure PriceExtractionSettingsDelete(Index: Integer); virtual;
    procedure PriceExtractionSettingsClear; virtual;
    // properties
    property RequiredCount: UInt32 read fRequiredCount write fRequiredCount;
    property StaticOptions: TILStaticManagerOptions read fStaticOptions write fStaticOptions;
    // data
    property VariableCount: Integer read GetVariableCount;
    property Variables[Index: Integer]: String read GetVariable write SetVariable;
    property VariablesRec: TILItemShopParsingVariables read fVariables;
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
AvailExtractionSettingsClear;
FreeAndNil(fAvailFinder);
PriceExtractionSettingsClear;
FreeAndNil(fPriceFinder);
end;

//------------------------------------------------------------------------------

procedure TILItemShopParsingSettings_Base.Initialize;
begin
fRequiredCount := 1;
fStaticOptions.NoPictures := False;
fStaticOptions.TestCode := False;
fStaticOptions.SavePages := False;
fStaticOptions.LoadPages := False;
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
fStaticOptions := Source.StaticOptions;
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

//------------------------------------------------------------------------------

Function TILItemShopParsingSettings_Base.AvailExtractionSettingsAdd: Integer;
begin
SetLength(fAvailExtrSetts,Length(fAvailExtrSetts) + 1);
Result := High(fAvailExtrSetts);
fAvailExtrSetts[Result].ExtractFrom := ilpefText;
fAvailExtrSetts[Result].ExtractionMethod := ilpemFirstInteger;
fAvailExtrSetts[Result].ExtractionData := '';
fAvailExtrSetts[Result].NegativeTag := '';
end;
 
//------------------------------------------------------------------------------

procedure TILItemShopParsingSettings_Base.AvailExtractionSettingsDelete(Index: Integer);
var
  i:  Integer;
begin
If (Index >= Low(fAvailExtrSetts)) and (Index <= High(fAvailExtrSetts)) then
  begin
    For i := Index to Pred(High(fAvailExtrSetts)) do
      fAvailExtrSetts[i] := fAvailExtrSetts[i + 1];
    SetLength(fAvailExtrSetts,Length(fAvailExtrSetts) - 1);
  end
else raise Exception.CreateFmt('TILItemShopParsingSettings_Base.AvailExtractionSettingsDelete: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

procedure TILItemShopParsingSettings_Base.AvailExtractionSettingsClear;
begin
SetLength(fAvailExtrSetts,0);
end;

//------------------------------------------------------------------------------

Function TILItemShopParsingSettings_Base.PriceExtractionSettingsAdd: Integer;
begin
SetLength(fPriceExtrSetts,Length(fPriceExtrSetts) + 1);
Result := High(fPriceExtrSetts);
fPriceExtrSetts[Result].ExtractFrom := ilpefText;
fPriceExtrSetts[Result].ExtractionMethod := ilpemFirstInteger;
fPriceExtrSetts[Result].ExtractionData := '';
fPriceExtrSetts[Result].NegativeTag := '';
end;

//------------------------------------------------------------------------------

procedure TILItemShopParsingSettings_Base.PriceExtractionSettingsDelete(Index: Integer);
var
  i:  Integer;
begin
If (Index >= Low(fPriceExtrSetts)) and (Index <= High(fPriceExtrSetts)) then
  begin
    For i := Index to Pred(High(fPriceExtrSetts)) do
      fPriceExtrSetts[i] := fPriceExtrSetts[i + 1];
    SetLength(fPriceExtrSetts,Length(fPriceExtrSetts) - 1);
  end
else raise Exception.CreateFmt('TILItemShopParsingSettings_Base.PriceExtractionSettingsDelete: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

procedure TILItemShopParsingSettings_Base.PriceExtractionSettingsClear;
begin
SetLength(fPriceExtrSetts,0);
end;


end.
