unit InflatablesList_ItemPictures_IO;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  Classes, Graphics,
  AuxTypes,
  InflatablesList_ItemPictures_Base;

const
  IL_ITEMPICTURES_SIGNATURE = UInt32($43495049);  // IPIC

  IL_ITEMPICTURES_STREAMSTRUCTURE_00000000 = UInt32($00000000);
  IL_ITEMPICTURES_STREAMSTRUCTURE_00000001 = UInt32($00000001);

  IL_ITEMPICTURES_STREAMSTRUCTURE_SAVE = IL_ITEMPICTURES_STREAMSTRUCTURE_00000001;

type
  TILItemPictures_IO = class(TILItemPictures_Base)
  protected
    fFNSaveToStream:    procedure(Stream: TStream) of object;
    fFNLoadFromStream:  procedure(Stream: TStream) of object;
    fFNSaveEntries:     procedure(Stream: TStream) of object;
    fFNLoadEntries:     procedure(Stream: TStream) of object;
    fFNSaveEntry:       procedure(Stream: TStream; Entry: TILItemPicturesEntry) of object;
    fFNLoadEntry:       procedure(Stream: TStream; out Entry: TILItemPicturesEntry) of object;
    fFNSaveThumbnail:   procedure(Stream: TStream; Thumbnail: TBitmap) of object;
    fFNLoadThumbnail:   procedure(Stream: TStream; out Thumbnail: TBitmap) of object;
    procedure InitSaveFunctions(Struct: UInt32); virtual; abstract;
    procedure InitLoadFunctions(Struct: UInt32); virtual; abstract;
    procedure Save(Stream: TStream; Struct: UInt32); virtual;
    procedure Load(Stream: TStream; Struct: UInt32); virtual;
  public
    procedure SaveToStream(Stream: TStream); virtual;
    procedure LoadFromStream(Stream: TStream); virtual;
    procedure SaveToFile(const FileName: String); virtual;
    procedure LoadFromFile(const FileName: String); virtual;
  end;

implementation

uses
  SysUtils,
  BinaryStreaming, StrRect;

procedure TILItemPictures_IO.Save(Stream: TStream; Struct: UInt32);
begin
InitSaveFunctions(Struct);
fFNSaveToStream(Stream);
end;

//------------------------------------------------------------------------------

procedure TILItemPictures_IO.Load(Stream: TStream; Struct: UInt32);
begin
InitLoadFunctions(Struct);
fFNLoadFromStream(Stream);
fCurrentSecondary := -1;
NextSecondary;
end;

//==============================================================================

procedure TILItemPictures_IO.SaveToStream(Stream: TStream);
begin
Stream_WriteUInt32(Stream,IL_ITEMPICTURES_SIGNATURE);
Stream_WriteUInt32(Stream,IL_ITEMPICTURES_STREAMSTRUCTURE_SAVE);
Save(Stream,IL_ITEMPICTURES_STREAMSTRUCTURE_SAVE);
end;

//------------------------------------------------------------------------------

procedure TILItemPictures_IO.LoadFromStream(Stream: TStream);
begin
If Stream_ReadUInt32(Stream) = IL_ITEMPICTURES_SIGNATURE then
  Load(Stream,Stream_ReadUInt32(Stream))
else
  raise Exception.Create('TILItemPictures_IO.LoadFromStream: Invalid stream.');
end;

//------------------------------------------------------------------------------

procedure TILItemPictures_IO.SaveToFile(const FileName: String);
var
  FileStream: TMemoryStream;
begin
FileStream := TMemoryStream.Create;
try
  SaveToStream(FileStream);
  FileStream.SaveToFile(StrToRTL(FileName));
finally
  FileStream.Free;
end;
end;

//------------------------------------------------------------------------------

procedure TILItemPictures_IO.LoadFromFile(const FileName: String);
var
  FileStream: TMemoryStream;
begin
FileStream := TMemoryStream.Create;
try
  FileStream.LoadFromFile(StrToRTL(FileName));
  FileStream.Seek(0,soBeginning);
  LoadFromStream(FileStream);
finally
  FileStream.Free;
end;
end;

end.
