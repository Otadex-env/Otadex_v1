// Recale les liens d'images de data/characters.json sur le contenu réel du dépôt
// public Otadex-env/otadex-assets. Aucune lecture Firestore : `npm run images`.
// - liens absents du dépôt (ou hébergés ailleurs) : retirés
// - personnage sans image valide : images du dossier à son nom, s'il existe
import { readFileSync, writeFileSync } from "node:fs";

const REPO = "Otadex-env/otadex-assets";
const RAW = `https://raw.githubusercontent.com/${REPO}/main/`;
const FILE = new URL("../data/characters.json", import.meta.url);

const res = await fetch(`https://api.github.com/repos/${REPO}/git/trees/main?recursive=1`, {
  headers: { "User-Agent": "catalogue-sync" },
});
if (!res.ok) throw new Error(`GitHub ${res.status}`);
const { tree, truncated } = await res.json();
if (truncated) throw new Error("Liste des fichiers tronquée par GitHub : rien modifié.");

const collator = new Intl.Collator("fr", { numeric: true });
const files = tree
  .filter((e) => e.type === "blob" && /\.(jpe?g|png|webp|gif|avif)$/i.test(e.path))
  .map((e) => e.path)
  .sort(collator.compare);

// chemin normalisé -> chemin exact du dépôt
const byPath = new Map(files.map((f) => [f.normalize("NFC"), f]));
// nom de dossier (= personnage) -> fichiers
const byFolder = new Map();
for (const f of files) {
  const key = f.split("/").at(-2)?.normalize("NFC").toLowerCase();
  if (key) byFolder.set(key, [...(byFolder.get(key) ?? []), f]);
}

const toUrl = (path) => RAW + encodeURI(path);
const resolve = (url) => {
  if (!url?.startsWith(RAW)) return undefined;
  let path = url.slice(RAW.length);
  try {
    path = decodeURI(path);
  } catch {}
  const real = byPath.get(path.normalize("NFC"));
  return real && toUrl(real);
};

const chars = JSON.parse(readFileSync(FILE, "utf8"));
const without = [];
for (const c of chars) {
  const listed = [...(c.images ?? []), c.imagePath].map(resolve).filter(Boolean);
  let images = [...new Set(listed)];
  if (!images.length) images = (byFolder.get(c.nom.normalize("NFC").toLowerCase()) ?? []).map(toUrl);
  if (!images.length) without.push(c.id);
  c.images = images;
  c.imagePath = images[0] ?? "";
}
writeFileSync(FILE, JSON.stringify(chars));
console.log(`${chars.length} personnages, ${without.length} sans image : ${without.join(", ")}`);
