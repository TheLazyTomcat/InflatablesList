unit IL_ItemShop;

{$INCLUDE '.\IL_defs.inc'}

interface

uses
  AuxTypes,
  IL_Types;

type
  TILItemShop = class(TObject)
  protected
    // data
    fSelected:        Boolean;
    fUntracked:       Boolean;
    fAltDownMethod:   Boolean;
    fName:            String;
    fShopURL:         String;
    fItemURL:         String;
    fAvailable:       Int32;
    fPrice:           UInt32;
    fAvailHistory:    TILItemShopHistory;
    fPriceHistory:    TILItemShopHistory;
    fNotes:           String;
    // parsing stuff
    //fParsingSettings: TILItemShopParsingSetting;
    fLastUpdateRes:   TILItemShopUpdateResult;
    fLastUpdateMsg:   String;
    // internals
    //fRequiredCount:   UInt32;   // used internally in updates, ignored otherwise
    // data getters and setters
    procedure SetSelected(Value: Boolean); virtual;
    procedure SetUntracked(Value: Boolean); virtual;
    procedure SetAltDownMethod(Value: Boolean); virtual;
    procedure SetName(const Value: String); virtual;
    procedure SetShopURL(const Value: String); virtual;
    procedure SetItemURL(const Value: String); virtual;
    procedure SetAvailable(Value: Int32); virtual;
    procedure SetPrice(Value: UInt32); virtual;
    procedure SetNotes(const Value: String); virtual;
    // other protected methods
    //procedure InitializeData; virtual;
    //procedure FinalizeData; virtual;
    //procedure Initialize; virtual;
    //procedure Finalize; virtual;
  public
    constructor Create; overload;
    constructor CreateAsCopy(Source: TILItemShop); overload;
    //procedure SetRequiredCount(Count: UInt32); virtual;
    property Selected: Boolean read fSelected write SetSelected;
    property Untracked: Boolean read fUntracked write SetUntracked;
    property AltDownMethod: Boolean read fAltDownMethod write SetAltDownMethod;
    property Name: String read fName write SetName;
    property ShopURL: String read fShopURL write SetShopURL;
    property ItemURL: String read fItemURL write SetItemURL;
    property Available: Int32 read fAvailable write SetAvailable;
    property Price: UInt32 read fPrice write SetPrice;
    //property AvailHistory: TILItemShopHistory;
    //property PriceHistory: TILItemShopHistory;
    property Notes: String read fNotes write SetNotes;
    // parsing
    property LastUpdateRes: TILItemShopUpdateResult read fLastUpdateRes;
    property LastUpdateMsg: String read fLastUpdateMsg;
  end;

implementation

uses
  SysUtils;

procedure TILItemShop.SetSelected(Value: Boolean);
begin
If fSelected <> Value then
  begin
    fSelected := Value;
  end;
end;

//------------------------------------------------------------------------------

procedure TILItemShop.SetUntracked(Value: Boolean);
begin
If fUntracked <> Value then
  begin
    fUntracked := Value;
  end;
end;

//------------------------------------------------------------------------------

procedure TILItemShop.SetAltDownMethod(Value: Boolean);
begin
If fAltDownMethod <> Value then
  begin
    fAltDownMethod := Value;
  end;
end;
 
//------------------------------------------------------------------------------

procedure TILItemShop.SetName(const Value: String);
begin
If not AnsiSameStr(fName,Value) then
  begin
    fName := Value;
  end;
end;
 
//------------------------------------------------------------------------------

procedure TILItemShop.SetShopURL(const Value: String);
begin
If not AnsiSameStr(fShopURL,Value) then
  begin
    fShopURL := Value;
  end;
end;
  
//------------------------------------------------------------------------------

procedure TILItemShop.SetItemURL(const Value: String);
begin
If not AnsiSameStr(fItemURL,Value) then
  begin
    fItemURL := Value;
  end;
end;
   
//------------------------------------------------------------------------------

procedure TILItemShop.SetAvailable(Value: Int32);
begin
If fAvailable <> Value then
  begin
    fAvailable := Value;
  end;
end;
 
//------------------------------------------------------------------------------

procedure TILItemShop.SetPrice(Value: UInt32);
begin
If fPrice <> Value then
  begin
    fPrice := Value;
  end;
end;

//------------------------------------------------------------------------------

procedure TILItemShop.SetNotes(const Value: String);
begin
If not AnsiSameStr(fNotes,Value) then
  begin
    fNotes := Value;
  end;
end;

(*
procedure TILItemShop.SetRequiredCount(Count: UInt32);
begin
fRequiredCount := Count;
end;
*)

//==============================================================================

constructor TILItemShop.Create;
begin
inherited Create;
end;

//------------------------------------------------------------------------------

constructor TILItemShop.CreateAsCopy(Source: TILItemShop);
begin
Create;
end;

end.
