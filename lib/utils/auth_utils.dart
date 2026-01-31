import 'dart:developer';
import 'package:mslgd/models/user_model.dart';
import 'package:mslgd/services/storage_service.dart';

class AuthUtils {
  static final StorageService _storageService = StorageService();

  /// Get current logged in user
  static Future<UserModel?> getCurrentUser() async {
    try {
      final isLoggedIn = await _storageService.isUserLoggedIn();
      if (!isLoggedIn) return null;

      final userDataString = await _storageService.getUserData();
      if (userDataString != null) {
        return UserModel.fromStorage(userDataString);
      }
      return null;
    } catch (e) {
      log('Error getting current user: $e');
      return null;
    }
  }

  /// Get user token
  static Future<String?> getUserToken() async {
    try {
      return await _storageService.getUserToken();
    } catch (e) {
      log('Error getting user token: $e');
      return null;
    }
  }

  /// Check if user is logged in
  static Future<bool> isLoggedIn() async {
    try {
      return await _storageService.isUserLoggedIn();
    } catch (e) {
      log('Error checking login status: $e');
      return false;
    }
  }

  /// Get user ID
  static Future<int?> getUserId() async {
    final user = await getCurrentUser();
    return user?.devoteeId;
  }

  /// Get user name
  static Future<String?> getUserName() async {
    final user = await getCurrentUser();
    return user?.devoteeName;
  }

  /// Get user mobile
  static Future<String?> getUserMobile() async {
    final user = await getCurrentUser();
    return user?.mobile;
  }
}