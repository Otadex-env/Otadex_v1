import 'package:flutter/material.dart';

class FeaturedSlide {
  final String id;
  final String title;
  final String subtitle;
  final String tag;
  final Color primaryColor;
  final Color secondaryColor;
  final String category;

  /// Image de fond de la carte (illustration d'un personnage de l'animé).
  /// `null` : la carte garde son dégradé de couleurs.
  final String? imageUrl;

  /// Identifiant de l'animé à ouvrir au toucher. `null` : carte non cliquable
  /// (cas des slides de secours, qui ne correspondent à aucun animé).
  final String? animeId;

  const FeaturedSlide({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.primaryColor,
    required this.secondaryColor,
    required this.category,
    this.imageUrl,
    this.animeId,
  });
}
