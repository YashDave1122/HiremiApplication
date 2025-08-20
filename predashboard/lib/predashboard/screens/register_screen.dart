import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pre_dashboard/API.dart';
import 'package:pre_dashboard/HomePage/screens/HomeScreen.dart';
import 'package:pre_dashboard/SharedPreferences/SharedPreferences.dart';
import 'package:pre_dashboard/predashboard/Services/user_service.dart';
import 'package:pre_dashboard/predashboard/widgets/custom_password_field.dart';
import 'package:pre_dashboard/predashboard/widgets/content_pages/step1_content.dart';
import 'package:pre_dashboard/predashboard/widgets/content_pages/step2_content.dart';
import 'package:pre_dashboard/predashboard/widgets/content_pages/step3_content.dart';
import 'package:pre_dashboard/shared_preferences_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../bloc/user_bloc.dart';
import '../constants/constants.dart';
import 'package:http/http.dart' as http;


class RegisterScreenEducational extends StatefulWidget {
  const RegisterScreenEducational({Key? key}) : super(key: key);

  @override
  State<RegisterScreenEducational> createState() =>
      _RegisterScreenEducationalState();
}

class _RegisterScreenEducationalState extends State<RegisterScreenEducational> {
//Zaidi's

  final TextEditingController fullNameController=TextEditingController();
  final TextEditingController fatherNameController=TextEditingController();
  final TextEditingController cityController=TextEditingController();
  final TextEditingController stateController = TextEditingController();
  int chosencity=0;
  int chosencityforcollege=0;


  final TextEditingController dobController = TextEditingController();
  final TextEditingController birthPlaceController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController collegeNameController = TextEditingController();
  final TextEditingController branchNameController = TextEditingController();
  final TextEditingController courseNameController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController confirmPasswordController=TextEditingController();
  final TextEditingController collegeStateController = TextEditingController();
  final TextEditingController collegeCityController = TextEditingController();
  final UserService _userService = UserService();

  String? password;
  String? passwordError;
  String? confirmPasswordError;

  String? selectedGender;
  int currentStep = 1;
  String countryValue = "India"; // Default country set to India
  String? stateValue;
  String? cityValue;
  List<int> citiesID = [];
  bool isLoading=false;


  List<String> heading = [
    "Personal Information",
    "Contact Information",
    "Educational Information",
    "Set New Password"
  ];

  void _clearFormData() {
    SharedPreferencesHelper.clearAllFormData().then((_) {
      print("All form data cleared!");
      // Add any additional logic after clearing (e.g., navigation)
    });
  }
  Future<void> storeCSRFToken(String csrfToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('csrfToken', csrfToken);
  }

