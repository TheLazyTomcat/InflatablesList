{-------------------------------------------------------------------------------

  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at http://mozilla.org/MPL/2.0/.

-------------------------------------------------------------------------------}
{===============================================================================

  Memory vector classes

  ©František Milt 2018-10-22

  Version 1.1.2

  Dependencies:
    AuxTypes    - github.com/ncs-sniper/Lib.AuxTypes
    AuxClasses  - github.com/ncs-sniper/Lib.AuxClasses
    StrRect     - github.com/ncs-sniper/Lib.StrRect
    ListSorters - github.com/ncs-sniper/Lib.ListSorters

===============================================================================}
(*******************************************************************************

  Not implemented as generic class mainly because of backward compatibility. To
  create a derived/specialized class from base class, replace @ClassName@ with a
  class identifier and @Type@ with identifier of used type in the following
  template. Also remember to implement proper comparison function for a chosen
  type.
  Optional methods are not required to be implemented, but they might be usefull
  in some instances (eg. when item contains reference-counted types, pointers
  or object references).

==  Declaration  ===============================================================
--------------------------------------------------------------------------------

  @ClassName@ = class(TMemVector)
  protected
    Function GetItem(Index: Integer): @Type@; virtual;
    procedure SetItem(Index: Integer; Value: @Type@); virtual;
  //procedure ItemInit(ItemPtr: Pointer); override;
  //procedure ItemFinal(ItemPtr: Pointer); override;
  //procedure ItemCopy(SrcItem,DstItem: Pointer); override;           
    Function ItemCompare(Item1,Item2: Pointer): Integer; override;
  //Function ItemEquals(Item1,Item2: Pointer): Boolean; override;
  public
    constructor Create; overload;
    constructor Create(Memory: Pointer; Count: Integer); overload;
    Function First: @Type@; reintroduce;
    Function Last: @Type@; reintroduce;
    Function IndexOf(Item: @Type@): Integer; reintroduce;
    Function Add(Item: @Type@): Integer; reintroduce;
    procedure Insert(Index: Integer; Item: @Type@); reintroduce;
    Function Remove(Item: @Type@): Integer; reintroduce;
    Function Extract(Item: @Type@): @Type@; reintroduce;
    property Items[Index: Integer]: @Type@ read GetItem write SetItem; default;
  end;

==  Implementation  ============================================================
--------------------------------------------------------------------------------

Function @ClassName@.GetItem(Index: Integer): @Type@;
begin
Result := @Type@(GetItemPtr(Index)^);
end;

//------------------------------------------------------------------------------

procedure @ClassName@.SetItem(Index: Integer; Value: @Type@);
begin
SetItemPtr(Index,@Value);
end;

//------------------------------------------------------------------------------

// Method called for each item that is implicitly (eg. when changing the Count
// property to a higher number) added to the vector.
// Item is filled with zeroes in default implementation.

//procedure @ClassName@.ItemInit(ItemPtr: Pointer); override;
//begin
//{$MESSAGE WARN 'Implement item initialization to suit actual type.'}
//end;

//------------------------------------------------------------------------------

// Method called for each item that is implicitly (e.g. when changing the Count
// property to a lower number) removed from the vector.
// No default behavior.

//procedure @ClassName@.ItemFinal(ItemPtr: Pointer); override;
//begin
//{$MESSAGE WARN 'Implement item finalization to suit actual type.'}
//end;

//------------------------------------------------------------------------------

// Called when an item is copied to the vector from an external source and
// ManagedCopy is set to true. Called only by methods that has parameter
// ManagedCopy.
// Item is copied without any further processing in default implementation.

//procedure @ClassName@.ItemCopy(SrcItem,DstItem: Pointer); override;
//begin
//{$MESSAGE WARN 'Implement item copy to suit actual type.'}
//end;

//------------------------------------------------------------------------------


// This method is called when there is a need to compare two items, for example
// when sorting the vector.
// Must return negative number when Item1 is higher/larger than Item2, zero when
// they are equal and positive number when Item1 is lower/smaller than Item2.
// No default implementation.
// This method must be implemented in derived classes!

Function @ClassName@.ItemCompare(Item1,Item2: Pointer): Integer;
begin
{$MESSAGE WARN 'Implement comparison to suit actual type.'}
end;

//------------------------------------------------------------------------------

// Called when two items are compared for equality (e.g. when searching for a
// particular item).
// In default implementation, it calls ItemCompare and when it returns zero,
// items are considered to be equal.

//Function @ClassName@.ItemEquals(Item1,Item2: Pointer): Boolean; override;
//begin
//{$MESSAGE WARN 'Implement equality comparison to suit actual type.'}
//end;

//==============================================================================

constructor @ClassName@.Create;
begin
inherited Create(SizeOf(@Type@));
end;

//   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---

constructor @ClassName@.Create(Memory: Pointer; Count: Integer);
begin
inherited Create(Memory,Count,SizeOf(@Type@));
end;

//------------------------------------------------------------------------------

Function @ClassName@.First: @Type@;
begin
Result := @Type@(inherited First^);
end;

//------------------------------------------------------------------------------

Function @ClassName@.Last: @Type@;
begin
Result := @Type@(inherited Last^);
end;

//------------------------------------------------------------------------------

Function @ClassName@.IndexOf(Item: @Type@): Integer;
begin
Result := inherited IndexOf(@Item);
end;

//------------------------------------------------------------------------------

Function @ClassName@.Add(Item: @Type@): Integer;
begin
Result := inherited Add(@Item);
end;
  
//------------------------------------------------------------------------------

procedure @ClassName@.Insert(Index: Integer; Item: @Type@);
begin
inherited Insert(Index,@Item);
end;
 
//------------------------------------------------------------------------------

Function @ClassName@.Remove(Item: @Type@): Integer;
begin
Result := inherited Remove(@Item);
end;
 
//------------------------------------------------------------------------------

Function @ClassName@.Extract(Item: @Type@): @Type@;
begin
Result := @Type@(inherited Extract(@Item)^);
end;

*******************************************************************************)
unit MemVector;

