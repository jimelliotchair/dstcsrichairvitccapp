import 'package:flutter/material.dart';
import 'package:dstcsri_chair_vitcc_app/screens/signin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dstcsri_chair_vitcc_app/utils/activity_logger.dart';

class GuidedPatientDashboardScreen
    extends StatelessWidget {

  const GuidedPatientDashboardScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Guided Patient Dashboard",
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
  ],
      ),

      body: const Center(
        child: Text(
          "Guided Patient Dashboard",
        ),
      ),
    );
  }
}