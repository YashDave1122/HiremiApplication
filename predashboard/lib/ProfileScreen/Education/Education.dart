
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pre_dashboard/API.dart';
import 'package:pre_dashboard/AppSizes/AppSizes.dart';
import 'package:pre_dashboard/HomePage/constants/constantsColor.dart';
import 'package:pre_dashboard/ProfileScreen/Education/AddEducation.dart';
import 'package:pre_dashboard/ProfileScreen/Education/apiServices.dart';
import 'package:pre_dashboard/ProfileScreen/ProfileSummary/OutlinedContainer.dart';
import 'package:pre_dashboard/SharedPreferences/SharedPreferences.dart';
import 'package:http/http.dart' as http;


class Education extends StatefulWidget {
  const Education({Key? key}) : super(key: key);

  @override
  _EducationState createState() => _EducationState();
}

class _EducationState extends State<Education> {
  List<Map<String, String>> education = [];
  final SharedPreferencesService _prefsService = SharedPreferencesService();
  int chosencityforcollege = 0;
  String selectedState = 'Select State';
  String selectedCity = 'Select District';


  @override
  void initState() {
    super.initState();
    // _loadEducationDetails();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }
  // Future<void> _loadData() async {
  //   final sharedPreferencesService = SharedPreferencesService();
  //   final userDetails = await sharedPreferencesService.getEducationDetails();
  //   print("User Details is $userDetails");
  // }
  Future<void> _loadData() async {
    final userDetails = await _prefsService.getEducationDetails();
    print("User Details is $userDetails");

    if (userDetails != null) {
      setState(() {
        education = [
          {
            "education": userDetails['branch'] ?? 'N/A',
            "degree": userDetails['degree'] ?? 'N/A',
            "passing_year": userDetails['passing_year'].toString(),
            "marks": userDetails['percentage'].toString(),
          }
        ];
      });
    } else {
      print("User details are null");
    }
  }


  bool isValid() {
    return education.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedContainer(

      onAddTap: () async {
      print("HEEDECXDCinggggggggggggggg");
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => AddEducation(isEditing: false),
        ),
      );
      _loadData();

      },
      onEditTap: ()async{
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AddEducation(isEditing: true),
          ),
        );
        _loadData();
      },
      title: "Education",
      isTrue: isValid(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: education
            .map((edu) => EducationChild(
          course: edu['education'] ?? '',
          place: edu['degree'] ?? '',
          duration: edu['passing_year'] ?? '',
          passoutYear:edu['passing_year']?? '',
            marks:edu['marks']?? '',

        ))
            .toList(),
      ),
    );
  }
}

class EducationChild extends StatelessWidget {
  const EducationChild({Key? key, required this.course, required this.place, required this.duration,required this.passoutYear,required this.marks}) : super(key: key);

  final String course, place, duration,passoutYear,marks;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$course,$place",
          style:  TextStyle(
            // fontSize: 9.5,
            fontSize: Sizes.responsiveMd(context)*1.25,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: Sizes.responsiveXs(context),
        ),

        Text(
          "$passoutYear | Percentage:$marks% ",
          style: TextStyle(
            fontSize: Sizes.responsiveMd(context)*1.05,
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
        SizedBox(height: Sizes.responsiveMd(context)),
      ],
    );
  }
}
