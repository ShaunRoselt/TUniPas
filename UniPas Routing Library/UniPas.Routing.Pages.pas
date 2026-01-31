unit UniPas.Routing.Pages;

interface

uses
  System.Classes,
  UniPas.uPage_404PageNotFound,
  uPage_Home,
  uPage_Achievements,
  uPage_Game,
  uPage_MatchHistory,
  uPage_Options,
  uPage_Statistics;

const
  PagesArray: TArray<String> = ['404PageNotFound',
                                'Home',
                                'Achievements',
                                'Game',
                                'MatchHistory',
                                'Options',
                                'Statistics'];

implementation

initialization
  // Register all page frame classes in one place.
  RegisterClasses([TPage_404PageNotFound,
                   TPage_Home,
                   TPage_Achievements,
                   TPage_Game,
                   TPage_MatchHistory,
                   TPage_Options,
                   TPage_Statistics
                  ]);

end.
