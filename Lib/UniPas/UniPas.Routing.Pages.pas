unit UniPas.Routing.Pages;

interface

uses
  System.Classes,
  UniPas.uFrame_404PageNotFound,

  uFrame_Home,
  uFrame_About,
  uFrame_Instructions;

const
  PagesArray: TArray<String> = ['404PageNotFound',
                                'Home',
                                'About',
                                'Instructions'
                               ];

implementation

initialization
  // Register all page frame classes in one place.
  RegisterClasses([TFrame_404PageNotFound, TFrame_Home, TFrame_About, TFrame_Instructions]);

end.
