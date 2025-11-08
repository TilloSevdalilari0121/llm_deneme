unit ThemeManagerForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  ThemeManager;

type
  TfrmThemeManager = class(TForm)
    pnlLeft: TPanel;
    pnlRight: TPanel;
    Splitter1: TSplitter;
    lstThemes: TListBox;
    lblThemes: TLabel;
    btnApply: TButton;
    pnlPreview: TPanel;
    lblPreview: TLabel;
    pnlBackground: TPanel;
    lblSampleText: TLabel;
    lblSampleAccent: TLabel;
    pnlSurface: TPanel;
    lblColors: TLabel;
    lblBgColor: TLabel;
    lblTextColor: TLabel;
    lblAccentColor: TLabel;
    edtBgColor: TEdit;
    edtTextColor: TEdit;
    edtAccentColor: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure lstThemesClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
  private
    procedure LoadThemes;
    procedure PreviewTheme(const ThemeName: string);
    procedure ApplyTheme(const ThemeName: string);
  public
    { Public declarations }
  end;

var
  frmThemeManager: TfrmThemeManager;

implementation

uses
  MainForm;

{$R *.dfm}

procedure TfrmThemeManager.FormCreate(Sender: TObject);
begin
  LoadThemes;
end;

procedure TfrmThemeManager.LoadThemes;
begin
  lstThemes.Clear;

  // Dark Themes
  lstThemes.Items.Add('VS Code Dark');
  lstThemes.Items.Add('GitHub Dark');
  lstThemes.Items.Add('Dracula');
  lstThemes.Items.Add('Monokai Pro');
  lstThemes.Items.Add('Nord');
  lstThemes.Items.Add('Gruvbox Dark');
  lstThemes.Items.Add('Solarized Dark');
  lstThemes.Items.Add('Tokyo Night');
  lstThemes.Items.Add('One Dark Pro');
  lstThemes.Items.Add('Material Dark');

  // Light Themes
  lstThemes.Items.Add('GitHub Light');
  lstThemes.Items.Add('VS Code Light');
  lstThemes.Items.Add('Solarized Light');
  lstThemes.Items.Add('Gruvbox Light');
  lstThemes.Items.Add('Material Light');

  // Select current theme
  var CurrentTheme := TThemeManager.GetCurrentThemeName;
  var Index := lstThemes.Items.IndexOf(CurrentTheme);
  if Index >= 0 then
  begin
    lstThemes.ItemIndex := Index;
    lstThemesClick(nil);
  end
  else if lstThemes.Items.Count > 0 then
  begin
    lstThemes.ItemIndex := 0;
    lstThemesClick(nil);
  end;
end;

procedure TfrmThemeManager.lstThemesClick(Sender: TObject);
begin
  if lstThemes.ItemIndex < 0 then Exit;
  PreviewTheme(lstThemes.Items[lstThemes.ItemIndex]);
end;

procedure TfrmThemeManager.PreviewTheme(const ThemeName: string);
var
  Theme: TTheme;
begin
  Theme := TThemeManager.GetThemeByName(ThemeName);

  // Update preview panel
  pnlBackground.Color := Theme.Background;
  pnlSurface.Color := Theme.Surface;
  lblSampleText.Font.Color := Theme.TextPrimary;
  lblSampleAccent.Font.Color := Theme.AccentPrimary;

  // Update color values
  edtBgColor.Text := ColorToHex(Theme.Background);
  edtTextColor.Text := ColorToHex(Theme.TextPrimary);
  edtAccentColor.Text := ColorToHex(Theme.AccentPrimary);
end;

procedure TfrmThemeManager.btnApplyClick(Sender: TObject);
begin
  if lstThemes.ItemIndex < 0 then
  begin
    ShowMessage('Please select a theme to apply.');
    Exit;
  end;

  ApplyTheme(lstThemes.Items[lstThemes.ItemIndex]);
  ShowMessage('Theme applied successfully. Some changes may require restart.');
end;

procedure TfrmThemeManager.ApplyTheme(const ThemeName: string);
begin
  TThemeManager.SetTheme(ThemeName);

  // Apply to main form
  if Assigned(frmMain) then
    TThemeManager.ApplyToForm(frmMain);

  // Apply to this form
  TThemeManager.ApplyToForm(Self);
end;

function ColorToHex(Color: TColor): string;
var
  R, G, B: Byte;
begin
  R := GetRValue(Color);
  G := GetGValue(Color);
  B := GetBValue(Color);
  Result := Format('#%.2X%.2X%.2X', [R, G, B]);
end;

end.
