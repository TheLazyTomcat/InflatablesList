unit InflatablesList_ItemShop_Base;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  AuxTypes, AuxClasses{for TNotifyEvent},
  InflatablesList_Types,
  InflatablesList_ItemShopParsingSettings;

type
  TILItemShopUpdateFlag = (ilisufClearSelected,ilisufOverviewUpdate,ilisufShopListItemUpdate,
                           ilisufValuesUpdate,ilisufAvailHistUpdate,ilisufPriceHistUpdate);
  
  TILItemShopUpdateFlags = set of TILItemShopUpdateFlag;

  TILItemShop_Base = class(TObject)
  protected
    // internals
    fStaticOptions:         TILStaticManagerOptions;
    fRequiredCount:         UInt32;   // used internally in updates, ignored otherwise
    fUpdateCounter:         Integer;
    fUpdated:               TILItemShopUpdateFlags;
    // internal events
    fOnClearSelected:       TNotifyEvent;
    fOnOverviewUpdate:      TNotifyEvent;
    fOnShopListItemUpdate:  TNotifyEvent;
    fOnValuesUpdate:        TNotifyEvent;
    fOnAvailHistUpdate:     TNotifyEvent;
    fOnPriceHistUpdate:     TNotifyEvent;    
    // data
    fSelected:              Boolean;
    fUntracked:             Boolean;
    fAltDownMethod:         Boolean;
    fName:                  String;
    fShopURL:               String;
    fItemURL:               String;
    fAvailable:             Int32;
    fPrice:                 UInt32;
    fAvailHistory:          TILItemShopHistory;
    fPriceHistory:          TILItemShopHistory;
    fNotes:                 String;
    // parsing stuff
    fParsingSettings:       TILItemShopParsingSettings;
    fLastUpdateRes:         TILItemShopUpdateResult;
    fLastUpdateMsg:         String;
    procedure SetRequiredCount(Value: UInt32); virtual;
    procedure SetStaticOptions(Value: TILStaticManagerOptions); virtual;
    // data getters and setters
    procedure SetSelected(Value: Boolean); virtual;
    procedure SetUntracked(Value: Boolean); virtual;
    procedure SetAltDownMethod(Value: Boolean); virtual;
    procedure SetName(const Value: String); virtual;
    procedure SetShopURL(const Value: String); virtual;
    procedure SetItemURL(const Value: String); virtual;
    procedure SetAvailable(Value: Int32); virtual;
    procedure SetPrice(Value: UInt32); virtual;
    Function GetAvailHistoryEntryCount: Integer; virtual;
    Function GetAvailHistoryEntry(Index: Integer): TILItemShopHistoryEntry; virtual;
    Function GetPriceHistoryEntryCount: Integer; virtual;
    Function GetPriceHistoryEntry(Index: Integer): TILItemShopHistoryEntry; virtual;
    procedure SetNotes(const Value: String); virtual;
    procedure SetLastUpdateRes(Value: TILItemShopUpdateResult); virtual;
    procedure SetLastUpdateMsg(const Value: String); virtual;
    // event callers
    procedure ClearSelected; virtual;
    procedure UpdateOverview; virtual;
    procedure UpdateShopListItem; virtual;
    procedure UpdateValues; virtual;
    procedure UpdateAvailHistory; virtual;
    procedure UpdatePriceHistory; virtual;
    // other protected methods
    procedure InitializeData; virtual;
    procedure FinalizeData; virtual;
    procedure Initialize; virtual;
    procedure Finalize; virtual;
  public
    constructor Create; overload;
    constructor CreateAsCopy(Source: TILItemShop_Base); overload;
    destructor Destroy; override;
    procedure BeginUpdate; virtual;
    procedure EndUpdate; virtual;
    // history
    Function AvailHistoryAdd: Integer; virtual;
    procedure AvailHistoryDelete(Index: Integer); virtual;
    procedure AvailHistoryClear; virtual;
    Function PriceHistoryAdd: Integer; virtual;
    procedure PriceHistoryDelete(Index: Integer); virtual;
    procedure PriceHistoryClear; virtual;
    procedure AvailAndPriceHistoryAdd; virtual;
    procedure UpdateAvailAndPriceHistory; virtual;
    // other methods
    procedure SetValues(const Msg: String; Res: TILItemShopUpdateResult; Avail: Int32; Price: UInt32);
    procedure ReplaceParsingSettings(Source: TILItemShopParsingSettings); virtual;
    procedure AssignInternalEvents(ClearSelected,OverviewUpdate,ShopListItemUpdate,
      ValuesUpdate,AvailHistUpdate,PriceHistUpdate: TNotifyEvent); virtual;
    procedure ClearInternalEvents; virtual;
    // properties
    property StaticOptions: TILStaticManagerOptions read fStaticOptions write SetStaticOptions;
    property RequiredCount: UInt32 read fRequiredCount write SetRequiredCount;
    // data
    property Selected: Boolean read fSelected write SetSelected;
    property Untracked: Boolean read fUntracked write SetUntracked;
    property AltDownMethod: Boolean read fAltDownMethod write SetAltDownMethod;
    property Name: String read fName write SetName;
    property ShopURL: String read fShopURL write SetShopURL;
    property ItemURL: String read fItemURL write SetItemURL;
    property Available: Int32 read fAvailable write SetAvailable;
    property Price: UInt32 read fPrice write SetPrice;
    property AvailHistoryEntryCount: Integer read GetAvailHistoryEntryCount;
    property AvailHistoryEntries[Index: Integer]: TILItemShopHistoryEntry read GetAvailHistoryEntry;
    property PriceHistoryEntryCount: Integer read GetPriceHistoryEntryCount;
    property PriceHistoryEntries[Index: Integer]: TILItemShopHistoryEntry read GetPriceHistoryEntry;
    property Notes: String read fNotes write SetNotes;
    property ParsingSettings: TILItemShopParsingSettings read fParsingSettings;
    property LastUpdateRes: TILItemShopUpdateResult read fLastUpdateRes write SetLastUpdateRes;
    property LastUpdateMsg: String read fLastUpdateMsg write SetLastUpdateMsg;
  end;

