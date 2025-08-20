import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static const String userIdKey = 'userId';
  static const String userDetailsKey = 'userDetails';
  static const String userEmailKey = 'userEmail';
  static const String userPasswordKey = 'userPassword';
  static const String educationDetailsKey = 'educationDetails';
  // Save the user ID to SharedPreferences
  Future<void> saveUserId(int userId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(userIdKey, userId);
  }

  // Retrieve the user ID from SharedPreferences
  Future<int?> getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(userIdKey);
  }

  // Clear the user ID from SharedPreferences
  Future<void> clearUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(userIdKey);
  }
  // Future<void> saveUserDetails(Map<String, dynamic> userDetails) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final String userDetailsJson = jsonEncode(userDetails);
  //   await prefs.setString(userDetailsKey, userDetailsJson);
  // }
  // Future<void> saveUserDetails(Map<String, dynamic> userDetails) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //
  //   // Ensure all keys exist in SharedPreferences by setting default values for nulls
  //   Map<String, dynamic> sanitizedDetails = userDetails.map((key, value) {
  //     return MapEntry(key, value ?? "N/A");
  //   });
  //
  //   final String userDetailsJson = jsonEncode(sanitizedDetails);
  //   await prefs.setString(SharedPreferencesService.userDetailsKey, userDetailsJson);
  //
  //   print("✅ User details saved in SharedPreferences: $sanitizedDetails");
  // }
  //
  // Future<Map<String, dynamic>?> getUserDetails() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final String? userDetailsJson = prefs.getString(userDetailsKey);
  //
  //   if (userDetailsJson != null) {
  //     return jsonDecode(userDetailsJson);
  //   }
  //   return null;
  // }
  Future<void> saveUserDetails(Map<String, dynamic> userDetails) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Ensure all keys exist in SharedPreferences by setting default values for nulls
    Map<String, dynamic> sanitizedDetails = userDetails.map((key, value) {
      return MapEntry(key, value ?? "N/A");
    });

    final String userDetailsJson = jsonEncode(sanitizedDetails);
    await prefs.setString(SharedPreferencesService.userDetailsKey, userDetailsJson);

    print("✅ User details saved in SharedPreferences: $sanitizedDetails");
  }

  Future<Map<String, dynamic>?> getUserDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userDetailsJson = prefs.getString(userDetailsKey);

    if (userDetailsJson != null) {
      return jsonDecode(userDetailsJson);
    }
    return null;
  }


  Future<void> saveUserCredentials(String email, String password) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(userEmailKey, email);
    await prefs.setString(userPasswordKey, password);
  }

  // ✅ Retrieve email and password
  Future<String?> getUserEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userEmailKey);
  }

  Future<String?> getUserPassword() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userPasswordKey);
  }
  Future<void> saveEducationDetails(Map<String, dynamic> educationDetails) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String educationDetailsJson = jsonEncode(educationDetails);
    await prefs.setString(educationDetailsKey, educationDetailsJson);
  }
  Future<Map<String, dynamic>?> getEducationDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? educationDetailsJson = prefs.getString(educationDetailsKey);

    if (educationDetailsJson != null) {
      return jsonDecode(educationDetailsJson);
    }
    return null;
  }


}





