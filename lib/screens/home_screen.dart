// home_screen.dart
import 'package:flutter/material.dart';
import 'package:news_app/screens/search_screen.dart';
import '../models/post_model.dart';
import '../services/api_service.dart';
import '../widgets/post_tile.dart';
import '../models/category_model.dart'; // Import the Category model

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Post>> _futureBreakingNewsPosts;
  late Future<List<Category>> _futureCategories;

  List<Post> _posts = [];
  int _currentPage = 1;
  bool _isLoadingMore = false;
  bool _hasMorePosts = true;
  final ScrollController _scrollController = ScrollController();

  // State variable to hold the currently selected category ID
  int? _selectedCategoryId; // Null means "All/Latest Stories"

  @override
  void initState() {
    super.initState();
    _futureBreakingNewsPosts = ApiService.fetchPosts(perPage: 5);
    _futureCategories = ApiService.fetchCategories();

    // Initial fetch for the main post list, possibly filtered by category
    _fetchPosts(1, categoryId: _selectedCategoryId);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMorePosts();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Modified _fetchPosts to accept an optional categoryId
  Future<void> _fetchPosts(int page, {int? categoryId}) async {
    if (!_hasMorePosts || _isLoadingMore) {
      return;
    }

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final newPosts = await ApiService.fetchPosts(
        page: page,
        perPage: 10,
        categoryId: categoryId, // Pass the selected category ID
      );

      setState(() {
        if (page == 1) {
          _posts = newPosts;
        } else {
          _posts.addAll(newPosts);
        }
        _currentPage++;
        if (newPosts.length < 10) {
          _hasMorePosts = false;
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to load posts: $e')));
      }
    } finally {
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  Future<void> _loadMorePosts() async {
    if (!_isLoadingMore && _hasMorePosts) {
      await _fetchPosts(
        _currentPage,
        categoryId: _selectedCategoryId,
      ); // Pass categoryId
    }
  }

  // Method to handle category selection
  void _onCategorySelected(int? categoryId) {
    setState(() {
      _selectedCategoryId = categoryId; // Set the selected category
      _posts.clear(); // Clear existing posts
      _currentPage = 1; // Reset page
      _isLoadingMore = false; // Reset loading state
      _hasMorePosts = true; // Assume more posts for the new category
    });
    // Fetch posts for the newly selected category
    _fetchPosts(1, categoryId: _selectedCategoryId);
    _scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    ); // Scroll to top
  }

  // Modified _refreshPosts to include category filtering
  Future<void> _refreshPosts() async {
    setState(() {
      _posts.clear();
      _currentPage = 1;
      _isLoadingMore = false;
      _hasMorePosts = true;
      _futureBreakingNewsPosts = ApiService.fetchPosts(perPage: 5);
      _futureCategories = ApiService.fetchCategories(); // Re-fetch categories
    });
    await _fetchPosts(
      1,
      categoryId: _selectedCategoryId,
    ); // Re-fetch with current category
  }

  @override
  Widget build(BuildContext context) {
    // Get theme data from context
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        // Use theme colors for AppBar
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: theme.appBarTheme.elevation,
        centerTitle: true,
        title: Text(
          'News 24x365',
          style: theme.appBarTheme.titleTextStyle, // Use theme's titleTextStyle
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/logo.jpg',
          ), // Assuming this logo looks good in both themes
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color:
                  theme.appBarTheme.iconTheme?.color, // Use theme's icon color
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshPosts,
        // The Scaffold's background color is now handled by theme.scaffoldBackgroundColor
        // which we updated in app_themes.dart to be a subtle grey.
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breaking News/Fresh Stories Section
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  'Breaking News',
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    // No need to set color here, it inherits from theme.textTheme.headlineSmall
                  ),
                ),
              ),
              SizedBox(
                height: 380,
                child: FutureBuilder<List<Post>>(
                  future: _futureBreakingNewsPosts,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: colorScheme.primary,
                        ),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          "Error: ${snapshot.error}",
                          style: textTheme.bodyMedium,
                        ),
                      );
                    }
                    if (snapshot.data!.isEmpty) {
                      return Center(
                        child: Text(
                          "No breaking news found.",
                          style: textTheme.bodyMedium,
                        ),
                      );
                    }

                    final breakingNewsPosts = snapshot.data!;
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: breakingNewsPosts.length,
                      itemBuilder: (context, index) {
                        final post = breakingNewsPosts[index];
                        return Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          margin: const EdgeInsets.only(right: 12),
                          // PostTile will also need to be updated to use theme colors
                          child: PostTile(post: post),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Categories Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  'Categories',
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(
                  12.0,
                ), // Changed to const EdgeInsets.all for consistency
                child: SizedBox(
                  height: 50,
                  child: FutureBuilder<List<Category>>(
                    future: _futureCategories,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: colorScheme.primary,
                          ),
                        );
                      }
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            "Error: ${snapshot.error}",
                            style: textTheme.bodyMedium,
                          ),
                        );
                      }
                      if (snapshot.data!.isEmpty) {
                        return Center(
                          child: Text(
                            "No categories found.",
                            style: textTheme.bodyMedium,
                          ),
                        );
                      }

                      final categories = snapshot.data!;
                      // Add an "All" category at the beginning with a distinct ID (e.g., 0)
                      final allCategories = [
                        Category(id: 0, name: 'All'),
                        ...categories,
                      ];

                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: allCategories.length,
                        itemBuilder: (context, index) {
                          final category = allCategories[index];
                          // Determine if this category is currently selected
                          final isSelected =
                              (_selectedCategoryId == null &&
                                  category.id == 0) ||
                              (_selectedCategoryId == category.id &&
                                  category.id != 0);

                          return GestureDetector(
                            onTap: () {
                              // Call _onCategorySelected when a category is tapped
                              // Pass null for "All" category (id: 0)
                              _onCategorySelected(
                                category.id == 0 ? null : category.id,
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                // Use theme colors for category tags
                                color:
                                    isSelected
                                        ? colorScheme
                                            .primary // Primary color when selected
                                        : colorScheme
                                            .surface, // Surface color for unselected (white/dark grey)
                                borderRadius: BorderRadius.circular(20),
                                border:
                                    isSelected // Add a subtle border for unselected in dark mode if desired
                                        ? null
                                        : Border.all(
                                          color: theme.dividerColor,
                                        ), // Use divider color for border
                              ),
                              child: Center(
                                child: Text(
                                  category.name,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    // Text color based on selection and theme
                                    color:
                                        isSelected
                                            ? colorScheme
                                                .onPrimary // Text on primary color
                                            : colorScheme
                                                .onSurface, // Text on surface color
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Main Post List (Latest Stories)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  'Latest Stories',
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Conditional display for when _posts is empty (e.g., during category switch)
              if (_posts.isEmpty && !_isLoadingMore)
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: Text(
                      'No posts found for this category.',
                      style: textTheme.bodyMedium,
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _posts.length,
                  itemBuilder: (context, index) {
                    final post = _posts[index];
                    // PostTile will also need its colors updated
                    return PostTile(post: post);
                  },
                ),

              // Loading indicator at the bottom of the main list
              if (_isLoadingMore)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: colorScheme.primary,
                    ),
                  ),
                ),
              // Message when all posts are loaded
              if (!_hasMorePosts && _posts.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      'You\'ve reached the end of the posts!',
                      style: textTheme.bodySmall?.copyWith(
                        fontSize: 14,
                      ), // Use bodySmall or customize
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
