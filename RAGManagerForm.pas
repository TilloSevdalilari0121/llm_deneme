unit RAGManagerForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls,
  RAGEngine, DatabaseManager;

type
  TfrmRAGManager = class(TForm)
    pnlTop: TPanel;
    pnlDocuments: TPanel;
    pnlQuery: TPanel;
    lstDocuments: TListView;
    btnUpload: TButton;
    btnDelete: TButton;
    btnRefresh: TButton;
    memoQuery: TMemo;
    btnSearch: TButton;
    memoResults: TRichEdit;
    lblDocuments: TLabel;
    lblQuery: TLabel;
    lblResults: TLabel;
    OpenDialog: TOpenDialog;
    progressUpload: TProgressBar;
    lblStatus: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnUploadClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
  private
    procedure LoadDocuments;
    procedure UploadDocument(const FileName: string);
    procedure SearchDocuments(const Query: string);
  public
    { Public declarations }
  end;

var
  frmRAGManager: TfrmRAGManager;

implementation

uses
  ThemeManager;

{$R *.dfm}

procedure TfrmRAGManager.FormCreate(Sender: TObject);
begin
  lstDocuments.ViewStyle := vsReport;
  lstDocuments.Columns.Add.Caption := 'Document';
  lstDocuments.Columns.Add.Caption := 'Type';
  lstDocuments.Columns.Add.Caption := 'Chunks';
  lstDocuments.Columns.Add.Caption := 'Uploaded';
  lstDocuments.Columns[0].Width := 300;
  lstDocuments.Columns[1].Width := 80;
  lstDocuments.Columns[2].Width := 80;
  lstDocuments.Columns[3].Width := 150;

  OpenDialog.Filter := 'Text Files (*.txt)|*.txt|PDF Files (*.pdf)|*.pdf|All Files (*.*)|*.*';

  LoadDocuments;
end;

procedure TfrmRAGManager.LoadDocuments;
var
  Docs: TArray<TDocument>;
  I: Integer;
  Item: TListItem;
begin
  lstDocuments.Clear;
  Docs := TDatabaseManager.GetAllDocuments;

  for I := 0 to High(Docs) do
  begin
    Item := lstDocuments.Items.Add;
    Item.Caption := Docs[I].FileName;
    Item.SubItems.Add(Docs[I].FileType);
    Item.SubItems.Add(IntToStr(Docs[I].ChunkCount));
    Item.SubItems.Add(DateTimeToStr(Docs[I].UploadedAt));
    Item.Data := Pointer(Docs[I].ID);
  end;
end;

procedure TfrmRAGManager.btnRefreshClick(Sender: TObject);
begin
  LoadDocuments;
end;

procedure TfrmRAGManager.btnUploadClick(Sender: TObject);
begin
  if OpenDialog.Execute then
  begin
    UploadDocument(OpenDialog.FileName);
  end;
end;

procedure TfrmRAGManager.UploadDocument(const FileName: string);
var
  Content: string;
  FileExt: string;
  Chunks: TArray<string>;
  I: Integer;
begin
  if not FileExists(FileName) then
  begin
    ShowMessage('File not found: ' + FileName);
    Exit;
  end;

  progressUpload.Visible := True;
  lblStatus.Caption := 'Processing document...';
  btnUpload.Enabled := False;

  TThread.CreateAnonymousThread(
    procedure
    var
      DocID: Int64;
    begin
      try
        // Read file content
        FileExt := LowerCase(ExtractFileExt(FileName));

        if FileExt = '.txt' then
        begin
          var F: TextFile;
          var Line: string;
          Content := '';
          AssignFile(F, FileName);
          Reset(F);
          try
            while not Eof(F) do
            begin
              ReadLn(F, Line);
              Content := Content + Line + #13#10;
            end;
          finally
            CloseFile(F);
          end;
        end
        else if FileExt = '.pdf' then
        begin
          // TODO: Implement PDF extraction
          Content := 'PDF extraction not yet implemented';
        end
        else
        begin
          // Try to read as text
          var F: TextFile;
          var Line: string;
          Content := '';
          AssignFile(F, FileName);
          Reset(F);
          try
            while not Eof(F) do
            begin
              ReadLn(F, Line);
              Content := Content + Line + #13#10;
            end;
          finally
            CloseFile(F);
          end;
        end;

        // Split into chunks
        Chunks := TRAGEngine.ChunkText(Content, 500);

        // Save to database
        DocID := TDatabaseManager.SaveDocument(
          ExtractFileName(FileName),
          FileExt,
          Length(Chunks)
        );

        // Save chunks with embeddings
        for I := 0 to High(Chunks) do
        begin
          var Embedding := TRAGEngine.GenerateEmbedding(Chunks[I]);
          TDatabaseManager.SaveChunk(DocID, I, Chunks[I], Embedding);
        end;

        TThread.Synchronize(nil,
          procedure
          begin
            lblStatus.Caption := 'Document uploaded successfully!';
            progressUpload.Visible := False;
            btnUpload.Enabled := True;
            LoadDocuments;
          end
        );
      except
        on E: Exception do
        begin
          TThread.Synchronize(nil,
            procedure
            begin
              ShowMessage('Error uploading document: ' + E.Message);
              lblStatus.Caption := 'Upload failed';
              progressUpload.Visible := False;
              btnUpload.Enabled := True;
            end
          );
        end;
      end;
    end
  ).Start;
end;

procedure TfrmRAGManager.btnDeleteClick(Sender: TObject);
var
  DocID: Int64;
  DocName: string;
begin
  if lstDocuments.Selected = nil then
  begin
    ShowMessage('Please select a document to delete.');
    Exit;
  end;

  DocID := Int64(lstDocuments.Selected.Data);
  DocName := lstDocuments.Selected.Caption;

  if MessageDlg('Delete document "' + DocName + '"?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    TDatabaseManager.DeleteDocument(DocID);
    LoadDocuments;
  end;
end;

procedure TfrmRAGManager.btnSearchClick(Sender: TObject);
var
  Query: string;
begin
  Query := Trim(memoQuery.Text);
  if Query = '' then
  begin
    ShowMessage('Please enter a search query.');
    Exit;
  end;

  SearchDocuments(Query);
end;

procedure TfrmRAGManager.SearchDocuments(const Query: string);
var
  Theme: TTheme;
begin
  memoResults.Clear;
  lblStatus.Caption := 'Searching...';

  TThread.CreateAnonymousThread(
    procedure
    var
      Results: TArray<TRAGResult>;
      I: Integer;
    begin
      Results := TRAGEngine.Search(Query, 5);

      TThread.Synchronize(nil,
        procedure
        begin
          Theme := TThemeManager.GetCurrentTheme;

          if Length(Results) = 0 then
          begin
            memoResults.Text := 'No results found.';
            lblStatus.Caption := 'No results';
          end
          else
          begin
            for I := 0 to High(Results) do
            begin
              memoResults.SelAttributes.Style := [fsBold];
              memoResults.SelAttributes.Color := Theme.AccentPrimary;
              memoResults.SelText := Format('Result %d (Score: %.3f):', [I + 1, Results[I].Score]) + #13#10;

              memoResults.SelAttributes.Style := [];
              memoResults.SelAttributes.Color := Theme.TextPrimary;
              memoResults.SelText := Results[I].Text + #13#10#13#10;
            end;

            lblStatus.Caption := Format('Found %d results', [Length(Results)]);
          end;
        end
      );
    end
  ).Start;
end;

end.
