{ ============================================================================
  UniPas Framework
  A modular Delphi framework for building FireMonkey applications with:
  - Routing (page/frame navigation)
  - Language Support (multi-language translations)
  - AppSettings (JSON-based configuration)

  Usage:
    // In your main form's OnCreate:
    TUniPas.Routing.SetDefaultContainerControl(UniPasContainer);
    TUniPas.Routing.RenderPage('Home');
    TUniPas.Lang.SetLanguage('en');
    TUniPas.Settings.SetValue('Theme', 'dark');

  No need to create or free - the framework manages itself automatically.
  ============================================================================ }
unit UniPas;

interface

uses
  System.SysUtils,
  System.Classes,
  UniPas.LanguageSupport;

type
  // Forward declarations
  TUniPasRouting = class;
  TUniPasLanguageSupport = class;
  TUniPasAppSettings = class;

  { TUniPas - Main framework class (singleton with class properties) }
  TUniPas = class
  private
    class var FRouting: TUniPasRouting;
    class var FLanguageSupport: TUniPasLanguageSupport;
    class var FAppSettings: TUniPasAppSettings;
    class var FAppName: string;
    class var FAppVersion: string;
    class function GetRouting: TUniPasRouting; static;
    class function GetLang: TUniPasLanguageSupport; static;
    class function GetSettings: TUniPasAppSettings; static;
  public
    // Module accessors (auto-created on first access)
    class property Routing: TUniPasRouting read GetRouting;
    class property Lang: TUniPasLanguageSupport read GetLang;
    class property Settings: TUniPasAppSettings read GetSettings;

    // Application info
    class property AppName: string read FAppName write FAppName;
    class property AppVersion: string read FAppVersion write FAppVersion;
  end;

  { TUniPasRouting - Routing module for page/frame navigation }
  TUniPasRouting = class
  public type
    TRenderPageOptions = record
      ContainerControl: TObject;
      PageName: string;
      PageInfo: string;
      PageTitle: string;
      class operator Initialize(out Dest: TRenderPageOptions);
    end;
  private
    FDefaultContainerControl: TObject;
    FCurrentPageName: string;
    FPreviousPageName: string;
    FCurrentPageInfo: string;
    FActiveFrame: TObject;
    FPendingFreeFrames: TList;
    FOnPageChanged: TNotifyEvent;
    FOnRoutingError: TGetStrProc;
    procedure DoPageChanged;
    procedure ReportError(const AMsg: string);
    function FormatPageName(const APageName: string): string;
    procedure FreeActiveFrame;
    procedure FlushPendingFreeFrames;
  public
    constructor Create;
    destructor Destroy; override;

    procedure RenderPage(const APageName: string; const APageInfo: string = ''; const APageTitle: string = ''); overload;
    procedure RenderPage(AContainerControl: TObject; const APageName: string; const APageInfo: string = ''; const APageTitle: string = ''); overload;
    procedure RenderPage(const AOptions: TRenderPageOptions); overload;
    procedure SetDefaultContainerControl(AControl: TObject);

    property CurrentPageName: string read FCurrentPageName;
    property PreviousPageName: string read FPreviousPageName;
    property CurrentPageInfo: string read FCurrentPageInfo;
    property ActiveFrame: TObject read FActiveFrame;
    property DefaultContainerControl: TObject read FDefaultContainerControl;

    property OnPageChanged: TNotifyEvent read FOnPageChanged write FOnPageChanged;
    property OnRoutingError: TGetStrProc read FOnRoutingError write FOnRoutingError;
  end;

  { TUniPasLanguageSupport - Multi-language translation module }
  TUniPasLanguageSupport = class
  private
    FCurrentLanguage: string;
    FOnLanguageChanged: TNotifyEvent;
    procedure DoLanguageChanged;
  public
    constructor Create;

    procedure SetLanguage(const ALang: string);
    procedure RegisterTranslations(const ARegisterProc: TUniPasTranslationRegisterProc);
    procedure ApplyTranslations; overload;
    procedure ApplyTranslationsToRoot(ARoot: TComponent); overload;
    function Translate(const AKey: string; const ADefault: string = ''): string;
    function GenerateEnglishTranslationFile(const AFileName: string = ''; const AUnitName: string = ''): Boolean;

    property CurrentLanguage: string read FCurrentLanguage;
    property OnLanguageChanged: TNotifyEvent read FOnLanguageChanged write FOnLanguageChanged;
  end;

  { TUniPasAppSettings - JSON-based application settings module }
  TUniPasAppSettings = class
  private
    FSettingsImpl: TObject;
    function GetFilePath: string;
    function GetAutoSave: Boolean;
    procedure SetAutoSave(const AValue: Boolean);
    function GetOnChange: TNotifyEvent;
    procedure SetOnChange(const AValue: TNotifyEvent);
  public
    constructor Create(const AFilePath: string = '');
    destructor Destroy; override;

    procedure LoadFromFile;
    procedure SaveToFile;
    procedure Clear;

    function HasKey(const AKey: string): Boolean;
    procedure RemoveKey(const AKey: string);
    function Keys: TArray<string>;

    // Type-specific setters
    procedure SetValue(const AKey: string; const AValue: string); overload;
    procedure SetValue(const AKey: string; AValue: Integer); overload;
    procedure SetValue(const AKey: string; AValue: Double); overload;
    procedure SetValue(const AKey: string; AValue: Boolean); overload;

    // Generic getter
    function GetValue<T>(const AKey: string; const ADefault: T): T;

    // Shorthand getters
    function GetString(const AKey: string; const ADefault: string = ''): string;
    function GetInt(const AKey: string; const ADefault: Integer = 0): Integer;
    function GetFloat(const AKey: string; const ADefault: Double = 0.0): Double;
    function GetBool(const AKey: string; const ADefault: Boolean = False): Boolean;

    property FilePath: string read GetFilePath;
    property AutoSave: Boolean read GetAutoSave write SetAutoSave;
    property OnChange: TNotifyEvent read GetOnChange write SetOnChange;
  end;

