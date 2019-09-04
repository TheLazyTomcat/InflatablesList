unit InflatablesList_Manager_IO_00000008;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  Classes,
  AuxTypes,
  InflatablesList_Manager_IO;

type
  TILManager_IO_00000008 = class(TILManager_IO)
  protected
    procedure InitSaveFunctions(Struct: UInt32); override;
    procedure InitLoadFunctions(Struct: UInt32); override;
    procedure SaveList_00000008(Stream: TStream); virtual;
    procedure LoadList_00000008(Stream: TStream); virtual;
    procedure SaveSortingSettings_00000008(Stream: TStream); virtual;
    procedure LoadSortingSettings_00000008(Stream: TStream); virtual;
    procedure SaveShopTemplates_00000008(Stream: TStream); virtual;
    procedure LoadShopTemplates_00000008(Stream: TStream); virtual;
    procedure SaveFilterSettings_00000008(Stream: TStream); virtual;
    procedure LoadFilterSettings_00000008(Stream: TStream); virtual;
    procedure SaveItems_00000008(Stream: TStream); virtual;
    procedure LoadItems_00000008(Stream: TStream); virtual;
    // conversion from version 7 to 8
    class procedure Convert_SortingSettings(Stream, ConvStream: TStream); virtual;
    class procedure Convert_ShopTemplates(Stream, ConvStream: TStream); virtual;
    class procedure Convert_FilterSettings(Stream, ConvStream: TStream); virtual;
    class procedure Convert_Items(Stream, ConvStream: TStream); virtual;
    procedure Load(Stream: TStream; Struct: UInt32); override;
  public
    class procedure Convert(Stream: TStream); virtual;      
  end;

implementation

uses
  SysUtils,
  BinaryStreaming,
  InflatablesList_Types,
  InflatablesList_Utils,
  InflatablesList_Item,
  InflatablesList_ItemShopTemplate;

procedure TILManager_IO_00000008.InitSaveFunctions(Struct: UInt32);
begin
If Struct = IL_LISTFILE_STREAMSTRUCTURE_00000008 then
  begin
    fFNSaveToStream := SaveList_00000008;
    fFNSaveSortingSettings := SaveSortingSettings_00000008;
    fFNSaveShopTemplates := SaveShopTemplates_00000008;
    fFNSaveFilterSettings := SaveFilterSettings_00000008;
    fFNSaveItems := SaveItems_00000008;
  end
else raise Exception.CreateFmt('TILManager_IO_00000008.InitSaveFunctions: Invalid stream structure (%.8x).',[Struct]);
end;

//------------------------------------------------------------------------------

procedure TILManager_IO_00000008.InitLoadFunctions(Struct: UInt32);
begin
If Struct = IL_LISTFILE_STREAMSTRUCTURE_00000008 then
  begin
    fFNLoadFromStream := LoadList_00000008;
    fFNLoadSortingSettings := LoadSortingSettings_00000008;
    fFNLoadShopTemplates := LoadShopTemplates_00000008;
    fFNLoadFilterSettings := LoadFilterSettings_00000008;
    fFNLoadItems := LoadItems_00000008;
  end
else raise Exception.CreateFmt('TILManager_IO_00000008.InitLoadFunctions: Invalid stream structure (%.8x).',[Struct]);
end;

//------------------------------------------------------------------------------

procedure TILManager_IO_00000008.SaveList_00000008(Stream: TStream);
begin
Stream_WriteString(Stream,IL_FormatDateTime('yyyy-mm-dd-hh-nn-ss-zzz',Now));
fFNSaveSortingSettings(Stream);
fFNSaveShopTemplates(Stream);
fFNSaveFilterSettings(Stream);
fFNSaveItems(Stream);
end;

//------------------------------------------------------------------------------

procedure TILManager_IO_00000008.LoadList_00000008(Stream: TStream);
begin
Stream_ReadString(Stream);  // discard time
fFNLoadSortingSettings(Stream);
fFNLoadShopTemplates(Stream);
fFNLoadFilterSettings(Stream);
fFNLoadItems(Stream);
end;

//------------------------------------------------------------------------------

procedure TILManager_IO_00000008.SaveSortingSettings_00000008(Stream: TStream);
var
  i:  Integer;

  procedure SaveSortingSettings(const Settings: TILSortingSettings);
  var
    ii: Integer;
  begin
    Stream_WriteUInt32(Stream,Settings.Count);
    For ii := Low(Settings.Items) to High(Settings.Items) do
      begin
        Stream_WriteInt32(Stream,IL_ItemValueTagToNum(Settings.Items[ii].ItemValueTag));
        Stream_WriteBool(Stream,Settings.Items[ii].Reversed);
      end;
  end;

