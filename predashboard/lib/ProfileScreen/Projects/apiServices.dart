import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pre_dashboard/API.dart';
import 'package:pre_dashboard/shared_preferences_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddProjectDetailsService {
  // final String baseUrl = '${ApiUrls.baseurl}/api/projects/';
  final String baseUrl = '${ApiUrls.projects}';

  // Method to add or update project details based on the presence of the profileId and detailId
  // Future<bool> addOrUpdateProjectDetails(Map<String, String> details, int profileId) async {
  //   details['profile'] = profileId.toString(); // Ensure profileId is included
  //   final int? detailId = await _getDetailId(profileId);
  //   print("Detailed is is $detailId");
  //   if (detailId != null) {
  //     return await updateProjectDetails(detailId, details);
  //   } else {
  //     return await addProjectDetails(details);
  //   }
  // }
  Future<bool> addOrUpdateProjectDetails(Map<String, String> details, int profileId) async {
    details['profile'] = profileId.toString(); // Ensure profileId is included
    final int? detailId = await _getDetailId(profileId);
    if (detailId != null) {
      print("Detailed is updateProjectDetails is $detailId");
      return await updateProjectDetails(detailId, details);
    } else {
      print("Detailed is is $detailId");
      return await addProjectDetails(details);
    }
  }

  // Method to add new project details
  Future<bool> addProjectDetails(Map<String, String> details) async {
    final String? token = await SharedPreferencesHelper.getToken();
    print("Token is $token");
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
        await _storeProjectDetailsLocally(details);
        return true;
      } else {
        print('Failed to add project details. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error occurred while adding project details: $e');
      return false;
    }
  }

  // Method to update existing project details
  Future<bool> updateProjectDetails(int detailId, Map<String, String> details) async {
    final String? token = await SharedPreferencesHelper.getToken();
    try {
      final response = await http.put(
        Uri.parse('$baseUrl$detailId/'),
        // headers: {'Content-Type': 'application/json'},
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',

        },
        body: jsonEncode(details),
      );

      if (response.statusCode == 200) {
        await _storeProjectDetailsLocally(details);
        return true;
      } else {
        print('Failed to update project details. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error occurred while updating project details: $e');
      return false;
    }
  }

  // Method to store project details locally in SharedPreferences
  Future<void> _storeProjectDetailsLocally(Map<String, String> details) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('projectDetails', jsonEncode(details));
  }

  // Method to get project details from either local storage or the server
  Future<Map<String, String>> getProjectDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final String? details = prefs.getString('projectDetails');
    // final int? profileId = prefs.getInt('profileId');
    final int?  profileId = await SharedPreferencesHelper.getProfileId();
    print("Prodile id in$profileId");

    // if (details != null) {
    //   print("Details isdsdsds $details");
    //   return Map<String, String>.from(jsonDecode(details));
    // }
    if (profileId != null) {
      print("Profile id is $profileId");
      final serverDetails = await getProjectDetailsFromServer(profileId);
      if (serverDetails != null) {
        print("Profile id is $profileId");

        await _storeProjectDetailsLocally(serverDetails);
        return serverDetails;
      }
      else {
        return {};
      }
    } else {
      print('Profile ID not found in SharedPreferences.');
      return {};
    }
  }


  Future<Map<String, String>?> getProjectDetailsFromServer(int profileId) async {
    final String? token = await SharedPreferencesHelper.getToken();
    try {
      final response = await http.get(
        Uri.parse(baseUrl), // Fetch all project details
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print("Status code is ${response.statusCode} and ${response.body} in server details");
        final List<dynamic> detailsList = jsonDecode(response.body);

        // Iterate through the list of project details
        for (var details in detailsList) {
          final int userId = details['user'] is String
              ? int.tryParse(details['user']) ?? -1
              : details['user'] ?? -1;
             print("User id is $userId");
             print("Profile id is $profileId");
          // Compare the user ID with the profileId
          if (userId == profileId) {
            print("Matching profile found! Details: $details");
            final Map<String, String> projectDetails = {};
            details.forEach((key, value) {
              projectDetails[key] = value.toString();
              print("${projectDetails[key]}");
            });
            await _storeProjectDetailsLocally(projectDetails);
            return projectDetails;
          }

          else{
            print("User id is $userId");
            print("Profile id is $profileId");
          }
        }

        // If no matching profile is found
        print("Did not get the data for profileId: $profileId");
        return null;
      } else {
        print('Failed to fetch project details. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error occurred while fetching project details: $e');
      return null;
    }
  }


  // Method to get the profile ID from local storage

  // Method to get the detail ID from the server based on profile ID
  // Future<int?> _getDetailId(int profileId) async {
  //   try {
  //     final response = await http.get(Uri.parse(baseUrl));
  //
  //     if (response.statusCode == 200) {
  //       final List<dynamic> detailsList = jsonDecode(response.body);
  //
  //       for (var details in detailsList) {
  //         final profile = details['profile'];
  //         final int profileIdFromDetails = profile is String
  //             ? int.tryParse(profile) ?? -1
  //             : profile is int
  //             ? profile
  //             : -1;
  //
  //         if (profileIdFromDetails == profileId) {
  //           return details['id'];
  //         }
  //       }
  //       return null; // No matching profileId found
  //     } else {
  //       print('Failed to fetch project details. Status code: ${response.statusCode}');
  //       return null;
  //     }
  //   } catch (e) {
  //     print('Error occurred while fetching project details: $e');
  //     return null;
  //   }
  // }
  Future<int?> _getDetailId(int profileId) async {
    final String? token = await SharedPreferencesHelper.getToken();
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> detailsList = jsonDecode(response.body);

        for (var details in detailsList) {
          final int userId = details['user'] is String
              ? int.tryParse(details['user']) ?? -1
              : details['user'] ?? -1;

          if (userId == profileId) {
            return details['id']; // Return the project ID (detailId)
          }
        }
        return null; // No matching profileId found
      } else {
        print('Failed to fetch project details. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error occurred while fetching project details: $e');
      return null;
    }
  }
}
