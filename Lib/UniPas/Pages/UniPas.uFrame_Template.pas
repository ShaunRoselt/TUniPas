unit UniPas.uFrame_Template;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls;

type
  TBaseFrame_Template = class of TFrame_Template;
  TFrame_Template = class(TFrame)
  private
    { Private declarations }
    constructor Create(AOwner: TComponent); override;
  public
    { Public declarations }
    PageInfo: String;
    procedure OpenPage(PageName: String; sPageInfo: String = ''; PageTitle: String = ''; PageQueryName: String = '');
  end;

implementation

uses
  UniPas.Routing;

{$R *.fmx}

constructor TFrame_Template.Create(AOwner: TComponent);
begin
  inherited;
  PageInfo := TUniPas.OpenPageInfo;
end;

procedure TFrame_Template.OpenPage(PageName, sPageInfo, PageTitle, PageQueryName: String);
{
  PageName: The name of the page to open. This is the name that is used to identify the page from UniPas.Routing.Pages
  sPageInfo: Additional information that can be sent to the page being opened. e.g. JSON Data
  PageTitle: The title of the page to open. This is the title that will be displayed in the browser tab.
  PageQueryName: The query string to be sent to the page being opened.
}
begin
  {$IFDEF PAS2JS}
   SetState(false, PageName, PageQueryName, PageTitle);
  {$ENDIF}
  // Prefer passing the frame's parent container explicitly so calls from
  // within a frame don't rely on the global variable and avoid nil/AV issues.
  TUniPas.RenderPage(TLibContainerControl(Self.Parent), PageName, sPageInfo, PageTitle, PageQueryName);
end;

initialization
  RegisterClasses([TFrame_Template]);

end.
