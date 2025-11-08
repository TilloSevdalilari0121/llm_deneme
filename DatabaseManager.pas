unit DatabaseManager;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, Data.DB,
  FireDAC.Comp.Client, FireDAC.Stan.Def, FireDAC.Phys.SQLite,
  FireDAC.Stan.Async, FireDAC.DApt;

type
  TConversation = record
    ID: Int64;
    Title: string;
    Provider: string;
    Model: string;
    CreatedAt: TDateTime;
    UpdatedAt: TDateTime;
  end;

  TMessage = record
    ID: Int64;
    ConversationID: Int64;
    Role: string;
    Content: string;
    Tokens: Integer;
    CreatedAt: TDateTime;
  end;

  TDatabaseManager = class
  private
    class var FConnection: TFDConnection;
    class var FInitialized: Boolean;
    class procedure CreateTables;
    class function GetConnection: TFDConnection;
  public
    class procedure Initialize(const DBPath: string);
    class procedure Finalize;

    // Conversations
    class function CreateConversation(const Title, Provider, Model: string): Int64;
    class procedure UpdateConversation(ConvID: Int64; const Title: string);
    class procedure DeleteConversation(ConvID: Int64);
    class function GetConversation(ConvID: Int64): TConversation;
    class function GetAllConversations: TArray<TConversation>;

    // Messages
    class procedure SaveMessage(ConvID: Int64; const Role, Content: string; Tokens: Integer = 0);
    class function GetMessages(ConvID: Int64): TArray<TMessage>;
    class procedure DeleteMessage(MsgID: Int64);

    // Settings
    class procedure SetSetting(const Key, Value: string);
    class function GetSetting(const Key, DefaultValue: string): string;

    // Prompts
    class procedure SavePrompt(const Name, Content, Category: string);
    class procedure DeletePrompt(PromptID: Int64);
    class function GetAllPrompts: TStringList; // Format: ID|Name|Content|Category

    // RAG Documents
    class procedure SaveDocument(const Name, Content, FilePath: string);
    class procedure DeleteDocument(DocID: Int64);
    class function GetAllDocuments: TStringList;

    // Performance logs
    class procedure LogPerformance(const Provider, Model: string;
      Tokens, Duration: Integer);
    class function GetPerformanceStats: TStringList;
  end;

implementation

const
  SCHEMA_SQL = '''
CREATE TABLE IF NOT EXISTS conversations (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  provider TEXT NOT NULL,
  model TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS messages (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  conversation_id INTEGER NOT NULL,
  role TEXT NOT NULL,
  content TEXT NOT NULL,
  tokens INTEGER DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (conversation_id) REFERENCES conversations(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS settings (
  key TEXT PRIMARY KEY,
  value TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS prompts (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  content TEXT NOT NULL,
  category TEXT DEFAULT ''General'',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS documents (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  content TEXT NOT NULL,
  file_path TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS performance_logs (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  provider TEXT NOT NULL,
  model TEXT NOT NULL,
  tokens INTEGER DEFAULT 0,
  duration_ms INTEGER DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_messages_conv ON messages(conversation_id);
CREATE INDEX IF NOT EXISTS idx_prompts_category ON prompts(category);
CREATE INDEX IF NOT EXISTS idx_perf_provider ON performance_logs(provider);
''';

class procedure TDatabaseManager.Initialize(const DBPath: string);
begin
  if FInitialized then Exit;

  FConnection := TFDConnection.Create(nil);
  FConnection.DriverName := 'SQLite';
  FConnection.Params.Database := DBPath;
  FConnection.LoginPrompt := False;

  try
    FConnection.Connected := True;
    FInitialized := True;
    CreateTables;
  except
    on E: Exception do
      raise Exception.Create('Failed to initialize database: ' + E.Message);
  end;
end;

class procedure TDatabaseManager.Finalize;
begin
  if FInitialized and Assigned(FConnection) then
  begin
    FConnection.Connected := False;
    FConnection.Free;
    FConnection := nil;
    FInitialized := False;
  end;
end;

class function TDatabaseManager.GetConnection: TFDConnection;
begin
  if not FInitialized then
    raise Exception.Create('Database not initialized');
  Result := FConnection;
end;

class procedure TDatabaseManager.CreateTables;
begin
  GetConnection.ExecSQL(SCHEMA_SQL);
end;

// Conversations
class function TDatabaseManager.CreateConversation(const Title, Provider, Model: string): Int64;
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := GetConnection;
    Query.SQL.Text := 'INSERT INTO conversations (title, provider, model) VALUES (:title, :provider, :model)';
    Query.ParamByName('title').AsString := Title;
    Query.ParamByName('provider').AsString := Provider;
    Query.ParamByName('model').AsString := Model;
    Query.ExecSQL;

    Result := GetConnection.GetLastAutoGenValue('');
  finally
    Query.Free;
  end;
end;

