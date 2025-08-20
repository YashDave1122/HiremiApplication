
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pre_dashboard/Non_verified_changes/Provider/CareerStagedProvider.dart';
import 'package:pre_dashboard/SharedPreferences/SharedPreferences.dart';
import 'package:http/http.dart' as http; // For making HTTP requests
import 'package:pre_dashboard/shared_preferences_helper.dart';
import 'package:provider/provider.dart';
import '../career_card.dart';

class CustomFormWidget2 extends StatefulWidget {
  final Function(bool, int) onContinue;

  const CustomFormWidget2({super.key, required this.onContinue});

  @override
  State<CustomFormWidget2> createState() => _CareerStageSelectorState();
}

class _CareerStageSelectorState extends State<CustomFormWidget2> {

  int _selectedIndex = -1;
 // final CareerStageService _careerStageService = CareerStageService();
  final SharedPreferencesHelper _sharedPreferencesService = SharedPreferencesHelper();


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeCareerStage();
    });
  }
  Future<void> _initializeCareerStage() async {
    // final userId = await SharedPreferencesHelper.getProfileId();
    final userId = await SharedPreferencesHelper.getProfileId();
    print('Retrieved User ID: $userId');
    if (userId != null) {
      await Provider.of<CareerStageProvider>(context, listen: false).fetchCareerStage(userId);

      final provider = Provider.of<CareerStageProvider>(context, listen: false);
      switch (provider.careerStage) {
        case "College Student":
          _selectedIndex = 0;
          break;
        case "Fresher":
          _selectedIndex = 1;
          break;
        case "Experienced":
          _selectedIndex = 2;
          break;
        default:
          _selectedIndex = -1;
      }
      setState(() {});
    } else {
      debugPrint("User ID not found in SharedPreferencesnjcjids");
    }
  }




  String _getCareerStageName(int index) {
    switch (index) {
      case 0:
        return "College Student";
      case 1:
        return "Fresher";
      case 2:
        return "Experienced";
      default:
        return "";
    }
  }
  String _getCareerStageTitle(int index) {
    switch (index) {
      case 0:
        return "College Student";
      case 1:
        return "Fresher";
      case 2:
        return "Experienced";
      default:
        return "";
    }
  }



  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final provider = Provider.of<CareerStageProvider>(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: height * 0.01),
          Text(
            'Choose your career stage',
            style: TextStyle(
              fontSize: width * 0.05,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF0F3CC9),
            ),
          ),
          SizedBox(height: height * 0.02),
          // if (provider.careerStage != null)
          //   Text(
          //     'Previously selected: ${provider.careerStage}',
          //     style: TextStyle(
          //       fontSize: width * 0.045,
          //       fontWeight: FontWeight.w500,
          //       color: Colors.black54,
          //     ),
          //   ),
          CareerCard(
            title: 'College Student',
            subtitle: '"I am a student preparing for my career."',
            isSelected: _selectedIndex == 0,
            onTap: () {
              setState(() {
                _selectedIndex = (_selectedIndex == 0) ? -1 : 0;
              });
            },
          ),
          SizedBox(height: height * 0.02),
          CareerCard(
            title: 'Fresher',
            subtitle: '"I am a recent graduate exploring opportunities."',
            isSelected: _selectedIndex == 1,
            onTap: () {
              setState(() {
                _selectedIndex = (_selectedIndex == 1) ? -1 : 1;
              });
            },
          ),
          SizedBox(height: height * 0.02),
          CareerCard(
            title: 'Experienced',
            subtitle: '"I have work experience and want to grow further."',
            isSelected: _selectedIndex == 2,
            onTap: () {
              setState(() {
                _selectedIndex = (_selectedIndex == 2) ? -1 : 2;
              });
            },
          ),
          SizedBox(height: height * 0.04),
          Center(
            child: ElevatedButton(
              onPressed: _handleContinue,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F3CC9),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: Size(width * 0.8, height * 0.06),
              ),
              child: const Text('Continue', style: TextStyle(fontSize: 16)),
            ),
          ),
          SizedBox(height: height * 0.01),
        ],
      ),
    );
  }



  void _handleContinue() async {
    if (_selectedIndex == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a career stage!'),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      try {
        // final userId = await _sharedPreferencesService.getUserId();
        final userId = await SharedPreferencesHelper.getProfileId();

        if (userId != null) {
          print("UserID is $userId");
          final selectedTitle = _getCareerStageTitle(_selectedIndex);
          // Provider.of<CareerStageProvider>(context, listen: false).saveCareerStage( selectedTitle,userId);
          Provider.of<CareerStageProvider>(context, listen: false)
              .saveCareerStage(selectedTitle, userId);
          widget.onContinue(true, 2);
        }
        else {
          // widget.onContinue(true, 2);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('User ID not found!'),
              backgroundColor: Colors.red,
            ),
          );


        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

}
