program UniPas_Starter_Project;

uses
  System.StartUpCopy,
  FMX.Forms,
  uMain in 'uMain.pas' {FrmMain},
  uPage_Home in 'Pages\uPage_Home.pas' {Page_Home: TFrame},
  uPage_About in 'Pages\uPage_About.pas' {Page_About: TFrame},
  uPage_Instructions in 'Pages\uPage_Instructions.pas' {Page_Instructions: TFrame},
  UniPas.uPage_404PageNotFound in 'Lib\UniPas\Default_Pages\UniPas.uPage_404PageNotFound.pas' {Page_404PageNotFound: TFrame},
  UniPas.LanguageSupport.AF in 'Lib\UniPas\Language_Translations\UniPas.LanguageSupport.AF.pas',
  UniPas.LanguageSupport.EN in 'Lib\UniPas\Language_Translations\UniPas.LanguageSupport.EN.pas',
  UniPas.AppSettings in '..\Source Code\UniPas.AppSettings.pas',
  UniPas.LanguageSupport in '..\Source Code\UniPas.LanguageSupport.pas',
  UniPas in '..\Source Code\UniPas.pas',
  UniPas.Routing in '..\Source Code\UniPas.Routing.pas',
  UniPas.Routing.Variables in '..\Source Code\UniPas.Routing.Variables.pas',
  UniPas.Routing.Pages in 'Lib\UniPas\UniPas.Routing.Pages.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.
