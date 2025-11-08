unit ChatForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls,
  APIBase, DatabaseManager, SettingsManager, PerformanceTracker;

type
  TfrmChat = class(TForm)
    pnlChat: TPanel;
    pnlInput: TPanel;
    memoChat: TRichEdit;
    memoInput: TMemo;
    btnSend: TButton;
    btnStop: TButton;
    pnlSidebar: TPanel;
    lstConversations: TListBox;
    btnNewChat: TButton;
    btnDeleteChat: TButton;
    Splitter1: TSplitter;
    pnlParams: TPanel;
    trackTemp: TTrackBar;
    lblTemp: TLabel;
    lblTempValue: TLabel;
    trackTopP: TTrackBar;
    lblTopP: TLabel;
    lblTopPValue: TLabel;
    edtMaxTokens: TEdit;
    lblMaxTokens: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnSendClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure btnNewChatClick(Sender: TObject);
    procedure btnDeleteChatClick(Sender: TObject);
    procedure lstConversationsClick(Sender: TObject);
    procedure trackTempChange(Sender: TObject);
    procedure trackTopPChange(Sender: TObject);
  private
    FCurrentConversationID: Int64;
    FGenerating: Boolean;

    procedure LoadConversations;
    procedure LoadMessages(ConvID: Int64);
    procedure AddMessage(const Role, Content: string);
    procedure GenerateResponse(const UserMessage: string);
    procedure OnToken(const Token: string);
    procedure OnComplete(const FullText: string; Tokens: Integer);
    procedure OnError(const Error: string);
  public
    { Public declarations }
  end;

var
  frmChat: TfrmChat;

implementation

uses
  MainForm, ThemeManager;

{$R *.dfm}

procedure TfrmChat.FormCreate(Sender: TObject);
begin
  LoadConversations;
  FGenerating := False;
  btnStop.Enabled := False;

  // Load saved parameters
  trackTemp.Position := Round(TSettingsManager.GetTemperature * 100);
  trackTempChange(nil);
  trackTopP.Position := Round(TSettingsManager.GetTopP * 100);
  trackTopPChange(nil);
  edtMaxTokens.Text := IntToStr(TSettingsManager.GetMaxTokens);
end;

procedure TfrmChat.LoadConversations;
var
  Convs: TArray<TConversation>;
  I: Integer;
begin
  lstConversations.Clear;
  Convs := TDatabaseManager.GetAllConversations;

  for I := 0 to High(Convs) do
    lstConversations.Items.AddObject(Convs[I].Title, TObject(Convs[I].ID));

  if lstConversations.Items.Count > 0 then
  begin
    lstConversations.ItemIndex := 0;
    lstConversationsClick(nil);
  end;
end;

procedure TfrmChat.LoadMessages(ConvID: Int64);
var
  Messages: TArray<TMessage>;
  I: Integer;
begin
  memoChat.Clear;
  Messages := TDatabaseManager.GetMessages(ConvID);

  for I := 0 to High(Messages) do
    AddMessage(Messages[I].Role, Messages[I].Content);

  FCurrentConversationID := ConvID;
end;

procedure TfrmChat.AddMessage(const Role, Content: string);
var
  Theme: TTheme;
begin
  Theme := TThemeManager.GetCurrentTheme;

  memoChat.SelAttributes.Style := [fsBold];
  if SameText(Role, 'user') then
  begin
    memoChat.SelAttributes.Color := Theme.AccentSecondary;
    memoChat.SelText := 'You: ';
  end
  else
  begin
    memoChat.SelAttributes.Color := Theme.AccentPrimary;
    memoChat.SelText := 'Assistant: ';
  end;

  memoChat.SelAttributes.Style := [];
  memoChat.SelAttributes.Color := Theme.TextPrimary;
  memoChat.SelText := Content + #13#10#13#10;
  memoChat.Perform(EM_SCROLLCARET, 0, 0);
end;

procedure TfrmChat.btnSendClick(Sender: TObject);
var
  UserMessage: string;
begin
  UserMessage := Trim(memoInput.Text);
  if UserMessage = '' then Exit;

  if not Assigned(frmMain.CurrentAPI) then
  begin
    ShowMessage('No API selected!');
    Exit;
  end;

  // Save message
  if FCurrentConversationID <= 0 then
    btnNewChatClick(nil);

  TDatabaseManager.SaveMessage(FCurrentConversationID, 'user', UserMessage);
  AddMessage('user', UserMessage);
  memoInput.Clear;

  // Generate response
  GenerateResponse(UserMessage);
end;

