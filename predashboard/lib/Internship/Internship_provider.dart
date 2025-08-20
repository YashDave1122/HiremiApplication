import 'package:flutter/material.dart';
import 'package:pre_dashboard/Internship/apiservices.dart';

import '../API.dart';


class InternshipProvider with ChangeNotifier {
  List<dynamic> _jobs = [];
  List<dynamic> _applications = [];
  int? userId;
  bool _isLoading = false; // Add this

  List<dynamic> get jobs => _jobs;
  List<dynamic> get applications => _applications;
  bool get isLoading => _isLoading; // Add this

  Future<void> setUserId(int id) async {
    userId = id;
    notifyListeners();
  }

  Future<void> fetchJobs() async {
    _isLoading = true; // Start loading
    print("badde we are in internship");
    final apiService = ApiService('${ApiUrls.baseurl}/api/internship/');
    _jobs = await apiService.fetchData();
    _isLoading = false; // End loading
    notifyListeners();
  }

  Future<void> fetchApplications() async {
    final apiService = ApiService('${ApiUrls.baseurl}/api/internship-applications/');
    _applications = await apiService.fetchData();
    _isLoading = false; // End loading
    notifyListeners();
  }
  void updateApplicationStatus(int internshipId, bool isApplied) {
    final job = _jobs.firstWhere((job) => job['id'] == internshipId, orElse: () => null);
    if (job != null) {
      job['isApplied'] = isApplied;
      notifyListeners(); // Notify listeners to update the UI
    }
  }
}
