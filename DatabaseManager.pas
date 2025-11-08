unit DatabaseManager;

{$IFDEF FPC}
  {$MODE DELPHI}
{$ENDIF}

interface

uses
  System.SysUtils, System.Classes, SQLiteBindings;

type
  TDatabaseManager = class
  private
    class var FDatabase: TSQLiteDB;
    class var FInitialized: Boolean;
    class procedure CreateTables;
    class procedure ExecuteSQL(const SQL: string);
    class function PrepareStatement(const SQL: string): TSQLiteStmt;
  public
    class procedure Initialize(const DBPath: string);
    class procedure Finalize;
    class function GetDatabase: TSQLiteDB;
    class function IsInitialized: Boolean;

    // Chat history
    class procedure SaveMessage(const ConversationID: Int64; const Role, Content: string);
    class function GetConversationMessages(const ConversationID: Int64): TStringList;
    class function CreateConversation(const Title: string): Int64;
    class procedure DeleteConversation(const ConversationID: Int64);
    class function GetAllConversations: TStringList; // Format: ID|Title|LastMessage|Timestamp

    // Settings
    class procedure SetSetting(const Key, Value: string);
    class function GetSetting(const Key, DefaultValue: string): string;

    // Models
    class procedure SaveModel(const Name, Path, ModelType: string; Size: Int64);
    class procedure DeleteModel(const ModelID: Int64);
    class function GetAllModels: TStringList; // Format: ID|Name|Path|Type|Size
    class function ModelExists(const Path: string): Boolean;
  end;

implementation

const
  SCHEMA_SQL = '''
CREATE TABLE IF NOT EXISTS conversations (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS messages (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  conversation_id INTEGER NOT NULL,
  role TEXT NOT NULL,
  content TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (conversation_id) REFERENCES conversations(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS settings (
  key TEXT PRIMARY KEY,
  value TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS models (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  path TEXT UNIQUE NOT NULL,
  model_type TEXT NOT NULL,
  size_bytes INTEGER NOT NULL,
  added_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_messages_conv ON messages(conversation_id);
CREATE INDEX IF NOT EXISTS idx_models_path ON models(path);
''';

class procedure TDatabaseManager.Initialize(const DBPath: string);
var
  Result: Integer;
begin
  if FInitialized then Exit;

  Result := sqlite3_open(PAnsiChar(AnsiString(DBPath)), FDatabase);
  if Result <> SQLITE_OK then
    raise Exception.Create('Failed to open database: ' + DBPath);

  FInitialized := True;
  CreateTables;
end;

class procedure TDatabaseManager.Finalize;
begin
  if FInitialized and Assigned(FDatabase) then
  begin
    sqlite3_close(FDatabase);
    FDatabase := nil;
    FInitialized := False;
  end;
end;

class procedure TDatabaseManager.CreateTables;
begin
  ExecuteSQL(SCHEMA_SQL);
end;

class procedure TDatabaseManager.ExecuteSQL(const SQL: string);
var
  ErrMsg: PAnsiChar;
  Result: Integer;
begin
  if not FInitialized then
    raise Exception.Create('Database not initialized');

  Result := sqlite3_exec(FDatabase, PAnsiChar(AnsiString(SQL)), nil, nil, @ErrMsg);
  if Result <> SQLITE_OK then
  begin
    var Error := string(ErrMsg);
    raise Exception.Create('SQL Error: ' + Error);
  end;
end;

class function TDatabaseManager.PrepareStatement(const SQL: string): TSQLiteStmt;
var
  Stmt: TSQLiteStmt;
  Tail: PAnsiChar;
  Result: Integer;
begin
  if not FInitialized then
    raise Exception.Create('Database not initialized');

  Result := sqlite3_prepare_v2(FDatabase, PAnsiChar(AnsiString(SQL)), -1, Stmt, Tail);
  if Result <> SQLITE_OK then
    raise Exception.Create('Failed to prepare statement: ' + SQL);

  Exit(Stmt);
end;

class function TDatabaseManager.GetDatabase: TSQLiteDB;
begin
  Result := FDatabase;
end;

class function TDatabaseManager.IsInitialized: Boolean;
begin
  Result := FInitialized;
