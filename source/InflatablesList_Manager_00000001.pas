unit InflatablesList_Manager_00000001;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  Classes,
  AuxTypes,
  InflatablesList_Manager_00000000;

type
  TILManager_00000001 = class(TILManager_00000000)
  protected
    procedure InitSaveFunctions(Struct: UInt32); override;
    procedure InitLoadFunctions(Struct: UInt32); override;
    procedure SaveSortingSettings_00000001(Stream: TStream); virtual;
    procedure LoadSortingSettings_00000001(Stream: TStream); virtual;
  end;

implementation

uses
  BinaryStreaming,
  InflatablesList_Types, InflatablesList_Manager_Base,
  InflatablesList_Manager_IO;

procedure TILManager_00000001.InitSaveFunctions(Struct: UInt32);
begin
case Struct of
  IL_LISTFILE_FILESTRUCTURE_00000001:
    begin
      fFNSaveToStream := SaveToStream_00000000;
      fFNSaveSortingSettings := SaveSortingSettings_00000001;
      fFNSaveShopTemplates := SaveShopTemplates_00000000;
      fFNSaveFilterSettings := SaveFilterSettings_00000000;
      fFNSaveItem := SaveItem_00000000;
      fFNSaveItemShop := SaveItemShop_00000000;
      fFNSaveParsingSettings := SaveParsingSettings_00000000;
      fFNExportShopTemplate := nil;
    end;
else
  inherited InitSaveFunctions(Struct);
end;
end;

//------------------------------------------------------------------------------

procedure TILManager_00000001.InitLoadFunctions(Struct: UInt32);
begin
case Struct of
  IL_LISTFILE_FILESTRUCTURE_00000001:
    begin
      fFNLoadFromStream := LoadFromStream_00000000;
      fFNLoadSortingSettings := LoadSortingSettings_00000001;
      fFNLoadShopTemplates := LoadShopTemplates_00000000;
      fFNLoadFilterSettings := LoadFilterSettings_00000000;
      fFNLoadItem := LoadItem_00000000;
      fFNLoadItemShop := LoadItemShop_00000000;
      fFNLoadParsingSettings := LoadParsingSettings_00000000;
      fFNImportShopTemplate := nil;
    end;
else
  inherited InitLoadFunctions(Struct);
end;
end;

//------------------------------------------------------------------------------

procedure TILManager_00000001.SaveSortingSettings_00000001(Stream: TStream);
var
  i,j:  Integer;
begin
// save resed flag
Stream_WriteBool(Stream,fReversedSort);
// save actual sort settings
SaveSortingSettings_00000000(Stream);
// now save profiles
Stream_WriteUInt32(Stream,Length(fSortingProfiles));
For i := Low(fSortingProfiles) to High(fSortingProfiles) do
  begin
    Stream_WriteString(Stream,fSortingProfiles[i].Name);
    Stream_WriteUInt32(Stream,fSortingProfiles[i].Settings.Count);
    For j := Low(fSortingProfiles[i].Settings.Items) to High(fSortingProfiles[i].Settings.Items) do
      begin
        Stream_WriteInt32(Stream,IL_ItemValueTagToNum(fSortingProfiles[i].Settings.Items[j].ItemValueTag));
        Stream_WriteBool(Stream,fSortingProfiles[i].Settings.Items[j].Reversed);
      end;
  end;
end;
 
//------------------------------------------------------------------------------

procedure TILManager_00000001.LoadSortingSettings_00000001(Stream: TStream);
var
  i,j:  Integer;
begin
// load resed flag
fReversedSort := Stream_ReadBool(Stream);
// load actual sort settings
LoadSortingSettings_00000000(Stream);
// now load profiles
SetLength(fSortingProfiles,Stream_ReadUInt32(Stream));
For i := Low(fSortingProfiles) to High(fSortingProfiles) do
  begin
    fSortingProfiles[i].Name := Stream_ReadString(Stream);
    fSortingProfiles[i].Settings.Count := Stream_ReadUInt32(Stream);
    For j := Low(fSortingProfiles[i].Settings.Items) to High(fSortingProfiles[i].Settings.Items) do
      begin
        fSortingProfiles[i].Settings.Items[j].ItemValueTag := IL_NumToItemValueTag(Stream_ReadInt32(Stream));
        fSortingProfiles[i].Settings.Items[j].Reversed := Stream_ReadBool(Stream);
      end;
  end;
end;

end.
