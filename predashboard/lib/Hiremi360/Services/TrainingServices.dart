// training_service.dart
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pre_dashboard/API.dart';
import 'package:pre_dashboard/SharedPreferences/SharedPreferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrainingService {
  final SharedPreferencesService _sharedPreferencesService = SharedPreferencesService();
  Future<String?> retrieveId() async {
    // final prefs = await SharedPreferences.getInstance();
    // final int? savedId = prefs.getInt('userId');
    final savedId = await _sharedPreferencesService.getUserId();
    if (savedId != null) {
      print("Retrieved id is $savedId");
      return savedId.toString();
    } else {
      print("No id found in SharedPreferences");
      return null;
    }
  }

  Future<List<dynamic>> fetchTrainingPrograms() async {
    print("HEllo in fetchTrainingPrograms" );
    final response = await http.get(Uri.parse('${ApiUrls.training}'));
    if (response.statusCode == 200) {
      List<dynamic> newPrograms = json.decode(response.body);

      final prefs = await SharedPreferences.getInstance();
      String? cachedData = prefs.getString('cachedTrainingPrograms');

      // If cached data is different from new data, update it
      if (cachedData == null || cachedData != response.body) {
        // Cache the new data
        await prefs.setString('cachedTrainingPrograms', response.body);
        print("Training programs is in if #$newPrograms");
        return newPrograms;
      } else {
        print("Training programs is in else #$newPrograms");
        // Load data from cache if no updates
        return json.decode(cachedData);
      }
    } else {
      throw Exception('Failed to load training programs');
    }
  }

  Future<List<dynamic>> fetchUserApplications() async {
    final response = await http.get(Uri.parse('${ApiUrls.trainingApplication}'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load user applications');
    }
  }

  List<Map<String, dynamic>> getAppliedPrograms(List<dynamic> userApplications, String userId, List<dynamic> trainingPrograms) {
    List<Map<String, dynamic>> appliedPrograms = [];

    for (var application in userApplications) {
      if (application['register'].toString() == userId) {
        final trainingProgramId = application['TrainingProgram'];
        final trainingProgram = trainingPrograms.firstWhere(
              (program) => program['id'] == trainingProgramId,
          orElse: () => null,
        );

        if (trainingProgram != null) {
          appliedPrograms.add(trainingProgram);
        }
      }
    }

    return appliedPrograms;
  }
}
