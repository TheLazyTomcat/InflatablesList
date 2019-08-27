unit InflatablesList_Manager_IO_0000000A;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  Classes,
  AuxTypes,
  InflatablesList_Manager_IO_00000009;

type
  TILManager_IO_0000000A = class(TILManager_IO_00000009)
  protected
    procedure InitSaveFunctions(Struct: UInt32); override;
    procedure InitLoadFunctions(Struct: UInt32); override;
    procedure SaveList_0000000A(Stream: TStream); virtual;
    procedure LoadList_0000000A(Stream: TStream); virtual;
  end;

implementation

uses
  SysUtils,
  BinaryStreaming,
  InflatablesList_Manager_IO;

procedure TILManager_IO_0000000A.InitSaveFunctions(Struct: UInt32);
begin
If Struct = IL_LISTFILE_STREAMSTRUCTURE_0000000A then
  begin
    fFNSaveToStream := SaveList_0000000A;
    fFNSaveSortingSettings := SaveSortingSettings_00000008;
    fFNSaveShopTemplates := SaveShopTemplates_00000008;
    fFNSaveFilterSettings := SaveFilterSettings_00000008;
    fFNSaveItems := SaveItems_00000008;
  end
else inherited InitSaveFunctions(Struct);
end;

//------------------------------------------------------------------------------

procedure TILManager_IO_0000000A.InitLoadFunctions(Struct: UInt32);
begin
If Struct = IL_LISTFILE_STREAMSTRUCTURE_0000000A then
  begin
    fFNLoadFromStream := LoadList_0000000A;
    fFNLoadSortingSettings := LoadSortingSettings_00000008;
    fFNLoadShopTemplates := LoadShopTemplates_00000008;
    fFNLoadFilterSettings := LoadFilterSettings_00000008;
    fFNLoadItems := LoadItems_00000008;
  end
else
inherited InitLoadFunctions(Struct);
end;

//------------------------------------------------------------------------------

procedure TILManager_IO_0000000A.SaveList_0000000A(Stream: TStream);
begin
// the main structure is the same as in version 9, only difference is the
// validity check value at the end
SaveList_00000009(Stream);
Stream_WriteUInt64(Stream,IL_LISTFILE_VALIDITYCHECK);
end;

//------------------------------------------------------------------------------

procedure TILManager_IO_0000000A.LoadList_0000000A(Stream: TStream);
begin
LoadList_00000009(Stream);
// validity check is discarded, it is used only for decryption
Stream_ReadUInt64(Stream);
end;

end.
