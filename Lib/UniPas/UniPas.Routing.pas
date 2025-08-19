// Support for TMS WEB Core
// Partial Support for FireMonkey
unit UniPas.Routing;

interface

uses
//  Web,
  System.SysUtils,
  System.StrUtils,
  System.Classes,
  {$IFDEF PAS2JS}
//  JS,
    WEBLib.Controls,
//  jsdelphisystem,
//  WEBLib.WebTools,
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

  UniPas.uFrame_Template,
  UniPas.uFrame_404PageNotFound,

  uFrame_Home,
  UniPas.Routing.Pages,
  UniPas.Routing.Variables;


type
  {$IFDEF PAS2JS}
    TLibFrame = type TWebFrame;
    TLibContainerControl = type TWebCustomControl;
  {$ELSE}
    TLibFrame = type TFrame;
    TLibContainerControl = type TControl;
  {$ENDIF}

  // Convenience record wrapper so callers can write TUniPas.RenderPage(...)
  TUniPas = record
  private
    class function GetOpenPageName: String; static;
    class function GetOpenPageNamePrevious: String; static;
    class function GetOpenPageInfo: String; static;
  class procedure FreeAndNilActiveFrame; static;
    class function FormatPageName(const sPageName: String): String; static;
  public
    class procedure RenderPage(ContainerControl: TLibContainerControl; sPageName: String; sPageInfo: String = ''; sPageTitle: String = ''; sPageQueryString: String = ''; ReplaceState: Boolean = False); static;
    class property OpenPageName: String read GetOpenPageName;
    class property OpenPageNamePrevious: String read GetOpenPageNamePrevious;
    class property OpenPageInfo: String read GetOpenPageInfo;
  end;

var
  // FrameManager: TArray<TLibFrame>;
  ActiveFrame: TLibFrame;

implementation

class procedure TUniPas.FreeAndNilActiveFrame;
var
  AF: TLibFrame;
begin
  // Safely free the ActiveFrame by capturing it, clearing the global,
  // and freeing it queued so caller stack can unwind first.
  if not Assigned(ActiveFrame) then
    Exit;

  AF := ActiveFrame;
  ActiveFrame := nil;

  TThread.Queue(nil, procedure
  begin
    try
      FreeAndNil(AF);
    except
      // swallow exceptions to avoid crashing during cleanup
    end;
  end);
end;

class procedure TUniPas.RenderPage(ContainerControl: TLibContainerControl; sPageName, sPageInfo, sPageTitle, sPageQueryString: String; ReplaceState: Boolean);
  procedure SelectFrame;
    procedure CreateAppFrame(FramePage: TLibFrame; FrameName: String);
    begin
      FramePage.Name := FrameName;
      FramePage.Visible := False;
      FramePage.Parent := ContainerControl;
      {$IFDEF PAS2JS}
        FramePage.Align := TAlign.alClient;
        FramePage.LoadFromForm;
      {$ELSE}
        FramePage.Align := TAlignLayout.Client;
      {$ENDIF}
    end;
  { FormatPageName moved to TUniPas.FormatPageName }
    var
      I: UInt64;
      Visibility, PageFound: Boolean;
      PageArrayItem: String;
      FrameInManager: TLibFrame;
      ControlsCount: UInt64;
  begin
  //  console.log('SelectFrame Before: ' + FrameLayoutName);
    sPageName := TUniPas.FormatPageName(sPageName);
  //  console.log('SelectFrame After: ' + FrameLayoutName);

  TUniPas.FreeAndNilActiveFrame;
    {$IFDEF PAS2JS}
      ContainerControl.ElementHandle.firstElementChild.innerHTML := '';
    {$ENDIF}
    for PageArrayItem in PagesArray do
    begin
      if (PageArrayItem = sPageName) then
      begin
        ActiveFrame := TLibFrame(TBaseFrame_Template(GetClass('TFrame_'+PageArrayItem)).Create(ContainerControl));
        CreateAppFrame(ActiveFrame,'lay'+PageArrayItem);
      end;
    end;

    PageFound := False;
    ControlsCount := 0;
    {$IFDEF PAS2JS}
      ControlsCount := ContainerControl.ControlCount;
    {$ELSE}
      ControlsCount := ContainerControl.ControlsCount;
    {$ENDIF}
    for I := 0 to ControlsCount-1 do // Loop through all tools and hide them
    begin
      Visibility := String(TControl(ContainerControl.Controls[I]).ClassName) = ('TFrame_' + sPageName);
      TControl(ContainerControl.Controls[I]).Visible := Visibility;

      if (Visibility = True) AND (PageFound = False) then
        PageFound := True;
    end;

    if (PageFound = False) then
    begin
      sPageName := '404PageNotFound';
      SelectFrame;
    end;
  end;
begin
  {$IFDEF PAS2JS}
    SetState(ReplaceState, sPageName, sPageQueryString, sPageTitle);
  {$ENDIF}

  // Update global open-page variables here so the routing unit owns page state.
  UniPasPageNamePrevious := UniPasPageName;
  UniPasPageName := sPageName;
  UniPasPageInfo := sPageInfo;

  // If caller passed nil (or the platform supplies a different global),
  // attempt to use the globally-registered container control.
  if (ContainerControl = nil) and Assigned(UniPas.Routing.Variables.UniPasContainerControl) then
    ContainerControl := TLibContainerControl(UniPas.Routing.Variables.UniPasContainerControl);

  // If we still don't have a container control, raise an informative exception
  // rather than allowing an access violation deeper in the frame creation/hiding.
  if not Assigned(ContainerControl) then
    raise Exception.Create('TUniPas.RenderPage: No container control supplied and UniPasContainerControl is not set.');

  SelectFrame;
end;

class function TUniPas.GetOpenPageName: String;
begin
  Result := UniPas.Routing.Variables.UniPasPageName;
end;

class function TUniPas.GetOpenPageNamePrevious: String;
begin
  Result := UniPas.Routing.Variables.UniPasPageNamePrevious;
end;

class function TUniPas.GetOpenPageInfo: String;
begin
  Result := UniPas.Routing.Variables.UniPasPageInfo;
end;

class function TUniPas.FormatPageName(const sPageName: String): String;
var
  aPageName: String;
begin
  Result := sPageName;
  if (Result = '') then
    Result := 'Home'
  else
    for aPageName in PagesArray do
      if (Result.ToLower = aPageName.ToLower) then
        Result := aPageName;

  if (MatchText(Result, PagesArray) = False) then
    Result := '404PageNotFound';
end;

end.
