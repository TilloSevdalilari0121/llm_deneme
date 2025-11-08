unit FirstRunWizard;

{$IFDEF FPC}
  {$MODE DELPHI}
{$ENDIF}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls, SettingsManager;

type
  TfrmFirstRunWizard = class(TForm)
    pgcWizard: TPageControl;
    tsWelcome: TTabSheet;
    tsModelPaths: TTabSheet;
    tsGPU: TTabSheet;
    tsComplete: TTabSheet;
    pnlButtons: TPanel;
    btnNext: TButton;
    btnBack: TButton;
    btnFinish: TButton;
    btnCancel: TButton;
    // Welcome page
    lblWelcome: TLabel;
    memoWelcome: TMemo;
    // Model paths page
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
    lblModelPathsInfo: TLabel;
    // GPU page
    chkGPUOffload: TCheckBox;
    lblGPULayers: TLabel;
    edtGPULayers: TEdit;
    lblThreads: TLabel;
    edtThreads: TEdit;
    lblGPUInfo: TLabel;
    // Complete page
    lblComplete: TLabel;
    memoComplete: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure btnFinishClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure pgcWizardChange(Sender: TObject);
    procedure btnBrowseOllamaClick(Sender: TObject);
    procedure btnBrowseLMStudioClick(Sender: TObject);
    procedure btnBrowseJanClick(Sender: TObject);
    procedure btnBrowseCustomClick(Sender: TObject);
    procedure chkGPUOffloadClick(Sender: TObject);
  private
    procedure UpdateButtons;
    procedure BrowseFolder(Edit: TEdit);
    procedure SaveSettings;
  public
    { Public declarations }
  end;

var
  frmFirstRunWizard: TfrmFirstRunWizard;

implementation

uses
  Vcl.FileCtrl;

{$R *.dfm}

procedure TfrmFirstRunWizard.FormCreate(Sender: TObject);
begin
  pgcWizard.ActivePageIndex := 0;
  UpdateButtons;

  // Set defaults
  edtGPULayers.Text := '32';
  edtThreads.Text := '8';
  chkGPUOffload.Checked := True;
end;

procedure TfrmFirstRunWizard.UpdateButtons;
var
  PageIndex: Integer;
begin
  PageIndex := pgcWizard.ActivePageIndex;

  btnBack.Enabled := PageIndex > 0;
  btnNext.Visible := PageIndex < pgcWizard.PageCount - 1;
  btnFinish.Visible := PageIndex = pgcWizard.PageCount - 1;
end;

procedure TfrmFirstRunWizard.pgcWizardChange(Sender: TObject);
begin
  UpdateButtons;
end;

procedure TfrmFirstRunWizard.btnNextClick(Sender: TObject);
begin
  if pgcWizard.ActivePageIndex < pgcWizard.PageCount - 1 then
  begin
    pgcWizard.ActivePageIndex := pgcWizard.ActivePageIndex + 1;
    UpdateButtons;
  end;
end;

procedure TfrmFirstRunWizard.btnBackClick(Sender: TObject);
begin
  if pgcWizard.ActivePageIndex > 0 then
  begin
    pgcWizard.ActivePageIndex := pgcWizard.ActivePageIndex - 1;
    UpdateButtons;
  end;
end;

procedure TfrmFirstRunWizard.btnFinishClick(Sender: TObject);
begin
  SaveSettings;
  ModalResult := mrOK;
end;

procedure TfrmFirstRunWizard.btnCancelClick(Sender: TObject);
begin
  if MessageDlg('Are you sure you want to cancel setup?', mtConfirmation,
    [mbYes, mbNo], 0) = mrYes then
    ModalResult := mrCancel;
end;

procedure TfrmFirstRunWizard.SaveSettings;
begin
  // Model paths
  TSettingsManager.SetOllamaPath(edtOllamaPath.Text);
  TSettingsManager.SetLMStudioPath(edtLMStudioPath.Text);
  TSettingsManager.SetJanPath(edtJanPath.Text);
  TSettingsManager.SetCustomModelPath(edtCustomPath.Text);

  // GPU settings
  if chkGPUOffload.Checked then
    TSettingsManager.SetGPULayers(StrToIntDef(edtGPULayers.Text, 32))
  else
    TSettingsManager.SetGPULayers(0);

  TSettingsManager.SetThreads(StrToIntDef(edtThreads.Text, 8));
end;

procedure TfrmFirstRunWizard.BrowseFolder(Edit: TEdit);
var
  Dir: string;
begin
  Dir := Edit.Text;
  if SelectDirectory('Select Folder', '', Dir) then
    Edit.Text := Dir;
end;

procedure TfrmFirstRunWizard.btnBrowseOllamaClick(Sender: TObject);
begin
  BrowseFolder(edtOllamaPath);
end;

procedure TfrmFirstRunWizard.btnBrowseLMStudioClick(Sender: TObject);
begin
  BrowseFolder(edtLMStudioPath);
end;

procedure TfrmFirstRunWizard.btnBrowseJanClick(Sender: TObject);
begin
  BrowseFolder(edtJanPath);
end;

procedure TfrmFirstRunWizard.btnBrowseCustomClick(Sender: TObject);
begin
  BrowseFolder(edtCustomPath);
end;

procedure TfrmFirstRunWizard.chkGPUOffloadClick(Sender: TObject);
begin
  edtGPULayers.Enabled := chkGPUOffload.Checked;
  if chkGPUOffload.Checked and (edtGPULayers.Text = '0') then
    edtGPULayers.Text := '32';
end;

end.
