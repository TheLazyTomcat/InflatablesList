unit InflatablesList_Manager_00000000;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  Classes,
  AuxTypes,
  InflatablesList_Types, InflatablesList_Manager_Draw;

type
  TILManager_00000000 = class(TILManager_Draw)
  protected
    procedure InitSaveFunctions(Struct: UInt32); override;
    procedure InitLoadFunctions(Struct: UInt32); override;
    // saving/loading of data for sion 0
    procedure SaveToStream_00000000(Stream: TStream); virtual;
    procedure LoadFromStream_00000000(Stream: TStream); virtual;
    procedure SaveSortingSettings_00000000(Stream: TStream); virtual;
    procedure LoadSortingSettings_00000000(Stream: TStream); virtual;
    procedure SaveShopTemplates_00000000(Stream: TStream); virtual;
    procedure LoadShopTemplates_00000000(Stream: TStream); virtual;
    procedure SaveFilterSettings_00000000(Stream: TStream); virtual;
    procedure LoadFilterSettings_00000000(Stream: TStream); virtual;
    procedure SaveItem_00000000(Stream: TStream; const Item: TILItem); virtual;
    procedure LoadItem_00000000(Stream: TStream; out Item: TILItem); virtual;
    procedure SaveItemShop_00000000(Stream: TStream; const Shop: TILItemShop); virtual;
    procedure LoadItemShop_00000000(Stream: TStream; out Shop: TILItemShop); virtual;
    procedure SaveParsingSettings_00000000(Stream: TStream; const ParsSett: TILItemShopParsingSetting); virtual;
    procedure LoadParsingSettings_00000000(Stream: TStream; out ParsSett: TILItemShopParsingSetting); virtual;
  end;

implementation

uses
  SysUtils, Graphics,
  BinaryStreaming,
  InflatablesList_Manager_IO,
  InflatablesList_HTML_ElementFinder;

//- old item shop parsing types ------------------------------------------------

type
  TILItemShopParsingStage_old = record
    ElementName:      String;   // if empty, return nil
    AttributeName:    String;   // if empty, ignore
    AttributeValue:   String;   // if empty, ignore
    FullTextMatch:    Boolean;  // search for occurence when false
    RecursiveSearch:  Boolean;  // search for text in subnodes
    Text:             String;   // if empty, ignore
  end;
  PILItemShopParsingStage_old = ^TILItemShopParsingStage_old;

  TILItemShopParsingStages_old = array of TILItemShopParsingStage_old;
  PILItemShopParsingStages_old = ^TILItemShopParsingStages_old;

  TILItemShopParsAvailExtrMethod_old = (ilpaemFirstInteger,ilpaemFirstIntegerTag,
                                        ilpaemMoreThanTagIsOne,ilpaemFIorMTTIO);
  TILItemShopParsPriceExtrMethod_old = (ilppemFirstInteger);

type
  TILItemShopParsingSetting_old = record
    MoreThanTag:      String;
    AvailExtrMethod:  TILItemShopParsAvailExtrMethod_old;
    PriceExtrMethod:  TILItemShopParsPriceExtrMethod_old;
    AvailStages:      TILItemShopParsingStages_old;
    PriceStages:      TILItemShopParsingStages_old;
  end;

//==============================================================================

Function IL_AvailExtrMethodToNum_old(ExtrMethod: TILItemShopParsAvailExtrMethod_old): Int32;
begin
case ExtrMethod of
  ilpaemFirstIntegerTag:  Result := 1;
  ilpaemMoreThanTagIsOne: Result := 2;
else
  {ilpemaFirstInteger}
  Result := 0;
end;
end;

//------------------------------------------------------------------------------

Function IL_NumToAvailExtrMethod_old(Num: Int32): TILItemShopParsAvailExtrMethod_old;
begin
case Num of
  1:  Result := ilpaemFirstIntegerTag;
  2:  Result := ilpaemMoreThanTagIsOne;
else
  Result := ilpaemFirstInteger;
end;
end;

//------------------------------------------------------------------------------

Function IL_PriceExtrMethodToNum_old(ExtrMethod: TILItemShopParsPriceExtrMethod_old): Int32;
begin
case ExtrMethod of
  ilppemFirstInteger:  Result := 0;
else
  Result := 0;  // nothing else is implemented atm.
