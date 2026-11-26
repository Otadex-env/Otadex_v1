import type { Metadata } from "next";
import { Suspense } from "react";
import { CharacterExplorer } from "@/components/CharacterExplorer";
import { getAnimeCards, getCharacters, toCard } from "@/lib/data";

export const metadata: Metadata = {
  title: "Personnages",
  description: "Recherche un personnage d'animé par son nom ou son univers.",
  alternates: { canonical: "/personnages" },
};

export default function CharactersPage() {
  return (
    <>
      <h1 className="title">Personnages</h1>
      <Suspense fallback={<p className="empty">Chargement du catalogue…</p>}>
        <CharacterExplorer
          characters={getCharacters().map(toCard)}
          animes={getAnimeCards().map(({ id, titre }) => ({ id, titre }))}
        />
      </Suspense>
    </>
  );
}
