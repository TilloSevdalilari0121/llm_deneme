program LocalModelRunner;

{$APPTYPE GUI}

uses
  Vcl.Forms,
  Vcl.Themes,
  Vcl.Styles,
  System.SysUtils,
  Winapi.Windows,
  ResourceExtractor in 'ResourceExtractor.pas',
  SQLiteBindings in 'SQLiteBindings.pas',
  LlamaCppBindings in 'LlamaCppBindings.pas',
  ThemeManager in 'ThemeManager.pas',
  DatabaseManager in 'DatabaseManager.pas',
  SettingsManager in 'SettingsManager.pas',
  ModelManager in 'ModelManager.pas',
  InferenceEngine in 'InferenceEngine.pas',
  CodeAssistant in 'CodeAssistant.pas',
  MainForm in 'MainForm.pas' {frmMain},
  SettingsForm in 'SettingsForm.pas' {frmSettings},
  ModelManagerForm in 'ModelManagerForm.pas' {frmModelManager},
  ThemeSettingsForm in 'ThemeSettingsForm.pas' {frmThemeSettings},
  WorkspaceForm in 'WorkspaceForm.pas' {frmWorkspace},
  FirstRunWizard in 'FirstRunWizard.pas' {frmFirstRunWizard};

{$R *.res}
{$R EmbeddedResources.res}

var
  Extractor: TResourceExtractor;
  AppDataPath: string;

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Local Model Runner';

  // Extract embedded DLLs on startup
  try
    AppDataPath := IncludeTrailingPathDelimiter(
      GetEnvironmentVariable('LOCALAPPDATA')) + 'LocalModelRunner\';

    if not DirectoryExists(AppDataPath) then
      ForceDirectories(AppDataPath);

    // Extract llama.dll (ROCm version)
    if TResourceExtractor.ResourceExists('LLAMA_DLL') then
      TResourceExtractor.ExtractResource('LLAMA_DLL', AppDataPath + 'llama.dll');

    // Extract sqlite3.dll
    if TResourceExtractor.ResourceExists('SQLITE3_DLL') then
      TResourceExtractor.ExtractResource('SQLITE3_DLL', AppDataPath + 'sqlite3.dll');

    // Add to DLL search path
    SetDllDirectory(PChar(AppDataPath));

    // Initialize database
    TDatabaseManager.Initialize(AppDataPath + 'localmodel.db');

    // Initialize settings
    TSettingsManager.Initialize;

    // Initialize theme manager
    TThemeManager.Initialize;

    // Check if first run
    if TSettingsManager.IsFirstRun then
    begin
      Application.CreateForm(TfrmFirstRunWizard, frmFirstRunWizard);
      if frmFirstRunWizard.ShowModal = mrOK then
      begin
        TSettingsManager.SetFirstRunComplete;
        Application.CreateForm(TfrmMain, frmMain);
      end
      else
      begin
        Application.Terminate;
        Exit;
      end;
    end
    else
    begin
      Application.CreateForm(TfrmMain, frmMain);
    end;

    // Apply saved theme
    TThemeManager.ApplySavedTheme;
    TThemeManager.ApplyToForm(frmMain);

    Application.Run;

  except
    on E: Exception do
    begin
      MessageBox(0, PChar('Fatal error on startup: ' + E.Message),
                 'Error', MB_OK or MB_ICONERROR);
    end;
  end;

  // Cleanup
  TDatabaseManager.Finalize;
end.
