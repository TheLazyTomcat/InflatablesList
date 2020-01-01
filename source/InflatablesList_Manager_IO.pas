unit InflatablesList_Manager_IO;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  Classes,
  AuxTypes,
  InflatablesList_Types,
  InflatablesList_Manager_Search;

const
  IL_LISTFILE_SIGNATURE = UInt32($4C464E49);  // signature of the list file

  IL_LISTFILE_STREAMSTRUCTURE_00000008 = UInt32($00000008);
  IL_LISTFILE_STREAMSTRUCTURE_00000009 = UInt32($00000009);
  IL_LISTFILE_STREAMSTRUCTURE_0000000A = UInt32($0000000A);
  IL_LISTFILE_STREAMSTRUCTURE_0000000B = UInt32($0000000B);

  IL_LISTFILE_STREAMSTRUCTURE_SAVE = IL_LISTFILE_STREAMSTRUCTURE_0000000B;

  IL_LISTFILE_DECRYPT_CHECK = UInt64($53444E455453494C);  // LISTENDS

  IL_LISTFILE_PREALLOC_BYTES_ITEM        = 2 * KiB;   // 2KiB per item data
  IL_LISTFILE_PREALLOC_BYTES_THUMB       = 27 * KiB;  // 27KiB per picture
  IL_LISTFILE_PREALLOC_BYTES_SORT_PROF   = 512;       // 512bytes per sorting profile
  IL_LISTFILE_PREALLOC_BYTES_ISHOP_TEMPL = 3 * KiB;   // 3KiB per item shop template

  IL_LISTFILE_SLOW_SIZE        = 20 * MiB;    // size of the list file where saving and loading is expected to be slow
  IL_LISTFILE_SLOW_SIZE_ENC    = 15 * MiB;    // size of the encrypted or to be encrypted list file...
  IL_LISTFILE_SLOW_SIZE_CMP    = 5 * MiB;     // size of the compressed list file...
  IL_LISTFILE_SLOW_SIZE_CMPENC = 4 * MiB;     // size of the compressed and encrypted list file...

  IL_LISTFILE_SLOW_SIZE_UCMP    = 12 * MiB;   // size of the list file to be compressed..  
  IL_LISTFILE_SLOW_SIZE_UCMPENC = 10 * MiB;   // size of the list file to be compressed and encrypted...

{
  number of encrypted items where the save is expected to be slow

  note that given how the encrypted items are loaded (ie. not decrypted), there
  is no need to use this in loading, only in saving
}
  IL_LISTFILE_SLOW_COUNT_ITEMENC = 10;


  IL_ITEMEXPORT_SIGNATURE = UInt32($49454C49);  // ILEI

type
  TILManager_IO = class(TILManager_Search)
  protected
    fFNSaveToStream:        procedure(Stream: TStream) of object;
    fFNLoadFromStream:      procedure(Stream: TStream) of object;
    fFNSaveSortingSettings: procedure(Stream: TStream) of object;
    fFNLoadSortingSettings: procedure(Stream: TStream) of object;
    fFNSaveShopTemplates:   procedure(Stream: TStream) of object;
    fFNLoadShopTemplates:   procedure(Stream: TStream) of object;
    fFNSaveFilterSettings:  procedure(Stream: TStream) of object;
    fFNLoadFilterSettings:  procedure(Stream: TStream) of object;
    fFNSaveItems:           procedure(Stream: TStream) of object;
    fFNLoadItems:           procedure(Stream: TStream) of object;
    fFNPreload:             procedure(Stream: TStream; out Info: TILPreloadInfo) of object;
    procedure InitSaveFunctions(Struct: UInt32); virtual; abstract;
    procedure InitLoadFunctions(Struct: UInt32); virtual; abstract;
    procedure InitPreloadFunctions(Struct: UInt32); virtual; abstract;
    procedure Save(Stream: TStream; Struct: UInt32); virtual;
    procedure Load(Stream: TStream; Struct: UInt32); virtual;
    procedure Preload(Stream: TStream; Struct: UInt32; out Info: TILPreloadInfo); virtual;
    Function PreallocSize: TMemSize; virtual;
  public
    // multiple items export/import
    procedure ItemsExport(const FileName: String; Indices: array of Integer); virtual;
    Function ItemsImport(const FileName: String): Integer; virtual;
    // normal io  
    procedure SaveToStream(Stream: TStream); virtual;
    procedure LoadFromStream(Stream: TStream); virtual;    
    procedure SaveToFile; virtual;
    procedure LoadFromFile; virtual;
    Function PreloadStream(Stream: TStream): TILPreloadInfo; virtual;
    Function PreloadFile(const FileName: String): TILPreloadInfo; overload; virtual;
    Function PreloadFile: TILPreloadInfo; overload; virtual;
    // utility methods
    Function SlowSaving: Boolean; virtual;
  end;

