program UniversalLLMStudio;

{$APPTYPE GUI}

uses
  Vcl.Forms,
  Vcl.Themes,
  Vcl.Styles,
  System.SysUtils,
  Winapi.Windows,
  HTTPClient in 'HTTPClient.pas',
  APIBase in 'APIBase.pas',
  OllamaAPI in 'OllamaAPI.pas',
  LMStudioAPI in 'LMStudioAPI.pas',
  JanAPI in 'JanAPI.pas',
  DatabaseManager in 'DatabaseManager.pas',
  SettingsManager in 'SettingsManager.pas',
  ThemeManager in 'ThemeManager.pas',
  PromptManager in 'PromptManager.pas',
  RAGEngine in 'RAGEngine.pas',
  CodeExecutor in 'CodeExecutor.pas',
  WorkspaceManager in 'WorkspaceManager.pas',
  PerformanceTracker in 'PerformanceTracker.pas',
  PluginSystem in 'PluginSystem.pas',
  WebScraper in 'WebScraper.pas',
  AgentSystem in 'AgentSystem.pas',
  ExportImport in 'ExportImport.pas',
  MainForm in 'MainForm.pas' {frmMain},
  ChatForm in 'ChatForm.pas' {frmChat},
  ModelCompareForm in 'ModelCompareForm.pas' {frmModelCompare},
  ModelManagerForm in 'ModelManagerForm.pas' {frmModelManager},
  BenchmarkForm in 'BenchmarkForm.pas' {frmBenchmark},
  RAGManagerForm in 'RAGManagerForm.pas' {frmRAGManager},
  PromptLibraryForm in 'PromptLibraryForm.pas' {frmPromptLibrary},
  APIPlaygroundForm in 'APIPlaygroundForm.pas' {frmAPIPlayground},
  CodeExecutionForm in 'CodeExecutionForm.pas' {frmCodeExecution},
  WorkspaceForm in 'WorkspaceForm.pas' {frmWorkspace},
  PerformanceMonitorForm in 'PerformanceMonitorForm.pas' {frmPerformanceMonitor},
  SettingsForm in 'SettingsForm.pas' {frmSettings},
  ThemeManagerForm in 'ThemeManagerForm.pas' {frmThemeManager},
  PluginManagerForm in 'PluginManagerForm.pas' {frmPluginManager},
  ExportImportForm in 'ExportImportForm.pas' {frmExportImport};

{$R *.res}

var
  AppDataPath: string;

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Universal LLM Studio';

  try
    // Use application directory
    AppDataPath := ExtractFilePath(Application.ExeName);

    // Initialize database
    TDatabaseManager.Initialize(AppDataPath + 'llmstudio.db');

    // Initialize all managers
    TSettingsManager.Initialize;
    TThemeManager.Initialize;
    TPromptManager.Initialize;
    TPerformanceTracker.Initialize;
    TPluginSystem.Initialize;

    // Apply saved theme
    TThemeManager.ApplySavedTheme;

    // Create main form
    Application.CreateForm(TfrmMain, frmMain);
    TThemeManager.ApplyToForm(frmMain);

    Application.Run;

  except
    on E: Exception do
    begin
      MessageBox(0, PChar('Fatal error: ' + E.Message),
                 'Error', MB_OK or MB_ICONERROR);
    end;
  end;

  // Cleanup
  TDatabaseManager.Finalize;
  TPerformanceTracker.Finalize;
  TPluginSystem.Finalize;
end.
