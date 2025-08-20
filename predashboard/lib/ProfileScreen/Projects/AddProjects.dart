import 'package:flutter/material.dart';
import 'package:pre_dashboard/AppSizes/AppSizes.dart';
import 'package:pre_dashboard/HomePage/constants/constantsColor.dart';
import 'package:pre_dashboard/ProfileScreen/Profile_screen.dart';
import 'package:pre_dashboard/ProfileScreen/Projects/TextFeildWithTitle.dart';
import 'package:pre_dashboard/ProfileScreen/Projects/apiServices.dart';
import 'package:pre_dashboard/shared_preferences_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AddProjects extends StatefulWidget {
  const AddProjects({Key? key}) : super(key: key);

  @override
  _AddProjectsState createState() => _AddProjectsState();
}

class _AddProjectsState extends State<AddProjects> {
  final titleController = TextEditingController();
  final clientController = TextEditingController();
  final projectLinkController = TextEditingController();
  final startingDateController = TextEditingController();
  final completionDateController = TextEditingController();
  final descriptionController = TextEditingController();
  String? projectStatus;
  final _formKey = GlobalKey<FormState>();
  final AddProjectDetailsService _apiService = AddProjectDetailsService();
  int? profileId;

  @override
  void initState() {
    super.initState();
    _loadProjectDetails();
  }

  Future<void> _loadProjectDetails() async {
    // final prefs = await SharedPreferences.getInstance();
    // profileId = prefs.getInt('profileId');
     profileId = await SharedPreferencesHelper.getProfileId();

    final project = await _apiService.getProjectDetails();
    print("Projects details areeeee $project");
    print("profile id is $profileId in _loadProjectDetails");
    setState(() {
      // titleController.text = project['project_title'] ?? '';
      // clientController.text = project['client'] ?? '';
      // projectLinkController.text = project['link'] ?? '';
      // startingDateController.text = project['start_date'] ?? '';
      // completionDateController.text = project['end_date'] ?? "null";
      // descriptionController.text = project['description'] ?? '';
      // projectStatus = project['status'] ?? '';
      titleController.text = project['name'] ?? '';
      clientController.text = project['client'] ?? '';
      projectLinkController.text = project['link'] ?? '';
      startingDateController.text = project['start_date'] ?? '';
      completionDateController.text = project['end_date'] ?? "null";
      descriptionController.text = project['description'] ?? '';
      projectStatus = project['status'] ?? '';
    });
  }


