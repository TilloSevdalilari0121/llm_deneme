unit CodeAssistant;

{$IFDEF FPC}
  {$MODE DELPHI}
{$ENDIF}

interface

uses
  System.SysUtils, System.Classes, System.IOUtils, SettingsManager;

type
  TFileInfo = record
    Name: string;
    Path: string;
    Extension: string;
    Size: Int64;
    IsDirectory: Boolean;
  end;

  TCodeAssistant = class
  private
    FWorkspacePath: string;
    class function GetRelativePath(const BasePath, FullPath: string): string;
  public
    constructor Create;

    // Workspace management
    procedure SetWorkspace(const Path: string);
    function GetWorkspace: string;
    function HasWorkspace: Boolean;

    // File operations
    function ListFiles(const SubPath: string = ''): TArray<TFileInfo>;
    function ReadFile(const RelativePath: string): string;
    procedure WriteFile(const RelativePath, Content: string);
    procedure DeleteFile(const RelativePath: string);
    function FileExists(const RelativePath: string): Boolean;

    // Directory operations
    procedure CreateDirectory(const RelativePath: string);
    function DirectoryExists(const RelativePath: string): Boolean;

    // Search
    function SearchInFiles(const SearchText: string; const FilePattern: string = '*.*'): TStringList;
    function FindFiles(const Pattern: string): TArray<string>;

    // Code analysis helpers
    function GetFileExtension(const FilePath: string): string;
    function IsCodeFile(const FilePath: string): Boolean;
    function GetCodeFiles: TArray<string>;
  end;

implementation

constructor TCodeAssistant.Create;
begin
  inherited Create;
  FWorkspacePath := TSettingsManager.GetWorkspacePath;
end;

procedure TCodeAssistant.SetWorkspace(const Path: string);
begin
  if not System.IOUtils.TDirectory.Exists(Path) then
    raise Exception.Create('Workspace path does not exist: ' + Path);

  FWorkspacePath := IncludeTrailingPathDelimiter(Path);
  TSettingsManager.SetWorkspacePath(FWorkspacePath);
end;

function TCodeAssistant.GetWorkspace: string;
begin
  Result := FWorkspacePath;
end;

function TCodeAssistant.HasWorkspace: Boolean;
begin
  Result := (FWorkspacePath <> '') and System.IOUtils.TDirectory.Exists(FWorkspacePath);
end;

class function TCodeAssistant.GetRelativePath(const BasePath, FullPath: string): string;
var
  Base, Full: string;
begin
  Base := IncludeTrailingPathDelimiter(ExpandFileName(BasePath));
  Full := ExpandFileName(FullPath);

  if Full.StartsWith(Base) then
    Result := Copy(Full, Length(Base) + 1, MaxInt)
  else
    Result := Full;
end;

function TCodeAssistant.ListFiles(const SubPath: string): TArray<TFileInfo>;
var
  SearchPath: string;
  SearchRec: TSearchRec;
  List: TList<TFileInfo>;
  Info: TFileInfo;
begin
  List := TList<TFileInfo>.Create;
  try
    if SubPath = '' then
      SearchPath := FWorkspacePath
    else
      SearchPath := IncludeTrailingPathDelimiter(FWorkspacePath + SubPath);

    if not System.IOUtils.TDirectory.Exists(SearchPath) then
      Exit(nil);

    if FindFirst(SearchPath + '*', faAnyFile, SearchRec) = 0 then
    begin
      repeat
        if (SearchRec.Name = '.') or (SearchRec.Name = '..') then
          Continue;

        Info.Name := SearchRec.Name;
        Info.Path := SearchPath + SearchRec.Name;
        Info.Extension := LowerCase(ExtractFileExt(SearchRec.Name));
        Info.IsDirectory := (SearchRec.Attr and faDirectory) <> 0;

        if Info.IsDirectory then
          Info.Size := 0
        else
          Info.Size := SearchRec.Size;

        List.Add(Info);
      until FindNext(SearchRec) <> 0;
      FindClose(SearchRec);
    end;

    Result := List.ToArray;
  finally
    List.Free;
  end;
end;

function TCodeAssistant.ReadFile(const RelativePath: string): string;
var
  FullPath: string;
begin
  FullPath := FWorkspacePath + RelativePath;

  if not System.IOUtils.TFile.Exists(FullPath) then
    raise Exception.Create('File not found: ' + RelativePath);

  Result := TFile.ReadAllText(FullPath);
