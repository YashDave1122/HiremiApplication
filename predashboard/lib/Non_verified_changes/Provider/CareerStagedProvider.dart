import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pre_dashboard/API.dart';
import 'package:pre_dashboard/shared_preferences_helper.dart';

class CareerStageProvider with ChangeNotifier {
  String? _careerStage;
  int? _registerId;

  String? get careerStage => _careerStage;
  int? get registerId => _registerId;


  // Future<void> fetchCareerStage(int userId) async {
  //   const url = ApiUrls.registration;
  //
  //   try {
  //     final response = await http.get(Uri.parse(url));
  //     if (response.statusCode == 200) {
  //       final List<dynamic> data = json.decode(response.body);
  //
  //       // Find the entry where register matches userId
  //       final matchingEntry = data.firstWhere(
  //             (entry) => int.tryParse(entry['register'].toString()) == userId,
  //         orElse: () => null,
  //       );
  //
  //       if (matchingEntry != null) {
  //         print("Matching entry is $matchingEntry");
  //         _careerStage = matchingEntry['career_stage'];
  //         _registerId = userId;
  //       } else {
  //         _careerStage = null; // No matching entry found
  //         _registerId = null;
  //       }
  //
  //       notifyListeners();
  //     } else {
  //       print("Response body is ${response.body}");
  //       print("Response status code is ${response.statusCode}");
  //
  //       throw Exception('Failed to fetch career stage');
  //     }
  //   } catch (e) {
  //     debugPrint('Error fetching career stage: $e');
  //   }
  // }
  Future<void> fetchCareerStage(int userId) async {
    print("SXSXS");
    const url = ApiUrls.registration;

    try {
      // 🔑 Get token from SharedPreferences
      final String? token = await SharedPreferencesHelper.getToken();

      if (token == null) {
        debugPrint('Token not found. User might not be logged in.');
        throw Exception('Authentication token missing');
      }

      // 🔐 GET request with Authorization header
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        // 🔍 Find the entry where register matches userId
        final matchingEntry = data.firstWhere(
              (entry) => int.tryParse(entry['id'].toString()) == userId,
          orElse: () => null,
        );

        if (matchingEntry != null) {
          print("Matching entry is $matchingEntry");
          _careerStage = matchingEntry['career_stage'];
          _registerId = userId;
        } else {
          _careerStage = null; // No matching entry found
          _registerId = null;
        }

        notifyListeners();
      } else {
        print("Response body is ${response.body}");
        print("Response status code is ${response.statusCode}");
        throw Exception('Failed to fetch career stage');
      }
    } catch (e) {
      debugPrint('Error fetching career stage: $e');
    }
  }

  Future<String?> loginUser(String email, String password) async {
    final response = await http.post(
      Uri.parse(ApiUrls.Login), // Replace with actual login endpoint
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("Response body is ${response.body}");
      print("Response code is ${response.statusCode}");

      final token = data['access_token']; // Assuming your API returns a token

      print("Token: $token");
      return token;
    } else {
      print("Login failed: ${response.body}");
      return null;
    }
  }



  Future<void> saveCareerStage(String careerStage, int registerId) async {
    const url = ApiUrls.registration;

    try {
      final String? token = await SharedPreferencesHelper.getToken();

      if (token == null) {
        throw Exception('No token found. Please login again.');
      }

      // ✅ GET request now includes Authorization header
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        final existingEntry = data.firstWhere(
              (entry) => int.tryParse(entry['id'].toString()) == registerId,
          orElse: () => null,
        );

        if (existingEntry != null) {
          final patchUrl = "$url${existingEntry['id']}/";
          final patchResponse = await http.patch(
            Uri.parse(patchUrl),
            headers: {
              "Authorization": "Bearer $token",
              "Content-Type": "application/json"
            },
            body: json.encode({"career_stage": careerStage}),
          );

          if (patchResponse.statusCode == 200) {
            _careerStage = careerStage;
            _registerId = registerId;
            notifyListeners();
            debugPrint('Career stage updated successfully.');
          } else {
            debugPrint("Patch URL: $patchUrl");
            debugPrint("Status Code: ${patchResponse.statusCode}");
            debugPrint("Response Body: ${patchResponse.body}");
            throw Exception('Failed to update career stage');
          }
        } else {
          final postResponse = await http.post(
            Uri.parse(url),
            headers: {
              "Authorization": "Bearer $token",
              "Content-Type": "application/json"
            },
            body: json.encode({
              "career_stage": careerStage,
              "register": registerId,
            }),
          );

          if (postResponse.statusCode == 201 || postResponse.statusCode == 200) {
            _careerStage = careerStage;
            _registerId = registerId;
            notifyListeners();
            debugPrint('Career stage created successfully.');
          } else {
            debugPrint('Failed to create career stage: ${postResponse.body}');
            throw Exception('Failed to create career stage');
          }
        }
      } else {
        debugPrint('Failed to fetch data: ${response.body}');
        throw Exception('Failed to fetch data for career stage');
      }
    } catch (e) {
      debugPrint('Error in saveCareerStage: $e');
    }
  }



}
