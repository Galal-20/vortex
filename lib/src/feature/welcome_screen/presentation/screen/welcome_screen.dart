import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    // Optionally, you can customize the status bar style
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Transparent status bar
      statusBarIconBrightness: Brightness.light, // Light icons
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          /*image: DecorationImage(
            image: AssetImage(tWelcomeScreenImage),
            fit: BoxFit.cover,
          ),*/
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image(image: AssetImage(tWelcomeLogo)),
            Text(
              tWelcomeTitle,
              style: TextStyle(
                fontSize: tDefaultSize,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      backgroundColor: tSecondaryColor, // Fill with color
                      foregroundColor: Colors.white, // Text color
                      side: BorderSide(color: tSecondaryColor), // Border color
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    ),
                    child: Text(tLogin)),
                SizedBox(width: 50),
                ElevatedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black,
                    side: BorderSide(color: Colors.white),
                  ),
                  onPressed: () {},
                  child: Text(tSignUp),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}