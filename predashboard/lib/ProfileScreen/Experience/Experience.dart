
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:pre_dashboard/AppSizes/AppSizes.dart';
import 'package:pre_dashboard/HomePage/constants/constantsColor.dart';
import 'package:pre_dashboard/ProfileScreen/Experience/AddExperience.dart';
import 'package:pre_dashboard/ProfileScreen/Experience/apiServices.dart';
import 'package:pre_dashboard/ProfileScreen/ProfileSummary/OutlinedContainer.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Experience extends StatefulWidget {
  const Experience({Key? key}) : super(key: key);

  @override
  _ExperienceState createState() => _ExperienceState();
}

class _ExperienceState extends State<Experience> {
  List<Map<String, String>> experiences = [];
  final AddExperienceService _apiService = AddExperienceService();


  @override
  void initState() {
    super.initState();
    _loadExperienceDetails();
  }

  Future<void> _loadExperienceDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? profileId = prefs.getInt('profileId');

    if (profileId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile ID not found')),
      );
      return;
    }
    print("Profile id is $profileId");

    final details = await _apiService.getExperienceDetails();

    if (details.isNotEmpty) {
      setState(() {
        experiences = details.map((detail) {
          return {
            'job_title': detail['job_title'] ?? '',
            'company_name': detail['company_name'] ?? '',
            'work_environment': detail['work_environment'] ?? '',
            'start_date': detail['start_date'] ?? '',
            'end_date': detail['end_date'] ?? '',
          };
        }).toList();
      });
    } else {
      print("Details are empty");
    }
  }



  bool isValid() {
    return experiences.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedContainer(
      onEditTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddExperience())),
      title: 'Experience',
      isTrue: isValid(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: experiences
            .map((exp) => ExperienceChild(
            title: exp['job_title'] ?? '',
            company: exp['company_name'] ?? '',
            jobType: exp['work_environment'] ?? '',
            timing: '${exp['start_date'] ?? ''} - ${exp['end_date'] ?? ''}'))
            .toList(),
      ),
    );
  }
}

class ExperienceChild extends StatelessWidget {
  const ExperienceChild({Key? key, required this.title, required this.jobType, required this.company, required this.timing}) : super(key: key);

  final String title, jobType, company, timing;

  String _formatDate(DateTime date) {
    final formatter = DateFormat('MMM yyyy'); // Format to 'Mon Year' (e.g., Aug 2024)
    return formatter.format(date);
  }

  String getFormattedTiming(String timing) {
    final now = DateTime.now();
    final dates = timing.split(' - ');

    if (dates.length == 2) {
      final startDateStr = dates[0];
      final endDateStr = dates[1];

      final startDate = DateTime.parse(startDateStr);
      final endDate = DateTime.parse(endDateStr);

      final formattedStartDate = _formatDate(startDate);
      final formattedEndDate = (endDate.year == now.year &&
          endDate.month == now.month &&
          endDate.day == now.day)
          ? 'Now'
          : _formatDate(endDate);

      return '$formattedStartDate - $formattedEndDate';
    }
    return timing;
  }

  @override
  Widget build(BuildContext context) {
    final formattedTiming = getFormattedTiming(timing);
    print('Timing: $formattedTiming');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // SizedBox(width: 18,),
        Text(
          title,
          style:  TextStyle(
            fontSize: Sizes.responsiveMd(context)*1.25,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: Sizes.responsiveXs(context)*1,
        ),
        Text(
          "$company-$title",
          style:  TextStyle(
            //fontSize: 7.5,
            fontWeight: FontWeight.w500,
            color: AppColors.secondaryText,
          ),
        ),
        SizedBox(
          height: Sizes.responsiveXxs(context),
        ),

        SizedBox(
          height: Sizes.responsiveXxs(context),
        ),
        Text(
           formattedTiming,
          style: TextStyle(
            // fontSize: 7.5,
            fontWeight: FontWeight.w500,

            color: AppColors.secondaryText,
          ),
        ),
        SizedBox(height: Sizes.responsiveSm(context)),
        Divider(
          height: 0.25,
          thickness: 0.25,
          color: AppColors.secondaryText,
        ),
      //  SizedBox(height: Sizes.responsiveMd(context))
      ],
    );
  }
}