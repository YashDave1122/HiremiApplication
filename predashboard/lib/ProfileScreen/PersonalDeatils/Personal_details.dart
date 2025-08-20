
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pre_dashboard/AppSizes/AppSizes.dart';
import 'package:pre_dashboard/HomePage/constants/constantsColor.dart';
import 'package:pre_dashboard/ProfileScreen/PersonalDeatils/AddPersonalDetails.dart';
import 'package:pre_dashboard/ProfileScreen/ProfileSummary/OutlinedContainer.dart';
import 'package:pre_dashboard/ProfileScreen/Projects/AddProjects.dart';
import 'package:pre_dashboard/SharedPreferences/SharedPreferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonalInfoForm extends StatefulWidget {
  const PersonalInfoForm({Key? key}) : super(key: key);

  @override
  _PersonalInfoFormState createState() => _PersonalInfoFormState();
}

class _PersonalInfoFormState extends State<PersonalInfoForm> {
  Map<String, dynamic>? userDetails;

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  Future<void> _loadUserDetails() async {
    // final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // final String? userDetailsString = sharedPreferences.getString('userDetails');
    SharedPreferencesService prefsService = SharedPreferencesService();


    // if (userDetailsString != null) {
    //   setState(() {
    //     userDetails = jsonDecode(userDetailsString);
    //   });
    //   print("userDetails are $userDetails");
    //
    // }
    // else{
    //   print("Data is empty");
    // }
    Map<String, dynamic>? storedDetails = await prefsService.getUserDetails();
    print("User details from SharedPreferences storedDetails: $storedDetails");
      setState(() {
        userDetails = storedDetails;
      });
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedContainer(
      showAdd: false,
      onEditTap: () async {
        final result = await Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const AddPersonalDetailsForProfileSection()),
        );

        if (result == true) {
          _loadUserDetails(); // Refresh user details after editing
        }
      },
      title: 'Personal Details',
      child: userDetails == null
          ? const Center(child: CircularProgressIndicator())
          : PersonalInfoFormChild(userDetails: userDetails!),
    );
  }
}

class PersonalInfoFormChild extends StatelessWidget {
  final Map<String, dynamic> userDetails;
  const PersonalInfoFormChild({Key? key, required this.userDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow(context, "Full Name", userDetails['full_name']),
        _buildDetailRow(context, "Father's Full Name", userDetails['father_name']),
        _buildDetailRow(context, "Gender", userDetails['gender']),
        _buildDetailRow(context, "Date of Birth", userDetails['date_of_birth']),

        // _buildDetailRow(context, "Birth Place", userDetails['birth_place']),
        // _buildDetailRow(context, "City", userDetails['city']),
        // _buildDetailRow(context, "Differently Abled", userDetails['differentlyAbled']),
        // _buildDetailRow(context, "Marital Status", userDetails['maritalStatus']),
      ],
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String? value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: Sizes.responsiveMd(context) * 1.25,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: Sizes.responsiveXs(context)*2.3),
        Text(
          value ?? 'N/A', // Handle null values safely
          style: TextStyle(
            fontSize: Sizes.responsiveMd(context),
            color: AppColors.secondaryText,
          ),
        ),
        SizedBox(height: Sizes.responsiveXs(context)*1.3),
        Divider(
          height: 0.25,
          thickness: 0.55,
          color: AppColors.secondaryText,
        ),
        SizedBox(height: Sizes.responsiveXs(context)),
      ],
    );
  }
}
