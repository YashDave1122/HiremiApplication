import 'package:flutter/material.dart';
import 'package:pre_dashboard/AppSizes/AppSizes.dart';
import 'package:pre_dashboard/HomePage/constants/constantsColor.dart';
import 'package:pre_dashboard/ProfileScreen/BasicDetails/CustomTextFeild.dart';
import 'package:pre_dashboard/ProfileScreen/BasicDetails/apiServices.dart';
import 'package:pre_dashboard/shared_preferences_helper.dart';

import 'package:shared_preferences/shared_preferences.dart';


class AddBasicDetails extends StatefulWidget {
  const   AddBasicDetails({Key? key}) : super(key: key);

  @override
  State<AddBasicDetails> createState() => _AddBasicDetailsState();
}

class _AddBasicDetailsState extends State<AddBasicDetails> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController cityController;
  late TextEditingController stateController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController whatsappController;
  late TextEditingController looking_forController;
  String profileId = '';
  String _savedEmail="";

  AddBasicDetailsService _apiService = AddBasicDetailsService();

  @override
  void initState() {
    super.initState();
    cityController = TextEditingController();
    stateController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    whatsappController = TextEditingController();
    looking_forController = TextEditingController();
    _loadBasicDetails();
    _printSavedEmail();
  }
  Future<String?> _printSavedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedEmail = prefs.getString('email') ?? 'No email saved';
    });

    print("Saved email is $_savedEmail");
    return null;

  }
  Future<void> _loadBasicDetails() async {
    final service = AddBasicDetailsService();
    final details = await service.getBasicDetails();
    print(details);
    setState(() {
      looking_forController.text = details['looking_for'] ?? '';
      cityController.text = details['city'] ?? '';
      stateController.text = details['state'] ?? '';
      emailController.text= details['email'] ?? '';
      phoneController.text = details['phone_number'] ?? '';
      whatsappController.text = details['whatsapp_number'] ?? '';
    });
  }

  @override
  void dispose() {
    cityController.dispose();
    stateController.dispose();
    emailController.dispose();
    phoneController.dispose();
    whatsappController.dispose();
    looking_forController.dispose();
    super.dispose();
  }

  bool isAllFieldFilled() {
    return looking_forController.text.isNotEmpty &&
        cityController.text.isNotEmpty &&
        stateController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        whatsappController.text.isNotEmpty;
  }

  Future<void> _saveBasicDetails() async {
    if (_formKey.currentState!.validate()) {
      final int? savedId = await SharedPreferencesHelper.getProfileId();
      if (savedId != null) {
        profileId = savedId.toString();
      } else {
        print("No id found in SharedPreferences");
      }

      final details = {
        "looking_for": looking_forController.text,
        "city": cityController.text,
        "state": stateController.text,
        "email": emailController.text.toLowerCase(),
        "phone_number": phoneController.text,
        "whatsapp_number": whatsappController.text,
        "profile": profileId,
      };

      final success = await _apiService.addOrUpdateBasicDetails(details);

      if (success) {
        Navigator.pop(context, true);
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Details added/updated ssaasassasauccessfully')),
        // );
        // Return true to indicate success
      }
      else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add/update details')),
        );
      }
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields correctly')),
      );
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                // Navigator.of(context).push(
                //     MaterialPageRoute(builder: (ctx) => const NotificationScreen()));
              },
              icon: const Icon(Icons.notifications))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
              top: Sizes.responsiveXl(context),
              right: Sizes.responsiveDefaultSpace(context),
              bottom: kToolbarHeight,
              left: Sizes.responsiveDefaultSpace(context)),
          child: Form(
            key: _formKey,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Basic Details',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: Sizes.responsiveMd(context),
                  ),
                  Row(
                    children: [
                      const Text(
                        'Looking for',
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
                    height: Sizes.responsiveMd(context),
                  ),
                  SizedBox(
                    height: Sizes.responsiveMd(context) * 1.3,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Radio(
                              activeColor: Colors.blue,
                              value: 'Internships',
                              groupValue: looking_forController.text,
                              onChanged: (value) => setState(() {
                                looking_forController.text = value as String;
                              }),
                            ),
                            const Text(
                              'Internships',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11,
                                  color: Colors.black),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Radio(
                              activeColor: Colors.blue,
                              value: 'Fresher Job',
                              groupValue: looking_forController.text,
                              onChanged: (value) {
                                setState(() {
                                  looking_forController.text = value as String;
                                });
                              },
                            ),
                            const Text(
                              'Fresher Jobs',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11,
                                  color: Colors.black),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Radio(
                              activeColor: Colors.blue,
                              value: 'Experienced',
                              groupValue: looking_forController.text,
                              onChanged: (value) {
                                setState(() {
                                  looking_forController.text = value as String;
                                });
                              },
                            ),
                            const Text(
                              'Experienced Jobs',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11,
                                  color: Colors.black),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: Sizes.responsiveMd(context),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(children: [
                              const Text(
                                'City',
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
                            CustomTextFieldforBasicDetails(
                              controller: cityController,
                              hintText: 'City',
                              validator: (value) {
                                final characterRegex = RegExp(r'^[a-zA-Z\s]+$');

                                if (value == null || value.isEmpty) {
                                  return 'Please enter your city';
                                } else if (!characterRegex.hasMatch(value)) {
                                  return 'Only letters are allowed';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: Sizes.responsiveMd(context),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              const Text(
                                'State',
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
                            CustomTextFieldforBasicDetails(
                              controller: stateController,
                              hintText: 'State',
                              validator: (value) {
                                final characterRegex = RegExp(r'^[a-zA-Z\s]+$');

                                if (value == null || value.isEmpty) {
                                  return 'Please enter your city';
                                } else if (!characterRegex.hasMatch(value)) {
                                  return 'Only letters are allowed';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: Sizes.responsiveMd(context),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        const Text(
                          'Email Address',
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
                      ]),
                      SizedBox(
                        height: Sizes.responsiveSm(context),
                      ),
                      CustomTextFieldforBasicDetails(
                        controller: emailController,
                        hintText: 'abc@gmail.com',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email address';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          if(value !=_savedEmail){
                            return 'Please entered registered email ';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Sizes.responsiveMd(context),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        const Text(
                          'Phone Number',
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
                      ]),
                      SizedBox(
                        height: Sizes.responsiveSm(context),
                      ),
                      CustomTextFieldforBasicDetails(
                        controller: phoneController,
                        textInputType: TextInputType.number,
                        hintText: 'Phone Number',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                            return 'Please enter a valid 10-digit phone number';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Sizes.responsiveMd(context),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        const Text(
                          'Whatsapp Number',
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
                      ]),
                      SizedBox(
                        height: Sizes.responsiveSm(context),
                      ),
                      CustomTextFieldforBasicDetails(
                        controller: whatsappController,
                        textInputType: TextInputType.number,
                        hintText: 'Whatsapp Number',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your WhatsApp number';
                          }
                          if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                            return 'Please enter a valid 10-digit WhatsApp number';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Sizes.responsiveMd(context),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(Sizes.radiusSm)),
                            padding: EdgeInsets.symmetric(
                                vertical: Sizes.responsiveHorizontalSpace(context),
                                horizontal: Sizes.responsiveMdSm(context)),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _saveBasicDetails();
                            }
                          },


                          child: const Text(
                            'Save',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.white,
                            ),
                          )),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColors.primary, width: 0.5),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(Sizes.radiusSm)),
                          padding: EdgeInsets.symmetric(
                              vertical: Sizes.responsiveSm(context),
                              horizontal: Sizes.responsiveMdSm(context)),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await _saveBasicDetails();
                            // Navigator.of(context).push(MaterialPageRoute(
                            //     builder: (ctx) => AddProfileSummary()));
                          }
                        },

                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Save & Next',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primary,
                              ),
                            ),
                            SizedBox(
                              width: Sizes.responsiveXs(context),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_sharp,
                              size: 11,
                              color: AppColors.primary,
                            )
                          ],
                        ),
                      ),

                    ],
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}

