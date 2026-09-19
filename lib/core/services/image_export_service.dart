import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:gal/gal.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

import '../constants/app_assets.dart';

/// Échec d'export d'image, avec un message directement affichable à l'utilisateur.
class ImageExportException implements Exception {
  final String message;
  const ImageExportException(this.message);

  @override
  String toString() => 'ImageExportException: $message';
}

/// Télécharge / partage une image de la galerie, avec ou sans filigrane.
///
/// Règle métier : Genin et Jonin exportent l'image avec le logo OTADEX incrusté
/// dans le fichier ; Kage exporte l'original octet pour octet.
class ImageExportService {
  const ImageExportService._();

  /// Largeur max du filigrane, en proportion de l'image.
  static const double _logoWidthFactor = 0.18;
  static const double _logoOpacity = 0.60;
  static const double _marginFactor = 0.03;

  /// Au-delà, l'image est décodée réduite (garde-fou mémoire) avant composition.
  static const int _maxCompositeWidth = 4096;

  static const Duration _downloadTimeout = Duration(seconds: 25);
  static const int _maxDownloadAttempts = 3;

  // ── API publique ──────────────────────────────────────────────────────────

  /// Enregistre l'image dans la galerie. Ne retourne qu'une fois le fichier
  /// réellement écrit ; lève [ImageExportException] sinon.
  static Future<void> saveToGallery(
    String imagePath, {
    required bool withWatermark,
  }) async {
    final bytes = await _prepare(imagePath, withWatermark: withWatermark);
    try {
      if (!await Gal.hasAccess()) {
        final granted = await Gal.requestAccess();
        if (!granted) {
          throw const ImageExportException(
            "Accès au stockage refusé. Autorise-le dans les réglages d'Android "
            'pour sauvegarder les images.',
          );
        }
      }
      await Gal.putImageBytes(
        bytes,
        name: 'otadex_${DateTime.now().millisecondsSinceEpoch}',
      );
    } on GalException catch (e) {
      throw ImageExportException(_galMessage(e));
    }
  }

  /// Ouvre la feuille de partage système avec l'image (filigranée si demandé).
  static Future<void> share(
    String imagePath, {
    required bool withWatermark,
  }) async {
    final bytes = await _prepare(imagePath, withWatermark: withWatermark);
    final File file;
    try {
      final dir = await Directory.systemTemp.createTemp('otadex_share');
      file = File('${dir.path}/otadex_${DateTime.now().millisecondsSinceEpoch}'
          '.${_extensionFor(bytes)}');
      await file.writeAsBytes(bytes, flush: true);
    } on FileSystemException {
      throw const ImageExportException(
        "Impossible de préparer l'image pour le partage (stockage plein ?).",
      );
    }
    await SharePlus.instance.share(
      ShareParams(files: [XFile(file.path, mimeType: _mimeFor(bytes))]),
    );
  }

  /// Ouvre la feuille de partage avec un simple texte.
  static Future<void> shareText(String text) =>
      SharePlus.instance.share(ShareParams(text: text));

  // ── Pipeline ──────────────────────────────────────────────────────────────

  static Future<Uint8List> _prepare(
    String imagePath, {
    required bool withWatermark,
  }) async {
    final original = await _loadBytes(imagePath);
    if (!withWatermark) return original; // Kage : original intact.
    try {
      return await _applyWatermark(original);
    } on ImageExportException {
      rethrow;
    } catch (_) {
      throw const ImageExportException(
        "Impossible d'appliquer le filigrane à cette image (format non pris "
        'en charge ou image trop lourde).',
      );
    }
  }

