{-------------------------------------------------------------------------------

  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at http://mozilla.org/MPL/2.0/.

-------------------------------------------------------------------------------}
{===============================================================================

  Utility Window

  ©František Milt 2018-10-22

  Version 1.2.2

  Dependencies:
    AuxTypes       - github.com/ncs-sniper/Lib.AuxTypes
    AuxClasses     - github.com/ncs-sniper/Lib.AuxClasses
    MulticastEvent - github.com/ncs-sniper/Lib.MulticastEvent
    WndAlloc       - github.com/ncs-sniper/Lib.WndAlloc

===============================================================================}
unit UtilityWindow;

{$IF not(defined(WINDOWS) or defined(MSWINDOWS))}
  {$MESSAGE FATAL 'Unsupported operating system.'}
{$IFEND}

{$IFDEF FPC}
  {$MODE Delphi}
  {$DEFINE FPC_DisableWarns}
  {$MACRO ON}
{$ENDIF}

interface

uses
  Windows, Messages, AuxClasses, MulticastEvent;

type
  TMessageEvent = procedure(var Msg: TMessage; var Handled: Boolean) of object;

{==============================================================================}
{--- TMulticastMessageEvent declarationn --------------------------------------}
{==============================================================================}

  TMulticastMessageEvent = class(TMulticastEvent)
  public
    Function IndexOf(const Handler: TMessageEvent): Integer; reintroduce;
    Function Add(Handler: TMessageEvent; AllowDuplicity: Boolean = False): Integer; reintroduce;
    Function Remove(const Handler: TMessageEvent): Integer; reintroduce;
    procedure Call(var Msg: TMessage; var Handled: Boolean); reintroduce;
  end;

{==============================================================================}
{--- TUtilityWindow declarationn ----------------------------------------------}
{==============================================================================}

  TUtilityWindow = class(TCustomObject)
  private
    fWindowHandle:  HWND;
    fOnMessage:     TMulticastMessageEvent;
  protected
    procedure WndProc(var Msg: TMessage); virtual;
  public
    constructor Create;
    destructor Destroy; override;
    procedure ProcessMessages(Synchronous: Boolean = False); virtual;
    property WindowHandle: HWND read fWindowHandle;
    property OnMessage: TMulticastMessageEvent read fOnMessage;
  end;

implementation

uses
  SysUtils, Classes, WndAlloc;

{$IFDEF FPC_DisableWarns}
  {$DEFINE FPCDWM}
  {$DEFINE W5057:={$WARN 5057 OFF}} // Local variable "$1" does not seem to be initialized
{$ENDIF}

{==============================================================================}
{--- TMulticastMessageEvent implementation ------------------------------------}
{==============================================================================}

{=== TMulticastMessageEvent // public methods =================================}

Function TMulticastMessageEvent.IndexOf(const Handler: TMessageEvent): Integer;
begin
Result := inherited IndexOf(TEvent(Handler));
end;

//------------------------------------------------------------------------------

Function TMulticastMessageEvent.Add(Handler: TMessageEvent; AllowDuplicity: Boolean = False): Integer;
begin
Result := inherited Add(TEvent(Handler),AllowDuplicity);
end;

//------------------------------------------------------------------------------

Function TMulticastMessageEvent.Remove(const Handler: TMessageEvent): Integer;
begin
Result := inherited Remove(TEvent(Handler));
end;

//------------------------------------------------------------------------------

procedure TMulticastMessageEvent.Call(var Msg: TMessage; var Handled: Boolean);
var
  i:          Integer;
  Processed:  Boolean;
begin
Processed := False;
For i := 0 to Pred(Count) do
  begin
    TMessageEvent(Methods[i])(Msg,Processed);
    If Processed then Handled := True;
  end;
end;

{==============================================================================}
{--- TUtilityWindow implementation --------------------------------------------}
{==============================================================================}

{=== TUtilityWindow // protected methods ======================================}

procedure TUtilityWindow.WndProc(var Msg: TMessage);
var
  Handled:  Boolean;
begin
Handled := False;
fOnMessage.Call(Msg,Handled);
If not Handled then
  Msg.Result := DefWindowProc(fWindowHandle,Msg.Msg,Msg.wParam,Msg.lParam);
end;

{=== TUtilityWindow // public methods =========================================}

constructor TUtilityWindow.Create;
begin
inherited;
fOnMessage := TMulticastMessageEvent.Create(Self);
fWindowHandle := WndAlloc.AllocateHWND(WndProc);
end;

//------------------------------------------------------------------------------

destructor TUtilityWindow.Destroy;
begin
fOnMessage.Clear;
WndAlloc.DeallocateHWND(fWindowHandle);
fOnMessage.Free;
inherited;
end;

//------------------------------------------------------------------------------

{$IFDEF FPCDWM}{$PUSH}W5057{$ENDIF}
procedure TUtilityWindow.ProcessMessages(Synchronous: Boolean = False);
var
  Msg:  TagMSG;
begin
If Synchronous then
  begin
    while GetMessage(Msg,fWindowHandle,0,0) do
      begin
        TranslateMessage(Msg);
        DispatchMessage(Msg);
      end;
  end
else
  begin
    while PeekMessage(Msg,fWindowHandle,0,0,PM_REMOVE) do
      begin
        TranslateMessage(Msg);
        DispatchMessage(Msg);
      end;
  end;
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

end.
