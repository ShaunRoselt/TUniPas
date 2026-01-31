# UniPas
⚠️ IMPORTANT — Work in progress — NOT FOR PRODUCTION

This project is actively under development and is not ready for production use. Do NOT use this library in production systems.

## Overview

UniPas is a small Delphi framework for building single‑page application style apps from one codebase. It targets both FireMonkey (desktop/mobile) and PAS2JS/TMS Web Core (web) and provides a lightweight routing and frame-management layer so you can author UI pages as Delphi frames and switch between them at runtime.

Key goals:
- Keep page UI modular using `TFrame`/`TWebFrame` components.
- Provide simple string-based routing and state (page name, info, querystring).
- Work with both FMX (native) and PAS2JS (web) targets with minimal changes.

## How it works

- Pages: each page is implemented as a Delphi frame class named `TPage_<PageName>` and listed in `PagesArray` (see `Demo/Lib/UniPas/UniPas.Routing.Pages.pas` or the routing unit in the "UniPas Routing Library" folder).
- Container control: the app sets a default container (`TUniPas.SetDefaultContainerControl`) which is where frames are created and parented. The container is usually a `TLayout` or other control placed on the main form.
- Routing: call `TUniPas.RenderPage('PageName', PageInfo)` to navigate. `RenderPage` formats the page name, frees the previous active frame, creates (or shows) the target frame and updates global state (`UniPasPageName`, `UniPasPageInfo`).
- Frame lifetime: the routing unit owns a global `ActiveFrame` reference. The implementation frees the previous frame before creating a new one. This avoids multiple frames stacking in the container.

Internals you may inspect:
- `Lib/UniPas/UniPas.Routing.pas`: Routing and frame lifecycle.
- `Lib/UniPas/UniPas.Routing.Variables.pas`: Shared global variables (container, current page, error log).
- `Lib/UniPas/UniPas.Routing.Pages.pas`: The list of available pages.

## Quick start

1. On your main form set the container control in `FormCreate`:

	TUniPas.SetDefaultContainerControl(UniPasContainer); // UniPasContainer is a TLayout
	TUniPas.RenderPage('Home');

2. Implement pages as frames named `TPage_Home`, `TPage_About`, etc., with unit filenames following the `uPage_<Name>.pas` pattern (for example `uPage_Home.pas` in `Demo/Pages`) and ensure they are registered so `GetClass('TPage_'+PageName)` can find them. The registration list lives in `UniPas.Routing.Pages` (example: `Demo/Lib/UniPas/UniPas.Routing.Pages.pas`).

3. Navigate by calling `TUniPas.RenderPage('PageName')` from buttons or code.

## Supported platforms

- FireMonkey (Windows/macOS/iOS/Android): Frames are `TFrame`.
- PAS2JS / TMS Web Core: Frames are `TWebFrame` (routing adapts to web APIs when compiled with `PAS2JS`).

## Multilanguage support

UniPas includes a simple multilanguage subsystem for translating form and frame text at runtime.

- API: use `TUniPasTranslations.SetLanguage('<lang>')` (for example `TUniPasTranslations.SetLanguage('af')`) to switch languages at runtime.
- Registration: language units call `TUniPasTranslations.RegisterTranslations(...)` in their `initialization` section to populate the translation catalog.
- Translation files: language units use `ACatalog.SetValue('<lang>', '<Key>', '<Value>')` entries. Keys follow the pattern `Root.Component.Property` (e.g. `FrmMain.Button1.Text` or `Page_Home.Label1.Text`).
- Generator: call `TUniPasTranslations.GenerateEnglishTranslationFile()` to scan forms and registered pages/frames and emit an English `.pas` translation unit (which auto-registers on initialization).

The subsystem is intentionally small and defensive: generated English files are overwritten on generation, and translations are applied to frames immediately after they are created so dynamic pages update correctly.
