unit BenchmarkForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls, System.Generics.Collections,
  APIBase;

type
  TBenchmarkResult = record
    Model: string;
    PromptTokens: Integer;
    ResponseTokens: Integer;
    TotalTime: Double;
    TokensPerSecond: Double;
    FirstTokenTime: Double;
  end;

  TfrmBenchmark = class(TForm)
    pnlTop: TPanel;
    pnlResults: TPanel;
    cmbModel: TComboBox;
    lblModel: TLabel;
    btnRun: TButton;
    btnClear: TButton;
    memoPrompt: TMemo;
    lblPrompt: TLabel;
    lstResults: TListView;
    lblResults: TLabel;
    memoResponse: TMemo;
    lblResponse: TLabel;
    progressBench: TProgressBar;
    lblStatus: TLabel;
    cmbTestType: TComboBox;
    lblTestType: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnRunClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure cmbTestTypeChange(Sender: TObject);
  private
    FResults: TList<TBenchmarkResult>;
    FRunning: Boolean;
    FStartTime: TDateTime;
    FFirstTokenTime: TDateTime;
    FTokenCount: Integer;

    procedure LoadModels;
    procedure RunBenchmark;
    procedure AddResult(const Result: TBenchmarkResult);
    procedure OnToken(const Token: string);
    procedure OnComplete(const FullText: string; Tokens: Integer);
    function GetTestPrompt(TestType: Integer): string;
  public
    destructor Destroy; override;
  end;

var
  frmBenchmark: TfrmBenchmark;

implementation

uses
  MainForm, System.DateUtils;

{$R *.dfm}

procedure TfrmBenchmark.FormCreate(Sender: TObject);
begin
  FResults := TList<TBenchmarkResult>.Create;
  FRunning := False;

  lstResults.ViewStyle := vsReport;
  lstResults.Columns.Add.Caption := 'Model';
  lstResults.Columns.Add.Caption := 'Total Time';
  lstResults.Columns.Add.Caption := 'Tokens/sec';
  lstResults.Columns.Add.Caption := 'First Token';
  lstResults.Columns.Add.Caption := 'Response Tokens';
  lstResults.Columns[0].Width := 200;
  lstResults.Columns[1].Width := 100;
  lstResults.Columns[2].Width := 100;
  lstResults.Columns[3].Width := 100;
  lstResults.Columns[4].Width := 120;

  cmbTestType.Items.Add('Quick Test (Short prompt)');
  cmbTestType.Items.Add('Medium Test (Paragraph)');
  cmbTestType.Items.Add('Long Test (Essay)');
  cmbTestType.Items.Add('Code Generation');
  cmbTestType.Items.Add('Math/Reasoning');
  cmbTestType.ItemIndex := 0;

  LoadModels;
  cmbTestTypeChange(nil);
end;

destructor TfrmBenchmark.Destroy;
begin
  FResults.Free;
  inherited;
end;

procedure TfrmBenchmark.LoadModels;
var
  Models: TArray<string>;
  I: Integer;
begin
  cmbModel.Clear;

  if Assigned(frmMain.CurrentAPI) then
  begin
    Models := frmMain.CurrentAPI.GetAvailableModels;
    for I := 0 to High(Models) do
      cmbModel.Items.Add(Models[I]);

    if cmbModel.Items.Count > 0 then
      cmbModel.ItemIndex := 0;
  end;
end;

procedure TfrmBenchmark.cmbTestTypeChange(Sender: TObject);
begin
  memoPrompt.Text := GetTestPrompt(cmbTestType.ItemIndex);
end;

function TfrmBenchmark.GetTestPrompt(TestType: Integer): string;
begin
  case TestType of
    0: Result := 'What is artificial intelligence?';
    1: Result := 'Explain the concept of machine learning and how it differs from traditional programming. Include at least three key differences.';
    2: Result := 'Write a comprehensive essay about the impact of artificial intelligence on modern society, covering economic, social, and ethical implications. The essay should be at least 500 words.';
    3: Result := 'Write a Python function that implements binary search on a sorted array. Include error handling and documentation.';
    4: Result := 'Solve this problem step by step: If a train travels at 60 mph for 2.5 hours, then 80 mph for 1.5 hours, what is the total distance traveled and the average speed?';
  else
    Result := 'Hello, how are you?';
  end;
end;

procedure TfrmBenchmark.btnClearClick(Sender: TObject);
begin
  lstResults.Clear;
  memoResponse.Clear;
  FResults.Clear;
end;

procedure TfrmBenchmark.btnRunClick(Sender: TObject);
begin
  if Trim(memoPrompt.Text) = '' then
  begin
    ShowMessage('Please enter a prompt for benchmarking.');
    Exit;
  end;

  if not Assigned(frmMain.CurrentAPI) then
  begin
    ShowMessage('No API selected!');
    Exit;
  end;

  RunBenchmark;
end;

procedure TfrmBenchmark.RunBenchmark;
var
  Messages: TArray<TChatMessage>;
begin
  FRunning := True;
  btnRun.Enabled := False;
  memoResponse.Clear;
  progressBench.Visible := True;
  FTokenCount := 0;
  FFirstTokenTime := 0;

  lblStatus.Caption := 'Running benchmark...';

  SetLength(Messages, 1);
  Messages[0].Role := mrUser;
  Messages[0].Content := Trim(memoPrompt.Text);

  FStartTime := Now;

  TThread.CreateAnonymousThread(
    procedure
    begin
      frmMain.CurrentAPI.Model := cmbModel.Text;
      frmMain.CurrentAPI.ChatStream(Messages, OnToken, OnComplete, nil);
    end
  ).Start;
end;

procedure TfrmBenchmark.OnToken(const Token: string);
begin
  TThread.Synchronize(nil,
    procedure
    begin
      if FFirstTokenTime = 0 then
        FFirstTokenTime := Now;

      memoResponse.Text := memoResponse.Text + Token;
      Inc(FTokenCount);
    end
  );
end;

procedure TfrmBenchmark.OnComplete(const FullText: string; Tokens: Integer);
var
  BenchResult: TBenchmarkResult;
  Duration: Double;
begin
  TThread.Synchronize(nil,
    procedure
    begin
      Duration := SecondsBetween(Now, FStartTime);

      BenchResult.Model := cmbModel.Text;
      BenchResult.PromptTokens := 0; // TODO: Calculate from prompt
      BenchResult.ResponseTokens := Tokens;
      BenchResult.TotalTime := Duration;
      if Duration > 0 then
        BenchResult.TokensPerSecond := Tokens / Duration
      else
        BenchResult.TokensPerSecond := 0;
      BenchResult.FirstTokenTime := SecondsBetween(FFirstTokenTime, FStartTime);

      AddResult(BenchResult);

      lblStatus.Caption := Format('Completed: %.2f tokens/sec', [BenchResult.TokensPerSecond]);
      progressBench.Visible := False;
      btnRun.Enabled := True;
      FRunning := False;
    end
  );
end;

procedure TfrmBenchmark.AddResult(const Result: TBenchmarkResult);
var
  Item: TListItem;
begin
  FResults.Add(Result);

  Item := lstResults.Items.Add;
  Item.Caption := Result.Model;
  Item.SubItems.Add(Format('%.2fs', [Result.TotalTime]));
  Item.SubItems.Add(Format('%.2f', [Result.TokensPerSecond]));
  Item.SubItems.Add(Format('%.2fs', [Result.FirstTokenTime]));
  Item.SubItems.Add(IntToStr(Result.ResponseTokens));
end;

end.
