import 'package:carousel_slider/carousel_slider.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

const String img1 = "assets/images/3.png";
const String img2 = "assets/images/4.png";
const String img3 = "assets/images/1.png";
const String img4 = "assets/images/2.png";
const String img5 = "assets/images/5.png";
class LiveProjectHubPage extends StatefulWidget {
  LiveProjectHubPage({super.key});

  @override
  State<LiveProjectHubPage> createState() => _LiveProjectHubState();
}

class _LiveProjectHubState extends State<LiveProjectHubPage> {
  final List<String> imageList = [
    "assets/images/carousel1.png",
    "assets/images/carousel1.png",
    "assets/images/carousel1.png"
  ];

  final String learningIcon = "assets/images/LiveProjectHubOrange.png";
  final String vectorIcon = "assets/images/Vector.svg";
  final String iconSvg = "assets/images/Icons.svg";
  final String offerImage = "assets/images/offer_image.svg";
  final String compainesImage = "assets/images/companies_image.png";
  final String jobStructureImage = "assets/images/job_structure_image.png";
  final String liveContributionImage = "assets/images/live_contribution.svg";
  final String reshotIcon = "assets/images/reshot_icon.svg";
  final String enrolmentImage = "assets/images/enrolment.svg";
  final String img6 = "assets/images/6.png";
  final String img7 = "assets/images/7.png";
  final String img8 = "assets/images/8.png";
  final String img9 = "assets/images/9.png";
  final String img10 = "assets/images/10.png";
  final String img11 = "assets/images/img11.png";


  int currentIndex = 0;

