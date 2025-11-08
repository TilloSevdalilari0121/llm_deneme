unit WebScraper;

interface

uses
  System.SysUtils, HTTPClient;

type
  TWebScraper = class
  public
    class function FetchURL(const URL: string): string;
    class function ExtractText(const HTML: string): string;
  end;

implementation

class function TWebScraper.FetchURL(const URL: string): string;
var
  HTTP: THTTPClient;
begin
  HTTP := THTTPClient.Create;
  try
    Result := HTTP.GET(URL);
  finally
    HTTP.Free;
  end;
end;

class function TWebScraper.ExtractText(const HTML: string): string;
begin
  // TODO: Implement HTML to text conversion
  Result := HTML;
end;

end.
