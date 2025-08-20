
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pre_dashboard/API.dart';
import 'package:pre_dashboard/AppSizes/AppSizes.dart';
import 'package:pre_dashboard/HomePage/constants/constantsColor.dart';
import 'package:pre_dashboard/ProfileScreen/PersonalLinks/CstomTextFeildForEditLinks.dart';
import 'package:pre_dashboard/ProfileScreen/PersonalLinks/apiServices.dart';
import 'package:pre_dashboard/ProfileScreen/Profile_screen.dart';
import 'package:pre_dashboard/shared_preferences_helper.dart';

import 'package:shared_preferences/shared_preferences.dart';



class EditLinksPage extends StatefulWidget {
  @override
  _EditLinksPageState createState() => _EditLinksPageState();
}

class _EditLinksPageState extends State<EditLinksPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _linkedInController = TextEditingController();
  final TextEditingController _gitHubController = TextEditingController();
  final TextEditingController _portfolioController = TextEditingController();
  final TextEditingController _otherController = TextEditingController();

  bool _isLoading = false;
  int? profileId;

  @override
  void initState() {
    super.initState();
    _loadProfileId();
    _fetchAndLoadLinks();
    //_fetchLinks();
  }

  Future<void> _loadProfileId() async {
    final prefs = await SharedPreferences.getInstance();
    profileId = prefs.getInt('profileId');
  }


  Future<void> _fetchAndLoadLinks() async {
    final String? token = await SharedPreferencesHelper.getToken();

    setState(() {
      _isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final profileID = prefs.getInt('profileId');

    if (profileID == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile ID not found.')),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    print("Profile ID is $profileID");

    try {
      final response = await http.get(
        Uri.parse('${ApiUrls.links}'), // Fetch all links
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Decode the response as a List (JSON array)
        final List<dynamic> data = json.decode(response.body);
        print("Data is $data");

        // Find the link data where the 'user' field matches the profileID
        final profileData = data.firstWhere(
              (item) => item['user'] == profileID,
          orElse: () => null,
        );

        if (profileData != null) {
          print("Profile data is ${profileData['link']}");
          print("Profile data is ${profileData}");

          setState(() {

            _linkedInController.text = profileData['link'] ?? '';
            // _gitHubController.text = profileData['github_url'] ?? '';
            // _portfolioController.text = profileData['Portfolio'] ?? '';
            // _otherController.text = profileData['Others'] ?? '';
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No matching data found for this profile.')),
          );
        }
      } else {
        print("Response body is ${response.body}");
        print("Response code is ${response.statusCode}");

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load links.')),
        );
      }
    } catch (e) {
      print("Error fetching links: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred while fetching links.')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveLinks() async {
    if (!_formKey.currentState!.validate()) {
      print("DDDC");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    // final profileID = prefs.getInt('profileId')?.toString();
    final profileID = prefs.getInt('profileId')?.toString();

    if (profileID == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile ID not found.')),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final apiService = LinksApiService();
    final details = {
      'link': _linkedInController.text.trim(),
      // 'github_url': _gitHubController.text.trim(),
      // 'Portfolio': _portfolioController.text.trim(),
      // 'Others': _otherController.text.trim(),
      'platform':"Linkedin",
      'user': profileID,
    };

    final success = await apiService.addOrUpdateLinks(details);

    if (success) {
      // await prefs.setString('linkedInLink', _linkedInController.text.trim());
      // await prefs.setString('gitHubLink', _gitHubController.text.trim());
      // await prefs.setString('portfolioLink', _portfolioController.text.trim());
      // await prefs.setString('otherLink', _otherController.text.trim());
      await prefs.setString('link', _linkedInController.text.trim());
      // await prefs.setString('gitHubLink', _gitHubController.text.trim());
      // await prefs.setString('portfolioLink', _portfolioController.text.trim());
      // await prefs.setString('otherLink', _otherController.text.trim());

      // Navigator.of(context).push(
      //   MaterialPageRoute(
      //     builder: (ctx) => NewNavbar(
      //       initTabIndex: 3,
      //       isV: true,
      //     ),
      //   ),
      // );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save links.')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  Widget _buildLinkField({
    required TextEditingController controller,
    required Widget icon,
    required String hintText,
  }) {
    return Column(
      children: [
        CustomTextFieldForEditLinks(
          controller: controller,
          hintText: hintText,
          prefix: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0, left: 10),
                child: icon,
              ),
            ],
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a $hintText link';
            }
            final urlPattern = r'^(https?:\/\/)';
            final regExp = RegExp(urlPattern, caseSensitive: false);
            if (!regExp.hasMatch(value)) {
              return 'Please enter a valid URL';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Links"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildLinkField(
                controller: _linkedInController,
                icon: const FaIcon(FontAwesomeIcons.linkedin, color: Colors.blue, size: 20),
                hintText: 'LinkedIn',
              ),
              // _buildLinkField(
              //   controller: _gitHubController,
              //   icon: const FaIcon(FontAwesomeIcons.github, color: AppColors.black, size: 20),
              //   hintText: 'GitHub',
              // ),
              ElevatedButton(onPressed: (){
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) =>  ProfileScreen()),
                );
              }, child: Text("Profile")),


              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF163EC8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Sizes.radiusSm),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: Sizes.responsiveHorizontalSpace(context),
                    horizontal: Sizes.responsiveMdSm(context),
                  ),
                ),
                onPressed: () async {
                  print("Clicking");
                  await _saveLinks();
                },
                child: const Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.white,
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
