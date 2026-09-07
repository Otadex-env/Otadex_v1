import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import '../models/user_rank.dart';

/// URL du Worker Cloudflare qui sert de proxy sécurisé vers l'API Chariow.
///
/// La clé Chariow (`sk_live_…`) vit **uniquement** côté Worker. Le client
/// n'envoie qu'un idToken Firebase + une clé de licence ; le Worker valide,
/// active si besoin, et écrit `abonnement` / `licenseExpires` / `licenseKey`
/// dans `users/{uid}` (les règles Firestore interdisent au client d'y toucher).
const String kLicenseWorkerBaseUrl =
    'https://otadex-licenses.israel01tientcheu.workers.dev';

/// Verdict d'une vérification de licence renvoyé par le Worker.
class LicenseResult {
  /// Rang accordé (`genin` si la licence n'est pas active).
  final UserRank rank;

  /// Date d'expiration renvoyée par le Worker, ou `null` (perpétuelle / absente).
  final DateTime? expiresAt;

  /// `null` → licence valide et active.
  ///
  /// Sinon un motif :
  /// - **définitif** (le client repasse `genin`) : `revoked`, `expired`,
  ///   `license_not_found`, `activation_limit_reached`, `activation_failed`,
  ///   `inactive`, `missing_license_key` ;
  /// - **transitoire** (le client garde son état courant) : `validation_failed`,
  ///   `internal_error`, `not_persisted`, `rate_limited`, `network`,
  ///   `unauthorized`.
  final String? reason;

  const LicenseResult({required this.rank, this.expiresAt, this.reason});

  static const _definitiveReasons = <String>{
    'revoked',
    'expired',
    'license_not_found',
    'activation_limit_reached',
    'activation_failed',
    'inactive',
    'missing_license_key',
  };

  /// Licence valide et active (rang premium effectivement accordé).
  bool get isValid => reason == null && rank != UserRank.genin;

  /// Verdict négatif *définitif* : on peut rétrograder franchement à `genin`.
  bool get isDefinitiveDowngrade =>
      reason != null && _definitiveReasons.contains(reason);
}

/// Client du Worker de licences. Aucune clé secrète ici : seulement l'idToken
/// Firebase de l'utilisateur courant.
class LicenseService {
  const LicenseService();

  /// `POST /validate` — valide la clé fournie et l'active si nécessaire
  /// (le Worker gère l'activation Chariow, `device_identifier` = uid Firebase).
  ///
  /// Utilisé par l'écran d'activation, accessible uniquement quand
  /// `kEnablePaidPlans == true`.
  Future<LicenseResult> activateLicense(String licenseKey) =>
      _post('/validate', body: {'licenseKey': licenseKey});

  /// `POST /refresh` — revalide la clé déjà stockée côté serveur pour cet uid.
  /// Détecte une révocation ou une expiration survenue côté Chariow. Sans body.
  Future<LicenseResult> refresh() => _post('/refresh');

  Future<LicenseResult> _post(String path, {Map<String, dynamic>? body}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const LicenseResult(rank: UserRank.genin, reason: 'unauthorized');
    }

    try {
      final token = await user.getIdToken();
      if (token == null) {
        return const LicenseResult(rank: UserRank.genin, reason: 'unauthorized');
      }

      final res = await http
          .post(
            Uri.parse('$kLicenseWorkerBaseUrl$path'),
            headers: {
              'Authorization': 'Bearer $token',
              if (body != null) 'Content-Type': 'application/json',
            },
            body: body == null ? null : jsonEncode(body),
          )
          .timeout(const Duration(seconds: 20));

      switch (res.statusCode) {
        case 200:
          break;
        case 401:
          return const LicenseResult(
              rank: UserRank.genin, reason: 'unauthorized');
        case 429:
          return const LicenseResult(
              rank: UserRank.genin, reason: 'rate_limited');
        default:
          return const LicenseResult(
              rank: UserRank.genin, reason: 'validation_failed');
      }

      final data = jsonDecode(res.body);
      if (data is! Map<String, dynamic>) {
        return const LicenseResult(
            rank: UserRank.genin, reason: 'validation_failed');
      }

      final rank = UserRankX.fromString(data['rank'] as String?);
      final rawExpires = data['expiresAt'] as String?;
      final expiresAt = (rawExpires != null && rawExpires.isNotEmpty)
          ? DateTime.tryParse(rawExpires)
          : null;

      return LicenseResult(
        rank: rank,
        expiresAt: expiresAt,
        reason: data['reason'] as String?,
      );
    } catch (_) {
      // Réseau coupé, timeout, JSON illisible… → transitoire, on ne touche à rien.
      return const LicenseResult(rank: UserRank.genin, reason: 'network');
    }
  }
}
