
import 'package:flutter/material.dart';

class RoundedContainer extends StatelessWidget {
  const RoundedContainer({
    //  super.key,
    required this.child,
    required this.radius,
    required this.padding,
    this.border,
    this.color,
    this.gradientBorder, // New parameter for gradient border
    this.borderWidth = 1.0, // Border width (default to 1.0)
  });

  final double radius;
  final EdgeInsets padding;
  final Border? border;
  final Widget child;
  final Color? color;
  final Gradient? gradientBorder; // New optional gradient for border
  final double borderWidth; // Border width for the gradient border

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
        border: border, // Regular border if no gradient is provided
      ),
      child: gradientBorder != null
          ? Padding(
        padding: EdgeInsets.all(borderWidth), // Border width padding
        child: ShaderMask(
          shaderCallback: (bounds) => gradientBorder!.createShader(
            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(color: Colors.white, width: borderWidth),
            ),
            child: Container(
              padding: padding,
              decoration: BoxDecoration(
                color: color, // Inner container color
                borderRadius: BorderRadius.circular(radius),
              ),
              child: child,
            ),
          ),
        ),
      )
          : Container(
        padding: padding,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(radius),
          border: border,
        ),
        child: child,
      ),
    );
  }
}
