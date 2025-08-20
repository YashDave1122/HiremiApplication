import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


import 'package:pre_dashboard/AppSizes/AppSizes.dart';
import 'package:pre_dashboard/HomePage/constants/constantsColor.dart';

class TextFieldWithTitle extends StatelessWidget {
  const TextFieldWithTitle({
    Key? key,
    required this.controller,
    required this.title,
    required this.hintText,
    this.starNeeded = true,
    this.prefix,
    this.suffix,
    this.spaceBtwTextField,
    this.maxLines,
    this.validator,
    this.keyboardType, // Add keyboardType property
    this.inputFormatters, // Add inputFormatters property
  }) : super(key: key);

  final TextEditingController controller;
  final String title, hintText;
  final bool starNeeded;
  final Widget? prefix, suffix;
  final double? spaceBtwTextField;
  final int? maxLines;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType; // Declare keyboardType
  final List<TextInputFormatter>? inputFormatters; // Declare inputFormatters

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
            if (starNeeded)
              Text(
                '*',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                ),
              ),
          ],
        ),
        SizedBox(
          height: spaceBtwTextField ?? Sizes.responsiveSm(context),
        ),
        // Use TextFormField for validation
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: prefix,
            suffixIcon: suffix,
            border: OutlineInputBorder(),
          ),
          maxLines: maxLines,
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          keyboardType: keyboardType, // Set the keyboardType
          inputFormatters: inputFormatters, // Apply inputFormatters
        ),
      ],
    );
  }
}
