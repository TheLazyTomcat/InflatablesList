unit InflatablesList_ItemPictures_Base;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  Graphics,
  AuxTypes, AuxClasses, CRC32,
  InflatablesList_Types;

type
  TILItemPicturesEntry = record
    PictureFile:    String;   // only file name, not full path
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
    // internals
    fStaticSettings:      TILStaticManagerSettings;
    fOwner:               TObject;  // should be TILItem, but it would cause circular reference
    fUpdateCounter:       Integer;
    fUpdated:             Boolean;
    fInitializing:        Boolean;
    // data
    fPictures:            array of TILItemPicturesEntry;
    fCount:               Integer;
    fCurrentSecondary:    Integer;
    fOnPicturesChange:    TNotifyEvent;
    // getters, setters
    procedure SetStaticSettings(Value: TILStaticManagerSettings); virtual;
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
    class procedure FreeEntry(var Entry: TILItemPicturesEntry; KeepFile: Boolean = False); virtual;
    class procedure GenerateSmallThumbnails(var Entry: TILItemPicturesEntry); virtual;
  public
    constructor Create(Owner: TObject);
    constructor CreateAsCopy(Owner: TObject; Source: TILItemPictures_Base; UniqueCopy: Boolean);
    destructor Destroy; override;
    Function LowIndex: Integer; override;
    Function HighIndex: Integer; override;
    procedure BeginUpdate; virtual;
    procedure EndUpdate; virtual;
    procedure BeginInitialization; virtual;
    procedure EndInitialization; virtual;
    Function IndexOf(const PictureFile: String): Integer; overload; virtual;
    Function IndexOf(Thumbnail: TBitmap): Integer; overload; virtual;
    Function IndexOfItemPicture: Integer; virtual;
    Function IndexOfPackagePicture: Integer; virtual;
    Function Add(AutomationInfo: TILPictureAutomationInfo): Integer; overload; virtual;
    Function Add(const PictureFile: String): Integer; overload; virtual;
    procedure Exchange(Idx1,Idx2: Integer); virtual;
    procedure Delete(Index: Integer); virtual;
    procedure Clear(Destroying: Boolean = False); virtual;
    Function AutomatePictureFile(const FileName: String; out AutomationInfo: TILPictureAutomationInfo): Boolean; virtual;
    procedure RealodPictureInfo(Index: Integer); virtual;
    procedure OpenPictureFile(Index: Integer); virtual;
    procedure SetThumbnail(Index: Integer; Thumbnail: TBitmap; CreateCopy: Boolean); virtual;
    procedure SetItemPicture(Index: Integer; Value: Boolean); virtual;
    procedure SetPackagePicture(Index: Integer; Value: Boolean); virtual;
    Function SecondaryCount(WithThumbnailOnly: Boolean): Integer; virtual;
    Function SecondaryIndex(Index: Integer): Integer; virtual;
    Function PrevSecondary: Integer; virtual;
    Function NextSecondary: Integer; virtual;
    Function ImportPictures(Source: TILItemPictures_Base): Integer; virtual;
    Function ExportPicture(Index: Integer; const IntoDirectory: String): Boolean; virtual;
    Function ExportThumbnail(Index: Integer; const IntoDirectory: String): Boolean; virtual;
    procedure AssignInternalEvents(OnPicturesChange: TNotifyEvent); virtual;
    property StaticSettings: TILStaticManagerSettings read fStaticSettings write SetStaticSettings;
    property Owner: TObject read fOwner;
    property Pictures[Index: Integer]: TILItemPicturesEntry read GetEntry; default;
    property CurrentSecondary: Integer read fCurrentSecondary;
  end;

implementation

uses
  SysUtils, JPEG,
  WinFileInfo, StrRect,
  InflatablesList_Utils,
  InflatablesList_Item;

procedure TILItemPictures_Base.SetStaticSettings(Value: TILStaticManagerSettings);
begin
fStaticSettings := IL_ThreadSafeCopy(Value);
end;