end;

procedure TCodeAssistant.WriteFile(const RelativePath, Content: string);
var
  FullPath, DirPath: string;
begin
  FullPath := FWorkspacePath + RelativePath;
  DirPath := ExtractFilePath(FullPath);

  if not System.IOUtils.TDirectory.Exists(DirPath) then
    System.IOUtils.TDirectory.CreateDirectory(DirPath);

  TFile.WriteAllText(FullPath, Content);
end;

procedure TCodeAssistant.DeleteFile(const RelativePath: string);
var
  FullPath: string;
begin
  FullPath := FWorkspacePath + RelativePath;

  if System.IOUtils.TFile.Exists(FullPath) then
    System.IOUtils.TFile.Delete(FullPath);
end;

function TCodeAssistant.FileExists(const RelativePath: string): Boolean;
var
  FullPath: string;
begin
  FullPath := FWorkspacePath + RelativePath;
  Result := System.IOUtils.TFile.Exists(FullPath);
end;

procedure TCodeAssistant.CreateDirectory(const RelativePath: string);
var
  FullPath: string;
begin
  FullPath := FWorkspacePath + RelativePath;

  if not System.IOUtils.TDirectory.Exists(FullPath) then
    System.IOUtils.TDirectory.CreateDirectory(FullPath);
end;

function TCodeAssistant.DirectoryExists(const RelativePath: string): Boolean;
var
  FullPath: string;
begin
  FullPath := FWorkspacePath + RelativePath;
  Result := System.IOUtils.TDirectory.Exists(FullPath);
end;

function TCodeAssistant.SearchInFiles(const SearchText: string;
  const FilePattern: string): TStringList;
var
  Files: TArray<string>;
  FilePath, Line, RelPath: string;
  LineNum: Integer;
  FileLines: TStringList;
begin
  Result := TStringList.Create;

  Files := FindFiles(FilePattern);
  for FilePath in Files do
  begin
    try
      FileLines := TStringList.Create;
      try
        FileLines.LoadFromFile(FilePath);
        LineNum := 0;

        for Line in FileLines do
        begin
          Inc(LineNum);
          if Line.Contains(SearchText) then
          begin
            RelPath := GetRelativePath(FWorkspacePath, FilePath);
            Result.Add(Format('%s:%d: %s', [RelPath, LineNum, Line.Trim]));
          end;
        end;
      finally
        FileLines.Free;
      end;
    except
      // Skip files that can't be read
    end;
  end;
end;

function TCodeAssistant.FindFiles(const Pattern: string): TArray<string>;
begin
  if not HasWorkspace then
    Exit(nil);

  Result := TDirectory.GetFiles(FWorkspacePath, Pattern, TSearchOption.soAllDirectories);
end;

function TCodeAssistant.GetFileExtension(const FilePath: string): string;
begin
  Result := LowerCase(ExtractFileExt(FilePath));
end;

function TCodeAssistant.IsCodeFile(const FilePath: string): Boolean;
var
  Ext: string;
const
  CodeExtensions: array[0..19] of string = (
    '.pas', '.dpr', '.dfm', '.inc', '.pp',           // Delphi/Pascal
    '.c', '.cpp', '.h', '.hpp', '.cc',                // C/C++
    '.py', '.java', '.cs', '.js', '.ts',              // Python, Java, C#, JS/TS
    '.go', '.rs', '.rb', '.php', '.swift'             // Go, Rust, Ruby, PHP, Swift
  );
var
  CodeExt: string;
begin
  Ext := GetFileExtension(FilePath);
  for CodeExt in CodeExtensions do
  begin
    if Ext = CodeExt then
      Exit(True);
  end;
  Result := False;
end;

function TCodeAssistant.GetCodeFiles: TArray<string>;
var
  AllFiles: TArray<string>;
  CodeFiles: TList<string>;
  FilePath: string;
begin
  CodeFiles := TList<string>.Create;
  try
    AllFiles := FindFiles('*.*');
    for FilePath in AllFiles do
    begin
      if IsCodeFile(FilePath) then
        CodeFiles.Add(GetRelativePath(FWorkspacePath, FilePath));
    end;

    Result := CodeFiles.ToArray;
  finally
    CodeFiles.Free;
  end;
end;

end.
