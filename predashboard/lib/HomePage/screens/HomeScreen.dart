
import 'dart:convert';

import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/animation.dart';
import 'package:pre_dashboard/API.dart';
import 'package:pre_dashboard/Footer/widget/custom_bottom_bar.dart';
import 'package:pre_dashboard/Hiremi360/controller_screen/controller_screen.dart';
import 'package:pre_dashboard/HomePage/Widget/customPopup.dart';
import 'package:pre_dashboard/SharedPreferences/SharedPreferences.dart';
import 'package:pre_dashboard/shared_preferences_helper.dart';
import '../Widget/carouselSection.dart';
import '../Widget/customAppBar.dart';
import '../Widget/customDrawer.dart';
import '../Widget/featuredGrid.dart';

import '../Widget/verificationCard.dart';
import 'askExpertScreen.dart';
import 'hiremi360Screen.dart';
import 'jobsScreen.dart';
import 'package:http/http.dart' as http;

import 'statusScreen.dart';

class HomeScreen extends StatefulWidget {
  final bool isVerified;
  final bool animation;
  final String email; // Add email parameter
  const HomeScreen({Key? key, required this.isVerified,
    required this.animation,
    required this.email, // Initialize email
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>with TickerProviderStateMixin {
  late bool animation ;
   String img1 = "assets/images/BottomNavBarhome.png";
   String img2 = "assets/images/NottomNavBarinternship.png";
   String img3 = "assets/images/BottomnavBar360.png";
   String img4 = "assets/images/BottomNavBarJobs.png";
   String img5 = "assets/images/BottomNavBarAskExpert.png";


// bool featureSection=false;
  @override
  void initState() {
    super.initState();

    animation = widget.animation;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      print("Animation is $animation");
      await _checkEmailAndFetchId(widget.email);
      if(animation){
        _showAlertBox(context);

      }

    });
  }







  Future<void> _checkEmailAndFetchId(String email) async {
    final sharedPreferencesService = SharedPreferencesService();

    String? Email = await sharedPreferencesService.getUserEmail();
    String? password = await sharedPreferencesService.getUserPassword();
    try {
      print("Email is $Email");
      print("Password is $password");

      final token = await _loginAndGetToken(Email!, password!);
      if (token == null) {
        print('Authentication failed. Cannot proceed.');
        return;
      }

      const String apiUrl = ApiUrls.registration;

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print("Response body is in checkemail and fetched id${response.body}");
        final List<dynamic> data = jsonDecode(response.body);

        final user = data.firstWhere(
              (user) => user['email'] == email,
          orElse: () => null,
        );


        if (user != null) {
          final userId = user['id'];
          await sharedPreferencesService.saveUserId(userId);
          await SharedPreferencesHelper.setProfileId(userId); // If setProfileId is static, this is fine
          await _fetchUserDetailsById(userId,token);
          print("User ID found: $userId");
          print("Username is full_name  ${user['full_name']}");
          print("Username detail is ${user}");

          final String formattedPhoneNumber = (user['phone_number'] ?? '').replaceFirst('+91', '');
          final String formattedWhatsNumber = (user['whatsapp_number'] ?? '').replaceFirst('+91', '');

          final Map<String, dynamic> combinedUserDetails = {
            "full_name": user['full_name'] ?? '',
            // "name": user['name'] ?? '',
            "unique": user['unique'] ?? '',

          };

          print("Extracted contact number:${formattedPhoneNumber}");




          // ✅ Correct usage with instance method
          // await sharedPreferencesService.saveUserDetails(combinedUserDetails);
          await _fetchAndStoreEducationDetails(userId, token);
        } else {
          print("Email not found in the API.");
        }
      } else {
        print("Failed to fetch API data. Status Code: ${response.statusCode} - ${response.body} in authentication");
      }
    } catch (error) {
      print("Error fetching or processing data: $error");
    }
  }






