unit HTTPClient;

interface

uses
  System.SysUtils, System.Classes, System.Net.HTTPClient, System.Net.URLClient,
  System.JSON;

type
  THTTPMethod = (hmGET, hmPOST, hmPUT, hmDELETE);

  THTTPClient = class
  private
    FClient: THTTPClient;
    FHeaders: TNetHeaders;
  public
    constructor Create;
    destructor Destroy; override;

    procedure SetHeader(const Name, Value: string);
    procedure ClearHeaders;

    function Request(const Method: THTTPMethod; const URL: string;
      const Body: string = ''): string;

    function GET(const URL: string): string;
    function POST(const URL: string; const Body: string): string;
    function PUT(const URL: string; const Body: string): string;
    function DELETE(const URL: string): string;

    function PostJSON(const URL: string; JSON: TJSONObject): TJSONValue;
    function GetJSON(const URL: string): TJSONValue;
  end;

implementation

constructor THTTPClient.Create;
begin
  inherited;
  FClient := System.Net.HTTPClient.THTTPClient.Create;
  FClient.HandleRedirects := True;
  FClient.ConnectionTimeout := 30000; // 30 seconds
  FClient.ResponseTimeout := 120000;  // 2 minutes
  SetLength(FHeaders, 0);
end;

destructor THTTPClient.Destroy;
begin
  FClient.Free;
  inherited;
end;

procedure THTTPClient.SetHeader(const Name, Value: string);
var
  I: Integer;
begin
  for I := 0 to High(FHeaders) do
  begin
    if SameText(FHeaders[I].Name, Name) then
    begin
      FHeaders[I].Value := Value;
      Exit;
    end;
  end;

  SetLength(FHeaders, Length(FHeaders) + 1);
  FHeaders[High(FHeaders)] := TNetHeader.Create(Name, Value);
end;

procedure THTTPClient.ClearHeaders;
begin
  SetLength(FHeaders, 0);
end;

function THTTPClient.Request(const Method: THTTPMethod; const URL: string;
  const Body: string): string;
var
  Response: IHTTPResponse;
  Stream: TStringStream;
begin
  Result := '';
  Stream := nil;

  try
    case Method of
      hmGET:
        Response := FClient.Get(URL, nil, FHeaders);

      hmPOST:
      begin
        Stream := TStringStream.Create(Body, TEncoding.UTF8);
        Response := FClient.Post(URL, Stream, nil, FHeaders);
      end;

      hmPUT:
      begin
        Stream := TStringStream.Create(Body, TEncoding.UTF8);
        Response := FClient.Put(URL, Stream, nil, FHeaders);
      end;

      hmDELETE:
        Response := FClient.Delete(URL, nil, FHeaders);
    end;

    if Assigned(Response) then
      Result := Response.ContentAsString;

  finally
    if Assigned(Stream) then
      Stream.Free;
  end;
end;

function THTTPClient.GET(const URL: string): string;
begin
  Result := Request(hmGET, URL);
end;

function THTTPClient.POST(const URL: string; const Body: string): string;
begin
  Result := Request(hmPOST, URL, Body);
end;

function THTTPClient.PUT(const URL: string; const Body: string): string;
begin
  Result := Request(hmPUT, URL, Body);
end;

function THTTPClient.DELETE(const URL: string): string;
begin
  Result := Request(hmDELETE, URL);
end;

function THTTPClient.PostJSON(const URL: string; JSON: TJSONObject): TJSONValue;
var
  ResponseText: string;
begin
  SetHeader('Content-Type', 'application/json');
  ResponseText := POST(URL, JSON.ToJSON);

  if ResponseText <> '' then
    Result := TJSONObject.ParseJSONValue(ResponseText)
  else
    Result := nil;
end;

function THTTPClient.GetJSON(const URL: string): TJSONValue;
var
  ResponseText: string;
begin
  ResponseText := GET(URL);

  if ResponseText <> '' then
    Result := TJSONObject.ParseJSONValue(ResponseText)
  else
    Result := nil;
end;

end.
