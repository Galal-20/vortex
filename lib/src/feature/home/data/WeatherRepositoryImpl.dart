import 'dart:convert';
import 'package:http/http.dart' as http;
import '../domain/repository/WeatherRepository.dart';
import '../domain/entities/WeatherEntity.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final String apiKey = "6a482dc37ff81d4d3deec39521543316";
  final String baseUrl = "https://pro.openweathermap.org/data/2.5/weather";

  @override
  Future<WeatherEntity> getWeather(double lat, double lon) async {
    final response = await http.get(
      Uri.parse("$baseUrl?lat=$lat&lon=$lon&appid=$apiKey&units=metric"),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

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
        seaLevel: data["main"]["sea_level"] ?? 0, // If sea_level is missing, default to 0
        clouds: data["clouds"]["all"],
      );
    } else {
      throw Exception("Failed to load weather data");
    }
  }
}