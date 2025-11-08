unit ThemeManager;

{$IFDEF FPC}
  {$MODE DELPHI}
{$ENDIF}

interface

uses
  System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Forms, Vcl.Controls,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls;

type
  TThemeMode = (tmLight, tmDark);

  TThemeColor = (
    tcBlueGray,      // Modern Blue/Gray
    tcDarkOrange,    // Dark/Orange (Cyberpunk)
    tcPurplePink,    // Purple/Pink (Neon)
    tcGreenMatrix,   // Green/Black (Matrix)
    tcRedBlack       // Red/Black (Aggressive)
  );

  TTheme = record
    Mode: TThemeMode;
    ColorScheme: TThemeColor;
    // Background colors
    BackgroundPrimary: TColor;
    BackgroundSecondary: TColor;
    BackgroundTertiary: TColor;
    // Text colors
    TextPrimary: TColor;
    TextSecondary: TColor;
    TextHint: TColor;
    // Accent colors
    AccentPrimary: TColor;
    AccentSecondary: TColor;
    AccentHighlight: TColor;
    // UI element colors
    BorderColor: TColor;
    HoverColor: TColor;
    ActiveColor: TColor;
    DisabledColor: TColor;
    // Chat specific
    UserMessageBg: TColor;
    AssistantMessageBg: TColor;
    CodeBlockBg: TColor;
  end;

  TThemeManager = class
  private
    class var FCurrentTheme: TTheme;
    class var FThemeMode: TThemeMode;
    class var FColorScheme: TThemeColor;
    class procedure BuildTheme;
  public
    class procedure Initialize;
    class procedure SetTheme(AMode: TThemeMode; AColor: TThemeColor);
    class procedure ApplySavedTheme;
    class procedure ApplyToForm(AForm: TForm);
    class procedure ApplyToControl(AControl: TControl);
    class function GetCurrentTheme: TTheme;
    class function GetThemeModeName(AMode: TThemeMode): string;
    class function GetColorSchemeName(AColor: TThemeColor): string;
  end;

implementation

uses
  SettingsManager;

class procedure TThemeManager.Initialize;
begin
  FThemeMode := tmDark;
  FColorScheme := tcBlueGray;
  BuildTheme;
end;

