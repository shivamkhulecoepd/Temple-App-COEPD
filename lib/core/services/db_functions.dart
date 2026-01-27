import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class DBFunctions {
  static const String baseUrl = 'https://marakatasrilaxmiganapathi.org/api/';

  // ──────────────────────────────────────────────────────────────
  // 1. Marquee News + Banners
  // ──────────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> fetchMarqueeAndBanners() async {
    const String endpoint = 'marquee_and_banners.php';

    try {
      final response = await http
          .get(Uri.parse(baseUrl + endpoint))
          .timeout(const Duration(seconds: 15));

      log('Marquee & Banners → Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;

        if (json['success'] == true) {
          return json['data'] as Map<String, dynamic>;
        } else {
          throw Exception(json['message'] ?? 'API returned failure');
        }
      } else {
        throw Exception('HTTP ${response.statusCode}');
      }
    } catch (e) {
      log('fetchMarqueeAndBanners error: $e');
      rethrow;
    }
  }

  // ──────────────────────────────────────────────────────────────
  // 2. Temple Timings
  // ──────────────────────────────────────────────────────────────
  Future<String> fetchTempleTimings() async {
    const String endpoint = 'temple_timings.php';

    try {
      final response = await http
          .get(Uri.parse(baseUrl + endpoint))
          .timeout(const Duration(seconds: 12));

      log('Timings → Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;

        final success = json['success'] as bool? ?? false;
        final data = json['data'] as Map<String, dynamic>?;

        if (success && data != null && data['timings'] is String) {
          return data['timings'] as String;
        }

        return data?['timings']?.toString() ?? 'Timings not available';
      } else {
        log('Timings failed: ${response.statusCode}');
        return '6:00 AM – 12:30 PM | 4:00 PM – 8:00 PM';
      }
    } catch (e) {
      log('fetchTempleTimings error: $e');
      return '6:00 AM – 12:30 PM | 4:00 PM – 8:00 PM';
    }
  }

  // ──────────────────────────────────────────────────────────────
  // 3. Live Stream Settings
  // ──────────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> fetchLiveStream() async {
    const String endpoint = 'live_stream.php';

    try {
      final response = await http
          .get(Uri.parse(baseUrl + endpoint))
          .timeout(const Duration(seconds: 15));

      log('Live Stream → Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;

        if (json['success'] == true) {
          return json['data'] as Map<String, dynamic>;
        } else {
          throw Exception(json['message'] ?? 'API returned failure');
        }
      } else {
        throw Exception('HTTP ${response.statusCode}');
      }
    } catch (e) {
      log('fetchLiveStream error: $e');
      rethrow;
    }
  }

  // ──────────────────────────────────────────────────────────────
  // 4. Upcoming Event
  // ──────────────────────────────────────────────────────────────
  Future<Map<String, dynamic>?> fetchUpcomingEvent() async {
    const String endpoint = 'upcoming_event.php';

    try {
      final response = await http
          .get(Uri.parse(baseUrl + endpoint))
          .timeout(const Duration(seconds: 12));

      log('Upcoming Event → Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;

        if (json['success'] == true) {
          return json['data'] as Map<String, dynamic>?;
        }
      }
      return null;
    } catch (e) {
      log('fetchUpcomingEvent error: $e');
      return null;
    }
  }

  // ──────────────────────────────────────────────────────────────
  // 5. Archive Videos
  // ──────────────────────────────────────────────────────────────
  Future<List<dynamic>> fetchArchiveVideos() async {
    const String endpoint = 'archive_videos.php';

    try {
      final response = await http
          .get(Uri.parse(baseUrl + endpoint))
          .timeout(const Duration(seconds: 15));

      log('Archive Videos → Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;

        if (json['success'] == true) {
          return json['data'] as List<dynamic>? ?? [];
        }
      }
      return [];
    } catch (e) {
      log('fetchArchiveVideos error: $e');
      return [];
    }
  }

  // ──────────────────────────────────────────────────────────────
  // 6. Active Poojas / Sevas
  // ──────────────────────────────────────────────────────────────
  Future<List<dynamic>> fetchActivePoojas() async {
    const String endpoint = 'active_poojas.php';

    try {
      final response = await http
          .get(Uri.parse(baseUrl + endpoint))
          .timeout(const Duration(seconds: 15));

      log('Active Poojas → Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;

        if (json['success'] == true) {
          return json['data'] as List<dynamic>? ?? [];
        }
      }
      return [];
    } catch (e) {
      log('fetchActivePoojas error: $e');
      return [];
    }
  }

  // ──────────────────────────────────────────────────────────────
  // 7. Contact Info (new - from latest contact page)
  // ──────────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> fetchContactInfo() async {
    const String endpoint = 'contact_info.php';

    try {
      final response = await http
          .get(Uri.parse(baseUrl + endpoint))
          .timeout(const Duration(seconds: 12));

      log('Contact Info → Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;

        if (json['success'] == true) {
          return json['data'] as Map<String, dynamic>;
        } else {
          throw Exception(json['message'] ?? 'API returned failure');
        }
      } else {
        throw Exception('HTTP ${response.statusCode}');
      }
    } catch (e) {
      log('fetchContactInfo error: $e');
      rethrow;
    }
  }

  // ──────────────────────────────────────────────────────────────
  // 8. Submit contact form
  // ──────────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> submitContactForm({
    required String name,
    required String phone,
    String? email,
    String? service,
    String? subject,
    required String message,
  }) async {
    const String endpoint = 'contact_submit.php';

    final body = {
      'name': name,
      'phone': phone,
      'email': email ?? '',
      'service': service ?? '',
      'subject': subject ?? '',
      'message': message,
    };

    try {
      final response = await http
          .post(
            Uri.parse(baseUrl + endpoint),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['success'] == true) {
          return json;
        } else {
          throw Exception(json['message'] ?? 'Submission failed');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      log('Contact submit error: $e');
      rethrow;
    }
  }
}

