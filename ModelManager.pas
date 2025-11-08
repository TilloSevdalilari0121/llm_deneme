unit ModelManager;

{$IFDEF FPC}
  {$MODE DELPHI}
{$ENDIF}

interface

uses
  System.SysUtils, System.Classes, System.IOUtils, DatabaseManager;

type
  TModelInfo = record
    ID: Int64;
    Name: string;
    Path: string;
    ModelType: string;
    SizeBytes: Int64;
    SizeFormatted: string;
  end;

  TModelManager = class
  private
    class function FormatFileSize(Bytes: Int64): string;
    class function GetModelName(const FilePath: string): string;
    class function IsGGUFFile(const FilePath: string): Boolean;
  public
    // Model discovery
    class function ScanDirectory(const DirPath: string): TArray<string>;
    class function ScanOllamaModels(const OllamaPath: string): TArray<string>;
    class function ScanLMStudioModels(const LMStudioPath: string): TArray<string>;
    class function ScanJanModels(const JanPath: string): TArray<string>;

    // Model management
    class procedure AddModel(const FilePath: string);
    class procedure RemoveModel(ModelID: Int64);
    class function GetAllModels: TArray<TModelInfo>;
    class function GetModelInfo(const FilePath: string): TModelInfo;
    class function ModelExists(const FilePath: string): Boolean;

    // Model validation
    class function ValidateGGUFFile(const FilePath: string): Boolean;
  end;

implementation

class function TModelManager.FormatFileSize(Bytes: Int64): string;
const
  KB = 1024;
  MB = KB * 1024;
  GB = MB * 1024;
begin
  if Bytes >= GB then
    Result := Format('%.2f GB', [Bytes / GB])
  else if Bytes >= MB then
    Result := Format('%.2f MB', [Bytes / MB])
  else if Bytes >= KB then
    Result := Format('%.2f KB', [Bytes / KB])
  else
    Result := Format('%d bytes', [Bytes]);
end;

class function TModelManager.GetModelName(const FilePath: string): string;
begin
  Result := TPath.GetFileNameWithoutExtension(FilePath);
end;

class function TModelManager.IsGGUFFile(const FilePath: string): Boolean;
var
  Ext: string;
begin
  Ext := LowerCase(TPath.GetExtension(FilePath));
  Result := (Ext = '.gguf') or (Ext = '.bin');
end;

class function TModelManager.ValidateGGUFFile(const FilePath: string): Boolean;
var
  FileStream: TFileStream;
  Magic: array[0..3] of AnsiChar;
begin
  Result := False;

  if not FileExists(FilePath) then Exit;
  if not IsGGUFFile(FilePath) then Exit;

  try
    FileStream := TFileStream.Create(FilePath, fmOpenRead or fmShareDenyNone);
    try
      if FileStream.Size < 4 then Exit;

      FileStream.Read(Magic, 4);
      // GGUF magic: 'GGUF'
      Result := (Magic[0] = 'G') and (Magic[1] = 'G') and
                (Magic[2] = 'U') and (Magic[3] = 'F');
    finally
      FileStream.Free;
    end;
  except
    Result := False;
  end;
end;

class function TModelManager.ScanDirectory(const DirPath: string): TArray<string>;
var
  SearchRec: TSearchRec;
  List: TStringList;
  FilePath: string;
begin
  List := TStringList.Create;
  try
    if FindFirst(IncludeTrailingPathDelimiter(DirPath) + '*.*', faAnyFile, SearchRec) = 0 then
    begin
      repeat
        if (SearchRec.Attr and faDirectory) = 0 then
        begin
          if IsGGUFFile(SearchRec.Name) then
          begin
            FilePath := IncludeTrailingPathDelimiter(DirPath) + SearchRec.Name;
            if ValidateGGUFFile(FilePath) then
              List.Add(FilePath);
          end;
        end;
      until FindNext(SearchRec) <> 0;
      FindClose(SearchRec);
    end;

    Result := List.ToStringArray;
  finally
    List.Free;
  end;
end;

class function TModelManager.ScanOllamaModels(const OllamaPath: string): TArray<string>;
var
  ModelsDir: string;
  List: TStringList;
  SearchRec: TSearchRec;
  BlobsDir, FilePath: string;
