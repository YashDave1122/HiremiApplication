import 'package:flutter/material.dart';

import 'package:pre_dashboard/AppSizes/AppSizes.dart';
import 'package:pre_dashboard/HomePage/constants/constantsColor.dart';
import 'package:pre_dashboard/ProfileScreen/BasicDetails/AddBasicDetails.dart';
import 'package:pre_dashboard/ProfileScreen/BasicDetails/OutlinedCOntainer.dart';
import 'package:pre_dashboard/ProfileScreen/BasicDetails/apiServices.dart';
import 'package:shared_preferences/shared_preferences.dart';


class BasicDetails extends StatefulWidget {
  const BasicDetails({Key? key}) : super(key: key);

  @override
  _BasicDetailsState createState() => _BasicDetailsState();
}

class _BasicDetailsState extends State<BasicDetails> {
  String lookingFor = '';
  String city = '';
  String state = '';
  String email = '';
  String phoneNumber = '';
  String whatsappNumber = '';


  @override
  void initState() {
    super.initState();
    _loadBasicDetails();

  }


  Future<void> _loadBasicDetails() async {
    final service = AddBasicDetailsService();
    final details = await service.getBasicDetails();
    print(details);
    setState(() {
      lookingFor = details['looking_for'] ?? '';
      city = details['city'] ?? '';
      state = details['state'] ?? '';
      email = details['email'] ?? '';
      phoneNumber = details['phone_number'] ?? '';
      whatsappNumber = details['whatsapp_number'] ?? '';
    });
  }

  bool isAllFieldValid() {
    return lookingFor.isNotEmpty &&
        city.isNotEmpty &&
        state.isNotEmpty &&
        email.isNotEmpty &&
        phoneNumber.isNotEmpty &&
        whatsappNumber.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedContainer(
      onTap: () async {
        // final result = await Navigator.of(context).push(
        //   MaterialPageRoute(builder: (context) => const AddBasicDetails()),
        // );
        // if (result == true) {
        //   // Refresh the details if the result indicates success
        //   _loadBasicDetails();
        // }
      },
      onEditTap: () async{
        // Add the desired action here for when the image is tapped
        print('Edit icon tapped');
        final result = await Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const AddBasicDetails()),
        );
        if (result == true) {
          // Refresh the details if the result indicates success
          _loadBasicDetails();
        }
        // You can navigate to another screen or perform any other action here
      },
      title: 'Basic Details',
      isTrue: isAllFieldValid(),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (isAllFieldValid())
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: Sizes.responsiveMd(context),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.business_center_outlined,
                    size: 10,
                    color: AppColors.secondaryText,
                  ),
                  SizedBox(
                    width: Sizes.responsiveXxs(context),
                  ),
                  const Text('Looking for ',
                      style: TextStyle(
                        fontSize: 10.0,
                        fontWeight: FontWeight.w400,
                        color: AppColors.black,
                      )),
                  Text(lookingFor,
                      style: TextStyle(
                        fontSize: 10.0,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      )),

                ],
              ),
              SizedBox(
                height: Sizes.responsiveSm(context),
              ),
              BasicDetailsChild(
                icon: Icons.add_location_alt,
                title: '$city, $state',
              ),
              SizedBox(
                height: Sizes.responsiveSm(context),
              ),
              BasicDetailsChild(icon: Icons.mail_outline, title: email),
              SizedBox(
                height: Sizes.responsiveSm(context),
              ),
              BasicDetailsChild(icon: Icons.call_outlined, title: phoneNumber),
              SizedBox(
                height: Sizes.responsiveSm(context),
              ),
              BasicDetailsChild(
                  icon: Icons.message_outlined, title: whatsappNumber),
            ],
          )
      ]),
    );
  }
}

class BasicDetailsChild extends StatelessWidget {
  const BasicDetailsChild({
    Key? key,
    required this.icon,
    required this.title,
  }) : super(key: key);

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 10,
          color: AppColors.secondaryText,
        ),
        SizedBox(width: Sizes.responsiveXxs(context)),
        Text(title,
            style: const TextStyle(
              fontSize: 10.0,
              fontWeight: FontWeight.w400,
              color: AppColors.black,
            )),
      ],
    );
  }
}
