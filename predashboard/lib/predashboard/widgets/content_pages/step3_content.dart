
  // import 'dart:convert';
  // import 'package:flutter/material.dart';
  // import 'package:shared_preferences/shared_preferences.dart';
  // import 'package:pre_dashboard/predashboard/DegreeAndBranches/DegreeAndBranches.dart';
  // import 'package:pre_dashboard/predashboard/StatesAndDistrict/StatesAndDistrict.dart';
  // import 'package:pre_dashboard/predashboard/widgets/custom_dropdown_field.dart';
  // import 'package:pre_dashboard/predashboard/widgets/custom_input_field.dart';
  // import 'package:pre_dashboard/predashboard/widgets/custom_text_field.dart';
  // import '../../constants/constants.dart';
  //
  // class Step3Content extends StatefulWidget {
  //   Step3Content({
  //     super.key,
  //     required this.formKey,
  //     required this.collegeNameController,
  //     required this.branchNameController,
  //     required this.courseNameController,
  //     required this.yearController,
  //     required this.stateControllerinEdu,
  //     required this.cityControllerinEdu,
  //   });
  //
  //   final GlobalKey<FormState> formKey;
  //   final TextEditingController collegeNameController;
  //   final TextEditingController branchNameController;
  //   final TextEditingController courseNameController;
  //   final TextEditingController yearController;
  //   final TextEditingController stateControllerinEdu;
  //   final TextEditingController cityControllerinEdu;
  //
  //   @override
  //   State<Step3Content> createState() => _Step3ContentState();
  // }
  //
  // class _Step3ContentState extends State<Step3Content> {
  //   String selectedCountry = 'India';
  //   String? selectedDegree;
  //   String? selectedBranch;
  //   String selectedState = 'Select State';
  //   String selectedCity = 'Select City';
  //   late SharedPreferences prefs;
  //
  //   @override
  //   void initState() {
  //     super.initState();
  //     _initPreferences();
  //     _setupControllerListeners();
  //   }
  //
  //   void _initPreferences() async {
  //     prefs = await SharedPreferences.getInstance();
  //     _loadSavedData();
  //   }
  //
  //   void _setupControllerListeners() {
  //     widget.collegeNameController.addListener(_saveFormData);
  //     widget.yearController.addListener(_saveFormData);
  //     widget.stateControllerinEdu.addListener(_saveFormData);
  //     widget.cityControllerinEdu.addListener(_saveFormData);
  //   }
  //
  //   Future<void> _saveFormData() async {
  //     await prefs.setString('collegeName', widget.collegeNameController.text);
  //     await prefs.setString('collegestate', selectedState);
  //     await prefs.setString('collegecity', selectedCity);
  //     await prefs.setString('degree', selectedDegree ?? '');
  //     await prefs.setString('branch', selectedBranch ?? '');
  //     await prefs.setString('year', widget.yearController.text);
  //   }
  //
  //   void _loadSavedData() {
  //     setState(() {
  //       widget.collegeNameController.text = prefs.getString('collegeName') ?? '';
  //       selectedState = prefs.getString('collegestate') ?? 'Select State';
  //       widget.stateControllerinEdu.text = selectedState;
  //       selectedCity = prefs.getString('collegecity') ?? 'Select City';
  //       widget.cityControllerinEdu.text = selectedCity;
  //       selectedDegree = prefs.getString('degree');
  //       // widget.branchNameController.text = selectedDegree ?? '';
  //       widget.branchNameController.text = prefs.getString('degree').toString();
  //
  //       selectedBranch = prefs.getString('branch');
  //       widget.courseNameController.text = selectedBranch ?? '';
  //       widget.yearController.text = prefs.getString('year') ?? '';
  //
  //       // Load cities for saved state
  //       if (selectedState != 'Select State') {
  //         List<String> districts = [];
  //         for (var stateMap in statesAndDistricts) {
  //           if (stateMap.containsKey(selectedState)) {
  //             districts = stateMap[selectedState]!;
  //             break;
  //           }
  //         }
  //         cities = ['Select City'] + districts;
  //       }
  //     });
  //     print("Selected Degree is $selectedDegree");
  //     print("Selected degree is ${widget.branchNameController.text}");
  //   }
  //
  //   List<String> cities = ['Select City'];
  //
  //   void _showStateSelection(BuildContext context) {
  //     List<String> states = statesAndDistricts.map((map) => map.keys.first).toList();
  //
  //     showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           title: Text('Select State'),
  //           content: SingleChildScrollView(
  //             child: Column(
  //               children: states.map((state) {
  //                 return ListTile(
  //                   title: Text(state),
  //                   onTap: () {
  //                     setState(() {
  //                       selectedState = state;
  //                       selectedCity = 'Select City';
  //                       widget.stateControllerinEdu.text = selectedState;
  //                       widget.cityControllerinEdu.clear();
  //                       _saveFormData();
  //                     });
  //                     Navigator.pop(context);
  //                   },
  //                 );
  //               }).toList(),
  //             ),
  //           ),
  //         );
  //       },
  //     );
  //   }
  //
  //   void _showCitySelection(BuildContext context) {
  //     List<String> districts = [];
  //     for (var stateMap in statesAndDistricts) {
  //       if (stateMap.containsKey(selectedState)) {
  //         districts = stateMap[selectedState]!;
  //         break;
  //       }
  //     }
  //
  //     showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           title: Text('Select District'),
  //           content: SingleChildScrollView(
  //             child: Column(
  //               children: districts.map((district) {
  //                 return ListTile(
  //                   title: Text(district),
  //                   onTap: () {
  //                     setState(() {
  //                       selectedCity = district;
  //                       widget.cityControllerinEdu.text = selectedCity;
  //                       _saveFormData();
  //                     });
  //                     Navigator.pop(context);
  //                   },
  //                 );
  //               }).toList(),
  //             ),
  //           ),
  //         );
  //       },
  //     );
  //   }
  //
  //   @override
  //   Widget build(BuildContext context) {
  //     final screenWidth = MediaQuery.of(context).size.width;
  //     return SingleChildScrollView(
  //       child: Padding(
  //         padding: EdgeInsets.only(top: screenWidth * 0.05),
  //         child: Form(
  //           key: widget.formKey,
  //           child: Column(
  //             children: [
  //               CustomInputField(
  //                 controller: widget.collegeNameController,
  //                 label: "College Name",
  //                 validator: (value) {
  //                   if (value == null || value.isEmpty) {
  //                     return 'Please enter college name';
  //                   }
  //                   return null;
  //                 },
  //               ),
  //               Row(
  //                 children: [
  //                   Expanded(
  //                     child: GestureDetector(
  //                       onTap: () => _showStateSelection(context),
  //                       child: AbsorbPointer(
  //                         child: CustomTextField(
  //                           controller: widget.stateControllerinEdu,
  //                           hintText: 'Select State',
  //                           isDropdown: false,
  //                           value: selectedState,
  //                           labelText: 'College State',
  //                           validator: (value) {
  //                             if (value == null || value.isEmpty || value == 'Select State') {
  //                               return 'Please select a state';
  //                             }
  //                             return null;
  //                           },
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                   SizedBox(width: 10),
  //                   Expanded(
  //                     child: GestureDetector(
  //                       onTap: () {
  //                         if (selectedState != 'Select State') {
  //                           _showCitySelection(context);
  //                         }
  //                       },
  //                       child: AbsorbPointer(
  //                         child: CustomTextField(
  //                           controller: widget.cityControllerinEdu,
  //                           hintText: 'Select District',
  //                           isDropdown: false,
  //                           value: selectedCity,
  //                           labelText: 'District',
  //                           validator: (value) {
  //                             if (value == null || value.isEmpty || value == 'Select City') {
  //                               return 'Please select a District';
  //                             }
  //                             return null;
  //                           },
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               CustomDropdownField(
  //                 controller: widget.branchNameController,
  //                 items: degreeBranches.keys.toList(),
  //                 label: "Select Degree",
  //                 value: selectedDegree,
  //                 onDropdownChanged: (value) {
  //                   setState(() {
  //                     selectedDegree = value;
  //                     widget.branchNameController.text = value!;
  //                     selectedBranch = null;
  //                     widget.courseNameController.text = '';
  //                     _saveFormData();
  //                   });
  //                 },
  //                 validator: (value) {
  //                   if (value == null || value.isEmpty) {
  //                     return 'Please specify your Degree';
  //                   }
  //                   return null;
  //                 },
  //               ),
  //               CustomDropdownField(
  //                 key: ValueKey(selectedDegree),
  //                 controller: widget.courseNameController,
  //                 items: degreeBranches[selectedDegree]?.toSet().toList() ?? [],
  //                 label: "Select Branch",
  //                 value: selectedBranch,
  //                 onDropdownChanged: (value) {
  //                   setState(() {
  //                     selectedBranch = value;
  //                     widget.courseNameController.text = value!;
  //                     _saveFormData();
  //                   });
  //                 },
  //                 validator: (value) {
  //                   if (value == null || value.isEmpty) {
  //                     return 'Please select a branch';
  //                   }
  //                   return null;
  //                 },
  //               ),
  //               CustomInputField(
  //                 label: "Enter Passing Year",
  //                 controller: widget.yearController,
  //                 isDropdown: true,
  //                 dropdownItems: List.generate(33, (index) => 2000 + index),
  //                 dropdownValidator: (value) {
  //                   if (value == null) {
  //                     return 'Please select a year';
  //                   }
  //                   return null;
  //                 },
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     );
  //   }
  // }
  import 'dart:async';
