import { T } from "@/components/T";
import { PLAY } from "@/lib/site";

export function AppBanner({ title }: { title: React.ReactNode }) {
  return (
    <aside className="banner">
      <div>
        <h2>{title}</h2>
        <p><T fr="Collection personnelle, rangs ninja et favoris : tout se passe dans l'application Android." en="Your collection, ninja ranks and favourites all live in the Android app." /></p>
      </div>
      <a href={PLAY} target="_blank" rel="noopener">
        <T fr="Télécharger sur Google Play" en="Get it on Google Play" />
      </a>
    </aside>
  );
}
