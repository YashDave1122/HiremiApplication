
import 'package:flutter/material.dart';

class SubscriptionCard extends StatelessWidget {
  final double price;
  final double originalPrice;
  final double discount;

  const SubscriptionCard({
    super.key,
    required this.price,
    required this.originalPrice,
    required this.discount,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Center(
      child: Container(
        width: size.width * 0.9,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.purple, width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipPath(
              clipper: CustomClipPath(),
              child: Container(
                width: double.infinity,
                height: size.height * 0.18,
                color: Colors.purple,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Subscribe to this",
                      style: TextStyle(
                        fontSize: size.width * 0.05,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Unimentors program",
                      style: TextStyle(
                        fontSize: size.width * 0.05,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: size.width * 0.045,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        children: [
                          TextSpan(text: "₹${price.toStringAsFixed(0)}  "),
                          TextSpan(
                            text: "₹${originalPrice.toStringAsFixed(0)}",
                            style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              fontSize: size.width * 0.04,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 6),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        "${discount.toStringAsFixed(0)}% Off",
                        style: TextStyle(
                          fontSize: size.width * 0.035,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12),
            _buildFeatureItem("Completion Certificate"),
            SizedBox(height: 12),
            _buildFeatureItem("Resume Building"),
            SizedBox(height: 12),
            _buildFeatureItem("Personalised Mentor"),
            SizedBox(height: 12),
            _buildFeatureItem("Mock Interview"),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(size.width * 0.02),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: size.width * 0.035,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: "Note: ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text:
                      "This program offers mentorship and support throughout the candidate’s college journey, providing guidance every step of the way.",
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 24,),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 22),
          SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(size.width / 2, size.height + 40, size.width, size.height - 40);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// Usage Example:
void main() {
  runApp(MaterialApp(
    home: Scaffold(
      backgroundColor: Colors.white,
      body: SubscriptionCard(
        price: 10000,
        originalPrice: 25000,
        discount: 40,
      ),
    ),
  ));
}
