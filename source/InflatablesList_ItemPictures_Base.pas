unit InflatablesList_ItemPictures_Base;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  Graphics,
  AuxTypes, AuxClasses, CRC32;

type
  TILItemPicturesEntry = record
    PictureFile:    String;
    PictureSize:    UInt64;
    PictureWidth:   Int32;
    PictureHeight:  Int32;
    Thumbnail:      TBitmap;
    ThumbnailSmall: TBitmap;
    ThumbnailMini:  TBitmap;
    ItemPicture:    Boolean;
    PackagePicture: Boolean;
  end;
  PILItemPicturesEntry = ^TILItemPicturesEntry;

  TILPictureAutomationInfo = record
    FileName: String;
    FilePath: String;
    CRC32:    TCRC32;
    Size:     UInt64;
    Width:    Int32;
    Height:   Int64;
  end;

  TILItemObjectRequired = Function(Sender: TObject): TObject of object;

  TILItemPictures_Base = class(TCustomListObject)
  protected
    fInitializing:        Boolean;
    fPictures:            array of TILItemPicturesEntry;
    fCount:               Integer;
    fCurrentSecondary:    Integer;
    fDeferrInitDone:      Boolean;
    fAutomationFolder:    String;
    fOnItemObjectReq:     TILItemObjectRequired;
    fOnPicturesChange:    TNotifyEvent;
    // getters, setters
    Function GetEntry(Index: Integer): TILItemPicturesEntry;
    // list methods
    Function GetCapacity: Integer; override;
    procedure SetCapacity(Value: Integer); override;
    Function GetCount: Integer; override;
    procedure SetCount(Value: Integer); override;
    // event callers
    procedure UpdatePictures; virtual;
    // other methods
    procedure Initialize; virtual;
    procedure Finalize; virtual;
    procedure DeferredInitialize; virtual;
    procedure UnAutomatePictureFile(const AutomatedPictureFile: String); virtual;
  public
    class procedure FreeEntry(var Entry: TILItemPicturesEntry; KeepFile: Boolean = False); virtual;
    constructor Create;
    constructor CreateAsCopy(Source: TILItemPictures_Base);
    destructor Destroy; override;
    Function LowIndex: Integer; override;
    Function HighIndex: Integer; override;
    procedure BeginInitialization; virtual;
    procedure EndInitialization; virtual;
    {$message 'implement and use'}
    //procedure BeginUpdate; virtual;
    //procedure EndUpdate; virtual;
    Function IndexOf(const PictureFile: String): Integer; overload; virtual;
    Function IndexOf(Thumbnail: TBitmap): Integer; overload; virtual;
    Function IndexOfItemPicture: Integer; virtual;
    Function IndexOfPackagePicture: Integer; virtual;
    Function Add(AutomationInfo: TILPictureAutomationInfo): Integer; overload; virtual;
    Function Add(const PictureFile: String): Integer; overload; virtual;
    procedure Exchange(Idx1,Idx2: Integer); virtual;
    procedure Delete(Index: Integer); virtual;
    procedure Clear(UnAutomate: Boolean = True; Destroying: Boolean = False); virtual;
    Function AutomatePictureFile(const FileName: String; out AutomationInfo: TILPictureAutomationInfo): Boolean; virtual;
    procedure OpenPictureFile(Index: Integer); virtual;
    procedure SetThumbnail(Index: Integer; Thumbnail: TBitmap; CreateCopy: Boolean); virtual;
    procedure SetItemPicture(Index: Integer; Value: Boolean); virtual;
    procedure SetPackagePicture(Index: Integer; Value: Boolean); virtual;
    Function SecondaryCount: Integer; virtual;
    Function PrevSecondary: Integer; virtual;
    Function NextSecondary: Integer; virtual;
    Function ExportPicture(Index: Integer; const IntoDirectory: String): Boolean; virtual;
    Function ExportThumbnail(Index: Integer; const IntoDirectory: String): Boolean; virtual;
    procedure AssignInternalEvents(ItemObjectReq: TILItemObjectRequired; OnPicturesChange: TNotifyEvent); virtual;
    property Pictures[Index: Integer]: TILItemPicturesEntry read GetEntry; default;
    property CurrentSecondary: Integer read fCurrentSecondary;
    property AutomationFolder: String read fAutomationFolder;
  end;

