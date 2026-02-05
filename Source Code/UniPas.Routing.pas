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
  FMX.Forms,
  FMX.Controls,
  FMX.Types,
  UniPas.Routing.Pages,
  UniPas.Routing.Variables,
  UniPas.LanguageSupport;

type
  TLibFrame = TFrame;
  TLibContainerControl = TControl;

var
  ActiveFrame: TLibFrame;

implementation

end.
