
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:pre_dashboard/AppSizes/AppSizes.dart';
import 'package:pre_dashboard/HomePage/constants/constantsColor.dart';
import 'package:pre_dashboard/ProfileScreen/ResumeSection/CustomTextFeild.dart';
import 'package:pre_dashboard/ProfileScreen/ResumeSection/apiService.dart';
import 'package:shared_preferences/shared_preferences.dart';


class EditResumePage extends StatefulWidget {
  @override
  _EditResumePageState createState() => _EditResumePageState();
}

class _EditResumePageState extends State<EditResumePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadResumeLink();
  }





  Future<void> _loadResumeLink() async {
    setState(() {
      _isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final profileID = prefs.getInt('profileId')?.toString();

    if (profileID == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile ID not found.')),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final apiService = ResumeApiService();
      final resumeLink = await apiService.getResumeLink(profileID);

      if (resumeLink != null && resumeLink.isNotEmpty) {
        // Check if the resumeLink is a valid JSON
        if (resumeLink.startsWith('{') && resumeLink.endsWith('}')) {
          final parsedJson = jsonDecode(resumeLink);
          final url = parsedJson['url'] as String?;
          _controller.text = url ?? '';
        } else {
          // If it's not JSON, assume it's a plain URL
          _controller.text = resumeLink;
        }
      } else {
        _controller.text = '';
      }
    } catch (e) {
      print('Failed to load resume link: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load resume link: $e')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }



  Future<void> _saveResumeLink() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final profileID = prefs.getInt('profileId')?.toString();

    if (profileID == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile ID not found.')),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final apiService = ResumeApiService();
    final details = {
      'url': _controller.text.trim(),
      'profile': profileID,
    };

    final success = await apiService.addOrUpdateResumeLink(details);

    if (success) {
      await prefs.setString('resumeLink', _controller.text.trim());

      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Resume link saved successfully!')),
      // );
      // Navigator.of(context).push(
      //   MaterialPageRoute(
      //     builder: (ctx) => NewNavbar(
      //       initTabIndex: 3,
      //       isV: true,
      //     ),
      //   ),
      // );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save resume link.')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Resume"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextFieldForResume(
                controller: _controller,
                hintText: 'Paste Resume Link',
                prefix: const Icon(
                  Icons.link,
                  color: AppColors.black,
                  size: 15,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please provide a resume link';
                  }
                  final urlPattern = r'^(https?:\/\/)';
                  final regExp = RegExp(urlPattern, caseSensitive: false);
                  if (!regExp.hasMatch(value)) {
                    return 'Please provide a valid URL';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Sizes.radiusSm),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: Sizes.responsiveHorizontalSpace(context),
                    horizontal: Sizes.responsiveMdSm(context),
                  ),
                ),
                onPressed: _isLoading ? null : () async {
                  await _saveResumeLink();
                },
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
