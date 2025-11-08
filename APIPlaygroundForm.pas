unit APIPlaygroundForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls, System.JSON,
  APIBase;

type
  TfrmAPIPlayground = class(TForm)
    pnlTop: TPanel;
    pnlRequest: TPanel;
    pnlResponse: TPanel;
    Splitter1: TSplitter;
    lblEndpoint: TLabel;
    cmbEndpoint: TComboBox;
    lblMethod: TLabel;
    cmbMethod: TComboBox;
    btnSend: TButton;
    btnClear: TButton;
    memoRequest: TMemo;
    lblRequest: TLabel;
    memoResponse: TMemo;
    lblResponse: TLabel;
    lblStatus: TLabel;
    chkPrettyPrint: TCheckBox;
    btnLoadTemplate: TButton;
    cmbTemplate: TComboBox;
    lblTemplate: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnSendClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure btnLoadTemplateClick(Sender: TObject);
    procedure cmbEndpointChange(Sender: TObject);
  private
    procedure LoadTemplates;
    procedure SendRequest;
    procedure FormatJSON(Memo: TMemo);
  public
    { Public declarations }
  end;

var
  frmAPIPlayground: TfrmAPIPlayground;

implementation

uses
  MainForm, HTTPClient;

{$R *.dfm}

procedure TfrmAPIPlayground.FormCreate(Sender: TObject);
begin
  cmbMethod.Items.Add('GET');
  cmbMethod.Items.Add('POST');
  cmbMethod.Items.Add('DELETE');
  cmbMethod.ItemIndex := 1;

  LoadTemplates;

  // Set default endpoint
  if Assigned(frmMain.CurrentAPI) then
  begin
    cmbEndpoint.Text := frmMain.CurrentAPI.BaseURL + '/api/chat';
  end;
end;

procedure TfrmAPIPlayground.LoadTemplates;
begin
  cmbTemplate.Clear;
  cmbTemplate.Items.Add('Chat Request');
  cmbTemplate.Items.Add('Generate Request');
  cmbTemplate.Items.Add('List Models');
  cmbTemplate.Items.Add('Pull Model');
  cmbTemplate.Items.Add('Delete Model');
  cmbTemplate.ItemIndex := 0;
end;

procedure TfrmAPIPlayground.cmbEndpointChange(Sender: TObject);
begin
  // Auto-detect method based on endpoint
  if Pos('/api/tags', cmbEndpoint.Text) > 0 then
    cmbMethod.ItemIndex := 0 // GET
  else if Pos('/api/pull', cmbEndpoint.Text) > 0 then
    cmbMethod.ItemIndex := 1 // POST
  else if Pos('/api/delete', cmbEndpoint.Text) > 0 then
    cmbMethod.ItemIndex := 2; // DELETE
end;

procedure TfrmAPIPlayground.btnLoadTemplateClick(Sender: TObject);
var
  Template: string;
begin
  case cmbTemplate.ItemIndex of
    0: // Chat Request
    begin
      Template := '{'#13#10 +
        '  "model": "llama2",'#13#10 +
        '  "messages": ['#13#10 +
        '    {'#13#10 +
        '      "role": "user",'#13#10 +
        '      "content": "Hello, how are you?"'#13#10 +
        '    }'#13#10 +
        '  ],'#13#10 +
        '  "stream": false'#13#10 +
        '}';
      cmbEndpoint.Text := frmMain.CurrentAPI.BaseURL + '/api/chat';
      cmbMethod.ItemIndex := 1; // POST
    end;

    1: // Generate Request
    begin
      Template := '{'#13#10 +
        '  "model": "llama2",'#13#10 +
        '  "prompt": "What is the capital of France?",'#13#10 +
        '  "stream": false'#13#10 +
        '}';
      cmbEndpoint.Text := frmMain.CurrentAPI.BaseURL + '/api/generate';
      cmbMethod.ItemIndex := 1; // POST
    end;

    2: // List Models
    begin
      Template := '';
      cmbEndpoint.Text := frmMain.CurrentAPI.BaseURL + '/api/tags';
      cmbMethod.ItemIndex := 0; // GET
    end;

    3: // Pull Model
    begin
      Template := '{'#13#10 +
        '  "name": "llama2"'#13#10 +
        '}';
      cmbEndpoint.Text := frmMain.CurrentAPI.BaseURL + '/api/pull';
      cmbMethod.ItemIndex := 1; // POST
    end;

    4: // Delete Model
    begin
      Template := '{'#13#10 +
        '  "name": "llama2"'#13#10 +
        '}';
      cmbEndpoint.Text := frmMain.CurrentAPI.BaseURL + '/api/delete';
      cmbMethod.ItemIndex := 2; // DELETE
    end;
  end;

  memoRequest.Text := Template;
