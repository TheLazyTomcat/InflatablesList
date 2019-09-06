unit InflatablesList_HTML_Download;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  Classes;

Function IL_WGETDownloadURL(const URL: String; Stream: TStream; out ResultCode: Integer): Boolean;

Function IL_SYNDownloadURL(const URL: String; Stream: TStream; out ResultCode: Integer): Boolean;

implementation

uses
  Windows, SysUtils, SyncObjs,
  HTTPSend, ssl_openssl, ssl_openssl_lib, // synapse
  CRC32, StrRect,
  InflatablesList_Utils;

// resource file with the binaries (DLLs, wget.exe)
{$R '..\resources\down_bins.res'}

const
  IL_PREP_DOWN_BINS_TAG_WGET = 1;
  IL_PREP_DOWN_BINS_TAG_OSSL = 2;

var
  ILPrepFlag_WGET: Integer = 0;
  ILPrepFlag_OSSL: Integer = 0;

  ILDiskAccessSection:  TCriticalSection;

//------------------------------------------------------------------------------

procedure IL_PrepDownloadBinaries(Tag: Integer);

  procedure ExtractResToFile(const ResName,FileName: String);
  var
    ResStream:  TResourceStream;
  begin
    ILDiskAccessSection.Enter;
    try
      // extract files to program folder
      If not IL_FileExists(IL_ExtractFilePath(RTLToStr(ParamStr(0))) + FileName) then
        begin
          ResStream := TResourceStream.Create(hInstance,StrToRTL(ResName),PChar(10));
          try
            ResStream.SaveToFile(StrToRTL(IL_ExtractFilePath(RTLToStr(ParamStr(0))) + FileName));
          finally
            ResStream.Free;
          end;
        end;
    finally
      ILDiskAccessSection.Leave;
    end;
  end;

begin
case Tag of
  IL_PREP_DOWN_BINS_TAG_WGET:
    If InterlockedExchangeAdd(ILPrepFlag_WGET,0) <= 0 then
      begin
        ExtractResToFile('wget','wget.exe');
        InterlockedExchangeAdd(ILPrepFlag_WGET,1);
      end;
  IL_PREP_DOWN_BINS_TAG_OSSL:
    If InterlockedExchangeAdd(ILPrepFlag_OSSL,0) <= 0 then
      begin
        ExtractResToFile('libeay32','libeay32.dll');
        ExtractResToFile('ssleay32','ssleay32.dll');
        InterlockedExchangeAdd(ILPrepFlag_OSSL,1);
      end;
end;
end;

//==============================================================================

Function IL_WGETDownloadURL(const URL: String; Stream: TStream; out ResultCode: Integer): Boolean;
const
  BELOW_NORMAL_PRIORITY_CLASS = $00004000;
var
  CommandLine:  String;
  OutFileName:  String;
  SecurityAttr: TSecurityAttributes;
  StartInfo:    TStartupInfo;
  ProcessInfo:  TProcessInformation;
  ExitCode:     DWORD;
  FileStream:   TFileStream;
begin
Result := False;
ResultCode := -1;
IL_PrepDownloadBinaries(IL_PREP_DOWN_BINS_TAG_WGET);
// prepare name for the temp file
OutFileName := IL_ExtractFilePath(RTLToStr(ParamStr(0))) + CRC32ToStr(StringCRC32(URL));
// prepare command line
{
  used wget options:
    -q      quiet
    -T ...  timeout [s]
    -O ...  output file
}
CommandLine := IL_Format('"%s" -q -T 5 -O "%s" "%s"',[
  IL_ExtractFilePath(RTLToStr(ParamStr(0))) + 'wget.exe',OutFileName,URL]);
// init security attributes
FillChar(SecurityAttr,SizeOf(TSecurityAttributes),0);
SecurityAttr.nLength := SizeOf(TSecurityAttributes);
SecurityAttr.lpSecurityDescriptor := nil;
SecurityAttr.bInheritHandle := True;
// init startinfo
FillChar(StartInfo,SizeOf(TStartUpInfo),0);
StartInfo.cb := SizeOf(TStartupInfo);
StartInfo.dwFlags := STARTF_USESHOWWINDOW;
StartInfo.wShowWindow := SW_HIDE;
// run the wget
If CreateProcess(nil,PChar(StrToWin(CommandLine)),@SecurityAttr,@SecurityAttr,True,
  BELOW_NORMAL_PRIORITY_CLASS,nil,nil,StartInfo,ProcessInfo) then
  begin
    WaitForSingleObject(ProcessInfo.hProcess,INFINITE);
    GetExitCodeProcess(ProcessInfo.hProcess,ExitCode);
    ResultCode := Integer(ExitCode);
    CloseHandle(ProcessInfo.hThread);
    CloseHandle(ProcessInfo.hProcess);
    If ResultCode = 0 then
      begin
        FileStream := TFileStream.Create(StrToRTL(OutFileName),fmOpenRead or fmShareDenyWrite);
        try
          Stream.CopyFrom(FileStream,0);
          Result := True;
        finally
          FileStream.Free;
        end;
      end;
  end;
If IL_FileExists(OutFileName) then
  IL_DeleteFile(OutFileName);
end;

//------------------------------------------------------------------------------

Function IL_SYNDownloadURL(const URL: String; Stream: TStream; out ResultCode: Integer): Boolean;
var
  HTTPClient: THTTPSend;
begin
Result := False;
ResultCode := -1;
IL_PrepDownloadBinaries(IL_PREP_DOWN_BINS_TAG_OSSL);
HTTPClient := THTTPSend.Create;
try
  // user agent must be set to something sensible, otherwise some webs refuse to send anything
  HTTPClient.UserAgent := 'Mozilla/5.0 (Windows NT 5.1; rv:62.0) Gecko/20100101 Firefox/62.0';
  HTTPClient.Timeout := 5000;
  If HTTPClient.HTTPMethod('GET',URL) then
    begin
      HTTPClient.Document.SaveToStream(Stream);
      Result := Stream.Size > 0;
    end;
  ResultCode := HTTPClient.ResultCode;
finally
  HTTPClient.Free;
end;
end;

//==============================================================================

initialization
  ILDiskAccessSection := TCriticalSection.Create;

finalization
  FreeAndNil(ILDiskAccessSection);

end.
