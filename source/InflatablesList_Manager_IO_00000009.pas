unit InflatablesList_Manager_IO_00000009;{$message 'revisit'}

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  Classes,
  AuxTypes,
  InflatablesList_Manager_IO_00000008;

type
  TILManager_IO_00000009 = class(TILManager_IO_00000008)
  protected
    procedure InitSaveFunctions(Struct: UInt32); override;
    procedure InitLoadFunctions(Struct: UInt32); override;
    procedure SaveList_00000009(Stream: TStream); virtual;
    procedure LoadList_00000009(Stream: TStream); virtual;
  end;

implementation

uses
  SysUtils,
  BinaryStreaming,
  InflatablesList_Manager_IO;

procedure TILManager_IO_00000009.InitSaveFunctions(Struct: UInt32);
begin
If Struct = IL_LISTFILE_STREAMSTRUCTURE_00000009 then
  begin
    fFNSaveToStream := SaveList_00000009;
    fFNSaveSortingSettings := SaveSortingSettings_00000008;
    fFNSaveShopTemplates := SaveShopTemplates_00000008;
    fFNSaveFilterSettings := SaveFilterSettings_00000008;
    fFNSaveItems := SaveItems_00000008;
  end
else inherited InitSaveFunctions(Struct);
end;

//------------------------------------------------------------------------------

procedure TILManager_IO_00000009.InitLoadFunctions(Struct: UInt32);
begin
If Struct = IL_LISTFILE_STREAMSTRUCTURE_00000009 then
  begin
    fFNLoadFromStream := LoadList_00000009;
    fFNLoadSortingSettings := LoadSortingSettings_00000008;
    fFNLoadShopTemplates := LoadShopTemplates_00000008;
    fFNLoadFilterSettings := LoadFilterSettings_00000008;
    fFNLoadItems := LoadItems_00000008;
  end
else
inherited InitLoadFunctions(Struct);
end;

//------------------------------------------------------------------------------

procedure TILManager_IO_00000009.SaveList_00000009(Stream: TStream);
begin
Stream_WriteString(Stream,FormatDateTime('yyyy-mm-dd-hh-nn-ss-zzz',Now));
fFNSaveSortingSettings(Stream);
fFNSaveShopTemplates(Stream);
fFNSaveFilterSettings(Stream);
fFNSaveItems(Stream);
Stream_WriteString(Stream,fNotes);
end;

//------------------------------------------------------------------------------

procedure TILManager_IO_00000009.LoadList_00000009(Stream: TStream);
begin
Stream_ReadString(Stream);  // discard time
fFNLoadSortingSettings(Stream);
fFNLoadShopTemplates(Stream);
fFNLoadFilterSettings(Stream);
fFNLoadItems(Stream);
fNotes := Stream_ReadString(Stream);
end;

end.
