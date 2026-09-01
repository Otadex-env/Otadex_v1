/// Rang d'abonnement OTADEX — enum UNIQUE de l'application.
///
/// Fichier feuille : AUCUNE dépendance (ni Riverpod, ni Firebase). Importé
/// aussi bien par `rank_providers.dart` que par `user_profile_provider.dart`
/// sans créer d'import mutuel.
///
/// Ne jamais recréer d'autre enum de rang (ex. l'ancien `OtadexRank`).
enum UserRank { genin, jonin, kage }

extension UserRankX on UserRank {
  String get label {
    switch (this) {
      case UserRank.genin:
        return 'Genin';
      case UserRank.jonin:
        return 'Jonin';
      case UserRank.kage:
        return 'Kage';
    }
  }

  /// Parse la valeur persistée (prefs `keyUserRank` / Firestore `abonnement`).
  static UserRank fromString(String? value) {
    switch (value) {
      case 'jonin':
        return UserRank.jonin;
      case 'kage':
        return UserRank.kage;
      default:
        return UserRank.genin;
    }
  }
}

/// Gates d'accès aux fonctionnalités selon le rang.
///
/// SEULE source de vérité pour "ce rang a-t-il droit à X". Toute comparaison
/// de rang dans l'UI doit passer par ces getters (ou par l'enum [UserRank]
/// lui-même), jamais par une chaîne `'genin'` / `'jonin'` / `'kage'`.
extension RankGatesX on UserRank {
  /// Publicités affichées (Genin uniquement).
  bool get showsAds => this == UserRank.genin;

  /// Fonctionnalités IA de base — quiz personnage (Jonin et Kage).
  bool get canUseAi => this != UserRank.genin;

  /// Génération d'images IA + chatbot personnage (Kage uniquement).
  bool get canGenerateImages => this == UserRank.kage;

  /// Téléchargement d'images sans filigrane (Kage uniquement).
  bool get canDownloadClean => this == UserRank.kage;

  /// Thèmes exclusifs (Kage uniquement).
  bool get hasExclusiveThemes => this == UserRank.kage;

  /// Nombre max de personnages collectionnables. `null` = illimité (Jonin+).
  int? get collectionLimit => this == UserRank.genin ? 10 : null;
}
