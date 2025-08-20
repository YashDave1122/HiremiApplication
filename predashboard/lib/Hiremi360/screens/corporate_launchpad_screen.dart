import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pre_dashboard/API.dart';
import 'package:pre_dashboard/Hiremi360/screens/corporate_subscribe.dart';
import 'package:pre_dashboard/Hiremi360/screens/payment_processing_corporate_launchpad.dart';
import 'package:pre_dashboard/Hiremi360/widgets/PremiumPackageCard%20.dart';
import 'package:pre_dashboard/Hiremi360/widgets/gradient_button.dart';
import 'package:pre_dashboard/shared_preferences_helper.dart';
import 'package:http/http.dart' as http;
import 'package:simple_gradient_text/simple_gradient_text.dart';

class CorporatePage extends StatefulWidget {
  const CorporatePage({super.key});

  @override
  State<CorporatePage> createState() => _CorporatePageState();
}

class _CorporatePageState extends State<CorporatePage> {
  final List<String> imageList = [
    "assets/images/CorporateFrame.png",
    // "assets/images/21.png",
    // "assets/images/21.png",
  ];

  // final String img1 = "assets/images/home.svg";
  final String internship = "assets/images/internship.svg";
  final String hireme360 = "assets/images/hiremi360.svg";
  final String jobs = "assets/images/jobs.svg";
  final String askexpert = "assets/images/askexpert.svg";

  int currentIndex = 0;

  CarouselSliderController controller = CarouselSliderController();
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
    const String apiUrl = '${ApiUrls.corporateDiscount}';

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
          await SharedPreferencesHelper.setCorporateDiscountedPrice(discountedPrice);

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
    final List<Widget> imageSliders = imageList.map((item) {
      int index = imageList.indexOf(item);
      // double size=MediaQuery.of(context).size;
      double width = MediaQuery.of(context).size.width;
      double height = MediaQuery.of(context).size.height;

      return Column(
        children: [
          Image.asset(
            item,
            fit: BoxFit.cover,
          )
        ],
      );
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xffEDFEFF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: GradientText(
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 24,
            ),
            "Corporate Launchpad",
            colors: const [
              // Color(0xffC1272D),
              // Color(0xff0075FF),
              Color(0xFF0F3CC9), // #0F3CC9
              Color(0xFF0075FF), // #0075FF
            ]),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // CarouselSlider(
              //   carouselController: controller,
              //   options: CarouselOptions(
              //     aspectRatio: 3.0,
              //     viewportFraction: 1,
              //     enlargeCenterPage: true,
              //     onPageChanged: (index, reason) {
              //       setState(() {
              //         currentIndex = index;
              //       });
              //     },
              //   ),
              //   items: imageSliders,
              // ),
              Image.asset('assets/images/CorporateFrame.png'),
              const SizedBox(
                height: 5,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: imageList.asMap().entries.map((entry) {
              //     int index = entry.key;
              //     return GestureDetector(
              //       onTap: () => controller
              //           .animateToPage(index), // Allow tapping to navigate
              //       child: Container(
              //         width: currentIndex == index ? 8.0 : 8.0,
              //         height: currentIndex == index ? 8.0 : 8.0,
              //         margin: const EdgeInsets.symmetric(horizontal: 4.0),
              //         decoration: BoxDecoration(
              //           shape: BoxShape.circle,
              //           color: currentIndex == index
              //               ? const Color(0xff000000) // Active dot
              //               : Colors.grey.withOpacity(0.5), // Inactive dots
              //         ),
              //       ),
              //     );
              //   }).toList(),
              // ),
              const SizedBox(
                height: 16,
              ),
              Card(
                color: Colors.white,
                child: Container(
                  margin: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "What is Hiremi 360°",
                        style: GoogleFonts.poppins(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      GradientText(
                        "Corporate Launchpad",
                        colors: const [
                          Color(0xffC1272D),
                          Color(0xff0075FF),
                        ],
                        style: GoogleFonts.poppins(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "Skip the hiring hassle! Get a guaranteed job without interviews, receive an offer letter on day one, and work on live projects for hands-on industry experience.",
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff7D7D7D)),
                      ),
                      Text(
                        "#HasslefreeExperience🏆",
                        style: GoogleFonts.poppins(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Container(
                margin: const EdgeInsets.all(8),
                decoration: const BoxDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Why Choose Hiremi 360°",
                      style: GoogleFonts.poppins(
                          fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    GradientText(
                      "Corporate Launchpad?",
                      colors: const [
                        Color(0xffC1272D),
                        Color(0xff0075FF),
                      ],
                      style: GoogleFonts.poppins(
                          fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    GradientText("Key feature of Hiremi 360 Corporate launchpad",
                        colors: const [
                          // Color(0xffC1272D),
                          // Color(0xff0075FF),
                          Color(0xFF0F3CC9), // #0F3CC9
                          Color(0xFF0075FF), // #0075FF
                        ]),
                    const SizedBox(
                      height: 16,
                    ),
                    Image.asset('assets/images/7.png'),
                    Column(
                      children: List.generate(5, (index) {
                        return Image.asset('assets/images/${index + 2}.png');
                      }),
                    )


                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Container(
                margin: const EdgeInsets.all(8),
                decoration: const BoxDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Who Can Enroll in this Program?",
                      style: GoogleFonts.poppins(
                          fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    // GradientText(
                    //   "Corporate Launchpad?",
                    //   colors: const [
                    //     Color(0xffC1272D),
                    //     Color(0xff0075FF),
                    //   ],
                    //   style: GoogleFonts.poppins(
                    //       fontSize: 20, fontWeight: FontWeight.w600),
                    // ),
                    // GradientText("Key feature of Hiremi 360 Corporate launchpad",
                    //     colors: const [
                    //       // Color(0xffC1272D),
                    //       // Color(0xff0075FF),
                    //       Color(0xFF0F3CC9), // #0F3CC9
                    //       Color(0xFF0075FF), // #0075FF
                    //     ]),
                    const SizedBox(
                      height: 16,
                    ),
                    Image.asset('assets/images/corporatepricing.png'),
                    // Text("Create for those facing challenges in launching their careerdue to lack of potential industry exposure"),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Create for those facing challenges in launching their career due to lack of potential ',
                            style: TextStyle(color: Colors.grey[800]),
                          ),
                        // Color(0xFF0F3CC9), // #0F3CC9
                        // Color(0xFF0075FF), /
                          TextSpan(
                            text: 'industry exposure',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ],
                      ),
                    )

                    // Column(
                    //   children: List.generate(5, (index) {
                    //     return Image.asset('assets/images/${index + 2}.png');
                    //   }),
                    // )


                  ],
                ),
              ),
              Image.asset('assets/images/howitworks.png'),

              const SizedBox(
                height: 16,
              ),
              Center(
                child: Text("One Time Program Pricing",
                  style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),

                ),
              ),
              Center(
                child: Text("Exclusive offer for job opportunity",style: TextStyle(
                    color: Colors.blue,
                ),),
              ),

              PremiumPackageCard(
                originalPrice: OriginalPrice,
                discountedPrice: DiscountedPrice,
                discount: Discount,
              ),
               SizedBox(
                height: MediaQuery.of(context).size.height*0.04,
              ),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: GradientButton(
                    text: "Enroll Now",
                    gradientColors: [Color(0xFF4577A6), Color(0xFF273389)],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CorporateSubscribe(
                            originalPrice: OriginalPrice,
                            discountedPrice: DiscountedPrice,
                            discount: Discount,
                          ),
                        ),
                      );
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
