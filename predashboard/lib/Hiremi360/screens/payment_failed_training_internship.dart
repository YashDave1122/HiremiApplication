import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import 'package:pre_dashboard/API.dart';
import 'package:pre_dashboard/Footer/widget/custom_bottom_bar.dart';
import 'package:pre_dashboard/Hiremi360/screens/payment_verification_training_internship.dart';
import 'package:pre_dashboard/Hiremi360/widgets/custom_bottom_bar.dart';
import 'package:pre_dashboard/RazorPayPayment/RazorPayPayment.dart';
import 'package:pre_dashboard/SharedPreferences/SharedPreferences.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentFailedTrainingInternship extends StatefulWidget {
  final Map<String, dynamic> program;
  const PaymentFailedTrainingInternship({super.key,required this.program});

  @override
  State<PaymentFailedTrainingInternship> createState() =>
      _PaymentFailureScreenState();
}

class _PaymentFailureScreenState extends State<PaymentFailedTrainingInternship> {
  int currentIndex = 0;
  late RazorpayHelper _razorpayHelper;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _razorpayHelper = RazorpayHelper();
  }
  Future<void> postTrainingApplication() async {
    final SharedPreferencesService _sharedPreferencesService = SharedPreferencesService();
    final savedId = await _sharedPreferencesService.getUserId();

    // final url = Uri.parse('http://13.127.246.196:8000/api/training-applications/');
    final url = Uri.parse('${ApiUrls.trainingApplication}');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'payment_status': 'Enrolled',
        'applied': 'Applied',
        'register': savedId,
        'TrainingProgram': widget.program['id'],
      }),
    );

    if (response.statusCode == 201) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PaymentVerificationTrainingInternship()),
      );
      print('Application posted successfully');
    } else {
      print('Failed to post application: ${response.statusCode}');
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
    // setState(() {
    //   isButtonDisabled = false; // Disable the button after click
    // });


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
        postTrainingApplication();
        print("Payment Successful: ${response.paymentId}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Payment Successful: ${response.paymentId}")),
        );

        // Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentFailedTrainingInternship(),));

        paymentCompleter.complete(true); // Payment successful
      },
      onFailure: (PaymentFailureResponse response) {
        // PaymentFailedTrainingInternship

        print("Payment failed Now navigation Comes");

        Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentFailedTrainingInternship(program: widget.program,),));

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
    return Scaffold(
        appBar: AppBar(
          title: ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
                colors: [Color(0xFFC1272D), Color(0xFF0075FF)],
                stops: [0.78, 1.0],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight)
                .createShader(bounds),
            child: Text(
              'Profile Verification',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
          centerTitle: true,
          leading: Container(
              decoration: BoxDecoration(
                color: Color(0xFFECF5FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(child: Image.asset('assets/images/appBarMenu.png'))),
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
          backgroundColor: Colors.transparent,
        ),
        body: Padding(
          padding: const EdgeInsets.only(right: 15, left: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                fit: StackFit.loose,
                alignment: Alignment.bottomCenter,
                children: [
                  Center(
                    child: Image.asset("assets/images/Ellipse.png"),
                  ),
                  Center(
                    child: Image.asset(
                      'assets/images/payment_failed_training_internship.png',
                      height: 195,
                      width: 212,
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.04),
              Text(
                "Your payment was not\nsuccessful. Please try again",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Color(0xffC1272D),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: size.height * 0.02),
              Text(
                "We encountered an issue with your payment\nPlease try again",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Color(0xFF030303),
                  fontSize: 14,
                ),
              ),
              SizedBox(height: size.height * 0.06),
              ElevatedButton.icon(
                onPressed: () async{
                  // Navigator.pushReplacement(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => PaymentVerificationTrainingInternship()));
                  bool isSuccess = await _makePayment(1);
                },
                icon: const Icon(Icons.refresh, color: Colors.white),
                label: Text(
                  "Try again",
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC08B6C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                ),
              ),
            ],
          ),
        ),

    );
  }
}
