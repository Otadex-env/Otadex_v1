import Link from "next/link";
import { byPopularity, getAnimes, getCharacters, img } from "@/lib/firestore";

export const revalidate = 3600;

export default async function Home() {
  const [animes, chars] = await Promise.all([getAnimes(), getCharacters()]);
  const top = [...chars].filter((c) => img(c)).sort(byPopularity).slice(0, 12);
  const count = (id: string) => chars.filter((c) => c.animeId === id).length;
  const withChars = animes.filter((a) => count(a.id) > 0);

  return (
    <>
      <section className="hero">
        <h1>
          Toute l&apos;encyclopédie <span>d&apos;animés</span>, aussi sur le web.
        </h1>
        <p>
          {withChars.length} univers et {chars.length} personnages, lus en direct depuis la même
          base que l&apos;application mobile.
        </p>
      </section>

      <h2 className="sec">Personnages populaires</h2>
      <div className="grid">
        {top.map((c) => (
          <Link key={c.id} href={`/personnage/${c.id}`} className="card">
            <div className="ph">
              <img src={img(c)} alt={c.nom} loading="lazy" />
            </div>
            <div className="tx">
              <div className="nm">{c.nom}</div>
              <div className="sb">{c.animeName}</div>
            </div>
          </Link>
        ))}
      </div>

      <h2 className="sec">Tous les animés</h2>
      <div className="animes">
        {withChars.map((a) => (
          <Link key={a.id} href={`/anime/${a.id}`} className="anime">
            <b>{a.titre}</b>
            <small>
              {count(a.id)} personnages{a.annee ? ` · ${a.annee}` : ""}
            </small>
          </Link>
        ))}
      </div>
    </>
  );
}
