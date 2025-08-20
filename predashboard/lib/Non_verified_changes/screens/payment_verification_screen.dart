import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pre_dashboard/API.dart';
import 'package:pre_dashboard/Non_verified_changes/screens/profile_verification_screen.dart';
import 'package:pre_dashboard/Non_verified_changes/widgets/custom_drawer.dart';
import 'package:pre_dashboard/Non_verified_changes/widgets/custombottombar.dart';
import 'package:http/http.dart' as http;
import 'package:pre_dashboard/shared_preferences_helper.dart';


class PaymentVerificationScreen extends StatefulWidget {
  const PaymentVerificationScreen({super.key});

  @override
  State<PaymentVerificationScreen> createState() =>
      _PaymentVerificationScreenState();
}

class _PaymentVerificationScreenState extends State<PaymentVerificationScreen> {
  int currentIndex = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _getProfileIdAndUpdateStatus();
  }
  // Future<void> _getProfileIdAndUpdateStatus() async {
  //   final int? profileId = await SharedPreferencesHelper.getProfileId();
  //
  //   if (profileId != null) {
  //     print('Profile ID retrieved: $profileId');
  //     updateUserVerificationStatus(profileId);
  //   } else {
  //     print('Profile ID not found in SharedPreferences.');
  //   }
  // }
  //
  // Future<void> updateUserVerificationStatus(int userId) async {
  //   final String? token = await SharedPreferencesHelper.getToken();
  //   final response = await http.patch(
  //
  //     // Uri.parse("${ApiUrls.baseurl}/api/registers/$userId/"),
  //     Uri.parse("${ApiUrls.registration}$userId/"),
  //
  //
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer $token', // Add token for authentication
  //     },
  //     body: jsonEncode({'verified': true}),
  //   );
  //
  //   if (response.statusCode == 200) {
  //     print('User verification updated.');
  //   } else {
  //     print('Failed to update verification. Status: ${response.statusCode}, Body: ${response.body}');
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: const CustomDrawer(),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Payment & Verification',
          style: TextStyle(fontSize: 18),
        ),

        actions: [
          IconButton(
            onPressed: () {},
            icon: Stack(
              children: [
                const Icon(
                  Icons.notifications_outlined,
                  color: Colors.black,
                  size: 30,
                ),
                Positioned(
                  top: size.height * 0.001,
                  right: size.width * 0.008,
                  child: Container(
                    height: size.height * 0.015,
                    width: size.width * 0.033,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7.5),
                        color: const Color(0xFFDBE4FF)),
                    child: Center(
                        child: Text(
                          '3',
                          style:
                          TextStyle(fontSize: size.width * 0.023, fontWeight: FontWeight.bold, color: const Color(0xFF0F3CC9)),
                        )),
                  ),
                )
              ],
            ),
          )
        ],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: size.height * 0.03,
            ),
            Image.asset('assets/images/payment_icon.png'),
            SizedBox(
              height: size.height * 0.06,
            ),
            Image.asset('assets/images/Verified (2).png',
            height: size.height*0.045,
            ),
            SizedBox(
              height: size.height * 0.025,
            ),
            RichText(
                text: TextSpan(
                    text: 'Payment Successful\n',
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF163EC8)),
                    children: [
                  TextSpan(
                      text: 'your profile is under verification.',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          height: size.height * 0.003,
                          color: const Color(0xFF163EC8)))
                ])),
            SizedBox(
              height: size.height * 0.09,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProfileVerificationScreen(currentIndex: currentIndex),
                      ));
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F3CC9),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.58))),
                child: const Text(
                  'Continue',
                  style: TextStyle(
                      fontSize: 13.5,
                      color: Colors.white,
                      fontWeight: FontWeight.w300),
                )),
          ],
        )),
      ),
      // bottomNavigationBar: Custombottombar(
      //     currentIndex: currentIndex,
      //     onTabSelected: (index) {
      //       setState(() {
      //         currentIndex = index;
      //       });
      //     }),
    );
  }
}
