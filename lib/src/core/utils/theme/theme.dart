
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WeatherTheme{
  static  ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
    textTheme: TextTheme(
      titleLarge: GoogleFonts.montserrat(
        color: Colors.amber,fontSize: 24
      ),
    )
  );
  static ThemeData darkTheme = ThemeData(brightness: Brightness.dark);


}