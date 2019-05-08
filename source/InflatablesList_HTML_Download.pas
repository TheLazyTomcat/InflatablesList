unit InflatablesList_HTML_Download;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  Classes;

Function IL_SYNDownloadURL(const URL: String; Stream: TStream; out ResultCode: Integer): Boolean;

implementation

uses
  SysUtils,
  HTTPSend, ssl_openssl, ssl_openssl_lib; // synapse

{$R '..\resources\ossl_bins.res'}

Function IL_SYNDownloadURL(const URL: String; Stream: TStream; out ResultCode: Integer): Boolean;
var
  HTTPClient: THTTPSend;
begin
HTTPClient := THTTPSend.Create;
try
  // user agent must be set to something sensible, otherwise some webs refuse to send anything
  HTTPClient.UserAgent := 'Mozilla/5.0 (Windows NT 5.1; rv:62.0) Gecko/20100101 Firefox/62.0';
  HTTPClient.Timeout := 10000; 
  If HTTPClient.HTTPMethod('GET',URL) then
    begin
      HTTPClient.Document.SaveToStream(Stream);
      Result := Stream.Size > 0;
    end
  else Result := False;
  ResultCode := HTTPClient.ResultCode;
finally
  HTTPClient.Free;
end;
end;

//==============================================================================

procedure ExtractLibsFromRes;

  procedure ExtractRestoFile(const ResName,FileName: String);
  var
    ResStream:  TResourceStream;
  begin
    If not FileExists(ExtractFilePath(ParamStr(0)) + FileName) then
      begin
        ResStream := TResourceStream.Create(hInstance,ResName,PChar(10));
        try
          ResStream.SaveToFile(ExtractFilePath(ParamStr(0)) + FileName);
        finally
          ResStream.Free;
        end;
      end;
  end;

begin
ExtractRestoFile('libeay32','libeay32.dll');
ExtractRestoFile('ssleay32','ssleay32.dll');
end;

initialization
  ExtractLibsFromRes;

end.
