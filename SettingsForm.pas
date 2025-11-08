unit SettingsForm;

{$IFDEF FPC}
  {$MODE DELPHI}
{$ENDIF}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls, SettingsManager;

type
  TfrmSettings = class(TForm)
    pgcSettings: TPageControl;
    tsInference: TTabSheet;
    tsGPU: TTabSheet;
    tsModelPaths: TTabSheet;
    pnlButtons: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    btnApply: TButton;
    // Inference controls
    lblTemperature: TLabel;
    trackTemperature: TTrackBar;
    edtTemperature: TEdit;
    lblTopP: TLabel;
    trackTopP: TTrackBar;
    edtTopP: TEdit;
    lblTopK: TLabel;
    edtTopK: TEdit;
    lblMaxTokens: TLabel;
    edtMaxTokens: TEdit;
    lblContextSize: TLabel;
    edtContextSize: TEdit;
    // GPU controls
    lblGPULayers: TLabel;
    edtGPULayers: TEdit;
    lblMainGPU: TLabel;
    edtMainGPU: TEdit;
    lblThreads: TLabel;
    edtThreads: TEdit;
    chkGPUOffload: TCheckBox;
    lblGPUInfo: TLabel;
    // Model paths
    lblOllama: TLabel;
    edtOllamaPath: TEdit;
    btnBrowseOllama: TButton;
    lblLMStudio: TLabel;
    edtLMStudioPath: TEdit;
    btnBrowseLMStudio: TButton;
    lblJan: TLabel;
    edtJanPath: TEdit;
    btnBrowseJan: TButton;
    lblCustom: TLabel;
    edtCustomPath: TEdit;
    btnBrowseCustom: TButton;
    // Help labels
    lblTempHelp: TLabel;
    lblTopPHelp: TLabel;
    lblTopKHelp: TLabel;
    lblMaxTokensHelp: TLabel;
    lblContextHelp: TLabel;
    lblGPULayersHelp: TLabel;
    lblThreadsHelp: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure trackTemperatureChange(Sender: TObject);
    procedure trackTopPChange(Sender: TObject);
    procedure btnBrowseOllamaClick(Sender: TObject);
    procedure btnBrowseLMStudioClick(Sender: TObject);
    procedure btnBrowseJanClick(Sender: TObject);
    procedure btnBrowseCustomClick(Sender: TObject);
    procedure chkGPUOffloadClick(Sender: TObject);
  private
    procedure LoadSettings;
    procedure SaveSettings;
    procedure BrowseFolder(Edit: TEdit);
  public
    { Public declarations }
  end;

var
  frmSettings: TfrmSettings;

implementation

uses
  Vcl.FileCtrl;

{$R *.dfm}

procedure TfrmSettings.FormCreate(Sender: TObject);
begin
  LoadSettings;
end;

procedure TfrmSettings.LoadSettings;
begin
  // Inference settings
  trackTemperature.Position := Round(TSettingsManager.GetDefaultTemperature * 100);
  edtTemperature.Text := Format('%.2f', [TSettingsManager.GetDefaultTemperature]);

  trackTopP.Position := Round(TSettingsManager.GetDefaultTopP * 100);
  edtTopP.Text := Format('%.2f', [TSettingsManager.GetDefaultTopP]);

  edtTopK.Text := IntToStr(TSettingsManager.GetDefaultTopK);
  edtMaxTokens.Text := IntToStr(TSettingsManager.GetDefaultMaxTokens);
  edtContextSize.Text := IntToStr(TSettingsManager.GetDefaultContextSize);

  // GPU settings
  edtGPULayers.Text := IntToStr(TSettingsManager.GetGPULayers);
  edtMainGPU.Text := IntToStr(TSettingsManager.GetMainGPU);
  edtThreads.Text := IntToStr(TSettingsManager.GetThreads);
  chkGPUOffload.Checked := TSettingsManager.GetGPULayers > 0;

  // Model paths
  edtOllamaPath.Text := TSettingsManager.GetOllamaPath;
  edtLMStudioPath.Text := TSettingsManager.GetLMStudioPath;
  edtJanPath.Text := TSettingsManager.GetJanPath;
  edtCustomPath.Text := TSettingsManager.GetCustomModelPath;
end;

procedure TfrmSettings.SaveSettings;
begin
  // Inference settings
  TSettingsManager.SetDefaultTemperature(trackTemperature.Position / 100.0);
  TSettingsManager.SetDefaultTopP(trackTopP.Position / 100.0);
  TSettingsManager.SetDefaultTopK(StrToIntDef(edtTopK.Text, 40));
  TSettingsManager.SetDefaultMaxTokens(StrToIntDef(edtMaxTokens.Text, 2048));
  TSettingsManager.SetDefaultContextSize(StrToIntDef(edtContextSize.Text, 4096));

  // GPU settings
  TSettingsManager.SetGPULayers(StrToIntDef(edtGPULayers.Text, 32));
  TSettingsManager.SetMainGPU(StrToIntDef(edtMainGPU.Text, 0));
  TSettingsManager.SetThreads(StrToIntDef(edtThreads.Text, 8));

  // Model paths
  TSettingsManager.SetOllamaPath(edtOllamaPath.Text);
  TSettingsManager.SetLMStudioPath(edtLMStudioPath.Text);
  TSettingsManager.SetJanPath(edtJanPath.Text);
  TSettingsManager.SetCustomModelPath(edtCustomPath.Text);
end;

procedure TfrmSettings.btnOKClick(Sender: TObject);
begin
  SaveSettings;
  ModalResult := mrOK;
end;

procedure TfrmSettings.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmSettings.btnApplyClick(Sender: TObject);
begin
  SaveSettings;
end;

procedure TfrmSettings.trackTemperatureChange(Sender: TObject);
begin
  edtTemperature.Text := Format('%.2f', [trackTemperature.Position / 100.0]);
end;

procedure TfrmSettings.trackTopPChange(Sender: TObject);
begin
  edtTopP.Text := Format('%.2f', [trackTopP.Position / 100.0]);
end;

procedure TfrmSettings.BrowseFolder(Edit: TEdit);
var
  Dir: string;
begin
  Dir := Edit.Text;
  if SelectDirectory('Select Folder', '', Dir) then
    Edit.Text := Dir;
end;

procedure TfrmSettings.btnBrowseOllamaClick(Sender: TObject);
begin
  BrowseFolder(edtOllamaPath);
end;

procedure TfrmSettings.btnBrowseLMStudioClick(Sender: TObject);
begin
  BrowseFolder(edtLMStudioPath);
end;

procedure TfrmSettings.btnBrowseJanClick(Sender: TObject);
begin
  BrowseFolder(edtJanPath);
end;

procedure TfrmSettings.btnBrowseCustomClick(Sender: TObject);
begin
  BrowseFolder(edtCustomPath);
end;

procedure TfrmSettings.chkGPUOffloadClick(Sender: TObject);
begin
  if chkGPUOffload.Checked then
    edtGPULayers.Text := '32'
  else
    edtGPULayers.Text := '0';
end;

end.
