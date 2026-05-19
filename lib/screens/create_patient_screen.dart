import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreatePatientScreen extends StatefulWidget {

  final bool assignTechnician;

  const CreatePatientScreen({
    super.key,
    required this.assignTechnician,
  });

  @override
  State<CreatePatientScreen> createState() =>
      _CreatePatientScreenState();
}

class _CreatePatientScreenState
    extends State<CreatePatientScreen> {

  final _formKey = GlobalKey<FormState>();

  final nameController =
      TextEditingController();

  final emailController =
      TextEditingController();

  final phoneController =
      TextEditingController();

  final ageController =
      TextEditingController();

  String gender = "Male";

  String? selectedTechnicianId;

  List<Map<String, dynamic>>
      technicianList = [];

  bool loading = false;

  String hospitalId = "";

  @override
  void initState() {

    super.initState();

    loadDoctorHospital();
  }

  Future<void> loadDoctorHospital() async {

    User? user =
        FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final doc =
        await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .get();

    final data = doc.data() ?? {};

    hospitalId =
        data["hospitalId"] ?? "";

    if (widget.assignTechnician) {

      loadTechnicians();
    }
  }

  Future<void> loadTechnicians() async {

    final snapshot =
        await FirebaseFirestore.instance
            .collection("users")
            .where("role",
                isEqualTo: "Technician")
            .where("hospitalId",
                isEqualTo: hospitalId)
            .get();

    technicianList =
        snapshot.docs.map((e) {

      final d = e.data();

      return {

        "uid": e.id,

        "name": d["name"],

        "technicianId":
            d["loginId"],
      };

    }).toList();

    setState(() {});
  }

  Future<void> createPatient() async {

    if (!_formKey.currentState!.validate()) {return;}

    setState(() {
      loading = true;
    });

    try {

      final patientDoc =
          FirebaseFirestore.instance
              .collection("users")
              .doc();

      await patientDoc.set({

        "name":
            nameController.text.trim(),

        "email":
            emailController.text.trim(),

        "phone":
            phoneController.text.trim(),

        "age":
            ageController.text.trim(),

        "gender": gender,

        "role":
            "Patient (Dependent-Guided)",

        "hospitalId": hospitalId,

        "assignedTechnicianId":
            selectedTechnicianId,

        "profileCompleted": true,

        "createdByDoctor": true,

        "createdAt":
            FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content:
              Text("Patient created"),
          backgroundColor:
              Colors.green,
        ),
      );

      Navigator.pop(context);

    } catch (e) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Create Patient",
        ),
      ),

      body: Padding(

        padding:
            const EdgeInsets.all(16),

        child: Form(

          key: _formKey,

          child: ListView(

            children: [

              TextFormField(
                controller:
                    nameController,
                decoration:
                    const InputDecoration(
                  labelText: "Name",
                ),
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller:
                    emailController,
                decoration:
                    const InputDecoration(
                  labelText: "Email",
                ),
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller:
                    phoneController,
                decoration:
                    const InputDecoration(
                  labelText:
                      "Phone Number",
                ),
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller:
                    ageController,
                decoration:
                    const InputDecoration(
                  labelText: "Age",
                ),
              ),

              const SizedBox(height: 15),

              DropdownButtonFormField<String>(

                initialValue: gender,

                items: const [

                  DropdownMenuItem(
                    value: "Male",
                    child: Text("Male"),
                  ),

                  DropdownMenuItem(
                    value: "Female",
                    child: Text("Female"),
                  ),
                ],

                onChanged: (v) {

                  setState(() {

                    gender = v!;
                  });
                },
              ),

              if (widget.assignTechnician)
                const SizedBox(height: 20),

              if (widget.assignTechnician)
                DropdownButtonFormField<String>(

                  initialValue:
                      selectedTechnicianId,

                  decoration:
                      const InputDecoration(
                    labelText:
                        "Assign Technician",
                  ),

items:
    technicianList.map<DropdownMenuItem<String>>((t) {

  return DropdownMenuItem<String>(

    value: t["uid"].toString(),

    child: Text(
      "${t["name"]} (${t["technicianId"]})",
    ),
  );

}).toList(),

                  onChanged: (v) {

                    setState(() {

                      selectedTechnicianId =
                          v;
                    });
                  },
                ),

              const SizedBox(height: 30),

              ElevatedButton(

                onPressed:
                    loading
                        ? null
                        : createPatient,

                child: loading
                    ? const CircularProgressIndicator()
                    : const Text(
                        "Create Patient",
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}