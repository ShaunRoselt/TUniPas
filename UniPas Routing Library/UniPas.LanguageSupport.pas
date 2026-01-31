// Simple multi-language support for UniPas
unit UniPas.LanguageSupport;

interface

uses
  System.SysUtils,
  System.Classes,
  System.TypInfo,
  {$IFDEF PAS2JS}
  WEBLib.Forms,
  WEBLib.Controls
  {$ELSE}
  FMX.Forms,
  FMX.Controls,
  System.IOUtils
  {$ENDIF}
  ;

type
  TUniPasTranslationCatalog = class
  private
    FTranslations: TStringList;
    FCurrentLanguage: String;
    class function NormalizeKey(const AValue: String): String; static;
    class function MakeKey(const ALang, AKey: String): String; static;
  public
    constructor Create;
    destructor Destroy; override;
    procedure SetValue(const ALang, AKey, AValue: String);
    function GetValue(const ALang, AKey: String; const ADefault: String = ''): String;
    property CurrentLanguage: String read FCurrentLanguage write FCurrentLanguage;
  end;

  TUniPasTranslationRegisterProc = procedure(const ACatalog: TUniPasTranslationCatalog);

  TUniPasTranslations = class
  private
    class var FCatalog: TUniPasTranslationCatalog;
    class function Catalog: TUniPasTranslationCatalog; static;
    class function GetRootKey(ARoot: TComponent): String; static;
    class function IsStringProp(const PropInfo: PPropInfo): Boolean; static;
    class procedure ApplyTranslationsToComponent(ARoot, AComponent: TComponent); static;
    class procedure CollectTranslationsFromComponent(ARoot, AComponent: TComponent; AList: TStrings); static;
    class function EscapePascalString(const S: String): String; static;
  public
    class procedure RegisterTranslations(const ARegisterProc: TUniPasTranslationRegisterProc); static;
    class procedure SetLanguage(const ALang: String); static;
    class procedure ApplyTranslationsToRoot(ARoot: TComponent); static;
    class procedure ApplyTranslations; static;
    class function GenerateEnglishTranslationFile(const AFileName: String = ''; const AUnitName: String = ''): Boolean; static;
  end;

implementation

uses
  UniPas.Routing.Pages;

const
  TranslatableProperties: array[0..2] of String = ('Text', 'Caption', 'Hint');

{ TTranslationCatalog }

constructor TUniPasTranslationCatalog.Create;
begin
  inherited Create;
  FTranslations := TStringList.Create;
  FTranslations.NameValueSeparator := '=';
  FTranslations.CaseSensitive := True;
  FTranslations.Sorted := False; // must be unsorted to allow value assignments at runtime
  FTranslations.Duplicates := dupIgnore;
end;

destructor TUniPasTranslationCatalog.Destroy;
begin
  FTranslations.Free;
  inherited Destroy;
end;

class function TUniPasTranslationCatalog.NormalizeKey(const AValue: String): String;
begin
  Result := AValue.Trim.ToLower;
end;

class function TUniPasTranslationCatalog.MakeKey(const ALang, AKey: String): String;
begin
  Result := NormalizeKey(ALang) + '|' + NormalizeKey(AKey);
end;

procedure TUniPasTranslationCatalog.SetValue(const ALang, AKey, AValue: String);
var
  PrevSorted: Boolean;
  Key: String;
begin
  Key := MakeKey(ALang, AKey);
  PrevSorted := FTranslations.Sorted;
  if PrevSorted then
    FTranslations.Sorted := False;
  try
    FTranslations.Values[Key] := AValue;
  finally
    if PrevSorted then
      FTranslations.Sorted := True;
  end;
end;

function TUniPasTranslationCatalog.GetValue(const ALang, AKey: String; const ADefault: String): String;
begin
  Result := FTranslations.Values[MakeKey(ALang, AKey)];
  if Result = '' then
    Result := ADefault;
end;

{ TUniPasTranslations }

class function TUniPasTranslations.Catalog: TUniPasTranslationCatalog;
begin
  if not Assigned(FCatalog) then
    FCatalog := TUniPasTranslationCatalog.Create;
  Result := FCatalog;
end;

class procedure TUniPasTranslations.RegisterTranslations(const ARegisterProc: TUniPasTranslationRegisterProc);
begin
  // assume callers may pass nil; guard to avoid AV when invoking nil proc
  if Assigned(ARegisterProc) then
    ARegisterProc(Catalog);
end;

