import Link from "next/link";
import { AppBanner } from "@/components/AppBanner";
import { AnimeGrid, CharacterGrid } from "@/components/Cards";
import { SearchForm } from "@/components/SearchForm";
import { getAnimeCards, getCharacters, toCard } from "@/lib/data";

export default function Home() {
  const animes = getAnimeCards();
  const chars = getCharacters();
  const popular = chars.filter((c) => c.images?.length).slice(0, 12).map(toCard);

  return (
    <>
      <section className="hero">
        <h1>
          Tous tes personnages d&apos;<span>animés</span>, fiche par fiche.
        </h1>
        <p>
          {chars.length} personnages et {animes.length} univers : biographies, pouvoirs, relations, citations et galeries.
        </p>
        <SearchForm />
      </section>

      <div className="sechead">
        <h2>Personnages populaires</h2>
        <Link href="/personnages">Tous les personnages</Link>
      </div>
      <CharacterGrid items={popular} />

      <div className="sechead">
        <h2>Les univers</h2>
        <Link href="/animes">Tous les animés</Link>
      </div>
      <AnimeGrid items={[...animes].sort((a, b) => b.count - a.count).slice(0, 8)} />

      <AppBanner title="Collectionne tes personnages préférés" />
    </>
  );
}
