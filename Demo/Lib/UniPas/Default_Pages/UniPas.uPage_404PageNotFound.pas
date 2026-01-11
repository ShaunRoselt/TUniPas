unit UniPas.uPage_404PageNotFound;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation;

type
  TPage_404PageNotFound = class(TFrame)
    layFrameContainer: TPanel;
    Label1: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Page_404PageNotFound: TPage_404PageNotFound;

implementation

{$R *.fmx}

uses
  UniPas.Routing;

end.
