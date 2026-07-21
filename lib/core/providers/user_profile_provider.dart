import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_profile.dart';
import '../models/user_rank.dart';

// ── UIDs du créateur — toujours rang Kage, bypass Chariow ──────────────────
const List<String> kDeveloperUids = [
  'tYTfcUyV76MTQCEWuwq1yxTuuAH3', // TilStack
];

// ── Emails développeur — même privilège que kDeveloperUids ─────────────────
const List<String> kDeveloperEmails = [
  'israel01tientcheu@gmail.com',
];

// ── Override rang affichage en dev (en mémoire uniquement, jamais Firestore) ─
final devOverrideRankProvider = StateProvider.autoDispose<UserRank?>((ref) => null);

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
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final isDev = (firebaseUser != null &&
            (kDeveloperEmails.contains(firebaseUser.email) ||
                kDeveloperUids.contains(firebaseUser.uid))) ||
        kDeveloperEmails.contains(state.email) ||
        kDeveloperUids.contains(state.id);
    final effectiveRank = isDev ? UserRank.kage.name : rank ?? state.rank;
    state = state.copyWith(
      id: id ?? state.id,
      pseudo: pseudo ?? state.pseudo,
      displayName: pseudo ?? state.displayName,
      email: email ?? state.email,
      rank: effectiveRank,
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
