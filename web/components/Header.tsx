"use client";

// Même barre que l'accueil (public/index.html) : liens, ordre, recherche et
// bouton doivent rester identiques des deux côtés.
import Link from "next/link";
import { usePathname } from "next/navigation";
import { useEffect, useState } from "react";
import { NEWSLETTER_FORM, PLAY } from "@/lib/site";
import { SearchForm } from "./SearchForm";
import { T } from "./T";

const LINKS = [
  { href: "/catalogue", label: "Catalogue", en: "Catalogue" },
  { href: "/animes", label: "Animés", en: "Anime", detail: "/anime" },
  { href: "/personnages", label: "Personnages", en: "Characters", detail: "/personnage" },
  { href: "/#plans", label: "Plans", en: "Plans", file: true },
  ...(NEWSLETTER_FORM ? [{ href: "/newsletter", label: "Newsletter", en: "Newsletter" }] : []),
];

export function Header() {
  const path = usePathname();
  const [open, setOpen] = useState(false);
  useEffect(() => setOpen(false), [path]);

  return (
    <header className="nav">
      <div className="bar">
        <a href="/" className="brand">
          <img src="/logo.webp" alt="" width={30} height={30} />
          OTADEX
        </a>
        <div className={open ? "menu open" : "menu"} id="menu">
          <nav aria-label="Navigation principale">
            <a href="/"><T fr="Accueil" en="Home" /></a>
            {LINKS.map((l) =>
              "file" in l ? (
                <a key={l.href} href={l.href}><T fr={l.label} en={l.en} /></a>
              ) : (
                <Link
                  key={l.href}
                  href={l.href}
                  aria-current={path === l.href || ("detail" in l && path.startsWith(`${l.detail}/`)) ? "page" : undefined}
                >
                  <T fr={l.label} en={l.en} />
                </Link>
              ),
            )}
          </nav>
          <SearchForm className="small" />
        </div>
        <a className="cta" href={PLAY} target="_blank" rel="noopener">
          <T fr="Télécharger" en="Download" />
        </a>
        <button type="button" className="burger" aria-label="Menu" aria-expanded={open} aria-controls="menu" onClick={() => setOpen(!open)}>
          <span />
          <span />
          <span />
        </button>
      </div>
    </header>
  );
}
