import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pre_dashboard/AppSizes/AppSizes.dart';
import 'package:pre_dashboard/HomePage/constants/constantsColor.dart';
import 'package:pre_dashboard/ProfileScreen/ContactDetails/AddContactsDeatils.dart';
import 'package:pre_dashboard/ProfileScreen/ProfileSummary/OutlinedContainer.dart';
import 'package:shared_preferences/shared_preferences.dart';
//
// class Contactdeatils extends StatefulWidget {
//   const Contactdeatils({super.key});
//
//   @override
//   State<Contactdeatils> createState() => _ContactdeatilsState();
// }
//
// class _ContactdeatilsState extends State<Contactdeatils> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _loadUserDetails();
//   }
//   Map<String, dynamic>? userDetails;
//   Future<void> _loadUserDetails() async {
//     final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//     final String? userDetailsString = sharedPreferences.getString('userDetails');
//
//     if (userDetailsString != null) {
//       setState(() {
//         userDetails = jsonDecode(userDetailsString);
//       });
//       print("userDetails are $userDetails");
//
//     }
//     else{
//       print("Data is empty");
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildDetailRow(context, "Email", userDetails!['email']),
//         _buildDetailRow(context, "Contact Number", userDetails?['phone_number']),
//         _buildDetailRow(context, "Whats App Number", userDetails?['whatsapp_number']),
//
//       ],
//     );
//   }
//
//   Widget _buildDetailRow(BuildContext context, String label, String? value) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: Sizes.responsiveMd(context) * 1.25,
//             fontWeight: FontWeight.bold,
//             color: Colors.black,
//           ),
//         ),
//         SizedBox(height: Sizes.responsiveXs(context)*2.3),
//         Text(
//           value ?? 'N/A', // Handle null values safely
//           style: TextStyle(
//             fontSize: Sizes.responsiveMd(context),
//             color: AppColors.secondaryText,
//           ),
//         ),
//         SizedBox(height: Sizes.responsiveXs(context)*1.3),
//         Divider(
//           height: 0.25,
//           thickness: 0.55,
//           color: AppColors.secondaryText,
//         ),
//         SizedBox(height: Sizes.responsiveXs(context)),
//       ],
//     );
//   }
// }
class Contactdeatils extends StatefulWidget {
  const Contactdeatils({super.key});

  @override
  State<Contactdeatils> createState() => _ContactdeatilsState();
}

class _ContactdeatilsState extends State<Contactdeatils> {
  Map<String, dynamic>? userDetails;

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  Future<void> _loadUserDetails() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final String? userDetailsString = sharedPreferences.getString('userDetails');

    if (userDetailsString != null) {
      setState(() {
        userDetails = jsonDecode(userDetailsString);
      });
      print("userDetails are $userDetails");
    } else {
      print("Data is empty");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if userDetails is null before rendering the widget
    if (userDetails == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return OutlinedContainer(
      showAdd: false,

      title: "Contact Details",
      onEditTap: () async {
        print("COntact Details");
        final result = await Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const Addcontactsdeatils()),
        );

        if (result == true) {
          _loadUserDetails(); // Refresh user details after editing
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow(context, "Email", userDetails?['email']),
          _buildDetailRow(context, "Contact Number", userDetails?['phone_number']),
          _buildDetailRow(context, "Whats App Number", userDetails?['whatsapp_number']),
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String? value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: Sizes.responsiveMd(context) * 1.25,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: Sizes.responsiveXs(context) * 2.3),
        Text(
          value ?? 'N/A', // Handle null values safely
          style: TextStyle(
            fontSize: Sizes.responsiveMd(context),
            color: AppColors.secondaryText,
          ),
        ),
        SizedBox(height: Sizes.responsiveXs(context) * 1.3),
        Divider(
          height: 0.25,
          thickness: 0.55,
          color: AppColors.secondaryText,
        ),
        SizedBox(height: Sizes.responsiveXs(context)),
      ],
    );
  }
}
