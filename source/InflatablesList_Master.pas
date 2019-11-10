unit InflatablesList_Master;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  WinSyncObjs,
  InflatablesList_Types,
  InflatablesList_Manager;

const
  IL_APPLICATION_NAME  = 'Inflatables List';
  IL_APPLICATION_MUTEX = 'il_application_start_mutex';

  IL_APPLICATION_TIMEOUT = 10000; // 10s

type
  TILMaster = class(TObject)
  private
    fILManager:     TILManager;
    fILStartMutex:  TMutex;
  protected
    procedure Initialize; virtual;
    procedure Finalize; virtual;
    Function CanStart: Boolean; virtual;
    procedure InitializeApplication; virtual;
    procedure CreateForms; virtual;
    Function LoadList: Boolean; virtual;
    procedure ThreadedLoadingEndHandler(LoadingResult: TILLoadingResult); virtual;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Run; virtual;
  end;

implementation

uses
  SysUtils,
  Forms, Dialogs,
  MainForm, TextEditForm, ShopsForm, ParsingForm, TemplatesForm, SortForm,
  SumsForm, SpecialsForm, OverviewForm, SelectionForm, UpdateForm,
  ItemSelectForm, BackupsForm, UpdResLegendForm, SettingsLegendForm, AboutForm,
  SplashForm, PromptForm, SaveForm, AdvancedSearchForm, ShopByItemsForm,
  InflatablesList_Encryption;

procedure TILMaster.Initialize;
begin
fILManager := TILManager.Create;
fILStartMutex := TMutex.Create(IL_APPLICATION_MUTEX);
end;

//------------------------------------------------------------------------------

procedure TILMaster.Finalize;
begin
FreeAndNil(fILStartMutex);
FreeAndNil(fILManager);
end;

//------------------------------------------------------------------------------

Function TILMaster.CanStart: Boolean;
begin
Result := fILStartMutex.WaitFor(IL_APPLICATION_TIMEOUT) = wrSignaled;
end;

//------------------------------------------------------------------------------

procedure TILMaster.InitializeApplication;
begin
Application.Initialize;
Application.Title := IL_APPLICATION_NAME;
end;

//------------------------------------------------------------------------------

procedure TILMaster.CreateForms;
begin
Application.CreateForm(TfMainForm, fMainForm);
Application.CreateForm(TfTextEditForm, fTextEditForm);
Application.CreateForm(TfShopsForm, fShopsForm);
Application.CreateForm(TfParsingForm, fParsingForm);
Application.CreateForm(TfTemplatesForm, fTemplatesForm);
Application.CreateForm(TfSortForm, fSortForm);
Application.CreateForm(TfSumsForm, fSumsForm);
Application.CreateForm(TfSpecialsForm, fSpecialsForm);
Application.CreateForm(TfOverviewForm, fOverviewForm);
Application.CreateForm(TfSelectionForm, fSelectionForm);
Application.CreateForm(TfUpdateForm, fUpdateForm);
Application.CreateForm(TfItemSelectForm, fItemSelectForm);
Application.CreateForm(TfBackupsForm, fBackupsForm);
Application.CreateForm(TfUpdResLegendForm, fUpdResLegendForm);
Application.CreateForm(TfSettingsLegendForm, fSettingsLegendForm);
Application.CreateForm(TfAboutForm, fAboutForm);
Application.CreateForm(TfSplashForm, fSplashForm);
Application.CreateForm(TfSaveForm, fSaveForm);
Application.CreateForm(TfAdvancedSearchForm, fAdvancedSearchForm);
Application.CreateForm(TfShopByItems,fShopByItems);
// do not automatically create prompt form
//Application.CreateForm(TfPromptForm, fPromptForm);
end;

//------------------------------------------------------------------------------

Function TILMaster.LoadList: Boolean;
var
  PreloadInfo:  TILPreloadInfo;
  Password:     String;
begin
Result := False;
PreloadInfo := fILManager.PreloadFile;
If not([ilprfInvalidFile,ilprfError] <= PreloadInfo.ResultFlags) then
  begin
    // when the file is encrypted, ask for password
    If ilprfEncrypted in PreloadInfo.ResultFlags then
      begin
        If IL_InputQuery('List password','Enter list password (can be empty):',Password,'*') then
          fILManager.ListPassword := Password
        else
          Exit; // exit with result set to false
      end;
    // load the file and catch wrong password exceptions
    try
      If ilprfSlowLoad in PreloadInfo.ResultFlags then
        begin
          Application.ShowMainForm := False;
          fSplashForm.ShowSplash;
          fILManager.LoadFromFileThreaded(ThreadedLoadingEndHandler);
          // main form initialization is deferred to time when the loading is done
        end
      else
        begin
          fILManager.LoadFromFile;
          fMainForm.Initialize(fILManager);
        end;
      Result := True;
    except
      on E: EILWrongPassword do
        MessageDlg('You have entered wrong password, program will now terminate.',mtError,[mbOk],0);
      else
        raise;
    end;
  end
else MessageDlg('Invalid list file, cannot continue.',mtError,[mbOk],0);
end;

//------------------------------------------------------------------------------

procedure TILMaster.ThreadedLoadingEndHandler(LoadingResult: TILLoadingResult);
begin
case LoadingResult of
  illrSuccess:;
    // do nothing
  illrFailed:
    MessageDlg('Loading of the file failed, terminating program.',mtError,[mbOk],0);
  illrWrongPassword:
    MessageDlg('You have entered wrong password, program will now terminate.',mtError,[mbOk],0);
end;
If LoadingResult = illrSuccess then
  fMainForm.Initialize(fILManager)  // deferred initialization
else
  Application.Terminate;  // Application.ShowMainForm is false already
fSplashForm.LoadingDone(LoadingResult = illrSuccess);
end;

//==============================================================================

constructor TILMaster.Create;
begin
inherited Create;
Initialize;
end;

//------------------------------------------------------------------------------

destructor TILMaster.Destroy;
begin
Finalize;
inherited;
end;

//------------------------------------------------------------------------------

procedure TILMaster.Run;
begin
InitializeApplication;
If CanStart then
  begin
    CreateForms;
    If not LoadList then
      begin
        Application.ShowMainForm := False;
        Application.Terminate;
        // fMainForm.OnClose event will not be called
      end;
    Application.Run;
    // fMainForm.Finalize is called automatically in OnClose event (only when loading succeeded)
    fILStartMutex.ReleaseMutex;
  end
else MessageDlg('Application is already running (only one instance is allowed at a time).',mtError,[mbOK],0);
end;

end.
