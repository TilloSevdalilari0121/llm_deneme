unit ModelCompareForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls,
  APIBase, DatabaseManager;

type
  TfrmModelCompare = class(TForm)
    pnlTop: TPanel;
    pnlModel1: TPanel;
    pnlModel2: TPanel;
    pnlModel3: TPanel;
    lblModel1: TLabel;
    lblModel2: TLabel;
    lblModel3: TLabel;
    cmbModel1: TComboBox;
    cmbModel2: TComboBox;
    cmbModel3: TComboBox;
    chkEnableModel3: TCheckBox;
    memoPrompt: TMemo;
    btnCompare: TButton;
    btnClear: TButton;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    memoResponse1: TRichEdit;
    memoResponse2: TRichEdit;
    memoResponse3: TRichEdit;
    lblStats1: TLabel;
    lblStats2: TLabel;
    lblStats3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnCompareClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure chkEnableModel3Click(Sender: TObject);
  private
    FGenerating: Boolean;
    FStartTime1, FStartTime2, FStartTime3: TDateTime;
    FTokenCount1, FTokenCount2, FTokenCount3: Integer;

    procedure LoadAvailableModels;
    procedure CompareModels;
    procedure OnToken1(const Token: string);
    procedure OnToken2(const Token: string);
    procedure OnToken3(const Token: string);
    procedure OnComplete1(const FullText: string; Tokens: Integer);
    procedure OnComplete2(const FullText: string; Tokens: Integer);
    procedure OnComplete3(const FullText: string; Tokens: Integer);
    procedure UpdateStats(LabelNum: Integer; Tokens: Integer; Duration: Double);
  public
    { Public declarations }
  end;

var
  frmModelCompare: TfrmModelCompare;

implementation

uses
  MainForm, ThemeManager, System.DateUtils;

{$R *.dfm}

procedure TfrmModelCompare.FormCreate(Sender: TObject);
begin
  LoadAvailableModels;
  FGenerating := False;
  pnlModel3.Enabled := False;
  memoResponse3.Enabled := False;
end;

procedure TfrmModelCompare.LoadAvailableModels;
var
  Models: TArray<string>;
  I: Integer;
begin
  cmbModel1.Clear;
  cmbModel2.Clear;
  cmbModel3.Clear;

  // Get available models from current API
  if Assigned(frmMain.CurrentAPI) then
  begin
    Models := frmMain.CurrentAPI.GetAvailableModels;
    for I := 0 to High(Models) do
    begin
      cmbModel1.Items.Add(Models[I]);
      cmbModel2.Items.Add(Models[I]);
      cmbModel3.Items.Add(Models[I]);
    end;

    if cmbModel1.Items.Count > 0 then
    begin
      cmbModel1.ItemIndex := 0;
      if cmbModel2.Items.Count > 1 then
        cmbModel2.ItemIndex := 1
      else
        cmbModel2.ItemIndex := 0;
      if cmbModel3.Items.Count > 2 then
        cmbModel3.ItemIndex := 2
      else if cmbModel3.Items.Count > 0 then
        cmbModel3.ItemIndex := 0;
    end;
  end;
end;

procedure TfrmModelCompare.chkEnableModel3Click(Sender: TObject);
begin
  pnlModel3.Enabled := chkEnableModel3.Checked;
  memoResponse3.Enabled := chkEnableModel3.Checked;
end;

procedure TfrmModelCompare.btnClearClick(Sender: TObject);
begin
  memoPrompt.Clear;
  memoResponse1.Clear;
  memoResponse2.Clear;
  memoResponse3.Clear;
  lblStats1.Caption := 'Waiting...';
  lblStats2.Caption := 'Waiting...';
  lblStats3.Caption := 'Waiting...';
end;

procedure TfrmModelCompare.btnCompareClick(Sender: TObject);
begin
  if Trim(memoPrompt.Text) = '' then
  begin
    ShowMessage('Please enter a prompt to compare.');
    Exit;
  end;

  if not Assigned(frmMain.CurrentAPI) then
  begin
    ShowMessage('No API selected!');
    Exit;
  end;

  CompareModels;
end;

procedure TfrmModelCompare.CompareModels;
var
  Messages: TArray<TChatMessage>;
  OriginalModel: string;
