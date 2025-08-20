import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pre_dashboard/Hiremi360/CorporateTrainingModel/CorporateTrainingController.dart';
import 'package:pre_dashboard/Hiremi360/CorporateTrainingModel/CorporateTrainingModel.dart';
import 'package:pre_dashboard/Hiremi360/screens/payment_failed_corporate_launchpad.dart';
import 'package:pre_dashboard/Hiremi360/screens/payment_processing_corporate_launchpad.dart';
import 'package:pre_dashboard/Hiremi360/widgets/PremiumPackageCard%20.dart';
import 'package:pre_dashboard/SharedPreferences/SharedPreferences.dart';
import 'package:pre_dashboard/shared_preferences_helper.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../widgets/gradient_button.dart';
import '../widgets/gradient_card.dart';
import 'package:pre_dashboard/Hiremi360/RazorPayPament/RazorPayPaymentForUnimentors.dart';


class CorporateSubscribe extends StatefulWidget {
  final String originalPrice;
  final String discountedPrice;
  final String discount;
  // const CorporateSubscribe({super.key});
  const CorporateSubscribe({
    Key? key,
    required this.originalPrice,
    required this.discountedPrice,
    required this.discount,
  }) : super(key: key);

  @override
  State<CorporateSubscribe> createState() => _CorporateSubscribeState();
}

class _CorporateSubscribeState extends State<CorporateSubscribe> {
  late RazorpayHelper _razorpayHelper;
  final CorporateTrainingController corporateTraininingController = CorporateTrainingController();

  String Email="";
  String SavedId="";
  Future<void> _enrollInCorporatetraining(String SavedId) async {
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
    _enrollInCorporatetraining(SavedId);

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
      backgroundColor: const Color(0xffEDFEFF),
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
            'Corporate Launchpad',
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
                child: Image.asset('assets/images/ic_pana_walet.png',
                    height: 180.0, width: 177.0),
              ),
              SizedBox(height: 12.0),
              Text('Hiremi 360 Corporate Training',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  )),
              SizedBox(height: 10.0),
              Text(
                'The Hiremi 360° Corporate Training Program helps college graduates build essential skills, gain real-world experience, and secure internships with top companies, ensuring a smooth transition into the corporate world.',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black45,
                ),
              ),
              const SizedBox(height: 20),
              // const GradientCard(
              //     gradientColors: [Color(0xFF4577A6), Color(0xFF273389)],
              //     title: 'Subscribe to this mentorship\nprogram',
              //     discountPriceColor: Color(0xFFBFBFBF),
              //     price: '₹2,50,000',
              //     discountPrice: '3,97,500',
              //     offPercentage: '40',
              //     textLines: [
              //       'Certificate of completion',
              //       'Working on live projects',
              //       'Portfolio Building',
              //       'Guaranteed Internship with client Companies'
              //     ]),
              PremiumPackageCard(
                originalPrice: widget.originalPrice,
                discountedPrice: widget.discountedPrice,
                discount: widget.discount,
              ),
              const SizedBox(height: 45),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset('assets/images/ic_lock.png'),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        text:
                        'By enrolling, you agree to be charged the amount shown, plus applicable taxes, starting today. You also agree to Hiremi',
                        style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                            text: ' Terms of Use, Refund Policy,',
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFFC1272D),
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {},
                          ),
                          const TextSpan(text: ' and acknowledge our'),
                          TextSpan(
                            text: ' Privacy Notice',
                            style: GoogleFonts.poppins(
                              color: Color(0xFFC1272D),
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {},
                          ),
                          TextSpan(
                            text: 'Please note that no refunds are available for purchases made through the Play Store. You will receive a confirmation email upon completion.',
                            style: GoogleFonts.poppins(
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
              const SizedBox(height: 35),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: GradientButton(
                    text: "Pay Now",
                    // gradientColors: [Color(0xFF4577A6), Color(0xFF273389)],
                    gradientColors: [
                      Color.fromRGBO(15, 60, 201, 0.8),
                      Color.fromRGBO(15, 60, 201, 1),
                    ],

                    onTap: () {
                      _makePayment();
                      //PaymentFailedCorporateLaunchpad
                      //PaymentVerificationCorporateLaunchpad

                      /// /// /// /// /// /// /// /// /// ///
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => PaymentProcessingCorporateLaunchpad(),
                      //   ),
                      // );
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