//------------------------------------------------------------------------------

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
If Assigned(fOnPicturesChange) and not fInitializing and (fUpdateCounter <= 0) then
  fOnPicturesChange(Self);
fUpdated := True
end;

//------------------------------------------------------------------------------

procedure TILItemPictures_Base.Initialize;
begin
fUpdateCounter := 0;
fUpdated := False;
fInitializing := False;
SetLength(fPictures,0);
fCount := 0;
fCurrentSecondary := -1;
end;

//------------------------------------------------------------------------------

procedure TILItemPictures_Base.Finalize;
begin
Clear(True);
end;

//------------------------------------------------------------------------------

class procedure TILItemPictures_Base.FreeEntry(var Entry: TILItemPicturesEntry; KeepFile: Boolean = False);
begin
If not KeepFile then
  begin
    Entry.PictureFile := '';
    Entry.PictureSize := 0;
    Entry.PictureWidth := -1;
    Entry.PictureHeight := -1;
    Entry.ItemPicture := False;
    Entry.PackagePicture := False;
  end;
If Assigned(Entry.Thumbnail) then
  FreeAndNil(Entry.Thumbnail);
If Assigned(Entry.ThumbnailSmall) then
  FreeAndNil(Entry.ThumbnailSmall);
If Assigned(Entry.ThumbnailMini) then
  FreeAndNil(Entry.ThumbnailMini);
end;

//------------------------------------------------------------------------------

class procedure TILItemPictures_Base.GenerateSmallThumbnails(var Entry: TILItemPicturesEntry);
begin
If Assigned(Entry.Thumbnail) then
  begin
    // create small (1/2) thumb
    Entry.ThumbnailSmall := TBitmap.Create;
    Entry.ThumbnailSmall.PixelFormat := pf24Bit;
    Entry.ThumbnailSmall.Width := 48;
    Entry.ThumbnailSmall.Height := 48;
    IL_PicShrink(Entry.Thumbnail,Entry.ThumbnailSmall,2);
    // create mini (1/3) thumb
    Entry.ThumbnailMini := TBitmap.Create;
    Entry.ThumbnailMini.PixelFormat := pf24Bit;
    Entry.ThumbnailMini.Width := 32;
    Entry.ThumbnailMini.Height := 32;
    IL_PicShrink(Entry.Thumbnail,Entry.ThumbnailMini,3);
    // minimize GDI handle use
    Entry.Thumbnail.Dormant;
    Entry.ThumbnailSmall.Dormant;
    Entry.ThumbnailMini.Dormant;
  end
else
  begin
    Entry.ThumbnailSmall := nil;
    Entry.ThumbnailMini := nil;
  end;
end;

//==============================================================================

constructor TILItemPictures_Base.Create(Owner: TObject);
begin
inherited Create;
If Owner is TILItem then
  begin
    fOwner := Owner;
    Initialize;
  end
else raise Exception.CreateFmt('TILItemPictures_Base.Create: Invalid owner class (%s).',[Owner.ClassName]);
end;

//------------------------------------------------------------------------------

constructor TILItemPictures_Base.CreateAsCopy(Owner: TObject; Source: TILItemPictures_Base; UniqueCopy: Boolean);
var
  i,Index:  Integer;
  Info:     TILPictureAutomationInfo;
begin
Create(Owner);
fStaticSettings := IL_ThreadSafeCopy(Source.StaticSettings);
For i := Source.LowIndex to Source.HighIndex do
  If UniqueCopy then
    begin
      If AutomatePictureFile(Source.StaticSettings.PicturesPath + Source[i].PictureFile,Info) then
        begin
          Index := Add(Info);
          If CheckIndex(Index) then
            begin
              SetThumbnail(Index,Source[i].Thumbnail,True);
              If Source[i].ItemPicture then
                SetItemPicture(Index,True);
              If Source[i].PackagePicture then
                SetPackagePicture(Index,True);
            end;
      end;
    end
  else
    begin
      Index := Add(Source[i].PictureFile);
      If CheckIndex(Index) then
        begin
          fPictures[Index].PictureSize := Source[i].PictureSize;
          fPictures[Index].PictureWidth := Source[i].PictureWidth;
          fPictures[Index].PictureHeight := Source[i].PictureHeight;
          fPictures[Index].ItemPicture := Source[i].ItemPicture;
          fPictures[Index].PackagePicture := Source[i].PackagePicture;
          SetThumbnail(Index,Source[i].Thumbnail,True);
        end;
    end;