class procedure TDatabaseManager.UpdateConversation(ConvID: Int64; const Title: string);
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := GetConnection;
    Query.SQL.Text := 'UPDATE conversations SET title = :title, updated_at = CURRENT_TIMESTAMP WHERE id = :id';
    Query.ParamByName('title').AsString := Title;
    Query.ParamByName('id').AsLargeInt := ConvID;
    Query.ExecSQL;
  finally
    Query.Free;
  end;
end;

class procedure TDatabaseManager.DeleteConversation(ConvID: Int64);
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := GetConnection;
    Query.SQL.Text := 'DELETE FROM conversations WHERE id = :id';
    Query.ParamByName('id').AsLargeInt := ConvID;
    Query.ExecSQL;
  finally
    Query.Free;
  end;
end;

class function TDatabaseManager.GetConversation(ConvID: Int64): TConversation;
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := GetConnection;
    Query.SQL.Text := 'SELECT * FROM conversations WHERE id = :id';
    Query.ParamByName('id').AsLargeInt := ConvID;
    Query.Open;

    if not Query.EOF then
    begin
      Result.ID := Query.FieldByName('id').AsLargeInt;
      Result.Title := Query.FieldByName('title').AsString;
      Result.Provider := Query.FieldByName('provider').AsString;
      Result.Model := Query.FieldByName('model').AsString;
      Result.CreatedAt := Query.FieldByName('created_at').AsDateTime;
      Result.UpdatedAt := Query.FieldByName('updated_at').AsDateTime;
    end;
  finally
    Query.Free;
  end;
end;

class function TDatabaseManager.GetAllConversations: TArray<TConversation>;
var
  Query: TFDQuery;
  List: TList<TConversation>;
  Conv: TConversation;
begin
  List := TList<TConversation>.Create;
  try
    Query := TFDQuery.Create(nil);
    try
      Query.Connection := GetConnection;
      Query.SQL.Text := 'SELECT * FROM conversations ORDER BY updated_at DESC';
      Query.Open;

      while not Query.EOF do
      begin
        Conv.ID := Query.FieldByName('id').AsLargeInt;
        Conv.Title := Query.FieldByName('title').AsString;
        Conv.Provider := Query.FieldByName('provider').AsString;
        Conv.Model := Query.FieldByName('model').AsString;
        Conv.CreatedAt := Query.FieldByName('created_at').AsDateTime;
        Conv.UpdatedAt := Query.FieldByName('updated_at').AsDateTime;
        List.Add(Conv);
        Query.Next;
      end;
    finally
      Query.Free;
    end;

    Result := List.ToArray;
  finally
    List.Free;
  end;
end;

// Messages
class procedure TDatabaseManager.SaveMessage(ConvID: Int64; const Role, Content: string; Tokens: Integer);
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := GetConnection;
    Query.SQL.Text := 'INSERT INTO messages (conversation_id, role, content, tokens) VALUES (:conv_id, :role, :content, :tokens)';
    Query.ParamByName('conv_id').AsLargeInt := ConvID;
    Query.ParamByName('role').AsString := Role;
    Query.ParamByName('content').AsString := Content;
    Query.ParamByName('tokens').AsInteger := Tokens;
    Query.ExecSQL;

    // Update conversation timestamp
    UpdateConversation(ConvID, ''); // Just updates timestamp
  finally
    Query.Free;
  end;
end;

class function TDatabaseManager.GetMessages(ConvID: Int64): TArray<TMessage>;
var
  Query: TFDQuery;
  List: TList<TMessage>;
  Msg: TMessage;
begin
  List := TList<TMessage>.Create;
  try
    Query := TFDQuery.Create(nil);
    try
      Query.Connection := GetConnection;
      Query.SQL.Text := 'SELECT * FROM messages WHERE conversation_id = :conv_id ORDER BY created_at ASC';
      Query.ParamByName('conv_id').AsLargeInt := ConvID;
      Query.Open;

      while not Query.EOF do
      begin
        Msg.ID := Query.FieldByName('id').AsLargeInt;
        Msg.ConversationID := Query.FieldByName('conversation_id').AsLargeInt;
        Msg.Role := Query.FieldByName('role').AsString;
        Msg.Content := Query.FieldByName('content').AsString;
        Msg.Tokens := Query.FieldByName('tokens').AsInteger;
        Msg.CreatedAt := Query.FieldByName('created_at').AsDateTime;
        List.Add(Msg);
        Query.Next;
      end;
    finally
      Query.Free;
    end;

    Result := List.ToArray;
  finally
    List.Free;
  end;
end;

class procedure TDatabaseManager.DeleteMessage(MsgID: Int64);
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := GetConnection;
    Query.SQL.Text := 'DELETE FROM messages WHERE id = :id';
    Query.ParamByName('id').AsLargeInt := MsgID;
    Query.ExecSQL;
  finally
    Query.Free;
  end;
end;

// Settings
class procedure TDatabaseManager.SetSetting(const Key, Value: string);
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := GetConnection;
    Query.SQL.Text := 'INSERT OR REPLACE INTO settings (key, value) VALUES (:key, :value)';
    Query.ParamByName('key').AsString := Key;
    Query.ParamByName('value').AsString := Value;
    Query.ExecSQL;
  finally
    Query.Free;
  end;
