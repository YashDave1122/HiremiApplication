import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:pre_dashboard/AppSizes/AppSizes.dart';
import 'package:pre_dashboard/HomePage/constants/constantsColor.dart';
import 'package:pre_dashboard/Internship/RoundecContainer.dart';

class SuccessfullyAppliedAlert extends StatelessWidget {
  const SuccessfullyAppliedAlert({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double size=MediaQuery.of(context).size.height;

    final date = DateTime.now();
    return RoundedContainer(
      radius: Sizes.radiusSm,
      padding: EdgeInsets.all(Sizes.responsiveXl(context)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // RoundedContainer(
          //     radius: 50,
          //     color: AppColors.green,
          //     padding: EdgeInsets.all(Sizes.responsiveMd(context)),
          //     child: const Icon(
          //       Icons.done_all,
          //       color: Colors.white,
          //       size: 27,
          //     )),

          SizedBox(
            height: Sizes.responsiveMd(context),
          ),
          RichText(
              text: TextSpan(children: [
                const TextSpan(
                    text: 'Thank you for applying at ',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: AppColors.black,
                        fontSize: 18)),
                TextSpan(
                    text: 'Hiremi!',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF163EC8),
                        fontSize: 18))
              ])),
          SizedBox(
            height: Sizes.responsiveXl(context),
          ),
          Container(
            height: size*0.06,
            width:size*1.2,
            color: Color.fromRGBO(15, 60, 201, 0.1),
            child: Center(
              child: Text(
                'You\'ve successfully applied in this opportunity.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Color(0xFF163EC8)),
              ),
            ),
          ),
          SizedBox(
            height: Sizes.responsiveMd(context),
          ),
          // Text(
          //   'We\'ll update you after few working hours.',
          //   textAlign: TextAlign.center,
          //   style: TextStyle(
          //       fontWeight: FontWeight.w400,
          //       fontSize: 8,
          //       color: AppColors.secondaryText),
          // ),
          RichText(
              textAlign: TextAlign.center,
              text: TextSpan(children: [
                 TextSpan(
                    text: 'If ',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color:Colors.grey[600],
                        fontSize: 14)),
                TextSpan(
                    text: 'selected,',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color:Color.fromRGBO(48, 161, 111, 1),
                        fontSize: 14)),
                TextSpan(
                    text: 'you will be contacted via',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color:Colors.grey[600],
                        fontSize: 14)),
                TextSpan(
                    text: ' email',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color:Color.fromRGBO(48, 161, 111, 1),
                        fontSize: 14)),
                TextSpan(
                    text: ' with furthur details',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color:Colors.grey[600],
                        fontSize: 14)),
              ])),


          SizedBox(
            height: Sizes.responsiveLg(context),
          ),
          SizedBox(
            height: Sizes.responsiveXl(context) * 1.22,
            width:Sizes.responsiveXl(context) * 4.02 ,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF163EC8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Sizes.radiusXs)),
                  padding: EdgeInsets.symmetric(
                      vertical: Sizes.responsiveVerticalSpace(context),
                      horizontal: Sizes.responsiveMdSm(context)),
                ),

                onPressed: (){
                  // Navigator.of(context).push(
                  //   // MaterialPageRoute(builder: (ctx) => const AppliesScreen(isVerified: true,)
                  //   //
                  //   MaterialPageRoute(
                  //     builder: (ctx) => NewNavbar(
                  //       initTabIndex: 1, // Set this to 1 to show AppliesScreen
                  //       isV: true,       // Pass the verification status
                  //     ),
                  //
                  //   ),
                  // );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Browse More jobs',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: AppColors.white,
                      ),
                    ),
                    SizedBox(
                      width: Sizes.responsiveXs(context),
                    ),

                  ],
                )),
          ),
          SizedBox(
            height: Sizes.responsiveMd(context),
          ),
          Text(
            'Applied Date:${DateFormat('dd/MM/yyyy').format(date)}',
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color: AppColors.black),
          ),
        ],
      ),
    );
  }
}
