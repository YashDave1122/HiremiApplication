
import 'package:flutter/material.dart';
import 'package:pre_dashboard/API.dart';

import 'package:pre_dashboard/ExperiencedJons/OpportunityCardforExperienced.dart';

import 'package:pre_dashboard/FresherJobs/apiservices.dart';
import 'package:pre_dashboard/FresherJobs/fresherJobProvider.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';



class ExperiencedJobs extends StatefulWidget {
  const ExperiencedJobs({Key? key, required this.isVerified}) : super(key: key);
  final bool isVerified;

  @override
  State<ExperiencedJobs> createState() => _ExperiencedJobsState();
}

class _ExperiencedJobsState extends State<ExperiencedJobs> {
  late Future<List<dynamic>> futureJobs;
  late Future<List<dynamic>> futureApplications;
  int? userId;
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
    _retrieveId();
    futureJobs = _getJobs();
    futureApplications = _getApplications();
  }
  Future<void> _retrieveId() async {
    final prefs = await SharedPreferences.getInstance();
    final int? savedId = prefs.getInt('userId');
    if (savedId != null) {
      setState(() {
        userId = savedId;
      });
      print("Retrieved id is $savedId");
    } else {
      print("No id found in SharedPreferences");
    }
  }

  Future<List<dynamic>> _getJobs() async {
    final apiService = ApiService('${ApiUrls.baseurl}/api/experiencejob/');
    return await apiService.fetchData();
  }

  Future<List<dynamic>> _getApplications() async {
    final apiService = ApiService('${ApiUrls.baseurl}/api/experience-job-applications/');
    return await apiService.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final jobsProvider = Provider.of<JobsProvider>(context);
    final List<dynamic> jobs = jobsProvider.jobs; // Ensure this list is populated
    final List<int> appliedJobs = jobsProvider.appliedJobs;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Experienced Jobs",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              // Navigator.of(context).push(
              //   MaterialPageRoute(builder: (ctx) => const NotificationScreen()),
              // );
            },
            icon: const Icon(Icons.notifications),
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: Future.wait([futureJobs, futureApplications]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty || snapshot.data![0].isEmpty) {
            // No jobs available
            return Center(
              child: Column(
                //   mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.03),
                  // Padding(
                  //   padding: const EdgeInsets.all(10.0),
                  //   child: Image.asset('images/Frame 110.png'),
                  // ),
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
          } else {
            final jobs = snapshot.data![0];
            final applications = snapshot.data![1];

            // Check which jobs the user has already applied for
            final appliedJobs = applications
                .where((application) => application['register'] == userId)
                .map((application) => application['experiencejob'])
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
                padding: EdgeInsets.all(screenWidth * 0.04), // 4% of screen width
                child: Center(
                  child: Column(
                    children: [
                      _buildSearchBar(),
                      SizedBox(
                        height: screenHeight * 0.03, // 3% of screen height
                      ),
                      _buildCategoryFilters(),
                      // Image.asset('images/Frame 110.png'),
                      SizedBox(
                        height: screenHeight * 0.03, // 3% of screen height
                      ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Available Experienced Jobs',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.03, // 3% of screen height
                      ),
                      Column(
                        // children: jobs.map<Widget>((job) {
                        children: filteredJobs.map<Widget>((job) {

                          bool isApplied = appliedJobs.contains(job['id']);
                          return Padding(
                            padding: EdgeInsets.only(bottom: screenHeight * 0.03),
                            child: OpportunityCard(
                              id: job['id'],
                              dp: Icon(Icons.business, color: Colors.grey),  // Placeholder image
                              profile: job['profile'] ?? 'N/A',
                              companyName: job['company_name'] ?? 'N/A',
                              location: job['location'] ?? 'N/A',
                              stipend: job['CTC']?.toString() ?? 'N/A',
                              mode: job['work_environment'] ?? 'N/A',
                              type: 'Job',
                              exp: job['years_experience_required'] ?? 0,
                              daysPosted:  DateTime.now().difference(DateTime.parse(job['upload_date'])).inDays, // Replace with actual data if available
                              isVerified: widget.isVerified,
                              ctc: job['CTC']?.toString() ?? '0', // Example, replace with actual field
                              description: job['description'] ?? 'No description available',
                              education: job['education'] ?? 'N/A',
                              skillsRequired: job['skills_required'] ?? 'N/A',
                              whoCanApply: job['who_can_apply'] ?? 'N/A',
                              isApplied: isApplied, // Indicate if already applied
                              fromExperiencedJobs: true,
                              benefits: job['type'] == 'Internship' ? job['benefits'] : null,
                              CandidateStatus: "Actively Recruiting",
                              whocanApply: job['who_can_apply'],
                              aboutCompany:job["about_company"],
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: screenHeight * 0.35),
                    ],
                  ),
                ),
              ),
            );
          }
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