implementation

uses
  System.StrUtils,
  System.Contnrs,
  FMX.Forms,
  FMX.Controls,
  FMX.Types,
  UniPas.AppSettings,
  UniPas.Routing.Pages,
  UniPas.Routing.Variables;

type
  TLibFrame = TFrame;
  TLibContainerControl = TControl;

{ TUniPas }

class function TUniPas.GetRouting: TUniPasRouting;
begin
  if not Assigned(FRouting) then
    FRouting := TUniPasRouting.Create;
  Result := FRouting;
end;

class function TUniPas.GetLang: TUniPasLanguageSupport;
begin
  if not Assigned(FLanguageSupport) then
    FLanguageSupport := TUniPasLanguageSupport.Create;
  Result := FLanguageSupport;
end;

class function TUniPas.GetSettings: TUniPasAppSettings;
begin
  if not Assigned(FAppSettings) then
    FAppSettings := TUniPasAppSettings.Create;
  Result := FAppSettings;
end;

{ TUniPasRouting.TRenderPageOptions }

class operator TUniPasRouting.TRenderPageOptions.Initialize(out Dest: TRenderPageOptions);
begin
  Dest.ContainerControl := nil;
  Dest.PageName := '';
  Dest.PageInfo := '';
  Dest.PageTitle := '';
end;

{ TUniPasRouting }

constructor TUniPasRouting.Create;
begin
  inherited Create;
  FActiveFrame := nil;
  FPendingFreeFrames := TList.Create;
  FDefaultContainerControl := nil;
  FCurrentPageName := '';
  FPreviousPageName := '';
  FCurrentPageInfo := '';
end;

destructor TUniPasRouting.Destroy;
begin
  // Don't free pending frames here - they were created with Application as owner,
  // so Application already freed them during shutdown. Just free the list.
  FPendingFreeFrames.Free;
  FActiveFrame := nil;
  inherited;
