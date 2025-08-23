program UniPas_Starter_Project;

uses
  System.StartUpCopy,
  FMX.Forms,
  uMain in 'uMain.pas' {FrmMain},
  uConfig in 'Data\uConfig.pas',
  uFrame_Home in 'Pages\uFrame_Home.pas' {Frame_Home: TFrame},
  UniPas.Routing in 'Lib\UniPas\UniPas.Routing.pas',
  uFrame_About in 'Pages\uFrame_About.pas' {Frame_About: TFrame},
  UniPas.Routing.Pages in 'Lib\UniPas\UniPas.Routing.Pages.pas',
  uFrame_Instructions in 'Pages\uFrame_Instructions.pas' {Frame_Instructions: TFrame},
  UniPas.uFrame_404PageNotFound in 'Lib\UniPas\Pages\UniPas.uFrame_404PageNotFound.pas' {Frame_404PageNotFound: TFrame},
  UniPas.Routing.Variables in 'Lib\UniPas\UniPas.Routing.Variables.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.