implementation

uses
  SysUtils,
  InflatablesList_Utils;

procedure TILItemShop_Base.SetStaticOptions(Value: TILStaticManagerOptions);
begin
fStaticOptions := IL_ThreadSafeCopy(Value);
fParsingSettings.StaticOptions := Value;
end;

//------------------------------------------------------------------------------

procedure TILItemShop_Base.SetRequiredCount(Value: UInt32);
begin
fRequiredCount := Value;
fParsingSettings.RequiredCount := Value;
end;

//------------------------------------------------------------------------------

procedure TILItemShop_Base.SetSelected(Value: Boolean);
begin
If fSelected <> Value then
  begin
    ClearSelected;
    fSelected := Value;
    UpdateOverview;
    UpdateShopListItem;
    UpdateValues;     
  end;
end;

//------------------------------------------------------------------------------

procedure TILItemShop_Base.SetUntracked(Value: Boolean);
begin
If fUntracked <> Value then
  begin
    fUntracked := Value;
    UpdateShopListItem;
  end;
end;

//------------------------------------------------------------------------------

procedure TILItemShop_Base.SetAltDownMethod(Value: Boolean);
begin
If fAltDownMethod <> Value then
  begin
    fAltDownMethod := Value;
  end;
end;
 
//------------------------------------------------------------------------------

procedure TILItemShop_Base.SetName(const Value: String);
begin
If not IL_SameStr(fName,Value) then
  begin
    fName := Value;
    UniqueString(fName);
    UpdateOverview;
    UpdateShopListItem;
  end;
end;
 
//------------------------------------------------------------------------------

procedure TILItemShop_Base.SetShopURL(const Value: String);
begin
If not IL_SameStr(fShopURL,Value) then
  begin
    fShopURL := Value;
    UniqueString(fShopURL);
  end;
end;
  
//------------------------------------------------------------------------------

procedure TILItemShop_Base.SetItemURL(const Value: String);
begin
If not IL_SameStr(fItemURL,Value) then
  begin
    fItemURL := Value;
    UniqueString(fItemURL);
    UpdateShopListItem;
  end;
end;
   
//------------------------------------------------------------------------------

procedure TILItemShop_Base.SetAvailable(Value: Int32);
begin
If fAvailable <> Value then
  begin
    fAvailable := Value;
    UpdateOverview;
    UpdateShopListItem;
    UpdateValues;    
  end;
end;
 
//------------------------------------------------------------------------------

procedure TILItemShop_Base.SetPrice(Value: UInt32);
begin
If fPrice <> Value then
  begin
    fPrice := Value;
    UpdateOverview;
    UpdateShopListItem;
    UpdateValues;
  end;
end;

//------------------------------------------------------------------------------

Function TILItemShop_Base.GetAvailHistoryEntryCount: Integer;
begin
Result := Length(fAvailHistory);
end;      

//------------------------------------------------------------------------------

