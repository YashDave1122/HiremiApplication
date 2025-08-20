import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pre_dashboard/API.dart';
import 'package:pre_dashboard/Footer/widget/custom_bottom_bar.dart';
import 'package:pre_dashboard/Hiremi360/screens/unimentors_subscribe.dart';
import 'package:pre_dashboard/Hiremi360/widgets/SubsciptionCard.dart';
import 'package:pre_dashboard/Hiremi360/widgets/custom_banner.dart';
import 'package:pre_dashboard/Hiremi360/widgets/custom_bottom_bar.dart';
import 'package:pre_dashboard/Hiremi360/widgets/custom_course_profile.dart';
import 'package:pre_dashboard/Hiremi360/widgets/custom_hiremi_program.dart';

import 'package:pre_dashboard/Hiremi360/widgets/custom_info_title.dart';
import 'package:pre_dashboard/shared_preferences_helper.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'enquiry_unimentor.dart';
import 'package:http/http.dart' as http;


class UnimentorScreen extends StatefulWidget {
  const UnimentorScreen({super.key});

  @override
  State<UnimentorScreen> createState() => _UnimentorScreenState();
}

class _UnimentorScreenState extends State<UnimentorScreen> {
  int currentIndex = 0;
  final String mockList = "assets/images/Mocklist.png";
  final String flowChart = "assets/images/flowChart.png";
  final String skills = "assets/images/16.png";


