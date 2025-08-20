
import 'package:flutter/material.dart';
import 'package:pre_dashboard/AppSizes/AppSizes.dart';
import 'package:pre_dashboard/FresherJobs/RoundedIcon.dart';
import 'package:pre_dashboard/HomePage/constants/constantsColor.dart';
import 'package:pre_dashboard/Internship/RoundecContainer.dart';




class HeaderSectionFresher extends StatelessWidget {
  const HeaderSectionFresher({

    required this.profile,
    required this.companyName,
    required this.location,
    required this.ctc, required this.onTap,
    required this.buttonText, // Added parameter
    required this.education,
    required this.mode,
    required this.exp,
    required this.daysPosted,
  });
  final String profile;
  final String companyName;
  final String location;
  final double ctc;
  final void Function() onTap;
  final String buttonText;
  final String education;
  final String mode;
  final String exp;
  final String daysPosted;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: [
            RoundedIcon(
                icon: Icon(Icons.business, color: Colors.grey),// Replace with your desired icon
                border: Border.all(width: 5.0, color: AppColors.lightGrey)),
            SizedBox(
              width: Sizes.responsiveXs(context),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  profile.length > 25 ? '${profile.substring(0, 25)}...' : profile,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  companyName,
                  style: const TextStyle(
                      fontSize: 8.0,
                      fontWeight: FontWeight.w400,
                      color: AppColors.black),
                ),
              ],
            ),
            const Spacer(),
            Align(
              alignment: Alignment.topRight,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.av_timer,
                    size: 8,
                  ),
                  SizedBox(
                    width: Sizes.responsiveXxs(context),
                  ),
                  Text(
                    '$daysPosted days ago',
                    style: TextStyle(
                        fontSize: 8.0,
                        fontWeight: FontWeight.w400,
                        color: AppColors.secondaryText),
                  ),
                ],
              ),
            )
          ],
        ),
        SizedBox(
          height: Sizes.responsiveSm(context),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.location_on_rounded,
                size: 8, color: AppColors.secondaryText),
            SizedBox(
              width: Sizes.responsiveXxs(context),
            ),
            Text(
              location,
              style: const TextStyle(
                fontSize: 8.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.school,
                size: 8, color: AppColors.secondaryText),
            SizedBox(
              width: Sizes.responsiveXxs(context),
            ),
            Text(
              education,
              style: const TextStyle(
                fontSize: 8.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.currency_rupee,
              size: 8,
              color: AppColors.secondaryText,
            ),
            SizedBox(
              width: Sizes.responsiveXxs(context),
            ),
            Text(
              '₹$ctc LPA',
              style: const TextStyle(
                fontSize: 8.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        SizedBox(
          height: Sizes.responsiveSm(context),
        ),
        Row(
          children: [
            RoundedContainer(
                color: AppColors.lightOrange,
                radius: 2,
                padding: EdgeInsets.symmetric(
                    horizontal: Sizes.responsiveXs(context),
                    vertical: Sizes.responsiveXs(context)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.shop,
                      color: AppColors.orange,
                      size: 8,
                    ),
                    SizedBox(
                      width: Sizes.responsiveXxs(context) * 1.5,
                    ),
                    Text(
                      '$mode',
                      style: TextStyle(
                        fontSize: 8.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                )),
            SizedBox(
              width: Sizes.responsiveSm(context),
            ),
            RoundedContainer(
                color: AppColors.lightOrange2,
                radius: 2,
                padding: EdgeInsets.symmetric(
                    horizontal: Sizes.responsiveXs(context),
                    vertical: Sizes.responsiveXs(context)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.access_alarms_rounded,
                      color: AppColors.primary,
                      size: 8,
                    ),
                    SizedBox(
                      width: Sizes.responsiveXxs(context) * 1.5,
                    ),
                    const Text(
                      'Job',
                      style: TextStyle(
                        fontSize: 8.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                )),
            SizedBox(
              width: Sizes.responsiveSm(context),
            ),
            RoundedContainer(
                color: AppColors.lightPink,
                radius: 2,
                padding: EdgeInsets.symmetric(
                    horizontal: Sizes.responsiveXs(context),
                    vertical: Sizes.responsiveXs(context)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.work,
                      color: AppColors.pink,
                      size: 8,
                    ),
                    SizedBox(
                      width: Sizes.responsiveXxs(context) * 1.5,
                    ),
                    Text(
                      '$exp year exp',
                      style: TextStyle(
                        fontSize: 8.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                )),
            const Spacer(),
            SizedBox(
              width: Sizes.responsiveXxl(context) * 2.02,
              height: Sizes.responsiveLg(context) * 1.06,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF163EC8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Sizes.radiusXs)),
                    padding: EdgeInsets.symmetric(
                        vertical: Sizes.responsiveHorizontalSpace(context),
                        horizontal: Sizes.responsiveMdSm(context)),
                  ),
                  onPressed: onTap,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        buttonText,
                        style: TextStyle(
                          fontSize: 8.5,
                          fontWeight: FontWeight.w500,
                          color: AppColors.white,
                        ),
                      ),
                      SizedBox(
                        width: Sizes.responsiveXs(context),
                      ),

                    ],
                  )),
            )
          ],
        ),
        SizedBox(
          height: Sizes.responsiveSm(context),
        ),
        Divider(
          color: AppColors.secondaryText,
          thickness: 0.25,
          height: 0.25,
        )
      ],
    );
  }
}
