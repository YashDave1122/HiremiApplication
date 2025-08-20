// controllers/mentorship_controller.dart
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pre_dashboard/API.dart';
import 'package:pre_dashboard/Hiremi360/CorporateTrainingModel/CorporateTrainingModel.dart';


class CorporateTrainingController {
  final String apiUrl = '${ApiUrls.corporatetraining}';

  Future<void> EnrollInCorporateTraining(CorporateTrainingModel corporateTrainingData) async {
    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        body: json.encode(corporateTrainingData.toJson()),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {


        print("corporateTraining data successfully posted");
      } else {
        print("Failed to post corporateTraining data, status code: ${response.statusCode}");
        print("${response.body}");
      }
    } catch (e) {
      print("Error posting corporateTraining data: $e");
    }
  }
}
