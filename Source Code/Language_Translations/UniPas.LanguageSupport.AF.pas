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
  ACatalog.SetValue('af', 'FrmMain.Caption', 'UniPas Starter-projek');
end;

initialization
  TUniPasTranslations.RegisterTranslations(@Register_Translations_AF);

end.