  Future<void> _fetchAndStoreEducationDetails(int userId, String token) async {
    print("User ID is $userId");
    final sharedPreferencesService = SharedPreferencesService();
    final String educationApiUrl = "http://3.109.62.159:8000/education/?user=$userId";

    try {
      final response = await http.get(
        Uri.parse(educationApiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> educationList = jsonDecode(response.body);

        if (educationList.isNotEmpty) {
          final Map<String, dynamic> educationData = educationList.first;
          print("Fetched Education Details: $educationData");

          await sharedPreferencesService.saveEducationDetails({
            "id":educationData['id'] ?? '',
            "college_name": educationData['college_name'] ?? '',
            "degree": educationData['degree'] ?? '',
            "branch": educationData['branch'] ?? '',
            "passing_year": educationData['passing_year'] ?? '',
            "college_state": educationData['college_state'] ?? '',
            "college_city": educationData['college_city'] ?? '',
            "percentage":educationData['percentage'],
          });
          print("College city id is ${educationData['college_city']}");

          print("Education details saved successfully.");
        }
        else {
          print("No education details found for user ID $userId.");
        }
      } else {
        print("Failed to fetch education details. Status Code: ${response.statusCode} and ${response.body}");
      }
    } catch (error) {
      print("Error fetching education details: $error");
    }
  }

  Future<void> displayEducationDetails() async {
    final sharedPreferencesService = SharedPreferencesService();
    final educationDetails = await sharedPreferencesService.getEducationDetails();

    if (educationDetails != null) {
      print("Saved Education Details:${educationDetails}");
      // for (var edu in educationDetails) {
      //   print("College: ${edu['college_name']}, Degree: ${edu['degree']}, Branch: ${edu['branch']}, Percentage: ${edu['percentage']}");
      // }
    } else {
      print("No saved education details found.");
    }
  }





  Future<String?> _loginAndGetToken(String email, String password) async {
    final response = await http.post(
      Uri.parse('${ApiUrls.Login}'), // Replace with actual login endpoint
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("Response body is ${response.body}");
      print("Response code is ${response.statusCode}");

      final token = data['access_token']; // Assuming your API returns a token
      await SharedPreferencesHelper.setToken(token);
      print("Token: $token");
      return token;
    }
    else {
      print("Login failed: ${response.body}");
      return null;
    }
  }





  // Future<void> _fetchUserDetailsById(int userId, String token) async {
  //   try {
  //     final String apiUrl = "${ApiUrls.registration}$userId";
  //     final response = await http.get(
  //       Uri.parse(apiUrl),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $token',
  //       },
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final Map<String, dynamic> userDetails = jsonDecode(response.body);
  //
  //       // Process phone number to remove +91 if present
  //       if (userDetails.containsKey("phone_number") && userDetails["phone_number"] != null) {
  //         String phoneNumber = userDetails["phone_number"];
  //         if (phoneNumber.startsWith("+91")) {
  //           userDetails["phone_number"] = phoneNumber.substring(3); // Remove "+91"
  //         }
  //         if (phoneNumber.startsWith("+91")) {
  //           userDetails["phone_number"] = phoneNumber.substring(3); // Remove "+91"
  //         }
  //       }
  //
  //       print("Processed User Details: $userDetails");
  //
  //       // Save modified user details to SharedPreferences
  //       SharedPreferencesService prefsService = SharedPreferencesService();
  //       await prefsService.saveUserDetails(userDetails);
  //
  //       Map<String, dynamic>? storedDetails = await prefsService.getUserDetails();
  //       print("User details fetched and saved successfully: $storedDetails");
  //     } else {
  //       print("Failed to fetch user details in _fetchUserDetailsById. Status Code: ${response.statusCode} and ${response.body}");
  //     }
  //   } catch (error) {
  //     print("Error fetching user details: $error");
  //   }
  // }
  Future<void> _fetchUserDetailsById(int userId, String token) async {
    try {
      final String apiUrl = "${ApiUrls.registration}$userId";
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> userDetails = jsonDecode(response.body);

        // Function to remove +91 prefix
        String removeCountryCode(String? number) {
          if (number != null && number.startsWith("+91")) {
            return number.substring(3); // Remove "+91"
          }
          return number ?? ''; // Return original number if null
        }

        // Remove +91 from phone_number and whatsapp_number
        userDetails["phone_number"] = removeCountryCode(userDetails["phone_number"]);
        userDetails["whatsapp_number"] = removeCountryCode(userDetails["whatsapp_number"]);

        print("Processed User Details: $userDetails");

        // Save modified user details to SharedPreferences
        SharedPreferencesService prefsService = SharedPreferencesService();
        await prefsService.saveUserDetails(userDetails);

        Map<String, dynamic>? storedDetails = await prefsService.getUserDetails();
        print("User details fetched and saved successfully: $storedDetails");
      } else {
        print("Failed to fetch user details in _fetchUserDetailsById. Status Code: ${response.statusCode} and ${response.body}");
      }
    } catch (error) {
      print("Error fetching user details: $error");
    }
  }








