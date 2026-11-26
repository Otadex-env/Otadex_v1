import type { Metadata } from "next";
import { LANDING, NEWSLETTER_FORM, PLAY } from "@/lib/site";

export const metadata: Metadata = {
  title: "Newsletter",
  description: "Chaque semaine, un personnage, une anecdote et les nouveautés d'OTADEX dans ta boîte mail.",
  alternates: { canonical: "/newsletter" },
  // Pas d'indexation tant que l'inscription n'est pas ouverte.
  robots: NEWSLETTER_FORM ? undefined : { index: false },
};

export default function NewsletterPage() {
  return (
    <div className="newsletter">
      <section className="hero">
        <h1>
          La newsletter <span>OTADEX</span>
        </h1>
        <p>Un e-mail par semaine pour découvrir un personnage et ne rien manquer du catalogue.</p>
      </section>

      <ul className="list">
        <li><strong>Le personnage de la semaine</strong>, avec le lien vers sa fiche.</li>
        <li><strong>Une anecdote</strong> tirée du catalogue.</li>
        <li><strong>Les nouveautés</strong> : animés et personnages ajoutés.</li>
      </ul>

      {NEWSLETTER_FORM ? (
        <>
          <iframe src={NEWSLETTER_FORM} title="Inscription à la newsletter OTADEX" />
          <p className="note">
            Le formulaire ne s&apos;affiche pas ? <a href={NEWSLETTER_FORM} target="_blank" rel="noopener">Ouvre-le dans un nouvel onglet</a>.
          </p>
        </>
      ) : (
        <div className="soon">
          <h2>Les inscriptions ouvrent bientôt</h2>
          <p>En attendant, retrouve les personnages dans l&apos;application.</p>
          <a href={PLAY} target="_blank" rel="noopener">Télécharger sur Google Play</a>
        </div>
      )}

      <p className="note">
        Inscription facultative, confirmée par e-mail, et désinscription en un clic.{" "}
        <a href={`${LANDING}/privacy-policy.html`}>Politique de confidentialité</a>
      </p>
    </div>
  );
}
