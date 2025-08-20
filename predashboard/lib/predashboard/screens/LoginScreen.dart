import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pre_dashboard/HomePage/screens/HomeScreen.dart';
import 'package:http/http.dart' as http;
import 'package:pre_dashboard/SharedPreferences/SharedPreferences.dart';
import 'package:pre_dashboard/predashboard/screens/password_recovery_page_screen.dart';
import 'package:pre_dashboard/predashboard/screens/register_screen.dart';
import 'package:pre_dashboard/predashboard/screens/splash_screens/splashscreen3.dart';
import 'package:pre_dashboard/predashboard/widgets/LoginAnimation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../API.dart';

import '../widgets/custom_text_field.dart';
// import '../screens/RegistrationScreen.dart';

class LoginScreenUpdated extends StatefulWidget {
  @override
  _LoginScreenUpdatedState createState() => _LoginScreenUpdatedState();
}
//Yash
class _LoginScreenUpdatedState extends State<LoginScreenUpdated> {
  @override

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _showAnimation = false;
  final SharedPreferencesService _prefsService = SharedPreferencesService();



  void initState() {
    // TODO: implement initState
    super.initState();

  }
  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _showAnimation = true;
      });

      final url = Uri.parse(ApiUrls.Login);
      final sharedPreferencesService = SharedPreferencesService();

      try {
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'email': _emailController.text.trim(),
            'password': _passwordController.text.trim(),
          }),
        );

        if (response.statusCode == 200) {
          await sharedPreferencesService.saveUserCredentials(
            _emailController.text.trim(),
            _passwordController.text.trim(),
          );

          final accessToken = jsonDecode(response.body)['access_token'];

          var sharedPref=await SharedPreferences.getInstance();
          sharedPref.setBool(FinalScreenState.KEYLOGIN, true);

          // Check if the email is verified
          bool isVerified = await _isEmailVerified(_emailController.text.trim(),accessToken);

          if (isVerified) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(
                  isVerified: true,
                  animation: false,
                  email: _emailController.text.trim(),
                ),
              ),
            );
            print(" ✅ Email is verified.");
          }
          else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(
                  isVerified: false,
                  animation: false,
                  email: _emailController.text.trim(),
                ),
              ),
            );
            print("❗Email is not verified.");
          }

          print('Login Successful: ${response.body} and ${response.statusCode}');
        }
        else {
          final errorBody = jsonDecode(response.body);
          final errorMessage = errorBody['non_field_errors'] != null
              ? errorBody['non_field_errors'][0]
              : 'Login failed. Please try again.';

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                errorMessage,
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(20),
            ),
          );
        }
      } catch (e) {
        print('An error occurred: $e');
      } finally {
        setState(() {
          _isLoading = false;
          _showAnimation = false;
        });
      }
    }
  }

  Future<bool> _isEmailVerified(String email,String accessToken) async {
    print("Email is $email");
    final String apiUrl = "${ApiUrls.registration}";
    try {
      final response = await http.get(Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> users = jsonDecode(response.body);
        for (var user in users) {
          if (user['email'] == email) {
            print("We are in if section");

            print("Verification Status: ${user['verified']}");
            return user['verified'] ?? false;
          }
          else{
           print("We are in else section");
          }
        }
      }

      else{
        print("Status code is ${response.statusCode} and response body is ${response.body}");
      }
    } catch (e) {
      print('Error checking verification: $e');
    }
    return false;
  }


  @override
  Widget build(BuildContext context) {
    print("Building");
    final size = MediaQuery.of(context).size;

    return WillPopScope(
        onWillPop: () async {
          // Return false to prevent back navigation
          return false;
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: _showAnimation
              ? LoginAnimation()
              : SafeArea(
           child: SingleChildScrollView(
            child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.05,
                    vertical: size.height * 0.02,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: size.height * 0.015),

                      Image.asset(
                        'assets/images/Hiremi.png',
                        width: size.width * 0.31,
                        height: size.height * 0.03,
                      ),

                      SizedBox(height: size.height * 0.055),
                      Text(
                        'Welcome back you’ve \nbeen missed!',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: size.width * 0.05,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: size.height * 0.065),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            CustomTextField(
                              controller: _emailController,
                              hintText: 'Email',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$')
                                    .hasMatch(value)) {
                                  return 'Enter a valid email';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: size.height * 0.015),
                            CustomTextField(
                              controller: _passwordController,
                              hintText: 'Password',
                              isPassword: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                            ),

                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(context,MaterialPageRoute(builder: (context)=> PasswordRecoveryPageScreen()));
                                },
                                child: Text(
                                  'Forgot password?',
                                  style: GoogleFonts.poppins(
                                    fontSize: size.width * 0.03,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xff0f3cc9),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: size.height * 0.045),
                      SizedBox(
                        height: size.height * 0.08,
                        width: size.width * 0.9,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff0F3CC9),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 6,
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  'Sign in',
                                  style: GoogleFonts.poppins(
                                    fontSize: size.width * 0.05,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.03),
                      SizedBox(
                        height: size.height * 0.07,
                        width: size.width * 0.9,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterScreenEducational(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffffffff),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Create new account',
                            style: GoogleFonts.poppins(
                              fontSize: size.width * 0.04,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xff494949),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
      ),
    ),
          ),

    );
  }
}