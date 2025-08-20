// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:pre_dashboard/FirstPage.dart';
// import 'package:pre_dashboard/Footer/screens/basic_details_screen.dart';
// import 'package:pre_dashboard/FresherJobs/fresherJobProvider.dart';
// import 'package:pre_dashboard/Hiremi360/screens/payment_failed_unimentor.dart';
// import 'package:pre_dashboard/HomePage/Provider/HomePageOppurtunity.dart';
// import 'package:pre_dashboard/HomePage/screens/AboutApp.dart';
// import 'package:pre_dashboard/HomePage/screens/Drawer/query2.dart';
// import 'package:pre_dashboard/HomePage/screens/HomeScreen.dart';
// import 'package:pre_dashboard/HomePage/screens/Query.dart';
// import 'package:pre_dashboard/HomePage/screens/askExpertScreen.dart';
// import 'package:pre_dashboard/Internship/Internship_provider.dart';
// import 'package:pre_dashboard/Non_verified_changes/Provider/CareerStagedProvider.dart';
// import 'package:pre_dashboard/Non_verified_changes/Provider/UserProfileProvider.dart';
// import 'package:pre_dashboard/Non_verified_changes/Provider/UserProvider.dart';
// import 'package:pre_dashboard/Non_verified_changes/screens/final_step_screen.dart';
// import 'package:pre_dashboard/Non_verified_changes/screens/payment_processing_step.dart';
// import 'package:pre_dashboard/Non_verified_changes/screens/payment_verification_screen.dart';
// import 'package:pre_dashboard/Non_verified_changes/screens/profile_verification_screen.dart';
// import 'package:pre_dashboard/Non_verified_changes/screens/profile_verification_screen1.dart';
// import 'package:pre_dashboard/ProfileScreen/Profile_screen.dart';
//
//
//
// import 'package:pre_dashboard/predashboard/bloc/user_bloc.dart';
//
// import 'package:provider/provider.dart';
//
// import 'Hiremi360/controller_screen/controller_screen.dart';
// // void main() {
// //   runApp( BlocProvider(
// //     create: (context) => UserBloc(),
// //     child: MyApp(),
// //   ));
// // }
// void main() {
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (context) => UserProfileProvider()),
//         ChangeNotifierProvider(create: (_) => CareerStageProvider()),
//         ChangeNotifierProvider(create: (_) => UserProvider()),
//         ChangeNotifierProvider(create: (_) => InternshipProvider()),
//         ChangeNotifierProvider(create: (_) => JobsProvider()),
//         ChangeNotifierProvider(create: (_) => HomePageOppurtunity()),
//
//       ],
//       child: BlocProvider(
//         create: (context) => UserBloc(),
//         child: MyApp(),
//       ),
//     ),
//   );
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'pre dashboard',
//       theme: ThemeData(
//         textTheme:TextTheme(
//           bodyMedium: GoogleFonts.poppins(
//             fontSize: MediaQuery.of(context).size.width * 0.035,
//             fontWeight: FontWeight.w500,
//           ),
//           titleLarge: GoogleFonts.poppins(
//             fontSize: MediaQuery.of(context).size.width * 0.07,
//             fontWeight: FontWeight.w800,
//             color: const Color(0xFF163EC8),
//           ),
//           bodySmall: GoogleFonts.poppins(
//             fontSize: MediaQuery.of(context).size.width * 0.03,
//             fontWeight: FontWeight.w400,
//             color: Colors.grey,
//           ),
//           headlineSmall: GoogleFonts.poppins(
//             fontSize: MediaQuery.of(context).size.width * 0.07,
//             color: const Color(0xFF6983D9),
//           ),
//         ),
//         useMaterial3: true,
//       ),
//       home:ProfileVerificationScreen(currentIndex: 3,),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pre_dashboard/Hiremi360/screens/payment_failed_corporate_launchpad.dart';
import 'package:pre_dashboard/Hiremi360/screens/payment_verification_training_internship.dart';
import 'package:pre_dashboard/Non_verified_changes/screens/final_step_screen.dart';
import 'package:pre_dashboard/Non_verified_changes/screens/profile_verification_screen.dart';
import 'package:pre_dashboard/predashboard/screens/splash_screens/splash_screen1.dart';
import 'package:pre_dashboard/predashboard/bloc/user_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pre_dashboard/Non_verified_changes/Provider/CareerStagedProvider.dart';
import 'package:pre_dashboard/Non_verified_changes/Provider/UserProfileProvider.dart';
import 'package:pre_dashboard/Non_verified_changes/Provider/UserProvider.dart';
import 'package:pre_dashboard/Internship/Internship_provider.dart';
import 'package:pre_dashboard/FresherJobs/fresherJobProvider.dart';
import 'package:pre_dashboard/HomePage/Provider/HomePageOppurtunity.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  int? timerValue = prefs.getInt('verification_start_time'); // Retrieve timer
  print("timer value is $timerValue");

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProfileProvider()),
        ChangeNotifierProvider(create: (_) => CareerStageProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => InternshipProvider()),
        ChangeNotifierProvider(create: (_) => JobsProvider()),
        ChangeNotifierProvider(create: (_) => HomePageOppurtunity()),
      ],
      child: BlocProvider(
        create: (context) => UserBloc(),
        child: MyApp(timerValue: timerValue),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final int? timerValue;

  const MyApp({super.key, this.timerValue});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pre Dashboard',
      theme: ThemeData(
        textTheme: TextTheme(
          bodyMedium: GoogleFonts.poppins(
            fontSize: MediaQuery.of(context).size.width * 0.035,
            fontWeight: FontWeight.w500,
          ),
          titleLarge: GoogleFonts.poppins(
            fontSize: MediaQuery.of(context).size.width * 0.07,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF163EC8),
          ),
          bodySmall: GoogleFonts.poppins(
            fontSize: MediaQuery.of(context).size.width * 0.03,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
          headlineSmall: GoogleFonts.poppins(
            fontSize: MediaQuery.of(context).size.width * 0.07,
            color: const Color(0xFF6983D9),
          ),
        ),
        useMaterial3: true,
      ),
      // home: (timerValue != null)
      //     ? SplashScreen()
      //     : ProfileVerificationScreen(currentIndex: 3)
      // home: SplashScreen()
      home:SplashScreen()
    );
  }
}
