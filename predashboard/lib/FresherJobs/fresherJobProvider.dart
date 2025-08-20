import 'package:flutter/material.dart';

import 'package:pre_dashboard/API.dart';
import 'package:pre_dashboard/FresherJobs/apiservices.dart';
import 'package:shared_preferences/shared_preferences.dart';



class JobsProvider with ChangeNotifier {
  List<dynamic> _jobs = [];
  List<dynamic> _applications = [];
  int? _userId;
  bool _isLoading = false;
  List<int> appliedJobs = [];

  List<dynamic> get jobs => _jobs;
  List<dynamic> get applications => _applications;
  int? get userId => _userId;
  bool get isLoading => _isLoading; // Add this
  Future<void> setUserId(int id) async {
    _userId = id;
    notifyListeners();
  }
  // Future<void> fetchAppliedJobs() async {
  //   try {
  //     final response = await ApiService('http://example.com/api/applied-jobs').fetchData();
  //
  //     // Ensure response is a list of maps
  //     if (response is List) {
  //       appliedJobs = response
  //           .where((job) => job is Map && job['id'] is int) // Filter out invalid entries
  //           .map<int>((job) => job['id'] as int) // Cast the job ID to int
  //           .toList();
  //     } else {
  //       throw Exception('Invalid response format');
  //     }
  //
  //     notifyListeners();
  //   } catch (e) {
  //     print('Error fetching applied jobs: $e');
  //     // Handle error as needed
  //   }
  // }

  Future<void> fetchJobs() async {
    final apiService = ApiService('${ApiUrls.baseurl}/api/fresherjob/');
    _jobs = await apiService.fetchData();
    notifyListeners();
  }

  Future<void> fetchApplications() async {
    final apiService = ApiService('http://13.127.81.177:8000/api/job-applications/');
    _applications = await apiService.fetchData();
    notifyListeners();
  }

  Future<void> retrieveId() async {
    final prefs = await SharedPreferences.getInstance();
    _userId = prefs.getInt('userId');
    notifyListeners();
  }

  bool isApplied(int jobId) {
    return _applications
        .where((application) => application['register'] == _userId)
        .map((application) => application['fresherjob'])
        .contains(jobId);
  }
}