fCurrentSecondary := Source.CurrentSecondary;
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

procedure TILItemPictures_Base.BeginUpdate;
begin
If fUpdateCounter <= 0 then
  fUpdated := False;
Inc(fUpdateCounter);
end;

//------------------------------------------------------------------------------

procedure TILItemPictures_Base.EndUpdate;
begin
Dec(fUpdateCounter);
If fUpdateCounter <= 0 then
  begin
    fUpdateCounter := 0;
    If fUpdated then
      UpdatePictures;
    fUpdated := False;
  end;
end;

//------------------------------------------------------------------------------

procedure TILItemPictures_Base.BeginInitialization;
begin
fInitializing := True;
BeginUpdate;
end;

//------------------------------------------------------------------------------

procedure TILItemPictures_Base.EndInitialization;
begin
EndUpdate;
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
If not CheckIndex(fCurrentSecondary) then
  fCurrentSecondary := Result;
Inc(fCount);  
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
        If fCurrentSecondary = Index then
          fCurrentSecondary := -1;
      end;
    If fCurrentSecondary > Index then
      Dec(fCurrentSecondary);
    FreeEntry(fPictures[Index]);
    For i := Index to Pred(HighIndex) do
      fPictures[i] := fPictures[i + 1];
    // clear item that was moved down  
    fPictures[HighIndex].PictureFile := '';
    FillChar(fPictures[HighIndex],SizeOf(TILItemPicturesEntry),0);
    Shrink;
    Dec(fCount);
    UpdatePictures;
  end
else raise Exception.CreateFmt('TILItemPictures_Base.Delete: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

procedure TILItemPictures_Base.Clear(Destroying: Boolean = False);
var
  i:  Integer;
begin
For i := LowIndex to HighIndex do
  FreeEntry(fPictures[i]);
SetLength(fPictures,0);
fCount := 0;
fCurrentSecondary := -1;
If not Destroying then
  UpdatePictures;
end;

//------------------------------------------------------------------------------

Function TILItemPictures_Base.AutomatePictureFile(const FileName: String; out AutomationInfo: TILPictureAutomationInfo): Boolean;
var
  Temp: TGUID;
begin
If IL_FileExists(FileName) then
  begin
    FillChar(AutomationInfo,SizeOf(TILPictureAutomationInfo),0);
    Temp := TILItem(fOwner).UniqueID; // cannot directly pass a property
    AutomationInfo.CRC32 := FileCRC32(FileName) xor BufferCRC32(Temp,SizeOf(TGUID));
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
      TILItem(Owner).Descriptor,
      IL_UpperCase(CRC32ToStr(AutomationInfo.CRC32)),
      IL_LowerCase(IL_ExtractFileExt(FileName))]);
    AutomationInfo.FilePath := fStaticSettings.PicturesPath + AutomationInfo.FileName;
    If not CheckIndex(IndexOf(AutomationInfo.FileName)) then
      begin
        // now copy the file into automation folder
        IL_CreateDirectoryPathForFile(AutomationInfo.FilePath);
        If not IL_SameText(FileName,AutomationInfo.FilePath) then
          IL_CopyFile(FileName,AutomationInfo.FilePath);
        // all is well...
        Result := True;
      end
    else Result := False;
  end
else Result := False;
end;

//------------------------------------------------------------------------------

