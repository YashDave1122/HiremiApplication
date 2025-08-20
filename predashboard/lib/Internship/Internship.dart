//
// import 'package:flutter/material.dart';
// import 'package:pre_dashboard/Internship/Internship_provider.dart';
// import 'package:pre_dashboard/Internship/OpportunityCard.dart';
//
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class InternshipsScreen extends StatefulWidget {
//   const InternshipsScreen({Key? key}) : super(key: key);
//
//   @override
//   State<InternshipsScreen> createState() => _InternshipsScreenState();
// }
//
// class _InternshipsScreenState extends State<InternshipsScreen> with AutomaticKeepAliveClientMixin {
//   @override
//   bool get wantKeepAlive => true;
//
//   final TextEditingController _searchController = TextEditingController();
//   String searchQuery = '';
//
//   @override
//   void initState() {
//     super.initState();
//     _retrieveIdAndFetchData();
//     _loadSearchQuery();
//   }
//
//   Future<void> _retrieveIdAndFetchData() async {
//     final prefs = await SharedPreferences.getInstance();
//     final int? savedId = prefs.getInt('userId');
//     if (savedId != null) {
//       print("Saved id is $savedId");
//       final internshipProvider = Provider.of<InternshipProvider>(context, listen: false);
//       await internshipProvider.setUserId(savedId);
//       internshipProvider.fetchJobs();
//       internshipProvider.fetchApplications();
//     }
//   }
//
//   Future<void> _loadSearchQuery() async {
//     final prefs = await SharedPreferences.getInstance();
//     final savedQuery = prefs.getString('searchQuery') ?? '';
//     setState(() {
//       searchQuery = savedQuery;
//       _searchController.text = savedQuery;
//     });
//   }
//
//   Future<void> _saveSearchQuery(String query) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('searchQuery', query);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Internship Jobs',
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//       ),
//       body: Consumer<InternshipProvider>(
//         builder: (context, internshipProvider, child) {
//           if (internshipProvider.isLoading) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//           final jobs = internshipProvider.jobs;
//           final applications = internshipProvider.applications;
//           final appliedJobs = applications
//               .where((application) => application['register'] == internshipProvider.userId)
//               .map((application) => application['internship'])
//               .toSet();
//
//           final filteredJobs = jobs.where((job) {
//             final profile = job['profile']?.toString().toLowerCase() ?? '';
//             return profile.contains(searchQuery.toLowerCase());
//           }).toList();
//
//           if (jobs.isEmpty) {
//             return Center(
//               child: Column(
//                 children: [
//                   SizedBox(height: screenHeight * 0.03),
//                   Image.asset('assets/images/Team work-bro.png'),
//                   SizedBox(height: screenHeight * 0.01),
//                   const Text(
//                     'Hiremi’s Recruiters are planning for new jobs',
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
//                     textAlign: TextAlign.center,
//                   ),
//                   const Text(
//                     'please wait for few days',
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//               ),
//             );
//           }
//
//           return SingleChildScrollView(
//             child: Padding(
//               padding: EdgeInsets.all(screenWidth * 0.04), // 4% of screen width
//               child: Center(
//                 child: Column(
//                   children: [
//                     SizedBox(
//                       height: screenHeight * 0.03,
//                     ),
//                     _buildSearchBar(),
//                     SizedBox(
//                       height: screenHeight * 0.03,
//                     ),
//                     const Align(
//                       alignment: Alignment.centerLeft,
//                       child: Text(
//                         'Available Internship Jobs',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                         textAlign: TextAlign.left,
//                       ),
//                     ),
//                     SizedBox(
//                       height: screenHeight * 0.03,
//                     ),
//                     Column(
//                       children: filteredJobs.map<Widget>((job) {
//                         bool isApplied = appliedJobs.contains(job['id']);
//                         return Padding(
//                           padding: EdgeInsets.only(bottom: screenHeight * 0.03),
//                           child: OpportunityCard(
//                             id: job['id'],
//                             dp: const Icon(Icons.business, color: Colors.grey), // Placeholder image
//                             profile: job['profile'] ?? 'N/A',
//                             companyName: job['company_name'] ?? 'N/A',
//                             location: job['location'] ?? 'N/A',
//                             stipend: job['Stipend']?.toString() ?? 'N/A',
//                             mode: job['work_environment'],
//                             type: 'Internships',
//                             exp: job['years_experience_required'] ?? 0,
//                             daysPosted: DateTime.now().difference(DateTime.parse(job['upload_date'])).inDays,
//                             ctc: job['Stipend']?.toString() ?? '0',
//                             description: job['description'] ?? 'No description available',
//                             education: job['education'],
//                             skillsRequired: job['skills_required'],
//                             whoCanApply: job['who_can_apply'],
//                             isApplied: isApplied,
//                             fromExperiencedJobs: false,
//                             benefits: job['benifits'],
//                             CandidateStatus: "Actively Recruiting",
//                             whocanApply: job['who_can_apply'],
//                             aboutCompany: job["about_company"],
//                           ),
//                         );
//                       }).toList(),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildSearchBar() {
//     return TextField(
//       controller: _searchController,
//       onChanged: (value) {
//         _saveSearchQuery(value); // Save query on Enter
//         setState(() {
//           searchQuery = value;
//         });
//       },
//       decoration: InputDecoration(
//         hintText: 'Search jobs',
//         prefixIcon: const Icon(Icons.search),
//         filled: true,
//         fillColor: Colors.grey[200],
//         contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(30.0), // Curved edges
//           borderSide: BorderSide.none,
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:pre_dashboard/Internship/Internship_provider.dart';
import 'package:pre_dashboard/Internship/OpportunityCard.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InternshipsScreen extends StatefulWidget {
  const InternshipsScreen({Key? key}) : super(key: key);

  @override
  State<InternshipsScreen> createState() => _InternshipsScreenState();
}

