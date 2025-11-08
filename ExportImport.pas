unit ExportImport;

interface

uses
  System.SysUtils, System.Classes, System.JSON, DatabaseManager;

type
  TExportImport = class
  public
    class function ExportConversation(ConvID: Int64): string; // Returns JSON
    class function ImportConversation(const JSON: string): Int64; // Returns new ConvID
    class function ExportAllConversations: string;
    class procedure ExportToFile(const FileName, JSON: string);
    class function ImportFromFile(const FileName: string): string;
  end;

implementation

class function TExportImport.ExportConversation(ConvID: Int64): string;
var
  Conv: TConversation;
  Messages: TArray<TMessage>;
  JSON, MsgsArray: TJSONObject;
  I: Integer;
begin
  Conv := TDatabaseManager.GetConversation(ConvID);
  Messages := TDatabaseManager.GetMessages(ConvID);
  
  JSON := TJSONObject.Create;
  try
    JSON.AddPair('title', Conv.Title);
    JSON.AddPair('provider', Conv.Provider);
    JSON.AddPair('model', Conv.Model);
    
    var Msgs := TJSONArray.Create;
    for I := 0 to High(Messages) do
    begin
      var Msg := TJSONObject.Create;
      Msg.AddPair('role', Messages[I].Role);
      Msg.AddPair('content', Messages[I].Content);
      Msgs.AddElement(Msg);
    end;
    JSON.AddPair('messages', Msgs);
    
    Result := JSON.ToJSON;
  finally
    JSON.Free;
  end;
end;

class function TExportImport.ImportConversation(const JSON: string): Int64;
var
  JSONObj: TJSONObject;
  Title, Provider, Model: string;
  MsgsArray: TJSONArray;
  I: Integer;
begin
  JSONObj := TJSONObject.ParseJSONValue(JSON) as TJSONObject;
  try
    Title := JSONObj.GetValue<string>('title');
    Provider := JSONObj.GetValue<string>('provider');
    Model := JSONObj.GetValue<string>('model');
    
    Result := TDatabaseManager.CreateConversation(Title, Provider, Model);
    
    MsgsArray := JSONObj.GetValue<TJSONArray>('messages');
    for I := 0 to MsgsArray.Count - 1 do
    begin
      var Msg := MsgsArray.Items[I] as TJSONObject;
      TDatabaseManager.SaveMessage(
        Result,
        Msg.GetValue<string>('role'),
        Msg.GetValue<string>('content')
      );
    end;
  finally
    JSONObj.Free;
  end;
end;

class function TExportImport.ExportAllConversations: string;
var
  Convs: TArray<TConversation>;
  I: Integer;
  AllJSON, ConvArray: TJSONObject;
begin
  Convs := TDatabaseManager.GetAllConversations;
  
  AllJSON := TJSONObject.Create;
  try
    ConvArray := TJSONArray.Create;
    for I := 0 to High(Convs) do
    begin
      var ConvJSON := TJSONObject.ParseJSONValue(ExportConversation(Convs[I].ID));
      TJSONArray(ConvArray).AddElement(ConvJSON);
    end;
    AllJSON.AddPair('conversations', ConvArray);
    Result := AllJSON.ToJSON;
  finally
    AllJSON.Free;
  end;
end;

class procedure TExportImport.ExportToFile(const FileName, JSON: string);
var
  F: TextFile;
begin
  AssignFile(F, FileName);
  Rewrite(F);
  try
    Write(F, JSON);
  finally
    CloseFile(F);
  end;
end;

class function TExportImport.ImportFromFile(const FileName: string): string;
var
  F: TextFile;
  Line, Content: string;
begin
  Content := '';
  AssignFile(F, FileName);
  Reset(F);
  try
    while not Eof(F) do
    begin
      ReadLn(F, Line);
      Content := Content + Line;
    end;
  finally
    CloseFile(F);
  end;
  Result := Content;
end;

end.