  void _showAlertBox(BuildContext context) {
    // Initialize the confetti controller
    ConfettiController _confettiController =
    ConfettiController(duration: const Duration(seconds: 6));

    // Start the confetti animation
    _confettiController.play();

    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            // Return false to prevent closing when back button is pressed
            return false;
          },
          child: Builder(
            builder: (context) {
              // Get screen size using MediaQuery
              double screenHeight = MediaQuery.of(context).size.height;
              double screenWidth = MediaQuery.of(context).size.width;

              // Animation controller to control fade-in effect
              AnimationController _animationController = AnimationController(
                duration: const Duration(seconds: 3), // Duration of the fade-in effect
                vsync: this, // Use `this` because `TickerProviderStateMixin` is mixed in
              );

              // Fade animation
              Animation<double> _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0)
                  .animate(CurvedAnimation(
                parent: _animationController,
                curve: Curves.easeIn,
              ));

              // Start the animation when the dialog is built
              _animationController.forward();
              return AlertDialog(
                contentPadding: EdgeInsets.zero, // Remove default padding
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Upper blue part with confetti animation
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                      child: Stack(
                        children: [
                          Container(
                            color: Color(0xFF163EC8),
                            height: screenHeight * 0.22,
                            width: screenWidth * 0.8,
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.only(left: screenWidth * 0.28),
                                child: Text(
                                  "Not just a milestone, but \na masterpiece of\nsuccess!",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenWidth * 0.04,
                                    fontWeight: FontWeight.bold, // Make text bold
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Gap between the container and the image
                          Positioned(
                            top: screenHeight * 0.04, // Position this below the container
                            left: screenHeight * 0.02, // Position this below the container
                            child: Image.asset(
                              "assets/images/award.png",
                              height: screenWidth * 0.29,
                              width: screenWidth * 0.2,
                            ),
                          ),
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.center,
                              child: ConfettiWidget(
                                confettiController: _confettiController,
                                blastDirectionality: BlastDirectionality.explosive,
                                maxBlastForce: 40, // Lower blast force for slower movement
                                minBlastForce: 30, // Lower blast force for slower movement
                                emissionFrequency: 0.05, // Slightly slower frequency
                                numberOfParticles: 50, // Keep intensity the same
                                gravity: 0.7, // Reduced gravity for slower rain effect
                                shouldLoop: true, // Keep animation looping
                                colors: const [
                                  Colors.red,
                                  Colors.green,
                                  Colors.blue,
                                  Colors.yellow,
                                  Colors.orange,
                                  Colors.purple,
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // White part with a button and animated text
                    Container(
                      color: Colors.transparent,
                      height: screenHeight * 0.18,
                      width: screenWidth * 0.8,
                      child: Padding(
                        padding: EdgeInsets.only(top: screenWidth * 0.05),
                        child: Column(
                          children: [
                            FadeTransition(
                              opacity: _fadeAnimation,
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "Congratulations!\n",
                                      style: TextStyle(
                                        color: Color(0xFF163EC8),
                                      ), // Change this color as needed
                                    ),
                                    TextSpan(
                                      text: "Your account has been created",
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();

                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.blue,
                                backgroundColor: Colors.white, // Text color
                                side: BorderSide(color: Color(0xFF163EC8)), // Border color
                              ),
                              child: Text(
                                "Continue",
                                style: TextStyle(
                                  color: Color(0xFF163EC8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );

    // Dispose of the controller after animation
    Future.delayed(const Duration(seconds: 4), () {
      _confettiController.dispose();
    });
  }






  int _selectedIndex = 0;
  int currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;
    final size = MediaQuery.of(context).size;
    print("Size is $size");
    final List<Widget> screens = [

      SingleChildScrollView(

        child: Column(
          children: [
            VerificationSection(isVerified: widget.isVerified,),
            CarouselSection(),
            FeaturedSection(isVerified: widget.isVerified,animation: animation,),
            // JobsForYouSection(),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
      const JobsScreen(),
      const AskExpertPage(),
      const StatusScreen(),
      const Hiremi360Screen(),
    ];

    return WillPopScope(
      onWillPop: ()async{
        return true;
      },
      child: Scaffold(
        appBar: const CustomAppBar(),
        drawer:  CustomDrawer(isVerified: widget.isVerified),
        body: IndexedStack(
          index: _selectedIndex,
          children: screens,
        ),
        // bottomNavigationBar: CustomBottomBar(
        //   currentIndex: currentIndex,
        //   onTabSelected: (value) {
        //     setState(() {
        //       currentIndex = value;
        //     });
        //   },
        // ),
          bottomNavigationBar: ConvexAppBar(
            style: TabStyle.fixed,
            backgroundColor: Color(0xff0F3CC9),
            items: [
              TabItem(icon: Image.asset(img1), title: "Home"),
              // TabItem(icon: Image.asset(img2), title: "Internships"),
              TabItem(
                icon: SizedBox(
                  width: 24, // Adjust as needed
                  height: 24,
                  child: Image.asset(img2),
                ),
                title: "Internship",
              ),

              TabItem(icon: Image.asset(img3), title: "HireMi 360"),
              TabItem(icon: Image.asset(img4), title: "Jobs"),
              TabItem(icon: Image.asset(img5), title: "Ask Expert"),
            ],
            initialActiveIndex: 0,
            onTap: (int i) {

              if (i == 1) {
                if (widget.isVerified) {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => AskExpertPage()),
                  // );
                } else {
                  showCustomPopup(context);
                }
              }
              if (i == 2) {
                if (widget.isVerified) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ControllerScreen()),
                  );
                } else {
                  showCustomPopup(context);
                }
              }
              if (i == 3) {
                if (widget.isVerified) {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => AskExpertPage()),
                  // );
                } else {
                  showCustomPopup(context);
                }
              }
              if (i == 4) {
                if (widget.isVerified) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AskExpertPage()),
                  );
                } else {
                  showCustomPopup(context);
                }
              }
            },
          ),




      ),
    );
  }
}
