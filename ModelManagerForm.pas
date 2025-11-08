unit ModelManagerForm;

{$IFDEF FPC}
  {$MODE DELPHI}
{$ENDIF}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Grids, ModelManager, SettingsManager;

type
  TfrmModelManager = class(TForm)
    pnlTop: TPanel;
    btnAddModel: TButton;
    btnRemoveModel: TButton;
    btnScanOllama: TButton;
    btnScanLMStudio: TButton;
    btnScanJan: TButton;
    btnRefresh: TButton;
    lstModels: TListBox;
    pnlBottom: TPanel;
    btnClose: TButton;
    lblInfo: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnAddModelClick(Sender: TObject);
    procedure btnRemoveModelClick(Sender: TObject);
    procedure btnScanOllamaClick(Sender: TObject);
    procedure btnScanLMStudioClick(Sender: TObject);
    procedure btnScanJanClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
  private
    procedure LoadModels;
    procedure ScanAndAddModels(const Path: string; ScanFunc: function(const Path: string): TArray<string> of object);
  public
    { Public declarations }
  end;

var
  frmModelManager: TfrmModelManager;

implementation

{$R *.dfm}

procedure TfrmModelManager.FormCreate(Sender: TObject);
begin
  LoadModels;
end;

procedure TfrmModelManager.LoadModels;
var
  Models: TArray<TModelInfo>;
  Model: TModelInfo;
begin
  lstModels.Clear;
  Models := TModelManager.GetAllModels;

  for Model in Models do
    lstModels.Items.AddObject(
      Format('%s - %s (%s)', [Model.Name, Model.ModelType, Model.SizeFormatted]),
      TObject(Model.ID)
    );

  lblInfo.Caption := Format('Total Models: %d', [Length(Models)]);
end;

procedure TfrmModelManager.btnAddModelClick(Sender: TObject);
var
  OpenDialog: TOpenDialog;
begin
  OpenDialog := TOpenDialog.Create(Self);
  try
    OpenDialog.Filter := 'GGUF Files (*.gguf)|*.gguf|BIN Files (*.bin)|*.bin|All Files (*.*)|*.*';
    OpenDialog.Title := 'Select Model File';

    if OpenDialog.Execute then
    begin
      try
        TModelManager.AddModel(OpenDialog.FileName);
        LoadModels;
        ShowMessage('Model added successfully!');
      except
        on E: Exception do
          ShowMessage('Error adding model: ' + E.Message);
      end;
    end;
  finally
    OpenDialog.Free;
  end;
end;

procedure TfrmModelManager.btnRemoveModelClick(Sender: TObject);
var
  ModelID: Int64;
begin
  if lstModels.ItemIndex < 0 then
  begin
    ShowMessage('Please select a model to remove!');
    Exit;
  end;

  if MessageDlg('Remove this model from the list?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    ModelID := Int64(lstModels.Items.Objects[lstModels.ItemIndex]);
    TModelManager.RemoveModel(ModelID);
    LoadModels;
  end;
end;

procedure TfrmModelManager.ScanAndAddModels(const Path: string;
  ScanFunc: function(const Path: string): TArray<string> of object);
var
  Models: TArray<string>;
  ModelPath: string;
  Added: Integer;
begin
  if Path = '' then
  begin
    ShowMessage('Please configure this path in Settings first!');
    Exit;
  end;

  Models := ScanFunc(Path);
  Added := 0;

  for ModelPath in Models do
  begin
    try
      if not TModelManager.ModelExists(ModelPath) then
      begin
        TModelManager.AddModel(ModelPath);
        Inc(Added);
      end;
    except
      // Skip invalid models
    end;
  end;

  LoadModels;
  ShowMessage(Format('Added %d new models', [Added]));
end;

procedure TfrmModelManager.btnScanOllamaClick(Sender: TObject);
begin
  ScanAndAddModels(TSettingsManager.GetOllamaPath, TModelManager.ScanOllamaModels);
end;

procedure TfrmModelManager.btnScanLMStudioClick(Sender: TObject);
begin
  ScanAndAddModels(TSettingsManager.GetLMStudioPath, TModelManager.ScanLMStudioModels);
end;

procedure TfrmModelManager.btnScanJanClick(Sender: TObject);
begin
  ScanAndAddModels(TSettingsManager.GetJanPath, TModelManager.ScanJanModels);
end;

procedure TfrmModelManager.btnRefreshClick(Sender: TObject);
begin
  LoadModels;
end;

procedure TfrmModelManager.btnCloseClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

end.