{$IFDEF FPC}
  {$MODE Delphi}
  {$DEFINE FPC_DisableWarns}
  {$MACRO ON}
{$ENDIF}

interface

uses
  Classes, AuxTypes, AuxClasses;

type
{===============================================================================
--------------------------------------------------------------------------------
                                   TMemVector
--------------------------------------------------------------------------------
===============================================================================}

{===============================================================================
    TMemVector - class declaration
===============================================================================}

  TMemVector = class(TCustomListObject)
  private
    fItemSize:      Integer;
    fOwnsMemory:    Boolean;
    fMemory:        Pointer;
    fCapacity:      Integer;
    fCount:         Integer;
    fChangeCounter: Integer;
    fChanged:       Boolean;
    fOnChange:      TNotifyEvent;
  protected
    fTempItem:      Pointer;
    Function GetCapacity: Integer; override;
    procedure SetCapacity(Value: Integer); override;
    Function GetCount: Integer; override;
    procedure SetCount(Value: Integer); override;
    Function GetItemPtr(Index: Integer): Pointer; virtual;
    procedure SetItemPtr(Index: Integer; Value: Pointer); virtual;
    Function GetSize: TMemSize; virtual;
    Function GetAllocatedSize: TMemSize; virtual;
    Function CheckIndexAndRaise(Index: Integer; CallingMethod: String = 'CheckIndexAndRaise'): Boolean; virtual;
    procedure RaiseError(const ErrorMessage: String; Values: array of const); overload; virtual;
    procedure RaiseError(const ErrorMessage: String); overload; virtual;
    Function GetNextItemPtr(ItemPtr: Pointer): Pointer; virtual;
    procedure ItemInit(Item: Pointer); virtual;
    procedure ItemFinal(Item: Pointer); virtual;
    procedure ItemCopy(SrcItem,DstItem: Pointer); virtual;
    Function ItemCompare(Item1,Item2: Pointer): Integer; virtual;
    Function ItemEquals(Item1,Item2: Pointer): Boolean; virtual;
    Function CompareItems(Index1,Index2: Integer): Integer; virtual;
    procedure FinalizeAllItems; virtual;
    procedure DoOnChange; virtual;
  public
    constructor Create(ItemSize: Integer); overload;
    constructor Create(Memory: Pointer; Count: Integer; ItemSize: Integer); overload;
    destructor Destroy; override;
    procedure BeginChanging; virtual;
    Function EndChanging: Integer; virtual;
    Function LowIndex: Integer; override;
    Function HighIndex: Integer; override;
    Function First: Pointer; virtual;
    Function Last: Pointer; virtual;
    Function IndexOf(Item: Pointer): Integer; virtual;
    Function Add(Item: Pointer): Integer; virtual;
    procedure Insert(Index: Integer; Item: Pointer); virtual;
    Function Remove(Item: Pointer): Integer; virtual;
    Function Extract(Item: Pointer): Pointer; virtual;
    procedure Delete(Index: Integer); virtual;
    procedure Move(SrcIndex,DstIndex: Integer); virtual;
    procedure Exchange(Index1,Index2: Integer); virtual;
    procedure Reverse; virtual;
    procedure Clear; virtual;
    procedure Sort(Reversed: Boolean = False); virtual;
    Function IsEqual(Vector: TMemVector): Boolean; virtual;
    Function EqualsBinary(Vector: TMemVector): Boolean; virtual;
    procedure Assign(Data: Pointer; Count: Integer; ManagedCopy: Boolean = False); overload; virtual;
    procedure Assign(Vector: TMemVector; ManagedCopy: Boolean = False); overload; virtual;
    procedure Append(Data: Pointer; Count: Integer; ManagedCopy: Boolean = False); overload; virtual;
    procedure Append(Vector: TMemVector; ManagedCopy: Boolean = False); overload; virtual;
    procedure SaveToStream(Stream: TStream); virtual;
    procedure LoadFromStream(Stream: TStream); virtual;
    procedure SaveToFile(const FileName: String); virtual;
    procedure LoadFromFile(const FileName: String); virtual;  
    property Memory: Pointer read fMemory;
    property Pointers[Index: Integer]: Pointer read GetItemPtr;
    property ItemSize: Integer read fItemSize;
    property OwnsMemory: Boolean read fOwnsMemory write fOwnsMemory;
    property Size: TMemSize read GetSize;
    property AllocatedSize: TMemSize read GetAllocatedSize;
    property OnChange: TNotifyEvent read fOnChange write fOnChange;
  end;

