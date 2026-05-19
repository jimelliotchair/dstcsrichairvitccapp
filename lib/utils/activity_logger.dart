import 'dart:io' show Platform;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:device_info_plus/device_info_plus.dart';

import 'package:universal_html/html.dart' as html;

import 'session_manager.dart';

class ActivityLogger {

  // =========================
  // DEVICE INFO
  // =========================
  static Future<String> getIpAddress() async {

  try {

    final response = await http.get(
      Uri.parse("https://ipapi.co/json/"),
    );

    if (response.statusCode == 200) {

      final data = jsonDecode(response.body);

      return data["ip"];
    }

  } catch (e) {

    //print("IP fetch error: $e");
  }

  return "";
}
static Future<Map<String, dynamic>>
    getNetworkInfo() async {

  try {

    late Uri url;

    if (kIsWeb) {

      url = Uri.parse(
        "https://ipapi.co/json/",
      );

    } else {

      url = Uri.parse(
        "https://ipwho.is/",
      );
    }

    final response =
        await http.get(url);

    if (response.statusCode == 200) {

      final data =
          jsonDecode(response.body);

      //print(data);

      if (kIsWeb) {

        return {

          "ipAddress":
              data["ip"]?.toString() ?? "",

          "location":
              [
                data["city"],
                data["region"],
                data["country_name"],
              ]
                  .where((e) =>
                      e != null &&
                      e.toString().trim().isNotEmpty)
                  .join(", "),

          "internetProvider":
              data["org"]?.toString() ?? "",
        };

      } else {

        return {

          "ipAddress":
              data["ip"]?.toString() ?? "",

          "location":
              [
                data["city"],
                data["region"],
                data["country"],
              ]
                  .where((e) =>
                      e != null &&
                      e.toString().trim().isNotEmpty)
                  .join(", "),

          "internetProvider":
              data["connection"] != null
                  ? data["connection"]["isp"]
                          ?.toString() ??
                      ""
                  : "",
        };
      }
    }

  } catch (e) {

    //print(
    //  "Network info error: $e",
    //);
  }

  return {

    "ipAddress": "",

    "location": "",

    "internetProvider": "",
  };
}
// static Future<Map<String, dynamic>>
//     getNetworkInfo() async {

//   try {

//     final response = await http.get(
//       Uri.parse("https://ipapi.co/json/"),
//     );

//     if (response.statusCode == 200) {

//       final data =
//           jsonDecode(response.body);

//       print(data);

//       return {

//         "ipAddress":
//             data["ip"]?.toString() ?? "",

//         "location":
//             [
//               data["city"],
//               data["region"],
//               data["country_name"],
//             ]
//                 .where((e) =>
//                     e != null &&
//                     e.toString().trim().isNotEmpty)
//                 .join(", "),

//         "internetProvider":
//             data["org"]?.toString() ?? "",
//       };
//     }

//   } catch (e) {

//     print("Network info error: $e");
//   }

//   return {

//     "ipAddress": "",

//     "location": "",

//     "internetProvider": "",
//   };
// }
// static Future<Map<String, dynamic>>
//     getNetworkInfo() async {

//   try {

//     final response = await http.get(
//       Uri.parse("https://ipwho.is/"),
//     );

//     if (response.statusCode == 200) {

//       final data =
//           jsonDecode(response.body);

//       print(data);

//       return {

//         "ipAddress":
//             data["ip"]?.toString() ?? "",

//         "location":
//             [
//               data["city"],
//               data["region"],
//               data["country"],
//             ]
//                 .where((e) =>
//                     e != null &&
//                     e.toString().trim().isNotEmpty)
//                 .join(", "),

//         "internetProvider":
//             data["connection"] != null
//                 ? data["connection"]["isp"]
//                         ?.toString() ??
//                     ""
//                 : "",
//       };
//     }

//   } catch (e) {

//     print("Network info error: $e");
//   }
//   return {

//     "ipAddress": "",

//     "location": "",

//     "internetProvider": "",


//   };
// }
  static Future<Map<String, dynamic>>
      getDeviceInfo() async {

    String device = "Unknown";

    String os = "Unknown";

    String browser = "Unknown";

    try {

      if (kIsWeb) {

        device = "Web";

        browser =
            html.window.navigator.userAgent;

        os =
            html.window.navigator.platform ??
            "Web";

      } else {

        DeviceInfoPlugin deviceInfo =
            DeviceInfoPlugin();

        if (Platform.isAndroid) {

          AndroidDeviceInfo androidInfo =
              await deviceInfo.androidInfo;

          device = androidInfo.model;

          os = "Android";

        } else if (Platform.isIOS) {

          IosDeviceInfo iosInfo =
              await deviceInfo.iosInfo;

          device = iosInfo.utsname.machine;

          os = "iOS";

        } else if (Platform.isWindows) {

          WindowsDeviceInfo windowsInfo =
              await deviceInfo.windowsInfo;

          device = windowsInfo.computerName;

          os = "Windows";

        } else if (Platform.isMacOS) {

          MacOsDeviceInfo macInfo =
              await deviceInfo.macOsInfo;

          device = macInfo.model;

          os = "macOS";

        } else if (Platform.isLinux) {

          LinuxDeviceInfo linuxInfo =
              await deviceInfo.linuxInfo;

          device = linuxInfo.name;

          os = "Linux";
        }
      }

    } catch (e) {

      //print("Device info error: $e");
    }
final networkInfo =
    await getNetworkInfo();
    return {

      "device": device,

      "browser": browser,

      "os": os,
  "ipAddress":
      networkInfo["ipAddress"],

  "location":
      networkInfo["location"],

  "internetProvider":
      networkInfo["internetProvider"],
         
    };
  }

