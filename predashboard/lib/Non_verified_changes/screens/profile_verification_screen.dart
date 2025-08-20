
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pre_dashboard/HomePage/screens/HomeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:pre_dashboard/Non_verified_changes/widgets/custom_drawer.dart';
import 'package:pre_dashboard/Non_verified_changes/widgets/custombottombar.dart';
import 'package:pre_dashboard/Non_verified_changes/widgets/gradient_progress_bar.dart';
import '../widgets/gradient_text.dart';

class ProfileVerificationScreen extends StatefulWidget {
  final int currentIndex;
  const ProfileVerificationScreen({super.key, required this.currentIndex});

  @override
  State<ProfileVerificationScreen> createState() =>
      _ProfileVerificationScreenState();
}

class _ProfileVerificationScreenState extends State<ProfileVerificationScreen> {
  static const int countdownDuration = 1 * 1 * 2; // 12 hours in seconds
  int remainingTime = countdownDuration;
  Timer? timer;
  String Email="";

  @override
  void initState() {
    super.initState();
    _loadStartTime();
    getUserDetails();
  }
   String userDetailsKey = "userDetails";

  // Future<Map<String, dynamic>?> getUserDetails() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final String? userDetailsJson = prefs.getString(userDetailsKey);
  //   final Map<String, dynamic> userDetails = jsonDecode(userDetailsJson);
  //   if (userDetailsJson != null) {
  //     print("USer detaisls is ${userDetailsJson}");
  //     setState(() {
  //       Email=userDetails['email'].toString();
  //
  //     });
  //     return jsonDecode(userDetailsJson);
  //   }
  //   return null;
  // }
  Future<void> getUserDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userDetailsJson = prefs.getString(userDetailsKey);

    if (userDetailsJson != null) {
      print("User details are: $userDetailsJson");

      final Map<String, dynamic> userDetails = jsonDecode(userDetailsJson);

      setState(() {
        Email = userDetails['email'].toString(); // Ensure you have a state variable `email`
      });
    }
  }



  // void _stopTimer() {
  //   setState(() {
  //     remainingTime = 0;
  //   });
  //   timer?.cancel();
  // }
  void _startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (remainingTime > 0) {
        setState(() {
          remainingTime--;
        });
      } else {
        timer.cancel();
        _clearStoredTime(); // Call function to remove time
      }
    });
  }
  void _stopTimer() async {
    setState(() {
      remainingTime = 0;
    });
    timer?.cancel();
    _clearStoredTime(); // Remove time when user clicks button
  }

  Future<void> _clearStoredTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('verification_start_time'); // Remove stored time
  }



  Future<void> _loadStartTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? startTime = prefs.getInt('verification_start_time');

    int currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    if (startTime == null) {
      // Save the start time if not set
      prefs.setInt('verification_start_time', currentTime);
      startTime = currentTime;
    }

    int elapsedTime = currentTime - startTime;
    remainingTime = countdownDuration - elapsedTime;

    if (remainingTime < 0) {
      remainingTime = 0;
    }

    setState(() {});
    _startTimer();
  }

  // void _startTimer() {
  //   timer = Timer.periodic(const Duration(seconds: 1), (timer) {
  //     if (remainingTime > 0) {
  //       setState(() {
  //         remainingTime--;
  //       });
  //     } else {
  //       timer.cancel();
  //     }
  //   });
  // }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  String formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int secs = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // Calculate progress dynamically
    double progress = 1 - (remainingTime / countdownDuration);

    return Scaffold(
      // drawer: const CustomDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Profile Verification',
          style: TextStyle(fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: size.height * 0.03),
              Image.asset(
                'assets/images/profile_verification_icon.png',
                height: size.height * 0.12,
              ),
              SizedBox(height: size.height * 0.02),
              const GradientText(
                'Verification in Progress',
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF163EC8),
                    Color(0xFF0870FF),
                    Color(0xFF378EFF),
                    Color(0xFF89C1FF),
                  ],
                ),
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: size.height * 0.02),
              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  text: 'Our team is currently verifying your profile, and this\n',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF163EC8)),
                  children: [
                    TextSpan(
                      text: 'process typically takes up to 12 hours.',
                    )
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.04),
              Text(
                formatTime(remainingTime),
                style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF163EC8)),
              ),
              SizedBox(height: size.height * 0.02),
              GradientProgressBar(progress: progress), // Pass dynamic progress
              SizedBox(height: size.height * 0.02),
              Image.asset('assets/images/PV2.png'),
              ElevatedButton(
                onPressed: () {
                  // _stopTimer();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(
                        isVerified: true,
                        animation: false,
                        email: Email,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Finish Verification',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
