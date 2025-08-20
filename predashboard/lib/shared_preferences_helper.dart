
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const String _tokenKey = 'authToken';
  static const String _profileIdKey = 'profileId';
  static const String _fullNameKey = 'fullName';
  static const String _uidKey = 'uid';
  static const String _enrollmentNumberKey = 'enrollmentNumber';
  static const String _interestedDomainKey = 'interestedDomain';
  static const String _discountedPriceKey = 'discountedPrice';
  static const String _MentorshipPriceKey= 'MentorshipPriceKey';
  static const String _CorporateTrainingKey='CorporatePricekey';

  // Save profile ID to SharedPreferences
  static Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  // 🔓 Retrieve token from SharedPreferences
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<void> clearAllFormData() async {
    final prefs = await SharedPreferences.getInstance();

    // List of all keys used across Step1, Step2, and Step3
    const formKeys = [
      // Step1 keys
      'fullName', 'fatherName', 'dob', 'state', 'city',
      'birthPlace', 'gender',

      // Step2 keys
      'email', 'phonenumber', 'isEmailVerified',

      // Step3 keys
      'collegeName', 'collegestate', 'collegecity',
      'degree', 'branch', 'year'
    ];

    // Remove each key
    for (final key in formKeys) {
      await prefs.remove(key);
    }
  }
  static Future<void> setProfileId(int profileId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_profileIdKey, profileId);
  }

  // Retrieve profile ID from SharedPreferences
  static Future<int?> getProfileId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_profileIdKey);
  }

  // Save full name to SharedPreferences
  static Future<void> setFullName(String fullName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_fullNameKey, fullName);
  }

  // Retrieve full name from SharedPreferences
  static Future<String?> getFullName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_fullNameKey);
  }

  // Save UID to SharedPreferences
  static Future<void> setUid(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_uidKey, uid);
  }

  // Retrieve UID from SharedPreferences
  static Future<String?> getUid() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_uidKey);
  }
  static Future<void> setEnrollmentNumber(String enrollmentNumber) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_enrollmentNumberKey, enrollmentNumber);
  }

  // Retrieve enrollment number from SharedPreferences
  static Future<String?> getEnrollmentNumber() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_enrollmentNumberKey);
  }
  static Future<void> setInterestedDomain(String domain) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_interestedDomainKey, domain);
  }

  // Retrieve interested domain from SharedPreferences
  static Future<String?> getInterestedDomain() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_interestedDomainKey);
  }
  static Future<void> setDiscountedPrice(double discountedPrice) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_discountedPriceKey, discountedPrice);
  }

  // Retrieve discounted price from SharedPreferences
  static Future<double?> getDiscountedPrice() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_discountedPriceKey);
  }
  static Future<void> setMentorshipDiscountedPrice(double MentorshipdiscountedPrice) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_MentorshipPriceKey, MentorshipdiscountedPrice);
  }

  // Retrieve discounted price from SharedPreferences
  static Future<double?> getMentorshipDiscountedPrice() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_MentorshipPriceKey);
  }
  static Future<void> setCorporateDiscountedPrice(double CorporatediscountedPrice) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_CorporateTrainingKey, CorporatediscountedPrice);
  }

  // Retrieve discounted price from SharedPreferences
  static Future<double?> getCorporateDiscountedPrice() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_CorporateTrainingKey);
  }
  static Future<void> setStringList(String key, List<String> values) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key, values);
  }

// Retrieve a list of strings from SharedPreferences
  static Future<List<String>?> getStringList(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key);
  }
}
