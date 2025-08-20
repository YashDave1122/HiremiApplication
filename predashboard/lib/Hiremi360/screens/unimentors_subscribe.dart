import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pre_dashboard/API.dart';
import 'package:http/http.dart' as http;
import 'package:pre_dashboard/Hiremi360/MentorshipModel/Mentorcontroller.dart';
import 'package:pre_dashboard/Hiremi360/MentorshipModel/MentorshipModel.dart';

import 'package:pre_dashboard/Hiremi360/RazorPayPament/RazorPayPaymentForUnimentors.dart';
import 'package:pre_dashboard/Hiremi360/screens/payment_failed_unimentor.dart';
import 'package:pre_dashboard/Hiremi360/screens/payment_processing_unimentor.dart';
import 'package:pre_dashboard/Hiremi360/screens/payment_verification_unimentor.dart';
import 'package:pre_dashboard/Hiremi360/widgets/SubsciptionCard.dart';
import 'package:pre_dashboard/SharedPreferences/SharedPreferences.dart';
import 'package:pre_dashboard/shared_preferences_helper.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:hiremi_t5/screens/payment_processing_unimentor.dart';
// import 'package:hiremi_t5/screens/unimentors_onboard.dart';

import '../widgets/gradient_button.dart';
import '../widgets/gradient_card.dart';

class UnimentorsSubscribe extends StatefulWidget {
  final double price;
  final double originalPrice;
  final double discount;
  const UnimentorsSubscribe({super.key,
    required this.price,
    required this.originalPrice,
    required this.discount,
  });

  @override
  State<UnimentorsSubscribe> createState() => _UnimentorsSubscribeState();
}

class _UnimentorsSubscribeState extends State<UnimentorsSubscribe> {
  late RazorpayHelper _razorpayHelper;
  String Email="";
  String SavedId="";
  String OriginalPrice="";
  String DiscountedPrice="";
  String Discount="";
  final MentorshipController mentorshipController = MentorshipController();
 // String userDetails="";
  Map<String, dynamic> userDetails = {}; // Or use 'late' if initialized properly
  void fetchUserEmail() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final String? userDetailsString = sharedPreferences.getString('userDetails');

