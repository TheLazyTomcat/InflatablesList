unit InflatablesList_ShopUpdate;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  Classes,
  AuxTypes,
  InflatablesList_Types,
  InflatablesList_HTML_Document;

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
    fShopData:    TILItemShop;
    // internals
    fDownStream:  TMemoryStream;
    // results
    fDownResCode: Integer;
    fDownSize:    Int64;
    fErrorString: String;
    fAvailable:   Int32;
    fPrice:       UInt32;
  protected
    procedure InitializeResults; virtual;
    Function FindElementNode(BaseNode: TILHTMLElementNode; SearchStages: TILItemShopParsingStages): TILHTMLElementNode; virtual;
    Function ExtractValue_FirstInteger(const Text: String): UInt32; virtual;
    Function ExtractValue_FirstIntegerTagged(const Text,Tag: String): Int32; virtual;
    Function ExtractValue_ContainsTag(const Text,Tag: String): UInt32; virtual;
    Function ExtractAvailValue(const Text: String; ExtractionMethod: TILItemShopParsAvailExtrMethod): Int32; virtual;
    Function ExtractPriceValue(const Text: String; ExtractionMethod: TILItemShopParsPriceExtrMethod): UInt32; virtual;
    Function ExtractAvailable(const Text: String): Int32; virtual;
    Function ExtractPrice(const Text: String): Int32; virtual;
  public
    constructor Create(ShopData: TILItemShop);
    destructor Destroy; override;
    Function Run: TILShopUpdaterResult; virtual;
    property DownloadResultCode: Integer read fDownResCode;
    property DownloadSize: Int64 read fDownSize;
    property ErrorString: String read fErrorString;
    property Available: Int32 read fAvailable;
    property Price: UInt32 read fPrice;
  end;

implementation

uses
  SysUtils, StrUtils, Dialogs,
  InflatablesList, CountedDynArrayObject,
  InflatablesList_Utils,
  InflatablesList_HTML_Download, InflatablesList_HTML_ElementFinder,
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

Function TILShopUpdater.FindElementNode(BaseNode: TILHTMLElementNode; SearchStages: TILItemShopParsingStages): TILHTMLElementNode;
var
  FoundNodesL1: TObjectCountedDynArray;
  FoundNodesL2: TObjectCountedDynArray;
  i,j:          Integer;

  Test:     TILElementFinder;
  Stage:    TILElementComparatorGroup;
  OutNode:  TILHTMLElementNode;
begin
Result := nil;
CDA_Init(FoundNodesL1);
CDA_Init(FoundNodesL2);
CDA_Add(FoundNodesL1,BaseNode);
For i := Low(SearchStages) to High(SearchStages) do
  begin
    CDA_Clear(FoundNodesL2);
    For j := CDA_Low(FoundNodesL1) to CDA_High(FoundNodesL1) do
      TILHTMLElementNode(CDA_GetItem(FoundNodesL1,j)).Find(SearchStages[i],True,FoundNodesL2);
    CDA_Clear(FoundNodesL1);
    FoundNodesL1 := CDA_Copy(FoundNodesL2);
  end;
If CDA_Count(FoundNodesL1) = 1 then
  Result := TILHTMLElementNode(CDA_GetItem(FoundNodesL1,0));

// test
Test := TILElementFinder.Create;
try
  CDA_Clear(FoundNodesL1);
  Stage := Test.StageAdd;
  with Stage.AddComparator do
    begin
      TagName.AddComparator.Str := 'div';
      //(*
      with Attributes.AddComparator do
        begin
          Name.AddComparator.Str := 'class';
          Value.AddComparator.Str := 'well well-sm';
        end;
      //*)
    end;
  Test.FindElement(TILHTMLDocument(BaseNode),OutNode);
  showmessage(booltostr(assigned(OutNode)));
finally
  Test.Free;
end;
{$message 'test new shit'}
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

//------------------------------------------------------------------------------

Function TILShopUpdater.ExtractValue_FirstIntegerTagged(const Text,Tag: String): Int32;
begin
Result := Int32(ExtractValue_FirstInteger(Text));
If Length(Tag) > 0 then
  If AnsiContainsText(Text,Tag) then
    Result := -Result;
end;

//------------------------------------------------------------------------------