  Future<void> saveEmailToSharedPreferences(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('enteredEmail', email);
    print("Saved Email: $email");
  }
  Future<void> generateOtp(String email) async {

    Map<String, dynamic> body = {"email": email.trim()};
    print("Body is $body");

    try {
      final response = await _userService.createPostApi(
        body,
        ApiUrls.SendOtpForEmailValidation,
      );

      if (response.statusCode == 201) {
        // widget.onVerifyTap();
        String csrfToken = response.headers['set-cookie'] ?? '';
        await storeCSRFToken(csrfToken);
        await saveEmailToSharedPreferences(email.trim());
        // setState(() {
        //   showOtpScreen = true;
        //   _isEmailVerified = true; // Update email verification status
        // });
        // print("Email verified is ${_isEmailVerified} in generateOTP");
        // await _saveToPrefs('isEmailVerified'); // Save verification status
      }

      else
      {
        // print("Email verified is ${_isEmailVerified} in generateOTP");
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        print("Response body: ${response.body}");
        print("Status code: ${response.statusCode}");
        // print("Email verified is ${_isEmailVerified}");

        // final errorMessage = responseBody['message'] ?? 'Unknown error';
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text(errorMessage),
        //     duration: const Duration(seconds: 3),
        //   ),
        // );
        String errorMessage = 'Unknown error';
        if (responseBody.containsKey('message')) {
          errorMessage = responseBody['message'];
        } else if (responseBody.containsKey('non_field_errors')) {
          errorMessage = responseBody['non_field_errors'][0];
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      print("Error occurred: \$e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred. Please try again.'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> registerUser(Map<String, dynamic> userData) async {
    final startTime = DateTime.now(); // Capture start time
    print("Clicking after Clicking");
    setState(() {
      isLoading = true;
    });
    print(userData);

    // Automatically add +91 if not present
    if (userData.containsKey("phone_number")) {
      String phoneNumber = userData["phone_number"]!;
      if (!phoneNumber.startsWith('+91')) {
        userData["phone_number"] = '+91${phoneNumber.trim()}';
      }
    }

    final url = Uri.parse(ApiUrls.registration);
    try {
      // Ensure the date is in the correct format before making the API call
      if (userData.containsKey("date_of_birth")) {
        final inputDate = userData["date_of_birth"]!;
        final parsedDate = DateFormat('dd/MM/yyyy').parse(inputDate);
        final formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);
        userData["date_of_birth"] = formattedDate;
      }

      // Make the API POST request
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(userData),
      );

      // Handle the API response
      final endTime = DateTime.now(); // Capture end time
      final difference = endTime.difference(startTime); // Calculate time difference
      if (response.statusCode == 200 || response.statusCode == 201) {

        final responseData = jsonDecode(response.body);
        print("Clicking after positive response ");
        print("Time difference: ${difference.inMilliseconds} ms");



        print("Full API Response: $responseData in registration");
        final userId = responseData['user']['id'];
        final accessToken = responseData['access_token']; // Extract token
        if (userId != null) {
          educationDetails(
            userId.toString(),
            {
              "user":userId,
              "college_state": collegeStateController.text,
              "college_city": chosencityforcollege,
              "college_name": collegeNameController.text,
              "branch": branchNameController.text,
              "degree": courseNameController.text,
              "passing_year": yearController.text,
            },
            accessToken,
          );
          await SharedPreferencesHelper.setProfileId(userId);
          final sharedPreferencesService = SharedPreferencesService();
          await sharedPreferencesService.saveUserId(userId);

        }
        // Assuming the API returns the user ID in the response

        print("User registered successfully with ID: $userId");

        // Pass the user ID to the educationDetails function
        // educationDetails(
        //   userId.toString(),
        //   {
        //     "user":userId,
        //     "college_state": collegeStateController.text,
        //     "college_city": chosencityforcollege,
        //     "college_name": collegeNameController.text,
        //     "branch": branchNameController.text,
        //     "degree": courseNameController.text,
        //     "passing_year": yearController.text,
        //   },
        //   accessToken,
        // );
      }

      else {
        print("${response.body} in Registration");

        // _showErrorSnackbar("Registration failed: ${response.body}");
      }

    }
    catch (e)
    {
      _showErrorSnackbar("Error: $e");
    }
  }

// Function to handle API errors and show a SnackBar
  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 30),
        backgroundColor: Colors.redAccent,
        action: SnackBarAction(
          label: 'CLOSE',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }



  Future<void> educationDetails(String userId,Map<String, dynamic> userData, String accessToken) async {
    print(userData);
    print("I am in Education");

    // Automatically add +91 if not present


    final url = Uri.parse(ApiUrls.education);
    try {
      // Ensure the date is in the correct format before making the API call
      // Ensure the date is in the correct format before making the API call
      if (userData.containsKey("date_of_birth")) {
        final inputDate = userData["date_of_birth"]!; // e.g., "30/12/2024"
        final parsedDate = DateFormat('dd/MM/yyyy').parse(inputDate);
        final formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);
        userData["date_of_birth"] = formattedDate; // Update the date in the payload
      }

      // Make the API POST request
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
        body: jsonEncode(userData),
      );

      // Handle the API response
      if (response.statusCode == 201) {
        final sharedPreferencesService = SharedPreferencesService();
        final educationResponseData = jsonDecode(response.body);


        final Map<String, dynamic> combinedUserDetails = {
          "full_name":fullNameController.text,
          'father_name':fatherNameController.text,
          "email": emailController.text.trim(),
          // "gender":Gen
          "gender":selectedGender.toString(),
          "phone_number": phoneController.text,
          "date_of_birth": dobController.text,
          "college_state": collegeStateController.text,
          "college_city": chosencityforcollege,
          "college_name": collegeNameController.text,
          "branch": branchNameController.text,
          "degree": courseNameController.text,
          "passing_year": yearController.text,
          "education_response": educationResponseData
        };
        await sharedPreferencesService.saveUserCredentials(
          emailController.text.trim(),
          passwordController.text.trim(),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(
            isVerified: false,
            animation: true, // Pass the value here
            email: emailController.text.trim(),
          )),
        );

        // print("Combine detailed is $combinedUserDetails");
        // _fetchAndStoreEducationDetails(int.parse(userId),  accessToken);

        // Save combined details in SharedPreferences
        // await sharedPreferencesService.saveUserDetails(combinedUserDetails);


        print("Full API Response: ${response.body} in education");
        print("User details saved successfully in SharedPreferences.");
        // _clearFormData();

        // static Future<void> clearAllFormData() async {
        //   final prefs = await SharedPreferences.getInstance();
        //   await prefs.clear(); // Clears EVERYTHING in SharedPreferences
        // }
        print("Full API Response: ${response.body} in education");


        setState(() {
          isLoading = false;
        });
        print("User registered successfully");
      } else {

        print("${response.statusCode} in education");
        print("${response.body}  in education");

        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text("${response.body}"),
        //     behavior: SnackBarBehavior.floating,
        //     duration: Duration(seconds: 30),
        //     backgroundColor: Colors.redAccent,
        //     action: SnackBarAction(
        //       label: 'CLOSE',
        //       onPressed: () {
        //         ScaffoldMessenger.of(context).hideCurrentSnackBar();
        //       },
        //     ),
        //   ),
        // );
        print("Education post  failed: ${response.body}");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("$e"),
          duration: Duration(seconds: 30),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.redAccent,
          action: SnackBarAction(
            label: 'CLOSE',
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
      print("Error in educationDetails: $e");
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
          final Map<String, dynamic> educationData = educationList.first; // ✅ Extract first object
          print("Fetched Education Details: $educationData");

          await sharedPreferencesService.saveEducationDetails({
            "id":educationData['id'] ?? '',
            "college_name": educationData['college_name'] ?? '',
            "degree": educationData['degree'] ?? '',
            "branch": educationData['branch'] ?? '',
            "passing_year": educationData['passing_year'] ?? '',
            "college_state": educationData['college_state'] ?? '',
            "college_city": educationData['college_city'] ?? '',
          });

          print("Education details saved successfully.");
        } else {
          print("No education details found for user ID $userId.");
        }
      } else {
        print("Failed to fetch education details. Status Code: ${response.statusCode} and ${response.body}");
      }
    } catch (error) {
      print("Error fetching education details: $error");
    }
  }


  Future<void> _saveToPrefs(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }
  Future<void> validateOtp(String otp) async {
    // setState(() {
    //   isLoading = true;
    // });
    print("otp is $otp");

    try {
      // final response = await _userService.createPostApi({"otp": otp}, ApiUrls.otpValidation);
      final response = await _userService.createPostApi({"otp": otp,
      "email":emailController.text
      }, ApiUrls.EmailOTPValidation);

      // setState(() {
      //   isLoading = false;
      // });

      if (response.statusCode == 200) {
        print(emailController.text);
        print("Status code is ${response.statusCode}");
        // await _saveToPrefs('isEmailVerified'); // Save verification status
        await _saveToPrefs('isEmailVerified', true);
        setState(() {
              isEmailVerified=true;
              shouldMove = true;
              //isEmailVerified = true;
              showOtpScreen = false;
            });
        // Store the OTP in shared preferences (example usage)
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('otp', otp);



      } else {

        print(response.statusCode);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid OTP. Please try again.'),
            backgroundColor: Color(0xff0F3CC9),
          ),
        );
      }
      //0xff0F3CC9
    } catch (e) {
      // setState(() {
      //   isLoading = false;
      // });
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again later.'),
        backgroundColor: Color(0xff0F3CC9),
        ),
      );
    }
  }

  //Sameers
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  // bool _isEmailVerified = false;
  // bool _verifyOTP = false;
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  String email = "JohnDoe@gmail.com";
  String phoneNumber = "";
  bool isEmailVerified = true;
  bool showOtpScreen = false;
  String otpInput = "";
  List<String> otpDigits = ["", "", "", ""]; // Stores OTP digits
  String? selectedState;
  String? selectedCity;
  bool shouldMove = false;
  final String validOtp = "1234";

  List<GlobalKey<FormState>> stepKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  bool isValidated = false;

  final PageController _pageController = PageController();
  final GlobalKey<FormState> step1Key = GlobalKey<FormState>();

   DateFormat format = DateFormat("dd/MM/yyyy");



  @override
  Widget build(BuildContext context) {
    // bool isActive = true;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return PopScope(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: showOtpScreen
            ? null
            : AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                centerTitle: true,
                title: Text(
                  'Create Account',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff0f3cc9),
                  ),
                ),
              ),
        body: Stack(
          children: [
            PopScope(
              canPop: false,
              onPopInvokedWithResult: (didPop, result) {
                if (didPop) return;
                if (_pageController.hasClients && _pageController.page == 0.0) {
                  Navigator.pop(context);
                } else {
                  setState(() {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  });
                }
              },
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                  vertical: screenHeight * 0.02,
                ),
                child: Column(
                  children: [
                    Text(
                      currentStep > 1
                          ? heading[currentStep - 1]
                          : heading[currentStep],
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(4, (index) {
                        bool isActive = index < currentStep;
                        bool isCurrent = index == currentStep;
                        // print(isActive);
                        // print('index $index');
                        // print('current Step $currentStep');

                        return Row(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                              width: screenHeight * 0.04,
                              height: screenHeight * 0.04,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isActive
                                    ? const Color(0xff002496)
                                    : Colors.transparent,
                                border: Border.all(
                                  color: isCurrent
                                      ? const Color(0xff0F3CC9)
                                      : Colors.grey,
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: isActive
                                    ? Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: screenHeight * 0.02,
                                      )
                                    : isCurrent
                                        ? Container(
                                            width: screenHeight * 0.02,
                                            height: screenHeight * 0.02,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color(0xffCBD6FF),
                                            ),
                                          )
                                        : null,
                              ),
                            ),
                            if (index < 3)
                              Container(
                                width: screenWidth * 0.15,
                                height: screenHeight * 0.003,
                                color: isActive
                                    ? const Color(0xff002496)
                                    : Colors.grey,
                              ),
                          ],
                        );
                      }),
                    ),
                    SizedBox(height: screenWidth * 0.003),

                    // PageView for dynamic content
                    Expanded(
                      child: PageView(
                        controller: _pageController,
                       // physics: const NeverScrollableScrollPhysics(),
                        onPageChanged: (pageIndex) {
                          setState(() {
                            currentStep = pageIndex + 1;
                          });
                        },
                        children: [
                          Step1ContentWidget(
                            formKey: stepKeys[0],
                            fullNameController: fullNameController,
                            fatherNameController: fatherNameController,
                            birthPlaceController: birthPlaceController,
                            dobController: dobController,
                            cityController:cityController ,
                            chosencity: chosencity,
                            citiesID:citiesID ,
                            // citiesID: citiesID.isNotEmpty ? citiesID.join(",") : "",
                            stateController:stateController ,

                            onStateChanged: (value) {
                              setState(() {
                                selectedState = value; // Update selectedState in parent
                              });
                            },
                            onCityIdChanged: (cityId) {
                              setState(() {
                                chosencity = cityId; //
                              });
                            },
                            onCityChanged: (value) {
                              setState(() {
                                selectedCity = value; // Update selectedCity in parent
                              });
                            },
                            selectedGender: selectedGender,
                            onGenderChanged: (value) {
                              print("CityController is ${cityController.text}");
                              setState(() {
                                // print(value);
                                selectedGender = value;
                                print("selectedGender is $selectedGender");
                              });
                            },
                            isValidated: isValidated,
                            onValidation: (bool isValid) {
                              setState(() {
                                isValidated = isValid;
                              });
                            },
                          ),
                          Step2Content(
                            formKey: stepKeys[1],
                            emailController: emailController,
                            phoneController: phoneController,
                            email: email,
                            // isEmailVerified: true,
                            isEmailVerified: false,

                            phoneNumber: phoneNumber,
                            showOtpScreen: showOtpScreen,
                            onChangedPhone: (value) {
                              setState(() {
                                phoneNumber = value;

                              });
                              print("PHone number is $phoneNumber");
                            },
                            onVerifyTap: () {
                              setState(() {
                                showOtpScreen = true;
                              });
                            },
                          ),
                          Step3Content(
                            collegeNameController: collegeNameController,
                            branchNameController: branchNameController,
                            courseNameController: courseNameController,
                            yearController: yearController,
                            chosencityforcollege: chosencityforcollege,
                            citiesID:citiesID ,
                            stateControllerinEdu: collegeStateController,
                            cityControllerinEdu: collegeCityController,
                            formKey: stepKeys[2],
                            onCityIdChanged: (cityId) {
                              setState(() {
                                print("City id is $cityId");
                                chosencityforcollege = cityId; // Update parent's chosencity
                                print("Chosencity is $chosencityforcollege");
                              });
                            },
                          ),
                          _buildPasswordScreenPlaceholder(screenHeight),

                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),

                    Padding(
                      padding:  EdgeInsets.only(left: screenHeight*0.035),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton(
                            onPressed: () {
                              if (currentStep > 1) {
                                setState(() {
                                  currentStep--;
                                  _pageController.previousPage(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeInOut,
                                  );
                                });
                              } else {
                                Navigator.pop(context);
                              }
                            },
                            child: Text(
                              "Back",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: screenHeight * 0.02,
                              ),
                            ),
                          ),
                         ElevatedButton(
                          onPressed: () {
                          // onPressed: isLoading ? null : () async {
                          if (currentStep < 4) {
                            print("Proceed pressed at step: $currentStep");

                            // Step 1: Validate current step form
                            if (stepKeys[currentStep - 1].currentState?.validate() ?? false) {
                              // if (currentStep == 1) {
                              //   // Page 1: Update the UserBloc state and move to next page
                              //   context.read<UserBloc>().add(UpdatePage1(
                              //     name: fullNameController.text,
                              //     fathersName: fatherNameController.text,
                              //     gender: selectedGender!,
                              //     dob: format.parse(dobController.text) ,
                              //     state: birthPlaceController.text,
                              //   ));
                              //   setState(() {
                              //     _pageController.nextPage(
                              //       duration: const Duration(milliseconds: 500),
                              //       curve: Curves.easeInOut,
                              //     );
                              //   });
                              // }
                              if (currentStep == 1) {
                                // Validate the form first
                             //   if (widget.formKey.currentState!.validate()) {
                                  // Ensure selectedGender is not null
                                  if (selectedGender != null) {
                                    context.read<UserBloc>().add(UpdatePage1(
                                      name: fullNameController.text,
                                      fathersName: fatherNameController.text,
                                      gender: selectedGender!,
                                      dob: format.parse(dobController.text),
                                      state: birthPlaceController.text,
                                    ));
                                    setState(() {
                                      _pageController.nextPage(
                                        duration: const Duration(milliseconds: 500),
                                        curve: Curves.easeInOut,
                                      );
                                    });
                                  } else {
                                    // Show error if gender is not selected
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Please select a gender')),
                                    );
                                  }
                              //  }
                              }
                              else if (currentStep == 2) {
                                // Page 2: Validate for condition and move forward
                                if (!shouldMove || shouldMove) {
                                  print("Moving to the next page at step 2");

                                  context.read<UserBloc>().add(UpdatePage2(
                                    email: email,
                                    phoneNumber: phoneNumber
                                  ));
                                  setState(() {
                                    _pageController.nextPage(
                                      duration: const Duration(milliseconds: 500),
                                      curve: Curves.easeInOut,
                                    );
                                  });
                                } else {
                                  print("$shouldMove");
                                  //ScaffoldMessenger.of(context).showSnackBar(
                                    // SnackBar(
                                    //   backgroundColor: Colors.white,
                                    //   content: Text(
                                    //     "Please verify to move forward.",
                                    //     style: GoogleFonts.poppins(
                                    //     color: AppColors.primaryColor,
                                    //       fontSize: screenWidth * 0.04,
                                    //     ),
                                    //   ),
                                    //   duration: const Duration(seconds: 2),
                                    // ),
                               //   );
                                }
                              } else if (currentStep == 3) {
                                // Page 3: Update UserBloc state and move to next page
                                context.read<UserBloc>().add(UpdatePage3(
                                  collegeName: collegeNameController.text,
                                  branch: branchNameController.text,
                                  course: courseNameController.text,
                                  year: yearController.text,
                                ));
                                setState(() {
                                  _pageController.nextPage(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeInOut,
                                  );
                                });
                              }
                            }
                            else {
                              print('Please fill out all required fields.');
                            }
                          }
                          else if (currentStep == 4) {

                            // Step 4: Final form submission or transition to the next screen
                            if (stepKeys[currentStep - 1].currentState?.validate() ?? false) {
                              registerUser({
                                "full_name": fullNameController.text,
                                "father_name": fatherNameController.text,
                                "college_state": collegeStateController.text,
                                "birth_place": stateController.text,
                                "college_city":chosencityforcollege,
                                "password": passwordController.text,
                                "current_city":chosencity,
                                "college_name":collegeNameController.text,
                                "branch_name": branchNameController.text,
                                "degree_name": courseNameController.text,
                                "passing_year": yearController.text,
                                "date_of_birth": dobController.text,
                                "gender": selectedGender.toString(),
                                "email": emailController.text,
                                "current_state":stateController.text,
                                "phone_number": phoneController.text,
                                // "current_city": citiesID.isNotEmpty ? citiesID.join(",") : "",
                                // "whatsapp_number":phoneController.text
                                // "current_city": citiesID.isNotEmpty ? citiesID.first.toString() : null,

                              });



                            }
                            else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Please try again'),
                                  duration: const Duration(seconds: 2),
                                  backgroundColor: AppColors.primaryColor,
                                ),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff0F3CC9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.08,
                            vertical: screenHeight * 0.015,
                          ),
                          child: Text(
                            currentStep < 4 ? "Proceed" : "Submit",
                            style: TextStyle(
                              fontSize: screenHeight * 0.02,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )

                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (showOtpScreen) _buildOtpOverlay(context),
          ],
        ),
      ),
    );
  }


  Widget _buildOtpOverlay(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        setState(() {
         showOtpScreen = false; // Close OTP screen when back button is pressed
         isEmailVerified=false;
        });
        return false; // Prevent default back navigation
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: SingleChildScrollView(
            child: Container(
              color: Colors.white.withOpacity(0.90),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.05,
                    vertical: screenWidth * 0.02,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.5,
                        child: Image.asset(
                          'assets/images/logo (2).png',
                          height: screenWidth * 0.1,
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(height: screenWidth * 0.01),
                      Text(
                        "OTP Verification",
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: screenWidth * 0.01),
                      Text(
                        "Enter the verification code we have sent to your Gmail-${emailController.text}",
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.035,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: screenWidth * 0.04),

                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.035,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(
                            4,
                                (index) => SizedBox(
                              width: screenWidth * 0.15,
                              child: TextField(
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    otpDigits[index] = value; // Update specific index
                                    if (index < 3) {
                                      FocusScope.of(context).nextFocus(); // Move to next field
                                    }
                                  } else {
                                    otpDigits[index] = ""; // Clear digit
                                    if (index > 0) {
                                      FocusScope.of(context).previousFocus();
                                    }
                                  }
                                },
                                decoration: InputDecoration(
                                  counterText: "",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(screenWidth * 0.04),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(screenWidth * 0.04),
                                    ),
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                      width: screenWidth * 0.0035,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(screenWidth * 0.04),
                                    ),
                                    borderSide: BorderSide(
                                      color: AppColors.primaryColor,
                                      width: screenWidth * 0.0035,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenWidth * 0.2),
                      ElevatedButton(
                        onPressed: () {
                          generateOtp(emailController.text);
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(screenWidth*0.025, screenWidth * 0.025),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(screenWidth * 0.05),
                          ),
                          backgroundColor: AppColors.primaryColor,
                        ),
                        child: Text(
                          "Resend OTP",
                          style: GoogleFonts.poppins(
                            color: AppColors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: screenWidth * 0.04,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                        //  validateOtp(otpInput.split('').reversed.join());
                          String finalOtp = otpDigits.join(); // Combine all entered digits
                          validateOtp(finalOtp); // Reverse OTP before sending

                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, screenWidth * 0.15),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(screenWidth * 0.05),
                          ),
                          backgroundColor: AppColors.primaryColor,
                        ),
                        child: Text(
                          "Verify OTP",
                          style: GoogleFonts.poppins(
                            color: AppColors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: screenWidth * 0.04,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildPasswordScreenPlaceholder(double screenHeight) {
    return SingleChildScrollView(
      child: Center(
        child: Form(
          key: stepKeys[3],
          child: Column(
            children: [
              // ElevatedButton(onPressed: (){
              //   print(branchNameController.text);
              // }, child: Text("he")),
              SizedBox(height: screenHeight * 0.05),
              Padding(
                padding: EdgeInsets.only(left: screenHeight * 0.001),
                child: Text.rich(
                  TextSpan(
                    text: "Min 8 characters",
                    style: TextStyle(
                        fontSize: screenHeight * 0.02,
                        color: Color(0xFF0F3CC9)),
                    children: const [
                      TextSpan(
                        text: ", 1 uppercase, 1 digit, 1 special character",
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              // Password Field
              CustomPasswordField(
                passwordController: passwordController,
                label: "Password",
                hintText: "********",
                isPasswordVisible: isPasswordVisible,
                onToggleVisibility: () {
                  setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  });
                },
                onChanged: (value) {
                  setState(() {
                    password = value; // Store the password value
                    passwordError = _validatePassword(value);
                  });
                },
                errorText: passwordError,
                validator: _validatePassword,
              ),
              SizedBox(height: screenHeight * 0.02),
              // Confirm Password Field
              CustomPasswordField(
                passwordController: confirmPasswordController,
                label: "Confirm Password",
                hintText: "********",
                isPasswordVisible: isConfirmPasswordVisible,
                onToggleVisibility: () {
                  setState(() {
                    isConfirmPasswordVisible = !isConfirmPasswordVisible;
                  });
                },
                onChanged: (value) {
                  setState(() {
                    confirmPasswordError =
                        value == password ? null : "Passwords do not match";
                  });
                },
                errorText: confirmPasswordError,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Confirm password is required";
                  }
                  if (value != password) {
                    return "Passwords do not match";
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

// Validation Method
  String? _validatePassword(String? password) {
    if (!RegExp(r'^(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$%^&*(),.?":{}|<>]).{8,}$')
        .hasMatch(password!)) {
      return "Password must include at least 1 uppercase letter";
    }
    return null;
  }
}