class procedure TThemeManager.BuildTheme;
begin
  // Set defaults
  FCurrentTheme.Mode := FThemeMode;
  FCurrentTheme.ColorScheme := FColorScheme;

  case FColorScheme of
    tcBlueGray:
    begin
      if FThemeMode = tmDark then
      begin
        FCurrentTheme.BackgroundPrimary := $2D2D30;    // Dark gray
        FCurrentTheme.BackgroundSecondary := $252526;  // Darker gray
        FCurrentTheme.BackgroundTertiary := $1E1E1E;   // Darkest
        FCurrentTheme.TextPrimary := $F0F0F0;          // Almost white
        FCurrentTheme.TextSecondary := $CCCCCC;        // Light gray
        FCurrentTheme.TextHint := $808080;             // Gray
        FCurrentTheme.AccentPrimary := $FFA500;        // Orange
        FCurrentTheme.AccentSecondary := $4080FF;      // Blue
        FCurrentTheme.AccentHighlight := $FFB84D;      // Light orange
        FCurrentTheme.BorderColor := $3F3F46;          // Border gray
        FCurrentTheme.HoverColor := $3E3E42;           // Hover gray
        FCurrentTheme.ActiveColor := $094771;          // Active blue
        FCurrentTheme.DisabledColor := $555555;
        FCurrentTheme.UserMessageBg := $3D2A1F;        // Brown tint
        FCurrentTheme.AssistantMessageBg := $1F3D2A;   // Green tint
        FCurrentTheme.CodeBlockBg := $1E1E1E;
      end
      else
      begin
        FCurrentTheme.BackgroundPrimary := $FFFFFF;
        FCurrentTheme.BackgroundSecondary := $F3F3F3;
        FCurrentTheme.BackgroundTertiary := $E8E8E8;
        FCurrentTheme.TextPrimary := $000000;
        FCurrentTheme.TextSecondary := $424242;
        FCurrentTheme.TextHint := $9E9E9E;
        FCurrentTheme.AccentPrimary := $FF6B00;
        FCurrentTheme.AccentSecondary := $0078D4;
        FCurrentTheme.AccentHighlight := $FF8533;
        FCurrentTheme.BorderColor := $D1D1D1;
        FCurrentTheme.HoverColor := $E5E5E5;
        FCurrentTheme.ActiveColor := $CCE8FF;
        FCurrentTheme.DisabledColor := $BDBDBD;
        FCurrentTheme.UserMessageBg := $FFF4E6;
        FCurrentTheme.AssistantMessageBg := $E6F7FF;
        FCurrentTheme.CodeBlockBg := $F5F5F5;
      end;
    end;

    tcDarkOrange:
    begin
      FCurrentTheme.BackgroundPrimary := $0F0F0F;      // Almost black
      FCurrentTheme.BackgroundSecondary := $1A1A1A;
      FCurrentTheme.BackgroundTertiary := $0A0A0A;
      FCurrentTheme.TextPrimary := $FFFFFF;
      FCurrentTheme.TextSecondary := $CCCCCC;
      FCurrentTheme.TextHint := $666666;
      FCurrentTheme.AccentPrimary := $1A8CFF;          // Cyber orange
      FCurrentTheme.AccentSecondary := $FF6A00;
      FCurrentTheme.AccentHighlight := $FFA733;
      FCurrentTheme.BorderColor := $2A2A2A;
      FCurrentTheme.HoverColor := $252525;
      FCurrentTheme.ActiveColor := $FF8C1A;
      FCurrentTheme.DisabledColor := $404040;
      FCurrentTheme.UserMessageBg := $2A1F0F;
      FCurrentTheme.AssistantMessageBg := $1F1F2A;
      FCurrentTheme.CodeBlockBg := $151515;
    end;

    tcPurplePink:
    begin
      FCurrentTheme.BackgroundPrimary := $1E1E2E;      // Dark purple
      FCurrentTheme.BackgroundSecondary := $2A2A3E;
      FCurrentTheme.BackgroundTertiary := $16162A;
      FCurrentTheme.TextPrimary := $F0E6FF;
      FCurrentTheme.TextSecondary := $D4C5F9;
      FCurrentTheme.TextHint := $8B7BA8;
      FCurrentTheme.AccentPrimary := $FF69B4;          // Hot pink
      FCurrentTheme.AccentSecondary := $9370DB;        // Medium purple
      FCurrentTheme.AccentHighlight := $FF1493;        // Deep pink
      FCurrentTheme.BorderColor := $433D5C;
      FCurrentTheme.HoverColor := $3A3450;
      FCurrentTheme.ActiveColor := $6B4B9A;
      FCurrentTheme.DisabledColor := $4A4A6A;
      FCurrentTheme.UserMessageBg := $2E1E3E;
      FCurrentTheme.AssistantMessageBg := $1E2E3E;
      FCurrentTheme.CodeBlockBg := $1A1A2A;
    end;

    tcGreenMatrix:
    begin
      FCurrentTheme.BackgroundPrimary := $000000;      // Pure black
      FCurrentTheme.BackgroundSecondary := $0A0A0A;
      FCurrentTheme.BackgroundTertiary := $050505;
      FCurrentTheme.TextPrimary := $00FF00;            // Matrix green
      FCurrentTheme.TextSecondary := $00CC00;
      FCurrentTheme.TextHint := $008800;
      FCurrentTheme.AccentPrimary := $00FF00;
      FCurrentTheme.AccentSecondary := $00AA00;
      FCurrentTheme.AccentHighlight := $66FF66;
      FCurrentTheme.BorderColor := $003300;
      FCurrentTheme.HoverColor := $0A1A0A;
      FCurrentTheme.ActiveColor := $00FF00;
      FCurrentTheme.DisabledColor := $004400;
      FCurrentTheme.UserMessageBg := $001100;
      FCurrentTheme.AssistantMessageBg := $000A00;
      FCurrentTheme.CodeBlockBg := $000800;
    end;

    tcRedBlack:
    begin
      FCurrentTheme.BackgroundPrimary := $0A0A0A;
      FCurrentTheme.BackgroundSecondary := $1A0A0A;
      FCurrentTheme.BackgroundTertiary := $050505;
      FCurrentTheme.TextPrimary := $FFFFFF;
      FCurrentTheme.TextSecondary := $E6E6E6;
      FCurrentTheme.TextHint := $999999;
      FCurrentTheme.AccentPrimary := $0000FF;          // Pure red (BGR)
      FCurrentTheme.AccentSecondary := $0000CC;        // Dark red
      FCurrentTheme.AccentHighlight := $3333FF;        // Light red
      FCurrentTheme.BorderColor := $1A0000;
      FCurrentTheme.HoverColor := $150A0A;
      FCurrentTheme.ActiveColor := $000088;
      FCurrentTheme.DisabledColor := $333333;
      FCurrentTheme.UserMessageBg := $0F0000;
      FCurrentTheme.AssistantMessageBg := $00000F;
      FCurrentTheme.CodeBlockBg := $0A0000;
    end;
  end;
