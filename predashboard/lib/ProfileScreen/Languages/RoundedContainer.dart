
import 'package:flutter/material.dart';


class RoundedContainerforLanguage extends StatelessWidget {
  const RoundedContainerforLanguage({Key? key,

    required this.child, required this.radius, required this.padding,this.border,  this.color ,
  }) : super(key: key);

  final double radius;
  final EdgeInsets padding;
  final Border? border;
  final Widget child;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(radius),
          border: border
      ),
      child: child,
    );
  }
}