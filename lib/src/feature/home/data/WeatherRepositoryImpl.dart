import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../domain/repository/WeatherRepository.dart';
import '../domain/entities/WeatherEntity.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final String apiKey = "6a482dc37ff81d4d3deec39521543316";
  final String baseUrl = "https://pro.openweathermap.org/data/2.5/";

  @override
  Future<WeatherEntity> getWeather(double lat, double lon) async {
    final response = await http.get(
      Uri.parse("$baseUrl/weather/?lat=$lat&lon=$lon&appid=$apiKey&units=metric"),
    );

    final forecastResponse = await http.get(
      Uri.parse("$baseUrl/forecast/daily?lat=$lat&lon=$lon&cnt=8&appid"
          "=$apiKey&units=metric"),
    );


    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final forecastData = jsonDecode(forecastResponse.body);

      List<DailyWeather> dailyForecast = (forecastData['list'] as List).map((day) {
        return DailyWeather(
          date: day['dt'],
          maxTemp: day['temp']['max'].toDouble(),
          minTemp: day['temp']['min'].toDouble(),
          description: day['weather'][0]['description'],
          icon: day['weather'][0]['icon'],
        );
      }).toList();

      return WeatherEntity(
        temperature: data["main"]["temp"].toDouble(),
        minTemperature: data["main"]["temp_min"].toDouble(),
        maxTemperature: data["main"]["temp_max"].toDouble(),
        description: data["weather"][0]["description"],
        icon: data["weather"][0]["icon"],
        windSpeed: data["wind"]["speed"].toDouble(),
        sunrise: data["sys"]["sunrise"],
        sunset: data["sys"]["sunset"],
        humidity: data["main"]["humidity"],
        seaLevel: data["main"]["sea_level"] ?? 0,
        clouds: data["clouds"]["all"],
        dailyForecast: dailyForecast,
      );
    } else {
      throw Exception("Failed to load weather data");
    }
  }



  @override
  Future<bool> shouldGoToClub(WeatherEntity weather) async {
    final url = Uri.parse('http://127.0.0.1:5001/predict');

    List<dynamic> features = [
      weather.description.toLowerCase().contains("rain") ? 1 : 0,  // Is it rainy?
      weather.description.toLowerCase().contains("sky is clear") ? 1 : 0, // Is it sunny?
      weather.temperature >= 30 ? 1 : 0,  // Is temperature hot? (30°C+)
      (weather.temperature >= 20 && weather.temperature < 30) ? 1 : 0, // Is temperature mild? (20-30°C)
      weather.humidity >= 40 && weather.humidity < 60 ? 1 : 0  // Is humidity normal? (40-60%)
    ];

    Map<String, dynamic> body = {
      "features": features
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (kDebugMode) {
          print('Prediction: ${result["prediction"]}');
        }
        return result["prediction"] == 1;
      } else {
        if (kDebugMode) {
          print('Failed to get AI prediction. Status Code: ${response.statusCode}');
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print("AI Prediction Error: $e");
      }
      return false;
    }
  }
}