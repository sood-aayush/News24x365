// post_model.dart
import 'package:html/parser.dart' show parse; // Import for HTML parsing

class Post {
  final int id;
  final String title;
  final String excerpt;
  final String content;
  final String date;
  final String link;
  final String imageUrl;

  Post({
    required this.id,
    required this.title,
    required this.excerpt,
    required this.content,
    required this.date,
    required this.link,
    required this.imageUrl,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    String imageUrl = ''; // Initialize imageUrl as empty string

    // Get rendered content and title safely
    final String postContent = json['content']?['rendered'] ?? '';
    final String postTitle = json['title']?['rendered'] ?? '';
    final String postExcerpt = json['excerpt']?['rendered'] ?? '';
    final String postDate = json['date'] ?? '';
    final String postLink = json['link'] ?? '';

    // --- Image URL Extraction Logic (Prioritized) ---

    // 1. Try to get featured media from '_embedded' (most common and reliable for featured images)
    if (json['_embedded'] != null &&
        json['_embedded']['wp:featuredmedia'] != null &&
        (json['_embedded']['wp:featuredmedia'] as List).isNotEmpty) {
      final featuredMedia = json['_embedded']['wp:featuredmedia'][0];
      if (featuredMedia['source_url'] != null) {
        imageUrl = featuredMedia['source_url'];
      }
      // Fallback within _embedded if source_url is not directly present (less common, but good to have)
      else if (featuredMedia['media_details'] != null &&
          featuredMedia['media_details']['sizes'] != null &&
          featuredMedia['media_details']['sizes']['full'] != null &&
          featuredMedia['media_details']['sizes']['full']['source_url'] !=
              null) {
        imageUrl =
            featuredMedia['media_details']['sizes']['full']['source_url'];
      }
    }

    // 2. Fallback: Check for 'jetpack_featured_media_url' (often present if Jetpack plugin is used)
    if (imageUrl.isEmpty && json['jetpack_featured_media_url'] != null) {
      imageUrl = json['jetpack_featured_media_url'] as String;
    }

    // 3. Fallback: Check for 'featured_image_src' (sometimes added directly by themes/plugins for convenience)
    // Note: The provided JSON for ID 35099 actually has this field!
    if (imageUrl.isEmpty && json['featured_image_src'] != null) {
      imageUrl = json['featured_image_src'] as String;
    }

    // 4. Fallback: Parse the first <img> tag from content if no featured image was found above
    // This is typically for images *within* the post body, but can serve as a last resort
    // for a thumbnail if no featured image is explicitly set or retrieved.
    if (imageUrl.isEmpty && postContent.isNotEmpty) {
      final document = parse(postContent);
      final imgTags = document.querySelectorAll('img');
      if (imgTags.isNotEmpty) {
        imageUrl = imgTags.first.attributes['src'] ?? '';
      }
    }

    // IMPORTANT: Add this print statement for debugging!
    // This will show you exactly what URL is being extracted for each post.

    return Post(
      id: json['id'],
      title: postTitle,
      excerpt: postExcerpt,
      content: postContent,
      date: postDate,
      link: postLink,
      imageUrl: imageUrl, // Assign the extracted URL to the imageUrl property
    );
  }
}
