

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:pre_dashboard/ExperiencedJons/Experienced_jobs.dart';
import 'package:pre_dashboard/FresherJobs/FresherJobs.dart';
import 'package:pre_dashboard/Hiremi360/controller_screen/controller_screen.dart';
import 'package:pre_dashboard/HomePage/Widget/StaticFeatureCard.dart';
import 'package:pre_dashboard/HomePage/Widget/popupmsg.dart';
import 'package:pre_dashboard/HomePage/screens/askExpertScreen.dart';
import 'package:pre_dashboard/Internship/Internship.dart';
import '../constants/constantText.dart';
import '../constants/constantsColor.dart';
import '../constants/constantsImage.dart';

class FeaturedSection extends StatelessWidget {
  final bool isVerified;
  final bool animation;

  const FeaturedSection({Key? key, required this.isVerified, required this.animation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final titleSize = size.width * 0.045;
    final padding = size.width * 0.04;

    final featuredKeys = FeaturedText.featuredItems.keys.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: padding, bottom: padding * 0.5),
          child: Text(
            FeaturedText.featuredSectionTitle,
            style: TextStyle(
              fontSize: titleSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // Show the grid view only if animation is true
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: padding,
            vertical: padding * 0.5,
          ),
          itemCount: featuredKeys.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2.0,
            mainAxisSpacing: padding * 0.75,
            crossAxisSpacing: padding * 0.75,
          ),
          // itemBuilder: (context, index) {
          //   final key = featuredKeys[index];
          //   return FeatureCard(
          //     title: FeaturedText.getTitle(key),
          //     subtitle: FeaturedText.getSubtitle(key),
          //     imagePath: _getImagePath(key),
          //     gradientColors: AppColors.gradients[key]! ?? [],
          //     bordercolor: AppColors.primaryColors[key] ?? Colors.black,
          //     onTap: () {
          //       if (isVerified) {
          //         // Handle navigation based on `key`
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(builder: (context) => AskExpertPage()),
          //         );
          //       } else {
          //         showCustomPopup(context);
          //       }
          //     },
          //     index: index,
          //     animation: animation, // Pass animation flag
          //   );
          // },
          itemBuilder: (context, index) {
            final key = featuredKeys[index];
            if (animation) {
              return FeatureCard(
                title: FeaturedText.getTitle(key),
                subtitle: FeaturedText.getSubtitle(key),
                imagePath: _getImagePath(key),
                gradientColors: AppColors.gradients[key]! ?? [],
                bordercolor: AppColors.primaryColors[key] ?? Colors.black,
                onTap: () {
                  print("Verified is $isVerified");
                  if (isVerified) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AskExpertPage()),
                    );
                  }
                  else {
                    print("Verified is $isVerified");
                    showCustomPopup(context);
                  }
                },
                index: index,
                animation: animation,
              );
            } else {
              return StaticFeatureCard(
                title: FeaturedText.getTitle(key),
                subtitle: FeaturedText.getSubtitle(key),
                imagePath: _getImagePath(key),
                gradientColors: AppColors.gradients[key]! ?? [],
                borderColor: AppColors.primaryColors[key] ?? Colors.black,
                onTap: () {
                  if (isVerified) {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => AskExpertPage()),
                    // );
                    if(key=='askExpert'){

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AskExpertPage()), // Navigate to InternshipScreen
                      );
                    }
                      if(key=='internship'){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => InternshipsScreen()), // Navigate to InternshipScreen
                        );
                      }
                      if(key=='freshers'){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FresherJobs(isVerified: isVerified)), // Navigate to InternshipScreen
                        );
                      }
                      if(key=='experience'){
                        print("key is $key");
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ExperiencedJobs(isVerified: isVerified)), // Navigate to InternshipScreen
                        );
                      }
                      if(key=='hiremi360'){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ControllerScreen()),
                        );
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => ExperiencedJobs(isVerified: isVerified)), // Navigate to InternshipScreen
                        // );
                      }
                  } else {
                    showCustomPopup(context);
                  }
                },
              );
            }
          },

        ),
      ],
    );
  }

  String _getImagePath(String key) {
    switch (key) {
      case 'askExpert':
        return AppImages.askExpert;
      case 'internship':
        return AppImages.internship;
      case 'status':
        return AppImages.status;
      case 'freshers':
        return AppImages.freshers;
      case 'hiremi360':
        return AppImages.hiremi360;
      case 'experience':
        return AppImages.experience;
      default:
        return '';
    }
  }
}


class FeatureCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final List<Color> gradientColors;
  final VoidCallback onTap;
  final Color bordercolor;
  final int index;
  final bool animation;

  const FeatureCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.gradientColors,
    required this.onTap,
    required this.bordercolor,
    required this.index,
    required this.animation,
  });

  @override
  _FeatureCardState createState() => _FeatureCardState();
}

class _FeatureCardState extends State<FeatureCard> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _springAnimation;

  @override
  void initState() {
    super.initState();

    if (widget.animation) {
      _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 800),
      );

      final slideTween = Tween<Offset>(
        begin: widget.index.isEven ? Offset(-1.0, 0) : Offset(1.0, 0),
        end: Offset.zero,
      );
      _slideAnimation = slideTween.animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      );

      _springAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(0.5, 1.0, curve: Curves.elasticOut),
        ),
      );

      Future.delayed(Duration(milliseconds: widget.index * 300), () {
        _controller.forward();
      });
    }


  }

  @override
  void dispose() {
    if (widget.animation) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final titleSize = size.width * 0.032;
    final subtitleSize = size.width * 0.025;
    final imageHeight = size.width * 0.18;
    final padding = size.width * 0.04;

    return InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(size.width * 0.03),
      child: widget.animation
          ? AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return SlideTransition(
            position: _slideAnimation,
            child: Transform.scale(
              scale: _springAnimation.value,
              child: child,
            ),
          );
        },
        child: _buildCardContent(size, titleSize, subtitleSize, imageHeight, padding),
      )
          : _buildCardContent(size, titleSize, subtitleSize, imageHeight, padding), // Show without animation if false
    );
  }

  Widget _buildCardContent(Size size, double titleSize, double subtitleSize, double imageHeight, double padding) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: padding * 0.75),
      decoration: BoxDecoration(
        border: Border.all(color: widget.bordercolor),
        gradient: LinearGradient(
          colors: widget.gradientColors,
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
                  widget.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: titleSize,
                    color: const Color(0xFF333333),
                  ),
                ),
                SizedBox(height: size.width * 0.01),
                Text(
                  widget.subtitle,
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
              widget.imagePath,
              scale: imageHeight,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
////////////////////////////////////////////////////////////////////////////////////

