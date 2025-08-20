import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pre_dashboard/API.dart';
import 'package:pre_dashboard/shared_preferences_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';



class LinksApiService {
  final String baseUrl = '${ApiUrls.links}';


  Future<bool> addOrUpdateLinks(Map<String, String> links) async {
    final int? profileId = await _getProfileId();
    if (profileId == null) {
      print('Profile ID not found in SharedPreferences.');
      return false;
    }

    final int? detailId = await _getLinksDetailId(profileId);
    print("Profile ID is $profileId and Detail ID is $detailId");

    if (detailId != null) {
      print("Updating existing links");
      return await updateLinks(detailId, links);
    } else {

      print("No existing links found. Adding new links.");
      return await addLinks(links);
    }
  }


  Future<bool> addLinks(Map<String, String> links) async {
    print("I am in addlinks");
    final String? token = await SharedPreferencesHelper.getToken();

    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(links),
      );

      if (response.statusCode == 201) {
        print("I am in if sections${response.body} and ${response.statusCode}");
        // await _storeLinksLocally(links);
        return true;
      } else {
        print("I am in else section");
        print('Failed to add links. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {

      print('Error occurred while adding links: $e');
      return false;
    }
  }

  Future<bool> updateLinks(int detailId, Map<String, String> links) async {
    final String? token = await SharedPreferencesHelper.getToken();
    print("DEtailed is $detailId");

    try {
      final response = await http.put(
        Uri.parse('$baseUrl$detailId/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',

        },
        body: jsonEncode(links),
      );

      if (response.statusCode == 200) {
        print("Response code is ${response.statusCode} and ${response.body}");
        await _storeLinksLocally(links);
        return true;
      } else {
        print('Failed to update links. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error occurred while updating links: $e');
      return false;
    }
  }

  Future<void> _storeLinksLocally(Map<String, String> links) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('personalLinks', jsonEncode(links));
  }

  Future<Map<String, String>> getLinks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? details = prefs.getString('personalLinks');
    final int? profileId = prefs.getInt('profileId');

    if (details != null) {
      try {
        return Map<String, String>.from(jsonDecode(details));
      } catch (e) {
        print('Error occurred while decoding links details: $e');
        return {};
      }
    } else if (profileId != null) {
      final serverDetails = await getLinksFromServer(profileId);
      if (serverDetails.isNotEmpty) {
        await _storeLinksLocally(serverDetails);
        return serverDetails;
      } else {
        return {};
      }
    } else {
      print('Profile ID not found in SharedPreferences.');
      return {};
    }
  }

  Future<Map<String, String>> getLinksFromServer(int profileId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl?profile_id=$profileId'));

      if (response.statusCode == 200) {
        final List<dynamic> linksList = jsonDecode(response.body);

        final List<Map<String, String>> links = linksList.map((link) {
          final Map<String, dynamic> decodedLink = link as Map<String, dynamic>;
          return decodedLink.map((key, value) => MapEntry(key, value.toString()));
        }).toList();

        final filteredLinks = _filterLinksByProfileId(links, profileId);
        return filteredLinks.isNotEmpty ? filteredLinks.first : {};
      } else {
        print('Failed to fetch links. Staxccxtus code: ${response.statusCode}');
        print("Failed${response.body}");
        return {};
      }
    } catch (e) {
      print('Error occurred while fetching links: $e');
      return {};
    }
  }

  List<Map<String, String>> _filterLinksByProfileId(List<Map<String, String>> linksList, int profileId) {
    return linksList.where((links) {
      final profile = links['profile'];
      final int profileIdFromLinks = profile != null ? int.tryParse(profile) ?? -1 : -1;
      return profileIdFromLinks == profileId;
    }).toList();
  }

  Future<int?> _getProfileId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('profileId');
  }

  // Future<int?> _getLinksDetailId(int profileId) async {
  //   final response = await http.get(Uri.parse(baseUrl));
  //
  //   if (response.statusCode == 200) {
  //     final List<dynamic> linksList = jsonDecode(response.body);
  //
  //     for (var links in linksList) {
  //       final profile = links['profile'];
  //       final int profileIdFromLinks = profile is String
  //           ? int.tryParse(profile) ?? -1
  //           : profile is int
  //           ? profile
  //           : -1;
  //
  //       if (profileIdFromLinks == profileId) {
  //         return links['id'];
  //       }
  //     }
  //     return null; // No matching profileId found
  //   } else {
  //     print('Failed to fetch links xzxzzxdetails. Status code: ${response.statusCode} and ${response.body}');
  //     return null;
  //   }
  // }
  Future<int?> _getLinksDetailId(int profileId) async {
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
        final List<dynamic> linksList = jsonDecode(response.body);

        for (var links in linksList) {
          // Ensure 'profile' exists and is valid
          if (links['user'] == profileId) {
            print("Matching Profile ID Found. Link ID: ${links['id']}");
            return links['id'];
          }
        }
        print("No matching profile found.");
        return null;
      } else {
        print('Failed to fetch links. Status code: ${response.statusCode}, Body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error occurred while fetching links: $e');
      return null;
    }
  }


}
