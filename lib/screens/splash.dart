import 'package:flutter/material.dart';
import 'package:mysimplenote/screens/home.dart';
import 'package:mysimplenote/Components/color.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();

}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Set a delay before navigating to the home screen
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: primaryColor,
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 40.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 50.0),
              // Logo image
              Image(
                image: AssetImage('assets/app-logo.png'),
                width: 100.0, // Adjust the size as needed
                height: 100.0,
              ),
              // Title
              SizedBox(height: 15.0),
              Text(
                'My Simple Note',
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontFamily: "Poppins",
                ),
              ),
              Spacer(), // Adds space between elements
              // Developer info
              Text(
                'Developed by: Mohammed Muslih',
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.grey,
                  fontFamily: "Poppins",
                ),
              ),
              SizedBox(height: 7.0),
              // Version info
              Text(
                'Version: 1.0.0',
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.grey,
                  fontFamily: "Poppins",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
