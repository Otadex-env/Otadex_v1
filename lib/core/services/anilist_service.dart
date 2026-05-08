import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/character.dart';
import '../models/anime_entry.dart';

class AniListService {
  static const _endpoint = 'https://graphql.anilist.co';

  // Color palette derived from AniList ID (API returns no color info)
  static const _palette = [
    [Color(0xFF1A237E), Color(0xFF7B1FA2)],
    [Color(0xFF4A148C), Color(0xFF880E4F)],
    [Color(0xFF006064), Color(0xFF1B5E20)],
    [Color(0xFF37474F), Color(0xFF1A237E)],
    [Color(0xFF4E342E), Color(0xFF880E4F)],
    [Color(0xFF1B5E20), Color(0xFF006064)],
    [Color(0xFF880E4F), Color(0xFF4A148C)],
    [Color(0xFF0D47A1), Color(0xFF004D40)],
  ];

  static Color _cardColor(int id) =>
      _palette[id.abs() % _palette.length][0];
  static Color _accentColor(int id) =>
      _palette[id.abs() % _palette.length][1];

  static CharacterTier _favouritesToTier(int f) {
    if (f >= 50000) return CharacterTier.ss;
    if (f >= 20000) return CharacterTier.s;
    if (f >= 8000) return CharacterTier.a;
    return CharacterTier.b;
  }

  static String _genreToCategory(List<dynamic> genres) {
    const mapping = {
      'Action': 'Shōnen',
      'Adventure': 'Shōnen',
      'Sports': 'Shōnen',
      'Comedy': 'Shōnen',
      'Fantasy': 'Shōnen',
      'Romance': 'Shōjo',
      'Drama': 'Shōjo',
      'Slice of Life': 'Shōjo',
      'Psychological': 'Seinen',
      'Horror': 'Seinen',
      'Mystery': 'Seinen',
      'Sci-Fi': 'Seinen',
    };
    for (final g in genres) {
      final mapped = mapping[g as String?];
      if (mapped != null) return mapped;
    }
    return 'Shōnen';
  }

  static String _clean(String text) => text
      .replaceAll(RegExp(r'<[^>]*>'), '')
      .replaceAll(RegExp(r'~![^!]*!~'), '')
      .replaceAll('__', '')
      .replaceAll('**', '')
      .trim();

