unit uMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts,

  UniPas;

type
  TFrmMain = class(TForm)
    UniPasContainer: TLayout;
    Layout1: TLayout;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button1: TButton;
    Button5: TButton;
    Button6: TButton;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Switch1: TSwitch;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure Switch1Click(Sender: TObject);
  private
    procedure ApplyLanguageChoice(const ALanguage: string);
    procedure SaveLanguageChoice(const ALanguage: string);
  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;

implementation

{$R *.fmx}

procedure TFrmMain.ApplyLanguageChoice(const ALanguage: string);
var
  SelectedLanguage: string;
begin
  SelectedLanguage := ALanguage.Trim.ToLower;
  if not SameText(SelectedLanguage, 'af') then
    SelectedLanguage := 'en';

  RadioButton1.IsChecked := SameText(SelectedLanguage, 'af');
  RadioButton2.IsChecked := SameText(SelectedLanguage, 'en');
  TUniPas.Lang.SetLanguage(SelectedLanguage);
end;

procedure TFrmMain.Button1Click(Sender: TObject);
begin
  TUniPas.Routing.RenderPage('Home');
end;

procedure TFrmMain.Button2Click(Sender: TObject);
begin
  TUniPas.Routing.RenderPage('Hierdie bestaan nie');
end;

procedure TFrmMain.Button3Click(Sender: TObject);
begin
  TUniPas.Routing.RenderPage('About');
end;

procedure TFrmMain.Button4Click(Sender: TObject);
begin
  TUniPas.Routing.RenderPage('Login');
end;

procedure TFrmMain.Button5Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TFrmMain.Button6Click(Sender: TObject);
begin
  TUniPas.Routing.RenderPage('Instructions');
end;

procedure TFrmMain.FormCreate(Sender: TObject);
begin
  // Configure app info
  TUniPas.AppName := 'UniPas Demo';
  TUniPas.AppVersion := '0.1.0.0 Beta';

  // Configure routing
  TUniPas.Routing.SetDefaultContainerControl(UniPasContainer);
  Switch1.IsChecked := TUniPas.Routing.FreeFramesOnNavigate;
  Switch1Click(Switch1);

  // Load settings (creates file if doesn't exist)
  TUniPas.Settings.LoadFromFile;

  // Configure language from persisted settings
  ApplyLanguageChoice(TUniPas.Settings.GetString('App.Language', 'en'));
  TUniPas.Settings.SetValue('App.Language', TUniPas.Lang.CurrentLanguage);

  // Navigate to home page
  TUniPas.Routing.RenderPage('Home');

  {$IFDEF DEBUG}
    // Generates an English Translation file in the same folder as your EXE
    TUniPas.Lang.GenerateEnglishTranslationFile();
  {$ENDIF}
end;

procedure TFrmMain.RadioButton1Click(Sender: TObject);
begin
  // Switch Language to Afrikaans
  SaveLanguageChoice('af');
end;

procedure TFrmMain.RadioButton2Click(Sender: TObject);
begin
  // Switch Language to English
  SaveLanguageChoice('en');
end;

procedure TFrmMain.SaveLanguageChoice(const ALanguage: string);
begin
  ApplyLanguageChoice(ALanguage);
  TUniPas.Settings.SetValue('App.Language', TUniPas.Lang.CurrentLanguage);
end;

procedure TFrmMain.Switch1Click(Sender: TObject);
begin
  TUniPas.Routing.FreeFramesOnNavigate := TSwitch(Sender).IsChecked;

  if TUniPas.Routing.FreeFramesOnNavigate then
    Label1.Text := 'Free Frames'
  else
    Label1.Text := 'Don''t Free Frames';
end;

end.
