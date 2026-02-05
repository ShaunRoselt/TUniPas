// Afrikaans Language Translations

unit UniPas.LanguageSupport.AF;

interface

uses
  System.SysUtils,
  UniPas.LanguageSupport;

procedure Register_Translations_AF(const ACatalog: TUniPasTranslationCatalog);

implementation

procedure Register_Translations_AF(const ACatalog: TUniPasTranslationCatalog);
begin
  // Add Afrikaans values here, e.g.
  ACatalog.SetValue('af', 'FrmMain.Button1.Text', 'Tuis');
  ACatalog.SetValue('af', 'FrmMain.Button2.Text', 'Hierdie bestaan nie');
  ACatalog.SetValue('af', 'FrmMain.Button3.Text', 'Oor');
  ACatalog.SetValue('af', 'FrmMain.Button4.Text', 'Teken aan');
  ACatalog.SetValue('af', 'FrmMain.Button5.Text', 'Verlaat');
  ACatalog.SetValue('af', 'FrmMain.Button6.Text', 'Instruksies');
  ACatalog.SetValue('af', 'FrmMain.Caption', 'UniPas Starter-projek');

  // Page / Frame translations
  ACatalog.SetValue('af', 'Page_404PageNotFound.Label1.Text', 'Bladsy nie gevind nie');
  ACatalog.SetValue('af', 'Page_Home.btnAboutPage.Text', 'Gaan na Oor-bladsy');
  ACatalog.SetValue('af', 'Page_Home.Label1.Text', 'TUIS');
  ACatalog.SetValue('af', 'Page_Home.btnInstructionsPage.Text', 'Gaan na Instruksies-bladsy');
  ACatalog.SetValue('af', 'Page_About.Label1.Text', 'OOR');
  ACatalog.SetValue('af', 'Page_About.Button1.Text', 'Gaan na Tuisblad');
  ACatalog.SetValue('af', 'Page_Instructions.Button1.Text', 'Gaan na Tuisblad');
  ACatalog.SetValue('af', 'Page_Instructions.Label1.Text', 'INSTRUKSIES');
  ACatalog.SetValue('af', 'FrmMain.RadioButton1.Text', 'Afrikaans');
  ACatalog.SetValue('af', 'FrmMain.RadioButton2.Text', 'Engels');
end;

initialization
  TUniPasTranslations.RegisterTranslations(@Register_Translations_AF);

end.