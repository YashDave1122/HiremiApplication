import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pre_dashboard/API.dart';
import 'package:shared_preferences/shared_preferences.dart';

//hello
class AddBasicDetailsService {
  final String Url =  '${ApiUrls.baseurl}/api/basic-details/';

  Future<bool> addOrUpdateBasicDetails(Map<String, String> details) async {
    final int? profileId = await _getProfileId();
    if (profileId != null) {
      final int? detailId = await _getDetailId(profileId);
      if (detailId != null) {
        return await updateBasicDetails(detailId, details);
      } else {
        return await addBasicDetails(details);
      }
    } else {
      print('Profile ID not found in SharedPreferences.');
      return false;
    }
  }

  Future<bool> addBasicDetails(Map<String, String> details) async {
    try {
      final response = await http.post(
        Uri.parse(Url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(details),
      );

      if (response.statusCode == 201) {
        await _storeBasicDetailsLocally(details);
        return true;
      } else {
        print('Failed to add details. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error occurred while adding details: $e');
      return false;
    }
  }

  Future<bool> updateBasicDetails(int detailId, Map<String, String> details) async {
    try {
      final response = await http.put(
        Uri.parse('$Url$detailId/'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(details),
      );

      if (response.statusCode == 200) {
        await _storeBasicDetailsLocally(details);
        return true;
      } else {
        print('Failed to update details. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error occurred while updating details: $e');
      return false;
    }
  }

  Future<void> _storeBasicDetailsLocally(Map<String, String> details) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('basicDetails', jsonEncode(details));
  }

  Future<Map<String, String>> getBasicDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final String? details = prefs.getString('basicDetails');
    final int? profileId = prefs.getInt('profileId');

    if (details != null) {
      return Map<String, String>.from(jsonDecode(details));
    } else if (profileId != null) {
      final serverDetails = await getBasicDetailsFromServer(profileId);
      if (serverDetails != null) {
        await _storeBasicDetailsLocally(serverDetails);
        return serverDetails;
      } else {
        return {};
      }
    } else {
      print('Profile ID not found in SharedPreferences.');
      return {};
    }
  }

  Future<Map<String, String>?> getBasicDetailsFromServer(int profileId) async {
    try {
      final response = await http.get(Uri.parse(Url));

      if (response.statusCode == 200) {
        final List<dynamic> detailsList = jsonDecode(response.body);

        for (var details in detailsList) {
          final profile = details['profile'];
          final int profileIdFromDetails = profile is String
              ? int.tryParse(profile) ?? -1
              : profile is int
              ? profile
              : -1;

          if (profileIdFromDetails == profileId) {
            final Map<String, String> basicDetails = {};
            details.forEach((key, value) {
              basicDetails[key] = value.toString();
            });
            await _storeBasicDetailsLocally(basicDetails);
            return basicDetails;
          }
        }
        return null; // No matching profileId found
      } else {
        print('Failed to fetch details. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error occurred while fetching details: $e');
      return null;
    }
  }

  Future<int?> _getProfileId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('profileId');
  }

  Future<int?> _getDetailId(int profileId) async {
    final response = await http.get(Uri.parse(Url));

    if (response.statusCode == 200) {
      final List<dynamic> detailsList = jsonDecode(response.body);

      for (var details in detailsList) {
        final profile = details['profile'];
        final int profileIdFromDetails = profile is String
            ? int.tryParse(profile) ?? -1
            : profile is int
            ? profile
            : -1;

        if (profileIdFromDetails == profileId) {
          return details['id'];
        }
      }
      return null; // No matching profileId found
    } else {
      print('Failed to fetch details. Status code: ${response.statusCode}');
      return null;
    }
  }
}
