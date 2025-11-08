unit PromptManager;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, DatabaseManager;

type
  TPromptTemplate = record
    ID: Int64;
    Name: string;
    Content: string;
    Category: string;
  end;

  TPromptManager = class
  private
    class var FTemplates: TDictionary<Int64, TPromptTemplate>;
    class var FInitialized: Boolean;
  public
    class procedure Initialize;
    class procedure Finalize;
    class procedure LoadTemplates;

    class procedure SaveTemplate(const Name, Content, Category: string);
    class procedure DeleteTemplate(ID: Int64);
    class function GetTemplate(ID: Int64): TPromptTemplate;
    class function GetAllTemplates: TArray<TPromptTemplate>;
    class function GetTemplatesByCategory(const Category: string): TArray<TPromptTemplate>;
    class function GetCategories: TArray<string>;
  end;

implementation

class procedure TPromptManager.Initialize;
begin
  if FInitialized then Exit;
  FTemplates := TDictionary<Int64, TPromptTemplate>.Create;
  FInitialized := True;
  LoadTemplates;
end;

class procedure TPromptManager.Finalize;
begin
  if FInitialized then
  begin
    FTemplates.Free;
    FInitialized := False;
  end;
end;

class procedure TPromptManager.LoadTemplates;
var
  List: TStringList;
  I: Integer;
  Parts: TArray<string>;
  Template: TPromptTemplate;
begin
  FTemplates.Clear;
  List := TDatabaseManager.GetAllPrompts;
  try
    for I := 0 to List.Count - 1 do
    begin
      Parts := List[I].Split(['|']);
      if Length(Parts) >= 4 then
      begin
        Template.ID := StrToInt64(Parts[0]);
        Template.Name := Parts[1];
        Template.Content := Parts[2];
        Template.Category := Parts[3];
        FTemplates.Add(Template.ID, Template);
      end;
    end;
  finally
    List.Free;
  end;
end;

class procedure TPromptManager.SaveTemplate(const Name, Content, Category: string);
begin
  TDatabaseManager.SavePrompt(Name, Content, Category);
  LoadTemplates;
end;

class procedure TPromptManager.DeleteTemplate(ID: Int64);
begin
  TDatabaseManager.DeletePrompt(ID);
  LoadTemplates;
end;

class function TPromptManager.GetTemplate(ID: Int64): TPromptTemplate;
begin
  if FTemplates.ContainsKey(ID) then
    Result := FTemplates[ID]
  else
    FillChar(Result, SizeOf(Result), 0);
end;

class function TPromptManager.GetAllTemplates: TArray<TPromptTemplate>;
var
  List: TList<TPromptTemplate>;
  Pair: TPair<Int64, TPromptTemplate>;
begin
  List := TList<TPromptTemplate>.Create;
  try
    for Pair in FTemplates do
      List.Add(Pair.Value);
    Result := List.ToArray;
  finally
    List.Free;
  end;
end;

class function TPromptManager.GetTemplatesByCategory(const Category: string): TArray<TPromptTemplate>;
var
  List: TList<TPromptTemplate>;
  Pair: TPair<Int64, TPromptTemplate>;
begin
  List := TList<TPromptTemplate>.Create;
  try
    for Pair in FTemplates do
    begin
      if SameText(Pair.Value.Category, Category) then
        List.Add(Pair.Value);
    end;
    Result := List.ToArray;
  finally
    List.Free;
  end;
end;

class function TPromptManager.GetCategories: TArray<string>;
var
  List: TStringList;
  Pair: TPair<Int64, TPromptTemplate>;
begin
  List := TStringList.Create;
  try
    List.Duplicates := dupIgnore;
    List.Sorted := True;

    for Pair in FTemplates do
      List.Add(Pair.Value.Category);

    Result := List.ToStringArray;
  finally
    List.Free;
  end;
end;

end.
