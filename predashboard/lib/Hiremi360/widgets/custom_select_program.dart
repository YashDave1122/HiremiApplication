import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pre_dashboard/API.dart';
import 'package:pre_dashboard/Hiremi360/Services/TrainingServices.dart';
import 'package:pre_dashboard/Hiremi360/screens/training_and_description.dart';
import 'package:pre_dashboard/SharedPreferences/SharedPreferences.dart';

class CustomSelectProgram extends StatefulWidget {
  const CustomSelectProgram({super.key});

  @override
  State<CustomSelectProgram> createState() => _CustomSelectProgramState();
}

class _CustomSelectProgramState extends State<CustomSelectProgram> {
  Map<int, String> uniqueIdsMap  = {};
  final List<String> courses = [
    // "Frontend Developer | 3 months",
    // "Ui UX Designer | 3 months",
    // "Flutter Developer | 3 months",
    // "Backend Developer | 3 months",
  ];

  String selectedCourse = '';
  String userId = "";
  List<dynamic> trainingPrograms = [];
  List<dynamic> userApplications = [];
  final TrainingService trainingService = TrainingService();
  final SharedPreferencesService _sharedPreferencesService = SharedPreferencesService();

  @override
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _retrieveIdAndFetchData();
    _initializeData();

  }
  Future<void> _retrieveIdAndFetchData() async {

    final savedId = await _sharedPreferencesService.getUserId();

    if (savedId != null) {
      print("Retrieved ID is $savedId");

      // final url = Uri.parse('http://13.127.246.196:8000/api/training-applications/');
      final url = Uri.parse('${ApiUrls.trainingApplication}');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        print("Status code is ${response.statusCode}");
        print("Status body is ${response.body}");

        final List<dynamic> data = json.decode(response.body);

        for (var item in data) {
          if (item['register'] == savedId) { // Check if the register ID matches the saved user ID
            uniqueIdsMap[item['TrainingProgram']] = item['unique_id'];
          }
        }
      } else {
        print('Failed to load data from the API. Status code: ${response.statusCode}');
      }
    } else {
      print("No ID found in SharedPreferences");
    }
  }

  Future<void> _initializeData() async {
    userId = await trainingService.retrieveId() ?? '';
    // userId = await _sharedPreferencesService.getUserId();
    userApplications = await trainingService.fetchUserApplications();
    trainingPrograms = await trainingService.fetchTrainingPrograms();
    courses.clear();
    for (var program in trainingPrograms) {

      courses.add("${program['training_program']} | ${program['duration']}");
    }

    setState(() {}); // Update the UI after fetching data
  }


  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: courses.length,

        itemBuilder: (context, index) {
          var program = trainingPrograms[index];
          int trainingProgramId = program['id']; // Training program ID
          bool isApplied = uniqueIdsMap.containsKey(trainingProgramId); // Check if applied
          return Padding(
            padding:  EdgeInsets.only(bottom:size.width*0.1),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedCourse = courses[index];
                });
              },
              child: InkWell(
                onTap: (){
               if(!isApplied){
                 Navigator.push(
                   context,
                   MaterialPageRoute(
                     builder: (context) => Trainingandinternshipdescription(
                       // program: program
                         program: trainingPrograms[index]
                     ),
                   ),
                 );
               }
                },
                child: Container(
                  height: size.height * 0.11,
                  width: size.width * 0.92,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: !(selectedCourse == courses[index])
                        ? Border.all(color: Color(0xFFC1272D), width: 1)
                        : Border(
                            left: BorderSide(color: Color(0xFFC1272D), width: 4),
                            top: BorderSide(color: Color(0xFFC1272D), width: 2),
                            right: BorderSide(color: Color(0xFFC1272D), width: 2),
                            bottom:
                                BorderSide(color: Color(0xFFC1272D), width: 2)),
                  ),
                  child: Padding(
                    padding:  EdgeInsets.symmetric(
                        horizontal: size.height*0.02, vertical:size.height*0.01),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: size.height * 0.029,
                      children: [
                        Text(
                          courses[index],
                          style: TextStyle(
                              fontSize: size.width * 0.037,
                              fontWeight: FontWeight.bold),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            RichText(
                              text: TextSpan(
                                text: '₹${program['discounted_price']} ',
                                style: TextStyle(
                                  fontSize: size.width * 0.035,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text: " ₹${program['original_price']}",
                                    style: TextStyle(
                                      fontSize: size.width * 0.022,
                                      color: Colors.black54,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // SizedBox(width: size.width*0.4,),
                            if (uniqueIdsMap.containsKey(trainingPrograms[index]['id'])) // Check if user has applied
                              Text(
                                "Applied",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: size.width * 0.035,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                          ],
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
