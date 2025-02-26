import '../entities/WeatherEntity.dart';

abstract class WeatherRepository {
  Future<WeatherEntity> getWeather(double lat, double lon);
  Future<bool> shouldGoToClub(WeatherEntity weather);
}