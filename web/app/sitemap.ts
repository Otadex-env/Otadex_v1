import type { MetadataRoute } from "next";
import { getAnimeCards, getCharacters } from "@/lib/data";
import { SITE_URL } from "@/lib/site";

export default function sitemap(): MetadataRoute.Sitemap {
  const paths = [
    "",
    "/catalogue",
    "/newsletter",
    "/privacy-policy.html",
    "/terms.html",
    "/account-deletion.html",
    "/animes",
    "/personnages",
    ...getAnimeCards().map((a) => `/anime/${a.id}`),
    ...getCharacters().map((c) => `/personnage/${c.id}`),
  ];
  return paths.map((p) => ({ url: `${SITE_URL}${p}` }));
}
