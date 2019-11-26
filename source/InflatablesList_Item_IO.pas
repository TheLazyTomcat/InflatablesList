unit InflatablesList_Item_IO;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  Classes, Graphics,
  AuxTypes,
  InflatablesList_Item_Search;

const
  IL_ITEM_SIGNATURE = UInt32($4D455449);  // ITEM

  IL_ITEM_STREAMSTRUCTURE_00000000 = UInt32($00000000);
  IL_ITEM_STREAMSTRUCTURE_00000001 = UInt32($00000001);
  IL_ITEM_STREAMSTRUCTURE_00000002 = UInt32($00000002);
  IL_ITEM_STREAMSTRUCTURE_00000003 = UInt32($00000003);
  IL_ITEM_STREAMSTRUCTURE_00000004 = UInt32($00000004);
  IL_ITEM_STREAMSTRUCTURE_00000005 = UInt32($00000005);
  IL_ITEM_STREAMSTRUCTURE_00000006 = UInt32($00000006);
  IL_ITEM_STREAMSTRUCTURE_00000007 = UInt32($00000007);
  IL_ITEM_STREAMSTRUCTURE_00000008 = UInt32($00000008);
  IL_ITEM_STREAMSTRUCTURE_00000009 = UInt32($00000009);

  IL_ITEM_STREAMSTRUCTURE_SAVE = IL_ITEM_STREAMSTRUCTURE_00000008;

  IL_ITEM_DECRYPT_CHECK = UInt64($53444E454D455449);  // ITEMENDS

type
  TILItem_IO = class(TILItem_Search)
  protected
    fFNSaveToStream:    procedure(Stream: TStream) of object;
    fFNLoadFromStream:  procedure(Stream: TStream) of object;
    fFNSavePicture:     procedure(Stream: TStream; Pic: TBitmap) of object;
    fFNLoadPicture:     procedure(Stream: TStream; out Pic: TBitmap) of object;
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

procedure TILItem_IO.Save(Stream: TStream; Struct: UInt32);
begin
InitSaveFunctions(Struct);
fFNSaveToStream(Stream);
end;

//------------------------------------------------------------------------------

procedure TILItem_IO.Load(Stream: TStream; Struct: UInt32);
begin
fEncryptedData.Data := PtrInt(Struct);
InitLoadFunctions(Struct);
fFNLoadFromStream(Stream);
RenderSmallPictures;
end;

//==============================================================================

procedure TILItem_IO.SaveToStream(Stream: TStream);
var
  SelectedStruct: UInt32;
begin
Stream_WriteUInt32(Stream,IL_ITEM_SIGNATURE);
If fEncrypted and not fDataAccessible then
  SelectedStruct := UInt32(fEncryptedData.Data)
else
  SelectedStruct := IL_ITEM_STREAMSTRUCTURE_SAVE;
Stream_WriteUInt32(Stream,SelectedStruct);  
Save(Stream,SelectedStruct);
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
  FileStream.SaveToFile(StrToRTL(FileName));
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
  FileStream.LoadFromFile(StrToRTL(FileName));
  FileStream.Seek(0,soBeginning);
  LoadFromStream(FileStream);
finally
  FileStream.Free;
end;
end;

end.
