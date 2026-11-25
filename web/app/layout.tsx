import type { Metadata } from "next";
import Link from "next/link";
import "./globals.css";

const PLAY = "https://play.google.com/store/apps/details?id=com.otadex.otadex";

export const metadata: Metadata = {
  title: { default: "OTADEX — L'encyclopédie d'animés", template: "%s · OTADEX" },
  description:
    "Explore les personnages et les animés d'OTADEX : fiches complètes, pouvoirs, citations, galerie. Même base que l'application mobile.",
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="fr">
      <body>
        <header className="nav">
          <div className="wrap">
            <Link href="/" className="brand">
              OTA<b>DEX</b>
            </Link>
            <a className="cta" href={PLAY} target="_blank" rel="noopener">
              Télécharger l&apos;app
            </a>
          </div>
        </header>
        <main className="wrap">{children}</main>
        <footer>© OTADEX — Prototype du catalogue web, données en direct depuis l&apos;app.</footer>
      </body>
    </html>
  );
}