end;

// Chat history methods
class procedure TDatabaseManager.SaveMessage(const ConversationID: Int64;
  const Role, Content: string);
var
  Stmt: TSQLiteStmt;
  SQL: string;
begin
  SQL := 'INSERT INTO messages (conversation_id, role, content) VALUES (?, ?, ?)';
  Stmt := PrepareStatement(SQL);
  try
    sqlite3_bind_int64(Stmt, 1, ConversationID);
    sqlite3_bind_text(Stmt, 2, PAnsiChar(AnsiString(Role)), -1, nil);
    sqlite3_bind_text(Stmt, 3, PAnsiChar(AnsiString(Content)), -1, nil);

    if sqlite3_step(Stmt) <> SQLITE_DONE then
      raise Exception.Create('Failed to save message');

    // Update conversation timestamp
    SQL := 'UPDATE conversations SET updated_at = CURRENT_TIMESTAMP WHERE id = ?';
    var UpdateStmt := PrepareStatement(SQL);
    try
      sqlite3_bind_int64(UpdateStmt, 1, ConversationID);
      sqlite3_step(UpdateStmt);
    finally
      sqlite3_finalize(UpdateStmt);
    end;
  finally
    sqlite3_finalize(Stmt);
  end;
end;

class function TDatabaseManager.GetConversationMessages(const ConversationID: Int64): TStringList;
var
  Stmt: TSQLiteStmt;
  SQL: string;
  Role, Content: string;
begin
  Result := TStringList.Create;
  SQL := 'SELECT role, content FROM messages WHERE conversation_id = ? ORDER BY created_at ASC';
  Stmt := PrepareStatement(SQL);
  try
    sqlite3_bind_int64(Stmt, 1, ConversationID);

    while sqlite3_step(Stmt) = SQLITE_ROW do
    begin
      Role := string(sqlite3_column_text(Stmt, 0));
      Content := string(sqlite3_column_text(Stmt, 1));
      Result.Add(Role + '|' + Content);
    end;
  finally
    sqlite3_finalize(Stmt);
  end;
end;

class function TDatabaseManager.CreateConversation(const Title: string): Int64;
var
  Stmt: TSQLiteStmt;
  SQL: string;
begin
  SQL := 'INSERT INTO conversations (title) VALUES (?)';
  Stmt := PrepareStatement(SQL);
  try
    sqlite3_bind_text(Stmt, 1, PAnsiChar(AnsiString(Title)), -1, nil);

    if sqlite3_step(Stmt) <> SQLITE_DONE then
      raise Exception.Create('Failed to create conversation');

    Result := sqlite3_last_insert_rowid(FDatabase);
  finally
    sqlite3_finalize(Stmt);
  end;
end;

class procedure TDatabaseManager.DeleteConversation(const ConversationID: Int64);
var
  Stmt: TSQLiteStmt;
  SQL: string;
begin
  SQL := 'DELETE FROM conversations WHERE id = ?';
  Stmt := PrepareStatement(SQL);
  try
    sqlite3_bind_int64(Stmt, 1, ConversationID);
    sqlite3_step(Stmt);
  finally
    sqlite3_finalize(Stmt);
  end;
end;

class function TDatabaseManager.GetAllConversations: TStringList;
var
  Stmt: TSQLiteStmt;
  SQL: string;
  ID: Int64;
  Title, UpdatedAt: string;
begin
  Result := TStringList.Create;
  SQL := 'SELECT id, title, updated_at FROM conversations ORDER BY updated_at DESC';
  Stmt := PrepareStatement(SQL);
  try
    while sqlite3_step(Stmt) = SQLITE_ROW do
    begin
      ID := sqlite3_column_int64(Stmt, 0);
      Title := string(sqlite3_column_text(Stmt, 1));
      UpdatedAt := string(sqlite3_column_text(Stmt, 2));
      Result.Add(Format('%d|%s|%s', [ID, Title, UpdatedAt]));
    end;
  finally
    sqlite3_finalize(Stmt);
  end;
end;

// Settings methods
class procedure TDatabaseManager.SetSetting(const Key, Value: string);
var
  Stmt: TSQLiteStmt;
  SQL: string;