{===============================================================================
--------------------------------------------------------------------------------
                                 TIntegerVector
--------------------------------------------------------------------------------
===============================================================================}

{===============================================================================
    TIntegerVector - class declaration
===============================================================================}

  TIntegerVector = class(TMemVector)
  protected
    Function GetItem(Index: Integer): Integer; virtual;
    procedure SetItem(Index: Integer; Value: Integer); virtual;
    Function ItemCompare(Item1,Item2: Pointer): Integer; override;
  public
    constructor Create; overload;
    constructor Create(Memory: Pointer; Count: Integer); overload;
    Function First: Integer; reintroduce;
    Function Last: Integer; reintroduce;
    Function IndexOf(Item: Integer): Integer; reintroduce;
    Function Add(Item: Integer): Integer; reintroduce;
    procedure Insert(Index: Integer; Item: Integer); reintroduce;
    Function Remove(Item: Integer): Integer; reintroduce;
    Function Extract(Item: Integer): Integer; reintroduce;
    property Items[Index: Integer]: Integer read GetItem write SetItem; default;
  end;

implementation

uses
  SysUtils, StrRect, ListSorters;

{$IFDEF FPC_DisableWarns}
  {$DEFINE FPCDWM}
  {$DEFINE W4055:={$WARN 4055 OFF}} // Conversion between ordinals and pointers is not portable
  {$DEFINE W5024:={$WARN 5024 OFF}} // Parameter "$1" not used
{$ENDIF}

{===============================================================================
--------------------------------------------------------------------------------
                                   TMemVector
--------------------------------------------------------------------------------
===============================================================================}

{===============================================================================
    TMemVector - class declaration
===============================================================================}

{-------------------------------------------------------------------------------
    TMemVector - protected methods
-------------------------------------------------------------------------------}

Function TmemVector.GetCapacity: Integer;
begin
Result := fCapacity;
end;

//------------------------------------------------------------------------------

procedure TMemVector.SetCapacity(Value: Integer);
var
  i:  Integer;
begin
If fOwnsMemory then
  begin
    If (Value <> fCapacity) and (Value >= 0) then
      begin
        If Value < fCount then
          For i := Value to HighIndex do
            ItemFinal(GetItemPtr(i));
        ReallocMem(fMemory,TMemSize(Value) * TMemSize(fItemSize));
        fCapacity := Value;
        If Value < fCount then
          begin
            fCount := Value;
            DoOnChange;
          end;
      end;
  end
