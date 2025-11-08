unit LMStudioAPI;

interface

uses
  System.SysUtils, System.Classes, System.JSON, APIBase, HTTPClient;

type
  TLMStudioAPI = class(TAPIBase)
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
  end;

implementation

constructor TLMStudioAPI.Create;
begin
  inherited;
  FBaseURL := 'http://localhost:1234/v1';
end;

function TLMStudioAPI.GetProviderName: string;
begin
  Result := 'LM Studio';
end;

function TLMStudioAPI.TestConnection: Boolean;
begin
  try
    var Response := FHTTP.GET(FBaseURL + '/models');
    Result := Response <> '';
  except
    Result := False;
  end;
end;

function TLMStudioAPI.GetModels: TArray<TModelInfo>;
var
  JSON: TJSONValue;
  DataArray: TJSONArray;
  I: Integer;
  ModelObj: TJSONObject;
begin
  SetLength(Result, 0);

  try
    JSON := FHTTP.GetJSON(FBaseURL + '/models');
    if not Assigned(JSON) then Exit;

    try
      DataArray := (JSON as TJSONObject).GetValue<TJSONArray>('data');
      SetLength(Result, DataArray.Count);

      for I := 0 to DataArray.Count - 1 do
      begin
        ModelObj := DataArray.Items[I] as TJSONObject;
        Result[I].Name := ModelObj.GetValue<string>('id');
        Result[I].Size := 0; // Not provided by LM Studio
        Result[I].Modified := Now;
      end;
    finally
      JSON.Free;
    end;
  except
    SetLength(Result, 0);
  end;
end;

function TLMStudioAPI.Chat(const Messages: TArray<TChatMessage>): string;
var
  Request, Response: TJSONObject;
  MessagesArray: TJSONArray;
  I: Integer;
  MsgObj: TJSONObject;
  ChoicesArray: TJSONArray;
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
    Request.AddPair('temperature', TJSONNumber.Create(FTemperature));
    Request.AddPair('max_tokens', TJSONNumber.Create(FMaxTokens));
    Request.AddPair('top_p', TJSONNumber.Create(FTopP));
    Request.AddPair('stream', TJSONBool.Create(False));

    Response := FHTTP.PostJSON(FBaseURL + '/chat/completions', Request) as TJSONObject;
    if Assigned(Response) then
    try
      ChoicesArray := Response.GetValue<TJSONArray>('choices');
      if ChoicesArray.Count > 0 then
      begin
        var Choice := ChoicesArray.Items[0] as TJSONObject;
        Result := Choice.GetValue<TJSONObject>('message').GetValue<string>('content');
      end;
    finally
      Response.Free;
    end;

  finally
    Request.Free;
  end;
end;

procedure TLMStudioAPI.ChatStream(const Messages: TArray<TChatMessage>;
  OnToken: TStreamCallback; OnComplete: TCompleteCallback;
  OnError: TErrorCallback);
begin
  // TODO: Implement SSE streaming
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

function TLMStudioAPI.Generate(const Prompt: string): string;
var
  Messages: TArray<TChatMessage>;
begin
  SetLength(Messages, 1);
  Messages[0].Role := mrUser;
  Messages[0].Content := Prompt;
  Result := Chat(Messages);
end;

end.
