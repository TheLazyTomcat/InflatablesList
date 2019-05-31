unit IL_Manager_Base;

{$INCLUDE '.\IL_defs.inc'}

interface

uses
  AuxClasses, SimpleCmdLineParser,
  IL_Types, IL_Data, IL_Item;

type
  TILManager_Base = class(TCustomListObject)
  protected
    fDataProvider:  TILDataProvider;
    fFileName:      String;
    fSorting:       Boolean;
    // cmd options
    fCMDLineParser: TCLPParser;
    fOptions:       TILCMDManagerOptions;
    // main list
    fList:          array of TILItem;
    fCount:         Integer;
    Function GetCapacity: Integer; override;
    procedure SetCapacity(Value: Integer); override;
    Function GetCount: Integer; override;
    procedure SetCount(Value: Integer); override;
    Function GetItem(Index: Integer): TILITem; virtual;
  public
    Function LowIndex: Integer; override;
    Function HighIndex: Integer; override;
    property Items[Index: Integer]: TILItem read GetItem; default; 
  end;

implementation

uses
  SysUtils;

Function TILManager_Base.GetCapacity: Integer;
begin
Result := Length(fList);
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.SetCapacity(Value: Integer);
var
  i:  Integer;
begin
If Value < fCount then
  For i := Value to Pred(fCount) do
    fList[i].Free;
SetLength(fList,Value);
end;

//------------------------------------------------------------------------------

Function TILManager_Base.GetCount: Integer;
begin
Result := fCount;
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.SetCount(Value: Integer);
begin
// do nothing
end;

//==============================================================================

Function TILManager_Base.LowIndex: Integer;
begin
Result := Low(fList);
end;

//------------------------------------------------------------------------------

Function TILManager_Base.HighIndex: Integer;
begin
Result := Pred(fCount);
end;

//------------------------------------------------------------------------------

Function TILManager_Base.GetItem(Index: Integer): TILITem;
begin
If CheckIndex(Index) then
  Result := fList[Index]
else
  raise Exception.CreateFmt('TILManager_Base.GetItem: Index (%d) out of bounds.',[Index]);
end;

end.
