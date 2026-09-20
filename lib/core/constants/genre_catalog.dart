/// Vocabulaire canonique des genres OTADEX (puces de l'Accueil).
///
/// Miroir de `scripts/anime_workflow/genres.js` (source unique côté import) :
/// les deux listes doivent rester identiques. Ce catalogue est FIXE et curaté :
/// un nouvel animé n'ajoute jamais de puce tant qu'un genre n'est pas validé ici.
library;

/// Démographie / format — 1re rangée de puces.
const List<String> kDemographicGenres = [
  'Shōnen',
  'Seinen',
  'Shōjo',
  'Josei',
  'Isekai',
];

/// Genres principaux — 2e rangée de puces.
const List<String> kMainGenres = [
  'Action',
  'Aventure',
  'Arts martiaux',
  'Comédie',
  'Drame',
  'Fantasy',
  'Horreur',
  'Philosophie',
  'Psychologique',
  'Romance',
  'Sport',
  'Stratégie',
  'Surnaturel',
  'Tranche de vie',
];
