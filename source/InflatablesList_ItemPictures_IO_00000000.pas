unit InflatablesList_ItemPictures_IO_00000000;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  Classes, Graphics,
  AuxTypes,
  InflatablesList_ItemPictures_Base,
  InflatablesList_ItemPictures_IO;

type
  TILItemPictures_IO_00000000 = class(TILItemPictures_IO)
  protected
    procedure InitSaveFunctions(Struct: UInt32); override;
    procedure InitLoadFunctions(Struct: UInt32); override;
    procedure SavePictures_00000000(Stream: TStream); virtual;
    procedure LoadPictures_00000000(Stream: TStream); virtual;
    procedure SaveEntries_00000000(Stream: TStream); virtual;
    procedure LoadEntries_00000000(Stream: TStream); virtual;
    procedure SaveEntry_00000000(Stream: TStream; Entry: TILItemPicturesEntry); virtual;
    procedure LoadEntry_00000000(Stream: TStream; out Entry: TILItemPicturesEntry); virtual;
    procedure SaveThumbnail_00000000(Stream: TStream; Thumbnail: TBitmap); virtual;
    procedure LoadThumbnail_00000000(Stream: TStream; out Thumbnail: TBitmap); virtual;
  end;

implementation

uses
  SysUtils,
  BinaryStreaming;

procedure TILItemPictures_IO_00000000.InitSaveFunctions(Struct: UInt32);
begin
If Struct = IL_ITEMPICTURES_STREAMSTRUCTURE_00000000 then
  begin
    fFNSaveToStream := SavePictures_00000000;
    fFNSaveEntries := SaveEntries_00000000;
    fFNSaveEntry := SaveEntry_00000000;
    fFNSaveThumbnail := SaveThumbnail_00000000;
  end
else raise Exception.CreateFmt('TILItemPictures_IO_00000000.InitSaveFunctions: Invalid stream structure (%.8x).',[Struct]);
end;

//------------------------------------------------------------------------------

procedure TILItemPictures_IO_00000000.InitLoadFunctions(Struct: UInt32);
begin
If Struct = IL_ITEMPICTURES_STREAMSTRUCTURE_00000000 then
  begin
    fFNLoadFromStream := LoadPictures_00000000;
    fFNLoadEntries := LoadEntries_00000000;
    fFNLoadEntry := LoadEntry_00000000;
    fFNLoadThumbnail := LoadThumbnail_00000000;
  end
else raise Exception.CreateFmt('TILItemPictures_IO_00000000.InitLoadFunctions: Invalid stream structure (%.8x).',[Struct]);
end;

//------------------------------------------------------------------------------

procedure TILItemPictures_IO_00000000.SavePictures_00000000(Stream: TStream);
begin
// in this version, nothing is saved beyond the entries
fFNSaveEntries(Stream);
end;

//------------------------------------------------------------------------------

procedure TILItemPictures_IO_00000000.LoadPictures_00000000(Stream: TStream);
begin
fFNLoadEntries(Stream);
end;

//------------------------------------------------------------------------------

procedure TILItemPictures_IO_00000000.SaveEntries_00000000(Stream: TStream);
var
  i:  Integer;
begin
Stream_WriteUInt32(Stream,UInt32(fCount));
For i := LowIndex to HighIndex do
  SaveEntry_00000000(Stream,fPictures[i]);
end;

//------------------------------------------------------------------------------

procedure TILItemPictures_IO_00000000.LoadEntries_00000000(Stream: TStream);
var
  i:  Integer;
begin
SetLength(fPictures,Stream_ReadUInt32(Stream));
fCount := Length(fPictures);
For i := LowIndex to HighIndex do
  LoadEntry_00000000(Stream,fPictures[i]);
end;

//------------------------------------------------------------------------------

procedure TILItemPictures_IO_00000000.SaveEntry_00000000(Stream: TStream; Entry: TILItemPicturesEntry);
begin
Stream_WriteString(Stream,Entry.PictureFile);
Stream_WriteUInt64(Stream,Entry.PictureSize);
Stream_WriteInt32(Stream,Entry.PictureWidth);
Stream_WriteInt32(Stream,Entry.PictureHeight);
fFNSaveThumbnail(Stream,Entry.Thumbnail);
Stream_WriteBool(Stream,Entry.ItemPicture);
Stream_WriteBool(Stream,Entry.PackagePicture);
end;

//------------------------------------------------------------------------------

procedure TILItemPictures_IO_00000000.LoadEntry_00000000(Stream: TStream; out Entry: TILItemPicturesEntry);
begin
FreeEntry(Entry);
Entry.PictureFile := Stream_ReadString(Stream);
Entry.PictureSize := Stream_ReadUInt64(Stream);
Entry.PictureWidth := Stream_ReadInt32(Stream);
Entry.PictureHeight := Stream_ReadInt32(Stream);
fFNLoadThumbnail(Stream,Entry.Thumbnail);
GenerateSmallThumbnails(Entry);
Entry.ItemPicture := Stream_ReadBool(Stream);
Entry.PackagePicture := Stream_ReadBool(Stream);
end;

//------------------------------------------------------------------------------

procedure TILItemPictures_IO_00000000.SaveThumbnail_00000000(Stream: TStream; Thumbnail: TBitmap);
var
  TempStream: TMemoryStream;
begin
If Assigned(Thumbnail) then
  begin
    TempStream := TMemoryStream.Create;
    try
      Thumbnail.SaveToStream(TempStream);
      Stream_WriteUInt32(Stream,TempStream.Size);
      Stream.CopyFrom(TempStream,0);
    finally
      TempStream.Free;
    end;
  end
else Stream_WriteUInt32(Stream,0);
end;
//------------------------------------------------------------------------------

procedure TILItemPictures_IO_00000000.LoadThumbnail_00000000(Stream: TStream; out Thumbnail: TBitmap);
var
  Size:       UInt32;
  TempStream: TMemoryStream;
begin
Size := Stream_ReadUInt32(Stream);
If Size > 0 then
  begin
    TempStream := TMemoryStream.Create;
    try
      TempStream.CopyFrom(Stream,Size);
      TempStream.Seek(0,soBeginning);
      Thumbnail := TBitmap.Create;
      try
        Thumbnail.LoadFromStream(TempStream);
      except
        FreeAndNil(Thumbnail);
      end;
    finally
      TempStream.Free;
    end;
  end
else Thumbnail := nil;
end;

end.
