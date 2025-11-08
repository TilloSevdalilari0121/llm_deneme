unit MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls, Vcl.Buttons,
  ThemeManager, SettingsManager, DatabaseManager, OllamaAPI, LMStudioAPI, JanAPI,
  APIBase;

type
  TfrmMain = class(TForm)
    pnlSidebar: TPanel;
    pnlMain: TPanel;
    pnlTop: TPanel;
    lstModules: TListBox;
    splSidebar: TSplitter;
    lblTitle: TLabel;
    btnSettings: TButton;
    btnTheme: TButton;
    cmbProvider: TComboBox;
    cmbModel: TComboBox;
    lblProvider: TLabel;
    lblModel: TLabel;
    pnlStatus: TPanel;
    lblStatus: TLabel;
    btnRefreshModels: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lstModulesClick(Sender: TObject);
    procedure btnSettingsClick(Sender: TObject);
    procedure btnThemeClick(Sender: TObject);
    procedure cmbProviderChange(Sender: TObject);
    procedure btnRefreshModelsClick(Sender: TObject);
  private
    FCurrentAPI: TAPIBase;
    FOllamaAPI: TOllamaAPI;
    FLMStudioAPI: TLMStudioAPI;
    FJanAPI: TJanAPI;
    FActiveForm: TForm;

    procedure InitializeAPIs;
    procedure LoadProviders;
    procedure LoadModels;
    procedure SwitchModule(const ModuleName: string);
    procedure ShowModuleForm(FormClass: TFormClass);
    procedure ApplyTheme;
  public
    property CurrentAPI: TAPIBase read FCurrentAPI;
  end;

var
  frmMain: TfrmMain;

implementation

uses
  ChatForm, ModelCompareForm, ModelManagerForm, BenchmarkForm,
  RAGManagerForm, PromptLibraryForm, APIPlaygroundForm,
  CodeExecutionForm, WorkspaceForm, PerformanceMonitorForm,
  SettingsForm, ThemeManagerForm, PluginManagerForm, ExportImportForm;

{$R *.dfm}

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  // Initialize APIs
  InitializeAPIs;

  // Setup modules list
  lstModules.Items.Clear;
  lstModules.Items.Add('Chat');
  lstModules.Items.Add('Model Compare');
  lstModules.Items.Add('Model Manager');
  lstModules.Items.Add('Benchmark');
  lstModules.Items.Add('RAG Manager');
  lstModules.Items.Add('Prompt Library');
  lstModules.Items.Add('API Playground');
  lstModules.Items.Add('Code Execution');
  lstModules.Items.Add('Workspace');
  lstModules.Items.Add('Performance Monitor');
  lstModules.Items.Add('Plugin Manager');
  lstModules.Items.Add('Export/Import');

  // Load providers
  LoadProviders;

  // Select default module
  lstModules.ItemIndex := 0;
  SwitchModule('Chat');

  // Apply theme
  ApplyTheme;

  lblStatus.Caption := 'Ready';
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  if Assigned(FActiveForm) then
    FActiveForm.Free;

  FOllamaAPI.Free;
  FLMStudioAPI.Free;
  FJanAPI.Free;
end;

procedure TfrmMain.InitializeAPIs;
begin
  FOllamaAPI := TOllamaAPI.Create;
  FOllamaAPI.BaseURL := TSettingsManager.GetOllamaURL;

  FLMStudioAPI := TLMStudioAPI.Create;
  FLMStudioAPI.BaseURL := TSettingsManager.GetLMStudioURL;

  FJanAPI := TJanAPI.Create;
  FJanAPI.BaseURL := TSettingsManager.GetJanURL;

  // Set current API based on settings
  case TSettingsManager.GetCurrentProvider of
    0: FCurrentAPI := FOllamaAPI;
    1: FCurrentAPI := FLMStudioAPI;
    2: FCurrentAPI := FJanAPI;
  else
    FCurrentAPI := FOllamaAPI;
  end;
end;

procedure TfrmMain.LoadProviders;
begin
  cmbProvider.Items.Clear;
  cmbProvider.Items.Add('Ollama');
  cmbProvider.Items.Add('LM Studio');
  cmbProvider.Items.Add('Jan');

  cmbProvider.ItemIndex := TSettingsManager.GetCurrentProvider;
  cmbProviderChange(nil);
end;

procedure TfrmMain.LoadModels;
var
  Models: TArray<TModelInfo>;
  I: Integer;
