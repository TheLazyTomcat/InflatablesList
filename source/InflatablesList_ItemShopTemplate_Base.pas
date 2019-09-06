unit InflatablesList_ItemShopTemplate_Base;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  InflatablesList_Types,
  InflatablesList_ItemShop,
  InflatablesList_ItemShopParsingSettings;

type
  TILItemShopTemplate_Base = class(TObject)
  protected
    // internals
    fStaticSettings:  TILStaticManagerSettings;
    // data
    fName:            String;
    fShopName:        String;
    fUntracked:       Boolean;
    fAltDownMethod:   Boolean;
    fShopURL:         String;
    fParsingSettings: TILItemShopParsingSettings;
    procedure SetStaticSettings(Value: TILStaticManagerSettings); virtual;
    // data setters
    procedure SetName(const Value: String); virtual;
    procedure SetShopName(const Value: String); virtual;
    procedure SetUntracked(const Value: Boolean); virtual;
    procedure SetAltDownMethod(const Value: Boolean); virtual;
    procedure SetShopURL(const Value: String); virtual;
    procedure InitializeData; virtual;
    procedure FinalizeData; virtual;
    procedure Initialize; virtual;
    procedure Finalize; virtual;
  public
    constructor Create; overload;
    constructor Create(BaseOn: TILItemShop); overload;
    destructor Destroy; override;
    procedure CopyTo(Shop: TILItemShop); virtual;
    property StaticSettings: TILStaticManagerSettings read fStaticSettings write SetStaticSettings;
    property Name: String read fName write SetName;
    property ShopName: String read fShopName write SetShopName;
    property Untracked: Boolean read fUntracked write SetUntracked;
    property AltDownMethod: Boolean read fAltDownMethod write SetAltDownMethod;
    property ShopURL: String read fShopURL write SetShopURL;
    property ParsingSettings: TILItemShopParsingSettings read fParsingSettings;
  end;

implementation

uses
  SysUtils,
  InflatablesList_Utils;

procedure TILItemShopTemplate_Base.SetStaticSettings(Value: TILStaticManagerSettings);
begin
fStaticSettings := IL_ThreadSafeCopy(Value);
fParsingSettings.StaticSettings := fStaticSettings;
end;

//------------------------------------------------------------------------------

procedure TILItemShopTemplate_Base.SetName(const Value: String);
begin
If not IL_SameStr(fName,Value) then
  begin
    fName := Value;
    UniqueString(fName);    
    fParsingSettings.TemplateReference := fName;
  end;
end;

//------------------------------------------------------------------------------

procedure TILItemShopTemplate_Base.SetShopName(const Value: String);
begin
If not IL_SameStr(fShopName,Value) then
  begin
    fShopName := Value;
    UniqueString(fShopName);
  end;
end;

//------------------------------------------------------------------------------

procedure TILItemShopTemplate_Base.SetUntracked(const Value: Boolean);
begin
If fUntracked <> Value then
  begin
    fUntracked := Value;
  end;
end;

//------------------------------------------------------------------------------

procedure TILItemShopTemplate_Base.SetAltDownMethod(const Value: Boolean);
begin
If fAltDownMethod <> Value then
  begin
    fAltDownMethod := Value;
  end;
end;

//------------------------------------------------------------------------------

procedure TILItemShopTemplate_Base.SetShopURL(const Value: String);
begin
If not IL_SameStr(fShopURL,Value) then
  begin
    fShopURL := Value;
    UniqueString(fShopURL);
  end;
end;

//------------------------------------------------------------------------------

procedure TILItemShopTemplate_Base.InitializeData;
begin
fName := '';
fShopName := '';
fUntracked := False;
fAltDownMethod := False;
fShopURL := '';
fParsingSettings := TILItemShopParsingSettings.Create;
fParsingSettings.StaticSettings := fStaticSettings;
end;

//------------------------------------------------------------------------------

procedure TILItemShopTemplate_Base.FinalizeData;
begin
FreeAndNil(fParsingSettings);
end;

//------------------------------------------------------------------------------

procedure TILItemShopTemplate_Base.Initialize;
begin
FillChar(fStaticSettings,SizeOf(TILStaticManagerSettings),0);
InitializeData;
end;

//------------------------------------------------------------------------------

procedure TILItemShopTemplate_Base.Finalize;
begin
FinalizeData;
end;

//==============================================================================

constructor TILItemShopTemplate_Base.Create;
begin
inherited Create;
Initialize;
end;

//------------------------------------------------------------------------------

constructor TILItemShopTemplate_Base.Create(BaseOn: TILItemShop);
begin
inherited Create;
// do not call initialize
fStaticSettings := IL_ThreadSafeCopy(BaseOn.StaticSettings);
fName := BaseOn.Name;
UniqueString(fName);
fShopName := BaseOn.Name;
UniqueString(fShopName);
fUntracked := BaseOn.Untracked;
fAltDownMethod := BaseOn.AltDownMethod;
fShopURL := BaseOn.ShopURL;
UniqueString(fShopURL);
fParsingSettings := TILItemShopParsingSettings.CreateAsCopy(BaseOn.ParsingSettings);
fParsingSettings.StaticSettings := fStaticSettings;
fParsingSettings.TemplateReference := fName;  // reference self
end;

//------------------------------------------------------------------------------

destructor TILItemShopTemplate_Base.Destroy;
begin
Finalize;
inherited;
end;

//------------------------------------------------------------------------------

procedure TILItemShopTemplate_Base.CopyTo(Shop: TILItemShop);
var
  i:  Integer;
begin
Shop.BeginUpdate;
try
  Shop.Name := fShopName;
  Shop.Untracked := fUntracked;
  Shop.AltDownMethod := fAltDownMethod;
  Shop.ShopURL := fShopURL;
  // variables (copy only when destination is empty)
  For i := 0 to Pred(Shop.ParsingSettings.VariableCount) do
    If Length(Shop.ParsingSettings.Variables[i]) <= 0 then
      Shop.ParsingSettings.Variables[i] := fParsingSettings.Variables[i];
  // copy only reference to self, not actual parsing settings (objects)
  Shop.ParsingSettings.TemplateReference := fName;
  Shop.ParsingSettings.DisableParsingErrors := fParsingSettings.DisableParsingErrors;
finally
  Shop.EndUpdate;
end;
end;

end.
