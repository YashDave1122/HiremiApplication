
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pre_dashboard/API.dart';
import 'package:pre_dashboard/AppSizes/AppSizes.dart';
import 'package:pre_dashboard/HomePage/constants/constantsColor.dart';
import 'package:pre_dashboard/Non_verified_changes/Provider/UserProvider.dart';
import 'package:pre_dashboard/ProfileScreen/Education/CustomTextFeildAddEducation.dart';
import 'package:pre_dashboard/ProfileScreen/Profile_screen.dart';
import 'package:pre_dashboard/SharedPreferences/SharedPreferences.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class AddPersonalDetailsForProfileSection extends StatefulWidget {
  const AddPersonalDetailsForProfileSection({super.key});

  @override
  State<AddPersonalDetailsForProfileSection> createState() =>
      _AddPersonalDetailsForProfileSectionState();
}

class _AddPersonalDetailsForProfileSectionState
    extends State<AddPersonalDetailsForProfileSection> {
  final SharedPreferencesService _sharedPreferencesService = SharedPreferencesService();

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController fatherFullNameController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController birthPlaceController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map<String, dynamic>? userDetails;
  List<String> statesList = [];
  List<String> citiesList = [];
  List<int> citiesID = [];
  int chosencity = 0;
  String selectedState = 'Select State';
  String selectedCity = 'Select District';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // _loadUserDetails();
    fetchUserDetails();
  }
  // Future<void> fetchUserDetails() async {
  //   SharedPreferencesService prefsService = SharedPreferencesService();
  //   Map<String, dynamic>? details = await prefsService.getUserDetails();
  //   print("USer details is ${details}");
  //   setState(() {
  //     userDetails = details;
  //   });
  //   // print("USer detais is ${userDetails}");
  // }
  Future<void> _loadUserDetails() async {

    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final String? userDetailsString = sharedPreferences.getString('userDetails');

    if (userDetailsString != null) {
      setState(() {
        userDetails = jsonDecode(userDetailsString);
        fullNameController.text = userDetails?['full_name'] ?? '';
        fatherFullNameController.text = userDetails?['father_name'] ?? '';
        genderController.text = userDetails?['gender'] ?? '';
        dobController.text = userDetails?['date_of_birth'] ?? '';
        birthPlaceController.text = userDetails?['current_state'] ?? '';
        chosencity = userDetails?['current_city'] ?? '';

      });
      if (chosencity != null && chosencity.toString().isNotEmpty && selectedState.isNotEmpty) {
        await _fetchCityName(selectedState, chosencity.toString());
      }
      else{
        print("Chosen city is $chosencity");
      }
      print("User Details: $userDetails");
    } else {
      print("Data is empty");
    }
  }
  Future<void> _fetchCityName(String stateName, String cityId) async {

    // final url = Uri.parse("http://3.109.62.159:8000/cities/$cityId");
    final url = Uri.parse("${ApiUrls.cities}$cityId");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Response body is ${response.body}");
        setState(() {
          cityController.text = data['name']; // Assuming API returns {"name": "CityName"}
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
  Future<void> fetchUserDetails() async {
    SharedPreferencesService prefsService = SharedPreferencesService();
    // Map<String, dynamic>? details = await prefsService.getUserDetails();
    //
    // print("✅ Retrieved User details: $details");
    //
    // // Check if `current_state` and `current_city` exist
    // if (!details!.containsKey('current_state')) {
    //   print("❌ ERROR: `current_state` is missing from SharedPreferences!");
    // }
    // if (!details.containsKey('current_city')) {
    //   print("❌ ERROR: `current_city` is missing from SharedPreferences!");
    // }
    Map<String, dynamic>? storedDetails = await prefsService.getUserDetails();
    print("User details from SharedPreferences: $storedDetails");

    setState(() {

      userDetails = storedDetails;
      fullNameController.text = userDetails?['full_name'] ?? '';
      fatherFullNameController.text = userDetails?['father_name'] ?? '';
      genderController.text = userDetails?['gender'] ?? '';
      dobController.text = userDetails?['date_of_birth'] ?? '';
      birthPlaceController.text = userDetails?['current_state'] ?? '';
      // cityController.text = userDetails?['current_city'] ?? '';
      chosencity = userDetails?['current_city'] ?? '';

    });
    if (chosencity != null && chosencity.toString().isNotEmpty && selectedState.isNotEmpty) {
      await _fetchCityName(selectedState, chosencity.toString());
    }
    print("Current city is ${userDetails?['current_city'] }");
  }

  // Future<void> _loadUserDetails() async {
  //   final SharedPreferences sharedPreferences =
  //   await SharedPreferences.getInstance();
  //   final String? userDetailsString = sharedPreferences.getString('userDetails');
  //
  //   if (userDetailsString != null) {
  //     setState(() {
  //       userDetails = jsonDecode(userDetailsString);
  //     });
  //     print("User Details: $userDetails");
  //   } else {
  //     print("Data is empty");
  //   }
  // }
  Future<void> fetchStates() async {

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
    // final url = Uri.parse('http://3.109.62.159:8000/states/$stateName/cities/');
    final url = Uri.parse('${ApiUrls.states}$stateName/cities/');

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
                    birthPlaceController.text = selectedState; // Update state controller
                    cityController.clear();  // Clear the city controller text

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
                    cityController.text = selectedCity;
                    chosencity=citiesID[index];

                    // _birthCityController.text = citiesID[index];
                  });
                  await prefs.setInt('birthcityId', citiesID[index]);
                  // widget.onCityIdChanged(citiesID[index]); // Notify parent
                  Navigator.pop(context); // Close modal after selection
                },
              );
            },
          ),
        );
      },
    );
  }



  // Widget _buildTextField({
  //   required String label,
  //   required TextEditingController controller,
  //   required String hintText,
  //   TextInputType textInputType = TextInputType.text,
  //   String? Function(String?)? validator,
  // }) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Row(
  //         children: [
  //           Text(
  //             label,
  //             style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
  //           ),
  //           Text(
  //             '*',
  //             style: TextStyle(
  //               fontSize: 12,
  //               fontWeight: FontWeight.w500,
  //               color: AppColors.primary,
  //             ),
  //           ),
  //         ],
  //       ),
  //       SizedBox(height: Sizes.responsiveSm(context)),
  //       CustomTextFieldAndEducation(
  //         controller: controller,
  //         hintText: hintText,
  //         textInputType: textInputType,
  //         validator: validator,
  //       ),
  //       SizedBox(height: Sizes.responsiveMd(context)),
  //     ],
  //   );
  // }
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    TextInputType textInputType = TextInputType.text,
    String? Function(String?)? validator,
    VoidCallback? onTap, // Optional onTap function
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
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
        SizedBox(height: Sizes.responsiveSm(context)),
        CustomTextFieldAndEducation(
          controller: controller,
          hintText: hintText,
          textInputType: textInputType,
          validator: validator,
          readOnly: onTap != null, // Make read-only when onTap is provided
          // suffix: Icon(Icons.calendar_today, color: AppColors.secondaryText), // Calendar icon
          onTap: onTap, // Assign onTap function
        ),
        SizedBox(height: Sizes.responsiveMd(context)),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          top: Sizes.responsiveXl(context),
          right: Sizes.responsiveDefaultSpace(context),
          bottom: kToolbarHeight,
          left: Sizes.responsiveDefaultSpace(context),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                label: 'Full Name',
                controller: fullNameController,
                hintText: 'Enter Full Name',
                validator: (value) =>
                (value == null || value.isEmpty) ? 'Please enter your full name' : null,
              ),
              _buildTextField(
                label: 'Father Full Name',
                controller: fatherFullNameController,
                hintText: 'Enter Father’s Full Name',
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter father’s full name';
                  if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) return 'Only letters are allowed';
                  return null;
                },
              ),
              _buildTextField(
                label: 'Gender',
                controller: genderController,
                hintText: 'Male/Female',
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter your gender';
                  if (!["Male", "Female"].contains(value)) return 'Enter "Male" or "Female" only';
                  return null;
                },
              ),
              // _buildTextField(
              //
              //   label: 'Date of Birth',
              //   controller: dobController,
              //   hintText: 'YYYY-MM-DD',
              //   textInputType: TextInputType.datetime,
              //   validator: (value) =>
              //   (value == null || value.isEmpty) ? 'Please enter your date of birth' : null,
              // ),
          _buildTextField(
            label: 'Date of Birth',
            controller: dobController,
            hintText: 'YYYY-MM-DD',
            textInputType: TextInputType.datetime,
            validator: (value) =>
            (value == null || value.isEmpty) ? 'Please enter your date of birth' : null,
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );

              if (pickedDate != null) {
                String formattedDate =
                    "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                dobController.text = formattedDate;
              }
            },
          ),
              SizedBox(height: 15,),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap:  () => _showStateSelection(context),

                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: birthPlaceController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Color(0xff0056D6)),
                            ),
                            labelText: 'Current State',
                            hintText: 'eg: West Bengal',
                            labelStyle: const TextStyle(
                              // color: Color(0xff0F3CC9),
                              color: Colors.black,

                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Current state is required';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap:()=> _showCitySelection(context),
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: cityController,
                          decoration: InputDecoration(
                            labelText: 'Current City',
                            hintText: 'eg: Kolkata',
                            labelStyle: const TextStyle(
                              // color: Color(0xff0F3CC9),
                              color: Colors.black87,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Color(0xff0056D6)),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Current city is required';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                     // backgroundColor: AppColors.primary,
                      backgroundColor: Color(0xFF163EC8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Sizes.radiusSm),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: Sizes.responsiveHorizontalSpace(context),
                        horizontal: Sizes.responsiveMdSm(context),
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // Handle Save logic
                        Map<String, dynamic> updatedUserDetails = {
                          'full_name': fullNameController.text.trim(),
                          'father_name': fatherFullNameController.text.trim(),
                          'gender': genderController.text.trim(),
                          'date_of_birth': dobController.text.trim(),
                          'current_state': birthPlaceController.text.trim(),
                          'current_city': chosencity,
                        };

                        // Save the updated details in SharedPreferences
                        final userId = await _sharedPreferencesService.getUserId();

                        final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                        await sharedPreferences.setString('userDetails', jsonEncode(updatedUserDetails));
                        // await Provider.of<UserProvider>(context, listen: false)
                        //     .updateUserDetails(userId!, updatedUserDetails);
                        bool isSuccess = await Provider.of<UserProvider>(context, listen: false)
                            .updateUserDetails(userId!, updatedUserDetails);
                        if (isSuccess) {
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   SnackBar(
                          //     content: Text("User details updated successfully!"),
                          //     backgroundColor: Colors.green,
                          //   ),
                          // );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileScreen(),
                            ),
                          );

                        } else {
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   SnackBar(
                          //     content: Text("Failed to update user details."),
                          //     backgroundColor: Colors.red,
                          //   ),
                          // );
                        }
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
    );
  }
}