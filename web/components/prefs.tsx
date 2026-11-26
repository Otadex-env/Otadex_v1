"use client";

// Langue et thème : mêmes clés localStorage que l'accueil et les pages légales.
import { useSyncExternalStore } from "react";

type Lang = "fr" | "en";
type Theme = "dark" | "light";

const EVENT = "otadex:prefs";

function subscribe(notify: () => void) {
  window.addEventListener(EVENT, notify);
  return () => window.removeEventListener(EVENT, notify);
}

function set(attr: "lang" | "theme", value: string) {
  const root = document.documentElement;
  root.dataset[attr] = value;
  if (attr === "lang") root.lang = value;
  localStorage.setItem(`otadex_${attr}`, value);
  window.dispatchEvent(new Event(EVENT));
}

export function useLang(): Lang {
  return useSyncExternalStore(
    subscribe,
    () => (document.documentElement.dataset.lang === "en" ? "en" : "fr"),
    () => "fr",
  );
}

function useTheme(): Theme {
  return useSyncExternalStore(
    subscribe,
    () => (document.documentElement.dataset.theme === "light" ? "light" : "dark"),
    () => "dark",
  );
}

/** Applique les choix enregistrés avant le premier affichage. */
export const PREFS_SCRIPT = `(function(){try{var d=document.documentElement,l=localStorage.getItem("otadex_lang")==="en"?"en":"fr";d.dataset.lang=l;d.lang=l;d.dataset.theme=localStorage.getItem("otadex_theme")==="light"?"light":"dark"}catch(e){}})()`;

export function Prefs() {
  const lang = useLang();
  const theme = useTheme();

  return (
    <div className="prefs">
      <div className="lang-toggle" role="group" aria-label="Langue / Language">
        {(["fr", "en"] as const).map((l) => (
          <button key={l} type="button" aria-pressed={lang === l} onClick={() => set("lang", l)}>
            {l.toUpperCase()}
          </button>
        ))}
      </div>
      <button
        type="button"
        className="theme-btn"
        aria-label={lang === "en" ? "Toggle theme" : "Changer le thème"}
        onClick={() => set("theme", theme === "dark" ? "light" : "dark")}
      >
        {theme === "dark" ? "🌙" : "☀️"}
      </button>
    </div>
  );
}
