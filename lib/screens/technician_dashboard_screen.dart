import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dstcsri_chair_vitcc_app/screens/signin_screen.dart';
import 'package:dstcsri_chair_vitcc_app/utils/activity_logger.dart';

class TechnicianDashboardScreen
    extends StatefulWidget {

  const TechnicianDashboardScreen({
    super.key,
  });
@override
  State<TechnicianDashboardScreen> createState() =>
      _TechnicianDashboardScreenState();
}

class _TechnicianDashboardScreenState
    extends State<TechnicianDashboardScreen> {

  String name = "";
  String loginId = "";
  bool hasPatients = false;
  @override
  void initState() {
    super.initState();
    loadUserDetails();
      checkAssignedPatients();
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
  Future<void> checkAssignedPatients() async {

  User? currentUser =
      FirebaseAuth.instance.currentUser;

  if (currentUser == null) return;

  final snapshot =
      await FirebaseFirestore.instance
          .collection("users")
          .where(
            "assignedTechnicianId",
            isEqualTo: currentUser.uid,
          )
          .get();

  setState(() {

    hasPatients =
        snapshot.docs.isNotEmpty;
  });
}
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Technician Dashboard",
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
body: Center(

  child: hasPatients

      ? Column(

          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [

            const Text(
              "Technician Dashboard",
            ),

            const SizedBox(height: 20),

            ElevatedButton(

              onPressed: () {

                // OPEN GUIDED PATIENTS SCREEN
              },

              child: const Text(
                "Manage Guided Patients",
              ),
            ),
          ],
        )

      : const Text(
          "No patients assigned",
        ),
),
      // body: const Center(
      //   child: Text(
      //     "Technician Dashboard",
      //   ),
      // ),
    );
  }
}