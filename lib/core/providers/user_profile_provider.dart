import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_profile.dart';

class UserProfileNotifier extends StateNotifier<UserProfile> {
  UserProfileNotifier() : super(UserProfile.mock());

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

  void addToCollection(String characterId) {
    if (state.rank == 'genin' && state.collectedCharacterIds.length >= 10) {
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
    final newIds = state.collectedCharacterIds
        .where((id) => id != characterId)
        .toList();
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
