unit WorkspaceForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls, System.IOUtils,
  WorkspaceManager;

type
  TfrmWorkspace = class(TForm)
    pnlTop: TPanel;
    pnlFiles: TPanel;
    pnlEditor: TPanel;
    Splitter1: TSplitter;
    lblWorkspace: TLabel;
    edtWorkspacePath: TEdit;
    btnBrowse: TButton;
    btnRefresh: TButton;
    treeFiles: TTreeView;
    lblFiles: TLabel;
    memoEditor: TMemo;
    lblEditor: TLabel;
    btnSave: TButton;
    btnNew: TButton;
    btnDelete: TButton;
    chkReadOnly: TCheckBox;
    lblStatus: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnNewClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure treeFilesClick(Sender: TObject);
  private
    FCurrentFile: string;
    FModified: Boolean;

    procedure LoadWorkspace(const Path: string);
    procedure AddFilesToTree(Node: TTreeNode; const Directory: string);
    procedure LoadFile(const FileName: string);
    procedure SaveFile;
    procedure SetModified(Value: Boolean);
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
  FCurrentFile := '';
  FModified := False;

  // Initialize workspace manager
  TWorkspaceManager.Initialize;

  // Load default workspace
  var DefaultPath := TWorkspaceManager.GetWorkspacePath;
  if DefaultPath <> '' then
  begin
    edtWorkspacePath.Text := DefaultPath;
    LoadWorkspace(DefaultPath);
  end;
end;

procedure TfrmWorkspace.btnBrowseClick(Sender: TObject);
var
  Directory: string;
begin
  Directory := edtWorkspacePath.Text;

  if SelectDirectory('Select Workspace Folder', '', Directory, [sdNewUI, sdNewFolder]) then
  begin
    edtWorkspacePath.Text := Directory;
    TWorkspaceManager.SetWorkspacePath(Directory);
    LoadWorkspace(Directory);
  end;
end;

procedure TfrmWorkspace.btnRefreshClick(Sender: TObject);
begin
  if edtWorkspacePath.Text <> '' then
    LoadWorkspace(edtWorkspacePath.Text);
end;

procedure TfrmWorkspace.LoadWorkspace(const Path: string);
begin
  if not TDirectory.Exists(Path) then
  begin
    ShowMessage('Directory does not exist: ' + Path);
    Exit;
  end;

  treeFiles.Items.Clear;

  var RootNode := treeFiles.Items.Add(nil, ExtractFileName(Path));
  RootNode.Data := Pointer(StrNew(PChar(Path)));

  AddFilesToTree(RootNode, Path);
  RootNode.Expand(False);

  lblStatus.Caption := 'Loaded workspace: ' + Path;
end;

procedure TfrmWorkspace.AddFilesToTree(Node: TTreeNode; const Directory: string);
var
  Files: TArray<string>;
  Dirs: TArray<string>;
  I: Integer;
  FileNode: TTreeNode;
begin
  // Add directories
  Dirs := TDirectory.GetDirectories(Directory);
  for I := 0 to High(Dirs) do
  begin
    var DirName := ExtractFileName(Dirs[I]);
    if (DirName <> '.') and (DirName <> '..') and (DirName <> '.git') then
    begin
      var DirNode := treeFiles.Items.AddChild(Node, DirName);
      DirNode.Data := Pointer(StrNew(PChar(Dirs[I])));
      DirNode.ImageIndex := 0;
      AddFilesToTree(DirNode, Dirs[I]);
    end;
  end;

  // Add files
  Files := TDirectory.GetFiles(Directory);
  for I := 0 to High(Files) do
  begin
    FileNode := treeFiles.Items.AddChild(Node, ExtractFileName(Files[I]));
    FileNode.Data := Pointer(StrNew(PChar(Files[I])));
    FileNode.ImageIndex := 1;
  end;
end;

procedure TfrmWorkspace.treeFilesClick(Sender: TObject);
var
  FilePath: string;