end;
end;

//------------------------------------------------------------------------------

Function IL_NumToPriceExtrMethod_old(Num: Int32): TILItemShopParsPriceExtrMethod_old;
begin
case Num of
  0:  Result := ilppemFirstInteger;
else
  Result := ilppemFirstInteger;
end;
end;

//==============================================================================

procedure TILManager_00000000.InitSaveFunctions(Struct: UInt32);
begin
case Struct of
  IL_LISTFILE_FILESTRUCTURE_00000000:
    begin
      fFNSaveToStream := SaveToStream_00000000;
      fFNSaveSortingSettings := SaveSortingSettings_00000000;
      fFNSaveShopTemplates := SaveShopTemplates_00000000;
      fFNSaveFilterSettings := SaveFilterSettings_00000000;
      fFNSaveItem := SaveItem_00000000;
      fFNSaveItemShop := SaveItemShop_00000000;
      fFNSaveParsingSettings := SaveParsingSettings_00000000;
      fFNExportShopTemplate := nil;
    end;
else
  raise Exception.CreateFmt('TILManager_00000000.InitSaveFunctions: Unknown stream structure (%.8x).',[Struct]);
end;
end;

//------------------------------------------------------------------------------

procedure TILManager_00000000.InitLoadFunctions(Struct: UInt32);
begin
case Struct of
  IL_LISTFILE_FILESTRUCTURE_00000000:
    begin
      fFNLoadFromStream := LoadFromStream_00000000;
      fFNLoadSortingSettings := LoadSortingSettings_00000000;
      fFNLoadShopTemplates := LoadShopTemplates_00000000;
      fFNLoadFilterSettings := LoadFilterSettings_00000000;
      fFNLoadItem := LoadItem_00000000;
      fFNLoadItemShop := LoadItemShop_00000000;
      fFNLoadParsingSettings := LoadParsingSettings_00000000;
      fFNImportShopTemplate := nil;
    end;
else
  raise Exception.CreateFmt('TILManager_00000000.InitSaveFunctions: Unknown stream structure (%.8x).',[Struct]);
end;
end;

//------------------------------------------------------------------------------

procedure TILManager_00000000.SaveToStream_00000000(Stream: TStream);
var
  i:  Integer;
begin
fFNSaveSortingSettings(Stream);
fFNSaveShopTemplates(Stream);
fFNSaveFilterSettings(Stream);
// items
Stream_WriteUInt32(Stream,Length(fList));
For i := Low(fList) to High(fList) do
  fFNSaveItem(Stream,fList[i]);
end;

//------------------------------------------------------------------------------

procedure TILManager_00000000.LoadFromStream_00000000(Stream: TStream);
var
  i:  Integer;
begin
fFNLoadSortingSettings(Stream);
fFNLoadShopTemplates(Stream);
fFNLoadFilterSettings(Stream);
// items
ItemClear;
SetLength(fList,Stream_ReadUInt32(Stream));
For i := Low(fList) to High(fList) do
  fFNLoadItem(Stream,fList[i]);
ReIndex;
ItemRedraw;
end;
 
//------------------------------------------------------------------------------

procedure TILManager_00000000.SaveSortingSettings_00000000(Stream: TStream);
var
  i:  Integer;
begin
Stream_WriteUInt32(Stream,fActualSortSett.Count);
For i := Low(fActualSortSett.Items) to High(fActualSortSett.Items) do
  begin
    Stream_WriteInt32(Stream,IL_ItemValueTagToNum(fActualSortSett.Items[i].ItemValueTag));
    Stream_WriteBool(Stream,fActualSortSett.Items[i].Reversed);
  end;
end;

//------------------------------------------------------------------------------

procedure TILManager_00000000.LoadSortingSettings_00000000(Stream: TStream);
var
  i:  Integer;
begin
fActualSortSett.Count := Stream_ReadUInt32(Stream);
For i := Low(fActualSortSett.Items) to High(fActualSortSett.Items) do
  begin
    fActualSortSett.Items[i].ItemValueTag := IL_NumToItemValueTag(Stream_ReadInt32(Stream));
    fActualSortSett.Items[i].Reversed := Stream_ReadBool(Stream);
  end;
end;
 
//------------------------------------------------------------------------------

procedure TILManager_00000000.SaveShopTemplates_00000000(Stream: TStream);
var
  i:  Integer;