class function TUniPasTranslations.GetRootKey(ARoot: TComponent): String;
begin
  if ARoot = nil then
    Exit('Root');

  // For frames, prefer class name so keys match Page_* (e.g., TPage_Home -> Page_Home)
  if ARoot is TFrame then
  begin
    Result := ARoot.ClassName;
    if (Result <> '') and (Result.Chars[0] = 'T') then
      Result := Copy(Result, 2, MaxInt);
    Exit;
  end;

  if ARoot.Name <> '' then
    Result := ARoot.Name
  else
    Result := ARoot.ClassName;
end;

class function TUniPasTranslations.IsStringProp(const PropInfo: PPropInfo): Boolean;
begin
  Result := Assigned(PropInfo) and (PropInfo.PropType^.Kind in [tkString, tkLString, tkWString, tkUString]);
end;

class procedure TUniPasTranslations.ApplyTranslationsToComponent(ARoot, AComponent: TComponent);
var
  PropName: String;
  PropInfo: PPropInfo;
  RootKey: String;
  Key: String;
  Value: String;
begin
  if (AComponent = nil) or (ARoot = nil) or (AComponent.Name = '') then
    Exit;

  RootKey := GetRootKey(ARoot);
  for PropName in TranslatableProperties do
  begin
    PropInfo := GetPropInfo(AComponent, PropName);
    if IsStringProp(PropInfo) then
    begin
      if AComponent = ARoot then
        Key := RootKey + '.' + PropName
      else
        Key := RootKey + '.' + AComponent.Name + '.' + PropName;

      Value := Catalog.GetValue(Catalog.CurrentLanguage, Key, '');
      if Value <> '' then
        SetStrProp(AComponent, PropInfo, Value);
    end;
  end;
end;

class procedure TUniPasTranslations.CollectTranslationsFromComponent(ARoot, AComponent: TComponent; AList: TStrings);
var
  PropName: String;
  PropInfo: PPropInfo;
  RootKey: String;
  Key: String;
  Value: String;
begin
  if (AComponent = nil) or (ARoot = nil) or (AComponent.Name = '') then
    Exit;

  RootKey := GetRootKey(ARoot);
  for PropName in TranslatableProperties do
  begin
    PropInfo := GetPropInfo(AComponent, PropName);
    if IsStringProp(PropInfo) then
    begin
      Value := GetStrProp(AComponent, PropInfo);
      if Value <> '' then
      begin
        if AComponent = ARoot then
          Key := RootKey + '.' + PropName
        else
          Key := RootKey + '.' + AComponent.Name + '.' + PropName;

        AList.Values[Key] := Value;
      end;
    end;
  end;
end;

