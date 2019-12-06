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
    procedure ThisCopyFrom_Filter(Source: TILManager_Base; UniqueCopy: Boolean); virtual;
  public
    constructor CreateAsCopy(Source: TILManager_Base; UniqueCopy: Boolean); override;
    procedure CopyFrom(Source: TILManager_Base; UniqueCopy: Boolean); override;
    procedure FilterItems; virtual;
    property FilterSettings: TILFilterSettings read fFilterSettings write fFilterSettings;
  end;

implementation

procedure TILManager_Filter.ThisCopyFrom_Filter(Source: TILManager_Base; UniqueCopy: Boolean);
begin
If Source is TILManager_Filter then
  fFilterSettings := TILManager_Filter(Source).FilterSettings;
end;

//==============================================================================

constructor TILManager_Filter.CreateAsCopy(Source: TILManager_Base; UniqueCopy: Boolean);
begin
inherited CreateAsCopy(Source,UniqueCopy);
ThisCopyFrom_Filter(Source,UniqueCopy);
end;

//------------------------------------------------------------------------------

procedure TILManager_Filter.CopyFrom(Source: TILManager_Base; UniqueCopy: Boolean);
begin
inherited CopyFrom(Source,UniqueCopy);
ThisCopyFrom_Filter(Source,UniqueCopy);
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
