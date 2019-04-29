unit InflatablesList_Manager_VER00000001;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  Classes,
  AuxTypes,
  InflatablesList_Manager_VER00000000;

type
  TILManager_VER00000001 = class(TILManager_VER00000000)
  protected
    procedure SaveData(Stream: TStream; Struct: UInt32); override;
    procedure SaveToStream_VER00000001(Stream: TStream); virtual;
    procedure SaveSortingSettings_VER00000001(Stream: TStream); virtual;
    procedure LoadData(Stream: TStream; Struct: UInt32); override;
    procedure LoadFromStream_VER00000001(Stream: TStream); virtual;
    procedure LoadSortingSettings_VER00000001(Stream: TStream); virtual;
  end;

implementation

uses
  BinaryStreaming,
  InflatablesList_Types, InflatablesList_Manager_Base;

procedure TILManager_VER00000001.SaveData(Stream: TStream; Struct: UInt32);
begin
case Struct of
  IL_LISTFILE_FILESTRUCTURE_00000001: SaveToStream_VER00000001(Stream);
else
  inherited SaveData(Stream,Struct);
end;
end;

//------------------------------------------------------------------------------

procedure TILManager_VER00000001.SaveToStream_VER00000001(Stream: TStream);
var
  i:  Integer;
begin
SaveSortingSettings_VER00000001(Stream);
SaveShopTemplates_VER00000000(Stream);
SaveFilterSettings_VER00000000(Stream);
// items
Stream_WriteUInt32(Stream,Length(fList));
For i := Low(fList) to High(fList) do
  SaveItem_VER00000000(Stream,fList[i]);
end;

//------------------------------------------------------------------------------

procedure TILManager_VER00000001.SaveSortingSettings_VER00000001(Stream: TStream);
var
  i,j:  Integer;
begin
// save actual sort settings
SaveSortingSettings_VER00000000(Stream);
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

procedure TILManager_VER00000001.LoadData(Stream: TStream; Struct: UInt32);
begin
case Struct of
  IL_LISTFILE_FILESTRUCTURE_00000001: LoadFromStream_VER00000001(Stream);
else
  inherited LoadData(Stream,Struct);
end;
end;

//------------------------------------------------------------------------------

procedure TILManager_VER00000001.LoadFromStream_VER00000001(Stream: TStream);
var
  i:  Integer;
begin
LoadSortingSettings_VER00000001(Stream);
LoadShopTemplates_VER00000000(Stream);
LoadFilterSettings_VER00000000(Stream);
// items
ItemClear;
SetLength(fList,Stream_ReadUInt32(Stream));
For i := Low(fList) to High(fList) do
  LoadItem_VER00000000(Stream,fList[i]);
ReIndex;
ItemRedraw;
end;

//------------------------------------------------------------------------------

procedure TILManager_VER00000001.LoadSortingSettings_VER00000001(Stream: TStream);
var
  i,j:  Integer;
begin
// load actual sort settings
LoadSortingSettings_VER00000000(Stream);
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
