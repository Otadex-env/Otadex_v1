import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/user_rank.dart';

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

class ChariowService {
  static const _baseUrl = 'https://api.chariow.com/v1';

  String get _apiKey {
    try {
      return dotenv.env['CHARIOW_API_KEY'] ?? '';
    } catch (_) {
      return '';
    }
  }

  Map<String, String> get _authHeaders => {
        'Authorization': 'Bearer $_apiKey',
        'Content-Type': 'application/json',
      };

  Future<LicenseResult> activateLicense(
      String licenseKey, String uid) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/licenses/$licenseKey/activate'),
        headers: _authHeaders,
        body: jsonEncode({'device_identifier': uid}),
      );
      final body = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        final data = body['data'] as Map<String, dynamic>? ?? {};
        return LicenseResult(
          isActive: data['is_active'] as bool? ?? false,
          isExpired: data['is_expired'] as bool? ?? false,
          expiresAt: data['expires_at'] != null
              ? DateTime.tryParse(data['expires_at'] as String)
              : null,
          productName:
              (data['product'] as Map<String, dynamic>?)?['name'] as String?,
        );
      }

      if (response.statusCode == 400) {
        final message = (body['message'] as String? ?? '').toLowerCase();
        final String errorMsg;
        if (message.contains('revoked')) {
          errorMsg = 'Cette licence a été révoquée.';
        } else if (message.contains('expired')) {
          errorMsg = 'Cette licence a expiré.';
        } else if (message.contains('limit')) {
          errorMsg = 'Limite d\'appareils atteinte.';
        } else {
          errorMsg = body['message'] as String? ?? 'Erreur d\'activation.';
        }
        return LicenseResult(
            isActive: false, isExpired: false, errorMessage: errorMsg);
      }

      if (response.statusCode == 404) {
        return const LicenseResult(
          isActive: false,
          isExpired: false,
          errorMessage: 'Licence introuvable. Vérifie la clé.',
        );
      }

      return LicenseResult(
        isActive: false,
        isExpired: false,
        errorMessage: 'Erreur ${response.statusCode}. Réessaie plus tard.',
      );
    } catch (_) {
      return const LicenseResult(
        isActive: false,
        isExpired: false,
        errorMessage: 'Erreur réseau. Réessaie plus tard.',
      );
    }
  }

  Future<LicenseResult> checkLicense(String licenseKey) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/licenses/$licenseKey'),
        headers: {'Authorization': 'Bearer $_apiKey'},
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final data =
            (body['data'] ?? body) as Map<String, dynamic>;
        return LicenseResult(
          isActive: data['is_active'] as bool? ?? false,
          isExpired: data['is_expired'] as bool? ?? false,
          expiresAt: data['expires_at'] != null
              ? DateTime.tryParse(data['expires_at'] as String)
              : null,
          productName:
              (data['product'] as Map<String, dynamic>?)?['name'] as String?,
        );
      }
      return const LicenseResult(isActive: false, isExpired: true);
    } catch (_) {
      return const LicenseResult(
        isActive: false,
        isExpired: false,
        errorMessage: 'Erreur réseau.',
      );
    }
  }

  UserRank detectPlan(String? productName) {
    if (productName == null) return UserRank.genin;
    final lower = productName.toLowerCase();
    if (lower.contains('kage')) return UserRank.kage;
    if (lower.contains('jonin')) return UserRank.jonin;
    return UserRank.genin;
  }
}
