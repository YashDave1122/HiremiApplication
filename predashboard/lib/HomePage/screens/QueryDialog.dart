import 'package:flutter/material.dart';
import 'package:pre_dashboard/HomePage/screens/HomeScreen.dart';
import 'package:pre_dashboard/SharedPreferences/SharedPreferences.dart';

class QueryDialog extends StatefulWidget {
  const QueryDialog({Key? key}) : super(key: key);

  @override
  State<QueryDialog> createState() => _QueryDialogState();
}

class _QueryDialogState extends State<QueryDialog> {
  String Email="";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadUserDetails();
  }
  final SharedPreferencesService _sharedPreferencesService = SharedPreferencesService();

  Future<void> _loadUserDetails() async {
    final userDetails = await _sharedPreferencesService.getUserDetails();
    if (userDetails != null) {
      setState(() {
        Email=userDetails['email'];
      });
      print("Emale is  is ${Email}");
    }
  }
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.8;
    double height = MediaQuery.of(context).size.height * 0.5;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      contentPadding: EdgeInsets.zero,
      content: SizedBox(
        width: width,
        height: height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: height*0.03),

            Image.asset(
              'assets/images/success.png', // Replace with your image
              height: height * 0.3,
            ),
            SizedBox(height: height*0.06),
            Text(
              'Your Query Generated Successfully.',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0F3CC9),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: height*0.05),
            Text(
              'Your query is being analyzed. Our mentors will reach out to you within 48 hours.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: height*0.06),
            ElevatedButton(
              onPressed: () {
                // Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(
                      isVerified: true,
                      animation: false,
                      email: Email,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F3CC9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Text(
                  'Go Home',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
