import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pre_dashboard/API.dart';
import 'package:pre_dashboard/Non_verified_changes/screens/payment_verification_fail_screen.dart';
import 'package:pre_dashboard/Non_verified_changes/screens/payment_verification_screen.dart';
import 'package:pre_dashboard/Non_verified_changes/screens/profile_verification_screen.dart';
import 'package:pre_dashboard/Non_verified_changes/widgets/custom_drawer.dart';
import 'package:pre_dashboard/Non_verified_changes/widgets/custombottombar.dart';
import 'package:pre_dashboard/Non_verified_changes/widgets/unlock_exclusive_features.dart';
import 'package:pre_dashboard/RazorPayPayment/RazorPayPayment.dart';
import 'package:pre_dashboard/shared_preferences_helper.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FinalStepScreen extends StatefulWidget {
  const FinalStepScreen({super.key});

  @override
  State<FinalStepScreen> createState() => _FinalStepScreenState();
}

class _FinalStepScreenState extends State<FinalStepScreen> {
final String apiUrl = '${ApiUrls.discount}';
String discountedPrice="";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAndStoreOriginalPrice();
    _razorpayHelper = RazorpayHelper(); // Initialize here

  }
  bool? paymentStatus;
  bool isButtonDisabled = false;
  int currentIndex = 0;
  late RazorpayHelper _razorpayHelper;


