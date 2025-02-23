import '../../domain/entities/WeatherEntity.dart';

abstract class WeatherState {}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final WeatherEntity weather;
  final bool shouldGoToClub;
  WeatherLoaded(this.weather, this.shouldGoToClub);
}

class WeatherError extends WeatherState {
  final String message;
  WeatherError(this.message);
}