  // =========================
  // SIGN IN
  // =========================

  static Future<void> logSignIn() async {

    try {

      User? user =
          FirebaseAuth.instance.currentUser;

      if (user == null) return;

      final userDoc =
          await FirebaseFirestore.instance
              .collection("users")
              .doc(user.uid)
              .get();

      final data = userDoc.data() ?? {};

      final deviceInfo =
          await getDeviceInfo();

      final docRef =
          await FirebaseFirestore.instance
              .collection("activity_logs")
              .add({

        "uid": user.uid,

        "name": data["name"] ?? "",

        "loginId": data["loginId"] ?? "",

        "email": data["email"] ?? "",

        "role": data["role"] ?? "",

        "signInTime":
            FieldValue.serverTimestamp(),

        "signOutTime": null,

        "sessionStatus": "Active",

        "device":
            deviceInfo["device"],

        "browser":
            deviceInfo["browser"],

        "os":
            deviceInfo["os"],

        "ipAddress":
            deviceInfo["ipAddress"],
            "location":
    deviceInfo["location"],

"internetProvider":
    deviceInfo["internetProvider"],
      });

      SessionManager.currentSessionId =
          docRef.id;

    } catch (e) {

      //print("Sign in log error: $e");
    }
  }

  // =========================
  // SIGN OUT
  // =========================
static Future<void> logSignOut() async {

  try {

    String? sessionId =
        SessionManager.currentSessionId;

    if (sessionId == null) return;

    final doc =
        await FirebaseFirestore.instance
            .collection("activity_logs")
            .doc(sessionId)
            .get();

    final data = doc.data();

    if (data == null) return;

    Timestamp? signInTimestamp =
        data["signInTime"];

    DateTime signInTime =
        signInTimestamp!.toDate();

    DateTime signOutTime =
        DateTime.now();

    Duration activeDuration =
        signOutTime.difference(signInTime);

    int totalSeconds =
        activeDuration.inSeconds;

    int totalMinutes =
        activeDuration.inMinutes;

    await FirebaseFirestore.instance
        .collection("activity_logs")
        .doc(sessionId)
        .update({

      "signOutTime":
          FieldValue.serverTimestamp(),

      "sessionStatus":
          "Completed",

      "totalActiveSeconds":
          totalSeconds,

      "totalActiveMinutes":
          totalMinutes,

      "totalActiveTime":
          activeDuration.toString(),
    });

  } catch (e) {

    //print("Sign out log error: $e");
  }
}
}