begin
Stream_WriteUInt32(Stream,Length(fShopTemplates));
For i := Low(fShopTemplates) to High(fShopTemplates) do
  begin
    Stream_WriteString(Stream,fShopTemplates[i].Name);
    fFNSaveItemShop(Stream,fShopTemplates[i].ShopData);
  end;
end;

//------------------------------------------------------------------------------

procedure TILManager_00000000.LoadShopTemplates_00000000(Stream: TStream);
var
  i:  Integer;
begin
SetLength(fShopTemplates,Stream_ReadUInt32(Stream));
For i := Low(fShopTemplates) to High(fShopTemplates) do
  begin
    fShopTemplates[i].Name := Stream_ReadString(Stream);
    fFNLoadItemShop(Stream,fShopTemplates[i].ShopData);
  end;
end;
 
//------------------------------------------------------------------------------

procedure TILManager_00000000.SaveFilterSettings_00000000(Stream: TStream);
begin
Stream_WriteInt32(Stream,IL_FilterOperatorToNum(fFilterSettings.Operator));
Stream_WriteUInt32(Stream,IL_EncodeFilterFlags(fFilterSettings.Flags));
end;

//------------------------------------------------------------------------------

procedure TILManager_00000000.LoadFilterSettings_00000000(Stream: TStream);
begin
fFilterSettings.Operator := IL_NumToFilterOperator(Stream_ReadInt32(Stream));
fFilterSettings.Flags := IL_DecodeFilterFlags(Stream_ReadUInt32(Stream));
end;
 
//------------------------------------------------------------------------------

procedure TILManager_00000000.SaveItem_00000000(Stream: TStream; const Item: TILItem);
var
  i:  Integer;

  procedure WritePicture(Pic: TBitmap);
  var
    TempStream: TMemoryStream;
  begin
    If Assigned(Pic) then
      begin
        TempStream := TMemoryStream.Create;
        try
          Pic.SaveToStream(TempStream);
          Stream_WriteUInt32(Stream,TempStream.Size);
          Stream.CopyFrom(TempStream,0);
        finally
          TempStream.Free;
        end;
      end
    else Stream_WriteUInt32(Stream,0);
  end;

begin
Stream_WriteFloat64(Stream,Item.TimeOfAddition);
// pictures
WritePicture(Item.MainPicture);
WritePicture(Item.PackagePicture);
// basic specs
Stream_WriteInt32(Stream,IL_ItemTypeToNum(Item.ItemType));
Stream_WriteString(Stream,Item.ItemTypeSpec);
Stream_WriteUInt32(Stream,Item.Count);
Stream_WriteInt32(Stream,IL_ItemManufacturerToNum(Item.Manufacturer));
Stream_WriteString(Stream,Item.ManufacturerStr);
Stream_WriteInt32(Stream,Item.ID);
// flags
Stream_WriteUInt32(Stream,IL_EncodeItemFlags(Item.Flags));
Stream_WriteString(Stream,Item.TextTag);
// extended specs
Stream_WriteUInt32(Stream,Item.WantedLevel);
Stream_WriteString(Stream,Item.Variant);
Stream_WriteUInt32(Stream,Item.SizeX);
Stream_WriteUInt32(Stream,Item.SizeY);
Stream_WriteUInt32(Stream,Item.SizeZ);
Stream_WriteUInt32(Stream,Item.UnitWeight);
// others
Stream_WriteString(Stream,Item.Notes);
Stream_WriteString(Stream,Item.ReviewURL);
Stream_WriteString(Stream,Item.MainPictureFile);
Stream_WriteString(Stream,Item.PackagePictureFile);
Stream_WriteUInt32(Stream,Item.UnitPriceDefault);
Stream_WriteUInt32(Stream,Item.UnitPriceLowest);
Stream_WriteUInt32(Stream,Item.UnitPriceSelected);
Stream_WriteInt32(Stream,Item.AvailablePieces);
// shops
Stream_WriteUInt32(Stream,Length(Item.Shops));
For i := Low(Item.Shops) to High(Item.Shops) do
  fFNSaveItemShop(Stream,Item.Shops[i]);
end;

//------------------------------------------------------------------------------

