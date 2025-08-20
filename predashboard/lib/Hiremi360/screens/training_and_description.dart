import 'package:flutter/material.dart';
import 'package:pre_dashboard/AppSizes/AppSizes.dart';
import 'package:pre_dashboard/Hiremi360/screens/EnrollPageTrainingAndInternship.dart';
import 'package:pre_dashboard/Hiremi360/widgets/roundedContainer.dart';


class Trainingandinternshipdescription extends StatefulWidget {
  final Map<String, dynamic> program; // Add this line to accept program details
  const Trainingandinternshipdescription({Key? key,required this.program}) : super(key: key);


  @override
  State<Trainingandinternshipdescription> createState() => _TrainingandinternshipdescriptionState();
}

class _TrainingandinternshipdescriptionState extends State<Trainingandinternshipdescription> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return  Scaffold(
      backgroundColor: const Color(0xffFFF8F2),
      appBar: AppBar(
        backgroundColor: const Color(0xffFFF8F2),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black), // Back arrow icon
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
        title: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Colors.redAccent, Colors.blueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: const Text(
            "Training + Internships",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,  // Text color is needed, but will be replaced by the gradient
            ),
          ),
        ),

        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(

          children: [
            SizedBox(height:screenWidth*0.02 ,),
            // Center(child: Image.asset("images/Rectangle 6618.png")),
            SizedBox(height:screenWidth*0.06 ,),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Regular text
                Text(
                  'Become a ${widget.program['training_program']} with',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: screenWidth * 0.0518,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  // textAlign: TextAlign.center,
                ),
                // Gradient text using ShaderMask
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: <Color>[
                      Color(0xFFC1272D), // Red color
                      Color(0xFF0075FF), // Blue color
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ).createShader(
                    Rect.fromLTWH(0.0, 0.0, bounds.width, bounds.height),
                  ),
                  child: Text(
                    'Hiremi 360',
                    style: TextStyle(
                      fontSize: screenWidth * 0.0518,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Color doesn't matter here as it's masked
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height:screenWidth*0.045 ,),
            // Text("Master Mobile and Web Design with expert-led training in User Interface (UI) and User Experience (UX) Design. Gain hands-on skills and real-world experience through our 360° Training + Internship, preparing you for success in today's digital world.",
            Text(widget.program['training_description'],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: screenWidth * 0.0359,
                //  fontWeight: FontWeight.bold,
                color: Colors.black,
              ),


            ),
            SizedBox(height:screenWidth*0.095,),
            Padding(
              padding:  EdgeInsets.only(left: screenWidth*0.075),
              child: Row(
                children: [
                  Icon(Icons.work_outline,size: screenWidth*0.065,color:Color(0xFFC1272D)), // Placeholder for the first icon
                  SizedBox(width: screenWidth*0.02),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Internship Company',
                        style: TextStyle(
                          fontSize: screenWidth*0.045,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${widget.program['company_name']}',
                        style: TextStyle(
                          fontSize: screenWidth * 0.029,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height:screenWidth*0.045 ,),
            Padding(
              padding:  EdgeInsets.only(left: screenWidth*0.075),
              child: Row(
                children: [
                  Icon(Icons.bar_chart,size: screenWidth*0.065,color: Color(0xFFC1272D),), // Placeholder for the first icon
                  SizedBox(width: screenWidth*0.02),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Beginner Level',
                        style: TextStyle(
                          fontSize: screenWidth*0.045,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'No prior experience required',
                        style: TextStyle(
                          fontSize: screenWidth * 0.027,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height:screenWidth*0.045 ,),
            Padding(
              padding:  EdgeInsets.only(left: screenWidth*0.075),
              child: Row(
                children: [
                  Icon(Icons.access_time,size: screenWidth*0.065,color: Color(0xFFC1272D),), // Placeholder for the first icon
                  SizedBox(width: screenWidth*0.02),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Duration ${widget.program['duration']}',
                        style: TextStyle(
                          fontSize: screenWidth*0.045,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Comprehensive Learning in Just ${widget.program['duration']}',
                        style: TextStyle(
                          fontSize: screenWidth * 0.027,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height:screenWidth*0.045 ,),

            Padding(
              padding:  EdgeInsets.only(right:screenWidth*0.3),
              child: Text("Skills you will gain",
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: screenWidth * 0.0568,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height:screenWidth*0.045 ,),


            // Wrap(
            //   crossAxisAlignment: WrapCrossAlignment.center,
            //   children: [
            //     Padding(
            //       padding: EdgeInsets.only(
            //         right: Sizes.responsiveSm(context),
            //         bottom: Sizes.responsiveSm(context),
            //       ),
            //       child: RoundedContainer(
            //         child: Text("${widget.program['skills_you_will_gain']}"),
            //         radius: 16.0,
            //         padding: EdgeInsets.symmetric(
            //           horizontal: screenWidth*0.02,
            //           vertical: screenWidth*0.02,
            //         ),
            //
            //         gradientBorder: LinearGradient(
            //           colors: [Colors.blue, Colors.red], // Gradient colors for the border
            //           begin: Alignment.topLeft,
            //           end: Alignment.bottomRight,
            //         ),
            //         color: Colors.transparent, // Background color of the container
            //         borderWidth: 3.0, // Border width
            //       ),
            //     ),
            //
            //   ],
            // ),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                // Split the skills string by comma and trim any whitespace
                ...widget.program['skills_you_will_gain']
                    .split(',')
                    .map((skill) => skill.trim()) // Trim each skill to remove excess spaces
                    .map((skill) => Padding(
                  padding: EdgeInsets.only(
                    right: Sizes.responsiveSm(context),
                    bottom: Sizes.responsiveSm(context),
                  ),
                  child: RoundedContainer(
                    child: Text(skill), // Display the skill in the container
                    // radius: 16.0,
                    radius: screenWidth,

                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.02,
                      vertical: screenWidth * 0.02,
                    ),
                    gradientBorder: LinearGradient(
                      colors: [Colors.blue, Colors.red], // Gradient colors for the border
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    color: Colors.transparent, // Background color of the container
                    borderWidth: screenWidth*0.006, // Border width
                  ),
                ))
                    .toList(), // Convert the Iterable to a List
              ],
            ),

            SizedBox(height:screenWidth*0.045 ,),

            SizedBox(height:screenWidth*0.045 ,),
            Container(
              width: screenWidth*0.845,
                decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFC1272D), width: 1),
                  borderRadius: BorderRadius.circular(screenWidth * 0.03),
                ),
              child: Column(
                children: [
                  SizedBox(height: screenWidth*0.03,),
                  Padding(
                    padding:  EdgeInsets.only(right:screenWidth*0.005),
                    child: Text("What you'll learn",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: screenWidth * 0.0568,
                        fontWeight: FontWeight.bold,
                        // color: Colors.black,
                        color: Color(0xFFC1272D),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: screenWidth * 0.068, top: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: (widget.program['What_you_Will_learm'] as String)
                          .split('\n')
                          .map((point) {
                        String trimmedPoint = point.trimRight(); // Remove only trailing spaces

                        return trimmedPoint.isNotEmpty
                            ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (trimmedPoint.trim().isNotEmpty) // Add tick only if not just spaces
                              Icon(Icons.done_all, color: Color(0xFFC1272D), size: screenWidth * 0.04),
                            if (trimmedPoint.trim().isNotEmpty)
                              SizedBox(width: screenWidth * 0.02),
                            Expanded(
                              child: Text(
                                trimmedPoint,
                                style: TextStyle(
                                  fontSize: screenWidth * 0.0329,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        )
                            : SizedBox(height: 8.0); // Maintain spacing but skip tick
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: screenWidth*0.03,)

                ],
              ),
            ),

            SizedBox(height:screenWidth*0.045 ,),
            Padding(
              padding:  EdgeInsets.only(right:screenWidth*0.13),
              child: Text("This Program includes",
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: screenWidth * 0.0568,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height:screenWidth*0.045 ,),
            // Text(widget.program['program_includes'],
            //   textAlign: TextAlign.center,
            //   style: TextStyle(
            //     fontSize: screenWidth * 0.0359,
            //     //  fontWeight: FontWeight.bold,
            //     color: Colors.black,
            //   ),
            //
            //
            // ),
            Padding(
              padding:  EdgeInsets.only(left:screenWidth*0.11),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Icon(Icons.check),
                      Text("🚀",
                        style: TextStyle(
                            fontSize: screenWidth*0.05
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.02), // Padding between icon and text
                      Text("Certificate of completion",
                        style: TextStyle(
                            fontSize: screenWidth*0.033,
                            color: Color(0xFFC1272D),
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01), // Space between each row
                  Row(
                    children: [

                      // Icon(Icons.check),
                      Text("🚀",
                        style: TextStyle(
                            fontSize: screenWidth*0.05
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                      Text("Working on live projects",
                        style: TextStyle(
                            fontSize: screenWidth*0.033,
                            color: Color(0xFFC1272D),
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  Row(
                    children: [
                      // Icon(Icons.check),
                      Text("🚀",
                        style: TextStyle(
                            fontSize: screenWidth*0.05
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                      Text("Portfolio building",
                        style: TextStyle(
                            fontSize: screenWidth*0.033,
                            color: Color(0xFFC1272D),
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  Row(
                    children: [
                      // Icon(Icons.check),
                      Text("🚀",
                        style: TextStyle(
                        fontSize: screenWidth*0.05
                      ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                      Text("Guaranteed Internship with client companies",

                        style: TextStyle(
                            fontSize: screenWidth*0.033,
                            color: Color(0xFFC1272D),
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.055), // Space between each row
            ElevatedButton(onPressed: (){
              Navigator.pop(context);
            }, child: Text("XSSXSX")),

            Container(
              height: screenWidth*0.1, // Set your desired height
              width: screenWidth*0.8, // Set your desired width
              decoration: BoxDecoration(
                // gradient: LinearGradient(
                //   colors: [
                //     Colors.blueAccent,
                //     Colors.redAccent
                //
                //   ], // Your gradient colors
                //   begin: Alignment.topLeft,
                //   end: Alignment.bottomRight,
                // ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFEFC59B), Color(0xFF95152F)], // Gradient colors
                ),
                borderRadius: BorderRadius.circular(10), // Optional: for rounded corners
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent, // Make the background transparent
                  elevation: 0, // Remove the button elevation
                ),
                onPressed: () {
                  // Your onPressed logic here
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EnrollpageTrainingAndInternship(program:widget.program)),
                  );
                },
                child: Text(
                  "Enroll Now",
                  style: TextStyle(color: Colors.white), // Text color
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.04), // Space between each row

          ],
        ),
      ),
    );
  }

}
