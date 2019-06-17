unit InflatablesList_Manager_Sort;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  InflatablesList_Types, InflatablesList_Manager_Base;

type
  TILManager_Sort = class(TILManager_Base)
  protected
    fReversedSort:    Boolean;
    fUsedSortSett:    TILSortingSettings;
    fDefaultSortSett: TILSortingSettings;
    fActualSortSett:  TILSortingSettings;
    fSortingProfiles: TILSortingProfiles;
    Function GetSortProfileCount: Integer;
    Function GetSortProfile(Index: Integer): TILSortingProfile;
    Function GetSortProfilePtr(Index: Integer): PILSortingProfile;
    procedure InitializeSortingSettings; virtual;
    procedure FinalizeSortingSettings; virtual;
    procedure Initialize; override;
    procedure Finalize; override;
    Function ItemCompare(Idx1,Idx2: Integer): Integer; virtual;
  public
    Function SortingProfileIndexOf(const Name: String): Integer; virtual;
    Function SortingProfileAdd(const Name: String): Integer; virtual;
    procedure SortingProfileRename(Index: Integer; const NewName: String); virtual;
    procedure SortingProfileExchange(Idx1,Idx2: Integer); virtual;
    procedure SortingProfileDelete(Index: Integer); virtual;
    procedure SortingProfileClear; virtual;
    procedure ItemSort(SortingProfile: Integer); overload; virtual;
    procedure ItemSort; overload; virtual;
    property ReversedSort: Boolean read fReversedSort write fReversedSort;
    property DefaultSortingSettings: TILSortingSettings read fDefaultSortSett write fDefaultSortSett;
    property ActualSortingSettings: TILSortingSettings read fActualSortSett write fActualSortSett;
    property SortingProfileCount: Integer read GetSortProfileCount;
    property SortingProfiles[Index: Integer]: TILSortingProfile read GetSortProfile;
    property SortingProfilePtrs[Index: Integer]: PILSortingProfile read GetSortProfilePtr;  
  end;

implementation

uses
  SysUtils,
  ListSorters,
  InflatablesList_Utils;

Function TILManager_Sort.GetSortProfileCount: Integer;
begin
Result := Length(fSortingProfiles);
end;

//------------------------------------------------------------------------------

Function TILManager_Sort.GetSortProfile(Index: Integer): TILSortingProfile;
begin
If (Index >= Low(fSortingProfiles)) and (Index <= High(fSortingProfiles)) then
  Result := fSortingProfiles[Index]
