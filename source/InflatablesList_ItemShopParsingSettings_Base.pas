unit InflatablesList_ItemShopParsingSettings_Base;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  AuxTypes,
  InflatablesList_Types,
  InflatablesList_HTML_ElementFinder;

type
  TILItemShopParsingSettings_Base = class(TObject)
  protected
    // internals
    fStaticOptions:   TILStaticManagerOptions;
    fRequiredCount:   UInt32;    
    // data
    fVariables:       TILItemShopParsingVariables;
    fTemplateRef:     String;
    fDisableParsErrs: Boolean;
    fAvailExtrSetts:  TILItemShopParsingExtrSettList;
    fAvailFinder:     TILElementFinder;
    fPriceExtrSetts:  TILItemShopParsingExtrSettList;
    fPriceFinder:     TILElementFinder;
    procedure SetStaticOptions(Value: TILStaticManagerOptions); virtual;
    procedure SetRequiredCount(Value: Uint32); virtual;
    // data getters and setters
    Function GetVariableCount: Integer; virtual;
    Function GetVariable(Index: Integer): String; virtual;
    procedure SetVariable(Index: Integer; const Value: String); virtual;
    procedure SetTemplateRef(const Value: String); virtual;
    procedure SetDisableParsErrs(Value: Boolean); virtual;
    Function GetAvailExtrSettCount: Integer; virtual;
    Function GetAvailExtrSett(Index: Integer): TILItemShopParsingExtrSett; virtual;
    procedure SetAvailExtrSett(Index: Integer; Value: TILItemShopParsingExtrSett); virtual;
    Function GetPriceExtrSettCount: Integer; virtual;
    Function GetPriceExtrSett(Index: Integer): TILItemShopParsingExtrSett; virtual;
    procedure SetPriceExtrSett(Index: Integer; Value: TILItemShopParsingExtrSett); virtual;
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
    property StaticOptions: TILStaticManagerOptions read fStaticOptions write SetStaticOptions;
    property RequiredCount: UInt32 read fRequiredCount write SetRequiredCount;
    // data
    property VariableCount: Integer read GetVariableCount;
    property Variables[Index: Integer]: String read GetVariable write SetVariable;
    property VariablesRec: TILItemShopParsingVariables read fVariables;
    property TemplateReference: String read fTemplateRef write SetTemplateRef;
    property DisableParsingErrors: Boolean read fDisableParsErrs write SetDisableParsErrs;
    property AvailExtractionSettingsCount: Integer read GetAvailExtrSettCount;
    property AvailExtractionSettings[Index: Integer]: TILItemShopParsingExtrSett read GetAvailExtrSett write SetAvailExtrSett;
    property AvailFinder: TILElementFinder read fAvailFinder;
    property PriceExtractionSettingsCount: Integer read GetPriceExtrSettCount;
    property PriceExtractionSettings[Index: Integer]: TILItemShopParsingExtrSett read GetPriceExtrSett write SetPriceExtrSett;
    property PriceFinder: TILElementFinder read fPriceFinder;    
  end;

implementation

uses
  SysUtils;

procedure TILItemShopParsingSettings_Base.SetStaticOptions(Value: TILStaticManagerOptions);
begin
fStaticOptions := IL_ThreadSafeCopy(Value);
end;

//------------------------------------------------------------------------------

procedure TILItemShopParsingSettings_Base.SetRequiredCount(Value: Uint32);
begin
If fRequiredCount <> Value then
  begin
    fRequiredCount := Value;
  end;
end;

//------------------------------------------------------------------------------

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
  begin
    If not AnsiSameStr(fVariables.Vars[Index],Value) then
      begin
        fVariables.Vars[Index] := Value;
        UniqueString(fVariables.Vars[Index]);
      end;
  end
else raise Exception.CreateFmt('TILItemShopParsingSettings_Base.SetVariable: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

procedure TILItemShopParsingSettings_Base.SetTemplateRef(const Value: String);
begin
If not AnsiSameStr(fTemplateRef,Value) then
  begin
    fTemplateRef := Value;
    UniqueString(fTemplateRef);
  end;
end;

//------------------------------------------------------------------------------

procedure TILItemShopParsingSettings_Base.SetDisableParsErrs(Value: Boolean);
begin
If fDisableParsErrs <> Value then
  begin
    fDisableParsErrs := Value;
  end;
end;

//------------------------------------------------------------------------------

Function TILItemShopParsingSettings_Base.GetAvailExtrSettCount: Integer;
begin
Result := Length(fAvailExtrSetts);
end;

//------------------------------------------------------------------------------

Function TILItemShopParsingSettings_Base.GetAvailExtrSett(Index: Integer): TILItemShopParsingExtrSett;
begin
If (Index >= Low(fAvailExtrSetts)) and (Index <= High(fAvailExtrSetts)) then
  Result := fAvailExtrSetts[Index]
else
  raise Exception.CreateFmt('TILItemShopParsingSettings_Base.GetAvailExtrSett: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

procedure TILItemShopParsingSettings_Base.SetAvailExtrSett(Index: Integer; Value: TILItemShopParsingExtrSett);
begin
If (Index >= Low(fAvailExtrSetts)) and (Index <= High(fAvailExtrSetts)) then
  fAvailExtrSetts[Index] := IL_ThreadSafeCopy(Value)
else
  raise Exception.CreateFmt('TILItemShopParsingSettings_Base.SetAvailExtrSett: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

Function TILItemShopParsingSettings_Base.GetPriceExtrSettCount: Integer;
begin
Result := Length(fPriceExtrSetts);
end;

//------------------------------------------------------------------------------

Function TILItemShopParsingSettings_Base.GetPriceExtrSett(Index: Integer): TILItemShopParsingExtrSett;
begin
If (Index >= Low(fPriceExtrSetts)) and (Index <= High(fPriceExtrSetts)) then
  Result := fPriceExtrSetts[Index]
else
  raise Exception.CreateFmt('TILItemShopParsingSettings_Base.GetPriceExtrSett: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

procedure TILItemShopParsingSettings_Base.SetPriceExtrSett(Index: Integer; Value: TILItemShopParsingExtrSett);
begin
If (Index >= Low(fPriceExtrSetts)) and (Index <= High(fPriceExtrSetts)) then
  fPriceExtrSetts[Index] := IL_ThreadSafeCopy(Value)
else
  raise Exception.CreateFmt('TILItemShopParsingSettings_Base.SetPriceExtrSett: Index (%d) out of bounds.',[Index]);
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
FillChar(fStaticOptions,SizeOf(TILStaticManagerOptions),0);
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
fStaticOptions := IL_ThreadSafeCopy(Source.StaticOptions);
fRequiredCount := Source.RequiredCount;
// copy data
fVariables := IL_ThreadSafeCopy(Source.VariablesRec);
fTemplateRef := Source.TemplateReference;
UniqueString(fTemplateRef);
fDisableParsErrs := Source.DisableParsingErrors;
SetLength(fAvailExtrSetts,Source.AvailExtractionSettingsCount);
For i := Low(fAvailExtrSetts) to High(fAvailExtrSetts) do
  fAvailExtrSetts[i] := IL_ThreadSafeCopy(Source.AvailExtractionSettings[i]);
fAvailFinder := TILElementFinder.CreateAsCopy(Source.AvailFinder);
SetLength(fPriceExtrSetts,Source.PriceExtractionSettingsCount);
For i := Low(fPriceExtrSetts) to High(fPriceExtrSetts) do
  fPriceExtrSetts[i] := IL_ThreadSafeCopy(Source.PriceExtractionSettings[i]);
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
