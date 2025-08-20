import 'package:flutter/material.dart';
import 'package:pre_dashboard/AppSizes/AppSizes.dart';
import 'package:pre_dashboard/HomePage/constants/constantsColor.dart';
import 'package:pre_dashboard/ProfileScreen/ResumeSection/EditResumePage.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart'; // Add this import

class ResumeSection extends StatefulWidget {
  const ResumeSection({Key? key}) : super(key: key);

  @override
  _ResumeSectionState createState() => _ResumeSectionState();
}

class _ResumeSectionState extends State<ResumeSection> {
  final TextEditingController _controller = TextEditingController();
  bool _isUploaded = false;

  @override
  void initState() {
    super.initState();
    _loadResumeLink();
  }

  Future<void> _loadResumeLink() async {
    final prefs = await SharedPreferences.getInstance();
    final resumeLink = prefs.getString('resumeLink') ?? '';
    setState(() {
      _controller.text = resumeLink;
      _isUploaded = resumeLink.isNotEmpty;
    });
  }
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch URL')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(width: 0.5, color: Colors.grey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             // Image.asset('assets/resume.png', height: 80,),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Resume URL',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(Google Drive Link)',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: Color(0xFF163EC8),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Note: Try to upload pdf in your Google Drive if possible,',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Other formats are also accepted. ' +
                          (_isUploaded ? '' : '(Not Uploaded)'),
                      style: TextStyle(
                        fontSize: 10,
                        color: _isUploaded ? Colors.grey : Color(0xFF163EC8),
                      ),
                    ),
                  ],
                ),
              ),
              // GestureDetector(
              //   onTap: () async {
              //     // Navigate to edit screen and wait for result
              //     final result = await Navigator.push(
              //       context,
              //       MaterialPageRoute(builder: (context) => EditResumePage()),
              //     );
              //     if (result == true) {
              //       // If result is true, reload the resume link
              //       _loadResumeLink();
              //     }
              //   },
              //   child: Image.asset(
              //     'assets/images/img_3.png',
              //     height: MediaQuery.of(context).size.height*0.0225,width: MediaQuery.of(context).size.height*0.022,
              //   ),
              // ),
              GestureDetector(
                onTap: () async {
                  // Navigate to edit screen and wait for result
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditResumePage()),
                  );
                  if (result == true) {
                    // If result is true, reload the resume link
                    _loadResumeLink();
                  }
                },
                child: SizedBox(
                  width: 24.0, // Specify a width for the content
                  height: 24.0, // Specify a height for the content
                  child: Image.asset(
                    'assets/images/img_3.png',
                    height: MediaQuery.of(context).size.height * 0.0225,
                    width: MediaQuery.of(context).size.height * 0.0225,
                  ),
                ),
              ),

            ],
          ),
          const SizedBox(height: 12),

          // Add the View Resume button if resumeLink is available
          if (_isUploaded)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Sizes.radiusSm)),
                padding: EdgeInsets.symmetric(
                    vertical: Sizes.responsiveHorizontalSpace(context),
                    horizontal: Sizes.responsiveMdSm(context)),
              ),
              onPressed: () async {
                // await Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => EditResumePage()),
                // );
                _launchURL(_controller.text);
                //_loadResumeLink();
              },
              child: const Text(
                'View Resume >',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
