import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/person.dart';

class FavoritesService {
  static const String _favoritesKey = 'favorites';

  static Future<List<Person>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = prefs.getStringList(_favoritesKey) ?? [];

    return favoritesJson
        .map((json) => Person.fromJson(jsonDecode(json)))
        .toList();
  }

  static Future<void> addToFavorites(Person person) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();

    if (!favorites.any((p) => p.id == person.id)) {
      favorites.add(person);
      final favoritesJson = favorites
          .map((p) => jsonEncode({
                'id': p.id,
                'name': p.name,
                'profile_path': p.profilePath,
                'known_for_department': p.knownForDepartment,
                'popularity': p.popularity,
              }))
          .toList();

      await prefs.setStringList(_favoritesKey, favoritesJson);
    }
  }

  static Future<void> removeFromFavorites(int personId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();

    favorites.removeWhere((p) => p.id == personId);
    final favoritesJson = favorites
        .map((p) => jsonEncode({
              'id': p.id,
              'name': p.name,
              'profile_path': p.profilePath,
              'known_for_department': p.knownForDepartment,
              'popularity': p.popularity,
            }))
        .toList();

    await prefs.setStringList(_favoritesKey, favoritesJson);
  }

  static Future<bool> isFavorite(int personId) async {
    final favorites = await getFavorites();
    return favorites.any((p) => p.id == personId);
  }
}
