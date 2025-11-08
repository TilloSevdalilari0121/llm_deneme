unit MainForm;

{$IFDEF FPC}
  {$MODE DELPHI}
{$ENDIF}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls, Vcl.Buttons,
  ThemeManager, InferenceEngine, ModelManager, DatabaseManager,
  SettingsManager, CodeAssistant;

type
  TfrmMain = class(TForm)
    pnlTop: TPanel;
    pnlChat: TPanel;
    pnlInput: TPanel;
    memoChat: TRichEdit;
    memoInput: TMemo;
    btnSend: TButton;
    btnStop: TButton;
    cmbModels: TComboBox;
    btnLoadModel: TButton;
    btnSettings: TButton;
    btnTheme: TButton;
    btnModels: TButton;
    btnWorkspace: TButton;
    lblModel: TLabel;
    lblStatus: TLabel;
    pnlSidebar: TPanel;
    lstConversations: TListBox;
    btnNewChat: TButton;
    btnDeleteChat: TButton;
    splConversations: TSplitter;
    pnlToolbar: TPanel;
    btnClearChat: TButton;
    chkCodeMode: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnSendClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure btnLoadModelClick(Sender: TObject);
    procedure btnSettingsClick(Sender: TObject);
    procedure btnThemeClick(Sender: TObject);
    procedure btnModelsClick(Sender: TObject);
    procedure btnWorkspaceClick(Sender: TObject);
    procedure btnNewChatClick(Sender: TObject);
    procedure btnDeleteChatClick(Sender: TObject);
    procedure btnClearChatClick(Sender: TObject);
    procedure lstConversationsClick(Sender: TObject);
    procedure memoInputKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    FEngine: TInferenceEngine;
    FCodeAssistant: TCodeAssistant;
    FCurrentConversationID: Int64;

    procedure LoadModels;
    procedure LoadConversations;
    procedure LoadConversationMessages(ConvID: Int64);
    procedure AddMessageToChat(const Role, Content: string);
    procedure OnTokenReceived(const Token: string);
    procedure OnGenerationComplete(const FullText: string; TokenCount: Integer);
    procedure OnGenerationError(const ErrorMsg: string);
    procedure UpdateStatus(const Status: string);
    procedure ApplyTheme;
    procedure ProcessCodeCommand(const Command: string);
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses
  SettingsForm, ModelManagerForm, ThemeSettingsForm, WorkspaceForm;

{$R *.dfm}

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FEngine := TInferenceEngine.Create;
  FCodeAssistant := TCodeAssistant.Create;
  FCurrentConversationID := -1;

  LoadModels;
  LoadConversations;
  ApplyTheme;

  btnStop.Enabled := False;
  UpdateStatus('Ready');

  // Load last conversation
  FCurrentConversationID := TSettingsManager.GetCurrentConversationID;
  if FCurrentConversationID > 0 then
    LoadConversationMessages(FCurrentConversationID)
  else
    btnNewChatClick(nil); // Create first conversation
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  FEngine.Free;
  FCodeAssistant.Free;
end;

procedure TfrmMain.ApplyTheme;
begin
  TThemeManager.ApplyToForm(Self);
end;

procedure TfrmMain.LoadModels;
var
  Models: TArray<TModelInfo>;
  Model: TModelInfo;
begin
  cmbModels.Clear;
  Models := TModelManager.GetAllModels;

  for Model in Models do
    cmbModels.Items.AddObject(Format('%s (%s)', [Model.Name, Model.SizeFormatted]), TObject(Model.ID));

  if cmbModels.Items.Count > 0 then
  begin
    // Try to load last used model
    var LastModel := TSettingsManager.GetLastModelPath;
    if LastModel <> '' then
    begin
      var I: Integer;
      for I := 0 to Models.High do
      begin
        if Models[I].Path = LastModel then
        begin
          cmbModels.ItemIndex := I;
          Break;
        end;
      end;
    end;

    if cmbModels.ItemIndex < 0 then
      cmbModels.ItemIndex := 0;
  end;
end;

procedure TfrmMain.LoadConversations;
var
  Convs: TStringList;
  I: Integer;
  Parts: TArray<string>;
begin
  lstConversations.Clear;
  Convs := TDatabaseManager.GetAllConversations;
  try
    for I := 0 to Convs.Count - 1 do
    begin
      Parts := Convs[I].Split(['|']);
      if Length(Parts) >= 2 then
        lstConversations.Items.AddObject(Parts[1], TObject(StrToInt64(Parts[0])));
    end;
  finally
    Convs.Free;
  end;
end;

procedure TfrmMain.LoadConversationMessages(ConvID: Int64);
var
  Messages: TStringList;
  I: Integer;
  Parts: TArray<string>;
