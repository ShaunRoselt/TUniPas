unit UniPas.Routing.Variables;

interface

uses
  System.Classes;

var
  UniPasContainerControl: TObject; // Default Container Control
  UniPasPageName: String; // The name of the current OpenPage Frame
  UniPasPageNamePrevious: String; // The name of the previous OpenPage Frame
  UniPasPageInfo: String; // A global variable that can be used to pass data through to the OpenPage Frame
  UniPasErrorLog: TStrings; // Appended with routing errors

implementation

uses
  System.SysUtils;

initialization
  UniPasErrorLog := TStringList.Create; // The only reason for this existing is because I kept getting errors when very quickly switching between different frames from within frames. It causes a runtime access violation. Still not fixed. I just swollow the exceptions right now.

finalization
  UniPasErrorLog.Free;

end.
