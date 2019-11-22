unit InflatablesList_ItemPictures_Base;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  Graphics;

type
  TILItemPicturesEntry = record
    Thumbnail:      TBitmap;
    ThumbnailSmall: TBitmap;
    ThumbnailMini:  TBitmap;
    PictureFile:    String;
  end;
  PILItemPicturesEntry = ^TILItemPicturesEntry;

  TILItemPictures_Base = class(TObject)
  protected
    fPictures:          array of TILItemPicturesEntry;
    fItemPicture:       Integer;
    fPackagePicture:    Integer;
    fCurrentSecondary:  Integer;
    Function GetPictureCount: Integer;
    Function GetEntry(Index: Integer): TILItemPicturesEntry;
    Function GetEntryPtr(Index: Integer): PILItemPicturesEntry;
    procedure Initialize; virtual;
    procedure Finalize; virtual;
  public
    class procedure FreeEntry(var Entry: TILItemPicturesEntry; KeepFile: Boolean = False); virtual;
    constructor Create;
    constructor CreateAsCopy(Source: TILItemPictures_Base);
    destructor Destroy; override;
    Function IndexOf(const PictureFile: String): Integer; overload; virtual;
    Function IndexOf(Thumbnail: TBitmap): Integer; overload; virtual;
    Function Add(const PictureFile: String): Integer; virtual;
    procedure Delete(Index: Integer); virtual;
    procedure Clear; virtual;
    procedure SetThumbnail(Index: Integer; Thumbnail: TBitmap; CreateCopy: Boolean); virtual;
    Function SecondaryCount: Integer; virtual;
    //Function PrevSecondary: Integer; virtual;
    //Function NextSecondary: Integer; virtual;
    property Count: Integer read GetPictureCount;
    property Pictures[Index: Integer]: TILItemPicturesEntry read GetEntry;
    property Pointers[Index: Integer]: PILItemPicturesEntry read GetEntryPtr;
    property ItemPicture: Integer read fItemPicture;// write SetItemPicture;
    property PackagePicture: Integer read fPackagePicture;// write SetPackagePicture;
    property CurrentSecondary: Integer read fCurrentSecondary;
  end;

implementation

uses
  SysUtils,
  InflatablesList_Utils;

Function TILItemPictures_Base.GetPictureCount: Integer;
begin
Result := Length(fPictures);
end;

//------------------------------------------------------------------------------

Function TILItemPictures_Base.GetEntry(Index: Integer): TILItemPicturesEntry;
begin
If (Index >= Low(fPictures)) and (Index <= High(fPictures)) then
  Result := fPictures[Index]
else
  raise Exception.CreateFmt('TILItemPictures_Base.GetEntry: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

Function TILItemPictures_Base.GetEntryPtr(Index: Integer): PILItemPicturesEntry;
begin
If (Index >= Low(fPictures)) and (Index <= High(fPictures)) then
  Result := Addr(fPictures[Index])
else
  raise Exception.CreateFmt('TILItemPictures_Base.GetEntryPtr: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

procedure TILItemPictures_Base.Initialize;
begin
SetLength(fPictures,0);
fItemPicture := -1;
fPackagePicture := -1;
fCurrentSecondary := -1;
end;

//------------------------------------------------------------------------------

procedure TILItemPictures_Base.Finalize;
begin
Clear;
end;

//==============================================================================

class procedure TILItemPictures_Base.FreeEntry(var Entry: TILItemPicturesEntry; KeepFile: Boolean = False);
begin
If Assigned(Entry.Thumbnail) then
  FreeAndnil(Entry.Thumbnail);
If Assigned(Entry.ThumbnailSmall) then
  FreeAndnil(Entry.ThumbnailSmall);
If Assigned(Entry.ThumbnailMini) then
  FreeAndnil(Entry.ThumbnailMini);
If not KeepFile then
  Entry.PictureFile := '';
end;

//------------------------------------------------------------------------------

constructor TILItemPictures_Base.Create;
begin
inherited Create;
Initialize;
end;

//------------------------------------------------------------------------------

destructor TILItemPictures_Base.Destroy;
begin
Finalize;
inherited;
end;

//------------------------------------------------------------------------------

Function TILItemPictures_Base.IndexOf(const PictureFile: String): Integer;
var
  i:  Integer;
begin
Result := -1;
For i := Low(fPictures) to High(fPictures) do
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
For i := Low(fPictures) to High(fPictures) do
  If fPictures[i].Thumbnail = Thumbnail then
    begin
      Result := i;
      Break{For i};
    end;
end;

//------------------------------------------------------------------------------

Function TILItemPictures_Base.Add(const PictureFile: String): Integer;
begin
SetLength(fPictures,Length(fPictures) + 1);
Result := High(fPictures);
FreeEntry(fPictures[Result]);
fPictures[Result].PictureFile := PictureFile;
If fCurrentSecondary < 0 then
  fCurrentSecondary := 0;
end;

//------------------------------------------------------------------------------

procedure TILItemPictures_Base.Delete(Index: Integer);
var
  i:  Integer;
begin
If (Index >= Low(fPictures)) and (Index <= High(fPictures)) then
  begin
    FreeEntry(fPictures[Index]);
    If Index = fItemPicture then
      fItemPicture := -1;
    If Index = fPackagePicture then
      fPackagePicture := -1;
    //If Index = fCurrentSecondary then
    //  fCurrentSecondary := -1;
    For i := Index to Pred(High(fPictures)) do
      fPictures[i] := fPictures[i + 1];
    SetLength(fPictures,Length(fPictures) - 1);
  end
else raise Exception.CreateFmt('TILItemPictures_Base.Delete: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

procedure TILItemPictures_Base.Clear;
var
  i:  Integer;
begin
For i := Low(fPictures) to High(fPictures) do
  FreeEntry(fPictures[i]);
SetLength(fPictures,0);
fItemPicture := -1;
fPackagePicture := -1;
fCurrentSecondary := -1;
end;

//------------------------------------------------------------------------------

procedure TILItemPictures_Base.SetThumbnail(Index: Integer; Thumbnail: TBitmap; CreateCopy: Boolean);
begin
If (Index >= Low(fPictures)) and (Index <= High(fPictures)) then
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
  end
else raise Exception.CreateFmt('TILItemPictures_Base.SetThumbnail: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

Function TILItemPictures_Base.SecondaryCount: Integer;
begin
Result := Count;
If fItemPicture >= 0 then
  Dec(Result);
If (fPackagePicture >= 0) and (fPackagePicture <> fItemPicture) then
  Dec(Result);
If Result < 0 then
  Result := 0;
end;

end.