  Future<bool> _saveProject() async {
    if (_formKey.currentState!.validate()) {
      // Create a map with all the project details
      final Map<String, String?> details = {
        // 'project_title': titleController.text,
        // 'client': clientController.text,
        // 'link': projectLinkController.text,
        // 'start_date': startingDateController.text,
        // 'description': descriptionController.text,
        // 'status': projectStatus,
        'name': titleController.text,

        'link': projectLinkController.text,

        'description': descriptionController.text,
        'user':profileId.toString(),

      };

      // If the project is not ongoing, add the end_date to the map


      // Remove any key-value pairs where the value is null
      final cleanedDetails = <String, String>{};
      details.forEach((key, value) {
        if (value != null && value.isNotEmpty) {
          cleanedDetails[key] = value;
        }
      });

      if (profileId != null) {
        print("Profile id is $profileId");
        final success = await _apiService.addOrUpdateProjectDetails(cleanedDetails, profileId!);
        if (success) {
          Navigator.pop(context, true);
          return true;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to save project details')),
          );
        }
      }

      else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile ID not found')),
        );
      }
    }
    return false;
  }


  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          startingDateController.text = picked.toIso8601String().split('T').first;
        } else {
          completionDateController.text = picked.toIso8601String().split('T').first;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Add Project'),
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                const Text(
                  'Projects',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: Sizes.responsiveMd(context)),
                Row(
                  children: [
                    Expanded(
                      child: TextFieldWithTitle(
                        controller: titleController,
                        title: 'Project Title',
                        hintText: 'eg: Project Title',
                        // validator: (value) {
                        //   final characterRegex = RegExp(r'^[a-zA-Z\s]+$');  // Regular expression for only letters and spaces
                        //
                        //   if (value == null || value.isEmpty) {
                        //     return 'Project Title is required';
                        //   } else if (!characterRegex.hasMatch(value)) {
                        //     return 'Only letters are allowed';
                        //   }
                        //
                        //   return null;
                        // },

                      ),
                    ),
                    // SizedBox(width: Sizes.responsiveMd(context)),
                    // Expanded(
                    //   child: TextFieldWithTitle(
                    //     controller: clientController,
                    //     title: 'Client',
                    //     hintText: 'eg: Organisation or Client etc.',
                    //     validator: (value) {
                    //       final characterRegex = RegExp(r'^[a-zA-Z\s]+$');  // Regular expression for only letters and spaces
                    //
                    //       if (value == null || value.isEmpty) {
                    //         return 'Client is required';
                    //       } else if (!characterRegex.hasMatch(value)) {
                    //         return 'Only letters are allowed';
                    //       }
                    //
                    //       return null;
                    //     },
                    //   ),
                    // ),
                  ],
                ),
                SizedBox(height: Sizes.responsiveMd(context)),
                TextFieldWithTitle(
                  controller: projectLinkController,
                  title: 'Add Project Link',
                  maxLines: 1,
                  hintText: 'eg: paste project link here.',
                  // validator: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     return 'Project Link is required';
                  //   }
                  //   return null;
                  // },
                ),
                SizedBox(height: Sizes.responsiveMd(context)),

                SizedBox(height: Sizes.responsiveMd(context)),
                TextFieldWithTitle(
                  title: 'Project Description',
                  hintText: 'Tell us about your project...',
                  controller: descriptionController,
                  spaceBtwTextField: Sizes.responsiveMd(context),
                  maxLines: 3,
                  // validator: (value) {
                  //   final emojiRegex = RegExp(
                  //       r'[\u{1F600}-\u{1F64F}]|' // Emoticons
                  //       r'[\u{1F300}-\u{1F5FF}]|' // Misc Symbols and Pictographs
                  //       r'[\u{1F680}-\u{1F6FF}]|' // Transport and Map
                  //       r'[\u{1F700}-\u{1F77F}]|' // Alchemical Symbols
                  //       r'[\u{1F780}-\u{1F7FF}]|' // Geometric Shapes Extended
                  //       r'[\u{1F800}-\u{1F8FF}]|' // Supplemental Arrows-C
                  //       r'[\u{1F900}-\u{1F9FF}]|' // Supplemental Symbols and Pictographs
                  //       r'[\u{1FA00}-\u{1FA6F}]|' // Chess Symbols
                  //       r'[\u{1FA70}-\u{1FAFF}]|' // Symbols and Pictographs Extended-A
                  //       r'[\u{2600}-\u{26FF}]',    // Misc symbols like sun, moon
                  //       unicode: true
                  //   );
                  //   if (value == null || value.isEmpty) {
                  //     return 'Project Description is required';
                  //   }
                  //   else if (emojiRegex.hasMatch(value)) {
                  //     return 'Emojis are not allowed';
                  //   }
                  //   // else if (!characterRegex.hasMatch(value)) {
                  //   //   return 'Only letters are allowed';// }
                  //   return null;
                  // },
                ),
                SizedBox(height: Sizes.responsiveMd(context) * 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(onPressed: (){
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) =>  ProfileScreen()),
                      );
                    }, child: Text("profile")),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          // backgroundColor: AppColors.primary,
                          backgroundColor: Color(0xFF163EC8),

                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(Sizes.radiusSm)),
                          padding: EdgeInsets.symmetric(
                              vertical: Sizes.responsiveHorizontalSpace(context),
                              horizontal: Sizes.responsiveMdSm(context)),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _saveProject();
                          }
                        },


                        child: const Text(
                          'Save',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.white,
                          ),
                        )),

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
