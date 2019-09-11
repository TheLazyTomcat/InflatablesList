unit InflatablesList_Manager_Filter;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  InflatablesList_Types,
  InflatablesList_Manager_Base,
  InflatablesList_Manager_Sort;

type
  TILManager_Filter = class(TILManager_Sort)
  protected
    fFilterSettings:  TILFilterSettings;
  public
    constructor CreateAsCopy(Source: TILManager_Base); override;
    procedure FilterItems; virtual;
    property FilterSettings: TILFilterSettings read fFilterSettings write fFilterSettings;
  end;

implementation

constructor TILManager_Filter.CreateAsCopy(Source: TILManager_Base);
begin
inherited CreateAsCopy(Source);
If Source is TILManager_Filter then
  fFilterSettings := TILManager_Filter(Source).FilterSettings;
end;

//------------------------------------------------------------------------------

procedure TILManager_Filter.FilterItems;
var
  i:  Integer;
begin
For i := ItemLowIndex to ItemHighIndex do
  fList[i].Filter(fFilterSettings);
end;

end.
