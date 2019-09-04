unit InflatablesList_ShopUpdater;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  Classes,
  AuxTypes,
  InflatablesList_Types,
  InflatablesList_HTML_Document,
  InflatablesList_HTML_ElementFinder,
  InflatablesList_ItemShop_Update;

type
  TILShopUpdaterResult = (
    ilurSuccess,          // all is well - both price and avail count are valid
    ilurNoLink,           // no download link defined - avail and price both invalid
    ilurNoData,           // insufficient search data - avail and price both invalid
    ilurFailDown,         // failed to download the web page - avail and price both invalid
    ilurFailParse,        // failed to parse the web page - avail and price both invalid
    ilurFailAvailSearch,  // avail count cannot be found - avail is 0, price is valid
    ilurFailSearch,       // price (or both price and avail) cannot be found - avail and price both invalid
    ilurFailAvailValGet,  // cannot get value for avail count - avail is 0, price is valid
    ilurFailValGet,       // cannot get value for price (or both price and avail) - avail and price both invalid
    ilurFail);            // general failure, avail and price both invalid

  TILShopUpdater = class(TObject)
  private
    fShopObject:    TILItemShop_Update;
    // internals
    fDownStream:    TMemoryStream;
    // results
    fDownResCode:   Integer;
    fDownSize:      Int64;
    fErrorString:   String;
    fAvailable:     Int32;
    fPrice:         UInt32;
  protected
    procedure InitializeResults; virtual;
    Function FindElementNode(Document: TILHTMLDocument; Finder: TILElementFinder): TILHTMLElements; virtual;
    Function ExtractValue_FirstInteger(const Text: String): UInt32; overload; virtual;
    Function ExtractValue_FirstInteger(const Text: TILReconvString): UInt32; overload; virtual;
    Function ExtractValue_ContainsTag(const Text,Tag: String): Boolean; overload; virtual;
    Function ExtractValue_ContainsTag(const Text: TILReconvString; const Tag: String): Boolean; overload; virtual;
    Function ExtractValue_FirstNumber(const Text: String): UInt32; overload; virtual;
    Function ExtractValue_FirstNumber(const Text: TILReconvString): UInt32; overload; virtual;
    Function ExtractValue_GetText(Node: TILHTMLElementNode; ExtractFrom: TILItemShopParsingExtrFrom; const Data: String): TILReconvString; virtual;
    Function ExtractAvailable(Nodes: TILHTMLElements): Int32; virtual;
    Function ExtractPrice(Nodes: TILHTMLElements): UInt32; virtual;
  public
    constructor Create(ShopObject: TILItemShop_Update);
    destructor Destroy; override;
    Function Run(AlternativeDownload: Boolean): TILShopUpdaterResult; virtual;
    property DownloadResultCode: Integer read fDownResCode;
    property DownloadSize: Int64 read fDownSize;
    property ErrorString: String read fErrorString;
    property Available: Int32 read fAvailable;
    property Price: UInt32 read fPrice;
  end;

implementation

uses
  SysUtils,
  CRC32, StrRect,
  InflatablesList_Utils,
  InflatablesList_HTML_Download,
  InflatablesList_HTML_Parser;

procedure TILShopUpdater.InitializeResults;
begin
fDownResCode := 0;
fDownSize := 0;
fErrorString := '';
fAvailable := 0;
fPrice := 0;
end;

//------------------------------------------------------------------------------

Function TILShopUpdater.FindElementNode(Document: TILHTMLDocument; Finder: TILElementFinder): TILHTMLElements;
begin
If not Finder.FindElements(Document,Result) then
  Result := nil;
end;

//------------------------------------------------------------------------------

Function TILShopUpdater.ExtractValue_FirstInteger(const Text: String): UInt32;
var
  i:    Integer;
  Buff: String;
