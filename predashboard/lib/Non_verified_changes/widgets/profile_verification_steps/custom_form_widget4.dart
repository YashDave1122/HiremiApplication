import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pre_dashboard/API.dart';
import 'package:pre_dashboard/Non_verified_changes/Provider/UserProvider.dart';
import 'package:pre_dashboard/SharedPreferences/SharedPreferences.dart';
import 'package:pre_dashboard/predashboard/DegreeAndBranches/DegreeAndBranches.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../custom_text_field.dart';

class CustomFormWidget4 extends StatefulWidget {
  final Function(bool, int) onContinue;

  const CustomFormWidget4({super.key, required this.onContinue});

  @override
  State<CustomFormWidget4> createState() => _ReviewDetailsFormState();
}

class _ReviewDetailsFormState extends State<CustomFormWidget4> {
  String selectedState = 'Select State';
  String selectedCity = 'Select District';
  String? selectedDegree;
  String? selectedBranch;
  List<String> citiesList = [];
  List<String> statesList = [];
  List<int> citiesID = [];
  bool isLoading = true;
  int chosencityforcollege = 0;
  int chosencityforcollegeddd=3;
  String id="";
  final TextEditingController _collegeNameController = TextEditingController();
  late TextEditingController _collegeStateController = TextEditingController();
  late TextEditingController _collegeCityController = TextEditingController();
  final TextEditingController _branchController = TextEditingController();
  final TextEditingController _degreeController = TextEditingController();
  final TextEditingController _passoutYearController = TextEditingController();
  final SharedPreferencesService _prefsService = SharedPreferencesService();
  final SharedPreferencesService _sharedPreferencesService = SharedPreferencesService();