implementation

uses
  SysUtils,
  BinaryStreaming, StrRect,
  InflatablesList_Utils,
  InflatablesList_Item;


procedure TILManager_IO.Save(Stream: TStream; Struct: UInt32);
begin
InitSaveFunctions(Struct);
fFNSaveToStream(Stream);
end;

//------------------------------------------------------------------------------

procedure TILManager_IO.Load(Stream: TStream; Struct: UInt32);
begin
InitLoadFunctions(Struct);
fFNLoadFromStream(Stream);
end;

//------------------------------------------------------------------------------

procedure TILManager_IO.Preload(Stream: TStream; Struct: UInt32; out Info: TILPreloadInfo);
begin
InitPreloadFunctions(Struct);
If Assigned(fFNPreload) then
  fFNPreload(Stream,Info);
end;

//------------------------------------------------------------------------------

Function TILManager_IO.PreallocSize: TMemSize;
begin
Result :=
  // some globals (notes, filter settings, ....)
  TMemSize(1 * KiB) +
  // sorting profiles
  TMemSize(SortingProfileCount * IL_LISTFILE_PREALLOC_BYTES_SORT_PROF) +
  // item shop templates
  TMemSize(ShopTemplateCount * IL_LISTFILE_PREALLOC_BYTES_ISHOP_TEMPL) +
  // item data
  TMemSize(fCount * IL_LISTFILE_PREALLOC_BYTES_ITEM) +
  // item pictures
  TMemSize(TotalPictureCount * IL_LISTFILE_PREALLOC_BYTES_THUMB)
end;

//==============================================================================

procedure TILManager_IO.ItemsExport(const FileName: String; Indices: array of Integer);
var
  AllocSize:  TMemSize;
  i,j:        Integer;
  Index:      Integer;
  FileStream: TMemoryStream;
  TempItem:   TILItem;
  PicCounter: UInt32;
  PicStream:  TMemoryStream;
  OutStream:  TFileStream;
  CountPos:   Int64;
begin
// check indices
For i := Low(Indices) to High(Indices) do
  If not CheckIndex(Indices[i]) then
    raise Exception.CreateFmt('TILManager_Base.ItemsExport: Index %d (%d) out of bounds.',[i,Indices[i]]);
FileStream := TMemoryStream.Create;
try
  // get preallocation size and preallocate
  AllocSize := 0;
  For i := Low(Indices) to High(Indices) do
    // assume all pictures have thumbnails assigned
    AllocSize := AllocSize + IL_LISTFILE_PREALLOC_BYTES_ITEM +
                 (UInt32(fList[Indices[i]].Pictures.Count) *
                   IL_LISTFILE_PREALLOC_BYTES_THUMB);
  FileStream.Size := AllocSize;
  FileStream.Seek(0,soBeginning);
  // save signature and count
  Stream_WriteUInt32(FileStream,IL_ITEMEXPORT_SIGNATURE);
  CountPos := FileStream.Position;
  Stream_WriteUInt64(FileStream,0); // reserve space for data size without pictures
  Stream_WriteUInt32(FileStream,Length(Indices));
  // now write individual items in the order they are in the indices array
  For i := Low(Indices) to High(Indices) do
    begin
      TempItem := TILItem.CreateAsCopy(fDataProvider,fList[Indices[i]],True,False);
      try
        // copy parsing data when they are only referenced
        For j := TempItem.ShopLowIndex to TempItem.ShopHighIndex do
          begin
            Index := ShopTemplateIndexOf(TempItem.Shops[j].ParsingSettings.TemplateReference);
            If Index >= 0 then
              begin
                TempItem.Shops[j].ReplaceParsingSettings(ShopTemplates[Index].ParsingSettings);
                TempItem.Shops[j].ParsingSettings.TemplateReference := '';
              end;
          end;
        TempItem.SaveToStream(FileStream);
      finally
        TempItem.Free;
      end;
    end;
  // adjust final size;
  FileStream.Size := FileStream.Position;
  // write data size without pictures
  FileStream.Seek(CountPos,soBeginning);
  Stream_WriteUInt64(FileStream,UInt64(FileStream.Size));
  // save to file
  FileStream.SaveToFile(StrToRTL(FileName));
