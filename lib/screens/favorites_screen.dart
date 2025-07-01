// favorites_screen.dart
import 'package:flutter/material.dart';
import '../models/post_model.dart';
import '../services/api_service.dart';
import '../services/favorites_service.dart';
import '../widgets/post_tile.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late Future<List<Post>> _favoritePosts;

  Future<List<Post>> _loadFavorites() async {
    try {
      final favIds = await FavoritesService.getFavorites(); // Get favorite IDs
      // It's generally more efficient to fetch only the favorite posts if your API supports it.
      // For now, if the API doesn't have a filter by ID, fetching all and filtering is a workaround.
      // If ApiService.fetchPosts had an 'ids' parameter, it would be:
      // return ApiService.fetchPosts(ids: favIds);
      final all = await ApiService.fetchPosts(); // Fetch all posts
      return all.where((post) => favIds.contains(post.id)).toList();
    } catch (e) {
      debugPrint('Error loading favorites: $e');
      // Show a user-friendly error message if desired
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load favorite posts.')),
        );
      }
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    _favoritePosts = _loadFavorites(); // Initial load
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // This is called when the State object is first created, and
    // also whenever the dependencies of this State object change.
    // We'll use it to reload favorites potentially when the screen is active again.
    // However, for favorites that might change from other screens (e.g., PostDetailScreen),
    // a better approach might be to use a Provider to manage favorite state,
    // or rely on Navigator.pop callbacks to trigger a reload.
    // For simplicity, re-fetching here will work for now, but be aware of potential performance implications
    // if didChangeDependencies is called frequently.
    _favoritePosts = _loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    // Get theme data from context
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        // AppBar's background and icon colors will automatically come from theme.appBarTheme
        title: Text(
          'Favourites',
          // Use the app bar's title text style defined in app_themes.dart
          style: theme.appBarTheme.titleTextStyle,
        ),
      ),
      body: FutureBuilder<List<Post>>(
        future: _favoritePosts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: colorScheme.primary,
              ), // Use theme primary color
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error loading favorites",
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.error,
                ), // Use error color for error text
              ),
            );
          }

          final posts = snapshot.data ?? [];
          if (posts.isEmpty) {
            return Center(
              child: Text(
                "No favorites yet. Tap the star icon on posts to add them here!",
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium, // Use theme text style
              ),
            );
          }

          return ListView.builder(
            itemCount: posts.length,
            // PostTile itself should now be theme-aware after our previous corrections
            itemBuilder: (context, index) => PostTile(post: posts[index]),
          );
        },
      ),
    );
  }
}