begin
  memoChat.Clear;
  Messages := TDatabaseManager.GetConversationMessages(ConvID);
  try
    for I := 0 to Messages.Count - 1 do
    begin
      Parts := Messages[I].Split(['|'], 2);
      if Length(Parts) = 2 then
        AddMessageToChat(Parts[0], Parts[1]);
    end;
  finally
    Messages.Free;
  end;

  FCurrentConversationID := ConvID;
  TSettingsManager.SetCurrentConversationID(ConvID);
end;

procedure TfrmMain.AddMessageToChat(const Role, Content: string);
var
  Theme: TTheme;
  RoleText: string;
begin
  Theme := TThemeManager.GetCurrentTheme;

  if Role = 'user' then
  begin
    RoleText := 'You: ';
    memoChat.SelAttributes.Color := Theme.AccentSecondary;
  end
  else
  begin
    RoleText := 'Assistant: ';
    memoChat.SelAttributes.Color := Theme.AccentPrimary;
  end;

  memoChat.SelAttributes.Style := [fsBold];
  memoChat.SelText := RoleText + #13#10;

  memoChat.SelAttributes.Color := Theme.TextPrimary;
  memoChat.SelAttributes.Style := [];
  memoChat.SelText := Content + #13#10#13#10;

  // Scroll to bottom
  memoChat.Perform(EM_SCROLLCARET, 0, 0);
end;

procedure TfrmMain.btnSendClick(Sender: TObject);
var
  UserMessage: string;
begin
  UserMessage := Trim(memoInput.Text);
  if UserMessage = '' then Exit;

  if not FEngine.IsModelLoaded then
  begin
    ShowMessage('Please load a model first!');
    Exit;
  end;

  // Check if it's a code command
  if chkCodeMode.Checked and UserMessage.StartsWithText('/code') then
  begin
    ProcessCodeCommand(UserMessage);
    Exit;
  end;

  // Save user message
  if FCurrentConversationID > 0 then
    TDatabaseManager.SaveMessage(FCurrentConversationID, 'user', UserMessage);

  // Display user message
  AddMessageToChat('user', UserMessage);
  memoInput.Clear;

  // Start generation
  btnSend.Enabled := False;
  btnStop.Enabled := True;
  UpdateStatus('Generating...');

  // Add assistant prefix
  memoChat.SelAttributes.Color := TThemeManager.GetCurrentTheme.AccentPrimary;
  memoChat.SelAttributes.Style := [fsBold];
  memoChat.SelText := 'Assistant: ' + #13#10;
  memoChat.SelAttributes.Style := [];
  memoChat.SelAttributes.Color := TThemeManager.GetCurrentTheme.TextPrimary;

  // Generate response
  TThread.CreateAnonymousThread(
    procedure
    begin
      FEngine.Generate(UserMessage, OnTokenReceived, OnGenerationComplete, OnGenerationError);
    end
  ).Start;
end;

procedure TfrmMain.btnStopClick(Sender: TObject);
begin
  FEngine.CancelGeneration;
  UpdateStatus('Stopped');
  btnSend.Enabled := True;
  btnStop.Enabled := False;
end;

procedure TfrmMain.OnTokenReceived(const Token: string);
begin
  TThread.Synchronize(nil,
    procedure
    begin
      memoChat.SelText := Token;
      memoChat.Perform(EM_SCROLLCARET, 0, 0);
    end
  );
end;

procedure TfrmMain.OnGenerationComplete(const FullText: string; TokenCount: Integer);
begin
  TThread.Synchronize(nil,
    procedure
    begin
      // Save assistant message
      if FCurrentConversationID > 0 then
        TDatabaseManager.SaveMessage(FCurrentConversationID, 'assistant', FullText);

      memoChat.SelText := #13#10#13#10;
      UpdateStatus(Format('Complete (%d tokens)', [TokenCount]));
      btnSend.Enabled := True;
      btnStop.Enabled := False;
    end
  );
end;

procedure TfrmMain.OnGenerationError(const ErrorMsg: string);
begin
  TThread.Synchronize(nil,
    procedure
    begin
      ShowMessage('Error: ' + ErrorMsg);
      UpdateStatus('Error');
      btnSend.Enabled := True;
      btnStop.Enabled := False;
    end
  );
end;

procedure TfrmMain.btnLoadModelClick(Sender: TObject);
var
  Models: TArray<TModelInfo>;
  ModelPath: string;