implementation

uses
  SysUtils, JPEG,
  WinFileInfo, StrRect,
  InflatablesList_Utils,
  InflatablesList_Item;

Function TILItemPictures_Base.GetEntry(Index: Integer): TILItemPicturesEntry;
begin
If CheckIndex(Index) then
  Result := fPictures[Index]
else
  raise Exception.CreateFmt('TILItemPictures_Base.GetEntry: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

Function TILItemPictures_Base.GetCapacity: Integer;
begin
Result := Length(fPictures);
end;

//------------------------------------------------------------------------------

procedure TILItemPictures_Base.SetCapacity(Value: Integer);
var
  i:  Integer;
begin
If Value < fCount then
  begin
    For i := Value to Pred(fCount) do
      FreeEntry(fPictures[i]);
    fCount := Value;
  end;
SetLength(fPictures,Value);
end;

//------------------------------------------------------------------------------

Function TILItemPictures_Base.GetCount: Integer;
begin
Result := fCount;
end;

//------------------------------------------------------------------------------

procedure TILItemPictures_Base.SetCount(Value: Integer);
begin
// do nothing
end;

//------------------------------------------------------------------------------

procedure TILItemPictures_Base.UpdatePictures;
begin
If Assigned(fOnPicturesChange) and not fInitializing then
  fOnPicturesChange(Self);
end;

//------------------------------------------------------------------------------

procedure TILItemPictures_Base.Initialize;
begin
fInitializing := False;
SetLength(fPictures,0);
fCount := 0;
fCurrentSecondary := -1;
fDeferrInitDone := False;
fAutomationFolder := '';
end;

//------------------------------------------------------------------------------

procedure TILItemPictures_Base.Finalize;
begin
Clear(False,True);
end;

//------------------------------------------------------------------------------

procedure TILItemPictures_Base.DeferredInitialize;
var
  Item: TILItem;
begin
If not fDeferrInitDone then
  begin
    Item := TILItem(fOnItemObjectReq(Self));
    fAutomationFolder := IL_IncludeTrailingPathDelimiter(Item.StaticSettings.ListPath + Item.StaticSettings.ListName + '_pics');
    fDeferrInitDone := False;
  end;
end;

//------------------------------------------------------------------------------

procedure TILItemPictures_Base.UnAutomatePictureFile(const AutomatedPictureFile: String);
begin
IL_DeleteFile(fAutomationFolder + AutomatedPictureFile);
end;

//==============================================================================

class procedure TILItemPictures_Base.FreeEntry(var Entry: TILItemPicturesEntry; KeepFile: Boolean = False);
begin
If not KeepFile then
  Entry.PictureFile := '';
If Assigned(Entry.Thumbnail) then
  FreeAndnil(Entry.Thumbnail);
If Assigned(Entry.ThumbnailSmall) then
  FreeAndnil(Entry.ThumbnailSmall);
If Assigned(Entry.ThumbnailMini) then
  FreeAndnil(Entry.ThumbnailMini);
Entry.ItemPicture := False;
Entry.PackagePicture := False;
end;

//------------------------------------------------------------------------------

constructor TILItemPictures_Base.Create;
begin
inherited Create;
Initialize;
end;

//------------------------------------------------------------------------------

constructor TILItemPictures_Base.CreateAsCopy(Source: TILItemPictures_Base);
var
  i:  Integer;
begin
Create;
SetLength(fPictures,Source.Count);
For i := LowIndex to HighIndex do
  begin
    fPictures[i] := Source.Pictures[i];
    UniqueString(fPictures[i].PictureFile);
    fPictures[i].Thumbnail := TBitmap.Create;
    fPictures[i].Thumbnail.Assign(Source.Pictures[i].Thumbnail);
    fPictures[i].ThumbnailSmall := TBitmap.Create;
    fPictures[i].ThumbnailSmall.Assign(Source.Pictures[i].ThumbnailSmall);
    fPictures[i].ThumbnailMini := TBitmap.Create;
    fPictures[i].ThumbnailMini.Assign(Source.Pictures[i].ThumbnailMini);
  end;
fCurrentSecondary := Source.CurrentSecondary;
fAutomationFolder := Source.AutomationFolder;
UniqueString(fAutomationFolder);
end;

//------------------------------------------------------------------------------

destructor TILItemPictures_Base.Destroy;
begin
Finalize;
inherited;
end;

//------------------------------------------------------------------------------

Function TILItemPictures_Base.LowIndex: Integer;
begin
Result := Low(fPictures);
end;

//------------------------------------------------------------------------------

Function TILItemPictures_Base.HighIndex: Integer;
begin
Result := Pred(fCount);
end;
 
//------------------------------------------------------------------------------

procedure TILItemPictures_Base.BeginInitialization;
begin
fInitializing := True;
end;

//------------------------------------------------------------------------------

procedure TILItemPictures_Base.EndInitialization;
begin
fInitializing := False;
end;

//------------------------------------------------------------------------------

Function TILItemPictures_Base.IndexOf(const PictureFile: String): Integer;
var
  i:  Integer;
begin
Result := -1;
For i := LowIndex to HighIndex do
  If IL_SameText(fPictures[i].PictureFile,PictureFile) then
    begin
      Result := i;
      Break{For i};
    end;
end;

//------------------------------------------------------------------------------

Function TILItemPictures_Base.IndexOf(Thumbnail: TBitmap): Integer;
var
  i:  Integer;
begin
Result := -1;
For i := LowIndex to HighIndex do
  If fPictures[i].Thumbnail = Thumbnail then
    begin
      Result := i;
      Break{For i};
    end;
end;

//------------------------------------------------------------------------------

Function TILItemPictures_Base.IndexOfItemPicture: Integer;
var
  i:  Integer;
begin
Result := -1;
For i := LowIndex to HighIndex do
  If fPictures[i].ItemPicture then
    begin
      Result := i;
      Break{For i};
    end;
end;

//------------------------------------------------------------------------------

Function TILItemPictures_Base.IndexOfPackagePicture: Integer;
var
  i:  Integer;
begin
Result := -1;
For i := LowIndex to HighIndex do
  If fPictures[i].PackagePicture then
    begin
      Result := i;
      Break{For i};
    end;
end;

//------------------------------------------------------------------------------

Function TILItemPictures_Base.Add(AutomationInfo: TILPictureAutomationInfo): Integer;
begin
Grow;
Result := fCount;
FreeEntry(fPictures[Result]);
fPictures[Result].PictureFile := AutomationInfo.FileName;
fPictures[Result].PictureSize := AutomationInfo.Size;
fPictures[Result].PictureWidth := AutomationInfo.Width;
fPictures[Result].PictureHeight := AutomationInfo.Height;
Inc(fCount);
If not CheckIndex(fCurrentSecondary) then
  fCurrentSecondary := Result;
UpdatePictures;
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

Function TILItemPictures_Base.Add(const PictureFile: String): Integer;
var
  Temp: TILPictureAutomationInfo;
begin
Temp.FileName := PictureFile;
Temp.CRC32 := 0;
Temp.Size := 0;
Temp.Width := -1;
Temp.Height := -1;
Result := Add(Temp);
end;

//------------------------------------------------------------------------------

procedure TILItemPictures_Base.Exchange(Idx1,Idx2: Integer);
var
  Temp: TILItemPicturesEntry;
begin
If Idx1 <> Idx2 then
  begin
    // sanity checks
    If not CheckIndex(Idx1) then
      raise Exception.CreateFmt('TILItemPictures_Base.Exchange: Index #1 (%d) out of bounds.',[Idx1]);
    If not CheckIndex(Idx2) then
      raise Exception.CreateFmt('TILItemPictures_Base.Exchange: Index #2 (%d) out of bounds.',[Idx2]);
    If fCurrentSecondary = Idx1 then
      fCurrentSecondary := Idx2
    else If fCurrentSecondary = Idx2 then
      fCurrentSecondary := Idx1;
    Temp := fPictures[Idx1];
    fPictures[Idx1] := fPictures[Idx2];
    fPictures[Idx2] := Temp;
    UpdatePictures;
  end;
end;

//------------------------------------------------------------------------------

procedure TILItemPictures_Base.Delete(Index: Integer);
var
  i:  Integer;
begin
If CheckIndex(Index) then
  begin
    If Index = fCurrentSecondary then
      begin
        NextSecondary;
        If Index = fCurrentSecondary then
          fCurrentSecondary := -1;
      end;
    UnAutomatePictureFile(fPictures[Index].PictureFile);
    FreeEntry(fPictures[Index]);
    For i := Index to Pred(HighIndex) do
      fPictures[i] := fPictures[i + 1];
    Shrink;
    Dec(fCount);
    UpdatePictures;
  end
else raise Exception.CreateFmt('TILItemPictures_Base.Delete: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

procedure TILItemPictures_Base.Clear(UnAutomate: Boolean = True; Destroying: Boolean = False);
var
  i:  Integer;
begin
For i := LowIndex to HighIndex do
  begin
    If UnAutomate then
      UnAutomatePictureFile(fPictures[i].PictureFile);
    FreeEntry(fPictures[i]);
  end;
SetLength(fPictures,0);
fCount := 0;
fCurrentSecondary := -1;
If not Destroying then
  UpdatePictures;
end;

//------------------------------------------------------------------------------

Function TILItemPictures_Base.AutomatePictureFile(const FileName: String; out AutomationInfo: TILPictureAutomationInfo): Boolean;
begin
DeferredInitialize;
If IL_FileExists(FileName) then
  begin
    FillChar(AutomationInfo,SizeOf(TILPictureAutomationInfo),0);
    AutomationInfo.CRC32 := FileCRC32(FileName);
    // get size
    with TWinFileInfo.Create(FileName,WFI_LS_LoadSize) do
    try
      AutomationInfo.Size := Size;
    finally
      Free;
    end;
    // try loading resolution (only for JPEG pics)
    try
      with TJPEGImage.Create do
      try
        LoadFromFile(StrToRTL(FileName));
        AutomationInfo.Width := Width;
        AutomationInfo.Height := Height;
      finally
        Free;
      end;
    except
      AutomationInfo.Width := -1;
      AutomationInfo.Height := -1;
      // swallow exception
    end;
    AutomationInfo.FileName := IL_Format('%s_%s%s',[
      TILItem(fOnItemObjectReq(Self)).Descriptor,
      IL_UpperCase(CRC32ToStr(AutomationInfo.CRC32)),
      IL_LowerCase(IL_ExtractFileExt(FileName))]);
    AutomationInfo.FilePath := fAutomationFolder + AutomationInfo.FileName;
    If not CheckIndex(IndexOf(AutomationInfo.FileName)) then
      begin
        // now copy the file into automation folder
        IL_CreateDirectoryPathForFile(AutomationInfo.FilePath);
        IL_CopyFile(FileName,AutomationInfo.FilePath);
        // all is well...
        Result := True;
      end
    else Result := False;
  end
else Result := False;
end;

//------------------------------------------------------------------------------

procedure TILItemPictures_Base.OpenPictureFile(Index: Integer);
begin
If CheckIndex(Index) then
  begin
    DeferredInitialize;
    IL_ShellOpen(0,fAutomationFolder + fPictures[Index].PictureFile);
  end
else raise Exception.CreateFmt('TILItemPictures_Base.OpenPictureFile: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

procedure TILItemPictures_Base.SetThumbnail(Index: Integer; Thumbnail: TBitmap; CreateCopy: Boolean);
begin
If CheckIndex(Index) then
  begin
    FreeEntry(fPictures[Index],True);
    If Assigned(Thumbnail) then
      begin
        If CreateCopy then
          begin
            fPictures[Index].Thumbnail := TBitmap.Create;
            fPictures[Index].Thumbnail.Assign(Thumbnail);
          end
        else fPictures[Index].Thumbnail := Thumbnail;
        // create small (1/2) thumb
        fPictures[Index].ThumbnailSmall := TBitmap.Create;
        fPictures[Index].ThumbnailSmall.PixelFormat := pf24Bit;
        fPictures[Index].ThumbnailSmall.Width := 48;
        fPictures[Index].ThumbnailSmall.Height := 48;
        IL_PicShrink(fPictures[Index].Thumbnail,fPictures[Index].ThumbnailSmall,2);
        // create mini (1/3) thumb
        fPictures[Index].ThumbnailMini := TBitmap.Create;
        fPictures[Index].ThumbnailMini.PixelFormat := pf24Bit;
        fPictures[Index].ThumbnailMini.Width := 32;
        fPictures[Index].ThumbnailMini.Height := 32;
        IL_PicShrink(fPictures[Index].Thumbnail,fPictures[Index].ThumbnailMini,3);
      end;
    UpdatePictures;
  end
else raise Exception.CreateFmt('TILItemPictures_Base.SetThumbnail: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

procedure TILItemPictures_Base.SetItemPicture(Index: Integer; Value: Boolean);
var
  i:  Integer;
begin
If CheckIndex(Index) then
  begin
    For i := LowIndex to HighIndex do
      fPictures[i].ItemPicture := (i = Index) and Value;
    If fCurrentSecondary = Index then
      NextSecondary;
    UpdatePictures;
  end
else raise Exception.CreateFmt('TILItemPictures_Base.SetItemPicture: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

procedure TILItemPictures_Base.SetPackagePicture(Index: Integer; Value: Boolean);
var
  i:  Integer;
begin
If CheckIndex(Index) then
  begin
    For i := LowIndex to HighIndex do
      fPictures[i].PackagePicture := (i = Index) and Value;
    If fCurrentSecondary = Index then
      NextSecondary;
    UpdatePictures;
  end
else raise Exception.CreateFmt('TILItemPictures_Base.SetPackagePicture: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

Function TILItemPictures_Base.SecondaryCount: Integer;
var
  i:  Integer;
begin
Result := 0;
For i := LowIndex to HighIndex do
  If not fPictures[i].ItemPicture and not fPictures[i].PackagePicture then
    Inc(Result);
end;

//------------------------------------------------------------------------------

Function TILItemPictures_Base.PrevSecondary: Integer;
var
  i:  Integer;
begin
If SecondaryCount > 0 then
  begin
    i := fCurrentSecondary;
    repeat
      i := IL_IndexWrap(i - 1,LowIndex,HighIndex);
    until not fPictures[i].ItemPicture and not fPictures[i].PackagePicture;
    fCurrentSecondary := i;
  end
else fCurrentSecondary := -1;
Result := fCurrentSecondary;
end;

//------------------------------------------------------------------------------

Function TILItemPictures_Base.NextSecondary: Integer;
var
  i:  Integer;
begin
If SecondaryCount > 0 then
  begin
    i := fCurrentSecondary;
    repeat
      i := IL_IndexWrap(i + 1,LowIndex,HighIndex);
    until not fPictures[i].ItemPicture and not fPictures[i].PackagePicture;
    fCurrentSecondary := i;
  end
else fCurrentSecondary := -1;
Result := fCurrentSecondary;
end;

//------------------------------------------------------------------------------

Function TILItemPictures_Base.ExportPicture(Index: Integer; const IntoDirectory: String): Boolean;
begin
Result := False;
If CheckIndex(Index) then
  begin
    DeferredInitialize;
    If IL_FileExists(fAutomationFolder + fPictures[Index].PictureFile) then
      begin
        IL_CopyFile(fAutomationFolder + fPictures[Index].PictureFile,
          IL_IncludeTrailingPathDelimiter(IntoDirectory) + fPictures[Index].PictureFile);
        Result := True;
      end;
  end
else raise Exception.CreateFmt('TILItemPictures_Base.ExportPicture: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

Function TILItemPictures_Base.ExportThumbnail(Index: Integer; const IntoDirectory: String): Boolean;
begin
Result := False;
If CheckIndex(Index) then
  begin
    DeferredInitialize;
    If Assigned(fPictures[Index].Thumbnail) then
      begin
        fPictures[Index].Thumbnail.SaveToFile(
          StrToRTL(IL_ChangeFileExt(IL_IncludeTrailingPathDelimiter(IntoDirectory) + fPictures[Index].PictureFile,'.bmp')));
        Result := True;  
      end;
  end
else raise Exception.CreateFmt('TILItemPictures_Base.ExportThumbnail: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

procedure TILItemPictures_Base.AssignInternalEvents(ItemObjectReq: TILItemObjectRequired; OnPicturesChange: TNotifyEvent);
begin
fOnItemObjectReq := ItemObjectReq;
fOnPicturesChange := OnPicturesChange;
end;

end.
