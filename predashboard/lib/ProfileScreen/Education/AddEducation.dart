import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pre_dashboard/API.dart';
import 'package:pre_dashboard/AppSizes/AppSizes.dart';
import 'package:pre_dashboard/HomePage/constants/constantsColor.dart';
import 'package:pre_dashboard/Non_verified_changes/Provider/UserProvider.dart';
import 'package:pre_dashboard/ProfileScreen/Education/CustomTextFeildAddEducation.dart';
import 'package:pre_dashboard/ProfileScreen/Education/apiServices.dart';
import 'package:http/http.dart' as http;
import 'package:pre_dashboard/ProfileScreen/Profile_screen.dart';
import 'package:pre_dashboard/SharedPreferences/SharedPreferences.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../Non_verified_changes/widgets/custom_text_field.dart';


class AddEducation extends StatefulWidget {
  final bool isEditing;
  const AddEducation({Key? key,required this.isEditing}) : super(key: key);

  @override
  _AddEducationState createState() => _AddEducationState();
}

class _AddEducationState extends State<AddEducation> {
  final _collegeNameController=TextEditingController();
  final educationController = TextEditingController();
  final _degreeController=TextEditingController();
  final _branchController = TextEditingController();
  final yearController = TextEditingController();
  final marksController = TextEditingController();
  final collegeStateController=TextEditingController();
  final collegeCityController=TextEditingController();
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


  final AddEducationService _apiService = AddEducationService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final SharedPreferencesService _prefsService = SharedPreferencesService();
  final SharedPreferencesService _sharedPreferencesService = SharedPreferencesService();

  String profileId = "";

