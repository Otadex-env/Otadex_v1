// Copie le catalogue public (animes + characters) de Firestore vers data/*.json.
//
// COÛT : une lecture par document, soit ≈ 350 lectures (le plan Spark en offre
// 50 000 / jour, partagées avec l'app). À lancer rarement : après l'ajout d'un
// animé, pas à chaque build. Ne jamais l'appeler dans une boucle ou un build.
import { mkdirSync, writeFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const BASE =
  "https://firestore.googleapis.com/v1/projects/tilqui/databases/(default)/documents";
const OUT = join(dirname(fileURLToPath(import.meta.url)), "..", "data");

function decode(v) {
  if ("stringValue" in v) return v.stringValue;
  if ("integerValue" in v) return Number(v.integerValue);
  if ("doubleValue" in v) return v.doubleValue;
  if ("booleanValue" in v) return v.booleanValue;
  if ("timestampValue" in v) return v.timestampValue;
  if ("nullValue" in v) return null;
  if ("arrayValue" in v) return (v.arrayValue.values ?? []).map(decode);
  if ("mapValue" in v)
    return Object.fromEntries(
      Object.entries(v.mapValue.fields ?? {}).map(([k, x]) => [k, decode(x)]),
    );
  return null;
}

async function fetchCollection(name) {
  const out = [];
  let token = "";
  do {
    const res = await fetch(
      `${BASE}/${name}?pageSize=300${token ? `&pageToken=${token}` : ""}`,
    );
    if (!res.ok) {
      throw new Error(
        `Firestore ${name}: HTTP ${res.status} — ${res.status === 429 ? "quota du jour dépassé, réessayez après la réinitialisation" : "erreur"}`,
      );
    }
    const json = await res.json();
    for (const d of json.documents ?? []) {
      out.push({
        id: d.name.split("/").pop(),
        ...Object.fromEntries(
          Object.entries(d.fields ?? {}).map(([k, v]) => [k, decode(v)]),
        ),
      });
    }
    token = json.nextPageToken ?? "";
  } while (token);
  return out;
}

mkdirSync(OUT, { recursive: true });
for (const name of ["animes", "characters"]) {
  const docs = await fetchCollection(name);
  writeFileSync(join(OUT, `${name}.json`), JSON.stringify(docs));
  console.log(`${name}: ${docs.length} documents`);
}
console.log("Terminé. Lecture unique, ne pas relancer inutilement.");