// import 'dart:convert';
// import 'dart:developer';
// import 'package:http/http.dart' as http;

// class DBFunctions {
//   static const String apiUrl = 'https://marakatasrilaxmiganapathi.org/api/';

//   Future<Map<String, dynamic>> fetchMarqueeAndBanners() async {
//     const String apiFile = 'marquee_and_banners.php';
//     try {
//       final response = await http.get(Uri.parse(apiUrl + apiFile));

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);

//         if (data['success'] == true) {
//           return data['data'];
//         } else {
//           throw Exception(data['message'] ?? 'API returned error');
//         }
//       } else {
//         throw Exception('Server error: ${response.statusCode}');
//       }
//     } catch (e) {
//       // Handle in UI (show snackbar, etc.)
//       rethrow;
//     }
//   }

//   Future<String> fetchTempleTimings() async {
//     const String apiFile = 'temple_timings.php';
//     try {
//       final response = await http
//           .get(Uri.parse(apiUrl + apiFile))
//           .timeout(const Duration(seconds: 12));

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body) as Map<String, dynamic>;

//         // Safely access nested keys
//         final success = data['success'] as bool? ?? false;
//         final timingsData = data['data'] as Map<String, dynamic>?;

//         if (success &&
//             timingsData != null &&
//             timingsData.containsKey('timings')) {
//           final timings = timingsData['timings'];
//           if (timings is String) {
//             return timings;
//           } else {
//             return timings.toString(); // fallback if somehow not string
//           }
//         } else {
//           // Return fallback from API or hardcoded
//           return timingsData?['timings']?.toString() ?? 'Timings not available';
//         }
//       } else {
//         throw Exception('Server error: ${response.statusCode}');
//       }
//     } catch (e) {
//       log('Timings fetch error: $e');
//       // Always return a fallback string — never let it crash the UI
//       return '6:00 AM – 12:30 PM | 4:00 PM – 8:00 PM';
//     }
//   }

//   // 1. Live Stream
//   Future<Map<String, dynamic>> fetchLiveStream() async {
//     const String apiFile = 'live_stream.php';
//     final res = await http.get(Uri.parse(apiUrl + apiFile));
//     if (res.statusCode == 200) {
//       final json = jsonDecode(res.body);
//       if (json['success'] == true) return json['data'];
//     }
//     throw Exception('Failed to load live stream');
//   }

//   // 2. Upcoming Event
//   Future<Map<String, dynamic>?> fetchUpcomingEvent() async {
//     const String apiFile = 'upcoming_event.php';
//     final res = await http.get(Uri.parse(apiUrl + apiFile));
//     if (res.statusCode == 200) {
//       final json = jsonDecode(res.body);
//       if (json['success'] == true) return json['data'];
//     }
//     return null; // null = no upcoming event
//   }

//   // 3. Archive Videos
//   Future<List<dynamic>> fetchArchiveVideos() async {
//     const String apiFile = 'archive_videos.php';
//     final res = await http.get(Uri.parse(apiUrl + apiFile));
//     if (res.statusCode == 200) {
//       final json = jsonDecode(res.body);
//       if (json['success'] == true) return json['data'];
//     }
//     return [];
//   }

//   // 4. Active Poojas/Sevas
//   Future<List<dynamic>> fetchActivePoojas() async {
//     const String apiFile = 'active_poojas.php';
//     final res = await http.get(Uri.parse(apiUrl + apiFile));
//     if (res.statusCode == 200) {
//       final json = jsonDecode(res.body);
//       if (json['success'] == true) return json['data'];
//     }
//     return [];
//   }

//   // Fetch contact info
//   Future<Map<String, dynamic>> fetchContactInfo() async {
//     const String endpoint = 'contact_info.php';
//     final data = await _fetchData(endpoint);
//     return data['data'] as Map<String, dynamic>? ?? {};
//   }

//   // Submit contact form
//   Future<Map<String, dynamic>> submitContactForm({
//     required String name,
//     required String phone,
//     String? email,
//     String? service,
//     String? subject,
//     required String message,
//   }) async {
//     const String endpoint = 'contact_submit.php';

//     final body = {
//       'name': name,
//       'phone': phone,
//       'email': email ?? '',
//       'service': service ?? '',
//       'subject': subject ?? '',
//       'message': message,
//     };

//     try {
//       final response = await http
//           .post(
//             Uri.parse(baseUrl + endpoint),
//             headers: {'Content-Type': 'application/json'},
//             body: jsonEncode(body),
//           )
//           .timeout(const Duration(seconds: 15));

//       if (response.statusCode == 200) {
//         final json = jsonDecode(response.body);
//         if (json['success'] == true) {
//           return json;
//         } else {
//           throw Exception(json['message'] ?? 'Submission failed');
//         }
//       } else {
//         throw Exception('Server error: ${response.statusCode}');
//       }
//     } catch (e) {
//       log('Contact submit error: $e');
//       rethrow;
//     }
//   }
// }
