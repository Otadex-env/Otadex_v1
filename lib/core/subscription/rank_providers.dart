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

/// L'utilisateur courant fait-il partie des développeurs déclarés ?
final isDeveloperProvider = Provider<bool>((ref) {
  final profile = ref.watch(userProfileProvider);
  return kDeveloperUids.contains(profile.id) ||
      kDeveloperEmails.contains(profile.email);
});

/// Rang effectivement appliqué à l'affichage ET aux gates de fonctionnalités.
///
/// = rang réel ([storedRankProvider]), SAUF si l'utilisateur est développeur
/// ET qu'un override est actif ([devRankOverrideProvider] non null).
final effectiveRankProvider = Provider<UserRank>((ref) {
  final stored = ref.watch(storedRankProvider);
  final override = ref.watch(devRankOverrideProvider);
  final isDeveloper = ref.watch(isDeveloperProvider);
  return (isDeveloper && override != null) ? override : stored;
});

/// `true` quand l'affichage est simulé (mode développeur actif) :
/// le rang effectif diffère du rang réel en base.
final isRankOverriddenProvider = Provider<bool>((ref) {
  return ref.watch(effectiveRankProvider) != ref.watch(storedRankProvider);
});