end;

procedure TfrmAPIPlayground.btnClearClick(Sender: TObject);
begin
  memoRequest.Clear;
  memoResponse.Clear;
  lblStatus.Caption := '';
end;

procedure TfrmAPIPlayground.btnSendClick(Sender: TObject);
begin
  if Trim(cmbEndpoint.Text) = '' then
  begin
    ShowMessage('Please enter an endpoint URL.');
    Exit;
  end;

  SendRequest;
end;

procedure TfrmAPIPlayground.SendRequest;
var
  URL: string;
  Method: string;
  RequestBody: string;
begin
  URL := Trim(cmbEndpoint.Text);
  Method := cmbMethod.Text;
  RequestBody := Trim(memoRequest.Text);

  lblStatus.Caption := 'Sending request...';
  btnSend.Enabled := False;
  memoResponse.Clear;

  TThread.CreateAnonymousThread(
    procedure
    var
      Response: TJSONValue;
      ResponseText: string;
      HTTP: THTTPClient;
    begin
      try
        HTTP := THTTPClient.Create;
        try
          if Method = 'GET' then
          begin
            Response := HTTP.GetJSON(URL);
            try
              ResponseText := Response.ToString;
            finally
              Response.Free;
            end;
          end
          else if Method = 'POST' then
          begin
            if RequestBody <> '' then
            begin
              var JSONObj := TJSONObject.ParseJSONValue(RequestBody) as TJSONObject;
              try
                Response := HTTP.PostJSON(URL, JSONObj);
                try
                  ResponseText := Response.ToString;
                finally
                  Response.Free;
                end;
              finally
                JSONObj.Free;
              end;
            end
            else
            begin
              Response := HTTP.PostJSON(URL, TJSONObject.Create);
              try
                ResponseText := Response.ToString;
              finally
                Response.Free;
              end;
            end;
          end
          else if Method = 'DELETE' then
          begin
            ResponseText := HTTP.DELETE(URL);
          end;
        finally
          HTTP.Free;
        end;

        TThread.Synchronize(nil,
          procedure
          begin
            memoResponse.Text := ResponseText;
            if chkPrettyPrint.Checked then
              FormatJSON(memoResponse);
            lblStatus.Caption := 'Request completed';
            btnSend.Enabled := True;
          end
        );

      except
        on E: Exception do
        begin
          TThread.Synchronize(nil,
            procedure
            begin
              memoResponse.Text := 'Error: ' + E.Message;
              lblStatus.Caption := 'Request failed';
              btnSend.Enabled := True;
            end
          );
        end;
      end;
    end
  ).Start;
end;

procedure TfrmAPIPlayground.FormatJSON(Memo: TMemo);
var
  JSONValue: TJSONValue;
begin
  try
    JSONValue := TJSONObject.ParseJSONValue(Memo.Text);
    if Assigned(JSONValue) then
    begin
      try
        Memo.Text := JSONValue.Format(2);
      finally
        JSONValue.Free;
      end;
    end;
  except
    // If it's not valid JSON, leave it as is
  end;
end;

end.
