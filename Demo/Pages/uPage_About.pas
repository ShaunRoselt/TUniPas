unit uPage_About;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, FMX.Controls.Presentation;

type
  TPage_About = class(TFrame)
    Label1: TLabel;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Page_About: TPage_About;

implementation

{$R *.fmx}

uses
  UniPas;

procedure TPage_About.Button1Click(Sender: TObject);
begin
  TUniPas.Routing.RenderPage('Home');
end;

end.
