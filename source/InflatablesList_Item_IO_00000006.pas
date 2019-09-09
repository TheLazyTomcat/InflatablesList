unit InflatablesList_Item_IO_00000006;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  Classes,
  AuxTypes,
  InflatablesList_Item_IO_00000005;

type
  TILItem_IO_00000006 = class(TILItem_IO_00000005)
  protected
    Function GetFlagsWord: UInt32; virtual;
    procedure SetFlagsWord(FlagsWord: UInt32); virtual;
    procedure InitSaveFunctions(Struct: UInt32); override;
    procedure InitLoadFunctions(Struct: UInt32); override;
    procedure SaveItem_00000006(Stream: TStream); virtual;
    procedure LoadItem_00000006(Stream: TStream); virtual;
  end;

implementation

uses
  BinaryStreaming,
  InflatablesList_Item_IO;

Function TILItem_IO_00000006.GetFlagsWord: UInt32;
begin
Result := 0;
end;

//------------------------------------------------------------------------------

procedure TILItem_IO_00000006.SetFlagsWord(FlagsWord: UInt32);
begin
// nothing to do
end;

//------------------------------------------------------------------------------

procedure TILItem_IO_00000006.InitSaveFunctions(Struct: UInt32);
begin
If Struct = IL_ITEM_STREAMSTRUCTURE_00000006 then
  begin
    fFNSaveToStream := SaveItem_00000006;
    fFNSavePicture := SavePicture_00000000;
  end
else inherited InitSaveFunctions(Struct);
end;

//------------------------------------------------------------------------------

procedure TILItem_IO_00000006.InitLoadFunctions(Struct: UInt32);
begin
If Struct = IL_ITEM_STREAMSTRUCTURE_00000006 then
  begin
    fFNLoadFromStream := LoadItem_00000006;
    fFNLoadPicture := LoadPicture_00000000;
  end
else inherited InitLoadFunctions(Struct);
end;

//------------------------------------------------------------------------------

procedure TILItem_IO_00000006.SaveItem_00000006(Stream: TStream);
begin
Stream_WriteUInt32(Stream,GetFlagsWord);
// rest of the structure is unchanged from ver 5
SaveItem_00000005(Stream);
end;

//------------------------------------------------------------------------------

procedure TILItem_IO_00000006.LoadItem_00000006(Stream: TStream);
begin
SetFlagsWord(Stream_ReadUInt32(Stream));
LoadItem_00000005(Stream);
end;

end.
