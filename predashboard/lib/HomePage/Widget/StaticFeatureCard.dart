import 'package:flutter/material.dart';

class StaticFeatureCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final List<Color> gradientColors;
  final VoidCallback onTap;
  final Color borderColor;

  const StaticFeatureCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.gradientColors,
    required this.onTap,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final titleSize = size.width * 0.032;
    final subtitleSize = size.width * 0.025;
    final imageHeight = size.width * 0.18;
    final padding = size.width * 0.04;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(size.width * 0.03),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: padding, vertical: padding * 0.75),
        decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          gradient: LinearGradient(
            colors: gradientColors,
            stops: const [0.4, 0.8, 0.9],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(size.width * 0.03),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: titleSize,
                      color: const Color(0xFF333333),
                    ),
                  ),
                  SizedBox(height: size.width * 0.01),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: subtitleSize,
                      color: Colors.grey[700],
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Image.asset(
                imagePath,
                scale: imageHeight,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
