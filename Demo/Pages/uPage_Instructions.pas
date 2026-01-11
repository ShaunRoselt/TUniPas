unit uPage_Instructions;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation;

type
  TPage_Instructions = class(TFrame)
    Button1: TButton;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Page_Instructions: TPage_Instructions;

implementation

{$R *.fmx}

uses
  UniPas.Routing;

procedure TPage_Instructions.Button1Click(Sender: TObject);
begin
  TUniPas.RenderPage('Home');
end;

end.
