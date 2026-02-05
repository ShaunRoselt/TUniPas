{ ============================================================================
  UniPas.Routing (Legacy Unit)
  This unit is kept for internal use by the framework.
  Use TUniPas from UniPas.pas for the main API.
  ============================================================================ }
unit UniPas.Routing;

interface

uses
  System.SysUtils,
  System.StrUtils,
  System.Classes,
  {$IFDEF PAS2JS}
  WEBLib.Controls,
  WEBLib.Forms,
  Vcl.Controls,
  {$ELSE}
  FMX.Forms,
  FMX.Controls,
  FMX.Types,
  {$ENDIF}

  {$IFDEF PAS2JS}
  Lib.Routing.Utilities,
  {$ENDIF}

  UniPas.Routing.Pages,
  UniPas.Routing.Variables,
  UniPas.LanguageSupport;

type
  {$IFDEF PAS2JS}
  TLibFrame = type TWebFrame;
  TLibContainerControl = type TWebCustomControl;
  {$ELSE}
  TLibFrame = type TFrame;
  TLibContainerControl = type TControl;
  {$ENDIF}

var
  ActiveFrame: TLibFrame;

implementation

end.
