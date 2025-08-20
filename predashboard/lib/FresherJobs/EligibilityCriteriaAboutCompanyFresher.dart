import 'package:flutter/material.dart';

import 'package:pre_dashboard/AppSizes/AppSizes.dart';
import 'package:pre_dashboard/HomePage/constants/constantsColor.dart';

class EligibilityCriteriaAboutCompanyFresher extends StatelessWidget {
  const EligibilityCriteriaAboutCompanyFresher({
    required this.companyName,
    required this.whoCanApply,
    required this.aboutCompany
  }) ;
  final String companyName;
  final String whoCanApply;
  final String aboutCompany;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Eligibility Criteria',
            style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF163EC8))),
        SizedBox(
          height: Sizes.responsiveMd(context),
        ),
        Padding(
          padding: EdgeInsets.only(left: Sizes.responsiveXxs(context)),
          child: Column(
            children: [
              buildBulletPoint(
                  context: context,
                  number: '1.',
                  text:
                  '$whoCanApply'),
              // buildBulletPoint(
              //     context: context,
              //     number: '2.',
              //     text: 'Branch: All branches are eligible.'),
              // buildBulletPoint(
              //     context: context,
              //     number: '3.',
              //     text:
              //     'Skills and Interests: Relevant skills and a keen interest in recruitment and talent acquisition.'),
            ],
          ),
        ),
        SizedBox(
          height: Sizes.responsiveLg(context),
        ),
        Text('About $companyName Company',
            style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color:  Color(0xFF163EC8))),
        SizedBox(
          height: Sizes.responsiveSm(context),
        ),
        Text(
            '$aboutCompany',
            style: TextStyle(
              fontSize: 10.0,
              fontWeight: FontWeight.w400,
            )),
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
        )
      ],
    ),
  );
}
