
import 'dart:convert';

import 'package:pre_dashboard/API.dart';
import 'package:pre_dashboard/predashboard/StatesAndDistrict/StatesAndDistrict.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;

import 'package:pre_dashboard/predashboard/bloc/user_bloc.dart';

import 'package:pre_dashboard/predashboard/widgets/custom_text_field.dart';
import 'package:pre_dashboard/predashboard/widgets/gender_radio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/constants.dart';

class Step1ContentWidget extends StatefulWidget {
  Step1ContentWidget({
    super.key,
    required this.formKey,
    required this.fullNameController,
    required this.fatherNameController,
    required this.birthPlaceController,
    required this.dobController,
    required this.cityController,
    required this.stateController,
    required this.onGenderChanged,
    required this.onCityChanged,
    required this.onStateChanged,
    this.selectedGender,
    required this.isValidated,
    required this.onValidation,
    required this.citiesID,
    required this.chosencity,
    required this.onCityIdChanged
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController fullNameController;
  final TextEditingController fatherNameController;
  final TextEditingController dobController;
  final TextEditingController stateController;
  final TextEditingController cityController;
  final TextEditingController birthPlaceController;
  final ValueChanged<String?> onGenderChanged;
  final ValueChanged<String?> onCityChanged;
  final ValueChanged<String?> onStateChanged;
  final ValueChanged<int> onCityIdChanged;
  int chosencity=0;

  final String? selectedGender;
  // final String? citiesID;
  // final String? citiesID;
  final List<int> citiesID; // ✅ Change this to List<int>


  final bool isValidated;
  final Function(bool) onValidation;



  @override
  State<Step1ContentWidget> createState() => _Step1ContentWidgetState();
}

class _Step1ContentWidgetState extends State<Step1ContentWidget> {
  String selectedCountry = 'India';
  String selectedState = 'Select State';
  String selectedCity = 'Select District';

  int chosencity = 0;
  String countryValue = "India"; // Default country set to India
  String? selectedGender;
  List<String> citiesList = [];
  List<int> citiesID = [];


  List<String> statesList = [];
  bool isLoading = true;





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
                    widget.stateController.text = selectedState; // Update state controller
                    widget.cityController.clear();  // Clear the city controller text

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
  Future<void> fetchCities(String stateName) async {
    final url = Uri.parse('http://3.109.62.159:8000/states/$stateName/cities/');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        setState(() {
          citiesList = data.map((city) => city["name"].toString()).toList();
          // citiesID = data.map((city) => city["id"]).toList();
          citiesID = data.map<int>((city) => city["id"] as int).toList(); // ✅ Correct


        });
      } else {
        print("Failed to load cities: ${response.body}");
      }
    } catch (e) {
      print("Error fetching cities: $e");
    }
  }
  void _showCitySelection(BuildContext context) async {
    print("Cities id is ${citiesID}");
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
                onTap: () async {
                  final prefs = await SharedPreferences.getInstance();
                  setState(() {
                    selectedCity = citiesList[index];
                    widget.cityController.text = selectedCity;
                    chosencity=citiesID[index];

                    // widget.cityController.text = citiesID[index];

                  });
                  await prefs.setInt('cityId', citiesID[index]);
                  widget.onCityIdChanged(citiesID[index]); // Notify parent
                  Navigator.pop(context); // Close modal after selection
                },
              );
            },
          ),
        );
      },
    );
  }



  @override
  void initState() {
    // TODO: implement initState
    // getCountries();
    selectedGender = widget.selectedGender;
    super.initState();
    _loadSavedData(); // Load saved data when widget initializes
    _setupControllerListeners(); // Set up listeners for text changes
  }
  void _setupControllerListeners() {
    widget.fullNameController.addListener(() => _saveToPrefs('fullName'));
    widget.fatherNameController.addListener(() => _saveToPrefs('fatherName'));
    widget.dobController.addListener(() => _saveToPrefs('dob'));
    widget.stateController.addListener(() => _saveToPrefs('state'));
    widget.cityController.addListener(() => _saveToPrefs('city'));
    widget.birthPlaceController.addListener(() => _saveToPrefs('birthPlace'));
   // widget.onGenderChanged.addListener(()=>_saveToPrefs('birthPlace'));
  }

  Future<void> _saveToPrefs(String key) async {
    final prefs = await SharedPreferences.getInstance();
    switch (key) {
      case 'fullName':
        prefs.setString(key, widget.fullNameController.text);
        break;
      case 'fatherName':
        prefs.setString(key, widget.fatherNameController.text);
        break;
      case 'dob':
        prefs.setString(key, widget.dobController.text);
        break;
      case 'state':
        prefs.setString(key, widget.stateController.text);
        break;
      case 'city':
        prefs.setString(key, widget.cityController.text);
        break;
      case 'birthPlace':
        prefs.setString(key, widget.birthPlaceController.text);
        break;
      case 'gender':
        prefs.setString(key, widget.selectedGender ?? '');
        break;
    }
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // Load text field values
      widget.fullNameController.text = prefs.getString('fullName') ?? '';
      widget.fatherNameController.text = prefs.getString('fatherName') ?? '';
      widget.dobController.text = prefs.getString('dob') ?? '';
      widget.stateController.text = prefs.getString('state') ?? 'Select State';
      widget.cityController.text = prefs.getString('city') ?? 'Select District';
      widget.birthPlaceController.text = prefs.getString('birthPlace') ?? '';

      // Load selections
      selectedState = prefs.getString('state') ?? 'Select State';
      selectedCity = prefs.getString('city') ?? 'Select District';

      // Load gender and update parent
      selectedGender = prefs.getString('gender');
      if (selectedGender != null) {
        widget.onGenderChanged(selectedGender); // Uncomment this line
      }


    });
    final savedCityId = prefs.getInt('cityId') ?? 0;
    if (savedCityId != 0)
    {
      widget.onCityIdChanged(savedCityId);
    }


  }


  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: widget.formKey, // Attach the form key here
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    SizedBox(height: screenHeight * 0.03),
                    CustomTextField(
                      value: state.user.name,
                      controller: widget.fullNameController,
                      labelText: "Full Name",
                      hintText: 'Full Name',
                      validator: (value) {
                        if (value!.length < 3 || value.isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                    ),
                    CustomTextField(
                      value: state.user.fathersName,
                      controller: widget.fatherNameController,
                      labelText: "Father’s Full Name",
                      hintText: 'Father Name',
                      validator: (value) {
                        if (value!.length < 3 || value.isEmpty) {
                          return 'Please enter your father\'s full name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Gender',
                            style: GoogleFonts.poppins(
                              fontSize: screenHeight * 0.02,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: '*',
                            style: GoogleFonts.poppins(
                              fontSize: screenHeight * 0.02,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xff0F3CC9),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.002),

                    GenderInput(
                      widget: widget,
                      selectedGender: selectedGender,
                      onGenderChanged: (value) {
                        setState(() {
                          selectedGender = value;
                        });
                        print("Selectected gender is $selectedGender and $value");
                        widget.onGenderChanged(value);
                      },
                      screenHeight: screenHeight,
                    ),


                    SizedBox(height: screenHeight * 0.02),
                    CustomTextField(
                      controller: widget.dobController,
                      labelText: 'Date of Birth',
                      hintText: 'DD/MM/YYYY',
                      prefixIcon: const Icon(Icons.calendar_today,
                          color: AppColors.secondaryTextColor),
                      isDatePicker: true,
                      onTap: () async {
                        DateTime? selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (selectedDate != null) {
                          widget.dobController.text =
                              '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}';
                       //   widget.dobController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select your date of birth';
                        }
                        return null;
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:
                      [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _showStateSelection(context), // Show state list when tapped
                            // onTap: ()=>fetchStates,
                            child: AbsorbPointer(
                              child: CustomTextField(
                                controller: widget.stateController,
                                hintText: 'Select State',
                                isDropdown: false,
                                value: selectedState,
                                labelText: 'Current State',
                                validator: (value) {
                                  if (value == null || value.isEmpty || value == 'Select State') {
                                    return 'Please select a state';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10), // Adjust space between the fields to fit better
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _showCitySelection(context), // Show city list when tapped
                            child: AbsorbPointer(
                              child: CustomTextField(
                                controller: widget.cityController,
                                hintText: 'Select District',
                                value: selectedCity,
                                labelText: 'District',
                                validator: (value) {
                                  if (value == null || value.isEmpty || value == 'Select District') {
                                    return 'Please select a district';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    )

                  ],
                ),
              ),
            ),
          );
        }
       // }
      ));

  }
}



class GenderInput extends StatefulWidget {
  const GenderInput({
    super.key,
    required this.widget,
    required this.screenHeight,
    required this.selectedGender,
    required this.onGenderChanged,
  });
  final String? selectedGender;
  final ValueChanged<String?> onGenderChanged;
  final Step1ContentWidget widget;
  final double screenHeight;

  @override
  State<GenderInput> createState() => _GenderInputState();
}

class _GenderInputState extends State<GenderInput> {
  final List<bool> selectionState = [false, false, false];
  String? _currentGender;

  @override
  void initState() {
    super.initState();
    _updateSelectionBasedOnGender(widget.selectedGender);
  }

  @override
  void didUpdateWidget(covariant GenderInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedGender != widget.selectedGender) {
      _updateSelectionBasedOnGender(widget.selectedGender);
      print("gender is ${widget.selectedGender}");
    }
  }

  void _updateSelectionBasedOnGender(String? gender) {
    setState(() {
      _currentGender = gender;
      selectionState[0] = gender == 'Male';
      selectionState[1] = gender == 'Female';
      selectionState[2] = gender == 'Other';
    });
  }

  String? validateGender(String? gender) {
    if (gender == null || gender.isEmpty) return 'Please select a gender.';
    else
      {
        print("Gender is $gender");
      }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      // Add a Key to force rebuild when selectedGender changes
      key: Key(widget.selectedGender ?? 'null'),
      initialValue: widget.selectedGender,
      validator: validateGender,
      builder: (field) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GenderRadio(
                  gender: 'Male',
                  selectedGender: field.value,
                  onChanged: (value) async {
                    _updateSelection(0);
                    field.didChange(value);
                    widget.onGenderChanged(value);
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setString('gender', value ?? '');
                  },
                  isSelected: selectionState[0],
                ),
                SizedBox(width: widget.screenHeight * 0.01),
                GenderRadio(
                  gender: 'Female',
                  selectedGender: field.value,
                  onChanged: (value) async {
                    _updateSelection(1);
                    field.didChange(value);
                    widget.onGenderChanged(value);
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setString('gender', value ?? '');
                  },
                  isSelected: selectionState[1],
                ),
                SizedBox(width: widget.screenHeight * 0.01),
                GenderRadio(
                  gender: 'Other',
                  selectedGender: field.value,
                  onChanged: (value) async {
                    _updateSelection(2);
                    field.didChange(value);
                    widget.onGenderChanged(value);
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setString('gender', value ?? '');
                  },
                  isSelected: selectionState[2],
                ),
              ],
            ),
            if (field.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  field.errorText!,
                  style: TextStyle(
                    color: Colors.red[900],
                    fontSize: widget.screenHeight * 0.0125,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  void _updateSelection(int selectedIndex) {
    for (int i = 0; i < selectionState.length; i++) {
      setState(() {
        selectionState[i] = (i == selectedIndex);
      });
    }
  }
}