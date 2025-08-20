import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pre_dashboard/AppSizes/AppSizes.dart';
import 'package:pre_dashboard/HomePage/constants/constantsColor.dart';
import 'package:pre_dashboard/Non_verified_changes/Provider/UserProvider.dart';
import 'package:pre_dashboard/ProfileScreen/Education/CustomTextFeildAddEducation.dart';
import 'package:pre_dashboard/ProfileScreen/Profile_screen.dart';
import 'package:pre_dashboard/SharedPreferences/SharedPreferences.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Addcontactsdeatils extends StatefulWidget {
  const Addcontactsdeatils({super.key});

  @override
  State<Addcontactsdeatils> createState() => _AddcontactsdeatilsState();
}

class _AddcontactsdeatilsState extends State<Addcontactsdeatils> {

  final SharedPreferencesService _sharedPreferencesService = SharedPreferencesService();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadUserDetails();
  }
  // Future<void> _loadUserDetails() async {
  //
  //   final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   final String? userDetailsString = sharedPreferences.getString('userDetails');
  //
  //   if (userDetailsString != null) {
  //     setState(() {
  //       userDetails = jsonDecode(userDetailsString);
  //       phoneNumber.text = userDetails?['phone_number'] ?? '';
  //       whatsAppNumber.text = userDetails?['whatsapp_number'] ?? '';
  //
  //     });
  //
  //     print("User Details: $userDetails");
  //   } else {
  //     print("Data is empty");
  //   }
  // }
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
            phoneNumber.text = userDetails?['phone_number'] ?? '';
            whatsAppNumber.text = userDetails?['whatsapp_number'] ?? '';
    });
  }
  final TextEditingController phoneNumber = TextEditingController();
  final TextEditingController whatsAppNumber = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map<String, dynamic>? userDetails;
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    TextInputType textInputType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
            Text(
              '*',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        SizedBox(height: Sizes.responsiveSm(context)),
        CustomTextFieldAndEducation(
          controller: controller,
          hintText: hintText,
          textInputType: textInputType,
          validator: validator,
        ),
        SizedBox(height: Sizes.responsiveMd(context)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          top: Sizes.responsiveXl(context),
          right: Sizes.responsiveDefaultSpace(context),
          bottom: kToolbarHeight,
          left: Sizes.responsiveDefaultSpace(context),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // _buildTextField(
              //   label: 'Phone Number',
              //   controller: phoneNumber,
              //   hintText: 'Phone Number',
              //   validator: (value) =>
              //   (value == null || value.isEmpty) ? 'Please enter your Phone number' : null,
              // ),
              _buildTextField(
                label: 'Phone Number',
                controller: phoneNumber,
                hintText: 'Phone Number',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  if (value.length != 10 || !RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                    return 'Phone number must be exactly 10 digits';
                  }
                  return null;
                },
              ),

              _buildTextField(
                label: 'Whats App Number',
                controller: whatsAppNumber,
                hintText: 'Whats App Number',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter WhatsApp number';
                  }
                  if (value.length != 10 || !RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                    return 'Phone number must be exactly 10 digits';
                  }
                  return null;
                },
              ),



              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      // backgroundColor: AppColors.primary,
                      backgroundColor: Color(0xFF163EC8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Sizes.radiusSm),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: Sizes.responsiveHorizontalSpace(context),
                        horizontal: Sizes.responsiveMdSm(context),
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // Handle Save logic
                       //  Map<String, dynamic> updatedUserDetails = {
                       //
                       //    'phone_number': phoneNumber.text.trim(),
                       //    'whatsapp_number': whatsAppNumber.text.trim(),
                       //  };
                       //
                       //  // Save the updated details in SharedPreferences
                       // final userId = await _sharedPreferencesService.getUserId();
                       //
                       //  final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                       //  await sharedPreferences.setString('userDetails', jsonEncode(updatedUserDetails));
                       //  await Provider.of<UserProvider>(context, listen: false)
                       //      .updateUserDetails(userId!, updatedUserDetails);
                        Map<String, dynamic> updatedUserDetails = {...userDetails!};
                        updatedUserDetails['phone_number'] = phoneNumber.text.trim();
                        updatedUserDetails['whatsapp_number'] = whatsAppNumber.text.trim();

                        // Save the updated details in SharedPreferences
                        final userId = await _sharedPreferencesService.getUserId();
                        final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                        await sharedPreferences.setString('userDetails', jsonEncode(updatedUserDetails));
                        print("Update user details is $updatedUserDetails");
                        // Update the user details using Provider
                        // await Provider.of<UserProvider>(context, listen: false)
                        //     .updateUserDetails(userId!, updatedUserDetails);
                        bool isSuccess = await Provider.of<UserProvider>(context, listen: false)
                            .updateContactDetails(userId!, updatedUserDetails);
                        if(isSuccess){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileScreen(),
                            ),
                          );
                        }
                      }
                    },
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.white,
                      ),
                    ),
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
