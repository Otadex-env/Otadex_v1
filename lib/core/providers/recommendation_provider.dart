import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../data/mock_data.dart';
import '../models/character.dart';

final recommendedCharactersProvider = FutureProvider<List<Character>>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final raw = prefs.getString(AppConstants.keyUserInterests);
  if (raw == null || raw.isEmpty) return MockData.recommended();
  final interests = List<String>.from(jsonDecode(raw) as List);
  return MockData.recommendedForInterests(interests);
});