    if (userDetailsString != null) {
      // Parse JSON string to Map
      final Map<String, dynamic> parsedData = jsonDecode(userDetailsString);
      int? id = await SharedPreferencesHelper.getProfileId();

      setState(() {
        SavedId = id.toString();
        userDetails = parsedData;
        Email=userDetails['email'];
      });
      print("Email is $Email");
      print("SavedId is $SavedId");

      print("userDetails are $userDetails");
    } else {
      print("Data is empty");
    }
  }


  Future<void> _enrollInMentorship(String SavedId) async {
    final SharedPreferencesService _sharedPreferencesService = SharedPreferencesService();

    final savedId = await _sharedPreferencesService.getUserId();
    var mentorshipData = MentorshipModel(
      program_status: "Applied",
      candidateStatus: "Applied",
      applied: true,
      register: savedId.toString(),
    );

    try {

      await mentorshipController.EnrollInMentorship(mentorshipData);

    } catch (e) {
      print("Enrollment failed: $e"); // Handle errors if the enrollment fails
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print("Payment Successful: ${response.paymentId}");

    Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentVerificationScreenUnimentor(),));

    _enrollInMentorship(SavedId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment Successful: ${response.paymentId}")),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("Payment Failed: ${response.code} - ${response.message}");
    // _enrollInMentorship(SavedId);

    Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentVerificationFailScreenUnimentor(),));


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

  // Future<void> fetchAndStoreDiscountedPrice() async {
  //   const String apiUrl = '${ApiUrls.baseurl}/api/mentorshipdiscount/';
  //
  //   try {
  //     final response = await http.get(Uri.parse(apiUrl));
  //
  //     if (response.statusCode == 200) {
  //       final List<dynamic> data = json.decode(response.body);
  //
  //       if (data.isNotEmpty && data[0]['discounted_price'] != null) {
  //         var discountedPriceValue = data[0]['discounted_price'];
  //         double discountedPrice;
  //
  //         if (discountedPriceValue is int) {
  //           discountedPrice = discountedPriceValue.toDouble();
  //         } else if (discountedPriceValue is double) {
  //           discountedPrice = discountedPriceValue;
  //         } else {
  //           print("Unexpected type for discounted_price: ${discountedPriceValue.runtimeType}");
  //           return;
  //         }
  //
  //         OriginalPrice = data[0]['original_price'].toString();
  //         DiscountedPrice = discountedPrice.toString();
  //         Discount = data[0]['discount'].toString();
  //
  //         // Store discounted price in SharedPreferences using helper class
  //         await SharedPreferencesHelper.setMentorshipDiscountedPrice(discountedPrice);
  //
  //         print("Discounted price stored: $discountedPrice");
  //
  //         // Update the UI
  //         setState(() {
  //
  //         });
  //       } else {
  //         print("Discounted price not found in the response.");
  //       }
  //     } else {
  //       print("Failed to fetch data. Status code: ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     print("Error fetching discounted price: $e");
  //   }
  // }

  void _makePayment() async {
   double? Amount = await SharedPreferencesHelper.getMentorshipDiscountedPrice();


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
          shaderCallback: (bounds) => LinearGradient(colors: [
            Color(0xFFC1272D),
            Color(0xFF5B509B),
            Color(0xFF0075FF)
          ], stops: [
            0.37,
            0.78,
            1.0
          ], begin: Alignment.bottomLeft, end: Alignment.topRight)
              .createShader(bounds),
          child: Text(
            'Unimentors',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.chevron_left)),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12.0),
              Center(
                child: Image.asset('assets/images/ic_violate_walet.png',
                    height: 180.0, width: 177.0),
              ),
              const SizedBox(height: 12.0),
              Text('Hiremi 360 Unimentor',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  )),
              const SizedBox(height: 10.0),
              Text(
                'The Hiremi 360° Mentorship Program guides you through your college journey with expert mentors, career advice, and a guaranteed internship in your preferred field, ensuring both academic and professional success.',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black45,
                ),
              ),
              const SizedBox(height: 20),
              // const GradientCard(
              //     gradientColors: [Color(0xFFA92AB4), Color(0xFF4720A3)],
              //     title: 'Subscribe to this mentorship\nprogram',
              //     discountPriceColor: Color(0xFFBFBFBF),
              //     price: '10,000',
              //     discountPrice: '25,000',
              //     offPercentage: '40',
              //     textLines: [
              //       'Certificate of completion',
              //       'Working on live projects',
              //       'Portfolio Building',
              //       'Guaranteed Internship with client Companies'
              //     ]),
              SubscriptionCard(
                price: widget.price,
                originalPrice: widget.originalPrice,
                discount: widget.discount,
              ),
              const SizedBox(height: 45),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset('assets/images/ic_lock.png'),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        text:
                            'By enrolling, you agree to be charged the amount shown, plus applicable taxes, starting today. You also agree to Hiremi',
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                            text: ' Terms of Use, Refund Policy,',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFFC1272D),
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {},
                          ),
                          const TextSpan(text: ' and acknowledge our'),
                          TextSpan(
                            text: ' Privacy Notice',
                            style: TextStyle(
                              color: const Color(0xFFC1272D),
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {},
                          ),
                          TextSpan(
                              text: 'Please note that no refunds are available for purchases made through the Play Store. You will receive a confirmation email upon completion.',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                          ),
                          )
                        ],
                      ),
                      textAlign: TextAlign.start,
                    ),
                  )
                ],
              ),
              SizedBox(height: 35),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => UnimentorsSubscribe(),));
                },
                child: Container(
                    width: size.width * 0.92,
                    height: size.height * 0.06,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                            colors: [Color(0xFFA42AB3), Color(0xFF5F22A7)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight)),
                    child: Center(
                        child: Text(
                          'Back',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ))),
              ),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: GradientButton(
                    text: "Enroll Now",
                    gradientColors: const <Color>[Color(0xFFA92AB4), Color(0xFF4720A3)],
                    onTap: () {
                      _makePayment();
                      },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
