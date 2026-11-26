"use client";

import { useSearchParams } from "next/navigation";
import { useState } from "react";
import type { Card } from "@/lib/data";
import { fold } from "@/lib/search";
import { CharacterGrid } from "./Cards";
import { useLang } from "./prefs";

const STEP = 48;

export function CharacterExplorer({ characters, animes }: { characters: Card[]; animes: { id: string; titre: string }[] }) {
  const en = useLang() === "en";
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
        <input type="search" value={q} onChange={(e) => set("q", e.target.value)} placeholder={en ? "Name, Japanese name, anime…" : "Nom, nom japonais, animé…"} aria-label={en ? "Search" : "Rechercher"} />
        <select value={anime} onChange={(e) => set("anime", e.target.value)} aria-label={en ? "Filter by anime" : "Filtrer par animé"}>
          <option value="">{en ? "All anime" : "Tous les animés"}</option>
          {animes.map((a) => (
            <option key={a.id} value={a.id}>{a.titre}</option>
          ))}
        </select>
        <select value={sort} onChange={(e) => set("tri", e.target.value)} aria-label={en ? "Sort" : "Trier"}>
          <option value="">{en ? "Most popular" : "Les plus populaires"}</option>
          <option value="nom">{en ? "A to Z" : "De A à Z"}</option>
        </select>
      </div>

      <p className="count" aria-live="polite">
        {results.length} {en ? "character" : "personnage"}{results.length > 1 ? "s" : ""}
        {(q || anime) && (
          <button type="button" onClick={() => show(new URLSearchParams())}>
            {en ? "Clear filters" : "Effacer les filtres"}
          </button>
        )}
      </p>

      {results.length ? (
        <CharacterGrid items={results.slice(0, limit)} />
      ) : (
        <p className="empty">{en ? "No character matches. Try another name or anime." : "Aucun personnage ne correspond. Essaie un autre nom ou un autre animé."}</p>
      )}

      {results.length > limit && (
        <button type="button" className="more" onClick={() => setLimit(limit + STEP)}>
          {en ? "Show more" : "Afficher plus"}
        </button>
      )}
    </>
  );
}
