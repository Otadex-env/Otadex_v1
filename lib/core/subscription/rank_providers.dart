import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';
import '../models/user_rank.dart';
import '../providers/user_profile_provider.dart';

export '../models/user_rank.dart' show UserRank, UserRankX, RankGatesX;

// ─────────────────────────────────────────────────────────────────────────────
// SOURCE DE VÉRITÉ UNIQUE DU RANG
//
//   storedRankProvider     → rang réel de l'utilisateur (Firestore `abonnement`,
//                            copie locale dans prefs `keyUserRank`)
//   devRankOverrideProvider → simulation du menu développeur (mémoire seule)
//   isDeveloperProvider     → l'utilisateur courant est-il un développeur ?
//   effectiveRankProvider   → LE SEUL provider que l'UI doit consommer
//   isRankOverriddenProvider → l'affichage diffère-t-il du rang réel ?
// ─────────────────────────────────────────────────────────────────────────────

/// Rang réel lu depuis le doc Firestore `users/{uid}.abonnement`.
///
/// Concrètement : miroir de la copie locale `prefs.keyUserRank`. Surchargé au
/// démarrage dans `main.dart`, resynchronisé au login et à l'activation de
/// licence. Fallback : [UserRank.genin].
final storedRankProvider = StateProvider<UserRank>((ref) => UserRank.genin);

/// Override du rang piloté par le menu développeur (7 taps sur l'avatar).
///
/// - `null` = aucune simulation en cours.
/// - Persisté dans les prefs (`keyDevRankOverride`) pour survivre aux hot
///   restarts, mais rechargé au démarrage UNIQUEMENT si l'utilisateur est
///   développeur (voir `main.dart`).
/// - N'est JAMAIS écrit dans Firestore et n'influence JAMAIS
///   [storedRankProvider].
class DevRankOverrideNotifier extends StateNotifier<UserRank?> {
  DevRankOverrideNotifier(super.initial);

  /// Applique (ou efface avec `null`) l'override et le persiste.
  Future<void> set(UserRank? rank) async {
    state = rank;
    final prefs = await SharedPreferences.getInstance();
    if (rank == null) {
      await prefs.remove(AppConstants.keyDevRankOverride);
    } else {
      await prefs.setString(AppConstants.keyDevRankOverride, rank.name);
    }
  }
}

final devRankOverrideProvider =
    StateNotifierProvider<DevRankOverrideNotifier, UserRank?>(
  (ref) => DevRankOverrideNotifier(null),
);

// ── Développeurs déclarés ────────────────────────────────────────────────────
// Chargés depuis `.env` (`DEVELOPER_UIDS` / `DEVELOPER_EMAILS`, valeurs séparées
// par des virgules). `.env` est livré en clair dans l'AAB : ce sont des
// identifiants de compte, PAS des secrets. Aucune constante en dur dans le code.

List<String> _envList(String key) {
  if (!dotenv.isInitialized) return const [];
  final raw = dotenv.maybeGet(key) ?? '';
  return raw
      .split(',')
      .map((s) => s.trim())
      .where((s) => s.isNotEmpty)
      .toList(growable: false);
}

List<String> get kDeveloperUids => _envList('DEVELOPER_UIDS');
List<String> get kDeveloperEmails => _envList('DEVELOPER_EMAILS');

/// Une identité (uid OU email) figure-t-elle dans les listes développeur ?
bool isDeveloperIdentity({String? uid, String? email}) =>
    (uid != null && kDeveloperUids.contains(uid)) ||
    (email != null && kDeveloperEmails.contains(email));

/// Garde-fou release : le menu développeur (7 taps) et l'override de rang
/// sont-ils utilisables pour cette identité ?
///
/// - Build debug / profile : toujours (pratique pour tester l'UI).
/// - Build **release** : UNIQUEMENT pour un développeur déclaré. Un utilisateur
///   lambda d'un build Play Store n'a aucun accès — même avec un
///   `keyDevRankOverride` résiduel dans ses prefs.
bool devToolsAllowed({String? uid, String? email}) =>
    !kReleaseMode || isDeveloperIdentity(uid: uid, email: email);

/// L'utilisateur courant fait-il partie des développeurs déclarés ?
final isDeveloperProvider = Provider<bool>((ref) {
  final profile = ref.watch(userProfileProvider);
  return isDeveloperIdentity(uid: profile.id, email: profile.email);
});

/// Les outils développeur sont-ils actifs pour l'utilisateur courant
/// (garde-fou release inclus, cf. [devToolsAllowed]) ?
final devToolsEnabledProvider = Provider<bool>((ref) {
  final profile = ref.watch(userProfileProvider);
  return devToolsAllowed(uid: profile.id, email: profile.email);
});

/// Rang effectivement appliqué à l'affichage ET aux gates de fonctionnalités.
///
/// = rang réel ([storedRankProvider]), SAUF si les outils développeur sont
/// actifs ([devToolsEnabledProvider]) ET qu'un override est en cours
/// ([devRankOverrideProvider] non null).
final effectiveRankProvider = Provider<UserRank>((ref) {
  final stored = ref.watch(storedRankProvider);
  final override = ref.watch(devRankOverrideProvider);
  final devTools = ref.watch(devToolsEnabledProvider);
  return (devTools && override != null) ? override : stored;
});

/// `true` quand l'affichage est simulé (mode développeur actif) :
/// le rang effectif diffère du rang réel en base.
final isRankOverriddenProvider = Provider<bool>((ref) {
  return ref.watch(effectiveRankProvider) != ref.watch(storedRankProvider);
});
