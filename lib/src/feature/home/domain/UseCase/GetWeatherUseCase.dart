import '../repository/WeatherRepository.dart';
import '../entities/WeatherEntity.dart';

class GetWeatherUseCase {
  final WeatherRepository repository;

  GetWeatherUseCase(this.repository);

  Future<WeatherEntity> call(double lat, double lon) {
    return repository.getWeather(lat, lon);
  }
}