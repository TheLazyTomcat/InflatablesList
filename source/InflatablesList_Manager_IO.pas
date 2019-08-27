unit InflatablesList_Manager_IO;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  Classes,
  AuxTypes,
  InflatablesList_Manager_Templates;

const
  IL_LISTFILE_SIGNATURE = UInt32($4C464E49);  // signature of the list file

  // 0 - 6 are deprecated (unsupported), 7 can be only read (converted)
  IL_LISTFILE_STREAMSTRUCTURE_00000000 = UInt32($00000000);
  IL_LISTFILE_STREAMSTRUCTURE_00000001 = UInt32($00000001);
  IL_LISTFILE_STREAMSTRUCTURE_00000002 = UInt32($00000002);
  IL_LISTFILE_STREAMSTRUCTURE_00000003 = UInt32($00000003);
  IL_LISTFILE_STREAMSTRUCTURE_00000004 = UInt32($00000004);
  IL_LISTFILE_STREAMSTRUCTURE_00000005 = UInt32($00000005);
  IL_LISTFILE_STREAMSTRUCTURE_00000006 = UInt32($00000006);
  IL_LISTFILE_STREAMSTRUCTURE_00000007 = UInt32($00000007);
  IL_LISTFILE_STREAMSTRUCTURE_00000008 = UInt32($00000008);
  IL_LISTFILE_STREAMSTRUCTURE_00000009 = UInt32($00000009);
  IL_LISTFILE_STREAMSTRUCTURE_0000000A = UInt32($0000000A);

  IL_LISTFILE_STREAMSTRUCTURE_SAVE = IL_LISTFILE_STREAMSTRUCTURE_0000000A;

  IL_ITEMEXPORT_SIGNATURE = UInt32($49454C49);  // ILEI

  IL_LISTFILE_VALIDITYCHECK = UInt64($53444E455453494C);  // LISTENDS

type
  TILManager_IO = class(TILManager_Templates)
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
    procedure Convert_7_to_8(Stream: TStream); virtual; abstract;
    procedure InitSaveFunctions(Struct: UInt32); virtual; abstract;
    procedure InitLoadFunctions(Struct: UInt32); virtual; abstract;
    procedure Save(Stream: TStream; Struct: UInt32); virtual;
    procedure Load(Stream: TStream; Struct: UInt32); virtual;
  public
    // items export/import
    procedure ItemsExport(const FileName: String; Indices: array of Integer); virtual;
    Function ItemsImport(const FileName: String): Integer; virtual;
    // normal io  
    procedure SaveToStream(Stream: TStream); virtual;
    procedure LoadFromStream(Stream: TStream); virtual;    
    procedure SaveToFile(const FileName: String); virtual;
    procedure LoadFromFile(const FileName: String); virtual;    
  end;

implementation

uses
  SysUtils,
  BinaryStreaming,
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
If Struct = IL_LISTFILE_STREAMSTRUCTURE_00000007 then
  begin
    Convert_7_to_8(Stream);
    Struct := IL_LISTFILE_STREAMSTRUCTURE_00000008;
  end;
InitLoadFunctions(Struct);
fFNLoadFromStream(Stream);
end;

//==============================================================================

procedure TILManager_IO.ItemsExport(const FileName: String; Indices: array of Integer);
var
  i,j:        Integer;
  Index:      Integer;
  FileStream: TMemoryStream;
  TempItem:   TILItem;
begin
// check indices
For i := Low(Indices) to High(Indices) do
  If not CheckIndex(Indices[i]) then
    raise Exception.CreateFmt('TILManager_Base.ItemsExport: Index %d (%d) out of bounds.',[i,Indices[i]]);
FileStream := TMemoryStream.Create;
try
  // pre-allocate
  FileStream.Size := Length(Indices) * (90 * 1024); // ~90Kib per item
  FileStream.Seek(0,soBeginning);
  // save signature and count
  Stream_WriteUInt32(FileStream,IL_ITEMEXPORT_SIGNATURE);
  Stream_WriteUInt32(FileStream,Length(Indices));
  // now write individual items in the order they are in the indices array
  For i := Low(Indices) to High(Indices) do
    begin
      TempItem := TILItem.CreateAsCopy(fDataProvider,fList[Indices[i]],True);
      try
        // copy parsing data
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
  // save to file
  FileStream.SaveToFile(FileName);
finally
  FileStream.Free;
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
  FileStream.LoadFromFile(FileName);
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
              fList[fCount + i].StaticOptions := fStaticOptions;
              fList[fCount + i].LoadFromStream(FileStream);
              fList[fCount + i].ResetTimeOfAddition;
              fList[fCount + i].Index := i;
              fList[fCount + i].OnMainListUpdate := MainListUpdateHandler;
              fList[fCount + i].OnSmallListUpdate := SmallListUpdateHandler;
              fList[fCount + i].OnOverviewListUpdate := OverviewUpdateHandler;
            end;
          fCount := fCount + Result;
          DoUpdate;
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

procedure TILManager_IO.SaveToFile(const FileName: String);
var
  FileStream: TMemoryStream;
begin
FileStream := TMemoryStream.Create;
try
  //prealloc
  FileStream.Size := fCount * (90 * 1024);  // ~90Kib per item
  FileStream.Seek(0,soBeginning);
  SaveToStream(FileStream);
  FileStream.Size := FileStream.Position;
  IL_CreateDirectoryPathForFile(ExpandFileName(FileName));
  FileStream.SaveToFile(ExpandFileName(FileName));
  fListFileName := ExpandFileName(FileName);
  fListFilePath := ExtractFilePath(fListFileName);
finally
  FileStream.Free;
end;
end;

//------------------------------------------------------------------------------

procedure TILManager_IO.LoadFromFile(const FileName: String);
var
  FileStream: TMemoryStream;
begin
FileStream := TMemoryStream.Create;
try
  FileStream.LoadFromFile(ExpandFileName(FileName));
  FileStream.Seek(0,soBeginning);
  LoadFromStream(FileStream);
  fListFileName := ExpandFileName(FileName);
  fListFilePath := ExtractFilePath(fListFileName);
finally
  FileStream.Free;
end;
end;

end.
