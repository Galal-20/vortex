import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DailyWeatherCard extends StatelessWidget {
  final String day;
  final String weatherDescription;
  final String maxTemp;
  final String minTemp;
  final String iconUrl;

  DailyWeatherCard({
    required this.day,
    required this.weatherDescription,
    required this.maxTemp,
    required this.minTemp,
    required this.iconUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 190,
      margin: EdgeInsets.symmetric(horizontal: 5),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black,width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(day, style: TextStyle(fontSize: 20, fontWeight: FontWeight
              .bold)),
          SizedBox(height: 5),
          Image.network(iconUrl, width: 40, height: 40, errorBuilder:
              (context, error, stackTrace) => Icon(Icons.cloud, size: 40)),
          SizedBox(height: 5),
          Text(weatherDescription, style: TextStyle(fontSize: 18)),
          SizedBox(height: 5),
          Text("$maxTemp°C", style: TextStyle(fontSize: 18, fontWeight:
          FontWeight.bold)),
          Text("$minTemp°C", style: TextStyle(fontSize: 16)),
          SizedBox(height: 5),

        ],
      ),
    );
  }
}
