import { T } from "@/components/T";
import type { Metadata } from "next";
import { NEWSLETTER_FORM, PLAY } from "@/lib/site";

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
          <T fr={<>La newsletter <em>OTADEX</em></>} en={<>The <em>OTADEX</em> newsletter</>} />
        </h1>
        <p><T fr="Un e-mail par semaine pour découvrir un personnage et ne rien manquer du catalogue." en="One email a week to discover a character and keep up with the catalogue. The newsletter and the form are in French." /></p>
      </section>

      <ul className="list">
        <li><T fr={<><strong>Le personnage de la semaine</strong>, avec le lien vers sa fiche.</>} en={<><strong>Character of the week</strong>, with a link to their sheet.</>} /></li>
        <li><T fr={<><strong>Une anecdote</strong> tirée du catalogue.</>} en={<><strong>A fun fact</strong> from the catalogue.</>} /></li>
        <li><T fr={<><strong>Les nouveautés</strong> : animés et personnages ajoutés.</>} en={<><strong>What's new</strong>: added anime and characters.</>} /></li>
      </ul>

      {NEWSLETTER_FORM ? (
        <>
          <iframe src={NEWSLETTER_FORM} title="Inscription à la newsletter OTADEX" />
          <p className="note">
            <T fr="Le formulaire ne s'affiche pas ?" en="Form not showing?" />{" "}
            <a href={NEWSLETTER_FORM} target="_blank" rel="noopener"><T fr="Ouvre-le dans un nouvel onglet" en="Open it in a new tab" /></a>.
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
        <T fr="Inscription facultative, confirmée par e-mail, et désinscription en un clic." en="Optional, confirmed by email, unsubscribe in one click." />{" "}
        <a href="/privacy-policy.html"><T fr="Politique de confidentialité" en="Privacy policy" /></a>
      </p>
    </div>
  );
}
