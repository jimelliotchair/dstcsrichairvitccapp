//signin_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dstcsri_chair_vitcc_app/screens/signup_screen.dart';
import 'package:dstcsri_chair_vitcc_app/screens/complete_profile_screen.dart';
import 'package:dstcsri_chair_vitcc_app/screens/patient_dashboard_screen.dart';
import 'package:dstcsri_chair_vitcc_app/screens/guided_patient_dashboard_screen.dart';
import 'package:dstcsri_chair_vitcc_app/screens/doctor_dashboard_screen.dart';
import 'package:dstcsri_chair_vitcc_app/screens/technician_dashboard_screen.dart';
import 'package:dstcsri_chair_vitcc_app/screens/researcher_dashboard_screen.dart';
import 'package:dstcsri_chair_vitcc_app/utils/activity_logger.dart';
class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});
  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool loading = false;
  bool obscurePassword = true;
  Future<void> signin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => loading = true);
    try {
      String input = emailController.text.trim();
      String password = passwordController.text.trim();
      String emailToUse = input;
      if (!input.contains("@")) {
        final doc = await FirebaseFirestore.instance
            .collection("loginIds")
            .doc(input)
            .get();
        if (!doc.exists) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Login ID not found"),
              backgroundColor: Colors.red,
            ),
          );
          setState(() => loading = false);
          return;
        }
        emailToUse = doc["email"];
      }
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailToUse, password: password);
      await userCredential.user!.reload();
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null && !user.emailVerified) {
        await FirebaseAuth.instance.signOut();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please verify your email before signing in"),
            backgroundColor: Colors.red,
          ),
        );
        setState(() => loading = false);
        return;
      }
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .get();
      final data = userDoc.data() as Map<String, dynamic>;
      bool profileCompleted = data["profileCompleted"] ?? false;
      String role = data["role"] ?? "";
      await ActivityLogger.logSignIn();
      if (!mounted) return;
      if (!profileCompleted) {
         
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const CompleteProfileScreen()),
        );
      } else {
        //await ActivityLogger.logSignIn();
        if (role == "Patient (Independent)") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const PatientDashboardScreen()),
          );
        } else if (role == "Patient (Dependent-Guided)") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const GuidedPatientDashboardScreen(),
            ),
          );
        } else if (role == "Doctor") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const DoctorDashboardScreen()),
          );
        } else if (role == "Technician") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const TechnicianDashboardScreen(),
            ),
          );
        } else if (role == "Researcher") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const ResearcherDashboardScreen(),
            ),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      String message = "Sign in failed";
      if (e.code == 'user-not-found') {
        message = "No user found";
      } else if (e.code == 'wrong-password') {
        message = "Incorrect password";
      } else if (e.code == 'invalid-email') {
        message = "Invalid email";
      } else if (e.code == 'invalid-credential') {
        message = "Invalid credentials";
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    }
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text(
          "Cognitive Health Assessment Indicative Record App -- Sign In",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 30),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Email or Login ID",
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return "Enter email";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: passwordController,
                obscureText: obscurePassword,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscurePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },
                  ),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return "Enter password";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: loading ? null : signin,
                child: loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text("Sign In"),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {},
                child: const Text("Forgot Email/Login ID?"),
              ),
              TextButton(
                onPressed: () async {
                  if (emailController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Enter your email first"),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                  try {
                    await FirebaseAuth.instance.sendPasswordResetEmail(
                      email: emailController.text.trim(),
                    );
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Password reset email sent"),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } on FirebaseAuthException catch (e) {
                    String message = "Failed to send reset email";
                    if (e.code == 'user-not-found') {
                      message = "No user found with this email";
                    } else if (e.code == 'invalid-email') {
                      message = "Invalid email address";
                    }
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(message),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: const Text("Forgot Password?"),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignupScreen(),
                        ),
                      );
                    },
                    child: const Text("Sign Up"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}