end;

class procedure TThemeManager.SetTheme(AMode: TThemeMode; AColor: TThemeColor);
begin
  FThemeMode := AMode;
  FColorScheme := AColor;
  BuildTheme;
  // Save to settings
  TSettingsManager.SetThemeMode(Ord(AMode));
  TSettingsManager.SetColorScheme(Ord(AColor));
end;

class procedure TThemeManager.ApplySavedTheme;
var
  Mode, Color: Integer;
begin
  Mode := TSettingsManager.GetThemeMode;
  Color := TSettingsManager.GetColorScheme;

  if Mode in [Ord(Low(TThemeMode))..Ord(High(TThemeMode))] then
    FThemeMode := TThemeMode(Mode);

  if Color in [Ord(Low(TThemeColor))..Ord(High(TThemeColor))] then
    FColorScheme := TThemeColor(Color);

  BuildTheme;
end;

class procedure TThemeManager.ApplyToForm(AForm: TForm);
begin
  if not Assigned(AForm) then Exit;

  AForm.Color := FCurrentTheme.BackgroundPrimary;
  AForm.Font.Color := FCurrentTheme.TextPrimary;

  // Apply to all controls
  var I: Integer;
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
    TPanel(AControl).Color := FCurrentTheme.BackgroundSecondary;
    TPanel(AControl).Font.Color := FCurrentTheme.TextPrimary;
  end
  // Labels
  else if AControl is TLabel then
  begin
    TLabel(AControl).Font.Color := FCurrentTheme.TextPrimary;
  end
  // Edits and Memos
  else if AControl is TEdit then
  begin
    TEdit(AControl).Color := FCurrentTheme.BackgroundTertiary;
    TEdit(AControl).Font.Color := FCurrentTheme.TextPrimary;
  end
  else if AControl is TMemo then
  begin
    TMemo(AControl).Color := FCurrentTheme.BackgroundTertiary;
    TMemo(AControl).Font.Color := FCurrentTheme.TextPrimary;
  end
  else if AControl is TRichEdit then
  begin
    TRichEdit(AControl).Color := FCurrentTheme.BackgroundTertiary;
    TRichEdit(AControl).Font.Color := FCurrentTheme.TextPrimary;
  end
  // Buttons
  else if AControl is TButton then
  begin
    TButton(AControl).Font.Color := FCurrentTheme.TextPrimary;
  end
  // ListBoxes and ComboBoxes
  else if AControl is TListBox then
  begin
    TListBox(AControl).Color := FCurrentTheme.BackgroundTertiary;
    TListBox(AControl).Font.Color := FCurrentTheme.TextPrimary;
  end
  else if AControl is TComboBox then
  begin
    TComboBox(AControl).Color := FCurrentTheme.BackgroundTertiary;
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

class function TThemeManager.GetThemeModeName(AMode: TThemeMode): string;
begin
  case AMode of
    tmLight: Result := 'Light Mode';
    tmDark: Result := 'Dark Mode';
  else
    Result := 'Unknown';
  end;
end;

class function TThemeManager.GetColorSchemeName(AColor: TThemeColor): string;
begin
  case AColor of
    tcBlueGray: Result := 'Blue/Gray (Modern)';
    tcDarkOrange: Result := 'Dark/Orange (Cyberpunk)';
    tcPurplePink: Result := 'Purple/Pink (Neon)';
    tcGreenMatrix: Result := 'Green/Black (Matrix)';
    tcRedBlack: Result := 'Red/Black (Aggressive)';
  else
    Result := 'Unknown';
  end;
end;

end.
