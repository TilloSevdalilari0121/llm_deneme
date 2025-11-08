unit ThemeManager;

interface

uses
  System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Forms, Vcl.Controls,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, SettingsManager;

type
  TThemeMode = (tmLight, tmDark);

  TTheme = record
    ID: Integer;
    Name: string;
    Mode: TThemeMode;
    // Background colors
    BgPrimary: TColor;
    BgSecondary: TColor;
    BgTertiary: TColor;
    // Text colors
    TextPrimary: TColor;
    TextSecondary: TColor;
    TextHint: TColor;
    // Accent colors
    AccentPrimary: TColor;
    AccentSecondary: TColor;
    AccentHighlight: TColor;
    // UI elements
    BorderColor: TColor;
    HoverColor: TColor;
    ActiveColor: TColor;
    // Chat specific
    UserMessageBg: TColor;
    AssistantMessageBg: TColor;
    CodeBlockBg: TColor;
  end;

  TThemeManager = class
  private
    class var FThemes: TArray<TTheme>;
    class var FCurrentTheme: TTheme;
    class procedure InitializeThemes;
  public
    class procedure Initialize;
    class procedure SetTheme(ThemeID: Integer);
    class procedure ApplySavedTheme;
    class procedure ApplyToForm(AForm: TForm);
    class procedure ApplyToControl(AControl: TControl);
    class function GetCurrentTheme: TTheme;
    class function GetAllThemes: TArray<TTheme>;
    class function GetThemeByID(ID: Integer): TTheme;
  end;

implementation

class procedure TThemeManager.Initialize;
begin
  InitializeThemes;
end;

class procedure TThemeManager.InitializeThemes;
var
  T: TTheme;
