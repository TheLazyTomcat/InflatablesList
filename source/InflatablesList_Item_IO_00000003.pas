unit InflatablesList_Item_IO_00000003;
{$message 'll_rework'}

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  Classes,
  AuxTypes,
  InflatablesList_Item_IO_00000002;

type
  TILItem_IO_00000003 = class(TILItem_IO_00000002)
  protected
    procedure InitSaveFunctions(Struct: UInt32); override;
    procedure InitLoadFunctions(Struct: UInt32); override;
    procedure SaveItem_00000003(Stream: TStream); virtual;
    procedure LoadItem_00000003(Stream: TStream); virtual;
  end;

implementation

uses
  BinaryStreaming,
  InflatablesList_Item_IO;

procedure TILItem_IO_00000003.InitSaveFunctions(Struct: UInt32);
begin
If Struct = IL_ITEM_STREAMSTRUCTURE_00000003 then
  begin
    fFNSaveToStream := SaveItem_00000003;
    fFNSavePicture := SavePicture_00000000;
  end
else inherited InitSaveFunctions(Struct);
end;

//------------------------------------------------------------------------------

procedure TILItem_IO_00000003.InitLoadFunctions(Struct: UInt32);
begin
If Struct = IL_ITEM_STREAMSTRUCTURE_00000003 then
  begin
    fFNLoadFromStream := LoadItem_00000003;
    fFNLoadPicture := LoadPicture_00000000;
  end
else inherited InitLoadFunctions(Struct);
end;

//------------------------------------------------------------------------------

procedure TILItem_IO_00000003.SaveItem_00000003(Stream: TStream);
begin
Stream_WriteBuffer(Stream,fUniqueID,SizeOf(fUniqueID));
// after UID, stream is the same as for ver 2
SaveItem_00000002(Stream);
end;

//------------------------------------------------------------------------------

procedure TILItem_IO_00000003.LoadItem_00000003(Stream: TStream);
begin
Stream_ReadBuffer(Stream,fUniqueID,SizeOf(fUniqueID));
// after UID, stream is the same as for ver 2
LoadItem_00000002(Stream);
end;

end.
