import type { Metadata } from "next";
import Link from "next/link";
import { notFound } from "next/navigation";
import { byPopularity, getAnime, getAnimes, getCharacters, img } from "@/lib/firestore";

export const revalidate = 3600;

export async function generateStaticParams() {
  return (await getAnimes()).map((a) => ({ id: a.id }));
}

export async function generateMetadata({ params }: { params: Promise<{ id: string }> }): Promise<Metadata> {
  const a = await getAnime((await params).id);
  if (!a) return {};
  return { title: a.titre, description: a.synopsis?.slice(0, 155) };
}

export default async function AnimePage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params;
  const anime = await getAnime(id);
  if (!anime) notFound();
  const chars = (await getCharacters()).filter((c) => c.animeId === id).sort(byPopularity);

  return (
    <>
      <div className="crumb">
        <Link href="/">Accueil</Link> › {anime.titre}
      </div>
      <h1 style={{ fontSize: 40, fontWeight: 900 }}>{anime.titre}</h1>
      {anime.titreJaponais && <p className="jp" style={{ color: "var(--muted)" }}>{anime.titreJaponais}</p>}
      <div className="tags">
        {anime.annee ? <span className="tag">{anime.annee}</span> : null}
        {anime.statut && <span className="tag">{anime.statut}</span>}
        {anime.studio && <span className="tag">{anime.studio}</span>}
        {anime.genres?.map((g) => (
          <span key={g} className="tag hot">{g}</span>
        ))}
      </div>
      {anime.synopsis && <p className="bio">{anime.synopsis}</p>}

      <h2 className="sec">Personnages ({chars.length})</h2>
      <div className="grid">
        {chars.map((c) => (
          <Link key={c.id} href={`/personnage/${c.id}`} className="card">
            <div className="ph">{img(c) && <img src={img(c)} alt={c.nom} loading="lazy" />}</div>
            <div className="tx">
              <div className="nm">{c.nom}</div>
              {c.rang && <div className="sb">{c.rang}</div>}
            </div>
          </Link>
        ))}
      </div>
    </>
  );
}