end;

procedure TUniPasRouting.DoPageChanged;
begin
  if Assigned(FOnPageChanged) then
    FOnPageChanged(Self);
end;

procedure TUniPasRouting.ReportError(const AMsg: string);
begin
  try
    if Assigned(UniPas.Routing.Variables.UniPasErrorLog) then
      UniPas.Routing.Variables.UniPasErrorLog.Add(FormatDateTime('yyyy-mm-dd hh:nn:ss', Now) + ' - ' + AMsg);

    if Assigned(FOnRoutingError) then
      FOnRoutingError(AMsg);
  except
    // Swallow logging errors
  end;
end;

procedure TUniPasRouting.FreeActiveFrame;
begin
  if not Assigned(FActiveFrame) then
    Exit;

  // Add the frame to the pending free list instead of freeing immediately.
  // This prevents access violations when the user rapidly switches pages
  // while a button click handler is still on the call stack.
  try
    TLibFrame(FActiveFrame).Visible := False;
    TLibFrame(FActiveFrame).Parent := nil;
    TLibFrame(FActiveFrame).Name := '';  // Clear name so new frames can reuse it
  except
  end;

  FPendingFreeFrames.Add(FActiveFrame);
  FActiveFrame := nil;
end;

procedure TUniPasRouting.FlushPendingFreeFrames;
begin
  // Free all pending frames - safe to do at the start of RenderPage
  // because any previous button handlers have completed by now.
  for var I := FPendingFreeFrames.Count - 1 downto 0 do
  begin
    var Frame := TObject(FPendingFreeFrames[I]);
    FPendingFreeFrames.Delete(I);
    try
      Frame.Free;
    except
      // Ignore errors during cleanup
    end;
  end;
end;

function TUniPasRouting.FormatPageName(const APageName: string): string;
begin
  Result := APageName;
  if Result = '' then
    Result := 'Home'
  else
    for var PageNameItem in PagesArray do
      if SameText(Result, PageNameItem) then
        Result := PageNameItem;

  if not MatchText(Result, PagesArray) then
    Result := '404PageNotFound';
end;

procedure TUniPasRouting.RenderPage(const APageName: string; const APageInfo: string; const APageTitle: string);
begin
  var Opts: TRenderPageOptions;
  Opts.PageName := APageName;
  Opts.PageInfo := APageInfo;
  Opts.PageTitle := APageTitle;
  RenderPage(Opts);
end;

procedure TUniPasRouting.RenderPage(AContainerControl: TObject; const APageName: string; const APageInfo: string; const APageTitle: string);
begin
  var Opts: TRenderPageOptions;
  Opts.ContainerControl := AContainerControl;
  Opts.PageName := APageName;
  Opts.PageInfo := APageInfo;
  Opts.PageTitle := APageTitle;
  RenderPage(Opts);
end;

