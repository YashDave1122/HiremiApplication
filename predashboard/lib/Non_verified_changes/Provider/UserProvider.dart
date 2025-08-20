import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pre_dashboard/API.dart';
import 'package:pre_dashboard/SharedPreferences/SharedPreferences.dart';
import 'package:pre_dashboard/shared_preferences_helper.dart';

class UserProvider with ChangeNotifier {

  // Future<bool> updateUserDetails(int userId, Map<String, dynamic> updatedDetails) async {
  //
  //   final url = Uri.parse('${ApiUrls.registration}$userId/');
  //
  //   try {
  //     final response = await http.patch(
  //       url,
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode(updatedDetails),
  //     );
  //
  //     if (response.statusCode == 200) {
  //       print("Response body and code is ${response.body} and ${response.statusCode} ");
  //       final SharedPreferencesService _sharedPreferencesService = SharedPreferencesService();
  //
  //       // Fetch the existing user details
  //       final existingDetails = await _sharedPreferencesService.getUserDetails();
  //
  //       // Merge updatedDetails with existingDetails
  //       final mergedDetails = {
  //         if (existingDetails != null) ...existingDetails,
  //         ...updatedDetails,
  //       };
  //
  //       // Save the merged details
  //       await _sharedPreferencesService.saveUserDetails(mergedDetails);
  //       return true;
  //       // print("Merged details are $mergedDetails");
  //       //   print("Resposne body is ${response.body}");
  //       // debugPrint('User details updated successfully.');
  //     }
  //
  //     else {
  //       print("Failed to update user details. Status Code: ${response.statusCode} and ${response.body}");
  //     }
  //   } catch (error) {
  //     print('Error updating user details: $error');
  //   }
  // }
  Future<bool> updateUserDetails(int userId, Map<String, dynamic> updatedDetails) async {
    final url = Uri.parse('${ApiUrls.registration}$userId/');

    try {
      final response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updatedDetails),
      );

