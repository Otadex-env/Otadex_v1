"use client";

import Form from "next/form";
import { useLang } from "./prefs";

export function SearchForm({ className = "" }: { className?: string }) {
  const en = useLang() === "en";
  const label = en ? "Search a character…" : "Rechercher un personnage…";

  return (
    <Form action="/personnages" className={`search ${className}`} role="search">
      <input type="search" name="q" placeholder={label} aria-label={label} />
      <button type="submit">{en ? "Search" : "Chercher"}</button>
    </Form>
  );
}