begin
Stream_WriteString(Stream,'SORT');
// save reversed flag
Stream_WriteBool(Stream,fReversedSort);
// save actual sort settings
SaveSortingSettings(fActualSortSett);
// save sorting profiles
Stream_WriteUInt32(Stream,SortingProfileCount);
For i := 0 to Pred(SortingProfileCount) do
  begin
    Stream_WriteString(Stream,fSortingProfiles[i].Name);
    SaveSortingSettings(fSortingProfiles[i].Settings);
  end;
end;

//------------------------------------------------------------------------------

procedure TILManager_IO_00000008.LoadSortingSettings_00000008(Stream: TStream);
var
  i:  Integer;

  procedure LoadSortingSettings(out Settings: TILSortingSettings);
  var
    ii: Integer;
  begin
    Settings.Count := Stream_ReadUInt32(Stream);
    For ii := Low(Settings.Items) to High(Settings.Items) do
      begin
        Settings.Items[ii].ItemValueTag := IL_NumToItemValueTag(Stream_ReadInt32(Stream));
        Settings.Items[ii].Reversed := Stream_ReadBool(Stream);
      end;
  end;

begin
If IL_SameStr(Stream_ReadString(Stream),'SORT') then
  begin
    // load resed flag
    fReversedSort := Stream_ReadBool(Stream);
    // load actual sort settings
    LoadSortingSettings(fActualSortSett);
    // now load profiles
    SortingProfileClear;
    SetLength(fSortingProfiles,Stream_ReadUInt32(Stream));
    For i := Low(fSortingProfiles) to High(fSortingProfiles) do
      begin
        fSortingProfiles[i].Name := Stream_ReadString(Stream);
        LoadSortingSettings(fSortingProfiles[i].Settings);
      end;
  end
else raise Exception.Create('TILManager_IO_00000008.LoadSortingSettings_00000008: Invalid stream.');
end;

//------------------------------------------------------------------------------

procedure TILManager_IO_00000008.SaveShopTemplates_00000008(Stream: TStream);
var
  i:  Integer;
begin
Stream_WriteString(Stream,'TEMPLATES');
Stream_WriteUInt32(Stream,ShopTemplateCount);
For i := 0 to Pred(ShopTemplateCount) do
  fShopTemplates[i].SaveToStream(Stream);
end;

//------------------------------------------------------------------------------

procedure TILManager_IO_00000008.LoadShopTemplates_00000008(Stream: TStream);
var
  i:  Integer;
begin
If IL_SameStr(Stream_ReadString(Stream),'TEMPLATES') then
  begin
    ShopTemplateClear;
    SetLength(fShopTemplates,Stream_ReadUInt32(Stream));
    For i := 0 to Pred(ShopTemplateCount) do
      begin
        fShopTemplates[i] := TILItemShopTemplate.Create;
        fShopTemplates[i].StaticSettings := fStaticSettings;
        fShopTemplates[i].LoadFromStream(Stream);
      end;
  end
else raise Exception.Create('TILManager_IO_00000008.LoadShopTemplates_00000008: Invalid stream.');
end;

//------------------------------------------------------------------------------

procedure TILManager_IO_00000008.SaveFilterSettings_00000008(Stream: TStream);
begin
Stream_WriteString(Stream,'FILTER');
Stream_WriteInt32(Stream,IL_FilterOperatorToNum(fFilterSettings.Operator));
Stream_WriteUInt32(Stream,IL_EncodeFilterFlags(fFilterSettings.Flags));
end;

//------------------------------------------------------------------------------

procedure TILManager_IO_00000008.LoadFilterSettings_00000008(Stream: TStream);
begin
If IL_SameStr(Stream_ReadString(Stream),'FILTER') then
  begin
    fFilterSettings.Operator := IL_NumToFilterOperator(Stream_ReadInt32(Stream));
    fFilterSettings.Flags := IL_DecodeFilterFlags(Stream_ReadUInt32(Stream));
  end
else raise Exception.Create('TILManager_IO_00000008.LoadFilterSettings_00000008: Invalid stream.');
end;

//------------------------------------------------------------------------------

procedure TILManager_IO_00000008.SaveItems_00000008(Stream: TStream);
var
  i:  Integer;
begin
Stream_WriteString(Stream,'ITEMS');
Stream_WriteUInt32(Stream,ItemCount);
For i := ItemLowIndex to ItemHighIndex do
  fList[i].SaveToStream(Stream);
end;

//------------------------------------------------------------------------------

procedure TILManager_IO_00000008.LoadItems_00000008(Stream: TStream);
var
  i:  Integer;