  CarouselSliderController controller = CarouselSliderController();
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    final List<Widget> imageSliders = imageList.map((item) {
      int index = imageList.indexOf(item);
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
      backgroundColor: const Color(0xffF7EEDD),
      // bottomNavigationBar: ConvexAppBar(
      //   style: TabStyle.react,
      //   backgroundColor: Color(0xff0F3CC9),
      //   items: [
      //     TabItem(icon: Image.asset(img1),title: "Home"),
      //     TabItem(icon: Image.asset(img2),title: "Internships"),
      //     TabItem(icon: Image.asset(img3),title: "HireMi 360"),
      //     TabItem(icon: Image.asset(img4),title: "Jobs"),
      //     TabItem(icon: Image.asset(img5),title: "Ask Expert"),
      //   ],
      //   initialActiveIndex: 1,
      //   onTap: (int i) => print('click index=$i'),
      // ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: GradientText(
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 24,
            ),
            "Live Project Hub",
            colors: const [
              Color(0xffC1272D),
              Color(0xff0075FF),
            ]
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
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
              Image.asset('assets/images/Live Project Hub 1.png'),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: imageList.asMap().entries.map((entry) {
              //     int index = entry.key;
              //     return GestureDetector(
              //       onTap: () => controller
              //           .animateToPage(index), // Allow tapping to navigate
              //       child: Container(
              //         width: currentIndex == index ? 12.0 : 8.0,
              //         height: currentIndex == index ? 12.0 : 8.0,
              //         margin: const EdgeInsets.symmetric(horizontal: 4.0),
              //         decoration: BoxDecoration(
              //           shape: BoxShape.circle,
              //           color: currentIndex == index
              //               ? Color(0xffFD5732) // Active dot
              //               : Colors.grey.withOpacity(0.5), // Inactive dots
              //         ),
              //       ),
              //     );
              //   }).toList(),
              // ),
              SizedBox(
                height: 30,
              ),
              Text(
                "What is Hiremi 360 Live Project Hub ?",
                style: GoogleFonts.poppins(
                    fontSize: 24, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                "The 360 Live Project feature is designed to provide hands-on industry exposure, practical problem-solving, and real-time collaboration.We offer structured guidance, real-world challenges, and mentorship, ensuring individuals gain practical expertise, teamwork experience, and industry-ready skills to excel in their careers.", style: GoogleFonts.poppins(
                  fontSize: 14, fontWeight: FontWeight.w500,
                  color: Color(0xff7D7D7D)
              ),),
              SizedBox(height: 32,),
              Text(
                "Browse Available Projects",
                style: GoogleFonts.poppins(
                    fontSize: 24, fontWeight: FontWeight.w600),
              ),
              GradientText(
                  "Click to read more and enroll",  colors: const [
                Color(0xffC1272D),
                Color(0xff0075FF),
              ]),
              SizedBox(height: 32,),
              Container(


                padding: EdgeInsets.symmetric(
                    horizontal: 24,vertical: 16
                ),
                decoration: BoxDecoration(

                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        width: 2,
                        color: Color(0xffFD5732)
                    )
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("UI/UX based Live Project", style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Color(0xff202020)
                        ),),
                        Image.asset(learningIcon,
                          width: screenWidth * 0.08,  // Adjust this value to change the width
                          height: screenWidth * 0.08, // Adjust this value to change the height
                          fit: BoxFit.cover,
                        )
                      ],
                    ),
                    SizedBox(height: 16,),
                    Row(

                      children: [
                        Text("₹30,000 ", style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Color(0xff202020)
                        ),),
                        SizedBox(width: 16,),

                        Text("₹30,000 ", style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,

                            fontSize: 16,
                            color: Color(0xff202020)
                        ),),
                        SizedBox(width: 16,),
                        // SvgPicture.asset(offerImage)



                      ],
                    )

                  ],
                ),
              ),
              SizedBox(height: 32,),
              Container(


                padding: EdgeInsets.symmetric(
                    horizontal: 24,vertical: 16
                ),
                decoration: BoxDecoration(

                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        width: 2,
                        color: Color(0xffFD5732)
                    )
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Python and Data Visualisation\nbased Live Project", style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Color(0xff202020)
                        ),),
                        Image.asset(learningIcon,
                          width: screenWidth * 0.08,  // Adjust this value to change the width
                          height: screenWidth * 0.08, // Adjust this value to change the height
                          fit: BoxFit.cover,
                        ),

                      ],
                    ),
                    SizedBox(height: 16,),
                    Row(

                      children: [
                        Text("₹21,600 ", style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Color(0xff202020)
                        ),),
                        SizedBox(width: 16,),

                        Text("₹36,000 ", style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Color(0xff202020)
                        ),),
                        SizedBox(width: 16,),
                        SvgPicture.asset(offerImage)


                      ],
                    )

                  ],
                ),
              ),
              SizedBox(height: 32,),
              Text("Who Is It Best For?", style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w600,

              ),),
              GradientText(
                "Ideal for Upskilling & Career Growth", colors: [

                Color(0xff0075FF),
                Color(0xffC1272D),
              ],
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,

                ),
              ),
              SizedBox(height: 32,),
              Text("Live Projects In Association With", style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,

              ),),
              SizedBox(height: 16,),
              Image.asset(compainesImage),
              SizedBox(height: 32,),
              Image.asset(jobStructureImage),
              SizedBox(height: 32,),
              Text("Program Benefits", style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w600,

              ),),
              GradientText(
                "The Advantages of Hiremi 360's Live Project Hub", colors: [

                Color(0xff0075FF),
                Color(0xffC1272D),
              ],
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,

                ),
              ),
              SizedBox(height: 16,),
              Container(
                padding: EdgeInsets.only(bottom: 16,right: 24),
                decoration: BoxDecoration(

                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        width: 2,
                        color: Color(0xffFD5732)
                    )
                ),
                child: Column(


                  children: [
                    Row(

                      children: [
                        Stack(
                          children: [
                            SvgPicture.asset(vectorIcon,height: 80,width: 80,),
                            Positioned.fill(
                                top: 0,

                                child: Image.asset(img10,)),



                          ],
                        ),
                        SizedBox(width: 20,),
                        Expanded(child: Column(


                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [

                                Text("Industry Insights",
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xff202020)
                                  ),),
                                SizedBox(height: 8,),

                                Text("Gain practical knowledge from industry experts & dive deep into the real world.",   style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w300,
                                    color: Color(0xff202020)
                                ),),

                              ],
                            )
                          ],
                        ))



                      ],
                    ),


                  ],
                ),
              ),
              SizedBox(height: 16,),
              Container(
                padding: EdgeInsets.only(bottom: 16,right: 24),
                decoration: BoxDecoration(

                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        width: 2,
                        color: Color(0xffFD5732)
                    )
                ),
                child: Column(


                  children: [
                    Row(

                      children: [
                        Stack(
                          children: [
                            SvgPicture.asset(vectorIcon,height: 80,width: 80,),
                            Positioned.fill(
                                top: 0,

                                child: Image.asset(img6,)),



                          ],
                        ),
                        SizedBox(width: 20,),
                        Expanded(child: Column(


                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [

                                Text("Skill Development",
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xff202020)
                                  ),),
                                SizedBox(height: 8,),

                                Text("Enhance your skill set with curated programs designed to make you job-ready.",   style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w300,
                                    color: Color(0xff202020)
                                ),),

                              ],
                            )
                          ],
                        ))



                      ],
                    ),


                  ],
                ),
              ),
              SizedBox(height: 16,),
              Container(
                padding: EdgeInsets.only(bottom: 16,right: 24),
                decoration: BoxDecoration(

                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        width: 2,
                        color: Color(0xffFD5732)
                    )
                ),
                child: Column(


                  children: [
                    Row(

                      children: [
                        Stack(
                          children: [
                            SvgPicture.asset(vectorIcon,height: 80,width: 80,),
                            Positioned.fill(
                                top: 0,

                                child: Image.asset(img7,)),



                          ],
                        ),
                        SizedBox(width: 20,),
                        Expanded(child: Column(


                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [

                                Text("Personalized Guidance",
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xff202020)
                                  ),),
                                SizedBox(height: 8,),

                                Text("Our mentorship program provides personalized growth tracking with detailed progress reports.",   style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w300,
                                    color: Color(0xff202020)
                                ),),

                              ],
                            )
                          ],
                        ))



                      ],
                    ),


                  ],
                ),
              ),
              SizedBox(height: 16,),
              Container(
                padding: EdgeInsets.only(bottom: 16,right: 24),
                decoration: BoxDecoration(

                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        width: 2,
                        color: Color(0xffFD5732)
                    )
                ),
                child: Column(


                  children: [
                    Row(

                      children: [
                        Stack(
                          children: [
                            SvgPicture.asset(vectorIcon,height: 80,width: 80,),
                            Positioned.fill(
                                top: 0,

                                child: Image.asset(img8,)),



                          ],
                        ),
                        SizedBox(width: 20,),
                        Expanded(child: Column(


                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [

                                Text("Networking Opportunities",
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xff202020)
                                  ),),
                                SizedBox(height: 8,),

                                Text("Expand your professional network with connections that can influence your career trajectory.",   style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w300,
                                    color: Color(0xff202020)
                                ),),

                              ],
                            )
                          ],
                        ))



                      ],
                    ),


                  ],
                ),
              ),
              SizedBox(height: 16,),
              Container(
                padding: EdgeInsets.only(bottom: 16,right: 24),
                decoration: BoxDecoration(

                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        width: 2,
                        color: Color(0xffFD5732)
                    )
                ),
                child: Column(


                  children: [
                    Row(

                      children: [
                        Stack(
                          children: [
                            SvgPicture.asset(vectorIcon,height: 80,width: 80,),
                            Positioned.fill(
                                top: 0,

                                child: Image.asset(img9,)),



                          ],
                        ),
                        SizedBox(width: 20,),
                        Expanded(child: Column(


                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [

                                Text("Referral Program",
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xff202020)
                                  ),),
                                SizedBox(height: 8,),

                                Text("Earn rewards and discounts by referring friends and peers to the program.",   style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w300,
                                    color: Color(0xff202020)
                                ),),

                              ],
                            )
                          ],
                        ))



                      ],
                    ),


                  ],
                ),
              ),
              SizedBox(height: 16,),
              Container(
                padding: EdgeInsets.only(bottom: 16,right: 24),
                decoration: BoxDecoration(

                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        width: 2,
                        color: Color(0xffFD5732)
                    )
                ),
                child: Column(


                  children: [
                    Row(

                      children: [
                        Stack(
                          children: [
                            SvgPicture.asset(vectorIcon,height: 80,width: 80,),
                            Positioned.fill(
                                top: 0,

                                child: Image.asset(img2,)),



                          ],
                        ),
                        SizedBox(width: 20,),
                        Expanded(child: Column(


                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [

                                Text("Confidence Building",
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xff202020)
                                  ),),
                                SizedBox(height: 8,),

                                Text("Build confidence in your abilities through ongoing support and constructive feedback.",   style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w300,
                                    color: Color(0xff202020)
                                ),),

                              ],
                            )
                          ],
                        ))



                      ],
                    ),


                  ],
                ),
              ),
              SizedBox(height: 32,),
              Text("3 Steps To Completion", style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w600,

              ),),
              GradientText(
                "Steps to complete the live project hub program and contribute to amazing projects.", colors: [

                Color(0xff0075FF),
                Color(0xffC1272D),
              ],
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,

                ),
              ),
              SizedBox(height: 32,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [

                      SvgPicture.asset(enrolmentImage),
                      SizedBox(height: 16,),
                      Text("Enrolment", style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 10,
                          color: Color(0xff202020)
                      ),)


                    ],
                  ),
                  Column(
                    children: [

                      SvgPicture.asset(liveContributionImage),
                      SizedBox(height: 16,),
                      Text("Project Allocation", style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 10,
                          color: Color(0xff202020)
                      ),)


                    ],
                  ),
                  Column(
                    children: [

                      SvgPicture.asset(reshotIcon),
                      SizedBox(height: 16,),
                      Text("Live Project\nContribution", style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 10,
                          color: Color(0xff202020)
                      ),)


                    ],
                  ),


                ],
              ),
              SizedBox(height: 32,),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                      ),
                      backgroundColor: Color(0xffFD5732)
                  ),
                  onPressed: () {

                  }, child: Text("Enquire About The Projects",
                style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white
                ),))








            ],
          ),
        ),
      ),
    );
  }
}
