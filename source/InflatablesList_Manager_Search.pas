unit InflatablesList_Manager_Search;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  InflatablesList_Types,
  InflatablesList_Manager_Templates;

type
  TILManager_Search = class(TILManager_Templates)
  protected
    fCurrentSearchSettings: TILAdvSearchSettings; // transient
    Function Search_Compare(const Value: String; IsText,IsEditable,IsCalculated: Boolean; const UnitStr: String = ''): Boolean; virtual;
    Function Search_ParsingTemplateResolve(const Template: String): Pointer; virtual; abstract;    
  public
    Function FindPrev(const Text: String; FromIndex: Integer = -1): Integer; virtual;
    Function FindNext(const Text: String; FromIndex: Integer = -1): Integer; virtual;
    procedure FindAll(const SearchSettings: TILAdvSearchSettings; out SearchResults: TILAdvSearchResults); virtual;
  end;

implementation

uses
  InflatablesList_Utils;

Function TILManager_Search.Search_Compare(const Value: String; IsText,IsEditable,IsCalculated: Boolean; const UnitStr: String = ''): Boolean;

  Function UnitsRectify: String;
  begin
    If (fCurrentSearchSettings.IncludeUnits) and (Length(UnitStr) > 0) then
      Result := IL_Format('%s%s',[fCurrentSearchSettings.Text,UnitStr])
    else
      Result := fCurrentSearchSettings.Text;
  end;
  
begin
If (not fCurrentSearchSettings.TextsOnly or IsText) and
   (not fCurrentSearchSettings.EditablesOnly or IsEditable) and
   (fCurrentSearchSettings.SearchCalculated or not IsCalculated) then
  begin
    If fCurrentSearchSettings.PartialMatch then
      begin
        If fCurrentSearchSettings.CaseSensitive then
          Result := IL_ContainsStr(Value,UnitsRectify)
        else
          Result := IL_ContainsText(Value,UnitsRectify)
      end
    else
      begin
        If fCurrentSearchSettings.CaseSensitive then
          Result := IL_SameStr(Value,UnitsRectify)
        else
          Result := IL_SameText(Value,UnitsRectify)
      end;
  end
else Result := False;
end;

//==============================================================================

Function TILManager_Search.FindPrev(const Text: String; FromIndex: Integer = -1): Integer;
var
  i:  Integer;
begin
Result := -1;
If fCount > 0 then
  begin
    i := IL_IndexWrap(Pred(FromIndex),ItemLowIndex,ItemHighIndex);
    while i <> FromIndex do
      begin
        If fList[i].Contains(Text) then
          begin
            Result := i;
            Break{while...};
          end;
        i := IL_IndexWrap(Pred(i),ItemLowIndex,ItemHighIndex);
      end;
  end;
end;

//------------------------------------------------------------------------------

Function TILManager_Search.FindNext(const Text: String; FromIndex: Integer = -1): Integer;
var
  i:  Integer;
begin
Result := -1;
If fCount > 0 then
  begin
    i := IL_IndexWrap(Succ(FromIndex),ItemLowIndex,ItemHighIndex);
    while i <> FromIndex do
      begin
        If fList[i].Contains(Text) then
          begin
            Result := i;
            Break{while...};
          end;
        i := IL_IndexWrap(Succ(i),ItemLowIndex,ItemHighIndex);
      end;
  end;
end;

//------------------------------------------------------------------------------

procedure TILManager_Search.FindAll(const SearchSettings: TILAdvSearchSettings; out SearchResults: TILAdvSearchResults);
var
  ResCntr:  Integer;
  i:        Integer;
  TempRes:  TILAdvSearchResult;
begin
fCurrentSearchSettings := IL_ThreadSafeCopy(SearchSettings);
fCurrentSearchSettings.CompareFunc := Search_Compare;
fCurrentSearchSettings.ParsTemplResolve := Search_ParsingTemplateResolve;
ResCntr := 0;
SetLength(SearchResults,fCount);
For i := ItemLowIndex to ItemHighIndex do
  If fList[i].FindAll(fCurrentSearchSettings,TempRes) then
    begin
      SearchResults[ResCntr] := TempRes;
      Inc(ResCntr);
    end;
SetLength(SearchResults,ResCntr);
end;

end.
