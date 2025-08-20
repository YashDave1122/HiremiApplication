
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pre_dashboard/API.dart';
import 'package:pre_dashboard/Non_verified_changes/screens/final_step_screen.dart';
import 'package:pre_dashboard/Non_verified_changes/widgets/domain_chip.dart';
import 'package:pre_dashboard/SharedPreferences/SharedPreferences.dart';
import 'package:pre_dashboard/shared_preferences_helper.dart';

class CustomFormWidget6 extends StatefulWidget {
  final Function(bool, int) onSubmit;
  // final Function(int) updateVerificationStep;

  const CustomFormWidget6({super.key, required this.onSubmit,
    // required this.updateVerificationStep,
  });

  @override
  State<CustomFormWidget6> createState() => _DomainSelectionWidgetState();
}

class _DomainSelectionWidgetState extends State<CustomFormWidget6> {
  final SharedPreferencesHelper _sharedPreferencesHelper = SharedPreferencesHelper();
  final int _maxSelection = 5;
  final List<String> _domains = [
    "Product Development",
    "Systems Analyst",
    "Machine Learning/AI",
    "Business Analysis",
    "UI/UX designer",
    "Full stack development",
    "Front-End Development",
    "Back-End Development",
    "Blockchain",
    "Sales & Marketing",
    "Content Writing",
    "Financial Analysis",
    "Graphic Design",
    "Strategy & Consulting",
    "Network Engineering",
    "Game Development",
    "Technical Support",
    "Project Management",
    "Human Resources (HR)",
    "Operations Management",
  ];
  List<String> _selectedDomains = [];
  int? _userId;
  int? _interestId;

  @override
  void initState() {
    super.initState();
    _loadUserInterests();
  }

  Future<void> _loadUserInterests() async {
    _userId = await SharedPreferencesHelper.getProfileId();
    if (_userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User ID not found!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final storedInterests = await SharedPreferencesHelper.getStringList('selected_interests');
    if (storedInterests != null) {
      setState(() {
        _selectedDomains = storedInterests;
      });
    } else {
      await _fetchInterestsFromApi();
    }
  }


  Future<void> _fetchInterestsFromApi() async {
    final response = await http.get(Uri.parse(ApiUrls.interest));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      // Find the interest record for the current user.
      final userRecord = data.firstWhere(
            (item) => item['user'] == _userId,
        orElse: () => null,
      );

      if (userRecord != null) {
        // Save the interest record ID.
        _interestId = userRecord['id'];
        final userInterests = (userRecord['interest'] as String)
            .split(',')
            .map((interest) => interest.trim())
            .toList();

        setState(() {
          _selectedDomains = userInterests;
        });

        await SharedPreferencesHelper.setStringList('selected_interests', _selectedDomains);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load interests: ${response.statusCode}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  Future<void> _submitInterests() async {
    if (_selectedDomains.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one interest'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final requestBody = jsonEncode({
      "interest": _selectedDomains.join(","),
      "user": _userId
    });

    http.Response response;

    // If _interestId is not null, we already have a record so we patch.
    if (_interestId != null) {
      final patchUrl = Uri.parse('${ApiUrls.interest}$_interestId/');
      response = await http.patch(
        patchUrl,
        headers: {"Content-Type": "application/json"},
        body: requestBody,
      );
    } else {
      print("Intrese id is null");
      // Otherwise, create a new record with POST.
      final postUrl = Uri.parse(ApiUrls.interest);
      response = await http.post(
        postUrl,
        headers: {"Content-Type": "application/json"},
        body: requestBody,
      );
    }

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Optionally, if patching, you may want to update _interestId from the response.
      if (_interestId == null) {
        // Assuming the API returns the created record with an id field.
        final responseData = json.decode(response.body);
        _interestId = responseData['id'];
      }
      await SharedPreferencesHelper.setStringList('selected_interests', _selectedDomains);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Interests saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => FinalStepScreen()),
      );
    } else {
      print("Response: ${response.body} and code ${response.statusCode}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save interests: ${response.statusCode}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _toggleDomainSelection(String domain) {
    setState(() {
      if (_selectedDomains.contains(domain)) {
        _selectedDomains.remove(domain);
      } else if (_selectedDomains.length < _maxSelection) {
        _selectedDomains.add(domain);
      } else {

      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Interested Area Domain",
              style: TextStyle(
                fontSize: width * 0.05,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: height * 0.005),
            Text(
              "Select maximum five ${_selectedDomains.length}/$_maxSelection",
              style: TextStyle(
                fontSize: width * 0.04,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: height * 0.02),
            Wrap(
              spacing: 10.0,
              runSpacing: 10.0,
              children: _domains.map((domain) {
                final isSelected = _selectedDomains.contains(domain);
                return DomainChip(
                  domain: domain,
                  isSelected: isSelected,
                  toggleDomainSelection: _toggleDomainSelection,
                );
              }).toList(),
            ),
            SizedBox(height: height * 0.04),
            Center(
              child: ElevatedButton(
                onPressed: _submitInterests,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F3CC9),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: Size(width * 0.8, height * 0.06),
                ),
                child: const Text("Submit", style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}