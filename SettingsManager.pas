unit SettingsManager;

{$IFDEF FPC}
  {$MODE DELPHI}
{$ENDIF}

interface

uses
  System.SysUtils, DatabaseManager;

type
  TSettingsManager = class
  public
    // First run
    class function IsFirstRun: Boolean;
    class procedure SetFirstRunComplete;

    // Theme
    class function GetThemeMode: Integer;
    class procedure SetThemeMode(Value: Integer);
    class function GetColorScheme: Integer;
    class procedure SetColorScheme(Value: Integer);

    // Model paths
    class function GetOllamaPath: string;
    class procedure SetOllamaPath(const Value: string);
    class function GetLMStudioPath: string;
    class procedure SetLMStudioPath(const Value: string);
    class function GetJanPath: string;
    class procedure SetJanPath(const Value: string);
    class function GetCustomModelPath: string;
    class procedure SetCustomModelPath(const Value: string);

    // Workspace
    class function GetWorkspacePath: string;
    class procedure SetWorkspacePath(const Value: string);

    // Inference settings
    class function GetDefaultTemperature: Double;
    class procedure SetDefaultTemperature(Value: Double);
    class function GetDefaultTopP: Double;
    class procedure SetDefaultTopP(Value: Double);
    class function GetDefaultTopK: Integer;
    class procedure SetDefaultTopK(Value: Integer);
    class function GetDefaultMaxTokens: Integer;
    class procedure SetDefaultMaxTokens(Value: Integer);
    class function GetDefaultContextSize: Integer;
    class procedure SetDefaultContextSize(Value: Integer);

    // GPU settings
    class function GetGPULayers: Integer;
    class procedure SetGPULayers(Value: Integer);
    class function GetMainGPU: Integer;
    class procedure SetMainGPU(Value: Integer);
    class function GetThreads: Integer;
    class procedure SetThreads(Value: Integer);

    // Last used model
    class function GetLastModelPath: string;
    class procedure SetLastModelPath(const Value: string);

    // Current conversation
    class function GetCurrentConversationID: Int64;
    class procedure SetCurrentConversationID(Value: Int64);

    // Initialize with defaults
    class procedure Initialize;
  end;

implementation

const
  KEY_FIRST_RUN = 'first_run';
  KEY_THEME_MODE = 'theme_mode';
  KEY_COLOR_SCHEME = 'color_scheme';
  KEY_OLLAMA_PATH = 'ollama_path';
  KEY_LMSTUDIO_PATH = 'lmstudio_path';
  KEY_JAN_PATH = 'jan_path';
  KEY_CUSTOM_MODEL_PATH = 'custom_model_path';
  KEY_WORKSPACE_PATH = 'workspace_path';
  KEY_TEMPERATURE = 'default_temperature';
  KEY_TOP_P = 'default_top_p';
  KEY_TOP_K = 'default_top_k';
  KEY_MAX_TOKENS = 'default_max_tokens';
  KEY_CONTEXT_SIZE = 'default_context_size';
  KEY_GPU_LAYERS = 'gpu_layers';
  KEY_MAIN_GPU = 'main_gpu';
  KEY_THREADS = 'threads';
  KEY_LAST_MODEL = 'last_model_path';
  KEY_CURRENT_CONVERSATION = 'current_conversation_id';

class procedure TSettingsManager.Initialize;
begin
  // Set defaults if not exists
  if TDatabaseManager.GetSetting(KEY_FIRST_RUN, '1') = '1' then
  begin
    SetThemeMode(1); // Dark mode
    SetColorScheme(0); // Blue/Gray
    SetDefaultTemperature(0.7);
    SetDefaultTopP(0.9);
    SetDefaultTopK(40);
    SetDefaultMaxTokens(2048);
    SetDefaultContextSize(4096);
    SetGPULayers(32); // Default GPU offload
    SetMainGPU(0);
    SetThreads(8);
  end;
end;

class function TSettingsManager.IsFirstRun: Boolean;
begin
  Result := TDatabaseManager.GetSetting(KEY_FIRST_RUN, '1') = '1';
end;

class procedure TSettingsManager.SetFirstRunComplete;
begin
  TDatabaseManager.SetSetting(KEY_FIRST_RUN, '0');
end;

class function TSettingsManager.GetThemeMode: Integer;
begin
  Result := StrToIntDef(TDatabaseManager.GetSetting(KEY_THEME_MODE, '1'), 1);
end;

class procedure TSettingsManager.SetThemeMode(Value: Integer);
begin
  TDatabaseManager.SetSetting(KEY_THEME_MODE, IntToStr(Value));
end;

class function TSettingsManager.GetColorScheme: Integer;
begin
  Result := StrToIntDef(TDatabaseManager.GetSetting(KEY_COLOR_SCHEME, '0'), 0);
end;

class procedure TSettingsManager.SetColorScheme(Value: Integer);
begin
  TDatabaseManager.SetSetting(KEY_COLOR_SCHEME, IntToStr(Value));
end;

class function TSettingsManager.GetOllamaPath: string;
begin
  Result := TDatabaseManager.GetSetting(KEY_OLLAMA_PATH, '');
end;

class procedure TSettingsManager.SetOllamaPath(const Value: string);
begin
  TDatabaseManager.SetSetting(KEY_OLLAMA_PATH, Value);
