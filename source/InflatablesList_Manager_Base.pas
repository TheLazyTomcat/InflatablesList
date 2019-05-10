unit InflatablesList_Manager_Base;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  // unit Windows must be before graphics and classes
  Windows, Classes, Graphics, StdCtrls,
  AuxTypes,
  InflatablesList_Types, InflatablesList_Data;

const
  IL_LISTFILE_SIGNATURE = UInt32($4C464E49);  // signature of the list file

  IL_LISTFILE_FILESTRUCTURE_00000000 = UInt32($00000000);
  IL_LISTFILE_FILESTRUCTURE_00000001 = UInt32($00000001);
  IL_LISTFILE_FILESTRUCTURE_00000002 = UInt32($00000002);
  IL_LISTFILE_FILESTRUCTURE_00000003 = UInt32($00000003);

  IL_LISTFILE_FILESTRUCTURE_SAVE = IL_LISTFILE_FILESTRUCTURE_00000003;

  IL_LISTFILE_UPDATE_TRYCOUNT = 5;  // how many times to repeat update when it fails in certain way

  IL_SHOPTEMPLATE_SIGNATURE = UInt32($4C505453);  // signature of the exported shop template

type
  TILManager_Base = class(TObject)
  protected
    fDataProvider:          TILDataProvider;
    // rendering variables
    fFileName:              String;
    fRenderWidth:           Integer;
    fRenderHeight:          Integer;
    fFontSettings:          TFont;
    // main list
    fList:                  array of TILItem;
    // sorting
    fSorting:               Boolean;
    fReversedSort:          Boolean;
    fUsedSortSett:          TILSortingSettings;
    fDefaultSortSett:       TILSortingSettings;
    fActualSortSett:        TILSortingSettings;
    fSortingProfiles:       TILSortingProfiles;
    // filer settings (for sums)
    fFilterSettings:        TILFilterSettings;
    // shop templates
    fShopTemplates:         TILShopTemplates;
    // IO functions
    fFNSaveToStream:        procedure(Stream: TStream) of object;
    fFNLoadFromStream:      procedure(Stream: TStream) of object;
    fFNSaveSortingSettings: procedure(Stream: TStream) of object;
    fFNLoadSortingSettings: procedure(Stream: TStream) of object;
    fFNSaveShopTemplates:   procedure(Stream: TStream) of object;
    fFNLoadShopTemplates:   procedure(Stream: TStream) of object;
    fFNSaveFilterSettings:  procedure(Stream: TStream) of object;
    fFNLoadFilterSettings:  procedure(Stream: TStream) of object;
    fFNSaveItem:            procedure(Stream: TStream; const Item: TILItem) of object;
    fFNLoadItem:            procedure(Stream: TStream; out Item: TILItem) of object;
    fFNSaveItemShop:        procedure(Stream: TStream; const Shop: TILItemShop) of object;
    fFNLoadItemShop:        procedure(Stream: TStream; out Shop: TILItemShop) of object;
    fFNSaveParsingSettings: procedure(Stream: TStream; const ParsSett: TILItemShopParsingSetting) of object;
    fFNLoadParsingSettings: procedure(Stream: TStream; out ParsSett: TILItemShopParsingSetting) of object;
    fFNExportShopTemplate:  procedure(Stream: TStream; const ShopTemplate: TILShopTemplate) of object;
    fFNImportShopTemplate:  procedure(Stream: TStream; out ShopTemplate: TILShopTemplate) of object;
    // getters, setters
    Function GetItemCount: Integer;
    Function GetItem(Index: Integer): TILItem;
    Function GetItemPtr(Index: Integer): PILItem;
    Function GetSortProfileCount: Integer;
    Function GetSortProfile(Index: Integer): TILSortingProfile;
    Function GetSortProfilePtr(Index: Integer): PILSortingProfile;
    Function GetShopTemplateCount: Integer;
    Function GetShopTemplate(Index: Integer): TILShopTemplate;
    Function GetShopTemplatePtr(Index: Integer): PILShopTemplate;
    // initialization / finalization
    procedure InitializeSortingSettings; virtual;
    procedure FinalizeSortingSettings; virtual;
    procedure Initialize; virtual;
    procedure Finalize; virtual;
    // saving/loading of data (excluding header)
    procedure InitSaveFunctions(Struct: UInt32); virtual; abstract;
    procedure InitLoadFunctions(Struct: UInt32); virtual; abstract;
    procedure SaveData(Stream: TStream; Struct: UInt32); virtual;
    procedure LoadData(Stream: TStream; Struct: UInt32); virtual;
    procedure ExportShopTemplate(Stream: TStream; const ShopTemplate: TILShopTemplate; Struct: UInt32); virtual;
    procedure ImportShopTemplate(Stream: TStream; out ShopTemplate: TILShopTemplate; Struct: UInt32); virtual;
    // other methods
    Function ItemCompare(Idx1,Idx2: Integer): Integer; virtual;
    Function ItemContains(const Item: TILItem; const Text: String): Boolean; virtual;
    procedure ReIndex; virtual;
  public
    // utility functions
    class procedure ItemFinalize(var Item: TILItem; FreePics: Boolean = False); virtual;
    class procedure ItemCopy(const Src: TILItem; out Dest: TILItem; CopyPics: Boolean = False); virtual;
    class procedure ItemShopCopy(const Src: TILItemShop; out Dest: TILItemShop); virtual;
    procedure ItemShopCopyForUpdate(const Src: TILItemShop; out Dest: TILItemShop); virtual;
    Function ItemTitleStr(const Item: TILItem): String; virtual;
    Function ItemTypeStr(const Item: TILItem): String; virtual;
    class Function ItemSize(const Item: TILItem): UInt32; virtual;
    class Function ItemSizeStr(const Item: TILItem): String; virtual;
    class Function ItemTotalWeight(const Item: TILItem): UInt32; virtual;
    class Function ItemUnitPrice(const Item: TILItem): UInt32; virtual;
    class Function ItemTotalPriceLowest(const Item: TILItem): UInt32; virtual;
    class Function ItemTotalPriceSelected(const Item: TILItem): UInt32; virtual;
    class Function ItemTotalPrice(const Item: TILItem): UInt32;
    class procedure ItemUpdatePriceAndAvail(var Item: TILItem); virtual;
    class procedure ItemFlagPriceAndAvail(var Item: TILItem; OldAvail: Int32; OldPrice: UInt32); virtual;
    class Function ItemSelectedShop(const Item: TILItem; out Shop: TILItemShop): Boolean; virtual;
    class procedure ItemUpdateShopsHistory(var Item: TILItem); virtual;
    class Function ItemShopUpdate(var Shop: TILItemShop): Boolean; virtual;
    Function SortingItemStr(const SortingItem: TILSortingItem): String; virtual;
    // constructors/destructors
    constructor Create(ListComponent: TListBox);
    destructor Destroy; override;
    // list manipulation
    Function ItemAddEmpty: Integer; virtual;
    Function ItemAddCopy(SrcIndex: Integer): Integer; virtual;    
    procedure ItemExchange(Idx1,Idx2: Integer); virtual;
    procedure ItemDelete(Index: Integer); virtual;
    procedure ItemClear; virtual;
    procedure ItemRedraw(var Item: TILItem); overload; virtual;
    procedure ItemRedraw; overload; virtual;
    Function ItemFilter(var Item: TILItem): Boolean; overload; virtual;
    procedure ItemFilter; overload; virtual;
    // item shop list manipulation
    class procedure ItemShopFinalize(var ItemShop: TILItemShop); virtual;
    class Function ItemShopAdd(var Item: TILItem): Integer; virtual;
    class procedure ItemShopExchange(var Item: TILItem; Idx1,Idx2: Integer); virtual;
    class procedure ItemShopDelete(var Item: TILItem; Index: Integer); virtual;
    class procedure ItemShopClear(var Item: TILItem); virtual;
    // searching
    Function FindPrev(const Text: String; FromIndex: Integer = -1): Integer; virtual;
    Function FindNext(const Text: String; FromIndex: Integer = -1): Integer; virtual;
    // sorting
    Function SortingProfileAdd(const Name: String): Integer; virtual;
    procedure SortingProfileRename(Index: Integer; const NewName: String); virtual;
    procedure SortingProfileExchange(Idx1,Idx2: Integer); virtual;
    procedure SortingProfileDelete(Index: Integer); virtual;
    procedure ItemSort(SortingProfile: Integer); overload; virtual;
    procedure ItemSort; overload; virtual;
    // shop templates
    Function ShopTemplateIndexOf(const Name: String): Integer; virtual;
    Function ShopTemplateAdd(const Name: String; ShopData: TILItemShop): Integer; virtual;
    procedure ShopTemplateRename(Index: Integer; const NewName: String); virtual;
    procedure ShopTemplateExchange(Idx1,Idx2: Integer); virtual;
    procedure ShopTemplateDelete(Index: Integer); virtual;
    procedure ShopTemplateClear; virtual;
    procedure ShopTemplateExport(const FileName: String; ShopTemplateIndex: Integer); virtual;
    Function ShopTemplateImport(const FileName: String): Integer; virtual;
    // IO
    procedure SaveToStream(Stream: TStream); virtual;
    procedure SaveToFile(const FileName: String); virtual;
    procedure SaveToFileBuffered(const FileName: String); virtual;
    procedure LoadFromStream(Stream: TStream); virtual;
    procedure LoadFromFile(const FileName: String); virtual;
    procedure LoadFromFileBuffered(const FileName: String); virtual;
    // properties
    property DataProvider: TILDataProvider read fDataProvider;
    property FileName: String read fFileName;
    property ItemCount: Integer read GetItemCount;
    property Items[Index: Integer]: TILItem read GetItem; default;
    property ItemPtrs[Index: Integer]: PILItem read GetItemPtr;
    property ReversedSort: Boolean read fReversedSort write fReversedSort;
    property DefaultSortingSettings: TILSortingSettings read fDefaultSortSett write fDefaultSortSett;
    property ActualSortingSettings: TILSortingSettings read fActualSortSett write fActualSortSett;
    property SortingProfileCount: Integer read GetSortProfileCount;
    property SortingProfiles[Index: Integer]: TILSortingProfile read GetSortProfile;
    property SortingProfilePtrs[Index: Integer]: PILSortingProfile read GetSortProfilePtr;
    property FilterSettings: TILFilterSettings read fFilterSettings write fFilterSettings;
    property ShopTemplateCount: Integer read GetShopTemplateCount;
    property ShopTemplates[Index: Integer]: TILShopTemplate read GetShopTemplate;
    property ShopTemplatePtrs[Index: Integer]: PILShopTemplate read GetShopTemplatePtr;
  end;

