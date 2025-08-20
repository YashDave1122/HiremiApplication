import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pre_dashboard/API.dart';
import 'package:shared_preferences/shared_preferences.dart';



// class ResumeApiService {
//   final String baseUrl = 'http://13.127.81.177:8000/api/resumelink/';
//
//   Future<bool> addOrUpdateResumeLink(Map<String, String> details) async {
//     final int? profileId = await _getProfileId();
//     if (profileId != null) {
//       final int? detailId = await _getResumeDetailId(profileId);
//       if (detailId != null) {
//         return await updateResumeLink(detailId, details);
//       } else {
//         return await addResumeLink(details);
//       }
//     } else {
//       print('Profile ID not found in SharedPreferences.');
//       return false;
//     }
//   }
//
//   Future<bool> addResumeLink(Map<String, String> details) async {
//     try {
//       final response = await http.post(
//         Uri.parse(baseUrl),
//         headers: {
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode(details),
//       );
//
//       if (response.statusCode == 201) {
//         await _storeResumeLinkLocally(details);
//         return true;
//       } else {
//         print('Failed to add resume link. Status code: ${response.statusCode}');
//         print('Response body: ${response.body}');
//         return false;
//       }
//     } catch (e) {
//       print('Error occurred while adding resume link: $e');
//       return false;
//     }
//   }
//
//   Future<bool> updateResumeLink(int detailId, Map<String, String> details) async {
//     try {
//       final response = await http.put(
//         Uri.parse('$baseUrl$detailId/'),
//         headers: {
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode(details),
//       );
//
//       if (response.statusCode == 200) {
//         await _storeResumeLinkLocally(details);
//         return true;
//       } else {
//         print('Failed to update resume link. Status code: ${response.statusCode}');
//         print('Response body: ${response.body}');
//         return false;
//       }
//     } catch (e) {
//       print('Error occurred while updating resume link: $e');
//       return false;
//     }
//   }
//
//   Future<void> _storeResumeLinkLocally(Map<String, String> details) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('resumeLink', jsonEncode(details));
//   }
//
//   Future<Map<String, String>> getResumeLink(String profileID) async {
//     final prefs = await SharedPreferences.getInstance();
//     final String? details = prefs.getString('resumeLink');
//     final int? profileId = prefs.getInt('profileId');
//
//     if (details != null) {
//       try {
//         return Map<String, String>.from(jsonDecode(details));
//       } catch (e) {
//         print('Error occurred while decoding resume link details: $e');
//         return {};
//       }
//     } else if (profileId != null) {
//       final serverDetails = await getResumeLinkFromServer(profileId);
//       if (serverDetails.isNotEmpty) {
//         await _storeResumeLinkLocally(serverDetails);
//         return serverDetails;
//       } else {
//         return {};
//       }
//     } else {
//       print('Profile ID not found in SharedPreferences.');
//       return {};
//     }
//   }
//
//   Future<Map<String, String>> getResumeLinkFromServer(int profileId) async {
//     try {
//       final response = await http.get(Uri.parse(baseUrl));
//
//       if (response.statusCode == 200) {
//         final List<dynamic> detailsList = jsonDecode(response.body);
//
//         final List<Map<String, String>> details = detailsList.map((detail) {
//           final Map<String, dynamic> decodedDetail = detail as Map<String, dynamic>;
//           return decodedDetail.map((key, value) => MapEntry(key, value.toString()));
//         }).toList();
//
//         final filteredDetails = _filterDetailsByProfileId(details, profileId);
//         return filteredDetails.isNotEmpty ? filteredDetails.first : {};
//       } else {
//         print('Failed to fetch resume link. Status code: ${response.statusCode}');
//         return {};
//       }
//     } catch (e) {
//       print('Error occurred while fetching resume link: $e');
//       return {};
//     }
//   }
//
//   List<Map<String, String>> _filterDetailsByProfileId(List<Map<String, String>> detailsList, int profileId) {
//     return detailsList.where((details) {
//       final profile = details['profile'];
//       final int profileIdFromDetails = profile != null ? int.tryParse(profile) ?? -1 : -1;
//       return profileIdFromDetails == profileId;
//     }).toList();
//   }
//
//   Future<int?> _getProfileId() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getInt('profileId');
//   }
//
//   Future<int?> _getResumeDetailId(int profileId) async {
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
//       print('Failed to fetch resume details. Status code: ${response.statusCode}');
//       return null;
//     }
//   }
// }
class ResumeApiService {
  final String baseUrl = '${ApiUrls.baseurl}/api/resumelink/';

  Future<bool> addOrUpdateResumeLink(Map<String, String> details) async {
    final int? profileId = await _getProfileId();
    if (profileId != null) {
      final int? detailId = await _getResumeDetailId(profileId);
      if (detailId != null) {
        return await updateResumeLink(detailId, details);
      } else {
        return await addResumeLink(details);
      }
    } else {
      print('Profile ID not found in SharedPreferences.');
      return false;
    }
  }

  Future<bool> addResumeLink(Map<String, String> details) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(details),
      );

      if (response.statusCode == 201) {
        await _storeResumeLinkLocally(details['url']!);
        return true;
      } else {
        print('Failed to add resume link. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error occurred while adding resume link: $e');
      return false;
    }
  }

  Future<bool> updateResumeLink(int detailId, Map<String, String> details) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl$detailId/'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(details),
      );

      if (response.statusCode == 200) {
        await _storeResumeLinkLocally(details['url']!);
        return true;
      } else {
        print('Failed to update resume link. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error occurred while updating resume link: $e');
      return false;
    }
  }

  Future<void> _storeResumeLinkLocally(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('resumeLink', url);
  }

  Future<String?> getResumeLink(String profileID) async {
    final prefs = await SharedPreferences.getInstance();
    final String? resumeLink = prefs.getString('resumeLink');

    if (resumeLink != null) {
      return resumeLink;
    } else {
      final profileId = int.tryParse(profileID);
      if (profileId != null) {
        final serverDetails = await getResumeLinkFromServer(profileId);
        if (serverDetails.isNotEmpty) {
          await _storeResumeLinkLocally(serverDetails['url']!);
          return serverDetails['url'];
        }
      }
      return null;
    }
  }

  Future<Map<String, String>> getResumeLinkFromServer(int profileId) async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final resumeDetail = data.firstWhere(
              (element) => element['profile'].toString() == profileId.toString(),
          orElse: () => null,
        );
        if (resumeDetail != null) {
          return {'url': resumeDetail['url']};
        }
      }
      return {};
    } catch (e) {
      print('Error occurred while fetching resume link: $e');
      return {};
    }
  }

  Future<int?> _getProfileId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('profileId');
  }

  Future<int?> _getResumeDetailId(int profileId) async {
    // Logic to get the resume detail ID
    return null; // Replace with actual logic
  }
}