procedure TUniPasRouting.RenderPage(const AOptions: TRenderPageOptions);
begin
  // Free any frames that were pending from previous navigations.
  FlushPendingFreeFrames;

  var ContainerControl := TLibContainerControl(AOptions.ContainerControl);
  if (ContainerControl = nil) and Assigned(FDefaultContainerControl) then
    ContainerControl := TLibContainerControl(FDefaultContainerControl);

  if not Assigned(ContainerControl) then
    raise Exception.Create('TUniPas.Routing.RenderPage: No container control supplied and DefaultContainerControl is not set.');

  // Update state
  FPreviousPageName := FCurrentPageName;
  FCurrentPageName := AOptions.PageName;
  FCurrentPageInfo := AOptions.PageInfo;

  // Also update global variables for backward compatibility
  UniPas.Routing.Variables.UniPasPageNamePrevious := FPreviousPageName;
  UniPas.Routing.Variables.UniPasPageName := FCurrentPageName;
  UniPas.Routing.Variables.UniPasPageInfo := FCurrentPageInfo;

  // Free current active frame
  FreeActiveFrame;

  var FormattedPageName := FormatPageName(AOptions.PageName);

  // Create the new frame
  var CompClass := TComponentClass(GetClass('TPage_' + FormattedPageName));
  if Assigned(CompClass) then
  begin
    try
      FActiveFrame := TLibFrame(CompClass.Create(Application));
      try
        TLibFrame(FActiveFrame).Name := 'lay' + FormattedPageName;
        TLibFrame(FActiveFrame).Visible := False;
        TLibFrame(FActiveFrame).Parent := ContainerControl;
        TLibFrame(FActiveFrame).Align := TAlignLayout.Client;
      except
        on E: Exception do
        begin
          ReportError('CreateAppFrame: ' + E.ClassName + ': ' + E.Message);
          FreeAndNil(FActiveFrame);
        end;
      end;
    except
      on E: Exception do
      begin
        ReportError('CreateFrame: ' + E.ClassName + ': ' + E.Message);
        FActiveFrame := nil;
      end;
    end;
  end;

  // Set visibility
  var PageFound := False;
  var ControlsCount := ContainerControl.ControlsCount;

  for var I := 0 to ControlsCount - 1 do
  begin
    try
      var FrameVisible := TControl(ContainerControl.Controls[I]).ClassName = ('TPage_' + FormattedPageName);
      try
        TControl(ContainerControl.Controls[I]).Visible := FrameVisible;
      except
        on E: Exception do
          ReportError('SetVisible: ' + E.ClassName + ': ' + E.Message);
      end;

      if FrameVisible and not PageFound then
        PageFound := True;
    except
      on E: Exception do
        ReportError('IterateControls: ' + E.ClassName + ': ' + E.Message);
    end;
  end;

  if not PageFound then
  begin
    RenderPage(TObject(ContainerControl), '404PageNotFound', AOptions.PageInfo, AOptions.PageTitle);
    Exit;
  end;

  // Apply translations if language support has been used
  if Assigned(TUniPas.FLanguageSupport) and Assigned(FActiveFrame) then
    TUniPas.Lang.ApplyTranslationsToRoot(TComponent(FActiveFrame));

  DoPageChanged;
end;

procedure TUniPasRouting.SetDefaultContainerControl(AControl: TObject);
begin
  FDefaultContainerControl := AControl;
  UniPas.Routing.Variables.UniPasContainerControl := AControl;
end;

{ TUniPasLanguageSupport }

constructor TUniPasLanguageSupport.Create;
begin
  inherited Create;
  FCurrentLanguage := 'en';
end;

procedure TUniPasLanguageSupport.DoLanguageChanged;
begin
  if Assigned(FOnLanguageChanged) then
    FOnLanguageChanged(Self);
end;

procedure TUniPasLanguageSupport.SetLanguage(const ALang: string);
begin
  FCurrentLanguage := ALang.Trim;
  TUniPasTranslations.SetLanguage(FCurrentLanguage);
  DoLanguageChanged;
end;

procedure TUniPasLanguageSupport.RegisterTranslations(const ARegisterProc: TUniPasTranslationRegisterProc);
begin
  if Assigned(ARegisterProc) then
    TUniPasTranslations.RegisterTranslations(ARegisterProc);
end;

procedure TUniPasLanguageSupport.ApplyTranslations;
begin
  TUniPasTranslations.ApplyTranslations;
end;

procedure TUniPasLanguageSupport.ApplyTranslationsToRoot(ARoot: TComponent);
begin
  TUniPasTranslations.ApplyTranslationsToRoot(ARoot);
end;

function TUniPasLanguageSupport.Translate(const AKey: string; const ADefault: string): string;
begin
  Result := ADefault;
end;

function TUniPasLanguageSupport.GenerateEnglishTranslationFile(const AFileName: string; const AUnitName: string): Boolean;
begin
  Result := TUniPasTranslations.GenerateEnglishTranslationFile(AFileName, AUnitName);