else
  raise Exception.CreateFmt('TILManager_Sort.GetSortProfile: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

Function TILManager_Sort.GetSortProfilePtr(Index: Integer): PILSortingProfile;
begin
If (Index >= Low(fSortingProfiles)) and (Index <= High(fSortingProfiles)) then
  Result := Addr(fSortingProfiles[Index])
else
  raise Exception.CreateFmt('TILManager_Sort.GetSortProfilePtr: Index (%d) out of bounds.',[Index]);
end;

//==============================================================================

procedure TILManager_Sort.InitializeSortingSettings;
begin
fSorting := False;
FillChar(fDefaultSortSett,SizeOf(fDefaultSortSett),0);
fDefaultSortSett.Count := 2;
fDefaultSortSett.Items[0].ItemValueTag := ilivtManufacturer;
fDefaultSortSett.Items[0].Reversed := False;
fDefaultSortSett.Items[1].ItemValueTag := ilivtID;
fDefaultSortSett.Items[1].Reversed := False;
fActualSortSett := fDefaultSortSett;
fUsedSortSett := fDefaultSortSett;
SetLength(fSortingProfiles,0);
end;

//------------------------------------------------------------------------------

procedure TILManager_Sort.FinalizeSortingSettings;
begin
SetLength(fSortingProfiles,0);
end;

//------------------------------------------------------------------------------

procedure TILManager_Sort.Initialize;
begin
inherited Initialize;
InitializeSortingSettings;
end;

//------------------------------------------------------------------------------

procedure TILManager_Sort.Finalize;
begin
FinalizeSortingSettings;
inherited Finalize;
end;

//------------------------------------------------------------------------------

Function TILManager_Sort.ItemCompare(Idx1,Idx2: Integer): Integer;
var
  i:  Integer;
begin
Result := 0;
If Idx1 <> Idx2 then
  begin
    For i := Low(fUsedSortSett.Items) to Pred(fUsedSortSett.Count) do
      with fUsedSortSett.Items[i] do
        Result := (Result shl 1) + fList[Idx1].Compare(fList[Idx2],ItemValueTag,Reversed);
    // stabilize sorting using indices
    If Result = 0 then
      Result := (Result shl 1) + IL_CompareInt32(fList[Idx1].Index,fList[Idx2].Index);
  end;
end;

//==============================================================================

Function TILManager_Sort.SortingProfileIndexOf(const Name: String): Integer;
var
  i:  Integer;
begin
Result := -1;
For i := Low(fSortingProfiles) to High(fSortingProfiles) do
  If AnsiSameText(fSortingProfiles[i].Name,Name) then
    begin
      Result := i;
      Break{For i};
    end;
end;

//------------------------------------------------------------------------------

Function TILManager_Sort.SortingProfileAdd(const Name: String): Integer;
begin
SetLength(fSortingProfiles,Length(fSortingProfiles) + 1);
Result := High(fSortingProfiles);
fSortingProfiles[Result].Name := Name;
FillChar(fSortingProfiles[Result].Settings,SizeOf(TILSortingSettings),0);
end;

//------------------------------------------------------------------------------

procedure TILManager_Sort.SortingProfileRename(Index: Integer; const NewName: String);
begin
If (Index >= Low(fSortingProfiles)) and (Index <= High(fSortingProfiles)) then
  fSortingProfiles[Index].Name := NewName
else
  raise Exception.CreateFmt('TILManager_Sort.SortingProfileRename: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

procedure TILManager_Sort.SortingProfileExchange(Idx1,Idx2: Integer);
var
  Temp: TILSortingProfile;
begin
If Idx1 <> Idx2 then
  begin
    // sanity checks
    If (Idx1 < Low(fSortingProfiles)) or (Idx1 > High(fSortingProfiles)) then
      raise Exception.CreateFmt('TILManager_Sort.SortingProfileExchange: First index (%d) out of bounds.',[Idx1]);
    If (Idx2 < Low(fSortingProfiles)) or (Idx2 > High(fSortingProfiles)) then
      raise Exception.CreateFmt('TILManager_Sort.SortingProfileExchange: Second index (%d) out of bounds.',[Idx2]);
    Temp := fSortingProfiles[Idx1];
    fSortingProfiles[Idx1] := fSortingProfiles[Idx2];
    fSortingProfiles[Idx2] := Temp;
  end;
end;

//------------------------------------------------------------------------------

procedure TILManager_Sort.SortingProfileDelete(Index: Integer);
var
  i:  Integer;
begin
If (Index >= Low(fSortingProfiles)) and (Index <= High(fSortingProfiles)) then
  begin
    For i := Index to Pred(High(fSortingProfiles)) do
      fSortingProfiles[Index] := fSortingProfiles[Index + 1];
    SetLength(fSortingProfiles,Length(fSortingProfiles) - 1);
  end
else raise Exception.CreateFmt('TILManager_Sort.SortingProfileDelete: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

procedure TILManager_Sort.SortingProfileClear;
begin
SetLength(fSortingProfiles,0);
end;

//------------------------------------------------------------------------------

procedure TILManager_Sort.ItemSort(SortingProfile: Integer);
var
  i:      Integer;
  Sorter: TListSorter;
begin
ReIndex;  // to be sure
case SortingProfile of
  -2: fUsedSortSett := fDefaultSortSett;
  -1: fUsedSortSett := fActualSortSett;
else
  If (SortingProfile >= Low(fSortingProfiles)) and (SortingProfile <= High(fSortingProfiles)) then
    fUsedSortSett := fSortingProfiles[SortingProfile].Settings
  else
    raise Exception.CreateFmt('TILManager_Sort.ItemSort: Invalid sorting profile index (%d).',[SortingProfile]);
end;
If fReversedSort then
  For i := Low(fUsedSortSett.Items) to Pred(fUsedSortSett.Count) do
    fUsedSortSett.Items[i].Reversed := not fUsedSortSett.Items[i].Reversed;
If Length(fList) > 1 then
  begin
    Sorter := TListQuickSorter.Create(ItemCompare,ItemExchange);
    try
      fSorting := True;
      try
        Sorter.Sort(ItemLowIndex,ItemHighIndex);
      finally
        fSorting := False;
      end;
    finally
      Sorter.Free;
    end;
    ReIndex;
  end;
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

procedure TILManager_Sort.ItemSort;
begin
ItemSort(-1);
end;

end.
