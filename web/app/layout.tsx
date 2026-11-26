import { T } from "@/components/T";
import type { Metadata, Viewport } from "next";
import { Nunito_Sans, Rajdhani } from "next/font/google";
import Link from "next/link";
import { Header } from "@/components/Header";
import { PREFS_SCRIPT, Prefs } from "@/components/prefs";
import { CONTACT, NEWSLETTER_FORM, PLAY, SITE_URL } from "@/lib/site";
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
    <html lang="fr" className={`${body.variable} ${display.variable}`} suppressHydrationWarning>
      <head>
        <script dangerouslySetInnerHTML={{ __html: PREFS_SCRIPT }} />
      </head>
      <body>
        <Header />
        <main className="wrap">{children}</main>
        <footer>
          <div className="wrap cols">
            <div>
              <div className="brand">OTADEX</div>
              <p><T fr="L'encyclopédie des personnages d'animés, développée par TilStack." en="The anime character encyclopedia, built by TilStack." /></p>
            </div>
            <div>
              <h2><T fr="Catalogue" en="Catalogue" /></h2>
              <Link href="/catalogue"><T fr="Accueil du catalogue" en="Catalogue home" /></Link>
              <Link href="/animes"><T fr="Animés" en="Anime" /></Link>
              <Link href="/personnages"><T fr="Personnages" en="Characters" /></Link>
              {NEWSLETTER_FORM && <Link href="/newsletter">Newsletter</Link>}
            </div>
            <div>
              <h2>Application</h2>
              <a href="/"><T fr="Présentation" en="Overview" /></a>
              <a href={PLAY} target="_blank" rel="noopener">Google Play</a>
              <a href={`mailto:${CONTACT}`}>{CONTACT}</a>
            </div>
            <div>
              <h2><T fr="Légal" en="Legal" /></h2>
              <a href="/privacy-policy.html"><T fr="Confidentialité" en="Privacy" /></a>
              <a href="/terms.html"><T fr="Conditions d'utilisation" en="Terms of use" /></a>
            </div>
          </div>
          <p className="wrap legal">
            <T fr="© 2026 TilStack. Les personnages et les images appartiennent à leurs auteurs et ayants droit respectifs." en="© 2026 TilStack. Characters and images belong to their respective authors and rights holders." />
          </p>
        </footer>
        <Prefs />
      </body>
    </html>
  );
}
