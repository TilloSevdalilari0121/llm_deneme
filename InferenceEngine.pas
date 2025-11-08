unit InferenceEngine;

{$IFDEF FPC}
  {$MODE DELPHI}
{$ENDIF}

interface

uses
  System.SysUtils, System.Classes, System.SyncObjs, LlamaCppBindings, SettingsManager;

type
  TInferenceParams = record
    Temperature: Single;
    TopP: Single;
    TopK: Integer;
    MaxTokens: Integer;
    ContextSize: Integer;
    GPULayers: Integer;
    MainGPU: Integer;
    Threads: Integer;
    StopSequences: TArray<string>;
  end;

  TTokenCallback = procedure(const Token: string) of object;
  TCompleteCallback = procedure(const FullText: string; TokenCount: Integer) of object;
  TErrorCallback = procedure(const ErrorMsg: string) of object;

  TInferenceEngine = class
  private
    FModel: llama_model;
    FContext: llama_context;
    FModelPath: string;
    FParams: TInferenceParams;
    FIsLoaded: Boolean;
    FGenerating: Boolean;
    FCancelFlag: Boolean;

    procedure ApplyParams;
    function TokenToString(Token: llama_token): string;
    function ShouldStop(const Token: llama_token; const Generated: string): Boolean;
  public
    constructor Create;
    destructor Destroy; override;

    // Model loading
    function LoadModel(const ModelPath: string): Boolean;
    procedure UnloadModel;
    function IsModelLoaded: Boolean;

    // Inference
    procedure Generate(const Prompt: string;
      OnToken: TTokenCallback;
      OnComplete: TCompleteCallback;
      OnError: TErrorCallback);

    procedure CancelGeneration;

    // Parameters
    procedure SetParams(const Params: TInferenceParams);
    function GetParams: TInferenceParams;
    procedure LoadDefaultParams;

    // Properties
    property ModelPath: string read FModelPath;
    property IsLoaded: Boolean read FIsLoaded;
    property IsGenerating: Boolean read FGenerating;
  end;

implementation

constructor TInferenceEngine.Create;
begin
  inherited Create;
  FModel := nil;
  FContext := nil;
  FIsLoaded := False;
  FGenerating := False;
  FCancelFlag := False;
  LoadDefaultParams;
  llama_backend_init(False);
end;

destructor TInferenceEngine.Destroy;
begin
  UnloadModel;
  llama_backend_free;
  inherited;
end;

procedure TInferenceEngine.LoadDefaultParams;
begin
  FParams.Temperature := TSettingsManager.GetDefaultTemperature;
  FParams.TopP := TSettingsManager.GetDefaultTopP;
  FParams.TopK := TSettingsManager.GetDefaultTopK;
  FParams.MaxTokens := TSettingsManager.GetDefaultMaxTokens;
  FParams.ContextSize := TSettingsManager.GetDefaultContextSize;
  FParams.GPULayers := TSettingsManager.GetGPULayers;
  FParams.MainGPU := TSettingsManager.GetMainGPU;
  FParams.Threads := TSettingsManager.GetThreads;
  SetLength(FParams.StopSequences, 0);
end;

procedure TInferenceEngine.SetParams(const Params: TInferenceParams);
begin
  FParams := Params;
end;

function TInferenceEngine.GetParams: TInferenceParams;
begin
  Result := FParams;
end;

function TInferenceEngine.LoadModel(const ModelPath: string): Boolean;
var
  ModelParams: llama_model_params;
  ContextParams: llama_context_params;
begin
  Result := False;

  if FIsLoaded then
    UnloadModel;

  if not FileExists(ModelPath) then
    Exit(False);

  try
    // Setup model parameters
    ModelParams := llama_model_default_params;
    ModelParams.n_gpu_layers := FParams.GPULayers;
    ModelParams.main_gpu := FParams.MainGPU;
    ModelParams.use_mmap := True;
    ModelParams.use_mlock := False;

    // Load model
    FModel := llama_load_model_from_file(PAnsiChar(AnsiString(ModelPath)), ModelParams);
    if FModel = nil then
      Exit(False);

    // Setup context parameters
    ContextParams := llama_context_default_params;
    ContextParams.n_ctx := FParams.ContextSize;
    ContextParams.n_batch := 512;
    ContextParams.n_threads := FParams.Threads;
    ContextParams.n_threads_batch := FParams.Threads;
    ContextParams.seed := 12345; // Or use random seed

    // Create context
    FContext := llama_new_context_with_model(FModel, ContextParams);
    if FContext = nil then
    begin
      llama_free_model(FModel);
      FModel := nil;
      Exit(False);
    end;

    FModelPath := ModelPath;
    FIsLoaded := True;
    Result := True;
  except
    on E: Exception do
    begin
      if FContext <> nil then
      begin
        llama_free(FContext);
        FContext := nil;
      end;
      if FModel <> nil then
      begin
        llama_free_model(FModel);
        FModel := nil;
      end;
      Result := False;
    end;
  end;
end;

