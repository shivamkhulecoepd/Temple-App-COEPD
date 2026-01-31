import 'dart:convert';

class UserModel {
  final int devoteeId;
  final String devoteeName;
  final String token;
  final String mobile;

  UserModel({
    required this.devoteeId,
    required this.devoteeName,
    required this.token,
    required this.mobile,
  });

  /// Create UserModel from login API response
  factory UserModel.fromJson(Map<String, dynamic> json, String mobile) {
    return UserModel(
      devoteeId: json['devotee_id'],
      devoteeName: json['devotee_name'],
      token: json['token'],
      mobile: mobile,
    );
  }

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'devotee_id': devoteeId,
      'devotee_name': devoteeName,
      'token': token,
      'mobile': mobile,
    };
  }

  /// Create from stored JSON string
  factory UserModel.fromStorage(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return UserModel(
      devoteeId: json['devotee_id'],
      devoteeName: json['devotee_name'],
      token: json['token'],
      mobile: json['mobile'],
    );
  }

  /// Convert to storage string
  String toStorageString() {
    return jsonEncode(toJson());
  }

  @override
  String toString() {
    return 'UserModel(devoteeId: $devoteeId, devoteeName: $devoteeName, mobile: $mobile)';
  }
}