begin
  cmbModel.Items.Clear;

  try
    Models := FCurrentAPI.GetModels;
    for I := 0 to High(Models) do
      cmbModel.Items.Add(Models[I].Name);

    if cmbModel.Items.Count > 0 then
    begin
      // Try to select saved model
      var SavedModel := TSettingsManager.GetCurrentModel;
      var Idx := cmbModel.Items.IndexOf(SavedModel);
      if Idx >= 0 then
        cmbModel.ItemIndex := Idx
      else
        cmbModel.ItemIndex := 0;

      FCurrentAPI.Model := cmbModel.Text;
    end;

    lblStatus.Caption := Format('Loaded %d models', [cmbModel.Items.Count]);
  except
    on E: Exception do
      lblStatus.Caption := 'Error loading models: ' + E.Message;
  end;
end;

procedure TfrmMain.cmbProviderChange(Sender: TObject);
begin
  case cmbProvider.ItemIndex of
    0: FCurrentAPI := FOllamaAPI;
    1: FCurrentAPI := FLMStudioAPI;
    2: FCurrentAPI := FJanAPI;
  end;

  TSettingsManager.SetCurrentProvider(cmbProvider.ItemIndex);
  LoadModels;
end;

procedure TfrmMain.btnRefreshModelsClick(Sender: TObject);
begin
  LoadModels;
end;

procedure TfrmMain.lstModulesClick(Sender: TObject);
begin
  if lstModules.ItemIndex >= 0 then
    SwitchModule(lstModules.Items[lstModules.ItemIndex]);
end;

procedure TfrmMain.SwitchModule(const ModuleName: string);
begin
  if SameText(ModuleName, 'Chat') then
    ShowModuleForm(TfrmChat)
  else if SameText(ModuleName, 'Model Compare') then
    ShowModuleForm(TfrmModelCompare)
  else if SameText(ModuleName, 'Model Manager') then
    ShowModuleForm(TfrmModelManager)
  else if SameText(ModuleName, 'Benchmark') then
    ShowModuleForm(TfrmBenchmark)
  else if SameText(ModuleName, 'RAG Manager') then
    ShowModuleForm(TfrmRAGManager)
  else if SameText(ModuleName, 'Prompt Library') then
    ShowModuleForm(TfrmPromptLibrary)
  else if SameText(ModuleName, 'API Playground') then
    ShowModuleForm(TfrmAPIPlayground)
  else if SameText(ModuleName, 'Code Execution') then
    ShowModuleForm(TfrmCodeExecution)
  else if SameText(ModuleName, 'Workspace') then
    ShowModuleForm(TfrmWorkspace)
  else if SameText(ModuleName, 'Performance Monitor') then
    ShowModuleForm(TfrmPerformanceMonitor)
  else if SameText(ModuleName, 'Plugin Manager') then
    ShowModuleForm(TfrmPluginManager)
  else if SameText(ModuleName, 'Export/Import') then
    ShowModuleForm(TfrmExportImport);
end;

procedure TfrmMain.ShowModuleForm(FormClass: TFormClass);
begin
  // Free previous form
  if Assigned(FActiveForm) then
  begin
    FActiveForm.Free;
    FActiveForm := nil;
  end;

  // Create new form
  FActiveForm := FormClass.Create(Self);
  FActiveForm.BorderStyle := bsNone;
  FActiveForm.Parent := pnlMain;
  FActiveForm.Align := alClient;
  FActiveForm.Show;

  TThemeManager.ApplyToForm(FActiveForm);
end;

procedure TfrmMain.btnSettingsClick(Sender: TObject);
var
  frm: TfrmSettings;
begin
  frm := TfrmSettings.Create(Self);
  try
    if frm.ShowModal = mrOK then
    begin
      // Reload settings
      InitializeAPIs;
      LoadProviders;
    end;
  finally
    frm.Free;
  end;
end;

procedure TfrmMain.btnThemeClick(Sender: TObject);
var
  frm: TfrmThemeManager;
begin
  frm := TfrmThemeManager.Create(Self);
  try
    if frm.ShowModal = mrOK then
      ApplyTheme;
  finally
    frm.Free;
  end;
end;

procedure TfrmMain.ApplyTheme;
begin
  TThemeManager.ApplyToForm(Self);
  if Assigned(FActiveForm) then
    TThemeManager.ApplyToForm(FActiveForm);
end;

end.
