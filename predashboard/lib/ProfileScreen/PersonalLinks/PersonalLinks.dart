//
//
//
// import 'dart:convert';
// import 'dart:math';
//
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:pre_dashboard/API.dart';
// import 'package:pre_dashboard/AppSizes/AppSizes.dart';
// import 'package:pre_dashboard/HomePage/constants/constantsColor.dart';
// import 'package:pre_dashboard/ProfileScreen/PersonalLinks/EditLinkPages.dart';
// import 'package:pre_dashboard/ProfileScreen/PersonalLinks/RoundedContainer.dart';
// import 'package:pre_dashboard/ProfileScreen/ProfileSummary/OutlinedContainer.dart';
// import 'package:pre_dashboard/shared_preferences_helper.dart';
//
// import 'package:shared_preferences/shared_preferences.dart';
//
// class PersonalLinks extends StatefulWidget {
//   const PersonalLinks({Key? key}) : super(key: key);
//
//   @override
//   State<PersonalLinks> createState() => _PersonalLinksState();
// }
//
// class _PersonalLinksState extends State<PersonalLinks> {
//   String _linkedinUrl = '';
//   String _gitHubUrl = '';
//   String _portofolio = "";
//   String _other = "";
//   String profileId = '';
//
//   @override
//   void initState() {
//     super.initState();
//     // _loadProfileId();
//     _fetchAndLoadLinks();
//   }
//
//   Future<void> _loadProfileId() async {
//     final prefs = await SharedPreferences.getInstance();
//     final int? savedId = prefs.getInt('profileId');
//     profileId = savedId?.toString() ?? '';
//     print("Profile id is in links$profileId");
//     if (profileId.isNotEmpty) {
//       _fetchLinks();
//     }
//   }
//
//   Future<void> _fetchAndLoadLinks() async {
//     final String? token = await SharedPreferencesHelper.getToken();
//
//     // setState(() {
//     //   _isLoading = true;
//     // });
//
//     final prefs = await SharedPreferences.getInstance();
//     final profileID = prefs.getInt('profileId');
//
//     if (profileID == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Profile ID not found.')),
//       );
//       // setState(() {
//       //   _isLoading = false;
//       // });
//       return;
//     }
//
//     print("Profile ID is $profileID");
//
//     try {
//       final response = await http.get(
//         Uri.parse('${ApiUrls.links}'), // Fetch all links
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//       );
//
//       if (response.statusCode == 200) {
//         // Decode the response as a List (JSON array)
//         final List<dynamic> data = json.decode(response.body);
//         print("Data is $data");
//
//         // Find the link data where the 'user' field matches the profileID
//         final profileData = data.firstWhere(
//               (item) => item['user'] == profileID,
//           orElse: () => null,
//         );
//
//         if (profileData != null) {
//           print("link in Personallinks is ${profileData['link']}");
//           print("Profile data is ${profileData}");
//
//           setState(() {
//             // _linkedInController.text = profileData['link'] ?? '';
//             // _gitHubController.text = profileData['github_url'] ?? '';
//             // _portfolioController.text = profileData['Portfolio'] ?? '';
//             // _otherController.text = profileData['Others'] ?? '';
//           });
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('No matching data found for this profile.')),
//           );
//         }
//       } else {
//         print("Response body is ${response.body}");
//         print("Response code is ${response.statusCode}");
//
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Failed to load links.')),
//         );
//       }
//     } catch (e) {
//       print("Error fetching links: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('An error occurred while fetching links.')),
//       );
//     } finally {
//       // setState(() {
//       //   _isLoading = false;
//       // });
//     }
//   }
//   Future<void> _fetchLinks() async {
//     final url = Uri.parse('${ApiUrls.links}');
//
//     try {
//       // Get the token from SharedPreferences or your storage
//       final String? token = await SharedPreferencesHelper.getToken();
//
//       if (token == null) {
//         print('Token not found. Please log in again.');
//         return;
//       }
//
//       final response = await http.get(
//         url,
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final List<dynamic> linksData = json.decode(response.body);
//         final links = linksData.firstWhere(
//               (link) => link['profile'].toString() == profileId,
//           orElse: () => null,
//         );
//         print('API Response: ${response.body}');
//
//         if (links != null) {
//           setState(() {
//             _linkedinUrl = links['linkedin_url'] ?? '';
//             _gitHubUrl = links['github_url'] ?? '';
//             _portofolio = links['Portfolio'] ?? '';
//             _other = links['Others'] ?? '';
//           });
//         } else {
//           print('No links found for the provided profileId. $profileId');
//         }
//       } else {
//         print('Failed to load links: ${response.statusCode} and ${response.body}');
//       }
//     } catch (e) {
//       print('Error fetching links: $e');
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return OutlinedContainer(
//       onEditTap: (){
//               Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder: (context) => EditLinksPage(),
//                   ),
//                 );
//       },
//       showEdit: true,
//       title: 'Add Links',
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildLinkCard('LinkedIn', _linkedinUrl,
//             const FaIcon(FontAwesomeIcons.linkedin, color: Colors.blue, size: 20),
//           ),
//           SizedBox(height: Sizes.responsiveMd(context)),
//           // _buildLinkCard('GitHub', _gitHubUrl,
//           //   const FaIcon(FontAwesomeIcons.github, color: AppColors.black, size: 20),
//           //           ),
//
//         ],
//       ),
//     );
//   }
//
//   Widget _buildLinkCard(String platform, String link, Widget icon) {
//     return Card(
//       color: Colors.white,
//       elevation: 2,
//       margin: EdgeInsets.symmetric(vertical: Sizes.responsiveSm(context) * 0.5),
//       child: ListTile(
//        leading: icon,
//         title: Text(
//           platform,
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.bold,
//             color: Colors.black87,
//           ),
//         ),
//         subtitle: Text(
//           link.isNotEmpty ? link : 'No link provided',
//           style: TextStyle(
//             fontSize: 12,
//             color: link.isNotEmpty ? AppColors.secondaryText : Colors.grey,
//           ),
//         ),
//       //  trailing: Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.secondaryText),
//         onTap: () {
//           if (link.isNotEmpty) {
//             // Handle link tap, e.g., open the link in a browser
//           }
//         },
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pre_dashboard/API.dart';
import 'package:pre_dashboard/AppSizes/AppSizes.dart';
import 'package:pre_dashboard/HomePage/constants/constantsColor.dart';
import 'package:pre_dashboard/ProfileScreen/PersonalLinks/EditLinkPages.dart';
import 'package:pre_dashboard/ProfileScreen/ProfileSummary/OutlinedContainer.dart';
import 'package:pre_dashboard/shared_preferences_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonalLinks extends StatefulWidget {
  const PersonalLinks({Key? key}) : super(key: key);

  @override
  State<PersonalLinks> createState() => _PersonalLinksState();
}

class _PersonalLinksState extends State<PersonalLinks> {
  String _linkedinUrl = '';
  String _gitHubUrl = '';
  String _portofolio = '';
  String _other = '';
  String profileId = '';

  @override
  void initState() {
    super.initState();
    _fetchAndLoadLinks();
  }

  Future<void> _fetchAndLoadLinks() async {
    final String? token = await SharedPreferencesHelper.getToken();
    final prefs = await SharedPreferences.getInstance();
    final profileID = prefs.getInt('profileId');

    if (profileID == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile ID not found.')),
      );
      return;
    }

    print("Profile ID is $profileID");

    try {
      final response = await http.get(
        Uri.parse('${ApiUrls.links}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print("Data is $data");

        // Find data matching the current user
        final profileData = data.firstWhere(
              (item) => item['user'] == profileID,
          orElse: () => null,
        );

        if (profileData != null) {
          print("Link in PersonalLinks is ${profileData['link']}");

          setState(() {
            _linkedinUrl = profileData['link'] ?? '';
            _gitHubUrl = profileData['github_url'] ?? '';
            _portofolio = profileData['Portfolio'] ?? '';
            _other = profileData['Others'] ?? '';
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No matching data found for this profile.')),
          );
        }
      } else {
        print("Failed to load links: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching links: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedContainer(
      showAdd: false,
      onEditTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>  EditLinksPage(),
          ),
        );
      },
      showEdit: true,
      title: 'Add Links',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLinkCard(
            'LinkedIn',
            _linkedinUrl,
            const FaIcon(FontAwesomeIcons.linkedin, color: Colors.blue, size: 20),
          ),



        ],
      ),
    );
  }

  Widget _buildLinkCard(String platform, String link, Widget icon) {
    return Card(
      color: Colors.white,
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: Sizes.responsiveSm(context) * 0.5),
      child: ListTile(
        leading: icon,
        title: Text(
          platform,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          link.isNotEmpty ? link : 'No link provided',
          style: TextStyle(
            fontSize: 12,
            color: link.isNotEmpty ? AppColors.secondaryText : Colors.grey,
          ),
        ),
        onTap: () {
          if (link.isNotEmpty) {
            print('Opening $platform link: $link');
          }
        },
      ),
    );
  }
}
