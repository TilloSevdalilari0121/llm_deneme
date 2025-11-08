unit ModelManagerForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls, System.Generics.Collections,
  APIBase;

type
  TModelInfo = record
    Name: string;
    Size: string;
    Modified: string;
  end;

  TfrmModelManager = class(TForm)
    pnlTop: TPanel;
    pnlModels: TPanel;
    lstModels: TListView;
    btnRefresh: TButton;
    btnPull: TButton;
    btnDelete: TButton;
    edtModelName: TEdit;
    lblModelName: TLabel;
    memoInfo: TMemo;
    lblInfo: TLabel;
    progressDownload: TProgressBar;
    lblProgress: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure btnPullClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure lstModelsClick(Sender: TObject);
  private
    FModels: TList<TModelInfo>;
    FDownloading: Boolean;

    procedure LoadModels;
    procedure UpdateModelList;
    procedure ShowModelInfo(const ModelName: string);
  public
    destructor Destroy; override;
  end;

var
  frmModelManager: TfrmModelManager;

implementation

uses
  MainForm, OllamaAPI;

{$R *.dfm}

procedure TfrmModelManager.FormCreate(Sender: TObject);
begin
  FModels := TList<TModelInfo>.Create;
  FDownloading := False;

  lstModels.ViewStyle := vsReport;
  lstModels.Columns.Add.Caption := 'Model Name';
  lstModels.Columns.Add.Caption := 'Size';
  lstModels.Columns.Add.Caption := 'Modified';
  lstModels.Columns[0].Width := 300;
  lstModels.Columns[1].Width := 120;
  lstModels.Columns[2].Width := 180;

  LoadModels;
end;

destructor TfrmModelManager.Destroy;
begin
  FModels.Free;
  inherited;
end;

procedure TfrmModelManager.LoadModels;
var
  Models: TArray<string>;
  I: Integer;
  ModelInfo: TModelInfo;
begin
  FModels.Clear;

  if not Assigned(frmMain.CurrentAPI) then
    Exit;

  // Only Ollama supports model management
  if not (frmMain.CurrentAPI is TOllamaAPI) then
  begin
    ShowMessage('Model management is only supported for Ollama API');
    Exit;
  end;

  Models := frmMain.CurrentAPI.GetAvailableModels;

  for I := 0 to High(Models) do
  begin
    ModelInfo.Name := Models[I];
    ModelInfo.Size := 'Unknown';
    ModelInfo.Modified := 'Unknown';
    FModels.Add(ModelInfo);
  end;

  UpdateModelList;
end;

procedure TfrmModelManager.UpdateModelList;
var
  I: Integer;
  Item: TListItem;
begin
  lstModels.Clear;

  for I := 0 to FModels.Count - 1 do
  begin
    Item := lstModels.Items.Add;
    Item.Caption := FModels[I].Name;
    Item.SubItems.Add(FModels[I].Size);
    Item.SubItems.Add(FModels[I].Modified);
  end;
end;

procedure TfrmModelManager.btnRefreshClick(Sender: TObject);
begin
  LoadModels;
end;

procedure TfrmModelManager.btnPullClick(Sender: TObject);
var
  ModelName: string;
  OllamaAPI: TOllamaAPI;
begin
  ModelName := Trim(edtModelName.Text);
  if ModelName = '' then
  begin
    ShowMessage('Please enter a model name to download.');
    Exit;
  end;

  if not (frmMain.CurrentAPI is TOllamaAPI) then
  begin
    ShowMessage('Model pulling is only supported for Ollama API');
    Exit;
  end;

  FDownloading := True;
  btnPull.Enabled := False;
  progressDownload.Visible := True;
  lblProgress.Caption := 'Downloading ' + ModelName + '...';

  OllamaAPI := frmMain.CurrentAPI as TOllamaAPI;

  TThread.CreateAnonymousThread(
    procedure
    var
      Success: Boolean;
    begin
      Success := OllamaAPI.PullModel(ModelName);

      TThread.Synchronize(nil,
        procedure
        begin
          FDownloading := False;
          btnPull.Enabled := True;
          progressDownload.Visible := False;

          if Success then
          begin
            lblProgress.Caption := 'Download completed!';
            LoadModels;
            edtModelName.Clear;
          end
          else
          begin
            lblProgress.Caption := 'Download failed!';
            ShowMessage('Failed to download model: ' + ModelName);
          end;
        end
      );
    end
  ).Start;
end;

procedure TfrmModelManager.btnDeleteClick(Sender: TObject);
var
  ModelName: string;
  OllamaAPI: TOllamaAPI;
begin
  if lstModels.Selected = nil then
  begin
    ShowMessage('Please select a model to delete.');
    Exit;
  end;

  ModelName := lstModels.Selected.Caption;

  if MessageDlg('Delete model "' + ModelName + '"?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    Exit;

  if not (frmMain.CurrentAPI is TOllamaAPI) then
  begin
    ShowMessage('Model deletion is only supported for Ollama API');
    Exit;
  end;

  OllamaAPI := frmMain.CurrentAPI as TOllamaAPI;

  TThread.CreateAnonymousThread(
    procedure
    var
      Success: Boolean;
    begin
      Success := OllamaAPI.DeleteModel(ModelName);

      TThread.Synchronize(nil,
        procedure
        begin
          if Success then
          begin
            ShowMessage('Model deleted successfully');
            LoadModels;
          end
          else
            ShowMessage('Failed to delete model: ' + ModelName);
        end
      );
    end
  ).Start;
end;

procedure TfrmModelManager.lstModelsClick(Sender: TObject);
begin
  if lstModels.Selected <> nil then
    ShowModelInfo(lstModels.Selected.Caption);
end;

procedure TfrmModelManager.ShowModelInfo(const ModelName: string);
begin
  memoInfo.Clear;
  memoInfo.Lines.Add('Model: ' + ModelName);
  memoInfo.Lines.Add('');
  memoInfo.Lines.Add('To download a new model:');
  memoInfo.Lines.Add('1. Enter the model name (e.g., llama2, mistral, codellama)');
  memoInfo.Lines.Add('2. Click "Pull Model"');
  memoInfo.Lines.Add('');
  memoInfo.Lines.Add('Popular models:');
  memoInfo.Lines.Add('- llama2:7b - Fast, general purpose');
  memoInfo.Lines.Add('- llama2:13b - Better quality');
  memoInfo.Lines.Add('- mistral:7b - High performance');
  memoInfo.Lines.Add('- codellama:7b - Code specialized');
  memoInfo.Lines.Add('- phi:2.7b - Small and fast');
end;

end.
