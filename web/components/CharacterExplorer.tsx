"use client";

import { useSearchParams } from "next/navigation";
import { useState } from "react";
import type { Card } from "@/lib/data";
import { fold } from "@/lib/search";
import { CharacterGrid } from "./Cards";

const STEP = 48;

export function CharacterExplorer({ characters, animes }: { characters: Card[]; animes: { id: string; titre: string }[] }) {
  const params = useSearchParams();
  const q = params.get("q") ?? "";
  const anime = params.get("anime") ?? "";
  const sort = params.get("tri") === "nom" ? "nom" : "";
  const [limit, setLimit] = useState(STEP);

  // L'adresse porte les filtres : un résultat peut être partagé ou retrouvé.
  function show(next: URLSearchParams) {
    window.history.replaceState(null, "", next.size ? `?${next}` : window.location.pathname);
    setLimit(STEP);
  }
  function set(key: string, value: string) {
    const next = new URLSearchParams(params.toString());
    if (value) next.set(key, value);
    else next.delete(key);
    show(next);
  }

  const words = fold(q).split(/\s+/).filter(Boolean);
  const results = characters.filter((c) => {
    if (anime && c.animeId !== anime) return false;
    const text = fold(`${c.nom} ${c.nomJaponais ?? ""} ${c.animeName}`);
    return words.every((w) => text.includes(w));
  });
  if (sort) results.sort((a, b) => a.nom.localeCompare(b.nom, "fr"));

  return (
    <>
      <div className="filters">
        <input type="search" value={q} onChange={(e) => set("q", e.target.value)} placeholder="Nom, nom japonais, animé…" aria-label="Rechercher" />
        <select value={anime} onChange={(e) => set("anime", e.target.value)} aria-label="Filtrer par animé">
          <option value="">Tous les animés</option>
          {animes.map((a) => (
            <option key={a.id} value={a.id}>{a.titre}</option>
          ))}
        </select>
        <select value={sort} onChange={(e) => set("tri", e.target.value)} aria-label="Trier">
          <option value="">Les plus populaires</option>
          <option value="nom">De A à Z</option>
        </select>
      </div>

      <p className="count" aria-live="polite">
        {results.length} personnage{results.length > 1 ? "s" : ""}
        {(q || anime) && (
          <button type="button" onClick={() => show(new URLSearchParams())}>
            Effacer les filtres
          </button>
        )}
      </p>

      {results.length ? (
        <CharacterGrid items={results.slice(0, limit)} />
      ) : (
        <p className="empty">Aucun personnage ne correspond. Essaie un autre nom ou un autre animé.</p>
      )}

      {results.length > limit && (
        <button type="button" className="more" onClick={() => setLimit(limit + STEP)}>
          Afficher plus
        </button>
      )}
    </>
  );
}
