unit InflatablesList_Manager_VER00000004;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  Classes,
  AuxTypes,
  InflatablesList_Types, InflatablesList_Manager_VER00000003;

type
  TILManager_VER00000004 = class(TILManager_VER00000003)
  protected
    procedure InitSaveFunctions(Struct: UInt32); override;
    procedure InitLoadFunctions(Struct: UInt32); override;
    procedure SaveItemShop_VER00000004(Stream: TStream; const Shop: TILItemShop); virtual;
    procedure LoadItemShop_VER00000004(Stream: TStream; out Shop: TILItemShop); virtual;
  end;

implementation

uses
  BinaryStreaming,
  InflatablesList_Manager_Base;

procedure TILManager_VER00000004.InitSaveFunctions(Struct: UInt32);
begin
case Struct of
  IL_LISTFILE_FILESTRUCTURE_00000004:
    begin
      fFNSaveToStream := SaveToStream_VER00000002;
      fFNSaveSortingSettings := SaveSortingSettings_VER00000001;
      fFNSaveShopTemplates := SaveShopTemplates_VER00000000;
      fFNSaveFilterSettings := SaveFilterSettings_VER00000000;
      fFNSaveItem := SaveItem_VER00000000;
      fFNSaveItemShop := SaveItemShop_VER00000004;
      fFNSaveParsingSettings := SaveParsingSettings_VER00000003;
      fFNExportShopTemplate := SaveShopTemplate_VER00000002;
    end;
else
  inherited InitSaveFunctions(Struct);
end;
end;

//------------------------------------------------------------------------------

procedure TILManager_VER00000004.InitLoadFunctions(Struct: UInt32);
begin
case Struct of
  IL_LISTFILE_FILESTRUCTURE_00000004:
    begin
      fFNLoadFromStream := LoadFromStream_VER00000002;
      fFNLoadSortingSettings := LoadSortingSettings_VER00000001;
      fFNLoadShopTemplates := LoadShopTemplates_VER00000000;
      fFNLoadFilterSettings := LoadFilterSettings_VER00000000;
      fFNLoadItem := LoadItem_VER00000000;
      fFNLoadItemShop := LoadItemShop_VER00000004;
      fFNLoadParsingSettings := LoadParsingSettings_VER00000003;
      fFNImportShopTemplate := LoadShopTemplate_VER00000002;
    end;
else
  inherited InitLoadFunctions(Struct);
end;
end;

//------------------------------------------------------------------------------

procedure TILManager_VER00000004.SaveItemShop_VER00000004(Stream: TStream; const Shop: TILItemShop);
var
  i:  Integer;
begin
Stream_WriteBool(Stream,Shop.Selected);
Stream_WriteBool(Stream,Shop.Untracked);
Stream_WriteString(Stream,Shop.Name);
Stream_WriteString(Stream,Shop.ShopURL);
Stream_WriteString(Stream,Shop.ItemURL);
Stream_WriteInt32(Stream,Shop.Available);
Stream_WriteUInt32(Stream,Shop.Price);
// avail history
Stream_WriteUInt32(Stream,Length(Shop.AvailHistory));
For i := Low(Shop.AvailHistory) to High(Shop.AvailHistory) do
  begin
    Stream_WriteInt32(Stream,Shop.AvailHistory[i].Value);
    Stream_WriteFloat64(Stream,Shop.AvailHistory[i].Time);
  end;
// price history
Stream_WriteUInt32(Stream,Length(Shop.PriceHistory));
For i := Low(Shop.PriceHistory) to High(Shop.PriceHistory) do
  begin
    Stream_WriteInt32(Stream,Shop.PriceHistory[i].Value);
    Stream_WriteFloat64(Stream,Shop.PriceHistory[i].Time);
  end;
// parsing settings
Stream_WriteString(Stream,Shop.Notes);
fFNSaveParsingSettings(Stream,Shop.ParsingSettings);
Stream_WriteString(Stream,Shop.LastUpdateMsg);
end;

//------------------------------------------------------------------------------

procedure TILManager_VER00000004.LoadItemShop_VER00000004(Stream: TStream; out Shop: TILItemShop);
var
  i: Integer;
begin
Shop.Selected := Stream_ReadBool(Stream);
Shop.Untracked := Stream_ReadBool(Stream);;
Shop.Name := Stream_ReadString(Stream);
Shop.ShopURL := Stream_ReadString(Stream);
Shop.ItemURL := Stream_ReadString(Stream);
Shop.Available := Stream_ReadInt32(Stream);
Shop.Price := Stream_ReadUInt32(Stream);
// avail history
SetLength(Shop.AvailHistory,Stream_ReadUInt32(Stream));
For i := Low(Shop.AvailHistory) to High(Shop.AvailHistory) do
  begin
    Shop.AvailHistory[i].Value := Stream_ReadInt32(Stream);
    Shop.AvailHistory[i].Time := Stream_ReadFloat64(Stream);
  end;
// price history
SetLength(Shop.PriceHistory,Stream_ReadUInt32(Stream));
For i := Low(Shop.PriceHistory) to High(Shop.PriceHistory) do
  begin
    Shop.PriceHistory[i].Value := Stream_ReadInt32(Stream);
    Shop.PriceHistory[i].Time := Stream_ReadFloat64(Stream);
  end;
Shop.Notes := Stream_ReadString(Stream);
// parsing settings
fFNLoadParsingSettings(Stream,Shop.ParsingSettings);
Shop.LastUpdateMsg := Stream_ReadString(Stream);
end;

end.
