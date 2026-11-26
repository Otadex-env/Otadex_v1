import { readFileSync } from "node:fs";
import { join } from "node:path";

// Les données viennent de fichiers locaux (data/*.json), générés par
// `npm run sync` (≈ 350 lectures Firestore). Le site ne lit jamais Firestore
// pendant le build ni pour les visiteurs : le quota gratuit est partagé avec
// l'application mobile. Les liens d'images sont recalés par `npm run images`.
function readLocal<T>(file: string): T[] {
  return JSON.parse(readFileSync(join(process.cwd(), "data", file), "utf8")) as T[];
}

export type Anime = {
  id: string;
  titre: string;
  titreJaponais?: string;
  annee?: number;
  statut?: string;
  studio?: string;
  auteur?: string;
  synopsis?: string;
  genres?: string[];
};

export type Relation = { type?: string; nomPersonnage?: string };

export type Character = {
  id: string;
  nom: string;
  nomJaponais?: string;
  animeId: string;
  animeName: string;
  rang?: string;
  description?: string;
  images?: string[];
  popularityRank?: number;
  age?: string;
  sexe?: string;
  statut?: string;
  nationalite?: string;
  dateNaissance?: string;
  voixJaponaise?: string;
  voixAnglaise?: string;
  pouvoirs?: string[];
  citations?: string[];
  trivia?: string[];
  relations?: Relation[];
};

/** Ce qu'une carte affiche (seules données envoyées au navigateur). */
export type Card = {
  id: string;
  nom: string;
  nomJaponais?: string;
  animeId: string;
  animeName: string;
  image?: string;
};

let animes: Anime[] | undefined;
let characters: Character[] | undefined;

export function getAnimes(): Anime[] {
  return (animes ??= readLocal<Anime>("animes.json")
    .filter((a) => a.titre)
    .sort((a, b) => a.titre.localeCompare(b.titre, "fr")));
}

/** Triés par popularité (le rang est relatif à chaque animé), puis par nom. */
export function getCharacters(): Character[] {
  return (characters ??= readLocal<Character>("characters.json")
    .filter((c) => c.nom)
    .sort(
      (a, b) =>
        (a.popularityRank ?? 99) - (b.popularityRank ?? 99) || a.nom.localeCompare(b.nom, "fr"),
    ));
}

export function toCard(c: Character): Card {
  return {
    id: c.id,
    nom: c.nom,
    nomJaponais: c.nomJaponais,
    animeId: c.animeId,
    animeName: c.animeName,
    image: c.images?.[0],
  };
}

/** Animés qui ont au moins un personnage, avec leurs trois visuels de couverture. */
export function getAnimeCards() {
  const chars = getCharacters();
  return getAnimes()
    .map((a) => {
      const own = chars.filter((c) => c.animeId === a.id);
      return {
        id: a.id,
        titre: a.titre,
        annee: a.annee,
        genres: a.genres ?? [],
        count: own.length,
        covers: own.flatMap((c) => c.images?.slice(0, 1) ?? []).slice(0, 3),
      };
    })
    .filter((a) => a.count > 0);
}

export type AnimeCardData = ReturnType<typeof getAnimeCards>[number];
