unit ResourceExtractor;

{$IFDEF FPC}
  {$MODE DELPHI}
{$ENDIF}

interface

uses
  System.SysUtils, System.Classes, Winapi.Windows;

type
  TResourceExtractor = class
  public
    class procedure ExtractResource(const ResourceName, OutputPath: string);
    class function ResourceExists(const ResourceName: string): Boolean;
  end;

implementation

class function TResourceExtractor.ResourceExists(const ResourceName: string): Boolean;
var
  ResStream: TResourceStream;
begin
  Result := False;
  try
    ResStream := TResourceStream.Create(HInstance, ResourceName, RT_RCDATA);
    try
      Result := True;
    finally
      ResStream.Free;
    end;
  except
    Result := False;
  end;
end;

class procedure TResourceExtractor.ExtractResource(const ResourceName, OutputPath: string);
var
  ResStream: TResourceStream;
  FileStream: TFileStream;
begin
  if FileExists(OutputPath) then
  begin
    // Check if file is valid/accessible
    try
      FileStream := TFileStream.Create(OutputPath, fmOpenRead);
      FileStream.Free;
      Exit; // File exists and is valid, skip extraction
    except
      // File is locked or corrupted, re-extract
      DeleteFile(OutputPath);
    end;
  end;

  try
    ResStream := TResourceStream.Create(HInstance, ResourceName, RT_RCDATA);
    try
      FileStream := TFileStream.Create(OutputPath, fmCreate);
      try
        FileStream.CopyFrom(ResStream, 0);
      finally
        FileStream.Free;
      end;
    finally
      ResStream.Free;
    end;
  except
    on E: Exception do
      raise Exception.CreateFmt('Failed to extract resource "%s": %s',
        [ResourceName, E.Message]);
  end;
end;

end.
