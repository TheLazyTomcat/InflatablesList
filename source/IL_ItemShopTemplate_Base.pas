unit IL_ItemShopTemplate_Base;

{$INCLUDE '.\IL_defs.inc'}

interface

uses
  IL_ItemShopParsingSettings, IL_ItemShop;

type
  TILItemShopTemplate_Base = class(TObject)
  protected
    fName:            String;
    fShopName:        String;
    fShopURL:         String;
    fParsingSettings: TILItemShopParsingSettings;
    procedure Initialize; virtual;
    procedure Finalize; virtual;
  public
    constructor Create; overload;
    constructor Create(BaseOn: TILItemShop); overload;
    destructor Destroy; override;
    property Name: String read fName write fName;
    property ShopName: String read fShopName write fShopName;
    property ShopURL: String read fShopURL write fShopURL;
    property ParsingSettings: TILItemShopParsingSettings read fParsingSettings;
  end;

implementation

uses
  SysUtils;

procedure TILItemShopTemplate_Base.Initialize;
begin
fName := '';
fShopName := '';
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
fName := '';
fShopName := BaseOn.Name;
UniqueString(fShopName);
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

end.
