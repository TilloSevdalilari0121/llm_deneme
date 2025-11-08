unit SettingsManager;

interface

uses
  System.SysUtils, DatabaseManager;

type
  TSettingsManager = class
  public
    class procedure Initialize;

    // API Settings
    class function GetOllamaURL: string;
    class procedure SetOllamaURL(const Value: string);
    class function GetLMStudioURL: string;
    class procedure SetLMStudioURL(const Value: string);
    class function GetJanURL: string;
    class procedure SetJanURL(const Value: string);

    // Current Provider
    class function GetCurrentProvider: Integer; // 0=Ollama, 1=LM, 2=Jan
    class procedure SetCurrentProvider(Value: Integer);
    class function GetCurrentModel: string;
    class procedure SetCurrentModel(const Value: string);

    // Inference Parameters
    class function GetTemperature: Double;
    class procedure SetTemperature(Value: Double);
    class function GetMaxTokens: Integer;
    class procedure SetMaxTokens(Value: Integer);
    class function GetTopP: Double;
    class procedure SetTopP(Value: Double);
    class function GetTopK: Integer;
    class procedure SetTopK(Value: Integer);

    // UI Settings
    class function GetThemeMode: Integer;
    class procedure SetThemeMode(Value: Integer);
    class function GetThemeID: Integer;
    class procedure SetThemeID(Value: Integer);
    class function GetUIMode: Integer; // 0=Professional, 1=Fancy
    class procedure SetUIMode(Value: Integer);

    // Current Conversation
    class function GetCurrentConversationID: Int64;
    class procedure SetCurrentConversationID(Value: Int64);

    // Workspace
    class function GetWorkspacePath: string;
    class procedure SetWorkspacePath(const Value: string);

    // Code Execution
    class function GetPythonPath: string;
    class procedure SetPythonPath(const Value: string);
    class function GetCodeExecutionEnabled: Boolean;
    class procedure SetCodeExecutionEnabled(Value: Boolean);

    // RAG Settings
    class function GetRAGEnabled: Boolean;
    class procedure SetRAGEnabled(Value: Boolean);
    class function GetEmbeddingModel: string;
    class procedure SetEmbeddingModel(const Value: string);

    // Performance
    class function GetTokenCostPerMillion: Double;
    class procedure SetTokenCostPerMillion(Value: Double);
  end;

implementation

const
  // API URLs
  KEY_OLLAMA_URL = 'ollama_url';
  KEY_LMSTUDIO_URL = 'lmstudio_url';
  KEY_JAN_URL = 'jan_url';

  // Current
  KEY_PROVIDER = 'current_provider';
  KEY_MODEL = 'current_model';

  // Inference
  KEY_TEMPERATURE = 'temperature';
  KEY_MAX_TOKENS = 'max_tokens';
  KEY_TOP_P = 'top_p';
  KEY_TOP_K = 'top_k';

  // UI
  KEY_THEME_MODE = 'theme_mode';
  KEY_THEME_ID = 'theme_id';
  KEY_UI_MODE = 'ui_mode';

  // Current Conversation
  KEY_CURRENT_CONV = 'current_conversation_id';

  // Workspace
  KEY_WORKSPACE = 'workspace_path';

  // Code Execution
  KEY_PYTHON_PATH = 'python_path';
  KEY_CODE_EXEC = 'code_execution_enabled';

  // RAG
  KEY_RAG_ENABLED = 'rag_enabled';
  KEY_EMBEDDING_MODEL = 'embedding_model';

  // Performance
  KEY_TOKEN_COST = 'token_cost_per_million';

class procedure TSettingsManager.Initialize;
begin
  // Set defaults if not exists
  if TDatabaseManager.GetSetting(KEY_OLLAMA_URL, '') = '' then
  begin
    SetOllamaURL('http://localhost:11434');
    SetLMStudioURL('http://localhost:1234/v1');
    SetJanURL('http://localhost:1337/v1');
    SetCurrentProvider(0);
    SetTemperature(0.7);
    SetMaxTokens(2048);
    SetTopP(0.9);
    SetTopK(40);
    SetThemeMode(1); // Dark
    SetThemeID(0); // First theme
    SetUIMode(0); // Professional
    SetCodeExecutionEnabled(False);
    SetRAGEnabled(False);
    SetTokenCostPerMillion(0.0);
  end;
end;

// API Settings
class function TSettingsManager.GetOllamaURL: string;
begin
  Result := TDatabaseManager.GetSetting(KEY_OLLAMA_URL, 'http://localhost:11434');
end;

class procedure TSettingsManager.SetOllamaURL(const Value: string);
begin
  TDatabaseManager.SetSetting(KEY_OLLAMA_URL, Value);
end;

class function TSettingsManager.GetLMStudioURL: string;
begin
  Result := TDatabaseManager.GetSetting(KEY_LMSTUDIO_URL, 'http://localhost:1234/v1');
end;

class procedure TSettingsManager.SetLMStudioURL(const Value: string);
begin
  TDatabaseManager.SetSetting(KEY_LMSTUDIO_URL, Value);
end;

class function TSettingsManager.GetJanURL: string;
begin
  Result := TDatabaseManager.GetSetting(KEY_JAN_URL, 'http://localhost:1337/v1');
end;

class procedure TSettingsManager.SetJanURL(const Value: string);
begin
  TDatabaseManager.SetSetting(KEY_JAN_URL, Value);
end;

// Current Provider
class function TSettingsManager.GetCurrentProvider: Integer;
begin
  Result := StrToIntDef(TDatabaseManager.GetSetting(KEY_PROVIDER, '0'), 0);
end;

class procedure TSettingsManager.SetCurrentProvider(Value: Integer);
begin
  TDatabaseManager.SetSetting(KEY_PROVIDER, IntToStr(Value));
