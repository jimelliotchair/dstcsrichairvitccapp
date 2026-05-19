import 'package:flutter/material.dart';
import 'screens/logo_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; 
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  //await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'CHAIR - VIT Chennai',

      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      home: const LogoScreen(), // 👈 your starting screen
       routes: {
        // '/login': (context) => const LoginScreen(),
      },
    );
  }
}