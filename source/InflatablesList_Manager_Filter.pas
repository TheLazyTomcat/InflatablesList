unit InflatablesList_Manager_Filter;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  InflatablesList_Types, InflatablesList_Manager_Sort;

type
  TILManager_Filter = class(TILManager_Sort)
  protected
    fFilterSettings:  TILFilterSettings;
  public
    Function ItemFilter(var Item: TILItem): Boolean; overload; virtual;
    procedure ItemFilter; overload; virtual;
    property FilterSettings: TILFilterSettings read fFilterSettings write fFilterSettings;
  end;

implementation

uses
  AuxTypes, BitOps;

Function TILManager_Filter.ItemFilter(var Item: TILItem): Boolean;
var
  FlagsMap:   UInt32;
  FlagsMask:  UInt32;
  i:          Integer;
  StateSet:   Boolean;
  State:      Boolean;  // true = filtered-in, false = filtered-out

  procedure CheckItemFlag(BitMask: UInt32; ItemFlag: TILItemFlag; FlagSet, FlagClr: TILFilterFlag);
  begin
    If FlagSet in fFilterSettings.Flags then
      begin
        SetFlagStateValue(FlagsMap,BitMask,ItemFlag in Item.Flags);
        SetFlagValue(FlagsMask,BitMask);
      end
    else If FlagClr in fFilterSettings.Flags then
      begin
        SetFlagStateValue(FlagsMap,BitMask,not(ItemFlag in Item.Flags));
        SetFlagValue(FlagsMask,BitMask);
      end
    else
      begin
        ResetFlagValue(FlagsMap,BitMask);
        ResetFlagValue(FlagsMask,BitMask);
      end;
  end;

begin
FlagsMap := 0;
FlagsMask := 0;
If fFilterSettings.Flags <> [] then
  begin
    CheckItemFlag($00000001,ilifOwned,ilffOwnedSet,ilffOwnedClr);
    CheckItemFlag($00000002,ilifWanted,ilffWantedSet,ilffWantedClr);
    CheckItemFlag($00000004,ilifOrdered,ilffOrderedSet,ilffOrderedClr);
    CheckItemFlag($00000008,ilifBoxed,ilffBoxedSet,ilffBoxedClr);
    CheckItemFlag($00000010,ilifElsewhere,ilffElsewhereSet,ilffElsewhereClr);
    CheckItemFlag($00000020,ilifUntested,ilffUntestedSet,ilffUntestedClr);
    CheckItemFlag($00000040,ilifTesting,ilffTestingSet,ilffTestingClr);
    CheckItemFlag($00000080,ilifTested,ilffTestedSet,ilffTestedClr);
    CheckItemFlag($00000100,ilifDamaged,ilffDamagedSet,ilffDamagedClr);
    CheckItemFlag($00000200,ilifRepaired,ilffRepairedSet,ilffRepairedClr);
    CheckItemFlag($00000400,ilifPriceChange,ilffPriceChangeSet,ilffPriceChangeClr);
    CheckItemFlag($00000800,ilifAvailChange,ilffAvailChangeSet,ilffAvailChangeClr);
    CheckItemFlag($00001000,ilifNotAvailable,ilffNotAvailableSet,ilffNotAvailableClr);
    CheckItemFlag($00002000,ilifLost,ilffLostSet,ilffLostClr);
  end;
StateSet := False;
State := False; // will be later set to true value
If FlagsMask <> 0 then
  begin
    For i := 0 to Ord(High(TILItemFlag)) do
      begin
        If FlagsMask and 1 <> 0 then
          begin
            If StateSet then
              begin
                case fFilterSettings.Operator of
                  ilfoOR:   State := State or (FlagsMap and 1 <> 0);
                  ilfoXOR:  State := State xor (FlagsMap and 1 <> 0);
                else
                 {ilfoAND}
                  State := State and (FlagsMap and 1 <> 0);
                end;
              end
            else
              begin
                State := FlagsMap and 1 <> 0;
                StateSet := True;
              end;
          end;
        FlagsMap := FlagsMap shr 1;
        FlagsMask := FlagsMask shr 1;
      end;
  end
else State := True;
Item.FilteredOut := not State;
Result := Item.FilteredOut;
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

procedure TILManager_Filter.ItemFilter;
var
  i:  Integer;
begin
For i := Low(fList) to High(fList) do
  ItemFilter(fList[i]);
end;

end.
