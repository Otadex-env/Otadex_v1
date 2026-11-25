import type { Metadata } from "next";
import Link from "next/link";
import { notFound } from "next/navigation";
import { getCharacter, getCharacters, img } from "@/lib/firestore";

export const revalidate = 3600;

const PLAY = "https://play.google.com/store/apps/details?id=com.otadex.otadex";

export async function generateStaticParams() {
  return (await getCharacters()).map((c) => ({ id: c.id }));
}

export async function generateMetadata({ params }: { params: Promise<{ id: string }> }): Promise<Metadata> {
  const c = await getCharacter((await params).id);
  if (!c) return {};
  return {
    title: `${c.nom} — ${c.animeName}`,
    description: c.description?.slice(0, 155),
    openGraph: { images: img(c) ? [img(c)!] : [] },
  };
}

export default async function CharacterPage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params;
  const c = await getCharacter(id);
  if (!c) notFound();

  const facts: [string, string | undefined][] = [
    ["Âge", c.age],
    ["Sexe", c.sexe],
    ["Statut", c.statut],
    ["Nationalité", c.nationalite],
    ["Naissance", c.dateNaissance],
    ["Voix (JP)", c.voixJaponaise],
    ["Voix (EN)", c.voixAnglaise],
  ];
  const gallery = (c.images ?? []).slice(1).map((u) => encodeURI(u));

  return (
    <>
      <div className="crumb">
        <Link href="/">Accueil</Link> › <Link href={`/anime/${c.animeId}`}>{c.animeName}</Link> › {c.nom}
      </div>

      <div className="head">
        <div className="big">{img(c) && <img src={img(c)} alt={c.nom} />}</div>
        <div>
          <h1>{c.nom}</h1>
          {c.nomJaponais && <div className="jp">{c.nomJaponais}</div>}
          <div className="tags">
            {c.rang && <span className="tag hot">{c.rang}</span>}
            {c.popularityRank && c.popularityRank < 99 ? (
              <span className="tag">Popularité n°{c.popularityRank}</span>
            ) : null}
            {c.likesCount ? <span className="tag">♥ {c.likesCount}</span> : null}
          </div>
          {c.description && <p className="bio">{c.description}</p>}
          <div className="facts">
            {facts
              .filter(([, v]) => v)
              .map(([k, v]) => (
                <div key={k} className="fact">
                  <small>{k}</small>
                  <b>{v}</b>
                </div>
              ))}
          </div>
        </div>
      </div>

      {gallery.length > 0 && (
        <>
          <h2 className="sec">Galerie</h2>
          <div className="thumbs">
            {gallery.map((u) => (
              <img key={u} src={u} alt={c.nom} loading="lazy" />
            ))}
          </div>
        </>
      )}

      {c.pouvoirs && c.pouvoirs.length > 0 && (
        <>
          <h2 className="sec">Pouvoirs &amp; capacités</h2>
          <ul className="list">{c.pouvoirs.map((p) => <li key={p}>{p}</li>)}</ul>
        </>
      )}

      {c.citations && c.citations.length > 0 && (
        <>
          <h2 className="sec">Citations</h2>
          <ul className="list">{c.citations.map((q) => <li key={q}>« {q} »</li>)}</ul>
        </>
      )}

      {c.trivia && c.trivia.length > 0 && (
        <>
          <h2 className="sec">Le saviez-vous ?</h2>
          <ul className="list">{c.trivia.map((t) => <li key={t}>{t}</li>)}</ul>
        </>
      )}

      <div className="banner">
        <h3>Ajoute {c.nom} à ta collection dans l&apos;app</h3>
        <a href={PLAY} target="_blank" rel="noopener">Télécharger OTADEX</a>
      </div>
    </>
  );
}
