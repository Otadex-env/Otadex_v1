import { T } from "@/components/T";
import Link from "next/link";
import { SearchForm } from "@/components/SearchForm";

export default function NotFound() {
  return (
    <section className="hero">
      <h1><T fr={<>Page <em>introuvable</em></>} en={<>Page <em>not found</em></>} /></h1>
      <p>
        <T fr="Cette fiche n'existe pas ou a changé d'adresse. Cherche un personnage ci-dessous." en="This page doesn't exist or has moved. Search for a character below." />{" "}
        <a href="/"><T fr="Retour à l'accueil" en="Back to home" /></a>
      </p>
      <SearchForm />
    </section>
  );
}
