
import 'package:flutter/material.dart';

class RoundedIconforInternship extends StatelessWidget {
  const RoundedIconforInternship({
    Key? key,
    required this.icon,
    required this.border,
    required this.iconSize,
  }) : super(key: key);

  final IconData icon;
  final Border border;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: border,
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: Container(
          height: iconSize,
          width: iconSize,
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: iconSize - 10, // Adjust size to fit within the border
          ),
        ),
      ),
    );
  }
}