Future<void> fetchAndStoreOriginalPrice() async {
  final response = await http.get(Uri.parse(apiUrl));
  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    if (data.isNotEmpty) {
      setState(() {
        discountedPrice = data[0]['discounted_price'].toString(); // Store the first original price
        print("Discount proce is $discountedPrice");
      });
    }
  } else {
    throw Exception('Failed to load data');
  }
}
Future<void> _getProfileIdAndUpdateStatus() async {
  final int? profileId = await SharedPreferencesHelper.getProfileId();

  if (profileId != null) {
    print('Profile ID retrieved: $profileId');
    updateUserVerificationStatus(profileId);
  } else {
    print('Profile ID not found in SharedPreferences.');
  }
}

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
//     Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) =>
//               PaymentVerificationScreen(),
//         ));
//     print('User verification updated.');
//
//   } else {
//     print('Failed to update verification. Status: ${response.statusCode}, Body: ${response.body}');
//   }
// }


  Future<void> updateUserVerificationStatus(int userId) async {
    final String? token = await SharedPreferencesHelper.getToken();

    // Generate a unique 6-digit number
    final String uniqueId = 'HM${Random().nextInt(900000) + 100000}';

    final response = await http.patch(
      Uri.parse("${ApiUrls.registration}$userId/"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'verified': true, 'unique': uniqueId}),
    );

    if (response.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentVerificationScreen(),
        ),
      );
      print('User verification updated with uniqueId: $uniqueId and response body${response.body}');
    } else {
      print('Failed to update verification. Status: ${response.statusCode}, Body: ${response.body}');
    }
  }

  Future<bool> _makePayment(double Amount) async {
    print("HEDEEE");

    double amount = Amount; // Example amount
    Completer<bool> paymentCompleter = Completer<bool>();

    // Generate Order ID

    _razorpayHelper.generateOrderId(
      amount: amount,
      onOrderIdGenerated: (orderId) async {
        print('Order ID generated: $orderId');
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('ORDERID', orderId);  // Save the orderId
        // Start Payment
        _razorpayHelper.startPayment(
          amount: amount,
          contact: '1234567890',
          email: "",
        );
      },

      onError: (errorMessage) {
        print("Order ID generation error: $errorMessage");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
        paymentCompleter.complete(false); // Payment failed
      },
    );
    setState(() {
      isButtonDisabled = false; // Disable the button after click
    });


    // Handle callbacks for Razorpay payment status
    _razorpayHelper.initialize(
      onSuccess: (PaymentSuccessResponse response) {
        print("HDHD");
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) =>
        //           PaymentVerificationScreen(),
        //     ));
        _getProfileIdAndUpdateStatus();
        print("Payment Successful: ${response.paymentId}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Payment Successful: ${response.paymentId}")),
        );
        paymentCompleter.complete(true); // Payment successful
      },
      onFailure: (PaymentFailureResponse response) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
              PaymentVerificationFailScreen(amount:double.parse(discountedPrice)),
            ));
        print("Payment Failed: ${response.code} - ${response.error}-${response.message}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Payment Failed: ${response.message}")),
        );
        paymentCompleter.complete(false); // Payment failed
      },
      onExternalWallet: (ExternalWalletResponse response) {
        print("External Wallet Selected: ${response.walletName}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("External Wallet Selected: ${response.walletName}")),
        );
        paymentCompleter.complete(false); // Consider external wallet as failure
      },
    );

    return paymentCompleter.future;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: ()async {

        return true;
      },
      child: Scaffold(
        drawer: const CustomDrawer(),
        appBar: AppBar(
          title: const Text(
            'Final Step',
            style: TextStyle(fontSize: 18),
          ),
          centerTitle: true,
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
                        style: TextStyle(
                            fontSize: size.width * 0.023,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF0F3CC9)),
                      )),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Image.asset('assets/images/final_step.png',
                height: size.height*0.23,
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey, blurRadius: 2, spreadRadius: 0.5)
                    ],
                    borderRadius: BorderRadius.circular(11),
                    color: Colors.white,
                  ),
                  height: size.height * 0.25,
                  width: size.width * 0.8,
                  child: Column(
                    children: [
                      Container(
                        height: size.height * 0.07,
                        decoration: const BoxDecoration(color: Color(0xFF0F3CC9)),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                             Image.asset('assets/images/medal.png',
                             height: size.height*0.03,
                             ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                'Unlock Exclusive Features Now!',
                                style:
                                    TextStyle(fontSize: 15, color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      const UnlockExclusiveFeatures(
                          image: 'assets/images/exclusive_career.png',
                          title: 'Exclusive Career Opportunity'),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      const UnlockExclusiveFeatures(
                          image: 'assets/images/lifetime_membership.png',
                          title: 'Lifetime Mentorship'),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      const UnlockExclusiveFeatures(
                          image: 'assets/images/eligible.png',
                          title: 'Eligible for HireMi 360'),
                      Padding(
                        padding: EdgeInsets.only(left: size.width * 0.6),
                        child: const Text(
                          'T&C applied',
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.only(
                        right: size.width * 0.1, top: size.height * 0.01),
                    child: const Text(
                      'Learn More',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF0F3CC9),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                Container(
                  height: size.height * 0.1,
                  width: size.width * 0.8,
                  decoration: BoxDecoration(
                    color: const Color(0xFF767680).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset('assets/images/Vector.png',
                        height: size.height*0.023,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text(
                            "Thank you for subscribing to our premium section! We're excited to have you on board and can't wait for you to enjoy all the exclusive benefits.",
                            style: TextStyle(fontSize: size.width * 0.03),
                            softWrap: true,
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.04),

                  Center(
                    child: ElevatedButton(
                      onPressed: isButtonDisabled
                          ? null // Disables the button if isButtonDisabled is true
                          : () async {
                        setState(() {
                          isButtonDisabled = true; // Disable the button after click
                        });
                        final parsedAmount = double.tryParse(discountedPrice);
                        if (parsedAmount == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Invalid discounted price")),
                          );
                          setState(() {
                            isButtonDisabled = false; // Re-enable the button if parsing fails
                          });
                          return;
                        }
                        bool isSuccess = await _makePayment(parsedAmount);

                        setState(() {
                          paymentStatus = isSuccess;
                          // Re-enable the button after payment is completed
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F3CC9),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: Size(size.width * 0.8, size.height * 0.06),
                      ),
                      child:
                           Text("Pay $discountedPrice", style: TextStyle(fontSize: 16)),
                    ),
                  ),
              ],
            ),
          ),
        ),

      ),
    );
  }
}