begin
Buff := '';
For i := 1 to Length(Text) do
  begin
    If IL_CharInSet(Text[i],['0'..'9']) then
      Buff := Buff + Text[i]
    else If IL_CharInSet(Text[i],[#0..#32,#160]) then
      Continue  // ignore character
    else If Length(Buff) > 0 then
      Break{For i};
  end;
Result := StrToIntDef(Buff,0);
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

Function TILShopUpdater.ExtractValue_FirstInteger(const Text: TILReconvString): UInt32;
begin
Result := ExtractValue_FirstInteger(Text.Str);
If Result = 0 then
  begin
    Result := ExtractValue_FirstInteger(Text.UTF8Reconv);
    If Result = 0 then
      Result := ExtractValue_FirstInteger(Text.AnsiReconv);
  end;
end;

//------------------------------------------------------------------------------

Function TILShopUpdater.ExtractValue_ContainsTag(const Text,Tag: String): Boolean;
begin
If Length(Tag) > 0 then
  Result := IL_ContainsText(Text,Tag)
else
  Result := True;
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

Function TILShopUpdater.ExtractValue_ContainsTag(const Text: TILReconvString; const Tag: String): Boolean;
begin
Result := ExtractValue_ContainsTag(Text.Str,Tag);
If not Result then
  begin
    Result := ExtractValue_ContainsTag(Text.UTF8Reconv,Tag);
    If not Result then
      Result := ExtractValue_ContainsTag(Text.AnsiReconv,Tag);
  end;
end;

//------------------------------------------------------------------------------

Function TILShopUpdater.ExtractValue_FirstNumber(const Text: String): UInt32;
var
  i:    Integer;
  Buff: String;
begin
Buff := '';
For i := 1 to Length(Text) do
  begin
    If IL_CharInSet(Text[i],['0'..'9']) then
      Buff := Buff + Text[i]
    else If IL_CharInSet(Text[i],[#0..#32,#160,'.',',','-']) then
      Continue  // ignore character
    else If Length(Buff) > 0 then
      Break{For i};
  end;
Result := StrToIntDef(Buff,0);
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

Function TILShopUpdater.ExtractValue_FirstNumber(const Text: TILReconvString): UInt32;
begin
Result := ExtractValue_FirstNumber(Text.Str);
If Result = 0 then
  begin
    Result := ExtractValue_FirstNumber(Text.UTF8Reconv);
    If Result = 0 then
      Result := ExtractValue_FirstNumber(Text.AnsiReconv);
  end;
end;

//------------------------------------------------------------------------------

Function TILShopUpdater.ExtractValue_GetText(Node: TILHTMLElementNode; ExtractFrom: TILItemShopParsingExtrFrom; const Data: String): TILReconvString;
var
  Index:  Integer;
begin
// no need to care for thread safety as result does not leave this object
Result := IL_ReconvString('');
case ExtractFrom of
  ilpefNestedText:  Result := Node.NestedText;
  ilpefAttrValue:   begin
                      Index := Node.AttributeIndexOfName(Data);
                      If Index >= 0 then
                        Result := Node.Attributes[Index].Value;
                    end;
else
  {ilpefText}
  Result := Node.Text;
end;
end;

//------------------------------------------------------------------------------

Function TILShopUpdater.ExtractAvailable(Nodes: TILHTMLElements): Int32;
var
  Text: TILReconvString;
  i,j:  Integer;
begin
Result := 0;
For i := 0 to Pred(fShopObject.ParsingSettings.AvailExtractionSettingsCount) do
  with fShopObject.ParsingSettings.AvailExtractionSettings[i] do
    begin
      For j := Low(Nodes) to High(Nodes) do
        begin
          // first get the text from which the value will be extracted
          Text := ExtractValue_GetText(Nodes[j],ExtractFrom,ExtractionData);
          // parse according to selected extr. method
          case ExtractionMethod of
            ilpemFirstIntegerTag:
              begin
                Result := Int32(ExtractValue_FirstInteger(Text));
                If ExtractValue_ContainsTag(Text,NegativeTag) then
                  Result := -Result;
              end;
            ilpemNegTagIsCount:
              If ExtractValue_ContainsTag(Text,NegativeTag) then
                Result := fShopObject.RequiredCount;
            ilpemFirstNumber:
              Result := Int32(ExtractValue_FirstNumber(Text));
            ilpemFirstNumberTag:
              begin
                Result := Int32(ExtractValue_FirstNumber(Text));
                If ExtractValue_ContainsTag(Text,NegativeTag) then
                  Result := -Result;
              end;
          else
            {ilpemFirstInteger}
            Result := Int32(ExtractValue_FirstInteger(Text));
          end;
          If Result <> 0 then
            Break{For j};
        end;
      If Result <> 0 then
        Break{For i};
    end;
end;

//------------------------------------------------------------------------------

Function TILShopUpdater.ExtractPrice(Nodes: TILHTMLElements): UInt32;
var
  Text: TILReconvString;
  i,j:  Integer;
begin
Result := 0;
For i := 0 to Pred(fShopObject.ParsingSettings.PriceExtractionSettingsCount) do
  with fShopObject.ParsingSettings.PriceExtractionSettings[i] do
    begin
      For j := Low(Nodes) to High(Nodes) do
        begin
          // first get the text from which the value will be extracted
          Text := ExtractValue_GetText(Nodes[j],ExtractFrom,ExtractionData);
          // parse according to selected extr. method
          case ExtractionMethod of
            ilpemNegTagIsCount:
              If ExtractValue_ContainsTag(Text,NegativeTag) then
                Result := fShopObject.RequiredCount;
            // price cannot be negative, ignore tag
            ilpemFirstNumber,
            ilpemFirstNumberTag:
              Result := Int32(ExtractValue_FirstNumber(Text)); 
          else
            {ilpemFirstInteger,
             ilpemFirstIntegerTag}
            // price cannot be negative, so ignore neg. tag even when requested
            Result := ExtractValue_FirstInteger(Text);
          end;
          If Result <> 0 then
            Break{For j};
        end;
      If Result <> 0 then
        Break{For i};
    end;
end;

//==============================================================================

constructor TILShopUpdater.Create(ShopObject: TILItemShop_Update);
begin
inherited Create;
fShopObject := TILItemShop_Update.CreateAsCopy(ShopObject);
fDownStream := TMemoryStream.Create;
InitializeResults;
end;

//------------------------------------------------------------------------------

destructor TILShopUpdater.Destroy;
begin
fDownStream.Free;
fShopObject.Free;
inherited;
end;

//------------------------------------------------------------------------------

Function TILShopUpdater.Run(AlternativeDownload: Boolean): TILShopUpdaterResult;
var
  Parser:       TILHTMLParser;
  Document:     TILHTMLDocument;
  AvailNodes:   TILHTMLElements;
  PriceNodes:   TILHTMLElements;
  ElementList:  TStringList;
  OfflineFile:  String;

  Function CallDownload: Boolean;
  begin
    If not fShopObject.StaticSettings.LoadPages then
      begin
        If AlternativeDownload then
          Result := IL_WGETDownloadURL(fShopObject.ItemURL,fDownStream,fDownResCode)
        else
          Result := IL_SYNDownloadURL(fShopObject.ItemURL,fDownStream,fDownResCode);
      end
    else
      begin
        If IL_FileExists(OfflineFile) then
          begin
            fDownStream.LoadFromFile(StrToRTL(OfflineFile));
            Result := True;
          end
        else Result := False;
      end;
  end;

begin
SetLength(AvailNodes,0);
SetLength(PriceNodes,0);
OfflineFile := fShopObject.StaticSettings.ListPath +
  IL_ExtractFileNameNoExt(fShopObject.StaticSettings.ListFile) + '_saved_pages\' +
  IL_UpperCase(CRC32ToStr(WideStringCRC32(StrToUnicode(fShopObject.ItemURL))));
If Length(fShopObject.ItemURL) > 0 then
  begin
    If (fShopObject.ParsingSettings.AvailFinder.StageCount > 0) and
       (fShopObject.ParsingSettings.PriceFinder.StageCount > 0) then
      try
        InitializeResults;
        // download
        fDownStream.Clear;
        If CallDownload then
          begin
            If fShopObject.StaticSettings.TestCode then
              fDownStream.SaveToFile(StrToRTL(fShopObject.StaticSettings.ListPath + 'page.txt'));
            If fShopObject.StaticSettings.SavePages then
              begin
                IL_CreateDirectoryPathForFile(OfflineFile);
                fDownStream.SaveToFile(StrToRTL(OfflineFile));
              end;
            fDownSize := fDownStream.Size;
            fDownStream.Seek(0,soBeginning);
            Parser := TILHTMLParser.Create(fDownStream);
            try
              try
                Parser.RaiseParseErrors := not fShopObject.ParsingSettings.DisableParsingErrors;
                Parser.Run; // whole parsing
                Document := Parser.GetDocument;
                try
                  If fShopObject.StaticSettings.TestCode then
                    begin
                      ElementList := TStringList.Create;
                      try
                        Document.List(ElementList);
                        ElementList.SaveToFile(StrToRTL(fShopObject.StaticSettings.ListPath + 'elements.txt'));
                      finally
                        ElementList.Free;
                      end;
                    end;
                  // prepare finders
                  fShopObject.ParsingSettings.AvailFinder.Prepare(fShopObject.ParsingSettings.VariablesRec);
                  fShopObject.ParsingSettings.PriceFinder.Prepare(fShopObject.ParsingSettings.VariablesRec);
                  // search
                  AvailNodes := FindElementNode(Document,fShopObject.ParsingSettings.AvailFinder);
                  PriceNodes := FindElementNode(Document,fShopObject.ParsingSettings.PriceFinder);
                  // process found nodes
                  If (Length(AvailNodes) > 0) and (Length(PriceNodes) > 0) then
                    begin
                      // both avail and price found
                      fAvailable := ExtractAvailable(AvailNodes);
                      fPrice := ExtractPrice(PriceNodes);
                      If fPrice > 0 then
                        begin
                          // price obtained
                          If fAvailable <> 0 then
                            Result := ilurSuccess
                          else
                            Result := ilurFailAvailValGet
                        end
                      else Result := ilurFailValGet;
                    end
                  else If Length(PriceNodes) > 0 then
                    begin
                      fPrice := ExtractPrice(PriceNodes);
                      If fPrice > 0 then
                        Result := ilurFailAvailSearch
                      else
                        Result := ilurFailValGet;
                    end
                  else Result := ilurFailSearch;
                finally
                  Document.Free;
                end;
              except
                on E: Exception do
                  begin
                    fErrorString := IL_Format('%s: %s',[E.ClassName,E.Message]);
                    Result := ilurFailParse;
                  end;
              end;
            finally
              Parser.Free;
            end;
          end
        else Result := ilurFailDown;
      except
        on E: Exception do
          begin
            fErrorString := IL_Format('%s: %s',[E.ClassName,E.Message]);
            Result := ilurFail;
          end;
      end
    else Result := ilurNoData;
  end
else Result := ilurNoLink;
end;

end.