begin
  if treeFiles.Selected = nil then Exit;
  if treeFiles.Selected.Data = nil then Exit;

  FilePath := string(PChar(treeFiles.Selected.Data));

  if TFile.Exists(FilePath) then
  begin
    if FModified then
    begin
      if MessageDlg('Save changes to current file?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
        SaveFile;
    end;

    LoadFile(FilePath);
  end;
end;

procedure TfrmWorkspace.LoadFile(const FileName: string);
var
  Content: TStringList;
begin
  if not TFile.Exists(FileName) then
  begin
    ShowMessage('File not found: ' + FileName);
    Exit;
  end;

  // Check permissions
  if not TWorkspaceManager.CanReadFile(FileName) then
  begin
    ShowMessage('No read permission for: ' + FileName);
    Exit;
  end;

  Content := TStringList.Create;
  try
    Content.LoadFromFile(FileName);
    memoEditor.Lines.Text := Content.Text;
    FCurrentFile := FileName;
    lblEditor.Caption := 'Editing: ' + ExtractFileName(FileName);
    SetModified(False);

    // Set read-only if no write permission
    chkReadOnly.Checked := not TWorkspaceManager.CanWriteFile(FileName);
    memoEditor.ReadOnly := chkReadOnly.Checked;
  finally
    Content.Free;
  end;
end;

procedure TfrmWorkspace.SaveFile;
var
  Content: TStringList;
begin
  if FCurrentFile = '' then
  begin
    ShowMessage('No file is currently open.');
    Exit;
  end;

  if not TWorkspaceManager.CanWriteFile(FCurrentFile) then
  begin
    ShowMessage('No write permission for: ' + FCurrentFile);
    Exit;
  end;

  Content := TStringList.Create;
  try
    Content.Text := memoEditor.Lines.Text;
    Content.SaveToFile(FCurrentFile);
    SetModified(False);
    lblStatus.Caption := 'Saved: ' + ExtractFileName(FCurrentFile);
  finally
    Content.Free;
  end;
end;

procedure TfrmWorkspace.btnSaveClick(Sender: TObject);
begin
  SaveFile;
end;

procedure TfrmWorkspace.btnNewClick(Sender: TObject);
var
  FileName: string;
  FilePath: string;
begin
  FileName := InputBox('New File', 'Enter file name:', '');
  if Trim(FileName) = '' then Exit;

  FilePath := TPath.Combine(edtWorkspacePath.Text, FileName);

  if TFile.Exists(FilePath) then
  begin
    ShowMessage('File already exists: ' + FileName);
    Exit;
  end;

  // Create empty file
  var F: TextFile;
  AssignFile(F, FilePath);
  Rewrite(F);
  CloseFile(F);

  btnRefreshClick(nil);
  lblStatus.Caption := 'Created: ' + FileName;
end;

procedure TfrmWorkspace.btnDeleteClick(Sender: TObject);
var
  FilePath: string;
  FileName: string;
begin
  if treeFiles.Selected = nil then
  begin
    ShowMessage('Please select a file to delete.');
    Exit;
  end;

  if treeFiles.Selected.Data = nil then Exit;

  FilePath := string(PChar(treeFiles.Selected.Data));
  FileName := ExtractFileName(FilePath);

  if not TFile.Exists(FilePath) then
  begin
    ShowMessage('Not a file or does not exist.');
    Exit;
  end;

  if not TWorkspaceManager.CanDeleteFile(FilePath) then
  begin
    ShowMessage('No delete permission for: ' + FileName);
    Exit;
  end;

  if MessageDlg('Delete file "' + FileName + '"?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    TFile.Delete(FilePath);
    btnRefreshClick(nil);
    memoEditor.Clear;
    FCurrentFile := '';
    lblStatus.Caption := 'Deleted: ' + FileName;
  end;
end;

procedure TfrmWorkspace.SetModified(Value: Boolean);
begin
  FModified := Value;
  if Value then
    lblEditor.Caption := lblEditor.Caption + ' *';
end;

end.
