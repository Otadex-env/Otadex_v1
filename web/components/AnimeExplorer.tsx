"use client";

import { useState } from "react";
import type { AnimeCardData } from "@/lib/data";
import { fold } from "@/lib/search";
import { AnimeGrid } from "./Cards";

export function AnimeExplorer({ animes }: { animes: AnimeCardData[] }) {
  const [q, setQ] = useState("");
  const [genre, setGenre] = useState("");
  const genres = [...new Set(animes.flatMap((a) => a.genres))].sort((a, b) => a.localeCompare(b, "fr"));
  const results = animes.filter((a) => (!genre || a.genres.includes(genre)) && fold(a.titre).includes(fold(q)));

  return (
    <>
      <div className="filters">
        <input type="search" value={q} onChange={(e) => setQ(e.target.value)} placeholder="Titre de l'animé…" aria-label="Rechercher un animé" />
      </div>
      <div className="chips">
        {["", ...genres].map((g) => (
          <button key={g} type="button" aria-pressed={genre === g} onClick={() => setGenre(g)}>
            {g || "Tous"}
          </button>
        ))}
      </div>
      <p className="count" aria-live="polite">{results.length} animé{results.length > 1 ? "s" : ""}</p>
      {results.length ? <AnimeGrid items={results} /> : <p className="empty">Aucun animé ne correspond.</p>}
    </>
  );
}
