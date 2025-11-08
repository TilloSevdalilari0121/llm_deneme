unit APIBase;

interface

uses
  System.SysUtils, System.Classes, System.JSON, System.Generics.Collections,
  HTTPClient;

type
  TAPIProvider = (apOllama, apLMStudio, apJan, apCustom);

  TMessageRole = (mrSystem, mrUser, mrAssistant);

  TChatMessage = record
    Role: TMessageRole;
    Content: string;
  end;

  TModelInfo = record
    Name: string;
    Size: Int64;
    Modified: TDateTime;
    Description: string;
  end;

  TStreamCallback = reference to procedure(const Token: string);
  TCompleteCallback = reference to procedure(const FullText: string; Tokens: Integer);
  TErrorCallback = reference to procedure(const Error: string);

  TAPIBase = class abstract
  protected
    FHTTP: THTTPClient;
    FBaseURL: string;
    FApiKey: string;
    FModel: string;
    FTemperature: Single;
    FMaxTokens: Integer;
    FTopP: Single;
    FTopK: Integer;
    FStream: Boolean;

    function GetProviderName: string; virtual; abstract;
  public
    constructor Create; virtual;
    destructor Destroy; override;

    // Connection
    function TestConnection: Boolean; virtual; abstract;
    function GetModels: TArray<TModelInfo>; virtual; abstract;

    // Chat
    function Chat(const Messages: TArray<TChatMessage>): string; virtual; abstract;
    procedure ChatStream(const Messages: TArray<TChatMessage>;
      OnToken: TStreamCallback; OnComplete: TCompleteCallback;
      OnError: TErrorCallback); virtual; abstract;

    // Generation (simple)
    function Generate(const Prompt: string): string; virtual; abstract;

    // Configuration
    procedure SetBaseURL(const URL: string);
    procedure SetApiKey(const Key: string);
    procedure SetModel(const ModelName: string);
    procedure SetTemperature(Value: Single);
    procedure SetMaxTokens(Value: Integer);
    procedure SetTopP(Value: Single);
    procedure SetTopK(Value: Integer);
    procedure SetStream(Value: Boolean);

    // Properties
    property ProviderName: string read GetProviderName;
    property BaseURL: string read FBaseURL write SetBaseURL;
    property ApiKey: string read FApiKey write SetApiKey;
    property Model: string read FModel write SetModel;
    property Temperature: Single read FTemperature write SetTemperature;
    property MaxTokens: Integer read FMaxTokens write SetMaxTokens;
    property TopP: Single read FTopP write SetTopP;
    property TopK: Integer read FTopK write SetTopK;
    property Stream: Boolean read FStream write SetStream;
  end;

  // Helper functions
  function RoleToString(Role: TMessageRole): string;
  function StringToRole(const S: string): TMessageRole;

implementation

function RoleToString(Role: TMessageRole): string;
begin
  case Role of
    mrSystem: Result := 'system';
    mrUser: Result := 'user';
    mrAssistant: Result := 'assistant';
  else
    Result := 'user';
  end;
end;

function StringToRole(const S: string): TMessageRole;
begin
  if SameText(S, 'system') then
    Result := mrSystem
  else if SameText(S, 'assistant') then
    Result := mrAssistant
  else
    Result := mrUser;
end;

{ TAPIBase }

constructor TAPIBase.Create;
begin
  inherited;
  FHTTP := THTTPClient.Create;
  FTemperature := 0.7;
  FMaxTokens := 2048;
  FTopP := 0.9;
  FTopK := 40;
  FStream := True;
end;

destructor TAPIBase.Destroy;
begin
  FHTTP.Free;
  inherited;
end;

procedure TAPIBase.SetBaseURL(const URL: string);
begin
  FBaseURL := URL;
end;

procedure TAPIBase.SetApiKey(const Key: string);
begin
  FApiKey := Key;
  if Key <> '' then
    FHTTP.SetHeader('Authorization', 'Bearer ' + Key);
end;

procedure TAPIBase.SetModel(const ModelName: string);
begin
  FModel := ModelName;
end;

procedure TAPIBase.SetTemperature(Value: Single);
begin
  FTemperature := Value;
end;

procedure TAPIBase.SetMaxTokens(Value: Integer);
begin
  FMaxTokens := Value;
end;

procedure TAPIBase.SetTopP(Value: Single);
begin
  FTopP := Value;
end;

procedure TAPIBase.SetTopK(Value: Integer);
begin
  FTopK := Value;
end;

procedure TAPIBase.SetStream(Value: Boolean);
begin
  FStream := Value;
end;

end.
