// screens/search_screen.dart
import 'package:flutter/material.dart';
import '../models/post_model.dart';
import '../services/api_service.dart';
import '../widgets/post_tile.dart'; // To display search results

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  Future<List<Post>>? _futureSearchResults;
  String _currentSearchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    final trimmedQuery = query.trim();

    if (trimmedQuery.isEmpty) {
      setState(() {
        _futureSearchResults = null; // Clear results if query is empty
        _currentSearchQuery = '';
      });
      return;
    }

    setState(() {
      _currentSearchQuery = trimmedQuery; // Store the current query for display
      _futureSearchResults = ApiService.fetchPosts(search: trimmedQuery);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get theme data and color scheme from context
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        // Use theme's AppBar background color and elevation
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: theme.appBarTheme.elevation,
        centerTitle: true,
        // Use theme's AppBar title text style
        title: Text('Search', style: theme.appBarTheme.titleTextStyle),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(
            60.0,
          ), // Height for the search bar
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: TextField(
              controller: _searchController,
              // Style text input and hint text using theme colors
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                hintText: 'Search for articles...',
                hintStyle: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: colorScheme.onSurface.withOpacity(
                    0.7,
                  ), // Use theme's onSurface for icons
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none, // No border line
                ),
                filled: true,
                // Use a surface color for the text field background,
                // or a lighter shade of the background color
                fillColor:
                    colorScheme.brightness == Brightness.light
                        ? Colors
                            .grey
                            .shade200 // A light grey for light mode
                        : colorScheme
                            .surfaceContainerHigh, // A slightly elevated surface for dark mode
                suffixIcon:
                    _searchController.text.isNotEmpty
                        ? IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: colorScheme.onSurface.withOpacity(
                              0.7,
                            ), // Theme's onSurface for icon
                          ),
                          onPressed: () {
                            _searchController.clear();
                            _performSearch(
                              '',
                            ); // Clear results when clearing text
                          },
                        )
                        : null,
              ),
              onSubmitted:
                  _performSearch, // Trigger search when user presses enter/done on keyboard
              onChanged: (value) {
                setState(
                  () {},
                ); // Used to update the UI for the clear button visibility
              },
            ),
          ),
        ),
      ),
      body:
          _futureSearchResults == null
              ? Center(
                child: Text(
                  'Enter a query to search for articles.',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onBackground.withOpacity(0.7),
                  ),
                ),
              )
              : FutureBuilder<List<Post>>(
                future: _futureSearchResults,
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
                        "Error: ${snapshot.error}",
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.error,
                        ), // Use theme error color
                      ),
                    );
                  }
                  if (snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(
                        "No results found for '$_currentSearchQuery'.",
                        textAlign: TextAlign.center,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onBackground.withOpacity(0.7),
                        ),
                      ),
                    );
                  }

                  final searchResults = snapshot.data!;
                  return ListView.builder(
                    itemCount: searchResults.length,
                    // PostTile itself is already theme-aware
                    itemBuilder:
                        (context, index) =>
                            PostTile(post: searchResults[index]),
                  );
                },
              ),
    );
  }
}