  bool _isValid = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
   print("USerdetails");
  }
  Future<void> _loadData() async {
    // Fetch saved education details
    final userDetails = await _prefsService.getEducationDetails();
    print("User data is $userDetails");

    if (userDetails != null) {
      print("Passing Years: ${userDetails['passing_year']}");
      print("Chosen city is $chosencityforcollege");
      setState(() {
        id = userDetails['id'].toString() ?? '';

        _collegeNameController.text = userDetails['college_name'] ?? '';
        _collegeStateController.text = userDetails['college_state'] ?? '';
        chosencityforcollege=userDetails['college_city'] ?? '';
        _branchController.text = userDetails['branch'] ?? '';
        _degreeController.text = userDetails['degree'] ?? '';
        _passoutYearController.text = userDetails['passing_year'].toString() ?? '';

        selectedState = userDetails['college_state'] ?? 'Select State';
        // selectedCity = userDetails['college_city'] ?? 'Select District';
        selectedDegree = userDetails['degree'] ?? 'Select Degree';
        selectedBranch = userDetails['branch'] ?? 'Select Branch';
        print("College id is $id");
        print("Chosen city is $chosencityforcollege");
        print("College Name: ${_collegeNameController.text}");
        print("College State: ${_collegeStateController.text}");
        print("College City: ${_collegeCityController.text}");
        print("Branch: ${_branchController.text}");
        print("Degree: ${_degreeController.text}");
        print("Passout Year: ${_passoutYearController.text}");
        print("Selected State: $selectedState");
        print("Selected City: $selectedCity");
        print("Selected Degree: $selectedDegree");
        print("Selected Branch: $selectedBranch");
      });
      if (chosencityforcollege != null && chosencityforcollege.toString().isNotEmpty && selectedState.isNotEmpty) {
        await _fetchCityName(selectedState, chosencityforcollege.toString());
      }

    } else {
      print("User details are null");
    }
  }
  Future<void> _fetchCityName(String stateName, String cityId) async {

    final url = Uri.parse("http://3.109.62.159:8000/cities/$cityId");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Response body is ${response.body}");
        setState(() {
          _collegeCityController.text = data['name']; // Assuming API returns {"name": "CityName"}
        });
        print("Fetched City Name: ${data['name']}");
      }

      else {
        print("Response code  is ${response.statusCode}");
        print("Response body is ${response.body}");

        print("Failed to fetch city name: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching city name: $e");
    }
  }
  Future<void> fetchStates() async {
    print("Clicking");
    final url = Uri.parse(ApiUrls.states);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        setState(() {
          statesList = data.map((state) => state["name"].toString()).toList();
          isLoading = false;
        });
      } else {
        print("Failed to load states: ${response.body}");
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("Error fetching states: $e");
      setState(() => isLoading = false);
    }
  }
  void _showStateSelection(BuildContext context) async {
    await fetchStates(); // Fetch states before showing the list
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(10),
          height: 300,
          child: ListView.builder(
            itemCount: statesList.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(statesList[index]),
                onTap: () {
                  setState(() {
                    // selectedState = statesList[index];
                    // widget.stateController.text = selectedState;
                    selectedState = statesList[index];
                    selectedCity = 'Select District';  // Reset district when state changes
                    _collegeStateController.text = selectedState; // Update state controller
                    _collegeCityController.clear();  // Clear the city controller text

                  });
                  Navigator.pop(context); // Close modal after selection
                },
              );
            },
          ),
        );
      },
    );
  }
  Future<void> fetchCities(String stateName) async {
    final url = Uri.parse('http://3.109.62.159:8000/states/$stateName/cities/');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        setState(() {
          citiesList = data.map((city) => city["name"].toString()).toList();
          citiesID = data.map<int>((city) => city["id"] as int).toList();
        });
      } else {
        print("Failed to load cities: ${response.body}");
      }
    } catch (e) {
      print("Error fetching cities: $e");
    }
  }
  void _showCitySelection(BuildContext context) async {
    if (selectedState == 'Select State') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a state first")),
      );
      return;
    }

    await fetchCities(selectedState); // Fetch cities for the selected state
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(10),
          height: 300,
          child: ListView.builder(
            itemCount: citiesList.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(citiesList[index]),
                onTap: ()async {
                  final prefs = await SharedPreferences.getInstance();
                  setState(() {
                    selectedCity = citiesList[index];
                    _collegeCityController.text = selectedCity;
                    chosencityforcollege=citiesID[index];
                    print("Chosend city is ${chosencityforcollege}");
                  });
                  await prefs.setInt('cityIdforCollege', citiesID[index]);
                  // widget.onCityIdChanged(citiesID[index]);
                  Navigator.pop(context); // Close modal after selection
                },
              );
            },
          ),
        );
      },
    );
  }


