
import 'package:flutter/material.dart';
import 'package:pre_dashboard/Non_verified_changes/Provider/UserProvider.dart';
import 'package:pre_dashboard/SharedPreferences/SharedPreferences.dart';
import 'package:provider/provider.dart';

import '../custom_text_field.dart';

class CustomFormWidget3 extends StatefulWidget {
  final Function(bool, int) onContinue;

  const CustomFormWidget3({super.key, required this.onContinue});

  @override
  State<CustomFormWidget3> createState() => _ReviewDetailsFormState();
}

class _ReviewDetailsFormState extends State<CustomFormWidget3> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _fatherNameController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _birthPlaceController = TextEditingController();
  bool _isValid = true;
  final SharedPreferencesService _sharedPreferencesService = SharedPreferencesService();
  String _selectedGender = '';


  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  Future<void> _loadUserDetails() async {
    final userDetails = await _sharedPreferencesService.getUserDetails();
    if (userDetails != null) {
      setState(() {
        _fullNameController.text = userDetails['full_name'] ?? '';
        _fatherNameController.text = userDetails['father_name'] ?? '';
        _selectedGender = userDetails['gender'] ?? '';
        _genderController.text = _selectedGender;
        _birthDateController.text = userDetails['date_of_birth'] ?? '';
        _birthPlaceController.text = userDetails['birth_place'] ?? '';
      });
    }
  }

  Future<void> _updateUserDetails() async {
    final userId = await _sharedPreferencesService.getUserId();
    if (userId != null) {
      final updatedDetails = {
        'full_name': _fullNameController.text,
        'father_name': _fatherNameController.text,
        'gender': _selectedGender,
        'date_of_birth': _birthDateController.text,
      };

      await Provider.of<UserProvider>(context, listen: false)
          .updateUserDetails(userId, updatedDetails);
      widget.onContinue(true, 3);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: height * 0.01),
        Padding(
          padding: EdgeInsets.only(left: width * 0.05),
          child: Text(
            'Review and Verify your details',
            style: TextStyle(
              fontSize: width * 0.05,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF0F3CC9),
            ),
          ),
        ),
        SizedBox(height: height * 0.02),
        CustomTextField(
          title: 'Full Name',
          hText: 'Jae Doe',
          controller: _fullNameController,
        ),
        SizedBox(height: height * 0.02),
        CustomTextField(
          title: "Father's Full Name",
          hText: 'John Copper',
          controller: _fatherNameController,
        ),
        SizedBox(height: height * 0.02),
        CustomTextField(
          title: "Gender",
          hText: 'Select Gender',
          controller: _genderController,
          isDropdown: true,
          dropdownItems: const ['Male', 'Female', 'Other'],
          value: _selectedGender,
          onChanged: (value) {
            setState(() {
              _selectedGender = value!;
              _genderController.text = value;
            });
          },
        ),
        SizedBox(height: height * 0.02),
        CustomTextField(
          title: "Birth Date",
          hText: '1/1/1999',
          controller: _birthDateController,
          readOnly: true,
          onTap: () async {
            DateTime? selectedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (selectedDate != null) {
              setState(() {
                _birthDateController.text =
                '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
              });
            }
          },
        ),
        SizedBox(height: height * 0.05),
        Center(
          child: ElevatedButton(
            onPressed: _validateAndSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F3CC9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(height * 0.012),
              ),
              minimumSize: Size(width * 0.8, height * 0.06),
            ),
            child: const Text(
              'Review and next',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _validateAndSubmit() async {
    if (_fullNameController.text.isEmpty ||
        _fatherNameController.text.isEmpty ||
        _selectedGender.isEmpty ||
        _birthDateController.text.isEmpty) {
      setState(() => _isValid = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All fields must be filled!'),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      await _updateUserDetails();
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _fatherNameController.dispose();
    _genderController.dispose();
    _birthDateController.dispose();
    _birthPlaceController.dispose();
    super.dispose();
  }
}