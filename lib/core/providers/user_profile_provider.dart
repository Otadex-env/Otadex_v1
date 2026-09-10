import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_profile.dart';
import '../models/user_rank.dart';

// Les développeurs déclarés (UIDs / emails) sont définis dans
// `core/subscription/rank_providers.dart`, chargés depuis `.env`.

class UserProfileNotifier extends StateNotifier<UserProfile> {
  UserProfileNotifier({
    UserRank initialRank = UserRank.genin,
    String? id,
    String? pseudo,
    String? email,
  }) : super(
          UserProfile.mock().copyWith(
            id: id,
            pseudo: pseudo,
            displayName: pseudo,
            email: email,
            rank: initialRank.name,
          ),
        );

  void updateIdentity({
    String? id,
    String? pseudo,
    String? email,
    String? rank,
  }) {
    state = state.copyWith(
      id: id ?? state.id,
      pseudo: pseudo ?? state.pseudo,
      displayName: pseudo ?? state.displayName,
      email: email ?? state.email,
      rank: rank ?? state.rank,
      updatedAt: DateTime.now(),
    );
  }

  void updateProfile({String? pseudo, String? bio}) {
    state = state.copyWith(
      pseudo: pseudo ?? state.pseudo,
      displayName: pseudo ?? state.displayName,
      bio: bio ?? state.bio,
      updatedAt: DateTime.now(),
    );
  }

  void updateAvatar(String? avatarPath) {
    state = state.copyWith(
      avatarUrl: avatarPath,
      updatedAt: DateTime.now(),
    );
  }

  // La collection vit UNIQUEMENT dans Firestore (`users/{uid}.collection`),
  // exposée par `collectionStreamProvider` / `collectionCountProvider` /
  // `collectedCharactersProvider`. Écriture via `CollectionService` (cf.
  // `toggleCollection`). Aucun miroir local ici — une seule source.
}

final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, UserProfile>((ref) {
  return UserProfileNotifier();
});
