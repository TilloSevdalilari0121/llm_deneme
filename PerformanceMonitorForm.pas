unit PerformanceMonitorForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls, System.Generics.Collections,
  PerformanceTracker;

type
  TfrmPerformanceMonitor = class(TForm)
    pnlTop: TPanel;
    pnlStats: TPanel;
    lstLogs: TListView;
    lblLogs: TLabel;
    btnRefresh: TButton;
    btnClear: TButton;
    btnExport: TButton;
    lblTotalRequests: TLabel;
    lblTotalTokens: TLabel;
    lblAvgTokens: TLabel;
    lblAvgDuration: TLabel;
    cmbFilter: TComboBox;
    lblFilter: TLabel;
    SaveDialog: TSaveDialog;
    procedure FormCreate(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
    procedure cmbFilterChange(Sender: TObject);
  private
    procedure LoadLogs;
    procedure UpdateStats;
    procedure ExportToCSV(const FileName: string);
  public
    { Public declarations }
  end;

var
  frmPerformanceMonitor: TfrmPerformanceMonitor;

implementation

uses
  DatabaseManager;

{$R *.dfm}

procedure TfrmPerformanceMonitor.FormCreate(Sender: TObject);
begin
  lstLogs.ViewStyle := vsReport;
  lstLogs.Columns.Add.Caption := 'Date/Time';
  lstLogs.Columns.Add.Caption := 'Provider';
  lstLogs.Columns.Add.Caption := 'Model';
  lstLogs.Columns.Add.Caption := 'Tokens';
  lstLogs.Columns.Add.Caption := 'Duration';
  lstLogs.Columns.Add.Caption := 'Tokens/sec';
  lstLogs.Columns[0].Width := 150;
  lstLogs.Columns[1].Width := 100;
  lstLogs.Columns[2].Width := 150;
  lstLogs.Columns[3].Width := 80;
  lstLogs.Columns[4].Width := 80;
  lstLogs.Columns[5].Width := 100;

  cmbFilter.Items.Add('All Providers');
  cmbFilter.Items.Add('Ollama');
  cmbFilter.Items.Add('LM Studio');
  cmbFilter.Items.Add('Jan');
  cmbFilter.ItemIndex := 0;

  SaveDialog.Filter := 'CSV Files (*.csv)|*.csv|All Files (*.*)|*.*';

  LoadLogs;
end;

procedure TfrmPerformanceMonitor.LoadLogs;
var
  Logs: TArray<TPerformanceLog>;
  I: Integer;
  Item: TListItem;
  FilterProvider: string;
  TokensPerSec: Double;
begin
  lstLogs.Clear;

  if cmbFilter.ItemIndex > 0 then
    FilterProvider := cmbFilter.Text
  else
    FilterProvider := '';

  Logs := TPerformanceTracker.GetLogs(FilterProvider);

  for I := 0 to High(Logs) do
  begin
    Item := lstLogs.Items.Add;
    Item.Caption := DateTimeToStr(Logs[I].Timestamp);
    Item.SubItems.Add(Logs[I].Provider);
    Item.SubItems.Add(Logs[I].Model);
    Item.SubItems.Add(IntToStr(Logs[I].TokenCount));
    Item.SubItems.Add(Format('%.2fs', [Logs[I].Duration]));

    if Logs[I].Duration > 0 then
      TokensPerSec := Logs[I].TokenCount / Logs[I].Duration
    else
      TokensPerSec := 0;

    Item.SubItems.Add(Format('%.2f', [TokensPerSec]));
  end;

  UpdateStats;
end;

procedure TfrmPerformanceMonitor.UpdateStats;
var
  Stats: TPerformanceStats;
  FilterProvider: string;
begin
  if cmbFilter.ItemIndex > 0 then
    FilterProvider := cmbFilter.Text
  else
    FilterProvider := '';

  Stats := TPerformanceTracker.GetStats(FilterProvider);

  lblTotalRequests.Caption := Format('Total Requests: %d', [Stats.TotalRequests]);
  lblTotalTokens.Caption := Format('Total Tokens: %d', [Stats.TotalTokens]);
  lblAvgTokens.Caption := Format('Avg Tokens/Request: %.2f', [Stats.AvgTokensPerRequest]);
  lblAvgDuration.Caption := Format('Avg Duration: %.2fs', [Stats.AvgDuration]);
end;

procedure TfrmPerformanceMonitor.btnRefreshClick(Sender: TObject);
begin
  LoadLogs;
end;

procedure TfrmPerformanceMonitor.btnClearClick(Sender: TObject);
begin
  if MessageDlg('Clear all performance logs?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    TPerformanceTracker.ClearLogs;
    LoadLogs;
  end;
end;

procedure TfrmPerformanceMonitor.cmbFilterChange(Sender: TObject);
begin
  LoadLogs;
end;

procedure TfrmPerformanceMonitor.btnExportClick(Sender: TObject);
begin
  if SaveDialog.Execute then
  begin
    ExportToCSV(SaveDialog.FileName);
    ShowMessage('Logs exported successfully to: ' + SaveDialog.FileName);
  end;
end;

procedure TfrmPerformanceMonitor.ExportToCSV(const FileName: string);
var
  CSV: TStringList;
  I: Integer;
  Line: string;
begin
  CSV := TStringList.Create;
  try
    // Header
    CSV.Add('Date/Time,Provider,Model,Tokens,Duration,Tokens/sec');

    // Data
    for I := 0 to lstLogs.Items.Count - 1 do
    begin
      Line := lstLogs.Items[I].Caption;
      Line := Line + ',' + lstLogs.Items[I].SubItems[0]; // Provider
      Line := Line + ',' + lstLogs.Items[I].SubItems[1]; // Model
      Line := Line + ',' + lstLogs.Items[I].SubItems[2]; // Tokens
      Line := Line + ',' + lstLogs.Items[I].SubItems[3]; // Duration
      Line := Line + ',' + lstLogs.Items[I].SubItems[4]; // Tokens/sec
      CSV.Add(Line);
    end;

    CSV.SaveToFile(FileName);
  finally
    CSV.Free;
  end;
end;

end.
