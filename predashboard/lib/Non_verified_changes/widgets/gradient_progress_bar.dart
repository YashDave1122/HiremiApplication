
import 'package:flutter/material.dart';

class GradientProgressBar extends StatelessWidget {
  final double progress; // Updated to stateless widget

  const GradientProgressBar({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.7;

    return Container(
      width: width,
      height: 22,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(seconds: 1),
            width: width * progress, // Directly apply progress
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF214EE7),
                  Color(0xFF1A3DB4),
                  Color(0xFF16349A),
                  Color(0xFF16349A),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }
}
