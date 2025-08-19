unit uFrame_Home;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  UniPas.uFrame_Template, FMX.Controls.Presentation;

type
  TFrame_Home = class(TFrame_Template)
    Button1: TButton;
    Label1: TLabel;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

procedure TFrame_Home.Button1Click(Sender: TObject);
begin
  OpenPage('About');
end;

initialization
  RegisterClasses([TFrame_Home]);

end.
