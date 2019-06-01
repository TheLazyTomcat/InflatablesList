unit IL_ItemShop;

{$INCLUDE '.\IL_defs.inc'}

interface

uses
  AuxTypes,
  Graphics;

type
  TILItemShopHistoryItem = record
    Value:  Int32;
    Time:   TDateTIme;
  end;

  TILItemShopHistory = array of TILItemShopHistoryItem;

  TILItemShopUpdateResult = (
    ilisurSuccess,    // lime     ilurSuccess
    ilisurMildSucc,   // green    ilurSuccess on untracked
    ilisurDataFail,   // blue     ilurNoLink, ilurNoData
    ilisurSoftFail,   // yellow   ilurFailAvailSearch, ilurFailAvailValGet
    ilisurHardFail,   // orange   ilurFailSearch, ilurFailValGet
    ilisurCritical,   // red      ilurFailDown, ilurFailParse
    ilisurFatal);     // black    ilurFail, unknown state

Function IL_ItemShopUpdateResultToNum(UpdateResult: TILItemShopUpdateResult): Int32;
Function IL_NumToItemShopUpdateResult(Num: Int32): TILItemShopUpdateResult;

Function IL_ItemShopUpdateResultToColor(UpdateResult: TILItemShopUpdateResult): TColor;

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

Function IL_ItemShopUpdateResultToNum(UpdateResult: TILItemShopUpdateResult): Int32;
begin
case UpdateResult of
  ilisurMildSucc: Result := 1;
  ilisurDataFail: Result := 2;
  ilisurSoftFail: Result := 3;
  ilisurHardFail: Result := 4;
  ilisurCritical: Result := 5;
  ilisurFatal:    Result := 6;
else
 {ilisurSuccess}
  Result := 0;
end;
end;

//------------------------------------------------------------------------------

Function IL_NumToItemShopUpdateResult(Num: Int32): TILItemShopUpdateResult;
begin
case Num of
  1:  Result := ilisurMildSucc;
  2:  Result := ilisurDataFail;
  3:  Result := ilisurSoftFail;
  4:  Result := ilisurHardFail;
  5:  Result := ilisurCritical;
  6:  Result := ilisurFatal;
else
  Result := ilisurSuccess;
end;
end;

//------------------------------------------------------------------------------

Function IL_ItemShopUpdateResultToColor(UpdateResult: TILItemShopUpdateResult): TColor;
begin
case UpdateResult of
  ilisurMildSucc: Result := clGreen;
  ilisurDataFail: Result := clBlue;
  ilisurSoftFail: Result := clYellow;
  ilisurHardFail: Result := $00409BFF;  // orange
  ilisurCritical: Result := clRed;
  ilisurFatal:    Result := clBlack;
else
 {ilisurSuccess}
  Result := clLime;
end;
end;

//==============================================================================

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