begin
  FGenerating := True;
  btnCompare.Enabled := False;
  memoResponse1.Clear;
  memoResponse2.Clear;
  memoResponse3.Clear;
  FTokenCount1 := 0;
  FTokenCount2 := 0;
  FTokenCount3 := 0;

  // Build message
  SetLength(Messages, 1);
  Messages[0].Role := mrUser;
  Messages[0].Content := Trim(memoPrompt.Text);

  // Save original model
  OriginalModel := frmMain.CurrentAPI.Model;

  // Model 1
  TThread.CreateAnonymousThread(
    procedure
    begin
      TThread.Synchronize(nil,
        procedure
        begin
          FStartTime1 := Now;
          frmMain.CurrentAPI.Model := cmbModel1.Text;
        end
      );
      frmMain.CurrentAPI.ChatStream(Messages, OnToken1, OnComplete1, nil);
    end
  ).Start;

  // Model 2
  TThread.CreateAnonymousThread(
    procedure
    begin
      TThread.Synchronize(nil,
        procedure
        begin
          FStartTime2 := Now;
          frmMain.CurrentAPI.Model := cmbModel2.Text;
        end
      );
      frmMain.CurrentAPI.ChatStream(Messages, OnToken2, OnComplete2, nil);
    end
  ).Start;

  // Model 3 (if enabled)
  if chkEnableModel3.Checked then
  begin
    TThread.CreateAnonymousThread(
      procedure
      begin
        TThread.Synchronize(nil,
          procedure
          begin
            FStartTime3 := Now;
            frmMain.CurrentAPI.Model := cmbModel3.Text;
          end
        );
        frmMain.CurrentAPI.ChatStream(Messages, OnToken3, OnComplete3, nil);
      end
    ).Start;
  end;

  // Restore original model
  frmMain.CurrentAPI.Model := OriginalModel;
end;

procedure TfrmModelCompare.OnToken1(const Token: string);
begin
  TThread.Synchronize(nil,
    procedure
    begin
      memoResponse1.SelText := Token;
      Inc(FTokenCount1);
    end
  );
end;

procedure TfrmModelCompare.OnToken2(const Token: string);
begin
  TThread.Synchronize(nil,
    procedure
    begin
      memoResponse2.SelText := Token;
      Inc(FTokenCount2);
    end
  );
end;

procedure TfrmModelCompare.OnToken3(const Token: string);
begin
  TThread.Synchronize(nil,
    procedure
    begin
      memoResponse3.SelText := Token;
      Inc(FTokenCount3);
    end
  );
end;

procedure TfrmModelCompare.OnComplete1(const FullText: string; Tokens: Integer);
var
  Duration: Double;
begin
  TThread.Synchronize(nil,
    procedure
    begin
      Duration := SecondsBetween(Now, FStartTime1);
      UpdateStats(1, Tokens, Duration);
    end
  );
end;

procedure TfrmModelCompare.OnComplete2(const FullText: string; Tokens: Integer);
var
  Duration: Double;
begin
  TThread.Synchronize(nil,
    procedure
    begin
      Duration := SecondsBetween(Now, FStartTime2);
      UpdateStats(2, Tokens, Duration);
    end
  );
end;

procedure TfrmModelCompare.OnComplete3(const FullText: string; Tokens: Integer);
var
  Duration: Double;
begin
  TThread.Synchronize(nil,
    procedure
    begin
      Duration := SecondsBetween(Now, FStartTime3);
      UpdateStats(3, Tokens, Duration);
      btnCompare.Enabled := True;
      FGenerating := False;
    end
  );
end;

procedure TfrmModelCompare.UpdateStats(LabelNum: Integer; Tokens: Integer; Duration: Double);
var
  TokensPerSec: Double;
  StatsText: string;
begin
  if Duration > 0 then
    TokensPerSec := Tokens / Duration
  else
    TokensPerSec := 0;

  StatsText := Format('Tokens: %d | Duration: %.2fs | Speed: %.2f tok/s',
    [Tokens, Duration, TokensPerSec]);

  case LabelNum of
    1: lblStats1.Caption := StatsText;
    2: lblStats2.Caption := StatsText;
    3: lblStats3.Caption := StatsText;
  end;
end;

end.