// Function to show a dialog for selecting a degree
  void _showDegreeSelection(BuildContext context) {
    List<String> degreeList = degreeBranches.keys.toList(); // Extract degree names

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select Degree'),
          content: SingleChildScrollView(
            child: Column(
              children: degreeList.map((degree) {
                return ListTile(
                  title: Text(degree),
                  onTap: () {
                    setState(() {
                      _degreeController.text = degree; // Update the degree controller text
                      selectedDegree = degree; // Update selected degree
                      selectedBranch = null; // Reset the selected branch
                      _branchController.text = ''; // Clear the branch controller text
                    });
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
  // Function to show a dialog for selecting a passout year
  void _showPassoutYearSelection(BuildContext context) {
    // List of passing years (2000-2032)
    List<String> passoutYears = List.generate(33, (index) => (2000 + index).toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select Passout Year'),
          content: SingleChildScrollView(
            child: Column(
              children: passoutYears.map((year) {
                return ListTile(
                  title: Text(year),
                  onTap: () {
                    setState(() {
                      _passoutYearController.text = year; // Update the passout year controller text
                    });
                    Navigator.pop(context); // Close the dialog
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

// Function to show a dialog for selecting a branch
  void _showBranchSelection(BuildContext context) {
    if (selectedDegree == null || selectedDegree!.isEmpty) {
      // If no degree is selected, show a warning
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a degree first.')),
      );
      return;
    }

    List<String> branches = degreeBranches[selectedDegree!] ?? []; // Get branches for the selected degree

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select Branch'),
          content: SingleChildScrollView(
            child: Column(
              children: branches.map((branch) {
                return ListTile(
                  title: Text(branch),
                  onTap: () {
                    setState(() {
                      _branchController.text = branch; // Update the branch controller text
                      selectedBranch = branch; // Update selected branch
                    });
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
  Future<void> _updateUserDetails() async {
    final userId = await _sharedPreferencesService.getUserId();
    if (userId != null) {
      print("USer id is $userId");
      final updatedDetails = {
        'college_name': _collegeNameController.text,
        'college_city': chosencityforcollege,
        'college_state': _collegeStateController.text,
        'branch': _branchController.text,
        'degree':_degreeController.text,
        'passing_year':_passoutYearController.text,
        'user':userId,
      };
      print("Updated details are $updatedDetails");

      await Provider.of<UserProvider>(context, listen: false)
          .updateEducationsDetails(int.tryParse(id.toString()) ?? 0, updatedDetails);

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User ID not found!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: height * 0.01),
          Padding(
            padding: EdgeInsets.only(left: width * 0.05),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Review and Verify your details',
                style: TextStyle(
                  fontSize: width * 0.05,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF0F3CC9),
                ),
              ),
            ),
          ),
          SizedBox(height: height * 0.02),
          CustomTextField(title: 'College Name', hText: "St John's University", controller: _collegeNameController,),
          SizedBox(height: height * 0.02),
          CustomTextField(
            title: "College's State",
            hText: 'Kolkata',
            controller: _collegeStateController,
            // onTap: () => _showStateSelection(context), // Show state list when tapped
            onTap: ()=>_showStateSelection(context),
            readOnly: true,

          ),
          SizedBox(height: height * 0.02),

          CustomTextField(
            title: "College's City",
            hText: 'Kolkata',
            controller: _collegeCityController,
            onTap: () => _showCitySelection(context), // Show state list when tapped
            readOnly: true,

          ),

          SizedBox(height: height * 0.02),



          CustomTextField(
            title: "Degree",
            hText: 'Bachelor Degree',
            controller: _degreeController,
            onTap: ()=>_showDegreeSelection(context),
            readOnly: true,
          ),


          CustomTextField(
            title: "Branch",
            hText: 'Computer Science',
           readOnly: true,
            dropdownItems: degreeBranches[selectedDegree]?.toSet().toList() ?? [], // Ensure unique list
            onTap: ()=>_showBranchSelection(context),
            controller: _branchController,
          ),


          SizedBox(height: height * 0.02),
          CustomTextField(
            title: "Passout Year",
            hText: '2022',
            readOnly: true,
            isDropdown: false,
            onTap: ()=>   _showPassoutYearSelection(context),
            controller: _passoutYearController,),
          SizedBox(height: height * 0.05),
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
              child: const Text('Review and next', style: TextStyle(fontSize: 16)),
            ),
          ),
          SizedBox(height: height * 0.02),
        ],
      ),
    );
  }

  Future<void> _handleContinue() async {
    if (_collegeNameController.text.isEmpty ||
        _collegeStateController.text.isEmpty ||
        _branchController.text.isEmpty ||
        _degreeController.text.isEmpty ||
        _passoutYearController.text.isEmpty ||
        _collegeCityController.text.isEmpty
    ) {
      setState(() {
        _isValid = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All fields must be filled!'),
          backgroundColor: Colors.red,
        ),
      );
      widget.onContinue(false, 3);
    } else {
      await _updateUserDetails();
      setState(() {
        _isValid = true;
      });
      widget.onContinue(true, 4);
    }
  }

  @override
  void dispose() {
    _collegeStateController.dispose();
    _collegeNameController.dispose();
    _branchController.dispose();
    _degreeController.dispose();
    _passoutYearController.dispose();
    super.dispose();
  }
}