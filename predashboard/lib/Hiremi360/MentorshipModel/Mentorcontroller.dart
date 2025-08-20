// controllers/mentorship_controller.dart
import 'dart:convert';
// import 'package:hiremi_version_two/Apis/api.dart';
// import 'package:hiremi_version_two/Hiremi360/Mentorship/Model/MentorshipModel.dart';
import 'package:http/http.dart' as http;
import 'package:pre_dashboard/API.dart';
import 'package:pre_dashboard/Hiremi360/MentorshipModel/MentorshipModel.dart';


class MentorshipController {
  final String apiUrl = '${ApiUrls.mentorship}';

  Future<void> EnrollInMentorship(MentorshipModel mentorshipData) async {
    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        body: json.encode(mentorshipData.toJson()),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        print("Mentorship data successfully posted");
      } else {
        print("Failed to post mentorship data, status code: ${response.statusCode}");
        print("${response.body}");
      }
    } catch (e) {
      print("Error posting mentorship data: $e");
    }
  }
}
