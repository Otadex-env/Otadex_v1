'use strict';

/**
 * Convertit un nom de personnage en nom de variable Dart (camelCase).
 *
 * "Izuku Midoriya"  → "izukuMidoriya"
 * "All Might"       → "allMight"
 * "Katsuki Bakugō"  → "katsukiBakugō"
 *
 * Source unique partagée par setup_anime.js et push_images.js
 * pour garantir la cohérence des noms de variables app_assets.dart.
 */
function toVarName(name) {
  return name.charAt(0).toLowerCase() +
    name.slice(1).replace(/\s+(.)/g, (_, l) => l.toUpperCase());
}

module.exports = { toVarName };