end;

class function TDatabaseManager.GetSetting(const Key, DefaultValue: string): string;
var
  Query: TFDQuery;
begin
  Result := DefaultValue;
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := GetConnection;
    Query.SQL.Text := 'SELECT value FROM settings WHERE key = :key';
    Query.ParamByName('key').AsString := Key;
    Query.Open;

    if not Query.EOF then
      Result := Query.FieldByName('value').AsString;
  finally
    Query.Free;
  end;
end;

// Prompts
class procedure TDatabaseManager.SavePrompt(const Name, Content, Category: string);
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := GetConnection;
    Query.SQL.Text := 'INSERT INTO prompts (name, content, category) VALUES (:name, :content, :category)';
    Query.ParamByName('name').AsString := Name;
    Query.ParamByName('content').AsString := Content;
    Query.ParamByName('category').AsString := Category;
    Query.ExecSQL;
  finally
    Query.Free;
  end;
end;

class procedure TDatabaseManager.DeletePrompt(PromptID: Int64);
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := GetConnection;
    Query.SQL.Text := 'DELETE FROM prompts WHERE id = :id';
    Query.ParamByName('id').AsLargeInt := PromptID;
    Query.ExecSQL;
  finally
    Query.Free;
  end;
end;

class function TDatabaseManager.GetAllPrompts: TStringList;
var
  Query: TFDQuery;
begin
  Result := TStringList.Create;
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := GetConnection;
    Query.SQL.Text := 'SELECT * FROM prompts ORDER BY category, name';
    Query.Open;

    while not Query.EOF do
    begin
      Result.Add(Format('%d|%s|%s|%s', [
        Query.FieldByName('id').AsLargeInt,
        Query.FieldByName('name').AsString,
        Query.FieldByName('content').AsString,
        Query.FieldByName('category').AsString
      ]));
      Query.Next;
    end;
  finally
    Query.Free;
  end;
end;

// RAG Documents
class procedure TDatabaseManager.SaveDocument(const Name, Content, FilePath: string);
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := GetConnection;
    Query.SQL.Text := 'INSERT INTO documents (name, content, file_path) VALUES (:name, :content, :path)';
    Query.ParamByName('name').AsString := Name;
    Query.ParamByName('content').AsString := Content;
    Query.ParamByName('path').AsString := FilePath;
    Query.ExecSQL;
  finally
    Query.Free;
  end;
end;

class procedure TDatabaseManager.DeleteDocument(DocID: Int64);
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := GetConnection;
    Query.SQL.Text := 'DELETE FROM documents WHERE id = :id';
    Query.ParamByName('id').AsLargeInt := DocID;
    Query.ExecSQL;
  finally
    Query.Free;
  end;
end;

class function TDatabaseManager.GetAllDocuments: TStringList;
var
  Query: TFDQuery;
begin
  Result := TStringList.Create;
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := GetConnection;
    Query.SQL.Text := 'SELECT * FROM documents ORDER BY created_at DESC';
    Query.Open;

    while not Query.EOF do
    begin
      Result.Add(Format('%d|%s|%s', [
        Query.FieldByName('id').AsLargeInt,
        Query.FieldByName('name').AsString,
        Query.FieldByName('file_path').AsString
      ]));
      Query.Next;
    end;
  finally
    Query.Free;
  end;
end;

// Performance logs
class procedure TDatabaseManager.LogPerformance(const Provider, Model: string; Tokens, Duration: Integer);
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := GetConnection;
    Query.SQL.Text := 'INSERT INTO performance_logs (provider, model, tokens, duration_ms) VALUES (:provider, :model, :tokens, :duration)';
    Query.ParamByName('provider').AsString := Provider;
    Query.ParamByName('model').AsString := Model;
    Query.ParamByName('tokens').AsInteger := Tokens;
    Query.ParamByName('duration').AsInteger := Duration;
    Query.ExecSQL;
  finally
    Query.Free;
  end;
end;

class function TDatabaseManager.GetPerformanceStats: TStringList;
var
  Query: TFDQuery;
begin
  Result := TStringList.Create;
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := GetConnection;
    Query.SQL.Text := '''
      SELECT provider, model,
             COUNT(*) as count,
             SUM(tokens) as total_tokens,
             AVG(duration_ms) as avg_duration
      FROM performance_logs
      GROUP BY provider, model
      ORDER BY count DESC
    ''';
    Query.Open;

    while not Query.EOF do
    begin
      Result.Add(Format('%s|%s|%d|%d|%d', [
        Query.FieldByName('provider').AsString,
        Query.FieldByName('model').AsString,
        Query.FieldByName('count').AsInteger,
        Query.FieldByName('total_tokens').AsInteger,
        Query.FieldByName('avg_duration').AsInteger
      ]));
      Query.Next;
    end;
  finally
    Query.Free;
  end;
end;

end.
