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
