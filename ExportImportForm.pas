unit ExportImportForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls,
  ExportImport, DatabaseManager;

type
  TfrmExportImport = class(TForm)
    PageControl: TPageControl;
    tabExport: TTabSheet;
    tabImport: TTabSheet;
    pnlExport: TPanel;
    lblExportConv: TLabel;
    lstConversations: TListBox;
    btnExportSelected: TButton;
    btnExportAll: TButton;
    btnRefresh: TButton;
    memoExportPreview: TMemo;
    lblExportPreview: TLabel;
    pnlImport: TPanel;
    lblImportFile: TLabel;
    edtImportFile: TEdit;
    btnBrowseImport: TButton;
    btnImport: TButton;
    memoImportPreview: TMemo;
    lblImportPreview: TLabel;
    SaveDialog: TSaveDialog;
    OpenDialog: TOpenDialog;
    lblStatus: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure btnExportSelectedClick(Sender: TObject);
    procedure btnExportAllClick(Sender: TObject);
    procedure btnBrowseImportClick(Sender: TObject);
    procedure btnImportClick(Sender: TObject);
    procedure lstConversationsClick(Sender: TObject);
  private
    procedure LoadConversations;
    procedure ExportConversation(ConvID: Int64);
    procedure ExportAllConversations;
    procedure ImportFromFile(const FileName: string);
  public
    { Public declarations }
  end;

var
  frmExportImport: TfrmExportImport;

implementation

{$R *.dfm}

procedure TfrmExportImport.FormCreate(Sender: TObject);
begin
  SaveDialog.Filter := 'JSON Files (*.json)|*.json|All Files (*.*)|*.*';
  OpenDialog.Filter := 'JSON Files (*.json)|*.json|All Files (*.*)|*.*';

  LoadConversations;
end;

procedure TfrmExportImport.LoadConversations;
var
  Convs: TArray<TConversation>;
  I: Integer;
begin
  lstConversations.Clear;
  Convs := TDatabaseManager.GetAllConversations;

  for I := 0 to High(Convs) do
    lstConversations.Items.AddObject(Convs[I].Title, TObject(Convs[I].ID));

  if lstConversations.Items.Count > 0 then
    lblStatus.Caption := Format('%d conversation(s) available for export', [lstConversations.Items.Count])
  else
    lblStatus.Caption := 'No conversations available';
end;

procedure TfrmExportImport.btnRefreshClick(Sender: TObject);
begin
  LoadConversations;
end;

procedure TfrmExportImport.lstConversationsClick(Sender: TObject);
var
  ConvID: Int64;
  JSON: string;
begin
  if lstConversations.ItemIndex < 0 then Exit;

  ConvID := Int64(lstConversations.Items.Objects[lstConversations.ItemIndex]);
  JSON := TExportImport.ExportConversation(ConvID);

  memoExportPreview.Text := JSON;
end;

procedure TfrmExportImport.btnExportSelectedClick(Sender: TObject);
var
  ConvID: Int64;
begin
  if lstConversations.ItemIndex < 0 then
  begin
    ShowMessage('Please select a conversation to export.');
    Exit;
  end;

  ConvID := Int64(lstConversations.Items.Objects[lstConversations.ItemIndex]);
  ExportConversation(ConvID);
end;

procedure TfrmExportImport.ExportConversation(ConvID: Int64);
var
  JSON: string;
  FileName: string;
begin
  SaveDialog.FileName := 'conversation_' + IntToStr(ConvID) + '.json';

  if SaveDialog.Execute then
  begin
    FileName := SaveDialog.FileName;
    JSON := TExportImport.ExportConversation(ConvID);

    TExportImport.ExportToFile(FileName, JSON);

    lblStatus.Caption := 'Exported to: ' + FileName;
    ShowMessage('Conversation exported successfully!');
  end;
end;

procedure TfrmExportImport.btnExportAllClick(Sender: TObject);
begin
  ExportAllConversations;
end;

procedure TfrmExportImport.ExportAllConversations;
var
  JSON: string;
  FileName: string;
begin
  if lstConversations.Items.Count = 0 then
  begin
    ShowMessage('No conversations to export.');
    Exit;
  end;

  SaveDialog.FileName := 'all_conversations.json';

  if SaveDialog.Execute then
  begin
    FileName := SaveDialog.FileName;
    JSON := TExportImport.ExportAllConversations;

    TExportImport.ExportToFile(FileName, JSON);

    lblStatus.Caption := 'Exported all conversations to: ' + FileName;
    ShowMessage(Format('Exported %d conversation(s) successfully!', [lstConversations.Items.Count]));
  end;
end;

procedure TfrmExportImport.btnBrowseImportClick(Sender: TObject);
begin
  if OpenDialog.Execute then
  begin
    edtImportFile.Text := OpenDialog.FileName;

    try
      var JSON := TExportImport.ImportFromFile(OpenDialog.FileName);
      memoImportPreview.Text := JSON;
      lblStatus.Caption := 'File loaded: ' + ExtractFileName(OpenDialog.FileName);
    except
      on E: Exception do
      begin
        ShowMessage('Error reading file: ' + E.Message);
        lblStatus.Caption := 'Error loading file';
      end;
    end;
  end;
end;

procedure TfrmExportImport.btnImportClick(Sender: TObject);
begin
  if Trim(edtImportFile.Text) = '' then
  begin
    ShowMessage('Please select a file to import.');
    Exit;
  end;

  ImportFromFile(edtImportFile.Text);
end;

procedure TfrmExportImport.ImportFromFile(const FileName: string);
var
  JSON: string;
  ConvID: Int64;
begin
  try
    JSON := TExportImport.ImportFromFile(FileName);

    // Check if it's a single conversation or multiple
    if Pos('"conversations"', JSON) > 0 then
    begin
      // Multiple conversations - not yet implemented
      ShowMessage('Importing multiple conversations not yet implemented.');
    end
    else
    begin
      // Single conversation
      ConvID := TExportImport.ImportConversation(JSON);

      if ConvID > 0 then
      begin
        lblStatus.Caption := 'Conversation imported successfully (ID: ' + IntToStr(ConvID) + ')';
        ShowMessage('Conversation imported successfully!');
        LoadConversations;
      end
      else
      begin
        lblStatus.Caption := 'Import failed';
        ShowMessage('Failed to import conversation.');
      end;
    end;

  except
    on E: Exception do
    begin
      ShowMessage('Error importing: ' + E.Message);
      lblStatus.Caption := 'Import error';
    end;
  end;
end;

end.
