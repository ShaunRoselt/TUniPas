{ ============================================================================
  UniPas.AppSettings
  JSON-based application settings with support for:
  - Dotted key paths for nested values (e.g., 'UI.Theme.DarkMode')
  - Auto-save functionality
  - Multiple data types (string, integer, double, boolean)
  ============================================================================ }
unit UniPas.AppSettings;

interface

uses
  System.SysUtils,
  System.Classes,
  System.JSON,
  System.IOUtils,
  System.Generics.Collections,
  System.TypInfo,
  System.Rtti;

type
  { TAppSettingsImpl - Internal implementation of app settings }
  TAppSettingsImpl = class
  private
    FData: TJSONObject;
    FFilePath: string;
    FAutoSave: Boolean;
    FOnChange: TNotifyEvent;
    procedure SetAutoSave(const Value: Boolean);
    procedure DoChange;
    function FindParentObject(const AKey: string; CreateMissing: Boolean; out LeafName: string): TJSONObject;
  public
    constructor Create(const AFilePath: string = '');
    destructor Destroy; override;

    procedure LoadFromFile;
    procedure SaveToFile;
    procedure Clear;

    function HasKey(const AKey: string): Boolean;
    procedure RemoveKey(const AKey: string);
    function Keys: TArray<string>;

    // Support dotted key paths for nested JSON objects (e.g., 'App.UI.DarkMode')
    // Keys written with dots will create nested objects; reads check nested then fall back to top-level.

    // Type-specific setters
    procedure SetValue(const AKey: string; const AValue: string); overload;
    procedure SetValue(const AKey: string; AValue: Integer); overload;
    procedure SetValue(const AKey: string; AValue: Double); overload;
    procedure SetValue(const AKey: string; AValue: Boolean); overload;

    // Generic getter: call with the expected type and a default value
    function GetValue<T>(const AKey: string; const ADefault: T): T;

    property FilePath: string read FFilePath;
    property AutoSave: Boolean read FAutoSave write SetAutoSave;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

implementation

// Utility: split a dotted key path into parts
function SplitPath(const AKey: string): TArray<string>;
begin
  Result := AKey.Split(['.']);
end;

{ TAppSettingsImpl }

constructor TAppSettingsImpl.Create(const AFilePath: string);
begin
  inherited Create;
  FData := TJSONObject.Create;
  FAutoSave := True;
  if AFilePath.Trim.IsEmpty then
    FFilePath := TPath.Combine(ExtractFilePath(ParamStr(0)), 'appsettings.json')
  else
    FFilePath := AFilePath;
end;

destructor TAppSettingsImpl.Destroy;
begin
  try
    if FAutoSave then
      SaveToFile;
  except
    // Ignore save errors during destruction
  end;
  FData.Free;
  inherited;
end;

function TAppSettingsImpl.FindParentObject(const AKey: string; CreateMissing: Boolean; out LeafName: string): TJSONObject;
var
  Parts: TArray<string>;
  I: Integer;
  Cur: TJSONObject;
  V: TJSONValue;
  Child: TJSONObject;
begin
  Result := nil;
  LeafName := AKey;

  if AKey = '' then
    Exit;

  Parts := SplitPath(AKey);
  if Length(Parts) = 0 then
    Exit;

  LeafName := Parts[High(Parts)];
  Cur := FData;

  for I := 0 to High(Parts) - 1 do
  begin
    V := Cur.Values[Parts[I]];
    if V is TJSONObject then
      Cur := TJSONObject(V)
    else if (V = nil) and CreateMissing then
    begin
      Child := TJSONObject.Create;
      Cur.AddPair(Parts[I], Child);
      Cur := Child;
    end
    else
    begin
      // Path doesn't exist
      Exit(nil);
    end;
  end;

  Result := Cur;
end;

procedure TAppSettingsImpl.DoChange;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
  if FAutoSave then
    SaveToFile;
end;

procedure TAppSettingsImpl.LoadFromFile;
var
  S: string;
  JSONVal: TJSONValue;
begin
  FData.Free;
  FData := TJSONObject.Create;

  if TFile.Exists(FFilePath) then
  begin
    S := TFile.ReadAllText(FFilePath, TEncoding.UTF8);
    JSONVal := TJSONObject.ParseJSONValue(S);
    try
      if Assigned(JSONVal) and (JSONVal is TJSONObject) then
      begin
        FData.Free;
        FData := TJSONObject(JSONVal);
        JSONVal := nil; // Ownership transferred
      end;
    finally
      JSONVal.Free;
    end;
  end;
end;

procedure TAppSettingsImpl.SaveToFile;
var
  S: string;
  Dir: string;
begin
  Dir := ExtractFilePath(FFilePath);
  if (Dir <> '') and not TDirectory.Exists(Dir) then
    TDirectory.CreateDirectory(Dir);

  S := FData.Format(2); // Pretty print with 2-space indentation
  TFile.WriteAllText(FFilePath, S, TEncoding.UTF8);
end;

procedure TAppSettingsImpl.Clear;
begin
  FData.Free;
  FData := TJSONObject.Create;
  DoChange;
end;

function TAppSettingsImpl.HasKey(const AKey: string): Boolean;
var
  L: string;
  P: TJSONObject;
begin
  P := FindParentObject(AKey, False, L);
  if Assigned(P) then
    Result := Assigned(P.Values[L])
  else
    Result := Assigned(FData.Values[AKey]);
