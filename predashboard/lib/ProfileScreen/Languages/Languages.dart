

import 'package:flutter/material.dart';
import 'package:pre_dashboard/API.dart';
import 'package:pre_dashboard/AppSizes/AppSizes.dart';
import 'package:pre_dashboard/HomePage/constants/constantsColor.dart';
import 'package:pre_dashboard/ProfileScreen/Languages/AddLanguages.dart';
import 'package:pre_dashboard/ProfileScreen/Languages/RoundedContainer.dart';
import 'package:pre_dashboard/ProfileScreen/ProfileSummary/OutlinedContainer.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Languages extends StatefulWidget {
  const Languages({Key? key}) : super(key: key);

  @override
  State<Languages> createState() => _LanguagesState();
}

class _LanguagesState extends State<Languages> {
  int? profileId;
  List<String> languagesList = [];

  @override
  void initState() {
    super.initState();
    loadProfileID();
  }

  Future<void> loadProfileID() async {
    final prefs = await SharedPreferences.getInstance();
    profileId = prefs.getInt('profileId');
    if (profileId != null) {
      print("Profile id is $profileId");
      await fetchLanguages();
    }
  }

  // Future<void> fetchLanguages() async {
  //   // final url = Uri.parse('${ApiUrls.baseurl}/api/languages/');
  //   final url = Uri.parse('${ApiUrls.language}');
  //
  //   try {
  //     final response = await http.get(url);
  //     if (response.statusCode == 200) {
  //       List<dynamic> languages = jsonDecode(response.body);
  //       // Filter languages by profileId
  //       List<dynamic> filteredLanguages = languages
  //           .where((lang) => lang['user'] == profileId)
  //           .toList();
  //
  //       if (filteredLanguages.isNotEmpty){
  //         setState(() {
  //           // Only take the languages from the last entry
  //           String lastLanguageEntry = filteredLanguages.last['language'];
  //           // Split the last language entry by spaces
  //           languagesList = lastLanguageEntry.split(' ');
  //           print("language list is $languagesList");
  //         });
  //       }
  //       else {
  //         print("Filtered language is empty");
  //       }
  //     }
  //
  //     else {
  //
  //       print('Failed to fetch languages: ${response.body}');
  //     }
  //   }
  //   catch (e) {
  //     print('Error occurred: $e');
  //   }
  // }
  Future<void> fetchLanguages() async {
    final url = Uri.parse('${ApiUrls.language}');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> languages = jsonDecode(response.body);

        // Filter languages by profileId
        List<String> userLanguages = languages
            .where((lang) => lang['user'] == profileId)
            .map<String>((lang) => lang['name'].toString())
            .toList();

        if (userLanguages.isNotEmpty) {
          setState(() {
            languagesList = userLanguages;
            print("Fetched languages: $languagesList");
          });
        } else {
          print("No languages found for this profile.");
          setState(() {
            languagesList = [];
          });
        }
      } else {
        print('Failed to fetch languages. Status: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return OutlinedContainer(
      showAdd: false,

      showEdit: true,
      onEditTap: () async {
        final result = await
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const AddLanguages()),
        );
        if (result == true) {
          await fetchLanguages(); // Refresh the language list
        }
      },
      title: 'Languages',
      child: languagesList.isNotEmpty
          ? Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: languagesList.map((language) {
          return Padding(
            padding: EdgeInsets.only(
              right: Sizes.responsiveSm(context),
              bottom: Sizes.responsiveSm(context),
            ),
            child: Text(
              language,
              style: TextStyle(
                fontSize: Sizes.responsiveMd(context)*1.25,
                fontWeight: FontWeight.bold,
                // color: AppColors.primary,
                color: Colors.black87
              ),
            ),
          );
        }).toList(),
      )
          : const Text('No languages found.'),
    );
  }
}
