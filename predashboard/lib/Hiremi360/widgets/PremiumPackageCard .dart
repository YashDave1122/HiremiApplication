import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:pre_dashboard/API.dart';
import 'package:pre_dashboard/shared_preferences_helper.dart';

class PremiumPackageCard extends StatefulWidget {
  final String originalPrice;
  final String discountedPrice;
  final String discount;


  const PremiumPackageCard({
    Key? key,
    required this.originalPrice,
    required this.discountedPrice,
    required this.discount,
  }) : super(key: key);

  @override
  State<PremiumPackageCard> createState() => _PremiumPackageCardState();
}

class _PremiumPackageCardState extends State<PremiumPackageCard> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 350, // Adjust size as needed
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Blue Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade900, Colors.blue.shade500],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Premium Package",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        // "₹2,50,000/-",
                        "${widget.discountedPrice}/-",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      Text(
                        // "₹3,97,500/-",
                        "${widget.originalPrice}/-",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                ),

                // Discount Tag
                Positioned(
                  bottom: -12,
                  left: (350 / 2) - 40,
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      // "59% Off",
                      "${widget.discount}% Off",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 24),

            // Features List
            // Row
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildFeature("Guaranteed Job Placement"),
                    buildFeature("Live Industry Projects"),
                    buildFeature("Expert Mentorship & Certification"),
                  ],
                ),
                Image.asset(
                  "assets/images/pana1234.png", // Replace with your actual image
                  width: 100,
                ),
              ],
            ),


            SizedBox(height: 16),

            // Illustration (Replace with an Image.asset)

            // Bottom Note
            SizedBox(height: 16),
            Text.rich(
              TextSpan(
                text: "NOTE: ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text:
                    "Unlock your potential with our mentorship program and get instantly placed in a top tech company with zero hiring hassles!",
                    style: TextStyle(fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFeature(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 10),
          SizedBox(width: 8),
          Text(text, style: TextStyle(fontWeight: FontWeight.w500,
            fontSize: 11.512,
          )),
        ],
      ),
    );
  }
}