procedure TILManager_00000000.LoadItem_00000000(Stream: TStream; out Item: TILItem);
var
  i:  Integer;

  procedure ReadPicture(var Pic: TBitmap);
  var
    Size:       UInt32;
    TempStream: TMemoryStream;
  begin
    Size := Stream_ReadUInt32(Stream);
    If Size > 0 then
      begin
        TempStream := TMemoryStream.Create;
        try
          TempStream.CopyFrom(Stream,Size);
          TempStream.Seek(0,soBeginning);
          Pic := TBitmap.Create;
          try
            Pic.LoadFromStream(TempStream);
          except
            FreeAndNil(Pic);
          end;
        finally
          TempStream.Free;
        end;
      end
    else Pic := nil;
  end;

begin
ItemInitialize(Item);
Item.TimeOfAddition := TDateTime(Stream_ReadFloat64(Stream));
// pictures
ReadPicture(Item.MainPicture);
ReadPicture(Item.PackagePicture);
// basic specs
Item.ItemType := IL_NumToItemType(Stream_ReadInt32(Stream));
Item.ItemTypeSpec := Stream_ReadString(Stream);
Item.Count := Stream_ReadUInt32(Stream);
Item.Manufacturer := IL_NumToItemManufacturer(Stream_ReadInt32(Stream));
Item.ManufacturerStr := Stream_ReadString(Stream);
Item.ID := Stream_ReadInt32(Stream);
// flags
Item.Flags := IL_DecodeItemFlags(Stream_ReadUInt32(Stream));
Item.TextTag := Stream_ReadString(Stream);
// extended specs
Item.WantedLevel := Stream_ReadUInt32(Stream);
Item.Variant := Stream_ReadString(Stream);
Item.SizeX := Stream_ReadUInt32(Stream);
Item.SizeY := Stream_ReadUInt32(Stream);
Item.SizeZ := Stream_ReadUInt32(Stream);
Item.UnitWeight := Stream_ReadUInt32(Stream);
// other info
Item.Notes := Stream_ReadString(Stream);
Item.ReviewURL := Stream_ReadString(Stream);
Item.MainPictureFile := Stream_ReadString(Stream);
Item.PackagePictureFile := Stream_ReadString(Stream);
Item.UnitPriceDefault := Stream_ReadUInt32(Stream);
Item.UnitPriceLowest := Stream_ReadUInt32(Stream);
Item.UnitPriceSelected := Stream_ReadUInt32(Stream);
Item.AvailablePieces := Stream_ReadInt32(Stream);
// shops
SetLength(Item.Shops,Stream_ReadUInt32(Stream));
For i := Low(Item.Shops) to High(Item.Shops) do
  fFNLoadItemShop(Stream,Item.Shops[i]);
// internals
ItemInitInternals(Item);
end;

//------------------------------------------------------------------------------

procedure TILManager_00000000.SaveItemShop_00000000(Stream: TStream; const Shop: TILItemShop);
var
  i:  Integer;
begin
Stream_WriteBool(Stream,Shop.Selected);
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
fFNSaveParsingSettings(Stream,Shop.ParsingSettings);
Stream_WriteString(Stream,Shop.LastUpdateMsg);
end;

//------------------------------------------------------------------------------

procedure TILManager_00000000.LoadItemShop_00000000(Stream: TStream; out Shop: TILItemShop);
var
  i: Integer;
begin
ItemShopInitialize(Shop);
Shop.Selected := Stream_ReadBool(Stream);
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
// parsing settings
fFNLoadParsingSettings(Stream,Shop.ParsingSettings);
Shop.LastUpdateMsg := Stream_ReadString(Stream);
end;

//------------------------------------------------------------------------------

procedure TILManager_00000000.SaveParsingSettings_00000000(Stream: TStream; const ParsSett: TILItemShopParsingSetting);
begin
// save empty settings
Stream_WriteString(Stream,'');
Stream_WriteInt32(Stream,IL_AvailExtrMethodToNum_old(ilpaemFirstInteger));
Stream_WriteInt32(Stream,IL_PriceExtrMethodToNum_old(ilppemFirstInteger));
Stream_WriteUInt32(Stream,0);
Stream_WriteUInt32(Stream,0);
end;

//------------------------------------------------------------------------------

