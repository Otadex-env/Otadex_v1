import { T } from "@/components/T";
import Link from "next/link";
import type { AnimeCardData, Card } from "@/lib/data";

export function CharacterGrid({ items }: { items: Card[] }) {
  return (
    <ul className="grid">
      {items.map((c) => (
        <li key={c.id}>
          <Link href={`/personnage/${c.id}`} className="card">
            <div className="ph">
              {c.image ? (
                <img src={c.image} alt="" loading="lazy" />
              ) : (
                <span className="noimg">{c.nom.charAt(0)}</span>
              )}
            </div>
            <div className="tx">
              <div className="nm">{c.nom}</div>
              <div className="sb">{c.animeName}</div>
            </div>
          </Link>
        </li>
      ))}
    </ul>
  );
}

export function AnimeGrid({ items }: { items: AnimeCardData[] }) {
  return (
    <ul className="animes">
      {items.map((a) => (
        <li key={a.id}>
          <Link href={`/anime/${a.id}`} className="anime">
            <div className="covers">
              {a.covers.map((u) => (
                <img key={u} src={u} alt="" loading="lazy" />
              ))}
            </div>
            <div className="tx">
              <div className="nm">{a.titre}</div>
              <div className="sb">
                {a.count} <T fr="personnages" en="characters" />{a.annee ? ` · ${a.annee}` : ""}
              </div>
            </div>
          </Link>
        </li>
      ))}
    </ul>
  );
}
