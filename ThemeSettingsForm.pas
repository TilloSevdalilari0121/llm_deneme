unit ThemeSettingsForm;

{$IFDEF FPC}
  {$MODE DELPHI}
{$ENDIF}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  ThemeManager;

type
  TfrmThemeSettings = class(TForm)
    rgMode: TRadioGroup;
    rgColorScheme: TRadioGroup;
    pnlPreview: TPanel;
    lblPreview: TLabel;
    pnlButtons: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    btnApply: TButton;
    pnlPreviewBg: TPanel;
    lblPreviewText: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure rgModeClick(Sender: TObject);
    procedure rgColorSchemeClick(Sender: TObject);
  private
    procedure LoadCurrentTheme;
    procedure ApplySelectedTheme;
    procedure UpdatePreview;
  public
    { Public declarations }
  end;

var
  frmThemeSettings: TfrmThemeSettings;

implementation

{$R *.dfm}

procedure TfrmThemeSettings.FormCreate(Sender: TObject);
begin
  // Populate theme options
  rgMode.Items.Clear;
  rgMode.Items.Add(TThemeManager.GetThemeModeName(tmLight));
  rgMode.Items.Add(TThemeManager.GetThemeModeName(tmDark));

  rgColorScheme.Items.Clear;
  rgColorScheme.Items.Add(TThemeManager.GetColorSchemeName(tcBlueGray));
  rgColorScheme.Items.Add(TThemeManager.GetColorSchemeName(tcDarkOrange));
  rgColorScheme.Items.Add(TThemeManager.GetColorSchemeName(tcPurplePink));
  rgColorScheme.Items.Add(TThemeManager.GetColorSchemeName(tcGreenMatrix));
  rgColorScheme.Items.Add(TThemeManager.GetColorSchemeName(tcRedBlack));

  LoadCurrentTheme;
  UpdatePreview;
end;

procedure TfrmThemeSettings.LoadCurrentTheme;
var
  Theme: TTheme;
begin
  Theme := TThemeManager.GetCurrentTheme;
  rgMode.ItemIndex := Ord(Theme.Mode);
  rgColorScheme.ItemIndex := Ord(Theme.ColorScheme);
end;

procedure TfrmThemeSettings.ApplySelectedTheme;
var
  Mode: TThemeMode;
  ColorScheme: TThemeColor;
begin
  if (rgMode.ItemIndex < 0) or (rgColorScheme.ItemIndex < 0) then Exit;

  Mode := TThemeMode(rgMode.ItemIndex);
  ColorScheme := TThemeColor(rgColorScheme.ItemIndex);

  TThemeManager.SetTheme(Mode, ColorScheme);
end;

procedure TfrmThemeSettings.UpdatePreview;
var
  Theme: TTheme;
begin
  ApplySelectedTheme;
  Theme := TThemeManager.GetCurrentTheme;

  pnlPreview.Color := Theme.BackgroundPrimary;
  pnlPreviewBg.Color := Theme.BackgroundSecondary;
  lblPreview.Font.Color := Theme.TextPrimary;
  lblPreviewText.Font.Color := Theme.AccentPrimary;
  lblPreviewText.Caption := 'This is a preview of the selected theme. Accent colors and text will look like this.';
end;

procedure TfrmThemeSettings.rgModeClick(Sender: TObject);
begin
  UpdatePreview;
end;

procedure TfrmThemeSettings.rgColorSchemeClick(Sender: TObject);
begin
  UpdatePreview;
end;

procedure TfrmThemeSettings.btnOKClick(Sender: TObject);
begin
  ApplySelectedTheme;
  ModalResult := mrOK;
end;

procedure TfrmThemeSettings.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmThemeSettings.btnApplyClick(Sender: TObject);
begin
  ApplySelectedTheme;
  UpdatePreview;
end;

end.
