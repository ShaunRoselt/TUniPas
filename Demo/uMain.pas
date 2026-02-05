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
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;

implementation

{$R *.fmx}

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

  // Configure language
  TUniPas.Lang.SetLanguage('en');

  // Load settings (creates file if doesn't exist)
  TUniPas.Settings.LoadFromFile;

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
  TUniPas.Lang.SetLanguage('af');
end;

procedure TFrmMain.RadioButton2Click(Sender: TObject);
begin
  // Switch Language to English
  TUniPas.Lang.SetLanguage('en');
end;

end.