implementation

uses
  SysUtils, IniFiles, TypInfo, StrUtils,
  BitOps, ListSorters, BinaryStreaming,
  InflatablesList_Utils, InflatablesList_ShopUpdate,
  InflatablesList_HTML_ElementFinder;

Function TILManager_Base.GetItemCount: Integer;
begin
Result := Length(fList);
end;

//------------------------------------------------------------------------------

Function TILManager_Base.GetItem(Index: Integer): TILItem;
begin
If (Index >= Low(fList)) and (Index <= High(fList)) then
  Result := fList[Index]
else
  raise Exception.CreateFmt('TILManager_Base.GetItem: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

Function TILManager_Base.GetItemPtr(Index: Integer): PILItem;
begin
If (Index >= Low(fList)) and (Index <= High(fList)) then
  Result := Addr(fList[Index])
else
  raise Exception.CreateFmt('TILManager_Base.GetItemPtr: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

Function TILManager_Base.GetSortProfileCount: Integer;
begin
Result := Length(fSortingProfiles);
end;

//------------------------------------------------------------------------------

Function TILManager_Base.GetSortProfile(Index: Integer): TILSortingProfile;
begin
If (Index >= Low(fSortingProfiles)) and (Index <= High(fSortingProfiles)) then
  Result := fSortingProfiles[Index]
else
  raise Exception.CreateFmt('TILManager_Base.GetSortProfile: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

Function TILManager_Base.GetSortProfilePtr(Index: Integer): PILSortingProfile;
begin
If (Index >= Low(fSortingProfiles)) and (Index <= High(fSortingProfiles)) then
  Result := Addr(fSortingProfiles[Index])
else
  raise Exception.CreateFmt('TILManager_Base.GetSortProfilePtr: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

Function TILManager_Base.GetShopTemplateCount: Integer;
begin
Result := Length(fShopTemplates);
end;

//------------------------------------------------------------------------------

Function TILManager_Base.GetShopTemplate(Index: Integer): TILShopTemplate;
begin
If (Index >= Low(fShopTemplates)) and (Index <= High(fShopTemplates)) then
  Result := fShopTemplates[Index]
else
  raise Exception.CreateFmt('TILManager_Base.GetShopTemplate: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

Function TILManager_Base.GetShopTemplatePtr(Index: Integer): PILShopTemplate;
begin
If (Index >= Low(fShopTemplates)) and (Index <= High(fShopTemplates)) then
  Result := Addr(fShopTemplates[Index])
else
  raise Exception.CreateFmt('TILManager_Base.GetShopTemplatePtr: Index (%d) out of bounds.',[Index]);
end;

//==============================================================================

procedure TILManager_Base.InitializeSortingSettings;
begin
fSorting := False;
FillChar(fDefaultSortSett,SizeOf(fDefaultSortSett),0);
fDefaultSortSett.Count := 2;
fDefaultSortSett.Items[0].ItemValueTag := ilivtManufacturer;
fDefaultSortSett.Items[0].Reversed := False;
fDefaultSortSett.Items[1].ItemValueTag := ilivtID;
fDefaultSortSett.Items[1].Reversed := False;
fActualSortSett := fDefaultSortSett;
fUsedSortSett := fDefaultSortSett;
SetLength(fSortingProfiles,0);
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.FinalizeSortingSettings;
begin
SetLength(fSortingProfiles,0);
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.Initialize;
begin
fDataProvider := TILDataProvider.Create;
InitializeSortingSettings;
SetLength(fShopTemplates,0);
SetLength(fList,0);
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.Finalize;
begin
ItemClear;
ShopTemplateClear;
FinalizeSortingSettings;
FreeAndNil(fDataProvider);
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.SaveData(Stream: TStream; Struct: UInt32);
begin
InitSaveFunctions(Struct);
fFNSaveToStream(Stream);
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.LoadData(Stream: TStream; Struct: UInt32);
begin
InitLoadFunctions(Struct);
fFNLoadFromStream(Stream);
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.ExportShopTemplate(Stream: TStream; const ShopTemplate: TILShopTemplate; Struct: UInt32);
begin
InitSaveFunctions(Struct);
fFNExportShopTemplate(Stream,ShopTemplate);
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.ImportShopTemplate(Stream: TStream; out ShopTemplate: TILShopTemplate; Struct: UInt32);
begin
InitLoadFunctions(Struct);
fFNImportShopTemplate(Stream,ShopTemplate);
end;

//------------------------------------------------------------------------------

Function TILManager_Base.ItemCompare(Idx1,Idx2: Integer): Integer;
var
  i:  Integer;

  Function CompareValues(ItemValueTag: TILItemValueTag; Reversed: Boolean): Integer;
  var
    SelShop1: TILItemShop;
    SelShop2: TILItemShop;
  begin
    case ItemValueTag of
      // internals
      ilivtTimeOfAdd:         Result := IL_CompareDateTime(fList[Idx1].TimeOfAddition,fList[Idx2].TimeOfAddition);
      // basic specs
      ilivtMainPicture:       Result := IL_CompareBool(Assigned(fList[Idx1].MainPicture),Assigned(fList[Idx2].MainPicture));
      ilivtPackagePicture:    Result := IL_CompareBool(Assigned(fList[Idx1].PackagePicture),Assigned(fList[Idx2].PackagePicture));
      ilivtItemType:          Result := IL_CompareInt32(Int32(fList[Idx1].ItemType),Int32(fList[Idx2].ItemType));
      ilivtItemTypeSpec:      Result := IL_CompareText(fList[Idx1].ItemTypeSpec,fList[Idx2].ItemTypeSpec);
      ilivtCount:             Result := IL_CompareUInt32(fList[Idx1].Count,fList[Idx2].Count);
      ilivtManufacturer:      Result := IL_CompareText(
                                fDataProvider.ItemManufacturers[fList[Idx1].Manufacturer].Str,
                                fDataProvider.ItemManufacturers[fList[Idx2].Manufacturer].Str,);
      ilivtManufacturerStr:   Result := IL_CompareText(fList[Idx1].ManufacturerStr,fList[Idx2].ManufacturerStr);
      ilivtID:                Result := IL_CompareInt32(fList[Idx1].ID,fList[Idx2].ID);
      // flags
      ilivtFlagOwned:         Result := IL_CompareBool(ilifOwned in fList[Idx1].Flags,ilifOwned in fList[Idx2].Flags);
      ilivtFlagWanted:        Result := IL_CompareBool(ilifWanted in fList[Idx1].Flags,ilifWanted in fList[Idx2].Flags);
      ilivtFlagOrdered:       Result := IL_CompareBool(ilifOrdered in fList[Idx1].Flags,ilifOrdered in fList[Idx2].Flags);
      ilivtFlagBoxed:         Result := IL_CompareBool(ilifBoxed in fList[Idx1].Flags,ilifBoxed in fList[Idx2].Flags);
      ilivtFlagElsewhere:     Result := IL_CompareBool(ilifElsewhere in fList[Idx1].Flags,ilifElsewhere in fList[Idx2].Flags);
      ilivtFlagUntested:      Result := IL_CompareBool(ilifUntested in fList[Idx1].Flags,ilifUntested in fList[Idx2].Flags);
      ilivtFlagTesting:       Result := IL_CompareBool(ilifTesting in fList[Idx1].Flags,ilifTesting in fList[Idx2].Flags);
      ilivtFlagTested:        Result := IL_CompareBool(ilifTested in fList[Idx1].Flags,ilifTested in fList[Idx2].Flags);
      ilivtFlagDamaged:       Result := IL_CompareBool(ilifDamaged in fList[Idx1].Flags,ilifDamaged in fList[Idx2].Flags);
      ilivtFlagRepaired:      Result := IL_CompareBool(ilifRepaired in fList[Idx1].Flags,ilifRepaired in fList[Idx2].Flags);
      ilivtFlagPriceChange:   Result := IL_CompareBool(ilifPriceChange in fList[Idx1].Flags,ilifPriceChange in fList[Idx2].Flags);
      ilivtFlagAvailChange:   Result := IL_CompareBool(ilifAvailChange in fList[Idx1].Flags,ilifAvailChange in fList[Idx2].Flags);
      ilivtFlagNotAvailable:  Result := IL_CompareBool(ilifNotAvailable in fList[Idx1].Flags,ilifNotAvailable in fList[Idx2].Flags);
      ilivtTextTag:           Result := IL_CompareText(fList[Idx1].TextTag,fList[Idx2].TextTag);
      // extended specs
      ilivtWantedLevel:       If (ilifWanted in fList[Idx1].Flags) and (ilifWanted in fList[Idx2].Flags) then
                               Result := IL_CompareUInt32(fList[Idx1].WantedLevel,fList[Idx2].WantedLevel)
                              else If ilifWanted in fList[Idx1].Flags then
                                Result := IL_NegateValue(+1,Reversed)
                              else If ilifWanted in fList[Idx2].Flags then
                                Result := IL_NegateValue(-1,Reversed) // those without the flag set goes at the end
                              else
                                Result := 0;
      ilivtVariant:           Result := IL_CompareText(fList[Idx1].Variant,fList[Idx2].Variant);
      ilivtSizeX:             Result := IL_CompareUInt32(fList[Idx1].SizeX,fList[Idx2].SizeX);
      ilivtSizeY:             Result := IL_CompareUInt32(fList[Idx1].SizeY,fList[Idx2].SizeY);
      ilivtSizeZ:             Result := IL_CompareUInt32(fList[Idx1].SizeZ,fList[Idx2].SizeZ);
      ilivtSize:              Result := IL_CompareUInt32(ItemSize(fList[Idx1]),ItemSize(fList[Idx2]));
      ilivtUnitWeight:        Result := IL_CompareUInt32(fList[Idx1].UnitWeight,fList[Idx2].UnitWeight);
      ilivtTotalWeight:       Result := IL_CompareUInt32(ItemTotalWeight(fList[Idx1]),ItemTotalWeight(fList[Idx2]));
      // others
      ilivtNotes:             Result := IL_CompareText(fList[Idx1].Notes,fList[Idx2].Notes);
      ilivtReviewURL:         Result := IL_CompareText(fList[Idx1].ReviewURL,fList[Idx2].ReviewURL);
      ilivtReview:            Result := IL_CompareBool(Length(fList[Idx1].ReviewURL) > 0,Length(fList[Idx2].ReviewURL) > 0);
      ilivtMainPictureFile:   Result := IL_CompareText(fList[Idx1].MainPictureFile,fList[Idx2].MainPictureFile);
      ilivtMainPicFilePres:   Result := IL_CompareBool(Length(fList[Idx1].MainPictureFile) > 0,Length(fList[Idx2].MainPictureFile) > 0);
      ilivtPackPictureFile:   Result := IL_CompareText(fList[Idx1].PackagePictureFile,fList[Idx2].PackagePictureFile);
      ilivtPackPicFilePres:   Result := IL_CompareBool(Length(fList[Idx1].PackagePictureFile) > 0,Length(fList[Idx2].PackagePictureFile) > 0);
      ilivtUnitPriceDefault:  Result := IL_CompareUInt32(fList[Idx1].UnitPriceDefault,fList[Idx2].UnitPriceDefault);
      ilivtUnitPriceLowest:   Result := IL_CompareUInt32(fList[Idx1].UnitPriceLowest,fList[Idx2].UnitPriceLowest);
      ilivtTotalPriceLowest:  Result := IL_CompareUInt32(ItemTotalPriceLowest(fList[Idx1]),ItemTotalPriceLowest(fList[Idx2]));
      ilivtUnitPriceSel:      Result := IL_CompareUInt32(fList[Idx1].UnitPriceSelected,fList[Idx2].UnitPriceSelected);
      ilivtTotalPriceSel:     Result := IL_CompareUInt32(ItemTotalPriceSelected(fList[Idx1]),ItemTotalPriceSelected(fList[Idx2]));
      ilivtTotalPrice:        Result := IL_CompareUInt32(ItemTotalPrice(fList[Idx1]),ItemTotalPrice(fList[Idx2]));
      ilivtAvailable:         begin
                                Result := IL_CompareInt32(Abs(fList[Idx1].AvailablePieces),Abs(fList[Idx2].AvailablePieces));
                                If Result = 0 then
                                  begin
                                    If fList[Idx1].AvailablePieces < 0 then
                                      Result := -1
                                    else If fList[Idx2].AvailablePieces < 0 then
                                      Result := +1;
                                  end;
                              end;
      ilivtShopCount:         Result := IL_CompareUInt32(Length(fList[Idx1].Shops),Length(fList[Idx2].Shops));
      ilivtSelectedShop:      If ItemSelectedShop(fList[Idx1],SelShop1) and ItemSelectedShop(fList[Idx2],SelShop2) then
                                Result := IL_CompareText(SelShop1.Name,SelShop2.Name)
                              else If ItemSelectedShop(fList[Idx1],SelShop1) then
                                Result := IL_NegateValue(+1,Reversed)
                              else If ItemSelectedShop(fList[Idx2],SelShop2) then
                                Result := IL_NegateValue(-1,Reversed) // push items with no shop selected at the end
                              else
                                Result := 0;
    else
      {vtNone}
      Result := 0;
    end;
    If Reversed then
      Result := -Result;
  end;

begin
Result := 0;
If Idx1 <> Idx2 then
  begin
    For i := Low(fUsedSortSett.Items) to Pred(fUsedSortSett.Count) do
      Result := (Result shl 1) +
        CompareValues(fUsedSortSett.Items[i].ItemValueTag,fUsedSortSett.Items[i].Reversed);
    // stabilize sorting using indices
    If Result = 0 then
      Result := (Result shl 1) + IL_CompareInt32(fList[Idx1].Index,fList[Idx2].Index);
  end;
end;

//------------------------------------------------------------------------------

Function TILManager_Base.ItemContains(const Item: TILItem; const Text: String): Boolean;
begin
Result :=
  AnsiContainsText(ItemTypeStr(Item),Text) or
  AnsiContainsText(Item.ItemTypeSpec,Text) or
  AnsiContainsText(IntToStr(Item.Count),Text) or
  AnsiContainsText(fDataProvider.ItemManufacturers[Item.Manufacturer].Str,Text) or
  AnsiContainsText(Item.ManufacturerStr,Text) or
  AnsiContainsText(IntToStr(Item.ID),Text) or
  AnsiContainsText(Item.TextTag,Text) or
  AnsiContainsText(IntToStr(Item.WantedLevel),Text) or
  AnsiContainsText(Item.Variant,Text) or
  AnsiContainsText(IntToStr(Item.SizeX),Text) or
  AnsiContainsText(IntToStr(Item.SizeY),Text) or
  AnsiContainsText(IntToStr(Item.SizeZ),Text) or
  AnsiContainsText(IntToStr(Item.UnitWeight),Text) or
  AnsiContainsText(Item.Notes,Text);
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.ReIndex;
var
  i:  Integer;
begin
For i := Low(fList) to High(fList) do
  fList[i].Index := i;
end;

//==============================================================================

class procedure TILManager_Base.ItemFinalize(var Item: TILItem; FreePics: Boolean = False);
var
  i:  Integer;
begin
If FreePics then
  begin
    If Assigned(Item.MainPicture) then
      FreeAndNil(Item.MainPicture);
    If Assigned(Item.PackagePicture) then
      FreeAndNil(Item.PackagePicture);
    If Assigned(Item.ItemListRender) then
      FreeAndNil(Item.ItemListRender);
  end;
For i := Low(Item.Shops) to High(Item.Shops) do
  ItemShopFinalize(Item.Shops[i]);
end;

//------------------------------------------------------------------------------

class procedure TILManager_Base.ItemCopy(const Src: TILItem; out Dest: TILItem; CopyPics: Boolean = False);
var
  i:  Integer;
begin
Dest := Src;
If CopyPics then
  begin
    If Assigned(Src.MainPicture) then
      begin
        Dest.MainPicture := TBitmap.Create;
        Dest.MainPicture.Assign(Src.MainPicture);
      end;
    If Assigned(Src.PackagePicture) then
      begin
        Dest.PackagePicture := TBitmap.Create;
        Dest.PackagePicture.Assign(Src.PackagePicture);
      end;
    If Assigned(Src.ItemListRender) then
      begin
        Dest.ItemListRender := TBitmap.Create;
        Dest.ItemListRender.Assign(Src.ItemListRender);
      end;
  end;
UniqueString(Dest.ItemTypeSpec);
UniqueString(Dest.ManufacturerStr);
UniqueString(Dest.TextTag);
UniqueString(Dest.Variant);
UniqueString(Dest.Notes);
UniqueString(Dest.ReviewURL);
UniqueString(Dest.MainPictureFile);
UniqueString(Dest.PackagePictureFile);
SetLength(Dest.Shops,Length(Dest.Shops));
For i := Low(Dest.Shops) to High(Dest.Shops) do
  ItemShopCopy(Src.Shops[i],Dest.Shops[i]);
end;

//------------------------------------------------------------------------------

class procedure TILManager_Base.ItemShopCopy(const Src: TILItemShop; out Dest: TILItemShop);
var
  i:  Integer;
begin
Dest := Src;
UniqueString(Dest.Name);
UniqueString(Dest.ShopURL);
UniqueString(Dest.ItemURL);
SetLength(Dest.AvailHistory,Length(Dest.AvailHistory));
SetLength(Dest.PriceHistory,Length(Dest.PriceHistory));
UniqueString(Dest.Notes);
with Dest.ParsingSettings do
  begin
    For i := Low(Variables.Vars) to High(Variables.Vars) do
      UniqueString(Variables.Vars[i]);
    SetLength(Available.Extraction,Length(Available.Extraction));
    For i := Low(Available.Extraction) to High(Available.Extraction) do
      begin
        UniqueString(Available.Extraction[i].ExtractionData);
        UniqueString(Available.Extraction[i].NegativeTag);
      end;
    Available.Finder := TILElementFinder.CreateAsCopy(
      TILElementFinder(Src.ParsingSettings.Available.Finder));
    SetLength(Price.Extraction,Length(Price.Extraction));
    For i := Low(Price.Extraction) to High(Price.Extraction) do
      begin
        UniqueString(Price.Extraction[i].ExtractionData);
        UniqueString(Price.Extraction[i].NegativeTag);
      end;
    Price.Finder := TILElementFinder.CreateAsCopy(
      TILElementFinder(Src.ParsingSettings.Price.Finder));
  end;
UniqueString(Dest.LastUpdateMsg);
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.ItemShopCopyForUpdate(const Src: TILItemShop; out Dest: TILItemShop);
var
  Index:  Integer;
begin
// make normal copy
ItemShopCopy(Src,Dest);
// resolve references
Index := ShopTemplateIndexOf(Dest.ParsingSettings.TemplateRef);
If Index >= 0 then
  with fShopTemplates[Index].ShopData.ParsingSettings do
    begin
      // reference found, set extraction settings and free current objects and copy the referenced
      Dest.ParsingSettings.Available.Extraction := Available.Extraction;
      Dest.ParsingSettings.Price.Extraction := Price.Extraction;
      SetLength(Dest.ParsingSettings.Available.Extraction,Length(Dest.ParsingSettings.Available.Extraction));
      SetLength(Dest.ParsingSettings.Price.Extraction,Length(Dest.ParsingSettings.Price.Extraction));
      FreeAndNil(Dest.ParsingSettings.Available.Finder);
      FreeAndNil(Dest.ParsingSettings.Price.Finder);
      Dest.ParsingSettings.Available.Finder := TILElementFinder.CreateAsCopy(TILElementFinder(Available.Finder));
      Dest.ParsingSettings.Price.Finder := TILElementFinder.CreateAsCopy(TILElementFinder(Price.Finder));
    end;
end;

//------------------------------------------------------------------------------

Function TILManager_Base.ItemTitleStr(const Item: TILItem): String;
begin
If Item.Manufacturer = ilimOthers then
  begin
    If Length(Item.ManufacturerStr) > 0 then
      Result := Item.ManufacturerStr
    else
      Result :='<unknown_manuf>';
  end
else Result := fDataProvider.ItemManufacturers[Item.Manufacturer].Str;
If Item.ID <> 0 then
  begin
    If Length(Result) > 0 then
      Result := Format('%s %d',[Result,Item.ID])
    else
      Result := IntToStr(Item.ID);
  end;
end;

//------------------------------------------------------------------------------

Function TILManager_Base.ItemTypeStr(const Item: TILItem): String;
begin
If not(Item.ItemType in [ilitUnknown,ilitOther]) then
  begin
    If Length(Item.ItemTypeSpec) > 0 then
      Result := Format('%s (%s)',[fDataProvider.GetItemTypeString(Item.ItemType),Item.ItemTypeSpec])
    else
      Result := fDataProvider.GetItemTypeString(Item.ItemType);
  end
else
  begin
    If Length(Item.ItemTypeSpec) > 0 then
      Result := Item.ItemTypeSpec
    else
      Result := '<unknown_type>';
  end;
end;

//------------------------------------------------------------------------------

class Function TILManager_Base.ItemSize(const Item: TILItem): UInt32;
var
  szX,szY,szZ:  UInt32;
begin
If Item.SizeX = 0 then szX := 1
  else szX := Item.SizeX;
If Item.SizeY = 0 then szY := 1
  else szY := Item.SizeY;
If Item.SizeZ = 0 then szZ := 1
  else szZ := Item.SizeZ;
Result := szX * szY * szZ;
end;

//------------------------------------------------------------------------------

class Function TILManager_Base.ItemSizeStr(const Item: TILItem): String;
begin
Result := '';
If Item.SizeX > 0 then
  Result := Format('%g',[Item.SizeX / 10]);
If Item.SizeY > 0 then
  begin
    If Length(Result) > 0 then
      Result := Format('%s x %g',[Result,Item.SizeY / 10])
    else
      Result := Format('%g',[Item.SizeY / 10]);
  end;
If Item.SizeZ > 0 then
  begin
    If Length(Result) > 0 then
      Result := Format('%s x %g',[Result,Item.SizeZ / 10])
    else
      Result := Format('%g',[Item.SizeZ / 10]);
  end;
If Length(Result) > 0 then
  Result := Format('%s cm',[Result]);
end;

//------------------------------------------------------------------------------

class Function TILManager_Base.ItemTotalWeight(const Item: TILItem): UInt32;
begin
Result := Item.UnitWeight * Item.Count;
end;

//------------------------------------------------------------------------------

class Function TILManager_Base.ItemUnitPrice(const Item: TILItem): UInt32;
begin
If Item.UnitPriceSelected > 0 then
  Result := Item.UnitPriceSelected
else
  Result := Item.UnitPriceDefault;
end;

//------------------------------------------------------------------------------

class Function TILManager_Base.ItemTotalPriceLowest(const Item: TILItem): UInt32;
begin
Result := Item.UnitPriceLowest * Item.Count;
end;

//------------------------------------------------------------------------------

class Function TILManager_Base.ItemTotalPriceSelected(const Item: TILItem): UInt32;
begin
Result := Item.UnitPriceSelected * Item.Count;
end;

//------------------------------------------------------------------------------

class Function TILManager_Base.ItemTotalPrice(const Item: TILItem): UInt32;
begin
Result := ItemUnitPrice(Item) * Item.Count;
end;

//------------------------------------------------------------------------------

class procedure TILManager_Base.ItemUpdatePriceAndAvail(var Item: TILItem);
var
  i:        Integer;
  Selected: Boolean;
  LowPrice: Int64;
begin
// first make sure only one shop is selected
Selected := False;
For i := Low(Item.Shops) to High(Item.Shops) do
  If Item.Shops[i].Selected and not Selected then
    Selected := True
  else
    Item.Shops[i].Selected := False;
// get lowest price (availability must be non-zero), also get selected price
LowPrice := -1;
Item.UnitPriceSelected := 0;
Item.AvailablePieces := 0;
For i := Low(Item.Shops) to High(Item.Shops) do
  begin
    If (Item.Shops[i].Available <> 0) and (Item.Shops[i].Price > 0) then
      If (Item.Shops[i].Price < LowPrice) or (LowPrice < 0) then
        LowPrice := Item.Shops[i].Price;
    If (Item.Shops[i].Available <> 0) and Item.Shops[i].Selected then
      begin
        Item.UnitPriceSelected := Item.Shops[i].Price;
        Item.AvailablePieces := Item.Shops[i].Available;
      end;
  end;
If LowPrice < 0 then
  Item.UnitPriceLowest := 0
else
  Item.UnitPriceLowest := LowPrice;
end;

//------------------------------------------------------------------------------

class procedure TILManager_Base.ItemFlagPriceAndAvail(var Item: TILItem; OldAvail: Int32; OldPrice: UInt32);
begin
If (ilifWanted in Item.Flags) and (Length(Item.Shops) > 0) then
  begin
    Exclude(Item.Flags,ilifNotAvailable);
    If (Item.AvailablePieces <> 0) and (Item.UnitPriceSelected > 0) then
      begin
        If Item.AvailablePieces > 0 then
          begin
            If UInt32(Item.AvailablePieces) < Item.Count then
              Include(Item.Flags,ilifNotAvailable);
          end
        else
          begin
            If UInt32(Abs(Item.AvailablePieces) * 2) < Item.Count then
              Include(Item.Flags,ilifNotAvailable);
          end;
        If Item.AvailablePieces <> OldAvail then
          Include(Item.Flags,ilifAvailChange);
        If Item.UnitPriceSelected <> OldPrice then
          Include(Item.Flags,ilifPriceChange);
      end
    else
      begin
        Include(Item.Flags,ilifNotAvailable);
        If (Item.AvailablePieces <> OldAvail) then
          Include(Item.Flags,ilifAvailChange);
      end;
  end;
end;

//------------------------------------------------------------------------------

class Function TILManager_Base.ItemSelectedShop(const Item: TILItem; out Shop: TILItemShop): Boolean;
var
  i:  Integer;
begin
Result := False;
For i := Low(Item.Shops) to High(Item.Shops) do
  If Item.Shops[i].Selected then
    begin
      Shop := Item.Shops[i];
      Result := True;
    end;
end;

//------------------------------------------------------------------------------

class procedure TILManager_Base.ItemUpdateShopsHistory(var Item: TILItem);
var
  i:  Integer;

  procedure DoAddToHistory(var Shop: TILItemShop);
  begin
    SetLength(Shop.AvailHistory,Length(Shop.AvailHistory) + 1);
    Shop.AvailHistory[High(Shop.AvailHistory)].Value := Shop.Available;
    Shop.AvailHistory[High(Shop.AvailHistory)].Time := Now;
    SetLength(Shop.PriceHistory,Length(Shop.PriceHistory) + 1);
    Shop.PriceHistory[High(Shop.PriceHistory)].Value := Int32(Shop.Price);
    // make sure the time is the same...
    Shop.PriceHistory[High(Shop.PriceHistory)].Time :=
      Shop.AvailHistory[High(Shop.AvailHistory)].Time;
  end;

begin
For i := Low(Item.Shops) to High(Item.Shops) do
  begin
    If Item.Shops[i].Price > 0 then
      begin
        // price is nonzero, add only when current price or avail differs from last entry
        // or there is no prior entry
        If (Length(Item.Shops[i].PriceHistory) <= 0) then
          DoAddToHistory(Item.Shops[i])
        else If (Item.Shops[i].AvailHistory[High(Item.Shops[i].AvailHistory)].Value <> Item.Shops[i].Available) or
                (Item.Shops[i].PriceHistory[High(Item.Shops[i].PriceHistory)].Value <> Int32(Item.Shops[i].Price)) then
          DoAddToHistory(Item.Shops[i]);
      end
    else
      begin
        // price is zero, add only when there is already a price entry and
        // current price or avail differs from last entry
        If (Length(Item.Shops[i].PriceHistory) > 0) then
          If ((Item.Shops[i].AvailHistory[High(Item.Shops[i].AvailHistory)].Value <> Item.Shops[i].Available) or
              (Item.Shops[i].PriceHistory[High(Item.Shops[i].PriceHistory)].Value <> Int32(Item.Shops[i].Price))) then
          DoAddToHistory(Item.Shops[i]);
      end
  end;
end;

//------------------------------------------------------------------------------

class Function TILManager_Base.ItemShopUpdate(var Shop: TILItemShop): Boolean;
var
  Updater:        TILShopUpdater;
  UpdaterResult:  TILShopUpdaterResult;
  TryCounter:     Integer;

  procedure SetValues(const Msg: String; Avail: Int32; Price: UInt32);
  begin
    Shop.Available := Avail;
    Shop.Price := Price;
    Shop.LastUpdateMsg := Msg;
  end;

begin
TryCounter := IL_LISTFILE_UPDATE_TRYCOUNT;
Result := False;
Updater := TILShopUpdater.Create(Shop);
try
  repeat
    UpdaterResult := Updater.Run;
    case UpdaterResult of
      ilurSuccess:          begin
                              SetValues(Format(
                                'Success (%d bytes downloaded) - Avail: %d  Price: %d',
                                [Updater.DownloadSize,Updater.Available,Updater.Price]),
                                Updater.Available,Updater.Price);
                              Result := True;
                            end;
      ilurNoLink:           SetValues('No item link',0,0);
      ilurNoData:           SetValues('Insufficient search data',0,0);
      // when download fails, keep old price (assumes the item vent unavailable)
      ilurFailDown:         SetValues(Format('Download failed (code: %d)',[Updater.DownloadResultCode]),0,Shop.Price);
      // when parsing fails, keep old values (assumes bad download or internal exception)
      ilurFailParse:        SetValues(Format('Parsing failed (%s)',[Updater.ErrorString]),Shop.Available,Shop.Price);
      // following assumes the item is unavailable
      ilurFailAvailSearch:  SetValues('Search of available count failed',0,Updater.Price);
      // following assumes the item is unavailable, keep old price
      ilurFailSearch:       SetValues('Search failed',0,Shop.Price);
      // following assumes the item is unavailable
      ilurFailAvailValGet:  SetValues('Unable to obtain available count',0,Updater.Price);
      // following assumes the item is unavailable, keep old price
      ilurFailValGet:       SetValues('Unable to obtain values',0,Shop.Price);
      // general fail, invalidate
      ilurFail:             SetValues('Failed (general error)',0,0);
    else
      SetValues('Failed (unknown state)',0,0);
    end;
    Dec(TryCounter);
  until (TryCounter <= 0) or not(UpdaterResult in [ilurFailDown,ilurFailParse]);
finally
  Updater.Free;
end;
end;

//------------------------------------------------------------------------------

Function TILManager_Base.SortingItemStr(const SortingItem: TILSortingItem): String;
begin
If SortingItem.Reversed then
  Result := Format('- %s',[fDataProvider.GetItemValueTagString(SortingItem.ItemValueTag)])
else
  Result := Format('+ %s',[fDataProvider.GetItemValueTagString(SortingItem.ItemValueTag)])
end;

//------------------------------------------------------------------------------

constructor TILManager_Base.Create(ListComponent: TListBox);
begin
inherited Create;
fFileName := '';
fRenderWidth := ListComponent.ClientWidth  - (2 * GetSystemMetrics(SM_CXEDGE)) - GetSystemMetrics(SM_CXVSCROLL);
fRenderHeight := ListComponent.ItemHeight;
fFontSettings := ListComponent.Font;
Initialize;
end;

//------------------------------------------------------------------------------

destructor TILManager_Base.Destroy;
begin
Finalize;
inherited;
end;

//------------------------------------------------------------------------------

Function TILManager_Base.ItemAddEmpty: Integer;
begin
SetLength(fList,Length(fList) + 1);
Result := High(fList);
// internals
fList[Result].Index := Result;
fList[Result].TimeOfAddition := Now;
// basic specs
fList[Result].MainPicture := nil;
fList[Result].PackagePicture := nil;
fList[Result].ItemType := ilitUnknown;
fList[Result].ItemTypeSpec := '';
fList[Result].Count := 1;
fList[Result].Manufacturer := ilimOthers;
fList[Result].ManufacturerStr := '';
fList[Result].ID := 0;
// flags
fList[Result].Flags := [];
fList[Result].TextTag := '';
// ext. specs
fList[Result].WantedLevel := 0;
fList[Result].Variant := '';
fList[Result].SizeX := 0;
fList[Result].SizeY := 0;
fList[Result].SizeZ := 0;
fList[Result].UnitWeight := 0;
// other info
fList[Result].Notes := '';
fList[Result].ReviewURL := '';
fList[Result].MainPictureFile := '';
fList[Result].PackagePictureFile := '';
fList[Result].UnitPriceDefault := 0;
fList[Result].UnitPriceLowest := 0;
fList[Result].UnitPriceSelected := 0;
fList[Result].AvailablePieces := 0;
// shops
SetLength(fList[Result].Shops,0);
// internals
fList[Result].ItemListRender := TBitmap.Create;
fList[Result].ItemListRender.PixelFormat := pf24bit;
fList[Result].ItemListRender.Width := fRenderWidth;
fList[Result].ItemListRender.Height := fRenderHeight;
fList[Result].FilteredOut := False;
end;

//------------------------------------------------------------------------------

Function TILManager_Base.ItemAddCopy(SrcIndex: Integer): Integer;
begin
If (SrcIndex >= Low(fList)) and (SrcIndex <= High(fList)) then
  begin
    Result := ItemAddEmpty;
    // free the internals as they will be recreated
    FreeAndNil(fList[Result].ItemListRender);
    If Result >= 0 then
      ItemCopy(fList[SrcIndex],fList[Result],True);
    fList[Result].Index := Result;
    fList[Result].TimeOfAddition := Now;      
  end
else raise Exception.CreateFmt('TILManager_Base.ItemAddCopy: Source index (%d) out of bounds.',[SrcIndex]);
end;


//------------------------------------------------------------------------------

procedure TILManager_Base.ItemExchange(Idx1,Idx2: Integer);
var
  Temp: TILItem;
begin
If Idx1 <> Idx2 then
  begin
    // sanity checks
    If (Idx1 < Low(fList)) or (Idx1 > High(fList)) then
      raise Exception.CreateFmt('TILManager_Base.ItemExchange: Index 1 (%d) out of bounds.',[Idx1]);
    If (Idx2 < Low(fList)) or (Idx2 > High(fList)) then
      raise Exception.CreateFmt('TILManager_Base.ItemExchange: Index 2 (%d) out of bounds.',[Idx1]);
    Temp := fList[Idx1];
    fList[Idx1] := fList[Idx2];
    fList[Idx2] := Temp;
    If not fSorting then
      begin
        // full reindex not needed
        fList[Idx1].Index := Idx1;
        fList[Idx2].Index := Idx2;
      end;
  end;
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.ItemDelete(Index: Integer);
var
  i:  Integer;
begin
If (Index >= Low(fList)) and (Index <= High(fList)) then
  begin
    FreeAndNil(fList[Index].MainPicture);
    FreeAndNil(fList[Index].PackagePicture);
    ItemShopClear(fList[Index]);
    FreeAndNil(fList[Index].ItemListRender);
    For i := Index to Pred(High(fList)) do
      fList[i] := fList[i + 1];
    SetLength(fList,Length(fList) - 1);
    ReIndex;
  end
else raise Exception.CreateFmt('TILManager_Base.ItemDelete: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.ItemClear;
var
  i:  Integer;
begin
For i := Low(fList) to High(fList) do
  begin
    FreeAndNil(fList[i].MainPicture);
    FreeAndNil(fList[i].PackagePicture);
    ItemShopClear(fList[i]);
    FreeAndNil(fList[i].ItemListRender);
  end;
SetLength(fList,0);
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.ItemRedraw(var Item: TILItem);
const
  WL_STRIP_WIDTH  = 20;
var
  TempStr:  String;
  TempInt:  Integer;
  ItemFlag: TILItemFlag;

  procedure DrawWantedLevelStrip(Canvas: TCanvas);
  const
    WL_STRIP_COLORS: array[0..7] of TColor =
    //(clWhite,$00D917F6,$00DE37F7,$00E355F9,$00E874FA,$00EE95FB,$00F3B4FD,$00F8D4FE);
    //(clWhite,$00F67A15,$00F78C34,$00F99D52,$00FAAF71,$00FBBF8E,$00FDD1AD,$00FEE3CC);
      (clWhite,$00FEE3CC,$00FDD1AD,$00FBBF8E,$00FAAF71,$00F99D52,$00F78C34,$00F67A15);
  var
    ii: UInt32;
  begin
    with Canvas do
      For ii := 7 downto 0 do
        begin
          Brush.Color := WL_STRIP_COLORS[ii];
          If Item.WantedLevel >= ii then
            Rectangle(0,fRenderHeight - Trunc(fRenderHeight * (ii / 7)),
                      WL_STRIP_WIDTH,fRenderHeight);
        end;
  end;

begin
with Item.ItemListRender,Item.ItemListRender.Canvas do
  begin
    Font := fFontSettings;

    // background
    Pen.Style := psClear;
    Brush.Style := bsSolid;
    Brush.Color := clWhite;
    Rectangle(0,0,Width,Height);

    // wanted level strip
    Pen.Style := psClear;
    Brush.Style := bsSolid;
    Brush.Color := $00F7F7F7;
    Rectangle(0,0,WL_STRIP_WIDTH,fRenderHeight);
    If ilifWanted in Item.Flags then
      begin
        If Assigned(fDataProvider.GradientImage) then
          begin
            TempInt := fRenderHeight - Trunc((fRenderHeight / 7) * Item.WantedLevel);
            If Item.WantedLevel > 0 then
              CopyRect(Rect(0,TempInt,Pred(WL_STRIP_WIDTH),fRenderHeight),
                fDataProvider.GradientImage.Canvas,
                Rect(0,TempInt,Pred(WL_STRIP_WIDTH),fRenderHeight));
          end
        else DrawWantedLevelStrip(Item.ItemListRender.Canvas);
      end;

    // title + count
    Brush.Style := bsClear;
    Font.Size := 12;
    Font.Style := Font.Style + [fsBold];
    If Item.Count > 1 then
      TextOut(WL_STRIP_WIDTH + 5,5,Format('%s (%dx)',[ItemTitleStr(Item),Item.Count]))
    else
      TextOut(WL_STRIP_WIDTH + 5,5,ItemTitleStr(Item));

    // type + size
    Font.Size := 10;
    Font.Style := Font.Style - [fsBold];
    TempStr := ItemSizeStr(Item);
    If Length(TempStr) > 0 then
      TextOut(WL_STRIP_WIDTH + 5,30,Format('%s - %s',[ItemTypeStr(Item),TempStr]))
    else
      TextOut(WL_STRIP_WIDTH + 5,30,ItemTypeStr(Item));

    // variant/color
    TextOut(WL_STRIP_WIDTH + 5,50,Item.Variant);

    // flag icons
    TempInt := WL_STRIP_WIDTH + 5;
    For ItemFlag := Low(TILItemFlag) to High(TILItemFlag) do
      If ItemFlag in Item.Flags then
        begin
          Draw(TempInt,fRenderHeight - (fDataProvider.ItemFlagIcons[ItemFlag].Height + 10),
               fDataProvider.ItemFlagIcons[ItemFlag]);
          Inc(TempInt,fDataProvider.ItemFlagIcons[ItemFlag].Width + 5);
        end;

    // review icon
    If Length(Item.ReviewURL) > 0 then
      begin
        Draw(TempInt,fRenderHeight - (fDataProvider.ItemReviewIcon.Height + 10),fDataProvider.ItemReviewIcon);
        Inc(TempInt,fDataProvider.ItemReviewIcon.Width + 5);
      end;

    // text tag
    If Length(Item.TextTag) > 0 then
      begin
        Font.Size := 8;
        Font.Style := Font.Style + [fsBold];
        TextOut(TempInt,fRenderHeight - 25,Item.TextTag);
      end;

    // prices
    Font.Size := 12;
    Font.Style := Font.Style + [fsBold];
    If ItemTotalPrice(Item) > 0 then
      begin
        If Item.Count > 1 then
          TempStr := Format('%d (%d) Kè',[ItemTotalPrice(Item),ItemUnitPrice(Item)])
        else
          TempStr := Format('%d Kè',[ItemTotalPrice(Item)]);
        TextOut(fRenderWidth - (TextWidth(TempStr) + 118),5,TempStr);
      end;

    Font.Size := 10;
    Font.Style := Font.Style - [fsBold];
    If (Item.UnitPriceSelected <> Item.UnitPriceLowest) and (Item.UnitPriceSelected > 0) and (Item.UnitPriceLowest > 0) then
      begin
        If Item.Count > 1 then
          TempStr := Format('%d (%d) Kè',[ItemTotalPriceLowest(Item),Item.UnitPriceLowest])
        else
          TempStr := Format('%d Kè',[ItemTotalPriceLowest(Item)]);
        TextOut(fRenderWidth - (TextWidth(TempStr) + 118),25,TempStr);
      end;

    // main picture
    If Assigned(Item.MainPicture) then
      Draw(fRenderWidth - 98,2,Item.MainPicture)
    else
      Draw(fRenderWidth - 98,2,fDataProvider.ItemDefaultPictures[Item.ItemType]);
  end;
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.ItemRedraw;
var
  i:  Integer;
begin
For i := Low(fList) to High(fList) do
  ItemRedraw(fList[i]);
end;

//------------------------------------------------------------------------------

Function TILManager_Base.ItemFilter(var Item: TILItem): Boolean;
var
  FlagsMap:   UInt32;
  FlagsMask:  UInt32;
  i:          Integer;
  StateSet:   Boolean;
  State:      Boolean;  // true = filtered-in, false = filtered-out

  procedure CheckItemFlag(BitMask: UInt32; ItemFlag: TILItemFlag; FlagSet, FlagClr: TILFilterFlag);
  begin
    If FlagSet in fFilterSettings.Flags then
      begin
        SetFlagStateValue(FlagsMap,BitMask,ItemFlag in Item.Flags);
        SetFlagValue(FlagsMask,BitMask);
      end
    else If FlagClr in fFilterSettings.Flags then
      begin
        SetFlagStateValue(FlagsMap,BitMask,not(ItemFlag in Item.Flags));
        SetFlagValue(FlagsMask,BitMask);
      end
    else
      begin
        ResetFlagValue(FlagsMap,BitMask);
        ResetFlagValue(FlagsMask,BitMask);
      end;
  end;

begin
FlagsMap := 0;
FlagsMask := 0;
If fFilterSettings.Flags <> [] then
  begin
    CheckItemFlag($00000001,ilifOwned,ilffOwnedSet,ilffOwnedClr);
    CheckItemFlag($00000002,ilifWanted,ilffWantedSet,ilffWantedClr);
    CheckItemFlag($00000004,ilifOrdered,ilffOrderedSet,ilffOrderedClr);
    CheckItemFlag($00000008,ilifBoxed,ilffBoxedSet,ilffBoxedClr);
    CheckItemFlag($00000010,ilifElsewhere,ilffElsewhereSet,ilffElsewhereClr);
    CheckItemFlag($00000020,ilifUntested,ilffUntestedSet,ilffUntestedClr);
    CheckItemFlag($00000040,ilifTesting,ilffTestingSet,ilffTestingClr);
    CheckItemFlag($00000080,ilifTested,ilffTestedSet,ilffTestedClr);
    CheckItemFlag($00000100,ilifDamaged,ilffDamagedSet,ilffDamagedClr);
    CheckItemFlag($00000200,ilifRepaired,ilffRepairedSet,ilffRepairedClr);
    CheckItemFlag($00000400,ilifPriceChange,ilffPriceChangeSet,ilffPriceChangeClr);
    CheckItemFlag($00000800,ilifAvailChange,ilffAvailChangeSet,ilffAvailChangeClr);
    CheckItemFlag($00001000,ilifNotAvailable,ilffNotAvailableSet,ilffNotAvailableClr);
  end;
StateSet := False;
State := False; // will be later set to true value
If FlagsMask <> 0 then
  begin
    For i := 0 to Ord(High(TILItemFlag)) do
      begin
        If FlagsMask and 1 <> 0 then
          begin
            If StateSet then
              begin
                case fFilterSettings.Operator of
                  ilfoOR:   State := State or (FlagsMap and 1 <> 0);
                  ilfoXOR:  State := State xor (FlagsMap and 1 <> 0);
                else
                 {ilfoAND}
                  State := State and (FlagsMap and 1 <> 0);
                end;
              end
            else
              begin
                State := FlagsMap and 1 <> 0;
                StateSet := True;
              end;
          end;
        FlagsMap := FlagsMap shr 1;
        FlagsMask := FlagsMask shr 1;
      end;
  end
else State := True;
Item.FilteredOut := not State;
Result := Item.FilteredOut;
end;

//------------------------------------------------------------------------------

class procedure TILManager_Base.ItemShopFinalize(var ItemShop: TILITemShop);
begin
FreeAndNil(ItemShop.ParsingSettings.Available.Finder);
FreeAndNil(ItemShop.ParsingSettings.Price.Finder);
end;

//------------------------------------------------------------------------------

class Function TILManager_Base.ItemShopAdd(var Item: TILItem): Integer;
begin
SetLength(Item.Shops,Length(Item.Shops) + 1);
Result := High(Item.Shops);
FillChar(Item.Shops[Result],SizeOf(TILItemShop),0);
Item.Shops[Result].ParsingSettings.Available.Finder := TILElementFinder.Create;
Item.Shops[Result].ParsingSettings.Price.Finder := TILElementFinder.Create;
end;

//------------------------------------------------------------------------------

class procedure TILManager_Base.ItemShopExchange(var Item: TILItem; Idx1,Idx2: Integer);
var
  Temp: TILItemShop;
begin
If Idx1 <> Idx2 then
  begin
    // sanity checks
    If (Idx1 < Low(Item.Shops)) or (Idx1 > High(Item.Shops)) then
      raise Exception.CreateFmt('TILManager_Base.ItemShopExchange: Index 1 (%d) out of bounds.',[Idx1]);
    If (Idx2 < Low(Item.Shops)) or (Idx2 > High(Item.Shops)) then
      raise Exception.CreateFmt('TILManager_Base.ItemShopExchange: Index 2 (%d) out of bounds.',[Idx1]);
    Temp := Item.Shops[Idx1];
    Item.Shops[Idx1] := Item.Shops[Idx2];
    Item.Shops[Idx2] := Temp;
  end;
end;

//------------------------------------------------------------------------------

class procedure TILManager_Base.ItemShopDelete(var Item: TILItem; Index: Integer);
var
  i:  Integer;
begin
If (Index >= Low(Item.Shops)) and (Index <= High(Item.Shops)) then
  begin
    ItemShopFinalize(Item.Shops[Index]);
    For i := Index to Pred(High(Item.Shops)) do
      Item.Shops[i] := Item.Shops[i + 1];
    SetLength(Item.Shops,Length(Item.Shops) - 1);
  end
else raise Exception.CreateFmt('TILManager_Base.ItemShopDelete: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

class procedure TILManager_Base.ItemShopClear(var Item: TILItem);
var
  i:  Integer;
begin
For i := Low(Item.Shops) to High(Item.Shops) do
  ItemShopFinalize(Item.Shops[i]);
SetLength(Item.Shops,0);
end;

//------------------------------------------------------------------------------

Function TILManager_Base.FindPrev(const Text: String; FromIndex: Integer = -1): Integer;
var
  i:  Integer;
begin
Result := -1;
i := IL_IndexWrap(Pred(FromIndex),Low(fList),High(fList));
while i <> FromIndex do
  begin
    If ItemContains(fList[i],Text) then
      begin
        Result := i;
        Break{while...};
      end;
    i := IL_IndexWrap(Pred(i),Low(fList),High(fList));
  end;
end;

//------------------------------------------------------------------------------

Function TILManager_Base.FindNext(const Text: String; FromIndex: Integer = -1): Integer;
var
  i:  Integer;
begin
Result := -1;
i := IL_IndexWrap(Succ(FromIndex),Low(fList),High(fList));
while i <> FromIndex do
  begin
    If ItemContains(fList[i],Text) then
      begin
        Result := i;
        Break{while...};
      end;
    i := IL_IndexWrap(Succ(i),Low(fList),High(fList));
  end;
end;

//------------------------------------------------------------------------------

Function TILManager_Base.SortingProfileAdd(const Name: String): Integer;
begin
SetLength(fSortingProfiles,Length(fSortingProfiles) + 1);
Result := High(fSortingProfiles);
fSortingProfiles[Result].Name := Name;
FillChar(fSortingProfiles[Result].Settings,SizeOf(TILSortingSettings),0);
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.SortingProfileRename(Index: Integer; const NewName: String);
begin
If (Index >= Low(fSortingProfiles)) and (Index <= High(fSortingProfiles)) then
  fSortingProfiles[Index].Name := NewName
else
  raise Exception.CreateFmt('TILManager_Base.SortingProfileRename: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.SortingProfileExchange(Idx1,Idx2: Integer);
var
  Temp: TILSortingProfile;
begin
If Idx1 <> Idx2 then
  begin
    // sanity checks
    If (Idx1 < Low(fSortingProfiles)) or (Idx1 > High(fSortingProfiles)) then
      raise Exception.CreateFmt('TILManager_Base.SortingProfileExchange: First index (%d) out of bounds.',[Idx1]);
    If (Idx2 < Low(fSortingProfiles)) or (Idx2 > High(fSortingProfiles)) then
      raise Exception.CreateFmt('TILManager_Base.SortingProfileExchange: Second index (%d) out of bounds.',[Idx2]);
    Temp := fSortingProfiles[Idx1];
    fSortingProfiles[Idx1] := fSortingProfiles[Idx2];
    fSortingProfiles[Idx2] := Temp;
  end;
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.SortingProfileDelete(Index: Integer);
var
  i:  Integer;
begin
If (Index >= Low(fSortingProfiles)) and (Index <= High(fSortingProfiles)) then
  begin
    For i := Index to Pred(High(fSortingProfiles)) do
      fSortingProfiles[Index] := fSortingProfiles[Index + 1];
    SetLength(fSortingProfiles,Length(fSortingProfiles) - 1);
  end
else raise Exception.CreateFmt('TILManager_Base.SortingProfileDelete: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.ItemFilter;
var
  i:  Integer;
begin
For i := Low(fList) to High(fList) do
  ItemFilter(fList[i]);
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.ItemSort(SortingProfile: Integer);
var
  i:      Integer;
  Sorter: TListSorter;
begin
ReIndex;  // to be sure
case SortingProfile of
  -2: fUsedSortSett := fDefaultSortSett;
  -1: fUsedSortSett := fActualSortSett;
else
  If (SortingProfile >= Low(fSortingProfiles)) and (SortingProfile <= High(fSortingProfiles)) then
    fUsedSortSett := fSortingProfiles[SortingProfile].Settings
  else
    raise Exception.CreateFmt('TILManager_Base.ItemSort: Invalid sorting profile index (%d).',[SortingProfile]);
end;
If fReversedSort then
  For i := Low(fUsedSortSett.Items) to Pred(fUsedSortSett.Count) do
    fUsedSortSett.Items[i].Reversed := not fUsedSortSett.Items[i].Reversed;
If Length(fList) > 1 then
  begin
    Sorter := TListQuickSorter.Create(ItemCompare,ItemExchange);
    try
      fSorting := True;
      try
        Sorter.Sort(Low(fList),High(fList));
      finally
        fSorting := False;
      end;
    finally
      Sorter.Free;
    end;
    ReIndex;
  end;
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

procedure TILManager_Base.ItemSort;
begin
ItemSort(-1);
end;

//------------------------------------------------------------------------------

Function TILManager_Base.ShopTemplateIndexOf(const Name: String): Integer;
var
  i:  Integer;
begin
Result := -1;
For i := Low(fShopTemplates) to High(fShopTemplates) do
  If AnsiSameText(fShopTemplates[i].Name,Name) then
    begin
      Result := i;
      Break{For i};
    end;
end;

//------------------------------------------------------------------------------

Function TILManager_Base.ShopTemplateAdd(const Name: String; ShopData: TILItemShop): Integer;
begin
SetLength(fShopTemplates,Length(fShopTemplates) + 1);
Result := High(fShopTemplates);
fShopTemplates[Result].Name := Name;
ItemShopCopy(ShopData,fShopTemplates[Result].ShopData);
fShopTemplates[Result].ShopData.Selected := False;
fShopTemplates[Result].ShopData.ItemURL := '';
fShopTemplates[Result].ShopData.Available := 0;
fShopTemplates[Result].ShopData.Price := 0;
SetLength(fShopTemplates[Result].ShopData.AvailHistory,0);
SetLength(fShopTemplates[Result].ShopData.PriceHistory,0);
fShopTemplates[Result].ShopData.ParsingSettings.TemplateRef := '';
fShopTemplates[Result].ShopData.LastUpdateMsg := '';
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.ShopTemplateRename(Index: Integer; const NewName: String);
begin
If (Index >= Low(fShopTemplates)) and (Index <= High(fShopTemplates)) then
  fShopTemplates[Index].Name := NewName
else
  raise Exception.CreateFmt('TILManager_Base.ShopTemplateRename: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.ShopTemplateExchange(Idx1,Idx2: Integer);
var
  Temp: TILShopTemplate;
begin
If Idx1 <> Idx2 then
  begin
    // sanity checks
    If (Idx1 < Low(fShopTemplates)) or (Idx1 > High(fShopTemplates)) then
      raise Exception.CreateFmt('TILManager_Base.ShopTemplateExchange: First index (%d) out of bounds.',[Idx1]);
    If (Idx2 < Low(fShopTemplates)) or (Idx2 > High(fShopTemplates)) then
      raise Exception.CreateFmt('TILManager_Base.ShopTemplateExchange: Second index (%d) out of bounds.',[Idx2]);
    Temp := fShopTemplates[Idx1];
    fShopTemplates[Idx1] := fShopTemplates[Idx2];
    fShopTemplates[Idx2] := Temp;
  end;
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.ShopTemplateDelete(Index: Integer);
var
  i:  Integer;
begin
If (Index >= Low(fShopTemplates)) and (Index <= High(fShopTemplates)) then
  begin
    ItemShopFinalize(fShopTemplates[Index].ShopData);
    For i := Index to Pred(High(fShopTemplates)) do
      fShopTemplates[i] := fShopTemplates[i + 1];
    SetLength(fShopTemplates,Length(fShopTemplates) - 1);
  end
else raise Exception.CreateFmt('TILManager_Base.ShopTemplateDelete: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.ShopTemplateClear;
var
  i:  Integer;
begin
For i := Low(fShopTemplates) to High(fShopTemplates) do
  ItemShopFinalize(fShopTemplates[i].ShopData);
SetLength(fShopTemplates,0);
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.ShopTemplateExport(const FileName: String; ShopTemplateIndex: Integer);
var
  FileStream: TFileStream;
begin
If (ShopTemplateIndex >= Low(fShopTemplates)) and (ShopTemplateIndex <= High(fShopTemplates)) then
  begin
    FileStream := TFileStream.Create(FileName,fmCreate or fmShareDenyWrite);
    try
      Stream_WriteUInt32(FileStream,IL_SHOPTEMPLATE_SIGNATURE);
      Stream_WriteUInt32(FileStream,IL_LISTFILE_FILESTRUCTURE_SAVE);
      ExportShopTemplate(FileStream,fShopTemplates[ShopTemplateIndex],IL_LISTFILE_FILESTRUCTURE_SAVE);
    finally
      FileStream.Free;
    end;
  end
else raise Exception.CreateFmt('TILManager_Base.ShopTemplateExport: Index (%d) out of bounds.',[ShopTemplateIndex]);
end;

//------------------------------------------------------------------------------

Function TILManager_Base.ShopTemplateImport(const FileName: String): Integer;
var
  FileStream: TFileStream;
begin
FileStream := TFileStream.Create(FileName,fmOpenRead or fmShareDenyWrite);
try
  SetLength(fShopTemplates,Length(fShopTemplates) + 1);
  Result := High(fShopTemplates);
  If Stream_ReadUInt32(FileStream) <> UInt32(IL_SHOPTEMPLATE_SIGNATURE) then
    raise Exception.Create('TILManager_Base.ShopTemplateImport: Unknown file format.');
  ImportShopTemplate(FileStream,fShopTemplates[Result],Stream_ReadUInt32(FileStream));
finally
  FileStream.Free;
end;
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.SaveToStream(Stream: TStream);
begin
Stream_WriteUInt32(Stream,IL_LISTFILE_SIGNATURE);
Stream_WriteUInt32(Stream,IL_LISTFILE_FILESTRUCTURE_SAVE);
SaveData(Stream,IL_LISTFILE_FILESTRUCTURE_SAVE);
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.SaveToFile(const FileName: String);
var
  FileStream: TFileStream;
begin
FileStream := TFileStream.Create(FileName,fmCreate or fmShareDenyWrite);
try
  SaveToStream(FileStream);
  FileStream.Size := FileStream.Position;
  fFileName := FileName;
finally
  FileStream.Free;
end;
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.SaveToFileBuffered(const FileName: String);
var
  FileStream: TMemoryStream;
begin
FileStream := TMemoryStream.Create;
try
  //prealloc
  FileStream.Size := Length(fList) * (45 * 1024); {~45Kib per item}
  SaveToStream(FileStream);
  FileStream.Size := FileStream.Position;
  FileStream.SaveToFile(FileName);
  fFileName := FileName;
finally
  FileStream.Free;
end;
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.LoadFromStream(Stream: TStream);
begin
If Stream_ReadUInt32(Stream) <> UInt32(IL_LISTFILE_SIGNATURE) then
  raise Exception.Create('TILManager_Base.LoadFromStream: Unknown file format.');
LoadData(Stream,Stream_ReadUInt32(Stream));
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.LoadFromFile(const FileName: String);
var
  FileStream: TFileStream;
begin
FileStream := TFileStream.Create(FileName,fmOpenRead or fmShareDenyWrite);
try
  LoadFromStream(FileStream);
  fFileName := FileName;
finally
  FileStream.Free;
end;
end;

//------------------------------------------------------------------------------

procedure TILManager_Base.LoadFromFileBuffered(const FileName: String);
var
  FileStream: TMemoryStream;
begin
FileStream := TMemoryStream.Create;
try
  FileStream.LoadFromFile(FileName);
  FileStream.Seek(0,soBeginning);
  LoadFromStream(FileStream);
  fFileName := FileName;
finally
  FileStream.Free;
end;
end;


end.
