import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pre_dashboard/API.dart';
import 'package:pre_dashboard/HomePage/screens/HomeScreen.dart';
import 'package:pre_dashboard/SharedPreferences/SharedPreferences.dart';
import 'package:pre_dashboard/predashboard/screens/LoginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class FinalScreen extends StatefulWidget {
  @override
  FinalScreenState createState() => FinalScreenState();
}

class FinalScreenState extends State<FinalScreen> {

  static const String KEYLOGIN ="login";
  final SharedPreferencesService _prefsService = SharedPreferencesService();

  String Email="";

  @override
  void initState() {
    super.initState();
    _loginAndGetToken();
    // _loadUserDetails();

  }
  Future<String?> _loginAndGetToken() async {
    final sharedPreferencesService = SharedPreferencesService();


    String? email = await sharedPreferencesService.getUserEmail();
    String? password = await sharedPreferencesService.getUserPassword();
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
      _isEmailVerified(email!,token);

      // await SharedPreferencesHelper.setToken(token);
      // print("Token: $token");
      return token;
    }
    else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreenUpdated()),
      );
      print("Login failed: ${response.body}");
      return null;
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
            // print("We are in if section");
            // whereToGo();
            //
            // print("Verification Status: ${user['verified']}");
            // return user['verified'] ?? false;
            bool isVerified = user['verified'] ?? false;
            print("Verification Status: $isVerified");
            // whereToGo(isVerified: isVerified);
            _loadUserDetails(isVerified:isVerified);
            return isVerified;
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
  Future<void> _loadUserDetails({required bool isVerified}) async {
    final details = await _prefsService.getUserDetails();
    if (details != null) {
      setState(() {
        Email = details['email'];
      });
      whereToGo(isVerified: isVerified);

      print("Email is $Email");
    } else {
      print("No user details found.");
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body:  Center(
        child: Image.asset(
          'assets/images/Hiremi.png',
          width: screenWidth * 0.36,
          height: screenWidth * 0.09,
        ),
      ),
    );
  }


  void whereToGo({required bool isVerified}) async{
    var sharedPref= await SharedPreferences.getInstance();
    var isLoggedIn=sharedPref.getBool(KEYLOGIN);
    Future.delayed(Duration(seconds: 2), () {
      if(isLoggedIn!=null)
      {
       if(isLoggedIn){
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen(isVerified: isVerified, animation: false, email: Email)),
          );
        }
       }
       else{
         if (mounted) {
           Navigator.push(
             context,
             MaterialPageRoute(builder: (context) => LoginScreenUpdated()),
           );
         }
       }
      }
      else{
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginScreenUpdated()),
          );
        }
      }

    });
  }
}


