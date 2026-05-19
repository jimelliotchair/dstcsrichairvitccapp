import 'package:flutter/material.dart';
import 'signup_screen.dart'; 
class LogoScreen extends StatefulWidget {
  const LogoScreen({super.key});
  @override
  State<LogoScreen> createState() => _LogoScreenState();
}
class _LogoScreenState extends State<LogoScreen> {
    @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SignupScreen()),
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
   body: LayoutBuilder(
  builder: (context, constraints) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: constraints.maxHeight,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logoo.png',
                width: MediaQuery.of(context).size.width * 0.5,
              ),
            ],
          ),
        ),
      ),
    );
  },
),
);
}
}