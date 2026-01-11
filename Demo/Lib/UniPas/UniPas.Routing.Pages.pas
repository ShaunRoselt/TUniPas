unit UniPas.Routing.Pages;

interface

uses
  System.Classes,
  UniPas.uPage_404PageNotFound,

  uPage_Home,
  uPage_About,
  uPage_Instructions;

const
  PagesArray: TArray<String> = ['404PageNotFound',
                                'Home',
                                'About',
                                'Instructions'
                               ];

implementation

initialization
  // Register all page frame classes in one place.
  RegisterClasses([TPage_404PageNotFound, TPage_Home, TPage_About, TPage_Instructions]);

end.