procedure TfrmChat.GenerateResponse(const UserMessage: string);
var
  Messages: TArray<TChatMessage>;
  AllMessages: TArray<TMessage>;
  I: Integer;
  StartTime: TDateTime;
begin
  FGenerating := True;
  btnSend.Enabled := False;
  btnStop.Enabled := True;

  // Build message history
  AllMessages := TDatabaseManager.GetMessages(FCurrentConversationID);
  SetLength(Messages, Length(AllMessages));
  for I := 0 to High(AllMessages) do
  begin
    Messages[I].Role := StringToRole(AllMessages[I].Role);
    Messages[I].Content := AllMessages[I].Content;
  end;

  // Apply parameters to API
  frmMain.CurrentAPI.Temperature := trackTemp.Position / 100.0;
  frmMain.CurrentAPI.TopP := trackTopP.Position / 100.0;
  frmMain.CurrentAPI.MaxTokens := StrToIntDef(edtMaxTokens.Text, 2048);

  StartTime := Now;

  // Add assistant prefix
  var Theme := TThemeManager.GetCurrentTheme;
  memoChat.SelAttributes.Style := [fsBold];
  memoChat.SelAttributes.Color := Theme.AccentPrimary;
  memoChat.SelText := 'Assistant: ';
  memoChat.SelAttributes.Style := [];

  // Stream chat
  TThread.CreateAnonymousThread(
    procedure
    begin
      frmMain.CurrentAPI.ChatStream(Messages, OnToken, OnComplete, OnError);
    end
  ).Start;
end;

procedure TfrmChat.OnToken(const Token: string);
begin
  TThread.Synchronize(nil,
    procedure
    begin
      memoChat.SelText := Token;
      memoChat.Perform(EM_SCROLLCARET, 0, 0);
    end
  );
end;

procedure TfrmChat.OnComplete(const FullText: string; Tokens: Integer);
begin
  TThread.Synchronize(nil,
    procedure
    begin
      // Save assistant message
      TDatabaseManager.SaveMessage(FCurrentConversationID, 'assistant', FullText, Tokens);

      // Log performance
      TPerformanceTracker.LogRequest(
        frmMain.CurrentAPI.ProviderName,
        frmMain.CurrentAPI.Model,
        Tokens,
        0 // TODO: Calculate duration
      );

      memoChat.SelText := #13#10#13#10;
      FGenerating := False;
      btnSend.Enabled := True;
      btnStop.Enabled := False;
    end
  );
end;

procedure TfrmChat.OnError(const Error: string);
begin
  TThread.Synchronize(nil,
    procedure
    begin
      ShowMessage('Error: ' + Error);
      FGenerating := False;
      btnSend.Enabled := True;
      btnStop.Enabled := False;
    end
  );
end;

procedure TfrmChat.btnStopClick(Sender: TObject);
begin
  // TODO: Implement stop
  FGenerating := False;
  btnSend.Enabled := True;
  btnStop.Enabled := False;
end;

procedure TfrmChat.btnNewChatClick(Sender: TObject);
var
  Title: string;
begin
  Title := 'New Chat ' + FormatDateTime('yyyy-mm-dd hh:nn', Now);
  FCurrentConversationID := TDatabaseManager.CreateConversation(
    Title,
    frmMain.CurrentAPI.ProviderName,
    frmMain.CurrentAPI.Model
  );
  LoadConversations;
  memoChat.Clear;
end;

procedure TfrmChat.btnDeleteChatClick(Sender: TObject);
var
  ConvID: Int64;
begin
  if lstConversations.ItemIndex < 0 then Exit;

  if MessageDlg('Delete this conversation?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    ConvID := Int64(lstConversations.Items.Objects[lstConversations.ItemIndex]);
    TDatabaseManager.DeleteConversation(ConvID);
    LoadConversations;
    memoChat.Clear;
  end;
end;

procedure TfrmChat.lstConversationsClick(Sender: TObject);
var
  ConvID: Int64;
begin
  if lstConversations.ItemIndex < 0 then Exit;
  ConvID := Int64(lstConversations.Items.Objects[lstConversations.ItemIndex]);
  LoadMessages(ConvID);
end;

procedure TfrmChat.trackTempChange(Sender: TObject);
begin
  lblTempValue.Caption := Format('%.2f', [trackTemp.Position / 100.0]);
  TSettingsManager.SetTemperature(trackTemp.Position / 100.0);
end;

procedure TfrmChat.trackTopPChange(Sender: TObject);
begin
  lblTopPValue.Caption := Format('%.2f', [trackTopP.Position / 100.0]);
  TSettingsManager.SetTopP(trackTopP.Position / 100.0);
end;

end.
