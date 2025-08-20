import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pre_dashboard/API.dart';
import 'package:pre_dashboard/shared_preferences_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';



class AddEducationService {
  // final String baseUrl = '${ApiUrls.baseurl}/api/education/';
  final String baseUrl = '${ApiUrls.education}';


  Future<bool> addOrUpdateEducation(Map<String, dynamic> details) async {
    print("I am in addOrUpdateEducation");

    try {
      final profileId = details['profile'];
      final String? token = await SharedPreferencesHelper.getToken();
      print("Token is $token");
      print("Profile id is $profileId");
      final existingId = await _getExistingEducationId(profileId,token!);
      print("Existing id is $existingId");
      if (existingId != null) {
        // Update existing record
        print("Existing id is $existingId");
        return await _updateEducation(existingId, details,token!);
      }
      else {
        print("Existing id is $existingId");

        // Add new record
        return await _addEducation(details,token!);
      }
    } catch (e) {
      print('Error occurred while adding or updating education details: $e');
      return false;
    }
  }

  Future<int?> _getExistingEducationId(String profileId,String token) async {
    try {
      final response = await http.get(Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',

        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> detailsList = jsonDecode(response.body);
        for (var detail in detailsList) {
          if (detail['profile'].toString() == profileId) {
            print("detail profile is ${detail['profile']}");
            return detail['id'];
          }
        }
      } else {
        print('Failed to fetch education details. Status code: ${response.statusCode} and resposne body is ${response.body}');
      }
    } catch (e) {
      print('Error occurred while fetching education details: $e');
    }
    return null;
  }

  Future<bool> _addEducation(Map<String, dynamic> details,String token) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',

        },
        body: jsonEncode(details),
      );

      if (response.statusCode == 201) {
        print("${response.statusCode} and ${response.body}");
        await _storeEducationDetailsLocally(details);
        return true;
      } else {
        print('Failed to add education details. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error occurred while adding education details: $e');
      return false;
    }
  }

  Future<bool> _updateEducation(int id, Map<String, dynamic> details,String token) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl$id/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',

        },
        body: jsonEncode(details),
      );

      if (response.statusCode == 200) {
        await _updateEducationDetailsLocally(details);
        return true;
      } else {
        print('Failed to update education details. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error occurred while updating education details: $e');
      return false;
    }
  }

  Future<void> _storeEducationDetailsLocally(Map<String, dynamic> details) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> existingDetails = prefs.getStringList('educationDetails') ?? [];
    existingDetails.add(jsonEncode(details));
    await prefs.setStringList('educationDetails', existingDetails);
  }

  Future<void> _updateEducationDetailsLocally(Map<String, dynamic> details) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> existingDetails = prefs.getStringList('educationDetails') ?? [];
    final updatedDetails = existingDetails.map((detail) {
      final Map<String, dynamic> decodedDetail = jsonDecode(detail);
      if (decodedDetail['profile'] == details['profile']) {
        return jsonEncode(details);
      }
      return detail;
    }).toList();
    await prefs.setStringList('educationDetails', updatedDetails);
  }

  Future<List<Map<String, String>>> getEducationDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final details = prefs.getStringList('educationDetails');
    final int? profileId = prefs.getInt('profileId');

    if (details != null) {
      try {
        final decodedDetails = details.map((detail) {
          final Map<String, dynamic> decodedDetail = jsonDecode(detail);
          return decodedDetail.map((key, value) => MapEntry(key, value.toString()));
        }).toList();
        return _filterDetailsByProfileId(decodedDetails, profileId);
      } catch (e) {
        print('Error occurred while decoding education details: $e');
        return [];
      }
    } else if (profileId != null) {
      final serverDetails = await getEducationDetailsFromServer(profileId);
      if (serverDetails.isNotEmpty) {
        await _storeEducationDetailsListLocally(serverDetails);
        return serverDetails;
      } else {
        return [];
      }
    } else {
      print('Profile ID not found in SharedPreferences.');
      return [];
    }
  }

  Future<void> _storeEducationDetailsListLocally(List<Map<String, String>> detailsList) async {
    final prefs = await SharedPreferences.getInstance();
    final encodedDetailsList = detailsList.map((details) => jsonEncode(details)).toList();
    await prefs.setStringList('educationDetails', encodedDetailsList);
  }

  Future<List<Map<String, String>>> getEducationDetailsFromServer(int profileId) async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final List<dynamic> detailsList = jsonDecode(response.body);

        final List<Map<String, String>> educationDetailsList = detailsList.map((details) {
          final Map<String, String> educationDetails = {};
          details.forEach((key, value) {
            educationDetails[key] = value.toString();
          });
          return educationDetails;
        }).toList();

        return _filterDetailsByProfileId(educationDetailsList, profileId);
      } else {
        print('Failed to fetch education details. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error occurred while fetching education details: $e');
      return [];
    }
  }

  List<Map<String, String>> _filterDetailsByProfileId(List<Map<String, String>> detailsList, int? profileId) {
    if (profileId == null) {
      print('Profile ID is null.');
      return [];
    }
    return detailsList.where((details) {
      final profile = details['profile'];
      final int profileIdFromDetails = profile != null ? int.tryParse(profile) ?? -1 : -1;
      return profileIdFromDetails == profileId;
    }).toList();
  }
}
