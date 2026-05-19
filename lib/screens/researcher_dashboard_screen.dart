import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dstcsri_chair_vitcc_app/screens/signin_screen.dart';
import 'package:dstcsri_chair_vitcc_app/utils/activity_logger.dart';

class ResearcherDashboardScreen
    extends StatefulWidget {

  const ResearcherDashboardScreen({
    super.key,
    
  });
 @override
  State<ResearcherDashboardScreen> createState() =>
      _ResearcherDashboardScreenState();
}

class _ResearcherDashboardScreenState
    extends State<ResearcherDashboardScreen> {

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
          "Researcher Dashboard",
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

      body: const Center(
        child: Text(
          "Researcher Dashboard",
        ),
      ),
    );
  }
}