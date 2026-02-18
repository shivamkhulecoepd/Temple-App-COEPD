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
          // Handle both possible response formats for backward compatibility
          var dataResult = json['data'];
          if (dataResult is Map<String, dynamic>) {
            // Original format: {marquee_news: [...], banners: [...]}
            return dataResult;
          } else {
            // New format: banners are returned directly as a list
            // Return in the expected format {banners: [...], marquee_news: [...]}
            return {
              'banners': dataResult as List<dynamic>?,
              'marquee_news': [],
            };
          }
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
          .timeout(const Duration(seconds: 15));

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
        // return '6:00 AM – 12:30 PM | 4:00 PM – 8:00 PM';
        return 'Pull down for latest timings';
      }
    } catch (e) {
      log('fetchTempleTimings error: $e');
      // return '6:00 AM – 12:30 PM | 4:00 PM – 8:00 PM';
      return 'Pull down for latest timings';
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
  Future<List<dynamic>?> fetchLatestBanner() async {
    const String endpoint = 'latest_banner.php';

    try {
      final response = await http
          .get(Uri.parse(baseUrl + endpoint))
          .timeout(const Duration(seconds: 12));

      log('Latest Banner → Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;

        if (json['success'] == true) {
          // Updated to handle the new API response format - returns a list of banners
          return json['data'] as List<dynamic>?;
        }
      }
      return [];
    } catch (e) {
      log('fetchLatestBanner error: $e');
      return [];
    }
  }

  // ──────────────────────────────────────────────────────────────
  // 15. Fetch user's booking history (requires token)
  // ──────────────────────────────────────────────────────────────
  Future<List<dynamic>> fetchMyBookings(String token) async {
    const String endpoint = 'devotee_bookings.php';

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

  // ──────────────────────────────────────────────────────────────
  // 16. Fetch user's donation history (requires token)
  // ──────────────────────────────────────────────────────────────
  Future<List<dynamic>> fetchMyDonations(String token) async {
    const String endpoint = 'devotee_donations.php';

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

  // ──────────────────────────────────────────────────────────────
  // 17. Fetch current profile
  // ──────────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> fetchMyProfile(String token) async {
    const String endpoint = 'devotee_profile.php';

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

  // ──────────────────────────────────────────────────────────────
  // 18. Update profile (POST)
  // ──────────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> updateMyProfile({
    required String token,
    required String name,
    required String mobile,
    String? password,
    String? confirmPassword,
  }) async {
    const String endpoint = 'devotee_profile.php';

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

  // ──────────────────────────────────────────────────────────────
  // 19. Submit seva booking
  // ──────────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> submitSevaBooking({
    required String token,
    required int poojaId,
    required String devoteeName,
    String? gothram,
    String? nakshatram,
    required String mobile,
    String? email,
    required String bookingDate,
    required String bookingTime,
    required bool inPerson,
    required bool proxy,
    String? sankalpamName,
    String? purpose,
    required String prasadam,
    String? address,
    String? pincode,
    required double amount,
    required String paymentMethod,
  }) async {
    const String endpoint = 'book_seva.php';

    final body = {
      'pooja_id': poojaId,
      'devotee_name': devoteeName.trim(),
      'gothram': gothram?.trim() ?? '',
      'nakshatram': nakshatram?.trim() ?? '',
      'mobile': mobile.trim(),
      'email': email?.trim() ?? '',
      'booking_date': bookingDate,
      'booking_time': bookingTime,
      'in_person': inPerson ? 1 : 0,
      'proxy': proxy ? 1 : 0,
      'sankalpam_name': sankalpamName?.trim() ?? '',
      'purpose': purpose?.trim() ?? '',
      'prasadam': prasadam,
      'address': address?.trim() ?? '',
      'pincode': pincode?.trim() ?? '',
      'amount': amount,
      'payment_method': paymentMethod,
    };

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
          .timeout(const Duration(seconds: 20));

      log('Seva Booking Submit → Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['success'] == true) {
          return json;
        } else {
          throw Exception(json['message'] ?? 'Booking failed');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      log('submitSevaBooking error: $e');
      rethrow;
    }
  }

  // ──────────────────────────────────────────────────────────────
  // 20. Submit donation
  // ──────────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> submitDonation({
    required String token, // can be empty if not logged in
    required String donationType,
    String? sevaType,
    required String fullName,
    String? gotra,
    String? nakshatram,
    required String mobile,
    String? email,
    String? address,
    String? cityStatePin,
    String? preferredDate,
    String? sessionType,
    int personsCount = 0,
    String? occasion,
    String? sankalpam,
    required double amount,
  }) async {
    const String endpoint = 'submit_donation.php';

    final body = {
      'donation_type': donationType.trim(),
      'seva_type': sevaType?.trim(),
      'full_name': fullName.trim(),
      'gotra': gotra?.trim() ?? '',
      'nakshatram': nakshatram?.trim() ?? '',
      'mobile': mobile.trim(),
      'email': email?.trim() ?? '',
      'address': address?.trim() ?? '',
      'city_state_pin': cityStatePin?.trim() ?? '',
      'preferred_date': preferredDate?.trim() ?? '',
      'session_type': sessionType?.trim() ?? '',
      'persons_count': personsCount,
      'occasion': occasion?.trim() ?? '',
      'sankalpam': sankalpam?.trim() ?? '',
      'amount': amount,
    };

    try {
      final response = await http
          .post(
            Uri.parse(baseUrl + endpoint),
            headers: {
              'Content-Type': 'application/json',
              if (token.isNotEmpty) 'X-Devotee-Token': token,
            },
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 20));

      log('Donation Submit → Status: ${response.statusCode}');
      log('Donation Submit → Response Body: ${response.body}');

      if (response.statusCode == 200) {
        // Check if response is JSON
        if (!response.body.startsWith('{')) {
          throw Exception(
            'Server returned HTML instead of JSON. Please check server configuration.',
          );
        }

        final json = jsonDecode(response.body);
        if (json['success'] == true) {
          return json;
        } else {
          throw Exception(json['message'] ?? 'Donation failed');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      log('submitDonation error: $e');
      rethrow;
    }
  }

  // ──────────────────────────────────────────────────────────────
  // 21. Submit volunteer application
  // ──────────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> submitVolunteerApplication({
    required String fullName,
    required String email,
    required String contact,
    required String address,
    required String city,
    required String state,
    required String serviceDate, // format: YYYY-MM-DD
    required String serviceTime,
    required String service,
  }) async {
    const String endpoint = 'submit_volunteer.php';

    final body = {
      'full_name': fullName.trim(),
      'email': email.trim(),
      'contact': contact.trim(),
      'address': address.trim(),
      'city': city.trim(),
      'state': state.trim(),
      'service_date': serviceDate.trim(),
      'service_time': serviceTime.trim(),
      'service': service.trim(),
    };

    try {
      final response = await http
          .post(
            Uri.parse(baseUrl + endpoint),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 15));

      log('Volunteer Submit → Status: ${response.statusCode}');

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
      log('submitVolunteerApplication error: $e');
      rethrow;
    }
  }

  // ──────────────────────────────────────────────────────────────
  // 22. Send forgot password request
  // ──────────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> forgotPassword(String email) async {
    const String endpoint = 'forgot_password.php';

    final body = {'email': email.trim()};

    try {
      final response = await http
          .post(
            Uri.parse(baseUrl + endpoint),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 15));

      log('Forgot Password → Status: ${response.statusCode}');
      log('Forgot Password → Response: ${jsonDecode(response.body)}');
      log('RAW BODY: ${response.body}');

      // Process the response regardless of status code since API returns meaningful data for both 200 and 400
      if (response.body.startsWith('{')) {
        final json = jsonDecode(response.body);
        return json;
      } else {
        throw Exception('Invalid response format');
      }
    } catch (e) {
      log('forgotPassword error: $e');
      rethrow;
    }
  }

  // ──────────────────────────────────────────────────────────────
  // 23. Fetch upcoming events for Download Upcoming Events button in festivals screen
  // ──────────────────────────────────────────────────────────────
  Future<List<dynamic>> fetchUpcomingEvents() async {
    const String endpoint = 'upcoming_events.php';

    try {
      final response = await http
          .get(Uri.parse(baseUrl + endpoint))
          .timeout(const Duration(seconds: 12));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['success'] == true) {
          return json['data'] as List<dynamic>? ?? [];
        }
      }
      return [];
    } catch (e) {
      log('fetchUpcomingEvents error: $e');
      return [];
    }
  }
}
