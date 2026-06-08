import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import '../constants/app_assets.dart';
import '../models/character.dart';

class ImagePrefetcher {
  /// Précache les images d'un personnage au moment du tap, avant la navigation.
  /// Fire-and-forget : ne pas await.
  static void prefetchCharacterImages(BuildContext context, Character character) {
    final images = _resolveImages(character);
    for (final url in images.take(4)) {
      if (!url.startsWith('http')) continue;
      precacheImage(
        CachedNetworkImageProvider(Uri.encodeFull(url)),
        context,
      );
    }
  }

  static List<String> _resolveImages(Character character) {
    final all = <String>[];
    // Image hero en premier (chargée dans CharDetailHero)
    if (character.imagePath?.isNotEmpty == true) all.add(character.imagePath!);
    // Galerie : Firestore > assets locaux
    final fsImages = character.images.where((u) => u.isNotEmpty).toList();
    if (fsImages.isNotEmpty) {
      all.addAll(fsImages);
    } else {
      all.addAll(AppAssets.getByCharacterId(character.id));
    }
    return all;
  }
}
