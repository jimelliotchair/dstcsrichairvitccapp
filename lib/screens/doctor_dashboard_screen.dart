import 'package:flutter/material.dart';
import 'package:dstcsri_chair_vitcc_app/screens/signin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dstcsri_chair_vitcc_app/utils/activity_logger.dart';
import 'create_patient_screen.dart';
//import 'assign_technician_screen.dart';
class DoctorDashboardScreen
    extends StatefulWidget {

  const DoctorDashboardScreen({
    super.key,
  });
   @override
  State<DoctorDashboardScreen> createState() =>
      _DoctorDashboardScreenState();
}

class _DoctorDashboardScreenState
    extends State<DoctorDashboardScreen> {

  String name = "";
  String loginId = "";

  @override
  void initState() {
    super.initState();
    loadUserDetails();
  }

  Future<void> loadUserDetails() async {

    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get();

    if (doc.exists) {

      final data = doc.data()!;

      setState(() {

        name = data["name"] ?? "";
        loginId = data["loginId"] ?? "";
      });
    }
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Doctor Dashboard",
        ),
         actions: [

    IconButton(

      icon: const Icon(Icons.logout),

      tooltip: "Sign Out",

      onPressed: () async {
await ActivityLogger.logSignOut();
        await FirebaseAuth.instance.signOut();

        if (!context.mounted) return;

        Navigator.pushAndRemoveUntil(

          context,

          MaterialPageRoute(
            builder: (_) => const SigninScreen(),
          ),

          (route) => false,
        );
      },
    ),
    Padding(
            padding: const EdgeInsets.only(
              right: 16,
            ),

            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,

              crossAxisAlignment:
                  CrossAxisAlignment.end,

              children: [

                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Text(
                  loginId,
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
  ],
  
      ),
      body: Padding(

  padding: const EdgeInsets.all(16),

  child: Column(

    children: [

      ElevatedButton(

        onPressed: () {

          Navigator.push(

            context,

            MaterialPageRoute(

              builder: (_) =>
                  const CreatePatientScreen(
                assignTechnician: false,
              ),
            ),
          );
        },

        child: const Text(
          "Create New Patient -",
        ),
      ),

      const SizedBox(height: 20),

      ElevatedButton(

        onPressed: () {

          Navigator.push(

            context,

            MaterialPageRoute(

              builder: (_) =>
                  const CreatePatientScreen(
                assignTechnician: true,
              ),
            ),
          );
        },

        child: const Text(
          "Create New Patient by Technician",
        ),
      ),
    ],
  ),
),
// body: Center(
//   child: Padding(
//     padding: const EdgeInsets.all(20),
//     child: Column(
//       mainAxisAlignment:
//           MainAxisAlignment.center,

//       children: [

//         const Text(
//           "Doctor Dashboard",
//           style: TextStyle(
//             fontSize: 22,
//             fontWeight: FontWeight.bold,
//           ),
//         ),

//         const SizedBox(height: 30),

//         ElevatedButton(
//           onPressed: () {

//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (_) =>
//                     const CreatePatientScreen(),
//               ),
//             );
//           },

//           child: const Text(
//             "Create New Patient",
//           ),
//         ),

//         const SizedBox(height: 20),

//         ElevatedButton(
//           onPressed: () {

//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (_) =>
//                     const AssignTechnicianScreen(),
//               ),
//             );
//           },

//           child: const Text(
//             "Create Patient By Technician",
//           ),
//         ),
//       ],
//     ),
//   ),
// ),
      // body: const Center(
      //   child: Text(
      //     "Doctor Dashboard",
      //   ),
      // ),
    );
  }
}