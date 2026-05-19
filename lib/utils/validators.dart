//validators.dart
class Validators {
  static String? validateDOB(DateTime? dob) {
    if (dob == null) return "Select Date of Birth";
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final dobDate = DateTime(dob.year, dob.month, dob.day);
    if (dobDate == todayDate) {
      return "Date of birth cannot be today";
    }
    if (dobDate.isAfter(todayDate)) {
      return "Date of birth cannot be in the future";
    }
    return null;
  }

  static String? validateEmail(String? v) {
    final value = v?.trim() ?? "";
    if (value.isEmpty) return "Enter email";
    final emailRegex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    );
    if (!emailRegex.hasMatch(value)) {
      return "Enter valid email";
    }
    return null;
  }
  static String? validateTechnicianId(String? v) {

  final value = v?.trim() ?? "";

  if (value.isEmpty) {
    return "Enter Technician ID";
  }

  if (value.length > 10) {
    return "Maximum 10 characters allowed";
  }

  return null;
}
  static String? validatePassword(String? v) {
    final value = v ?? "";
    if (value.isEmpty) return "Enter password";
    if (value.length < 6) {
      return "Minimum 6 characters required";
    }
    if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*?&]+$')
        .hasMatch(value)) {
      return "Include letters and numbers";
    }
    return null;
  }
  static String? validateEmailOrLoginId(String? v) {
  final value = v?.trim() ?? "";
  if (value.isEmpty) {
    return "Enter Email or Login ID";
  }
  if (value.contains("@")) {
    final emailRegex = RegExp(
        r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,4}$',
    );
    if (!emailRegex.hasMatch(value)) {
      return "Enter valid email";
    }
  }
  return null;
}
static String? validateDropdown(
  String? value,
  String fieldName,
) {
  if (value == null || value.isEmpty) {
    return "Select $fieldName";
  }
  return null;
}
static String? validatePhone(String? v) {
  final value = v?.trim() ?? "";
  if (value.isEmpty) {
    return "Enter phone number";
  }
  if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
    return "Only digits allowed";
  }
  if (value.length != 10) {
    return "Phone number must be 10 digits";
  }
  return null;
}
static String? validateAddress(String? v) {

  final value = v?.trim() ?? "";

  if (value.isEmpty) {
    return "Enter address";
  }

  if (value.length > 50) {
    return "Maximum 50 characters allowed";
  }

  return null;
}
static String? validateYearsOfEducation(
    String? v) {

  final value = v?.trim() ?? "";

  if (value.isEmpty) {
    return "Enter years of education";
  }

  if (!RegExp(r'^[0-9]+$')
      .hasMatch(value)) {

    return "Only digits allowed";
  }

  if (value.length > 2) {
    return "Maximum 2 digits allowed";
  }

  int years = int.parse(value);

  if (years < 1 || years > 99) {
    return "Enter valid years";
  }

  return null;
}
static String? validateHeight(
    String? v) {

  final value = v?.trim() ?? "";

  if (value.isEmpty) {
    return "Enter height";
  }

  if (!RegExp(r'^[0-9]+$')
      .hasMatch(value)) {

    return "Only digits allowed";
  }

  if (value.length > 3) {
    return "Maximum 3 digits allowed";
  }

  int height = int.parse(value);

  if (height < 1 || height > 999) {
    return "Enter valid height";
  }

  return null;
}
static String? validateWeight(
    String? v) {

  final value = v?.trim() ?? "";

  if (value.isEmpty) {
    return "Enter weight";
  }

  if (!RegExp(r'^[0-9]+$')
      .hasMatch(value)) {

    return "Only digits allowed";
  }

  if (value.length > 3) {
    return "Maximum 3 digits allowed";
  }

  int weight = int.parse(value);

  if (weight < 1 || weight > 999) {
    return "Enter valid weight";
  }

  return null;
}
static String? validateOccupation(String? v) {

  final value = v?.trim() ?? "";

  if (value.isEmpty) {
    return "Enter occupation";
  }

  if (value.length > 30) {
    return "Maximum 30 characters allowed";
  }

  if (!RegExp(r'^[a-zA-Z ]+$')
      .hasMatch(value)) {

    return "Only alphabets and spaces allowed";
  }

  return null;
}
static String? validatePincode(String? v) {
  final value = v?.trim() ?? "";
  if (value.isEmpty) {
    return "Enter pincode";
  }
  if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
    return "Only digits allowed";
  }
  if (value.length != 6) {
    return "Pincode must be 6 digits";
  }
  return null;
}
}