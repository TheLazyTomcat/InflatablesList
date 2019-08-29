unit InflatablesList_Item_IO;{$message 'revisit'}

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  Classes, Graphics,
  AuxTypes,
  InflatablesList_Item_Comp;

const
  IL_ITEM_SIGNATURE = UInt32($4D455449);  // ITEM

  IL_ITEM_STREAMSTRUCTURE_00000000 = UInt32($00000000);
  IL_ITEM_STREAMSTRUCTURE_00000001 = UInt32($00000001);
  IL_ITEM_STREAMSTRUCTURE_00000002 = UInt32($00000002);
  IL_ITEM_STREAMSTRUCTURE_00000003 = UInt32($00000003);
  IL_ITEM_STREAMSTRUCTURE_00000004 = UInt32($00000004);
  IL_ITEM_STREAMSTRUCTURE_00000005 = UInt32($00000005);

  IL_ITEM_STREAMSTRUCTURE_SAVE = IL_ITEM_STREAMSTRUCTURE_00000005;

type
  TILItem_IO = class(TILItem_Comp)
  protected
    fFNSaveToStream:    procedure(Stream: TStream) of object;
    fFNLoadFromStream:  procedure(Stream: TStream) of object;
    fFNSavePicture:     procedure(Stream: TStream; Pic: TBitmap) of object;
    fFNLoadPicture:     procedure(Stream: TStream; out Pic: TBitmap) of object;
    procedure InitSaveFunctions(Struct: UInt32); virtual; abstract;
    procedure InitLoadFunctions(Struct: UInt32); virtual; abstract;
    procedure Save(Stream: TStream; Struct: UInt32); virtual;
    procedure Load(Stream: TStream; Struct: UInt32); virtual;
    procedure AfterLoad; virtual;
  public
    procedure SaveToStream(Stream: TStream); virtual;
    procedure LoadFromStream(Stream: TStream); virtual;    
    procedure SaveToFile(const FileName: String); virtual;
    procedure LoadFromFile(const FileName: String); virtual;  
  end;

implementation

uses
  SysUtils,
  BinaryStreaming;

procedure TILItem_IO.Save(Stream: TStream; Struct: UInt32);
begin
InitSaveFunctions(Struct);
fFNSaveToStream(Stream);
end;

//------------------------------------------------------------------------------

procedure TILItem_IO.Load(Stream: TStream; Struct: UInt32);
begin
InitLoadFunctions(Struct);
fFNLoadFromStream(Stream);
AfterLoad;
end;

//------------------------------------------------------------------------------

procedure TILItem_IO.AfterLoad;
begin
RenderSmallPictures;
end;

//==============================================================================

procedure TILItem_IO.SaveToStream(Stream: TStream);
begin
Stream_WriteUInt32(Stream,IL_ITEM_SIGNATURE);
Stream_WriteUInt32(Stream,IL_ITEM_STREAMSTRUCTURE_SAVE);
Save(Stream,IL_ITEM_STREAMSTRUCTURE_SAVE);
end;

//------------------------------------------------------------------------------

procedure TILItem_IO.LoadFromStream(Stream: TStream);
begin
If Stream_ReadUInt32(Stream) = IL_ITEM_SIGNATURE then
  Load(Stream,Stream_ReadUInt32(Stream))
else
  raise Exception.Create('TILItem_IO.LoadFromStream: Invalid stream.');
end;

//------------------------------------------------------------------------------

procedure TILItem_IO.SaveToFile(const FileName: String);
var
  FileStream: TMemoryStream;
begin
FileStream := TMemoryStream.Create;
try
  SaveToStream(FileStream);
  FileStream.SaveToFile(FileName);
finally
  FileStream.Free;
end;
end;

//------------------------------------------------------------------------------

procedure TILItem_IO.LoadFromFile(const FileName: String);
var
  FileStream: TMemoryStream;
begin
FileStream := TMemoryStream.Create;
try
  FileStream.LoadFromFile(FileName);
  FileStream.Seek(0,soBeginning);
  LoadFromStream(FileStream);
finally
  FileStream.Free;
end;
end;

end.
