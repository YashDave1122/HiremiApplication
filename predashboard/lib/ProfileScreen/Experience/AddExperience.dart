
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:pre_dashboard/API.dart';
import 'package:pre_dashboard/AppSizes/AppSizes.dart';
import 'package:pre_dashboard/HomePage/constants/constantsColor.dart';
import 'package:pre_dashboard/ProfileScreen/Experience/CustomTextFeildForExperience.dart';
import 'package:pre_dashboard/ProfileScreen/Experience/apiServices.dart';
import 'package:pre_dashboard/ProfileScreen/Profile_screen.dart';
import 'package:pre_dashboard/shared_preferences_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddExperience extends StatefulWidget {
  const AddExperience({Key? key}) : super(key: key);

  @override
  State<AddExperience> createState() => _AddExperienceState();
}

class _AddExperienceState extends State<AddExperience> {
  String environment = '';
  String currentCompany = '';
  final organizationController = TextEditingController();
  final jobTitleController = TextEditingController();
  final skillSetController = TextEditingController();
  final joiningDateController = TextEditingController();
  final EndingDateController = TextEditingController();
  final AddExperienceService _apiService = AddExperienceService();
  DateTime? _selectedDate;
  DateTime? _selectedEndingDate;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadExperienceDetails();
    // fetchExperiences();
  }
  Future<void> fetchExperiences() async {
    final String? token = await SharedPreferencesHelper.getToken();
    print("Token is $token");
    // const String url = "http://3.109.62.159:8000/experiences/";
     String url =ApiUrls.experiences;

    try {
      final response = await http.get(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        print("Full Response Data: ${jsonEncode(data)}"); // Print full JSON response

        // setState(() {
        //   experiences = data;
        //   isLoading = false;
        // });
      } else {
        print("Failed to load data. Status Code: ${response.statusCode}");
        print("Response Body: ${response.body}");

      }
    } catch (e) {
      print("Error fetching data: $e");

    }
  }

  void _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null) {
      setState(() {
        joiningDateController.text = selectedDate.toString().split(' ')[0]; // Format YYYY-MM-DD
      });
    }
  }

  void _selectEndingDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      // Parse the joining date from the controller
      DateTime? joiningDate;
      if (joiningDateController.text.isNotEmpty) {
        joiningDate = DateTime.tryParse(joiningDateController.text);
      }

      // Validate if the ending date is greater than the joining date
      if (joiningDate != null && selectedDate.isBefore(joiningDate)) {
        // Show error if ending date is before joining date
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ending Date should be after Joining Date')),
        );
      } else {
        // If valid, set the ending date in the controller
        setState(() {
          EndingDateController.text = selectedDate.toString().split(' ')[0]; // Format YYYY-MM-DD
        });
      }
    }
  }


  

  // Future<void> _loadExperienceDetails() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final int? profileId = prefs.getInt('profileId');
  //
  //   if (profileId == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Profile ID not found')),
  //     );
  //     return;
  //   }
  //   else
  //     {
  //      print("profile id is in Add Experience $profileId");
  //     }
  //
  //   final details = await _apiService.getExperienceDetails();
  //
  //   if (details.isNotEmpty) {
  //
  //
  //     final firstDetail = details.last;
  //     print("details is $details");
  //     print("details id  is ${firstDetail['id']}");
  //
  //     print("current company is ${firstDetail['current_company']}");
  //     print("work environment is ${firstDetail['work_environment']}");
  //
  //     setState(() {
  //       environment = firstDetail["work_environment"] ?? '';
  //       organizationController.text = firstDetail["company_name"] ?? '';
  //       jobTitleController.text = firstDetail["job_title"] ?? '';
  //       skillSetController.text = firstDetail["skill_used"] ?? '';
  //       joiningDateController.text = firstDetail["start_date"] ?? '';
  //       currentCompany = firstDetail["current_company"] ?? '';
  //       EndingDateController.text = firstDetail["end_date"] ?? '';
  //     });
  //   }
  //   else{
  //     print("Details is empty");
  //   }
  // }
  Future<void> _loadExperienceDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? profileId = prefs.getInt('profileId');

    if (profileId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile ID not found')),
      );
      return;
    }

    print("Profile ID is in Add Experience $profileId");

    // ✅ Load from the correct key in SharedPreferences
    final List<String>? savedDataList = prefs.getStringList('experienceDetails');

    if (savedDataList != null && savedDataList.isNotEmpty) {
      final List<Map<String, dynamic>> experienceList = savedDataList
          .map((data) => jsonDecode(data) as Map<String, dynamic>)
          .toList();

      final savedDetails = experienceList.firstWhere(
            (exp) => exp['user'] == profileId.toString(),
        orElse: () => {},
      );

      if (savedDetails.isNotEmpty) {
        print("Saved Data for Profile ID $profileId: $savedDetails");

        setState(() {
          environment = savedDetails["work_environment"] ?? '';
          organizationController.text = savedDetails["company_name"] ?? '';
          jobTitleController.text = savedDetails["job_title"] ?? '';
          skillSetController.text = savedDetails["skill_used"] ?? '';
          joiningDateController.text = savedDetails["start_date"] ?? '';
          currentCompany = savedDetails["current_company"] ?? '';
          EndingDateController.text = savedDetails["end_date"] ?? '';
        });
      } else {
        print("No matching experience found for Profile ID $profileId.");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No experience data found for this profile')),
        );
      }
    } else {
      print("No saved experience data in SharedPreferences.");
    }
  }





  // Future<bool> _saveExperience() async {
  //   print("Clicking");
  //   if (_formKey.currentState!.validate()) {
  //     final SharedPreferences prefs = await SharedPreferences.getInstance();
  //     final String? profileId = prefs.getInt('profileId')?.toString();
  //
  //     if (profileId == null) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Profile ID not found')),
  //       );
  //       return false;
  //     }
  //     else
  //       {
  //         print("Profile id is $profileId");
  //       }
  //
  //     final details = {
  //       // "work_environment": environment,
  //       // "company_name": organizationController.text,
  //       // "job_title": jobTitleController.text,
  //       // "skill_used": skillSetController.text.isEmpty ? null : skillSetController.text,
  //       // "start_date": joiningDateController.text,
  //       // "current_company": currentCompany,
  //       // "end_date": EndingDateController.text,
  //       // "profile": profileId,
  //       "work_environment": environment,
  //       "company_name": organizationController.text,
  //       "job_title": jobTitleController.text,
  //       // "skill_used": skillSetController.text.isEmpty ? null : skillSetController.text,
  //       "start_date": joiningDateController.text,
  //       "current_company": currentCompany,
  //       "end_date": EndingDateController.text,
  //       "user": profileId,
  //     };
  //     print("Sending payload: ${(details)}");
  //
  //     final success = await _apiService.addExperience(details);
  //
  //     if (success) {
  //       // Navigator.of(context).push(
  //       //   MaterialPageRoute(builder: (context) => ProfileScreen()),
  //       // );
  //       List<String> existingExperiences = prefs.getStringList('experiences') ?? [];
  //
  //       // Convert new data to JSON and add to list
  //       existingExperiences.add(jsonEncode(details));
  //
  //       // Save back to SharedPreferences
  //       await prefs.setStringList('experiences', existingExperiences);
  //       print("Existing Experiencedd details are $existingExperiences");
  //
  //       print("Experience saved in SharedPreferences.");
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Failed to add experience details')),
  //       );
  //       return false;
  //     }
  //   }
  //   return false;
  // }
  Future<bool> _saveExperience() async {
    print("Clicking");
    if (_formKey.currentState!.validate()) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? profileId = prefs.getInt('profileId')?.toString();

      if (profileId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile ID not found')),
        );
        return false;
      } else {
        print("Profile id is $profileId");
      }

      final details = {
        // "employement_type": environment,
        "company_name": organizationController.text,
        "job_title": jobTitleController.text,
        "start_date": joiningDateController.text,
        "current_company": currentCompany,
        "end_date": EndingDateController.text,
        "user": profileId,
      };
      print("Sending payload: $details");

      final success = await _apiService.addExperience(details);

      if (success) {
        List<String> existingExperiences = prefs.getStringList('experienceDetails') ?? [];

        // Convert to a list of maps for easy manipulation
        List<Map<String, dynamic>> experienceList = existingExperiences
            .map((e) => jsonDecode(e) as Map<String, dynamic>)
            .toList();

        // ✅ Remove any existing experience for the same profileId
        experienceList.removeWhere((exp) => exp['user'] == profileId);

        // ✅ Add or Update the Experience
        experienceList.add(details);

        // Save back to SharedPreferences using the correct key
        final updatedExperiences = experienceList.map((e) => jsonEncode(e)).toList();
        await prefs.setStringList('experienceDetails', updatedExperiences);

        print("Updated Experience Details: $updatedExperiences");
        print("Experience saved in SharedPreferences.");
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add experience details')),
        );
        return false;
      }
    }
    return false;
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.only(
          top: Sizes.responsiveXl(context),
          right: Sizes.responsiveDefaultSpace(context),
          bottom: kToolbarHeight,
          left: Sizes.responsiveDefaultSpace(context),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // const Text(
              //   'Experience',
              //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              // ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            const Text(
                              'Organization Name',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                            Text(
                              '*',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primary,
                              ),
                            ),
                          ]),
                          SizedBox(
                            height: Sizes.responsiveXs(context),
                          ),
                          CustomTextFieldForExperience(
                            controller: organizationController,
                            hintText: '',
                            validator: (value) {
                              final characterRegex =
                              RegExp(r'^[a-zA-Z\s]+$'); // Regular expression for letters and spaces

                              if (value == null || value.isEmpty) {
                                return 'Organization Name is required';
                              } else if (!characterRegex.hasMatch(value)) {
                                return 'Only letters are allowed';
                              }
                              return null;
                            },
                          ),
                        ]),
                  ),
                  SizedBox(width: Sizes.responsiveSm(context)),
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            const Text(
                              'Job Title',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                            Text(
                              '*',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primary,
                              ),
                            ),
                          ]),
                          SizedBox(
                            height: Sizes.responsiveXs(context),
                          ),
                          CustomTextFieldForExperience(
                            controller: jobTitleController,
                            hintText: '',
                            validator: (value) {
                              final characterRegex =
                              RegExp(r'^[a-zA-Z\s]+$'); // Regular expression for letters and spaces

                              if (value == null || value.isEmpty) {
                                return 'Job Title is required';
                              } else if (!characterRegex.hasMatch(value)) {
                                return 'Only letters are allowed';
                              }
                              return null;
                            },
                          ),
                        ]),
                  ),
                ],
              ),
              SizedBox(
                height: Sizes.responsiveMd(context) * 0.4,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    const Text(
                      'Joining Date',
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '*',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    ),
                  ]),
                  SizedBox(
                    height: Sizes.responsiveSm(context) * 1.4,
                  ),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Sizes.radiusXs),
                          border: Border.all(width: 0.37, color: AppColors.black),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.calendar_today,
                                size: 14,
                                color: AppColors.secondaryText,
                              ),
                            ),
                            const VerticalDivider(
                              thickness: 1.0,
                              width: 0.37,
                              color: AppColors.black,
                            ),
                            Expanded(
                              child: TextField(
                                controller: joiningDateController,
                                cursorColor: AppColors.black,
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'YYYY-MM-DD',
                                  suffixIconColor: AppColors.secondaryText,
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: Sizes.responsiveSm(context),
                                    horizontal: Sizes.responsiveMd(context),
                                  ),
                                  alignLabelWithHint: true,
                                  hintStyle: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.secondaryText,
                                  ),
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Sizes.responsiveMd(context),
                  ),
                  Row(
                    children: [
                      const Text(
                        'Is this your current company?',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
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
                  SizedBox(
                    height: Sizes.responsiveMd(context) * 0.4,
                  ),
                  Row(
                    children: [
                      Row(
                        children: [
                          Radio<String>(
                            activeColor: Colors.blue,
                            value: 'YES',
                            groupValue: currentCompany,
                            onChanged: (value) => setState(() {
                              currentCompany = value!;
                            }),
                          ),
                          Text(
                            'Yes',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 11,
                              color: currentCompany == 'YES'
                                  ? Colors.black
                                  : AppColors.secondaryText,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Radio<String>(
                            activeColor: Colors.blue,
                            value: 'NO',
                            groupValue: currentCompany,
                            onChanged: (value) {
                              setState(() {
                                currentCompany = value!;
                              });
                            },
                          ),
                          Text(
                            'No',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 11,
                              color: currentCompany == 'NO'
                                  ? Colors.black
                                  : AppColors.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Sizes.responsiveMd(context),
                  ),
                  Row(children: [
                    const Text(
                      'Ending Date',
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '*',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    ),
                  ]),
                  SizedBox(
                    height: Sizes.responsiveSm(context),
                  ),
                  GestureDetector(
                    onTap: () => _selectEndingDate(context),
                    child: AbsorbPointer(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Sizes.radiusXs),
                          border: Border.all(width: 0.37, color: AppColors.black),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.calendar_today,
                                size: 14,
                                color: AppColors.secondaryText,
                              ),
                            ),
                            const VerticalDivider(
                              thickness: 1.0,
                              width: 0.37,
                              color: AppColors.black,
                            ),
                            Expanded(
                              child: TextField(
                                controller: EndingDateController,
                                cursorColor: AppColors.black,
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'YYYY-MM-DD',
                                  suffixIconColor: AppColors.secondaryText,
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: Sizes.responsiveSm(context),
                                    horizontal: Sizes.responsiveMd(context),
                                  ),
                                  alignLabelWithHint: true,
                                  hintStyle: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.secondaryText,
                                  ),
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: Sizes.responsiveMd(context) ,
              ),
              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     const Text(
              //       'Employement type',
              //       style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              //     ),
              //     Text(
              //       '*',
              //       style: TextStyle(
              //         fontSize: 12,
              //         fontWeight: FontWeight.w500,
              //         color: AppColors.primary,
              //       ),
              //     ),
              //   ],
              // ),
              // SizedBox(
              //   height: Sizes.responsiveMd(context) * 0.4,
              // ),

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceAround,
              //   children: [
              //     Row(
              //       children: [
              //         Radio<String>(
              //           activeColor: Colors.blue,
              //           // value: 'On-Site',
              //           value: 'Full-time',
              //           groupValue: environment,
              //           onChanged: (value) => setState(() {
              //             environment = value!;
              //           }),
              //         ),
              //         Text(
              //           'Full-time',
              //           style: TextStyle(
              //             fontWeight: FontWeight.w400,
              //             fontSize: 11,
              //             color: environment == 'Full-time'
              //                 ? Colors.black
              //                 : AppColors.secondaryText,
              //           ),
              //         ),
              //       ],
              //     ),
              //     Row(
              //       children: [
              //         Radio<String>(
              //           activeColor: Colors.blue,
              //           value: 'Part Time',
              //           groupValue: environment,
              //           onChanged: (value) {
              //             setState(() {
              //               environment = value!;
              //             });
              //           },
              //         ),
              //         Text(
              //           'Part Time',
              //           style: TextStyle(
              //             fontWeight: FontWeight.w400,
              //             fontSize: 11,
              //             color: environment == 'Part Time'
              //                 ? Colors.black
              //                 : AppColors.secondaryText,
              //           ),
              //         ),
              //       ],
              //     ),
              //     Row(
              //       children: [
              //         Radio<String>(
              //           activeColor: Colors.blue,
              //           value: 'Internship',
              //           groupValue: environment,
              //           onChanged: (value) {
              //             setState(() {
              //               environment = value!;
              //             });
              //           },
              //         ),
              //         Text(
              //           'Internship',
              //           style: TextStyle(
              //             fontWeight: FontWeight.w400,
              //             fontSize: 11,
              //             color: environment == 'Internship'
              //                 ? Colors.black
              //                 : AppColors.secondaryText,
              //           ),
              //         ),
              //       ],
              //     ),
              //     // Row(
              //     //   children: [
              //     //     Radio<String>(
              //     //       activeColor: Colors.blue,
              //     //       value: 'Internship',
              //     //       groupValue: environment,
              //     //       onChanged: (value) {
              //     //         setState(() {
              //     //           environment = value!;
              //     //         });
              //     //       },
              //     //     ),
              //     //     Text(
              //     //       'Internship',
              //     //       style: TextStyle(
              //     //         fontWeight: FontWeight.w400,
              //     //         fontSize: 11,
              //     //         color: environment == 'Internship'
              //     //             ? Colors.black
              //     //             : AppColors.secondaryText,
              //     //       ),
              //     //     ),
              //     //   ],
              //     // ),
              //   ],
              // ),
              SizedBox(
                height: Sizes.responsiveMd(context) * 0.4,
              ),

              SizedBox(
                height: Sizes.responsiveMd(context) * 0.4,
              ),

              SizedBox(
                height: Sizes.responsiveMd(context),
              ),



              SizedBox(height: Sizes.responsiveMd(context)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ElevatedButton(onPressed: (){
                  //   Navigator.of(context).push(
                  //     MaterialPageRoute(builder: (context) =>  ProfileScreen()),
                  //   );
                  // }, child: Text("Profile")),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
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
                        bool success = await _saveExperience();
                        if (success) {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => ProfileScreen()),
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
              SizedBox(
                height: Sizes.responsiveXs(context) * 2,
              ),
            ]),
          ),
        ),
      ),
    );
  }
}