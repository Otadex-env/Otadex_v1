/** @type {import("next").NextConfig} */
const nextConfig = {
  // L'ancienne adresse du catalogue renvoie vers le site principal, chemin conservé.
  async redirects() {
    const oldHost = [{ type: "host", value: "otadexcat.tilstack.me" }];
    return [
      // L'application publiée ouvre cette adresse : page sans lien vers les offres.
      { source: "/newsletter", has: oldHost, destination: "https://otadex.tilstack.me/newsletter/app.html", permanent: false },
      {
        source: "/:path*",
        has: [{ type: "host", value: "otadexcat.tilstack.me" }],
        destination: "https://otadex.tilstack.me/:path*",
        permanent: true,
      },
    ];
  },
  // L'accueil est la page de présentation de l'application (public/index.html).
  async rewrites() {
    return { beforeFiles: [{ source: "/", destination: "/index.html" }] };
  },
};
export default nextConfig;