finally
  FileStream.Free;
end;
// open the export file as file stream and write full pictures (to limit memory use)
PicCounter := 0;
OutStream := TFileStream.Create(StrToRTL(FileName),fmOpenReadWrite or fmShareDenyWrite);
try
  OutStream.Seek(0,soEnd);
  Stream_WriteString(OutStream,'EPCS');
  CountPos := OutStream.Position;
  Stream_WriteUInt32(OutStream,0);  // reserve space for counter  
  PicStream := TMemoryStream.Create;
  try
    For i := Low(Indices) to High(Indices) do
      begin
        TempItem := fList[Indices[i]];
        For j := TempItem.Pictures.LowIndex to TempItem.Pictures.HighIndex do
          If IL_FileExists(fStaticSettings.PicturesPath + TempItem.Pictures[j].PictureFile) then
            begin
              PicStream.LoadFromFile(fStaticSettings.PicturesPath + TempItem.Pictures[j].PictureFile);
              Stream_WriteString(OutStream,TempItem.Pictures[j].PictureFile);
              Stream_WriteUInt64(OutStream,UInt64(PicStream.Size));
              Stream_WriteBuffer(OutStream,PicStream.Memory^,PicStream.Size);
              Inc(PicCounter);
            end;
      end;
  finally
    PicStream.Free;
  end;
  // write number of saved pictures
  OutStream.Seek(CountPos,soBeginning);
  Stream_WriteUInt32(OutStream,PicCounter);
finally
  OutStream.Free;
end;
end;

//------------------------------------------------------------------------------

Function TILManager_IO.ItemsImport(const FileName: String): Integer;
var
  FileStream: TMemoryStream;
  i:          Integer;
begin
Result := 0;
FileStream := TMemoryStream.Create;
try
  FileStream.LoadFromFile(StrToRTL(FileName));
  FileStream.Seek(0,soBeginning);
  // now the reading itself...
  If Stream_ReadUInt32(FileStream) = IL_ITEMEXPORT_SIGNATURE then
    begin
      Result := Stream_ReadUInt32(FileStream);
      If Result > 0 then
        begin
          SetCapacity(Capacity + Result);
          For i := 0 to Pred(Result) do
            begin
              fList[fCount + i] := TILItem.Create(fDataProvider);
              fList[fCount + i].StaticSettings:= fStaticSettings;
              fList[fCount + i].LoadFromStream(FileStream);
              fList[fCount + i].ResetTimeOfAddition;
              fList[fCount + i].Index := i;
              fList[fCount + i].AssignInternalEvents(
                ShopUpdateShopListItemHandler,
                ShopUpdateValuesHandler,
                ShopUpdateAvailHistoryHandler,
                ShopUpdatePriceHistoryHandler,
                ItemUpdateMainListHandler,
                ItemUpdateSmallListHandler,
                ItemUpdateMiniListHandler,
                ItemUpdateOverviewHandler,
                ItemUpdateTitleHandler,
                ItemUpdatePicturesHandler,
                ItemUpdateFlagsHandler,
                ItemUpdateValuesHandler,
                ItemUpdateOthersHandler,
                ItemUpdateShopListHandler,
                ItemPasswordRequestHandler);
            end;
          fCount := fCount + Result;
          UpdateList;
          UpdateOverview;
        end;
    end
  else raise Exception.Create('TILItem_IO.ItemsImport: Invalid stream.');
finally
  FileStream.Free;
end;
end;

//------------------------------------------------------------------------------

procedure TILManager_IO.SaveToStream(Stream: TStream);
begin
Stream_WriteUInt32(Stream,IL_LISTFILE_SIGNATURE);
Stream_WriteUInt32(Stream,IL_LISTFILE_STREAMSTRUCTURE_SAVE);
Save(Stream,IL_LISTFILE_STREAMSTRUCTURE_SAVE);
end;