end;

procedure TAppSettingsImpl.RemoveKey(const AKey: string);
var
  L: string;
  P: TJSONObject;
begin
  P := FindParentObject(AKey, False, L);
  if Assigned(P) then
    P.RemovePair(L)
  else
    FData.RemovePair(AKey);
  DoChange;
end;

function TAppSettingsImpl.Keys: TArray<string>;
var
  L: TList<string>;

  procedure CollectKeys(Obj: TJSONObject; const Prefix: string);
  var
    J: Integer;
    Name: string;
    V: TJSONValue;
    NewPrefix: string;
  begin
    for J := 0 to Obj.Count - 1 do
    begin
      Name := Obj.Pairs[J].JsonString.Value;
      V := Obj.Pairs[J].JsonValue;

      if Prefix = '' then
        NewPrefix := Name
      else
        NewPrefix := Prefix + '.' + Name;

      if V is TJSONObject then
        CollectKeys(TJSONObject(V), NewPrefix)
      else
        L.Add(NewPrefix);
    end;
  end;

begin
  L := TList<string>.Create;
  try
    CollectKeys(FData, '');
    Result := L.ToArray;
  finally
    L.Free;
  end;
end;

procedure TAppSettingsImpl.SetValue(const AKey: string; const AValue: string);
var
  Leaf: string;
  Parent: TJSONObject;
begin
  Parent := FindParentObject(AKey, True, Leaf);
  if Assigned(Parent) then
  begin
    Parent.RemovePair(Leaf);
    Parent.AddPair(Leaf, TJSONString.Create(AValue));
    DoChange;
  end;
end;

procedure TAppSettingsImpl.SetValue(const AKey: string; AValue: Integer);
var
  Leaf: string;
  Parent: TJSONObject;
begin
  Parent := FindParentObject(AKey, True, Leaf);
  if Assigned(Parent) then
  begin
    Parent.RemovePair(Leaf);
    Parent.AddPair(Leaf, TJSONNumber.Create(AValue));
    DoChange;
  end;
end;

procedure TAppSettingsImpl.SetValue(const AKey: string; AValue: Double);
var
  Leaf: string;
  Parent: TJSONObject;
begin
  Parent := FindParentObject(AKey, True, Leaf);
  if Assigned(Parent) then
  begin
    Parent.RemovePair(Leaf);
    Parent.AddPair(Leaf, TJSONNumber.Create(AValue));
    DoChange;
  end;
end;

procedure TAppSettingsImpl.SetValue(const AKey: string; AValue: Boolean);
var
  Leaf: string;
  Parent: TJSONObject;
begin
  Parent := FindParentObject(AKey, True, Leaf);
  if Assigned(Parent) then
  begin
    Parent.RemovePair(Leaf);
    if AValue then
      Parent.AddPair(Leaf, TJSONTrue.Create)
    else
      Parent.AddPair(Leaf, TJSONFalse.Create);
    DoChange;
  end;
end;

function TAppSettingsImpl.GetValue<T>(const AKey: string; const ADefault: T): T;
var
  PType: PTypeInfo;
  V: TJSONValue;
  tmp: TValue;
  s: string;
  i: Integer;
  d: Double;
  b: Boolean;
  Leaf: string;
  Parent: TJSONObject;
begin
  PType := TypeInfo(T);
  Parent := FindParentObject(AKey, False, Leaf);

  if Assigned(Parent) then
    V := Parent.Values[Leaf]
  else
    V := FData.Values[AKey];

  if not Assigned(V) then
    Exit(ADefault);

  // String type
  if PType = TypeInfo(string) then
  begin
    if V is TJSONString then
      s := TJSONString(V).Value
    else
      s := V.ToString.Replace('"', '');
    tmp := TValue.From<string>(s);
    Exit(tmp.AsType<T>);
  end;

  // Integer type
  if PType = TypeInfo(Integer) then
  begin
    if V is TJSONNumber then
      i := Trunc(TJSONNumber(V).AsDouble)
    else
    begin
      tmp := TValue.From<T>(ADefault);
      i := StrToIntDef(V.Value, tmp.AsType<Integer>);
    end;
    tmp := TValue.From<Integer>(i);
    Exit(tmp.AsType<T>);
  end;

  // Boolean type
  if PType = TypeInfo(Boolean) then
  begin
    if V is TJSONTrue then
      b := True
    else if V is TJSONFalse then
      b := False
    else if SameText(V.Value, 'true') then
      b := True
    else if SameText(V.Value, 'false') then
      b := False
    else
      b := TValue.From<T>(ADefault).AsType<Boolean>;
    tmp := TValue.From<Boolean>(b);
    Exit(tmp.AsType<T>);
  end;

  // Double/Single types
  if (PType = TypeInfo(Double)) or (PType = TypeInfo(Single)) then
  begin
    if V is TJSONNumber then
      d := TJSONNumber(V).AsDouble
    else
    begin
      tmp := TValue.From<T>(ADefault);
      d := StrToFloatDef(V.Value, tmp.AsType<Double>);
    end;
    tmp := TValue.From<Double>(d);
    Exit(tmp.AsType<T>);
  end;

  Result := ADefault;
end;

procedure TAppSettingsImpl.SetAutoSave(const Value: Boolean);
begin
  FAutoSave := Value;
  if FAutoSave then
    SaveToFile;
end;

end.
