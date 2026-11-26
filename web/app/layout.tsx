import type { Metadata, Viewport } from "next";
import { Nunito_Sans, Rajdhani } from "next/font/google";
import Link from "next/link";
import { SearchForm } from "@/components/SearchForm";
import { CONTACT, LANDING, PLAY, SITE_URL } from "@/lib/site";
import "./globals.css";

// Mêmes polices que la page de l'application (docs/index.html).
const body = Nunito_Sans({ subsets: ["latin", "latin-ext"], variable: "--font-body" });
const display = Rajdhani({ subsets: ["latin", "latin-ext"], weight: ["600", "700"], variable: "--font-display" });

const description =
  "Le catalogue web d'OTADEX : fiches de personnages d'animés, pouvoirs, citations, relations et galeries.";

export const metadata: Metadata = {
  metadataBase: new URL(SITE_URL),
  title: { default: "OTADEX — L'encyclopédie des personnages d'animés", template: "%s · OTADEX" },
  description,
  openGraph: { siteName: "OTADEX", locale: "fr_FR", type: "website", images: ["/og.png"] },
};

export const viewport: Viewport = { themeColor: "#0d0d14" };

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="fr" className={`${body.variable} ${display.variable}`}>
      <body>
        <header className="nav">
          <div className="wrap">
            <Link href="/" className="brand">
              <img src="/logo.webp" alt="" width={30} height={30} />
              OTADEX
            </Link>
            <nav aria-label="Navigation principale">
              <Link href="/animes">Animés</Link>
              <Link href="/personnages">Personnages</Link>
              <a href={LANDING}>L&apos;application</a>
            </nav>
            <SearchForm className="small" />
            <a className="cta" href={PLAY} target="_blank" rel="noopener">
              Télécharger
            </a>
          </div>
        </header>
        <main className="wrap">{children}</main>
        <footer>
          <div className="wrap cols">
            <div>
              <div className="brand">OTADEX</div>
              <p>L&apos;encyclopédie des personnages d&apos;animés, développée par TilStack.</p>
            </div>
            <div>
              <h2>Catalogue</h2>
              <Link href="/animes">Animés</Link>
              <Link href="/personnages">Personnages</Link>
            </div>
            <div>
              <h2>Application</h2>
              <a href={LANDING}>Présentation</a>
              <a href={PLAY} target="_blank" rel="noopener">Google Play</a>
              <a href={`mailto:${CONTACT}`}>{CONTACT}</a>
            </div>
            <div>
              <h2>Légal</h2>
              <a href={`${LANDING}/privacy-policy.html`}>Confidentialité</a>
              <a href={`${LANDING}/terms.html`}>Conditions d&apos;utilisation</a>
            </div>
          </div>
          <p className="wrap legal">
            © 2026 TilStack. Les personnages et les images appartiennent à leurs auteurs et ayants droit respectifs.
          </p>
        </footer>
      </body>
    </html>
  );
}
