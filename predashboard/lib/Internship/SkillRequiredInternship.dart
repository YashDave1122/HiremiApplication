
import 'package:flutter/material.dart';

import 'package:pre_dashboard/AppSizes/AppSizes.dart';
import 'package:pre_dashboard/HomePage/constants/constantsColor.dart';

class SkillRequiredInternship extends StatelessWidget {
  final String skillsRequired;

  const SkillRequiredInternship({
    Key? key,
    required this.skillsRequired,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> skillsList = skillsRequired.split(',');

    // Define the colors to be used in the loop
    List<Color> colors = [
      const Color(0xFFFFF6E5),
      const Color(0xFFFFEEE5),
      const Color(0xFFFFE5EE),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Skill Required',
            style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF163EC8))),
        SizedBox(
          height: Sizes.responsiveMd(context),
        ),
        Wrap(
          spacing: 8.0, // Add spacing between the containers
          children: skillsList.map((skill) {
            int index = skillsList.indexOf(skill);
            Color skillColor = colors[index % colors.length];
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
              decoration: BoxDecoration(
                color: skillColor, // Background color from the list
                borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.01),
              ),
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
              child: Text(
                skill,
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                  color: Colors.black, // Text color
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
