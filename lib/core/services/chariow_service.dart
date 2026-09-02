import '../models/user_rank.dart';

/// Résultat d'une vérification de licence.
class LicenseResult {
  final bool isActive;
  final bool isExpired;
  final DateTime? expiresAt;
  final String? productName;
  final String? errorMessage;

  const LicenseResult({
    required this.isActive,
    required this.isExpired,
    this.expiresAt,
    this.productName,
    this.errorMessage,
  });
}

/// Service d'activation / vérification de licence Chariow.
///
/// ⚠️ NEUTRALISÉ CÔTÉ CLIENT (2026-09).
/// La clé API Chariow (`sk_live_…`) n'a aucun scope : embarquée dans l'APK,
/// elle exposait Store / Sales / Customers / Licenses. Elle a été retirée du
/// client ; plus aucun appel réseau ne part d'ici.
///
/// Comme `kEnablePaidPlans == false`, aucun utilisateur ne peut acquérir de
/// licence : il n'y a rien à activer ni à vérifier côté client. La
/// rétrogradation à l'expiration est gérée hors-ligne par `_checkLicenseExpiry`
/// (`main.dart`) à partir du timestamp local.
///
/// Structure et signatures conservées : quand les paiements repasseront par un
/// backend (Cloud Function avec la clé côté serveur), seules les
/// implémentations ci-dessous sont à rebrancher.
class ChariowService {
  /// Neutralisé : renvoie systématiquement un échec, sans I/O réseau.
  Future<LicenseResult> activateLicense(String licenseKey, String uid) async {
    return const LicenseResult(
      isActive: false,
      isExpired: false,
      errorMessage:
          'Activation de licence indisponible dans cette version.',
    );
  }

  /// Neutralisé : aucune requête. La rétrogradation s'appuie sur le timestamp
  /// local (`keyLicenseExpires`), pas sur une vérification distante.
  Future<LicenseResult> checkLicense(String licenseKey) async {
    return const LicenseResult(isActive: false, isExpired: false);
  }

  UserRank detectPlan(String? productName) {
    if (productName == null) return UserRank.genin;
    final lower = productName.toLowerCase();
    if (lower.contains('kage')) return UserRank.kage;
    if (lower.contains('jonin')) return UserRank.jonin;
    return UserRank.genin;
  }
}
