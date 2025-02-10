import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/image_strings.dart';
import '../../../../core/constants/size.dart';
import '../../../../core/constants/strings.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();

    // Hides the status bar and the navigation bar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Transparent status bar
      statusBarIconBrightness: Brightness.light, // Light icons
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(tWelcomeScreenImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center everything vertically
          children: [
            Expanded(
              child: Center( // Ensures animation stays in center
                child: Lottie.asset(
                  tAnimation,
                  width: 500,
                  height: 500,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    backgroundColor: tSecondaryColor,
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: tSecondaryColor),
                    padding: const EdgeInsets.symmetric(horizontal: 50,
                        vertical: 20),
                  ),
                  child: Text(tLogin),
                ),
                const SizedBox(width: 50),
                ElevatedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black,
                    side: const BorderSide(color: Colors.white),
                    padding: const EdgeInsets.symmetric(horizontal: 50,
                        vertical: 20),
                  ),
                  onPressed: () {},
                  child: Text(tSignUp),
                ),
              ],
            ),
            const SizedBox(height: 200),
          ],
        ),
      ),
    );
  }
}