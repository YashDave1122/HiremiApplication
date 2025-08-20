import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserProfileScreen extends StatelessWidget {
  // Data to send in the POST request
  Map<String, dynamic> userData = {
    "birth_state": "Madhya Pradesh",
    "birth_city": "Bhopal",
    "are_you_differently_abled": false,
    "pincode": "462021",
    "register": "1",
  };

  // Simple POST request function
  Future<void> postUserData() async {
    const String apiUrl = "http://13.127.246.196:8000/api/userprofiles/";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(userData),
      );

      if (response.statusCode == 201) {
        print("User data successfully posted!");
      } else {
        print("Failed to post data: ${response.statusCode}");
      }
    } catch (e) {
      print("Error occurred: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User Profile")),
      body: Center(
        child: ElevatedButton(
          onPressed: postUserData,  // Trigger the POST request on button click
          child: Text("Submit Data"),
        ),
      ),
    );
  }
}
