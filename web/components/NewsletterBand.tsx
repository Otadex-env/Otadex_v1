import { T } from "@/components/T";
import Link from "next/link";
import { NEWSLETTER_FORM } from "@/lib/site";

export function NewsletterBand() {
  if (!NEWSLETTER_FORM) return null;
  return (
    <aside className="newsband">
      <div>
        <h2><T fr="La newsletter OTADEX" en="The OTADEX newsletter" /></h2>
        <p><T fr="Chaque semaine : un personnage, une anecdote et les nouveautés." en="Every week: a character, a fun fact and what's new. Written in French." /></p>
      </div>
      <Link href="/newsletter"><T fr="S'inscrire gratuitement" en="Subscribe for free" /></Link>
    </aside>
  );
}
