unit WorkspaceManager;

interface

uses
  System.SysUtils, System.Classes, System.IOUtils, SettingsManager;

type
  TWorkspaceManager = class
  private
    class var FWorkspacePath: string;
  public
    class procedure Initialize;
    class procedure SetWorkspace(const Path: string);
    class function GetWorkspace: string;
    class function HasWorkspace: Boolean;
    
    class function ReadFile(const RelativePath: string): string;
    class procedure WriteFile(const RelativePath, Content: string);
    class procedure DeleteFile(const RelativePath: string);
    class function FileExists(const RelativePath: string): Boolean;
    class function ListFiles(const SubPath: string = ''): TArray<string>;
  end;

implementation

class procedure TWorkspaceManager.Initialize;
begin
  FWorkspacePath := TSettingsManager.GetWorkspacePath;
end;

class procedure TWorkspaceManager.SetWorkspace(const Path: string);
begin
  if not DirectoryExists(Path) then
    raise Exception.Create('Workspace path does not exist');
  FWorkspacePath := IncludeTrailingPathDelimiter(Path);
  TSettingsManager.SetWorkspacePath(FWorkspacePath);
end;

class function TWorkspaceManager.GetWorkspace: string;
begin
  Result := FWorkspacePath;
end;

class function TWorkspaceManager.HasWorkspace: Boolean;
begin
  Result := (FWorkspacePath <> '') and DirectoryExists(FWorkspacePath);
end;

class function TWorkspaceManager.ReadFile(const RelativePath: string): string;
begin
  Result := TFile.ReadAllText(FWorkspacePath + RelativePath);
end;

class procedure TWorkspaceManager.WriteFile(const RelativePath, Content: string);
begin
  TFile.WriteAllText(FWorkspacePath + RelativePath, Content);
end;

class procedure TWorkspaceManager.DeleteFile(const RelativePath: string);
begin
  System.SysUtils.DeleteFile(FWorkspacePath + RelativePath);
end;

class function TWorkspaceManager.FileExists(const RelativePath: string): Boolean;
begin
  Result := System.SysUtils.FileExists(FWorkspacePath + RelativePath);
end;

class function TWorkspaceManager.ListFiles(const SubPath: string): TArray<string>;
begin
  if not HasWorkspace then Exit(nil);
  Result := TDirectory.GetFiles(FWorkspacePath + SubPath, '*.*', TSearchOption.soAllDirectories);
end;

end.
