import type { Metadata } from "next";
import { AnimeExplorer } from "@/components/AnimeExplorer";
import { getAnimeCards } from "@/lib/data";

export const metadata: Metadata = {
  title: "Animés",
  description: "Parcours les univers du catalogue OTADEX et filtre-les par genre.",
  alternates: { canonical: "/animes" },
};

export default function AnimesPage() {
  return (
    <>
      <h1 className="title">Animés</h1>
      <AnimeExplorer animes={getAnimeCards()} />
    </>
  );
}
