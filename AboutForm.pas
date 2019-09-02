unit AboutForm;
{$message 'll_rework'}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls,
  InflatablesList_Manager;

type
  TfAboutForm = class(TForm)
    imgLogo: TImage;
    lblTitle: TLabel;
    lblTitleShadow: TLabel;
    lblVersion: TLabel;
    lblCompiler: TLabel;
    lblCopyright: TLabel;
    lblMail: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure lblMailClick(Sender: TObject);    
    procedure lblMailMouseEnter(Sender: TObject);
    procedure lblMailMouseLeave(Sender: TObject);
  private
    { Private declarations }
    fILManager: TILManager;
  protected
    procedure BuildForm;
  public
    { Public declarations }
    procedure Initialize(ILManager: TILManager);
    procedure Finalize;
    procedure ShowInfo;
  end;

var
  fAboutForm: TfAboutForm;

implementation

uses
  WinFileInfo,
  InflatablesList_Utils;

{$R *.dfm}

procedure TfAboutForm.BuildForm;
begin
with TWinFileInfo.Create(WFI_LS_LoadVersionInfo or WFI_LS_LoadFixedFileInfo or WFI_LS_DecodeFixedFileInfo) do
try
  lblTitle.Caption := VersionInfoValues[VersionInfoTranslations[0].LanguageStr,'FileDescription'];
  lblTitleShadow.Caption := lblTitle.Caption;
  lblVersion.Caption := Format('version %d.%d.%d (build #%d, %s)',
   [VersionInfoFixedFileInfoDecoded.FileVersionMembers.Major,
    VersionInfoFixedFileInfoDecoded.FileVersionMembers.Minor,
    VersionInfoFixedFileInfoDecoded.FileVersionMembers.Release,
    VersionInfoFixedFileInfoDecoded.FileVersionMembers.Build,
    {$IFDEF Debug}'debug'{$ELSE}'release'{$ENDIF}]);
  lblCompiler.Caption := Format('compiled in %s %s',
    [{$IFDEF FPC}'Lazarus/FPC'{$ELSE}'Delphi'{$ENDIF},
     {$IFDEF x64}'64bit'{$ELSE}'32bit'{$ENDIF}]);
  lblCopyright.Caption := Format('%s, all rights reserved',
    [VersionInfoValues[VersionInfoTranslations[0].LanguageStr,'LegalCopyright']]);
finally
  Free;
end;
end;

//==============================================================================

procedure TfAboutForm.Initialize(ILManager: TILManager);
begin
fILManager := ILManager;
end;

//------------------------------------------------------------------------------

procedure TfAboutForm.Finalize;
begin
// nothing to do
end;

//------------------------------------------------------------------------------

procedure TfAboutForm.ShowInfo;
begin
ShowModal;
end;

//==============================================================================

procedure TfAboutForm.FormCreate(Sender: TObject);
begin
BuildForm;
end;

//------------------------------------------------------------------------------

procedure TfAboutForm.lblMailClick(Sender: TObject);
begin
IL_ShellOpen(Self.Handle,'mailto:' + lblMail.Caption);
end;

//------------------------------------------------------------------------------

procedure TfAboutForm.lblMailMouseEnter(Sender: TObject);
begin
lblMail.Font.Style := lblMail.Font.Style + [fsUnderline];
lblMail.Font.Color := $00DAC074;
end;
  
//------------------------------------------------------------------------------

procedure TfAboutForm.lblMailMouseLeave(Sender: TObject);
begin
lblMail.Font.Style := lblMail.Font.Style - [fsUnderline];
lblMail.Font.Color := $00B99731;
end;

end.
