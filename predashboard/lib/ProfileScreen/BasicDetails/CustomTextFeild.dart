import 'package:flutter/material.dart';
import 'package:pre_dashboard/AppSizes/AppSizes.dart';
import 'package:pre_dashboard/HomePage/constants/constantsColor.dart';

class CustomTextFieldforBasicDetails extends StatelessWidget {
  const CustomTextFieldforBasicDetails({
    Key? key,
    required this.controller,
    required this.hintText,
    this.textInputType = TextInputType.text,
    this.maxLines,
    this.suffix,
    this.prefix,
    this.validator,
  }) : super(key: key);

  final TextEditingController controller;
  final String hintText;
  final TextInputType textInputType;
  final int? maxLines;
  final Widget? suffix;
  final Widget? prefix;
  final String? Function(String?)? validator;  // Validator parameter added

  @override
  Widget build(BuildContext context) {
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
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: suffix,
        prefixIcon: prefix,
        suffixIconColor: AppColors.secondaryText,
        contentPadding: EdgeInsets.symmetric(
            vertical: Sizes.responsiveSm(context),
            horizontal: Sizes.responsiveMd(context)),
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
