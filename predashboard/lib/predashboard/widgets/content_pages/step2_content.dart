
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:pre_dashboard/API.dart';
import 'package:pre_dashboard/predashboard/Services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../bloc/user_bloc.dart';
import '../../constants/constants.dart';

class Step2Content extends StatefulWidget {
  const Step2Content({
    Key? key,
    required this.formKey,
    required this.email,
    required this.isEmailVerified,
    required this.phoneNumber,
    required this.showOtpScreen,
    required this.emailController,
    required this.phoneController,
    required this.onChangedPhone,
    required this.onVerifyTap,
  }) : super(key: key);

  final GlobalKey<FormState> formKey;
  final bool isEmailVerified;
  final String email;
  final String phoneNumber;
  final bool showOtpScreen;

  final ValueChanged<String> onChangedPhone;
  final VoidCallback onVerifyTap;

  final TextEditingController emailController;
  final TextEditingController phoneController;

  @override
  State<Step2Content> createState() => _Step2ContentState();
}

class _Step2ContentState extends State<Step2Content> {
  bool isEmailFilled = false;
  bool _isEmailVerified = false; // Local state for email verification
  bool showOtpScreen=false;
  List<String> otpDigits = ["", "", "", ""]; // Stores OTP digits

  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
    _loadSavedData(); // Load saved data when widget initializes
    _setupControllerListeners(); // Set up listeners for text changes
  }
  Future<void> validateOtp(String otp) async {
    // setState(() {
    //   isLoading = true;
    // });
    print("otp is $otp");

    try {
      // final response = await _userService.createPostApi({"otp": otp}, ApiUrls.otpValidation);
      final response = await _userService.createPostApi({"otp": otp,
        "email":widget.email
      }, ApiUrls.EmailOTPValidation);

      // setState(() {
      //   isLoading = false;
      // });

      if (response.statusCode == 200) {
        // print(emailController.text);
        print("Status code is ${response.statusCode}");
        // await _saveToPrefs('isEmailVerified'); // Save verification status
        await _saveToPrefsemail('isEmailVerified', true);
        setState(() {
          _isEmailVerified=true;
         // shouldMove = true;
          //isEmailVerified = true;
       //   showOtpScreen = false;
        });
        // Store the OTP in shared preferences (example usage)
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('otp', otp);



      } else {

        print(response.statusCode);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid OTP. Please try again.'),
            backgroundColor: Color(0xff0F3CC9),
          ),
        );
      }
      //0xff0F3CC9
    } catch (e) {
      // setState(() {
      //   isLoading = false;
      // });
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again later.'),
          backgroundColor: Color(0xff0F3CC9),
        ),
      );
    }
  }

  void _setupControllerListeners() {
    widget.emailController.addListener(() => _saveToPrefs('email'));
    widget.phoneController.addListener(() => _saveToPrefs('phonenumber'));
  }
  Future<void> _saveToPrefsemail(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Future<void> _saveToPrefs(String key) async {
    final prefs = await SharedPreferences.getInstance();
    switch (key) {
      case 'email':
        await prefs.setString(key, widget.emailController.text);
        break;
      case 'phonenumber':
        await prefs.setString(key, widget.phoneController.text);
        break;
      case 'isEmailVerified':
        await prefs.setBool(key, _isEmailVerified);
        break;
    }
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // Update the controllers with saved values
      widget.emailController.text = prefs.getString('email') ?? '';
      widget.phoneController.text = prefs.getString('phonenumber') ?? '';
      _isEmailVerified = prefs.getBool('isEmailVerified') ?? false; // Load email verification status
    });
    print("Loaded Email: ${widget.emailController.text}");
    print("Loaded Phone: ${widget.phoneController.text}");
    print("Email Verified in _loadSavedData: $_isEmailVerified");
  }

  void _validateEmail() {
    final email = widget.emailController.text;
    if (email.isNotEmpty &&
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
            .hasMatch(email)) {
      setState(() {
        isEmailFilled = true;
      });
    } else {
      setState(() {
        isEmailFilled = false;
      });
    }
  }
  Future<void> generateOtp(String email) async {

    Map<String, dynamic> body = {"email": email.trim()};
    print("Body is $body");

    try {
      final response = await _userService.createPostApi(
        body,
        ApiUrls.SendOtpForEmailValidation,
      );

      if (response.statusCode == 201) {
        widget.onVerifyTap();
        String csrfToken = response.headers['set-cookie'] ?? '';
        await storeCSRFToken(csrfToken);
        await saveEmailToSharedPreferences(email.trim());
        setState(() {
           showOtpScreen = true;
          _isEmailVerified = true; // Update email verification status
        });
        print("Email verified is ${_isEmailVerified} in generateOTP");
        // await _saveToPrefs('isEmailVerified'); // Save verification status
      } else {

        print("Email verified is ${_isEmailVerified} in generateOTP");
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        print("Response body: ${response.body}");
        print("Status code: ${response.statusCode}");
        print("Email verified is ${_isEmailVerified}");

        // final errorMessage = responseBody['message'] ?? 'Unknown error';
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text(errorMessage),
        //     duration: const Duration(seconds: 3),
        //   ),
        // );
        String errorMessage = 'Unknown error';
        if (responseBody.containsKey('message')) {
          errorMessage = responseBody['message'];
        } else if (responseBody.containsKey('non_field_errors')) {
          errorMessage = responseBody['non_field_errors'][0];
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      print("Error occurred: \$e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred. Please try again.'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }


  Future<void> checkEmailExists(String email) async {
    // final url = Uri.parse('http://3.109.62.159:8000/accounts/');
    final url = Uri.parse("${ApiUrls.registration}");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        final emailExists = data.any((user) => user['email'] == email);

        if (!emailExists) {
          widget.onVerifyTap();
          Map<String, dynamic> body = {"email": email.trim()};
          print("Body is $body");
          final response = await _userService.createPostApi(
              body, ApiUrls.SendOtpForEmailValidation);

          if (response.statusCode == 200) {
            // String csrfToken = response.headers['set-cookie'] ?? '';
            // await storeCSRFToken(csrfToken);
            // await saveEmailToSharedPreferences(email.trim());
            // setState(() {
            //   _isEmailVerified = true; // Update email verification status
            // });
            // await _saveToPrefs('isEmailVerified'); // Save verification status
          }
          else {
            final Map<String, dynamic> responseBody = jsonDecode(response.body);
            print("Response body: ${response.body}");
            print("Status code: ${response.statusCode}");
            setState(() {
              _isEmailVerified = true; // Update email verification status
            });
            // final errorMessage =
            //     responseBody['message'] ?? 'Unknown error';
            String errorMessage = 'Unknown error';
            if (responseBody.containsKey('message')) {
              errorMessage = responseBody['message'];
            } else if (responseBody.containsKey('non_field_errors')) {
              errorMessage = responseBody['non_field_errors'][0];
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(errorMessage),
                duration: const Duration(seconds: 3),
              ),
            );
          }
        }

        else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.redAccent,
              content: Text('Email does exist'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error fetching email data')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Network error: Unable to fetch data')),
      );
    }
  }

  Future<void> storeCSRFToken(String csrfToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('csrfToken', csrfToken);
  }

  Future<void> saveEmailToSharedPreferences(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('enteredEmail', email);
    print("Saved Email: $email");
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: widget.formKey, // Assign the GlobalKey to the Form
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Email Address*",
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: screenWidth * 0.015),
                  // Email TextFormField using controller only (no initialValue)
                  TextFormField(
                    onTap: () {
                      setState(() {
                        // Reset email verification flag if needed.
                      });
                      print("Email field tapped");
                    },
                    onChanged: (value) {
                      _validateEmail();
                    },
                    controller: widget.emailController,
                    decoration: InputDecoration(
                      contentPadding:
                      EdgeInsets.all(screenWidth * 0.05),
                      hintText: "JohnDoe@gmail.com",
                      errorStyle: const TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                      hintStyle:
                      GoogleFonts.poppins(fontSize: screenWidth * 0.04),
                      suffixIcon: _isEmailVerified
                          ? Image.asset('assets/images/check.png')
                          : Image.asset('assets/images/exclaim.png'),
                      border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(screenWidth * 0.02),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(screenWidth * 0.02),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(screenWidth * 0.02),
                        borderSide: const BorderSide(
                            color: AppColors.primaryColor),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      }
                      if (!RegExp(
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                          .hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      if (!_isEmailVerified) {
                        return 'Please verify to move forward';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: screenWidth * 0.01),
                  Row(
                    children: [
                      const Spacer(),
                      _isEmailVerified
                          ? Container(
                          width:
                          MediaQuery.of(context).size.width * 0.8,
                          decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(screenWidth *
                                  0.001)),
                          child: Text(
                            "Your Email has been verified",
                            style: GoogleFonts.poppins(
                              color: AppColors.linkUnderline,
                            ),
                          ))
                          : ElevatedButton(
                        onPressed: isEmailFilled
                            // ? () => checkEmailExists(
                            // widget.emailController.text)
                            ?()=>generateOtp(widget.emailController.text)
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          const Color(0xff0F3CC9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                screenWidth * 0.02),
                          ),
                        ),
                        child: Text(
                          "Verify Now",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenWidth * 0.03),
                  Text(
                    "Phone Number*",
                    style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: screenWidth * 0.02),
                  // Phone TextFormField using controller only
                  TextFormField(
                    onChanged: widget.onChangedPhone,
                    controller: widget.phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: "+91 ",
                      errorStyle: const TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                      suffixIcon: widget.phoneController.text.length ==
                          10
                          ? Image.asset('assets/images/check.png')
                          : Image.asset('assets/images/exclaim.png'),
                      border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(screenWidth * 0.02),
                        borderSide:
                        const BorderSide(color: Colors.grey),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(screenWidth * 0.02),
                        borderSide:
                        const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(screenWidth * 0.02),
                        borderSide:
                        const BorderSide(color: Colors.blue),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Phone number is required';
                      }
                      if (value.length != 10) {
                        return 'Phone number must be 10 digits';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                ],
              ),
            ),
          ),
        );
      },
    );
  }


}