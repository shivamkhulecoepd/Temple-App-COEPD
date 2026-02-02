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

      if (!response.body.contains('{')) {
        throw Exception('Invalid response format');
      }

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

      if (!response.body.contains('{')) {
        throw Exception('Invalid response format');
      }

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
      'name': name.trim(),
      'phone': phone.trim(),
      'email': email?.trim() ?? '',
      'service': service?.trim() ?? '',
      'subject': subject?.trim() ?? '',
      'message': message.trim(),
    };

    try {
      final response = await http
          .post(
            Uri.parse(baseUrl + endpoint),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 15));

      log('Contact Submit → Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;

        if (json['success'] == true) {
          return json;
        } else {
          throw Exception(json['message'] ?? 'Submission failed');
        }
      } else {
        throw Exception(
          'Server error: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      log('submitContactForm error: $e');
      rethrow;
    }
  }

  // ──────────────────────────────────────────────────────────────
  // 9. Fetch all active events (for Upcoming Events panel)
  // ──────────────────────────────────────────────────────────────
  Future<List<dynamic>> fetchActiveEvents() async {
    const String endpoint = 'active_events.php';

    try {
      final response = await http
          .get(Uri.parse(baseUrl + endpoint))
          .timeout(const Duration(seconds: 15));

      log('Active Events → Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;

        if (json['success'] == true) {
          return json['data'] as List<dynamic>? ?? [];
        } else {
          throw Exception(json['message'] ?? 'API error');
        }
      } else {
        throw Exception('HTTP ${response.statusCode}');
      }
    } catch (e) {
      log('fetchActiveEvents error: $e');
      return [];
    }
  }

  // ──────────────────────────────────────────────────────────────
  // 10. Fetch active live stream settings (festival screen)
  // ──────────────────────────────────────────────────────────────
  Future<Map<String, dynamic>?> fetchLiveStreamSettings() async {
    const String endpoint = 'live_stream_settings.php';

    try {
      final response = await http
          .get(Uri.parse(baseUrl + endpoint))
          .timeout(const Duration(seconds: 12));

      log('Live Stream Settings → Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;

        if (json['success'] == true) {
          return json['data'] as Map<String, dynamic>?;
        }
      }
      return null;
    } catch (e) {
      log('fetchLiveStreamSettings error: $e');
      return null;
    }
  }

  // ──────────────────────────────────────────────────────────────
  // 11. Fetch gallery images by category (explore media screen)
  // ──────────────────────────────────────────────────────────────
  Future<List<dynamic>> fetchGalleryImages({
    String category = 'festivals',
  }) async {
    const String endpoint = 'gallery_images.php';

    final uri = Uri.parse(
      (baseUrl + endpoint),
    ).replace(queryParameters: {'category': category});

    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 15));

      log('Gallery Images ($category) → Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;

        if (json['success'] == true) {
          return json['data'] as List<dynamic>? ?? [];
        } else {
          log('API message: ${json['message']}');
          return [];
        }
      } else {
        throw Exception('HTTP ${response.statusCode}');
      }
    } catch (e) {
      log('fetchGalleryImages error ($category): $e');
      return [];
    }
  }

  // ──────────────────────────────────────────────────────────────
  // 12. Fetch archive videos by category (explore media screen)
  // ──────────────────────────────────────────────────────────────
  Future<List<dynamic>> fetchArchiveVideosByCategory({
    String category = 'festivals',
  }) async {
    const String endpoint = 'archive_videos_by_category.php';
    final uri = Uri.parse(
      (baseUrl + endpoint),
    ).replace(queryParameters: {'category': category});

    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 15));

      log('Archive Videos ($category) → Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;

        if (json['success'] == true) {
          return json['data'] as List<dynamic>? ?? [];
        } else {
          log('API message: ${json['message']}');
          return [];
        }
      } else {
        throw Exception('HTTP ${response.statusCode}');
      }
    } catch (e) {
      log('fetchArchiveVideosByCategory error ($category): $e');
      return [];
    }
  }

  // ──────────────────────────────────────────────────────────────
  // 13. Fetch all notices/announcements (News and Notices screen)
  // ──────────────────────────────────────────────────────────────
  Future<List<dynamic>> fetchNotices() async {
    const String endpoint = 'notices.php';

    try {
      final response = await http
          .get(Uri.parse(baseUrl + endpoint))
          .timeout(const Duration(seconds: 12));

      log('Notices → Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;

        if (json['success'] == true) {
          return json['data'] as List<dynamic>? ?? [];
        }
      }
      return [];
    } catch (e) {
      log('fetchNotices error: $e');
      return [];
    }
  }

  // ──────────────────────────────────────────────────────────────
  // 14. Fetch latest active banner (News and Notices screen)
  // ──────────────────────────────────────────────────────────────
  Future<Map<String, dynamic>?> fetchLatestBanner() async {
    const String endpoint = 'latest_banner.php';

    try {
      final response = await http
          .get(Uri.parse(baseUrl + endpoint))
          .timeout(const Duration(seconds: 12));

      log('Latest Banner → Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;

        if (json['success'] == true) {
          return json['data'] as Map<String, dynamic>?;
        }
      }
      return null;
    } catch (e) {
      log('fetchLatestBanner error: $e');
      return null;
    }
  }

  // Fetch user's booking history (requires token)
  Future<List<dynamic>> fetchMyBookings(String token) async {
    const String endpoint = 'my_bookings.php';

    try {
      final response = await http
          .get(
            Uri.parse(baseUrl + endpoint),
            headers: {
              'X-Devotee-Token': token, // Send token in header
            },
          )
          .timeout(const Duration(seconds: 12));

      log('My Bookings → Status: ${response.statusCode}');
      log('My Bookings → Data: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;

        if (json['success'] == true) {
          return json['data'] as List<dynamic>? ?? [];
        } else {
          throw Exception(json['message'] ?? 'Failed to fetch bookings');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      log('fetchMyBookings error: $e');
      rethrow;
    }
  }

  // Fetch user's donation history (requires token)
  Future<List<dynamic>> fetchMyDonations(String token) async {
    const String endpoint = 'my_donations.php';

    try {
      final response = await http
          .get(
            Uri.parse(baseUrl + endpoint),
            headers: {'X-Devotee-Token': token},
          )
          .timeout(const Duration(seconds: 12));

      log('My Donations → Status: ${response.statusCode}');
      log('My Donations → Data: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;

        if (json['success'] == true) {
          return json['data'] as List<dynamic>? ?? [];
        } else {
          throw Exception(json['message'] ?? 'Failed to fetch donations');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      log('fetchMyDonations error: $e');
      rethrow;
    }
  }

  // Fetch current profile
  Future<Map<String, dynamic>> fetchMyProfile(String token) async {
    const String endpoint = 'my_profile.php';

    try {
      final response = await http
          .get(
            Uri.parse(baseUrl + endpoint),
            headers: {'X-Devotee-Token': token},
          )
          .timeout(const Duration(seconds: 12));

      log('My Profile GET → Status: ${response.statusCode}');
      log('My Profile GET → Body: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['success'] == true) {
          return json['data'] as Map<String, dynamic>;
        } else {
          throw Exception(json['message'] ?? 'Failed to fetch profile');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      log('fetchMyProfile error: $e');
      rethrow;
    }
  }

  // Update profile (POST)
  Future<Map<String, dynamic>> updateMyProfile({
    required String token,
    required String name,
    required String mobile,
    String? password,
    String? confirmPassword,
  }) async {
    const String endpoint = 'my_profile.php';

    final body = {'name': name.trim(), 'mobile': mobile.trim()};

    if (password != null && password.isNotEmpty) {
      if (password != confirmPassword) {
        throw Exception('Passwords do not match');
      }
      body['password'] = password;
      body['confirm_password'] = confirmPassword ?? '';
    }

    try {
      final response = await http
          .post(
            Uri.parse(baseUrl + endpoint),
            headers: {
              'Content-Type': 'application/json',
              'X-Devotee-Token': token,
            },
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 15));

      log('My Profile POST → Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['success'] == true) {
          return json;
        } else {
          throw Exception(json['message'] ?? 'Update failed');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      log('updateMyProfile error: $e');
      rethrow;
    }
  }
}
