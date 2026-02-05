program UniPas_Starter_Project;

uses
  System.StartUpCopy,
  FMX.Forms,
  uMain in 'uMain.pas' {FrmMain},
  uPage_Home in 'Pages\uPage_Home.pas' {Page_Home: TFrame},
  uPage_About in 'Pages\uPage_About.pas' {Page_About: TFrame},
  uPage_Instructions in 'Pages\uPage_Instructions.pas' {Page_Instructions: TFrame},
  UniPas.uPage_404PageNotFound in 'Lib\UniPas\Default_Pages\UniPas.uPage_404PageNotFound.pas' {Page_404PageNotFound: TFrame},
  UniPas.AppSettings in 'Lib\UniPas\UniPas.AppSettings.pas',
  UniPas.LanguageSupport in 'Lib\UniPas\UniPas.LanguageSupport.pas',
  UniPas in 'Lib\UniPas\UniPas.pas',
  UniPas.Routing.Pages in 'Lib\UniPas\UniPas.Routing.Pages.pas',
  UniPas.Routing in 'Lib\UniPas\UniPas.Routing.pas',
  UniPas.Routing.Variables in 'Lib\UniPas\UniPas.Routing.Variables.pas',
  UniPas.LanguageSupport.AF in 'Lib\UniPas\Language_Translations\UniPas.LanguageSupport.AF.pas',
  UniPas.LanguageSupport.EN in 'Lib\UniPas\Language_Translations\UniPas.LanguageSupport.EN.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.