import 'dart:convert';
  import 'package:flutter/material.dart';
import 'package:pre_dashboard/API.dart';
  import 'package:http/http.dart' as http;

  import 'package:shared_preferences/shared_preferences.dart';
  import 'package:pre_dashboard/predashboard/DegreeAndBranches/DegreeAndBranches.dart';
  import 'package:pre_dashboard/predashboard/StatesAndDistrict/StatesAndDistrict.dart';
  import 'package:pre_dashboard/predashboard/widgets/custom_dropdown_field.dart';
  import 'package:pre_dashboard/predashboard/widgets/custom_input_field.dart';
  import 'package:pre_dashboard/predashboard/widgets/custom_text_field.dart';
  import '../../constants/constants.dart';

  class Step3Content extends StatefulWidget {
    Step3Content({
      super.key,
      required this.formKey,
      required this.collegeNameController,
      required this.branchNameController,
      required this.courseNameController,
      required this.yearController,
      required this.stateControllerinEdu,
      required this.cityControllerinEdu,
      required this.chosencityforcollege,
      required this.citiesID,
      required this.onCityIdChanged,
    });

    final GlobalKey<FormState> formKey;
    final TextEditingController collegeNameController;
    final TextEditingController branchNameController;
    final TextEditingController courseNameController;
    final TextEditingController yearController;
    final TextEditingController stateControllerinEdu;
    final TextEditingController cityControllerinEdu;
    final ValueChanged<int> onCityIdChanged;
    int chosencityforcollege=0;
    final List<int> citiesID; // ✅ Change this to List<int>

    @override
    State<Step3Content> createState() => _Step3ContentState();
  }

  class _Step3ContentState extends State<Step3Content> {
    List<String> citiesList = [];
    List<String> statesList = [];
    List<int> citiesID = [];


    bool isLoading = true;
    String selectedCountry = 'India';
    String? selectedDegree;
    int chosencityforcollege = 0;
    String? selectedBranch;
    String selectedState = 'Select State';
    String selectedCity = 'Select City';
    late SharedPreferences prefs;
    bool _isLoading = true; // Track loading state

    @override
    void initState() {
      super.initState();
      _initPreferences();
      _setupControllerListeners();
    }

    void _initPreferences() async {
      prefs = await SharedPreferences.getInstance();
      await _loadSavedData();
      setState(() {
        _isLoading = false; // Data loaded, stop loading
      });
    }


    void _setupControllerListeners() {
      widget.collegeNameController.addListener(_saveFormData);
      widget.yearController.addListener(_saveFormData);
      widget.stateControllerinEdu.addListener(_saveFormData);
      widget.cityControllerinEdu.addListener(_saveFormData);
    }

    Future<void> _saveFormData() async {
      await prefs.setString('collegeName', widget.collegeNameController.text);
      await prefs.setString('collegestate', selectedState);
      await prefs.setString('collegecity', selectedCity);
      await prefs.setString('degree', selectedDegree ?? '');
      await prefs.setString('branch', selectedBranch ?? '');
      await prefs.setString('year', widget.yearController.text);
    }

    Future<void> _loadSavedData() async {
      setState(() {
        widget.collegeNameController.text = prefs.getString('collegeName') ?? '';
        selectedState = prefs.getString('collegestate') ?? 'Select State';
        widget.stateControllerinEdu.text = selectedState;
        selectedCity = prefs.getString('collegecity') ?? 'Select City';
        widget.cityControllerinEdu.text = selectedCity;
        selectedDegree = prefs.getString('degree');
        widget.branchNameController.text = selectedDegree ?? '';
        selectedBranch = prefs.getString('branch');
        widget.courseNameController.text = selectedBranch ?? '';
        widget.yearController.text = prefs.getString('year') ?? '';

        // Load cities for saved state
        if (selectedState != 'Select State') {
          List<String> districts = [];
          for (var stateMap in statesAndDistricts) {
            if (stateMap.containsKey(selectedState)) {
              districts = stateMap[selectedState]!;
              break;
            }
          }
          cities = ['Select City'] + districts;
        }
      });
      final savedCityId = prefs.getInt('cityIdforCollege') ?? 0;
      if (savedCityId != 0) {
        widget.onCityIdChanged(savedCityId);
      }
      print("Selected Degree is $selectedDegree");
      print("Selected degree is ${widget.branchNameController.text}");
    }

    List<String> cities = ['Select City'];
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
                      widget.stateControllerinEdu.text = selectedState; // Update state controller
                      widget.cityControllerinEdu.clear();  // Clear the city controller text

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
                      widget.cityControllerinEdu.text = selectedCity;
                      chosencityforcollege=citiesID[index];
                      print("Chosend city is ${chosencityforcollege}");
                    });
                    await prefs.setInt('cityIdforCollege', citiesID[index]);
                    widget.onCityIdChanged(citiesID[index]);
                    Navigator.pop(context); // Close modal after selection
                  },
                );
              },
            ),
          );
        },
      );
    }

    // void _showCitySelection(BuildContext context) {
    //   List<String> districts = [];
    //   for (var stateMap in statesAndDistricts) {
    //     if (stateMap.containsKey(selectedState)) {
    //       districts = stateMap[selectedState]!;
    //       break;
    //     }
    //   }
    //
    //   showDialog(
    //     context: context,
    //     builder: (context) {
    //       return AlertDialog(
    //         title: Text('Select District'),
    //         content: SingleChildScrollView(
    //           child: Column(
    //             children: districts.map((district) {
    //               return ListTile(
    //                 title: Text(district),
    //                 onTap: () {
    //                   setState(() {
    //                     selectedCity = district;
    //                     widget.cityControllerinEdu.text = selectedCity;
    //                     _saveFormData();
    //                   });
    //                   Navigator.pop(context);
    //                 },
    //               );
    //             }).toList(),
    //           ),
    //         ),
    //       );
    //     },
    //   );
    // }

    @override
    Widget build(BuildContext context) {
      final screenWidth = MediaQuery.of(context).size.width;

      // Show a loading indicator while data is being loaded
      if (_isLoading) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }

      return SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: screenWidth * 0.05),
          child: Form(
            key: widget.formKey,
            child: Column(
              children: [
                CustomInputField(
                  controller: widget.collegeNameController,
                  label: "College Name",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter college name';
                    }
                    return null;
                  },
                ),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _showStateSelection(context),
                        child: AbsorbPointer(
                          child: CustomTextField(
                            controller: widget.stateControllerinEdu,
                            hintText: 'Select State',
                            isDropdown: false,
                            value: selectedState,
                            labelText: 'College State',
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
                    SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (selectedState != 'Select State') {
                            _showCitySelection(context);
                          }
                        },
                        child: AbsorbPointer(
                          child: CustomTextField(
                            controller: widget.cityControllerinEdu,
                            hintText: 'Select District',
                            isDropdown: false,
                            value: selectedCity,
                            labelText: 'District',
                            validator: (value) {
                              if (value == null || value.isEmpty || value == 'Select City') {
                                return 'Please select a District';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                CustomDropdownField(
                  controller: widget.branchNameController,
                  items: degreeBranches.keys.toList(),
                  label: "Select Degree",
                  value: selectedDegree,
                  onDropdownChanged: (value) {
                    setState(() {
                      selectedDegree = value;
                      widget.branchNameController.text = value!;
                      selectedBranch = null;
                      widget.courseNameController.text = '';
                      _saveFormData();
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please specify your Degree';
                    }
                    return null;
                  },
                ),
                CustomDropdownField(
                  key: ValueKey(selectedDegree),
                  controller: widget.courseNameController,
                  items: degreeBranches[selectedDegree]?.toSet().toList() ?? [],
                  label: "Select Branch",
                  value: selectedBranch,
                  onDropdownChanged: (value) {
                    setState(() {
                      selectedBranch = value;
                      widget.courseNameController.text = value!;
                      _saveFormData();
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a branch';
                    }
                    return null;
                  },
                ),
                CustomInputField(
                  label: "Enter Passing Year",
                  controller: widget.yearController,
                  isDropdown: true,
                  dropdownItems: List.generate(33, (index) => 2000 + index),
                  dropdownValidator: (value) {
                    if (value == null) {
                      return 'Please select a year';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      );
    }
  }