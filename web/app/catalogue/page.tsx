import type { Metadata } from "next";
import Link from "next/link";
import { AppBanner } from "@/components/AppBanner";
import { AnimeGrid, CharacterGrid } from "@/components/Cards";
import { NewsletterBand } from "@/components/NewsletterBand";
import { SearchForm } from "@/components/SearchForm";
import { T } from "@/components/T";
import { getAnimeCards, getCharacters, toCard } from "@/lib/data";

export const metadata: Metadata = {
  title: "Catalogue des personnages",
  alternates: { canonical: "/catalogue" },
};

export default function CataloguePage() {
  const animes = getAnimeCards();
  const chars = getCharacters();
  const popular = chars.filter((c) => c.images?.length).slice(0, 12).map(toCard);

  return (
    <>
      <section className="hero">
        <h1>
          <T fr={<>Tous tes personnages d'<em>animés</em>, fiche par fiche.</>} en={<>All your <em>anime</em> characters, one sheet at a time.</>} />
        </h1>
        <p>
          <T
            fr={`${chars.length} personnages et ${animes.length} univers : biographies, pouvoirs, relations, citations et galeries.`}
            en={`${chars.length} characters from ${animes.length} series: biographies, powers, relationships, quotes and galleries. Character sheets are written in French.`}
          />
        </p>
        <SearchForm />
      </section>

      <div className="sechead">
        <h2><T fr="Personnages populaires" en="Popular characters" /></h2>
        <Link href="/personnages"><T fr="Tous les personnages" en="All characters" /></Link>
      </div>
      <CharacterGrid items={popular} />

      <NewsletterBand />

      <div className="sechead">
        <h2><T fr="Les univers" en="Series" /></h2>
        <Link href="/animes"><T fr="Tous les animés" en="All anime" /></Link>
      </div>
      <AnimeGrid items={[...animes].sort((a, b) => b.count - a.count).slice(0, 8)} />

      <AppBanner title={<T fr="Collectionne tes personnages préférés" en="Collect your favourite characters" />} />
    </>
  );
}