begin
  SQL := 'INSERT OR REPLACE INTO settings (key, value) VALUES (?, ?)';
  Stmt := PrepareStatement(SQL);
  try
    sqlite3_bind_text(Stmt, 1, PAnsiChar(AnsiString(Key)), -1, nil);
    sqlite3_bind_text(Stmt, 2, PAnsiChar(AnsiString(Value)), -1, nil);
    sqlite3_step(Stmt);
  finally
    sqlite3_finalize(Stmt);
  end;
end;

class function TDatabaseManager.GetSetting(const Key, DefaultValue: string): string;
var
  Stmt: TSQLiteStmt;
  SQL: string;
begin
  Result := DefaultValue;
  SQL := 'SELECT value FROM settings WHERE key = ?';
  Stmt := PrepareStatement(SQL);
  try
    sqlite3_bind_text(Stmt, 1, PAnsiChar(AnsiString(Key)), -1, nil);

    if sqlite3_step(Stmt) = SQLITE_ROW then
      Result := string(sqlite3_column_text(Stmt, 0));
  finally
    sqlite3_finalize(Stmt);
  end;
end;

// Model methods
class procedure TDatabaseManager.SaveModel(const Name, Path, ModelType: string; Size: Int64);
var
  Stmt: TSQLiteStmt;
  SQL: string;
begin
  SQL := 'INSERT OR REPLACE INTO models (name, path, model_type, size_bytes) VALUES (?, ?, ?, ?)';
  Stmt := PrepareStatement(SQL);
  try
    sqlite3_bind_text(Stmt, 1, PAnsiChar(AnsiString(Name)), -1, nil);
    sqlite3_bind_text(Stmt, 2, PAnsiChar(AnsiString(Path)), -1, nil);
    sqlite3_bind_text(Stmt, 3, PAnsiChar(AnsiString(ModelType)), -1, nil);
    sqlite3_bind_int64(Stmt, 4, Size);
    sqlite3_step(Stmt);
  finally
    sqlite3_finalize(Stmt);
  end;
end;

class procedure TDatabaseManager.DeleteModel(const ModelID: Int64);
var
  Stmt: TSQLiteStmt;
  SQL: string;
begin
  SQL := 'DELETE FROM models WHERE id = ?';
  Stmt := PrepareStatement(SQL);
  try
    sqlite3_bind_int64(Stmt, 1, ModelID);
    sqlite3_step(Stmt);
  finally
    sqlite3_finalize(Stmt);
  end;
end;

class function TDatabaseManager.GetAllModels: TStringList;
var
  Stmt: TSQLiteStmt;
  SQL: string;
  ID, Size: Int64;
  Name, Path, ModelType: string;
begin
  Result := TStringList.Create;
  SQL := 'SELECT id, name, path, model_type, size_bytes FROM models ORDER BY name ASC';
  Stmt := PrepareStatement(SQL);
  try
    while sqlite3_step(Stmt) = SQLITE_ROW do
    begin
      ID := sqlite3_column_int64(Stmt, 0);
      Name := string(sqlite3_column_text(Stmt, 1));
      Path := string(sqlite3_column_text(Stmt, 2));
      ModelType := string(sqlite3_column_text(Stmt, 3));
      Size := sqlite3_column_int64(Stmt, 4);
      Result.Add(Format('%d|%s|%s|%s|%d', [ID, Name, Path, ModelType, Size]));
    end;
  finally
    sqlite3_finalize(Stmt);
  end;
end;

class function TDatabaseManager.ModelExists(const Path: string): Boolean;
var
  Stmt: TSQLiteStmt;
  SQL: string;
begin
  Result := False;
  SQL := 'SELECT COUNT(*) FROM models WHERE path = ?';
  Stmt := PrepareStatement(SQL);
  try
    sqlite3_bind_text(Stmt, 1, PAnsiChar(AnsiString(Path)), -1, nil);

    if sqlite3_step(Stmt) = SQLITE_ROW then
      Result := sqlite3_column_int(Stmt, 0) > 0;
  finally
    sqlite3_finalize(Stmt);
  end;
end;

end.
