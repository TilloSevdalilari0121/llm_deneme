unit SQLiteBindings;

{$IFDEF FPC}
  {$MODE DELPHI}
{$ENDIF}

interface

uses
  System.SysUtils, Winapi.Windows;

const
  SQLITE_OK = 0;
  SQLITE_ROW = 100;
  SQLITE_DONE = 101;
  SQLITE_INTEGER = 1;
  SQLITE_FLOAT = 2;
  SQLITE_TEXT = 3;
  SQLITE_BLOB = 4;
  SQLITE_NULL = 5;

type
  TSQLiteDB = Pointer;
  TSQLiteStmt = Pointer;

// Core SQLite functions
function sqlite3_open(filename: PAnsiChar; var db: TSQLiteDB): Integer; cdecl; external 'sqlite3.dll';
function sqlite3_close(db: TSQLiteDB): Integer; cdecl; external 'sqlite3.dll';
function sqlite3_exec(db: TSQLiteDB; sql: PAnsiChar; callback: Pointer;
  userData: Pointer; errmsg: PPAnsiChar): Integer; cdecl; external 'sqlite3.dll';

// Prepared statements
function sqlite3_prepare_v2(db: TSQLiteDB; sql: PAnsiChar; nByte: Integer;
  var stmt: TSQLiteStmt; var pzTail: PAnsiChar): Integer; cdecl; external 'sqlite3.dll';
function sqlite3_step(stmt: TSQLiteStmt): Integer; cdecl; external 'sqlite3.dll';
function sqlite3_finalize(stmt: TSQLiteStmt): Integer; cdecl; external 'sqlite3.dll';
function sqlite3_reset(stmt: TSQLiteStmt): Integer; cdecl; external 'sqlite3.dll';

// Binding parameters
function sqlite3_bind_int(stmt: TSQLiteStmt; idx: Integer; value: Integer): Integer; cdecl; external 'sqlite3.dll';
function sqlite3_bind_int64(stmt: TSQLiteStmt; idx: Integer; value: Int64): Integer; cdecl; external 'sqlite3.dll';
function sqlite3_bind_double(stmt: TSQLiteStmt; idx: Integer; value: Double): Integer; cdecl; external 'sqlite3.dll';
function sqlite3_bind_text(stmt: TSQLiteStmt; idx: Integer; text: PAnsiChar;
  n: Integer; destructor: Pointer): Integer; cdecl; external 'sqlite3.dll';
function sqlite3_bind_null(stmt: TSQLiteStmt; idx: Integer): Integer; cdecl; external 'sqlite3.dll';

// Reading columns
function sqlite3_column_int(stmt: TSQLiteStmt; iCol: Integer): Integer; cdecl; external 'sqlite3.dll';
function sqlite3_column_int64(stmt: TSQLiteStmt; iCol: Integer): Int64; cdecl; external 'sqlite3.dll';
function sqlite3_column_double(stmt: TSQLiteStmt; iCol: Integer): Double; cdecl; external 'sqlite3.dll';
function sqlite3_column_text(stmt: TSQLiteStmt; iCol: Integer): PAnsiChar; cdecl; external 'sqlite3.dll';
function sqlite3_column_bytes(stmt: TSQLiteStmt; iCol: Integer): Integer; cdecl; external 'sqlite3.dll';
function sqlite3_column_type(stmt: TSQLiteStmt; iCol: Integer): Integer; cdecl; external 'sqlite3.dll';
function sqlite3_column_count(stmt: TSQLiteStmt): Integer; cdecl; external 'sqlite3.dll';

// Error handling
function sqlite3_errmsg(db: TSQLiteDB): PAnsiChar; cdecl; external 'sqlite3.dll';
function sqlite3_errcode(db: TSQLiteDB): Integer; cdecl; external 'sqlite3.dll';

// Utility
function sqlite3_last_insert_rowid(db: TSQLiteDB): Int64; cdecl; external 'sqlite3.dll';
function sqlite3_changes(db: TSQLiteDB): Integer; cdecl; external 'sqlite3.dll';

implementation

end.