end;

{ TUniPasAppSettings }

constructor TUniPasAppSettings.Create(const AFilePath: string);
begin
  inherited Create;
  FSettingsImpl := TAppSettingsImpl.Create(AFilePath);
end;

destructor TUniPasAppSettings.Destroy;
begin
  FreeAndNil(FSettingsImpl);
  inherited;
end;

function TUniPasAppSettings.GetFilePath: string;
begin
  Result := TAppSettingsImpl(FSettingsImpl).FilePath;
end;

function TUniPasAppSettings.GetAutoSave: Boolean;
begin
  Result := TAppSettingsImpl(FSettingsImpl).AutoSave;
end;

procedure TUniPasAppSettings.SetAutoSave(const AValue: Boolean);
begin
  TAppSettingsImpl(FSettingsImpl).AutoSave := AValue;
end;

function TUniPasAppSettings.GetOnChange: TNotifyEvent;
begin
  Result := TAppSettingsImpl(FSettingsImpl).OnChange;
end;

procedure TUniPasAppSettings.SetOnChange(const AValue: TNotifyEvent);
begin
  TAppSettingsImpl(FSettingsImpl).OnChange := AValue;
end;

procedure TUniPasAppSettings.LoadFromFile;
begin
  TAppSettingsImpl(FSettingsImpl).LoadFromFile;
end;

procedure TUniPasAppSettings.SaveToFile;
begin
  TAppSettingsImpl(FSettingsImpl).SaveToFile;
end;

procedure TUniPasAppSettings.Clear;
begin
  TAppSettingsImpl(FSettingsImpl).Clear;
end;

function TUniPasAppSettings.HasKey(const AKey: string): Boolean;
begin
  Result := TAppSettingsImpl(FSettingsImpl).HasKey(AKey);
end;

procedure TUniPasAppSettings.RemoveKey(const AKey: string);
begin
  TAppSettingsImpl(FSettingsImpl).RemoveKey(AKey);
end;

function TUniPasAppSettings.Keys: TArray<string>;
begin
  Result := TAppSettingsImpl(FSettingsImpl).Keys;
end;

procedure TUniPasAppSettings.SetValue(const AKey: string; const AValue: string);
begin
  TAppSettingsImpl(FSettingsImpl).SetValue(AKey, AValue);
end;

procedure TUniPasAppSettings.SetValue(const AKey: string; AValue: Integer);
begin
  TAppSettingsImpl(FSettingsImpl).SetValue(AKey, AValue);
end;

procedure TUniPasAppSettings.SetValue(const AKey: string; AValue: Double);
begin
  TAppSettingsImpl(FSettingsImpl).SetValue(AKey, AValue);
end;

procedure TUniPasAppSettings.SetValue(const AKey: string; AValue: Boolean);
begin
  TAppSettingsImpl(FSettingsImpl).SetValue(AKey, AValue);
end;

function TUniPasAppSettings.GetValue<T>(const AKey: string; const ADefault: T): T;
begin
  Result := TAppSettingsImpl(FSettingsImpl).GetValue<T>(AKey, ADefault);
end;

function TUniPasAppSettings.GetString(const AKey: string; const ADefault: string): string;
begin
  Result := GetValue<string>(AKey, ADefault);
end;

function TUniPasAppSettings.GetInt(const AKey: string; const ADefault: Integer): Integer;
begin
  Result := GetValue<Integer>(AKey, ADefault);
end;

function TUniPasAppSettings.GetFloat(const AKey: string; const ADefault: Double): Double;
begin
  Result := GetValue<Double>(AKey, ADefault);
end;

function TUniPasAppSettings.GetBool(const AKey: string; const ADefault: Boolean): Boolean;
begin
  Result := GetValue<Boolean>(AKey, ADefault);
end;

initialization

finalization
  TUniPas.FRouting.Free;
  TUniPas.FLanguageSupport.Free;
  TUniPas.FAppSettings.Free;

end.
