import { existsSync, readFileSync } from "node:fs";
import { join } from "node:path";

// Les données viennent de fichiers locaux (data/*.json), générés UNE FOIS par
// `npm run sync` (≈ 350 lectures Firestore). Le site ne lit donc jamais
// Firestore pendant le build ni pour les visiteurs : zéro impact sur le quota
// gratuit partagé avec l'application mobile.
function readLocal<T>(file: string): T[] {
  const path = join(process.cwd(), "data", file);
  if (!existsSync(path)) {
    throw new Error(`data/${file} introuvable : lancez d'abord « npm run sync ».`);
  }
  return JSON.parse(readFileSync(path, "utf8")) as T[];
}

function listAll<T>(collection: string): Promise<T[]> {
  return Promise.resolve(readLocal<T>(`${collection}.json`));
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

export type Relation = { type?: string; nomPersonnage?: string; characterId?: string };

export type Character = {
  id: string;
  nom: string;
  nomJaponais?: string;
  animeId: string;
  animeName: string;
  rang?: string;
  description?: string;
  images?: string[];
  imagePath?: string;
  popularityRank?: number;
  likesCount?: number;
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

export async function getAnimes(): Promise<Anime[]> {
  const all = await listAll<Anime>("animes");
  return all.filter((a) => a.titre).sort((a, b) => a.titre.localeCompare(b.titre, "fr"));
}

export async function getCharacters(): Promise<Character[]> {
  const all = await listAll<Character>("characters");
  return all.filter((c) => c.nom);
}

export async function getAnime(id: string) {
  return (await getAnimes()).find((a) => a.id === id);
}

export async function getCharacter(id: string) {
  return (await getCharacters()).find((c) => c.id === id);
}

export function byPopularity(a: Character, b: Character) {
  return (a.popularityRank ?? 99) - (b.popularityRank ?? 99);
}

/** URL d'image utilisable dans <img> (les chemins contiennent espaces/accents). */
export function img(c: Character, i = 0): string | undefined {
  const list = c.images?.length ? c.images : c.imagePath ? [c.imagePath] : [];
  const u = list[i] ?? list[0];
  return u && u.startsWith("http") ? encodeURI(u) : undefined;
}
