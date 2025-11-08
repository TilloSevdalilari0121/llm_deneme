unit PluginManagerForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls,
  PluginSystem;

type
  TfrmPluginManager = class(TForm)
    pnlTop: TPanel;
    pnlPlugins: TPanel;
    lstPlugins: TListView;
    lblPlugins: TLabel;
    btnLoad: TButton;
    btnUnload: TButton;
    btnRefresh: TButton;
    memoInfo: TMemo;
    lblInfo: TLabel;
    OpenDialog: TOpenDialog;
    lblStatus: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnLoadClick(Sender: TObject);
    procedure btnUnloadClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure lstPluginsClick(Sender: TObject);
  private
    procedure LoadPluginList;
    procedure ShowPluginInfo(const PluginName: string);
  public
    { Public declarations }
  end;

var
  frmPluginManager: TfrmPluginManager;

implementation

{$R *.dfm}

procedure TfrmPluginManager.FormCreate(Sender: TObject);
begin
  lstPlugins.ViewStyle := vsReport;
  lstPlugins.Columns.Add.Caption := 'Plugin Name';
  lstPlugins.Columns.Add.Caption := 'Status';
  lstPlugins.Columns.Add.Caption := 'Path';
  lstPlugins.Columns[0].Width := 200;
  lstPlugins.Columns[1].Width := 100;
  lstPlugins.Columns[2].Width := 300;

  OpenDialog.Filter := 'DLL Files (*.dll)|*.dll|All Files (*.*)|*.*';

  LoadPluginList;
end;

procedure TfrmPluginManager.LoadPluginList;
var
  Plugins: TArray<string>;
  I: Integer;
  Item: TListItem;
begin
  lstPlugins.Clear;
  Plugins := TPluginSystem.GetLoadedPlugins;

  for I := 0 to High(Plugins) do
  begin
    Item := lstPlugins.Items.Add;
    Item.Caption := Plugins[I];
    Item.SubItems.Add('Loaded');
    Item.SubItems.Add('N/A');
  end;

  if Length(Plugins) = 0 then
  begin
    lblStatus.Caption := 'No plugins loaded';
  end
  else
  begin
    lblStatus.Caption := Format('%d plugin(s) loaded', [Length(Plugins)]);
  end;
end;

procedure TfrmPluginManager.btnRefreshClick(Sender: TObject);
begin
  LoadPluginList;
end;

procedure TfrmPluginManager.btnLoadClick(Sender: TObject);
var
  PluginPath: string;
  Success: Boolean;
begin
  if OpenDialog.Execute then
  begin
    PluginPath := OpenDialog.FileName;
    lblStatus.Caption := 'Loading plugin...';

    Success := TPluginSystem.LoadPlugin(PluginPath);

    if Success then
    begin
      lblStatus.Caption := 'Plugin loaded successfully: ' + ExtractFileName(PluginPath);
      LoadPluginList;
    end
    else
    begin
      lblStatus.Caption := 'Failed to load plugin';
      ShowMessage('Failed to load plugin: ' + ExtractFileName(PluginPath) + #13#10 +
        'The plugin may be incompatible or corrupted.');
    end;
  end;
end;

procedure TfrmPluginManager.btnUnloadClick(Sender: TObject);
var
  PluginName: string;
begin
  if lstPlugins.Selected = nil then
  begin
    ShowMessage('Please select a plugin to unload.');
    Exit;
  end;

  PluginName := lstPlugins.Selected.Caption;

  if MessageDlg('Unload plugin "' + PluginName + '"?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    TPluginSystem.UnloadPlugin(PluginName);
    LoadPluginList;
    lblStatus.Caption := 'Plugin unloaded: ' + PluginName;
  end;
end;

procedure TfrmPluginManager.lstPluginsClick(Sender: TObject);
begin
  if lstPlugins.Selected <> nil then
    ShowPluginInfo(lstPlugins.Selected.Caption);
end;

procedure TfrmPluginManager.ShowPluginInfo(const PluginName: string);
begin
  memoInfo.Clear;
  memoInfo.Lines.Add('Plugin: ' + PluginName);
  memoInfo.Lines.Add('Status: Loaded');
  memoInfo.Lines.Add('');
  memoInfo.Lines.Add('Plugin System Information:');
  memoInfo.Lines.Add('');
  memoInfo.Lines.Add('The plugin system allows you to extend Universal LLM Studio');
  memoInfo.Lines.Add('with custom functionality. Plugins are loaded as DLL files');
  memoInfo.Lines.Add('and must implement the required plugin interface.');
  memoInfo.Lines.Add('');
  memoInfo.Lines.Add('Features:');
  memoInfo.Lines.Add('- Custom API providers');
  memoInfo.Lines.Add('- Additional processing modules');
  memoInfo.Lines.Add('- UI extensions');
  memoInfo.Lines.Add('- Custom export/import formats');
  memoInfo.Lines.Add('');
  memoInfo.Lines.Add('Note: Only load plugins from trusted sources.');
end;

end.
