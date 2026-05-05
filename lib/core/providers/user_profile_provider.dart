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
}

final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, UserProfile>((ref) {
  return UserProfileNotifier();
});
