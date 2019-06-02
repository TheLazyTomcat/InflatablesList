unit IL_Manager_Filter;

{$INCLUDE '.\IL_defs.inc'}

interface

uses
  IL_Types, IL_Manager_Sort;

type
  TILManager_Filter = class(TILManager_Sort)
  protected
    fFilterSettings:  TILFilterSettings;
  public
    procedure ItemFilter; virtual;
    property FilterSettings: TILFilterSettings read fFilterSettings write fFilterSettings;
  end;

implementation

procedure TILManager_Filter.ItemFilter;
var
  i:  Integer;
begin
For i := ItemLowIndex to ItemHighIndex do
  fList[i].Filter(fFilterSettings);
end;

end.
