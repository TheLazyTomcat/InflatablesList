unit InflatablesList_Manager_Templates;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  AuxTypes,
  InflatablesList_Types, InflatablesList_Manager_Filter;

const
  // signature of the exported shop template
  IL_SHOPTEMPLATE_SIGNATURE = UInt32($4C505453);

type
  TILManager_Templates = class(TILManager_Filter)
  protected
    fShopTemplates: TILShopTemplates;
    Function GetShopTemplateCount: Integer;
    Function GetShopTemplate(Index: Integer): TILShopTemplate;
    Function GetShopTemplatePtr(Index: Integer): PILShopTemplate;
    procedure Initialize; override;
    procedure Finalize; override;
  public
    procedure ItemShopCopyForUpdate(const Src: TILItemShop; out Dest: TILItemShop); virtual;
    Function ShopTemplateIndexOf(const Name: String): Integer; virtual;
    Function ShopTemplateAdd(const Name: String; ShopData: TILItemShop): Integer; virtual;
    procedure ShopTemplateRename(Index: Integer; const NewName: String); virtual;
    procedure ShopTemplateExchange(Idx1,Idx2: Integer); virtual;
    procedure ShopTemplateDelete(Index: Integer); virtual;
    procedure ShopTemplateClear; virtual;
    procedure ShopTemplateExport(const FileName: String; ShopTemplateIndex: Integer); virtual;
    Function ShopTemplateImport(const FileName: String): Integer; virtual;
    property ShopTemplateCount: Integer read GetShopTemplateCount;
    property ShopTemplates[Index: Integer]: TILShopTemplate read GetShopTemplate;
    property ShopTemplatePtrs[Index: Integer]: PILShopTemplate read GetShopTemplatePtr;    
  end;

implementation

uses
  SysUtils, Classes,
  BinaryStreaming,
  InflatablesList_Manager_Base, InflatablesList_Manager_IO,
  InflatablesList_HTML_ElementFinder;

Function TILManager_Templates.GetShopTemplateCount: Integer;
begin
Result := Length(fShopTemplates);
end;

//------------------------------------------------------------------------------

Function TILManager_Templates.GetShopTemplate(Index: Integer): TILShopTemplate;
begin
If (Index >= Low(fShopTemplates)) and (Index <= High(fShopTemplates)) then
  Result := fShopTemplates[Index]
else
  raise Exception.CreateFmt('TILManager_Templates.GetShopTemplate: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

Function TILManager_Templates.GetShopTemplatePtr(Index: Integer): PILShopTemplate;
begin
If (Index >= Low(fShopTemplates)) and (Index <= High(fShopTemplates)) then
  Result := Addr(fShopTemplates[Index])
else
  raise Exception.CreateFmt('TILManager_Templates.GetShopTemplatePtr: Index (%d) out of bounds.',[Index]);
end;

//==============================================================================

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

procedure TILManager_Templates.ItemShopCopyForUpdate(const Src: TILItemShop; out Dest: TILItemShop);
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

//------------------------------------------------------------------------------

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

Function TILManager_Templates.ShopTemplateAdd(const Name: String; ShopData: TILItemShop): Integer;
begin
SetLength(fShopTemplates,Length(fShopTemplates) + 1);
Result := High(fShopTemplates);
fShopTemplates[Result].Name := Name;
ItemShopCopy(ShopData,fShopTemplates[Result].ShopData);
fShopTemplates[Result].ShopData.Selected := False;
fShopTemplates[Result].ShopData.ItemURL := '';
fShopTemplates[Result].ShopData.Available := 0;
fShopTemplates[Result].ShopData.Price := 0;
SetLength(fShopTemplates[Result].ShopData.AvailHistory,0);
SetLength(fShopTemplates[Result].ShopData.PriceHistory,0);
fShopTemplates[Result].ShopData.ParsingSettings.TemplateRef := '';
fShopTemplates[Result].ShopData.LastUpdateRes := ilisurSuccess;
fShopTemplates[Result].ShopData.LastUpdateMsg := '';
end;

//------------------------------------------------------------------------------

procedure TILManager_Templates.ShopTemplateRename(Index: Integer; const NewName: String);
var
  i,j:  Integer;
begin
If (Index >= Low(fShopTemplates)) and (Index <= High(fShopTemplates)) then
  begin
    // change all references to this template
    For i := Low(fList) to High(fList) do
      For j := Low(fList[i].Shops) to High(fList[i].Shops) do
        If AnsiSameText(fList[i].Shops[j].ParsingSettings.TemplateRef,fShopTemplates[Index].Name) then
          fList[i].Shops[j].ParsingSettings.TemplateRef := NewName;
    // rename
    fShopTemplates[Index].Name := NewName
  end
else raise Exception.CreateFmt('TILManager_Templates.ShopTemplateRename: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

procedure TILManager_Templates.ShopTemplateExchange(Idx1,Idx2: Integer);
var
  Temp: TILShopTemplate;
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
    ItemShopFinalize(fShopTemplates[Index].ShopData);
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
  ItemShopFinalize(fShopTemplates[i].ShopData);
SetLength(fShopTemplates,0);
end;

//------------------------------------------------------------------------------

procedure TILManager_Templates.ShopTemplateExport(const FileName: String; ShopTemplateIndex: Integer);
var
  FileStream: TFileStream;
begin
If (ShopTemplateIndex >= Low(fShopTemplates)) and (ShopTemplateIndex <= High(fShopTemplates)) then
  begin
    FileStream := TFileStream.Create(FileName,fmCreate or fmShareDenyWrite);
    try
      Stream_WriteUInt32(FileStream,IL_SHOPTEMPLATE_SIGNATURE);
      Stream_WriteUInt32(FileStream,IL_LISTFILE_FILESTRUCTURE_SAVE);
      ExportShopTemplate(FileStream,fShopTemplates[ShopTemplateIndex],IL_LISTFILE_FILESTRUCTURE_SAVE);
    finally
      FileStream.Free;
    end;
  end
else raise Exception.CreateFmt('TILManager_Templates.ShopTemplateExport: Index (%d) out of bounds.',[ShopTemplateIndex]);
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
  If Stream_ReadUInt32(FileStream) <> UInt32(IL_SHOPTEMPLATE_SIGNATURE) then
    raise Exception.Create('TILManager_Templates.ShopTemplateImport: Unknown file format.');
  ImportShopTemplate(FileStream,fShopTemplates[Result],Stream_ReadUInt32(FileStream));
finally
  FileStream.Free;
end;
end;

end.