//------------------------------------------------------------------------------

procedure TILManager_IO.LoadFromStream(Stream: TStream);
begin
If Stream_ReadUInt32(Stream) = IL_LISTFILE_SIGNATURE then
  Load(Stream,Stream_ReadUInt32(Stream))
else
  raise Exception.Create('TILItem_IO.LoadFromStream: Invalid stream.');
end;

//------------------------------------------------------------------------------

procedure TILManager_IO.SaveToFile;
var
  FileStream: TMemoryStream;
begin
// do backup
If not fStaticSettings.NoBackup and fMainManager then
  fBackupManager.Backup;
// do saving
FileStream := TMemoryStream.Create;
try
  //prealloc
  FileStream.Size := Int64(PreallocSize);
  FileStream.Seek(0,soBeginning);
  SaveToStream(FileStream);
  FileStream.Size := FileStream.Position;
  IL_CreateDirectoryPathForFile(fStaticSettings.ListFile);
  FileStream.SaveToFile(StrToRTL(fStaticSettings.ListFile));
finally
  FileStream.Free;
end;
end;

//------------------------------------------------------------------------------

procedure TILManager_IO.LoadFromFile;
var
  FileStream: TMemoryStream;
begin
If IL_FileExists(fStaticSettings.ListFile) then
  begin
    FileStream := TMemoryStream.Create;
    try
      FileStream.LoadFromFile(StrToRTL(fStaticSettings.ListFile));
      FileStream.Seek(0,soBeginning);
      LoadFromStream(FileStream);
    finally
      FileStream.Free;
    end;
  end;
end;

//------------------------------------------------------------------------------

Function TILManager_IO.PreloadStream(Stream: TStream): TILPreloadInfo;
begin
FillChar(Result,SizeOf(TILPreloadInfo),0);
try
  Result.FileSize := UInt64(Stream.Size);
  Result.Signature := Stream_ReadUInt32(Stream);
  If Result.Signature = IL_LISTFILE_SIGNATURE then
    begin
      Result.Structure := Stream_ReadUInt32(Stream);
      Preload(Stream,Result.Structure,Result);
    end
  else Include(Result.ResultFlags,ilprfInvalidFile);
  // check for slow loading
  If (Result.FileSize > IL_LISTFILE_SLOW_SIZE) or
    ((Result.FileSize > IL_LISTFILE_SLOW_SIZE_ENC) and (ilprfEncrypted in Result.ResultFlags)) or
    ((Result.FileSize > IL_LISTFILE_SLOW_SIZE_CMP) and (ilprfCompressed in Result.ResultFlags)) or
    ((Result.FileSize > IL_LISTFILE_SLOW_SIZE_CMPENC) and ([ilprfEncrypted,ilprfCompressed] <= Result.ResultFlags)) then
    Include(Result.ResultFlags,ilprfSlowLoad);
except
  Include(Result.ResultFlags,ilprfError);
end;
end;

//------------------------------------------------------------------------------

Function TILManager_IO.PreloadFile(const FileName: String): TILPreloadInfo;
var
  FileStream: TFileStream;
begin
If IL_FileExists(FileName) then
  begin
    FileStream := TFileStream.Create(StrToRTL(FileName),fmOpenRead or fmShareDenyWrite);
    try
      FileStream.Seek(0,soBeginning);
      Result := PreloadStream(FileStream);
    finally
      FileStream.Free;
    end;
  end;
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

Function TILManager_IO.PreloadFile: TILPreloadInfo;
begin
Result := PreloadFile(fStaticSettings.ListFile)
end;

//------------------------------------------------------------------------------

Function TILManager_IO.SlowSaving: Boolean;
begin
Result := (PreallocSize > IL_LISTFILE_SLOW_SIZE) or
  ((PreallocSize > IL_LISTFILE_SLOW_SIZE_ENC) and fEncrypted) or
  ((PreallocSize > IL_LISTFILE_SLOW_SIZE_UCMP) and fCompressed) or
  ((PreallocSize > IL_LISTFILE_SLOW_SIZE_UCMPENC) and fCompressed and fEncrypted) or
  (((EncryptedItemCount(True) - EncryptedItemCount(False){only decrypted}) >= IL_LISTFILE_SLOW_COUNT_ITEMENC));
end;

end.