      if (response.statusCode == 200) {
        print("Response body and code is ${response.body} and ${response.statusCode}");

        final SharedPreferencesService _sharedPreferencesService = SharedPreferencesService();
        final existingDetails = await _sharedPreferencesService.getUserDetails();

        final mergedDetails = {
          if (existingDetails != null) ...existingDetails,
          ...updatedDetails,
        };

        // Save the merged details
        await _sharedPreferencesService.saveUserDetails(mergedDetails);

        return true; // Return success
      } else {
        print("Failed to update user details. Status Code: ${response.statusCode} and ${response.body}");
        return false; // Return failure
      }
    } catch (error) {
      print('Error updating user details: $error');
      return false; // Return failure
    }
  }


  Future<bool> updateContactDetails(int userId, Map<String, dynamic> updatedDetails) async {
    final url = Uri.parse('${ApiUrls.registration}$userId/');

    try {
      // Prepare the API payload with +91 prefix
      final apiDetails = {
        'email': updatedDetails['email'],
        'phone_number': '+91${updatedDetails['phone_number'].replaceAll('+91', '')}',
        'whatsapp_number': '+91${updatedDetails['whatsapp_number'].replaceAll('+91', '')}',
      };

      final response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(apiDetails),
      );

      if (response.statusCode == 200) {
        print("Response body and code is ${response.body} and ${response.statusCode}");

        final SharedPreferencesService _sharedPreferencesService = SharedPreferencesService();
        final existingDetails = await _sharedPreferencesService.getUserDetails();

        // Save merged details **without +91**
        final mergedDetails = {
          if (existingDetails != null) ...existingDetails,
          'email': updatedDetails['email'],
          'phone_number': updatedDetails['phone_number'].replaceAll('+91', ''),
          'whatsapp_number': updatedDetails['whatsapp_number'].replaceAll('+91', ''),
        };

        // Save the merged details (without +91)
        print("Merged details are $mergedDetails");
        await _sharedPreferencesService.saveUserDetails(mergedDetails);
        return true;
      } else {
        print("Failed to update user details. Status Code: ${response.statusCode} and ${response.body}");
        return false; // Ensure function returns false in case of failure
      }
    } catch (error) {
      print('Error updating user details: $error');
      return false; // Ensure function returns false in case of failure
    }
  }


  Future<void> updateEducationsDetails(int userId, Map<String, dynamic> updatedDetails) async {
    print("User id is in updateEducationsDetails $userId");
    final url = Uri.parse('${ApiUrls.education}$userId/');

    try {
      final String? token = await SharedPreferencesHelper.getToken();
      print("Token is $token");
      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',

        },
        body: jsonEncode(updatedDetails),
      );

      if (response.statusCode == 200) {
        print("Response body and code is ${response.body} and ${response.statusCode} ");
        final SharedPreferencesService _sharedPreferencesService = SharedPreferencesService();

        // Fetch the existing user details
        // final existingDetails = await _sharedPreferencesService.getUserDetails();
        //
        // // Merge updatedDetails with existingDetails
        // final mergedDetails = {
        //   if (existingDetails != null) ...existingDetails,
        //   ...updatedDetails,
        // };
        //
        // // Save the merged details
        // await _sharedPreferencesService.saveUserDetails(mergedDetails);
        // print("Merged details are $mergedDetails");
        //   print("Resposne body is ${response.body}");
        // debugPrint('User details updated successfully.');

        final existingDetails = await _sharedPreferencesService.getEducationDetails();

        // Merge updatedDetails with existingDetails
        final mergedDetails = {
          if (existingDetails != null) ...existingDetails,
          ...updatedDetails,
        };

        // Save the merged details
        await _sharedPreferencesService.saveEducationDetails(mergedDetails);
        print("Merged details re $mergedDetails");
      }

      else {
        print("Failed to update user details. Status Code: ${response.statusCode} and ${response.body}");
      }
    } catch (error) {
      print('Error updating user details: $error');
    }
  }

  // Future<void> addEducationDetails(Map<String, dynamic> updatedDetails) async {
  //   print("User id is in AddEducationsDetails ");
  //   final url = Uri.parse('${ApiUrls.education}');
  //
  //   try {
  //     final String? token = await SharedPreferencesHelper.getToken();
  //     print("Token is $token");
  //     final response = await http.post(
  //       url,
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $token',
  //
  //       },
  //       body: jsonEncode(updatedDetails),
  //     );
  //
  //     if (response.statusCode == 201) {
  //       print("Response body and code is ${response.body} and ${response.statusCode} ");
  //       final SharedPreferencesService _sharedPreferencesService = SharedPreferencesService();
  //
  //
  //
  //       final existingDetails = await _sharedPreferencesService.getEducationDetails();
  //
  //       // Merge updatedDetails with existingDetails
  //       final mergedDetails = {
  //         if (existingDetails != null) ...existingDetails,
  //         ...updatedDetails,
  //       };
  //
  //       // Save the merged details
  //       await _sharedPreferencesService.saveEducationDetails(mergedDetails);
  //       print("Merged details re $mergedDetails");
  //     }
  //
  //     else {
  //       print("Failed to update user details. Status Code: ${response.statusCode} and ${response.body}");
  //     }
  //   } catch (error) {
  //     print('Error updating user details: $error');
  //   }
  // }
  Future<void> addEducationDetails(Map<String, dynamic> updatedDetails) async {
    print("User id is in AddEducationsDetails");
    final url = Uri.parse('${ApiUrls.education}');

    try {
      final String? token = await SharedPreferencesHelper.getToken();
      print("Token is $token");
      final response = await http.post( // Use POST instead of PATCH for adding
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(updatedDetails),
      );

      if (response.statusCode == 201) {
        print("Response body and code is ${response.body} and ${response.statusCode}");
        final SharedPreferencesService _sharedPreferencesService = SharedPreferencesService();

        // Retrieve the added education details
        // final existingDetails = await _sharedPreferencesService.getAddedEducationDetails();

        // Merge added details with the existing ones
        // final List<dynamic> updatedList = existingDetails != null
        //     ? [...existingDetails, updatedDetails]
        //     : [updatedDetails];

        // await _sharedPreferencesService.saveAddedEducationDetails(updatedList);
        // print("Updated Added Education Details: $updatedList");
      } else {
        print("Failed to add user details. Status Code: ${response.statusCode} and ${response.body}");
      }
    } catch (error) {
      print('Error adding user details: $error');
    }
  }


}
