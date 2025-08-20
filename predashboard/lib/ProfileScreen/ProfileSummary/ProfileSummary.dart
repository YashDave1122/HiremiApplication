import 'package:flutter/material.dart';
import 'package:pre_dashboard/HomePage/constants/constantsColor.dart';
import 'package:pre_dashboard/ProfileScreen/ProfileSummary/AddProfileSummary.dart';
import 'package:pre_dashboard/ProfileScreen/ProfileSummary/OutlinedContainer.dart';
import 'package:pre_dashboard/ProfileScreen/ProfileSummary/apiServices.dart';


class ProfileSummary extends StatefulWidget {
  const ProfileSummary({Key? key}) : super(key: key);

  @override
  _ProfileSummaryState createState() => _ProfileSummaryState();
}

class _ProfileSummaryState extends State<ProfileSummary> {
  late Future<String?> _profileSummaryFuture;

  @override
  void initState() {
    super.initState();
    _profileSummaryFuture = _fetchProfileSummary();
  }

  Future<String?> _fetchProfileSummary() async {
    final AddProfileSummaryService service = AddProfileSummaryService();
    final summary = await service.getProfileSummary();
    return summary;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _profileSummaryFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
        {
          return Center(child: CircularProgressIndicator());
        }
        else if (snapshot.hasError)
        {
          print('Error fetching profile summary: ${snapshot.error}'); // Debug print
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        else if (!snapshot.hasData || snapshot.data!.isEmpty)
        {
          print('No profile summary available'); // Debug print
          return OutlinedContainer(
            // onTap: () => Navigator.of(context).push(
            //   MaterialPageRoute(builder: (context) => AddProfileSummary()),
            // ),
            title: 'Profile Summary',
            isTrue: false,
            child: const Text(
              '',
              style: TextStyle(
                fontSize: 9.0,
                fontWeight: FontWeight.w500,
                color: AppColors.black,
              ),
            ),
          );
        } else {
          final summary = snapshot.data!;
          return OutlinedContainer(
            // onTap: () => Navigator.of(context).push(
            //   MaterialPageRoute(builder: (context) => AddProfileSummary()),
            // ),
            onEditTap: (){
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AddProfileSummary()),
              );
            },
            title: 'Profile Summary',
            isTrue: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  summary,
                  style: const TextStyle(
                    fontSize: 9.0,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
