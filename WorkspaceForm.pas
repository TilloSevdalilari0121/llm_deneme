unit WorkspaceForm;

{$IFDEF FPC}
  {$MODE DELPHI}
{$ENDIF}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  CodeAssistant;

type
  TfrmWorkspace = class(TForm)
    pnlTop: TPanel;
    edtWorkspacePath: TEdit;
    btnBrowse: TButton;
    btnSet: TButton;
    lblWorkspace: TLabel;
    lstFiles: TListBox;
    pnlBottom: TPanel;
    btnClose: TButton;
    lblInfo: TLabel;
    btnRefresh: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure btnSetClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
  private
    FCodeAssistant: TCodeAssistant;
    procedure LoadWorkspaceFiles;
  public
    { Public declarations }
  end;

var
  frmWorkspace: TfrmWorkspace;

implementation

uses
  Vcl.FileCtrl;

{$R *.dfm}

procedure TfrmWorkspace.FormCreate(Sender: TObject);
begin
  FCodeAssistant := TCodeAssistant.Create;
  edtWorkspacePath.Text := FCodeAssistant.GetWorkspace;

  if FCodeAssistant.HasWorkspace then
    LoadWorkspaceFiles;
end;

procedure TfrmWorkspace.btnBrowseClick(Sender: TObject);
var
  Dir: string;
begin
  Dir := edtWorkspacePath.Text;
  if SelectDirectory('Select Workspace Folder', '', Dir) then
    edtWorkspacePath.Text := Dir;
end;

procedure TfrmWorkspace.btnSetClick(Sender: TObject);
begin
  if edtWorkspacePath.Text = '' then
  begin
    ShowMessage('Please select a folder!');
    Exit;
  end;

  if not DirectoryExists(edtWorkspacePath.Text) then
  begin
    ShowMessage('Directory does not exist!');
    Exit;
  end;

  try
    FCodeAssistant.SetWorkspace(edtWorkspacePath.Text);
    LoadWorkspaceFiles;
    ShowMessage('Workspace set successfully!');
  except
    on E: Exception do
      ShowMessage('Error setting workspace: ' + E.Message);
  end;
end;

procedure TfrmWorkspace.LoadWorkspaceFiles;
var
  Files: TArray<TFileInfo>;
  FileInfo: TFileInfo;
  Ext: string;
begin
  lstFiles.Clear;

  if not FCodeAssistant.HasWorkspace then
  begin
    lblInfo.Caption := 'No workspace set';
    Exit;
  end;

  Files := FCodeAssistant.ListFiles('');

  for FileInfo in Files do
  begin
    if FileInfo.IsDirectory then
      lstFiles.Items.Add('[DIR] ' + FileInfo.Name)
    else
    begin
      Ext := LowerCase(FileInfo.Extension);
      if FCodeAssistant.IsCodeFile(FileInfo.Path) then
        lstFiles.Items.Add('[CODE] ' + FileInfo.Name)
      else
        lstFiles.Items.Add(FileInfo.Name);
    end;
  end;

  lblInfo.Caption := Format('Workspace: %s (%d items)', [FCodeAssistant.GetWorkspace, Length(Files)]);
end;

procedure TfrmWorkspace.btnRefreshClick(Sender: TObject);
begin
  LoadWorkspaceFiles;
end;

procedure TfrmWorkspace.btnCloseClick(Sender: TObject);
begin
  Close;
end;

end.
