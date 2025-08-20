import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pre_dashboard/Footer/widget/custom_bottom_bar.dart';

import 'package:pre_dashboard/Hiremi360/screens/enquiry_training_internship.dart';
import 'package:pre_dashboard/Hiremi360/screens/training_subscribe.dart';
import 'package:pre_dashboard/Hiremi360/widgets/custom_banner.dart';
import 'package:pre_dashboard/Hiremi360/widgets/custom_bottom_bar.dart';
import 'package:pre_dashboard/Hiremi360/widgets/custom_course_profile.dart';
import 'package:pre_dashboard/Hiremi360/widgets/custom_hiremi_program.dart';
import 'package:pre_dashboard/Hiremi360/widgets/custom_select_program.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class TrainingInternshipScreen extends StatefulWidget {
  const TrainingInternshipScreen({super.key});

  @override
  State<TrainingInternshipScreen> createState() =>
      _TrainingInternshipScreenState();
}

class _TrainingInternshipScreenState extends State<TrainingInternshipScreen> {
  int currentIndex = 0;
  final String traininglist = "assets/images/traininglist.png";

  final List<String> title = [
    'Personalized Guidance',
    'Industry Insights',
    'Skill Development',
    'Networking Opportunity',
    'Confidence Building',
    'Guaranteed Internship'
  ];
  final List<String> logo = [
    'assets/images/personalized_guidance.png',
    'assets/images/industry_insights.png',
    'assets/images/skill_development.png',
    'assets/images/networking_opportunity.png',
    'assets/images/confidence_building.png',
    'assets/images/guaranteed_internship.png',
  ];
  final List<String> subTitle = [
    'Receive tailored mentorship aligned with your career goals and aspirations.',
    'Gain practical knowledge from industry experts, diving deep into the corporate world.',
    'Enhance your skill set with curated programs designed to make you job-ready.',
    'Expand your professional network with connections that can influence your career trajectory.',
    'Build confidence in your abilities through ongoing support and constructive feedback.',
    'Secure internships in your chosen field and gain hands-on experience to kickstart your professional journey.'
  ];
  final List<String> image = ['assets'];
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xffFFF8F2),
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
            'Training + Internship',
            style: TextStyle(fontSize: size.height*0.023, color: Colors.white),
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
                  size: size.height*0.04,
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
        padding:  EdgeInsets.symmetric(horizontal:size.height*0.022),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 20,
            children: [
              SizedBox(),
              // CustomBanner(
              //   title: 'Training + internship',
              //   pana: 'assets/images/pana.png',
              //   eclipse: 'assets/images/Trainingplusinternshiptop.png',
              //   colors: [Color(0xFF95152F), Color(0xFFEFC59B)],
              // ),
              Image.asset('assets/images/Trainingplusinternshiptop.png'),
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Text(
              //       'Select Programs',
              //       style: TextStyle(
              //           fontWeight: FontWeight.bold,
              //           fontSize: size.width * 0.044,
              //           color: Colors.black),
              //     ),
              //     ShaderMask(
              //       shaderCallback: (bounds) => LinearGradient(colors: [
              //         Color(0xFF0075FF),
              //         Color(0xFF5B509B),
              //         Color(0xFFC1272D),
              //       ], stops: [
              //         0.37,
              //         0.68,
              //         1.0
              //       ], begin: Alignment.bottomLeft, end: Alignment.topRight)
              //           .createShader(bounds),
              //       child: Text(
              //         'Mentorship',
              //         style: TextStyle(fontSize: 16, color: Colors.white),
              //       ),
              //     )
              //   ],
              // ),
              Container(
                margin: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "What is Hiremi 360 ",
                      style: GoogleFonts.poppins(
                          fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    GradientText(
                      "Training + Internship?",
                      colors: const [
                        Color(0xffC1272D),
                        Color(0xff0075FF),
                      ],
                      style: GoogleFonts.poppins(
                          fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 5,),
                    Text(
                      "Hiremi’s 360° Training + Internship Program helps students overcome internship hurdles by providing essential training and hands-on experience. We connect you with top companies, ensuring you gain real-world skills to excel in your career.",
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
                  ],
                ),
              ),

              // CustomSelectProgram(),
              // CustomCourseProfile(
              //   image: 'assets/images/training_internship4.png',
              //   subTitle:
              //       "Our Training + Internship assists students in navigating their academic journey, making informed career choices, and preparing for the professional world.",
              //   status1: 'Not Active Program',
              //   status2: "Please enroll now to jumpstart your journey!",
              //   subHeadline: 'Addon for College Students',
              //   backgroundColor1: Color(0xFFEFC59B),
              //   backgroundColor2: Color(0xFFFC3C3C),
              // ),
              Container(
                margin: const EdgeInsets.all(8),
                decoration: const BoxDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Why Choose Hiremi Training +\nInternship program?",
                          softWrap: true,
                          style: GoogleFonts.poppins(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                      ],
                    ),
                    const Text(
                      "The Advantages of Hiremi 360's Training + Internship program.",
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Image.asset(traininglist),
                  ],
                ),
              ),
              Center(child: Text("Avaiable Programs",
                style: GoogleFonts.poppins(
                    fontSize: 20, fontWeight: FontWeight.w600),
              )),
              CustomSelectProgram(),

              ElevatedButton(onPressed: (){
                Navigator.pop(context);
              }, child: Text("DDCDCDC")),

              SizedBox(
                height: size.height * 0.02,
              ),

              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => EnquiryTrainingInternship(),));
                },
                child: Container(
                    width: size.width * 0.92,
                    height: size.height * 0.06,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Color(0xFFC1272D))),
                    child: Center(
                        child: Text(
                      'Enquire Now',
                      style: TextStyle(
                          fontSize: 17,
                          color: Color(0xFFC1272D),
                          fontWeight: FontWeight.bold),
                    ))),
              ),
              SizedBox(),
            ],
          ),
        ),
      ),

    );
  }
}
