# UniPas Framework

⚠️ **IMPORTANT — Work in progress — NOT FOR PRODUCTION**

This project is actively under development and is not ready for production use. Do NOT use this library in production systems.

## Overview

UniPas is a modular Delphi framework for building applications with a unified codebase. It targets both FireMonkey (desktop/mobile) and PAS2JS/TMS Web Core (web) platforms.

### Features

- **Routing** - Page/frame navigation with URL state management
- **Language Support** - Multi-language translations at runtime
- **App Settings** - JSON-based configuration with nested key support

## Quick Start

```pascal
uses
  UniPas;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  // UniPas is a singleton-style framework.
  // No Create/Free needed — modules are created on first access.
  TUniPas.AppName := 'My Application';
  TUniPas.AppVersion := '0.1.0';

  // Configure routing
  TUniPas.Routing.SetDefaultContainerControl(MainContainer);
  TUniPas.Routing.RenderPage('Home');

  // Configure language
  TUniPas.Lang.SetLanguage('en');

  // Use app settings
  TUniPas.Settings.LoadFromFile;
  TUniPas.Settings.SetValue('UI.Theme', 'dark');
end;
```

## Modules

### Routing Module

Manages page navigation using Delphi frames.

```pascal
// Set the container control (usually a TLayout)
TUniPas.Routing.SetDefaultContainerControl(MainContainer);

// Navigate to pages
TUniPas.Routing.RenderPage('Home');
TUniPas.Routing.RenderPage('About', 'some extra info');

// Check current page
if TUniPas.Routing.CurrentPageName = 'Home' then
  // ...

// Handle page changes
TUniPas.Routing.OnPageChanged := procedure(Sender: TObject)
begin
  UpdateStatusBar;
end;

// Optional: handle routing errors
TUniPas.Routing.OnRoutingError := procedure(const Msg: string)
begin
  // log or show the error
end;
```

**Page Setup:**
- Implement pages as frames named `TPage_<PageName>` (e.g., `TPage_Home`, `TPage_About`)
- Register pages in `UniPas.Routing.Pages.pas`
- Pages are auto-managed by the framework

### Language Support Module

Provides runtime translation of UI components.

```pascal
// Set the current language
TUniPas.Lang.SetLanguage('en');  // English
TUniPas.Lang.SetLanguage('af');  // Afrikaans

// Handle language changes
TUniPas.Lang.OnLanguageChanged := procedure(Sender: TObject)
begin
  RefreshUI;
end;

// Generate translation template
TUniPas.Lang.GenerateEnglishTranslationFile;
```

**Translation Setup:**
- Create language units (e.g., `UniPas.LanguageSupport.EN.pas`)
- Use `ACatalog.SetValue('en', 'Page_Home.Label1.Text', 'Hello')` pattern
- Translations auto-apply when pages are rendered

### App Settings Module

JSON-based configuration with auto-save support.

```pascal
// Load existing settings
TUniPas.Settings.LoadFromFile;

// Set values (supports dotted paths for nesting)
TUniPas.Settings.SetValue('AppName', 'My App');           // String
TUniPas.Settings.SetValue('WindowWidth', 1024);           // Integer
TUniPas.Settings.SetValue('Volume', 0.75);                // Double
TUniPas.Settings.SetValue('UI.DarkMode', True);           // Boolean (nested)
TUniPas.Settings.SetValue('User.Preferences.Font', 'Arial');  // Deep nesting

// Get values with defaults
var Theme := TUniPas.Settings.GetString('UI.Theme', 'light');
var Width := TUniPas.Settings.GetInt('WindowWidth', 800);
var Volume := TUniPas.Settings.GetFloat('Volume', 1.0);
var DarkMode := TUniPas.Settings.GetBool('UI.DarkMode', False);

// Or use generic getter
var Name := TUniPas.Settings.GetValue<string>('AppName', 'Default');

// Auto-save is enabled by default
TUniPas.Settings.AutoSave := True;  // Saves on every change
TUniPas.Settings.AutoSave := False; // Manual save only
TUniPas.Settings.SaveToFile;

// Check and remove keys
if TUniPas.Settings.HasKey('OldSetting') then
  TUniPas.Settings.RemoveKey('OldSetting');

// Get all keys
var AllKeys := TUniPas.Settings.Keys;

// Handle changes
TUniPas.Settings.OnChange := procedure(Sender: TObject)
begin
  ApplySettings;
end;
```

**JSON Output Example:**
```json
{
  "AppName": "My App",
  "WindowWidth": 1024,
  "Volume": 0.75,
  "UI": {
    "DarkMode": true,
    "Theme": "dark"
  },
  "User": {
    "Preferences": {
      "Font": "Arial"
    }
  }
}
```

## Supported Platforms

| Platform | Frame Type | Notes |
|----------|-----------|-------|
| FireMonkey (Windows/macOS/iOS/Android) | `TFrame` | Full support |
| PAS2JS / TMS Web Core | `TWebFrame` | Web-specific adaptations |

## File Structure

```
UniPas/
├── Source Code/
│   ├── UniPas.pas                    # Main framework (TUniPas)
│   ├── UniPas.AppSettings.pas        # Settings module
│   ├── UniPas.LanguageSupport.pas    # Translation engine
│   ├── UniPas.Routing.pas            # Internal routing types
│   ├── UniPas.Routing.Pages.pas      # Page registry
│   ├── UniPas.Routing.Variables.pas  # Shared state
│   ├── Default_Pages/                # Built-in pages
│   │   └── UniPas.uPage_404PageNotFound.pas
│   └── Language_Translations/        # Translation files
│       ├── UniPas.LanguageSupport.EN.pas
│       └── UniPas.LanguageSupport.AF.pas
└── Demo/                             # Example application
```

## License

See [LICENSE](LICENSE) file.