begin
  List := TStringList.Create;
  try
    if OllamaPath = '' then Exit(nil);

    // Ollama stores models in: <path>\models\blobs\
    ModelsDir := IncludeTrailingPathDelimiter(OllamaPath);
    BlobsDir := ModelsDir + 'models\blobs\';

    if not DirectoryExists(BlobsDir) then Exit(nil);

    if FindFirst(BlobsDir + '*', faAnyFile, SearchRec) = 0 then
    begin
      repeat
        if (SearchRec.Attr and faDirectory) = 0 then
        begin
          FilePath := BlobsDir + SearchRec.Name;
          // Ollama blobs might not have extension, check magic number
          if ValidateGGUFFile(FilePath) then
            List.Add(FilePath);
        end;
      until FindNext(SearchRec) <> 0;
      FindClose(SearchRec);
    end;

    Result := List.ToStringArray;
  finally
    List.Free;
  end;
end;

class function TModelManager.ScanLMStudioModels(const LMStudioPath: string): TArray<string>;
var
  ModelsDir: string;
begin
  if LMStudioPath = '' then Exit(nil);

  // LM Studio: <path>\.cache\lm-studio\models\
  ModelsDir := IncludeTrailingPathDelimiter(LMStudioPath);
  if DirectoryExists(ModelsDir) then
    Result := ScanDirectory(ModelsDir)
  else
    Result := nil;
end;

class function TModelManager.ScanJanModels(const JanPath: string): TArray<string>;
var
  ModelsDir: string;
begin
  if JanPath = '' then Exit(nil);

  // Jan: <path>\jan\models\
  ModelsDir := IncludeTrailingPathDelimiter(JanPath);
  if DirectoryExists(ModelsDir) then
    Result := ScanDirectory(ModelsDir)
  else
    Result := nil;
end;

class procedure TModelManager.AddModel(const FilePath: string);
var
  Name, ModelType: string;
  Size: Int64;
begin
  if not FileExists(FilePath) then
    raise Exception.Create('Model file not found: ' + FilePath);

  if not ValidateGGUFFile(FilePath) then
    raise Exception.Create('Invalid GGUF file: ' + FilePath);

  if TDatabaseManager.ModelExists(FilePath) then
    Exit; // Already exists

  Name := GetModelName(FilePath);
  ModelType := 'GGUF';
  Size := TFile.GetSize(FilePath);

  TDatabaseManager.SaveModel(Name, FilePath, ModelType, Size);
end;

class procedure TModelManager.RemoveModel(ModelID: Int64);
begin
  TDatabaseManager.DeleteModel(ModelID);
end;

class function TModelManager.GetAllModels: TArray<TModelInfo>;
var
  List: TStringList;
  Info: TModelInfo;
  Parts: TArray<string>;
  I: Integer;
  Models: TList<TModelInfo>;
begin
  Models := TList<TModelInfo>.Create;
  try
    List := TDatabaseManager.GetAllModels;
    try
      for I := 0 to List.Count - 1 do
      begin
        Parts := List[I].Split(['|']);
        if Length(Parts) = 5 then
        begin
          Info.ID := StrToInt64(Parts[0]);
          Info.Name := Parts[1];
          Info.Path := Parts[2];
          Info.ModelType := Parts[3];
          Info.SizeBytes := StrToInt64(Parts[4]);
          Info.SizeFormatted := FormatFileSize(Info.SizeBytes);
          Models.Add(Info);
        end;
      end;
    finally
      List.Free;
    end;

    Result := Models.ToArray;
  finally
    Models.Free;
  end;
end;

class function TModelManager.GetModelInfo(const FilePath: string): TModelInfo;
begin
  Result.ID := -1;
  Result.Name := GetModelName(FilePath);
  Result.Path := FilePath;
  Result.ModelType := 'GGUF';

  if FileExists(FilePath) then
  begin
    Result.SizeBytes := TFile.GetSize(FilePath);
    Result.SizeFormatted := FormatFileSize(Result.SizeBytes);
  end
  else
  begin
    Result.SizeBytes := 0;
    Result.SizeFormatted := 'Unknown';
  end;
end;

class function TModelManager.ModelExists(const FilePath: string): Boolean;
begin
  Result := TDatabaseManager.ModelExists(FilePath);
end;

end.
