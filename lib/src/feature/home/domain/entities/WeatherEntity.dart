

class DailyWeather {
  final int date;
  final double maxTemp;
  final double minTemp;
  final String description;
  final String icon;

  DailyWeather({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.description,
    required this.icon,

  });
}




class WeatherEntity {
  final double temperature;
  final double minTemperature;
  final double maxTemperature;
  final String description;
  final String icon;
  final double windSpeed;
  final int sunrise;
  final int sunset;
  final int humidity;
  final int seaLevel;
  final int clouds;
  final List<DailyWeather> dailyForecast;


  WeatherEntity({
    required this.temperature,
    required this.minTemperature,
    required this.maxTemperature,
    required this.description,
    required this.icon,
    required this.windSpeed,
    required this.sunrise,
    required this.sunset,
    required this.humidity,
    required this.seaLevel,
    required this.clouds,
    required this.dailyForecast,

  });
}