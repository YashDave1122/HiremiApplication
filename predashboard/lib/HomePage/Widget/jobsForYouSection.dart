
import 'package:flutter/material.dart';
import 'package:pre_dashboard/HomePage/Provider/HomePageOppurtunity.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JobsForYouSection extends StatefulWidget {
  JobsForYouSection({super.key});

  @override
  State<JobsForYouSection> createState() => _JobsForYouSectionState();
}

class _JobsForYouSectionState extends State<JobsForYouSection> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _retrieveAndFetchJobs();
    });
  }

  Future<void> _retrieveAndFetchJobs() async {
    final prefs = await SharedPreferences.getInstance();
    final int? savedId = prefs.getInt('userId');
    if (savedId != null) {
      print("Saved id: $savedId");
      final homePageOpportunity =
      Provider.of<HomePageOppurtunity>(context, listen: false);
      await homePageOpportunity.fetchAppliedJobs(savedId);
      await homePageOpportunity.fetchJobs(); // Fetch jobs after fetching applied jobs
    } else {
      print("No id found in SharedPreferences");
    }
  }

  @override
  Widget build(BuildContext context) {
    final homePageOpportunity = Provider.of<HomePageOppurtunity>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return homePageOpportunity.isLoading
        ? Center(child: CircularProgressIndicator())
        : homePageOpportunity.jobs.isEmpty
        ? Center(child: Text('No jobs available right now!'))
        : Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Text(
            'Jobs for you',
            style: TextStyle(
              fontSize: screenWidth * 0.05,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: screenHeight * 0.25,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
            itemCount: homePageOpportunity.jobs.length,
            itemBuilder: (context, index) {
              final job = homePageOpportunity.jobs[index];
              print('Job data at index $index: $job'); // Debug print

              if (job == null || job is! Map<String, dynamic>) {
                return Center(child: Text('Invalid job data'));
              }

              return _buildJobCard(job, screenWidth, screenHeight);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildJobCard(Map<String, dynamic> job, double screenWidth, double screenHeight) {
    return Padding(
      padding: EdgeInsets.only(right: screenWidth * 0.04),
      child: Container(
        width: screenWidth * 0.68,
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(screenWidth * 0.03),
        ),
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              job['profile']?.toString() ?? 'Job Title',
              style: TextStyle(
                fontSize: screenWidth * 0.045,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            Row(
              children: [
                Icon(Icons.location_on_outlined, size: screenWidth * 0.04, color: Colors.grey),
                SizedBox(width: screenWidth * 0.01),
                Text(
                  job['location']?.toString() ?? 'Location',
                  style: TextStyle(color: Colors.grey, fontSize: screenWidth * 0.035),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.01),
            if (job['tags'] != null && job['tags'] is List)
              Wrap(
                spacing: screenWidth * 0.02,
                children: (job['tags'] as List<dynamic>)
                    .map<Widget>((tag) => _buildTag(tag.toString(), screenWidth))
                    .toList(),
              ),
            SizedBox(height: screenHeight * 0.01),
            Text(
              job['company_name']?.toString() ?? 'Company Name',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: screenWidth * 0.035),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: (job['isApplied'] ?? false)
                      ? null
                      : () {
                    print('Job details: $job');
                    print('Opportunity type: ${job['type']}');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: (job['isApplied'] ?? false) ? Colors.grey : Colors.blue,
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.03,
                      vertical: screenHeight * 0.01,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.02),
                    ),
                  ),
                  child: Text(
                    (job['isApplied'] ?? false) ? 'Applied' : 'Apply Now',
                    style: TextStyle(fontSize: screenWidth * 0.035, color: Colors.white),
                  ),
                ),
                Text(
                  job['CTC']?.toString() ?? job['Stipend']?.toString() ?? 'N/A',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenWidth * 0.04),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text, double screenWidth) {
    return Container(
      margin: EdgeInsets.only(right: screenWidth * 0.02),
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.02,
        vertical: screenWidth * 0.01,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(screenWidth * 0.02),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.grey,
          fontSize: screenWidth * 0.035,
        ),
      ),
    );
  }
}