  final List<String> title = [
    'Guaranteed Internship',
    'Internship Certification',
    'Personalized Guidance',
    'Industry Insights',
    'Skill Development',
    'Networking Opportunities',
    'College to Corporate',
    'Personal Branding',
    'Confidence Building',
    'Career Growth Analytics',
    'Referral Program'
  ];
  final List<String> subTitle = [
    'Secure internships in your chosen field and gain hands-on experience to kickstart your professional journey.',
    'Verified internship completion certificates from partner companies.',
    'Receive tailored mentorship aligned with your career goals and aspirations.',
    'Gain practical knowledge from industry experts, diving deep into the corporate world.',
    'Enhance your skill set with curated programs designed to make you job-ready.',
    'Expand your professional network with connections that can influence your career trajectory.',
    'Our program prepares students for corporate life with training in culture, office environment, job readiness, and work-life balance.',
    'Social media and LinkedIn profile optimization to enhance visibility to recruiters.',
    'Build confidence in your abilities through ongoing support and constructive feedback.',
    'Our mentorship program provides personalized growth tracking with detailed progress reports and regular skill feedback.',
    'Earn rewards and discounts by referring friends and peers to the Hiremi mentorship plan.'
  ];
  final List<String> logo = [
    'assets/images/guaranteed_internship.png',
    'assets/images/internship_certification.png',
    'assets/images/personalized_guidance.png',
    'assets/images/industry_insights.png',
    'assets/images/skill_development.png',
    'assets/images/networking_opportunity.png',
    'assets/images/college_to_corporate.png',
    'assets/images/personal_branding.png',
    'assets/images/confidence_building.png',
    'assets/images/career_growth_analytics.png',
    'assets/images/referral_programming.png',
  ];
  String OriginalPrice="";
  String DiscountedPrice="";
  String Discount="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAndStoreDiscountedPrice();

  }
  Future<void> fetchAndStoreDiscountedPrice() async {
    const String apiUrl = '${ApiUrls.mentorshipDiscount}';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        if (data.isNotEmpty && data[0]['discounted_price'] != null) {
          var discountedPriceValue = data[0]['discounted_price'];
          double discountedPrice;

          if (discountedPriceValue is int) {
            discountedPrice = discountedPriceValue.toDouble();
          } else if (discountedPriceValue is double) {
            discountedPrice = discountedPriceValue;
          } else {
            print("Unexpected type for discounted_price: ${discountedPriceValue.runtimeType}");
            return;
          }

          OriginalPrice = data[0]['original_price'].toString();
          DiscountedPrice = discountedPrice.toString();
          Discount = data[0]['discount'].toString();

          // Store discounted price in SharedPreferences using helper class
          await SharedPreferencesHelper.setMentorshipDiscountedPrice(discountedPrice);

          print("Discounted price stored: $discountedPrice");

          // Update the UI
          setState(() {

          });
        } else {
          print("Discounted price not found in the response.");
        }
      } else {
        print("Failed to fetch data. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching discounted price: $e");
    }
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
            style: TextStyle(fontSize: size.height*0.025, color: Colors.white),
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
                 Icon(
                  Icons.notifications_outlined,
                  color: Colors.black,
                  size: size.height*0.03,
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
        padding:  EdgeInsets.symmetric(horizontal: size.height*0.02),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 20,
            children: [
              Image.asset("assets/images/UnimentorTop.png"),
              SizedBox(),

              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "What is Hiremi 360 ",
                      style: TextStyle(color: Colors.black, fontSize: size.height*0.024,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.baseline,
                      baseline: TextBaseline.alphabetic,
                      child: ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [
                            Colors.blue,
                            Colors.red,
                          ],
                        ).createShader(bounds),
                        child: Text(
                          "Unimentors",
                          style: TextStyle(
                            fontSize:  size.height*0.024,
                            color: Colors.white, // This is required for gradient to show
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    TextSpan(
                      text: "?",
                      style: TextStyle(color: Colors.black, fontSize:  size.height*0.024,fontWeight: FontWeight.bold,),
                    ),
                  ],
                ),
              ),
              Text(
                "All-in-one guide for Corporate mentorship!Get expert mentorship, stay ahead of market trends, and make smart academic and career moves. With a guaranteed mentor in your preferred domain and Achieve success during your college years.",
                style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xff7D7D7D)),
              ),
              Text(
                "#FutureReady🚀",
                style: GoogleFonts.poppins(
                    fontSize: 14, fontWeight: FontWeight.w600),
              ),
              Container(
                // margin: const EdgeInsets.all(8),
                decoration: const BoxDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Why Choose Hiremi 360o",
                          style: GoogleFonts.poppins(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        GradientText(
                          "Unimentor?",
                          colors: const [
                            Color(0xffC1272D),
                            Color(0xff0075FF),
                          ],
                          style: GoogleFonts.poppins(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    GradientText("Key feature of Hiremi 360 unimentor test",
                        colors: const [
                          Color(0xffC1272D),
                          Color(0xff0075FF),
                        ]),
                    const SizedBox(
                      height: 16,
                    ),
                    Image.asset(mockList),
                  ],
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                    child: Text(
                      "Who does it Help?",
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: GradientText(
                      "Perfectly Designed Of College-goers",
                      colors: const [
                        Color(0xff0075FF),
                        Color(0xffC1272D),
                      ],
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Image.asset(flowChart),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Your ultimate College Companion Unimentor Program for all years effectively.",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Color(0xff7D7D7D)),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Text(
                      "Skills you will gain",
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Image.asset(skills)
                ],
              ),


              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'One-Time Program Pricing',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(colors: [
                            Color(0xFF0075FF),
                            Color(0xFF6D4988),
                            Color(0xFFC1272D)
                          ], stops: [
                            0.55,
                            0.69,
                            1.00
                          ]).createShader(bounds),
                      child: Text(
                        'Kickstart your professional career',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )),
                ],
              ),


              SizedBox(
                height: size.height * 0.02,
              ),
              // SubscriptionCard(
              //   price:DiscountedPrice,
              //   originalPrice: OriginalPrice,
              //   discount:Discount,
              // ),
            SubscriptionCard(
              price: double.tryParse(DiscountedPrice) ?? 0.0,
              originalPrice: double.tryParse(OriginalPrice) ?? 0.0,
              discount: double.tryParse(Discount) ?? 0.0,
            ),

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
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => UnimentorsSubscribe(
                    price: double.tryParse(DiscountedPrice) ?? 0.0,
                    originalPrice: double.tryParse(OriginalPrice) ?? 0.0,
                    discount: double.tryParse(Discount) ?? 0.0,
                  ),));
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
                          'Enroll Now',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ))),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => EnquiryUnimentor(),));
                },
                child: Container(
                    width: size.width * 0.92,
                    height: size.height * 0.06,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Color(0xFF6122A7))),
                    child: Center(
                        child: Text(
                          'Enquire Now',
                          style: TextStyle(
                              fontSize: 17,
                              color: Color(0xFF6122A7),
                              fontWeight: FontWeight.bold),
                        ))),
              ),
              SizedBox(),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: CustomBottomBar(
      //   currentIndex: currentIndex,
      //   onTabSelected: (value) {
      //     setState(() {
      //       currentIndex = value;
      //     });
      //   },
      // ),
    );
  }
}
