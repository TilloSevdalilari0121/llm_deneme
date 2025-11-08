unit CodeExecutionForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls,
  CodeExecutor;

type
  TfrmCodeExecution = class(TForm)
    pnlTop: TPanel;
    pnlCode: TPanel;
    pnlOutput: TPanel;
    Splitter1: TSplitter;
    cmbLanguage: TComboBox;
    lblLanguage: TLabel;
    btnRun: TButton;
    btnClear: TButton;
    btnStop: TButton;
    memoCode: TMemo;
    lblCode: TLabel;
    memoOutput: TMemo;
    lblOutput: TLabel;
    chkSandbox: TCheckBox;
    lblStatus: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnRunClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure cmbLanguageChange(Sender: TObject);
  private
    FRunning: Boolean;
    procedure LoadLanguages;
    procedure ExecuteCode;
    procedure LoadSampleCode(const Language: string);
  public
    { Public declarations }
  end;

var
  frmCodeExecution: TfrmCodeExecution;

implementation

{$R *.dfm}

procedure TfrmCodeExecution.FormCreate(Sender: TObject);
begin
  FRunning := False;
  btnStop.Enabled := False;
  LoadLanguages;
  cmbLanguageChange(nil);
end;

procedure TfrmCodeExecution.LoadLanguages;
begin
  cmbLanguage.Items.Add('Python');
  cmbLanguage.Items.Add('JavaScript (Node.js)');
  cmbLanguage.Items.Add('PowerShell');
  cmbLanguage.Items.Add('Batch');
  cmbLanguage.ItemIndex := 0;
end;

procedure TfrmCodeExecution.cmbLanguageChange(Sender: TObject);
begin
  LoadSampleCode(cmbLanguage.Text);
end;

procedure TfrmCodeExecution.LoadSampleCode(const Language: string);
begin
  if Pos('Python', Language) > 0 then
  begin
    memoCode.Text := '# Python Example' + #13#10 +
      'print("Hello from Python!")' + #13#10 +
      '' + #13#10 +
      'for i in range(5):' + #13#10 +
      '    print(f"Count: {i}")';
  end
  else if Pos('JavaScript', Language) > 0 then
  begin
    memoCode.Text := '// JavaScript Example' + #13#10 +
      'console.log("Hello from Node.js!");' + #13#10 +
      '' + #13#10 +
      'for (let i = 0; i < 5; i++) {' + #13#10 +
      '    console.log(`Count: ${i}`);' + #13#10 +
      '}';
  end
  else if Pos('PowerShell', Language) > 0 then
  begin
    memoCode.Text := '# PowerShell Example' + #13#10 +
      'Write-Host "Hello from PowerShell!"' + #13#10 +
      '' + #13#10 +
      'for ($i = 0; $i -lt 5; $i++) {' + #13#10 +
      '    Write-Host "Count: $i"' + #13#10 +
      '}';
  end
  else if Pos('Batch', Language) > 0 then
  begin
    memoCode.Text := '@echo off' + #13#10 +
      'echo Hello from Batch!' + #13#10 +
      '' + #13#10 +
      'for /L %%i in (0,1,4) do (' + #13#10 +
      '    echo Count: %%i' + #13#10 +
      ')';
  end;
end;

procedure TfrmCodeExecution.btnClearClick(Sender: TObject);
begin
  memoCode.Clear;
  memoOutput.Clear;
  lblStatus.Caption := '';
end;

procedure TfrmCodeExecution.btnStopClick(Sender: TObject);
begin
  // TODO: Implement stop functionality
  FRunning := False;
  btnRun.Enabled := True;
  btnStop.Enabled := False;
  lblStatus.Caption := 'Stopped';
end;

procedure TfrmCodeExecution.btnRunClick(Sender: TObject);
begin
  if Trim(memoCode.Text) = '' then
  begin
    ShowMessage('Please enter code to execute.');
    Exit;
  end;

  if chkSandbox.Checked then
  begin
    if MessageDlg('Execute code in sandbox mode?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
      Exit;
  end
  else
  begin
    if MessageDlg('WARNING: Code will execute with full system access. Continue?',
      mtWarning, [mbYes, mbNo], 0) <> mrYes then
      Exit;
  end;

  ExecuteCode;
end;

procedure TfrmCodeExecution.ExecuteCode;
var
  Language: string;
  Code: string;
  Sandbox: Boolean;
begin
  Language := cmbLanguage.Text;
  Code := memoCode.Text;
  Sandbox := chkSandbox.Checked;

  FRunning := True;
  btnRun.Enabled := False;
  btnStop.Enabled := True;
  memoOutput.Clear;
  lblStatus.Caption := 'Executing...';

  TThread.CreateAnonymousThread(
    procedure
    var
      Output: string;
      Success: Boolean;
    begin
      try
        if Pos('Python', Language) > 0 then
          Output := TCodeExecutor.ExecutePython(Code, Sandbox)
        else if Pos('JavaScript', Language) > 0 then
          Output := TCodeExecutor.ExecuteNode(Code, Sandbox)
        else if Pos('PowerShell', Language) > 0 then
          Output := TCodeExecutor.ExecutePowerShell(Code, Sandbox)
        else if Pos('Batch', Language) > 0 then
          Output := TCodeExecutor.ExecuteBatch(Code, Sandbox)
        else
          Output := 'Unsupported language: ' + Language;

        Success := True;
      except
        on E: Exception do
        begin
          Output := 'Error: ' + E.Message;
          Success := False;
        end;
      end;

      TThread.Synchronize(nil,
        procedure
        begin
          memoOutput.Text := Output;
          if Success then
            lblStatus.Caption := 'Execution completed'
          else
            lblStatus.Caption := 'Execution failed';

          FRunning := False;
          btnRun.Enabled := True;
          btnStop.Enabled := False;
        end
      );
    end
  ).Start;
end;

end.
