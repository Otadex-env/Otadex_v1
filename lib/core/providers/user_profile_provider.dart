import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_profile.dart';
import '../models/user_rank.dart';

// ── UIDs / emails développeur — bypass Chariow, menu debug ─────────────────
// (Le rang Kage n'est plus forcé ici : voir devRankOverrideProvider dans
//  core/subscription/rank_providers.dart.)
const List<String> kDeveloperUids = [
  'tYTfcUyV76MTQCEWuwq1yxTuuAH3', // TilStack
];

const List<String> kDeveloperEmails = [
  'israel01tientcheu@gmail.com',
];

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

  /// [collectionLimit] : `null` = illimité (voir `UserRank.collectionLimit`).
  void addToCollection(String characterId, {required int? collectionLimit}) {
    if (collectionLimit != null &&
        state.collectedCharacterIds.length >= collectionLimit) {
      throw Exception('LIMIT_REACHED');
    }
    if (state.collectedCharacterIds.contains(characterId)) return;
    final newIds = [...state.collectedCharacterIds, characterId];
    state = state.copyWith(
      collectedCharacterIds: newIds,
      collectCount: newIds.length,
      updatedAt: DateTime.now(),
    );
  }

  void removeFromCollection(String characterId) {
    final newIds =
        state.collectedCharacterIds.where((id) => id != characterId).toList();
    state = state.copyWith(
      collectedCharacterIds: newIds,
      collectCount: newIds.length,
      updatedAt: DateTime.now(),
    );
  }
}

final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, UserProfile>((ref) {
  return UserProfileNotifier();
});
