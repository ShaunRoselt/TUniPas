// Auto-generated English translations

unit UniPas.LanguageSupport.EN;

interface

uses
  System.SysUtils,
  UniPas.LanguageSupport;

procedure Register_Translations_EN(const ACatalog: TUniPasTranslationCatalog);

implementation

procedure Register_Translations_EN(const ACatalog: TUniPasTranslationCatalog);
begin
  ACatalog.SetValue('en', 'FrmMain.Caption', 'UniPas Starter Project');
  ACatalog.SetValue('en', 'FrmMain.Button2.Text', 'Hierdie bestaan nie');
  ACatalog.SetValue('en', 'FrmMain.Button3.Text', 'About');
  ACatalog.SetValue('en', 'FrmMain.Button4.Text', 'Login');
  ACatalog.SetValue('en', 'FrmMain.Button1.Text', 'Home');
  ACatalog.SetValue('en', 'FrmMain.Button5.Text', 'Exit');
  ACatalog.SetValue('en', 'FrmMain.Button6.Text', 'Instructions');
  ACatalog.SetValue('en', 'FrmMain.RadioButton1.Text', 'Afrikaans');
  ACatalog.SetValue('en', 'FrmMain.RadioButton2.Text', 'English');
  ACatalog.SetValue('en', 'Page_404PageNotFound.Label1.Text', 'Page Not Found');
  ACatalog.SetValue('en', 'Page_Home.btnAboutPage.Text', 'Go to About Page');
  ACatalog.SetValue('en', 'Page_Home.Label1.Text', 'HOME');
  ACatalog.SetValue('en', 'Page_Home.btnInstructionsPage.Text', 'Go to Instructions Page');
  ACatalog.SetValue('en', 'Page_About.Label1.Text', 'ABOUT');
  ACatalog.SetValue('en', 'Page_About.Button1.Text', 'Go to Home Page');
  ACatalog.SetValue('en', 'Page_Instructions.Button1.Text', 'Go to Home Page');
  ACatalog.SetValue('en', 'Page_Instructions.Label1.Text', 'INSTRUCTIONS');
end;

initialization
  TUniPasTranslations.RegisterTranslations(@Register_Translations_EN);

end.
