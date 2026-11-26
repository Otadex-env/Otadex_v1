import Link from "next/link";
import { SearchForm } from "@/components/SearchForm";

export default function NotFound() {
  return (
    <section className="hero">
      <h1>Page <span>introuvable</span></h1>
      <p>
        Cette fiche n&apos;existe pas ou a changé d&apos;adresse. Cherche un personnage ou{" "}
        <Link href="/">reviens à l&apos;accueil</Link>.
      </p>
      <SearchForm />
    </section>
  );
}
