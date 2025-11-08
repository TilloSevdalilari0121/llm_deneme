unit CodeExecutor;

interface

uses
  System.SysUtils, System.Classes, Winapi.Windows;

type
  TCodeExecutor = class
  public
    class function ExecutePython(const Code: string): string;
    class function ExecuteCode(const Language, Code: string): string;
    class function IsCodeExecutionEnabled: Boolean;
  end;

implementation

uses SettingsManager;

class function TCodeExecutor.IsCodeExecutionEnabled: Boolean;
begin
  Result := TSettingsManager.GetCodeExecutionEnabled;
end;

class function TCodeExecutor.ExecutePython(const Code: string): string;
var
  TempFile, OutputFile: string;
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
  SecurityAttr: TSecurityAttributes;
  OutputHandle: THandle;
begin
  Result := '';
  if not IsCodeExecutionEnabled then
    Exit('Code execution is disabled');

  // TODO: Implement safe Python execution
  Result := 'Python execution not yet implemented';
end;

class function TCodeExecutor.ExecuteCode(const Language, Code: string): string;
begin
  if SameText(Language, 'python') then
    Result := ExecutePython(Code)
  else
    Result := 'Unsupported language: ' + Language;
end;

end.
