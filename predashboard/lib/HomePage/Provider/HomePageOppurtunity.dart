import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pre_dashboard/API.dart';
import 'dart:convert';



class HomePageOppurtunity extends ChangeNotifier {
  Set<int> appliedJobIds = {};
  Set<int> appliedInternshipIds = {};
  Set<int> appliedExperienceJobIds = {};
  List<dynamic> _jobs = [];
  bool _isLoading = true;

  bool get isLoading => _isLoading;
  List<dynamic> get jobs => _jobs;

  Future<void> fetchAppliedJobs(int userId) async {
    const String jobApplicationsUrl = '${ApiUrls.baseurl}/api/job-applications/';
    const String internshipApplicationsUrl = '${ApiUrls.baseurl}/api/internship-applications/';
    const String experienceJobApplicationsUrl = '${ApiUrls.baseurl}/api/experience-job-applications/';

    try {
      final jobResponse = await http.get(Uri.parse(jobApplicationsUrl));
      final internshipResponse = await http.get(Uri.parse(internshipApplicationsUrl));
      final experienceJobResponse = await http.get(Uri.parse(experienceJobApplicationsUrl));

      if (jobResponse.statusCode == 200 &&
          internshipResponse.statusCode == 200 &&
          experienceJobResponse.statusCode == 200) {
        final List<dynamic> jobApplications = jsonDecode(jobResponse.body);
        final List<dynamic> internshipApplications = jsonDecode(internshipResponse.body);
        final List<dynamic> experienceJobApplications = jsonDecode(experienceJobResponse.body);

        appliedJobIds = jobApplications
            .where((application) => application['register'] == userId)
            .map<int>((application) => application['fresherjob'])
            .toSet();

        appliedInternshipIds = internshipApplications
            .where((application) => application['register'] == userId)
            .map<int>((application) => application['internship'])
            .toSet();

        appliedExperienceJobIds = experienceJobApplications
            .where((application) => application['register'] == userId)
            .map<int>((application) => application['experiencejob'])
            .toSet();

        notifyListeners(); // Notify listeners when applied jobs are updated
      } else {
        print('Failed to fetch job, internship, or experience job applications. Status code: ${jobResponse.statusCode}, ${internshipResponse.statusCode}, ${experienceJobResponse.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> fetchJobs() async {
    const String internshipUrl = '${ApiUrls.baseurl}/api/internship/';
    const String fresherJobUrl = '${ApiUrls.baseurl}/api/fresherjob/';
    const String experiencedJobUrl = '${ApiUrls.baseurl}/api/experiencejob/';

    try {
      final internshipResponse = await http.get(Uri.parse(internshipUrl));
      final fresherJobResponse = await http.get(Uri.parse(fresherJobUrl));
      final experiencedJobResponse = await http.get(Uri.parse(experiencedJobUrl));

      if (internshipResponse.statusCode == 200 &&
          fresherJobResponse.statusCode == 200 &&
          experiencedJobResponse.statusCode == 200) {
        final List<dynamic> internships = jsonDecode(internshipResponse.body);
        final List<dynamic> fresherJobs = jsonDecode(fresherJobResponse.body);
        final List<dynamic> experiencedJobs = jsonDecode(experiencedJobResponse.body);

        List<dynamic> allJobs = [];
        allJobs.addAll(internships.map((job) {
          return {
            ...job,
            'type': 'Internship',
            'isApplied': appliedInternshipIds.contains(job['id']),
            'benefits': job['benefits'],
          };
        }).toList());
        allJobs.addAll(fresherJobs.map((job) {
          return {
            ...job,
            'type': 'Job',
            'isApplied': appliedJobIds.contains(job['id']),
          };
        }).toList());
        allJobs.addAll(experiencedJobs.map((job) {
          return {
            ...job,
            'type': 'Job',
            'fromExperienced': true,
            'isApplied': appliedExperienceJobIds.contains(job['id']),
          };
        }).toList());

        allJobs.sort((a, b) {
          DateTime dateA = DateTime.parse(a['upload_date']);
          DateTime dateB = DateTime.parse(b['upload_date']);
          return dateB.compareTo(dateA);
        });

        _jobs = allJobs;
        _isLoading = false;
        notifyListeners(); // Notify listeners when jobs are fetched
      } else {
        _isLoading = false;
        print('Failed to fetch jobs. Status code: ${internshipResponse.statusCode}, ${fresherJobResponse.statusCode}, ${experiencedJobResponse.statusCode}');
        notifyListeners(); // Notify listeners even if there's a failure
      }
    } catch (e) {
      _isLoading = false;
      print('Error: $e');
      notifyListeners(); // Notify listeners even if there's an error
    }
  }
}
