import Form from "next/form";

export function SearchForm({ className = "" }: { className?: string }) {
  return (
    <Form action="/personnages" className={`search ${className}`} role="search">
      <input type="search" name="q" placeholder="Rechercher un personnage…" aria-label="Rechercher un personnage" />
      <button type="submit">Chercher</button>
    </Form>
  );
}