end;

class function TSettingsManager.GetLMStudioPath: string;
begin
  Result := TDatabaseManager.GetSetting(KEY_LMSTUDIO_PATH, '');
end;

class procedure TSettingsManager.SetLMStudioPath(const Value: string);
begin
  TDatabaseManager.SetSetting(KEY_LMSTUDIO_PATH, Value);
end;

class function TSettingsManager.GetJanPath: string;
begin
  Result := TDatabaseManager.GetSetting(KEY_JAN_PATH, '');
end;

class procedure TSettingsManager.SetJanPath(const Value: string);
begin
  TDatabaseManager.SetSetting(KEY_JAN_PATH, Value);
end;

class function TSettingsManager.GetCustomModelPath: string;
begin
  Result := TDatabaseManager.GetSetting(KEY_CUSTOM_MODEL_PATH, '');
end;

class procedure TSettingsManager.SetCustomModelPath(const Value: string);
begin
  TDatabaseManager.SetSetting(KEY_CUSTOM_MODEL_PATH, Value);
end;

class function TSettingsManager.GetWorkspacePath: string;
begin
  Result := TDatabaseManager.GetSetting(KEY_WORKSPACE_PATH, '');
end;

class procedure TSettingsManager.SetWorkspacePath(const Value: string);
begin
  TDatabaseManager.SetSetting(KEY_WORKSPACE_PATH, Value);
end;

class function TSettingsManager.GetDefaultTemperature: Double;
var
  S: string;
begin
  S := TDatabaseManager.GetSetting(KEY_TEMPERATURE, '0.7');
  Result := StrToFloatDef(S, 0.7);
end;

class procedure TSettingsManager.SetDefaultTemperature(Value: Double);
begin
  TDatabaseManager.SetSetting(KEY_TEMPERATURE, FloatToStr(Value));
end;

class function TSettingsManager.GetDefaultTopP: Double;
var
  S: string;
begin
  S := TDatabaseManager.GetSetting(KEY_TOP_P, '0.9');
  Result := StrToFloatDef(S, 0.9);
end;

class procedure TSettingsManager.SetDefaultTopP(Value: Double);
begin
  TDatabaseManager.SetSetting(KEY_TOP_P, FloatToStr(Value));
end;

class function TSettingsManager.GetDefaultTopK: Integer;
begin
  Result := StrToIntDef(TDatabaseManager.GetSetting(KEY_TOP_K, '40'), 40);
end;

class procedure TSettingsManager.SetDefaultTopK(Value: Integer);
begin
  TDatabaseManager.SetSetting(KEY_TOP_K, IntToStr(Value));
end;

class function TSettingsManager.GetDefaultMaxTokens: Integer;
begin
  Result := StrToIntDef(TDatabaseManager.GetSetting(KEY_MAX_TOKENS, '2048'), 2048);
end;

class procedure TSettingsManager.SetDefaultMaxTokens(Value: Integer);
begin
  TDatabaseManager.SetSetting(KEY_MAX_TOKENS, IntToStr(Value));
end;

class function TSettingsManager.GetDefaultContextSize: Integer;
begin
  Result := StrToIntDef(TDatabaseManager.GetSetting(KEY_CONTEXT_SIZE, '4096'), 4096);
end;

class procedure TSettingsManager.SetDefaultContextSize(Value: Integer);
begin
  TDatabaseManager.SetSetting(KEY_CONTEXT_SIZE, IntToStr(Value));
end;

class function TSettingsManager.GetGPULayers: Integer;
begin
  Result := StrToIntDef(TDatabaseManager.GetSetting(KEY_GPU_LAYERS, '32'), 32);
end;

class procedure TSettingsManager.SetGPULayers(Value: Integer);
begin
  TDatabaseManager.SetSetting(KEY_GPU_LAYERS, IntToStr(Value));
end;

class function TSettingsManager.GetMainGPU: Integer;
begin
  Result := StrToIntDef(TDatabaseManager.GetSetting(KEY_MAIN_GPU, '0'), 0);
end;

class procedure TSettingsManager.SetMainGPU(Value: Integer);
begin
  TDatabaseManager.SetSetting(KEY_MAIN_GPU, IntToStr(Value));
end;

class function TSettingsManager.GetThreads: Integer;
begin
  Result := StrToIntDef(TDatabaseManager.GetSetting(KEY_THREADS, '8'), 8);
end;

class procedure TSettingsManager.SetThreads(Value: Integer);
begin
  TDatabaseManager.SetSetting(KEY_THREADS, IntToStr(Value));
end;

class function TSettingsManager.GetLastModelPath: string;
begin
  Result := TDatabaseManager.GetSetting(KEY_LAST_MODEL, '');
end;

class procedure TSettingsManager.SetLastModelPath(const Value: string);
begin
  TDatabaseManager.SetSetting(KEY_LAST_MODEL, Value);
end;

class function TSettingsManager.GetCurrentConversationID: Int64;
begin
  Result := StrToInt64Def(TDatabaseManager.GetSetting(KEY_CURRENT_CONVERSATION, '-1'), -1);
end;

class procedure TSettingsManager.SetCurrentConversationID(Value: Int64);
begin
  TDatabaseManager.SetSetting(KEY_CURRENT_CONVERSATION, IntToStr(Value));
end;

end.
