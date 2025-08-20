//
// import 'package:flutter/material.dart';
// import 'package:pre_dashboard/FresherJobs/OpportunityCard.dart';
// import 'package:pre_dashboard/FresherJobs/fresherJobProvider.dart';
// import 'package:provider/provider.dart';
//
// class FresherJobs extends StatefulWidget {
//   const FresherJobs({Key? key, required this.isVerified}) : super(key: key);
//   final bool isVerified;
//
//   @override
//   State<FresherJobs> createState() => _FresherJobsState();
// }
//
// class _FresherJobsState extends State<FresherJobs> {
//   final TextEditingController _searchController = TextEditingController();
//   String searchQuery = '';
//   String selectedCategory = 'All'; // Default selected category
//   bool _isLoading = true;
//   final List<String> categories = [
//     'All',
//     'Product Management',
//     'Software Development',
//     'Operations',
//     // Add more categories as needed
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     final jobsProvider = Provider.of<JobsProvider>(context, listen: false);
//     jobsProvider.retrieveId();
//     jobsProvider.fetchJobs().then((_) {
//       setState(() {
//         _isLoading = false;
//       });
//     });
//     jobsProvider.fetchApplications();
//   }
//
//   List _getFilteredJobs(JobsProvider jobsProvider) {
//     return jobsProvider.jobs.where((job) {
//       final matchesCategory = selectedCategory == 'All' ||
//           job['category']?.toString().toLowerCase() ==
//               selectedCategory.toLowerCase();
//       final matchesSearch = job['profile']
//           ?.toString()
//           .toLowerCase()
//           .contains(searchQuery.toLowerCase()) ??
//           false;
//       return matchesCategory && matchesSearch;
//     }).toList();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final jobsProvider = Provider.of<JobsProvider>(context);
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//     final filteredJobs = _getFilteredJobs(jobsProvider);
//
//
//     return  Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Fresher Jobs',
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//       ),
//       body: Consumer<JobsProvider>(
//         builder: (context, fresherJobsProvider, child) {
//           if (fresherJobsProvider.isLoading) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//           final jobs = fresherJobsProvider.jobs;
//           final applications = fresherJobsProvider.applications;
//           final appliedJobs = applications
//               .where((application) => application['register'] == fresherJobsProvider.userId)
//               .map((application) => application['job'])
//               .toSet();
//
//           // Filter jobs by search query and category
//           final filteredJobs = jobs.where((job) {
//             final profile = job['profile']?.toString().toLowerCase() ?? '';
//             final matchesSearch = profile.contains(searchQuery.toLowerCase());
//
//             if (selectedCategory == 'All') {
//               return matchesSearch;
//             } else {
//               final jobCategory = job['category']?.toString().toLowerCase() ?? '';
//               return matchesSearch && jobCategory.contains(selectedCategory.toLowerCase());
//             }
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
//                     _buildCategoryFilters(), // Add category filters
//                     SizedBox(
//                       height: screenHeight * 0.03,
//                     ),
//                     const Align(
//                       alignment: Alignment.centerLeft,
//                       child: Text(
//                         'Available Fresher Jobs',
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
//                             dp: const Icon(Icons.work_outline, color: Colors.grey), // Placeholder image
//                             profile: job['profile'] ?? 'N/A',
//                             companyName: job['company_name'] ?? 'N/A',
//                             location: job['location'] ?? 'N/A',
//                             stipend: job['Stipend']?.toString() ?? 'N/A',
//                             mode: job['work_environment'],
//                             type: 'Fresher Jobs',
//                             exp: job['years_experience_required'] ?? 0,
//                             daysPosted: DateTime.now().difference(DateTime.parse(job['upload_date'])).inDays,
//                             ctc: job['Stipend']?.toString() ?? '0',
//                             description: job['description'] ?? 'No description available',
//                             education: job['education'],
//                             skillsRequired: job['skills_required'],
//                             whoCanApply: job['who_can_apply'],
//                             isApplied: isApplied,
//                             fromExperiencedJobs: false,
//                             benefits: job['benefits'],
//                             CandidateStatus: "Actively Recruiting",
//                             whocanApply: job['who_can_apply'],
//                             aboutCompany: job["about_company"], isVerified: true,
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
//
//   }
//
//   Widget _buildCategoryFilters() {
//     double size = MediaQuery.of(context).size.height;
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Row(
//         children: categories.map((category) {
//           final isSelected = category == selectedCategory;
//           return Padding(
//             padding: EdgeInsets.symmetric(horizontal: size * 0.01),
//             child: GestureDetector(
//               onTap: () {
//                 setState(() {
//                   selectedCategory = category;
//                 });
//               },
//               child: Container(
//                 padding: EdgeInsets.symmetric(
//                     horizontal: size * 0.014, vertical: size * 0.01),
//                 decoration: BoxDecoration(
//                   color: isSelected ? Color(0xFF163EC8) : Colors.grey[200],
//                   borderRadius: BorderRadius.circular(size * 0.013),
//                 ),
//                 child: Text(
//                   category,
//                   style: TextStyle(
//                     color: isSelected ? Colors.white : Colors.black,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }
//
//   Widget _buildSearchBar() {
//     return TextField(
//       controller: _searchController,
//       onChanged: (value) {
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
//           borderRadius: BorderRadius.circular(30.0),
//           borderSide: BorderSide.none,
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:pre_dashboard/FresherJobs/OpportunityCard.dart';
import 'package:pre_dashboard/FresherJobs/fresherJobProvider.dart';
import 'package:provider/provider.dart';

class FresherJobs extends StatefulWidget {
  const FresherJobs({Key? key, required this.isVerified}) : super(key: key);
  final bool isVerified;

  @override
  State<FresherJobs> createState() => _FresherJobsState();
}

class _FresherJobsState extends State<FresherJobs> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';
  String selectedCategory = 'All';
  bool _isLoading = true;
  final List<String> categories = [
    'All',
    'Product Management',
    'Software Development',
    'Operations',
  ];

  @override
  void initState() {
    super.initState();
    final jobsProvider = Provider.of<JobsProvider>(context, listen: false);
    jobsProvider.retrieveId();
    jobsProvider.fetchJobs().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
    jobsProvider.fetchApplications();
  }

  @override
  Widget build(BuildContext context) {
    final jobsProvider = Provider.of<JobsProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Fresher Jobs',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Consumer<JobsProvider>(
        builder: (context, fresherJobsProvider, child) {
          if (_isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final jobs = fresherJobsProvider.jobs;
          final applications = fresherJobsProvider.applications;
          final appliedJobs = applications
              .where((application) => application['register'] == fresherJobsProvider.userId)
              .map((application) => application['job'])
              .toSet();

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

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.04),
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
                    _buildCategoryFilters(),
                    SizedBox(
                      height: screenHeight * 0.03,
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Available Fresher Jobs',
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
                            dp: const Icon(Icons.work_outline, color: Colors.grey),
                            profile: job['profile'] ?? 'N/A',
                            companyName: job['company_name'] ?? 'N/A',
                            location: job['location'] ?? 'N/A',
                            stipend: job['Stipend']?.toString() ?? 'N/A',
                            mode: job['work_environment'],
                            type: 'Fresher Jobs',
                            exp: job['years_experience_required'] ?? 0,
                            daysPosted: DateTime.now().difference(DateTime.parse(job['upload_date'])).inDays,
                            ctc: job['Stipend']?.toString() ?? '0',
                            description: job['description'] ?? 'No description available',
                            education: job['education'],
                            skillsRequired: job['skills_required'],
                            whoCanApply: job['who_can_apply'],
                            isApplied: isApplied,
                            fromExperiencedJobs: false,
                            benefits: job['benefits'],
                            CandidateStatus: "Actively Recruiting",
                            whocanApply: job['who_can_apply'],
                            aboutCompany: job["about_company"],
                            isVerified: true,
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
    double size = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) {
          final isSelected = category == selectedCategory;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: size * 0.01),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedCategory = category;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: size * 0.014, vertical: size * 0.01),
                decoration: BoxDecoration(
                  color: isSelected ? Color(0xFF163EC8) : Colors.grey[200],
                  borderRadius: BorderRadius.circular(size * 0.013),
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
      onChanged: (value) {
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
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
