//Add some comment
import 'package:flutter/material.dart';
import 'package:pre_dashboard/API.dart';
import 'package:pre_dashboard/AppSizes/AppSizes.dart';
import 'package:pre_dashboard/ApplyinternandJobs/apiservices.dart';
import 'package:pre_dashboard/ExperiencedJons/experienced_job.providerdart.dart';
import 'package:pre_dashboard/FresherJobs/EligibilityCriteriaAboutCompanyFresher.dart';
import 'package:pre_dashboard/FresherJobs/HeaderSectionFresher.dart';
import 'package:pre_dashboard/FresherJobs/RoleDetailedFresher.dart';
import 'package:pre_dashboard/FresherJobs/SkillRequiredFresher.dart';
import 'package:pre_dashboard/FresherJobs/apiservices.dart';
import 'package:pre_dashboard/FresherJobs/fresherJobProvider.dart';


import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';





class DetailedFresherJobs extends StatefulWidget {

  final int id;
  final String profile;
  final String location;
  final String codeRequired;
  final int code;
  final String daysPosted;
  final String companyName;
  final String education;
  final String skillsRequired;
  final String? knowledgeStars;
  final String whoCanApply;
  final String exp;
  final String description;
  final String termsAndConditions;
  final double ctc;
  final bool fromExperiencedJobs;
  final String mode;
  final String aboutCompany;


  const DetailedFresherJobs({
    Key? key,
    required this.id,
    required this.profile,
    required this.location,
    required this.exp,
    required this.codeRequired,
    required this.code,
    required this.companyName,
    required this.education,
    required this.skillsRequired,
    this.knowledgeStars,
    required this.whoCanApply,
    required this.description,
    required this.termsAndConditions,
    required this.ctc,
    required this.fromExperiencedJobs,
    required this.mode,
    required this.daysPosted,
    required this.aboutCompany,


  });

  @override
  State<DetailedFresherJobs> createState() => _DetailedFresherJobsState();
}

class _DetailedFresherJobsState extends State<DetailedFresherJobs> {
  int? userId;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("Applies is $_isApplied");
    print("Experience job is ${widget.fromExperiencedJobs}");

