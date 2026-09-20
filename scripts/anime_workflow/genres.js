'use strict';

/**
 * Vocabulaire canonique des genres OTADEX + table d'alias.
 *
 * SOURCE UNIQUE, partagée par :
 *   - scripts/setup_anime.js        (parsing du .docx)
 *   - scripts/import_*.js           (import Firestore)
 *   - scripts/normalize_genres.js   (correction de la base existante)
 *
 * Corriger la base sans corriger la source, c'est un bug qui revient au
 * prochain animé : tout genre écrit dans Firestore doit passer par
 * `normalizeGenres()`.
 *
 * Miroir côté app : lib/core/constants/genre_catalog.dart. Les deux listes
 * doivent rester identiques.
 */

// Démographie / format (1re rangée de puces dans l'app).
const DEMOGRAPHICS = ['Shōnen', 'Seinen', 'Shōjo', 'Josei', 'Isekai'];

// Genres principaux (2e rangée de puces).
const GENRES = [
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

const CANONICAL = [...DEMOGRAPHICS, ...GENRES];

/**
 * Clé de comparaison : minuscules, sans diacritiques (ō→o, é→e, ô→o), sans
 * espaces/tirets/ponctuation. "Shōnen", "shônen", "SHONEN", "Slice-of-Life"
 * → "shonen", "shonen", "shonen", "sliceoflife".
 */
function keyOf(raw) {
  return String(raw)
    .normalize('NFD')
    .replace(/[̀-ͯ]/g, '')
    .toLowerCase()
    .replace(/[^a-z0-9]/g, '');
}

// alias (écrit librement, comparé via keyOf) → genre canonique.
// Les 5 premières familles sont celles validées ; le reste couvre les
// équivalents anglais / romanisations courants d'un .docx rédigé à la main.
const ALIAS_SOURCE = {
  // Validés
  Fantaisie: 'Fantasy',
  Drama: 'Drame',
  Shonen: 'Shōnen',
  Shounen: 'Shōnen',
  'Dark Fantasy': 'Fantasy', // sous-genre fondu dans son parent
  'Drame scolaire': 'Drame', // sous-genre fondu dans son parent
  // Démographie
  Shojo: 'Shōjo',
  Shoujo: 'Shōjo',
  // Équivalents anglais
  Adventure: 'Aventure',
  Comedy: 'Comédie',
  Horror: 'Horreur',
  Psychological: 'Psychologique',
  Strategy: 'Stratégie',
  Supernatural: 'Surnaturel',
  Sports: 'Sport',
  'Martial Arts': 'Arts martiaux',
  'Slice of Life': 'Tranche de vie',
  Philosophical: 'Philosophie',
};

const LOOKUP = new Map();
for (const c of CANONICAL) LOOKUP.set(keyOf(c), c);
for (const [alias, canonical] of Object.entries(ALIAS_SOURCE)) {
  if (!CANONICAL.includes(canonical)) {
    throw new Error(`Alias "${alias}" → "${canonical}" : cible hors vocabulaire`);
  }
  LOOKUP.set(keyOf(alias), canonical);
}

/** Genre canonique pour `raw`, ou `null` s'il est inconnu. */
function normalizeGenre(raw) {
  if (raw == null) return null;
  const k = keyOf(raw);
  return k ? LOOKUP.get(k) ?? null : null;
}

/**
 * Normalise une liste de genres : canonise, dédoublonne en gardant l'ordre de
 * première apparition (le 1er genre sert de catégorie principale, cf.
 * ANIME_WORKFLOW.md).
 *
 * @returns {{ genres: string[], unknown: string[] }} `unknown` liste les
 *   valeurs hors vocabulaire (elles ne sont PAS dans `genres`).
 */
function normalizeGenres(list) {
  const genres = [];
  const unknown = [];
  for (const raw of list || []) {
    const canon = normalizeGenre(raw);
    if (canon === null) {
      if (String(raw).trim()) unknown.push(String(raw).trim());
    } else if (!genres.includes(canon)) {
      genres.push(canon);
    }
  }
  return { genres, unknown };
}

/**
 * Comme `normalizeGenres`, mais lève une erreur explicite si une valeur est
 * hors vocabulaire : un import ne doit jamais écrire un genre non validé.
 */
function normalizeGenresStrict(list, context = '') {
  const { genres, unknown } = normalizeGenres(list);
  if (unknown.length > 0) {
    throw new Error(
      `Genre(s) hors vocabulaire${context ? ` (${context})` : ''} : ` +
        `${unknown.map((g) => `"${g}"`).join(', ')}.\n` +
        `    Vocabulaire : ${CANONICAL.join(', ')}.\n` +
        `    → corrige le .docx, ou ajoute un alias / un genre validé dans ` +
        `scripts/anime_workflow/genres.js (et lib/core/constants/genre_catalog.dart).`
    );
  }
  return genres;
}

module.exports = {
  DEMOGRAPHICS,
  GENRES,
  CANONICAL,
  normalizeGenre,
  normalizeGenres,
  normalizeGenresStrict,
};
