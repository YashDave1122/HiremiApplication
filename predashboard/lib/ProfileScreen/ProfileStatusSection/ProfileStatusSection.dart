
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:pre_dashboard/AppSizes/AppSizes.dart';
import 'package:pre_dashboard/HomePage/constants/constantsColor.dart';
import 'package:pre_dashboard/SharedPreferences/SharedPreferences.dart';
import 'package:pre_dashboard/shared_preferences_helper.dart';

class ProfileStatusSection extends StatefulWidget {
  const ProfileStatusSection({Key? key}) : super(key: key);

  @override
  State<ProfileStatusSection> createState() => _ProfileStatusSectionState();
}

class _ProfileStatusSectionState extends State<ProfileStatusSection> {
 String FullName="";
 final SharedPreferencesService _prefsService = SharedPreferencesService();

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }
  Future<void> _loadUserDetails() async {
    final details = await _prefsService.getUserDetails();
    if (details != null) {
      print("Details is $details");
      setState(() {

        FullName=details['full_name'];
      });

    }
  }


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(Sizes.responsiveLg(context)),
            decoration: BoxDecoration(
              color: HexColor('#FBEEEE'),
              shape: BoxShape.circle,
              border: Border.all(width: 5, color: AppColors.green),
            ),
            child: Icon(
              Icons.person,
              color: AppColors.primary,
              size: Sizes.responsiveMd(context), // Adjust icon size as needed
            ),
          ),
          SizedBox(height: Sizes.responsiveMd(context)),
          Text(
            FullName != null ? FullName!.split(' ').first : 'Loading...', // Handle null case
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          SizedBox(height: Sizes.responsiveSm(context)),
          Container(
            padding: EdgeInsets.symmetric(
              vertical: Sizes.responsiveVerticalSpace(context),
              horizontal: Sizes.responsiveHorizontalSpace(context),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                width: 0.7,
                color: Color(0xFF163EC8),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Image.asset(
                //   'images/icons/verified.png',
                //   height: MediaQuery.of(context).size.width * 0.025,
                //   width: MediaQuery.of(context).size.width * 0.025,
                // ),
                SizedBox(width: Sizes.responsiveXs(context)),
                Text(
                  'Verified',
                  style: TextStyle(
                    color: AppColors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: Sizes.responsiveSm(context)),
          // Uncomment and use if needed
          // Text(
          //   'Last updated today',
          //   style: TextStyle(
          //     fontSize: 10.0,
          //     fontWeight: FontWeight.w400,
          //     color: AppColors.secondaryText,
          //   ),
          // ),
        ],
      ),
    );
  }
}
