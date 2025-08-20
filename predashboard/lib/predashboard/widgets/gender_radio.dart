
import 'package:flutter/material.dart';
import '../constants/constants.dart';

class GenderRadio extends StatelessWidget {
  final String gender;
  final String? selectedGender;
  final ValueChanged<String?> onChanged;
  final bool isSelected;
  final TextStyle? genderTextStyle;

  const GenderRadio({
    Key? key,
    required this.gender,
    this.selectedGender,
    required this.onChanged,
    required this.isSelected,
    this.genderTextStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(gender),
        child: Container(
          height: screenWidth * 0.1,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(screenWidth * 0.025),
            border: Border.all(
              color: isSelected ? AppColors.textField : AppColors.black,
              width: 1.5,
            ),
            color: Colors.white,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              // Custom radio indicator
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? const Color(0xff0F3CC9) : Colors.grey,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? Center(
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xff0F3CC9),
                    ),
                  ),
                )
                    : null,
              ),
              const SizedBox(width: 8),
              // Gender label
              Flexible(
                child: Text(
                  gender,
                  style: genderTextStyle ??
                      TextStyle(
                        fontSize: screenWidth * 0.03,
                        fontWeight: FontWeight.w500,
                        color: isSelected ? const Color(0xff0F3CC9) : Colors.black,
                      ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
