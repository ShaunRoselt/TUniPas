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
end;

initialization
  TUniPasTranslations.RegisterTranslations(@Register_Translations_EN);

end.
