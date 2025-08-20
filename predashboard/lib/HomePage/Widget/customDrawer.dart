import 'package:flutter/material.dart';
import 'package:pre_dashboard/HomePage/Widget/popupmsg.dart';
import 'package:pre_dashboard/HomePage/screens/AboutApp.dart';
import 'package:pre_dashboard/HomePage/screens/Drawer/Settings.dart';
import 'package:pre_dashboard/HomePage/screens/Drawer/help_Support.dart';
import 'package:pre_dashboard/HomePage/screens/HelpAnsSupport.dart';
import 'package:pre_dashboard/ProfileScreen/Profile_screen.dart';
import 'package:pre_dashboard/SharedPreferences/SharedPreferences.dart';


import '../screens/Drawer/about.dart';
import 'logoutDialog.dart';

class CustomDrawer extends StatefulWidget {
  final bool isVerified;
  // const CustomDrawer({super.key});
  const CustomDrawer({Key? key, required this.isVerified}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadUserDetails();
  }
  String FullName="";
  String unique="";
  String Email="";

  final SharedPreferencesService _sharedPreferencesService = SharedPreferencesService();

  Future<void> _loadUserDetails() async {
    final userDetails = await _sharedPreferencesService.getUserDetails();
    if (userDetails != null) {
      setState(() {
        FullName = userDetails['full_name'] ?? '';
        Email= userDetails['email'] ?? '';
        unique=userDetails['unique'];

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final size = MediaQuery.of(context).size;
    print("Size is $size");
    final width = size.width;
    final height = size.height;

    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.04,
            vertical: width * 0.02,
          ),
          child: Column(
            children: [
              // Header Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: width * 0.12,
                        height: width * 0.12,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // CircularProgressIndicator(
                            //   value: 0.25,
                            //   backgroundColor: const Color(0xFFEEF2FF),
                            //   color: const Color.fromARGB(255, 36, 231, 33),
                            //   strokeWidth: width * 0.015,
                            // ),
                            // Text(
                            //   '25%',
                            //   style: TextStyle(
                            //     fontSize: width * 0.032,
                            //     fontWeight: FontWeight.w600,
                            //     color: const Color.fromARGB(255, 36, 231, 33),
                            //   ),
                            // ), // CircularProgressIndicator(
                            //   value: 0.25,
                            //   backgroundColor: const Color(0xFFEEF2FF),
                            //   color: const Color.fromARGB(255, 36, 231, 33),
                            //   strokeWidth: width * 0.015,
                            // ),
                            // Text(
                            //   '25%',
                            //   style: TextStyle(
                            //     fontSize: width * 0.032,
                            //     fontWeight: FontWeight.w600,
                            //     color: const Color.fromARGB(255, 36, 231, 33),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                      SizedBox(width: width * 0.01),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            // 'Zaidi Akram',
                            FullName,
                            style: TextStyle(
                              fontSize: width * 0.039,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1F1F1F),
                            ),
                          ),
                          Text(
                            // 'zaidiakram123@gmail.com',
                            Email,
                            style: TextStyle(
                              fontSize: width * 0.028,
                              color: const Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close,
                      size: width * 0.06,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),

              SizedBox(height: height * 0.025),

              // Profile Verification Section
              // Container(
              //   padding: EdgeInsets.all(width * 0.04),
              //   decoration: BoxDecoration(
              //     color: const Color(0xFF0F3CC9),
              //     borderRadius: BorderRadius.circular(width * 0.03),
              //   ),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Row(
              //         children: [
              //           Text(
              //             'HireMi',
              //             style: TextStyle(
              //               color: Colors.white,
              //               fontSize: width * 0.045,
              //               fontWeight: FontWeight.w700,
              //             ),
              //           ),
              //         ],
              //       ),
              //       SizedBox(height: height * 0.01),
              //       Text(
              //         'Complete profile verification to access premium features',
              //         style: TextStyle(
              //           color: Colors.white,
              //           fontSize: width * 0.032,
              //           height: 1.3,
              //         ),
              //       ),
              //       SizedBox(height: height * 0.008),
              //       ElevatedButton(onPressed: (){
              //
              //       },
              //           style: ElevatedButton.styleFrom(
              //             shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(width*0.02), // Adjust the radius as needed
              //             ),
              //             padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Adjust padding
              //           ),
              //           child: Row(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //           Text("Get Verified",style: TextStyle(
              //             color: const Color(0xFF0F3CC9),
              //           ),),
              //           SizedBox(width: width*0.02,),
              //           Icon(Icons.check_circle_outline,
              //           color: const Color(0xFF0F3CC9),
              //           )
              //         ],
              //       ))
              //     ],
              //   ),
              // ),
              // Container(
              //   padding: EdgeInsets.all(width * 0.04),
              //   decoration: BoxDecoration(
              //     color: widget.isVerified ? const Color(0xFFFF4C4C) : const Color(0xFF0F3CC9),
              //     borderRadius: BorderRadius.circular(width * 0.03),
              //   ),
              //   child: widget.isVerified
              //       ? Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text(
              //         'HireMi',
              //         style: TextStyle(
              //           color: Colors.white,
              //           fontSize: width * 0.045,
              //           fontWeight: FontWeight.w700,
              //         ),
              //       ),
              //       SizedBox(height: height * 0.01),
              //       Text(
              //         'You are Verified! Enjoy all premium features.',
              //         style: TextStyle(
              //           color: Colors.white,
              //           fontSize: width * 0.032,
              //           height: 1.3,
              //         ),
              //       ),
              //     ],
              //   )
              //       : Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text(
              //         'HireMi',
              //         style: TextStyle(
              //           color: Colors.white,
              //           fontSize: width * 0.045,
              //           fontWeight: FontWeight.w700,
              //         ),
              //       ),
              //       SizedBox(height: height * 0.01),
              //       Text(
              //         'Complete profile verification to access premium features',
              //         style: TextStyle(
              //           color: Colors.white,
              //           fontSize: width * 0.032,
              //           height: 1.3,
              //         ),
              //       ),
              //       SizedBox(height: height * 0.008),
              //       ElevatedButton(
              //         onPressed: () {},
              //         style: ElevatedButton.styleFrom(
              //           shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(width * 0.02),
              //           ),
              //           padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              //         ),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: [
              //             Text(
              //               "Get Verified",
              //               style: TextStyle(
              //                 color: const Color(0xFF0F3CC9),
              //               ),
              //             ),
              //             SizedBox(width: width * 0.02),
              //             Icon(
              //               Icons.check_circle_outline,
              //               color: const Color(0xFF0F3CC9),
              //             ),
              //           ],
              //         ),
              //       )
              //     ],
              //   ),
              // ),
              Container(
                width: screenWidth * 0.774,
                height: screenHeight * 0.076,
                decoration: BoxDecoration(
                  // color: Colors.blueAccent,
                  color: const Color(0xFF0F3CC9),
                  borderRadius: BorderRadius.circular(screenWidth * 0.025),
                  border: Border.all(color: Colors.blueAccent),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(screenWidth * 0.025),
                  // child: Column(
                  //   children: [
                  //     SizedBox(height: 20,),
                  //
                  //   ],
                  // ),
                  child:  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 4,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("${FullName}",style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),),
                          Text("AppID:${unique}",style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),),
                        ],
                      ),
                      // SizedBox(width: 55,),
                      // Text("${fullName}",style: TextStyle(
                      //   color: Colors.white,
                      //   fontSize: 20,
                      // ),)
                      Image.asset( "assets/images/VerifiedImage.png",
                        height: screenWidth*0.034,
                        width: 145,
                      )
                    ],
                  ),
                ),
              ),


              SizedBox(height: height * 0.025),

              _buildMenuItemGeneral(
                context,
                Icons.account_circle,
                'Your Profile',
                () {
                //
                  if(widget.isVerified){
                    print("Hwllo");
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()),
                    );
                  }
                  else
                    {
                      showCustomPopup(context);
                    }

                }
              ),
              SizedBox(height: height * 0.015),
              _buildMenuItemGeneral(
                context,
                Icons.menu,
                'Settings',
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingsScreen(),
                    ),
                  );
                },
              ),
              SizedBox(height: height * 0.015),
              _buildMenuItemGeneral(
                context,
                Icons.assignment,
                'About App',
                ()  {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => About_App(),
                    ),
                  );
                },
              ),
              SizedBox(height: height * 0.015),
              _buildMenuItemGeneral(
                context,
                Icons.quickreply,
                'Help & Support',
                () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => HelpAndSupport(),
                  //   ),
                  // );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HelpSupport(),
                    ),
                  );
                },
              ),

              const Spacer(),

              // Logout Item
              _buildMenuItem(
                context,
                Icons.logout,
                'Log out',
                isLogout: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItemGeneral(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    final width = MediaQuery.of(context).size.width;

    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        horizontal: width * 0.03,
        vertical: width * 0.005,
      ),
      leading: Icon(icon, size: width * 0.055, color: const Color(0xFF0F3CC9)),
      title: Text(
        title,
        style: TextStyle(
          fontSize: width * 0.036,
          color: const Color(0xFF1F1F1F),
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(Icons.chevron_right,
          size: width * 0.06, color: const Color(0xFF6B7280)),
      onTap: onTap,
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String title, {
    bool isLogout = false,
  }) {
    final width = MediaQuery.of(context).size.width;

    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        horizontal: width * 0.03,
        vertical: width * 0.005,
      ),
      leading: Icon(
        icon,
        size: width * 0.055,
        color: isLogout ?const Color(0xFF0F3CC9) : const Color(0xFFDC2626) ,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: width * 0.036,
          color: isLogout ? const Color(0xFF0F3CC9) :  Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: isLogout
          ? null
          : Icon(
              Icons.chevron_right,
              size: width * 0.06,
              color: const Color(0xFF6B7280),
            ),
      onTap: () async {
        if (isLogout) {
          Navigator.pop(context);
          final shouldLogout = await showDialog<bool>(
            context: context,
            barrierColor: Colors.black.withOpacity(0.5),
            builder: (context) => const LogoutDialog(),
          );

          if (shouldLogout == true) {
            print('Performing logout...');
          }
        }
      },
    );
  }
}
