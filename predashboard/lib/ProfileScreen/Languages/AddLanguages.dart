//
// import 'package:flutter/material.dart';
// import 'package:pre_dashboard/API.dart';
// import 'package:pre_dashboard/AppSizes/AppSizes.dart';
// import 'package:pre_dashboard/HomePage/constants/constantsColor.dart';
// import 'package:pre_dashboard/ProfileScreen/Languages/TextFeildsWithTitle.dart';
// import 'package:pre_dashboard/ProfileScreen/Profile_screen.dart';
// import 'package:pre_dashboard/shared_preferences_helper.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// class AddLanguages extends StatefulWidget {
//   const AddLanguages({Key? key}) : super(key: key);
//
//   @override
//   State<AddLanguages> createState() => _AddLanguagesState();
// }
//
// class _AddLanguagesState extends State<AddLanguages> {
//   final TextEditingController languageController = TextEditingController();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   int? profileId;
//   List<String> userLanguages = [];
//   // bool _isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchAndLoadLanguages();
//   }
//
//
//   Future<void> _fetchAndLoadLanguages() async {
//     final prefs = await SharedPreferences.getInstance();
//     profileId = prefs.getInt('profileId');
//
//     if (profileId == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Profile ID not found.')),
//       );
//       return;
//     }
//     else
//       {
//         print("profile id in Addlanguages is $profileId");
//       }
//
//     try {
//       final response = await http.get(Uri.parse('${ApiUrls.language}'));
//
//       if (response.statusCode == 200) {
//         final List<dynamic> data = json.decode(response.body);
//         print("Fetched Data: $data");
//
//         final List<String> userLanguages = data
//             .where((item) => item['user'] == profileId)
//             .map<String>((item) => item['name'].toString())
//             .toList();
//
//         if (userLanguages.isNotEmpty) {
//           setState(() {
//             languageController.text = userLanguages.join(", ");
//           });
//         } else {
//           print("No languages found for this profile");
//           languageController.clear();
//         }
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to load languages. Error: ${response.statusCode}')),
//         );
//       }
//     } catch (e) {
//       print("Error fetching languages: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Error occurred while fetching languages.')),
//       );
//     }
//   }
//
//
//
//   Future<void> _submitLanguage() async {
//     print("Save button clicked");
//     if (_formKey.currentState!.validate()) {
//       // setState(() {
//       //   _isLoading = true;
//       // });
//
//       final String? token = await SharedPreferencesHelper.getToken();
//       print("Token: $token");
//
//       final language = languageController.text.trim();
//       print("Language: $language");
//
//       if (profileId != null && language.isNotEmpty) {
//         final url = Uri.parse('${ApiUrls.language}');
//         print("API URL: $url");
//
//         final headers = {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         };
//         final body = jsonEncode({
//           'name': language,
//           'user': profileId,
//         });
//         print("Request Body: $body");
//
//         try {
//           final response = await http.post(url, headers: headers, body: body);
//           print("Response Status Code: ${response.statusCode}");
//           print("Response Body: ${response.body}");
//
//           if (response.statusCode == 201) {
//             Navigator.of(context).push(
//               MaterialPageRoute(builder: (context) =>  ProfileScreen()),
//             );
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('Language saved successfully!')),
//             );
//           } else {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('Failed to save language.')),
//             );
//           }
//         } catch (e) {
//           print("Error saving language: $e");
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Error occurred while saving language.')),
//           );
//         }
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Profile ID or language is missing.')),
//         );
//       }
//
//       // setState(() {
//       //   _isLoading = false;
//       // });
//     } else {
//       print("Form validation failed");
//     }
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       resizeToAvoidBottomInset: false,
//       appBar: AppBar(
//         title: const Text('Edit Profile'),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.only(
//             top: Sizes.responsiveXl(context),
//             right: Sizes.responsiveDefaultSpace(context),
//             bottom: kToolbarHeight,
//             left: Sizes.responsiveDefaultSpace(context),
//           ),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Languages',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//                 ),
//                 SizedBox(height: Sizes.responsiveMd(context)),
//                 TextFieldWithTitle(
//                   controller: languageController,
//                   title: 'Add Language',
//                   hintText: 'eg: Hindi, English etc.',
//                   validator: (value) {
//                     final characterRegex = RegExp(r'^[a-zA-Z\s]+$');
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter a language';
//                     }
//                     // else if (!characterRegex.hasMatch(value)) {
//                     //   return 'Only characters are allowed';
//                     // }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: Sizes.responsiveMd(context) * 2),
//                 ElevatedButton(onPressed: (){
//                   Navigator.of(context).push(
//                     MaterialPageRoute(builder: (context) =>  ProfileScreen()),
//                   );
//                 }, child: Text("Profile")),
//                 Center(
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Color(0xFF163EC8),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(Sizes.radiusSm),
//                       ),
//                       padding: EdgeInsets.symmetric(
//                         vertical: Sizes.responsiveHorizontalSpace(context),
//                         horizontal: Sizes.responsiveMdSm(context),
//                       ),
//                     ),
//                     // onPressed: _isLoading ? null : _submitLanguage,
//                     onPressed:_submitLanguage,
//                     // onPressed:(){},
//                     child: const Text(
//                       'Save',
//                       style: TextStyle(
//                         fontSize: 12,
//                         fontWeight: FontWeight.w500,
//                         color: AppColors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
import 'package:flutter/material.dart';
import 'package:pre_dashboard/API.dart';
import 'package:pre_dashboard/AppSizes/AppSizes.dart';
import 'package:pre_dashboard/HomePage/constants/constantsColor.dart';
import 'package:pre_dashboard/ProfileScreen/Languages/TextFeildsWithTitle.dart';
import 'package:pre_dashboard/ProfileScreen/Profile_screen.dart';
import 'package:pre_dashboard/shared_preferences_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddLanguages extends StatefulWidget {
  const AddLanguages({Key? key}) : super(key: key);

  @override
  State<AddLanguages> createState() => _AddLanguagesState();
}

