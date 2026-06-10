/**
 * google_time_offset.js
 *
 * Preloader Node.js — corrige le décalage d'horloge système pour les JWT Google Admin SDK.
 *
 * Usage :
 *   env NODE_OPTIONS='--require ./scripts/google_time_offset.js' node scripts/import_xxx.js
 *
 * Contexte :
 *   Firebase Admin SDK génère des JWT signés avec iat = Date.now().
 *   Si l'horloge locale est en avance de plus de 60 s sur les serveurs Google,
 *   le token est refusé (UNAUTHENTICATED).  Ce script soustrait 60 s à Date.now()
 *   pour que le JWT soit accepté même avec un léger décalage.
 *
 *   OFFSET_MS = 0 si l'horloge est synchronisée (NTP OK).
 *   Augmenter à 60000 (−1 min) si Google renvoie UNAUTHENTICATED.
 */

'use strict';

const OFFSET_MS = 0; // Ajuster si horloge décalée : ex. -60000

const _Date = Date;

class OffsetDate extends _Date {
  constructor(...args) {
    if (args.length === 0) {
      super(_Date.now() + OFFSET_MS);
    } else {
      super(...args);
    }
  }
  static now() { return _Date.now() + OFFSET_MS; }
}

OffsetDate.UTC   = _Date.UTC;
OffsetDate.parse = _Date.parse;

global.Date = OffsetDate;