procedure TInferenceEngine.UnloadModel;
begin
  if FContext <> nil then
  begin
    llama_free(FContext);
    FContext := nil;
  end;

  if FModel <> nil then
  begin
    llama_free_model(FModel);
    FModel := nil;
  end;

  FIsLoaded := False;
  FModelPath := '';
end;

function TInferenceEngine.IsModelLoaded: Boolean;
begin
  Result := FIsLoaded;
end;

function TInferenceEngine.TokenToString(Token: llama_token): string;
var
  Buffer: array[0..255] of AnsiChar;
  Len: Integer;
begin
  FillChar(Buffer, SizeOf(Buffer), 0);
  Len := llama_token_to_piece(FModel, Token, @Buffer[0], Length(Buffer));

  if Len > 0 then
    Result := string(Copy(Buffer, 0, Len))
  else
    Result := '';
end;

function TInferenceEngine.ShouldStop(const Token: llama_token; const Generated: string): Boolean;
var
  StopSeq: string;
begin
  Result := False;

  // Check EOS token
  if Token = llama_token_eos(FModel) then
    Exit(True);

  // Check stop sequences
  for StopSeq in FParams.StopSequences do
  begin
    if Generated.EndsWith(StopSeq) then
      Exit(True);
  end;
end;

procedure TInferenceEngine.Generate(const Prompt: string;
  OnToken: TTokenCallback;
  OnComplete: TCompleteCallback;
  OnError: TErrorCallback);
var
  Tokens: array of llama_token;
  TokenCount: Integer;
  Batch: llama_batch;
  NewToken: llama_token;
  Logits: PSingle;
  Candidates: array of llama_token_data;
  CandidatesArray: llama_token_data_array;
  I, GeneratedCount: Integer;
  TokenStr, FullText: string;
  VocabSize: Integer;
begin
  if not FIsLoaded then
  begin
    if Assigned(OnError) then
      OnError('Model not loaded');
    Exit;
  end;

  if FGenerating then
  begin
    if Assigned(OnError) then
      OnError('Already generating');
    Exit;
  end;

  FGenerating := True;
  FCancelFlag := False;
  FullText := '';
  GeneratedCount := 0;

  try
    // Tokenize prompt
    SetLength(Tokens, Length(Prompt) + 1024);
    TokenCount := llama_tokenize(FModel, PAnsiChar(AnsiString(Prompt)), Length(Prompt),
      @Tokens[0], Length(Tokens), True, True);

    if TokenCount < 0 then
    begin
      if Assigned(OnError) then
        OnError('Failed to tokenize prompt');
      Exit;
    end;

    SetLength(Tokens, TokenCount);

    // Create batch
    Batch := llama_batch_init(512, 0, 1);
    try
      // Clear KV cache
      llama_kv_cache_clear(FContext);

      // Process prompt tokens
      Batch.n_tokens := TokenCount;
      Batch.token := @Tokens[0];
      Batch.logits := nil; // We'll get logits for last token

      if llama_decode(FContext, Batch) <> 0 then
      begin
        if Assigned(OnError) then
          OnError('Failed to process prompt');
        Exit;
      end;

      // Get vocabulary size
      VocabSize := llama_n_vocab(FModel);

      // Generation loop
      while (GeneratedCount < FParams.MaxTokens) and (not FCancelFlag) do
      begin
        // Get logits
        Logits := llama_get_logits_ith(FContext, TokenCount - 1 + GeneratedCount);

        // Build candidates array
        SetLength(Candidates, VocabSize);
        for I := 0 to VocabSize - 1 do
        begin
          Candidates[I].id := I;
          Candidates[I].logit := Logits[I];
          Candidates[I].p := 0.0;
        end;

        CandidatesArray.data := @Candidates[0];
        CandidatesArray.size := VocabSize;
        CandidatesArray.sorted := False;

        // Apply sampling
        llama_sample_top_k(FContext, CandidatesArray, FParams.TopK, 1);
        llama_sample_top_p(FContext, CandidatesArray, FParams.TopP, 1);
        llama_sample_temp(FContext, CandidatesArray, FParams.Temperature);
        llama_sample_softmax(FContext, CandidatesArray);
        NewToken := llama_sample_token(FContext, CandidatesArray);

        // Convert token to string
        TokenStr := TokenToString(NewToken);
        FullText := FullText + TokenStr;

        // Callback
        if Assigned(OnToken) then
          OnToken(TokenStr);

        // Check stop conditions
        if ShouldStop(NewToken, FullText) then
          Break;

        // Prepare next batch
        Batch.n_tokens := 1;
        Batch.token := @NewToken;

        if llama_decode(FContext, Batch) <> 0 then
          Break;

        Inc(GeneratedCount);
      end;

      // Complete callback
      if Assigned(OnComplete) then
        OnComplete(FullText, GeneratedCount);

    finally
      llama_batch_free(Batch);
    end;

  except
    on E: Exception do
    begin
      if Assigned(OnError) then
        OnError('Generation error: ' + E.Message);
    end;
  end;

  FGenerating := False;
  FCancelFlag := False;
end;

procedure TInferenceEngine.CancelGeneration;
begin
  FCancelFlag := True;
end;

end.