begin
  SetLength(FThemes, 15);

  // 1. VS Code Dark
  T.ID := 0;
  T.Name := 'VS Code Dark';
  T.Mode := tmDark;
  T.BgPrimary := $1E1E1E;
  T.BgSecondary := $252526;
  T.BgTertiary := $2D2D30;
  T.TextPrimary := $D4D4D4;
  T.TextSecondary := $CCCCCC;
  T.TextHint := $858585;
  T.AccentPrimary := $FF9800;
  T.AccentSecondary := $007ACC;
  T.AccentHighlight := $FFC947;
  T.BorderColor := $3E3E42;
  T.HoverColor := $2A2D2E;
  T.ActiveColor := $094771;
  T.UserMessageBg := $2D2520;
  T.AssistantMessageBg := $202D25;
  T.CodeBlockBg := $1E1E1E;
  FThemes[0] := T;

  // 2. GitHub Dark
  T.ID := 1;
  T.Name := 'GitHub Dark';
  T.Mode := tmDark;
  T.BgPrimary := $0D1117;
  T.BgSecondary := $161B22;
  T.BgTertiary := $21262D;
  T.TextPrimary := $C9D1D9;
  T.TextSecondary := $8B949E;
  T.TextHint := $6E7681;
  T.AccentPrimary := $58A6FF;
  T.AccentSecondary := $1F6FEB;
  T.AccentHighlight := $79C0FF;
  T.BorderColor := $30363D;
  T.HoverColor := $161B22;
  T.ActiveColor := $388BFD;
  T.UserMessageBg := $1A1F25;
  T.AssistantMessageBg := $151A1F;
  T.CodeBlockBg := $0D1117;
  FThemes[1] := T;

  // 3. Dracula
  T.ID := 2;
  T.Name := 'Dracula';
  T.Mode := tmDark;
  T.BgPrimary := $282A36;
  T.BgSecondary := $44475A;
  T.BgTertiary := $21222C;
  T.TextPrimary := $F8F8F2;
  T.TextSecondary := $BD93F9;
  T.TextHint := $6272A4;
  T.AccentPrimary := $FF79C6;
  T.AccentSecondary := $8BE9FD;
  T.AccentHighlight := $FFB86C;
  T.BorderColor := $44475A;
  T.HoverColor := $343746;
  T.ActiveColor := $BD93F9;
  T.UserMessageBg := $2E303E;
  T.AssistantMessageBg := $2A2C38;
  T.CodeBlockBg := $282A36;
  FThemes[2] := T;

  // 4. Monokai Pro
  T.ID := 3;
  T.Name := 'Monokai Pro';
  T.Mode := tmDark;
  T.BgPrimary := $2D2A2E;
  T.BgSecondary := $403E41;
  T.BgTertiary := $221F22;
  T.TextPrimary := $FCFCFA;
  T.TextSecondary := $FFD866;
  T.TextHint := $727072;
  T.AccentPrimary := $FF6188;
  T.AccentSecondary := $A9DC76;
  T.AccentHighlight := $FC9867;
  T.BorderColor := $5B595C;
  T.HoverColor := $363437;
  T.ActiveColor := $FF6188;
  T.UserMessageBg := $332F34;
  T.AssistantMessageBg := $2F2D32;
  T.CodeBlockBg := $2D2A2E;
  FThemes[3] := T;

  // 5. Nord
  T.ID := 4;
  T.Name := 'Nord';
  T.Mode := tmDark;
  T.BgPrimary := $2E3440;
  T.BgSecondary := $3B4252;
  T.BgTertiary := $434C5E;
  T.TextPrimary := $ECEFF4;
  T.TextSecondary := $D8DEE9;
  T.TextHint := $4C566A;
  T.AccentPrimary := $88C0D0;
  T.AccentSecondary := $81A1C1;
  T.AccentHighlight := $5E81AC;
  T.BorderColor := $4C566A;
  T.HoverColor := $3B4252;
  T.ActiveColor := $88C0D0;
  T.UserMessageBg := $363D4A;
  T.AssistantMessageBg := $323944;
  T.CodeBlockBg := $2E3440;
  FThemes[4] := T;

  // 6. Gruvbox Dark
  T.ID := 5;
  T.Name := 'Gruvbox Dark';
  T.Mode := tmDark;
  T.BgPrimary := $282828;
  T.BgSecondary := $3C3836;
  T.BgTertiary := $1D2021;
  T.TextPrimary := $EBDBB2;
  T.TextSecondary := $D5C4A1;
  T.TextHint := $928374;
  T.AccentPrimary := $FE8019;
  T.AccentSecondary := $B8BB26;
  T.AccentHighlight := $FABD2F;
  T.BorderColor := $504945;
  T.HoverColor := $32302F;
  T.ActiveColor := $FE8019;
  T.UserMessageBg := $3C3632;
  T.AssistantMessageBg := $333028;
  T.CodeBlockBg := $1D2021;
  FThemes[5] := T;

  // 7. Solarized Dark
  T.ID := 6;
  T.Name := 'Solarized Dark';
  T.Mode := tmDark;
  T.BgPrimary := $002B36;
  T.BgSecondary := $073642;
  T.BgTertiary := $001F29;
  T.TextPrimary := $839496;
  T.TextSecondary := $93A1A1;
  T.TextHint := $586E75;
  T.AccentPrimary := $B58900;
  T.AccentSecondary := $268BD2;
  T.AccentHighlight := $CB4B16;
  T.BorderColor := $073642;
  T.HoverColor := $073642;
  T.ActiveColor := $268BD2;
  T.UserMessageBg := $073642;
  T.AssistantMessageBg := $00313C;
  T.CodeBlockBg := $002B36;
  FThemes[6] := T;

  // 8. Tokyo Night
  T.ID := 7;
  T.Name := 'Tokyo Night';
  T.Mode := tmDark;
  T.BgPrimary := $1A1B26;
  T.BgSecondary := $24283B;
  T.BgTertiary := $16161E;
  T.TextPrimary := $A9B1D6;
  T.TextSecondary := $C0CAF5;
  T.TextHint := $565F89;
  T.AccentPrimary := $7AA2F7;
  T.AccentSecondary := $BB9AF7;
  T.AccentHighlight := $7DCFFF;
  T.BorderColor := $292E42;
  T.HoverColor := $1F2335;
  T.ActiveColor := $7AA2F7;
  T.UserMessageBg := $1E2030;
  T.AssistantMessageBg := $1C1E2C;
  T.CodeBlockBg := $16161E;
  FThemes[7] := T;

  // 9. One Dark Pro
  T.ID := 8;
  T.Name := 'One Dark Pro';
  T.Mode := tmDark;
  T.BgPrimary := $282C34;
  T.BgSecondary := $21252B;
  T.BgTertiary := $1E2227;
  T.TextPrimary := $ABB2BF;
  T.TextSecondary := $C8CCD4;
  T.TextHint := $5C6370;
  T.AccentPrimary := $61AFEF;
  T.AccentSecondary := $C678DD;
  T.AccentHighlight := $E5C07B;
  T.BorderColor := $181A1F;
  T.HoverColor := $2C313A;
  T.ActiveColor := $61AFEF;
  T.UserMessageBg := $2E333C;
  T.AssistantMessageBg := $292D36;
  T.CodeBlockBg := $282C34;
  FThemes[8] := T;

  // 10. Material Dark
  T.ID := 9;
  T.Name := 'Material Dark';
  T.Mode := tmDark;
  T.BgPrimary := $263238;
  T.BgSecondary := $37474F;
  T.BgTertiary := $1E272E;
  T.TextPrimary := $EEFFFF;
  T.TextSecondary := $B2CCD6;
  T.TextHint := $546E7A;
  T.AccentPrimary := $80CBC4;
  T.AccentSecondary := $89DDFF;
  T.AccentHighlight := $FFB62C;
  T.BorderColor := $37474F;
  T.HoverColor := $2E3C43;
  T.ActiveColor := $80CBC4;
  T.UserMessageBg := $2C3A41;
  T.AssistantMessageBg := $29363D;
  T.CodeBlockBg := $263238;
  FThemes[9] := T;

  // 11. Light (GitHub Light)
  T.ID := 10;
  T.Name := 'GitHub Light';
  T.Mode := tmLight;
  T.BgPrimary := $FFFFFF;
  T.BgSecondary := $F6F8FA;
  T.BgTertiary := $FFFFFF;
  T.TextPrimary := $24292F;
  T.TextSecondary := $586069;
  T.TextHint := $6A737D;
  T.AccentPrimary := $0969DA;
  T.AccentSecondary := $1F883D;
  T.AccentHighlight := $0550AE;
  T.BorderColor := $D0D7DE;
  T.HoverColor := $F3F4F6;
  T.ActiveColor := $DDF4FF;
  T.UserMessageBg := $F0F6FF;
  T.AssistantMessageBg := $F0FFF4;
  T.CodeBlockBg := $F6F8FA;
  FThemes[10] := T;

  // 12. Light (VS Code Light)
  T.ID := 11;
  T.Name := 'VS Code Light';
  T.Mode := tmLight;
  T.BgPrimary := $FFFFFF;
  T.BgSecondary := $F3F3F3;
  T.BgTertiary := $F8F8F8;
  T.TextPrimary := $000000;
  T.TextSecondary := $424242;
  T.TextHint := $6A737D;
  T.AccentPrimary := $0078D4;
  T.AccentSecondary := $008000;
  T.AccentHighlight := $007ACC;
  T.BorderColor := $DDDDDD;
  T.HoverColor := $E8E8E8;
  T.ActiveColor := $CCE8FF;
  T.UserMessageBg := $EBF5FB;
  T.AssistantMessageBg := $E8F8F5;
  T.CodeBlockBg := $F5F5F5;
  FThemes[11] := T;

  // 13. Solarized Light
  T.ID := 12;
  T.Name := 'Solarized Light';
  T.Mode := tmLight;
  T.BgPrimary := $FDF6E3;
  T.BgSecondary := $EEE8D5;
  T.BgTertiary := $FCF5E1;
  T.TextPrimary := $657B83;
  T.TextSecondary := $586E75;
  T.TextHint := $93A1A1;
  T.AccentPrimary := $B58900;
  T.AccentSecondary := $268BD2;
  T.AccentHighlight := $CB4B16;
  T.BorderColor := $EEE8D5;
  T.HoverColor := $EEE8D5;
  T.ActiveColor := $D9D2C2;
  T.UserMessageBg := $F5EFDB;
  T.AssistantMessageBg := $F0EBDC;
  T.CodeBlockBg := $FDF6E3;
  FThemes[12] := T;

  // 14. Gruvbox Light
  T.ID := 13;
  T.Name := 'Gruvbox Light';
  T.Mode := tmLight;
  T.BgPrimary := $FBF1C7;
  T.BgSecondary := $EBDBB2;
  T.BgTertiary := $F2E5BC;
  T.TextPrimary := $3C3836;
  T.TextSecondary := $504945;
  T.TextHint := $928374;
  T.AccentPrimary := $AF3A03;
  T.AccentSecondary := $79740E;
  T.AccentHighlight := $B57614;
  T.BorderColor := $D5C4A1;
  T.HoverColor := $EBDBB2;
  T.ActiveColor := $D5C4A1;
  T.UserMessageBg := $F9F5D7;
  T.AssistantMessageBg := $F5EDCA;
  T.CodeBlockBg := $FBF1C7;
  FThemes[13] := T;

  // 15. Material Light
  T.ID := 14;
  T.Name := 'Material Light';
  T.Mode := tmLight;
  T.BgPrimary := $FAFAFA;
  T.BgSecondary := $FFFFFF;
  T.BgTertiary := $F5F5F5;
  T.TextPrimary := $212121;
  T.TextSecondary := $424242;
  T.TextHint := $9E9E9E;
  T.AccentPrimary := $2196F3;
  T.AccentSecondary := $4CAF50;
  T.AccentHighlight := $03A9F4;
  T.BorderColor := $E0E0E0;
  T.HoverColor := $F5F5F5;
  T.ActiveColor := $E1F5FE;
  T.UserMessageBg := $E3F2FD;
  T.AssistantMessageBg := $E8F5E9;
  T.CodeBlockBg := $FAFAFA;
  FThemes[14] := T;

  // Set default theme
  FCurrentTheme := FThemes[0];
