/**
 * Texte d'interface bilingue : les deux versions sont dans la page, le CSS
 * n'affiche que la langue choisie (aucun clignotement, pages statiques).
 * Les fiches (biographies, pouvoirs…) ne sont écrites qu'en français.
 */
export function T({ fr, en }: { fr: React.ReactNode; en: React.ReactNode }) {
  return (
    <>
      <span data-l="fr">{fr}</span>
      <span data-l="en">{en}</span>
    </>
  );
}
