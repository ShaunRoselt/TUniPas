unit UniPas.Routing.Pages;

interface

uses
  System.Classes,
  UniPas.uPage_404PageNotFound;

const
  PagesArray: TArray<String> = ['404PageNotFound'];

implementation

initialization
  // Register all page frame classes in one place.
  RegisterClasses([TPage_404PageNotFound]);

end.