class _InternshipsScreenState extends State<InternshipsScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';
  String selectedCategory = 'All'; // Default selected category

  final List<String> categories = [
    'All',
    'Product Management',
    'Software Development',
    'Operations',
    // Add more categories as needed
  ];

  @override
  void initState() {
    super.initState();
    _retrieveIdAndFetchData();
   // _loadSearchQuery();
  }

  Future<void> _retrieveIdAndFetchData() async {
    final prefs = await SharedPreferences.getInstance();
    final int? savedId = prefs.getInt('userId');
    if (savedId != null) {
      print("Saved id is $savedId");
      final internshipProvider = Provider.of<InternshipProvider>(context, listen: false);
      await internshipProvider.setUserId(savedId);
      internshipProvider.fetchJobs();
      internshipProvider.fetchApplications();
    }
  }

  Future<void> _loadSearchQuery() async {
    final prefs = await SharedPreferences.getInstance();
    final savedQuery = prefs.getString('searchQuery') ?? '';
    setState(() {
      searchQuery = savedQuery;
      _searchController.text = savedQuery;
    });
  }

  Future<void> _saveSearchQuery(String query) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('searchQuery', query);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Internship Jobs',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Consumer<InternshipProvider>(
        builder: (context, internshipProvider, child) {
          if (internshipProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final jobs = internshipProvider.jobs;
          final applications = internshipProvider.applications;
          final appliedJobs = applications
              .where((application) => application['register'] == internshipProvider.userId)
              .map((application) => application['internship'])
              .toSet();

          // Filter jobs by search query and category
          final filteredJobs = jobs.where((job) {
            final profile = job['profile']?.toString().toLowerCase() ?? '';
            final matchesSearch = profile.contains(searchQuery.toLowerCase());

            if (selectedCategory == 'All') {
              return matchesSearch;
            } else {
              final jobCategory = job['category']?.toString().toLowerCase() ?? '';
              return matchesSearch && jobCategory.contains(selectedCategory.toLowerCase());
            }
          }).toList();

          if (jobs.isEmpty) {
            return Center(
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.03),
                  Image.asset('assets/images/Team work-bro.png'),
                  SizedBox(height: screenHeight * 0.01),
                  const Text(
                    'Hiremi’s Recruiters are planning for new jobs',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
                    textAlign: TextAlign.center,
                  ),
                  const Text(
                    'please wait for few days',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.04), // 4% of screen width
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: screenHeight * 0.03,
                    ),
                    _buildSearchBar(),
                    SizedBox(
                      height: screenHeight * 0.03,
                    ),
                    _buildCategoryFilters(), // Add category filters
                    SizedBox(
                      height: screenHeight * 0.03,
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Available Internship Jobs',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.03,
                    ),
                    Column(
                      children: filteredJobs.map<Widget>((job) {
                        bool isApplied = appliedJobs.contains(job['id']);
                        return Padding(
                          padding: EdgeInsets.only(bottom: screenHeight * 0.03),
                          child: OpportunityCard(
                            id: job['id'],
                            dp: const Icon(Icons.business, color: Colors.grey), // Placeholder image
                            profile: job['profile'] ?? 'N/A',
                            companyName: job['company_name'] ?? 'N/A',
                            location: job['location'] ?? 'N/A',
                            stipend: job['Stipend']?.toString() ?? 'N/A',
                            mode: job['work_environment'],
                            type: 'Internships',
                            exp: job['years_experience_required'] ?? 0,
                            daysPosted: DateTime.now().difference(DateTime.parse(job['upload_date'])).inDays,
                            ctc: job['Stipend']?.toString() ?? '0',
                            description: job['description'] ?? 'No description available',
                            education: job['education'],
                            skillsRequired: job['skills_required'],
                            whoCanApply: job['who_can_apply'],
                            isApplied: isApplied,
                            fromExperiencedJobs: false,
                            benefits: job['benifits'],
                            CandidateStatus: "Actively Recruiting",
                            whocanApply: job['who_can_apply'],
                            aboutCompany: job["about_company"],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryFilters() {
    double size=MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) {
          final isSelected = category == selectedCategory;
          return Padding(
            padding:  EdgeInsets.symmetric(horizontal: size*0.01),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedCategory = category;
                });
              },
              child: Container(
                padding:  EdgeInsets.symmetric(horizontal: size*0.014, vertical:size*0.01),
                decoration: BoxDecoration(
                  color: isSelected ? Color(0xFF163EC8) : Colors.grey[200],
                  borderRadius: BorderRadius.circular(size*0.013),
                ),
                child: Text(
                  category,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      onChanged:(value) {
        //_saveSearchQuery(value); // Save query on Enter
        setState(() {
          searchQuery = value;
        });
      },
      decoration: InputDecoration(
        hintText: 'Search jobs',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.grey[200],
        contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0), // Curved edges
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
