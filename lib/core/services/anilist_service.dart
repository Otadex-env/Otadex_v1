import '../models/anime_entry.dart';
import '../models/character.dart';

class AniListService {  // AniList désactivé — données Firestore uniquement
  // Réactiver pour les animés non encore importés

  Future<List<Character>> searchCharacters(String query,
      {int page = 1, int perPage = 20}) async => [];

  Future<List<Character>> getTrendingCharacters(
      {int page = 1, int perPage = 20}) async => [];

  Future<List<AnimeEntry>> getTrendingAnimes(
      {int page = 1, int perPage = 5}) async => [];

  Future<List<AnimeEntry>> searchAnimes(String query,
      {int page = 1, int perPage = 10}) async => [];

  Future<Character?> getCharacterById(int anilistId) async => null;

  Future<Map<String, dynamic>?> getFullCharacterData(int anilistId) async => null;

  Future<Map<String, dynamic>?> getStudioById(int studioId) async => null;

  Future<Map<String, dynamic>?> getVoiceActorById(int staffId) async => null;

  Future<List<Character>> getCharactersByAnimeId(int anilistId,
      {int perPage = 5}) async => [];
}
