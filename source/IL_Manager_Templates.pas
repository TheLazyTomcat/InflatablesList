unit IL_Manager_Templates;

{$INCLUDE '.\IL_defs.inc'}

interface

uses
  AuxTypes,
  IL_Types, IL_ItemShop, IL_ItemShopTemplate, IL_Manager_Filter;

type
  TILManager_Templates = class(TILManager_Filter)
  protected
    fShopTemplates: array of TILItemShopTemplate;
    Function GetShopTemplateCount: Integer;
    Function GetShopTemplate(Index: Integer): TILItemShopTemplate;
    procedure Initialize; override;
    procedure Finalize; override;
  public
    Function ShopTemplateIndexOf(const Name: String): Integer; virtual;
    Function ShopTemplateAdd(const Name: String; Shop: TILItemShop): Integer; virtual;
    procedure ShopTemplateRename(Index: Integer; const NewName: String); virtual;
    procedure ShopTemplateExchange(Idx1,Idx2: Integer); virtual;
    procedure ShopTemplateDelete(Index: Integer); virtual;
    procedure ShopTemplateClear; virtual;
    procedure ShopTemplateExport(const FileName: String; ShopTemplateIndex: Integer); virtual;
    Function ShopTemplateImport(const FileName: String): Integer; virtual;
    property ShopTemplateCount: Integer read GetShopTemplateCount;
    property ShopTemplates[Index: Integer]: TILItemShopTemplate read GetShopTemplate;
  end;

implementation

uses
  SysUtils, Classes,
  BinaryStreaming;

Function TILManager_Templates.GetShopTemplateCount: Integer;
begin
Result := Length(fShopTemplates);
end;

//------------------------------------------------------------------------------

Function TILManager_Templates.GetShopTemplate(Index: Integer): TILItemShopTemplate;
begin
If (Index >= Low(fShopTemplates)) and (Index <= High(fShopTemplates)) then
  Result := fShopTemplates[Index]
else
  raise Exception.CreateFmt('TILManager_Templates.GetShopTemplate: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

procedure TILManager_Templates.Initialize;
begin
inherited Initialize;
SetLength(fShopTemplates,0);
end;

//------------------------------------------------------------------------------

procedure TILManager_Templates.Finalize;
begin
ShopTemplateClear;
inherited Finalize;
end;

//==============================================================================

Function TILManager_Templates.ShopTemplateIndexOf(const Name: String): Integer;
var
  i:  Integer;
begin
Result := -1;
For i := Low(fShopTemplates) to High(fShopTemplates) do
  If AnsiSameText(fShopTemplates[i].Name,Name) then
    begin
      Result := i;
      Break{For i};
    end;
end;

//------------------------------------------------------------------------------

Function TILManager_Templates.ShopTemplateAdd(const Name: String; Shop: TILItemShop): Integer;
begin
SetLength(fShopTemplates,Length(fShopTemplates) + 1);
Result := High(fShopTemplates);
fShopTemplates[Result] := TILItemShopTemplate.Create(Shop);
fShopTemplates[Result].Name := Name;
end;

//------------------------------------------------------------------------------

procedure TILManager_Templates.ShopTemplateRename(Index: Integer; const NewName: String);
var
  i,j:  Integer;
begin
If (Index >= Low(fShopTemplates)) and (Index <= High(fShopTemplates)) then
  begin
    // change all references to this template
    For i := ItemLowIndex to ItemHighIndex do
      For j := fList[i].ShopLowIndex to fList[i].ShopHighIndex do
        If AnsiSameText(fList[i].Shops[j].ParsingSettings.TemplateReference,fShopTemplates[Index].Name) then
          fList[i].Shops[j].ParsingSettings.TemplateReference := NewName;
    // rename
    fShopTemplates[Index].Name := NewName
  end
else raise Exception.CreateFmt('TILManager_Templates.ShopTemplateRename: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

procedure TILManager_Templates.ShopTemplateExchange(Idx1,Idx2: Integer);
var
  Temp: TILItemShopTemplate;
begin
If Idx1 <> Idx2 then
  begin
    // sanity checks
    If (Idx1 < Low(fShopTemplates)) or (Idx1 > High(fShopTemplates)) then
      raise Exception.CreateFmt('TILManager_Templates.ShopTemplateExchange: First index (%d) out of bounds.',[Idx1]);
    If (Idx2 < Low(fShopTemplates)) or (Idx2 > High(fShopTemplates)) then
      raise Exception.CreateFmt('TILManager_Templates.ShopTemplateExchange: Second index (%d) out of bounds.',[Idx2]);
    Temp := fShopTemplates[Idx1];
    fShopTemplates[Idx1] := fShopTemplates[Idx2];
    fShopTemplates[Idx2] := Temp;
  end;
end;

//------------------------------------------------------------------------------

procedure TILManager_Templates.ShopTemplateDelete(Index: Integer);
var
  i:  Integer;
begin
If (Index >= Low(fShopTemplates)) and (Index <= High(fShopTemplates)) then
  begin
    FreeAndNil(fShopTemplates[Index]);
    For i := Index to Pred(High(fShopTemplates)) do
      fShopTemplates[i] := fShopTemplates[i + 1];
    SetLength(fShopTemplates,Length(fShopTemplates) - 1);
  end
else raise Exception.CreateFmt('TILManager_Templates.ShopTemplateDelete: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

procedure TILManager_Templates.ShopTemplateClear;
var
  i:  Integer;
begin
For i := Low(fShopTemplates) to High(fShopTemplates) do
  FreeAndNil(fShopTemplates[i]);
SetLength(fShopTemplates,0);
end;

//------------------------------------------------------------------------------

procedure TILManager_Templates.ShopTemplateExport(const FileName: String; ShopTemplateIndex: Integer);
begin
If (ShopTemplateIndex >= Low(fShopTemplates)) and (ShopTemplateIndex <= High(fShopTemplates)) then
  fShopTemplates[ShopTemplateIndex].SaveToFile(FileName)
else
  raise Exception.CreateFmt('TILManager_Templates.ShopTemplateExport: Index (%d) out of bounds.',[ShopTemplateIndex]);
end;

//------------------------------------------------------------------------------

Function TILManager_Templates.ShopTemplateImport(const FileName: String): Integer;
var
  FileStream: TFileStream;
begin
FileStream := TFileStream.Create(FileName,fmOpenRead or fmShareDenyWrite);
try
  SetLength(fShopTemplates,Length(fShopTemplates) + 1);
  Result := High(fShopTemplates);
  fShopTemplates[Result] := TILItemShopTemplate.Create;
  try
    fShopTemplates[Result].LoadFromFile(FileName);
    fShopTemplates[Result].StaticOptions := fStaticOptions;
  except
    fShopTemplates[Result].Free;
    SetLength(fShopTemplates,Length(fShopTemplates) - 1);
  end;
finally
  FileStream.Free;
end;
end;

end.