  Future<Map<String, dynamic>?> _query(String gql,
      [Map<String, dynamic>? vars]) async {
    try {
      final response = await http.post(
        Uri.parse(_endpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'query': gql, if (vars != null) 'variables': vars}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return data['data'] as Map<String, dynamic>?;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<List<Character>> searchCharacters(String query,
      {int page = 1, int perPage = 20}) async {
    const gql = r'''
      query($search: String, $page: Int, $perPage: Int) {
        Page(page: $page, perPage: $perPage) {
          characters(search: $search, sort: FAVOURITES_DESC) {
            id name { full native } image { large medium }
            description favourites gender age
            media(sort: POPULARITY_DESC, perPage: 1) {
              nodes { id title { romaji french english } genres }
            }
          }
        }
      }
    ''';
    final data = await _query(gql, {
      'search': query,
      'page': page,
      'perPage': perPage,
    });
    if (data == null) return [];
    return ((data['Page']['characters'] as List?) ?? [])
        .map((c) => _mapCharacter(c as Map<String, dynamic>))
        .toList();
  }

  Future<List<Character>> getTrendingCharacters(
      {int page = 1, int perPage = 20}) async {
    const gql = r'''
      query($page: Int, $perPage: Int) {
        Page(page: $page, perPage: $perPage) {
          characters(sort: FAVOURITES_DESC) {
            id name { full native } image { large medium }
            description favourites gender age
            media(sort: POPULARITY_DESC, perPage: 1) {
              nodes { id title { romaji french english } genres }
            }
          }
        }
      }
    ''';
    final data = await _query(gql, {'page': page, 'perPage': perPage});
    if (data == null) return [];
    return ((data['Page']['characters'] as List?) ?? [])
        .map((c) => _mapCharacter(c as Map<String, dynamic>, isTrending: true))
        .toList();
  }

  Future<List<AnimeEntry>> getTrendingAnimes(
      {int page = 1, int perPage = 5}) async {
    const gql = r'''
      query($page: Int, $perPage: Int) {
        Page(page: $page, perPage: $perPage) {
          media(sort: TRENDING_DESC, type: ANIME, isAdult: false) {
            id title { romaji french english } description genres
            format episodes seasonYear averageScore
            studios(isMain: true) { nodes { name } }
          }
        }
      }
    ''';
    final data = await _query(gql, {'page': page, 'perPage': perPage});
    if (data == null) return [];
    return ((data['Page']['media'] as List?) ?? [])
        .map((a) => _mapAnime(a as Map<String, dynamic>))
        .toList();
  }

  Future<List<AnimeEntry>> searchAnimes(String query,
      {int page = 1, int perPage = 10}) async {
    const gql = r'''
      query($search: String, $page: Int, $perPage: Int) {
        Page(page: $page, perPage: $perPage) {
          media(search: $search, type: ANIME, isAdult: false, sort: POPULARITY_DESC) {
            id title { romaji french english } description genres
            format episodes seasonYear averageScore
            studios(isMain: true) { nodes { name } }
          }
        }
      }
    ''';
    final data = await _query(gql, {
      'search': query,
      'page': page,
      'perPage': perPage,
    });
    if (data == null) return [];
    return ((data['Page']['media'] as List?) ?? [])
        .map((a) => _mapAnime(a as Map<String, dynamic>))
        .toList();
  }

  Future<Character?> getCharacterById(int anilistId) async {
    const gql = r'''
      query($id: Int) {
        Character(id: $id) {
          id name { full native alternative }
          image { large medium } description favourites age gender
          media(sort: POPULARITY_DESC, perPage: 1) {
            nodes { id title { romaji french english } genres }
          }
        }
      }
    ''';
    final data = await _query(gql, {'id': anilistId});
    if (data == null || data['Character'] == null) return null;
    return _mapCharacter(data['Character'] as Map<String, dynamic>);
  }

  // ── MAPPERS ────────────────────────────────────────────────────────────────

  Character _mapCharacter(Map<String, dynamic> c, {bool isTrending = false}) {
    final mediaNodes = (c['media']?['nodes'] as List?) ?? [];
    final firstMedia = mediaNodes.isNotEmpty
        ? mediaNodes.first as Map<String, dynamic>
        : <String, dynamic>{};
    final title = firstMedia['title'] as Map<String, dynamic>?;
    final animeName =
        title?['french'] ?? title?['romaji'] ?? title?['english'] ?? 'Inconnu';
    final genres = (firstMedia['genres'] as List?) ?? [];
    final id = c['id'] as int;
    final favourites = (c['favourites'] as int?) ?? 0;

    String desc = _clean(c['description'] as String? ?? '');
    if (desc.length > 500) desc = '${desc.substring(0, 500)}...';

    final largeImg = c['image']?['large'] as String?;
    final mediumImg = c['image']?['medium'] as String?;

    return Character(
      id: 'anilist-$id',
      name: (c['name'] as Map?)?['full'] as String? ?? 'Inconnu',
      animeName: animeName as String,
      cardColor: _cardColor(id),
      accentColor: _accentColor(id),
      tier: _favouritesToTier(favourites),
      rating: (favourites.clamp(0, 100000) / 10000.0).clamp(1.0, 10.0),
      likes: favourites,
      imagePath: largeImg,
      images: [
        if (largeImg != null) largeImg,
        if (mediumImg != null) mediumImg,
      ],
      category: _genreToCategory(genres),
      isTrending: isTrending,
      bio: desc.isNotEmpty ? desc : null,
      gender: c['gender'] as String?,
      age: c['age'] as String?,
    );
  }

  AnimeEntry _mapAnime(Map<String, dynamic> a) {
    final title = a['title'] as Map<String, dynamic>?;
    final studios = (a['studios']?['nodes'] as List?) ?? [];
    final studioName = studios.isNotEmpty
        ? (studios.first as Map)['name'] as String? ?? ''
        : '';
    final genres = List<String>.from(a['genres'] as List? ?? []);
    final id = a['id'] as int;

    String desc = _clean(a['description'] as String? ?? '');
    if (desc.length > 400) desc = '${desc.substring(0, 400)}...';

    return AnimeEntry(
      id: 'anilist-$id',
      name: (title?['french'] ?? title?['romaji'] ?? title?['english'] ??
          'Inconnu') as String,
      originalTitle: title?['romaji'] as String? ?? '',
      category: genres.isNotEmpty ? _genreToCategory(genres) : 'Shōnen',
      genres: genres,
      year: a['seasonYear'] as int? ?? 0,
      seasons: 1,
      episodes: a['episodes'] as int? ?? 0,
      status: 'En cours',
      studio: studioName,
      rating: ((a['averageScore'] as int?) ?? 0) / 10.0,
      synopsis: desc,
      cardColor: _cardColor(id),
      accentColor: _accentColor(id),
      tags: genres.take(3).toList(),
    );
  }
}
