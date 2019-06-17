unit IL_ItemShopTemplate_Base;

{$INCLUDE '.\IL_defs.inc'}

interface

uses
  IL_Types, IL_ItemShopParsingSettings, IL_ItemShop;

type
  TILItemShopTemplate_Base = class(TObject)
  protected
    // internals
    fStaticOptions:   TILStaticManagerOptions;
    // data
    fName:            String;
    fShopName:        String;
    fUntracked:       Boolean;
    fAltDownMethod:   Boolean;
    fShopURL:         String;
    fParsingSettings: TILItemShopParsingSettings;
    procedure SetStaticOptions(Value: TILStaticManagerOptions); virtual;
    procedure Initialize; virtual;
    procedure Finalize; virtual;
  public
    constructor Create; overload;
    constructor Create(BaseOn: TILItemShop); overload;
    destructor Destroy; override;
    procedure CopyTo(Shop: TILItemShop); virtual;
    property StaticOptions: TILStaticManagerOptions read fStaticOptions write SetStaticOptions;
    property Name: String read fName write fName;
    property ShopName: String read fShopName write fShopName;
    property Untracked: Boolean read fUntracked write fUntracked;
    property AltDownMethod: Boolean read fAltDownMethod write fAltDownMethod;
    property ShopURL: String read fShopURL write fShopURL;
    property ParsingSettings: TILItemShopParsingSettings read fParsingSettings;
  end;

implementation

uses
  SysUtils;

procedure TILItemShopTemplate_Base.SetStaticOptions(Value: TILStaticManagerOptions);
begin
fStaticOptions := IL_ThreadSafeCopy(Value);
end;

//------------------------------------------------------------------------------

procedure TILItemShopTemplate_Base.Initialize;
begin
fStaticOptions.NoPictures := False;
fStaticOptions.TestCode := False;
fStaticOptions.SavePages := False;
fStaticOptions.LoadPages := False;
fName := '';
fShopName := '';
fUntracked := False;
fAltDownMethod := False;
fShopURL := '';
fParsingSettings := TILItemShopParsingSettings.Create;
end;

//------------------------------------------------------------------------------

procedure TILItemShopTemplate_Base.Finalize;
begin
FreeAndNil(fParsingSettings);
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
fStaticOptions := IL_ThreadSafeCopy(BaseOn.StaticOptions);
fName := '';
fShopName := BaseOn.Name;
UniqueString(fShopName);
fUntracked := BaseOn.Untracked;
fAltDownMethod := BaseOn.AltDownMethod;
fShopURL := BaseOn.ShopURL;
UniqueString(fShopURL);
fParsingSettings := TILItemShopParsingSettings.CreateAsCopy(BaseOn.ParsingSettings);
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
Shop.BeginListUpdate;
try
  Shop.Name := fShopName;
  Shop.Untracked := fUntracked;
  Shop.AltDownMethod := fAltDownMethod;
  Shop.ShopURL := fShopURL;
  // variables (copy only when destination is empty)
  For i := 0 to Pred(Shop.ParsingSettings.VariableCount) do
    If Length(Shop.ParsingSettings.Variables[i]) <= 0 then
      Shop.ParsingSettings.Variables[i] := fParsingSettings.Variables[i];
  Shop.ParsingSettings.TemplateReference := fParsingSettings.TemplateReference;
  Shop.ParsingSettings.DisableParsingErrors := fParsingSettings.DisableParsingErrors;
finally
  Shop.EndListUpdate;
end;
end;

end.
