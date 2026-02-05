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

var
  App: TUniPas;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  // Create the framework instance
  App := TUniPas.Create;
  App.AppName := 'My Application';
  
  // Attach modules as needed
  App.UseRouting;
  App.UseLanguageSupport;
  App.UseAppSettings;
  
  // Configure routing
  App.Routing.SetDefaultContainerControl(MainContainer);
  App.Routing.RenderPage('Home');
  
  // Configure language
  App.Lang.SetLanguage('en');
  
  // Use app settings
  App.Settings.LoadFromFile;
  App.Settings.SetValue('UI.Theme', 'dark');
  App.Settings.SetValue('User.LastLogin', Now);
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  App.Free;
end;
```

## Modules

### Routing Module

Manages page navigation using Delphi frames.

```pascal
// Attach the routing module
App.UseRouting;

// Set the container control (usually a TLayout)
App.Routing.SetDefaultContainerControl(MainContainer);

// Navigate to pages
App.Routing.RenderPage('Home');
App.Routing.RenderPage('About', 'some extra info');

// Check current page
if App.Routing.CurrentPageName = 'Home' then
  // ...

// Handle page changes
App.Routing.OnPageChanged := procedure(Sender: TObject)
begin
  UpdateStatusBar;
end;
```

**Page Setup:**
- Implement pages as frames named `TPage_<PageName>` (e.g., `TPage_Home`, `TPage_About`)
- Register pages in `UniPas.Routing.Pages.pas`
- Pages are auto-managed by the framework

### Language Support Module

Provides runtime translation of UI components.

```pascal
// Attach the language support module
App.UseLanguageSupport;

// Set the current language
App.Lang.SetLanguage('en');  // English
App.Lang.SetLanguage('af');  // Afrikaans

// Handle language changes
App.Lang.OnLanguageChanged := procedure(Sender: TObject)
begin
  RefreshUI;
end;

// Generate translation template
App.Lang.GenerateEnglishTranslationFile;
```

**Translation Setup:**
- Create language units (e.g., `UniPas.LanguageSupport.EN.pas`)
- Use `ACatalog.SetValue('en', 'Page_Home.Label1.Text', 'Hello')` pattern
- Translations auto-apply when pages are rendered

### App Settings Module

JSON-based configuration with auto-save support.

```pascal
// Attach the settings module (optional custom path)
App.UseAppSettings;  // Default: appsettings.json
// or
App.UseAppSettings('/path/to/config.json');

// Load existing settings
App.Settings.LoadFromFile;

// Set values (supports dotted paths for nesting)
App.Settings.SetValue('AppName', 'My App');           // String
App.Settings.SetValue('WindowWidth', 1024);           // Integer
App.Settings.SetValue('Volume', 0.75);                // Double
App.Settings.SetValue('UI.DarkMode', True);           // Boolean (nested)
App.Settings.SetValue('User.Preferences.Font', 'Arial');  // Deep nesting

// Get values with defaults
var Theme := App.Settings.GetString('UI.Theme', 'light');
var Width := App.Settings.GetInt('WindowWidth', 800);
var Volume := App.Settings.GetFloat('Volume', 1.0);
var DarkMode := App.Settings.GetBool('UI.DarkMode', False);

// Or use generic getter
var Name := App.Settings.GetValue<string>('AppName', 'Default');

// Auto-save is enabled by default
App.Settings.AutoSave := True;  // Saves on every change
App.Settings.AutoSave := False; // Manual save only
App.Settings.SaveToFile;

// Check and remove keys
if App.Settings.HasKey('OldSetting') then
  App.Settings.RemoveKey('OldSetting');

// Get all keys
var AllKeys := App.Settings.Keys;

// Handle changes
App.Settings.OnChange := procedure(Sender: TObject)
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
