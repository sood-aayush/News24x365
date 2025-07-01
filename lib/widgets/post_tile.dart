import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/post_model.dart';
import '../screens/post_detail_screen.dart';
import '../services/favorites_service.dart';

class PostTile extends StatefulWidget {
  final Post post;
  const PostTile({super.key, required this.post});

  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadFavorite();
  }

  void _loadFavorite() async {
    final fav = await FavoritesService.isFavorite(widget.post.id);
    if (mounted) setState(() => isFavorite = fav);
  }

  void _toggleFavorite() async {
    await FavoritesService.toggleFavorite(widget.post.id);
    final updated = await FavoritesService.isFavorite(widget.post.id);
    if (mounted) setState(() => isFavorite = updated);
  }

  String cleanExcerpt(String rawExcerpt) {
    final withoutHtml = rawExcerpt.replaceAll(RegExp(r'<[^>]*>'), '');
    var decoded =
        withoutHtml
            .replaceAll('&hellip;', '...')
            .replaceAll('&nbsp;', ' ')
            .replaceAll('&amp;', '&')
            .trim();

    if (decoded.endsWith('[...]')) {
      decoded = decoded.replaceAll(RegExp(r'\[\.\.\.\]$'), '...');
    }

    return decoded;
  }

  @override
  Widget build(BuildContext context) {
    // Get theme data and color scheme from context
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PostDetailScreen(post: widget.post),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          // Use theme's surface color for card background
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          // Use theme's divider color for border
          border: Border.all(color: theme.dividerColor),
          boxShadow: [
            BoxShadow(
              // Adjust shadow color based on theme brightness
              color:
                  theme.brightness == Brightness.light
                      ? Colors.grey.withOpacity(
                        0.2,
                      ) // Lighter shadow for light mode
                      : Colors.black.withOpacity(
                        0.3,
                      ), // Darker shadow for dark mode
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(14),
              ),
              child:
                  widget.post.imageUrl.isNotEmpty
                      ? CachedNetworkImage(
                        imageUrl: widget.post.imageUrl,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                        placeholder:
                            (context, url) => Container(
                              height: 200,
                              // Use theme's background color with slight transparency or a light variant
                              color: colorScheme.background.withOpacity(0.8),
                              child: Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color:
                                      colorScheme
                                          .primary, // Use primary color for indicator
                                ),
                              ),
                            ),
                        errorWidget:
                            (context, url, error) => Container(
                              height: 200,
                              // Use theme's surface color or background for error container
                              color: colorScheme.surface,
                              child: Icon(
                                Icons.broken_image,
                                size: 50,
                                color: colorScheme.onSurface.withOpacity(
                                  0.5,
                                ), // Use a less prominent color
                              ),
                            ),
                      )
                      : Container(
                        // Placeholder when no image is available
                        color:
                            colorScheme
                                .background, // Use theme's background color
                        child: Image.asset(
                          'assets/logo.jpg', // Your asset image path
                          width: double.infinity,
                          height: 180, // Slightly smaller for the logo
                          fit:
                              BoxFit
                                  .contain, // Use contain to ensure logo isn't cropped
                          errorBuilder:
                              (context, error, stackTrace) => Container(
                                width: double.infinity,
                                height: 180,
                                color:
                                    colorScheme
                                        .surface, // Error container color
                                child: Icon(
                                  Icons.error,
                                  size: 50,
                                  color:
                                      colorScheme
                                          .error, // Use theme's error color
                                ),
                              ),
                        ),
                      ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.post.title,
                          // Use theme's titleLarge or a custom style with onSurface color
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color:
                                colorScheme
                                    .onSurface, // Text color for main content
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        onPressed: _toggleFavorite,
                        icon: Icon(
                          isFavorite ? Icons.star : Icons.star_border,
                          // Use theme's primary/secondary for favorite, and onSurface for unfavorite
                          color:
                              isFavorite
                                  ? colorScheme.primary
                                  : colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    cleanExcerpt(widget.post.excerpt),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(
                        0.8,
                      ), // Slightly less prominent than title
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.post.date.split("T").first,
                    // Use theme's bodySmall or a custom style for date
                    style: textTheme.bodySmall?.copyWith(
                      fontSize: 12,
                      color: colorScheme.onSurface.withOpacity(
                        0.6,
                      ), // Subtle date color
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