begin
If IL_SameStr(Stream_ReadString(Stream),'ITEMS') then
  begin
    ItemClear;
    SetLength(fList,Stream_ReadUInt32(Stream));
    fCount := Length(fList);
    For i := ItemLowIndex to ItemHighIndex do
      begin
        fList[i] := TILItem.Create(fDataProvider);
        // StaticSettings must be set must be before load so it is propagated to item shops
        fList[i].StaticSettings := fStaticSettings;
        fList[i].LoadFromStream(Stream);
        fList[i].Index := i;
        fList[i].AssignInternalEvents(
          ShopUpdateShopListItemHandler,
          ShopUpdateValuesHandler,
          ShopUpdateAvailHistoryHandler,
          ShopUpdatePriceHistoryHandler,
          ItemUpdateMainListHandler,
          ItemUpdateSmallListHandler,
          ItemUpdateOverviewHandler,
          ItemUpdateTitleHandler,
          ItemUpdatePicturesHandler,
          ItemUpdateFlagsHandler,
          ItemUpdateValuesHandler,
          ItemUpdateShopListHandler);
      end;
  end
else raise Exception.Create('TILManager_IO_00000008.LoadItems_00000008: Invalid stream.');
end;

//------------------------------------------------------------------------------

class procedure TILManager_IO_00000008.Convert_SortingSettings(Stream, ConvStream: TStream);
var
  Cntr: UInt32;
  i:    Integer;

  procedure ConvertSortingSettings;
  var
    ii: Integer;
  begin
    Stream_WriteUInt32(ConvStream,Stream_ReadUInt32(Stream));
    For ii := 0 to 29 do 
      begin
        Stream_WriteInt32(ConvStream,Stream_ReadInt32(Stream));
        Stream_WriteBool(ConvStream,Stream_ReadBool(Stream));
      end;
  end;

begin
Stream_WriteString(ConvStream,'SORT');
// data itself are the same, do plain copy...
// reversed flag
Stream_WriteBool(ConvStream,Stream_ReadBool(Stream));
// actual sort settings
ConvertSortingSettings;
// sorting profiles
Cntr := Stream_ReadUInt32(Stream);
Stream_WriteUInt32(ConvStream,Cntr);
For i := 0 to Pred(Cntr) do
  begin
    Stream_WriteString(ConvStream,Stream_ReadString(Stream));
    ConvertSortingSettings;
  end;
end;

//------------------------------------------------------------------------------

class procedure TILManager_IO_00000008.Convert_ShopTemplates(Stream, ConvStream: TStream);
var
  Cntr: UInt32;
  i:    Integer;
begin
Stream_WriteString(ConvStream,'TEMPLATES');
Cntr := Stream_ReadUInt32(Stream);
Stream_WriteUInt32(ConvStream,Cntr);
For i := 0 to Pred(Cntr) do
  TILItemShopTemplate.Convert(Stream,ConvStream);
end;

//------------------------------------------------------------------------------

class procedure TILManager_IO_00000008.Convert_FilterSettings(Stream, ConvStream: TStream);
begin
Stream_WriteString(ConvStream,'FILTER');
// no change to data
Stream_WriteInt32(ConvStream,Stream_ReadInt32(Stream));   // Operator
Stream_WriteUInt32(ConvStream,Stream_ReadUInt32(Stream)); // Flags
end;

//------------------------------------------------------------------------------

class procedure TILManager_IO_00000008.Convert_Items(Stream, ConvStream: TStream);
var
  Cntr: UInt32;
  i:    Integer;
begin
Stream_WriteString(ConvStream,'ITEMS');
Cntr := Stream_ReadUInt32(Stream);
Stream_WriteUInt32(ConvStream,Cntr);
For i := 0 to Pred(Cntr) do
  TILItem.Convert(Stream,ConvStream);
end;

//------------------------------------------------------------------------------

procedure TILManager_IO_00000008.Load(Stream: TStream; Struct: UInt32);
begin
If Struct = IL_LISTFILE_STREAMSTRUCTURE_00000007 then
  begin
    Convert(Stream);
    inherited Load(Stream,IL_LISTFILE_STREAMSTRUCTURE_00000008);
  end
else inherited Load(Stream,Struct);
end;

//==============================================================================

class procedure TILManager_IO_00000008.Convert(Stream: TStream);
var
  ConvertStream:  TMemoryStream;
  StartPos:       Int64;
begin
// at this point, stream position is just after structure selection
ConvertStream := TMemoryStream.Create;
try
  ConvertStream.Size := Stream.Size - Stream.Position;
  ConvertStream.Seek(0,soBeginning);
  StartPos := Stream.Position;
  try
    Stream_WriteString(ConvertStream,Stream_ReadString(Stream)); // time
    Convert_SortingSettings(Stream,ConvertStream);
    Convert_ShopTemplates(Stream,ConvertStream);
    Convert_FilterSettings(Stream,ConvertStream);
    Convert_Items(Stream,ConvertStream);
    Stream.Seek(StartPos,soBeginning);
    Stream.CopyFrom(ConvertStream,0);
    // do not alter stream size
  finally
    Stream.Seek(StartPos,soBeginning);
  end;
finally
  ConvertStream.Free;
end;
end;

end.
