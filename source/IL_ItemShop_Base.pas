unit IL_ItemShop_Base;

{$INCLUDE '.\IL_defs.inc'}

interface

uses
  Classes,
  AuxTypes,
  IL_Types, IL_ItemShopParsingSettings;

type
  TILItemShop_Base = class(TObject)
  protected
    // events
    fOnListUpdate:    TNotifyEvent;
    fOnAvailHistUpd:  TNotifyEvent;
    fOnPriceHistUpd:  TNotifyEvent;
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
    fParsingSettings: TILItemShopParsingSettings;
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
    Function GetAvailHistoryEntryCount: Integer; virtual;
    Function GetAvailHistoryEntry(Index: Integer): TILItemShopHistoryEntry; virtual;
    Function GetPriceHistoryEntryCount: Integer; virtual;
    Function GetPriceHistoryEntry(Index: Integer): TILItemShopHistoryEntry; virtual;
    procedure SetNotes(const Value: String); virtual;
    // other protected methods
    procedure InitializeData; virtual;
    procedure FinalizeData; virtual;
    procedure Initialize; virtual;
    procedure Finalize; virtual;
    procedure UpdateList; virtual;
    procedure UpdateAvailHistory; virtual;
    procedure UpdatePriceHistory; virtual;
  public
    constructor Create; overload;
    constructor CreateAsCopy(Source: TILItemShop_Base); overload;
    destructor Destroy; override;
    // history
    Function AvailHistoryAdd: Integer; virtual;
    procedure AvailHistoryDelete(Index: Integer); virtual;
    procedure AvailHistoryClear; virtual;
    Function PriceHistoryAdd: Integer; virtual;
    procedure PriceHistoryDelete(Index: Integer); virtual;
    procedure PriceHistoryClear; virtual;
    procedure AvailPriceHistoryAdd; virtual;
    // properties
    property OnListUpdate: TNotifyEvent read fOnListUpdate write fOnListUpdate;
    property OnAvailHistoryUpdate: TNotifyEvent read fOnAvailHistUpd write fOnAvailHistUpd;
    property OnPriceHistoryUpdate: TNotifyEvent read fOnPriceHistUpd write fOnPriceHistUpd;
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
    property LastUpdateRes: TILItemShopUpdateResult read fLastUpdateRes;
    property LastUpdateMsg: String read fLastUpdateMsg;
  end;

implementation

uses
  SysUtils;

(*
procedure TILManager_Templates.ItemShopCopyForUpdate(const Src: TILItemShop_Base; out Dest: TILItemShop_Base);
var
  Index:  Integer;
begin
// make normal copy
ItemShopCopy(Src,Dest);
// resolve references
Index := ShopTemplateIndexOf(Dest.ParsingSettings.TemplateRef);
If Index >= 0 then
  with fShopTemplates[Index].ShopData.ParsingSettings do
    begin
      // reference found, set extraction settings and free current objects and copy the referenced
      Dest.ParsingSettings.Available.Extraction := Available.Extraction;
      Dest.ParsingSettings.Price.Extraction := Price.Extraction;
      SetLength(Dest.ParsingSettings.Available.Extraction,Length(Dest.ParsingSettings.Available.Extraction));
      SetLength(Dest.ParsingSettings.Price.Extraction,Length(Dest.ParsingSettings.Price.Extraction));
      FreeAndNil(Dest.ParsingSettings.Available.Finder);
      FreeAndNil(Dest.ParsingSettings.Price.Finder);
      Dest.ParsingSettings.Available.Finder := TILElementFinder.CreateAsCopy(TILElementFinder(Available.Finder));
      Dest.ParsingSettings.Price.Finder := TILElementFinder.CreateAsCopy(TILElementFinder(Price.Finder));
    end;
end;
*)

procedure TILItemShop_Base.SetSelected(Value: Boolean);
begin
If fSelected <> Value then
  begin
    fSelected := Value;
    UpdateList;
  end;
end;

//------------------------------------------------------------------------------

procedure TILItemShop_Base.SetUntracked(Value: Boolean);
begin
If fUntracked <> Value then
  begin
    fUntracked := Value;
    UpdateList;
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
If not AnsiSameStr(fName,Value) then
  begin
    fName := Value;
    UpdateList;
  end;
end;
 
//------------------------------------------------------------------------------

procedure TILItemShop_Base.SetShopURL(const Value: String);
begin
If not AnsiSameStr(fShopURL,Value) then
  begin
    fShopURL := Value;
  end;
end;
  
//------------------------------------------------------------------------------

procedure TILItemShop_Base.SetItemURL(const Value: String);
begin
If not AnsiSameStr(fItemURL,Value) then
  begin
    fItemURL := Value;
    UpdateList;
  end;
end;
   
//------------------------------------------------------------------------------

procedure TILItemShop_Base.SetAvailable(Value: Int32);
begin
If fAvailable <> Value then
  begin
    fAvailable := Value;
    UpdateList;
  end;
end;
 
//------------------------------------------------------------------------------

procedure TILItemShop_Base.SetPrice(Value: UInt32);
begin
If fPrice <> Value then
  begin
    fPrice := Value;
    UpdateList;
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
If not AnsiSameStr(fNotes,Value) then
  begin
    fNotes := Value;
  end;
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
InitializeData;
end;
 
//------------------------------------------------------------------------------

procedure TILItemShop_Base.Finalize;
begin
FinalizeData;
end;

//------------------------------------------------------------------------------

procedure TILItemShop_Base.UpdateList;
begin
If Assigned(fOnListUpdate) then
  fOnListUpdate(Self);
end;

//------------------------------------------------------------------------------

procedure TILItemShop_Base.UpdateAvailHistory;
begin
If Assigned(fOnAvailHistUpd) then
  fOnAvailHistUpd(Self);
end;

//------------------------------------------------------------------------------

procedure TILItemShop_Base.UpdatePriceHistory;
begin
If Assigned(fOnPriceHistUpd) then
  fOnPriceHistUpd(Self);
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
  fAvailHistory[i] := Source.AvailHistoryEntries[i];
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

procedure TILItemShop_Base.AvailPriceHistoryAdd;
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

end.
