unit InflatablesList_ItemPictures_IO_00000001;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  Classes,
  AuxTypes,
  InflatablesList_ItemPictures_IO_00000000;

type
  TILItemPictures_IO_00000001 = class(TILItemPictures_IO_00000000)
  protected
    Function GetFlagsWord: UInt32; virtual;
    procedure SetFlagsWord(FlagsWord: UInt32); virtual;
    procedure InitSaveFunctions(Struct: UInt32); override;
    procedure InitLoadFunctions(Struct: UInt32); override;
    procedure SavePictures_00000001(Stream: TStream); virtual;
    procedure LoadPictures_00000001(Stream: TStream); virtual;
  end;

implementation

uses
  BinaryStreaming,
  InflatablesList_ItemPictures_IO;

Function TILItemPictures_IO_00000001.GetFlagsWord: UInt32;
begin
Result := 0;
end;

//------------------------------------------------------------------------------

procedure TILItemPictures_IO_00000001.SetFlagsWord(FlagsWord: UInt32);
begin
// nothing to do atm.
end;

//------------------------------------------------------------------------------

procedure TILItemPictures_IO_00000001.InitSaveFunctions(Struct: UInt32);
begin
If Struct = IL_ITEMPICTURES_STREAMSTRUCTURE_00000001 then
  begin
    fFNSaveToStream := SavePictures_00000001;
    fFNSaveEntries := SaveEntries_00000000;
    fFNSaveEntry := SaveEntry_00000000;
    fFNSaveThumbnail := SaveThumbnail_00000000;
  end
else inherited InitSaveFunctions(Struct);
end;

//------------------------------------------------------------------------------

procedure TILItemPictures_IO_00000001.InitLoadFunctions(Struct: UInt32);
begin
If Struct = IL_ITEMPICTURES_STREAMSTRUCTURE_00000001 then
  begin
    fFNLoadFromStream := LoadPictures_00000001;
    fFNLoadEntries := LoadEntries_00000000;
    fFNLoadEntry := LoadEntry_00000000;
    fFNLoadThumbnail := LoadThumbnail_00000000;
  end
else inherited InitLoadFunctions(Struct);
end;

//------------------------------------------------------------------------------

procedure TILItemPictures_IO_00000001.SavePictures_00000001(Stream: TStream);
begin
Stream_WriteUInt32(Stream,GetFlagsWord);
// rest of the structure is unchanged
SavePictures_00000000(Stream);
end;

//------------------------------------------------------------------------------

procedure TILItemPictures_IO_00000001.LoadPictures_00000001(Stream: TStream);
begin
SetFlagsWord(Stream_ReadUInt32(Stream));
LoadPictures_00000000(Stream);
end;

end.