    _retrieveId();
  }
  Future<void> _retrieveId() async {
    final prefs = await SharedPreferences.getInstance();
    final int? savedId = prefs.getInt('userId');
    if (savedId != null) {
      setState(() {
        userId = savedId;
        _fetchApplications(); // Fetch applications once the userId is retrieved
      });
      print("Retrieved id is $savedId");
    } else {
      print("No id found in SharedPreferences");
    }
  }

  Future<void> _fetchApplications() async {
    final String fresherJobApi = '${ApiUrls.baseurl}/api/job-applications/';
    final String experiencedJobApi = '${ApiUrls.baseurl}/api/experience-job-applications/';

    // Fetch fresher job applications
    final fresherJobApplications = await ApiService(fresherJobApi).fetchData();
    // Fetch experienced job applications
    final experiencedJobApplications = await ApiService(experiencedJobApi).fetchData();

    setState(() {
      _isApplied = fresherJobApplications.any((application) =>
      application['fresherjob'] == widget.id &&
          application['register'] == userId);
      //     experiencedJobApplications.any((application) =>
      //     application['experiencejob'] == widget.id &&
      //         application['register'] == userId);


    });
    print("Apploed is $_isApplied");
  }

  bool _isApplied = false;



  Future<void> showConfirmationDialog(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(screenWidth * 0.04),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const Spacer(),
                        Container(
                          width: screenWidth * 0.08,
                          height: screenWidth * 0.08,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(screenWidth * 0.04),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: Icon(
                              Icons.close,
                              size: screenWidth * 0.032,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          height: 1,
                          width: screenWidth * 0.310,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                          ),
                        ),
                        Icon(
                          Icons.error_rounded,
                          color: const Color(0xFFC1272D),
                          size: screenWidth * 0.105,
                        ),
                        Container(
                          height: 1,
                          width: screenWidth * 0.310,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: screenHeight * 0.01,
                    ),
                    Text(
                      'Are you sure you want to apply?',
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: screenHeight * 0.01,
                    ),
                  ],
                ),
              ),
              Center(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(screenWidth * 0.04),
                        color: Colors.green,
                      ),
                      child: TextButton(
                        onPressed: () async {
                          if (widget.fromExperiencedJobs) {
                            // Call the function for experienced jobs
                            _applyForExperiencedJob();
                            print("We are coming from ex");
                          } else {
                            // Call the function for fresher jobs
                            _applyForFresherJob();
                            print(widget.fromExperiencedJobs);
                            print("We are coming from normal job");

                          }
                        },
                        child: const Text(
                          'Yes',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.02,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _applyForExperiencedJob() async {
    if (_isApplied) return;
    print('Applying for experienced job');
    print(widget.id);

    try {
      await ApiServices.applyForExperiencedJob(widget.id, context);
      // setState(() {
      //   _isApplied = true;
      // });
    } catch (error) {
      print('Error applying for Experience job: $error');
    }
  }

  Future<void> _applyForFresherJob() async {
    print(widget.id);

    try {
      await ApiServices.applyForJob(widget.id, context);
      // setState(() {
      //   _isApplied = true;
      // });
    } catch (error) {
      print('Error applying for fresher job: $error');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        // title: const Text('Fresher Jobs', style:  TextStyle(
        //     fontSize: 16.0, fontWeight: FontWeight.w500, color: Colors.black),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () async {
            print("Hello");
            final prefs = await SharedPreferences.getInstance();
            final int? savedId = prefs.getInt('userId');
            print(savedId);
            final jobsProvider = Provider.of<JobsProvider>(context, listen: false);
            await jobsProvider.setUserId(savedId!);
            jobsProvider.fetchJobs();
            jobsProvider.fetchApplications();
            final ExjobsProvider = Provider.of<ExperiencedJobsProvider>(context, listen: false);
            ExjobsProvider.ExfetchJobs();
            ExjobsProvider.ExfetchApplications();
            ExjobsProvider.retrieveId();
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Navigator.of(context).push(
              //     MaterialPageRoute(builder: (ctx) => const NotificationScreen()));
            },
            icon: const Icon(Icons.notifications),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: Sizes.responsiveXl(context),
            right: Sizes.responsiveDefaultSpace(context),
            bottom: kToolbarHeight * 1.5,
            left: Sizes.responsiveDefaultSpace(context),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header Sections
              // HeaderSectionFresher(
              //   profile: widget.profile,
              //   mode:widget.mode,
              //   exp:widget.exp,
              //   daysPosted:widget.daysPosted,
              //   companyName: widget.companyName,
              //   location: widget.location,
              //   education:widget.education,
              //   ctc: widget.ctc,
              //   onTap: ()async{
              //     // if (widget.fromExperiencedJobs) {
              //     //   // Call the function for experienced jobs
              //     //   _applyForExperiencedJob();
              //     //   print("We are coming from ex");
              //     // } else {
              //     //   // Call the function for fresher jobs
              //     //   _applyForFresherJob();
              //     //   print(widget.fromExperiencedJobs);
              //     //   print("We are coming from normal job");
              //     //
              //     // }
              //     await showConfirmationDialog(context);
              //   },
              //   buttonText: _isApplied ? 'Applied' : 'Apply Now >',
              // ),

              HeaderSectionFresher(
                profile: widget.profile,
                mode: widget.mode,
                exp: widget.exp,
                daysPosted: widget.daysPosted,
                companyName: widget.companyName,
                location: widget.location,
                education: widget.education,
                ctc: widget.ctc,
                onTap: () async {
                  if (_isApplied) {
                    print("Applied is $_isApplied");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('You have already applied for this job.'),
                        backgroundColor: Colors.redAccent,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                    return;
                  }

                  // If not applied, proceed with the confirmation dialog
                  await showConfirmationDialog(context);
                },
                buttonText: _isApplied ? 'Applied' : 'Apply Now >',
              ),
              SizedBox(height: Sizes.responsiveXl(context)),
              /// Role Details
              RoleDetailsFresher(
                profile: widget.profile,
                location: widget.location,
                ctc: widget.ctc,
                description: widget.description,
              ),
              SizedBox(
                height: Sizes.responsiveLg(context),
              ),
              /// Skill Required
              SkillRequiredFresher(
                skillsRequired: widget.skillsRequired,
              ),
              SizedBox(
                height: Sizes.responsiveLg(context),
              ),
              /// Eligibility Criteria
              EligibilityCriteriaAboutCompanyFresher(
                  companyName:widget.companyName,
                  whoCanApply:widget.whoCanApply,
                  aboutCompany:widget.aboutCompany
              ),

            ],
          ),
        ),
      ),
    );
  }
}