procedure TILManager_00000000.LoadParsingSettings_00000000(Stream: TStream; out ParsSett: TILItemShopParsingSetting);
var
  i:    Integer;
  Temp: TILItemShopParsingSetting_old;

  procedure ContStages(ElementFinder: TILElementFinder; Stages: TILItemShopParsingStages_old);
  var
    ii:           Integer;
    TempElemComp: TILElementComparator;
  begin
    For ii := Low(Stages) to High(Stages) do
      begin
        TempElemComp := ElementFinder.StageAdd.AddComparator;
        TempElemComp.NestedText := Stages[ii].RecursiveSearch;
        // name
        TempElemComp.TagName.AddComparator.Str := Stages[ii].ElementName;
        // attributes
        If (Length(Stages[ii].AttributeName) > 0) or (Length(Stages[ii].AttributeValue) > 0) then
          with TempElemComp.Attributes.AddComparator do
            begin
              If Length(Stages[ii].AttributeName) > 0 then
                Name.AddComparator.Str := Stages[ii].AttributeName;
              If Length(Stages[ii].AttributeValue) > 0 then
                Value.AddComparator.Str := Stages[ii].AttributeValue;
            end;
        // text
        If Length(Stages[ii].Text) > 0 then
          with TempElemComp.Text.AddComparator do
            begin
              Str := Stages[ii].Text;
              AllowPartial := not Stages[ii].FullTextMatch;
            end;
      end;
  end;

begin
// load old structures to temp
Temp.MoreThanTag := Stream_ReadString(Stream);
Temp.AvailExtrMethod := IL_NumToAvailExtrMethod_old(Stream_ReadInt32(Stream));
Temp.PriceExtrMethod := IL_NumToPriceExtrMethod_old(Stream_ReadInt32(Stream));
// parsing stages for available pieces
SetLength(Temp.AvailStages,Stream_ReadUInt32(Stream));
For i := Low(Temp.AvailStages) to High(Temp.AvailStages) do
  begin
    Temp.AvailStages[i].ElementName := Stream_ReadString(Stream);
    Temp.AvailStages[i].AttributeName := Stream_ReadString(Stream);
    Temp.AvailStages[i].AttributeValue := Stream_ReadString(Stream);
    Temp.AvailStages[i].FullTextMatch := Stream_ReadBool(Stream);
    Temp.AvailStages[i].RecursiveSearch := Stream_ReadBool(Stream);
    Temp.AvailStages[i].Text := Stream_ReadString(Stream);
  end;
// parsing stages for price
SetLength(Temp.PriceStages,Stream_ReadUInt32(Stream));
For i := Low(Temp.PriceStages) to High(Temp.PriceStages) do
  begin
    Temp.PriceStages[i].ElementName := Stream_ReadString(Stream);
    Temp.PriceStages[i].AttributeName := Stream_ReadString(Stream);
    Temp.PriceStages[i].AttributeValue := Stream_ReadString(Stream);
    Temp.PriceStages[i].FullTextMatch := Stream_ReadBool(Stream);
    Temp.PriceStages[i].RecursiveSearch := Stream_ReadBool(Stream);
    Temp.PriceStages[i].Text := Stream_ReadString(Stream);
  end;
// construct new structures from old ones
FillChar(ParsSett,SizeOf(TILItemShopParsingSetting),0);
// available count
SetLength(ParsSett.Available.Extraction,1);
ParsSett.Available.Extraction[0].ExtractFrom := ilpefText;
ParsSett.Available.Extraction[0].ExtractionMethod := ilpemFirstIntegerTag;
ParsSett.Available.Extraction[0].ExtractionData := '';
ParsSett.Available.Extraction[0].NegativeTag := Temp.MoreThanTag;
ParsSett.Available.Finder := TILElementFinder.Create;
ContStages(ParsSett.Available.Finder as TILElementFinder,Temp.AvailStages);
// price
SetLength(ParsSett.Price.Extraction,1);
ParsSett.Price.Extraction[0].ExtractFrom := ilpefText;
ParsSett.Price.Extraction[0].ExtractionMethod := ilpemFirstInteger;
ParsSett.Price.Extraction[0].ExtractionData := '';
ParsSett.Price.Extraction[0].NegativeTag := '';
ParsSett.Price.Finder := TILElementFinder.Create;
ContStages(ParsSett.Price.Finder as TILElementFinder,Temp.PriceStages);
end;

end.
