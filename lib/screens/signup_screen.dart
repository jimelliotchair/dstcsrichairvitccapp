//signup_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:dstcsri_chair_vitcc_app/utils/validators.dart';
import 'package:dstcsri_chair_vitcc_app/screens/signin_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String gender = "Male";
  String role = "Patient (Independent)";
  DateTime? dob;
  String? dobErrorText;
  bool loading = false;
  bool get isGuidedPatient => role == "Patient (Dependent-Guided)";
  List<Map<String, String>> hospitals = [
    {"id": "HOSP001", "name": "Hospital A"},
    {"id": "HOSP002", "name": "Hospital B"},
    {"id": "HOSP003", "name": "Hospital C"},
    {"id": "HOSP004", "name": "Hospital D"},
  ];
  String selectedHospitalId = "HOSP001";
  String selectedHospitalName = "Hospital A";
  String generateLoginId({
    required String role,
    required String name,
    required String gender,
    required DateTime dob,
    required String uid,
  }) {
    String roleAbbr = "";
    if (role == "Patient (Independent)") {
      roleAbbr = "PATIN";
    } else if (role == "Patient (Dependent-Guided)") {
      roleAbbr = "PATDE";
    } else if (role == "Technician") {
      roleAbbr = "TECH";
    } else if (role == "Doctor") {
      roleAbbr = "DOCT";
    } else if (role == "Researcher") {
      roleAbbr = "RESE";
    } else {
      roleAbbr = "USER";
    }
    String namePart = name.length >= 2
        ? name.substring(0, 2).toUpperCase()
        : name.toUpperCase();
    String genderAbbr = gender[0].toUpperCase();
    String month = dob.month.toString().padLeft(2, '0');
    String year = dob.year.toString();
    String day = dob.day.toString().padLeft(2, '0');
    String random = (100 + DateTime.now().millisecond % 900).toString();
    String uidPart = uid.substring(uid.length - 2).toUpperCase();
    return "$roleAbbr$namePart$genderAbbr$month$year$day$random$uidPart";
  }

  Future<void> signup() async {
    if (!_formKey.currentState!.validate()) return;
    final error = Validators.validateDOB(dob);
    setState(() {
      dobErrorText = error;
    });
    if (error != null) return;
    setState(() => loading = true);
    try {
      UserCredential userCred = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );
      String uid = userCred.user!.uid;
      await userCred.user!.sendEmailVerification();
      String loginId = generateLoginId(
        role: role,
        name: nameController.text.trim(),
        gender: gender,
        dob: dob!,
        uid: uid,
      );
      await FirebaseFirestore.instance.collection("users").doc(uid).set({
        "uid": uid,
        "name": nameController.text.trim(),
        "email": emailController.text.trim(),
        "gender": gender,
        "dob": dob,
        "hospitalId": selectedHospitalId,
        "hospitalName": selectedHospitalName,
        "role": role,
        "loginId": loginId,
        "isVerified": false,
        "profileCompleted": false,
        "patientCreationEnabled": false,
        "createdAt": FieldValue.serverTimestamp(),
      });
      await FirebaseFirestore.instance.collection("loginIds").doc(loginId).set({
        "email": emailController.text.trim(),
      });
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: const Text("Signup Successful"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Verification email has been sent."),
                const SizedBox(height: 15),
                const Text(
                  "Your Login ID:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                SelectableText(
                  loginId,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "(Kindly make a note of this for future use)",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const SigninScreen()),
                  );
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      String message = "Signup failed";
      if (e.code == 'email-already-in-use') {
        message = "Email is already registered";
      } else if (e.code == 'invalid-email') {
        message = "Invalid email address";
      } else if (e.code == 'weak-password') {
        message = "Password is too weak";
      } else if (e.code == 'network-request-failed') {
        message = "No internet connection";
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
      debugPrint("Signup error: $e");
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Something went wrong"),
          backgroundColor: Colors.red,
        ),
      );
      debugPrint("General error: $e");
    }
    setState(() => loading = false);
  }

  Future<void> pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(1950),
      lastDate: DateTime.now().subtract(const Duration(days: 1)),
    );
    if (picked != null) {
      setState(() {
        dob = picked;
        dobErrorText = null; // ✅ clear error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text(
          "Cognitive Health Assessment Indicative Record Application -- Signup",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField(
                hint: const Text("Select Role"),
                initialValue: null,
                items:
                    [
                          "Patient (Independent)",
                          "Patient (Dependent-Guided)",
                          "Technician",
                          "Doctor",
                          "Researcher",
                        ]
                        .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                        .toList(),
                onChanged: (v) {
                  setState(() {
                    role = v!;
                  });
                },
                decoration: const InputDecoration(labelText: "Role"),
                validator: (v) => v == null ? "Select role" : null,
              ),
              if (isGuidedPatient)
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    "Dependent-Guided patients must be registered by a technician or doctor.",
                    style: TextStyle(color: Colors.red, fontSize: 13),
                  ),
                ),
              const SizedBox(height: 20),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name"),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z@ ]')),
                  LengthLimitingTextInputFormatter(50),
                ],
                validator: (v) {
                  final value = v?.trim() ?? "";
                  if (value.isEmpty) return "Enter name";
                  if (value.length > 50) {
                    return "Maximum 50 characters allowed";
                  }
                  if (!RegExp(r'^[a-zA-Z@ ]+$').hasMatch(value)) {
                    return "Only alphabets, spaces and @ allowed";
                  }
                  return null;
                },
              ),
              DropdownButtonFormField(
                hint: const Text("Select Gender"),
                initialValue: null,
                items: ["Male", "Female", "Prefer not to say", "Other"]
                    .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                    .toList(),
                onChanged: (v) {
                  setState(() {
                    gender = v!;
                  });
                },
                decoration: const InputDecoration(labelText: "Gender"),
                validator: (v) => v == null ? "Select gender" : null,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(
                      dob == null
                          ? "Select Date of Birth"
                          : "${dob!.day}/${dob!.month}/${dob!.year}",
                    ),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: pickDate,
                  ),
                  if (dobErrorText != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 16, top: 4),
                      child: Text(
                        dobErrorText!,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                ],
              ),
              DropdownButtonFormField<String>(
                hint: const Text("Select Hospital"),
                initialValue: null,
                decoration: const InputDecoration(labelText: "Hospital"),
                validator: (v) => v == null ? "Select hospital" : null,
                items: hospitals.map((hospital) {
                  return DropdownMenuItem<String>(
                    value: hospital["id"],
                    child: Text(hospital["name"]!),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedHospitalId = value!;
                    selectedHospitalName = hospitals.firstWhere(
                      (h) => h["id"] == value,
                    )["name"]!;
                  });
                },
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email"),
                validator: Validators.validateEmail,
              ),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Password"),
                validator: Validators.validatePassword,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: loading || isGuidedPatient ? null : signup,
                child: loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text("Sign Up (New account)"),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SigninScreen(),
                    ),
                  );
                },
                child: const Text("Already have an account? Sign In"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
