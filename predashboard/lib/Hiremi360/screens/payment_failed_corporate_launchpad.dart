import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pre_dashboard/Footer/widget/custom_bottom_bar.dart';
import 'package:pre_dashboard/Hiremi360/CorporateTrainingModel/CorporateTrainingController.dart';
import 'package:pre_dashboard/Hiremi360/CorporateTrainingModel/CorporateTrainingModel.dart';
import 'package:pre_dashboard/Hiremi360/RazorPayPament/RazorPayPaymentForUnimentors.dart';

import 'package:pre_dashboard/Hiremi360/screens/payment_verification_corporate_launchpad.dart';
import 'package:pre_dashboard/Hiremi360/widgets/custom_bottom_bar.dart';
import 'package:pre_dashboard/SharedPreferences/SharedPreferences.dart';
import 'package:pre_dashboard/shared_preferences_helper.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentFailedCorporateLaunchpad extends StatefulWidget {
  const PaymentFailedCorporateLaunchpad({super.key});

  @override
  State<PaymentFailedCorporateLaunchpad> createState() =>
      _PaymentFailureScreenState();
}

class _PaymentFailureScreenState extends State<PaymentFailedCorporateLaunchpad> {
  int currentIndex = 0;
  String Email="";
  late RazorpayHelper _razorpayHelper;
  final CorporateTrainingController corporateTraininingController = CorporateTrainingController();
  Future<void> _enrollInCorporatetraining() async {
    final SharedPreferencesService _sharedPreferencesService = SharedPreferencesService();
    final savedId = await _sharedPreferencesService.getUserId();

    var corporateTraininingData = CorporateTrainingModel(
      program_status: "Applied",
      candidateStatus: "Applied",
      applied: true,
      register: savedId.toString(),
    );

    try {
      await corporateTraininingController.EnrollInCorporateTraining(corporateTraininingData);
      // _checkEnrollmentStatus();
    } catch (e) {
      print("Enrollment failed: $e"); // Handle errors if the enrollment fails
    }
  }
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => PaymentVerificationCorporateLaunchpad()));
    _enrollInCorporatetraining();

    print("Payment Successful: ${response.paymentId}");
    // Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentVerificationScreenUnimentor(),));


    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment Successful: ${response.paymentId}")),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentFailedCorporateLaunchpad(),
      ),
    );
    print("Payment Failed: ${response.code} - ${response.message}");
    // _enrollInMentorship(SavedId);

    // Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentVerificationFailScreenUnimentor(),));


    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment Failed: ${response.message}")),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("External Wallet: ${response.walletName}");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("External Wallet Selected: ${response.walletName}")),
    );
  }
  void _makePayment() async {
    double? Amount = await SharedPreferencesHelper.getCorporateDiscountedPrice();


    double amount = Amount!;

    // Generate Order ID
    _razorpayHelper.generateOrderId(
      amount: amount,
      onOrderIdGenerated: (orderId) {
        print('Order ID generated: $orderId');
        // Start Payment
        _razorpayHelper.startPayment(
          amount: amount,
          contact: '1234567890',
          email: Email,
        );
      },
      onError: (errorMessage) {
        print(errorMessage);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      },
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _razorpayHelper = RazorpayHelper();
    _razorpayHelper.initialize(
      onSuccess: _handlePaymentSuccess,
      onFailure: _handlePaymentError,
      onExternalWallet: _handleExternalWallet,
    );
    // fetchUserEmail();
    // fetchAndStoreDiscountedPrice();
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
                      'assets/images/payment_failed_corporate_launchpad.png',
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
                  color: Color(0xffDB5A61),
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
                onPressed: () {
                _makePayment();
                },
                icon: const Icon(Icons.refresh, color: Colors.white),
                label: Text(
                  "Try again",
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF324C94),
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
