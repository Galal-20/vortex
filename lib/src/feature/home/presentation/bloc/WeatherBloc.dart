
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/UseCase/GetWeatherUseCase.dart';
import 'WeatherEvent.dart';
import 'WeatherState.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final GetWeatherUseCase getWeatherUseCase;

  WeatherBloc(this.getWeatherUseCase) : super(WeatherInitial()) {
    on<FetchWeather>((event, emit) async {
      emit(WeatherLoading());
      try {
        final weather = await getWeatherUseCase(event.lat, event.lon);
        emit(WeatherLoaded(weather));
      } catch (e) {
        emit(WeatherError("Failed to fetch weather data"));
      }
    });
  }
}