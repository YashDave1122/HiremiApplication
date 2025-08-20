
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pre_dashboard/API.dart';
import 'package:pre_dashboard/Non_verified_changes/Provider/UserProfileProvider.dart';
import 'package:pre_dashboard/SharedPreferences/SharedPreferences.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;



class CustomFormWidget1 extends StatefulWidget {
  final Function(bool, int) onComplete;

  const CustomFormWidget1({super.key, required this.onComplete});

  @override
  State<CustomFormWidget1> createState() => _CustomFormWidgetState();
}

class _CustomFormWidgetState extends State<CustomFormWidget1> {
  // final SharedPreferencesService _prefsService = SharedPreferencesService();
  final SharedPreferencesService _sharedPreferencesService = SharedPreferencesService();

  // bool _isformCompleted = false;
  bool showErrorMessage = false; // Flag to show error message
  List<String> statesList = [];
  List<String> citiesList = [];
  List<int> citiesID = [];
  int chosencity = 0;
  bool isLoading = true;
  String selectedState = 'Select State';
  String selectedCity = 'Select District';
  final _birthStateController = TextEditingController();
  final _birthCityController = TextEditingController();
  final _pincodeController = TextEditingController();
  FocusNode _pincodeFocusNode = FocusNode();
  bool isDifferentlyAbled = false;
  Map<String, dynamic>? userData; // Variable to hold fetched user data

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
                    _birthStateController.text = selectedState; // Update state controller
                    _birthCityController.clear();  // Clear the city controller text

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
                    _birthCityController.text = selectedCity;
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


  Future<void> _validateFields(UserProfileProvider userProvider) async {
    // print("Chosen city is $chosencity");
    // chosencity=1;
    // final prefs = await SharedPreferences.getInstance();
    // setState(() {
    //   chosencity = prefs.getInt('birthcityId') ?? 0; // Default to 0 if not found
    // });
    if (_birthStateController.text.isNotEmpty &&
        _birthCityController.text.isNotEmpty &&
        _pincodeController.text.isNotEmpty) {
      try {
        final userId = await _sharedPreferencesService.getUserId();
        print("Userid is $userId");
        final existingData = userProvider.userData;

        Map<String, dynamic> userData = {
          "birth_state": _birthStateController.text,
          "birth_city": chosencity,
          "is_differently_abled": isDifferentlyAbled,
          "current_pincode": _pincodeController.text,
          "register": userId.toString(),
        };

        // Determine which id to use for patching
        final int patchId = (existingData.isNotEmpty && existingData['id'] != null)
            ? existingData['id']
            : userId!; // Using userId as a fallback

        await userProvider.patchUserData(patchId, userData);

        widget.onComplete(true, 1); // Notify completion with success
        setState(() {
          showErrorMessage = false; // Hide error message on success
        });
      } catch (error) {
        print("Error updating user data: $error");
        setState(() {
          showErrorMessage = true; // Show error message on failure
        });
      }
    }
    else {

      widget.onComplete(true, 0); // Notify incomplete fields
      setState(() {
        showErrorMessage = true; // Show error message
      });
    }
  }









  @override
  void initState() {
    super.initState();
    _pincodeFocusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userProfileProvider = context.read<UserProfileProvider>();
      final sharedPreferencesService = SharedPreferencesService();


      String? email = await sharedPreferencesService.getUserEmail();
      String? password = await sharedPreferencesService.getUserPassword();

      if (email != null && password != null) {
        String? token = await userProfileProvider.loginUser(email, password); // Log in with saved credentials

        if (token != null) {
          print("Token is $token");
          userProfileProvider.fetchUserData(token).then((data) {
            setState(() {
              userData = data;
              int? cityId = userData!['birth_city_id'];
              chosencity=userData!['birth_city_id'];
              _birthStateController.text = userData!['birth_state'] ?? '';
              _birthCityController.text = userData!['birth_city'] ?? '';
              _pincodeController.text = userData!['current_pincode'] ?? '';
              isDifferentlyAbled = userData!['is_differently_abled'] ;
              print("🔵 Birth city ID in initState: $cityId");
            });
            print("Birth citutytytyty is${userData!['birth_city']}");
            print("Birth Sate is ${_birthStateController.text}");
            print("Birth city is ${_birthCityController.text}");
            print("Pincode is ${_pincodeController.text}");
            print("Differently abled is $isDifferentlyAbled");

            print("User data is ${userData!['birth_city']}");
          }).catchError((error) {
            print("Error in custom from widget 1 $error");
          });
        }
        else
        {
          print("Failed to log in");
        }
      }
      else {
        print("No saved credentials found in SharedPreferences.");
      }
    });
  }



  FocusNode focusNode = FocusNode();

  @override
  void dispose() {
    _pincodeFocusNode.dispose();
    _birthStateController.dispose();
    _birthCityController.dispose();
    _pincodeController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProfileProvider>(context);
    final formKey = GlobalKey<FormState>();
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
          child: Form(
            key: formKey,
            child: ListView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Personal Information',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff0F3CC9),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap:  () => _showStateSelection(context),

                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: _birthStateController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: Color(0xff0056D6)),
                              ),
                              labelText: 'Birth State',
                              hintText: 'eg: West Bengal',
                              labelStyle: const TextStyle(
                                color: Color(0xff0F3CC9),
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
                            controller: _birthCityController,
                            decoration: InputDecoration(
                              labelText: 'Birth City',
                              hintText: 'eg: Kolkata',
                              labelStyle: const TextStyle(
                                color: Color(0xff0F3CC9),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: Color(0xff0056D6)),
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
                const SizedBox(height: 16),


                Row(
                  children: [
                    Expanded(
                      child: InputDecorator(
                        decoration: _inputDecoration('Are you differently abled?'),
                        child: SwitchListTile(
                          title: Text(isDifferentlyAbled ? 'Yes' : 'No'),
                          value: isDifferentlyAbled,
                          onChanged: (value) {
                            setState(() {
                              isDifferentlyAbled = value;
                            });
                          },
                          activeColor: Colors.blue,
                        ),
                      ),
                    ),



                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _pincodeController,
                        keyboardType: TextInputType.number,
                        decoration: _inputDecoration('Current Pincode'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter a pincode';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Error Message
                Visibility(
                  visible: showErrorMessage,
                  child: Padding(
                    padding: EdgeInsets.all(size.height * 0.01),
                    child: Text(
                      'Required fields are incomplete.\nFill them out to move forward.',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: size.height * 0.015,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  // onPressed:() => _validateFields(userProvider),
                  onPressed: (){
                    if (formKey.currentState!.validate()) {
                      // All fields are valid; proceed with form submission
                      _validateFields(userProvider);
                    } else {
                      // Show error messages for invalid fields
                      setState(() {
                        showErrorMessage = true;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff0F3CC9),
                    minimumSize: Size(size.width * 0.7, size.height * 0.06),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        color: Color(0xff0F3CC9),
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xff0056D6)),
      ),
    );
  }
}