class function TUniPasTranslations.EscapePascalString(const S: String): String;
begin
  Result := StringReplace(S, '''', '''''', [rfReplaceAll]);
end;

class procedure TUniPasTranslations.SetLanguage(const ALang: String);
begin
  Catalog.CurrentLanguage := ALang.Trim;
  ApplyTranslations;
end;

class procedure TUniPasTranslations.ApplyTranslationsToRoot(ARoot: TComponent);
var
  J: Integer;
begin
  if not Assigned(ARoot) then
    Exit;

  ApplyTranslationsToComponent(ARoot, ARoot);
  for J := 0 to ARoot.ComponentCount - 1 do
    ApplyTranslationsToComponent(ARoot, ARoot.Components[J]);
end;

class procedure TUniPasTranslations.ApplyTranslations;
var
  I: Integer;
  J: Integer;
  Root: TComponent;
begin
  {$IFDEF PAS2JS}
  for I := 0 to Screen.FormCount - 1 do
  begin
    Root := Screen.Forms[I];
    ApplyTranslationsToComponent(Root, Root);
    for J := 0 to Root.ComponentCount - 1 do
      ApplyTranslationsToComponent(Root, Root.Components[J]);
  end;
  {$ELSE}
  for I := 0 to Screen.FormCount - 1 do
  begin
    Root := Screen.Forms[I];
    ApplyTranslationsToComponent(Root, Root);
    for J := 0 to Root.ComponentCount - 1 do
      ApplyTranslationsToComponent(Root, Root.Components[J]);
  end;

  if Assigned(Application) then
  begin
    for I := 0 to Application.ComponentCount - 1 do
    begin
      Root := Application.Components[I];
      if Root is TFrame then
      begin
        ApplyTranslationsToComponent(Root, Root);
        for J := 0 to Root.ComponentCount - 1 do
          ApplyTranslationsToComponent(Root, Root.Components[J]);
      end;
    end;
  end;
  {$ENDIF}
end;

class function TUniPasTranslations.GenerateEnglishTranslationFile(const AFileName: String; const AUnitName: String): Boolean;
var
    Lines: TStringList;
    Entries: TStringList;
    UnitName: String;
    I: Integer;
    J: Integer;
    Root: TComponent;
  PageName: String;
  PageClass: TComponentClass;
  PageFrame: TFrame;
  TargetFileName: String;
begin
  Result := False;
  {$IFDEF PAS2JS}
  Exit;
  {$ELSE}
  // If caller didn't provide a target filename, we'll choose a sensible
  // default (placed alongside the executable) so callers can simply call
  // GenerateEnglishTranslationFile('') and get an auto-named unit.
  // Note: UnitName is determined below; if neither AUnitName nor AFileName
  // are provided, we default the unit name to 'UniPas.LanguageSupport.EN'.

  Lines := TStringList.Create;
  Entries := TStringList.Create;
  try
    Entries.NameValueSeparator := '=';
    Entries.CaseSensitive := True;
    Entries.Sorted := False; // keep unsorted so we can assign Values[] safely
    Entries.Duplicates := dupIgnore;

    for I := 0 to Screen.FormCount - 1 do
    begin
      Root := Screen.Forms[I];
      CollectTranslationsFromComponent(Root, Root, Entries);
      for J := 0 to Root.ComponentCount - 1 do
        CollectTranslationsFromComponent(Root, Root.Components[J], Entries);
    end;

    // Collect translations from all registered pages/frames
    for PageName in PagesArray do
    begin
      PageClass := TComponentClass(GetClass('TPage_' + PageName));
      if Assigned(PageClass) then
      begin
        PageFrame := TFrame(PageClass.Create(Application));
        try
          CollectTranslationsFromComponent(PageFrame, PageFrame, Entries);
          for J := 0 to PageFrame.ComponentCount - 1 do
            CollectTranslationsFromComponent(PageFrame, PageFrame.Components[J], Entries);
        finally
          PageFrame.Free;
        end;
      end;
    end;

    if Assigned(Application) then
    begin
      for I := 0 to Application.ComponentCount - 1 do
      begin
        Root := Application.Components[I];
        if Root is TFrame then
        begin
          CollectTranslationsFromComponent(Root, Root, Entries);
          for J := 0 to Root.ComponentCount - 1 do
            CollectTranslationsFromComponent(Root, Root.Components[J], Entries);
        end;
      end;
    end;

    // Initialize local filename from the (const) parameter so we can modify it.
    TargetFileName := AFileName.Trim;

    if AUnitName.Trim = '' then
    begin
      if TargetFileName <> '' then
        UnitName := ChangeFileExt(ExtractFileName(TargetFileName), '')
      else
        UnitName := 'UniPas.LanguageSupport.EN';
    end
    else
      UnitName := AUnitName.Trim;

    // If no filename was provided, create one next to the executable
    // using the chosen unit name.
    if TargetFileName = '' then
      TargetFileName := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + UnitName + '.pas';

    Lines.Add('// Auto-generated English translations');
    Lines.Add('');
    Lines.Add('unit ' + UnitName + ';');
    Lines.Add('');
    Lines.Add('interface');
    Lines.Add('');
    Lines.Add('uses');
    Lines.Add('  System.SysUtils,');
    Lines.Add('  UniPas.LanguageSupport;');
    Lines.Add('');
    Lines.Add('procedure Register_Translations_EN(const ACatalog: TUniPasTranslationCatalog);');
    Lines.Add('');
    Lines.Add('implementation');
    Lines.Add('');
    Lines.Add('procedure Register_Translations_EN(const ACatalog: TUniPasTranslationCatalog);');
    Lines.Add('begin');

    for I := 0 to Entries.Count - 1 do
      Lines.Add(Format('  ACatalog.SetValue(''en'', ''%s'', ''%s'');',
        [Entries.Names[I], EscapePascalString(Entries.ValueFromIndex[I])]
      ));

    Lines.Add('end;');
    Lines.Add('');
    Lines.Add('initialization');
    Lines.Add('  TUniPasTranslations.RegisterTranslations(@Register_Translations_EN);');
    Lines.Add('');
    Lines.Add('end.');

    TDirectory.CreateDirectory(ExtractFileDir(TargetFileName));

    // Ensure any previous generated file is removed so the generated unit
    // is always replaced cleanly (prevents stale content between runs).
    if FileExists(TargetFileName) then
      DeleteFile(TargetFileName);

    Lines.SaveToFile(TargetFileName);
    Result := True;
  finally
    Lines.Free;
    Entries.Free;
  end;
  {$ENDIF}
end;

initialization

finalization
  // Free without an Assigned() check; TObject.Free is nil-safe and
  // this ensures the class var is cleared for deterministic teardown.
  TUniPasTranslations.FCatalog.Free;
  TUniPasTranslations.FCatalog := nil;

end.
