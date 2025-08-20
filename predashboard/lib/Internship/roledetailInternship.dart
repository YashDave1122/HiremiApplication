import 'package:flutter/material.dart';

import 'package:pre_dashboard/AppSizes/AppSizes.dart';
import 'package:pre_dashboard/HomePage/constants/constantsColor.dart';


class RoleDetailsInternship extends StatelessWidget {
  final String profile;
  final String location;
  final double ctc;
  final String description;

  const RoleDetailsInternship({
    Key? key,
    required this.profile,
    required this.location,
    required this.ctc,
    required this.description,
  }) : super(key: key);

  // @override
  // Widget build(BuildContext context) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         profile,
  //         style: Theme.of(context).textTheme.titleSmall,
  //       ),
  //       SizedBox(
  //         height: Sizes.responsiveSm(context),
  //       ),
  //       Text(
  //         location,
  //         style: const TextStyle(
  //           fontSize: 8.0,
  //           fontWeight: FontWeight.w400,
  //         ),
  //       ),
  //       Row(
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: [
  //           Icon(
  //             Icons.currency_rupee,
  //             size: 8,
  //             color: AppColors.secondaryText,
  //           ),
  //           SizedBox(
  //             width: Sizes.responsiveXxs(context),
  //           ),
  //           Text(
  //             '₹$ctc',
  //             style: const TextStyle(
  //               fontSize: 8.0,
  //               fontWeight: FontWeight.w400,
  //             ),
  //           ),
  //         ],
  //       ),
  //       SizedBox(
  //         height: Sizes.responsiveSm(context),
  //       ),
  //       Text(
  //         description,
  //         style: const TextStyle(
  //           fontSize: 8.0,
  //           fontWeight: FontWeight.w400,
  //           height: 1.5,
  //         ),
  //       ),
  //     ],
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Job Title
        Text('Role : $profile',
            style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF163EC8))),
        SizedBox(height: Sizes.responsiveLg(context)),
        Text(
          'Location: $location',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.green,
          ),
        ),
        SizedBox(
          height: Sizes.responsiveXs(context),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Stipend: ',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.green,
              ),
            ),
            // Salary₹
            Text(
              '$ctc per month',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        SizedBox(height: Sizes.responsiveXl(context)),
        // About Job Section
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('About the Role',
                style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF163EC8))),
            SizedBox(
              height: Sizes.responsiveXs(context),
            ),
            Text(
              description,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
            ),
            // Padding(
            //   padding:
            //   EdgeInsets.only(left: Sizes.responsiveXxs(context)),
            //   // First
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       buildBulletPoint(
            //           context: context,
            //           number: '1.',
            //           text:
            //           'Sourcing and Recruiting: Identify and recruit potential candidates through various channels.'),
            //       buildBulletPoint(
            //           context: context,
            //           number: '2.',
            //           text:
            //           'Screening Resumes: Evaluate candidate qualifications and skills.'),
            //       buildBulletPoint(
            //           context: context,
            //           number: '3.',
            //           text:
            //           'Conducting Interviews: Arrange and conduct interviews with potential candidates.'),
            //       buildBulletPoint(
            //           context: context,
            //           number: '4.',
            //           text:
            //           'Coordinating: Manage and coordinate with hiring managers to fulfill staffing needs.'),
            //       buildBulletPoint(
            //           context: context,
            //           number: '5.',
            //           text:
            //           'Maintaining Records: Keep accurate records of all candidates and their status in the hiring process.'),
            //     ],
            //   ),
            // )
          ],
        ),
      ],
    );
  }
}
Padding buildBulletPoint({
  required String text,
  required String number,
  required BuildContext context,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: Sizes.responsiveXxs(context)),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$number ',
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w400,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    ),
  );
}

