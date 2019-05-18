unit InflatablesList_Manager_00000005;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  Classes,
  AuxTypes,
  InflatablesList_Types, InflatablesList_Manager_00000004;

type
  TILManager_00000005 = class(TILManager_00000004)
  protected
    procedure InitSaveFunctions(Struct: UInt32); override;
    procedure InitLoadFunctions(Struct: UInt32); override;
    procedure SaveItemShop_00000005(Stream: TStream; const Shop: TILItemShop); virtual;
    procedure LoadItemShop_00000005(Stream: TStream; out Shop: TILItemShop); virtual;
  end;

implementation

uses
  BinaryStreaming,
  InflatablesList_Manager_Base, InflatablesList_Manager_IO;

procedure TILManager_00000005.InitSaveFunctions(Struct: UInt32);
begin
case Struct of
  IL_LISTFILE_FILESTRUCTURE_00000005:
    begin
      fFNSaveToStream := SaveToStream_00000002;
      fFNSaveSortingSettings := SaveSortingSettings_00000001;
      fFNSaveShopTemplates := SaveShopTemplates_00000000;
      fFNSaveFilterSettings := SaveFilterSettings_00000000;
      fFNSaveItem := SaveItem_00000000;
      fFNSaveItemShop := SaveItemShop_00000005;
      fFNSaveParsingSettings := SaveParsingSettings_00000003;
      fFNExportShopTemplate := SaveShopTemplate_00000002;
    end;
else
  inherited InitSaveFunctions(Struct);
end;
end;

//------------------------------------------------------------------------------

procedure TILManager_00000005.InitLoadFunctions(Struct: UInt32);
begin
case Struct of
  IL_LISTFILE_FILESTRUCTURE_00000005:
    begin
      fFNLoadFromStream := LoadFromStream_00000002;
      fFNLoadSortingSettings := LoadSortingSettings_00000001;
      fFNLoadShopTemplates := LoadShopTemplates_00000000;
      fFNLoadFilterSettings := LoadFilterSettings_00000000;
      fFNLoadItem := LoadItem_00000000;
      fFNLoadItemShop := LoadItemShop_00000005;
      fFNLoadParsingSettings := LoadParsingSettings_00000003;
      fFNImportShopTemplate := LoadShopTemplate_00000002;
    end;
else
  inherited InitLoadFunctions(Struct);
end;
end;

//------------------------------------------------------------------------------

procedure TILManager_00000005.SaveItemShop_00000005(Stream: TStream; const Shop: TILItemShop);
var
  i:  Integer;
begin
Stream_WriteBool(Stream,Shop.Selected);
Stream_WriteBool(Stream,Shop.Untracked);
Stream_WriteBool(Stream,Shop.AltDownMethod);
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

procedure TILManager_00000005.LoadItemShop_00000005(Stream: TStream; out Shop: TILItemShop);
var
  i: Integer;
begin
ItemShopInitialize(Shop);
Shop.Selected := Stream_ReadBool(Stream);
Shop.Untracked := Stream_ReadBool(Stream);
Shop.AltDownMethod := Stream_ReadBool(Stream);
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
