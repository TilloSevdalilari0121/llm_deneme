program LocalModelRunner;

uses
  Vcl.Forms,
  Vcl.Themes,
  Vcl.Styles,
  MainForm in 'src\Forms\MainForm.pas' {frmMain},
  ModelManagerForm in 'src\Forms\ModelManagerForm.pas' {frmModelManager},
  SettingsForm in 'src\Forms\SettingsForm.pas' {frmSettings},
  ModelImportForm in 'src\Forms\ModelImportForm.pas' {frmModelImport},
  LlamaCppBindings in 'src\Units\LlamaCppBindings.pas',
  ModelManager in 'src\Units\ModelManager.pas',
  InferenceEngine in 'src\Units\InferenceEngine.pas',
  ResourceExtractor in 'src\Units\ResourceExtractor.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Windows11 Modern Dark');
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
