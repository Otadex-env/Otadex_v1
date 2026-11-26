/** @type {import("next").NextConfig} */
const nextConfig = {
  // L'accueil est la page de présentation de l'application (public/index.html).
  async rewrites() {
    return { beforeFiles: [{ source: "/", destination: "/index.html" }] };
  },
};
export default nextConfig;
