
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:pre_dashboard/API.dart';
import 'dart:ui';
import 'package:pre_dashboard/HomePage/Widget/customPopup.dart';
import 'package:pre_dashboard/SharedPreferences/SharedPreferences.dart';

class VerificationSection extends StatefulWidget {
  final bool isVerified;
  final List<VerificationStep> steps;
  final int currentStep;

  const VerificationSection({
    required this.isVerified,
    super.key,
    this.steps = const [

      VerificationStep(
        number: 1,
        label: 'Complete Profile',
        isCompleted: true,
        isActive: true,
      ),
      VerificationStep(
        number: 2,
        label: 'Verification Payment',
        isCompleted: false,
        isActive: false,
      ),
      VerificationStep(
        number: 3,
        label: 'Wait for Verification',
        isCompleted: false,
        isActive: false,
      ),
      VerificationStep(
        number: 4,
        label: 'Get Lifetime Access',
        isCompleted: false,
        isActive: false,
      ),
    ],
    this.currentStep = 1,
  });

  @override
  State<VerificationSection> createState() => _VerificationSectionState();
}

class _VerificationSectionState extends State<VerificationSection> {
  String fullName="";
  String unique="";
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadUserDetails();

  }
  Future<String?> _loginAndGetToken() async {
    final sharedPreferencesService = SharedPreferencesService();


    String? email = await sharedPreferencesService.getUserEmail();
    String? password = await sharedPreferencesService.getUserPassword();
    final response = await http.post(
      Uri.parse('${ApiUrls.Login}'), // Replace with actual login endpoint
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("Response body is ${response.body}");
      print("Response code is ${response.statusCode}");

      final token = data['access_token']; // Assuming your API returns a token
      getnameAND_AppID(email!,token);

      // await SharedPreferencesHelper.setToken(token);
      // print("Token: $token");
      return token;
    }
    else {

      return null;
    }
  }
  Future<bool> getnameAND_AppID(String email,String accessToken) async {
    print("Email is $email");
    final String apiUrl = "${ApiUrls.registration}";
    try {
      final response = await http.get(Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> users = jsonDecode(response.body);
        for (var user in users) {
          if (user['email'] == email) {
            print("We are in if section");
            setState(() {
              fullName=user['full_name'];
              unique=user['unique'];
            });
          }
          else{
            print("We are in else section");
          }
        }
      }

      else{
        print("Status code is ${response.statusCode} and response body is ${response.body}");
      }
    } catch (e) {
      print('Error checking verification: $e');
    }
    return false;
  }
  final SharedPreferencesService _sharedPreferencesService = SharedPreferencesService();
  Future<void> _loadUserDetails() async {
    setState(() {
      isLoading = true; // Show loading indicator
    });

    print("I am in LoaduserDetails");
    final userDetails = await _sharedPreferencesService.getUserDetails();

    if (userDetails != null) {
      setState(() {
        fullName = userDetails['full_name'] ?? '';
        unique = userDetails['unique'];
        isLoading = false; // Hide loading indicator
      });
      print("Details loaded from SharedPreferences: ${fullName} and ${unique}");
    } else {
      final token = await _loginAndGetToken();
      if (token != null) {
        print("Token fetched successfully.");
      }
      setState(() {
        isLoading = false; // Hide loading indicator
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    print("Widget is verified is ${widget.isVerified}");
    return widget.isVerified ? _buildVerifiedUI(context) : _buildUnverifiedUI(context);
  }

  /// **UI for Verified Users**

  Widget _buildVerifiedUI(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        Container(
          width: screenWidth,
          height: screenHeight * 0.16,
          decoration: BoxDecoration(
            color: const Color(0xFF0F3CC9),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(screenWidth * 0.1),
              bottomRight: Radius.circular(screenWidth * 0.1),
            ),
          ),
        ),
        Positioned(
          left: screenWidth * 0.063,
          top: screenHeight * 0.013,
          child: GestureDetector(
            onTap: () {
              // showCustomPopup(context);
            },
            child: Container(
              width: screenWidth * 0.874,
              height: screenHeight * 0.106,
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(screenWidth * 0.025),
                border: Border.all(color: Colors.blueAccent),
              ),
              child: isLoading
                  ? Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
                  : ClipRRect(
                borderRadius: BorderRadius.circular(screenWidth * 0.025),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "$fullName",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          "App ID: $unique",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenHeight * 0.013,
                          ),
                        ),
                      ],
                    ),
                    Image.asset(
                      "assets/images/VerifiedImage.png",
                      height: 40,
                      width: 145,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }


  /// **UI for Unverified Users**
  Widget _buildUnverifiedUI(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        Container(
          width: screenWidth,
          height: screenHeight * 0.2,
          decoration: BoxDecoration(
            color: const Color(0xFF0F3CC9),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(screenWidth * 0.1),
              bottomRight: Radius.circular(screenWidth * 0.1),
            ),
          ),
        ),
        Positioned(
          left: screenWidth * 0.063,
          top: screenHeight * 0.03,
          child: GestureDetector(
            onTap: () {
              showCustomPopup(context);
            },
            child: Container(
              width: screenWidth * 0.874,
              height: screenHeight * 0.156,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(screenWidth * 0.025),
                border: Border.all(color: Colors.white),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.015),
                  Text(
                    'Verify Your Account Today!',
                    style: TextStyle(
                      color: const Color(0xFF0F3CC9),
                      fontSize: screenWidth * 0.03,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.019),
                  _buildProgressIndicator(context),
                  SizedBox(height: screenHeight * 0.019),
                  _buildVerifyButton(context),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// **Builds the Progress Indicator**
  Widget _buildProgressIndicator(BuildContext context) {
    return CustomPaint(
      painter: StepLinePainter(steps: widget.steps, currentStep: widget.currentStep),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: widget.steps.map((step) => _buildStep(context, step)).toList(),
      ),
    );
  }

  /// **Builds Each Step in the Verification Process**
  Widget _buildStep(BuildContext context, VerificationStep step) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        Container(
          width: screenWidth * 0.0675,
          height: screenWidth * 0.0675,
          decoration: BoxDecoration(
            color: step.isActive ? const Color(0xFF002496) : Colors.white,
            borderRadius: BorderRadius.circular(screenWidth * 0.0675),
            border: Border.all(color: const Color(0xFF0874E3)),
          ),
          child: Center(
            child: step.isCompleted
                ? Icon(
              Icons.check,
              color: Colors.white,
              size: screenWidth * 0.04,
            )
                : Text(
              step.number.toString(),
              style: TextStyle(
                color: step.isActive ? Colors.white : const Color(0xFF0174C8),
                fontSize: screenWidth * 0.03,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.005),
        SizedBox(
          width: screenWidth * 0.18,
          child: Text(
            step.label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF0F3CC9),
              fontSize: screenWidth * 0.0114,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  /// **Builds the "Get Verified" Button**
  Widget _buildVerifyButton(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        showCustomPopup(context);
      },
      child: Container(
        width: screenWidth * 0.75,
        height: screenHeight * 0.0325,
        decoration: BoxDecoration(
          color: const Color(0xFF0F3CC9),
          borderRadius: BorderRadius.circular(screenWidth * 0.0105),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0472E3).withOpacity(0.5),
              blurRadius: screenWidth * 0.037,
              offset: Offset(0, screenHeight * 0.005),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.new_releases, color: Colors.white, size: screenWidth * 0.036),
            SizedBox(width: screenWidth * 0.007),
            Text(
              'Get Verified',
              style: TextStyle(fontSize: screenWidth * 0.035, fontWeight: FontWeight.w500, color: Colors.white),
            ),
            Icon(Icons.chevron_right, color: Colors.white, size: screenWidth * 0.035),
          ],
        ),
      ),
    );
  }
}

class VerificationStep {
  final int number;
  final String label;
  final bool isCompleted;
  final bool isActive;

  const VerificationStep({
    required this.number,
    required this.label,
    this.isCompleted = false,
    this.isActive = false,
  });
}

class StepLinePainter extends CustomPainter {
  final List<VerificationStep> steps;
  final int currentStep;

  StepLinePainter({required this.steps, required this.currentStep});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF0F3CC9)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final stepWidth = size.width / (steps.length);
    final y = size.height * 0.3;

    for (var i = 0; i < steps.length - 1; i++) {
      canvas.drawLine(Offset(stepWidth * (i + 0.5), y), Offset(stepWidth * (i + 1.5), y), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
