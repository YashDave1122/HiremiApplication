// // import 'package:flutter/material.dart';
// //
// // class CustomHiremiFeatured extends StatelessWidget {
// //   final String image;
// //   final String logo;
// //   final String title;
// //   final GestureTapCallback onTap;
// //   const CustomHiremiFeatured(
// //       {super.key,
// //       required this.image,
// //       required this.logo,
// //       required this.title, required this.onTap});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final size = MediaQuery.of(context).size;
// //     return GestureDetector(
// //       onTap: onTap,
// //       child: Container(
// //         clipBehavior: Clip.hardEdge,
// //         decoration: BoxDecoration(
// //           borderRadius: BorderRadius.circular(size.height*0.01),
// //         ),
// //         child: Stack(
// //           children: [
// //             Image.asset(image),
// //             Positioned(
// //                 left: size.width * 0.025,
// //                 bottom: size.height * 0.04,
// //                 child: Container(
// //                   height: size.height * 0.035,
// //                   width: size.height * 0.035,
// //                   decoration: BoxDecoration(
// //                     color: Colors.white,
// //                     borderRadius: BorderRadius.circular(50),
// //                   ),
// //                   child: Image.asset(logo),
// //                 )),
// //             Positioned(
// //               left: size.width * 0.025,
// //               bottom: size.height * 0.022,
// //               child: Text(
// //                 title,
// //                 style:
// //                     TextStyle(fontSize: size.width * 0.024, color: Colors.white),
// //               ),
// //             ),
// //             Positioned(
// //               left: size.width * 0.025,
// //               bottom: size.height * 0.01,
// //               child: Text(
// //                 "Hiremi 360's Featured Program",
// //                 style:
// //                     TextStyle(fontSize: size.width * 0.0147, color: Colors.white),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
//
// class CustomHiremiFeatured extends StatelessWidget {
//   final String image;
//   final String logo;
//   final String title;
//   final GestureTapCallback onTap;
//   final double? imageHeight;
//   final double? imageWidth;
//   final double? logoHeight;
//   final double? logoWidth;
//
//   const CustomHiremiFeatured({
//     super.key,
//     required this.image,
//     required this.logo,
//     required this.title,
//     required this.onTap,
//     this.imageHeight,
//     this.imageWidth,
//     this.logoHeight,
//     this.logoWidth,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         clipBehavior: Clip.hardEdge,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(size.height * 0.01),
//         ),
//         child: Stack(
//           children: [
//             Image.asset(
//               image,
//               height: imageHeight ?? size.height * 0.2,
//               width: imageWidth ?? size.width * 0.3,
//               fit: BoxFit.cover,
//             ),
//             Positioned(
//               left: size.width * 0.025,
//               bottom: size.height * 0.04,
//               child: Container(
//                 height: logoHeight ?? size.height * 0.035,
//                 width: logoWidth ?? size.height * 0.035,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(50),
//                 ),
//                 child: Image.asset(logo),
//               ),
//             ),
//             Positioned(
//               left: size.width * 0.025,
//               bottom: size.height * 0.022,
//               child: Text(
//                 title,
//                 style: TextStyle(
//                   fontSize: size.width * 0.024,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//             Positioned(
//               left: size.width * 0.025,
//               bottom: size.height * 0.01,
//               child: Text(
//                 "Hiremi 360's Featured Program",
//                 style: TextStyle(
//                   fontSize: size.width * 0.0147,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class CustomHiremiFeatured extends StatelessWidget {
  final String image;
  final String logo;
  final String title;
  final GestureTapCallback onTap;
  final double? imageHeight;
  final double? imageWidth;
  final double? logoHeight;
  final double? logoWidth;
  final bool showLogo;  // Added flag to control logo visibility

  const CustomHiremiFeatured({
    super.key,
    required this.image,
    required this.logo,
    required this.title,
    required this.onTap,
    this.imageHeight,
    this.imageWidth,
    this.logoHeight,
    this.logoWidth,
    this.showLogo = false,  // Default value is false, meaning logo will not be shown by default
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size.height * 0.01),
        ),
        child: Stack(
          children: [
            Image.asset(
              image,
              height: imageHeight ?? size.height * 0.2,
              width: imageWidth ?? size.width * 0.3,
              fit: BoxFit.cover,
            ),
            // Only show logo if showLogo is true
            if (showLogo)
              Positioned(
                left: size.width * 0.025,
                bottom: size.height * 0.04,
                child: Container(
                  height: logoHeight ?? size.height * 0.035,
                  width: logoWidth ?? size.height * 0.035,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Image.asset(logo),
                ),
              ),
            Positioned(
              left: size.width * 0.025,
              bottom: size.height * 0.022,
              child: Text(
                title,
                style: TextStyle(
                  fontSize: size.width * 0.024,
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
              left: size.width * 0.025,
              bottom: size.height * 0.01,
              child: Text(
                "Hiremi 360's Featured Program",
                style: TextStyle(
                  fontSize: size.width * 0.0147,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
