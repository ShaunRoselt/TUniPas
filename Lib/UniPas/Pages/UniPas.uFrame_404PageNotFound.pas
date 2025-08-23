unit UniPas.uFrame_404PageNotFound;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation;

type
  TFrame_404PageNotFound = class(TFrame)
    layFrameContainer: TPanel;
    Label1: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frame_404PageNotFound: TFrame_404PageNotFound;

implementation

{$R *.fmx}

uses
  UniPas.Routing;

end.