class _AddLanguagesState extends State<AddLanguages> {
  final TextEditingController languageController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int? profileId;
  List<Map<String, dynamic>> userLanguages = [];

  @override
  void initState() {
    super.initState();
    _fetchAndLoadLanguages();
  }

  // ✅ Fetch Existing Languages
  Future<void> _fetchAndLoadLanguages() async {
    final prefs = await SharedPreferences.getInstance();
    profileId = prefs.getInt('profileId');

    if (profileId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile ID not found.')),
      );
      return;
    }

    try {
      final response = await http.get(Uri.parse('${ApiUrls.language}'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print("Fetched Data: $data");

        userLanguages = data
            .where((item) => item['user'] == profileId)
            .map<Map<String, dynamic>>((item) => {
          'id': item['id'],
          'name': item['name'].toString(),
        })
            .toList();

        if (userLanguages.isNotEmpty) {
          setState(() {
            languageController.text =
                userLanguages.map((e) => e['name']).join(", ");

          });
        } else {
          print("No languages found for this profile");
          languageController.clear();
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
              Text('Failed to load languages. Error: ${response.statusCode}')),
        );
      }
    } catch (e) {
      print("Error fetching languages: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error occurred while fetching languages.')),
      );
    }
  }


  // Future<void> _submitLanguage() async {
  //   if (!_formKey.currentState!.validate()) {
  //     print("Form validation failed");
  //     return;
  //   }
  //
  //   final String? token = await SharedPreferencesHelper.getToken();
  //   if (token == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Token not found.')),
  //     );
  //     return;
  //   }
  //
  //   final enteredLanguages = languageController.text
  //       .trim()
  //       .split(',')
  //       .map((e) => e.trim().toLowerCase()) // Normalize input
  //       .toList();
  //
  //   for (var language in enteredLanguages) {
  //     if (language.isEmpty) continue;
  //
  //     // ✅ Find Existing Language using Case-Insensitive Match
  //     // final existingLanguage = userLanguages.firstWhere(
  //     //       (item) => item['name'].toLowerCase() == language,
  //     //   orElse: () => {},
  //     // );
  //     final existingLanguage = userLanguages.firstWhere(
  //           (item) => item['name'].toLowerCase() == language,
  //       orElse: () => {}, // Return an empty map instead of null
  //     );
  //     print("Existing language is $existingLanguage");
  //
  //     if (existingLanguage.isNotEmpty) {
  //       print("Language '${existingLanguage['name']}' already exists with ID: ${existingLanguage['id']}");
  //       await _patchLanguage(existingLanguage['id'], language, token);
  //     } else {
  //       print("Adding new language: $language");
  //       await _addLanguage(language, token);
  //     }
  //
  //   }
  //
  //   await _fetchAndLoadLanguages();
  // }
  Future<void> _submitLanguage() async {
    if (!_formKey.currentState!.validate()) {
      print("Form validation failed");
      return;
    }

    final String? token = await SharedPreferencesHelper.getToken();
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Token not found.')),
      );
      return;
    }

    final enteredLanguages = languageController.text
        .trim()
        .split(',')
        .map((e) => e.trim().toLowerCase())
        .toList();

    if (userLanguages.isEmpty) {
      // ✅ No previous language → POST
      print("No languages found. Adding new languages.");
      for (var language in enteredLanguages) {
        if (language.isNotEmpty) {
          await _addLanguage(language, token);
        }
      }
    } else {
      // ✅ Languages exist → Perform checks
      for (var language in enteredLanguages) {
        if (language.isEmpty) continue;

        // Check if the language already exists (case-insensitive)
        final existingLanguage = userLanguages.firstWhere(
              (item) => item['name'].toLowerCase() == language,
          orElse: () => {},
        );

        if (existingLanguage.isNotEmpty) {
          print("Language '${existingLanguage['name']}' already exists.");
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) =>  ProfileScreen()),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Language '${existingLanguage['name']}' already exists.")),
          );
        } else {
          print("New language detected: $language. Updating the language.");
          // ✅ PATCH to update with the new language
          await _patchLanguage(userLanguages.first['id'], language, token);
        }
      }
    }

    await _fetchAndLoadLanguages();
  }


