import { T } from "@/components/T";
import type { Metadata } from "next";
import Link from "next/link";
import { notFound } from "next/navigation";
import { AnimeGrid, CharacterGrid } from "@/components/Cards";
import { getAnimeCards, getAnimes, getCharacters, toCard } from "@/lib/data";

export const dynamicParams = false;

type Props = { params: Promise<{ id: string }> };

export function generateStaticParams() {
  return getAnimes().map((a) => ({ id: a.id }));
}

export async function generateMetadata({ params }: Props): Promise<Metadata> {
  const { id } = await params;
  const a = getAnimes().find((x) => x.id === id);
  if (!a) return {};
  return {
    title: `${a.titre} : tous les personnages`,
    description: a.synopsis?.slice(0, 155),
    alternates: { canonical: `/anime/${a.id}` },
  };
}

export default async function AnimePage({ params }: Props) {
  const { id } = await params;
  const anime = getAnimes().find((a) => a.id === id);
  if (!anime) notFound();
  const chars = getCharacters().filter((c) => c.animeId === id).map(toCard);
  const shared = (g: string[]) => g.filter((x) => anime.genres?.includes(x)).length;
  const similar = getAnimeCards()
    .filter((a) => a.id !== id && shared(a.genres))
    .sort((a, b) => shared(b.genres) - shared(a.genres))
    .slice(0, 4);
  const facts = [
    [<T fr="Année" en="Year" />, anime.annee],
    [<T fr="Statut" en="Status" />, anime.statut],
    ["Studio", anime.studio],
    [<T fr="Auteur" en="Author" />, anime.auteur],
  ].filter(([, v]) => v);

  return (
    <>
      <nav className="crumb" aria-label="Fil d'Ariane">
        <Link href="/catalogue">Catalogue</Link> › <Link href="/animes"><T fr="Animés" en="Anime" /></Link> › {anime.titre}
      </nav>
      <h1 className="title">{anime.titre}</h1>
      {anime.titreJaponais && <p className="jp" lang="ja">{anime.titreJaponais}</p>}
      <div className="tags">
        {anime.genres?.map((g) => <span key={g} className="tag hot">{g}</span>)}
      </div>
      {anime.synopsis && <p className="bio">{anime.synopsis}</p>}
      <dl className="facts row">
        {facts.map(([k, v], i) => (
          <div key={i}>
            <dt>{k}</dt>
            <dd>{v}</dd>
          </div>
        ))}
      </dl>

      <div className="sechead">
        <h2><T fr="Personnages" en="Characters" /> ({chars.length})</h2>
      </div>
      <CharacterGrid items={chars} />

      {similar.length > 0 && (
        <>
          <div className="sechead">
            <h2><T fr="Dans le même genre" en="Similar series" /></h2>
          </div>
          <AnimeGrid items={similar} />
        </>
      )}
    </>
  );
}
