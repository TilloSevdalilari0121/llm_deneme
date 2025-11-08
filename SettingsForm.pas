unit SettingsForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls,
  SettingsManager;

type
  TfrmSettings = class(TForm)
    PageControl: TPageControl;
    tabGeneral: TTabSheet;
    tabAPI: TTabSheet;
    tabAdvanced: TTabSheet;
    pnlBottom: TPanel;
    btnSave: TButton;
    btnCancel: TButton;
    btnApply: TButton;
    lblOllamaURL: TLabel;
    edtOllamaURL: TEdit;
    lblLMStudioURL: TLabel;
    edtLMStudioURL: TEdit;
    lblJanURL: TLabel;
    edtJanURL: TEdit;
    lblDefaultTemp: TLabel;
    trackTemp: TTrackBar;
    lblTempValue: TLabel;
    lblDefaultTopP: TLabel;
    trackTopP: TTrackBar;
    lblTopPValue: TLabel;
    lblMaxTokens: TLabel;
    edtMaxTokens: TEdit;
    chkAutoSave: TCheckBox;
    chkStreamResponse: TCheckBox;
    edtWorkspacePath: TEdit;
    lblWorkspacePath: TLabel;
    btnBrowseWorkspace: TButton;
    lblTimeout: TLabel;
    edtTimeout: TEdit;
    chkDebugMode: TCheckBox;
    lblMaxHistory: TLabel;
    edtMaxHistory: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure trackTempChange(Sender: TObject);
    procedure trackTopPChange(Sender: TObject);
    procedure btnBrowseWorkspaceClick(Sender: TObject);
  private
    procedure LoadSettings;
    procedure SaveSettings;
  public
    { Public declarations }
  end;

var
  frmSettings: TfrmSettings;

implementation

uses
  Vcl.FileCtrl, MainForm, WorkspaceManager;

{$R *.dfm}

procedure TfrmSettings.FormCreate(Sender: TObject);
begin
  LoadSettings;
end;

procedure TfrmSettings.LoadSettings;
begin
  // API Settings
  edtOllamaURL.Text := TSettingsManager.GetOllamaURL;
  edtLMStudioURL.Text := TSettingsManager.GetLMStudioURL;
  edtJanURL.Text := TSettingsManager.GetJanURL;

  // General Settings
  trackTemp.Position := Round(TSettingsManager.GetTemperature * 100);
  trackTempChange(nil);
  trackTopP.Position := Round(TSettingsManager.GetTopP * 100);
  trackTopPChange(nil);
  edtMaxTokens.Text := IntToStr(TSettingsManager.GetMaxTokens);
  chkAutoSave.Checked := TSettingsManager.GetAutoSave;
  chkStreamResponse.Checked := TSettingsManager.GetStreamResponse;

  // Advanced Settings
  edtWorkspacePath.Text := TWorkspaceManager.GetWorkspacePath;
  edtTimeout.Text := IntToStr(TSettingsManager.GetTimeout);
  chkDebugMode.Checked := TSettingsManager.GetDebugMode;
  edtMaxHistory.Text := IntToStr(TSettingsManager.GetMaxHistory);
end;

procedure TfrmSettings.SaveSettings;
begin
  // API Settings
  TSettingsManager.SetOllamaURL(edtOllamaURL.Text);
  TSettingsManager.SetLMStudioURL(edtLMStudioURL.Text);
  TSettingsManager.SetJanURL(edtJanURL.Text);

  // General Settings
  TSettingsManager.SetTemperature(trackTemp.Position / 100.0);
  TSettingsManager.SetTopP(trackTopP.Position / 100.0);
  TSettingsManager.SetMaxTokens(StrToIntDef(edtMaxTokens.Text, 2048));
  TSettingsManager.SetAutoSave(chkAutoSave.Checked);
  TSettingsManager.SetStreamResponse(chkStreamResponse.Checked);

  // Advanced Settings
  TWorkspaceManager.SetWorkspacePath(edtWorkspacePath.Text);
  TSettingsManager.SetTimeout(StrToIntDef(edtTimeout.Text, 30));
  TSettingsManager.SetDebugMode(chkDebugMode.Checked);
  TSettingsManager.SetMaxHistory(StrToIntDef(edtMaxHistory.Text, 100));

  // Update main form APIs
  if Assigned(frmMain) then
    frmMain.InitializeAPIs;
end;

procedure TfrmSettings.trackTempChange(Sender: TObject);
begin
  lblTempValue.Caption := Format('%.2f', [trackTemp.Position / 100.0]);
end;

procedure TfrmSettings.trackTopPChange(Sender: TObject);
begin
  lblTopPValue.Caption := Format('%.2f', [trackTopP.Position / 100.0]);
end;

procedure TfrmSettings.btnBrowseWorkspaceClick(Sender: TObject);
var
  Directory: string;
begin
  Directory := edtWorkspacePath.Text;

  if SelectDirectory('Select Workspace Folder', '', Directory, [sdNewUI, sdNewFolder]) then
    edtWorkspacePath.Text := Directory;
end;

procedure TfrmSettings.btnApplyClick(Sender: TObject);
begin
  SaveSettings;
  ShowMessage('Settings applied successfully');
end;

procedure TfrmSettings.btnSaveClick(Sender: TObject);
begin
  SaveSettings;
  Close;
end;

procedure TfrmSettings.btnCancelClick(Sender: TObject);
begin
  Close;
end;

end.
