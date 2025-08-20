import 'dart:async';
import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pre_dashboard/API.dart';
import 'package:pre_dashboard/Hiremi360/screens/payment_failed_training_internship.dart';
import 'package:pre_dashboard/Hiremi360/screens/payment_verification_training_internship.dart';
import 'package:pre_dashboard/RazorPayPayment/RazorPayPayment.dart';
import 'package:pre_dashboard/SharedPreferences/SharedPreferences.dart';


import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EnrollpageTrainingAndInternship extends StatefulWidget {
  final Map<String, dynamic> program;
  const EnrollpageTrainingAndInternship({Key? key,required this.program}) : super(key: key);

  @override
  State<EnrollpageTrainingAndInternship> createState() => _EnrollpageState();
}

class _EnrollpageState extends State<EnrollpageTrainingAndInternship> {
  // late PaymentService paymentService;
  String Email="";
  String SavedId="";
  late RazorpayHelper _razorpayHelper;
  // late RazorpayHelper _razorpayHelper;





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
        print("Payment Successful: ${response.paymentId}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Payment Successful: ${response.paymentId}")),
        );
        postTrainingApplication();
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
    double screenWidth = MediaQuery.of(context).size.width;
    return  Scaffold(
      backgroundColor: const Color(0xffFFF8F2),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black), // Back arrow icon
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
        title: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Colors.redAccent, Colors.blueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: const Text(
            "Training + Internships",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,  // Text color is needed, but will be replaced by the gradient
            ),
          ),
        ),

        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child:Column(
          children: [
            SizedBox(height: screenWidth*0.049,),

            SizedBox(height: screenWidth*0.109,),
            Container(
              width:MediaQuery.of(context).size.width*0.97 ,
              margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04), // Outer margin for spacing
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.005), // This controls the thickness of the border
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.04), // Rounded corners for the border
                // gradient: const LinearGradient(
                //   begin: Alignment.topRight,
                //   end: Alignment.bottomLeft,
                //   colors: [
                //     Colors.blueAccent,
                //     Colors.redAccent
                //   ],
                // ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFEFC59B), Color(0xFF95152F)], // Gradient colors
                ),
              ),
              child: Container(
                padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04), // Inner padding for content inside the border
                decoration: BoxDecoration(
                  // color: Colors.white,  // Card content background
                  color: const Color(0xffFFF8F2),
                  borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.035), // Rounded corners slightly smaller to match border
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Heading
                    SizedBox(height:screenWidth*0.01 ,),
                    Text(
                      'Subscribe to \n${widget.program['training_program']}',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.04, // Responsive font size for heading
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.013), // Responsive space between heading and content

                    // Content
                    Row(
                      children: [
                        SizedBox(width: screenWidth * 0.01),
                        Text(
                          '₹ ${widget.program['discounted_price']}',
                          style: TextStyle(
                            fontSize: screenWidth * 0.043,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.01),

                        Text(
                          '₹ ${widget.program['original_price']}',
                          style: TextStyle(
                            fontSize: screenWidth * 0.032,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: Colors.grey,
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.07),
                        Container(
                          width:MediaQuery.of(context).size.width*0.1820 ,
                          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.005), // This controls the thickness of the border
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.04), // Rounded corners for the border
                            // gradient: const LinearGradient(
                            //   begin: Alignment.topRight,
                            //   end: Alignment.bottomLeft,
                            //   colors: [
                            //     Colors.blueAccent,
                            //     Colors.redAccent
                            //   ],
                            // ),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFFEFC59B), Color(0xFF95152F)], // Gradient colors
                            ),
                          ),
                          child: Container(
                            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02), // Inner padding for content inside the border
                            decoration: BoxDecoration(
                              color: Colors.white,  // Card content background
                              borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.035), // Rounded corners slightly smaller to match border
                            ),
                            child: Text(
                              '${widget.program['discount_percentage']}% Off',
                              textAlign: TextAlign.center,
                              style:  TextStyle(
                                  color: Color.fromRGBO(193, 39, 45, 1),
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenWidth*0.03
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.013),
                    // Text("Certificate of completion"),
                    // Text("Working on live projects"),
                    // Text("Portofolip building"),
                    // Text("Guranteed Internship with client companies")
                    // ,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // Icon(Icons.check),
                            Icon(Icons.done_all, color: Color(0xFFC1272D), size: screenWidth * 0.04),

                            SizedBox(width: MediaQuery.of(context).size.width * 0.02), // Padding between icon and text
                            Text("Certificate of completion",
                              style: TextStyle(
                                  fontSize: screenWidth*0.028
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.01), // Space between each row
                        Row(
                          children: [
                            // Icon(Icons.check),
                            Icon(Icons.done_all, color: Color(0xFFC1272D), size: screenWidth * 0.04),

                            SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                            Text("Working on live projects",
                              style: TextStyle(
                                  fontSize: screenWidth*0.028
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                        Row(
                          children: [
                            // Icon(Icons.check),
                            Icon(Icons.done_all, color: Color(0xFFC1272D), size: screenWidth * 0.04),

                            SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                            Text("Portfolio building",
                              style: TextStyle(
                                  fontSize: screenWidth*0.028
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                        Row(
                          children: [
                            // Icon(Icons.check),
                            Icon(Icons.done_all, color: Color(0xFFC1272D), size: screenWidth * 0.04),

                            SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                            Text("Guaranteed Internship with client companies",
                              style: TextStyle(
                                  fontSize: screenWidth*0.028
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),



                    SizedBox(height: MediaQuery.of(context).size.height * 0.023),




                  ],
                ),
              ),
            ),
            SizedBox(height: screenWidth*0.409,),
            ElevatedButton(onPressed: (){
              Navigator.pop(context);
            }, child: Text("DDCDCDC")),
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
                        const TextSpan(text:'and acknowledge our'),
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
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
            SizedBox(height: screenWidth*0.109,),
            Container(
              height: screenWidth*0.1, // Set your desired height
              width: screenWidth*0.8, // Set your desired width
              decoration: BoxDecoration(
                // gradient: LinearGradient(
                //   colors: [
                //     Colors.blueAccent,
                //     Colors.redAccent
                //
                //   ], // Your gradient colors
                //   begin: Alignment.topLeft,
                //   end: Alignment.bottomRight,
                // ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFEFC59B), Color(0xFF95152F)], // Gradient colors
                ),
                borderRadius: BorderRadius.circular(10), // Optional: for rounded corners
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent, // Make the background transparent
                  elevation: 0, // Remove the button elevation
                ),
                onPressed: () async {

                  bool isSuccess = await _makePayment(widget.program['discounted_price']);
                  print("Success id $isSuccess");
                  if(isSuccess){
                    print("Succesfull");
                  }
                  else
                    {
                      print("Not Succesfull");
                    }

                },
                child: Text(
                  "Pay Now",
                  style: TextStyle(color: Colors.white), // Text color
                ),
              ),
            ),
          ],
        ),
      ),
    );

  }
}
