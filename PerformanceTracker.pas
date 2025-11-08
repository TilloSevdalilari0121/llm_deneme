unit PerformanceTracker;

interface

uses
  System.SysUtils, DatabaseManager;

type
  TPerformanceTracker = class
  public
    class procedure Initialize;
    class procedure Finalize;
    
    class procedure LogRequest(const Provider, Model: string; Tokens, DurationMS: Integer);
    class function GetStats: TStringList;
    class function GetTotalTokens: Int64;
    class function GetTotalCost: Double;
  end;

implementation

uses SettingsManager;

class procedure TPerformanceTracker.Initialize;
begin
  // Initialize
end;

class procedure TPerformanceTracker.Finalize;
begin
  // Cleanup
end;

class procedure TPerformanceTracker.LogRequest(const Provider, Model: string; Tokens, DurationMS: Integer);
begin
  TDatabaseManager.LogPerformance(Provider, Model, Tokens, DurationMS);
end;

class function TPerformanceTracker.GetStats: TStringList;
begin
  Result := TDatabaseManager.GetPerformanceStats;
end;

class function TPerformanceTracker.GetTotalTokens: Int64;
var
  Stats: TStringList;
  I: Integer;
  Parts: TArray<string>;
begin
  Result := 0;
  Stats := GetStats;
  try
    for I := 0 to Stats.Count - 1 do
    begin
      Parts := Stats[I].Split(['|']);
      if Length(Parts) >= 4 then
        Result := Result + StrToInt64Def(Parts[3], 0);
    end;
  finally
    Stats.Free;
  end;
end;

class function TPerformanceTracker.GetTotalCost: Double;
var
  TotalTokens: Int64;
  CostPerMillion: Double;
begin
  TotalTokens := GetTotalTokens;
  CostPerMillion := TSettingsManager.GetTokenCostPerMillion;
  Result := (TotalTokens / 1000000.0) * CostPerMillion;
end;

end.
