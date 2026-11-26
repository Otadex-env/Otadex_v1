import { PLAY } from "@/lib/site";

export function AppBanner({ title }: { title: string }) {
  return (
    <aside className="banner">
      <div>
        <h2>{title}</h2>
        <p>Collection personnelle, rangs ninja et favoris : tout se passe dans l&apos;application Android.</p>
      </div>
      <a href={PLAY} target="_blank" rel="noopener">
        Télécharger sur Google Play
      </a>
    </aside>
  );
}