else RaiseError('SetCapacity: Operation not allowed for not owned memory.');
end;

//------------------------------------------------------------------------------

Function TmemVector.GetCount: Integer;
begin
Result := fCount;
end;

//------------------------------------------------------------------------------

procedure TMemVector.SetCount(Value: Integer);
var
  OldCount: Integer;
  i:        Integer;
begin
If fOwnsMemory then
  begin
    If (Value <> fCount) and (Value >= 0) then
      begin
        BeginChanging;
        try
          If Value > fCapacity then
            SetCapacity(Value);
          If Value > fCount then
            begin
              OldCount := fCount;
              fCount := Value;
              For i := OldCount to HighIndex do
                ItemInit(GetItemPtr(i));
            end
          else
            begin
              For i := HighIndex downto Value do
                ItemFinal(GetItemPtr(i));
              fCount := Value;
            end;
          DoOnChange;
        finally
          EndChanging;
        end;
      end;
  end
else RaiseError('SetCount: Operation not allowed for not owned memory.');
end;

//------------------------------------------------------------------------------

{$IFDEF FPCDWM}{$PUSH}W4055{$ENDIF}
Function TMemVector.GetItemPtr(Index: Integer): Pointer;
begin
Result := nil;
If CheckIndex(Index) then
  Result := Pointer(PtrUInt(fMemory) + PtrUInt(Index * fItemSize))
else
  RaiseError('GetItemPtr: Index (%d) out of bounds.',[Index]);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

//------------------------------------------------------------------------------

procedure TMemVector.SetItemPtr(Index: Integer; Value: Pointer);
begin
If CheckIndex(Index) then
  begin
    System.Move(GetItemPtr(Index)^,fTempItem^,fItemSize);
    System.Move(Value^,GetItemPtr(Index)^,fItemSize);
    If not ItemEquals(fTempItem,Value) then DoOnChange;
  end