Function TILItemShop_Base.GetAvailHistoryEntry(Index: Integer): TILItemShopHistoryEntry;
begin
If (Index >= Low(fAvailHistory)) and (Index <= High(fAvailHistory)) then
  Result := fAvailHistory[Index]
else
  raise Exception.CreateFmt('TILItemShop_Base.GetAvailHistoryItem: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

Function TILItemShop_Base.GetPriceHistoryEntryCount: Integer;
begin
Result := Length(fPriceHistory);
end;       

//------------------------------------------------------------------------------

Function TILItemShop_Base.GetPriceHistoryEntry(Index: Integer): TILItemShopHistoryEntry;
begin
If (Index >= Low(fPriceHistory)) and (Index <= High(fPriceHistory)) then
  Result := fPriceHistory[Index]
else
  raise Exception.CreateFmt('TILItemShop_Base.GetPriceHistoryItem: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

procedure TILItemShop_Base.SetNotes(const Value: String);
begin
If not IL_SameStr(fNotes,Value) then
  begin
    fNotes := Value;
    UniqueString(fNotes);
  end;
end;

//------------------------------------------------------------------------------

procedure TILItemShop_Base.SetLastUpdateRes(Value: TILItemShopUpdateResult);
begin
If fLastUpdateRes <> Value then
  begin
    fLastUpdateRes := Value;
  end;
end;

//------------------------------------------------------------------------------

procedure TILItemShop_Base.SetLastUpdateMsg(const Value: String);
begin
If not IL_SameStr(fLastUpdateMsg,Value) then
  begin
    fLastUpdateMsg := Value;
    UniqueString(fLastUpdateMsg);
    UpdateValues;     
  end;
end;

//------------------------------------------------------------------------------

procedure TILItemShop_Base.ClearSelected;
begin
If Assigned(fOnClearSelected) and (fUpdateCounter <= 0) then
  fOnClearSelected(Self);
Include(fUpdated,ilisufClearSelected);
end;

//------------------------------------------------------------------------------

procedure TILItemShop_Base.UpdateOverview;
begin
If Assigned(fOnOverviewUpdate) and (fUpdateCounter <= 0) then
  fOnOverviewUpdate(Self);
Include(fUpdated,ilisufOverviewUpdate);
end;

//------------------------------------------------------------------------------

procedure TILItemShop_Base.UpdateShopListItem;
begin
If Assigned(fOnShopListItemUpdate) and (fUpdateCounter <= 0) then
  fOnShopListItemUpdate(Self);
Include(fUpdated,ilisufShopListItemUpdate);
end;

//------------------------------------------------------------------------------

procedure TILItemShop_Base.UpdateValues;
begin
If Assigned(fOnValuesUpdate) and (fUpdateCounter <= 0) then
  fOnValuesUpdate(Self);
Include(fUpdated,ilisufValuesUpdate);
end;

//------------------------------------------------------------------------------

procedure TILItemShop_Base.UpdateAvailHistory;
begin
If Assigned(fOnAvailHistUpdate) and (fUpdateCounter <= 0) then
  fOnAvailHistUpdate(Self);
Include(fUpdated,ilisufAvailHistUpdate);
end;

//------------------------------------------------------------------------------

procedure TILItemShop_Base.UpdatePriceHistory;
begin
If Assigned(fOnPriceHistUpdate) and (fUpdateCounter <= 0) then
  fOnPriceHistUpdate(Self);
Include(fUpdated,ilisufPriceHistUpdate);
end;

//------------------------------------------------------------------------------

procedure TILItemShop_Base.InitializeData;
begin
fSelected := False;
fUntracked := False;
fAltDownMethod := False;
fName := '';
fShopURL := '';
fItemURL := '';
fAvailable := 0;
fPrice := 0;
SetLength(fAvailHistory,0);
SetLength(fPriceHistory,0);
fNotes := '';
fParsingSettings := TILItemShopParsingSettings.Create;
fParsingSettings.StaticOptions := fStaticOptions;
fParsingSettings.RequiredCount := fRequiredCount;
fLastUpdateRes := ilisurSuccess;
fLastUpdateMsg := '';
end;

//------------------------------------------------------------------------------

procedure TILItemShop_Base.FinalizeData;
begin
SetLength(fAvailHistory,0);
SetLength(fPriceHistory,0);
FreeAndNil(fParsingSettings);
end;

//------------------------------------------------------------------------------

procedure TILItemShop_Base.Initialize;
begin
FillChar(fStaticOptions,SizeOf(TILStaticManagerOptions),0);
fRequiredCount := 0;
fUpdateCounter := 0;
fUpdated := [];
InitializeData;
end;
 
//------------------------------------------------------------------------------

procedure TILItemShop_Base.Finalize;
begin
FinalizeData;
end;

//==============================================================================

constructor TILItemShop_Base.Create;
begin
inherited Create;
Initialize;
end;

//------------------------------------------------------------------------------

constructor TILItemShop_Base.CreateAsCopy(Source: TILItemShop_Base);
var
  i:  Integer;
begin
inherited Create;
// do not call initialize
fStaticOptions := IL_ThreadSafeCopy(Source.StaticOptions);
fRequiredCount := Source.RequiredCount;
fUpdateCounter := 0;
fUpdated := [];
// copy data...
fSelected := Source.Selected;
fUntracked := Source.Untracked;
fAltDownMethod := Source.AltDownMethod;
fName := Source.Name;
UniqueString(fName);
fShopURL := Source.ShopURL;
UniqueString(fShopURL);
fItemURL := Source.ItemURL;
UniqueString(fItemURL);
fAvailable := Source.Available;
fPrice := Source.Price;
SetLength(fAvailHistory,Source.AvailHistoryEntryCount);
For i := Low(fAvailHistory) to High(fAvailHistory) do
  fAvailHistory[i] := Source.AvailHistoryEntries[i];  // no need to care for thread safety
SetLength(fPriceHistory,Source.PriceHistoryEntryCount);
For i := Low(fPriceHistory) to High(fPriceHistory) do
  fPriceHistory[i] := Source.PriceHistoryEntries[i];
fNotes := Source.Notes;
UniqueString(fNotes);
// parsing stuff
fParsingSettings := TILItemShopParsingSettings.CreateAsCopy(Source.ParsingSettings);
fLastUpdateRes := Source.LastUpdateRes;
fLastUpdateMsg := Source.LastUpdateMsg;
UniqueString(fLastUpdateMsg);
end;

//------------------------------------------------------------------------------

destructor TILItemShop_Base.Destroy;
begin
Finalize;
inherited;
end;

//------------------------------------------------------------------------------

procedure TILItemShop_Base.BeginUpdate;
begin
If fUpdateCounter <= 0 then
  fUpdated := [];
Inc(fUpdateCounter);
end;

//------------------------------------------------------------------------------

procedure TILItemShop_Base.EndUpdate;
begin
Dec(fUpdateCounter);
If fUpdateCounter <= 0 then
  begin
    fUpdateCounter := 0;
    If ilisufClearSelected in fUpdated then
      ClearSelected;
    If ilisufOverviewUpdate in fUpdated then
      UpdateOverview;
    If ilisufShopListItemUpdate in fUpdated then
      UpdateShopListItem;
    If ilisufValuesUpdate in fUpdated then
      UpdateValues;
    If ilisufAvailHistUpdate in fUpdated then
      UpdateAvailHistory;
    If ilisufPriceHistUpdate in fUpdated then
      UpdatePriceHistory;
    fUpdated := [];
  end;
end;

//------------------------------------------------------------------------------

Function TILItemShop_Base.AvailHistoryAdd: Integer;
begin
Result := Length(fAvailHistory);
SetLength(fAvailHistory,Result + 1);
fAvailHistory[Result].Value := fAvailable;
fAvailHistory[Result].Time := Now;
UpdateAvailHistory;
end;

//------------------------------------------------------------------------------

procedure TILItemShop_Base.AvailHistoryDelete(Index: Integer);
var
  i:  Integer;
begin
If (Index >= Low(fAvailHistory)) and (Index <= High(fAvailHistory)) then
  begin
    For i := Index to Pred(High(fAvailHistory)) do
      fAvailHistory[i] := fAvailHistory[i + 1];
    SetLength(fAvailHistory,Length(fAvailHistory) - 1);
    UpdateAvailHistory;
  end
else raise Exception.CreateFmt('TILItemShop_Base.AvailHistoryDelete: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

procedure TILItemShop_Base.AvailHistoryClear;
begin
SetLength(fAvailHistory,0);
UpdateAvailHistory;
end;

//------------------------------------------------------------------------------

Function TILItemShop_Base.PriceHistoryAdd: Integer;
begin
Result := Length(fPriceHistory);
SetLength(fPriceHistory,Result + 1);
fPriceHistory[Result].Value := fPrice;
fPriceHistory[Result].Time := Now;
UpdatePriceHistory;
end;
 
//------------------------------------------------------------------------------

procedure TILItemShop_Base.PriceHistoryDelete(Index: Integer);
var
  i:  Integer;
begin
If (Index >= Low(fPriceHistory)) and (Index <= High(fPriceHistory)) then
  begin
    For i := Index to Pred(High(fPriceHistory)) do
      fPriceHistory[i] := fPriceHistory[i + 1];
    SetLength(fPriceHistory,Length(fPriceHistory) - 1);
    UpdatePriceHistory;
  end
else raise Exception.CreateFmt('TILItemShop_Base.PriceHistoryDelete: Index (%d) out of bounds.',[Index]);
end;
 
//------------------------------------------------------------------------------

procedure TILItemShop_Base.PriceHistoryClear;
begin
SetLength(fPriceHistory,0);
UpdatePriceHistory;
end;

//------------------------------------------------------------------------------

procedure TILItemShop_Base.AvailAndPriceHistoryAdd;
var
  CurrTime: TDateTime;
begin
CurrTime := Now;
SetLength(fAvailHistory,Length(fAvailHistory) + 1);
fAvailHistory[High(fAvailHistory)].Value := fAvailable;
fAvailHistory[High(fAvailHistory)].Time := CurrTime;
SetLength(fPriceHistory,Length(fPriceHistory) + 1);
fPriceHistory[High(fPriceHistory)].Value := fPrice;
fPriceHistory[High(fPriceHistory)].Time := CurrTime;
UpdateAvailHistory;
UpdatePriceHistory;
end;

//------------------------------------------------------------------------------

procedure TILItemShop_Base.UpdateAvailAndPriceHistory;
begin
If fPrice > 0 then
  begin
    // price is nonzero, add only when current price or avail differs from last
    // entry or there is no prior entry
    If (Length(fPriceHistory) <= 0) then
      AvailAndPriceHistoryAdd
    else If (fAvailHistory[High(fAvailHistory)].Value <> fAvailable) or
            (fPriceHistory[High(fPriceHistory)].Value <> Int32(fPrice)) then
      AvailAndPriceHistoryAdd;
  end
else
  begin
    // price is zero, add only when there is already a price entry and
    // current price or avail differs from last entry
    If (Length(fPriceHistory) > 0) then
      If ((fAvailHistory[High(fAvailHistory)].Value <> fAvailable) or
          (fPriceHistory[High(fPriceHistory)].Value <> Int32(fPrice))) then
        AvailAndPriceHistoryAdd;
  end;
end;

//------------------------------------------------------------------------------

procedure TILItemShop_Base.SetValues(const Msg: String; Res: TILItemShopUpdateResult; Avail: Int32; Price: UInt32);
begin
fAvailable := Avail;
fPrice := Price;
fLastUpdateRes := Res;
fLastUpdateMsg := Msg;
UniqueString(fLastUpdateMsg);
UpdateOverview;
UpdateShopListItem;
UpdateValues;
end;

//------------------------------------------------------------------------------

procedure TILItemShop_Base.ReplaceParsingSettings(Source: TILItemShopParsingSettings);
var
  Variables:  TILItemShopParsingVariables;
  i:          Integer;
begin
// keep variables
// no need to care for thread safety, strings are cured when assigned to new object
Variables := fParsingSettings.VariablesRec;
fParsingSettings.Free;
fParsingSettings := TILItemShopParsingSettings.CreateAsCopy(Source);
fParsingSettings.StaticOptions := fStaticOptions;
fParsingSettings.RequiredCount := fRequiredCount;
For i := 0 to Pred(fParsingSettings.VariableCount) do
  fParsingSettings.Variables[i] := Variables.Vars[i];
end;

//------------------------------------------------------------------------------

procedure TILItemShop_Base.AssignInternalEvents(ClearSelected,OverviewUpdate,
  ShopListItemUpdate,ValuesUpdate,AvailHistUpdate,PriceHistUpdate: TNotifyEvent);
begin
fOnClearSelected := IL_CheckHandler(ClearSelected);
fOnOverviewUpdate := IL_CheckHandler(OverviewUpdate);
fOnShopListItemUpdate := IL_CheckHandler(ShopListItemUpdate);
fOnValuesUpdate := IL_CheckHandler(ValuesUpdate);
fOnAvailHistUpdate := IL_CheckHandler(AvailHistUpdate);
fOnPriceHistUpdate := IL_CheckHandler(PriceHistUpdate);
end;
 
//------------------------------------------------------------------------------

procedure TILItemShop_Base.ClearInternalEvents;
begin
fOnClearSelected := nil;
fOnOverviewUpdate := nil;
fOnShopListItemUpdate := nil;
fOnValuesUpdate := nil;
fOnAvailHistUpdate := nil;
fOnPriceHistUpdate := nil;
end;

end.
