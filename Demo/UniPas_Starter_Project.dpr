program UniPas_Starter_Project;

uses
  System.StartUpCopy,
  FMX.Forms,
  uMain in 'uMain.pas' {FrmMain},
  uConfig in 'Data\uConfig.pas',
  uPage_Home in 'Pages\uPage_Home.pas' {Page_Home: TFrame},
  UniPas.Routing in 'Lib\UniPas\UniPas.Routing.pas',
  uPage_About in 'Pages\uPage_About.pas' {Page_About: TFrame},
  UniPas.Routing.Pages in 'Lib\UniPas\UniPas.Routing.Pages.pas',
  uPage_Instructions in 'Pages\uPage_Instructions.pas' {Page_Instructions: TFrame},
  UniPas.Routing.Variables in 'Lib\UniPas\UniPas.Routing.Variables.pas',
  UniPas.uPage_404PageNotFound in 'Lib\UniPas\Default_Pages\UniPas.uPage_404PageNotFound.pas' {Page_404PageNotFound: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.