  // @override
  // void initState() {
  //   super.initState();
  //   // _loadEducationDetails();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     _loadData();
  //   });
  // }
  @override
  void initState() {
    super.initState();
    if (widget.isEditing) {
      // Only load data if we're in edit mode
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadData();
      });
    } else {
      // Initialize with empty values for new entry
      _initializeEmptyValues();
    }
  }
  void _initializeEmptyValues() {
    setState(() {
      _collegeNameController.clear();
      marksController.clear();
      collegeStateController.clear();
      collegeCityController.clear();
      _branchController.clear();
      _degreeController.clear();
      yearController.clear();
      selectedState = 'Select State';
      selectedCity = 'Select District';
      selectedDegree = null;
      selectedBranch = null;
      chosencityforcollege = 0;
    });
  }

  // Future<void> _loadEducationDetails() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final int? savedId = prefs.getInt('profileId');
  //   if (savedId != null) {
  //     profileId = savedId.toString();
  //     final details = await _apiService.getEducationDetails();
  //     final latestDetails = details.isNotEmpty ? details.first : null;
  //
  //     if (latestDetails != null) {
  //       setState(() {
  //         educationController.text = latestDetails['education'] ?? '';
  //         courseController.text = latestDetails['degree'] ?? '';
  //         yearController.text = latestDetails['passing_year'] ?? '';
  //         marksController.text = latestDetails['marks'] ?? '';
  //       });
  //     }
  //   } else {
  //     print('Profile ID not found');
  //   }
  // }
  Future<void> _fetchCityName(String stateName, String cityId) async {

    // final url = Uri.parse("http://3.109.62.159:8000/cities/$cityId");
    final url = Uri.parse("${ApiUrls.cities}$cityId");


    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Response body is ${response.body}");
        setState(() {
          collegeCityController.text = data['name']; // Assuming API returns {"name": "CityName"}
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
  Future<void> _loadData() async {
    // Fetch saved education details
    final userDetails = await _prefsService.getEducationDetails();
    print("User data is $userDetails");

    if (userDetails != null) {
      print("Percentage is : ${userDetails['percentage']}");
      print("Chosen city is $chosencityforcollege");
      setState(() {
        id = userDetails['id'].toString() ?? '';

        _collegeNameController.text = userDetails['college_name'] ?? '';
        // marksController.text=userDetails['percentage'].toString();
        marksController.text = userDetails['percentage'] != null
            ? userDetails['percentage'].toString()
            : '';

        collegeStateController.text = userDetails['college_state'] ?? '';
        chosencityforcollege=userDetails['college_city'] ?? '';
        _branchController.text = userDetails['branch'] ?? '';
        _degreeController.text = userDetails['degree'] ?? '';
        yearController.text = userDetails['passing_year'].toString() ?? '';

        selectedState = userDetails['college_state'] ?? 'Select State';
        // selectedCity = userDetails['college_city'] ?? 'Select District';
        selectedDegree = userDetails['degree'] ?? 'Select Degree';
        selectedBranch = userDetails['branch'] ?? 'Select Branch';
        print("College id is $id");
        print("Chosen city is $chosencityforcollege");
        print("College Name: ${_collegeNameController.text}");
        print("College State: ${collegeStateController.text}");
        print("College City: ${collegeCityController.text}");
        print("Branch: ${_branchController.text}");
        print("Degree: ${_degreeController.text}");
        print("Passout Year: ${yearController.text}");
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
                    collegeStateController.text = selectedState; // Update state controller
                    collegeCityController.clear();  // Clear the city controller text

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
                    collegeCityController.text = selectedCity;
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

    Future<bool> _saveEducation(BuildContext context) async {
      print(":WE are in save education");
      if (!_formKey.currentState!.validate()) {
        return false;
      }
      else{
        print("Everything is right");
      }

      final marksText = marksController.text;
      final marks = int.tryParse(marksText.replaceAll(RegExp(r'[^\d]'), ''));
      if (marks == null) {
        _showError('Marks should be a valid integer');
        return false;
      }

      final yearText = yearController.text;
      final year = int.tryParse(yearText);
      if (year == null) {
        _showError('Year should be a valid integer');
        return false;
      }

      final prefs = await SharedPreferences.getInstance();
      final int? savedId = prefs.getInt('profileId');
      print("Saved id is $savedId");
      if (savedId != null) {
        profileId = savedId.toString();
      } else {
        _showError('Profile ID not found');
        return false;
      }

      final details = {

        // "education": educationController.text,
        // "degree": _degreeController.text,
        // "marks": marks.toString(),
        // "passing_year": year.toString(),
        // "profile": profileId,
        "college_name": _collegeNameController.text,
        "branch":_branchController.text,
        "degree": _degreeController.text,
        // "marks": marks.toString(),
        // "passing_year": year.toString(),
        "user": id,
      };

      final success = await _apiService.addOrUpdateEducation(details);

      if (success) {
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (ctx) => NewNavbar(
        //       initTabIndex: 3, // Navigate to the desired screen
        //       isV: true, // Pass the verification status
        //     ),
        //   ),
        // );

      } else {
        _showError('Failed to save education details');
      }
      return true;
    }
  Future<void> _updateUserDetails() async {
    final userId = await _sharedPreferencesService.getUserId();
    if (userId != null) {
      print("USer id is $userId");
      final updatedDetails = {
        'college_name': _collegeNameController.text,
        'college_city': chosencityforcollege,
        'college_state': collegeStateController.text,
        'branch': _branchController.text,
        'degree':_degreeController.text,
        'passing_year':yearController.text,
        'percentage':marksController.text,
        'user':userId,
      };
      print("Updated details are $updatedDetails");


      if (widget.isEditing) {
        // Update existing education
        await Provider.of<UserProvider>(context, listen: false)
            .updateEducationsDetails(int.tryParse(id.toString()) ?? 0, updatedDetails);
      } else {
        // Create new education
        await Provider.of<UserProvider>(context, listen: false)
            .addEducationDetails(updatedDetails);
      }

      // await Provider.of<UserProvider>(context, listen: false)
      //     .updateEducationsDetails(int.tryParse(id.toString()) ?? 0, updatedDetails);

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User ID not found!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
              top: Sizes.responsiveXl(context),
              right: Sizes.responsiveDefaultSpace(context),
              bottom: kToolbarHeight,
              left: Sizes.responsiveDefaultSpace(context)),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // const Text(
                //   'Education',
                //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                // ),
                SizedBox(
                  height: Sizes.responsiveMd(context),
                ),
                Row(
                  children: [
                    const Text(
                      'College Name',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '*',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: Sizes.responsiveSm(context),
                ),
                CustomTextFieldAndEducation(
                  controller: _collegeNameController,
                  hintText: 'Select College name',
                  // suffix: const Icon(
                  //   Icons.arrow_drop_down,
                  //   color: AppColors.black,
                  //   size: 15,
                  // ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select your college name';
                    }

                    return null;

                  },
                ),
                SizedBox(
                  height: Sizes.responsiveSm(context),
                ),
                Row(
                  children: [
                    const Text(
                      'Degree',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '*',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: Sizes.responsiveSm(context),
                ),
                CustomTextFieldAndEducation(
                  controller: _branchController,
                  hintText: 'Select degree',
                  // suffix: const Icon(
                  //   Icons.arrow_drop_down,
                  //   color: AppColors.black,
                  //   size: 15,
                  // ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select your degree';
                    }

                    return null;

                  },
                ),
                SizedBox(
                  height: Sizes.responsiveMd(context),
                ),
                Row(
                  children: [
                    const Text(
                      'Branch',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '*',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height: Sizes.responsiveSm(context),
                ),

                CustomTextFieldAndEducation(
                  controller: _degreeController,
                  hintText: 'Select Subject or Course Level',
                  // suffix: const Icon(
                  //   Icons.arrow_drop_down,
                  //   color: AppColors.black,
                  //   size: 15,
                  // ),
                  validator: (value) {
                    final alphabetRegex = RegExp(r'^[a-zA-Z\s]+$');

                    if (value == null || value.isEmpty) {
                      return 'Please select your Subject';
                    }
                    // else if (!alphabetRegex.hasMatch(value)) {
                    //   return 'Only letters  are allowed';
                    // }
                    return null;

                    return null;
                  },
                ),
                SizedBox(
                  height: Sizes.responsiveMd(context),
                ),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap:  () => _showStateSelection(context),

                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: collegeStateController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: Color(0xff0056D6)),
                              ),
                              labelText: 'Birth State',
                              hintText: 'eg: West Bengal',
                              labelStyle: const TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Birth state is required';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap:()=> _showCitySelection(context),
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: collegeCityController,
                            decoration: InputDecoration(
                              labelText: 'Birth City',
                              hintText: 'eg: Kolkata',
                              labelStyle: const TextStyle(
                                // color: Color(0xff0F3CC9),
                                color: Colors.black87,

                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                // borderSide: const BorderSide(color: Color(0xff0056D6)),
                                borderSide: const BorderSide(color: Colors.grey),

                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'birth city is required';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: Sizes.responsiveMd(context),
                ),
                Row(
                  children: [
                    const Text(
                      'Passing Out Year',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '*',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: Sizes.responsiveSm(context),
                ),

                // CustomTextFieldAndEducation(
                //   controller: yearController,
                //   hintText: 'eg: 2024',
                //   // suffix: const Icon(
                //   //   Icons.arrow_drop_down,
                //   //   color: AppColors.black,
                //   //   size: 15,
                //   // ),
                //   textInputType: TextInputType.number,
                //   validator: (value) {
                //     final numericRegex = RegExp(r'^[0-9]+$');  // Regular expression for numbers
                //
                //     if (value == null || value.isEmpty) {
                //       return 'Please enter a passing out year';
                //     } else if (!numericRegex.hasMatch(value)) {
                //       return 'Only numbers are allowed';
                //     }
                //     return null;
                //   },
                // ),
                CustomTextFieldAndEducation(
                  controller: yearController,
                  hintText: 'Select Passing Year',
                  textInputType: TextInputType.number,
                  isDropdown: true, // Enable dropdown
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter or select a passing year';
                    }
                    return null;
                  },
                ),

                SizedBox(
                  height: Sizes.responsiveMd(context),
                ),

                Row(
                  children: [
                    const Text(
                      'Percentage/CGPA',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '*',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: Sizes.responsiveSm(context),
                ),
                // CustomTextFieldAndEducation(
                //   controller: marksController,
                //   hintText: 'eg: 84.99%',
                //   textInputType: TextInputType.number,
                //   validator: (value) {
                //     if (value == null || value.isEmpty)
                //     {
                //       return 'Please enter marks';
                //     }
                //     else
                //       {
                //         print("Empty nhi hai");
                //       }
                //
                //     return null;
                //   },
                // ),
                CustomTextFieldAndEducation(
                  controller: marksController,
                  hintText: 'eg: 84.99%',
                  textInputType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter marks'; // Ensure this message is returned when the field is empty
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: Sizes.responsiveMd(context),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(onPressed: (){
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) =>  ProfileScreen()),
                      );
                    }, child: Text("Profile")),
                    // ElevatedButton(
                    //   style: ElevatedButton.styleFrom(
                    //   //  backgroundColor: AppColors.primary,
                    //     backgroundColor: Color(0xFF163EC8),
                    //
                    //     shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(Sizes.radiusSm)),
                    //     padding: EdgeInsets.symmetric(
                    //         vertical: Sizes.responsiveHorizontalSpace(context),
                    //         horizontal: Sizes.responsiveMdSm(context)),
                    //   ),
                    //   onPressed: () async {
                    //     // await _saveEducation(context);
                    //     _updateUserDetails();
                    //
                    //
                    //   },
                    //   child: const Text(
                    //     'Save',
                    //     style: TextStyle(
                    //       fontSize: 12,
                    //       fontWeight: FontWeight.w500,
                    //       color: AppColors.white,
                    //     ),
                    //   ),
                    // ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF163EC8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Sizes.radiusSm),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: Sizes.responsiveHorizontalSpace(context),
                            horizontal: Sizes.responsiveMdSm(context)),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          // Only proceed if all fields are valid
                          await _updateUserDetails();
                        }
                      },
                      child: const Text(
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
