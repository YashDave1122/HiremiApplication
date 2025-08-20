import 'package:flutter/material.dart';
import 'package:pre_dashboard/AppSizes/AppSizes.dart';
import 'package:pre_dashboard/Footer/screens/contact_details.dart';
import 'package:pre_dashboard/HomePage/constants/constantsColor.dart';
import 'package:pre_dashboard/HomePage/screens/HomeScreen.dart';
import 'package:pre_dashboard/ProfileScreen/ContactDetails/ContactDeatils.dart';

import 'package:pre_dashboard/ProfileScreen/Education/Education.dart';
import 'package:pre_dashboard/ProfileScreen/Experience/Experience.dart';
import 'package:pre_dashboard/ProfileScreen/Languages/Languages.dart';
import 'package:pre_dashboard/ProfileScreen/PersonalDeatils/Personal_details.dart';
import 'package:pre_dashboard/ProfileScreen/PersonalLinks/PersonalLinks.dart';
import 'package:pre_dashboard/ProfileScreen/ProfileStatusSection/ProfileStatusSection.dart';

import 'package:pre_dashboard/ProfileScreen/Projects/Projects.dart';
import 'package:pre_dashboard/ProfileScreen/ResumeSection/ResumeSection.dart';
import 'package:pre_dashboard/SharedPreferences/SharedPreferences.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final SharedPreferencesService _prefsService = SharedPreferencesService();
  Map<String, dynamic>? userDetails;
  String Email="";
  String FullName="";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadUserDetails();

  }
  Future<void> _loadUserDetails() async {
    final details = await _prefsService.getUserDetails();
    if (details != null) {
      print("Details is $details");
      setState(() {
        Email = details['email'];
        FullName=details['full_name'];
      });
      print("User details loaded: $userDetails");
      print("Email is $Email");
    } else {
      print("No user details found.");
    }
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Disable back button by returning false
        // return false;
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) =>  HomeScreen(isVerified: true, animation: false, email:Email)),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        body:SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  left: Sizes.responsiveDefaultSpace(context),
                  right: Sizes.responsiveDefaultSpace(context),
                  top: Sizes.responsiveDefaultSpace(context),
                  bottom: Sizes.responsiveXxl(context) * 2.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ProfileStatusSection(),
                  SizedBox(
                    height: Sizes.responsiveMd(context),
                  ),
                  Divider(
                    height: 0.25,
                    thickness: 0.5,
                    color: AppColors.secondaryText,
                  ),
                  SizedBox(
                    height: Sizes.responsiveMd(context),
                  ),
                  ResumeSection(),
                  SizedBox(
                    height: Sizes.responsiveMd(context),
                  ),
                  Text("Personal details",style: TextStyle(
                    fontSize: Sizes.responsiveMd(context)*1.45,
                    color:Color(0xFF163EC8),
                    fontWeight: FontWeight.bold,
                  ),),

                  PersonalInfoForm(),
                  SizedBox(
                    height: Sizes.responsiveMd(context),
                  ),
                  Text("Contact details",style: TextStyle(
                    fontSize: Sizes.responsiveMd(context)*1.45,
                    color:Color(0xFF163EC8),
                    fontWeight: FontWeight.bold,
                  ),),

                  //PersonalInfoForm(),
                  Contactdeatils(),
                  SizedBox(
                    height: Sizes.responsiveMd(context),
                  ),
                  Text("Education Details",style: TextStyle(
                    fontSize: Sizes.responsiveMd(context)*1.45,
                    color:Color(0xFF163EC8),
                    fontWeight: FontWeight.bold,
                  ),),
                  SizedBox(
                    height: Sizes.responsiveMd(context),
                  ),
                  const Education(),
                  SizedBox(
                    height: Sizes.responsiveMd(context),
                  ),
                  Text("Experience",style: TextStyle(
                    fontSize: Sizes.responsiveMd(context)*1.45,
                    color:Color(0xFF163EC8),
                    fontWeight: FontWeight.bold,
                  ),),

                  SizedBox(
                    height: Sizes.responsiveMd(context),
                  ),
                  const Experience(),
                  SizedBox(
                    height: Sizes.responsiveMd(context),
                  ),
                  Text("Projects",style: TextStyle(
                    fontSize: Sizes.responsiveMd(context)*1.45,
                    color:Color(0xFF163EC8),
                    fontWeight: FontWeight.bold,
                  ),),
                  SizedBox(
                    height: Sizes.responsiveMd(context),
                  ),
                  const Projects(),

                  SizedBox(
                    height: Sizes.responsiveMd(context),
                  ),
                  Text("Social Links",style: TextStyle(
                    fontSize: Sizes.responsiveMd(context)*1.45,
                    color:Color(0xFF163EC8),
                    fontWeight: FontWeight.bold,
                  ),),
                  SizedBox(
                    height: Sizes.responsiveMd(context),
                  ),
                  const PersonalLinks(),

                  SizedBox(
                    height: Sizes.responsiveMd(context),
                  ),
                  Text("Languages",style: TextStyle(
                    fontSize: Sizes.responsiveMd(context)*1.45,
                    color:Color(0xFF163EC8),
                    fontWeight: FontWeight.bold,
                  ),),
                  SizedBox(
                    height: Sizes.responsiveMd(context),
                  ),
                  const Languages()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
