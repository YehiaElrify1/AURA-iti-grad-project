// lib/app/features/favorites/data/favorites_repository_impl.dart
import 'dart:convert';

import 'package:iti_grad_proj/app/features/persons/data/models/person_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'favorites_repository.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  // Single key that stores a JSON-encoded list of full person objects.
  static const _key = 'aura_favorite_persons_v2';

  final SharedPreferences prefs;

  FavoritesRepositoryImpl({required this.prefs});

  @override
  Future<List<PersonModel>> loadFavorites() async {
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return [];

    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .map((item) => PersonModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      // Corrupt data — clear and start fresh.
      await prefs.remove(_key);
      return [];
    }
  }

  @override
  Future<void> saveFavorites(List<PersonModel> persons) async {
    final encoded = jsonEncode(
      persons.map((p) => p.toJson()).toList(),
    );
    await prefs.setString(_key, encoded);
  }
}
