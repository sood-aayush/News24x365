import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/post_model.dart';
import 'package:share_plus/share_plus.dart';

class PostDetailScreen extends StatelessWidget {
  final Post post;

  const PostDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    // Get theme data and color scheme from context
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        // Use theme's AppBar background color
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: theme.appBarTheme.elevation, // Use theme's elevation
        centerTitle: true,
        title: Text(
          '📰 News 24x365',
          // Use the app bar's title text style defined in app_themes.dart
          style: theme.appBarTheme.titleTextStyle,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.share,
              // Use the app bar's icon theme color
              color: theme.appBarTheme.iconTheme?.color,
            ),
            onPressed: () {
              Share.share(post.link, subject: post.title);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Image
            if (post.imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(16),
                ),
                child: CachedNetworkImage(
                  imageUrl: post.imageUrl,
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                  placeholder:
                      (context, url) => Container(
                        height: 220,
                        // Use theme's background color with slight opacity
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
                        height: 220,
                        // Use theme's surface color for error container
                        color: colorScheme.surface,
                        child: Icon(
                          Icons.broken_image,
                          size: 50,
                          color: colorScheme.onSurface.withOpacity(
                            0.5,
                          ), // Subtle color for broken image icon
                        ),
                      ),
                ),
              )
            else // Display asset image if post.imageUrl is empty
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(16),
                ),
                child: Container(
                  color:
                      colorScheme
                          .surface, // Use theme's surface for no-image background
                  child: Image.asset(
                    'assets/logo.jpg', // Your asset image path
                    width: double.infinity,
                    height: 220, // Keep height consistent with network image
                    fit:
                        BoxFit
                            .contain, // Use contain to ensure logo isn't cropped
                    errorBuilder:
                        (context, error, stackTrace) => Container(
                          width: double.infinity,
                          height: 220,
                          color:
                              colorScheme
                                  .surface, // Error container color for asset
                          child: Icon(
                            Icons.error,
                            size: 50,
                            color: colorScheme.error, // Use theme's error color
                          ),
                        ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.date.split("T").first,
                    // Use theme's bodySmall for date style
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withOpacity(
                        0.6,
                      ), // Subtle date color
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    post.title,
                    // Use theme's headlineSmall for titles, with onSurface color
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      height: 1.3,
                      color: colorScheme.onSurface, // Main text color
                    ),
                  ),
                  const SizedBox(height: 20),
                  Html(
                    data: post.content,
                    style: {
                      "body": Style(
                        fontSize: FontSize(16),
                        lineHeight: LineHeight.number(1.5),
                        margin: Margins.all(0),
                        padding: HtmlPaddings.all(0),
                        // Set text color for HTML content to match theme
                        color: colorScheme.onSurface,
                      ),
                      "p": Style(margin: Margins.only(bottom: 16)),
                      // You can add more specific styles for other HTML tags if needed,
                      // ensuring their colors also match colorScheme.onSurface or similar.
                      // For example, for links:
                      "a": Style(
                        color:
                            colorScheme
                                .primary, // Use theme's primary color for links
                      ),
                      // "img": Style(
                      //   width: Width(double.maxFinite),
                      //   display: Display.block,
                      //   margin: Margins.all(CssLength.auto()),
                      // ),
                    },
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
