
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pre_dashboard/API.dart';
import 'package:pre_dashboard/shared_preferences_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddExperienceService {
  final String url = '${ApiUrls.experiences}';
  // final String url ="http://10.0.2.2:8000/experiences/";

  Future<bool> addExperience(Map<String, dynamic> details) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final int? profileId = prefs.getInt('profileId');

      if (profileId == null) {
        print('Profile ID not found in SharedPreferences.');
        return false;
      }

      // Check for existing experience
      final existingDetails = await getExperienceDetailsFromServer(profileId);
      if (existingDetails.isNotEmpty) {
        // Assuming there's only one experience per profile
        final existingDetail = existingDetails.first;
        final int experienceId = int.parse(existingDetail['id']!);
        print("Updating in Add experience/Apiservices.dart");
        return await updateExperience(experienceId, details);
      } else {
        return await _addNewExperience(details);
      }
    } catch (e) {
      print('Error occurred while adding/updating experience details: $e');
      return false;
    }
  }

  Future<bool> _addNewExperience(Map<String, dynamic> details) async {
    final String? token = await SharedPreferencesHelper.getToken();
    print("Token is $token");

    try {
      // Ensure dates are in YYYY-MM-DD format
      details["start_date"] = _formatDate(details["start_date"]);
      details["end_date"] = _formatDate(details["end_date"]);

      // Remove `end_date` if it's empty (""), so it's not sent in the request
      details.removeWhere((key, value) => value == "");

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(details),
      );

      if (response.statusCode == 201) {
        await _storeExperienceDetailsLocally(details);
        return true;
      } else {
        print('Failed to add experience details. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error occurred while adding experience details: $e');
      return false;
    }
  }

  String _formatDate(String? date) {
    if (date == null || date.isEmpty) {
      return ""; // Return empty string instead of null
    }
    try {
      DateTime parsedDate = DateTime.parse(date);
      return "${parsedDate.year}-${_twoDigits(parsedDate.month)}-${_twoDigits(parsedDate.day)}";
    } catch (e) {
      print("Invalid date format: $date");
      return ""; // Return empty string if parsing fails
    }
  }

  // Helper function to ensure two-digit month and day
  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  Future<bool> updateExperience(int id, Map<String, dynamic> details) async {
    final String? token = await SharedPreferencesHelper.getToken();
    print("Token is $token");
    try {
      final response = await http.put(
        Uri.parse('$url$id/'),

        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(details),
      );
      print("Whole Response Body: ${response.body}");
      print("Response Status Code: ${response.statusCode}");
      // print("Response Headers: ${response.headers}");

      // Decode the JSON response
      dynamic responseBody;

      if (response.statusCode == 200) {

        print("Response status code and response body in ${response.statusCode} and ${response.body}");
        await _updateExperienceDetailsLocally(details);
        return true;
      } else {
        print('Failed to update experience details. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error occurred while updating experience details: $e');
      return false;
    }
  }

  Future<void> _storeExperienceDetailsLocally(Map<String, dynamic> details) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> existingDetails = prefs.getStringList('experienceDetails') ?? [];

    // Check if the experience already exists
    final bool exists = existingDetails.any((detail) {
      final Map<String, dynamic> existingDetail = jsonDecode(detail);
      return existingDetail['job_title'] == details['job_title'] &&
          existingDetail['company_name'] == details['company_name'] &&
          existingDetail['user'] == details['user'];
    });

    // Add only if it doesn't exist
    if (!exists) {
      existingDetails.add(jsonEncode(details));
      await prefs.setStringList('experienceDetails', existingDetails);
    }
  }

  Future<void> _updateExperienceDetailsLocally(Map<String, dynamic> details) async {
    print("I am in _updateExperienceDetailsLocally");
    final prefs = await SharedPreferences.getInstance();
    final List<String> existingDetails = prefs.getStringList('experienceDetails') ?? [];

    // Find and update the existing detail in the local storage
    for (int i = 0; i < existingDetails.length; i++) {
      final Map<String, dynamic> existingDetail = jsonDecode(existingDetails[i]);
      if (existingDetail['job_title'] == details['job_title'] &&
          existingDetail['company_name'] == details['company_name'] &&
          existingDetail['user'] == details['user']) {
        existingDetails[i] = jsonEncode(details);
        break;
      }
    }
    await prefs.setStringList('experienceDetails', existingDetails);
  }

  Future<void> _storeExperienceDetailsListLocally(List<Map<String, String>> newExperiences) async {
    final prefs = await SharedPreferences.getInstance();
    final existingDetails = prefs.getStringList('experienceDetails') ?? [];

    // Decode existing experiences
    List<Map<String, String>> decodedExistingDetails = existingDetails.map((detail) {
      final Map<String, dynamic> decodedDetail = jsonDecode(detail);
      return decodedDetail.map((key, value) => MapEntry(key, value.toString()));
    }).toList();

    // Update existing experiences or add new ones
    for (var newExperience in newExperiences) {
      // Find the index of the existing experience with the same job_title, company_name, and user
      final index = decodedExistingDetails.indexWhere(
            (existing) =>
        existing["job_title"] == newExperience["job_title"] &&
            existing["company_name"] == newExperience["company_name"] &&
            existing["user"] == newExperience["user"],
      );

      if (index != -1) {
        // Update existing experience
        decodedExistingDetails[index] = newExperience;
      } else {
        // Add new experience only if it doesn't already exist
        if (!decodedExistingDetails.any(
              (existing) =>
          existing["job_title"] == newExperience["job_title"] &&
              existing["company_name"] == newExperience["company_name"] &&
              existing["user"] == newExperience["user"],
        )) {
          decodedExistingDetails.add(newExperience);
        }
      }
    }

    // Encode and save updated details
    final updatedDetails = decodedExistingDetails.map((e) => jsonEncode(e)).toList();
    await prefs.setStringList('experienceDetails', updatedDetails);
  }

  Future<List<Map<String, String>>> getExperienceDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final details = prefs.getStringList('experienceDetails');

    final int? profileId = prefs.getInt('profileId');

    if (details != null) {
      try {
        print("Details in getExperienceDetails: $details");
        final decodedDetails = details.map((detail) {
          final Map<String, dynamic> decodedDetail = jsonDecode(detail);
          return decodedDetail.map((key, value) => MapEntry(key, value.toString()));
        }).toList();
        print("Decodeddetails list is $decodedDetails");
        return _filterDetailsByProfileId(decodedDetails, profileId);
      } catch (e) {
        print('Error occurred while decoding experience details: $e');
        return [];
      }
    }
    else if (profileId != null) {
      print("profile id is  in get experienced $profileId");
      final serverDetails = await getExperienceDetailsFromServer(profileId);
      if (serverDetails.isNotEmpty) {
        await _storeExperienceDetailsListLocally(serverDetails);
        return serverDetails;
      } else {
        return [];
      }
    } else {
      print('Profile ID not found in SharedPreferences.');
      return [];
    }
  }

  Future<List<Map<String, String>>> getExperienceDetailsFromServer(int profileId) async {
    final String? token = await SharedPreferencesHelper.getToken();
    print("Token is $token");
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> detailsList = jsonDecode(response.body);

        final List<Map<String, String>> experienceDetailsList = detailsList.map((details) {
          final Map<String, String> experienceDetails = {};
          details.forEach((key, value) {
            experienceDetails[key] = value.toString();
          });
          return experienceDetails;
        }).toList();

        return _filterDetailsByProfileId(experienceDetailsList, profileId);
      } else {
        print('Failed to fetch experience details. Status code: ${response.statusCode} and ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error occurred while fetching experience details: $e');
      return [];
    }
  }

  List<Map<String, String>> _filterDetailsByProfileId(List<Map<String, String>> detailsList, int? profileId) {
    if (profileId == null) {
      print('Profile ID is null.');
      return [];
    }
    else{
      print("Profile id is $profileId");
    }
    return detailsList.where((details) {
      final profile = details['user'];
      print("${details['user']}");
      final int profileIdFromDetails = profile != null ? int.tryParse(profile) ?? -1 : -1;
      return profileIdFromDetails == profileId;
    }).toList();

  }
}