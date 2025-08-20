
import 'package:flutter/material.dart';
import 'package:pre_dashboard/AppSizes/AppSizes.dart';
import 'package:pre_dashboard/HomePage/constants/constantsColor.dart';

class OutlinedContainer extends StatelessWidget {
  const OutlinedContainer({
    Key? key,
    required this.child,
    required this.title,
    this.showEdit = true,
    this.showAdd = true, // Add this for Add icon visibility
    this.isTrue = true,
    this.onTap,
    this.onEditTap,
    this.onAddTap,
  }) : super(key: key);

  final Widget child;
  final String title;
  final bool showEdit;
  final bool showAdd; // New variable for Add visibility
  final bool isTrue;
  final VoidCallback? onTap;
  final VoidCallback? onEditTap;
  final VoidCallback? onAddTap;


  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: AppColors.secondaryText,
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(Sizes.responsiveDefaultSpace(context)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Sizes.radiusSm),
          border: Border.all(width: 0.5, color: AppColors.secondaryText),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                ),
                Row(
                  children: [
                    if (showEdit)
                      GestureDetector(
                        onTap: onEditTap,
                        child: Image.asset(
                          'assets/images/img_3.png',
                          height: MediaQuery.of(context).size.height * 0.0465,
                          width: MediaQuery.of(context).size.height * 0.029,
                        ),
                      ),
                    if (showEdit && showAdd)
                      SizedBox(width: 8), // Optional spacing
                    if (showEdit && showAdd)
                      GestureDetector(
                        onTap:  onAddTap,
                        child: Image.asset(
                          'assets/images/Add.png',
                          height: MediaQuery.of(context).size.height * 0.0465,
                          width: MediaQuery.of(context).size.height * 0.029,
                        ),
                      ),
                  ],
                ),
              ],
            ),
            if (isTrue) SizedBox(height: Sizes.responsiveMd(context)),
            child
          ],
        ),
      ),
    );
  }
}