  static Future<Uint8List> _loadBytes(String path) async {
    if (path.isEmpty) {
      throw const ImageExportException('Aucune image à enregistrer.');
    }
    if (path.startsWith('assets/')) {
      try {
        final data = await rootBundle.load(path);
        return data.buffer.asUint8List();
      } catch (_) {
        throw const ImageExportException('Image introuvable.');
      }
    }
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return _download(Uri.parse(_normalizeUrl(path)));
    }
    throw const ImageExportException('Source d\'image non prise en charge.');
  }

  /// Télécharge avec quelques tentatives : une coupure réseau en cours de
  /// réponse (fréquente en mobile) ne doit pas faire échouer l'export.
  static Future<Uint8List> _download(Uri uri) async {
    Object? lastError;
    for (var attempt = 1; attempt <= _maxDownloadAttempts; attempt++) {
      try {
        final response = await http.get(uri).timeout(_downloadTimeout);
        if (response.statusCode == 200 && response.bodyBytes.isNotEmpty) {
          return response.bodyBytes;
        }
        // Réponse HTTP définitive (404, 403…) : inutile de réessayer.
        if (response.statusCode >= 400 && response.statusCode < 500) {
          throw const ImageExportException(
            "Cette image n'est plus disponible sur le serveur.",
          );
        }
        lastError = 'HTTP ${response.statusCode}';
      } on ImageExportException {
        rethrow;
      } catch (e) {
        lastError = e;
      }
      if (attempt < _maxDownloadAttempts) {
        await Future<void>.delayed(Duration(milliseconds: 700 * attempt));
      }
    }
    debugPrint(
        'ImageExportService: échec du téléchargement de $uri : $lastError');
    if (lastError is TimeoutException) {
      throw const ImageExportException(
        "Le téléchargement de l'image a expiré. Vérifie ta connexion.",
      );
    }
    throw const ImageExportException(
      "Impossible de télécharger l'image. Vérifie ta connexion.",
    );
  }

  /// Compose le logo OTADEX en bas à droite de l'image et renvoie un PNG.
  static Future<Uint8List> _applyWatermark(Uint8List source) async {
    ui.Image? photo;
    ui.Image? logo;
    ui.Image? result;
    try {
      photo = await _decode(source, maxWidth: _maxCompositeWidth);
      final logoData = await rootBundle.load(AppAssets.logoFull);
      logo = await _decode(logoData.buffer.asUint8List());

      final w = photo.width.toDouble();
      final h = photo.height.toDouble();

      final recorder = ui.PictureRecorder();
      final canvas = ui.Canvas(recorder);
      canvas.drawImage(photo, ui.Offset.zero, ui.Paint());

      final logoW = w * _logoWidthFactor;
      final logoH = logoW * logo.height / logo.width;
      final margin = w * _marginFactor;
      canvas.drawImageRect(
        logo,
        ui.Rect.fromLTWH(0, 0, logo.width.toDouble(), logo.height.toDouble()),
        ui.Rect.fromLTWH(w - margin - logoW, h - margin - logoH, logoW, logoH),
        ui.Paint()
          ..filterQuality = ui.FilterQuality.high
          // L'alpha du Paint module l'opacité de l'image dessinée.
          ..color = const ui.Color(0xFFFFFFFF).withValues(alpha: _logoOpacity),
      );

      final picture = recorder.endRecording();
      result = await picture.toImage(photo.width, photo.height);
      picture.dispose();
      final data = await result.toByteData(format: ui.ImageByteFormat.png);
      if (data == null) {
        throw const ImageExportException("Échec de l'encodage de l'image.");
      }
      return data.buffer.asUint8List();
    } finally {
      photo?.dispose();
      logo?.dispose();
      result?.dispose();
    }
  }

  static Future<ui.Image> _decode(Uint8List bytes, {int? maxWidth}) async {
    // targetWidth n'agrandit jamais : on ne le passe que si l'image est plus
    // large que le plafond (lu sans décoder les pixels).
    int? targetWidth;
    if (maxWidth != null) {
      final buffer = await ui.ImmutableBuffer.fromUint8List(bytes);
      try {
        final descriptor = await ui.ImageDescriptor.encoded(buffer);
        if (descriptor.width > maxWidth) targetWidth = maxWidth;
        descriptor.dispose();
      } finally {
        buffer.dispose();
      }
    }
    final codec =
        await ui.instantiateImageCodec(bytes, targetWidth: targetWidth);
    try {
      final frame = await codec.getNextFrame();
      return frame.image;
    } finally {
      codec.dispose();
    }
  }

  // ── Utilitaires ───────────────────────────────────────────────────────────

  /// Même normalisation que `OtadexImage` : URL déjà encodée ou non.
  static String _normalizeUrl(String url) {
    try {
      return Uri.encodeFull(Uri.decodeFull(url));
    } catch (_) {
      return url;
    }
  }

  static String _galMessage(GalException e) {
    switch (e.type) {
      case GalExceptionType.accessDenied:
        return "Accès au stockage refusé. Autorise-le dans les réglages d'Android "
            'pour sauvegarder les images.';
      case GalExceptionType.notEnoughSpace:
        return "Espace de stockage insuffisant pour enregistrer l'image.";
      case GalExceptionType.notSupportedFormat:
        return "Format d'image non pris en charge par la galerie.";
      case GalExceptionType.unexpected:
        return "L'enregistrement dans la galerie a échoué. Réessaie.";
    }
  }

  static String _extensionFor(Uint8List b) {
    if (_startsWith(b, const [0x89, 0x50, 0x4E, 0x47])) return 'png';
    if (_startsWith(b, const [0xFF, 0xD8, 0xFF])) return 'jpg';
    if (_startsWith(b, const [0x47, 0x49, 0x46])) return 'gif';
    if (b.length > 12 && _startsWith(b, const [0x52, 0x49, 0x46, 0x46])) {
      return 'webp';
    }
    return 'png';
  }

  static String _mimeFor(Uint8List b) => switch (_extensionFor(b)) {
        'jpg' => 'image/jpeg',
        'gif' => 'image/gif',
        'webp' => 'image/webp',
        _ => 'image/png',
      };

  static bool _startsWith(Uint8List b, List<int> magic) {
    if (b.length < magic.length) return false;
    for (var i = 0; i < magic.length; i++) {
      if (b[i] != magic[i]) return false;
    }
    return true;
  }
}
