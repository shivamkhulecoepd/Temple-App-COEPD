import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class DBFunctions {
  static const String apiUrl = 'https://marakatasrilaxmiganapathi.org/api/';

  Future<Map<String, dynamic>> fetchMarqueeAndBanners() async {
    const String apiFile = 'marquee_and_banners.php';
    try {
      final response = await http.get(Uri.parse(apiUrl + apiFile));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true) {
          return data['data'];
        } else {
          throw Exception(data['message'] ?? 'API returned error');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      // Handle in UI (show snackbar, etc.)
      rethrow;
    }
  }

  Future<String> fetchTempleTimings() async {
    const String apiFile = 'temple_timings.php';
    try {
      final response = await http
          .get(Uri.parse(apiUrl + apiFile))
          .timeout(const Duration(seconds: 12));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;

        // Safely access nested keys
        final success = data['success'] as bool? ?? false;
        final timingsData = data['data'] as Map<String, dynamic>?;

        if (success &&
            timingsData != null &&
            timingsData.containsKey('timings')) {
          final timings = timingsData['timings'];
          if (timings is String) {
            return timings;
          } else {
            return timings.toString(); // fallback if somehow not string
          }
        } else {
          // Return fallback from API or hardcoded
          return timingsData?['timings']?.toString() ?? 'Timings not available';
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      log('Timings fetch error: $e');
      // Always return a fallback string — never let it crash the UI
      return '6:00 AM – 12:30 PM | 4:00 PM – 8:00 PM';
    }
  }
}
