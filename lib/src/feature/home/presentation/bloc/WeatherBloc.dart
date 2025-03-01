
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vortex/src/feature/home/domain/entities/WeatherEntity.dart';

import '../../domain/UseCase/GetWeatherUseCase.dart';
import '../../domain/repository/WeatherRepository.dart';
import 'WeatherEvent.dart';
import 'WeatherState.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final GetWeatherUseCase getWeatherUseCase;
  final WeatherRepository aiPrediction;


  WeatherBloc(this.getWeatherUseCase, this.aiPrediction) : super(WeatherInitial()) {
    on<FetchWeather>((event, emit) async {
      emit(WeatherLoading());
      try {
        final weather = await getWeatherUseCase(event.lat, event.lon);
        final shouldGo = await aiPrediction.shouldGoToClub(weather);
        emit(WeatherLoaded(weather, shouldGo));
      } catch (e) {
        emit(WeatherError("Failed to fetch weather data"));
      }
    });
  }
}