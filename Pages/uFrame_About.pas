unit uFrame_About;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, UniPas.uFrame_Template, FMX.Controls.Presentation;

type
  TFrame_About = class(TFrame_Template)
    Label1: TLabel;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frame_About: TFrame_About;

implementation

{$R *.fmx}

procedure TFrame_About.Button1Click(Sender: TObject);
begin
  OpenPage('Home');
end;

initialization
  RegisterClasses([TFrame_About]);

end.
