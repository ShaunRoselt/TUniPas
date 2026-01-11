unit UniPas.Routing.Pages;

interface

uses
  System.Classes,
  UniPas.uPage_404PageNotFound,

  uPage_Home,
  uPage_About,
  uPage_Instructions;

const
  PagesArray: TArray<String> = ['404PageNotFound'];

implementation

initialization
  // Register all page frame classes in one place.
  RegisterClasses([TPage_404PageNotFound]);

end.