end;

class function TSettingsManager.GetCurrentModel: string;
begin
  Result := TDatabaseManager.GetSetting(KEY_MODEL, '');
end;

class procedure TSettingsManager.SetCurrentModel(const Value: string);
begin
  TDatabaseManager.SetSetting(KEY_MODEL, Value);
end;

// Inference Parameters
class function TSettingsManager.GetTemperature: Double;
begin
  Result := StrToFloatDef(TDatabaseManager.GetSetting(KEY_TEMPERATURE, '0.7'), 0.7);
end;

class procedure TSettingsManager.SetTemperature(Value: Double);
begin
  TDatabaseManager.SetSetting(KEY_TEMPERATURE, FloatToStr(Value));
end;

class function TSettingsManager.GetMaxTokens: Integer;
begin
  Result := StrToIntDef(TDatabaseManager.GetSetting(KEY_MAX_TOKENS, '2048'), 2048);
end;

class procedure TSettingsManager.SetMaxTokens(Value: Integer);
begin
  TDatabaseManager.SetSetting(KEY_MAX_TOKENS, IntToStr(Value));
end;

class function TSettingsManager.GetTopP: Double;
begin
  Result := StrToFloatDef(TDatabaseManager.GetSetting(KEY_TOP_P, '0.9'), 0.9);
end;

class procedure TSettingsManager.SetTopP(Value: Double);
begin
  TDatabaseManager.SetSetting(KEY_TOP_P, FloatToStr(Value));
end;

class function TSettingsManager.GetTopK: Integer;
begin
  Result := StrToIntDef(TDatabaseManager.GetSetting(KEY_TOP_K, '40'), 40);
end;

class procedure TSettingsManager.SetTopK(Value: Integer);
begin
  TDatabaseManager.SetSetting(KEY_TOP_K, IntToStr(Value));
end;

// UI Settings
class function TSettingsManager.GetThemeMode: Integer;
begin
  Result := StrToIntDef(TDatabaseManager.GetSetting(KEY_THEME_MODE, '1'), 1);
end;

class procedure TSettingsManager.SetThemeMode(Value: Integer);
begin
  TDatabaseManager.SetSetting(KEY_THEME_MODE, IntToStr(Value));
end;

class function TSettingsManager.GetThemeID: Integer;
begin
  Result := StrToIntDef(TDatabaseManager.GetSetting(KEY_THEME_ID, '0'), 0);
end;

class procedure TSettingsManager.SetThemeID(Value: Integer);
begin
  TDatabaseManager.SetSetting(KEY_THEME_ID, IntToStr(Value));
end;

class function TSettingsManager.GetUIMode: Integer;
begin
  Result := StrToIntDef(TDatabaseManager.GetSetting(KEY_UI_MODE, '0'), 0);
end;

class procedure TSettingsManager.SetUIMode(Value: Integer);
begin
  TDatabaseManager.SetSetting(KEY_UI_MODE, IntToStr(Value));
end;

// Current Conversation
class function TSettingsManager.GetCurrentConversationID: Int64;
begin
  Result := StrToInt64Def(TDatabaseManager.GetSetting(KEY_CURRENT_CONV, '-1'), -1);
end;

class procedure TSettingsManager.SetCurrentConversationID(Value: Int64);
begin
  TDatabaseManager.SetSetting(KEY_CURRENT_CONV, IntToStr(Value));
end;

// Workspace
class function TSettingsManager.GetWorkspacePath: string;
begin
  Result := TDatabaseManager.GetSetting(KEY_WORKSPACE, '');
end;

class procedure TSettingsManager.SetWorkspacePath(const Value: string);
begin
  TDatabaseManager.SetSetting(KEY_WORKSPACE, Value);
end;

// Code Execution
class function TSettingsManager.GetPythonPath: string;
begin
  Result := TDatabaseManager.GetSetting(KEY_PYTHON_PATH, 'python');
end;

class procedure TSettingsManager.SetPythonPath(const Value: string);
begin
  TDatabaseManager.SetSetting(KEY_PYTHON_PATH, Value);
end;

class function TSettingsManager.GetCodeExecutionEnabled: Boolean;
begin
  Result := TDatabaseManager.GetSetting(KEY_CODE_EXEC, '0') = '1';
end;

class procedure TSettingsManager.SetCodeExecutionEnabled(Value: Boolean);
begin
  TDatabaseManager.SetSetting(KEY_CODE_EXEC, IfThen(Value, '1', '0'));
end;

// RAG
class function TSettingsManager.GetRAGEnabled: Boolean;
begin
  Result := TDatabaseManager.GetSetting(KEY_RAG_ENABLED, '0') = '1';
end;

class procedure TSettingsManager.SetRAGEnabled(Value: Boolean);
begin
  TDatabaseManager.SetSetting(KEY_RAG_ENABLED, IfThen(Value, '1', '0'));
end;

class function TSettingsManager.GetEmbeddingModel: string;
begin
  Result := TDatabaseManager.GetSetting(KEY_EMBEDDING_MODEL, 'nomic-embed-text');
end;

class procedure TSettingsManager.SetEmbeddingModel(const Value: string);
begin
  TDatabaseManager.SetSetting(KEY_EMBEDDING_MODEL, Value);
end;

// Performance
class function TSettingsManager.GetTokenCostPerMillion: Double;
begin
  Result := StrToFloatDef(TDatabaseManager.GetSetting(KEY_TOKEN_COST, '0.0'), 0.0);
end;

class procedure TSettingsManager.SetTokenCostPerMillion(Value: Double);
begin
  TDatabaseManager.SetSetting(KEY_TOKEN_COST, FloatToStr(Value));
end;

end.