Function TILShopUpdater.ExtractValue_ContainsTag(const Text,Tag: String): UInt32;
begin
If AnsiContainsText(Text,Tag) then
  Result := 1
else
  Result := 0;
end;

//------------------------------------------------------------------------------

Function TILShopUpdater.ExtractAvailValue(const Text: String; ExtractionMethod: TILItemShopParsAvailExtrMethod): Int32;
begin
case ExtractionMethod of
  ilpaemFirstInteger:     Result := Int32(ExtractValue_FirstInteger(Text));
  ilpaemFirstIntegerTag:  Result := ExtractValue_FirstIntegerTagged(Text,fShopData.ParsingSettings.MoreThanTag);
  ilpaemMoreThanTagIsOne: Result := Int32(ExtractValue_ContainsTag(Text,fShopData.ParsingSettings.MoreThanTag));
  ilpaemFIorMTTIO:        begin
                            Result := Int32(ExtractValue_FirstInteger(Text));
                            If Result = 0 then
                              Result := ExtractValue_ContainsTag(Text,fShopData.ParsingSettings.MoreThanTag);
                          end;
else
  Result := 0;
end;
end;

//------------------------------------------------------------------------------

Function TILShopUpdater.ExtractPriceValue(const Text: String; ExtractionMethod: TILItemShopParsPriceExtrMethod): UInt32;
begin
case ExtractionMethod of
  ilppemFirstInteger:  Result := ExtractValue_FirstInteger(Text);
else
  Result := 0;
end;
end;

//------------------------------------------------------------------------------

Function TILShopUpdater.ExtractAvailable(const Text: String): Int32;
begin
Result := ExtractAvailValue(Text,fShopData.ParsingSettings.AvailExtrMethod);
end;

//------------------------------------------------------------------------------

Function TILShopUpdater.ExtractPrice(const Text: String): Int32;
begin
Result := ExtractPriceValue(Text,fShopData.ParsingSettings.PriceExtrMethod);
end;

//==============================================================================

constructor TILShopUpdater.Create(ShopData: TILItemShop);
begin
inherited Create;
TILManager.ItemShopCopy(ShopData,fShopData);
fDownStream := TMemoryStream.Create;
InitializeResults;
end;

//------------------------------------------------------------------------------

destructor TILShopUpdater.Destroy;
begin
fDownStream.Free;
inherited;
end;

//------------------------------------------------------------------------------

Function TILShopUpdater.Run: TILShopUpdaterResult;
var
  Parser:       TILHTMLParser;
  Document:     TILHTMLDocument;
  AvailNode:    TILHTMLElementNode;
  PriceNode:    TILHTMLElementNode;
begin
If Length(fShopData.ItemURL) > 0 then
  begin
    If (Length(fShopData.ParsingSettings.AvailStages) > 0) and
       (Length(fShopData.ParsingSettings.PriceStages) > 0) then
      try
        InitializeResults;
        // download
        fDownStream.Clear;
        If IL_SYNDownloadURL(fShopData.ItemURL,fDownStream,fDownResCode) then
          begin
            fDownStream.SaveToFile(ExtractFilePath(ParamStr(0)) + 'test.out');
            fDownSize := fDownStream.Size;
            fDownStream.Seek(0,soBeginning);
            Parser := TILHTMLParser.Create(fDownStream);
            try
              try
                // parse
                Parser.Run;
                Document := Parser.GetDocument;
                try
                  // search
                  AvailNode := FindElementNode(Document,fShopData.ParsingSettings.AvailStages);
                  PriceNode := FindElementNode(Document,fShopData.ParsingSettings.PriceStages);
                  If Assigned(AvailNode) and Assigned(PriceNode) then
                    begin
                      // both avail and price found
                      fAvailable := ExtractAvailable(AvailNode.Text);
                      fPrice := ExtractPrice(PriceNode.Text);
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
                  else If Assigned(PriceNode) then
                    begin
                      fPrice := ExtractPrice(PriceNode.Text);
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
                    fErrorString := Format('%s: %s',[E.ClassName,E.Message]);
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
            fErrorString := Format('%s: %s',[E.ClassName,E.Message]);
            Result := ilurFail;
          end;
      end
    else Result := ilurNoData;
  end
else Result := ilurNoLink;
end;

end.
