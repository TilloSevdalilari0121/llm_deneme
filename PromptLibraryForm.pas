unit PromptLibraryForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls,
  PromptManager, DatabaseManager;

type
  TfrmPromptLibrary = class(TForm)
    pnlLeft: TPanel;
    pnlRight: TPanel;
    Splitter1: TSplitter;
    lstPrompts: TListBox;
    lblPrompts: TLabel;
    btnNew: TButton;
    btnDelete: TButton;
    btnSave: TButton;
    edtName: TEdit;
    lblName: TLabel;
    cmbCategory: TComboBox;
    lblCategory: TLabel;
    memoTemplate: TMemo;
    lblTemplate: TLabel;
    memoDescription: TMemo;
    lblDescription: TLabel;
    memoVariables: TMemo;
    lblVariables: TLabel;
    btnApplyToChat: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnNewClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure lstPromptsClick(Sender: TObject);
    procedure btnApplyToChatClick(Sender: TObject);
    procedure cmbCategoryChange(Sender: TObject);
  private
    FCurrentPromptID: Int64;
    FModified: Boolean;

    procedure LoadPrompts;
    procedure LoadPrompt(PromptID: Int64);
    procedure ClearForm;
    procedure SetModified(Value: Boolean);
  public
    { Public declarations }
  end;

var
  frmPromptLibrary: TfrmPromptLibrary;

implementation

uses
  MainForm, ChatForm;

{$R *.dfm}

procedure TfrmPromptLibrary.FormCreate(Sender: TObject);
begin
  FCurrentPromptID := -1;
  FModified := False;

  // Initialize categories
  cmbCategory.Items.Add('General');
  cmbCategory.Items.Add('Coding');
  cmbCategory.Items.Add('Writing');
  cmbCategory.Items.Add('Analysis');
  cmbCategory.Items.Add('Creative');
  cmbCategory.Items.Add('Business');
  cmbCategory.Items.Add('Education');
  cmbCategory.Items.Add('Research');
  cmbCategory.ItemIndex := 0;

  LoadPrompts;
end;

procedure TfrmPromptLibrary.LoadPrompts;
var
  Prompts: TArray<TPromptTemplate>;
  I: Integer;
begin
  lstPrompts.Clear;
  Prompts := TPromptManager.GetAllPrompts;

  for I := 0 to High(Prompts) do
    lstPrompts.Items.AddObject(Prompts[I].Name, TObject(Prompts[I].ID));
end;

procedure TfrmPromptLibrary.lstPromptsClick(Sender: TObject);
var
  PromptID: Int64;
begin
  if lstPrompts.ItemIndex < 0 then Exit;

  if FModified then
  begin
    if MessageDlg('Save changes to current prompt?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      btnSaveClick(nil);
  end;

  PromptID := Int64(lstPrompts.Items.Objects[lstPrompts.ItemIndex]);
  LoadPrompt(PromptID);
end;

procedure TfrmPromptLibrary.LoadPrompt(PromptID: Int64);
var
  Prompt: TPromptTemplate;
begin
  Prompt := TPromptManager.GetPrompt(PromptID);

  FCurrentPromptID := PromptID;
  edtName.Text := Prompt.Name;
  cmbCategory.ItemIndex := cmbCategory.Items.IndexOf(Prompt.Category);
  memoTemplate.Text := Prompt.Template;
  memoDescription.Text := Prompt.Description;
  memoVariables.Text := Prompt.Variables;

  SetModified(False);
end;

procedure TfrmPromptLibrary.ClearForm;
begin
  FCurrentPromptID := -1;
  edtName.Clear;
  cmbCategory.ItemIndex := 0;
  memoTemplate.Clear;
  memoDescription.Clear;
  memoVariables.Clear;
  SetModified(False);
end;

procedure TfrmPromptLibrary.SetModified(Value: Boolean);
begin
  FModified := Value;
  if Value then
    btnSave.Caption := 'Save *'
  else
    btnSave.Caption := 'Save';
end;

procedure TfrmPromptLibrary.btnNewClick(Sender: TObject);
begin
  if FModified then
  begin
    if MessageDlg('Save changes to current prompt?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      btnSaveClick(nil);
  end;

  ClearForm;
  edtName.SetFocus;
end;

procedure TfrmPromptLibrary.btnSaveClick(Sender: TObject);
var
  Name, Category, Template, Description, Variables: string;
begin
  Name := Trim(edtName.Text);
  if Name = '' then
  begin
    ShowMessage('Please enter a prompt name.');
    Exit;
  end;

  Template := Trim(memoTemplate.Text);
  if Template = '' then
  begin
    ShowMessage('Please enter a prompt template.');
    Exit;
  end;

  Category := cmbCategory.Text;
  Description := Trim(memoDescription.Text);
  Variables := Trim(memoVariables.Text);

  if FCurrentPromptID > 0 then
  begin
    // Update existing
    TPromptManager.UpdatePrompt(FCurrentPromptID, Name, Category, Template, Description, Variables);
  end
  else
  begin
    // Create new
    FCurrentPromptID := TPromptManager.SavePrompt(Name, Category, Template, Description, Variables);
  end;

  SetModified(False);
  LoadPrompts;

  // Select the saved prompt
  var I: Integer;
  for I := 0 to lstPrompts.Items.Count - 1 do
  begin
    if Int64(lstPrompts.Items.Objects[I]) = FCurrentPromptID then
    begin
      lstPrompts.ItemIndex := I;
      Break;
    end;
  end;
end;

procedure TfrmPromptLibrary.btnDeleteClick(Sender: TObject);
var
  PromptName: string;
begin
  if FCurrentPromptID <= 0 then
  begin
    ShowMessage('Please select a prompt to delete.');
    Exit;
  end;

  PromptName := edtName.Text;

  if MessageDlg('Delete prompt "' + PromptName + '"?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    TPromptManager.DeletePrompt(FCurrentPromptID);
    ClearForm;
    LoadPrompts;
  end;
end;

procedure TfrmPromptLibrary.cmbCategoryChange(Sender: TObject);
begin
  SetModified(True);
end;

procedure TfrmPromptLibrary.btnApplyToChatClick(Sender: TObject);
var
  PromptText: string;
  Variables: TArray<string>;
  I: Integer;
  VarName, VarValue: string;
begin
  if Trim(memoTemplate.Text) = '' then
  begin
    ShowMessage('No prompt template to apply.');
    Exit;
  end;

  PromptText := memoTemplate.Text;

  // Parse variables
  if Trim(memoVariables.Text) <> '' then
  begin
    Variables := memoVariables.Text.Split([#13#10], TStringSplitOptions.ExcludeEmpty);

    for I := 0 to High(Variables) do
    begin
      VarName := Trim(Variables[I]);
      if VarName = '' then Continue;

      // Ask user for value
      VarValue := InputBox('Variable Value', 'Enter value for ' + VarName + ':', '');
      PromptText := StringReplace(PromptText, '{' + VarName + '}', VarValue, [rfReplaceAll, rfIgnoreCase]);
    end;
  end;

  // Apply to chat
  if Assigned(frmChat) then
  begin
    frmChat.memoInput.Text := PromptText;
    frmChat.Show;
  end
  else
    ShowMessage('Chat form not available');
end;

end.
