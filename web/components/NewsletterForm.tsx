"use client";

import { useState, type FormEvent } from "react";
import { NEWSLETTER_FORM } from "@/lib/site";
import { useLang } from "./prefs";
import { T } from "./T";

/**
 * Formulaire maison : Brevo reçoit l'adresse, envoie l'e-mail de confirmation
 * et tient la liste. Attention, Brevo répond « success » même à une adresse
 * vide : c'est le navigateur qui la vérifie (required + pattern).
 * La page d'accueil (public/index.html) a la même copie en HTML.
 */
export function NewsletterForm() {
  const en = useLang() === "en";
  const [state, setState] = useState<"idle" | "sending" | "done" | "error">("idle");

  async function submit(e: FormEvent<HTMLFormElement>) {
    e.preventDefault();
    const body = new FormData(e.currentTarget);
    setState("sending");
    try {
      const res = await fetch(`${NEWSLETTER_FORM}?isAjax=1`, { method: "POST", body });
      const json = await res.json();
      setState(res.ok && json.success ? "done" : "error");
    } catch {
      setState("error");
    }
  }

  if (state === "done") {
    return (
      <div className="signup done" role="status">
        <h2><T fr="Vérifie tes e-mails" en="Check your inbox" /></h2>
        <p><T fr="Clique sur le lien de confirmation pour terminer ton inscription. Pense à regarder dans les spams." en="Click the confirmation link to finish subscribing. Remember to check your spam folder." /></p>
      </div>
    );
  }

  // Sans JavaScript, l'envoi ouvre la page de Brevo (action + method).
  return (
    <form className="signup" action={NEWSLETTER_FORM} method="post" onSubmit={submit}>
      <label htmlFor="news-email"><T fr="Ton adresse e-mail" en="Your email address" /></label>
      <div className="row">
        <input id="news-email" type="email" name="EMAIL" required pattern="[^@\s]+@[^@\s]+\.[^@\s]+" autoComplete="email" placeholder={en ? "you@example.com" : "toi@exemple.com"} />
        <button type="submit" disabled={state === "sending"}>
          {state === "sending" ? <T fr="Envoi…" en="Sending…" /> : <T fr="S'inscrire" en="Subscribe" />}
        </button>
      </div>
      {/* Piège à robots attendu par Brevo : doit rester vide. */}
      <input className="hp" type="text" name="email_address_check" tabIndex={-1} autoComplete="off" aria-hidden="true" />
      <input type="hidden" name="locale" value="en" />
      {state === "error" && (
        <p className="error" role="alert">
          <T fr="L'inscription n'est pas passée. Réessaie dans un instant." en="That didn't go through. Please try again in a moment." />
        </p>
      )}
    </form>
  );
}
