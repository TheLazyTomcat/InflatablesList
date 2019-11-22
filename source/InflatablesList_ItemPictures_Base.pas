unit InflatablesList_ItemPictures_Base;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  Graphics,
  AuxClasses;

type
  TILItemPicturesEntry = record
    PictureFile:    String;
    Thumbnail:      TBitmap;
    ThumbnailSmall: TBitmap;
    ThumbnailMini:  TBitmap;
    ItemPicture:    Boolean;
    PackagePicture: Boolean;
  end;
  PILItemPicturesEntry = ^TILItemPicturesEntry;

  TILItemPictures_Base = class(TCustomListObject)
  protected
    fPictures:          array of TILItemPicturesEntry;
    fCount:             Integer;
    fCurrentSecondary:  Integer;
    // getters, setters
    Function GetEntry(Index: Integer): TILItemPicturesEntry;
    Function GetEntryPtr(Index: Integer): PILItemPicturesEntry;
    // list methods
    Function GetCapacity: Integer; override;
    procedure SetCapacity(Value: Integer); override;
    Function GetCount: Integer; override;
    procedure SetCount(Value: Integer); override;
    // other methods
    procedure Initialize; virtual;
    procedure Finalize; virtual;
  public
    class procedure FreeEntry(var Entry: TILItemPicturesEntry; KeepFile: Boolean = False); virtual;
    constructor Create;
    constructor CreateAsCopy(Source: TILItemPictures_Base);
    destructor Destroy; override;
    Function LowIndex: Integer; override;
    Function HighIndex: Integer; override;
    Function IndexOf(const PictureFile: String): Integer; overload; virtual;
    Function IndexOf(Thumbnail: TBitmap): Integer; overload; virtual;
    Function IndexOfItemPicture: Integer; virtual;
    Function IndexOfPackagePicture: Integer; virtual;
    Function Add(const PictureFile: String): Integer; virtual;
    procedure Delete(Index: Integer); virtual;
    procedure Clear; virtual;
    procedure SetThumbnail(Index: Integer; Thumbnail: TBitmap; CreateCopy: Boolean); virtual;
    procedure SetItemPicture(Index: Integer; Value: Boolean); virtual;
    procedure SetPackagePicture(Index: Integer; Value: Boolean); virtual;
    Function SecondaryCount: Integer; virtual;
    Function PrevSecondary: Integer; virtual;
    Function NextSecondary: Integer; virtual;
    property Pictures[Index: Integer]: TILItemPicturesEntry read GetEntry;
    property Pointers[Index: Integer]: PILItemPicturesEntry read GetEntryPtr; {$message 'remove?'}
    property CurrentSecondary: Integer read fCurrentSecondary;
  end;

implementation

uses
  SysUtils,
  InflatablesList_Utils;

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

procedure TILItemPictures_Base.Initialize;
begin
SetLength(fPictures,0);
fCount := 0;
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

constructor TILItemPictures_Base.CreateAsCopy(Source: TILItemPictures_Base);
var
  i:  Integer;
begin
Create;
SetLength(fPictures,Source.Count);
For i := Low(fPictures) to High(fPictures) do
  begin
    fPictures[i] := Source.Pictures[i];
    fPictures[i].Thumbnail := TBitmap.Create;
    fPictures[i].Thumbnail.Assign(Source.Pictures[i].Thumbnail);
    fPictures[i].ThumbnailSmall := TBitmap.Create;
    fPictures[i].ThumbnailSmall.Assign(Source.Pictures[i].ThumbnailSmall);
    fPictures[i].ThumbnailMini := TBitmap.Create;
    fPictures[i].ThumbnailMini.Assign(Source.Pictures[i].ThumbnailMini);
  end;
fCurrentSecondary := Source.CurrentSecondary;
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

Function TILItemPictures_Base.IndexOfItemPicture: Integer;
var
  i:  Integer;
begin
Result := -1;
For i := Low(fPictures) to High(fPictures) do
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
For i := Low(fPictures) to High(fPictures) do
  If fPictures[i].PackagePicture then
    begin
      Result := i;
      Break{For i};
    end;
end;

//------------------------------------------------------------------------------

Function TILItemPictures_Base.Add(const PictureFile: String): Integer;
begin
Grow;
Result := fCount;
FreeEntry(fPictures[Result]);
fPictures[Result].PictureFile := PictureFile;
Inc(fCount);
If fCurrentSecondary < 0 then
  fCurrentSecondary := Result;
end;

//------------------------------------------------------------------------------

procedure TILItemPictures_Base.Delete(Index: Integer);
var
  i:  Integer;
begin
If (Index >= Low(fPictures)) and (Index <= High(fPictures)) then
  begin
    If Index = fCurrentSecondary then
      begin
        NextSecondary;
        If Index = fCurrentSecondary then
          fCurrentSecondary := -1;
      end;
    FreeEntry(fPictures[Index]);
    For i := Index to Pred(High(fPictures)) do
      fPictures[i] := fPictures[i + 1];
    Shrink;
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
fCount := 0;
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

procedure TILItemPictures_Base.SetItemPicture(Index: Integer; Value: Boolean);
var
  i:  Integer;
begin
If (Index >= Low(fPictures)) and (Index <= High(fPictures)) then
  begin
    For i := Low(fPictures) to High(fPictures) do
      fPictures[i].ItemPicture := (i = Index) and Value;
    If fCurrentSecondary = Index then
      NextSecondary;
  end
else raise Exception.CreateFmt('TILItemPictures_Base.SetItemPicture: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

procedure TILItemPictures_Base.SetPackagePicture(Index: Integer; Value: Boolean);
var
  i:  Integer;
begin
If (Index >= Low(fPictures)) and (Index <= High(fPictures)) then
  begin
    For i := Low(fPictures) to High(fPictures) do
      fPictures[i].ItemPicture := (i = Index) and Value;
    If fCurrentSecondary = Index then
      NextSecondary;      
  end
else raise Exception.CreateFmt('TILItemPictures_Base.SetPackagePicture: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

Function TILItemPictures_Base.SecondaryCount: Integer;
var
  i:  Integer;
begin
Result := 0;
For i := Low(fPictures) to High(fPictures) do
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
      i := IL_IndexWrap(i - 1,Low(fPictures),High(fPictures));
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
      i := IL_IndexWrap(i + 1,Low(fPictures),High(fPictures));
    until not fPictures[i].ItemPicture and not fPictures[i].PackagePicture;
    fCurrentSecondary := i;
  end
else fCurrentSecondary := -1;
Result := fCurrentSecondary;
end;

end.