end;

class procedure TThemeManager.SetTheme(ThemeID: Integer);
begin
  if (ThemeID >= 0) and (ThemeID < Length(FThemes)) then
  begin
    FCurrentTheme := FThemes[ThemeID];
    TSettingsManager.SetThemeID(ThemeID);
    TSettingsManager.SetThemeMode(Ord(FCurrentTheme.Mode));
  end;
end;

class procedure TThemeManager.ApplySavedTheme;
var
  ThemeID: Integer;
begin
  ThemeID := TSettingsManager.GetThemeID;
  SetTheme(ThemeID);
end;

class procedure TThemeManager.ApplyToForm(AForm: TForm);
var
  I: Integer;
begin
  if not Assigned(AForm) then Exit;

  AForm.Color := FCurrentTheme.BgPrimary;
  AForm.Font.Color := FCurrentTheme.TextPrimary;

  for I := 0 to AForm.ComponentCount - 1 do
  begin
    if AForm.Components[I] is TControl then
      ApplyToControl(TControl(AForm.Components[I]));
  end;
end;

class procedure TThemeManager.ApplyToControl(AControl: TControl);
begin
  if not Assigned(AControl) then Exit;

  // Panels
  if AControl is TPanel then
  begin
    TPanel(AControl).Color := FCurrentTheme.BgSecondary;
    TPanel(AControl).Font.Color := FCurrentTheme.TextPrimary;
  end
  // Labels
  else if AControl is TLabel then
    TLabel(AControl).Font.Color := FCurrentTheme.TextPrimary
  // Edits
  else if AControl is TEdit then
  begin
    TEdit(AControl).Color := FCurrentTheme.BgTertiary;
    TEdit(AControl).Font.Color := FCurrentTheme.TextPrimary;
  end
  // Memos
  else if AControl is TMemo then
  begin
    TMemo(AControl).Color := FCurrentTheme.BgTertiary;
    TMemo(AControl).Font.Color := FCurrentTheme.TextPrimary;
  end
  // RichEdit
  else if AControl is TRichEdit then
  begin
    TRichEdit(AControl).Color := FCurrentTheme.BgTertiary;
    TRichEdit(AControl).Font.Color := FCurrentTheme.TextPrimary;
  end
  // Buttons
  else if AControl is TButton then
    TButton(AControl).Font.Color := FCurrentTheme.TextPrimary
  // ListBoxes
  else if AControl is TListBox then
  begin
    TListBox(AControl).Color := FCurrentTheme.BgTertiary;
    TListBox(AControl).Font.Color := FCurrentTheme.TextPrimary;
  end
  // ComboBoxes
  else if AControl is TComboBox then
  begin
    TComboBox(AControl).Color := FCurrentTheme.BgTertiary;
    TComboBox(AControl).Font.Color := FCurrentTheme.TextPrimary;
  end;

  // Recursively apply to child controls
  if AControl is TWinControl then
  begin
    var I: Integer;
    for I := 0 to TWinControl(AControl).ControlCount - 1 do
      ApplyToControl(TWinControl(AControl).Controls[I]);
  end;
end;

class function TThemeManager.GetCurrentTheme: TTheme;
begin
  Result := FCurrentTheme;
end;

class function TThemeManager.GetAllThemes: TArray<TTheme>;
begin
  Result := FThemes;
end;

class function TThemeManager.GetThemeByID(ID: Integer): TTheme;
begin
  if (ID >= 0) and (ID < Length(FThemes)) then
    Result := FThemes[ID]
  else
    Result := FThemes[0];
end;

end.
