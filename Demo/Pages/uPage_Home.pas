unit uPage_Home;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation;

type
  TPage_Home = class(TFrame)
    btnAboutPage: TButton;
    Label1: TLabel;
    btnInstructionsPage: TButton;
    procedure btnAboutPageClick(Sender: TObject);
    procedure btnInstructionsPageClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

uses
  UniPas;

procedure TPage_Home.btnAboutPageClick(Sender: TObject);
begin
  TUniPas.Routing.RenderPage('About');
end;

procedure TPage_Home.btnInstructionsPageClick(Sender: TObject);
begin
  TUniPas.Routing.RenderPage('Instructions');
end;

end.
