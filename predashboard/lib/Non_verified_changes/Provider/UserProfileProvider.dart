import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pre_dashboard/API.dart';
import 'package:pre_dashboard/shared_preferences_helper.dart';

class UserProfileProvider extends ChangeNotifier {
 // final String apiUrl = ApiUrls.userprofiles;
 //  final String apiUrl = "http://3.109.62.159:8000/accounts/";
  // User data
  final String apiUrl =ApiUrls.registration;

  Map<String, dynamic> _userData = {};

  Map<String, dynamic> get userData => _userData;



  Future<String?> loginUser(String email, String password) async {
    final response = await http.post(
      Uri.parse('${ApiUrls.Login}'), // Replace with actual login endpoint
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("Response body is ${response.body}");
      print("Response code is ${response.statusCode}");

      final token = data['access_token']; // Assuming your API returns a token
      await SharedPreferencesHelper.setToken(token);
      print("Token: $token");
      return token;
    }
    else {
      print("Login failed: ${response.body}");
      return null;
    }
  }

  Future<Map<String, dynamic>> fetchUserData(String token) async {
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print(response.body);
        final List<dynamic> data = json.decode(response.body);

        if (data.isNotEmpty) {
          _userData = data.last;

          // Convert birth_city ID to city name
          int birthCityId = _userData['birth_city'];
          String birthState = _userData['birth_state'];

          print("🔵 Birth city ID: $birthCityId");
          _userData['birth_city_id'] = birthCityId; // Store ID separately

          // if (birthCityId is int) {
          //   print("Birth city id id $birthCityId");
          //   String? cityName = await getCityName(birthState, birthCityId);
          //   _userData['birth_city'] = cityName ?? 'Unknown';
          //
          // }
          if (birthCityId is int?) {
            print("Birth city id id $birthCityId");
            String? cityName = await getCityName(birthState, birthCityId);
            _userData['birth_city'] = cityName ?? 'Unknown';

          }

          notifyListeners();
          return _userData;
        } else {
          throw Exception('No user data available');
        }
      }
      else {
        print("Status Code: ${response.statusCode}");
        print("Response Body: ${response.body}");
        throw Exception('Failed to load user data: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching user datayash: $e");
      throw Exception('Error fetching user data');
    }
  }

// Fetch city name using city ID and state name
  Future<String?> getCityName(String state, int cityId) async {
    print("State is $state");
    print("City id is $cityId");
    final response = await http.get(
      Uri.parse('http://3.109.62.159:8000/cities/$cityId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['name']; // Extract the city name
    } else {
      print("Failed to fetch city name:${response.statusCode}");
      print("Failed to fetch city name: ${response.body}");
      return null;
    }
  }



  Future<void> patchUserData(int id, Map<String, dynamic> userData) async {
    try {
      final response = await http.patch(
        Uri.parse('$apiUrl$id/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(userData),
      );

      if (response.statusCode == 200) {
        print("User data patched successfully");
      }
      else
      {


        print("${response.body}");
        throw Exception('Failed to patch user data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to patch user data: $e');
    }
  }


  Future<void> postUserData(Map<String, dynamic> userData) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(userData),
      );

      if (response.statusCode == 201) {
        print("User data posted successfully");
      } else {
        print("USer data is $userData");
        print("POST userData: ${json.encode(userData)}");

        print("${response.statusCode}");
        print("${response.body}");
        throw Exception('Failed to post user data: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to post user data: $e');
    }
  }
}
