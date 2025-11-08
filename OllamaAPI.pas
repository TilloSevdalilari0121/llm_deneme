unit OllamaAPI;

interface

uses
  System.SysUtils, System.Classes, System.JSON, APIBase, HTTPClient;

type
  TOllamaAPI = class(TAPIBase)
  protected
    function GetProviderName: string; override;
  public
    constructor Create; override;

    function TestConnection: Boolean; override;
    function GetModels: TArray<TModelInfo>; override;
    function Chat(const Messages: TArray<TChatMessage>): string; override;
    procedure ChatStream(const Messages: TArray<TChatMessage>;
      OnToken: TStreamCallback; OnComplete: TCompleteCallback;
      OnError: TErrorCallback); override;
    function Generate(const Prompt: string): string; override;

    // Ollama-specific
    function PullModel(const ModelName: string): Boolean;
    function DeleteModel(const ModelName: string): Boolean;
  end;

implementation

constructor TOllamaAPI.Create;
begin
  inherited;
  FBaseURL := 'http://localhost:11434';
end;

function TOllamaAPI.GetProviderName: string;
begin
  Result := 'Ollama';
end;

function TOllamaAPI.TestConnection: Boolean;
begin
  try
    var Response := FHTTP.GET(FBaseURL + '/api/tags');
    Result := Response <> '';
  except
    Result := False;
  end;
end;

function TOllamaAPI.GetModels: TArray<TModelInfo>;
var
  JSON: TJSONValue;
  ModelsArray: TJSONArray;
  I: Integer;
  ModelObj: TJSONObject;
begin
  SetLength(Result, 0);

  try
    JSON := FHTTP.GetJSON(FBaseURL + '/api/tags');
    if not Assigned(JSON) then Exit;

    try
      ModelsArray := (JSON as TJSONObject).GetValue<TJSONArray>('models');
      SetLength(Result, ModelsArray.Count);

      for I := 0 to ModelsArray.Count - 1 do
      begin
        ModelObj := ModelsArray.Items[I] as TJSONObject;
        Result[I].Name := ModelObj.GetValue<string>('name');
        Result[I].Size := ModelObj.GetValue<Int64>('size', 0);
        Result[I].Modified := Now; // Parse from string if needed
      end;
    finally
      JSON.Free;
    end;
  except
    SetLength(Result, 0);
  end;
end;

function TOllamaAPI.Chat(const Messages: TArray<TChatMessage>): string;
var
  Request, Response: TJSONObject;
  MessagesArray: TJSONArray;
  I: Integer;
  MsgObj: TJSONObject;
begin
  Result := '';

  Request := TJSONObject.Create;
  try
    Request.AddPair('model', FModel);

    MessagesArray := TJSONArray.Create;
    for I := 0 to High(Messages) do
    begin
      MsgObj := TJSONObject.Create;
      MsgObj.AddPair('role', RoleToString(Messages[I].Role));
      MsgObj.AddPair('content', Messages[I].Content);
      MessagesArray.AddElement(MsgObj);
    end;

    Request.AddPair('messages', MessagesArray);
    Request.AddPair('stream', TJSONBool.Create(False));
    Request.AddPair('options', TJSONObject.Create
      .AddPair('temperature', TJSONNumber.Create(FTemperature))
      .AddPair('num_predict', TJSONNumber.Create(FMaxTokens))
    );

    Response := FHTTP.PostJSON(FBaseURL + '/api/chat', Request) as TJSONObject;
    if Assigned(Response) then
    try
      Result := Response.GetValue<TJSONObject>('message').GetValue<string>('content');
    finally
      Response.Free;
    end;

  finally
    Request.Free;
  end;
end;

procedure TOllamaAPI.ChatStream(const Messages: TArray<TChatMessage>;
  OnToken: TStreamCallback; OnComplete: TCompleteCallback;
  OnError: TErrorCallback);
begin
  // TODO: Implement streaming using TIdHTTP or similar for SSE
  // For now, use non-streaming
  try
    var Response := Chat(Messages);
    if Assigned(OnToken) then
      OnToken(Response);
    if Assigned(OnComplete) then
      OnComplete(Response, 0);
  except
    on E: Exception do
      if Assigned(OnError) then
        OnError(E.Message);
  end;
end;

function TOllamaAPI.Generate(const Prompt: string): string;
var
  Request, Response: TJSONObject;
begin
  Result := '';

  Request := TJSONObject.Create;
  try
    Request.AddPair('model', FModel);
    Request.AddPair('prompt', Prompt);
    Request.AddPair('stream', TJSONBool.Create(False));

    Response := FHTTP.PostJSON(FBaseURL + '/api/generate', Request) as TJSONObject;
    if Assigned(Response) then
    try
      Result := Response.GetValue<string>('response');
    finally
      Response.Free;
    end;

  finally
    Request.Free;
  end;
end;

function TOllamaAPI.PullModel(const ModelName: string): Boolean;
var
  Request: TJSONObject;
begin
  Request := TJSONObject.Create;
  try
    Request.AddPair('name', ModelName);
    try
      FHTTP.PostJSON(FBaseURL + '/api/pull', Request).Free;
      Result := True;
    except
      Result := False;
    end;
  finally
    Request.Free;
  end;
end;

function TOllamaAPI.DeleteModel(const ModelName: string): Boolean;
var
  Request: TJSONObject;
begin
  Request := TJSONObject.Create;
  try
    Request.AddPair('name', ModelName);
    try
      FHTTP.DELETE(FBaseURL + '/api/delete');
      Result := True;
    except
      Result := False;
    end;
  finally
    Request.Free;
  end;
end;

end.
