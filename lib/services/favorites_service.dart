import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const String key = 'favorite_post_ids';

  /// Get a list of favorite post IDs
  static Future<List<int>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final strings = prefs.getStringList(key) ?? [];
    return strings.map((id) => int.tryParse(id)).whereType<int>().toList();
  }

  /// Toggle a post as favorite or not
  static Future<void> toggleFavorite(int postId) async {
    final prefs = await SharedPreferences.getInstance();
    final current = await getFavorites();
    final updated = [...current];

    if (updated.contains(postId)) {
      updated.remove(postId);
    } else {
      updated.add(postId);
    }

    await prefs.setStringList(key, updated.map((e) => e.toString()).toList());
  }

  /// Check if a post is marked favorite
  static Future<bool> isFavorite(int postId) async {
    final current = await getFavorites();
    return current.contains(postId);
  }
}
