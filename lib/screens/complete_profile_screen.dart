//complete_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dstcsri_chair_vitcc_app/utils/validators.dart';
import 'package:dstcsri_chair_vitcc_app/screens/patient_dashboard_screen.dart';
import 'package:dstcsri_chair_vitcc_app/screens/guided_patient_dashboard_screen.dart';
import 'package:dstcsri_chair_vitcc_app/screens/doctor_dashboard_screen.dart';
import 'package:dstcsri_chair_vitcc_app/screens/technician_dashboard_screen.dart';
import 'package:dstcsri_chair_vitcc_app/screens/researcher_dashboard_screen.dart';
import 'package:country_picker/country_picker.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:dstcsri_chair_vitcc_app/screens/signin_screen.dart';
class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});
  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final addressline1Controller = TextEditingController();
  final addressline2Controller = TextEditingController();
  final emergencyController = TextEditingController();
  final educationController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final medicationsController = TextEditingController();
  final conditionsController = TextEditingController();
  final occupationController = TextEditingController();
  final specializationController = TextEditingController();
  final registrationController = TextEditingController();
  final departmentController = TextEditingController();
  final technicianIdController = TextEditingController();
  final institutionController = TextEditingController();
  final domainController = TextEditingController();
  final stateController = TextEditingController();
  final pincodeController = TextEditingController();
  final countryController = TextEditingController();
  final doctorIdController = TextEditingController();
  final List<String> languageList = [
    "English",    "Tamil",     "Hindi",    "Malayalam",
    "Telugu",    "Kannada",     "Bengali",    "Marathi",
    "Gujarati",     "Punjabi",     "Urdu",     "Arabic",
    "French",     "German",     "Spanish",     "Chinese",
    "Japanese",     "Russian",     "Portuguese",     "Italian",
    "Korean",  ];
  String name = "";
  String email = "";
  String gender = "";
  String hospital = "";
  String loginId = "";
  String dobText = "";
  String? bloodGroup;
  String? headinjury;
  String? familyhistory;
  String? smoking;
  String? alcohol;
  String? physicalactivity;
  String? diet;
  String? sleep;
  String? stress;
  String? vision;
  String? hearing;
  String? educationlevel;
  String? employmentStatus;
  String? nativelanguage;
  List<String> languagesKnown = [];
  String? country;
  String role = "";
  bool loading = true;
  Widget readOnlyField(String label, String value) {
    return Padding(padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(initialValue: value,
        readOnly: true, decoration: InputDecoration(
          labelText: label, border: const OutlineInputBorder(),
          filled: true,),),);}

  @override
  void initState() {
    super.initState();
    loadRole();
  }

  Future<void> loadRole() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get();
    final data = doc.data()!;
    final profile = data["profile"] ?? {};
    role = data["role"] ?? "";
    name = data["name"] ?? "";
    email = data["email"] ?? "";
    gender = data["gender"] ?? "";
    hospital = data["hospitalName"] ?? "";
    loginId = data["loginId"] ?? "";
    country = profile["country"] ?? "";
    nativelanguage = profile["nativelanguage"] ?? "";
    languagesKnown = List<String>.from(profile["languagesknown"] ?? []);
    stateController.text = profile["state"] ?? "";
    pincodeController.text = profile["pincode"] ?? "";
    country = profile["country"] ?? "";
    heightController.text = profile["height"] ?? "";
    weightController.text = profile["weight"] ?? "";
    occupationController.text = profile["occupation"] ?? "";
    specializationController.text = profile["specialization"] ?? "";
    educationController.text = profile["education"] ?? "";
    addressline1Controller.text = profile["addressLine1"] ?? "";
    addressline2Controller.text = profile["addressLine2"] ?? "";
    phoneController.text = profile["phone"] ?? "";
    emergencyController.text = profile["emergencyContact"] ?? "";
    medicationsController.text = profile["medications"] ?? "";
    conditionsController.text = profile["conditions"] ?? "";
    bloodGroup = profile["bloodGroup"];
    educationlevel = profile["educationlevel"];
    employmentStatus = profile["employmentStatus"];
    headinjury = profile["headInjury"];
    familyhistory = profile["familyHistory"];
    vision = profile["vision"];
    hearing = profile["hearing"];
    sleep = profile["sleep"];
    stress = profile["stress"];
    physicalactivity = profile["physicalActivity"];
    diet = profile["diet"];
    alcohol = profile["alcohol"];
    smoking = profile["smoking"];
    educationController.text = profile["yearsOfExperience"] ?? "";
    technicianIdController.text = profile["technicianId"] ?? "";
    occupationController.text = profile["designation"] ?? "";
    departmentController.text = profile["department"] ?? "";
    Timestamp? dobTimestamp = data["dob"];
    if (dobTimestamp != null) {
      DateTime dob = dobTimestamp.toDate();
      dobText = "${dob.day}/${dob.month}/${dob.year}";
    }
    setState(() {
      loading = false;
    });
  }

  Future<void> saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    Map<String, dynamic> profileData = {};
    if (role.contains("Patient")) {
      profileData = {
        "bloodGroup": bloodGroup,
        "phone": phoneController.text.trim(),
        "addressLine1": addressline1Controller.text.trim(),
        "addressLine2": addressline2Controller.text.trim(),
        "emergencyContact": emergencyController.text.trim(),
        "education": educationController.text.trim(),
        "occupation": occupationController.text.trim(),
        "educationLevel": educationlevel,
        "employmentStatus": employmentStatus,
        "height": heightController.text.trim(),
        "weight": weightController.text.trim(),
        "medications": medicationsController.text.trim(),
        "conditions": conditionsController.text.trim(),
        "headInjury": headinjury,
        "familyHistory": familyhistory,
        "vision": vision,
        "hearing": hearing,
        "sleep": sleep,
        "stress": stress,
        "physicalActivity": physicalactivity,
        "diet": diet,
        "alcohol": alcohol,
        "smoking": smoking,
      };
    } else if (role == "Doctor") {
      profileData = {
        "doctorId": doctorIdController.text.trim(),
        "department": departmentController.text.trim(),
        "specialization": specializationController.text.trim(),
        "designation": occupationController.text.trim(),
        "educationlevel": educationlevel,
        "yearsOfExperience": educationController.text.trim(),
        "phone": phoneController.text.trim(),
        "state": stateController.text.trim(),
        "pincode": pincodeController.text.trim(),
        "country": country,
        "nativelanguage": nativelanguage,
        "languagesknown": languagesKnown,
      };
    } else if (role == "Technician") {
      profileData = {
        "technicianId": technicianIdController.text.trim(),
        "department": departmentController.text.trim(),
        "specialization": specializationController.text.trim(),
        "designation": occupationController.text.trim(),
        "educationlevel": educationlevel,
        "yearsOfExperience": educationController.text.trim(),
        "phone": phoneController.text.trim(),
        "state": stateController.text.trim(),
        "pincode": pincodeController.text.trim(),
        "country": country,
        "nativelanguage": nativelanguage,
        "languagesknown": languagesKnown,
      };
    } else if (role == "Researcher") {
      profileData = {
        "institution": institutionController.text.trim(),
        "domain": domainController.text.trim(),
        "department": departmentController.text.trim(),
        "specialization": specializationController.text.trim(),
        "designation": occupationController.text.trim(),
        "educationlevel": educationlevel,
        "yearsOfExperience": educationController.text.trim(),
        "phone": phoneController.text.trim(),
        "state": stateController.text.trim(),
        "pincode": pincodeController.text.trim(),
        "country": country,
        "nativelanguage": nativelanguage,
        "languagesknown": languagesKnown,
      };
    }
    await FirebaseFirestore.instance.collection("users").doc(user.uid).update({
      "profile": profileData,
      "profileCompleted": true,
    });
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Profile completed and saved successfully!"),
        backgroundColor: Colors.green,
      ),
    );
    if (role == "Patient (Independent)") {
      Navigator.pushReplacement(        context,
        MaterialPageRoute(builder: (_) => const PatientDashboardScreen()),
      );
    } else if (role == "Patient (Dependent-Guided)") {
      Navigator.pushReplacement(        context,
        MaterialPageRoute(builder: (_) => const GuidedPatientDashboardScreen()),
      );
    } else if (role == "Doctor") {
      Navigator.pushReplacement(        context,
        MaterialPageRoute(builder: (_) => const DoctorDashboardScreen()),
      );
    } else if (role == "Technician") {
      Navigator.pushReplacement(        context,
        MaterialPageRoute(builder: (_) => const TechnicianDashboardScreen()),
      );
    } else if (role == "Researcher") {
      Navigator.pushReplacement(        context,
        MaterialPageRoute(builder: (_) => const ResearcherDashboardScreen()),
      );
    }
  }

  Widget buildPatientFields() {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          initialValue: bloodGroup,
          decoration: const InputDecoration(labelText: "Blood Group"),
          items: const [
            DropdownMenuItem(value: "A+", child: Text("A+")),
            DropdownMenuItem(value: "A-", child: Text("A-")),
            DropdownMenuItem(value: "B+", child: Text("B+")),
            DropdownMenuItem(value: "B-", child: Text("B-")),
            DropdownMenuItem(value: "AB+", child: Text("AB+")),
            DropdownMenuItem(value: "AB-", child: Text("AB-")),
            DropdownMenuItem(value: "O+", child: Text("O+")),
            DropdownMenuItem(value: "O-", child: Text("O-")),
          ],
          onChanged: (value) {
            setState(() {
              bloodGroup = value;
            });
          },
          validator: (v) => Validators.validateDropdown(v, "blood group"),
        ),
        TextFormField(
          controller: phoneController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(labelText: "Phone Number"),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          validator: Validators.validatePhone,
        ),
        TextFormField(
          controller: addressline1Controller,
          decoration: const InputDecoration(labelText: "Address Line 1"),
          inputFormatters: [LengthLimitingTextInputFormatter(50)],
          validator: Validators.validateAddress,
        ),
        TextFormField(
          controller: addressline2Controller,
          decoration: const InputDecoration(labelText: "Address Line 2"),
          inputFormatters: [LengthLimitingTextInputFormatter(50)],
          validator: Validators.validateAddress,
        ),
        TextFormField(
          controller: emergencyController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(labelText: "Emergency Contact"),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          validator: Validators.validatePhone,
        ),
        TextFormField(
          controller: educationController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: "Years of Education"),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(2),
          ],
          validator: Validators.validateYearsOfEducation,
        ),
        DropdownButtonFormField<String>(
          initialValue: educationlevel,
          decoration: const InputDecoration(labelText: "Education Level"),
          items: const [
            DropdownMenuItem(value: "Middle School",child: Text("Middle School"),),
            DropdownMenuItem(value: "High School", child: Text("High School")),
            DropdownMenuItem(value: "Diploma", child: Text("Diploma")),
            DropdownMenuItem(value: "Bachelor's", child: Text("Bachelor's")),
            DropdownMenuItem(value: "Master's", child: Text("Master's")),
            DropdownMenuItem(value: "Doctorate", child: Text("Doctorate")),
            DropdownMenuItem(value: "Medical Doctor",child: Text("Medical Doctor"),),
            DropdownMenuItem(value: "Others", child: Text("Others")),
          ],
          onChanged: (value) {
            setState(() {
              educationlevel = value;
            });
          },

          validator: (v) => Validators.validateDropdown(v, "education level"),
        ),
        TextFormField(
          controller: occupationController,
          decoration: const InputDecoration(labelText: "Occupation"),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
            LengthLimitingTextInputFormatter(30),
          ],
          validator: Validators.validateOccupation,
        ),
        DropdownButtonFormField<String>(
          initialValue: employmentStatus,
          decoration: const InputDecoration(labelText: "Employment Status"),
          items: const [
            DropdownMenuItem(value: "Employed", child: Text("Employed")),
            DropdownMenuItem(value: "Unemployed", child: Text("Unemployed")),
            DropdownMenuItem(value: "Self-Employed",child: Text("Self-Employed"),),
            DropdownMenuItem(value: "Retired", child: Text("Retired")),
            DropdownMenuItem(value: "Student", child: Text("Student")),
            DropdownMenuItem(value: "Others", child: Text("Others")),
          ],
          onChanged: (value) {
            setState(() {
              employmentStatus = value;
            });
          },

          validator: (v) => Validators.validateDropdown(v, "employment status"),
        ),
        TextFormField(
          controller: heightController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: "Height (cm)"),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(3),
          ],
          validator: Validators.validateHeight,
        ),
        TextFormField(
          controller: weightController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: "Weight (kg)"),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(3),
          ],
          validator: Validators.validateWeight,
        ),
        TextFormField(
          controller: medicationsController,
          decoration: const InputDecoration(labelText: "Medications"),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
            LengthLimitingTextInputFormatter(30),
          ],
          validator: Validators.validateOccupation,
        ),
        TextFormField(
          controller: conditionsController,
          decoration: const InputDecoration(labelText: "Conditions"),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
            LengthLimitingTextInputFormatter(30),
          ],
          validator: Validators.validateOccupation,
        ),
        DropdownButtonFormField<String>(
          initialValue: headinjury,
          decoration: const InputDecoration(
            labelText: "Do you have a head injury?",
          ),
          items: const [
            DropdownMenuItem(value: "Yes", child: Text("Yes")),
            DropdownMenuItem(value: "No", child: Text("No")),
            DropdownMenuItem(value: "Others", child: Text("Others")),
            DropdownMenuItem(value: "Unknown", child: Text("Unknown")),
          ],

          onChanged: (value) {
            setState(() {
              headinjury = value;
            });
          },

          validator: (v) => Validators.validateDropdown(v, "head injury"),
        ),
        DropdownButtonFormField<String>(
          initialValue: familyhistory,
          decoration: const InputDecoration(
            labelText:
                "Do you have a family history of dementia, stroke, or Alzheimer's disease, etc.?",
          ),
          items: const [
            DropdownMenuItem(value: "Yes", child: Text("Yes")),
            DropdownMenuItem(value: "No", child: Text("No")),
            DropdownMenuItem(value: "Others", child: Text("Others")),
            DropdownMenuItem(value: "Unknown", child: Text("Unknown")),
          ],
          onChanged: (value) {
            setState(() {
              familyhistory = value;
            });
          },

          validator: (v) => Validators.validateDropdown(v, "family history"),
        ),
        DropdownButtonFormField<String>(
          initialValue: vision,
          decoration: const InputDecoration(
            labelText: "Do you have vision problems?",
          ),
          items: const [
            DropdownMenuItem(value: "No", child: Text("No")),
            DropdownMenuItem(value: "Yes (Corrected)",child: Text("Yes (Corrected)"),),
            DropdownMenuItem(value: "Yes (Uncorrected)",child: Text("Yes (Uncorrected)"),),
            DropdownMenuItem(value: "Unknown", child: Text("Unknown")),
          ],

          onChanged: (value) {
            setState(() {
              vision = value;
            });
          },

          validator: (v) => Validators.validateDropdown(v, "vision"),
        ),
        DropdownButtonFormField<String>(
          initialValue: hearing,
          decoration: const InputDecoration(
            labelText: "Do you have hearing problems?",
          ),
          items: const [
            DropdownMenuItem(value: "No", child: Text("No")),
            DropdownMenuItem(value: "Yes (Corrected)",child: Text("Yes (Corrected)"),),
            DropdownMenuItem(value: "Yes (Uncorrected)",child: Text("Yes (Uncorrected)"),),
            DropdownMenuItem(value: "Unknown", child: Text("Unknown")),
          ],

          onChanged: (value) {
            setState(() {
              hearing = value;
            });
          },

          validator: (v) => Validators.validateDropdown(v, "hearing"),
        ),
        DropdownButtonFormField<String>(
          initialValue: sleep,
          decoration: const InputDecoration(
            labelText: "How many hours (average) of sleep do you get?",
          ),
          items: const [
            DropdownMenuItem(
              value: "0 to 3 hours",
              child: Text("0 to 3 hours"),
            ),
            DropdownMenuItem(
              value: "3 to 6 hours",
              child: Text("3 to 6 hours"),
            ),
            DropdownMenuItem(
              value: "6 to 9 hours",
              child: Text("6 to 9 hours"),
            ),
            DropdownMenuItem(
              value: "More than 9 hours",
              child: Text("More than 9 hours"),
            ),
          ],

          onChanged: (value) {
            setState(() {
              sleep = value;
            });
          },

          validator: (v) => Validators.validateDropdown(v, "sleep"),
        ),
        DropdownButtonFormField<String>(
          initialValue: stress,
          decoration: const InputDecoration(
            labelText: "Do you experience stress?",
          ),
          items: const [
            DropdownMenuItem(value: "Yes", child: Text("Yes")),
            DropdownMenuItem(value: "No", child: Text("No")),
            DropdownMenuItem(value: "Others", child: Text("Others")),
            DropdownMenuItem(value: "Unknown", child: Text("Unknown")),
          ],

          onChanged: (value) {
            setState(() {
              stress = value;
            });
          },

          validator: (v) => Validators.validateDropdown(v, "stress"),
        ),
        DropdownButtonFormField<String>(
          initialValue: physicalactivity,
          decoration: const InputDecoration(
            labelText: "How much physical activity do you get?",
          ),
          items: const [
            DropdownMenuItem(
              value: "1 to 2 times a week",
              child: Text("1 to 2 times a week"),
            ),
            DropdownMenuItem(
              value: "2 to 4 times a week",
              child: Text("2 to 4 times a week"),
            ),
            DropdownMenuItem(
              value: "4 to 6 times a week",
              child: Text("4 to 6 times a week"),
            ),
            DropdownMenuItem(value: "Daily", child: Text("Daily")),
            DropdownMenuItem(value: "Unknown", child: Text("Unknown")),
          ],

          onChanged: (value) {
            setState(() {
              physicalactivity = value;
            });
          },

          validator: (v) => Validators.validateDropdown(v, "physical activity"),
        ),
        DropdownButtonFormField<String>(
          initialValue: diet,
          decoration: const InputDecoration(
            labelText: "Do you have a healthy diet?",
          ),
          items: const [
            DropdownMenuItem(value: "Yes", child: Text("Yes")),
            DropdownMenuItem(value: "No", child: Text("No")),
            DropdownMenuItem(value: "Others", child: Text("Others")),
            DropdownMenuItem(value: "Unknown", child: Text("Unknown")),
          ],
          onChanged: (value) {
            setState(() {
              diet = value;
            });
          },

          validator: (v) => Validators.validateDropdown(v, "diet"),
        ),
        DropdownButtonFormField<String>(
          initialValue: alcohol,
          decoration: const InputDecoration(
            labelText: "Do you consume alcohol?",
          ),
          items: const [
            DropdownMenuItem(value: "Never", child: Text("Never")),
            DropdownMenuItem(
              value: "Occasionally",
              child: Text("Occasionally"),
            ),
            DropdownMenuItem(value: "Regularly", child: Text("Regularly")),
            DropdownMenuItem(value: "Formerly", child: Text("Formerly")),
            DropdownMenuItem(value: "Others", child: Text("Others")),
          ],

          onChanged: (value) {
            setState(() {
              alcohol = value;
            });
          },

          validator: (v) => Validators.validateDropdown(v, "alcohol"),
        ),
        DropdownButtonFormField<String>(
          initialValue: smoking,
          decoration: const InputDecoration(labelText: "Do you smoke?"),
          items: const [
            DropdownMenuItem(value: "Never", child: Text("Never")),
            DropdownMenuItem(
              value: "Occasionally",
              child: Text("Occasionally"),
            ),
            DropdownMenuItem(value: "Regularly", child: Text("Regularly")),
            DropdownMenuItem(value: "Formerly", child: Text("Formerly")),
            DropdownMenuItem(value: "Others", child: Text("Others")),
          ],

          onChanged: (value) {
            setState(() {
              smoking = value;
            });
          },

          validator: (v) => Validators.validateDropdown(v, "smoking"),
        ),
      ],
    );
  }

  Widget buildDoctorFields() {
    return Column(
      children: [
        TextFormField(
          controller: doctorIdController,
          decoration: const InputDecoration(labelText: "Doctor ID"),
          validator: Validators.validateTechnicianId,
        ),
        TextFormField(
          controller: departmentController,
          decoration: const InputDecoration(labelText: "Department"),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
            LengthLimitingTextInputFormatter(30),
          ],
          validator: Validators.validateOccupation,
        ),
        TextFormField(
          controller: specializationController,
          decoration: const InputDecoration(labelText: "Specialization"),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
            LengthLimitingTextInputFormatter(30),
          ],
          validator: Validators.validateOccupation,
        ),
        TextFormField(
          controller: occupationController,
          decoration: const InputDecoration(labelText: "Designation"),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
            LengthLimitingTextInputFormatter(30),
          ],
          validator: Validators.validateOccupation,
        ),
        DropdownButtonFormField<String>(
          initialValue: educationlevel,
          decoration: const InputDecoration(labelText: "Education Level"),
          items: const [
            DropdownMenuItem(
              value: "Middle School",
              child: Text("Middle School"),
            ),
            DropdownMenuItem(value: "High School", child: Text("High School")),
            DropdownMenuItem(value: "Diploma", child: Text("Diploma")),
            DropdownMenuItem(value: "Bachelor's", child: Text("Bachelor's")),
            DropdownMenuItem(value: "Master's", child: Text("Master's")),
            DropdownMenuItem(value: "Doctorate", child: Text("Doctorate")),
            DropdownMenuItem(
              value: "Medical Doctor",
              child: Text("Medical Doctor"),
            ),
            DropdownMenuItem(value: "Others", child: Text("Others")),
          ],

          onChanged: (value) {
            setState(() {
              educationlevel = value;
            });
          },

          validator: (v) => Validators.validateDropdown(v, "education level"),
        ),
        TextFormField(
          controller: educationController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: "Years of Experience"),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(2),
          ],
          validator: Validators.validateYearsOfEducation,
        ),
        TextFormField(
          controller: phoneController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(labelText: "Phone Number"),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          validator: Validators.validatePhone,
        ),
        TextFormField(
          controller: stateController,
          decoration: const InputDecoration(labelText: "State"),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
            LengthLimitingTextInputFormatter(30),
          ],
          validator: Validators.validateOccupation,
        ),
        TextFormField(
          controller: pincodeController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(labelText: "Pin Code"),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(6),
          ],
          validator: Validators.validatePincode,
        ),
        TextFormField(
          readOnly: true,
          controller: TextEditingController(text: country ?? ""),
          decoration: const InputDecoration(
            labelText: "Country",
            suffixIcon: Icon(Icons.arrow_drop_down),
          ),

          onTap: () {
            showCountryPicker(
              context: context,
              showPhoneCode: false,
              onSelect: (Country selectedCountry) {
                setState(() {
                  country = selectedCountry.name;
                });
              },
            );
          },

          validator: (value) {
            if (country == null || country!.trim().isEmpty) {
              return "Select country";
            }

            return null;
          },
        ),
        MultiSelectDialogField(
          items: languageList.map((e) => MultiSelectItem(e, e)).toList(),
          title: const Text("Languages Known"),
          buttonText: const Text("Languages Known"),
          searchable: true,
          listType: MultiSelectListType.CHIP,
          initialValue: languagesKnown,
          onConfirm: (values) {
            setState(() {
              languagesKnown = values.cast<String>();

              // Reset native language if removed
              if (!languagesKnown.contains(nativelanguage)) {
                nativelanguage = null;
              }
            });
          },

          validator: (values) {
            if (values == null || values.isEmpty) {
              return "Select at least one language";
            }

            return null;
          },
        ),
        DropdownButtonFormField<String>(
          initialValue: nativelanguage,

          decoration: const InputDecoration(labelText: "Native Language"),

          items: languagesKnown.map((language) {
            return DropdownMenuItem(value: language, child: Text(language));
          }).toList(),

          onChanged: (value) {
            setState(() {
              nativelanguage = value;
            });
          },

          validator: (v) {
            if (v == null || v.isEmpty) {
              return "Select native language";
            }

            return null;
          },
        ),
      ],
    );
  }

  Widget buildTechnicianFields() {
    return Column(
      children: [
        TextFormField(
          controller: technicianIdController,
          decoration: const InputDecoration(labelText: "Technician ID"),
          validator: Validators.validateTechnicianId,
        ),
        TextFormField(
          controller: departmentController,
          decoration: const InputDecoration(labelText: "Department"),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
            LengthLimitingTextInputFormatter(30),
          ],
          validator: Validators.validateOccupation,
        ),
        TextFormField(
          controller: specializationController,
          decoration: const InputDecoration(labelText: "Specialization"),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
            LengthLimitingTextInputFormatter(30),
          ],
          validator: Validators.validateOccupation,
        ),
        TextFormField(
          controller: occupationController,
          decoration: const InputDecoration(labelText: "Designation"),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
            LengthLimitingTextInputFormatter(30),
          ],
          validator: Validators.validateOccupation,
        ),
        DropdownButtonFormField<String>(
          initialValue:
              const [
                "Middle School",  "High School",
                "Diploma",    "Bachelor's",
                "Master's",    "Doctorate",
                "Medical Doctor",  "Others",
              ].contains(educationlevel)
              ? educationlevel
              : null,
          decoration: const InputDecoration(labelText: "Education Level"),
          items: const [
            DropdownMenuItem(
              value: "Middle School",
              child: Text("Middle School"),
            ),
            DropdownMenuItem(value: "High School", child: Text("High School")),
            DropdownMenuItem(value: "Diploma", child: Text("Diploma")),
            DropdownMenuItem(value: "Bachelor's", child: Text("Bachelor's")),
            DropdownMenuItem(value: "Master's", child: Text("Master's")),
            DropdownMenuItem(value: "Doctorate", child: Text("Doctorate")),
            DropdownMenuItem(
              value: "Medical Doctor",
              child: Text("Medical Doctor"),
            ),
            DropdownMenuItem(value: "Others", child: Text("Others")),
          ],

          onChanged: (value) {
            setState(() {
              educationlevel = value;
            });
          },

          validator: (v) => Validators.validateDropdown(v, "education level"),
        ),
        TextFormField(
          controller: educationController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: "Years of Experience"),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(2),
          ],
          validator: Validators.validateYearsOfEducation,
        ),
        TextFormField(
          controller: phoneController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(labelText: "Phone Number"),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          validator: Validators.validatePhone,
        ),
        TextFormField(
          controller: stateController,
          decoration: const InputDecoration(labelText: "State"),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),

            LengthLimitingTextInputFormatter(30),
          ],
          validator: Validators.validateOccupation,
        ),
        TextFormField(
          controller: pincodeController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(labelText: "Pin Code"),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(6),
          ],
          validator: Validators.validatePincode,
        ),
        TextFormField(
          readOnly: true,
          controller: TextEditingController(text: country ?? ""),
          decoration: const InputDecoration(
            labelText: "Country",
            suffixIcon: Icon(Icons.arrow_drop_down),
          ),

          onTap: () {
            showCountryPicker(
              context: context,
              showPhoneCode: false,
              onSelect: (Country selectedCountry) {
                setState(() {
                  country = selectedCountry.name;
                });
              },
            );
          },

          validator: (value) {
            if (country == null || country!.trim().isEmpty) {
              return "Select country";
            }

            return null;
          },
        ),
        MultiSelectDialogField(
          items: languageList.map((e) => MultiSelectItem(e, e)).toList(),
          title: const Text("Languages Known"),
          buttonText: const Text("Select Languages Known"),
          searchable: true,
          listType: MultiSelectListType.CHIP,
          initialValue: languagesKnown,
          onConfirm: (values) {
            setState(() {
              languagesKnown = values.cast<String>();

              if (!languagesKnown.contains(nativelanguage)) {
                nativelanguage = null;
              }
            });
          },

          validator: (values) {
            if (values == null || values.isEmpty) {
              return "Select at least one language";
            }

            return null;
          },
        ),
        DropdownButtonFormField<String>(
          initialValue: nativelanguage,
          decoration: const InputDecoration(labelText: "Native Language"),
          items: languagesKnown.map((language) {
            return DropdownMenuItem(value: language, child: Text(language));
          }).toList(),

          onChanged: (value) {
            setState(() {
              nativelanguage = value;
            });
          },

          validator: (v) {
            if (v == null || v.isEmpty) {
              return "Select native language";
            }

            return null;
          },
        ),
      ],
    );
  }

  Widget buildResearcherFields() {
    return Column(
      children: [
        TextFormField(
          controller: institutionController,
          decoration: const InputDecoration(labelText: "Institution"),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
            LengthLimitingTextInputFormatter(30),
          ],
          validator: Validators.validateOccupation,
        ),
        TextFormField(
          controller: domainController,
          decoration: const InputDecoration(labelText: "Research Domain"),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
            LengthLimitingTextInputFormatter(30),
          ],
          validator: Validators.validateOccupation,
        ),
        TextFormField(
          controller: departmentController,
          decoration: const InputDecoration(labelText: "Department"),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
            LengthLimitingTextInputFormatter(30),
          ],
          validator: Validators.validateOccupation,
        ),
        TextFormField(
          controller: specializationController,
          decoration: const InputDecoration(labelText: "Specialization"),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
            LengthLimitingTextInputFormatter(30),
          ],
          validator: Validators.validateOccupation,
        ),
        TextFormField(
          controller: occupationController,
          decoration: const InputDecoration(labelText: "Designation"),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
            LengthLimitingTextInputFormatter(30),
          ],
          validator: Validators.validateOccupation,
        ),
        DropdownButtonFormField<String>(
          initialValue: educationlevel,
          decoration: const InputDecoration(labelText: "Education Level"),
          items: const [
            DropdownMenuItem(
              value: "Middle School",
              child: Text("Middle School"),
            ),
            DropdownMenuItem(value: "High School", child: Text("High School")),
            DropdownMenuItem(value: "Diploma", child: Text("Diploma")),
            DropdownMenuItem(value: "Bachelor's", child: Text("Bachelor's")),
            DropdownMenuItem(value: "Master's", child: Text("Master's")),
            DropdownMenuItem(value: "Doctorate", child: Text("Doctorate")),
            DropdownMenuItem(
              value: "Medical Doctor",
              child: Text("Medical Doctor"),
            ),
            DropdownMenuItem(value: "Others", child: Text("Others")),
          ],
          onChanged: (value) {
            setState(() {
              educationlevel = value;
            });
          },

          validator: (v) => Validators.validateDropdown(v, "education level"),
        ),
        TextFormField(
          controller: educationController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: "Years of Experience"),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(2),
          ],
          validator: Validators.validateYearsOfEducation,
        ),
        TextFormField(
          controller: phoneController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(labelText: "Phone Number"),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          validator: Validators.validatePhone,
        ),
        TextFormField(
          controller: stateController,
          decoration: const InputDecoration(labelText: "State"),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
            LengthLimitingTextInputFormatter(30),
          ],
          validator: Validators.validateOccupation,
        ),
        TextFormField(
          controller: pincodeController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(labelText: "Pin Code"),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(6),
          ],
          validator: Validators.validatePincode,
        ),
        TextFormField(
          readOnly: true,
          controller: TextEditingController(text: country ?? ""),
          decoration: const InputDecoration(
            labelText: "Country",
            suffixIcon: Icon(Icons.arrow_drop_down),
          ),

          onTap: () {
            showCountryPicker(
              context: context,
              showPhoneCode: false,
              onSelect: (Country selectedCountry) {
                setState(() {
                  country = selectedCountry.name;
                });
              },
            );
          },

          validator: (value) {
            if (country == null || country!.trim().isEmpty) {
              return "Select country";
            }

            return null;
          },
        ),
        MultiSelectDialogField(
          items: languageList.map((e) => MultiSelectItem(e, e)).toList(),
          title: const Text("Languages Known"),
          buttonText: const Text("Select Languages Known"),
          searchable: true,
          listType: MultiSelectListType.CHIP,
          initialValue: languagesKnown,
          onConfirm: (values) {
            setState(() {
              languagesKnown = values.cast<String>();

              if (!languagesKnown.contains(nativelanguage)) {
                nativelanguage = null;
              }
            });
          },

          validator: (values) {
            if (values == null || values.isEmpty) {
              return "Select at least one language";
            }

            return null;
          },
        ),
        DropdownButtonFormField<String>(
          initialValue: nativelanguage,
          decoration: const InputDecoration(labelText: "Native Language"),
          items: languagesKnown.map((language) {
            return DropdownMenuItem(value: language, child: Text(language));
          }).toList(),

          onChanged: (value) {
            setState(() {
              nativelanguage = value;
            });
          },

          validator: (v) {
            if (v == null || v.isEmpty) {
              return "Select native language";
            }

            return null;
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(title: Text("$role Profile page"),
        actions: [

    IconButton(

      icon: const Icon(Icons.logout),

      tooltip: "Sign Out",

      onPressed: () async {

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
  ],),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              readOnlyField("Name", name),
              readOnlyField("Email", email),
              readOnlyField("Role", role),
              readOnlyField("Gender", gender),
              readOnlyField("Hospital", hospital),
              readOnlyField("Date of Birth", dobText),
              readOnlyField("Login ID", loginId),
              const SizedBox(height: 20),
              if (role.contains("Patient")) buildPatientFields(),
              if (role == "Doctor") buildDoctorFields(),
              if (role == "Technician") buildTechnicianFields(),
              if (role == "Researcher") buildResearcherFields(),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: saveProfile,
                child: const Text("Save Profile"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