begin
  if cmbModels.ItemIndex < 0 then
  begin
    ShowMessage('Please select a model!');
    Exit;
  end;

  Models := TModelManager.GetAllModels;
  if cmbModels.ItemIndex > Models.High then Exit;

  ModelPath := Models[cmbModels.ItemIndex].Path;
  UpdateStatus('Loading model...');

  if FEngine.LoadModel(ModelPath) then
  begin
    UpdateStatus('Model loaded: ' + Models[cmbModels.ItemIndex].Name);
    TSettingsManager.SetLastModelPath(ModelPath);
    lblModel.Caption := 'Model: ' + Models[cmbModels.ItemIndex].Name;
  end
  else
  begin
    UpdateStatus('Failed to load model');
    ShowMessage('Failed to load model!');
  end;
end;

procedure TfrmMain.btnSettingsClick(Sender: TObject);
begin
  var frm := TfrmSettings.Create(Self);
  try
    if frm.ShowModal = mrOK then
    begin
      // Reload engine params
      FEngine.LoadDefaultParams;
    end;
  finally
    frm.Free;
  end;
end;

procedure TfrmMain.btnThemeClick(Sender: TObject);
begin
  var frm := TfrmThemeSettings.Create(Self);
  try
    if frm.ShowModal = mrOK then
      ApplyTheme;
  finally
    frm.Free;
  end;
end;

procedure TfrmMain.btnModelsClick(Sender: TObject);
begin
  var frm := TfrmModelManager.Create(Self);
  try
    if frm.ShowModal = mrOK then
      LoadModels;
  finally
    frm.Free;
  end;
end;

procedure TfrmMain.btnWorkspaceClick(Sender: TObject);
begin
  var frm := TfrmWorkspace.Create(Self);
  try
    frm.ShowModal;
  finally
    frm.Free;
  end;
end;

procedure TfrmMain.btnNewChatClick(Sender: TObject);
var
  Title: string;
  ConvID: Int64;
begin
  Title := 'New Conversation ' + FormatDateTime('yyyy-mm-dd hh:nn', Now);
  ConvID := TDatabaseManager.CreateConversation(Title);
  LoadConversations;
  LoadConversationMessages(ConvID);
end;

procedure TfrmMain.btnDeleteChatClick(Sender: TObject);
var
  ConvID: Int64;
begin
  if lstConversations.ItemIndex < 0 then Exit;

  if MessageDlg('Delete this conversation?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    ConvID := Int64(lstConversations.Items.Objects[lstConversations.ItemIndex]);
    TDatabaseManager.DeleteConversation(ConvID);
    LoadConversations;

    if ConvID = FCurrentConversationID then
      btnNewChatClick(nil);
  end;
end;

procedure TfrmMain.btnClearChatClick(Sender: TObject);
begin
  if MessageDlg('Clear current chat window?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    memoChat.Clear;
end;

procedure TfrmMain.lstConversationsClick(Sender: TObject);
var
  ConvID: Int64;
begin
  if lstConversations.ItemIndex < 0 then Exit;
  ConvID := Int64(lstConversations.Items.Objects[lstConversations.ItemIndex]);
  LoadConversationMessages(ConvID);
end;

procedure TfrmMain.memoInputKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_RETURN) and (ssCtrl in Shift) then
  begin
    btnSendClick(nil);
    Key := 0;
  end;
end;

procedure TfrmMain.ProcessCodeCommand(const Command: string);
var
  Parts: TArray<string>;
  Action, FilePath, Content: string;
begin
  Parts := Command.Split([' '], 3);
  if Length(Parts) < 3 then
  begin
    AddMessageToChat('system', 'Usage: /code [read|write|list] <file> [content]');
    Exit;
  end;

  Action := LowerCase(Parts[1]);
  FilePath := Parts[2];

  try
    if Action = 'read' then
    begin
      Content := FCodeAssistant.ReadFile(FilePath);
      AddMessageToChat('system', 'File: ' + FilePath + #13#10 + Content);
    end
    else if Action = 'write' then
    begin
      if Length(Parts) < 4 then
      begin
        AddMessageToChat('system', 'Usage: /code write <file> <content>');
        Exit;
      end;
      Content := Parts[3];
      FCodeAssistant.WriteFile(FilePath, Content);
      AddMessageToChat('system', 'File written: ' + FilePath);
    end
    else if Action = 'list' then
    begin
      var Files := FCodeAssistant.ListFiles(FilePath);
      var FileList := '';
      for var F in Files do
        FileList := FileList + F.Name + #13#10;
      AddMessageToChat('system', 'Files in ' + FilePath + ':' + #13#10 + FileList);
    end
    else
      AddMessageToChat('system', 'Unknown command: ' + Action);
  except
    on E: Exception do
      AddMessageToChat('system', 'Error: ' + E.Message);
  end;
end;

procedure TfrmMain.UpdateStatus(const Status: string);
begin
  lblStatus.Caption := 'Status: ' + Status;
end;

end.