else RaiseError('SetItemPtr: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

Function TMemVector.GetSize: TMemSize;
begin
Result := TMemSize(fCount) * TMemSize(fItemSize);
end;

//------------------------------------------------------------------------------

Function TMemVector.GetAllocatedSize: TMemSize;
begin
Result := TMemSize(fCapacity) * TMemSize(fItemSize);
end;

//------------------------------------------------------------------------------

Function TMemVector.CheckIndexAndRaise(Index: Integer; CallingMethod: String = 'CheckIndexAndRaise'): Boolean;
begin
Result := CheckIndex(Index);
If not Result then
  RaiseError('%s: Index (%d) out of bounds.',[CallingMethod,Index]);
end;

//------------------------------------------------------------------------------

procedure TMemVector.RaiseError(const ErrorMessage: String; Values: array of const);
begin
raise Exception.CreateFmt(Format('%s.%s',[Self.ClassName,ErrorMessage]),Values);
end;

//------------------------------------------------------------------------------

procedure TMemVector.RaiseError(const ErrorMessage: String);
begin
RaiseError(ErrorMessage,[]);
end;

//------------------------------------------------------------------------------

Function TMemVector.GetNextItemPtr(ItemPtr: Pointer): Pointer;
begin
{$IFDEF FPCDWM}{$PUSH}W4055{$ENDIF}
Result := Pointer(PtrUInt(ItemPtr) + PtrUInt(fItemSize));
{$IFDEF FPCDWM}{$POP}{$ENDIF}
end;

//------------------------------------------------------------------------------

procedure TMemVector.ItemInit(Item: Pointer);
begin
FillChar(Item^,fItemSize,0);
end;

//------------------------------------------------------------------------------

{$IFDEF FPCDWM}{$PUSH}W5024{$ENDIF}
procedure TMemVector.ItemFinal(Item: Pointer);
begin
// nothing to do here
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

//------------------------------------------------------------------------------

procedure TMemVector.ItemCopy(SrcItem,DstItem: Pointer);
begin
System.Move(SrcItem^,DstItem^,fItemSize);
end;

//------------------------------------------------------------------------------

Function TMemVector.ItemCompare(Item1,Item2: Pointer): Integer;
begin
{$IFDEF FPCDWM}{$PUSH}W4055{$ENDIF}
Result := Integer(PtrUInt(Item2) - PtrUInt(Item1));
{$IFDEF FPCDWM}{$POP}{$ENDIF}
end;

//------------------------------------------------------------------------------

Function TMemVector.ItemEquals(Item1,Item2: Pointer): Boolean;
begin
Result := ItemCompare(Item1,Item2) = 0;
end;

//------------------------------------------------------------------------------

Function TMemVector.CompareItems(Index1,Index2: Integer): Integer;
begin
Result := ItemCompare(GetItemPtr(Index1),GetItemPtr(Index2));
end;

//------------------------------------------------------------------------------

procedure TMemVector.FinalizeAllItems;
var
  i:  Integer;
begin
For i := LowIndex to HighIndex do
  ItemFinal(GetItemPtr(i));
end;

//------------------------------------------------------------------------------

procedure TMemVector.DoOnChange;
begin
fChanged := True;
If (fChangeCounter <= 0) and Assigned(fOnChange) then
  fOnChange(Self);
end;

{-------------------------------------------------------------------------------
    TMemVector - public methods
-------------------------------------------------------------------------------}

constructor TMemVector.Create(ItemSize: Integer);
begin
inherited Create;
If ItemSize <= 0 then
  RaiseError('Create: Size of the item must be larger than zero.');
fItemSize := ItemSize;
fOwnsMemory := True;
fMemory := nil;
fCapacity := 0;
fCount := 0;
fChangeCounter := 0;
fChanged := False;
fOnChange := nil;
GetMem(fTempItem,ItemSize);
end;

//   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---

constructor TMemVector.Create(Memory: Pointer; Count: Integer; ItemSize: Integer);
begin
Create(ItemSize);
fOwnsMemory := False;
fMemory := Memory;
fCapacity := Count;
fCount := Count;
end;

//------------------------------------------------------------------------------

destructor TMemVector.Destroy;
begin
FreeMem(fTempItem,fItemSize);
If fOwnsMemory then
  begin
    FinalizeAllItems;
    FreeMem(fMemory,TMemSize(fCapacity) * TMemSize(fItemSize));
  end;
inherited;
end;

//------------------------------------------------------------------------------

procedure TMemVector.BeginChanging;
begin
If fChangeCounter <= 0 then
  fChanged := False;
Inc(fChangeCounter);
end;

//------------------------------------------------------------------------------

Function TMemVector.EndChanging: Integer;
begin
Dec(fChangeCounter);
If fChangeCounter <= 0 then
  begin
    fChangeCounter := 0;
    If fChanged and Assigned(fOnChange) then
      fOnChange(Self);
    fChanged := False;
  end;
Result := fChangeCounter;
end;

//------------------------------------------------------------------------------

Function TMemVector.LowIndex: Integer;
begin
Result := 0;
end;

//------------------------------------------------------------------------------

Function TMemVector.HighIndex: Integer;
begin
Result := fCount - 1;
end;

//------------------------------------------------------------------------------

Function TMemVector.First: Pointer;
begin
Result := GetItemPtr(LowIndex);
end;

//------------------------------------------------------------------------------

Function TMemVector.Last: Pointer;
begin
Result := GetItemPtr(HighIndex);
end;

//------------------------------------------------------------------------------

Function TMemVector.IndexOf(Item: Pointer): Integer;
var
  i:  Integer;
begin
Result := -1;
For i := LowIndex to HighIndex do
  If ItemEquals(Item,GetItemPtr(i)) then
    begin
      Result := i;
      Exit;
    end;
end;
 
//------------------------------------------------------------------------------

Function TMemVector.Add(Item: Pointer): Integer;
begin
Result := -1;
If fOwnsMemory then
  begin
    Grow;
    Result := fCount;
    Inc(fCount);
    System.Move(Item^,GetItemPtr(Result)^,fItemSize);
    DoOnChange;
  end
else RaiseError('Add: Operation not allowed for not owned memory.');
end;

//------------------------------------------------------------------------------

procedure TMemVector.Insert(Index: Integer; Item: Pointer);
var
  InsertPtr:  Pointer;
begin
If fOwnsMemory then
  begin
    If CheckIndex(Index) then
      begin
        Grow;
        InsertPtr := GetItemPtr(Index);
        System.Move(InsertPtr^,GetNextItemPtr(InsertPtr)^,fItemSize * (fCount - Index));
        System.Move(Item^,InsertPtr^,fItemSize);
        Inc(fCount);
        DoOnChange;
      end
    else
      begin
        If Index >= fCount then
          Add(Item)
        else
          RaiseError('Insert: Index (%d) out of bounds.',[Index]);
      end;
  end
else RaiseError('Insert: Operation not allowed for not owned memory.');
end;

//------------------------------------------------------------------------------

Function TMemVector.Remove(Item: Pointer): Integer;
begin
Result := -1;
If fOwnsMemory then
  begin
    Result := IndexOf(Item);
    If Result >= 0 then
      Delete(Result);
  end
else RaiseError('Remove: Operation not allowed for not owned memory.');
end;

//------------------------------------------------------------------------------

Function TMemVector.Extract(Item: Pointer): Pointer;
var
  Index:  Integer;
begin
Result := nil;
If fOwnsMemory then
  begin
    Index := IndexOf(Item);
    If Index >= 0 then
      begin
        System.Move(GetItemPtr(Index)^,fTempItem^,fItemSize);
        Delete(Index);
        Result := fTempItem;
      end
    else RaiseError('Extract: Requested item not found.');
  end
else RaiseError('Extract: Operation not allowed for not owned memory.');
end;

//------------------------------------------------------------------------------

procedure TMemVector.Delete(Index: Integer);
var
  DeletePtr: Pointer;
begin
If fOwnsMemory then
  begin
    If CheckIndex(Index) then
      begin
        DeletePtr := GetItemPtr(Index);
        ItemFinal(DeletePtr);
        If Index < Pred(fCount) then
          System.Move(GetNextItemPtr(DeletePtr)^,DeletePtr^,fItemSize * Pred(fCount - Index));
        Dec(fCount);
        Shrink;
        DoOnChange;
      end
    else RaiseError('Delete: Index (%d) out of bounds.',[Index]);
  end
else RaiseError('Delete: Operation not allowed for not owned memory.');
end;

//------------------------------------------------------------------------------

procedure TMemVector.Move(SrcIndex,DstIndex: Integer);
var
  SrcPtr: Pointer;
  DstPtr: Pointer;
begin
If CheckIndexAndRaise(SrcIndex,'Move') and CheckIndexAndRaise(DstIndex,'Move') then
  If SrcIndex <> DstIndex then
    begin
      SrcPtr := GetItemPtr(SrcIndex);
      DstPtr := GetItemPtr(DstIndex);
      System.Move(SrcPtr^,fTempItem^,fItemSize);
      If SrcIndex < DstIndex then
        System.Move(GetNextItemPtr(SrcPtr)^,SrcPtr^,fItemSize * (DstIndex - SrcIndex))
      else
        System.Move(DstPtr^,GetNextItemPtr(DstPtr)^,fItemSize * (SrcIndex - DstIndex));
      System.Move(fTempItem^,DstPtr^,fItemSize);
      DoOnChange;
    end;
end;

//------------------------------------------------------------------------------

procedure TMemVector.Exchange(Index1,Index2: Integer);
var
  Idx1Ptr:  Pointer;
  Idx2Ptr:  Pointer;
begin
If CheckIndexAndRaise(Index1,'Exchange') and CheckIndexAndRaise(Index2,'Exchange') then
  If Index1 <> Index2 then
    begin
      Idx1Ptr := GetItemPtr(Index1);
      Idx2Ptr := GetItemPtr(Index2);
      System.Move(Idx1Ptr^,fTempItem^,fItemSize);
      System.Move(Idx2Ptr^,Idx1Ptr^,fItemSize);
      System.Move(fTempItem^,Idx2Ptr^,fItemSize);
      DoOnChange;
    end;
end;

//------------------------------------------------------------------------------

procedure TMemVector.Reverse;
var
  i:  Integer;
begin
If fCount > 1 then
  begin
    BeginChanging;
    try
      For i := LowIndex to Pred(fCount shr 1) do
        Exchange(i,Pred(fCount - i));
      DoOnChange;
    finally
      EndChanging;
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TMemVector.Clear;
var
  OldCount: Integer;
begin
OldCount := fCount;
If fOwnsMemory then
  begin
    FinalizeAllItems;
    fCount := 0;
    Shrink;
  end
else
  begin
    fCapacity := 0;
    fCount := 0;
    fMemory := nil;
  end;
If OldCount > 0 then
  DoOnChange;
end;

//------------------------------------------------------------------------------

procedure TMemVector.Sort(Reversed: Boolean = False);
var
  Sorter: TListQuickSorter;
begin
If fCount > 1 then
  begin
    BeginChanging;
    try
      Sorter := TListQuickSorter.Create(CompareItems,Exchange);
      try
        Sorter.Reversed := Reversed;
        Sorter.Sort(LowIndex,HighIndex);
      finally
        Sorter.Free;
      end;
      DoOnChange;
    finally
      EndChanging;
    end;
  end;
end;

//------------------------------------------------------------------------------

Function TMemVector.IsEqual(Vector: TMemVector): Boolean;
var
  i:  Integer;
begin
Result := False;
If Vector is Self.ClassType then
  begin
    If Vector.Count = fCount then
      begin
        For i := LowIndex to HighIndex do
          If not ItemEquals(GetItemPtr(i),Vector.Pointers[i]) then Exit;
        Result := True;  
      end;
  end
else RaiseError('IsEqual: Object is of incompatible class (%s).',[Vector.ClassName]);
end;

//------------------------------------------------------------------------------

Function TMemVector.EqualsBinary(Vector: TMemVector): Boolean;
var
  i:  PtrUInt;
begin
Result := False;
If Size = Vector.Size then
  begin
    If Size > 0 then
      For i := 0 to Pred(Size) do
      {$IFDEF FPCDWM}{$PUSH}W4055{$ENDIF}
        If PByte(PtrUInt(fMemory) + i)^ <> PByte(PtrUInt(Vector.Memory) + i)^ then Exit;
      {$IFDEF FPCDWM}{$POP}{$ENDIF}
    Result := True;
  end;
end;

//------------------------------------------------------------------------------

procedure TMemVector.Assign(Data: Pointer; Count: Integer; ManagedCopy: Boolean = False);
var
  i:  Integer;
begin
If fOwnsMemory then
  begin
    BeginChanging;
    try
      FinalizeAllItems;
      fCount := 0;
      SetCapacity(Count);
      fCount := Count;
      If ManagedCopy then
        For i := 0 to Pred(Count) do
        {$IFDEF FPCDWM}{$PUSH}W4055{$ENDIF}
          ItemCopy(Pointer(PtrUInt(Data) + PtrUInt(i * fItemSize)),GetItemPtr(i))
        {$IFDEF FPCDWM}{$POP}{$ENDIF}
      else
        If Count > 0 then
          System.Move(Data^,fMemory^,Count * fItemSize);
      DoOnChange;
    finally
      EndChanging;
    end;
  end
else RaiseError('Assign: Operation not allowed for not owned memory.');
end;

//------------------------------------------------------------------------------

procedure TMemVector.Assign(Vector: TMemVector; ManagedCopy: Boolean = False);
begin
If fOwnsMemory then
  begin
    If Vector is Self.ClassType then
      Assign(Vector.Memory,Vector.Count,ManagedCopy)
    else
      RaiseError('Assign: Object is of incompatible class (%s).',[Vector.ClassName]);
  end
else RaiseError('Assign: Operation not allowed for not owned memory.');
end;

//------------------------------------------------------------------------------

procedure TMemVector.Append(Data: Pointer; Count: Integer; ManagedCopy: Boolean = False);
var
  i:  Integer;
begin
If fOwnsMemory then
  begin
    BeginChanging;
    try
      If (fCount + Count) > fCapacity then
        SetCapacity(fCount + Count);
      fCount := fCount + Count;
      If ManagedCopy then
        For i := 0 to Pred(Count) do
        {$IFDEF FPCDWM}{$PUSH}W4055{$ENDIF}
          ItemCopy(Pointer(PtrUInt(Data) + PtrUInt(i * fItemSize)),GetItemPtr((fCount - Count) + i))
        {$IFDEF FPCDWM}{$POP}{$ENDIF}
      else
        If Count > 0 then
          System.Move(Data^,GetItemPtr(fCount - Count)^,Count * fItemSize);
      DoOnChange;
    finally
      EndChanging;
    end;
  end
else RaiseError('Append: Operation not allowed for not owned memory.');
end;

//------------------------------------------------------------------------------

procedure TMemVector.Append(Vector: TMemVector; ManagedCopy: Boolean = False);
begin
If fOwnsMemory then
  begin
    If Vector is Self.ClassType then
      Append(Vector.Memory,Vector.Count,ManagedCopy)
    else
      RaiseError('Append: Object is of incompatible class (%s).',[Vector.ClassName]);
  end
else RaiseError('Append: Operation not allowed for not owned memory.');
end;

//------------------------------------------------------------------------------

procedure TMemVector.SaveToStream(Stream: TStream);
begin
Stream.WriteBuffer(fMemory^,fCount * fItemSize);
end;

//------------------------------------------------------------------------------

procedure TMemVector.LoadFromStream(Stream: TStream);
begin
If fOwnsMemory then
  begin
    BeginChanging;
    try
      FinalizeAllItems;
      fCount := 0;
      SetCapacity(Integer((Stream.Size - Stream.Position) div fItemSize));
      fCount := fCapacity;
      Stream.ReadBuffer(fMemory^,fCount * fItemSize);
      DoOnChange;
    finally
      EndChanging;
    end;
  end
else RaiseError('LoadFromStream: Operation not allowed for not owned memory.');
end;

//------------------------------------------------------------------------------

procedure TMemVector.SaveToFile(const FileName: String);
var
  FileStream: TFileStream;
begin
FileStream := TFileStream.Create(StrToRTL(FileName),fmCreate or fmShareExclusive);
try
  SaveToStream(FileStream);
finally
  FileStream.Free;
end;
end;

//------------------------------------------------------------------------------

procedure TMemVector.LoadFromFile(const FileName: String);
var
  FileStream: TFileStream;
begin
FileStream := TFileStream.Create(StrToRTL(FileName),fmOpenRead or fmShareDenyWrite);
try
  LoadFromStream(FileStream);
finally
  FileStream.Free;
end;
end;


{===============================================================================
--------------------------------------------------------------------------------
                                 TIntegerVector
--------------------------------------------------------------------------------
===============================================================================}

{===============================================================================
    TIntegerVector - class declaration
===============================================================================}

{-------------------------------------------------------------------------------
    TIntegerVector - private methods
-------------------------------------------------------------------------------}

Function TIntegerVector.GetItem(Index: Integer): Integer;
begin
Result := Integer(GetItemPtr(Index)^);
end;

//------------------------------------------------------------------------------

procedure TIntegerVector.SetItem(Index: Integer; Value: Integer);
begin
SetItemPtr(Index,@Value);
end;

//------------------------------------------------------------------------------

Function TIntegerVector.ItemCompare(Item1,Item2: Pointer): Integer;
begin
Result := Integer(Item2^) - Integer(Item1^);
end;

{-------------------------------------------------------------------------------
    TIntegerVector - public methods
-------------------------------------------------------------------------------}

constructor TIntegerVector.Create;
begin
inherited Create(SizeOf(Integer));
end;

//   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---

constructor TIntegerVector.Create(Memory: Pointer; Count: Integer);
begin
inherited Create(Memory,Count,SizeOf(Integer));
end;

//------------------------------------------------------------------------------

Function TIntegerVector.First: Integer;
begin
Result := Integer(inherited First^);
end;

//------------------------------------------------------------------------------

Function TIntegerVector.Last: Integer;
begin
Result := Integer(inherited Last^);
end;

//------------------------------------------------------------------------------

Function TIntegerVector.IndexOf(Item: Integer): Integer;
begin
Result := inherited IndexOf(@Item);
end;

//------------------------------------------------------------------------------

Function TIntegerVector.Add(Item: Integer): Integer;
begin
Result := inherited Add(@Item);
end;
  
//------------------------------------------------------------------------------

procedure TIntegerVector.Insert(Index: Integer; Item: Integer);
begin
inherited Insert(Index,@Item);
end;
 
//------------------------------------------------------------------------------

Function TIntegerVector.Remove(Item: Integer): Integer;
begin
Result := inherited Remove(@Item);
end;
 
//------------------------------------------------------------------------------

Function TIntegerVector.Extract(Item: Integer): Integer;
begin
Result := Integer(inherited Extract(@Item)^);
end;

end.
