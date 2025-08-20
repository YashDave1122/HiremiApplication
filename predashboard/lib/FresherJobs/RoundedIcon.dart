
import 'package:flutter/material.dart';

class RoundedIcon extends StatelessWidget {
  const RoundedIcon({
    Key? key,
    required this.icon,
    required this.border,
  }) : super(key: key);

  final Icon icon;
  final Border border;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: border,
        shape: BoxShape.circle,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Container(
          height: 31.5,
          width: 31.5,
          alignment: Alignment.center,
          child: icon,
        ),
      ),
    );
  }
}
