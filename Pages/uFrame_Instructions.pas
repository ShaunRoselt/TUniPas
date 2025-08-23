unit uFrame_Instructions;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation;

type
  TFrame_Instructions = class(TFrame)
    Button1: TButton;
    Label1: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frame_Instructions: TFrame_Instructions;

implementation

{$R *.fmx}

uses
  UniPas.Routing;

end.
