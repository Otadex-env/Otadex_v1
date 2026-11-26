import { T } from "@/components/T";
import type { Metadata } from "next";
import Link from "next/link";
import { notFound } from "next/navigation";
import { AppBanner } from "@/components/AppBanner";
import { CharacterGrid } from "@/components/Cards";
import { Gallery } from "@/components/Gallery";
import { NewsletterBand } from "@/components/NewsletterBand";
import { getCharacters, toCard } from "@/lib/data";
import { fold } from "@/lib/search";

export const dynamicParams = false;

type Props = { params: Promise<{ id: string }> };

export function generateStaticParams() {
  return getCharacters().map((c) => ({ id: c.id }));
}

export async function generateMetadata({ params }: Props): Promise<Metadata> {
  const { id } = await params;
  const c = getCharacters().find((x) => x.id === id);
  if (!c) return {};
  const title = `${c.nom} — ${c.animeName}`;
  const description = c.description?.slice(0, 155);
  return {
    title,
    description,
    alternates: { canonical: `/personnage/${c.id}` },
    openGraph: { title, description, images: c.images?.length ? [c.images[0]] : ["/og.png"] },
  };
}

export default async function CharacterPage({ params }: Props) {
  const { id } = await params;
  const c = getCharacters().find((x) => x.id === id);
  if (!c) notFound();

  const cast = getCharacters().filter((x) => x.animeId === c.animeId);
  const others = cast.filter((x) => x.id !== c.id).slice(0, 6).map(toCard);
  const find = (name: string) => cast.find((x) => x.id !== c.id && fold(x.nom) === fold(name));
  const relations = (c.relations ?? []).flatMap((r) => (r.nomPersonnage ? [{ ...r, nom: r.nomPersonnage }] : []));
  const images = c.images ?? [];
  const facts = [
    [<T fr="Âge" en="Age" />, c.age],
    [<T fr="Sexe" en="Gender" />, c.sexe],
    [<T fr="Statut" en="Status" />, c.statut],
    [<T fr="Nationalité" en="Nationality" />, c.nationalite],
    [<T fr="Naissance" en="Born" />, c.dateNaissance],
    [<T fr="Voix japonaise" en="Japanese voice" />, c.voixJaponaise],
    [<T fr="Voix anglaise" en="English voice" />, c.voixAnglaise],
  ].filter(([, v]) => v);

  return (
    <>
      <nav className="crumb" aria-label="Fil d'Ariane">
        <Link href="/catalogue">Catalogue</Link> › <Link href={`/anime/${c.animeId}`}>{c.animeName}</Link> › {c.nom}
      </nav>

      <div className="profile">
        <header>
          <h1 className="title">{c.nom}</h1>
          {c.nomJaponais && <p className="jp">{c.nomJaponais}</p>}
          <div className="tags">
            {c.rang && <span className="tag hot">{c.rang}</span>}
            <Link href={`/anime/${c.animeId}`} className="tag">{c.animeName}</Link>
          </div>
        </header>

        <aside>
          <div className="portrait">
            {images[0] ? <img src={images[0]} alt={c.nom} /> : <span className="noimg">{c.nom.charAt(0)}</span>}
          </div>
          {facts.length > 0 && (
            <dl className="facts">
              {facts.map(([k, v], i) => (
                <div key={i}>
                  <dt>{k}</dt>
                  <dd>{v}</dd>
                </div>
              ))}
            </dl>
          )}
        </aside>

        <article>
          {c.description && <p className="bio">{c.description}</p>}

          {images.length > 1 && (
            <section>
              <h2><T fr="Galerie" en="Gallery" /></h2>
              <Gallery images={images} name={c.nom} />
            </section>
          )}

          {!!c.pouvoirs?.length && (
            <section>
              <h2><T fr="Pouvoirs et capacités" en="Powers and abilities" /></h2>
              <ul className="list">{c.pouvoirs.map((p) => <li key={p}>{p}</li>)}</ul>
            </section>
          )}

          {relations.length > 0 && (
            <section>
              <h2><T fr="Relations" en="Relationships" /></h2>
              <ul className="relations">
                {relations.map((r) => {
                  const target = find(r.nom);
                  return (
                    <li key={`${r.nom}-${r.type}`}>
                      {target ? <Link href={`/personnage/${target.id}`}>{r.nom}</Link> : <strong>{r.nom}</strong>}
                      {r.type && <small>{r.type}</small>}
                    </li>
                  );
                })}
              </ul>
            </section>
          )}

          {!!c.citations?.length && (
            <section>
              <h2><T fr="Citations" en="Quotes" /></h2>
              <ul className="list">{c.citations.map((q) => <li key={q}>« {q} »</li>)}</ul>
            </section>
          )}

          {!!c.trivia?.length && (
            <section>
              <h2><T fr="Le savais-tu ?" en="Did you know?" /></h2>
              <ul className="list">{c.trivia.map((t) => <li key={t}>{t}</li>)}</ul>
            </section>
          )}
        </article>
      </div>

      {others.length > 0 && (
        <>
          <div className="sechead">
            <h2><T fr="Aussi dans" en="Also in" /> {c.animeName}</h2>
            <Link href={`/anime/${c.animeId}`}><T fr="Voir les" en="See all" /> {cast.length}</Link>
          </div>
          <CharacterGrid items={others} />
        </>
      )}

      <NewsletterBand />

      <AppBanner title={<T fr={`Ajoute ${c.nom} à ta collection`} en={`Add ${c.nom} to your collection`} />} />
    </>
  );
}
