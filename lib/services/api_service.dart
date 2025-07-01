// services/api_service.dart
import 'dart:convert';
import 'dart:math'; // Required for the 'min' function used in debugging print statements
import 'package:http/http.dart' as http;
import '../models/post_model.dart';
import '../models/category_model.dart'; // Ensure this is imported

class ApiService {
  static const String _baseUrl = 'https://news24x365.com/wp-json/wp/v2';

  // Updated fetchPosts to accept optional search query, page, perPage, and categoryId
  static Future<List<Post>> fetchPosts({
    String? search,
    int page = 1,
    int perPage = 10,
    int? categoryId, // New parameter for category filtering
  }) async {
    // Construct the base URL string.
    // Removed '_fields' to ensure full '_embedded' data (including featured media) is returned.
    String urlString = '$_baseUrl/posts?_embed';

    if (search != null && search.isNotEmpty) {
      urlString += '&search=$search';
    }

    if (categoryId != null) {
      // Add category filter if categoryId is provided
      urlString += '&categories=$categoryId';
    }

    // Add pagination parameters
    urlString += '&page=$page&per_page=$perPage';

    final url = Uri.parse(urlString);

    // Debugging: Print the full URL being fetched

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Debugging: Print the raw response body (first 500 characters for brevity)
        // This helps confirm if the '_embedded' data is truly present in the API response

        final List jsonData = json.decode(response.body);
        return jsonData.map((json) => Post.fromJson(json)).toList();
      } else {
        // More detailed error message for better debugging

        throw Exception('Failed to load posts: ${response.statusCode}');
      }
    } catch (e) {
      // Catch any network or parsing errors

      throw Exception('Error fetching posts: $e');
    }
  }

  // Existing method to fetch categories
  static Future<List<Category>> fetchCategories() async {
    final url = Uri.parse('$_baseUrl/categories?per_page=100');

    // Debugging: Print the URL being fetched

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List jsonData = json.decode(response.body);
        return jsonData.map((json) => Category.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }
}
