//
// import 'package:flutter/material.dart';
// import 'package:pre_dashboard/AppSizes/AppSizes.dart';
// import 'package:pre_dashboard/HomePage/constants/constantsColor.dart';
//
// class CustomTextFieldAndEducation extends StatelessWidget {
//   const CustomTextFieldAndEducation({
//     Key? key,
//     required this.controller,
//     required this.hintText,
//     this.textInputType = TextInputType.text,
//     this.maxLines,
//     this.suffix,
//     this.prefix,
//     this.validator,
//     this.readOnly = false, // Added read-only property
//     this.onTap, // Added onTap callback
//   }) : super(key: key);
//
//   final TextEditingController controller;
//   final String hintText;
//   final TextInputType textInputType;
//   final int? maxLines;
//   final Widget? suffix;
//   final Widget? prefix;
//   final String? Function(String?)? validator;
//   final bool readOnly; // New property
//   final VoidCallback? onTap; // New property
//
//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: controller,
//       cursorColor: AppColors.black,
//       textAlign: TextAlign.start,
//       maxLines: maxLines,
//       style: const TextStyle(
//         fontSize: 12,
//         fontWeight: FontWeight.w500,
//       ),
//       keyboardType: textInputType,
//       validator: validator,
//       autovalidateMode: AutovalidateMode.onUserInteraction,
//       readOnly: readOnly, // Make read-only if needed
//       onTap: onTap, // Call onTap function if provided
//       decoration: InputDecoration(
//         hintText: hintText,
//         suffixIcon: suffix,
//         prefixIcon: prefix,
//         suffixIconColor: AppColors.secondaryText,
//         contentPadding: EdgeInsets.symmetric(
//           vertical: Sizes.responsiveSm(context),
//           horizontal: Sizes.responsiveMd(context),
//         ),
//         alignLabelWithHint: true,
//         hintStyle: TextStyle(
//           fontSize: 12,
//           fontWeight: FontWeight.w400,
//           color: AppColors.secondaryText,
//         ),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(3),
//           borderSide: BorderSide(
//             color: AppColors.secondaryText,
//             width: 0.37,
//           ),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(3),
//           borderSide: BorderSide(
//             color: AppColors.secondaryText,
//             width: 0.37,
//           ),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(3),
//           borderSide: BorderSide(
//             color: AppColors.secondaryText,
//             width: 0.37,
//           ),
//         ),
//         errorStyle: TextStyle(
//           fontSize: 12,
//           color: Colors.red,
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:pre_dashboard/AppSizes/AppSizes.dart';
import 'package:pre_dashboard/HomePage/constants/constantsColor.dart';

class CustomTextFieldAndEducation extends StatelessWidget {
  const CustomTextFieldAndEducation({
    Key? key,
    required this.controller,
    required this.hintText,
    this.textInputType = TextInputType.text,
    this.maxLines,
    this.suffix,
    this.prefix,
    this.validator,
    this.readOnly = false,
    this.onTap,
    this.isDropdown = false, // New property to enable dropdown
  }) : super(key: key);

  final TextEditingController controller;
  final String hintText;
  final TextInputType textInputType;
  final int? maxLines;
  final Widget? suffix;
  final Widget? prefix;
  final String? Function(String?)? validator;
  final bool readOnly;
  final VoidCallback? onTap;
  final bool isDropdown; // New property

  @override
  Widget build(BuildContext context) {
    if (isDropdown) {
      // Dropdown mode
      return DropdownButtonFormField<String>(
        value: controller.text.isNotEmpty ? controller.text : null,
        onChanged: (value) {
          controller.text = value ?? '';
        },
        validator: validator,
        items: List.generate(
          31, // Generates years from 2000 to 2030
              (index) {
            String year = (2000 + index).toString();
            return DropdownMenuItem(
              value: year,
              child: Text(year),
            );
          },
        ),
        decoration: InputDecoration(
          hintText: hintText,
          suffixIcon: suffix,
          prefixIcon: prefix,
          contentPadding: EdgeInsets.symmetric(
            vertical: Sizes.responsiveSm(context),
            horizontal: Sizes.responsiveMd(context),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(3),
            borderSide: BorderSide(
              color: AppColors.secondaryText,
              width: 0.37,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(3),
            borderSide: BorderSide(
              color: AppColors.secondaryText,
              width: 0.37,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(3),
            borderSide: BorderSide(
              color: AppColors.secondaryText,
              width: 0.37,
            ),
          ),
          errorStyle: TextStyle(
            fontSize: 12,
            color: Colors.red,
          ),
        ),
      );
    } else {
      // TextField mode
      return TextFormField(
        controller: controller,
        cursorColor: AppColors.black,
        textAlign: TextAlign.start,
        maxLines: maxLines,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        keyboardType: textInputType,
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        readOnly: readOnly,
        onTap: onTap,
        decoration: InputDecoration(
          hintText: hintText,
          suffixIcon: suffix,
          prefixIcon: prefix,
          suffixIconColor: AppColors.secondaryText,
          contentPadding: EdgeInsets.symmetric(
            vertical: Sizes.responsiveSm(context),
            horizontal: Sizes.responsiveMd(context),
          ),
          alignLabelWithHint: true,
          hintStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppColors.secondaryText,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(3),
            borderSide: BorderSide(
              color: AppColors.secondaryText,
              width: 0.37,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(3),
            borderSide: BorderSide(
              color: AppColors.secondaryText,
              width: 0.37,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(3),
            borderSide: BorderSide(
              color: AppColors.secondaryText,
              width: 0.37,
            ),
          ),
          errorStyle: TextStyle(
            fontSize: 12,
            color: Colors.red,
          ),
        ),
      );
    }
  }
}