procedure TILItemPictures_Base.RealodPictureInfo(Index: Integer);
begin
If CheckIndex(Index) then
  begin
    try
      // get size
      with TWinFileInfo.Create(fStaticSettings.PicturesPath + fPictures[Index].PictureFile,WFI_LS_LoadSize) do
      try
        fPictures[Index].PictureSize := Size;
      finally
        Free;
      end;
      // try load resolution
      with TJPEGImage.Create do
      try
        LoadFromFile(StrToRTL(fStaticSettings.PicturesPath + fPictures[Index].PictureFile));
        fPictures[Index].PictureWidth := Width;
        fPictures[Index].PictureHeight := Height;
      finally
        Free;
      end;
    except
      fPictures[Index].PictureSize := 0;
      fPictures[Index].PictureWidth := -1;
      fPictures[Index].PictureHeight := -1;
    end;
  end
else raise Exception.CreateFmt('TILItemPictures_Base.RealodPictureInfo: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

procedure TILItemPictures_Base.OpenPictureFile(Index: Integer);
begin
If CheckIndex(Index) then
  IL_ShellOpen(0,fStaticSettings.PicturesPath + fPictures[Index].PictureFile)
else
  raise Exception.CreateFmt('TILItemPictures_Base.OpenPictureFile: Index (%d) out of bounds.',[Index]);
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
        GenerateSmallThumbnails(fPictures[Index]);
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
    If ((fPictures[Index].ItemPicture or fPictures[Index].PackagePicture) and
        (fCurrentSecondary = Index)) or not CheckIndex(fCurrentSecondary) then
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
    If ((fPictures[Index].ItemPicture or fPictures[Index].PackagePicture) and
        (fCurrentSecondary = Index)) or not CheckIndex(fCurrentSecondary) then
      NextSecondary;
    UpdatePictures;
  end
else raise Exception.CreateFmt('TILItemPictures_Base.SetPackagePicture: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

Function TILItemPictures_Base.SecondaryCount(WithThumbnailOnly: Boolean): Integer;
var
  i:  Integer;
begin
Result := 0;
For i := LowIndex to HighIndex do
  If (not fPictures[i].ItemPicture and not fPictures[i].PackagePicture) and
     (Assigned(fPictures[i].Thumbnail) or not WithThumbnailOnly) then
    Inc(Result); 
end;

//------------------------------------------------------------------------------

Function TILItemPictures_Base.SecondaryIndex(Index: Integer): Integer;
var
  i:  Integer;
begin
Result := -1;
If CheckIndex(Index) then
  For i := LowIndex to Index do
    If not fPictures[i].ItemPicture and not fPictures[i].PackagePicture then
      Inc(Result);
end;

//------------------------------------------------------------------------------

Function TILItemPictures_Base.PrevSecondary: Integer;
var
  i:  Integer;
begin
If SecondaryCount(False) > 0 then
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
If SecondaryCount(False) > 0 then
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

Function TILItemPictures_Base.ImportPictures(Source: TILItemPictures_Base): Integer;
var
  i:      Integer;
  Info:   TILPictureAutomationInfo;
  Index:  Integer;
begin
Result := 0;
BeginUpdate;
try
  For i := Source.LowIndex to Source.HighIndex do
    If AutomatePictureFile(Source.StaticSettings.PicturesPath + Source[i].PictureFile,Info) then
      begin
        Index := Add(Info);
        If CheckIndex(Index) then
          begin
            SetThumbnail(Index,Source[i].Thumbnail,True);
            Inc(Result);
          end;
      end;
finally
  EndUpdate;
end;
end;

//------------------------------------------------------------------------------

Function TILItemPictures_Base.ExportPicture(Index: Integer; const IntoDirectory: String): Boolean;
begin
Result := False;
If CheckIndex(Index) then
  begin
    If IL_FileExists(fStaticSettings.PicturesPath + fPictures[Index].PictureFile) then
      begin
        IL_CopyFile(fStaticSettings.PicturesPath + fPictures[Index].PictureFile,
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

procedure TILItemPictures_Base.AssignInternalEvents(OnPicturesChange: TNotifyEvent);
begin
fOnPicturesChange := OnPicturesChange;
end;

end.
