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
  });
}