// ✅ PATCH Existing Language
  Future<void> _patchLanguage(int languageId, String language, String token) async {
    final url = Uri.parse('${ApiUrls.language}$languageId/');
    print("PATCH URL: $url");

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final body = jsonEncode({'name': language});

    try {
      final response = await http.patch(url, headers: headers, body: body);
      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) =>  ProfileScreen()),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$language updated successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update language.')),
        );
      }
    } catch (e) {
      print("Error updating language: $e");
    }
  }

// ✅ POST New Language
  Future<void> _addLanguage(String language, String token) async {
    final url = Uri.parse('${ApiUrls.language}');
    print("POST URL: $url");

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final body = jsonEncode({'name': language, 'user': profileId});

    try {
      final response = await http.post(url, headers: headers, body: body);
      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 201) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) =>  ProfileScreen()),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$language added successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add language.')),
        );
      }
    } catch (e) {
      print("Error adding language: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: Sizes.responsiveXl(context),
            right: Sizes.responsiveDefaultSpace(context),
            bottom: kToolbarHeight,
            left: Sizes.responsiveDefaultSpace(context),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Languages',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: Sizes.responsiveMd(context)),
                TextFieldWithTitle(
                  controller: languageController,
                  title: 'Add Language',
                  hintText: 'eg: Hindi, English etc.',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a language';
                    }
                    return null;
                  },
                ),
                SizedBox(height: Sizes.responsiveMd(context) * 2),
                ElevatedButton(onPressed: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) =>  ProfileScreen()),
                  );
                }, child: Text("Profile")),
                // Center(
                //   child: ElevatedButton(
                //     onPressed: _submitLanguage,
                //     child: const Text('Save'),
                //   ),
                // ),


                Center(
                  child: ElevatedButton(
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
                    // onPressed: _isLoading ? null : _submitLanguage,
                    onPressed:_submitLanguage,
                    // onPressed:(){},
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
