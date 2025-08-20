import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pre_dashboard/API.dart';
import 'package:pre_dashboard/Internship/SuccessfullyAppliedAlert.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ApiServices {
  static  String baseUrl = '${ApiUrls.baseurl}/api';


  static Future<void> applyForJob(int jobId, BuildContext context) async {
    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    // final String? profileId = prefs.getString('profileId');
    final prefs = await SharedPreferences.getInstance();
    final int? savedId = prefs.getInt('userId');
    if (savedId != null) {
      print("Retrieved id is $savedId");
    } else {
      print("No id found in SharedPreferences");
    }

    if (savedId == null) {
      throw Exception('Profile ID not found in shared preferences');
    }


    try {
      // final profileUrl = '$baseUrl/profiles/$profileId';
      // final profileResponse = await http.get(Uri.parse(profileUrl));
      // if (profileResponse.statusCode != 200) {
      //   throw Exception('Failed to load profile: ${profileResponse.body}');
      // }
      // final profileData = jsonDecode(profileResponse.body);
      // final String registerValue = profileData['register'].toString();

      // Prepare the payload for the job application
      final applicationData = {
        'candidate_status': 'Applied',
        'register': savedId.toString(),
        'fresherjob': jobId.toString(),
      };
      print(applicationData);

      // Post the application data
      final applicationUrl = '$baseUrl/job-applications/';
      final response = await http.post(
        Uri.parse(applicationUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(applicationData),
      );

      if (response.statusCode != 201) {
        print(response.statusCode);
        final responseData = jsonDecode(response.body);
        if (responseData['error'] == 'You have already applied for this fresher job.') {
          // Show a snackbar if the job is already applied
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     content: Text('You have already applied for this job.'),
          //     backgroundColor: Colors.redAccent,
          //   ),
          // );
        }
        throw Exception('Already applied: ${response.body}');
      }


      // showDialog(
      //   context: context,
      //   builder: (BuildContext context) {
      //     return BackdropFilter(
      //       filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      //       child: AlertDialog(
      //         contentPadding: EdgeInsets.zero,
      //         backgroundColor: Colors.white,
      //         shape: RoundedRectangleBorder(
      //           borderRadius: BorderRadius.circular(20),
      //         ),
      //         content: const SuccessfullyAppliedAlert(),
      //       ),
      //     );
      //   },
      // );

    } catch (error) {
      print('Error in applyForJob: $error');
      throw Exception('Failed to apply for the job: $error');
    }
  }
  static Future<void> applyForInternship(int InternshipId, BuildContext context) async {
    String profileId="";
    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    // final String? profileId = prefs.getString('profileId');
    final prefs = await SharedPreferences.getInstance();
    final int? savedId = prefs.getInt('userId');
    if (savedId != null) {
      print("Retrieved id is $savedId");
      profileId=savedId.toString();
      print("ProfileID is $profileId");
    } else {
      print("No id found in SharedPreferences");
    }

    if (savedId == null) {
      print(savedId);
      throw Exception('Profile ID not found in shared preferences');
    }
    else
    {
      print(savedId);
    }

    try {
      print("Saved id is $savedId");
      // final profileUrl = '$baseUrl/profiles/$savedId';
      // final profileResponse = await http.get(Uri.parse(profileUrl));
      // if (profileResponse.statusCode != 200) {
      //   throw Exception('Failed to load profile: ${profileResponse.body}');
      // }
      // final profileData = jsonDecode(profileResponse.body);
      // final String registerValue = profileData['register'].toString();

      // Prepare the payload for the job application
      final applicationData = {
        'candidate_status': 'Applied',
        'register': savedId.toString(),
        'internship': InternshipId.toString(),
      };
      print(applicationData);

      // Post the application data
      final applicationUrl = '$baseUrl/internship-applications/';
      final response = await http.post(
        Uri.parse(applicationUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(applicationData),
      );

      if (response.statusCode != 201) {
        print(response.statusCode);
        final responseData = jsonDecode(response.body);
        if (responseData['error'] == 'You have already applied for this internship.') {
          // Show a snackbar if the job is already applied
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     content: Text('You have already applied for this internship.'),
          //     backgroundColor: Colors.redAccent,
          //   ),
          // );
        }
        throw Exception('Already applied: ${response.body}');
      }

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: AlertDialog(
              contentPadding: EdgeInsets.zero,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              content: const SuccessfullyAppliedAlert(),
            ),
          );
        },
      );

    } catch (error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: AlertDialog(
              contentPadding: EdgeInsets.zero,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              content: const SuccessfullyAppliedAlert(),
            ),
          );
        },
      );
      print('Error in applyForInternship: $error');
      throw Exception('Failed to apply for the Internship: $error');
    }
  }
  static Future<void> applyForExperiencedJob(int jobId, BuildContext context) async {
    String profileId="";
    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    // final String? profileId = prefs.getString('profileId');
    final prefs = await SharedPreferences.getInstance();
    final int? savedId = prefs.getInt('userId');
    if (savedId != null) {
      print("Retrieved id is $savedId");
      // profileId=savedId.toString();
    } else {
      print("No id found in SharedPreferences");
    }

    if (savedId == null) {
      throw Exception('Profile ID not found in shared preferences');
    }

    try {


      // Prepare the payload for the job application
      final applicationData = {
        'candidate_status': 'Applied',
        'register': savedId.toString(),
        'experiencejob': jobId.toString(),
      };
      print(applicationData);

      // Post the application data
      final applicationUrl = '$baseUrl/experience-job-applications/';
      final response = await http.post(
        Uri.parse(applicationUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(applicationData),
      );



      // Show the SuccessfullyAppliedAlert dialog
      print(response.statusCode);
      if (response.statusCode != 201) {
        print(response.statusCode);
        final responseData = jsonDecode(response.body);
        if (responseData['error'] == 'You have already applied for this experience job.') {
          // Show a snackbar if the job is already applied
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     content: Text('You have already applied for this job.'),
          //     backgroundColor: Colors.redAccent,
          //   ),
          // );
        }
        throw Exception('Already applied: ${response.body}');
      }

      // showDialog(
      //   context: context,
      //   builder: (BuildContext context) {
      //     return BackdropFilter(
      //       filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      //       child: AlertDialog(
      //         contentPadding: EdgeInsets.zero,
      //         backgroundColor: Colors.white,
      //         shape: RoundedRectangleBorder(
      //           borderRadius: BorderRadius.circular(20),
      //         ),
      //         content: const SuccessfullyAppliedAlert(),
      //       ),
      //     );
      //   },
      // );

    } catch (error) {
      print('Error in applyForJob: $error');
      throw Exception('Failed to apply for the job: $error');
    }
  }
}
